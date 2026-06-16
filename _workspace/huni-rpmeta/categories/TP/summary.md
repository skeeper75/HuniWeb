# TP(디자인템플릿) 카테고리 — RP-Meta 파이프라인 요약

> 후니 RP-Meta 하네스. RedPrinting TP(디자인템플릿 — 디자인명함/티켓/캘린더/북/평면지류) 카테고리의 역공학→메타모델→갭→그릇 파이프라인 산출 인덱스.
> **★TP 본질 = 디자인 입력(에디터/템플릿) 축.** 같은 상품이 TP면 에디터+기성템플릿, 비-TP(HL)면 PDF업로드 — 자재/사이즈/후가공/가격은 동일, TP가 추가하는 단 하나 = "디자인 입력 레이어"(본체 옵션과 직교·가격 0).

## 산출물
- **역공학(reverse):** `reverse.md` — 대표 3상품(TPBCDFT 디자인명함·TPTKDFT 티켓·TPCLSTD 탁상캘린더) + 20상품 그룹 A~E 횡단 태깅. 에디터 채널 3종(KOI/Edicus/없음)·템플릿 자산·페이지 계층·티켓 variant. TPCLSTD vs HLCLSTD 비-TP 트윈 직접 대조. (Vue client-render 미노출분은 자매 TPCLWLB/TPCLECO `[reuse:productInfo]` 실측·SSR TPTKDFT 인라인 플래그로 확정·`unobserved` 정직 표기.)
- **메타모델(02_metamodel):** `discovered-axes.md`(D-11 TP 신축·TP facet T-A~T-E)·`metamodel-dictionary.md`(#16 디자인 입력 채널·#4 템플릿 이중의미 분리). BN+GS+TP 통합 **16축**(7 정적 + 4 관계/동역학 + 2 횡단 + GS 신축 2 + **TP 신축 1**). TP 발굴 6종 중 distinct 승격 = **#16 디자인 입력 채널 1종만**, 나머지 5종(템플릿자산·VDP·페이지계층·형태variant·특수인쇄)은 facet 흡수.
- **갭(03_gap):** `gap-matrix.md §VIII~X` — 후니 라이브 t_* 대조 **PASS 5·WEAK 8·GAP 4**(2026-06-17 read-only information_schema 정밀 실측). ★#16 디자인 입력 채널 = **GAP(vessel-gap 1순위·directive 핵심)** — `editor_yn`/`file_upload_yn` 불리언 2개뿐·item_gbn 3분기·에디터종류·리소스ID·VDP 그릇 전무·dbmap 미터치 신규.
- **그릇(04_vessel):** `vessel-design-input-channel.md`(V-10·#16 GAP→코드행+컬럼4·신규테이블 0)·`vessel-template-asset.md`(V-11·T-A WEAK→이중의미 분리 위해 본 하네스 유일 신규테이블 mint).
- **심층보강(deepcheck):** **✅ 완료** — codex-cli(gpt-5.5·CLI 0.140.0·데드락 해소) second-opinion 53후보 triage. `deepcheck.md` 참조.

## deepcheck 포인터 → `deepcheck.md`
- **상태: ✅ DEEPCHECK 완료** (codex 가용·ping PONG·BN 당시 CLI 버전 블로커 해소). codex `exec --sandbox read-only`로 TP 분석(16축+gap+vessel)을 컨텍스트로 주고 **53후보 발굴**(라이브 RedPrinting 인용 동반 — TPCAPTW/TPBLMEO/TPBLPST).
- **triage:** HIGH 9 · MED 19 · LOW 10 · 이미커버됨 12(23%·정직 폐기) · 환각의심 3. 순 신규 검증가치(HIGH+MED) = 28건.
- **HIGH 핵심:** H-1 승인/교정 워크플로 STATE 축(주문 라이프사이클·범위 판정 필요) · H-6 VDP 1급 데이터스키마 축(우리 T-B facet 재검) · H-8 포토카드 set-composition 그릇(20종/세트·라이브 즉시 checkable) · H-5 에디터채널 vs 템플릿자산 2축 분리(T-A 재검) · H-9 빠른출고 SLA 제약 축.
- **라우팅(검증 선행):** 신규축/판정재검 → metamodel-architect(Ph3, H-1·H-3·H-5·H-6·H-7) · 갭/그릇보강 → gap-analyst(Ph4, H-2·H-4·H-8·H-9·M-1~5·M-9·M-15·M-16) · 미샘플 상품 → reverse-engineer(Ph2, 상장 M-11·데코페이퍼 M-13·엽서북 M-14).
- **[HARD] 환각경계:** 전 후보 `unverified`. deepcheck는 채택 안 함(triage까지)·검증 후 살아남는 후보만 재진입. validator에 목록 전달 → M게이트 무단채택 0 확인.

## 시각화 (viz)

> **renderer: mermaid (codex deadlock)** — codex-image/`codex exec` 환경 데드락(버전-계정 불일치·OPENAI_API_KEY 미설정)으로 raster(PNG) 경로 차단. **mermaid 텍스트 도해로 폴백**(BN viz와 동일 방식·텍스트=분석 그대로·환각 0·GitHub/뷰어 렌더). raster 경로 복구 시 PNG로 재생성. 소스 = `viz/*.mmd`.

### 1. 옵션-구성 트리 — `viz/option-tree.mmd`
TPCLSTD 대표상품의 옵션 구성 트리. **★에디터 채널 = 옵션트리와 직교(⊥) 레인으로 분리 표현** + TPCLSTD(TP) vs HLCLSTD(비-TP) 직접 대조(TP가 추가하는 건 디자인 입력 레이어뿐·자재/사이즈/후가공/가격 동일). 가격 주체=PRT_DFT 인쇄[P], 에디터/템플릿=[P0]. 출처: `reverse.md §0·§3·§5`.

### 2. 16축 메타모델 맵 — `viz/axis-map.mmd`
TP가 16축 중 어느 축을 건드리나·기여하나. **★TP 기여 = #16 디자인 입력 채널 1축 distinct 신설**(보라·BN/GS 미발굴 본질축). TP facet 5종(T-A~T-E)은 기존 축 흡수(점선 → 흡수처). 출처: `02_metamodel/discovered-axes.md(D-11)`+`metamodel-dictionary.md(#16·#4 이중의미)`.

### 3. 갭 히트맵 — `viz/gap-heatmap.mmd`
TP 16축 축별 PASS/WEAK/GAP(🟢 5·🟡 8·🔴 4). **★TP 직접 산출 강조 = #16 디자인입력채널 GAP(1순위·vessel-gap·V-10) + T-A 템플릿자산 WEAK(이중의미 오염·V-11).** 나머지 BN/GS 판정 보존. 출처: `03_gap/gap-matrix.md §VIII~X`.

### 4. 상품 구조 BOM — `viz/bom.mmd`
TP 상품 구조 = 본체 인쇄물(동종 비-TP 공유: 용지·페이지계층·후가공) + **디자인 입력 레이어(에디터 채널 + 템플릿 자산 + VDP — 본체 BOM과 직교·가격 0)**. ★가격 주체 = PRT_DFT 인쇄(TPCLWLB 실측 PRICE=11900), 디자인 입력=가격 0. 출처: `reverse.md §0~3·§5` + `02_metamodel(#16 D-11)`.

> 4종 모두 분석 출처 섹션과 1:1 대응(노드/엣지/라벨/색 = 분석이 말한 것·없는 구조 발명 0). mermaid 전문은 각 `.mmd` 파일. mermaid 문법 유효(subgraph/end 균형·classDef↔class 참조 정합 검증 완료·BN viz 컨벤션 동일).
