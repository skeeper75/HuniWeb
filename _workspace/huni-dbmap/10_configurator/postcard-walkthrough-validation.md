# postcard-walkthrough.md 적대 검증 보고서 — GAP-1/GAP-3 클로징 검증

> 검증 2026-06-06 · `dbm-validator` 독립 적대 검증 · 대상 `10_configurator/postcard-walkthrough.md`.
> 방법: 인용 실코드·값·도메인 주장을 권위 소스에 char-단위 대조(python CSV 파싱/grep) + JSONLogic(reduce 포함) 손계산. DB read-only(쓰기 0).
> 권위 순서: 라이브(존재 판정) > 엑셀/ref(값 권위) > 설계문서. 식별자/코드/JSON = English, 설명 = Korean.
> 동반 참조: 본인 작성 `banner-walkthrough-validation.md`(닫을 GAP 리스트), `cpq-design.md`(불변 설계 권위).

---

## 0. 판정 요약 (verdict table)

### 0.1 오케스트레이터 지정 7대 체크

| # | 체크 | 판정 | 증명 소스 라인 |
|---|---|---|---|
| 1 | GAP-1 후가공 동시선택 (row4 4종 병렬) | **VERIFIED** | digital-print-l1.csv row_seq 4: col37 오시=`1줄`·col38 미싱=`1줄`·col39 가변텍스트=`1개`·col40 가변이미지=`1개` **한 행 동시**. 4종이 **독립 컬럼**(orthogonal 축)임을 down-column 열거로 입증 |
| 2 | 별색 5컬럼 공백 + PROC_000007 다중 | **VERIFIED** | L1 col24~28(화이트~은색) 전 7행 공백. ref-processes.csv PROC_000007 note=`"...(선택유형=다중)"` literal 존재. 008~012=화이트/클리어/핑크/금색/은색 |
| 3 | GAP-3 봉투 siz_cd freeze (EXISTS 유효) | **VERIFIED** | SIZ_000085=`110x160mm(50장)` 110×160, PRD_000001·002 보유. SIZ_000104=`화이트165x115mm(10장)` 165×115, PRD_000004 보유. 봉투 자기차원 EXISTS 통과 |
| 4 | PROC identity (027/028/029~032/print_option) | **VERIFIED** | ref-processes.csv 전건 일치. PRD_000016 process=027/028뿐(029~032 미적재). print_option opt1 단면(CLR_000005/CLR_000001)·opt2 양면(CLR_000005/005) |
| 5 | JSONLogic 정확성(reduce 포함) | **VERIFIED** | reduce 배열길이 idiom 유효(0/2/4→TRUE, 5→FALSE). §4 selection→PASS, 80%8==0. 적대 edge(qty81/5종/osi4) 전부 FALSE. fake count/length op 없음 |
| 6 | `[CONFIRM]` 정직성 + 발명 탐지 | **VERIFIED (정직)** | 판수15 vs 판걸이18(SIZ_000001만) 실불일치·SIZ_000104 "10장"vs note"50장" 실충돌·봉투가격 무가격컬럼·박/형압 L1공백 — 전부 실재근거로 `[CONFIRM]`. 발명 0 |
| 7 | 설계발견(§5.2 a~e) 무결성 | **VERIFIED (건전, 보강 권고)** | 5 긴장 전부 실데이터 근거. 단 누락 발굴 3건(§4) |

### 0.2 테이블별 실코드 대조 (per-table)

| 차원/주장 | 워크스루 값 | 라이브/ref 실값 | 판정 |
|---|---|---|---|
| PRD_000016 prd_nm/typ | 프리미엄엽서 / PRD_TYPE.04 | `프리미엄엽서` / `PRD_TYPE.04` | VERIFIED |
| nonspec_yn / qty 15/10000/15 | N / 15·10000·15 | `N` / `15·10000·15` | VERIFIED |
| qty_unit_typ_cd | NULL | 공백 | VERIFIED |
| size 7행 SIZ_000001~007 dflt=Y | 7행 | 정확히 7행 전부 dflt_yn=Y | VERIFIED |
| 판수 15/12/8/6/6/4/4 | L1 col12 | row3~9 col12 = `15/12/8/6/6/4/4` | VERIFIED |
| SIZ note 판걸이 18/12/8/6/6/4/4 | §1.3 | `판걸이=18.0/12/8/6/6/4/4` | VERIFIED |
| 판수 vs 판걸이: 73x98만 15 vs 18 | "73x98만 불일치" | SIZ_000001 only(15 vs 18.0), 나머지 일치 | VERIFIED |
| SIZ_000003 = 100x150 work102x152 | §4 | `100x150` work 102.00/152.00 cut 100/150 | VERIFIED |
| print_option 2행 | 단면/양면 + clr | opt1 단면 CLR_000005/CLR_000001, opt2 양면 CLR_000005/005 | VERIFIED |
| CLR_000005 CMYK4도 / CLR_000001 인쇄안함 | §1.3 | `CMYK 4도` chnl4 / `인쇄 안 함` chnl0 | VERIFIED |
| process 2행 027/028 mand=N | §1.3 | PROC_000027/028, mand_proc_yn=N, excl 공백 | VERIFIED |
| PROC_000027 직각(부모026 default재단)/028 둥근(R라운딩) | §1.3 | 027 직각 parent026 "default 재단" / 028 둥근 "R 라운딩" / 026 귀돌이 | VERIFIED |
| PROC_000029오시/030미싱 {줄수0~3}/031가변텍스트/032가변이미지 {개수0~3} | §1.3 | 029/030 `{줄수 0~3 줄}`, 031/032 `{개수 0~3 개}` | VERIFIED |
| material 0행 (종이 별도설정) | GAP-5 | ref-product-materials PRD_000016 부재(0행) + L1 col22 `*별도설정` | VERIFIED |
| addon 3행 PRD_000001/002/004 | §1.4 | 정확히 3행, note "...110x160 50장"/"165x115 50장" | VERIFIED |
| 봉투 prd_typ PRD_TYPE.03 | §1.4 | 001/002/004 전부 PRD_TYPE.03 | VERIFIED |
| 봉투 보유 사이즈 11/11/2 | §1.4 | PRD_000001=11(078~088)·002=11·004=2(104,105) | VERIFIED |
| 트레싱지봉투 미등록 | addon 불가 | ref-products 검색 0건 | VERIFIED |
| plate-size 7행, 112만 PAPER.03+PDF | §1.3 | SIZ_000112~118, 112만 OUTPUT_PAPER_TYPE.03+PDF | VERIFIED |
| 박 PROC_000033{크기}+자식16 / 형압 PROC_000050 | §3.3 composite | 033 `{크기 mm}` + 034~049(16종) / 050 형압(자식 051양각/052음각) | VERIFIED |
| color-count ref_key1 | `opt_id`(1/2) | 설계는 `clr_cd` — **키슬롯 불일치** | **MISMATCH(경미)** |
| SEL_TYPE.01/.02 | 인용 | code-values.md line54 동일 | VERIFIED |

**MISMATCH 발견: 1건(경미·설계↔워크스루 키슬롯). INVENTED: 0건. OVERSTATED: 0건(별색은 스스로 "설계상 입증, 본상품 미실증"으로 정직 한정).**

---

## 1. MISMATCH / INVENTED / OVERSTATED 상세

### MISMATCH-1 [MINOR] color-count ref_key1: `opt_id` vs 설계 `clr_cd`
- **워크스루 §3.3 line146/147:** 도수를 `ref_dim_cd='color-count'`, `ref_key1='1'/'2'`(= print_option **opt_id**)로 인스턴스화.
- **설계 cpq-design.md line81:** `color-count` → `ref_key1 = clr_cd`, 대상 `t_prd_product_print_options`.
- **불일치 실체:** 설계는 색상수 코드(`clr_cd`, 예 CLR_000005)를 키로 잡는데, 워크스루는 print_option 행 식별자(`opt_id`, 1=단면/2=양면)를 키로 잡았다. **참조 대상이 다른 컬럼**이다. 설계의 EXISTS 트리거(line146 `EXISTS(t_prd_product_print_options ...)`)는 print_options 테이블을 보긴 하나 키 컬럼이 미명세(`...`)라 어느 쪽이 맞는지 설계가 불완전.
- **다운스트림 영향:** `color-count` 차원의 의미가 "색상수(clr_cd)"인지 "인쇄면 선택(opt_id)"인지 모호. 단/양면은 print_option opt_id로 식별하는 게 실데이터(ref-product-print-options.csv opt_id 1/2)와 정합하므로 **워크스루 쪽이 실데이터에 더 맞다** → 설계의 `color-count→clr_cd` 매핑을 `print_option_opt_id`로 정정하거나 별도 `print-side` 차원 신설 필요. 발명은 아니나 설계 정합 결함.
- **권위 판정:** 라이브(opt_id로 단/양면 식별) > 설계(clr_cd). 워크스루가 옳고 **설계 매핑이 버그**.

### INVENTED: 없음.
모든 신규 코드(`opt_grp_cd`/`opt_cd`/`tmpl_cd`/`rule_cd`)는 "본 설계 신규 부여"로 명시. 실코드 인용(siz/proc/clr/addon_prd_cd)은 전부 라이브 일치. `[CONFIRM]` 마커는 라이브 실부재/실충돌 기반으로 정당.

### OVERSTATED: 없음 (별색 한정 정직).
§5.4가 "별색 multi-select은 설계상 가능 입증이지 본 상품 실증 아님(L1 5컬럼 공백)"을 명시 → GAP-1을 별색이 아닌 **후가공으로 실증**했음을 정직히 구분. 과대주장 회피 성공.

---

## 2. GAP-1 / GAP-3 클로징 판정 (핵심)

### GAP-1 (pick-N / max-N / SEL_TYPE.02) — **GENUINELY CLOSED ✅**
- **구조적 입증:** 후가공 4종(오시/미싱/가변텍스트/가변이미지)은 L1에서 **4개 독립 컬럼**(col37~40)이며 각자 0~3 값을 독립 열거. 배너의 단일 `가공` 컬럼(행당 1값 = 택일 SEL_TYPE.01)과 **근본적으로 다른 구조**.
- **실데이터 동시선택:** row_seq 4가 오시1줄+미싱1줄+가변텍스트1개+가변이미지1개를 **한 행에 동시** 보유, row_seq 5가 2줄/2줄/2개/2개 동시 보유 — 상호배타가 아닌 orthogonal 병렬축. 따라서 SEL_TYPE.02 + max_sel_cnt=4가 정당.
- **JSONLogic 검증:** R-HUGA-MAXN(reduce 배열길이≤4)이 max-N을 실제 계산(5종→FALSE 확인). 배너가 한 번도 못 행사한 다중선택·max-N을 비로소 행사.
- **단서(과대주장 아님):** 별색(SEL_TYPE.02·max5)은 본 상품 미보유라 미실증 — 워크스루 스스로 한정. 후가공만으로 GAP-1 충분 입증.
- **판정: 진짜 닫힘.** (단 모델링 뉘앙스 GAP-A 참조 — "4 독립 토글" vs "리스트에서 N개 픽"의 의미 차이.)

### GAP-3 (composite add-on freeze) — **GENUINELY CLOSED ✅**
- **EXISTS 트리거 유효성 입증:** template_selections가 freeze하는 siz_cd가 base 봉투 자기차원에 실재 — SIZ_000085∈PRD_000001/002 sizes, SIZ_000104∈PRD_000004 sizes(ref-product-sizes.csv char 확인). 배너 거치대(`[CONFIRM]` base_prd_cd, qty-only selection)와 달리 **코드까지 환원 완결**(가격만 `[CONFIRM]`).
- **진짜 복합 freeze:** `base 봉투 prd_cd + siz_cd 1개 + qty 50`이 selections로 운반 → AS-IS note 문자열("110x160 50장")이 구조화 차원 선택으로 승격. 배너가 못 행사한 복합 selections 실증.
- **판정: 진짜 닫힘.** (단 GAP-D template 깊이 한계는 봉투가 단순 PRD_TYPE.03이라 우연히 회피된 것 — 워크스루 §5.2(d)가 정직히 인정.)

### GAP-2 / GAP-5 (참고)
- **GAP-2 (excl-group 마이그레이션):** 여전히 **N/A**. 엽서도 excl_grp_cd 0행 → 마이그레이션 원천 없음. 배너 검증 must-fix #1이 그대로 잔존(GRP-BOOK류로만 실증 가능). 워크스루 §5.1이 정직 명시.
- **GAP-5 (미적재 차원 vs EXISTS 트리거):** **재확인·악화.** 종이 material 0행 + 후가공 029~032 process 0행(라이브 확인). OP-JONGI-DEFAULT·OP-HUGA-* 옵션은 참조차원 부재 → 설계 §4 EXISTS 트리거 위반 → 옵션 등록 불가. 배너 열재단(053 미적재)보다 광범위(종이 전체 + 후가공 4종). 워크스루 §5.1이 정직 노출.

---

## 3. 설계 정합성 (cpq-design.md ↔ postcard-walkthrough.md)

| 항목 | 설계 | 워크스루 | 정합 |
|---|---|---|---|
| option_groups SEL_TYPE.02 + max_sel_cnt | line59/164: SEL_TYPE.02 + max_sel_cnt로 pick-N/max-N | §3.1 OG-HUGAGONG SEL_TYPE.02 max=4 | OK (설계 의도 정확 행사) |
| option_items polymorphic + ref_param_json | line66~71 | §3.3 동일 | OK |
| `color-count` ref_key1 | **clr_cd** (line81) | **opt_id** (§3.3) | **MISMATCH-1** |
| `process` ref_key1=proc_cd + param | line79 | §3.3 동일 | OK |
| `addon`/`set` template | §3.2 templates + selections | §3.4 동일 | OK |
| templates base_prd_cd/price/note | line94~96 | §3.4 동일(price `[CONFIRM]`) | OK |
| template_selections 차원 참조 | line99~101 (옵션/차원 선택) | §3.4 ref_dim_cd=size+siz_cd+qty | OK |
| product_addons addon_prd_cd→tmpl_cd | line103~105 | §3.5 동일 + 마이그레이션 | OK |
| constraints rule_typ/logic JSONLogic | line110~116 | §3.6 3 rule | OK |
| `set` 차원에 `addon` 추가 | 설계 OPT_REF_DIM = size/material/process/bundle-qty/color-count/plate/set | 워크스루 §3.3 ref_dim_cd=`addon` 사용 | **경미 불일치** — 설계 OPT_REF_DIM에 `addon` 미열거(`set`만). 워크스루는 `addon`(template) 사용. 배너는 `set`. 차원명 미통일 |

**정합 결론:** 대체로 충실하나 **2건 불일치** — (1) color-count 키슬롯(MISMATCH-1), (2) ref_dim_cd `addon` vs 설계 `set` 미통일. 둘 다 설계의 base-code(OPT_REF_DIM) 미확정에서 기인 → 설계 측 보강 필요(워크스루 발명 아님).

---

## 4. 누락 발굴 (아키텍트가 놓친 약점)

### GAP-A [MAJOR] 후가공 "4 독립 토글" ≠ "리스트에서 N개 픽" — max_sel_cnt 의미 과부하
- 워크스루는 후가공을 SEL_TYPE.02 + max_sel_cnt=4 단일그룹으로 모델. 그러나 후가공 4축(오시/미싱/가변텍스트/가변이미지)은 **상호배타 리스트에서 고르는 게 아니라, 각자 독립 on/off + 0~3 정수 파라미터를 갖는 4개 별도 옵션**이다.
- max_sel_cnt=4는 "4개 다 켜도 됨"이라 항상 만족(상한이 곧 전체 개수) → **max-N 제약이 실질 무의미**(절대 위반 불가). 진짜 max-N(예: 5종 중 3종만)을 행사한 게 아님. GAP-1의 "max-N 행사"는 SEL_TYPE.02(다중)는 입증하나 **max_sel_cnt<전체인 진짜 상한**은 미입증.
- 영향: 별색(5종 중 max5)도 동일 함정. 진짜 max-N(전체>상한)은 여전히 미실증 — 배너 검증 GAP-1의 절반만 닫힘. **권고:** max_sel_cnt<옵션수인 케이스(예: 박색상 16종 중 2종 제한) 추가 실증.

### GAP-B [MINOR] row3 addon "★사이즈선택" 동적 freeze 미모델
- L1 row3 col44 = `엽서봉투 ★사이즈선택 : 100x150` — 봉투 사이즈를 **엽서 본체 사이즈에 연동 선택**하는 동적 addon. 워크스루는 봉투 siz_cd를 SIZ_000085/104로 **고정** freeze했으나, L1은 "★사이즈선택"(고객/본체연동 가변)을 시사. template이 siz_cd를 1개로 고정하는 모델이 이 동적 케이스를 표현 못 함 → template_selections가 "고정 freeze"만 지원, "본체연동 동적 선택"은 미지원. 설계 한계로 노출 권고.

### GAP-C [MINOR] 봉투 base 사이즈 1개 선택 근거 부재 — 왜 SIZ_000085인가?
- PRD_000001은 11개 사이즈(078~088) 보유. 워크스루는 SIZ_000085(110x160)를 freeze했으나, **그 선택 근거는 addon note 문자열 "110x160" 매칭뿐**. note→siz_cd 매핑은 명칭 문자열 파싱(110x160 → SIZ_000085)에 의존 → 자동 마이그레이션 시 명칭 충돌(여러 봉투사이즈가 같은 치수)·오매칭 위험. 트레이서빌리티 약함. **권고:** AS-IS note→template_selections 마이그레이션의 siz_cd 결정 규칙 명문화.

### GAP-D [참고] template 깊이 한계 — 워크스루 §5.2(d)가 이미 인정
- 봉투가 옵션 풍부한 상품이면 selections가 base 전 옵션트리 복제 → 폭발. 봉투가 단순 PRD_TYPE.03이라 우연히 회피. 워크스루가 정직히 인정했으므로 누락 아님(재확인).

---

## 5. §5 설계 발견 무결성 재검토

| 워크스루 주장 | 검증 |
|---|---|
| 5.2(a) 도수=print_option vs 별색=process 모델 분리 | 정확. print_option(opt_id 차원) vs PROC_000007 family(process) — 둘 다 "색상"이나 환원경로 분기 실재. (MISMATCH-1이 이 긴장의 구체화) |
| 5.2(b) 판수=size 부속 숨은축 | 정확. SIZ note `판걸이=N`에만 존재, CPQ 7차원에 판수축 없음 |
| 5.2(c) 박/형압 3차원 composite | 부분 정정 필요 — 박색상(034~049)은 PROC_000033 **자식**(계층종속) 맞으나, 형압은 PROC_000050(자식 051양각/052음각)으로 **박과 별개 트리**. "박가공+박색상+형압=3차원"은 박색상이 박 종속이라 실제로는 "박(가공+색상 1트리) + 형압(별트리)" = 2 독립축. 깊이 주장은 타당하나 트리 구조 서술 부정확 |
| 5.2(d) template 깊이 한계 | 정확(GAP-D) |
| 5.2(e) SIZ_000104 "10장" vs note "50장" | 정확. ref-sizes `화이트165x115mm(10장)` vs addon note `50장` 실충돌 |
| 5.3 권고 7건 | 건전. 단 GAP-A(진짜 max-N 미실증)·GAP-B(동적 freeze)를 추가 필요 |

---

## 6. 최종 판정

### **CONDITIONAL-GO** — GAP-1·GAP-3 클로징은 진짜이나, 설계 정합 1건 + 누락 1건 보강 조건부.

**근거:**
- 사실 정확성: 거의 완벽. INVENTED 0·OVERSTATED 0. 고위험 #1(동시선택)·#2(별색공백+다중)·#3(봉투 siz EXISTS)·#5(reduce JSONLogic) 전부 char/손계산 입증.
- GAP-1·GAP-3 **진짜 닫힘**(구조적·실데이터·JSONLogic 3중 입증).
- `[CONFIRM]` 정직성: 판수15vs18·10장vs50장·무가격·박형압공백 전부 실근거. 숨긴 값 없음.
- 설계발견: 5 긴장 건전(5.2(c) 박/형압 트리구조 서술만 경미 부정확).

**must-fix (순위):**
1. **[MINOR→설계버그·MISMATCH-1]** `color-count` ref_key1을 `clr_cd`(설계)가 아닌 `opt_id`(워크스루·실데이터 정합)로 정정하거나, 단/양면 식별용 `print-side` 차원 신설. 설계 cpq-design.md line81 매핑이 실데이터와 불일치 — 설계 측 정정 라우팅.
2. **[MAJOR·GAP-A]** 진짜 max-N(전체 옵션수 > max_sel_cnt)은 여전히 미실증. 후가공 max_sel_cnt=4=전체4라 제약 무의미. max_sel_cnt<옵션수 케이스(예: 박색상 16종 중 N) 추가 실증 필요. GAP-1은 "다중선택(SEL_TYPE.02)"만 완전히 닫고, "진짜 상한 max-N"은 부분.
3. **[MINOR·GAP-B/C]** ★사이즈선택 동적 addon·note→siz_cd 매핑 규칙 미모델 — template 고정 freeze 한계 + 마이그레이션 결정규칙 명문화.

추가(비차단): ref_dim_cd `addon`/`set` 차원명 통일(설계 OPT_REF_DIM 보강), §5.2(c) 박/형압 트리구조 서술 정정, GAP-2(마이그레이션)·GAP-5(미적재차원) 잔존 — 둘 다 배너 검증서 이미 식별·정직 승계.

---

## 부록 — 검증 사용 권위 소스 라인

- digital-print-l1.csv row_seq 3~9 (python CSV, col 11/12/22/23/24~28/36~40/44/33~35)
- ref-products.csv: PRD_000016 + PRD_000001/002/004 + 트레싱지 0건
- ref-product-sizes.csv: PRD_000016(7행)·PRD_000001(11)·002(11)·004(2)
- ref-sizes.csv: SIZ_000001~007(판걸이 note)·SIZ_000085·SIZ_000104
- ref-processes.csv: PROC_000007(다중 note)·008~012·026~032·033~050
- ref-product-processes.csv: PRD_000016 = 027/028뿐
- ref-product-materials.csv: PRD_000016 0행
- ref-product-print-options.csv: opt1/opt2 + ref-color-counts.csv CLR_000005/001
- ref-product-addons.csv: PRD_000016 3행 + note
- ref-product-plate-sizes.csv: PRD_000016 112~118
- code-values.md line54: SEL_TYPE.01/.02
- cpq-design.md line81: color-count→clr_cd (MISMATCH-1 근거)
- JSONLogic: 독립 평가기 손계산(reduce 배열길이·§4 PASS·적대 edge FALSE)
