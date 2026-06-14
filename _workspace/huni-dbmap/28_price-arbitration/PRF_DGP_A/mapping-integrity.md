# PRF_DGP_A — mapping-integrity & root-cause (arbiter 정립)

> 작성 2026-06-14 · round-18+ Phase 6 정립 · 클래스 PRF_DGP_A(디지털인쇄 원자합산형A·엽서 등 9상품).
> 입력: G-DATA 게이트([[PRF_DGP_A-gdata-gate]] NO-GO) · prcx01 명세(`raw/webadmin/docs/prcx01-pricing-model.md`) · 라이브 실측(읽기전용).
> 권위 = 가격표/상품마스터 엑셀 + 스키마 설계의도(prcx01). 라이브는 검증 대상.

## 1. G-DATA NO-GO 사유 재확인
- GATE-S ✅(29 comp 배선·단가행 완비) / A-2 ✅(참조 가격 차원 마스터 고아 0·round-13 MIS-LOADED 무관).
- **A-1 🔴 — D-2(옵션→comp 멤버십 매핑 부재) + D-1(작업사이즈→출력판형 변환 부재).**

## 2. 근본원인 — D-2 (최중대)

### 2-1. 진단: 멤버십(membership) ≠ 차원(dimension)
가격엔진은 두 가지를 풀어야 한다:
1. **멤버십** — 고객 옵션 선택에 따라 *어느 comp를 합산집합에 포함*하나.
2. **단가** — 포함된 comp의 *단가를 얼마로 조회*하나(prcx01 다차원 매칭).

prcx01 명세는 **단가(차원 매칭)만** 규정하고 **멤버십은 규정하지 않는다.** 라이브도 멤버십 매핑이 없다(아래). 순수 차원매칭만 적용하면 배선된 29 comp가 무차별 합산 = 과대합산(D-2).

### 2-2. 라이브 실측 — comp 3유형
| 유형 | comp 예 | 단가 차원(prcx01) | 멤버십 결정 | 라이브 멤버십 매핑 |
|---|---|---|---|---|
| 차원=멤버십 일치 | 용지 COMP_PAPER | siz×mat | mat_cd(옵션 종이=MAT_xxx → 그 mat 단가행) | ✅ 자동(option_items .03자재 → comp mat_cd 차원 공유) |
| 차원-단가 + 옵션-멤버십 | 인쇄 S1/S2·코팅 유광/무광 | siz×clr×coat_side | 옵션값(단면/양면·유광/무광/없음)이 comp_cd 택1 | 🔴 **부재** |
| 순수 선택-멤버십 | 모서리 직각/둥근·후가공 오시/미싱/가변 | 없음(차원 NULL·0원/고정) | 옵션값이 comp_cd 포함 | 🔴 **부재** |

- 라이브 증거: COMP_PP_CORNER_RIGHT 단가행 = 전 차원 NULL·unit_price 0(comp_cd 자체로만 식별). COMP_COAT_GLOSSY = siz×coat_side 단가 있으나 유광/무광 택1은 차원 밖.

### 2-3. 끊긴 지점
엽서 016 옵션 레이어는 적재됨(4그룹: 인쇄·종이·모서리·후가공). option_items는 polymorphic `ref_dim_cd`로:
- 종이 → MAT_xxx (OPT_REF_DIM.03 자재) ✅ comp(COMP_PAPER) mat_cd와 연결됨
- 모서리 → PROC_000027/028 (OPT_REF_DIM.04 공정) 🔴 가격 comp(COMP_PP_CORNER_RIGHT/ROUND)와 **무관**(공정코드 ≠ comp코드)
- 후가공 → PROC_000029~032 (.04) 🔴 COMP_PP_CREASE/PERF/VARIMG/VARTEXT와 **무관**
- 인쇄 → 면수 1/2 (OPT_REF_DIM.06 도수, ref_key=1/2) 🔴 COMP_PRINT_DIGITAL_S1/S2 택1과 **무관**

**OPT_REF_DIM 7종(.01사이즈~.07셋트)에 가격 comp(comp_cd) 참조 타입이 없다.** component_prices.opt_cd 컬럼은 존재하나 3,481행 전부 NULL(미사용). → 옵션값→comp_cd 멤버십을 표현할 자리가 라이브 어디에도 채워지지 않음 = D-2 근본원인.

## 3. 근본원인 — D-1 (별개·중대)
단가행 siz_cd = **출력판형**(SIZ_000499 316×467 등), 상품 작업사이즈(SIZ_000001~007)와 불일치. 작업사이즈 입력으로 직접 siz_cd 매칭 시 0행. 엔진이 작업사이즈→출력판형(임포지션/네스팅 런타임 계산, [[dbmap-compute-in-app-db-stores-lookup]])을 선행해야 단가행 조회 가능. **DB 매핑 결함 아니라 엔진 전처리 책임** — remediation 별도 항목.

## 4. 부수 노트
- SIZ_000077(와이드벽걸이캘린더 판형)이 PRF_DGP_A 공유 comp(디지털인쇄/코팅) 단가행에 혼입. 클래스가 공유 comp를 쓰므로 자연스러우나, 엽서 출력판형 집합이 SIZ_000499 외 무엇을 포함하는지는 D-1 변환표 정립 시 확정.
