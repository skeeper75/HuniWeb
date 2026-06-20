# engine-design-silsa-banner.md — 실사·현수막 면적매트릭스형 가격엔진 설계 (완제품)

> **핵심 설계가(hpe-engine-designer) 산출 — 실사·현수막 종단(아크릴 면적매트릭스 동형 전파).**
> cartographer 지도(`formula-map-silsa-banner.md`) + benchmark 흡수(`absorption-candidates-silsa-banner.md`)를 종합해,
> 실사·현수막 **3계산방식**(면적매트릭스·고정가·수량구간) 완제품의 가격공식 + 가격구성요소 + t_prc_* 단가행 그릇 + 바인딩 +
> **G-S1 후가공 배선 명세**를 라이브 `evaluate_price`가 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — t_prc_* 데이터 그릇/배선 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527) **포스터사인 [가로×세로] 면적매트릭스** > ③ 라이브 t_prc_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-20 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털인쇄·아크릴 GO 설계와 동일 컨벤션·동일 engine-contract(`pricing.py` 직접 확인 2026-06-20).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나 (실측 2026-06-20)

라이브 실측이 cartographer 지도를 **거의 전부 확인**했다. 실사·현수막은 아크릴(본체 미바인딩 G-A1)과 정반대로 **본체 가격사슬이 완성**돼 있고, 핵심 작업은 **G-S1 후가공 배선**(가격사슬 직교 단절 해소)이다.

| 라이브 실측 (2026-06-20·읽기전용 SELECT) | 값 | 설계 함의 |
|------------------------------------------|----|-----------|
| **PRF_POSTER_* 공식 28** | 전건 use_yn=Y·각 disp_seq 1 = 자기 본체 comp 1개 | 본체 완성·U6 공식분리(소재별) 이미 라이브 적용 |
| **상품 바인딩 PRD_000118~145** | 28상품 전건 1:1 자기 공식 바인딩(레거시 `PRF_POSTER_FIXED`는 바인딩 0=고아) | ★아크릴 G-A1(본체 미바인딩)과 정반대 — 바인딩 작업 불요 |
| **면적 본체 comp** | `["siz_width","siz_height"]`(일부 `min_qty` 잔류 선언)·prc_typ 전건 `.01 단가형`·동형결합 13→7 정본/단독 | ÷min_qty 미발생(아크릴 `.02` 가드 불필요)·골든 verbatim 풍부 |
| **고정가 본체 comp** | `["siz_cd"]` 또는 `["siz_cd","min_qty"]`·`.01` | 규격축(아크릴 카라비너 opt_cd와 다름) |
| **수량구간 본체 comp** | MINI_BANNER 10행·MINI_STANDBOARD 15행·`["siz_cd","min_qty"]`·`.01` | ★신규 유형(아크릴·디지털 비동형)·수량밴드 개당가 |
| **공통 후가공 comp**(오시·미싱·귀돌이×2·가변×2·별색×2) | proc_cd/proc_grp/print_opt_cd 판별차원 보유·`.01`·dim_vals.줄수/개수 충전 | **배선 가능**(미싱 PERF_1L 이미 proc_grp:PROC_000030 전환 완료=G-S2 BLOCKED 해소) |
| **배너 후가공 comp**(PUNCH_4/6/8·QBANG·STRING·BONGSEW·CUTEDGE·DTAPE·STAND) | ★**use_dims=[]·전 차원 컬럼 NULL = 판별차원 전무**·각 1행 | ★**silent 합산 위험원**(§2-4 가드 핵심) |
| **거치/우드행거/우드봉/천정고리/린넨마감** | `[siz_cd]`/`[opt_cd,min_qty]`/`[bdl_qty,min_qty]`·`.01` | 판별차원 보유(배선 안전) |
| **후가공 배선** | ★전 PRF_POSTER 공식이 **comp 1개뿐**(후가공 disp_seq 2~ 0건) | **G-S1 = 핵심 갭**(현 견적 시 후가공 선택해도 가격 반영 0) |

**∴ 실사·현수막 설계의 핵심 = "이미 완성된 본체 공식에 후가공 add-on을 안전하게 배선"이다(G-S1).** 신규 mint 0(공식·comp·단가행 전부 실재). search-before-mint 강하게 충족(아크릴보다 우월). 단 **배너 후가공의 판별차원 전무(use_dims=[])가 silent 합산 위험** → 배선 전 판별차원 충전 선결(§2-4·§5).

★ **골든값 라이브 재현 확인(2026-06-20·SELECT verbatim)**: 캔버스 600×1800=**37,800** / 아트프린트 600×1800=**21,600** / 린넨 600×600=**17,000**·600×1800=**32,400** / 접착투명 600×1800=**59,400**·600×600=**16,000** / 미니배너 SIZ_000028 [4=6,500·19=4,900·49=4,200·99=3,500·10000=2,800].

---

## 1. 계산방식 3종 (calc-formula-draft 권위) — 아크릴 2종 + 수량구간형 1종

| 계산방식 | 정의 | 실사·현수막 상품 | 엔진 처리(engine-contract) |
|----------|------|------------------|---------------------------|
| **면적매트릭스형** | 판매가 = 소재별 [세로행][가로열] 면적 룩업단가(off-grid=각 축 '이하' 최소 임계 ceiling·`pricing.py:144-164`). 인쇄+재단+소재 단가 통합 | 면적 13소재(아트프린트/방수/접착투명/린넨/캔버스/레더/타이벡/메쉬프린트/아트페이퍼/아트패브릭/접착방수 + 일반·메쉬현수막) | comp 1개 매칭(siz_width/siz_height TIER)·단가형 unit×qty |
| **고정가형** | 판매가 = 규격(siz_cd)별 고정 개당단가(면적 무관·이산 규격) | 폼보드·포맥스·액자2·캔버스행잉·족자2·PET/메쉬배너·시트커팅2·아크릴스티커2 | comp 1개(use_dims=[siz_cd]/[siz_cd,min_qty])·단가형 unit×qty |
| **★수량구간형(고정가+qty band)** | 판매가 = 규격(siz_cd) × **수량구간(min_qty tier)별 개당단가**(수량 ↑ 개당가 ↓·볼륨할인 단가 내장) | **미니배너·미니보드스탠딩** | comp 1개(use_dims=[siz_cd,min_qty])·단가형·★min_qty TIER 룩업 후 unit×qty(§4-B) |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·`pricing.py:8` "frm_typ 폐기→공식은 항상 구성요소 합산"·라이브 t_prc_price_formulas에 frm_typ_cd 컬럼 부재). 3계산방식은 별 엔진 분기가 아니라 **본체 comp 1개의 use_dims가 면적축(siz_width/siz_height)이냐 규격축(siz_cd)이냐 규격+수량축(siz_cd,min_qty)이냐의 차이**일 뿐. 설계는 셋을 똑같이 `formula_components` 배선으로 표현한다(디지털·아크릴 §1 동형).

**★아크릴과의 차이 3가지(비동형점):**
1. **prc_typ 더 안전** — 실사·현수막 면적 본체 전건 `.01 단가형`(아크릴 CLEAR3T=`.02 합가형`). `unit×qty`·÷min_qty 미발생 → ValueError 위험 구조적 0. **아크릴의 ".02 신규행 min_qty=1 가드"가 실사·현수막엔 불필요.**
2. **고정가형 축이 siz_cd(규격)** — 아크릴 카라비너=opt_cd(형상). 실사·현수막 고정가=명시 규격.
3. **수량구간형 추가**(미니류 min_qty tier·아크릴 부재) — 규격×수량밴드 개당가(§4-B).

---

## 2. 면적매트릭스 엔진 계약 — evaluate_price가 어떻게 먹나 [HARD]

### 2-1. 매트릭스 룩업 메커니즘 (라이브 `pricing.py` 검증)

본체 면적단가는 `COMP_POSTER_<MAT>` 한 comp이 2축(siz_width·siz_height)으로 단가행을 매칭한다. 엔진 처리(`pricing.py:78-174`):

1. **비수량 차원 정확매칭**(`NON_QTY_DIMS`·`pricing.py:38-39` 고정 상수): 면적 본체는 NON_QTY_DIMS 컬럼이 전건 NULL(소재 분기는 별 comp/공식이라 mat_cd 불요) → combos 1개(동시매칭 위험 없음·공식당 본체 1 comp).
2. **구간(티어) 차원 ceiling**(`TIER_DIMS`·`TIER_UPPER`·`pricing.py:41-46·144-164`): `siz_width`·`siz_height`는 **'이하' 상한 방향**(`TIER_UPPER`). 각 축 독립 "주문값 ≤ 임계 중 최소 임계"(=한 단계 큰 격자) 선택. off-grid(예 가로650×세로650) → width ceiling·height ceiling. 주문값 > 최대 → `ERR_ABOVE_MAX`.
3. **단가행 1행 확정** 후 `component_subtotal`(`pricing.py:177-192`)로 소계 산출(§3).

★ **아크릴 두께(mat_cd)와 차이 [HARD]**: 아크릴은 1소재 내 두께 분기가 mat_cd 정확매칭(165행 1 comp). **실사·현수막 소재는 별 comp/별 공식**(13→7 동형결합 정본·소재≠가격 차원). 면적 본체 comp에 mat_cd 차원 없음(전건 NULL). designer는 소재를 면적 comp의 mat_cd 차원으로 답습 금지(benchmark C-SB3·아크릴 두께와 다른 패턴).

### 2-2. ★W=가로(앞)·H=세로(뒤) — 가격축 권위 = 가격표 매트릭스 헤더 (work사이즈 금물) [HARD·돈크리티컬]

아크릴 돈크리티컬 동형 + 실사 직접입력 특성:

- **면적축 권위 = `siz_width`=가로(앞)·`siz_height`=세로(뒤)** = 가격표 [세로행]×[가로열] 매트릭스 헤더. 라이브 면적 본체 전건 `siz_cd=NULL·siz_width/siz_height NOT NULL`(WH 전환 COMMIT 완료·work 미사용). 축이 뒤바뀌면 비대칭 셀(예 린넨 600×1800=32,400 vs 1800×600)을 틀리게 룩업.
- **★work_width/height(작업사이즈·블리드) 절대 금물** — work 기준 룩업하면 주문자가 "600×600"을 골라도 work(블리드 가산) 구간을 룩업해 더 비싼 셀. **단 실사는 직접입력형(자유 가로/세로·cut=work·여백 0·silsa-quote §1.3)이라 work 가산 위험이 아크릴보다 낮으나 원칙은 동일**(가격축=siz_width/height 수치·work 가산 금물).
- **설계는 라이브 WH 상태 유지** — 신규 좌표 INSERT 시도 시 절대 work 기준 금지·가격축=가격표 매트릭스 헤더 verbatim.

### 2-3. off-grid ceiling = 엔진 내장 (단가행에 ceiling 행 안 만듦)

각 축 '이하' 최소 임계 ceiling은 `pricing.py:144-164`가 런타임 처리(TIER_UPPER). 단가행에 보간/ceiling 행을 만들지 않는다([[dbmap-compute-in-app-db-stores-lookup]]·benchmark C-SB1 "면적함수 부결·매트릭스+ceiling"). 가격표 명시 구간만 단가행(현수막 5m까지 무한 셀 불요)·off-grid는 ceiling으로 흡수.

### 2-4. ★nonspec 증가단위 = 입력 스냅(가격축 아님) — 현수막 100mm·포스터 200mm

대형 자유사이즈(현수막 m 단위)는 `t_prd_products.nonspec_*`(nonspec_yn·width/height_min/max/**incr**)로 입력 스냅 후 siz_width/siz_height TIER 매칭(benchmark C-SB2). 라이브 백필 **완료**(아크릴은 incr NULL이 GAP였으나 실사·현수막은 전건 실재):

| 상품 | width_incr | 함의 |
|------|:--:|------|
| 면적포스터 11소재 | 200mm | 직접입력 200mm 스냅 |
| 일반현수막(PRD_000138) | **100mm** | ★현수막=100mm 미세 증가단위(라이브 본체 행 900/1000/1200/1500/1750 실측 정합) |
| 메쉬현수막(PRD_000139) | 100mm | 〃 |
| 고정가 15·수량구간 2 | — | 규격(siz_cd) 이산·nonspec 무관 |

★ **incr은 입력 정규화(가격축 아님)** — incr 스냅 후 TIER ceiling이 가격 룩업. 최대 구간 초과 정책(현수막 5m 초과 거부 vs nonspec_max 제한)은 컨펌큐 Q-SB-NSPEC1.

---

## 3. ★min_qty / 면적단가 엔진 계약 확정 (benchmark 돈크리티컬 해소) [HARD]

### 3-1. 긴장과 라이브 증거

- **cartographer**: "면적 본체 전건 `.01 단가형`·min_qty 전건 1 또는 NULL → ÷ 미발생·안전".
- **benchmark**: "면적단가가 '1장당(×수량)'인지 '수량구간 총액'인지 엔진 계약 확정 필요(디지털 ×qty 과청구·아크릴 .02 미확정과 동일 돈-크리티컬 클래스·추측 적재 금지)".

라이브 직접 실측(2026-06-20) + 코드 검증(`pricing.py:177-192`)으로 **확정**:

| 증거 | 값 | 출처 |
|------|----|------|
| 면적 본체 prc_typ | **전건 `.01 단가형`**(CANVAS_FABRIC·ARTPRINT_PHOTO·ADH_CLEAR_PVC·LINEN_FABRIC·ARTPAPER·BANNER_NORMAL·BANNER_MESH) | 라이브 `t_prc_price_components.prc_typ_cd` SELECT |
| 면적 본체 min_qty | ADH_CLEAR/LINEN/ARTPAPER 단가행 min_qty=NULL·BANNER_NORMAL min_qty=1 전건·ARTPRINT/CANVAS use_dims에 min_qty 선언 잔류(단가행 NULL) | 라이브 SELECT(§아래 G-S3 잔류) |
| `component_subtotal` 계약 | `.01`(단가형): `subtotal = unit_price × qty`(÷min_qty 미발생·`pricing.py:191-192`). `.02`(합가형)만 `÷tier_min_qty × qty`(NULL→ValueError) | `pricing.py:177-192` 직접 확인 |
| 면적단가 의미 | 가격표 [가로×세로] 셀 = **그 사이즈 완제품 1장당 단가**(인쇄+재단+소재 통합) | 가격표260527 포스터사인·calc-draft "판매가=[세로][가로]" |

### 3-2. 확정 결론 — **면적단가 = 1장당 완제품가·subtotal = unit × qty (×qty 폭발 없음·디지털과 정반대)**

> **결론[HARD]: 실사·현수막 면적단가는 "1장당 완제품가"이고, prc_typ가 전건 `.01`이라 `subtotal = unit × qty` = 1장가×수량 누적이 정답. ×qty 과청구 위험은 없다.**

근거(반증불가·라이브 실측):
1. **면적 본체 전건 `.01 단가형`**: `component_subtotal`(`pricing.py:191-192`)이 단가형 분기 = `unit_price × qty`(÷min_qty 자체 미발생). 캔버스 600×1800 10장 = `37,800 × 10 = 378,000`(정상·1장 37,800×10). **묶음총액이 아니라 1장당가**(가격표 셀이 "그 사이즈 완제품 1장당 단가"이기 때문).
2. **디지털 ×qty 결함과 다른 이유**: 디지털 결함(명함 3500→350,000)은 단가가 "100매 1세트 총액"인데 prc_typ=.01·min_qty=100이라 ×100 폭발. **실사·현수막은 단가가 1장당가**이고 prc_typ=.01이라 ×qty가 곧 정답. **단가 의미(1장당 vs 묶음총액)가 디지털과 정반대** → ×qty 위험 없음.
3. **아크릴(.02 합가형 min_qty=1)과도 다름**: 아크릴은 `.02`라 `÷min_qty(=1)×qty`로 우연히 같은 결과·신규행 min_qty=1 가드 필요. **실사·현수막은 `.01`이라 ÷ 자체 미발생** → 가드 불필요·더 안전.

**∴ 면적단가=1장당 완제품가, subtotal=unit×qty(1장가×수량 누적). 디지털 ×qty 과청구·아크릴 .02 미확정 위험 둘 다 실사·현수막엔 없다(prc_typ .01 + 단가 의미가 1장당가).** (benchmark가 경계한 돈-크리티컬은 라이브 prc_typ + 단가 의미 확정으로 해소.)

### 3-3. ★G-S3 잔류 — ARTPRINT_PHOTO/CANVAS_FABRIC use_dims에 min_qty 선언 (단가행 NULL) [LOW·시맨틱]

- **실측**: COMP_POSTER_ARTPRINT_PHOTO·CANVAS_FABRIC·CANVAS_HANGING의 use_dims에 `min_qty` 선언이 있으나 단가행 min_qty 전건 NULL.
- **엔진 영향 = 없음**: 단가형(`.01`)은 min_qty를 ÷에 안 씀(`component_subtotal`). min_qty TIER 매칭(`pricing.py:144`)은 NULL=하한0 → 모든 수량 통과. **가격 무영향**.
- **설계**: use_dims에서 min_qty 제거(시맨틱 정리·`["siz_width","siz_height"]` 통일)는 LOW 정리(가격 무관). **단 신규 .02 전환 시엔 단가행 min_qty 충전 필수**(현 .01 유지면 불요). 컨펌큐 Q-SB-DIM1.

---

## 4. 고정가형 + 수량구간형 본체 (라이브 바인딩 완료)

### 4-A. 고정가형 (규격 siz_cd) — 바인딩 실재·유지

폼보드(2행)·포맥스(2)·프레임리스액자([siz_cd,min_qty] 2)·레더액자([siz_cd,min_qty] 2)·캔버스행잉(3)·린넨우드봉족자(3)·족자(4)·PET배너(1)·메쉬배너(1)·무광시트커팅(3)·홀로시트커팅(3)·유광아크릴스티커(4)·미러아크릴스티커(4) → 각 PRF_POSTER_<X>에 1:1 바인딩 라이브 실재(§0). **본체 작업 불요**·후가공/거치 배선만(G-S1·§5).

★ **G-S3b 캔버스행잉 차원 정합(MED)**: COMP_POSTER_CANVAS_HANGING use_dims=`[siz_width,siz_height,min_qty]` 선언이나 실 3행 siz_width/height NULL·min_qty=1 = 사실상 고정 3규격(siz_cd 룩업). 엔진은 NON_QTY_DIMS siz_cd 정확매칭이 작동하려면 단가행에 siz_cd 충전 필요. **현 3행이 siz_cd로 매칭되는지 / siz_width·height numeric인지 라이브 재확인 후 use_dims를 [siz_cd] 정정 vs 단가행 채움** 결정(가격축 정확성·컨펌큐 Q-SB-CH1·실무 권위).

### 4-B. ★수량구간형 (규격 × 수량밴드 단가·아크릴/디지털 비동형) [HARD·엔진계약]

> 라이브 실측 — 미니류만 min_qty tier(볼륨할인 단가 내장)·MINI_BANNER 10행·MINI_STANDBOARD 15행·바인딩 실재.

**단가행 verbatim(라이브 SELECT 2026-06-20):**

| comp | siz_cd | min_qty band | 개당가 verbatim |
|------|--------|:--:|------|
| COMP_POSTER_MINI_BANNER | SIZ_000028·SIZ_000328 | 4 / 19 / 49 / 99 / 10000 | 6,500 / 4,900 / 4,200 / 3,500 / 2,800 |
| COMP_POSTER_MINI_STANDBOARD | SIZ_000258 | 4/19/49/99/10000 | 4,500 / 4,300 / 4,200 / 4,000 / 3,800 |
| 〃 | SIZ_000315 | 〃 | 6,500 / 6,200 / 6,100 / 5,900 / 5,500 |
| 〃 | SIZ_000426 | 〃 | 3,500 / 3,400 / 3,300 / 3,100 / 2,900 |

**★엔진 계약 [HARD·구간 매칭 ≠ 할인]:**
1. **min_qty TIER = '이상' 하한 방향**(`pricing.py:42` "min_qty(수량): '이상' 하한. 행 적용조건 qty ≥ min_qty, 적용행 중 '최대' 임계"). 즉 주문수량 이하의 **최대 min_qty 구간** 선택(예 주문 30개 → min_qty=19 행 선택[19≤30<49]·개당 4,900). siz_width/siz_height TIER('이하' 상한)와 **방향 반대**임에 주의.
2. **개당가 × 수량**: prc_typ `.01 단가형` → `subtotal = unit_price(구간 개당가) × qty`. 30개 미니배너 = `4,900 × 30 = 147,000`. ★단가가 **수량구간별 개당가**(묶음총액 아님·4개=6,500/개·100개=2,800/개)이므로 ×qty가 정답·×qty 폭발 없음.
3. **★t_dsc 수량구간 할인과 구분[HARD]**: 미니류 수량밴드는 **단가행 자체에 볼륨할인이 내장된 가격(comp_prices.min_qty)**이지 t_dsc_* 별도 구간할인이 아니다. 엔진은 ① comp subtotal(min_qty 밴드 개당가×수량) → ② t_dsc 수량구간할인(별도·있으면) 순차 적용(§6). **둘을 합쳐 이중할인하지 않도록** — 미니류는 본체 단가에 이미 수량할인 baked(t_dsc 미연결 권장·컨펌큐 Q-SB-MINI-DSC).
4. **최소 구간 미달(qty < 4)**: `ERR_BELOW_MIN`(`pricing.py:56·160`) → 합산 제외(계산불가). 미니류 최소주문 4개 미만 견적 시도 = 정상 거부. 컨펌큐 Q-SB-MINI-MIN(4개 미만 주문 정책).

---

## 5. ★G-S1 후가공 배선 명세 (최우선·핵심 갭) — 판별차원 필수 [HARD·돈크리티컬]

### 5-0. 갭 정의 (라이브 실측)

전 28 PRF_POSTER 공식이 **comp 1개(본체)뿐**·후가공 disp_seq 2~ 배선 **0건**. 후가공 comp(오시·미싱·귀돌이·가변·별색 + 배너 타공/봉미싱/큐방/끈/거치 + 거치/우드봉/우드행거/천정고리/린넨마감)는 전부 라이브 실재하나 **공식과 단절** → 현 견적 시 후가공 선택해도 가격 반영 0(본체만 산출). gd2-wiring W4 명세가 존재하나 미적용.

### 5-1. 엔진 합산 메커니즘 (코드 확정·gd2-wiring §0 정합)

- **엔진은 addtn_yn을 안 읽는다**(`_evaluate_formula`·`pricing.py:340-349`): 공식의 모든 formula_components를 selections와 매칭 → 매칭되면 `included_sum += subtotal`, 매칭 0건이면 자연 제외. **후가공 comp를 공식에 배선만 하면 선택 시 가산·미선택 시 제외.**
- **U6 공식분리는 이미 완료**(라이브 28 공식 소재별 분리·각 본체 1 comp) → 본체 동시매칭 위험 없음(아크릴 gd2 선결 조건 충족됨).

### 5-2. ★silent 이중합산 가드 — 판별차원 필수 [HARD·핵심]

본체+후가공 N comp를 한 공식에 배선할 때, **각 후가공 comp가 판별차원(proc_cd/opt_cd/print_opt_cd 등 NON_QTY_DIMS 컬럼)을 갖지 않으면** silent 이중합산이 발생한다. 라이브 실측이 이를 노출:

| 후가공 그룹 | use_dims 실측 | 판별차원 | 배선 안전성 |
|-------------|---------------|:--:|:--:|
| 오시(CREASE_1L)·미싱(PERF_1L)·귀돌이(CORNER_ROUND/RIGHT)·가변(VARTEXT/VARIMG_1EA) | `[proc_cd,min_qty,proc_grp:...]`·dim_vals.줄수/개수 | ✅ proc_cd+dim_vals | 🟢 **안전**(선택 매칭) |
| 별색(SPOT_WHITE_S1/S2) | `[plt_siz_cd,proc_cd,print_opt_cd,min_qty,proc_grp:PROC_000007]` | ✅ proc_cd+print_opt_cd | 🟢 안전 |
| 거치(CANVAS_HANGING_WOODHANGER·LINEN_WOODBONG)·천정고리(JOKJA_CEILHOOK)·린넨마감(LINEN_FINISH) | `[siz_cd]`/`[bdl_qty,min_qty]`/`[opt_cd,min_qty]` | ✅ siz_cd/opt_cd | 🟢 안전 |
| **배너 타공(PUNCH_4/6/8)·큐방(QBANG_4)·끈(STRING_4)·봉미싱(BONGSEW)·열재단(CUTEDGE)·양면테이프(DTAPE)·PET거치(STAND_IN/OUT_S1/S2)** | ★**`[]` (빈 배열)·전 차원 컬럼 NULL** | ❌ **전무** | 🔴 **위험**(항상매칭·silent 합산) |

**★확정된 silent 합산 메커니즘(돈크리티컬)**:
- PUNCH_4·PUNCH_6·PUNCH_8은 **서로 다른 comp_cd**·각 use_dims=[]·단가행 전 컬럼 NULL. 한 공식(현수막)에 셋을 동시 배선하면 → `_match_entry`가 각 comp를 독립 평가 → `_row_matches`(`pricing.py:78-81`)가 NON_QTY_DIMS 전건 NULL=와일드카드로 **셋 다 통과** → 각자 1행 매칭(included=True) → **타공 4개+6개+8개 동시 합산**(3,000+4,000+5,000 = 12,000 과청구). 손님이 "타공 6개" 하나만 골라도 셋 다 가산.
- 이것은 ERR_AMBIGUOUS(한 comp 내부 단가행 사이·combos>1)가 **아니다** — 서로 다른 comp는 서로 만나지 않음. **디지털 V-DGP-1형 silent 합산**(견적이 "깨지는" 게 아니라 "틀린 값으로 성립"). `_match_entry`는 note "판별차원 없음 — 항상 매칭"만 남길 뿐 included=True로 합산함(`pricing.py:415-419`).

**∴ 배너 후가공 배선 [HARD] 선결 조건:**
- **(a) 같은 택1 그룹(타공 4/6/8 중 하나)은 단일 comp로 통합 + 판별차원 충전** — PUNCH_4/6/8을 1 comp(`COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH`)로 통합하고 use_dims=`[opt_cd]` 또는 `[proc_cd]` + 단가행에 구멍수 판별값(opt_cd 또는 dim_vals.구멍수=4/6/8) 충전. 손님 "타공 6개" 선택 → 6개 행만 매칭(silent 합산 차단). [[dbmap-price-component-grouping]] 종류축 차원키 그룹핑 패턴(comp_grp 신설 불요).
- **(b) 별개 후가공(타공·큐방·끈은 서로 직교·동시 선택 가능)은 별 comp 유지 가능** — 단 각 comp가 자기 선택 여부를 판별할 차원 필요. 큐방/끈/봉미싱/열재단/D테이프는 **택N(동시 선택 가능)**이라 각 별 comp + 각 comp에 자기 판별 opt_cd(선택 시만 selections에 실려 매칭). use_dims=[] 그대로 두면 미선택해도 항상 가산 → **반드시 opt_cd(또는 proc_cd) 판별차원 충전 선결**.
- ★**이 판별차원 충전(use_dims + 단가행 컬럼)이 배너 후가공 배선의 절대 선결**(아크릴 §5-B 미러 silent 합산 가드와 동형·디지털 D-3 print_opt_cd 충전과 동형). 충전 없이 배선하면 100% 과청구.

### 5-3. 배선 매트릭스 (gd2-wiring W4 계승·확장) — 명세까지(실 INSERT 인간 승인)

각 PRF_POSTER 공식에 본체(disp_seq 1·실재) + 후가공(disp_seq 2~) 배선:

**(가) 공통 후가공 — 면적·고정가 전 공식 공통(판별차원 보유·즉시 배선 가능):**

| disp_seq | 후가공 comp(정본) | 판별차원(use_dims) | 단가행 | addtn_yn | silent 합산 위험 |
|:--:|------|------|:--:|:--:|:--:|
| 2 | COMP_PP_CREASE_1L 오시 | proc_cd·dim_vals.줄수 | 30✅ | Y | 🟢 없음 |
| 3 | COMP_PP_PERF_1L 미싱 | proc_cd(PROC_000086)·dim_vals.줄수 | 실재✅(이미 proc_grp 전환·G-S2 해소) | Y | 🟢 없음 |
| 4 | COMP_PP_CORNER_ROUND/RIGHT 귀돌이 | proc_cd | 9/18✅ | Y | 🟢 없음(grouping C-5 통합 시 1 comp) |
| 5 | COMP_PP_VARTEXT_1EA 가변텍스트 | proc_cd·dim_vals.개수 | 69✅ | Y | 🟢 없음 |
| 6 | COMP_PP_VARIMG_1EA 가변이미지 | proc_cd·dim_vals.개수 | 69✅ | Y | 🟢 없음 |
| 7 | COMP_PRINT_SPOT_WHITE_S1 별색단면 | plt_siz_cd·proc_cd·print_opt_cd | 530✅(정본·5색 흡수) | Y | 🟢 없음 |
| 8 | COMP_PRINT_SPOT_WHITE_S2 별색양면 | 〃 | 53✅ | Y | 🟢 없음 |

**(나) 배너 전용 후가공 — 일반/메쉬현수막 공식만(★판별차원 충전 선결):**

| 후가공 | comp(현 상태) | 단가 verbatim | 선결 조치 | 배선 |
|------|------|:--:|------|:--:|
| 타공 4/6/8개(택1) | PUNCH_4/6/8 별 3 comp·use_dims=[] | 3,000/4,000/5,000 | ★**1 comp 통합 + opt_cd(구멍수) 판별차원 충전** | 통합 후 disp_seq 9 |
| 큐방 4개 | QBANG_4·use_dims=[] | 3,000 | opt_cd 판별차원 충전(택N) | disp_seq 10 |
| 끈 4개 | STRING_4·use_dims=[] | 4,000 | opt_cd 판별차원 충전 | disp_seq 11 |
| 봉미싱 | BONGSEW·use_dims=[] | 4,000 | opt_cd 판별차원 충전 | disp_seq 12 |
| 열재단 | CUTEDGE·use_dims=[] | 3,000 | opt_cd 판별차원 충전 | disp_seq 13 |
| 양면테이프 | DTAPE·use_dims=[] | 3,000 | opt_cd 판별차원 충전 | disp_seq 14 |

> 메쉬현수막은 PUNCH_4/6/8·QBANG_4·STRING_4(동형·use_dims=[] 동일 위험). 동일 충전 선결.

**(다) 거치/완제 부속 — 해당 고정가 공식만(판별차원 보유·배선 안전):**

| 후가공 | comp | 단가 verbatim | use_dims | 배선 대상 공식 |
|------|------|:--:|------|------|
| PET거치(실내/실외단면/양면) | STAND_IN/OUT_S1/S2 (use_dims=[]) | 7,000/23,000/25,000 | ★opt_cd 충전 선결(택1·3종) | PRF_POSTER_PET_BANNER |
| 캔버스행잉 우드행거+면끈 | CANVAS_HANGING_WOODHANGER | 16,000/18,000/20,000 | siz_cd✅ | PRF_POSTER_CANVAS_HANGING |
| 린넨우드봉 우드봉+면끈 | LINEN_WOODBONG_WOODBONG | 7,000/9,800/12,000 | siz_cd✅ | PRF_POSTER_LINEN_WOODBONG |
| 족자 천정형고리 | JOKJA_CEILHOOK | 6,500 | bdl_qty,min_qty✅ | PRF_POSTER_JOKJA |
| 린넨 마감가공(5택1) | LINEN_FINISH | 0/800/1,000/2,000/2,000 | opt_cd✅(OPV_000025/024/026/424/027) | PRF_POSTER_LINEN |

> PET거치 STAND_IN/OUT은 택1(실내 vs 실외단면 vs 실외양면)·use_dims=[]이라 ★opt_cd 판별차원 충전 선결(택1 셋 동시 합산 방지). 나머지(우드행거/우드봉/천정고리/린넨마감)는 판별차원 보유·안전.

### 5-4. 후가공 가산 = 개당 1회 vs ×수량 [HARD·돈크리티컬]

배너 후가공(타공/큐방/끈/봉미싱/열재단/거치)은 단가행 prc_typ `.01`·단가가 **건당 통가격**(예 타공 4개 세트 3,000원)인지 ×수량(현수막 1장당 3,000원)인지 = 디지털 후가공 ×수량 과청구와 동일 클래스. **라이브 단가행 의미 확정 필요**(추측 적재 금지):
- 단가가 "주문 1건당 통가격"이면 → 수량 무관 1회 가산. 그러나 엔진 `.01`은 `unit×qty`이므로 수량>1이면 자동 ×qty(예 10장 주문 시 타공 3,000×10=30,000). **단가 의미가 "1장당"이면 정합·"1건당 통가격"이면 과청구**.
- ★컨펌큐 Q-SB-PROC-QTY: 배너 후가공(타공/큐방/끈/봉미싱/거치)이 1장당인지 1주문건당인지 가격표/실무진 권위 확정. 1건당이면 별 prc_typ(고정 통액) 또는 min_qty 처리 설계(dbm-price-arbiter 심의). 거치대(STAND 23,000/25,000·우드행거 16,000~20,000)는 명백히 1장당이 아닌 **부속 SKU 통가격** 가능성 높음 → ×qty 과청구 위험 큼(컨펌 우선).

---

## 6. 수량할인 적용 순서 [HARD·엔진 계약]

엔진 단일 순서(`pricing.py:340-371`·아크릴 §7 동형):

```
① comp subtotal Σ  (면적/규격/수량밴드 본체 + 후가공 합산 — 공식의 모든 included 구성요소 합)
② 수량구간 할인     (_quantity_discount: prd_cd 연결 t_dsc 디테일·min_qty≤qty≤max_qty·정률/정액)
③ 등급 할인         (_grade_discount: 주카테고리·등급별·선택적)
   → ②③ 순차 곱(sequential)·final_price = round_won
```

- **면적/고정가 본체**: ① = 본체 subtotal(1장가×수량) + 후가공 → ② t_dsc 수량구간할인(있으면) → ③ 등급. 할인은 합계(amount)에 단계 적용(`pricing.py:357-368`).
- **★미니류 수량구간형**: 본체 단가에 이미 수량밴드 할인 baked(§4-B) → t_dsc 이중할인 금지(컨펌큐 Q-SB-MINI-DSC). 본체 min_qty 밴드 + t_dsc 둘 다 연결되면 이중 볼륨할인.
- **설계 함의**: 할인 데이터(t_dsc)는 dbmap round-1(구간할인 매핑·GO·미적재) 트랙. 본 설계는 할인 적용 순서가 엔진에 단일 경로로 내장됨을 명시·바인딩 시 prd_cd↔t_dsc 연결 유효성만 확인(컨펌큐 Q-SB-DSC1).

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| C7 frm_typ 미참조·공식=합산 | ✅ 면적/고정가/수량구간 모두 comp 합산형으로 표현(frm_typ 무참조) |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이·combos>1) | ✅ 본체 면적 comp 단가행 NON_QTY_DIMS NULL·combos 1개. 후가공 통합 시 같은 구멍수 1행 |
| P3-DEF 판별차원 없음 / silent 이중합산 | ✅ 공통 후가공·거치(판별차원 보유) 안전. ★배너 후가공(PUNCH/QBANG/STRING/STAND use_dims=[])는 **판별차원 충전 선결**(§5-2)·미충전 배선 절대 금지 |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ 면적/고정가/수량구간 본체 전건 `.01 단가형`(unit×qty·÷ 미발생). ★아크릴 .02 가드 불필요(전건 .01) |
| TIER_UPPER siz_width/height '이하' ceiling | ✅ off-grid=각 축 ceiling(엔진 내장·§2-3)·단가행 ceiling 행 안 만듦 |
| TIER min_qty '이상' 하한(수량구간형) | ✅ 미니류 min_qty 밴드 = '이상' 하한·주문수량 이하 최대 임계(§4-B·방향 siz와 반대) |
| U-7 시트 차원경계(SOT 1) | ✅ 각 PRF=자기 본체 1 comp(다른 소재/디지털 comp 침입 금지)·후가공만 addtn_yn=Y 별 comp. 배선은 시트 경계 안에서만 |
| 할인 적용 순서 | ✅ ① comp Σ → ② 수량구간 → ③ 등급(엔진 단일 경로·§6)·미니류 t_dsc 이중할인 가드 |
| search-before-mint | ✅ 신규 공식·comp·단가행 mint 0(전부 실재). 작업=후가공 배선 + 배너 후가공 판별차원 충전(use_dims/컬럼 UPDATE·신규 행 0)·grouping 통합 |

---

## 8. 핵심 메모 (아크릴 동형점 / 비동형점)

### 아크릴 동형점 (그대로 적용)
1. 면적매트릭스 = siz_width/siz_height 2축 구간 + 엔진 ceiling(신안 라이브 COMMIT).
2. W=가로(앞)·H=세로(뒤)·work사이즈 금물(돈크리티컬·단 실사는 cut=work).
3. off-grid = 엔진 TIER ceiling 내장(단가행 ceiling 행 안 만듦).
4. 도수·재단 = 단가 통합(1장당 완제품가)·별축 없음.
5. silent 이중합산 가드 = 판별차원 필수(아크릴 미러 §5-B 동형 → 실사 배너 후가공에 적용).
6. 명시적 반제품(세트조합) 없음(set-product 절).

### 비동형점 (아크릴과 다름)
1. **prc_typ 더 안전** — 면적 본체 전건 `.01`(아크릴 `.02`). ÷ 미발생·가드 불필요.
2. **고정가형 축 = siz_cd**(아크릴 카라비너 opt_cd와 다름).
3. **수량구간형 추가**(미니류·min_qty 밴드·아크릴 부재·§4-B).
4. **대형 면적·nonspec_incr 차등**(현수막 100mm/포스터 200mm·라이브 백필 완료).
5. **소재 다양·동형결합 라이브 적용**(13→7 정본·아크릴은 결합 대상 없었음).
6. **가격사슬 완성도 정반대** — 아크릴=본체 미바인딩(G-A1) 핵심 갭. **실사·현수막=본체 완성(28공식 바인딩·동형결합)·핵심 갭=후가공 배선(G-S1)**.
7. **★배너 후가공 판별차원 전무(use_dims=[])** — 아크릴엔 없던 silent 합산 위험원·배선 전 충전 선결(§5-2).

### 라이브 현황 요약
8. **본체 = 완성** — 28 PRF·28상품 1:1 바인딩·동형결합·신안 WH 전환 전부 라이브 COMMIT(2026-06-20 실측). 골든(캔버스 37,800·아트프린트 21,600·린넨 17,000·접착투명 59,400·미니배너 밴드) verbatim 재현.
9. **후가공 = 단절** — 전 PRF가 comp 1개뿐(후가공 배선 0). 핵심 갭=G-S1 배선·gd2-wiring W4 명세 존재(미적용)·배너 후가공 판별차원 충전 선결.
