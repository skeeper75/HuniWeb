# D-WIRE BIND/NAMECARD/PHOTOCARD 가격공식 상품별 재모델 — 적재 실행본

생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 · **생성 단계**(검증·실 적재는 별도, 인간 승인)

## 한 줄 요약
D-WIRE 잔여 broken 3공식(`PRF_BIND_SUM` 4/1 · `PRF_NAMECARD_FIXED` 3/2 · `PRF_PHOTOCARD_FIXED` 2/2-모호)을 POSTER 와 **동일 처방**(상품별 공식 1:1)으로 해소. 9 상품 → **상품별 공식 9개** 신설 + 자기 comp 배선(14) + 재바인딩(9 DELETE + 9 INSERT) + 공유공식 3종 은퇴(use_yn='N'). **BIND=합산형(.01)·NAMECARD/PHOTOCARD=단순형(.02)**. comp/단가 전건 라이브 선존재 → **BLOCKED 0**, 신규 mint 0. **라이브 쓰기 0건**(멱등 SQL + DRY-RUN 계획만). **C1 명함 설계 supersede**.

## D-WIRE 문제 (라이브 실측 2026-06-07 재확증)
- 가격사슬: 상품 → `t_prd_product_price_formulas`(prd→frm) → `t_prc_formula_components`(frm→comp[]) → `t_prc_component_prices`(comp,siz…→단가).
- 상품→comp 직결 테이블 **부재** → 여러 상품이 1 공유공식에 묶이면 상품별 comp 분기 불가. **유일 해법 = 상품별 공식 1:1**.
- BIND 4/1: 중철만 배선·무선/PUR/트윈링 미배선(단가 8행씩 존재). NAMECARD 3/2: STD만 배선·프리미엄/코팅 미배선(단가 존재). PHOTOCARD 2/2: 둘 다 배선됐으나 공유라 라우팅 불가.

## BIND 합산형 처리 (적대적 핵심)
- BIND 는 **FRM_TYPE.01 합산형** — single-wire 가 아니라 **각 상품의 full summation comp-set** 를 라이브에서 결정.
- 실측: 라이브에 책자용 인쇄/용지/코팅 comp **부재**. 책자 직결 comp = 11 제본비(COMP_BIND_*)뿐. → 후니 엔진은 책자 가격 = **제본비 단일 합산항**으로 모델(라이브 권위).
- 결론: 각 책자 공식 = {자기 제본비 comp 1개} 합산(addtn_yn='Y'·FRM_TYPE.01 유지). "책자=인쇄+용지+제본 합산" 원하면 책자용 comp 신규 mint 필요 → 별건 인간승인(발명 금지, 설계결정 D-BIND-SCOPE).

## C1 supersede (LD-2)
- `02_mapping/price211-sticker-namecard/` 의 **명함 부분 폐기**: load.sql 단계2 명함배선 17행(PRF_NAMECARD_FIXED ← PEARL/SHAPE/MINISHAPE/CLEAR/WHITE/FOIL/FOIL_SETUP) + 단계3 명함바인딩 6행(PRD_000034/035/036/039/040/037) — 공유공식+택일 = 라우팅 불가.
- **STICKER 부분 유지**(정당-공유, 본 트랙 미관여): `PRF_STK_FIXED`·`PRF_STK_PACK_FIXED`.
- 본 트랙은 C1 의 3 기바인딩 명함(STD/PREMIUM/COAT)을 상품별로 분리. 7 무가격 명함은 후속 트랙(C1 공유설계 폐기).

## 파일
| 파일 | 용도 |
|------|------|
| `mapping.md` | 라이브 재검증·9상품↔comp 매핑·BIND 합산형 comp-set 처리·C1 supersede·재모델 설계·설계결정 |
| `load.sql` | 멱등 단일 tx (공식·배선·재바인딩·은퇴3 + 단계0 FK검증 + 말미 사슬무결성 assert). BEGIN/COMMIT 미포함(apply.sh 주입) |
| `dryrun-plan.md` | FK 적재순서 + DRY-RUN 게이트(R1~R6) + 설계자 사전점검(read-only 증거). **실행 안 함** |
| `load/t_prc_price_formulas.csv` | 신규 공식 9 |
| `load/t_prc_formula_components.csv` | 신규 배선 14 |
| `load/t_prd_product_price_formulas_INSERT.csv` | 재바인딩 추가 9 |
| `load/t_prd_product_price_formulas_DELETE.csv` | 재바인딩 제거 키 9 |
| `load/BLOCKED.csv` | 차단 상품(헤더만 — BLOCKED 0) |

## 적재 상태
- **INSERTABLE**: 공식 9 + 배선 14 + 재바인딩(DELETE 9 + INSERT 9) + 은퇴 UPDATE 3. **BLOCKED 0**(9상품 전건 comp+단가 선존재·FK 충족).
- component_prices(단가 본체) **미적재** — 14 comp 전건 라이브 선존재(사슬 시뮬 RESOLVES). POSTER 의 Slice A/C3 같은 단가 보충 불요.

## 사슬 무결성 (read-only 시뮬 실증)
9상품 전건 prd→formula→comp→price RESOLVES(n_prices: BIND 8·STD/COAT 2·PREMIUM 1·SET/CLEAR_SET 1). BLOCKED-DATA 0.

## 다음 단계
1. dbm-validator 독립 재검증 (감사 수치 live 재확인 + R1~R6 + 사슬 무결성 + C1 supersede 정합).
2. (인간 승인) load.sql DRY-RUN 2-pass 멱등 실증 → COMMIT.
3. 후속 트랙: C1 의 7 무가격 명함 상품별 재모델 상신(인간 우선순위).

## 설계결정 — 인간 확인 필요
- **D-BIND-SCOPE**: 책자 가격 = 제본비 단일항 합산(라이브 현황·권고) vs 인쇄+용지+제본 합산(comp 신규 mint·별건 승인).
- **D-NC-ADDTN**: NAMECARD 변형 comp addtn_yn='N'(택일·권고) vs 'Y'(C1 답습).
- **D-RETIRE**: 공유 3공식(0상품) use_yn='N' 비활성 권고(DELETE 는 잔존 배선 FK RESTRICT·별건 승인).
- **D-NC-RETIRE**: PRF_NAMECARD_FIXED 은퇴 ↔ 7무가격 명함 후속 트랙 충돌 재확인.
- **D-OTHER-NC7**: C1 7 무가격 명함 후속 트랙(공유설계 폐기·상품별 통일).
