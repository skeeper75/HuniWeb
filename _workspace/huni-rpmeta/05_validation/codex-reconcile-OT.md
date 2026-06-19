# codex Reconcile — OT (상자·패키징) · 12번째 카테고리

> RP-Meta Phase 6.5 · codex(gpt-5.5) 독립 판정 ↔ rpm-validator mgate-verdict 대조 · 2026-06-20
> 베이스라인 = `05_validation/mgate-verdict-OT.md`(M1~M6 GO·전개도/dieline #18 부결·distinct 0). validator 판정은 codex에 **비노출**(독립성 HARD) — 본 대조는 사후 reconcile.
> ★codex 주장 = `unverified` 가설. 라이브 우선·codex 인용 신뢰 금지·자동 flip 금지.

## codex 가용성 노트
- **AVAILABLE · model=gpt-5.5** (foreground `codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check` · exit 0 · output `_tmp/ot-codex/verdict.md`).
- 레인 작동 = 정상. "codex 미가용·Claude 단독" 폴백 **불발동**.

## reconcile 매트릭스

| 항목 | rpm-validator (베이스라인) | codex (독립·unverified) | 합의/불일치 | 신뢰도 |
|---|---|---|---|---|
| **distinct #18 전개도/dieline** | 부결 (전용슬롯+KB결함 둘 다 불충족) | **ABSORBED** (전용슬롯 관측 없음·KB defect 없음) | **합의** | **고신뢰** |
| 3D 입체치수 W×D×H 귀속 | 사이즈#13 파생(미저장·height 컬럼 부재) | 사이즈#13 표시/파생 속성 | **합의** | 고신뢰 |
| 전개도/work·cut 치수 귀속 | 사이즈#13 work/cut/margin 단일행(8컬럼 라이브 실재) | 사이즈#13 (work/cut/margin 한 row) | **합의** | 고신뢰 |
| 도무송 칼선·오시 접지 귀속 | 공정#2 PROC family(라이브 실재) | 공정#2 facet | **합의** | 고신뢰 |
| glue tab(접착탭) 귀속 | (명시 안 됨·#14 음의사례 맥락) | 공정#2 또는 TemplateAsset 표현요소·#14 아님 | **정합**(미세 보강) | 중(라이브 미관측) |
| 박스형태(케이크/납작/반달/봉투) 귀속 | 사이즈#13 프리셋 + 카테고리#7 | 카테고리#7 product-code split + 보조 사이즈#13 라벨 | **합의** | 고신뢰 |
| dieline 에디터 템플릿 귀속 | #16 TemplateAsset(V-11 subtype 1차 불요) | #16 TemplateAsset(editor seed·가격0) | **합의** | 고신뢰 |
| flat→3D 조립 = #14 음의사례 | #14 형태가공의 반대(고객 조립·RP 입체화 안 함) | #14 아님(positive form-processing 아님) | **합의** | 고신뢰 |
| 신규 vessel | 0건(V-11/V-12 불변) | structural-net 신설 = 오버핏 경고(=신설 반대) | **합의** | 고신뢰 |
| makers 응답 fabrication 경계 | 응답 표면=generic 포인터·gcs 내부 미해석 정직 표기(L-OT-2) | 동일 경고("gcs 미해석이라 '존재안함'까지 말하면 fabrication") | **합의** | 고신뢰 |

## 종합

- **★전 항목 합의 = 고신뢰 confirm.** codex가 validator 판정(distinct #18 부결·흡수 매핑)을 독립 도달로 재확인 — **12번째 외부 재포화**(distinct 0·17축 안정). 두 모델이 같은 증거에서 같은 부결.
- **불일치 0건.** codex가 NEW-AXIS를 1건도 주장하지 않음 → 조사 트리거 없음·라이브 재실측 불요·라우팅 불요.
- **codex 추가 가치(검증된 게 아닌 정합 보강):**
  - glue tab을 "공정#2 또는 TemplateAsset 표현요소"로 명시 — validator가 비명시한 미세 항목을 흡수처로 확정(라이브 미관측이라 중신뢰·기존 결론 강화 방향).
  - makers fabrication 경계를 validator의 L-OT-2와 **독립 일치** — "gcs 내부 미해석 상태에서 dieline geometry 부재 단정 금지"를 양측이 동일 지적. validator 정직 표기 타당성 외부 보강.
- **divergence 해소:** 해소할 divergence 없음(전 항목 합의). validator의 mgate-verdict 그대로 standing.

## owner / 후속
- divergence 없음 → owning agent 라우팅 **불요**.
- codex가 보강한 glue tab 흡수처(공정#2 vs TemplateAsset)는 라이브 미관측분이라 `unverified` 잔존 — DC-1 makers gcs 1-hop 실측이 닫는 deepcheck 큐와 동일 지점(신규 작업 아님·기존 §13/DC-1 라우팅에 포함).
- 최종: **M1~M6 GO + distinct 0 부결 = codex 독립 합의로 고신뢰 confirm.** verdict 변동 없음.
