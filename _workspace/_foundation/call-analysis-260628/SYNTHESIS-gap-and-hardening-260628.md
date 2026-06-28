# 통화분석 ↔ webadmin 코드 갭 종합 + 파이프라인 하드닝 (2026-06-28)

> 입력: `PRINCIPLES-call-analysis-260628.md`(통화 결정 SOT) ↔ 3 갭 감사(`01_gap_pricing-engine.md`·`02_gap_cpq-classification.md`·`03_gap_set-product-bugs.md`).
> 목적: 기존 가격 파이프라인(§26→§7→§18→§7→§21·§27 마스터)이 통화 원칙을 인코딩하도록 하드닝. webadmin 코드 정적 분석·라이브 쓰기 0.

## ★최우선 발견 — 엔진 계약의 silent-undercharge 갭 2종 (돈크리티컬)

가격엔진(`evaluate_price`)은 **호출자가 넘긴 것만 평가**한다. "자동 가산/자동선택"은 **시뮬레이터 JS(UI)에만** 있고 **엔진 불변식이 아니다**. → 위젯·`evaluate_price` API·주문 재검증이 필수공정/기본자재를 안 넘기면 **인쇄비·자재값 누락(저청구)**.

| # | 갭 | 플래그 실재 | 자동주입 위치 | 엔진 갭 | 함의 |
|---|---|---|---|---|---|
| G1 | **D2 필수공정 자동가산** | `mand_proc_yn` ✅ `models.py:451` | JS만 `price_simulator.html:325`·POST는 클라가 보낸 proc만 `price_views.py:1769` | ★엔진 미주입 | 위젯/API서 인쇄비 누락(B4와 동일 병인) |
| G2 | **D3 기본자재 자동선택** | `dflt_yn` ✅ `models.py:326` | JS만 `price_simulator.html:196` | ★엔진 미주입 | 다자재 상품 위젯/API서 자재단가 comp 누락 |

→ **하드닝 핵심: "엔진이 `mand_proc_yn=Y` 공정·`dflt_yn=Y` 자재를 호출자 미제공 시 자동 주입"을 엔진 계약(불변식)으로 승격.** 현재는 UI 한정 약속. (C트랙 webadmin 코드 OR 위젯 계약서 양쪽 인코딩.)

## D1 가격 3종 모델 — 엔진 OK·데이터 오타이핑이 결함
- `.01 단가형=unit×qty`·`.02 합가형=unit÷min_qty×qty`(보간 SOT 공식 정확 일치=지원확인)·`.03 고정=그대로`(제3형 고정가산형 정확 구현) `pricing.py:193~210`. **엔진 표현력 충분.**
- 증폭기: **NULL→.01 기본** `pricing.py:587`. 밴드총액 comp이 .01로 적재되면 ×qty 폭증.
- ✅ **이미 교정**: band-total 바인딩 12건 `.01→.02` COMMIT(`FINDING-bandtotal-x-qty-overcharge.md`). 잔여=미바인딩 13+나머지 상품 probe.
- ★미결(통화): 합가형이 실존 모델인지 vs 고정가산형만 필요한지 — **라이브 레거시 대조**(§27 단계5 교차검증 오라클로).

## D4 분류 3원칙 — 그릇 지원확인·복합형만 갭
- 옵션/추가상품/공정 = 별개 테이블·별개 UI 분리(지원확인). `sel_typ_cd`(택1/택N)·`mand_yn`·`max_sel_cnt` 실재 `models.py:593`.
- ★**복합형 '가공옵션'(자재+공정 혼합단가) = 돈크리티컬 갭**: 가격경로 `component_prices.opt_cd`(FK없는 CharField)·엔진 자인 "판별차원 없음→상시 매칭" `pricing.py:598`. 손님 선택 미주입→상시가산/본체묻힘. 정식=추가상품 템플릿. [[addon-optcd-model-broken-live]] 합류 → §18 재설계+§21 전수적발.

## D5 공정 상세·다중누적 — 지원확인
- `t_prd_product_processes` PK=(prd_cd,proc_cd)=1:N 다중누적 OK(화이트+클리어·금박+은박). 공정상세=`prcs_dtl_opt`(정의 JSON)+`dim_vals`(선택값). 엔진 공정별 개별평가·합산 `pricing.py:694`. **추가작업 불요.**

## D6 책자 반제품/세트 — 그릇 완비·UI/데이터/미결만
- `t_prd_product_sets`에 `min_cnt`/`max_cnt`/`cnt_incr` 실재 `models.py:469`. `evaluate_set_price` 하이브리드(Σ구성원+셋트 제본공식·할인 합산후1회) `pricing.py:844~958`=D6 정합. **스키마 결함 0.**
- 갭: ① 셋트 구성원 개수선택 시뮬/위젯 UI 미발견(가설=미구현) ② `sub_prd_qty`↔`min_cnt` 의미중첩 ③ 제본세부(링컬러/D링)=공정상세 vs 옵션 미결(내일 11시).

## D7 조각수 / D8 비규격 — 규명 완료
- D7: 옵션그룹 Min-Max **실재**(`min_sel_cnt`/`max_sel_cnt` `models.py:594`·단 '동시선택 개수'이지 '조각수 값범위' 아님=용어혼선). 조각수 5~10 개별 option_item 등록=현 모델 정합.
- D8: nonspec 트리거 **규명**=`t_prd_products.nonspec_yn` `models.py:508`. UI=`nonspec_yn=="Y"`→비규격 직접입력 체크박스 `price_simulator.html:247`·siz_cd 차원 없으면 자동체크. **통화 미결 해소.**

## D9 버그 — C트랙(코드) vs 하네스(데이터) 분리
| 버그 | 근본원인 | 라우팅 |
|---|---|---|
| **B1** 자재저장 500 | 복합PK(prd_cd+mat_cd+usage_cd) 동시삭제+키변경시 `update_or_create` 경합 `views.py:983`(가설) | ★C트랙(개발팀·돈/운영) |
| **B2** OC 두줄 소실 | 시뮬 공정상세 캐시 배열인덱스 키잉+early-return `price_simulator.html:368,354` | ★C트랙(프론트·돈) |
| **B3** Step/Max 무시 | Max 미바인딩 `price_simulator.html:298`(C트랙) + Step=incr 폴백·라이브 `qty_incr` NULL 의심(데이터 선확인) | 혼합 |
| **B4** 인쇄 중복·디지털 누락 | print_options 정본인데 공정 "인쇄" 중복·디지털인쇄 공정 누락 | 하네스 §7/§21 데이터 |
| **B5** 옵션·자재 중복(고리) | 고리가 materials+옵션 양쪽(D4 미적용) | 하네스 §7/§21 데이터 |

## ★파이프라인 하드닝 액션 (갭→어느 하네스에 인코딩)
| 액션 | 대상 | 유형 |
|---|---|---|
| H1 | **엔진계약 불변식 승격**: `mand_proc_yn=Y`·`dflt_yn=Y` 자동주입(G1·G2) | §18 `hpe-engine-design` 설계계약 + 위젯계약(§6) + C트랙 검토 |
| H2 | **밴드총액 .01 결함룰**: 밴드총액 comp이 .01이면 결함 + 3종모델 판별 | §26 `hpti-load-integrity-audit`(일부 codify됨) |
| H3 | **복합형 가공옵션→addon 강제**: opt_cd-only comp 금지·addon 템플릿 정식 | §18 재설계 + §21 전수적발(addon-broken guard) |
| H4 | **분류 3원칙 게이트**: 엑셀표기(추가상품/가공옵션)→t_* 매핑 규칙·B5 중복 가드 | §7 dbmap CPQ + §21 정합 |
| H5 | **통화 PRINCIPLES SOT 참조**: §27 마스터가 D1~D9를 인코딩 기준으로 로드 | §27 `huni-price-master-orchestrator` |
| C트랙 | B1·B2·B3(Max)=webadmin 코드결함 | 개발팀 배포(인간) |

## 결론
- 통화 결정 다수는 **그릇이 이미 webadmin에 존재**(D4·D5·D6·D7·D8 지원확인=과잉설계 방지). 진짜 갭은 **엔진 계약(G1·G2 자동주입)·데이터 오타이핑(D1 밴드총액·D4 복합형)·UI(셋트 구성원·B2/B3)·코드결함(B1)**.
- 최대 가치 하드닝 = **H1(엔진 자동주입 불변식)** — 위젯/API 저청구의 구조적 원인. 그 다음 H3(복합형)·H2(밴드총액·진행중).
