# 016 프리미엄엽서 가격사슬 note 교정 — 적재 매니페스트

> 대상: PRD_000016 프리미엄엽서가 바인딩한 가격공식 **PRF_DGP_A** 가격사슬의 모든 note 보유 행.
> 권위: `17_correctness/postcard-016-price/note-remediation.md` + `chain-trace.md` + 토대 §9-1.
> **이 단계 = 빌드 + 롤백전용 DRY-RUN까지. 실제 COMMIT은 독립 게이트(dbm-validator) 후 인간 승인.**

## 1. 무엇을 바꾸나 (note 컬럼만)

가격 계산과 무관한 운영자용 라벨(비고)에 남은 **전문용어·내부 코드값·교정 마커·생성 출처**를
일반 실무진이 admin에서 알아볼 **쉬운 한국어**로 바꾼다.

| 테이블 | 컬럼 | 행수 | 교정 방식 |
|--------|------|:--:|-----------|
| `t_prc_price_components` | `note` | 29 | comp_cd별 1:1 한국어 라벨 (CASE) |
| `t_prc_component_prices` | `note` (비-용지비) | 1,354 | 결정적 regexp 치환 (마커 제거 + 축 한국어화) |
| `t_prc_component_prices` | `note` (COMP_PAPER 용지비) | 49 | 친화 설명 suffix 추가 |
| **합계** | | **1,432** | |

교정 대상에서 **제외**(이미 양호하거나 NULL):
- `t_prc_price_formulas.note` (PRF_DGP_A): 이미 쉬운 한국어 — 무변경.
- `t_cod_base_codes.note` (PRC_COMPONENT_TYPE.*·PRICE_TYPE.* 코드값): 전부 NULL — 교정 대상 없음(cod_nm은 양호).
- `t_prc_formula_components`: note 컬럼 자체가 없음.

## 2. 교정 규칙 (제거 → 표현)

제거: `[siz-corrected: SIZ_PENDING_*→SIZ_*]` 내부 교정 마커 · `(별색=공정,clr=NULL)` 설계 메모 ·
`(합가, comp_typ=.04 후가공비, 옵션=comp흡수)` 코드값 메모 · `round-2 파일럿 자동생성. comp_typ_cd=...` 생성 출처 ·
`차원=mat_cd(종이)×siz_cd(...)·...앱 런타임(C-4)` 식별자·결정 ID.

유지/표현: 축을 한국어로 — `출력매수≥N` → `출력매수 N장 이상`, `제작수량≥N` → `주문수량 N건 이상`.
합가형(후가공)은 `(합가 ...)` 대신 `/ 작업 1건 고정 금액`을 풀어 써서 왜 금액이 큰지 오해 없게.
출력축(인쇄·코팅 = 장당 단가) vs 주문축(후가공 = 작업 1건 고정)을 실무진이 구분하도록 보존.

## 3. 가격행 불변 보증 [HARD]

- **변경 컬럼 = `note`, `upd_dt` 둘뿐.** 모든 UPDATE의 `SET` 절에 `unit_price`·`prc_typ_cd`·`comp_typ_cd`·
  `qty_from`/`qty_to`·`siz_cd`·`clr_cd` 등 가격/단가행·축 컬럼은 들어있지 않다.
- DRY-RUN 검증 SELECT가 정정 전후 `unit_price` 합계·행수·`prc_typ_cd` 분포가 동일함을 실증한다(§dry-run-result).

## 4. 멱등 가드

- 정의행: `WHERE comp_cd=... AND note IS DISTINCT FROM <new>` — 이미 교정됐으면 0행.
- 단가행(regexp): `WHERE ... AND note IS DISTINCT FROM (<같은 regexp>)` — 마커 없는 텍스트엔 regexp가 no-op → 0행.
- 용지비(suffix): `WHERE note NOT LIKE '%실제 청구는 출력매수만큼 자동 계산%'` — 이미 붙었으면 0행.
- → 2회차 재실행 delta 0 (DRY-RUN 2-pass로 실증).

## 5. 산출 파일

| 파일 | 역할 |
|------|------|
| `gen_remediation_sql.py` | 생성기 — 라이브 읽기전용 SELECT로 현재 note 실측 → note-map.csv + SQL 생성(재현성·손편집 금지) |
| `note-map.csv` | 행별 {table·pk·comp_cd·current_note(라이브 실측)·corrected_note} 1,432행 전수 대조표 |
| `01_update_notes.sql` | 멱등 UPDATE (note 컬럼만, IS DISTINCT FROM 가드, upd_dt=now()) |
| `apply.sql` | 단일 트랜잭션 래퍼(ON_ERROR_STOP·BEGIN·\i) — COMMIT/ROLLBACK은 로더 주입 |
| `apply_loader.sh` | psql 로더 — 기본 DRY-RUN(ROLLBACK), `commit` 인자는 인간 승인 시에만 |
| `dry-run-result.md` | 라이브 롤백전용 DRY-RUN 2-pass 실증 결과 |

## 6. 실행 방법 / 백업·롤백

```bash
cd _workspace/huni-dbmap/23_remediation-apply/016-notes
./apply_loader.sh            # DRY-RUN (기본, 롤백전용 — 아무것도 커밋 안 됨)
./apply_loader.sh commit     # 실제 적재 (인간 승인 후에만)
```

- **백업 불필요(권장)**: note 컬럼만 바꾸는 멱등 UPDATE라 위험 변경 아님. git에 `note-map.csv`(현재→교정 전수)가
  baseline 역할 — 역치환이 필요하면 `current_note` 컬럼으로 되돌릴 수 있다(토대: 일상 멱등 UPDATE는 baseline로 충분).
- **롤백**: DRY-RUN은 트랜잭션이 항상 ROLLBACK이라 라이브 무변경. COMMIT 후 되돌리려면 `note-map.csv`의
  `current_note`를 동일 PK로 재적용(별도 역방향 스크립트 생성 가능).

## 7. 다음 단계

1. `dbm-validator` 독립 게이트 (R1 멱등·R3 실행·R5 라이브 DRY-RUN·note-only 보증·전문용어 잔존 0).
2. 게이트 GO + 인간 승인 → `./apply_loader.sh commit`.
