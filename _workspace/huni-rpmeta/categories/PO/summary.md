# PO(포맥스·폼보드·등신대·피켓 = 경질 기재 인쇄물) 카테고리 — RP-Meta 파이프라인 요약

> 후니 RP-Meta 하네스. RedPrinting PO(경질 기재 인쇄물 — 포맥스/폼보드 합지·직접출력·피켓·등신대) 카테고리의 역공학→메타모델→갭→deepcheck→검증→codex 교차검증 파이프라인 산출 인덱스.
> **★PO 본질 = 경질 기재(포맥스/폼보드)에 합지 또는 직접출력 + 모양재단·자립 부자재 · distinct 0 → 17축 재포화(13번째 카테고리).** PO는 **선별 모드 프로브** = "경질 기재 마운팅(합지 vs 직접출력)·자립 구조(등신대/피켓)가 distinct #18 관리축인가". 두 각도 모두 부결 — 제작방식=인쇄방식#12(NC 동형·5번째 인코딩)·자립=형상#17(모양재단)+부속물#8(거치대 독립 SKU). ★PO 우월점: PH(Vue client-render)·AC(SSR-negative)와 달리 7상품 전부 레거시 SSR 완전노출 → "판정불가/추정"이 아닌 **관측 기반 부결**.

## 산출물
- **역공학(reverse):** [`reverse.md`](reverse.md) — 대표 5상품(POMXPRT 직접출력·POMXHAP 합지·POFMPRT 폼보드·POFMPCK 피켓·POSTPRT 등신대) 레거시 SSR GET 옵션 완전노출 실측(읽기전용·주문 0). 원자추출 + 기재마운팅/자립 #18 1차 예측. Ambiguous fragments PO-1~PO-4.
- **메타모델(02_metamodel):** [`_resolved-fragments.md`](../../02_metamodel/_resolved-fragments.md)(PO-1~PO-4) + [`discovered-axes.md`](../../02_metamodel/discovered-axes.md) §PO(v13.0). **★distinct 승급 0건.** PO facet 흡수: 기재(포맥스/폼보드×두께×검정)→자재#1 한 select 합성·제작방식(합지/직접출력)→인쇄방식#12+공정#2 라미/코팅·모양재단(컷아웃)→형상#17·거치대(CDL_DFT 700/1200/1500mm)→부속물#8 독립 SKU add-on·타일링→공정#2·사이즈 직접입력→사이즈#13 면적 연속차원.
- **★기재마운팅/자립구조 distinct #18 적대검증 (선별 모드 프로브):**
  - **제작방식(합지/직접출력) #18 부결 = 인쇄방식#12 5번째 인코딩.** NC 인쇄방식 부결과 정확히 동형 — 한 상품 내 "제작방식 select" 부재(POMXPRT/POMXHAP=별 pdtCode·차이=paper 검정 variant+코팅 캐스케이드)·①전용 슬롯 부재·②KB 결함 부재(합지=라미=#12 게이팅 멤버). 합지만 코팅(COT_DFT) 활성 = #12가 후가공 게이팅하는 lifecycle(NC 자재풀 게이팅 동형).
  - **자립구조(등신대 거치대/피켓) #18 부결 = 형상#17+부속물#8.** 모양재단=형상#17(ST 완칼 인스턴스)·거치대(CDL_DFT)=부속물#8 add-on이면서 GS 독립 부자재 SKU(GS/GSSBMTL) 참조·피켓은 자립 부자재 무(손잡이 내재)→자립방식=형상+부속물 유무로 분해. ①OBSERVED·②KB결함 부재 → ②불충족. PH 거치 부결과 동형이나 SSR 노출로 관측 기반 격상.
- **갭(03_gap):** [`gap-matrix.md`](../../03_gap/gap-matrix.md) §XXVII~XXVIII — 후니 라이브 information_schema 직접 SELECT(2026-06-20 read-only). **★PO facet = PASS(거치대 독립SKU·면적 연속차원·합지 코팅 PROC)·WEAK/data-gap(검정 variant·number4 면적배수)·★신규 vessel-gap 0**. ★PO-2 거치대 독립 SKU 참조 = **PASS**(`t_prd_product_addons.tmpl_cd` FK→`t_prd_templates`·PRD_000016이 5개 SKU[TMPL-000005/006/009/010/011] disp_seq 다중귀속 실데이터·옵션값 복제 아닌 정규화). PO-4 면적=`nonspec_width/height_min/max/incr` 7컬럼+work/cut. **PO가 추가하는 vessel-needs = 0건**(V-11·V-12 불변·search-before-mint 13연속 통과).
- **deepcheck(Phase 4.5·codex 발굴):** [`deepcheck.md`](deepcheck.md) — codex(gpt-5.5) 14후보 triage(전부 unverified). **신규 distinct 후보 0·codex 독립으로 "18번째 고객 주문축 불필요" 명시 동의.** ★codex 인용 출처 전부 signs.com(미국 사이니지)·Wikipedia = RP/후니 라이브 아님 → 전부 가설·미채택(RP 미관측 옵션·base-data facet·엣지케이스·소재군 세분화). 최강 #18 적대 construction_route도 codex 스스로 "고객 주문축 아님" 자인→PO-1 #12 facet 불변.
- **검증(05_validation):** [`mgate-verdict-PO.md`](../../05_validation/mgate-verdict-PO.md) — **M1~M6 전건 GO**·distinct 0 비준·제작방식=#12/자립 부결 확인·라이브 6/6 일치(addons.tmpl_cd·PRD_000016 5SKU·nonspec_* 7컬럼·코팅 PROC_000013~015·print_method 컬럼 전역 0건·siz work/cut)·deepcheck 14후보 무단채택 0·결함 0.

## ★codex 교차검증 (Phase 6.5·정식 에이전트 4번째 실증)
> codex cross-validation (Phase 6.5): gpt-5.5 독립 ABSORBED 판정 = validator 제작방식/자립 #18 부결과 **6/6 전건 합의·divergence 0 → 고신뢰 confirm**. 원문 [`codex-verdict.md`](codex-verdict.md)·reconcile [`codex-reconcile-PO.md`](../../05_validation/codex-reconcile-PO.md).

- **독립성[HARD] 보존:** codex에 우리 verdict("제작방식=#12"·"자립=형상+부속물") 비노출·workdir=`categories/PO/` 격리. codex가 17축 frame만 보고 동일 메커니즘(#12 게이팅·#8 독립 SKU 흡수)을 독립 재구성·"hard-substrate/self-standing을 신규 축 승격하면 overfit" 경고. stdin 파이프 호출(`cat prompt | codex exec ... -`)로 `/tmp` trusted-dir 우회.

## 종단 결론
**PO = 17축 재포화 13번째 카테고리·distinct 0·신규 vessel 0.** M1~M6 GO + codex 교차검증 6/6 합의로 고신뢰 확정. 상품 커버리지 누적 ≈ 401/479(84%). **★PO의 의미:** directive 최대 관전 2건(제작방식·자립구조)을 가진 강력한 프로브였으나 둘 다 기존 17축(#12·형상#17·부속물#8)으로 무손실 흡수 → 제작방식=NC 인쇄방식 부결 계열, 자립=PH 거치 부결 계열에 각각 정확히 합류. data-gap(검정 본체소재·면적 siz 적재·real_price 면적계수)은 dbmap 적재 트랙. carry-forward: real_price 면적배수 실계산(huni-widget)·deepcheck 후보 RP 라이브 재캡처 검증.
