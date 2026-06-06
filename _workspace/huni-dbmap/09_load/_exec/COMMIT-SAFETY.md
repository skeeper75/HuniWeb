# 상품마스터(t_prd_*/t_proc_/t_siz_) 적재 — COMMIT 안전(백업·되돌림) 절차

> 사용자 "되돌릴 수 없다"는 우려를 닫기 위한 산출물. 실제 COMMIT 을 인간이 승인하기 전/후에
> 적재를 **무손실 되돌릴(REVERSIBLE)** 수 있게 백업 스냅샷 + 언두 스크립트를 갖춘다.
> 본 하네스는 스크립트만 생성한다 — **DB 쓰기·COMMIT 은 인간 승인 시에만**. 자동 실행 금지.

## 0. 적재 구성과 되돌림 전략

상품마스터 적재는 **INSERT 와 UPDATE-set 두 종류**가 섞여 있어, 가격(전부 INSERT)보다
되돌림이 복잡하다. 각각 다른 방식으로 정확히 되돌린다.

| 구분 | 적재 내용 | 되돌림 방식 |
|------|----------|------------|
| **INSERT** | 코드행(proc 1·siz 10) · materials 316 · processes 62 · bundle 24 | **이번 트랜잭션이 실제로 새로 넣은 행만 DELETE**(xmin 로그) — 선존행 불가침 |
| **UPDATE-set** | qty_unit 242 · nonspec 25 · thickness(mat_cd) 20 | **적재 전 현재값(before-image)으로 UPDATE 복원** |

- **INSERT 되돌림 정확성**: `ON CONFLICT DO NOTHING` 으로 스킵된 선존행은 절대 지우지 않는다.
  이번 트랜잭션이 새로 넣은 행만 `xmin = pg_current_xact_id()::xid` 로 식별해 로그하고, 그
  로그된 PK 키만 DELETE 한다.
- **thickness 특수 처리(검증으로 적발·보정)**: thickness UPDATE 는 `mat_cd`(=PK)를 바꾼다.
  그러면 갱신된 행의 xmin 이 현재 트랜잭션이 되어 "INSERT 신규행"처럼 보인다. 이를 INSERT-언두
  DELETE 대상에서 **제외**하고(이 행은 UPDATE 이므로), before-image 의 원래 `mat_cd` 로
  되돌린다. 캡처 SQL 이 thickness NEW-타깃 `(prd, NEW_mat, usage)`을 `NOT IN` 으로 배제한다.

## 1. 안전한 COMMIT 절차 (순서 엄수)

`<runts>` = 실행 타임스탬프(예: `20260606T1530`). 호출자가 직접 지정(재현성·시간생성 없음).
자격증명은 `.env.local` 에서만 로드되고 화면에 노출되지 않는다.

### ① 백업 (적재 전, read-only) — **인간 실행, 필수**
```
./backup-before-load.sh <runts>
```
- `backup_<runts>/` 에 before-image CSV 3종:
  - `before_t_prd_products.csv` — UPDATE-set 이 바꿀 242상품의 현재 qty_unit + nonspec 5컬럼.
  - `before_t_prd_product_materials_thickness.csv` — thickness 20행의 현재 PK(원래 mat_cd).
  - `before_code_row_targets.csv` — 신설 proc/siz 의 선존 진단(정상 = 비어 있음).
- DB 변경 0(읽기전용). **이 백업이 없으면 UPDATE-set 을 되돌릴 수 없다 → 반드시 선행.**

### ② DRY-RUN (적재 가능성·멱등성 확인) — 인간 실행
```
./apply.sh dryrun
```
- 단일 트랜잭션 적재 후 **무조건 ROLLBACK**. 영구 변경 0. 제약 위반은 여기서 전체 롤백.

### ③ 실제 COMMIT (영구 적재) — **인간 승인 시에만**
```
./apply.sh commit <runts>
```
- 영구 INSERT/UPDATE + 같은 트랜잭션 안에서 **신규 INSERT 행 PK 를 `inserted_keys_<runts>.csv`
  로 캡처**(thickness UPDATE 행은 제외). runts 를 빼면 캡처 생략 → 반드시 지정.

### ④ 검증 (뷰어로 눈으로 확인) — 인간
- 라이브 뷰어/조회로 결과 확인. 잘못됐으면 ⑤ 로.

### ⑤ 언두 (되돌리기) — 잘못된 경우에만, **인간 승인 시에만**
```
./undo.sh <runts>            # DRY-RUN(롤백) — 언두 시연 후 ROLLBACK
./undo.sh <runts> commit     # 영구 언두 — 적재를 실제로 되돌림
```
- 언두 = (A) `inserted_keys_<runts>.csv` 로그 신규 PK DELETE + (B) `backup_<runts>/` before-image
  로 UPDATE 복원. **`inserted_keys_<runts>.csv` + `backup_<runts>/` 둘 다 있어야 실행 가능**
  (없으면 undo.sh 가 중단).

## 2. 되돌림이 정확한 이유 (라이브 롤백 DRY-RUN 으로 실증)

종단 검증(BEGIN → 적재 → 캡처 → 언두 → 검증 → ROLLBACK, **영구 변경 0**):

| 검증 | 결과 |
|------|------|
| 적재 후 신설 코드행(proc/siz) | proc 1 · siz 10 생성 |
| 적재 후 qty_unit·thickness UPDATE | 적용됨 |
| 언두 후 신설 코드행 | proc 0 · siz 10→0 (전부 삭제 = 되돌림) |
| 언두 후 242상품 update-target | 적재 전과 차이 0 (완전 복원) |
| 언두 후 thickness mat_cd | MAT_000043 → MAT_000192 원복(1행 복원·신규 0) |

→ INSERT·UPDATE-set 양쪽 모두 적재 이전 상태로 정확히 복원됨.

## 3. 안전 불변식 (HARD)

- 본 하네스는 **DB 쓰기·COMMIT·DDL 을 하지 않는다**. ②③⑤ 의 commit 은 인간이 직접 실행.
- 비밀번호는 `.env.local`(chmod 600·gitignore)에서만 로드, stdout 노출 0.
- 적재 SQL(00~90)은 일절 변경되지 않았다(멱등성 보존). 안전 장치는 별도 파일로만 추가.
- `apply.sh`/`undo.sh` 기본 모드 = DRY-RUN(ROLLBACK). 영구 변경은 `commit` 명시 시에만.
- **①(백업)을 건너뛰면 UPDATE-set 을 되돌릴 수 없다.** 백업은 선택이 아니라 필수.

## 4. 산출 파일

| 파일 | 역할 |
|------|------|
| `backup-before-load.sh` + `backup_q_{products,materials,coderows}.sql` | ① before-image 스냅샷(read-only) |
| `apply.sh` (`commit <runts>`) + `capture-inserted-keys.sql` | ③ 적재 + 신규키 캡처(thickness 제외) |
| `undo.sh` + `undo-after-load.sql` | ⑤ INSERT 언두(로그키 DELETE) + UPDATE 언두(before-image 복원) |
| `gen_safety_sql.py` | 위 SQL 재현 생성기(손편집 금지) |
| `inserted_keys_<runts>.csv` | ③에서 생성(언두 입력). git 미추적 권장 |
| `backup_<runts>/` | ①에서 생성(before-image). git 미추적 권장 |
