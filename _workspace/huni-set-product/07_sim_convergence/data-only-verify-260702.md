# 엽서북(PRD_000094) 0원 — 데이터-only 해결경로 실검증 (2026-07-02)

**질문:** webadmin 메뉴/데이터만으로(코드 수정 없이) 시뮬레이터 화면에 올바른 가격(100부 = 450,000원)이 나오게 할 수 있는가?
**방법:** 라이브 DB에 **실제 webadmin 엔진 코드(pricing.py)를 그대로 붙여** 각 후보의 데이터 변경을 트랜잭션 안에서 수행 → `evaluate_set_price`/`evaluate_price` 실호출 → **강제 ROLLBACK**. 라이브 흔적 0 (COMMIT 0건 — 사후 상태 스냅샷 동일성 검증 `residue_check_identical: true`).
**검증 하네스:** `data-only-verify-260702-dryrun.py` (Django 5.2 + config.settings + DATABASE_URL, 시뮬레이터 뷰 `price_simulate_set`의 페이로드 조립을 라인 단위로 충실 재현) · 전체 원시 출력 = `data-only-verify-260702-evidence.json`.

---

## 0. 하네스 신뢰성 먼저 검증 (S0 베이스라인)

내 로컬 재현이 라이브와 같은지부터 확인했다. 직전 라이브 API A/B 증거(`round2-ab-simulate-set-evidence.json`)와 **경고 문구까지 문자 그대로 일치**.

| 시나리오 | 데이터 변경 | 결과 | 라이브 A/B 대조 |
|---|---|---|---|
| S0a: UI 충실 페이로드(set_selections에 siz_cd 없음 — 화면 그대로) | 없음 | **final = 0** · 경고 4건 동일 | 일치 (A_ui_payload… final 0) |
| S0b: set_selections에 siz_cd 주입 | 없음 | **final = 450,000** | 일치 (B_with_setsel… 450000) |

판걸이수 `fn_calc_pansu(SIZ_000499, SIZ_000003)=9` · 내지 파생수량 = 100부×⌈20p/9⌉ = **300장** — 뷰(:1960-1966) 산식 그대로.

---

## 1. 후보별 실측 결과 (전부 ROLLBACK — 라이브 무변경)

### 후보 C — 셋트 구성 해제 (t_prd_product_sets del_yn=Y) → **기술적으로 유일한 GO (단, SOT 위반·비권장)**

```sql
BEGIN; UPDATE t_prd_product_sets SET del_yn='Y' WHERE prd_cd='PRD_000094'; …검증…; ROLLBACK;
```
- is_set 판정 행 0건 확인 → `price_sim_meta`(price_views.py:1757-1765)가 **단일상품 UI**로 분기.
- 단일상품 UI는 siz_cd를 렌더·전송한다(price_simulator.html:452) → `evaluate_price({prd_cd:094}, {siz_cd:SIZ_000003, print_opt_cd:POPT_000001, opt_cd:OPV_000491}, 100)` 실호출:
  - **100부 = 450,000 (source=FORMULA, 권위 verbatim)** · **2부 = 22,000 (2×11,000 — 권위 verbatim)** · 경고 0건.
- **적용 시 기대 화면**: 시뮬레이터가 셋트 폼 대신 단일상품 폼(사이즈/도수/페이지옵션 드롭다운)을 띄우고, 동일 입력에서 450,000원 표시. (실화면 확인은 라이브 데이터를 실제로 바꿔야만 가능 — COMMIT 금지라 DRY-RUN 근거로 갈음. 적용은 인간 승인 후 별도.)
- **그러나 비권장**: ① CLAUDE.md §1 [HARD] 상품유형 SOT 위반 — 094는 권위상 셋트 완제품이고 셋트 구분 자체가 `t_prd_product_sets` 부모 등록 여부다(역방향 교정 금지). ② §23 셋트 19개 전수진단·위젯 컨버전 트랙 회귀. ③ 페이지→내지매수 파생·생산 BOM 표시 소실. ④ 상품정보 changeform 인라인 삭제는 물리 DELETE라 복구까지 위험. 채택한다면 "임시조치 + C트랙 착지 시 원복" 조건의 인간 결정 사안.

### 후보 A/(b) — 공식 바인딩 094→095(내지) 이동 → **NO-GO 확정 (양방향 실증)**

```sql
BEGIN; DELETE …price_formulas WHERE prd_cd='PRD_000094';
INSERT …(PRD_000095,'PRF_PCB_FIXED','2026-06-01'); …검증…; ROLLBACK;
```
- **(i) UI 충실 페이로드: final = 0.** 내지 member는 source=FORMULA로 공식을 물었지만, 4개 구성요소 전부 `included=false` — **member 화이트리스트(price_views.py:1929-1933 = `("siz_cd","mat_cd","print_opt_cd")` 정확히 3개)에 opt_cd가 없어** 20P/30P(OPV_000491/492) 값이 member.selections에 영원히 도달 못 한다. 단가행 468행 전부가 opt_cd 값을 갖고 있어 행측 차원 비교(`_row_matches`, pricing.py:94-103 — 행 차원이 NULL일 때만 와일드카드)에서 전부 탈락. 게다가 프론트 구성원 입력(price_simulator.html:742)에 opt_cd 수집 UI 자체가 없다. **→ 질문 2에 대한 실증 답: opt_cd가 화이트리스트에 없으므로 페이지수 차원이 죽는다 = NO-GO.**
- **(ii) 가설(코드를 고쳐 opt_cd를 통과시킨다면?): final = 1,035,000 — 여전히 오답.** 내지 유효수량이 부수(100)가 아니라 파생 총내지매수(300장)라, min_qty 밴드가 300부 구간(3,450/부)으로 오매칭 → 300×3,450=1,035,000 (권위 450,000의 2.3배 과대청구). 즉 화이트리스트를 고쳐도 수량 축 충돌 때문에 재바인딩은 성립 불가.
- 부수 축을 맞추려고 member 전용 공식/단가를 새로 만들면 = 권당 완제품가(권위 단일표)를 장당가로 역산 분해 = **단가 날조 금지[HARD] 위반**.

### 후보 D — use_dims에서 siz_cd 제거 → **NO-GO 확정 (예측과 메커니즘 다름·결과 동일)**

```sql
BEGIN; UPDATE t_prc_price_components SET use_dims='["min_qty","print_opt_cd","opt_cd","opt_grp:OPT_000082"]'
WHERE comp_cd LIKE 'COMP_PCB%'; …검증…; ROLLBACK;
```
- **final = 0.** 당초 예측(ERR_AMBIGUOUS 동시매칭)과 달리, 실측은 그보다 앞 단계에서 죽는다: 매칭 필터는 use_dims가 아니라 **단가행 자신이 가진 차원 값**(`_row_matches` pricing.py:94-103)이 권위다. 468행 전부 siz_cd 값을 품고 있으므로, 선택값에 siz_cd가 없으면 행 하나도 후보가 못 되어 no-match → 0원. (ERR_AMBIGUOUS·합산제외(pricing.py:603)에 도달하려면 단가행의 siz_cd를 비우거나 2개 사이즈 행을 지워야 하는데 그건 권위 468행 날조.) use_dims는 공용 축이라 타상품 회귀 위험도 그대로. **어느 경로든 데이터만으로는 0원 탈출 불가.**

### 후보 B — 094 직접단가 등록 → **부적격 확정 (수치 실증)**

```sql
BEGIN; INSERT INTO t_prd_product_prices VALUES ('PRD_000094','2026-06-01',4500,…); …검증…; ROLLBACK;
```
- 직접단가는 공식보다 우선한다(pricing.py:461 — `unit_price × qty`, 공식 분기 자체를 안 탐).
- **100부 = 450,000 (우연 일치 — 4,500이 마침 100부 밴드 단가라서)** · **2부 = 9,000 ← 권위 22,000의 41%로 저청구.** 사이즈 3종×20P/30P×수량밴드 468행이 단일 unit_price로 붕괴 — 특정 한 조합만 맞고 나머지 전부 오가격. 등록하는 순간 FORMULA가 영구히 가려져 추후 C트랙 백필이 착지해도 공식이 안 돌아가는 조용한 회귀 함정. **등록 금지.**

### 후보 E — CPQ 옵션그룹 maps.dims로 siz_cd 주입 → **BLOCKED (코드 사실로 종결·DB 실측 불요)**

- `price_sim_meta`가 `opt_groups = []`로 **하드코딩**(price_views.py:1480 — "옵션그룹은 가격 시뮬레이터에서 제외 (2026-06-28)" 설계결정 주석 실재 확인). 프론트 주입 루프(price_simulator.html:733)는 살아 있으나 서버가 옵션그룹을 한 건도 안 내려보내므로, 어떤 데이터를 등록해도 setSel에 siz_cd가 실릴 수 없다. 데이터로 재활성 불가.

### (c)/(d) 대안 — 분해 공식 신설 / 사이즈의 옵션 재인코딩 → **검증 없이 기각 (권위 위반이 선행 차단)**

- (c) 표지/내지/제본 분해 단가가 권위(엽서북 = 권당 완제품가 단일표·계산공식집 고정가형)에 존재하지 않음 — 실측할 "정답 단가" 자체가 없어 어떤 값을 넣어도 날조. (d) 468행 재키잉+가짜 옵션그룹 mint — 기술적으론 가능하나 도메인 정본(사이즈=siz_cd 차원)·위젯/CPQ 계약 왜곡. 둘 다 DRY-RUN이 무의미한 권위 차단.

---

## 2. 결정 축 코드 사실 (전부 이번 세션 재확인)

| 파일:라인 | 사실 |
|---|---|
| price_simulator.html:635 | 셋트 폼 렌더에서 siz_cd 차원 제외 (`d.name!=="siz_cd"`) |
| price_simulator.html:722 | runSetSim setSel 조립에서 siz_cd 명시 skip — **0원의 결정 축** |
| price_simulator.html:742 | 구성원 페이로드 = siz/mat/popt만 (opt_cd 입력 UI 없음) |
| price_simulator.html:452 | 단일상품 폼은 siz_cd 정상 전송 (후보 C가 동작하는 이유) |
| price_views.py:1929-1933 | member 복사 화이트리스트 = ("siz_cd","mat_cd","print_opt_cd") — opt_cd 없음 |
| price_views.py:1987-1988 | set_selections = body 그대로 (siz_cd 백필 없음) |
| price_views.py:1480 | opt_groups=[] 하드코딩 (2026-06-28 설계결정) |
| price_views.py:1691·1757-1765 | is_set = t_prd_product_sets(del_yn='N') 행 존재 여부 |
| pricing.py:94-103 | 단가행 차원 값이 매칭 권위 (행 NULL만 와일드카드) — use_dims 편집으로 우회 불가 |
| pricing.py:461 | 직접단가 > 공식 우선순위 (직접단가 등록 = 공식 영구 마스킹) |
| pricing.py:603 | ERR_AMBIGUOUS = 합산 제외 (도달하려면 단가행 날조 필요) |

## 3. 최종 판정 (쉬운 말)

**엽서북 데이터는 잘못이 없다.** 사이즈만 서버에 전해지면 엔진이 정확히 450,000원(2부면 22,000원)을 낸다 — 이번에 실제 엔진 코드로 재확인했다. 문제는 시뮬레이터 화면이 "셋트 가격공식은 제본비만 쓴다"고 가정하고 **사이즈 값을 아예 서버로 안 보내는 것**(화면 코드 1곳 + 서버가 그걸 메워주지 않는 것 1곳).

데이터/메뉴만으로 가격이 나오는 길은 딱 하나 실재한다 — **셋트 등록을 풀어 단일상품으로 되돌리는 것(후보 C)**. 실측상 정확한 값이 나오지만, 이는 "엽서북은 셋트 완제품"이라는 상품 분류 정본을 거꾸로 데이터에 맞춰 깨는 것이라 금지된 방향이고(§1 SOT [HARD]), 셋트 전수진단·위젯 트랙이 회귀한다. 나머지 후보는 전부 실측 NO-GO: 공식을 자식으로 옮기면 페이지수(20P/30P)가 전달될 통로가 없어 0원이고, 통로를 코드로 뚫어도 수량 축이 어긋나 1,035,000원 오답이 된다. use_dims 편집은 단가행이 사이즈 값을 품고 있어 소용없고, 직접단가는 2부에서 저청구(9,000 vs 22,000), 옵션그룹 주입은 서버 하드코딩으로 막혀 있다.

**결론: 올바른 해법은 코드 1점 수정(개발팀 C트랙) — price_views.py:1987 부근 "부모 공식이 siz_cd를 요구하는데 안 왔으면 내지 구성원의 siz_cd를 백필".** 068/072 등 동작 셋트는 부모 공식이 siz_cd를 안 쓰므로 백필이 발동하지 않아 무영향. 검수 기대값 = 화면 동일 입력(100부·100×150·단면·20P) → 450,000원.

## 4. 증거 파일

- `data-only-verify-260702-evidence.json` — DRY-RUN 원시 출력 전체(시나리오별 final/구성요소/경고 + 사전·사후 상태 스냅샷 + `residue_check_identical: true`)
- `data-only-verify-260702-dryrun.py` — 재현 스크립트(ROLLBACK 전용·페이로드 조립 근거 주석)
- `round2-ab-simulate-set-evidence.json` — 라이브 API A/B(하네스 충실도 대조 기준)
- 기존: `diagnosis.md` · `menu-map-260702.md` · `formula-design-verdict-260702.md` · 스크린샷(round1/round2/postfix)
