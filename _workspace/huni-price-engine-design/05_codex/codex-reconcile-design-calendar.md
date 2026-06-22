# codex ↔ 설계 reconcile — 디자인캘린더(가격포함) (Phase 5.5·11번째·최종 종단)

> **codex 가용성 노트**: AVAILABLE · model=**gpt-5.5** · read-only · effort=**high** · exit 0 · 2026-06-22. (미가용 폴백 아님 — codex 독립 2nd opinion 정상 확보.)
> 본 reconcile은 **codex 독립 판정 ↔ designer 설계**를 대조한다. ★이 에이전트(codex-validator)는 hpe-validator(Claude)의 E1~E7 gate-verdict를 **읽지 않았다**(독립성 [HARD]). 따라서 아래는 codex 결론·확신도·divergence 후보를 명확히 산출하되, Claude 판정과의 최종 합의/불일치 종합은 **메인(오케스트레이터)이 별도 보유한 gate-verdict로 수행**한다.
> codex 주장 = 가설(`미검증`). 라이브/권위 검증 전 자동 채택·자동 flip 금지. 충돌 시 라이브 우선.

---

## 0. 한 줄 요약

codex(gpt-5.5·독립)는 디자인캘린더 설계의 **핵심 구조 4건을 독립 산술로 지지**(① inline=정찰가 스냅샷 BLOCKED ② G-PRODPRICE 가드 ③ 봉투 외부화 ④ 세트 불요)하되, **돈크리티컬 divergence 1건(GC-DCAL-9 qty=10 = 44,000 vs codex 80,000)** 과 **codex 신규 발굴 RISK 2건(엽서 editor_yn=N 라우팅 / COMP_DCAL_FIXED siz_cd-only 미래충돌)** 을 표면화했다. 핵심 directive(정찰가 BLOCKED) = **codex 독립 지지(고신뢰)**.

---

## 1. 합의 매트릭스 (codex ↔ 설계 — 고신뢰 후보)

| # | 사안 | 설계 명세 | codex 독립 판정 | 합의? | 신뢰 |
|---|------|-----------|-----------------|-------|------|
| A1 | **inline 정찰가 = 산식 재현 불가 → 정찰가 스냅샷 BLOCKED** (핵심 directive) | inline 7건 유효판수 전부 비정수(1.313/0.486/1.285/1.574/6.104)·추측 단가 INSERT 금지 | **FLAW(산식)→스냅샷 SOUND**·codex가 node로 독립 재산출(1.313044/0.486313/1.285108/1.574257/6.104261)·앞4+와이드 동형 일치·"추측 단가 INSERT는 FLAW" | ✅ **완전 합의** | **고신뢰** |
| A2 | **고정가 그릇 = .01 단가형 + min_qty=1 + siz_cd**(.03 부재) | qty 무관 단일 정찰가를 .01 min_qty=1로 표현 | ".03 없으므로 .01+min_qty=1+siz_cd는 수량구간 없는 1부 단가 그릇으로 타당" (단 ★qty 의미 단서·아래 D1) | 🟡 **부분 합의**(그릇 SOUND·qty 의미 분기) | 중(D1 해소 전) |
| A3 | **G-PRODPRICE 가드**(본체 product_prices INSERT 금지·formula 유지) | product_prices INSERT 시 PRODUCT_PRICE 선점→FORMULA(add-on) 우회 silent | "PRODUCT_PRICE가 FORMULA 선점→우드 silent 우회(qty1=4000만/qty10=40000만)·**가드 SOUND**" | ✅ **완전 합의** | **고신뢰** |
| A4 | **siz_cd 판별차원 필수**(NULL 와일드카드 금지·동시매칭 회피) | 상품별 전용 PRF + COMP_DCAL_FIXED use_dims=[siz_cd] | "siz_cd 필수·220/130 뭉개면 ERR_AMBIGUOUS 또는 700원 오청구" | ✅ **완전 합의** | **고신뢰** |
| A5 | **봉투 외부화**(독립 PRD_000005·봉투트랙·본체 미합산) | 캘린더봉투=독립판매+addon 이중역할·봉투제작 트랙 위임·평탄화 가드 | "독립 PRD_000005 실재→본체 합산 안 함 SOUND·2500/2400 평탄화 시 100원 오청구·부모행 미명시=데이터 부족" | ✅ **완전 합의** | **고신뢰** |
| A6 | **세트 불요**(정찰가 완제품·페이지=baked) | t_prd_product_sets 0행·페이지 내지 부품 오적용 금지 | "세트 분해 부적절·페이지 N장 곱 시 즉시 과청구(탁상 128,377원 등)·정찰가 완제품+add-on 구조가 맞음" | ✅ **완전 합의** | **고신뢰** |
| A7 | **미니 두 사이즈 동일가(6500=6500)=정상** | G-DCAL-MINI-FLAT 결함 아님 | "권위값 verbatim이면 정상·결함 아님 SOUND" | ✅ **완전 합의** | **고신뢰** |
| A8 | **삼각대/트윈링 baked → 별 가공 comp 재가산 금지** | 정찰가에 baked·이중계상 가드 | "baked 정찰가에 별도 가공 comp 재가산하면 이중계상 FLAW" | ✅ **완전 합의** | **고신뢰** |
| A9 | **주문방법 분기 필요**(동일 prd_cd 이중 바인딩 비결정) | 편집기→DCAL·업로드→CAL 판별차원 분기·Q-DCAL-ROUTE 컨펌 | "주문방법 분기 없으면 비결정/오선택/중복 실재 위험"(어느 값 나오는지는 데이터 부족 정직) | ✅ **합의(위험 인식)**·구현 미해결 공유 | 중(미배선) |

★ **핵심 directive 답 = 완전 합의**: "inline을 FORMULA 공식화할지 정찰가 BLOCKED 유지할지" → codex가 **독립 산술로 정찰가 스냅샷 BLOCKED를 지지**(포토북은 공식화 가능과 대비). 우리 설계 결판과 동일 방향. 포토북(divergence 0)에 이은 11번째 종단도 핵심축 합의.

---

## 2. 불일치(divergence) 매트릭스 — 조사 신호

| # | 사안 | 설계 명세 | codex 독립 판정 | divergence 성격 | 소유자·해소 경로 |
|---|------|-----------|-----------------|-----------------|-------------------|
| **D1** ★최대·돈크리티컬 | **GC-DCAL-9: 엽서+우드거치대 qty=10 = 44,000** (본체 4,000 1회 + 우드 4,000×10) — 본체 정찰가를 qty 무관 단일가로 간주 | **불일치 = 80,000**: ".01 단가형은 unit_price×qty이므로 **본체도 ×10=40,000** + 우드 40,000 = 80,000. 44,000은 본체 4,000 **1회**일 때만 나오는데 .01 모델은 본체도 qty 곱함 → **설계상 미해결 RISK/FLAW**(컨펌 사안 아님)" | **진짜 충돌(엔진계약 해석)** — `.01 단가형 min_qty=1`이 본체를 qty-불변으로 만드는가 vs unit_price×qty인가. 골든값(돈) 직결. | **validator/engine-contract 재측정** — pricing.py `_component_subtotal`로 `.01 단가형 min_qty=1` comp에 qty=10 줄 때 실제 산출(4000 vs 40000) 라이브 재현. 라이브 우선·codex에 자동 flip 금지. **설계의 "qty 무관 정찰가" 표현이 엔진계약과 정합하는지 designer 재확인 필요.** |
| **D2** (codex 신규 발굴) | **엽서캘린더 PRD_000110 editor_yn=N** — 설계는 편집기 주문(editor_yn=Y)을 PRF_DCAL_* 라우팅 자연 키로 명시 | "PRD_000110은 editor_yn=N. 주문방법 분기를 editor 여부에 의존하면 **엽서 디자인캘린더가 누락**될 수 있다(RISK)" | **설계 내부 모순 후보** — 설계 §0이 110(엽서)=editor_yn=N을 실측했으면서 §2.4/§3.1 라우팅을 editor_yn 자연 키로 둠. 엽서는 editor_yn=N인데 디자인캘린더(편집기형)에 속함. | **designer 재확인** — editor_yn 라우팅이 엽서(110·N)를 어떻게 PRF_DCAL_POSTCARD로 보내는가. Q-DCAL-ROUTE에 엽서 예외 명시 필요. 라이브 editor_yn=N 사실은 우리 설계 §0에도 기록(codex 발굴이 우리 실측과 정합·라우팅 키 결함을 새로 지적). |
| **D3** (codex 신규 발굴) | **COMP_DCAL_FIXED siz_cd-only 단일 comp** — 7 정찰가를 siz_cd 7행으로 한 comp군에 적재 | "siz_cd만 차원이면 현재 7행은 재현되나 **향후 다른 상품이 같은 siz_cd에 다른 정찰가를 가지면 충돌**. prd_cd 또는 상품별 comp 분리가 더 견고(RISK)" | **확장성 RISK(현재 무해)** — 설계는 이미 상품별 전용 PRF 5개로 분리해 동시매칭을 막음(현 7 siz_cd 중복 없음). codex 우려는 미래 siz_cd 재사용 시나리오. | **검토(현 무해)** — 설계의 "상품별 전용 PRF"가 codex 우려를 부분 완화(각 PRF가 자기 상품 siz_cd만 매칭). 단 한 comp(COMP_DCAL_FIXED)에 전 siz_cd를 담으면 PRF가 다른 상품 siz_cd 행도 후보로 볼 수 있어 ERR_AMBIGUOUS 위험 → **comp 분리 또는 PRF별 단가행 scoping 점검 권고.** designer/validator. |

---

## 3. codex 단독 주장 (미검증 가설·채택 보류)

| 주장 | 분류 | 처리 |
|------|------|------|
| GC-DCAL-9 = 80,000(본체 ×qty) | **미검증 가설(강력)** — codex가 명시한 엔진계약(`.01=unit_price×qty`)에 부합·우리 프롬프트가 준 계약과 자기정합 | D1로 라우팅. 라이브 `_component_subtotal` 재측정으로 판별(채택 보류). |
| editor_yn=N(엽서) 라우팅 누락 | **미검증 가설** — 라이브 editor_yn=N은 우리 설계 §0 실측과 정합·라우팅 결함 지적은 신규 | D2로 라우팅. designer Q-DCAL-ROUTE 보강. |
| siz_cd-only 미래 충돌 | **미검증 가설(확장성)** | D3로 라우팅. 현 무해·comp scoping 점검. |

★ codex가 **틀리게 짚은 것 없음**(가짜 합의·환각 결론 없음). 봉투 부모행 미명시·이중바인딩 산출값은 "데이터 부족"으로 정직 회피.

---

## 4. ★메인(오케스트레이터)에게 — codex 결론·divergence 후보 종합

> 이 에이전트는 Claude E-verdict 미열람. 아래는 **codex 결론 + divergence 후보**만(Claude와의 최종 합의/불일치는 메인이 gate-verdict로 종합).

**codex 핵심 결론:**
1. **inline BLOCKED 지지 여부 = ✅ 지지(고신뢰)** — codex 독립 node 산술로 유효판수 전부 비정수 재현(1.313/0.486/1.285/1.574/6.104), 페이지수 정수배수 무관, 포토북과 대비해 "정찰가 스냅샷"·"추측 단가 INSERT는 FLAW" 독립 결론. 핵심 directive 답이 양 모델 합의.
2. **고정가 매핑(.01 min_qty=1 siz_cd) = 조건부 지지** — 그릇 자체는 SOUND, 단 qty 의미가 D1에 걸림.
3. **G-PRODPRICE 가드 = ✅ SOUND 지지**(본체 product_prices INSERT 시 add-on silent 우회·qty10=40000만 출력 입증).
4. **봉투 외부화·세트 불요·삼각대 이중계상 가드 = ✅ 전건 지지.**

**divergence(메인 조사 필요):**
- **D1[돈크리티컬·최우선]**: GC-DCAL-9 qty=10 골든값 — 설계 44,000 vs codex 80,000. `.01 단가형 min_qty=1` 본체가 ×qty인지(codex) qty-불변 정찰가인지(설계). 라이브 evaluate_price 재측정으로 판별. **이 한 건이 디자인캘린더 골든 정합의 유일한 실질 충돌**(GC-DCAL-1~8은 합의·재현가능).
- **D2**: 엽서(110) editor_yn=N인데 편집기 라우팅 키로 PRF_DCAL_* 분기 — 라우팅 키 누락 위험(설계 §0 실측과 정합한 신규 결함 지적).
- **D3**: COMP_DCAL_FIXED siz_cd-only 단일 comp 미래 충돌(현 무해·확장성).

**verdict 함의**: D1·D2가 해소되기 전까지 디자인캘린더 codex 종단은 **CONDITIONAL**(핵심축 합의=고신뢰이나 qty 골든·라우팅 키는 divergence). 10종단(포토북 등 divergence 0) 대비 **divergence 1 돈크리티컬 + 2 RISK 발생** — 정찰가 채택 적재 자체가 인간 컨펌 대기(Q-DCAL-AUTHORITY)인 점과 결합해, 메인은 D1을 라이브 재측정으로 우선 종결 권고.

---

## 5. ★메인(오케스트레이터) 최종 종합 — divergence 조사·해소 (2026-06-22·11번째 최종 종단)

codex가 제기한 D1·D2를 메인이 엔진계약·라이브로 조사한 결과 **둘 다 codex가 정당**(설계 오류)했고, designer 폐루프 보정 + validator 2차 재게이트로 해소했다.

- **D1 (돈크리티컬·저청구) = codex 채택**: 엔진계약 `huni-price-quote/01_engine/price-flow-map.md:106`("④ 단가형×qty / 합가형÷min_qty×qty")·validator 엔진 코드 직접 Read(`pricing.py:180-192` 단가형=`up*q`)로 **`.01 단가형`은 항상 unit_price × qty** 확정. 설계의 "본체 정찰가 qty 무관"은 계약 위반(탁상 10부 10,400 고정=104,000 정답 대비 93,600 저청구). 캘린더 정찰가=1부 단가이므로 ×qty가 도메인상으로도 정답. **교정: 본체 = 1부 정찰가 × qty·GC-DCAL-9 44,000 → 80,000(본체 40,000+우드 40,000)·신규 가드 G-DCAL-QTY**(qty-불변 모델링 금지). GC-DCAL-1~7은 qty=1 케이스라 값 불변(10,400 등).
- **D2 (라우팅 키) = codex 채택**: 엽서 PRD_000110 `editor_yn=N`(validator 라이브 SELECT 재확인)인데 라우팅 자연키를 editor_yn=Y로 둬 엽서 정찰가 라우팅 누락. **교정: 라우팅 신호=가격포함 시트 등재 + 상품별 PRF_DCAL_* 명시 바인딩(엽서 포함 5상품)·editor_yn 보조**·Q-DCAL-ROUTE에 엽서 항목 추가.
- **D3 (확장성·현 무해) = 기록**: COMP_DCAL_FIXED siz_cd-only 단일 comp 미래 충돌 → design-decisions D-DCAL-7 1줄 기록(현 설계 변경 불요·상품별 PRF_DCAL_* 5개로 부분 완화).

**불변(라이브 재실측 확인)**: inline BLOCKED(비정수 1.313/0.486/1.285/1.574/6.104)·G-DCAL-DUAL 결판(product_prices 0·바인딩 0·PRF 0)·G-PRODPRICE 가드·정찰가 verbatim(qty=1: 10400/9700/6500/6500/4000/9900/24000)·신규 mint(공식5+comp1·search-before-mint 11연속).

**★종단 함의 = GO (divergence 해소 후 합의)**: 앞 10종단(divergence 0)과 달리 codex가 **돈크리티컬 2건(저청구·라우팅 누락)을 독립 적발**해 설계를 강화 — validator 1차가 설계 자체 골든(44,000)을 재유도만 하고 qty 의미를 도전하지 않은 **생성≠검증 간극을 codex가 메운** 사례. 교정 후 validator 2차 재게이트 E1~E7 전건 PASS·codex 적발 정당 → **종합 GO**. 실 적재는 인간 승인 후 dbmap 위임(Q-DCAL-AUTHORITY/ROUTE/DSC/FIN).
