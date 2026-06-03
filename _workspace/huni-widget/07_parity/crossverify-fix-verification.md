# crossverify-fix-verification.md — 팀 교차검증 4결함 수정 독립 재검증

> 검증자: hw-qa. 일시: 2026-06-03. 입력: crossverify-findings.md(처리결과 섹션), parity-gap-map.md(PRICE=0 정정), memory "Red NEVER returns PRICE=0".
> **원칙: 빌더 자가보고 미신뢰.** 증거는 내가 직접 수집(Red 소스 정독 + diff·fixture 추출 + 독립 vite-node walk-back/re-derive/per-product probe + 게이트 재현).
> **팀이 드러낸 사각**: 순차검증은 "단일 트리거 1-step + 현 fixture"만 봤다 → 본 검증은 **walk-back / re-derive / 상품별 경로**를 직접 probe.

---

## 0. 한 줄 결론

**4결함(C-B/G-1/G-2/PRICE=0) 전부 RESOLVED**(독립 증거). tsc 0 / vitest **148/148** / build OK 내 눈으로 확인. **C-B 대칭 self-heal이 새 과잉선택 부채를 만들지 않음**(fully-disabled SKIP 유지 + 비-자재 cascade가 store 로드-디폴트와 동형이라 신규 행위 아님 + 사용자 non-first 선택 미clobber — 3방향 probe). **G-1 ACPDSTD SUB_MTR 미제거 확인**(ATTB='3'). INV-3 최소(contract +1 priceUnavailableReason, cascade ±2줄). → **GO. 신규 부채 0. 이연(L-3/잠복/G-3) 명시 추적.**

---

## 1. 결함별 독립 판정

### C-B 자재 왕복 self-heal (대칭) — **RESOLVED, 신규 과잉선택 0** (최정밀)

cascade.ts 변경 = `applyVisibilityAndEssential` skip 조건에서 `g.visible` 제거(1곳, ±2줄). 3방향 probe:

| probe(내가 직접) | 결과 |
|------------------|------|
| **(a) walk-back 복구** | RXOMO080(COT disable→coating cleared) → RXART300(re-enable) 왕복 → **coating REFILLED=TCMA**(이전 C-B 버그: 영구 empty). 해소 |
| **(b) fully-disabled SKIP(CRITICAL no-regression)** | 합성 product에서 자재가 PCS_F 전체 disable → `g.values.find(v=>!v.disabled)`=undefined → `if(first)` 가드로 **selection undefined 유지(과잉선택 0)**. P4×material-disable 무결 불변 유지 |
| **(c) 비-자재 cascade 후 visible-required 자동충전 = 신규 부채인가?** | GRP_SIZE 변경 cascade → PRBKYPR 8 visible-required 그룹 전부 first-active 충전. **그러나 이는 신규 행위 아님** ↓ |

**(c) 핵심 판정 — 대칭화가 새 과잉선택을 안 만드는 이유(소스 추적):**
- store `defaultSelections`(widget-store.ts:124)가 **로드 시 이미 전 non-input 그룹을 first-active로 채운다**(`g.values.find(v=>!v.disabled)`). self-heal과 **동일 로직**. 즉 visible-required 그룹은 정상 진입 시 절대 empty가 아니다 — self-heal의 visible 충전은 로드-디폴트의 재확인일 뿐.
- self-heal은 `nextSelections[g.id] != null` 이면 skip → **사용자 non-first 선택 미clobber 확인**(probe: GRP_DOSU_COVER=SID_D 사용자선택 → GRP_SIZE cascade 후 SID_D **PRESERVED**).
- 따라서 대칭화는 (re-enable 갭만 닫고) visible 그룹엔 로드-디폴트와 동형 → **신규 over-select 부채 0**. 팀이 경고한 C-A→C-B 체인이 C-C로 번지지 않음.
- 테스트 parity-crossverify.test.ts:40-61이 fully-disabled SKIP을 별도 단언(과잉선택 0 회귀가드).

### G-1 자재연결 ATTB — **RESOLVED, ACPDSTD 미파손 확인**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **Red 4종 소스 확인** | `mod_06:1313-1315`(SUB_MTR/DIR_MTR/WRK_MTR map) + `1356-1357`(PDT_WRK) + `1279`(orderQty watcher) 정독 | 4종 전부 자재연결 PCS, ATTB=orderQty. QUANTITY_ECHO_PCS={SUB_MTR,PDT_WRK,INN_DFT,**WRK_MTR,DIR_MTR**} 정합 |
| **GSTGMIC WRK_MTR+PDT_WRK 공존(독립 probe)** | vite-node quantity=7 | **WRK_MTR.ATTB="7", PDT_WRK.ATTB="7"**(둘 다 echo, 이전 WRK_MTR 누락='' 해소) |
| **ACPDSTD SUB_MTR 미제거(CRITICAL retraction)** | vite-node quantity=3 | **SUB_MTR.ATTB="3"**(제거 안 됨 — 초기 오검출 "제거" 철회 확인. Red SUB_MTR도 orderQty default라 날조 아님) |
| **비-자재연결 과잉 echo 0** | test:110-115 | CUT_DFT ATTB='' + ATTB_2 키 부재(자재연결 아닌 후가공은 빈 echo 유지) |

### G-2 에디터 가격콜백 배선 — **RESOLVED, no-op 해소**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **3콜백 실제 전달** | EditorOverlay.tsx diff 정독 | onProdVarChanged→reQuote(), onPageCountChanged→setPageCount(>0 가드), onRequestUserToken→refreshEditorToken. **이전 미전달(no-op) → 배선됨**. useEffect deps에도 추가 |
| **store 도달** | test:191-230 | prod-var-changed→priceCalls 증가(재계산), page-count-changed→pageCount>0, request-user-token→editorConfig 재발급 호출수 증가. **실 store 액션 도달**(타우톨로지 아님) |
| **refreshEditorToken 토큰 미보관(보안)** | widget-store diff 정독 | `bff.editorConfig` 재호출 → `set({editorConfig:config})`. 토큰은 config 내 transient(기존 openEditor와 동일 패턴), EditorBridge가 즉시 URL로 전달. **신규 누출 아님**(기존 세션-transient 패턴 동일) |

### PRICE=0 진단(D-L3 재정의) — **RESOLVED**

| 검증 | 결과 |
|------|------|
| **ok:false + reason + warn, no throw** | mapPriceResponse diff: finalPrice≤0 → `priceUnavailableReason` 설정 + `console.warn` + `ok=false`. **throw 없음**(미캡처 fixture 렌더 보존) |
| **fixture 렌더 보존(독립)** | 의류/ACC/포스터 fixture는 PRICE=0이나 throw 안 함 → mapProduct/render 정상(이전 probe들에서 CLSTSHS/ACPDSTD/BNBNFBL 전부 렌더 확인됨) |
| **reason 명시** | test:129-138: priceUnavailableReason 정의됨 + `/Red.*0\|결함\|세션\|필드/` 매칭 + warn 호출 |
| **contract additive** | price.ts `priceUnavailableReason?` optional 1필드(PRICE>0이면 undefined) |

---

## 2. 게이트 재현 (내가 직접 실행)

```
cd 04_build
npx tsc --noEmit  → tsc_rc=0
npx vitest run    → Test Files 17 passed, Tests 148 passed (136→148, +12 교차검증 회귀가드)
npx vite build    → build_rc=0, dist/widget.js 894KB (Wave-C 893KB +1KB: 진단/배선 로직만)
```
`test/parity-crossverify.test.ts` 12케이스 정독: C-B(왕복 복구 + fully-disabled SKIP) 2 / G-1(WRK_MTR/DIR_MTR/PDT_WRK+SUB_MTR 정정/비자재 빈echo) 4 / PRICE=0(reason+warn+no-throw) 3 / G-2(prod-var 재계산/page-count/token 재발급) 3. **전부 실 소스(mod_06 map)·실 fixture·실 store 액션 대조 — 타우톨로지 아님.**

---

## 3. INV-3 최소·additive — **PASS**

| 파일 | 변경 | 판정 |
|------|------|------|
| contract/price.ts | `priceUnavailableReason?` optional +1 | **additive**(PRICE>0이면 undefined) |
| cascade.ts | `g.visible` 조건 제거(±2줄) | **최소** — skip조건 1곳, 신규 함수 0. fully-disabled 가드(`if(first)`) 유지 |
| red-adapter.ts | QUANTITY_ECHO_PCS +2 코드(WRK_MTR/DIR_MTR) + PRICE=0 진단 블록 | 데이터 set + 어댑터 진단 |
| EditorOverlay.tsx | 콜백 3 배선 + deps | additive |
| widget-store.ts | refreshEditorToken 액션 +1 | additive |
| context.tsx | useEditorSession에 3액션 노출 +4 | additive |

- **신규 contract = priceUnavailableReason 1개**(optional). 신규 leaf 0, 신규 dispatcher case 0.
- scope-creep 0: 4결함에 정확히 한정. cascade 변경이 1곳(±2줄)으로 회귀면 최소.

---

## 4. 이연 항목 (은폐 금지 — 추적)

| ID | 상태 | 사유 |
|----|------|------|
| **L-3** size-linked 반경(GSCDPOP factor='size') | **DEFER** | 어댑터가 divSeq 미전달 → 항상 '4' echo(Red '3'/'6'). GSCDPOP fixture 부재로 **dormant**. cascade post-pass는 selection 복구만(반경 ATTB 재계산은 별 메커니즘). 컨버전 게이트 이연 — 실 BFF 배선 시 침묵 가격왜곡 위험 명시 |
| **잠복** 합성 재합성 attb 미포함 | **DEFER** | price.ts 합성 재합성이 `{groupId,valueId}`만 emit(attb 미포함). 전 fixture COT/SCO×ATTB_CD 공존 0건 → 무발현. 컨버전 게이트 체크리스트 |
| **G-3** deob 라인앵커 stale | **MINOR** | 주석 라인번호 밀림(2586 vs 실제 2607). 추적성만 영향, 동작 무관 |
| **의류/ACC/포스터 PRICE** | **TODO 재캡처** | PRICE=0이 캡처공백(비로그인/세션)이지 Red 미가격 아님(B1 오진 철회). PRICE>0 재캡처 필요: BNBNFBL/BNPTPET/CLSTSHS/ACPDSTD/GSSBMTL. 현재 ok:false+reason으로 안전 격리 |

---

## 5. 최종 판정

## **GO**

- **C-B [RESOLVED]**: 대칭 self-heal로 자재 왕복 복구. **신규 과잉선택 부채 0** — fully-disabled SKIP 유지 + visible 충전이 store 로드-디폴트와 동형(신규행위 아님) + 사용자 non-first 선택 미clobber, 3방향 독립 probe 입증. 팀이 경고한 C-A→C-B 체인이 C-C로 번지지 않음.
- **G-1 [RESOLVED]**: WRK_MTR/DIR_MTR 추가(Red 4종 자재연결 소스 확인), GSTGMIC 공존 echo 확인, **ACPDSTD SUB_MTR 미제거(ATTB='3')** — 오검출 철회 정확 반영.
- **G-2 [RESOLVED]**: 3콜백 EditorOverlay 배선 + store 도달 확인, stale-price no-op 벡터 해소. 토큰 신규 누출 0.
- **PRICE=0 [RESOLVED]**: ok:false+reason+warn, no-throw(fixture 렌더 보존), contract additive.
- **INV-3**: contract +1(optional), cascade ±2줄, 신규 leaf/case 0, scope-creep 0.

**신규 부채: 0.** 이연(L-3 dormant / 잠복 / G-3 / PRICE 재캡처)은 전부 자가신고됐고 day-1 무발현 또는 안전 격리(ok:false).

**검증 통찰(회의적):** 팀이 드러낸 "순차검증은 fixture 일부만 본다"는 사각을 본 검증은 **walk-back(RXOMO080→RXART300) + per-product(GSTGMIC/ACPDSTD) + fully-disabled 합성**으로 직접 probe해 메웠다. 가장 위험했던 C-B 대칭화는 "fix가 새 부채를 만드는가"를 3방향으로 추궁한 결과 — store `defaultSelections`와 동형이라 visible 그룹엔 신규 행위가 없고, fully-disabled 가드가 과잉선택을 막는다. **유일한 실질 미해소는 L-3 size-linked 반경(dormant, 컨버전 이연)**이며 day-1 무발현이라 GO를 막지 않는다.

**→ 빌더 fix 라운드 GO. 코드 레벨 정합(S0~S3 + MAJOR A·B·C + 교차검증 fix) 완료. 잔여는 컨버전 단계(후니 옵션마스터 수령 시 어댑터 데이터소스 교체 + L-3/잠복 게이트 + 의류/ACC/포스터 PRICE>0 재캡처).**
