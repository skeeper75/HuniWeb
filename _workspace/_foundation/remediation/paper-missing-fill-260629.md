# COMP_PAPER 미적재 자재 충전 진단 (2026-06-29)

## 배경·교정 규칙
투명엽서019 견적 0원 결함의 본질 = 가격구성요소 `COMP_PAPER`(용지비)에 선택 자재의
단가행이 없으면 엔진이 용지비를 못 찾아 견적이 깨지는 것. 확정 교정 규칙:

- **COMP_PAPER.unit_price = 권위 인쇄상품가격표 "가격(국4절)" 컬럼 값을 verbatim 적재.**
  - 증명(라이브 정확 일치): 백색모조지 100g→30.73 · 120g→36.88 · 220g→70.64 · 투명PET260g→1100.
- 모든 COMP_PAPER 행은 동형: `plt_siz_cd='SIZ_000499'`(316x467 전지) · `min_qty=1` · `apply_ymd='2026-06-01'`,
  나머지 차원 컬럼(siz_cd·clr_cd·print_opt_cd·proc_cd·opt_cd 등) 전부 NULL. (pansu가 사이즈→전지매수 환산)
- 권위 종이표: `_workspace/huni-dbmap/06_extract/import-paper-l1.csv` (컬럼 `가격\n(국4절)`).

## 범위 도출
1. COMP_PAPER 를 formula_components 에 포함하는 공식: **PRF_DGP_A~F (6개)**.
2. 그 공식에 바인딩된 상품: **20개** (PRD_000016~022·026·041~047·027~029·051·023·046 등).
3. 그 상품들의 선택 가능 자재(`t_prd_product_materials` del_yn='N'): **55개 distinct mat_cd**.
4. 이미 COMP_PAPER 단가행 보유: **57개 mat_cd** (위 55 + 다른 공식 공유분 포함).
5. **미적재 자재(범위 안 55개 중 COMP_PAPER 행 없음) = 3개.**

## 미적재 자재 → 권위 매핑 (3건 전부 FILL · BLOCKED 0)

| mat_cd | 라이브 mat_nm | 권위 종이명(국4절 출처) | 평량 | 가격(국4절) | 신뢰도 | 근거 |
|---|---|---|---|---|---|---|
| MAT_000149 | 아이보리 | 아이보리 | 300g | **153** | HIGH | 종이명 정확 일치(권위 유일 후보) |
| MAT_000240 | 스타드림(다이아) 240g | 스타드림(다이아몬드) 240g | 240g | **407.5** | MEDIUM-HIGH | 색상 약어 "다이아"≈"다이아몬드"·평량 240g 동일·스타드림 동일계열 |
| MAT_000241 | 스타드림(로츠쿼츠) 240g | 스타드림(로즈쿼츠) 240g | 240g | **524** | MEDIUM | 라이브 mat_nm "로츠쿼츠"=오타 추정(권위 "로즈쿼츠"·1글자 차)·평량 240g·스타드림 계열 잔여 유일색 |

출처: 모든 단가는 권위 가격표 `가격(국4절)` 값 verbatim. 값 날조 0. 추정 단가 없음.

### 영향 상품 (mat_cd 단위 충전이라 PRF_DGP 밖 상품도 동시 해소)
- MAT_000149 (아이보리) → PRD_000051 썬캡.
- MAT_000240 / MAT_000241 → PRD_000042 프리미엄 쿠폰/상품권 (PRF_DGP_A), **PRD_000034 펄명함**(범위 밖이나 동시 해소).

## 주의해야 할 모호 매칭
- **MAT_000241 스타드림(로츠쿼츠)** — 라이브 표기 "로츠쿼츠" vs 권위 "로즈쿼츠"는 **1글자 불일치(ㅈ↔ㅊ)**.
  스타드림 240g 색상은 권위에 다이아몬드/실버/골드/로즈쿼츠 4종뿐이고, 다이아·실버·골드는 라이브에
  별도로 안 잡혔으므로 잔여 색상 = 로즈쿼츠로 귀속. 라이브 mat_nm 오타로 판단했으나 **실무진 확인 권장**
  (만약 다른 색상이면 단가가 다름: 실버 425·골드 435). 평량은 240g로 일치.
- MAT_000240 "다이아"는 권위 "다이아몬드"의 약어로 명확하나, 표기 정규화 차이라 신뢰도 MEDIUM-HIGH 표기.
- MAT_000149 아이보리는 평량(300g)이 mat_nm 에 없으나 권위에 "아이보리" 단일 행뿐이라 모호성 없음.

## DRY-RUN 결과 (실 COMMIT 금지)
`paper-missing-fill-260629-dryrun.sql` 실행(psql -f, BEGIN/ROLLBACK):
- BEFORE COMP_PAPER 행수 = **57** → AFTER = **60** (INSERT 0 1 × 3건).
- 충전 행: comp_price_id 40330(MAT_000149·153) · 40331(MAT_000240·407.5) · 40332(MAT_000241·524).
- **PK 중복(DUP_PK) = 0**, ROLLBACK 정상(라이브 무변경).
- 멱등: 각 INSERT 는 `NOT EXISTS (comp_cd=COMP_PAPER AND mat_cd=...)` 가드 → 재실행 시 중복 0.

## 산출물
- 이 진단: `paper-missing-fill-260629.md`
- 멱등 충전 DRY-RUN SQL: `paper-missing-fill-260629-dryrun.sql`
- 매핑 CSV: `paper-missing-fill-260629-map.csv` (mat_cd,mat_nm,authority_paper_name,unit_price,confidence,status)

## 다음 단계 (인간 승인 필요)
1. MAT_000241(로츠쿼츠↔로즈쿼츠) 색상 동일성 실무진 1건 확인.
2. 승인 시 dryrun SQL 의 `ROLLBACK`→`COMMIT` 으로 실 적재(별도 처리·이 작업 범위 아님).
3. 적재 후 시뮬레이터로 PRD_000051(썬캡·아이보리)·PRD_000042(스타드림) 견적 PRICE≠0 검증 권장.
