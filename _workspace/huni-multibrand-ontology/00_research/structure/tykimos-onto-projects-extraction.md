# tykimos 온톨로지 프로젝트 추출 — 개선·보완·확장 (§35 구조 리서치 보강)

> 작성: 2026-07-04 · 원천 = GitHub `tykimos/ontoair`·`tykimos/onto-osint`(WebFetch README 수준).
> 목적: 두 프로젝트에서 후니 온톨로지에 도움될 부분 추출 → 개선/보완/확장 권고. **생성 단계**(검증 별도).
> [HARD] search-before-mint · 실 출처 앵커 · 경량 원칙 유지(임베딩/트리플스토어 기각 승계) · GAP 정직.

---

## 0. 두 프로젝트 성격 (한 줄)

| | 무엇 | 후니 관련성 |
|---|---|---|
| **OntoAir** | macOS 3D 온톨로지 **시각화 도구**(THREE.js·RDF/OWL/Turtle 파서·백엔드 없음·연구용 비오픈 라이선스) | 낮음 — 시각화 아이디어만(코드 재사용 불가·RDF/OWL 기질은 우리가 이미 기각) |
| **Onto-OSINT** | Claude Code CLI 기반 **온톨로지 OSINT 모니터링 시스템**(4에이전트 파이프라인·파일 핸드오프·경량 JSON·GitHub Actions 자동화) | **높음 — 우리 하네스와 형제 아키텍처.** 외부 검증 + 차용 메커니즘 다수 |

**핵심 발견**: Onto-OSINT는 후니와 **같은 계열**(Claude·파일 기반·에이전트 파이프라인·GAP 정직·Neo4j/임베딩 **의도적 배제**)이다. tykimos도 경량 JSON을 택했다 → 후니의 "임베딩/트리플스토어/OWL 기각(과공학)" 결정을 **독립 제3자가 같은 도메인 판단으로 재확인**. OntoAir(RDF/OWL 기질)는 시각화 전용이지 KB 엔진이 아님 → 우리가 RDF를 안 쓰는 판단과 상충 없음.

---

## A. 개선 (기존을 더 정밀·표준정합하게)

### 개선-T1 — 엣지에 신뢰도 점수(confidence 0.0~1.0) 병기 [badge 보완]
- **Onto-OSINT 방식**: 모든 트리플 (주어,관계,목적어)에 confidence 0.0~1.0. 추론 신뢰도 = 입력1 × 입력2 (× 체인 감쇠 0.5). 전이·이벤트체인·공동참여 추론 결과의 불확실성을 수치로 랭킹.
- **후니 적용**: 현재 badge(verified/candidate/gap) 3값 → **불확실 엣지(특히 교차관계 `same_family_as` partial 8쌍·라우팅 `can_produce` 후보·미래 추론 엣지)에 confidence 수치 보강**. "strong 8 / partial 8" 정성 구분을 0.9/0.6 같은 수치로 정밀화 → 추천 순위·"왜 이 후보" 설명 품질↑.
- **경계 유지**: 가격/배정 **값**은 여전히 엔진(D-18/D-ROUTE). confidence는 "이 연결이 얼마나 확실한가"지 가격 값이 아님.
- **리스크**: 낮음. badge와 병존(badge=성격·confidence=강도). 초기엔 교차관계·라우팅 후보에만.

### 개선-T2 — 추론 로그(reasoning-log)로 파생 노드 출처 강화
- **Onto-OSINT 방식**: `instances.json`(누적 인벤토리) + `sources/YYYY-MM-DD/items/src-XXX.json`(개별 출처) + `reasoning-log.md`(모든 추론에 출처 인용+confidence).
- **후니 적용**: 우리 출처5필드(source_file·locator·captured_at·badge·src_id)는 **1차 사실**엔 완비. 하지만 **파생 노드**(구조 리서치의 community 요약 노드·same_family_as 교차엣지·capability_covers 추론)는 "무엇으로부터 도출됐나"의 추론 이력이 산재 → **`reasoning-log.md` 패턴 채택**(파생 = derived_from 멤버 목록 + 도출 규칙 명시). H-1 드리프트·staleness 추적에도 유용.
- **리스크**: 낮음(문서 규약).

---

## B. 보완 (빠진 것 채움) — 가장 가치 큰 추출

### 보완-T1 — 가설 주도 승격 규칙: "N+ 근거 인스턴스" 임계값 [키스톤 게이트]
- **Onto-OSINT 방식**: **hypothesis-driven ontology extension** — 새 클래스/관계는 **3+ 코로보레이션(뒷받침 인스턴스)** 확보 후에만 추가. "시간이 지나면 새 클래스/관계 추가가 줄어든다"(안정화).
- **★후니 최대 적용**: 구조 리서치의 **키스톤=intent 원자 분해**에 정확히 빠져 있던 **승격 임계값**을 제공. 현재 우리는 "badge=candidate·실 질의로 검증"이라 했으나 **"언제 candidate→verified로 승격하나"의 구체 기준이 없었다**. → **"용도 원자·라우팅 능력·교차엣지 등 신규 노드는 근거 인스턴스 N개(예 3개) 이상일 때만 승격, 미만은 candidate 유지"** 규칙 채택. search-before-mint의 정량 게이트가 됨.
- **과분해 방지와 결합**: 구조 리서치 "수정-3(원자 과분해 금지·용도당 2~4개)"과 상보 — N+ 임계값이 자동으로 근거 약한 원자를 걸러냄.
- **리스크**: 중. 임계값(3?)은 후니 규모(283상품)에 맞게 조정. 파일럿서 실측. **generate≠verify 유지**: 승격 제안=생성, 임계 판정·채택=검증 게이트+인간.

### 보완-T2 — 시간 태깅(new/reported/update)으로 노후·드리프트 탐지
- **Onto-OSINT 방식**: Extractor가 7일 이력 대조 → 각 사실을 `new`·`reported`·`update`로 태깅. 신규 vs 중복 vs 갱신 구분.
- **후니 적용**: 두 실증 문제에 직결 —
  ① **와우 catalog 노후(2025-10-14)**: 카탈로그 사실에 captured_at 기반 **stale-suspect 태깅** → 재수집(devshop) 시 new/update 판정.
  ② **H-1 드리프트(병행 세션 적재 2회 실증)**: 게이트 단계 재-SELECT를 `update` 태깅으로 형식화 → 드리프트 = "이전 verified가 update로 바뀜" 신호.
- **리스크**: 낮음(captured_at 이미 있음·비교 규약만 추가).

---

## C. 확장 (새 능력 추가)

### 확장-T1 — Reasoner 단계 + 소규모 추론 규칙 집합 [신규 능력]
- **Onto-OSINT 방식**: 4에이전트 중 **Reasoner**가 추론 규칙 적용 — 전이(A→B,B→C ⟹ A→C)·이벤트체인(감쇠)·공동참여(잠재 관계). 우리 하네스는 생성·검증은 있으나 **명시적 추론 단계가 없다**.
- **후니 적용**(경량·소수 규칙):
  - **전이 추론**: `same_family_as` 전이 — 레드 추가 시 huni-A ~ wow-B, wow-B ~ red-C ⟹ **huni-A ~ red-C 자동 후보**(confidence 감쇠). 교차엣지 수동 배선 부담↓.
  - **포섭 추론**: 라우팅 `capability_covers` + 사양 ⊆ 능력 ⟹ `can_produce`(이미 설계에 포섭 매칭 있음 → 규칙으로 명문화).
  - **집계 추론**: community 요약 노드(구조 리서치 확장-1)를 family 멤버로부터 결정론 도출(GraphRAG global).
- **경계**: 추론 = 후보·엣지 생성까지. 값·최종 선택 = 엔진(D-18/D-ROUTE). 추론 결과 = badge=candidate + confidence + reasoning-log.
- **리스크**: 중. 규칙 폭발 금지(소수 규칙만). 전이 추론은 confidence 감쇠로 노이즈 억제.

### 확장-T2 — Collector 자동화(스케줄) → 자기개선 KB 루프 구체화
- **Onto-OSINT 방식**: Collector(스케줄 웹검색·엔티티로 질의 확장) + GitHub Actions cron → **자동 재수집·재추론·리포트**. 구조 리서치의 "self-refine 루프 명문화(확장-3)"를 실동 구현으로 보여줌.
- **후니 적용**: **와우 catalog 자동 재수집**(devshop 읽기전용 gstack·주기적) → 노후 갱신 + drift 탐지(보완-T2) + Reasoner 재추론. 단 **자기 산출 자기 승인 금지 유지**: 자동 수집·추론 제안 = 생성, 채택 = 검증 게이트 + 인간. 적재는 여전히 인간 승인.
- **리스크**: 중. 라이브 읽기전용 경계·rate 유의. 초기엔 수동, 안정화 후 스케줄.

### 확장-T3 — Fork-and-Configure(설정 파일 1개로 도메인/브랜드 확장)
- **Onto-OSINT 방식**: `config/osint-config.json` 하나로 주제 변경(기후테크→북한 핵). "설정만 고치면 어떤 주제든".
- **후니 적용**: **brand를 config로**(huni/wowpress/red) → 레드 추가 = 코드 무변경·config append + instance_of(이미 architecture-neutral 설계와 정합). 미래 **라우팅 공급자 레지스트리도 config**로 → 형(型) 재사용. 아키텍처 "독립 후 통합" 결정과 상보(config 경계가 브랜드 격리).
- **리스크**: 낮음(설계 원칙·이미 브랜드축 있음).

---

## D. 수정 / 안 가져올 것 (경계)

- **OntoAir RDF/OWL + THREE.js 3D**: 기질(RDF/OWL) 채택 금지 — 후니는 이미 SQLite 3층·결정론 트리로 기각(과공학·D-2 승계). OntoAir는 **시각화 도구지 KB 엔진 아님**. 가치 = 미래 시각화 만들 때 아이디어(Class/Individual 렌더 구분·소스↔그래프 양방향 하이라이트)뿐. 라이선스도 연구용 비오픈(코드 재사용 불가).
- **Onto-OSINT 트리플 JSON 기질**: (주어,관계,목적어) 순수 트리플로 **대체 금지** — 후니 SQLite 3층이 가격/차원/제약에 더 풍부. **메커니즘만 차용**(confidence·시간태깅·승격 임계·추론규칙·config), 기질은 유지.
- **경량 원칙 재확인**: 둘 다(특히 Onto-OSINT) Neo4j·임베딩·벡터스토어 **안 씀** → 후니 경량 판단 외부 검증. 이 추출로도 무거운 기질 도입 유혹 차단.

---

## 우선순위 (가장 가치 큰 추출 3)

1. **보완-T1 (N+ 근거 승격 임계값)** — 키스톤(intent 원자 분해)에 빠져 있던 정량 승격 게이트. search-before-mint를 정량화. 즉시 적용 가치 최고.
2. **개선-T1 + 확장-T1 (confidence + 전이 추론)** — 교차관계·라우팅 후보의 불확실성 수치화 + 레드 확장 시 교차엣지 자동 도출. 추천 순위·설명 품질 직결.
3. **보완-T2 + 확장-T2 (시간태깅 + 자동 재수집)** — 와우 노후·H-1 드리프트 실증 문제 직접 대응. self-refine 루프 구체화.

## GAP
- **G-TYK-1**: 추출은 **README 수준**(WebFetch). 정밀 구현(승격 임계 정확값·confidence 공식 상수·Reasoner 규칙 전체)은 소스 파일(`ontology/`·에이전트 프롬프트) 직독 필요 → 채택 전 확인. 현재 권고는 "메커니즘 차용"까지.
- **G-TYK-2**: OntoAir 시각화 아이디어는 후니 시각화 트랙(미정) 있을 때만. 현재 범위 밖.
- **G-TYK-3**: 이 권고들의 실효는 그래프 빌드·질의 엔진 구현 후 실측(설계 권고까지·DB 미적재). 채택은 아키텍처 게이트+인간 승인.

## Sources
- [tykimos/ontoair](https://github.com/tykimos/ontoair) — 3D 온톨로지 시각화(macOS·THREE.js·RDF/OWL/Turtle·연구용 비오픈)
- [tykimos/onto-osint](https://github.com/tykimos/onto-osint) — 온톨로지 OSINT 모니터링(Claude Code CLI·4에이전트 Collector/Extractor/Reasoner/Reporter·파일 핸드오프·JSON 트리플+confidence·가설주도 확장·GitHub Actions)
- 후니 승계: 본 하네스 `structure-recommendations.md`(개선/보완/확장/수정 4구분)·`routing-layer-schema.md`(capability_covers 포섭)·§35 `crossbrand-relations.md`(same_family_as strong/partial)·§33 [[huni-ontology-kb-harness]](badge·H-1 드리프트·경량 원칙)
