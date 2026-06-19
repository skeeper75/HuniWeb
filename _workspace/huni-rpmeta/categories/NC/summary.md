# NC([옵셋] 명함·쿠폰·포토카드 = 옵셋 인쇄방식 인쇄물) 카테고리 — RP-Meta 파이프라인 요약

> 후니 RP-Meta 하네스. RedPrinting NC([옵셋](offset) 명함류 — 일반/고급지/2·3단 명함·쿠폰·대량 포토카드) 카테고리의 역공학→메타모델→갭→deepcheck→검증→codex 교차검증 파이프라인 산출 인덱스.
> **★NC 본질 = 디지털(PR/BC)과 동일 상품군이되 인쇄방식만 옵셋 · distinct 0 → 17축 재포화(11번째 카테고리).** NC는 **선별 모드 핵심 프로브** = "인쇄방식(옵셋 vs 디지털)이 distinct #18 관리축인가". 옵셋은 별도 가격엔진(offset2023_price)·자재종속 이산 부수 tier·옵셋전용 자재풀·item_gbn 토큰까지 가진 *가장 강력한 #18 후보*였으나 **부결** — 인쇄방식은 새 축이 아니라 **이미 #12(생산레시피/인쇄방식 게이팅 축·BN v2.0 등재)**. NC는 #12의 4번째 토큰 인코딩(`offset2023_*`)일 뿐. 가장 깨끗한 #18 부결.

## 산출물
- **역공학(reverse):** [`reverse.md`](reverse.md) — 대표 3상품(NCDFDFT [옵셋]일반명함·NCDFFLD [옵셋]2/3단명함·NCCDPHO [옵셋]대량포토카드) 라이브 infoCall 캡처([`captures/`](captures/)) 원자추출 + ★디지털(BC/PR) 대비 옵셋 차이표(7행 전부 "같은 슬롯·값만 다름") + 인쇄방식 #18 1차 예측. **★라이브 보강: playwright 헤드리스로 `get_digital_product_info` infoCall 인터셉트(Vue client-render SSR 우회·주문/POST 0·read-only).** Ambiguous fragments N-1~N-5.
- **메타모델(02_metamodel):** [`_resolved-fragments.md`](../../02_metamodel/_resolved-fragments.md)(NC v11.0·N-1~N-5) + [`discovered-axes.md`](../../02_metamodel/discovered-axes.md) §NC. **★distinct 승급 0건.** NC facet 흡수: item_gbn/price_gbn 토큰→#12 인쇄방식 enum·offset2023_price→가격#11 라우팅(ST 3엔진·AC 3엔진이 한 슬롯 다른 값 라우팅 선례)·접지→사이즈#13 SKU·오시/귀돌이→공정#2·옵셋 자재풀→자재#1.
- **★인쇄방식 distinct #18 적대검증 (선별 모드 핵심):**
  - **인쇄방식 #18 부결 = 이미 #12.** ①전용 슬롯 부재(옵셋 NC↔디지털 BC base-data 슬롯 100% 동형·item_gbn=discriminator enum·새 슬롯 0)·②KB 결함 부재(인쇄방식 #12 D-7로 BN v2.0 이미 1급 등재). 별도 가격엔진이 ①을 충족 안 시킴(가격#11 라우팅 enum 값). 신축 #18 제안=이미 등재된 축의 중복.
  - **★N-2 결정적 분기 = data-gap(vessel-gap 아님):** 옵셋 자재종속 이산 부수 tier(MTRL_CD×PRN_CNT 100~500·자유입력 불가)는 인쇄방식 축 증거가 아니라 같은 `pdt_exp_prn_cnt_info` 슬롯의 *채움 방식 차이*(디지털=연속 increment·옵셋=이산 매트릭스) → 수량#10 이산 모드 표현력 미적재(data-gap)·제약#5·가격#11 분산. PD-4·FS-1 타일링 data-gap 동일 계열.
  - **★dbmap 정합:** rpmeta "인쇄방식=#12·신축 #18 부결(중복)" = dbmap `print-method-not-absolute-axis`("인쇄방식≠절대축·시트가 1차 단위") — **같은 결론·다른 렌즈·상호 보강**(taxonomy 과대화 금지 = 중복 신축 금지).
- **갭(03_gap):** [`gap-matrix.md`](../../03_gap/gap-matrix.md) §XXV~XXVI — 후니 라이브 information_schema 직접 SELECT(2026-06-19 read-only). **★NC facet = PASS·WEAK 2·GAP 2·★신규 vessel-gap 0**(전부 기존 #10/#11/#12 재확인). data-gap: 자재×허용부수 매트릭스(round-6 CPQ)·부수구간 단가(round-1 t_dsc_* 구간할인)·상품↔offset2023_price 바인딩(round-5)·옵셋 자재행/박형압(round-22·unobserved). **NC가 추가하는 vessel-needs = 0건**(V-11·V-12 불변·search-before-mint 11연속 통과).
- **deepcheck(Phase 4.5·codex 발굴):** [`deepcheck.md`](deepcheck.md) — codex(gpt-5.5) 17후보 triage(전부 unverified). **신규 distinct 후보 0·codex 인쇄방식 #18 부결 독립 동의.** 최강 잔여 NC-DC-17(variable-data offset)도 codex 스스로 "새 축 아닌 #12 표현력 갭"으로 분류. codex 합판/터잡기 판정이 메모리 `dbmap-compute-in-app-db-stores-lookup`(판수=앱계산·DB 룩업만)과 독립 일치. ★실제 갭=쿠폰 전용 후가공(넘버링/미싱) 미관측·고급지 2종 자재풀 미캡처(대표샘플 명함 중심·honest-scope unobserved).
- **검증(05_validation):** [`mgate-verdict-NC.md`](../../05_validation/mgate-verdict-NC.md) — **M1~M6 전건 GO**·distinct 0 비준·인쇄방식=#12 확인·라이브 재실측 11건 일치(price_gbn/item_gbn/frm_typ 컬럼 전역 0건·product_price_formulas 76행·연속 increment 수량슬롯·mat print_method 0·constraints 10·t_dsc_* min/max_qty)·결함 0. Low 드리프트 1(option_items 469→477 정상 적재·판정 무영향).

## ★codex 교차검증 (Phase 6.5·정식 에이전트 실증)
> codex cross-validation (Phase 6.5): codex gpt-5.5 독립 lane이 인쇄방식 #18 = ABSORBED(부결) 독립 동의 + 옵셋 4요소(offset2023_price→#11·이산 tier→#10/#5/#11·RXWMO220→#1·item_gbn→#12) 기존축 분류 + 이산 tier data-gap 합의 = validator와 **7/7 전건 합의·divergence 0 → 고신뢰 confirm**. 원문 [`codex-verdict.md`](codex-verdict.md)·reconcile [`codex-reconcile-NC.md`](../../05_validation/codex-reconcile-NC.md).

- **독립성[HARD] 보존:** codex에 우리 verdict("#18 부결"·"인쇄방식=#12") 비노출·workdir=`categories/NC/` 격리. codex가 17축 frame의 #12 존재만 보고 ABSORBED를 독립 도출 → echo 아닌 진짜 교차확인. codex가 동일 evidence로 동일 verdict 독립 수렴.
- **★정식 에이전트 실증(2번째):** FS는 오케스트레이터 인라인이었으나 NC는 정식 `rpm-codex-validator` 에이전트가 직접 수행. codex CLI 호출 함정 자가복구: `/tmp` trusted-dir 미인정 → `--skip-git-repo-check` + stdin 파이프. gpt-5.5 AVAILABLE·EXIT 0.

## 종단 결론
**NC = 17축 재포화 11번째 카테고리·distinct 0·신규 vessel 0.** M1~M6 GO + codex 교차검증 7/7 합의로 고신뢰 확정. 상품 커버리지 누적 ≈ 387/479(81%). **★NC의 의미 = 선별 모드 핵심 프로브 통과**: 별도 가격엔진까지 가진 *가장 강력한 인쇄방식 distinct 후보*조차 새 축이 아닌 기존 #12의 토큰 재확인 → 17축 그릇이 인쇄방식 변이(옵셋/디지털)를 무왜곡 흡수함을 강하게 입증. data-gap(이산 부수 tier·offset price 바인딩·자재 호환)은 dbmap 적재 트랙(round-1/5/6/22). carry-forward: 쿠폰 후가공·고급지 자재풀 미캡처·박/형압 명함([Coming soon]) 출시 후 재캡처.
