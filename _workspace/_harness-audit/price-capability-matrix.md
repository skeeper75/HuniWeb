# 가격 클러스터 역량 매트릭스 (역량 × 하네스)

감사일: 2026-06-18 · 감사 범위: 가격 관련 4개 하네스(§7 dbmap 가격 서브셋·§13 huni-price-quote·§14 huni-price-engine-diag·§15 huni-quote-verify) · 읽기 전용 감사(정의 파일 근거).

근거: 각 에이전트 `.claude/agents/**/*.md` frontmatter description + 각 오케스트레이터/방법론 `SKILL.md` 본문. 추정 없음 — 정의 파일에서 추출.

---

## 1. 하네스별 구성원 인벤토리

| 하네스 | 에이전트 | 스킬(오케스트레이터 + 방법론) | 정체성 한 줄 |
|--------|---------|------------------------------|-------------|
| **§7 dbmap 가격 서브셋** | dbm-price-arbiter · dbm-price-engine-verifier · dbm-price-formula-auditor · dbm-price-import-builder · dbm-option-mapper | dbm-price-arbiter · dbm-price-engine-verify · dbm-price-formula · dbm-price-formula-audit · dbm-price-import-prep · dbm-cpq-option-mapping | 가격 데이터를 **분석·논의·적재**(매핑→재계산→정립→적재본) |
| **§13 huni-price-quote** | hpq-engine-cartographer · hpq-authority-curator · hpq-price-chain-inspector · hpq-option-constraint-mapper · hpq-quote-gate-validator | huni-price-quote-orchestrator + hpq-{engine-cartography·authority-curation·price-chain-inspection·option-constraint-mapping·quote-gate-validation} | **대표 상품군 파일럿**을 evaluate_price 권위로 **냉철 게이트 검증**(생성≠검증·P1~P7) |
| **§14 huni-price-engine-diag** | hped-mechanism-researcher · hped-code-schema-auditor · hped-binding-validity-designer | huni-price-engine-diag-orchestrator + hped-{mechanism-research·code-schema-audit·binding-validity-mapping} | **5장치 역할 원리 정의 + 코드↔DB 속성 정합 진단 + 아는것/모르는것 분리**(검증 선행 이해 레이어) |
| **§15 huni-quote-verify** | hqv-product-decomposer · hqv-quote-verifier · hqv-codex-cross-verifier | huni-quote-verify-orchestrator + hqv-{product-decompose·quote-verification·codex-cross-verify} | **단일 상품 온디맨드** 검증(Claude+Codex 병행 3축) + 개선 |

규모: 16 에이전트(5+5+3+3) · 19 스킬(6+6+4+3, 오케스트레이터 3 포함).

---

## 2. 역량 × 하네스 매트릭스

각 셀: 그 하네스가 그 역량을 **수행하는 주체(에이전트/스킬)** · 빈칸 = 미보유. ⚠️ = 같은 역량이 2곳 이상에 존재(중복 후보).

| # | 역량 (무엇을 하는가) | §7 dbmap | §13 hpq | §14 hped | §15 hqv |
|---|---------------------|----------|---------|----------|---------|
| C1 | **엔진 흐름·계약 지도**(pricing.py evaluate_price 계약·우선순위·차원매칭 도해) | — | hpq-engine-cartographer ⚠️ | hped-mechanism-researcher(역할 원리) ⚠️ | — |
| C2 | **권위 엑셀 골든값 추출**(상품마스터260610·가격표260527→정답 가격축·단가 골든) | (재사용·dbm-excel-parse) | hpq-authority-curator ⚠️ | — | hqv-product-decomposer(상품 단위 골든) ⚠️ |
| C3 | **가격사슬 완전성 실측**(공식→formula_components→price_components→component_prices 배선·단가행) | dbm-price-engine-verifier ⚠️ | hpq-price-chain-inspector ⚠️ | hped-code-schema-auditor(속성 정합) ⚠️ | hqv-quote-verifier(상품 단위) ⚠️ |
| C4 | **불필요분/오염 적발**(판별차원없음·동시매칭·고아·중복 단가행·미사용 공식) | (dbm-price-formula-auditor 정적정리) | hpq-price-chain-inspector ⚠️ | hped-binding-validity-designer(오배선·시트경계 위반) ⚠️ | hqv-quote-verifier(silent 합산 오배선) ⚠️ |
| C5 | **차원 매핑 정합**(use_dims ↔ 단가행 충전 차원 ↔ 권위 가격축 3원) | dbm-price-engine-verifier | hpq-price-chain-inspector ⚠️ | hped-code-schema-auditor ⚠️ | hqv-quote-verifier ⚠️ |
| C6 | **사이즈 중복 점검**(siz_cd 이산축 vs siz_width/height 구간축 혼동) | — | hpq-price-chain-inspector | — | — (요구 안 함) |
| C7 | **CPQ 옵션/템플릿/제약/공정json 정합**(option_items·templates·constraints·dim_vals) | dbm-option-mapper(설계) ⚠️ | hpq-option-constraint-mapper(검사) ⚠️ | — | — |
| C8 | **독립 재계산·골든 대조**(evaluate_price 실호출 or 재구현 → 엑셀 골든 수치 대조) | dbm-price-engine-verifier(**재구현**) ⚠️ | hpq-quote-gate-validator(**실호출**) ⚠️ | — | hqv-quote-verifier(**실호출**) ⚠️ |
| C9 | **냉철한 게이트 판정**(P1~P7 / R1~R6 / PE1~PE6 GO·NO-GO) | (dbm-validator PE1~PE6) | hpq-quote-gate-validator(P1~P7) | — | (reconcile·게이트 아님) |
| C10 | **5장치 역할 원리 정의**(공식·구성요소·할인테이블·뷰어·시뮬레이터가 무엇을 위한 장치인가) | — | — | hped-mechanism-researcher | — |
| C11 | **코드↔DB 속성 단위 진단**(dead/phantom 컬럼·설계산출물 3-way 추적) | — | — | hped-code-schema-auditor | — |
| C12 | **아는것 vs 모르는것 지식맵**(미지를 결론 위장 금지·확신도 표기) | — | — | hped-mechanism-researcher | (확신도 표기·골든 부재 컨펌) |
| C13 | **구성요소↔상품군 유효성 정합**(comp가 그 상품군에 유효한가·시트 차원경계 위반) | — | — | hped-binding-validity-designer | hqv-quote-verifier(축2 부분) ⚠️ |
| C14 | **경쟁사 가격 합리성 벤치마크**(와우프레스/레드 대조·터무니없는 차이) | dbm-competitor-benchmark¹ | — | — | — |
| C15 | **가격공식 정적 정리 검증**(frm_nm·note 가독성·실무진 정리표·뷰어 노출) | dbm-price-formula-auditor | — | — | — |
| C16 | **가격표 그릇 분해·webadmin import 엑셀**(다차원 매트릭스→t_prc_* 4테이블·복붙 .xlsx) | dbm-price-import-builder | — | — | — |
| C17 | **가격 매핑 설계(round-2 fit-gap)**(공식 유형 분류·다차원 평면화·적재 CSV) | dbm-price-formula | — | — | — |
| C18 | **돈-크리티컬 정립 심의**(결함 근본원인·트레이드오프·정립 방안·트랙 라우팅) | dbm-price-arbiter | (인간 승인 큐로 위임) | (검증 인계로 위임) | dbm-price-arbiter(재사용·Phase4) ⚠️ |
| C19 | **명령 해독**("상품군+상품명" 한 줄→work-spec 분해) | — | — | — | hqv-product-decomposer |
| C20 | **Codex 독립 2nd opinion**(gpt-5.5 교차검증·reconcile·환각 경계) | — | — | — | hqv-codex-cross-verifier |

¹ dbm-competitor-benchmark는 본 감사의 명시 대상(§7 가격 서브셋 5에이전트) 밖이지만 arbiter 입력 사슬에 등장하므로 참고 표기.

---

## 3. 역량 중복 핵심 (⚠️ 셀 집계)

같은 역량이 여러 하네스에 존재하는 핵심 5건. (상세 경계 판정은 `price-overlap-analysis.md`.)

| 중복 역량 | 보유 하네스 | 표면 중복도 | 실질 판정(요약) |
|----------|-----------|-----------|----------------|
| **D-1 가격사슬 실측(C3)** | §7 engine-verifier · §13 chain-inspector · §15 quote-verifier (+ §14 code-schema-auditor 속성렌즈) | **최고(4곳)** | 입력 범위 다름(전 상품군 재계산 / 대표 파일럿 결함보드 / 단일 상품 / 속성 정합). §7만 STALE 전제로 **진짜 중복+노후**. |
| **D-2 독립 재계산·골든 대조(C8)** | §7 engine-verifier(재구현) · §13 gate-validator(실호출) · §15 quote-verifier(실호출) | **최고(3곳)** | **방법이 갈림**: §7=엔진 부재 전제 "재구현", §13·§15=엔진 실재 확인 "실호출". §7 방법 자체가 STALE. |
| **D-3 차원 매핑 정합(C5)** | §7 · §13 · §14 · §15 | 높음(4곳) | 렌즈 다름(전수 / 대표결함 / 코드속성 / 단일상품). 상보적이나 §13↔§15 검사 항목 상당 겹침. |
| **D-4 엔진 계약/역할 정의(C1·C10)** | §13 cartographer(계약 도해) · §14 mechanism-researcher(역할 원리) | 중간(2곳) | 의도 분리(계약 추출 vs 원리 정의)이나 산출물(engine-contract vs device-roles) 내용 상당 중첩. §14가 §13 산출 인용. |
| **D-5 정립 심의(C18)** | §7 dbm-price-arbiter (§13·§15가 **동일 에이전트 재사용**) | 표면 3곳, 실제 1곳 | 중복 아님 — §13·§15가 §7 arbiter를 **공유 도구로 호출**(설계상 단일 SOT). 건전. |

추가: **C2 권위 골든값 추출**도 §13 authority-curator와 §15 product-decomposer가 둘 다 상품마스터260610·가격표260527에서 골든을 뽑음(범위만 다름: 상품군 vs 단일상품).

---

## 4. 역량 공백 (어느 하네스도 안 하거나 1곳뿐)

| 공백/단독 역량 | 현황 | 비고 |
|---------------|------|------|
| C6 사이즈 중복 점검 | §13 단독 | 단일 보유·중복 없음 |
| C10 5장치 역할 원리 / C11 코드 속성 진단 | §14 단독 | §14 고유 가치(다른 하네스가 의존하는 선행 정의) |
| C14 경쟁사 벤치마크 | dbm-competitor-benchmark 단독(서브셋 밖) | arbiter 입력 |
| C15·C16·C17 정적정리·그릇분해·매핑설계 | §7 단독(분석·적재 전용) | 검증 하네스(§13·15)에 없음 = 상보 |
| C19 명령 해독 / C20 Codex 교차 | §15 단독 | §15 고유 가치 |

---

## 5. 한 줄 요약

- **검증 3종(§13·§14·§15)**: 의도적으로 다른 **입력 단위·렌즈**(대표 파일럿 게이트 / 5장치 이해·진단 / 단일 상품 온디맨드)로 분화 — 대체로 **상보적 레이어**.
- **§7 가격 서브셋**: 분석·적재 도구 모음(C14~C18)으로 검증 하네스와 **상보**(검증의 입력·도구). **단 dbm-price-engine-verifier(C8 재구현 경로)는 §13·§15와 진짜 중복 + STALE 전제** — 핵심 정리 후보.
- 중복 핵심 5건 중 **D-1·D-2가 실질 중복**(가격사슬 실측 + 독립 재계산), 나머지(D-3·D-4·D-5)는 경계 명확화로 충분.
