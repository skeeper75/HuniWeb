# 코롯토·지비츠 고아 구성요소 §18 가격엔진 설계 명세 (아크릴 굿즈)

- 입력: `orphan-classification.json`(dead 7·pcb30p_live_rediag) · `HANDOFF.md` A-4 · 권위 단가 = `인쇄상품 가격표 260527` 아크릴 시트(추출 `huni-price-table-integrity/01_authority/acrylic-authority-grid.csv` B05·B04) · 상품마스터 260610(`huni-dbmap/24_master-extract-260610/acrylic-l1.csv`) · 엔진 = `pricing.py`(`_row_matches`·`component_subtotal`) · 라이브 실측(read-only SELECT, snap `latest`)
- 작업: **설계 명세까지**. 실 COMMIT 없음·DB 미적재·생성≠검증(validator/codex 교차·PRICE≠0 실호출은 후속). dryrun = `design-corotto-jibbitz-260701-dryrun.sql`(멱등·NOT EXISTS 가드·BEGIN…ROLLBACK).
- 산출일 2026-07-01.

---

## 0. 핵심 결론 (라이브 실측이 task 전제를 정정)

| 대상 | 상품 | 라이브 실측 현재상태 | 판정 | 설계 |
|---|---|---|---|---|
| **코롯토(89-96 면적)** | **PRD_000164 아크릴코롯토** | **이미 완전 배선**(2026-06-27): PRF_COROTTO_ACRYL ← COMP_ACRYL_COROTTO(36 area행 verbatim)·PRD_000164 바인딩 | **GO — search-before-mint HIT·mint 0** | 신규 설계 불요. **검증만**. 단 `use_yn=N`(비활성)=발현조건 §7 |
| **지비츠(72 고정 200)** | **PRD_000156 아크릴지비츠** | **dead**: PRD_000156 → PRF_ACRYL_ZIBITZ_TBD(placeholder) ← COMP_ACRYL_PENDING_TBD. 권위 有(투명 200/스핀 600) | **설계 GO** | COMP_ACRYL_ZIBITZ + PRF_ZIBITZ_ACRYL 신설·rebind |
| 지비츠★(무권위) | PRD_000171 지비츠★ | dead: → PRF_ACRYL_ZIBITZ2_TBD. `nonspec_yn=N`·사이즈/자재/단가 미설정·**가격표 미발견** | **BLOCKED** | 실무진 CONFIRM(범위 밖) |
| 코롯토 변종(무권위) | PRD_000165 포카·168 입체·226 쉐이커 | dead: *_TBD. 가격표 미발견(미수록) | **BLOCKED** | 실무진 CONFIRM(범위 밖·orphan-classification confirm_queue_v2 ④) |

**요지:** task가 "코롯토·지비츠 둘 다 고아"로 봤으나 라이브는 **코롯토 main(164)=이미 배선 완료**, **지비츠(156)만 실 설계 대상**이다. 코롯토를 재-mint하면 중복(search-before-mint 위반) — **검증만** 한다. 무권위 4상품(171·165·168·226)은 dead placeholder 정당·CONFIRM 잔존.

---

## A. 코롯토 PRD_000164 아크릴코롯토 — 이미 배선(검증 전용·mint 0)

### A-1. 라이브 실측 (변경 없음)
- 상품: `nonspec_yn=Y`, 가로/세로 30~80mm, min_qty 1·max 10000·incr 1, qty_unit.01. **`use_yn=N`**(아직 비활성).
- 공식 `PRF_COROTTO_ACRYL`(use_yn=Y) ← `COMP_ACRYL_COROTTO`(seq1). 바인딩 `PRD_000164 → PRF_COROTTO_ACRYL`(note "고아 formula 해소", 2026-06-27).
- 구성요소 `COMP_ACRYL_COROTTO` "아크릴코롯토 인쇄가공비"·`PRC_COMPONENT_TYPE.01`·`PRICE_TYPE.01`(단가형 unit×qty)·`use_dims=["siz_width","siz_height"]`·use_yn=Y.
- 단가행 **36행 = 6×6 완전격자**(가로 30/40/50/60/70/80 × 세로 30/40/50/60/70/80)·값 = 가격표 B05 verbatim(3,600~8,400). `count=distinct(w×h)=36` 확인.

### A-2. disjoint 자가검증
- 공식에 **단일 구성요소**(형제 없음) → silent-sum 불가. 각 단가행은 (siz_width, siz_height) 쌍이 유일 → 면적매칭이 정확히 1행 선택. off-grid(예 45×45)는 엔진 TIER_UPPER '이하 상한'으로 다음 큰 구간(w50×h50) ceiling. **disjoint ✓·always-match 없음**.

### A-3. 배선 판정 = **GO(변경 0)**
- 재-mint/재배선 **불요**. 유일 잔존 = **상품 활성화**(`use_yn=N → Y`)는 가격배선 결함 아님 = §7/§21 상품등록 트랙(발현조건).

---

## B. 지비츠 PRD_000156 아크릴지비츠 — 설계(고정가·가공 택1)

### B-1. 권위 단가 (가격표 260527 아크릴 시트 B04·verbatim)

authority-grid `B04 addon_option 아크릴지비츠(슈츠참)`:

| 가공(옵션) | 단가(원/개) | 비고 |
|---|---|---|
| **투명** | **200** | 기본(default)·task "고정 200원(개당)" |
| 스핀 | 600 | 회전참 변종 |

- **가격 = 가공 택1 × 수량**(사이즈 15~35mm는 물리 규격일 뿐 가격 무관 — 면적매트릭스 아님). 코롯토(size-driven)와 정반대 모델.
- 상품마스터: 소재 투명아크릴 3mm(MAT_000043·이미 dflt 등록), 인쇄·가공 all-in(코롯토 "인쇄가공비"와 동형 번들가).
- 라이브 현재: PRD_000156 min 1·max 10000·incr 1·qty_unit.01·**use_yn=N**(비활성). 옵션그룹 0건·자재 MAT_000043(dflt)·print_opt 3(POPT_003/004/005).

### B-2. 설계 결정 — 2 경로(권장=Path 1 즉시 GO)

권위에 투명 200 / 스핀 600 두 값이 있으나, **스핀은 선택수단(가공 옵션그룹)이 있어야 주문 가능**하고 그 option_items 참조차원(OPT_REF_DIM.04 공정)에 걸 **투명/스핀 공정코드가 라이브에 부재**(search-before-mint 결과 `t_proc_processes`에 투명/스핀 없음) → 기초마스터 공정 mint가 선행돼야 한다. 이를 분리한다.

**Path 1 (권장·즉시 GO·task 문자 그대로·mint 최소):** 투명 200 **고정가**만 배선.
- `COMP_ACRYL_ZIBITZ` 신설·`use_dims=["min_qty"]`·단가행 1(투명 200·min_qty=1).
- 옵션그룹 불요(주문에 opt_cd 없어도 min_qty tier로 항상 매칭) → **PRICE≠0 즉시 보장**·기초마스터 mint 0.
- 스핀은 미주문(옵션그룹 부재)=**과소청구 없음**(주문 경로 자체가 없음)·후속 §7 addon으로 추가.

**Path 2 (완전 충실·스핀 포함·§7 선행):** 가공 택1(투명 200 dflt / 스핀 600).
- `COMP_ACRYL_ZIBITZ`·`use_dims=["opt_cd","min_qty"]`(린넨 `COMP_POSTEROPT_LINEN_FINISH` 동형)·단가행 2(opt_cd 투명→200·스핀→600).
- 선택수단: 옵션그룹 `가공`(택1 mand)·옵션 투명(dflt)/스핀 + option_items(OPT_REF_DIM.04 공정).
- **mint 경계/CONFIRM**: 투명/스핀 공정코드 부재 → 기초마스터 공정 2 신설(§12/§7 dbmap 라우팅) 또는 순수 addon 템플릿(§7 CPQ)로 option_items proc 참조 회피. **이 결정 전 스핀 배선 BLOCKED**.

### B-3. Path 1 설계 상세 (dryrun 수록)

- 구성요소 `COMP_ACRYL_ZIBITZ` "아크릴지비츠 인쇄가공비"·`PRC_COMPONENT_TYPE.01`·`PRICE_TYPE.01`·`use_dims=["min_qty"]`·use_yn=Y.
- 단가행: `comp_price_id`(신규·MAX 79165→**79166**)·min_qty=1·unit_price=**200.00**·siz/opt/proc 전부 NULL·note "아크릴지비츠 투명 기본단가 [260527 B04 verbatim]".
- 공식 `PRF_ZIBITZ_ACRYL` "아크릴지비츠 공식"(use_yn=Y·PRF_COROTTO_ACRYL 명명 동형)·formula_components ← COMP_ACRYL_ZIBITZ(seq1·addtn_yn=N).
- 바인딩: PRD_000156 기존 `PRF_ACRYL_ZIBITZ_TBD` 삭제 → `PRF_ZIBITZ_ACRYL` 신설. 폐기된 `PRF_ACRYL_ZIBITZ_TBD`는 use_yn=N(superseded·삭제금지)·`COMP_ACRYL_PENDING_TBD`는 타 *_TBD(165/168/226/171)가 공유하므로 **보존**.

### B-4. disjoint 자가검증 (Path 1)
- 단일 구성요소·단일 단가행(min_qty=1) → 항상 정확히 1행 매칭·형제 없음·silent-sum 불가. **disjoint ✓**.
- Path 2 시: opt_cd 2행(투명/스핀) 각기 opt_cd 비-NULL → 주문 opt_cd로 정확히 1행. 와일드카드(NULL) 없음·dflt 투명이 무선택 시 보장. **disjoint ✓**.

### B-5. 채번 (search-before-mint·MAX+1·separator `_`)
- comp_cd `COMP_ACRYL_ZIBITZ`(신규·부재 확인)·frm_cd `PRF_ZIBITZ_ACRYL`(신규)·comp_price_id 79166(MAX 79165+1).
- Path 2 추가: opt_grp `OPT_000082`(MAX OPT_000081+1)·opt `OPV_000491`(투명)/`OPV_000492`(스핀)(MAX OPV_000490+1/+2)·comp_price_id 79167(스핀).

---

## C. 골든 케이스 (검증가 재현 대상·권위 verbatim)

| # | 상품 | 주문 | 기대가 | 근거 |
|---|---|---|---|---|
| G1 | 코롯토 164 | 30×30, 수량 1 | **3,600** | B05 verbatim(라이브 24128) |
| G2 | 코롯토 164 | 80×80, 수량 1 | **8,400** | B05 verbatim |
| G3 | 코롯토 164 | 45×45, 수량 1 | **5,200** | off-grid→ceiling w50×h50(5,200) |
| G4 | 코롯토 164 | 50×50, 수량 10 | **52,000** | 5,200×10(단가형 unit×qty) |
| G5 | 지비츠 156(Path1) | 투명, 수량 1 | **200** | B04 verbatim |
| G6 | 지비츠 156(Path1) | 투명, 수량 100 | **20,000** | 200×100 |
| G7 | 지비츠 156(Path2) | 스핀, 수량 1 | **600** | B04 verbatim(스핀 배선 후) |
| G8 | 지비츠 156(Path2) | 스핀, 수량 100 | **60,000** | 600×100 |

G1~G4는 **현재 라이브에서 이미 재현되어야 함**(코롯토 기배선)·G5·G6은 Path 1 COMMIT 후·G7·G8은 Path 2(스핀·§7 선행) 후.

---

## D. 종료척도(§27) 대비

| 항목 | 코롯토(164) | 지비츠(156) |
|---|---|---|
| 배선 결함 | **0**(기배선) | Path 1 COMMIT 시 0(dead placeholder 해소) |
| PRICE≠0 | ✓(기배선·검증 대상) | Path 1 COMMIT 시 ✓(투명 200) |
| 잔존 | use_yn=N 활성화(§7) | 스핀 600(Path 2·§7 공정 mint) |
| 범위 밖 dead | 171·165·168·226 = 무권위 CONFIRM(실무진) — 배선 결함 아님(placeholder 정당) |

---

## E. 라우팅 표기

- **§7/dbmap**: ① 상품 활성화 use_yn=N→Y(164·156) ② Path 2 스핀 공정코드 mint(기초마스터) 또는 addon 템플릿.
- **실무진 CONFIRM**: 지비츠★(171)·포카/입체/쉐이커 코롯토(165/168/226) 단가(가격표 미수록·orphan confirm_queue_v2 ④).
- **실 COMMIT**: 인간 승인 후 §7 위임(dbmap load-execution). 본 설계 = dryrun까지.
