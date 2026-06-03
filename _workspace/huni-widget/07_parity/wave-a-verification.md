# wave-a-verification.md — Wave-A 9 MAJOR 갭 독립 재검증 (S3)

> 검증자: hw-qa. 일시: 2026-06-03. 입력: s3-major-round-plan.md, parity-gap-map.md, major-capture-note.md, blocker-fix-verification.md.
> **원칙: 빌더 자가보고 미신뢰.** 모든 증거는 내가 직접 수집(diff 정독 + 캡처/fixture 필드 추출 + 독립 vite-node 실행 + 라이브 Shadow-DOM 렌더 + 게이트 재현). 기준 = 책임/로직/분기 재현 동등.
> INV-3 의도적 RELAX(구조결함 — core/contract 불가피). 최소·additive 판정 포함.

---

## 0. 한 줄 결론

**Wave-A 9 갭 전부 RESOLVED**(독립 증거). tsc 0 / vitest **114/114** / build OK 내 눈으로 확인. core/contract 편집 **최소·additive**(전부 optional 슬롯/콜백, 기존 필드 0변경). **P4 회귀 없음**(material→disable 핵심 기제 독립 입증). **L-4 Shadow-DOM 실렌더 입증**(computed hex = 상수맵). 신규 leaf 1개(MultiCheckGroup, D4 정당). → **Wave-B GO.**
> 단 **1건 비차단 CONCERN**: COT_DFT/SCO_DFT 대상 disable 룰이 L-2 합성분해(BLOCKER 라운드)로 group-id 미스매치 → silent no-op. **Wave-A 회귀 아님**(BLOCKER 라운드 L-2가 도입, 현 SKU 무증상). Wave-B 추적.

---

## 1. 갭별 독립 판정 (9건)

| # | 갭 | 판정 | 내가 수집한 증거 |
|---|----|------|------------------|
| 1 | **L-4 END_PAP color-chip hex** | **RESOLVED** | (a) `component-type-map.ts` PCS_COLOR_HEX 10색 = deob_07:2511 값 일치(diff 정독). (b) PRBKYPR fixture END_PAP 10 PCS_DTL_CD(CLYEL…CLGRY) 실재. (c) **라이브 Shadow-DOM 렌더**: 면지 = 10 원형칩(`br:9999px`), computedBg = inlineBg(예 CLBLU `rgb(173,204,236)`=#adccec, CLGRY `rgb(237,237,238)`=#ededee 등 7색 실측 일치), `selects:0`(드롭다운 아님). ColorChip `style={{backgroundColor:hex}}` 인라인 → **Shadow-DOM safe**(Tailwind 변수체인 함정 회피) |
| 2 | **D-L2 itemGroup echo** | **RESOLVED, 회귀 0** | mapProduct `itemGroup:opt.item_gbn`. **fixture 실측**: PRBKYPR=`book2025_item`(startsWith book2025=true → 책자 유지), GSPUFBC/STPADPN/AIPPCUT=`vDigital_item`, BCSPDFT=`digital_item`(전부 non-book 유지) → **기존 책자/비책자 분기 무회귀**. serializer 권위 = itemGroup 우선, 미전달 시 inner 휴리스틱 fallback(테스트 68-111 실증) |
| 3 | **onOptionChange** | **RESOLVED** | widget-store `selectOption` 끝에 `deps.onOptionChange?.({groupId,valueId})` 발화(additive, 미주입 시 no-op). 테스트 118-129 GREEN |
| 4 | **에디터 3액션** | **RESOLVED, 누수 0** | editor-bridge switch에 page-count-changed/request-user-token/prod-var-changed 3 case 추가(diff 151-165). **나머지 ~25 액션은 switch default 미처리 = 기존과 동일(누수 아님 — 명시 case만 콜백)**. 콜백 3종 전부 optional. 테스트 161-177 GREEN |
| 5 | **L-D3-1 isReadyToOrder** | **RESOLVED, 계약 무파손** | 신규 `checkOrderReadiness`(widget-store): `selectCanOrder` 클라게이트 먼저 → 통과 시 `bff.isReadyToOrder`. **editor-bridge goto-cart→onResult→onClose 경로 무변경**(diff 미포함) — 기존 goto-cart=close 계약 보존. 어댑터 isReadyToOrder finalPrice>0 게이트(테스트 223-231) |
| 6 | **C-2 disable 폴백** | **RESOLVED** | cascade.ts: required 그룹 값 disable 시 빈선택 대신 `firstActiveOf` 재선택(단일 137-139, 멀티 129-131). 테스트 238-261(V1 disable→V2 재선택). **독립 vite-node 확인**: 합성 required 그룹 disable→첫활성값 교체 |
| 7 | **L-3a ROU_DFT 멀티** | **RESOLVED, 신규 leaf 정당** | 어댑터 `MULTI_SELECT_PCS={ROU_DFT}` → multiple:true. OptionControl이 **신규 ComponentType 없이 `group.multiple`로 MultiCheckGroup 분기**(diff). MultiCheckGroup = 체크박스+전체토글(양방향), 라벨 props .map(하드코딩 0), `style` 인라인 치수. BCFOXXX fixture 4귀. 테스트 268-285. **반경 ATTB는 Wave-B slot(주석 명시)** |
| 8 | **P4 VIEW_YN 동적+hidden-essential** | **RESOLVED, 회귀 0**(§2 정밀) | cascade.ts `applyVisibilityAndEssential`. 독립 입증 ↓ |
| 9 | **L-D3-5 buildIframeSrc 분기** | **RESOLVED, 기본 보존** | cmd create(기본)/open(edit)/reform 분기 + projectId 전달. 테스트 194-206(기본=create 회귀 보존, edit→open&project_id, reform→reform). 격리된 URL 조립 |

---

## 2. P4 정밀 회귀 검증 (최고위험 — 독립 probe)

**우려:** cascade.ts가 BLOCKER까지 disable전용 단일책임이었는데 P4가 visible 토글 + hidden-essential 자동선택을 추가. 회귀면이 가장 넓음.

내가 직접 vite-node로 PRBKYPR에 probe 4종 실행:

| probe | 기대 | 실측 | 판정 |
|-------|------|------|------|
| **material→disable 핵심 기제 보존** | 자재 disable 룰이 EXISTING 그룹 disable+deselect, 복귀 시 re-enable | 합성 required 그룹: M_LOW 선택→PCS_COT all-disabled=true & deselect, M_HI 복귀→re-enabled=true | **무회귀** — BLOCKER-era 기제 그대로 |
| **hidden-essential 자동선택 정확성** | `!visible && required` 그룹만 채움, visible 그룹은 안 건드림 | GRP_SIZE 변경 cascade → PCS_CUT_DFT/PER_DFT/CVR_SFT(hidden essential) 자동선택(DFXXX/BPLFT/DFXXX), **visible-required 7그룹은 미충전(사용자 몫)** | **정확** — 과잉선택 0 |
| **빈 visibilityRules → visible 무변경** | 현 fixture는 visibilityRules=[] → visible 플래그 baseline 동일 | baseline visible == cascade-후 visible: **true** | **무회귀** |
| **deselect 체인 무크래시** | disable된 선택값 정리, 크래시 0 | selections keys 정상, 크래시 0 | OK |

**P4 회귀 결론: 없음.** applyVisibilityAndEssential은 (a) visibilityRules 비면 visible 토글 스킵, (b) hidden-essential은 `!g.visible && g.required && !g.inputSpec && g.values.length>0 && 미선택`로 엄격 가드해 visible 그룹·입력형 그룹·이미선택 그룹을 안 건드림. material-disable 경로(76-141)는 **로직 1줄도 안 바뀜**, 끝에 visibility 적용만 append. 테스트 292-335도 hidden-essential 3그룹·visible 토글·미트리거 보존 단언.

---

## 3. L-4 Shadow-DOM 렌더 증명 (요구사항)

라이브 렌더(`npm run dev :5173`, Playwright Shadow-DOM 관통):
- **면지(END_PAP) = 10 원형 color-chip 그리드**(select 아님, `selects:0`). 스크린샷 `05_qa/captures/wave_a_L4_PRBKYPR.png` 시각 확인(노랑/민트/흰/라벤더/핑크/피치/연두/파랑+하늘/회색, 첫칩 #553886 ring 선택).
- **computed background-color = inline hex**(Shadow-DOM safe): 7색 실측 전부 상수맵 일치 — CLPPL #e0def0, CLPIN #f6e6f1, CLAPR #fde7dc, CLGRN #e4f2e8, CLBLU #adccec, CLSKY #bae5fb, CLGRY #ededee. `computedBg===inlineBg`로 Tailwind 변수체인 함정 미발생(ColorChip `style={{backgroundColor}}` 인라인).
- 보너스: 동일 렌더에서 L-2 합성분해(코팅 면+코팅 / 부분UV 면+부분UV)도 2축 구조로 정상 렌더 확인.

---

## 4. INV-3 RELAX 최소·additive 판정 — **PASS**

core/contract 변경(`git diff --stat`):

| 파일 | 변경 | 판정 |
|------|------|------|
| `contract/constraints.ts` | +11 (`VisibilityRule` 타입 + `visibilityRules?` optional) | **additive** |
| `contract/product.ts` | +4 (`itemGroup?` optional) | **additive** |
| `contract/price.ts` | +3 (`itemGroup?` optional) | **additive** |
| `contract/cart.ts` | +7 (`NormalizedOrderReadiness` 신규 타입) | **additive**(신규 인터페이스) |
| `contract/index.ts` | +8 (re-export) | barrel |
| `widget/stores/cascade.ts` | +75 (P4 `applyVisibilityAndEssential` + C-2 폴백) | **정당** — 단일책임 확장이나 기존 disable 경로 무변경, 신규 함수 격리. P4+C-2 두 갭 분량 |
| `widget/stores/widget-store.ts` | +16 (onOptionChange 발화 + checkOrderReadiness) | additive |
| `widget/stores/price.ts` | +1 (itemGroup echo) | additive |
| `widget/components/controls/OptionControl.tsx` | +9 (`group.multiple`→MultiCheckGroup 분기, **신규 ComponentType 0**) | 최소 — dispatcher case 미추가 |
| `widget/editor/editor-bridge.ts` | +39 (3 case + buildIframeSrc 분기) | additive(콜백 optional) |
| `adapters/red/*` | hex맵/itemGroup echo/멀티/isReadyToOrder — 어댑터 데이터 주입 | 어댑터 책임 |
| **신규 leaf** | `MultiCheckGroup.tsx` 1개 | **D4 사전정당 2개 중 1번째** (AccPanel은 Wave-C) |

- **scope-creep 0**: 변경이 Wave-A 9갭에 정확히 한정. Wave-B/C 항목(L-3b 반경·L-1 속성칩 runtime·의류·ACC) 미손댐.
- **신규 ComponentType 0**(OptionControl이 `group.multiple` 플래그로 분기 — dispatcher 무변경, D4 단순성 가드 준수).
- **신규 leaf 정확히 1개**(MultiCheckGroup). D4가 정당화한 2개 중 첫째, AccPanel은 Wave-C로 미도입.
- cascade.ts +75는 P4(동적 visible+hidden-essential)+C-2(폴백) 2갭 합산 — 기존 disable 경로 무변경·신규함수 격리라 정당.

---

## 5. 게이트 재현 (내가 직접 실행)

```
cd 04_build
npx tsc --noEmit  → tsc_rc=0 (에러 0)
npx vitest run    → Test Files 14 passed, Tests 114 passed (94→114, +20 Wave-A 회귀가드)
npx vite build    → build_rc=0, 165 modules, dist/widget.js 830KB (BLOCKER 758KB +72KB: MultiCheckGroup+L-4)
```
`test/parity-wave-a.test.ts` 20케이스 정독: L-4(hex 상수값 단언 + finish-button 회귀), D-L2(echo + 분기권위 + fallback), onOptionChange, 에디터3(vi.fn 호출 단언), L-D3-5(create/open/reform), L-D3-1(어댑터 finalPrice 게이트), C-2(합성 disable→재선택), L-3a(multiple+배열 echo), P4(hidden-essential 3그룹 + visible 토글 + 미트리거 보존). **전부 실 fixture/실 코드맵값 대조 — 타우톨로지 아님.**

---

## 6. CONCERN (비차단, Wave-B 추적)

### C-A: COT_DFT/SCO_DFT disable 룰 group-id 미스매치 (silent no-op)

- **발견(독립 probe):** PRBKYPR disableRules 24건의 disablesGroupId 9종 distinct(`PCS_COT_DFT/PCS_SCO_DFT/PCS_SCO_GLD/PCS_SCO_SLV/PCS_FLD_DFT/PCS_MIS_DFT/PCS_PRT_MAG/PCS_LAM_DFT/PCS_OSI_DFT`) **전부 EXISTING 그룹과 미스매치(exist:[])**.
  - `COT_DFT/SCO_DFT/SCO_GLD/SCO_SLV` (4종): BLOCKER 라운드 **L-2 합성분해**로 그룹이 `PCS_COT_DFT__side`/`__coating`으로 개명 → 룰의 `PCS_COT_DFT`가 안 맞음 → **자재변경 시 코팅그룹 disable이 silent no-op**.
  - `FLD_DFT/MIS_DFT/PRT_MAG/LAM_DFT/OSI_DFT` (5종): 이 SKU의 pdt_pcs_info에 **애초 부재**한 그룹(Red 데이터 특성, 무증상, 무관).
- **Wave-A 회귀 아님:** 이 미스매치는 **BLOCKER 라운드 L-2가 도입**(COT/SCO 개명)했고 Wave-A는 무관. Wave-A의 disable 핵심기제 자체는 EXISTING 그룹 대상으로 **정상 동작 독립 입증**(§2 probe 1).
- **현 영향:** PRBKYPR에서 저평량지 선택 시 코팅 후가공이 회색처리 안 됨(사용자가 불가조합 선택 가능 → 가격 측 부정확 소지). 단 **현 fixture day-1 발현은 약함**(C-2 폴백·서버 가드가 일부 흡수, COT는 합성이라 한축만으론 emit 안 됨).
- **권고(Wave-B):** L-2 합성 그룹의 disable 룰 매핑 보정 — 어댑터가 disableRules의 `PCS_COT_DFT` 타깃을 `__side`/`__coating` 양쪽으로 확장하거나, cascade가 base-id 매칭으로 합성 그룹을 disable. Wave-B(반경/속성칩) 캡처 라운드에 묶어 처리. **BLOCKER 게이트·Wave-A 게이트 차단 아님**(기제 정상, 데이터 매핑 보정 사안).

---

## 7. 최종 Wave-A 판정

## **GO (Wave-B 진행 가능)**

- **RESOLVED 9 / PARTIAL 0 / NOT-RESOLVED 0** — 9 갭 전부 독립 증거로 해소 확인.
- **P4 회귀 없음**(최고위험): material→disable 기제 무변경 독립 입증, hidden-essential 과잉선택 0, 빈 visibilityRules 무영향.
- **L-4 Shadow-DOM 실렌더 입증**: computed hex=상수맵, color-chip(select 아님), 인라인 style.
- **INV-3 relax 최소·additive**: 전부 optional 슬롯/콜백, 신규 ComponentType 0, 신규 leaf 정확히 1(D4 정당), scope-creep 0.
- **CONCERN 1건 비차단**: COT/SCO disable 룰 group-id 미스매치(L-2 BLOCKER 라운드 유래, Wave-A 무관, 무증상 약함) → Wave-B 추적.

**검증 통찰(회의적):** Wave-A는 빌더 주장대로 9갭·114테스트가 사실이며 P4 회귀도 없다. 다만 독립 probe가 **빌더 자가테스트가 못 본 L-2 disable 룰 미스매치(C-A)**를 잡았다 — 이는 Wave-A 결함이 아니라 BLOCKER 라운드의 잠복 부채로, 자가테스트가 EXISTING-그룹 합성만 검증하고 disable-룰×합성그룹 교차를 안 본 사각. Wave-B에서 마감 권고. 이 한 건이 Wave-A GO를 막지 않는다(기제 정상·무증상).
