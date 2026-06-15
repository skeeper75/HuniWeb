# 전 상품군 가격 note 교정 — 라이브 롤백전용 DRY-RUN 실증 결과

> 실행 2026-06-15 · 라이브 `railway` DB · `BEGIN … <apply> … ROLLBACK` (lead 승인 범위).
> **COMMIT 0 — 아무것도 라이브에 반영되지 않음.** 비밀번호 미출력. note 컬럼만 검증.

## 1. 단일 트랜잭션 2-pass 결과

| 항목 | 결과 | 판정 |
|------|------|:--:|
| PASS1 변경 — 정의행(`t_prc_price_components`) | 115 (UPDATE 1 × 115문) | ✅ |
| PASS1 변경 — 단가행(`t_prc_component_prices`) | 2,057 (UPDATE 2057 × 1블록) | ✅ |
| **합계** | **2,172행** | |
| PASS2 delta (재실행) — 116개 UPDATE 문 전부 `UPDATE 0` | **0** | ✅ 멱등 |
| note 전역 지문 PASS1 후 == PASS2 후 | `db36b75384b718f83f9b1fe73eff39e5` 동일 | ✅ delta 0 |
| ROLLBACK 후 라이브 | 무변경 (전문용어 115+2,057 그대로) | ✅ |

PASS2에서 정의행 115문 + 단가행 1블록 = 116문 모두 `UPDATE 0` — `IS DISTINCT FROM` 가드와
결정적 no-op regexp로 재실행 delta 0 실증.

## 2. 가격행 불변 보증 (note 컬럼만 변경)

| 검사 | before | after | 판정 |
|------|--------|-------|:--:|
| 단가행 가격/축 지문 `sum(unit_price)\|sum(bdl_qty)\|sum(min_qty)\|md5(siz/clr/mat/proc/opt/apply_ymd)` | `76884888.51\|8442\|31524957\|fdcd168a947eb0a75b0684259e59c126` | (동일) | ✅ |
| 정의행 prc_typ 분포 | `PRICE_TYPE.01:144` | `PRICE_TYPE.01:144` | ✅ |

→ unit_price·bdl_qty·min_qty·siz_cd·clr_cd·mat_cd·proc_cd·opt_cd·apply_ymd·prc_typ_cd 어떤 값도
변하지 않음. SET 절은 `note`·`upd_dt` 둘뿐임을 라이브가 실증.

## 3. 전문용어 잔존 0 (전수, FLAG_UNCLEAR 제외 — 본 번들 FLAG 0건)

PASS1 후 (트랜잭션 내):

| 검사 | 잔존 | 판정 |
|------|:--:|:--:|
| 정의행 전체 전문용어(`siz-corrected\|comp_typ\|PRC_COMPONENT_TYPE\|round-2\|clr=NULL\|별색=공정\|옵션=comp흡수\|SIZ_N\|MAT_N\|PROC_N\|mat_cd\|siz_cd\|C-N\|≥`) | **0** | ✅ |
| 단가행 전체 전문용어(동일 패턴) | **0** | ✅ |

→ note-map.csv `corrected_note` 컬럼도 동일하게 전문용어 0 (python 재검증). 단가행 SQL 체인 결과는
note-map.csv corrected와 라이브 2,057행 byte-identical(mismatch 0).

## 4. 교정 예시 (현재 → 교정, 라이브 인용 · 상품군 다양)

| comp_cd | 현재 (라이브) | 교정 |
|---------|--------------|------|
| 정의 COMP_ACRYL_CLEAR15T (아크릴) | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01` | `투명 아크릴 1.5T 인쇄·가공 포함가. 사이즈·수량별 단가표.` |
| 정의 COMP_BIND_JUNGCHEOL (책자) | `round-2 7시트 확대 자동생성` | `제본 가공비(후가공). 제본 종류·수량별 단가표.` |
| 정의 COMP_POSTER_BANNER_NORMAL (포스터/현수막) | `round-2 7시트 확대 자동생성` | `포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.` |
| 단가 COMP_GANGPAN_PRINT (합판/굿즈) | `[siz-corrected: SIZ_PENDING_GP_원형35mm→SIZ_000422] 원형 35mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)` | `원형 35mm/비코팅/무광코팅/유광코팅 제작수량 1000 이상` |
| 단가 COMP_FOLD_CARD_2H (카드접지) | `카드접지/2단 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]` | `카드접지/2단 제작수량 1 이상 / 작업 1건 고정 금액(수량을 곱하지 않음) [묶음 동일단가: 2단가로접지 / 2단세로접지]` |
| 단가 COMP_ENV_MAKING (봉투) | `[siz: ENV_TICKET→SIZ_000191] 봉투제작/티켓봉투/모조 120g 제작수량≥1000 (완제품가 .06)` | `봉투제작/티켓봉투/모조 120g 제작수량 1000 이상` |

## 5. 종합

| 게이트 | 판정 |
|--------|:--:|
| 멱등성 (2-pass delta 0 · note 지문 동일) | ✅ PASS |
| 실행성 (apply.sql/loader 무오류 실행) | ✅ PASS |
| 라이브 DRY-RUN 제약 위반 | ✅ 0 |
| note 컬럼만 변경 (가격행 지문 before==after) | ✅ PASS |
| 전문용어 잔존 0 (전수) | ✅ PASS |
| 의미 보존 (소재·색·도수·사이즈·축·단위) | ✅ PASS |
| SQL↔Python 동치 (단가행 2,057행 byte-identical) | ✅ PASS |
| ROLLBACK 후 라이브 무변경 | ✅ PASS |

**빌드 + DRY-RUN 완료.** 실제 COMMIT은 `dbm-validator` 독립 게이트 GO + 인간 승인 후
`./apply_loader.sh commit`. (이 에이전트는 자기승인하지 않음.)
