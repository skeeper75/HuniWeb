# 가격(t_prc_*) 적재 — COMMIT 안전(백업·되돌림) 절차

> 사용자 "되돌릴 수 없다"는 우려를 닫기 위한 산출물. 실제 COMMIT 을 인간이 승인하기 전/후에
> 적재를 **무손실 되돌릴(REVERSIBLE)** 수 있게 백업 스냅샷 + 언두 스크립트를 갖춘다.
> 본 하네스는 스크립트만 생성한다 — **DB 쓰기·COMMIT 은 인간 승인 시에만**. 자동 실행 금지.

## 0. 전제 — 왜 가격은 되돌리기 쉬운가

가격 5 테이블(`t_prc_price_formulas`, `t_prc_price_components`, `t_prc_formula_components`,
`t_prc_component_prices`, `t_prd_product_price_formulas`)은 **라이브에서 전부 비어 있다(count=0,
2026-06-06 read-only 확증)**. 따라서 이번 적재로 들어가는 행 = 전부 신규행이고, 되돌림 =
**적재한 행을 전부 DELETE** 하면 끝이다. 공유 코드행(`t_cod_base_codes`의
`PRC_COMPONENT_TYPE.06`)만은 신설 시에만 삭제하고, 선존이면 보존한다.

적재 규모: 공식 10 · 구성요소 143 · 배선 13 · 단가 3,292(GUK4/3JEOL/GP35 교정 포함) · 코드행 1
= INSERT 문 3,504.

## 1. 안전한 COMMIT 절차 (순서 엄수)

`<runts>` = 실행 타임스탬프(예: `20260606T1530`). 호출자가 직접 지정한다(스크립트 내부에서
시간 생성 안 함 — 재현성). 자격증명은 `.env.local` 에서만 로드되고 화면에 노출되지 않는다.

### ① 백업 (적재 전, read-only) — 인간 실행
```
./backup-before-load.sh <runts>
```
- `backup_<runts>/before_prc_counts.csv` 에 5 테이블 행수(=0) + 코드행 선존여부를 기록.
- DB 변경 0(읽기전용). 되돌림이 "전부 DELETE 로 충분"함을 증명하는 근거.

### ② DRY-RUN (적재 가능성·멱등성 확인) — 인간 실행
```
./apply.sh dryrun
```
- 단일 트랜잭션으로 적재를 시도한 뒤 **무조건 ROLLBACK**. 영구 변경 0.
- 제약 위반·FK 오류가 있으면 여기서 전체 롤백되어 드러난다.

### ③ 실제 COMMIT (영구 적재) — **인간 승인 시에만**
```
./apply.sh commit <runts>
```
- 영구 INSERT + 같은 트랜잭션 안에서 **신규행 PK 키를 `inserted_keys_<runts>.csv` 로 캡처**.
- 이 캡처본이 있어야 ④ 언두가 "이번에 넣은 행만" 정확히 지운다.
- runts 를 빼면 캡처가 생략되어 언두가 제한된다 → **반드시 runts 지정**.

### ④ 검증 (뷰어로 눈으로 확인) — 인간
- 라이브 뷰어/조회로 적재 결과를 확인. 잘못됐으면 ⑤ 로.

### ⑤ 언두 (되돌리기) — 잘못된 경우에만, **인간 승인 시에만**
```
./undo.sh <runts>            # DRY-RUN(롤백) — 언두를 시연만 하고 ROLLBACK
./undo.sh <runts> commit     # 영구 언두 — 적재한 행을 실제 삭제
```
- `inserted_keys_<runts>.csv` 에 로그된 신규 PK 만 DELETE → 적재 이전 상태로 복원.
- 코드행은 이번에 신설했을 때만 삭제(선존 코드값 불가침).

## 2. 되돌림이 정확한 이유 (검증됨)

- **신규행 식별 = `xmin = pg_current_xact_id()::xid`.** 적재 트랜잭션이 실제로 새로 INSERT 한
  행만 잡힌다. `ON CONFLICT DO NOTHING` 으로 스킵된 선존행은 이전 xmin 이라 제외된다.
- **라이브 롤백 DRY-RUN 으로 종단 실증**: BEGIN → 적재(3,504행) → xmin 캡처(3,504 키) →
  언두 DELETE → 5 테이블 + 코드행 전부 0 으로 복귀 → ROLLBACK. **영구 변경 0**.

## 3. 안전 불변식 (HARD)

- 본 하네스는 **DB 쓰기·COMMIT·DDL 을 하지 않는다**. ②③⑤ 의 commit 은 인간이 직접 실행.
- 비밀번호는 `.env.local`(chmod 600·gitignore)에서만 로드, stdout 노출 0.
- 적재 SQL(00~05)은 일절 변경되지 않았다(멱등성 보존). 안전 장치는 별도 파일로만 추가.
- `apply.sh`/`undo.sh` 기본 모드 = DRY-RUN(ROLLBACK). 영구 변경은 `commit` 명시 시에만.

## 4. 산출 파일

| 파일 | 역할 |
|------|------|
| `backup-before-load.sh` / `backup-before-load.sql` | ① 적재 전 행수 스냅샷(read-only) |
| `apply.sh` (`commit <runts>`) + `capture-inserted-keys.sql` | ③ 적재 + 신규키 캡처 |
| `undo.sh` + `undo-after-load.sql` | ⑤ 신규키 DELETE 로 되돌림 |
| `gen_safety_sql.py` | 위 SQL 재현 생성기(손편집 금지) |
| `inserted_keys_<runts>.csv` | ③에서 생성(언두 입력). git 미추적 권장 |
| `backup_<runts>/` | ①에서 생성(스냅샷). git 미추적 권장 |
