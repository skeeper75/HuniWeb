# wave-c-verification.md — Wave-C 독립 재검증 (의류 clothes2025 + ACC 부자재) + MAJOR 라운드 최종

> 검증자: hw-qa. 일시: 2026-06-03. 입력: s3-major-round-plan.md, major-capture-note.md, parity-matrix-D4, wave-a/b-verification.md, Red 소스 mod_05_app_api.js.
> **원칙: 빌더 자가보고 미신뢰.** 증거는 내가 직접 수집(Red 소스 정독 + diff·fixture 추출 + 독립 vite-node live-smoke + 게이트 재현). 기준 = 책임/로직/분기 재현 동등.

---

## 0. 한 줄 결론

**Wave-C 2도메인(의류·ACC) 전부 RESOLVED**(독립 증거). tsc 0 / vitest **136/136** / build OK 내 눈으로 확인. **신규 leaf 정확히 2개**(MultiCheckGroup #1·AccPanel #2 = D4 사전정당 그대로, 스코프 크립 0). **accFilterConfigMap fabrication 0**(K_ 소스 직접 대조, GSSBACM 정확 제외). **apparel/ACC price fabrication 0**(PRICE=0→ok:false 라우팅). **의류 PTP_SLK 토글이 Wave-A P4 cascade 재사용**(신규 cascade 0). fixture trim 진짜 subset. → **MAJOR 라운드 전 웨이브(A·B·C) GO.**

---

## 1. 도메인별 독립 판정

### 의류 clothes2025 (`adapters/red/apparel.ts`) — **RESOLVED**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **6블록 파싱 + itemGroup 분기** | vite-node live-smoke CLSTSHS | itemGroup='clothes2025_item' → APP 6그룹 생성(GRP_SIZE 등 일반경로 아님). PRINT_TYPE/PRINT_AREA/COLOR/SIZE/MULTI_SIZE/PANTONE |
| **PRINT_TYPE 3분기** | live-smoke | option-button PTP_DTF/PTP_DIR/PTP_SLK (소스 USE_YN!=='N' 필터) |
| **PTP_SLK 토글 = Wave-A P4 재사용(신규 cascade 0)** | live-smoke applyCascade | `APP_PRINT_TYPE='PTP_SLK'` → multiSize·pantone visible=**true**. `PTP_DTF` → 둘 다 **false**(유지). visibilityRules=`[{PTP_SLK→APP_MULTI_SIZE},{PTP_SLK→APP_PANTONE}]`. apparel.ts가 visible:false + visibilityRules push만, cascade 로직은 Wave-A `applyVisibilityAndEssential` 그대로 — **신규 cascade 코드 0** |
| **multiSize = MultiCheckGroup 재사용(신규 leaf 0)** | live-smoke | APP_MULTI_SIZE componentType='finish-button' + multiple=true → OptionControl이 `group.multiple`로 MultiCheckGroup 분기(Wave-A 경로). **신규 컨트롤 아님** |
| **color→color-chip HEX / print_area→option-button + KOI_NME attb** | apparel.ts 정독 + test:34-50 | apparel_color→color-chip(HEX), print_area→option-button values에 `attb=KOI_NME`(에디터 영역키 불투명 echo) |
| **price fabrication 0** | fixture-source 정독 | CL* → digital_price shape fixture(비로그인 PRICE=0 → mapPriceResponse ok:false). 주석 "가격 날조 금지" 명시. **D-L3 게이트로 침묵주문 차단** |

### ACC 부자재 (`adapters/red/acc-config.ts` + `AccPanel.tsx`) — **RESOLVED, fabrication 0**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| **accFilterConfigMap 소스 대조(no fabrication)** | `mod_05_app_api.js:2189` K_ 직접 정독 | K_ 키 = **GSSBMTL/GSSBSTP만**(GSSBACM은 M1 Set에만 있고 K_ 키 아님 — 빌더 정확 제외). GSSBMTL ptt=37/38/19/61, GSSBSTP=3(CASCADE)/8(MULTI). acc-config.ts ingest가 소스와 일치(컬러 5/불박 3, 제조사 애플·삼성, MULTI GRP_COD SMT_ISB/VPD/DLU) |
| **단순 add-on vs 다단 분기** | live-smoke | ACPDSTD(미등록) → SUB_MTR finish-button 12값, **acc-panel 미생성**. GSSBMTL(등록) → acc-panel CASCADE 2단(ACC_F0 컬러 5 → ACC_F1 불박 3) |
| **acc-panel = 유일 신규 dispatcher case** | OptionControl diff | `case 'acc-panel'` 1건만 신규 추가. MultiCheckGroup은 group.multiple 분기(case 추가 0) |
| **dependsOn 동적 단계** | test:114-141 + acc-config | SUB_GRP 옵션 부재(기종/패턴) → 상위 의존(동적), AccPanel이 `enabled = dependsOn==null \|\| values[dependsOn]!=null`로 게이트 |
| **AccPanel Shadow-DOM safe** | AccPanel.tsx 정독 | 치수 inline `style={{height:44}}`, 색은 RULE-2 동형 className. CASCADE radio + MULTI checkbox 분기 |

---

## 2. 신규 leaf 최종 집계 (CRITICAL INV) — **정확히 2개**

| # | 신규 leaf | 웨이브 | D4 사전정당? | dispatcher case |
|---|-----------|--------|-------------|-----------------|
| 1 | `MultiCheckGroup.tsx` | Wave-A | O (멀티선택 후가공/ROU) | **case 추가 0** (group.multiple로 finish-button 분기) |
| 2 | `AccPanel.tsx` | Wave-C | O (ACC 부자재 캐스케이드) | `case 'acc-panel'` 1건 |

- **untracked control .tsx = 정확히 2개**(git status 확인): MultiCheckGroup, AccPanel.
- **MAJOR 라운드 전체 신규 dispatcher case = 1개**(acc-panel). 신규 ComponentType union 추가 = 1개(acc-panel).
- **D4가 사전정당화한 2개와 정확히 일치 — 스코프 크립 0.** 그 외 모든 갭(L-4 color-chip/L-3 ROU/P4 VIEW_YN/의류 6그룹)은 기존 14 컨트롤 + 어댑터 파생 + cascade 확장으로 흡수.

---

## 3. fixture-trim 무결성 (CLSTSHS) — **진짜 subset, 날조 0**

| 블록 | 캡처(major-capture-note) | 빌드 fixture | 판정 |
|------|--------------------------|--------------|------|
| print_type | 3 | 3 (PTP_DTF/DIR/SLK) | full |
| print_area | 6 | 6 | full |
| apparel_color | 54 | 54 | full |
| size_info | 7 | 7 | full |
| size_color_info | 227 | **30** | **trim(subset)** |
| pantone_color | 1124 | **24** | **trim(subset)** |

- 빌드 fixture 29,596 bytes. size_color/pantone만 대표 subset으로 trim(분기·렌더 검증엔 충분, 227·1124 전량 불요).
- **trim된 값이 실데이터**: pantone 샘플 `PANTONE 100 C #F2EA7A` ~ `PANTONE 1215 C #FADD80`(실 RGB 보유) — **placeholder/날조 아님, 캡처의 진짜 부분집합**. print_type/area/color/size는 full 보존(분기 권위 블록은 손실 없음).

---

## 4. INV-3 RELAX 최소·additive — **PASS**

| 영역 | Wave-C 변경 | 판정 |
|------|------------|------|
| contract/product.ts | `acc-panel` ComponentType + `AccFilterGroup`/`AccPanelSpec` 타입 + `accSpec?` optional | **additive**(기존 필드 0변경) |
| contract (price/cart/constraints/index) | Wave-A/B 것 re-export, Wave-C 신규 contract = acc-panel/accSpec만 | additive |
| OptionControl.tsx | `case 'acc-panel'` + AccPanelBridge | dispatcher 1 case |
| 신규 파일 | `apparel.ts`(어댑터), `acc-config.ts`(상수), `AccPanel.tsx`(leaf #2) | 어댑터 데이터 + 정당 leaf |
| cascade.ts | **Wave-C 변경 0** (의류 토글이 Wave-A applyVisibilityAndEssential 재사용) | **무변경** |
| 기존 leaf/store | 의류·ACC가 기존 경로 재사용 | 무변경 |

- **cascade.ts Wave-C 추가 0** — 의류 동적 토글이 Wave-A P4 인프라를 그대로 탐(신규 cascade 코드 없음). 회귀면 0.
- scope-creep 0: Wave-C는 의류·ACC에 정확히 한정.

---

## 5. apparel price 후속 노트 (은폐 금지)

- 의류(clothes2025)·ACC 가격은 **미캡처**(major-capture-note §5: 옵션 shape에 집중, 가격스윕 별도). 현 어댑터는 CL*/AC*/GSSB* → digital_price shape fixture(PRICE=0) → **ok:false**(D-L3 게이트). 침묵 주문 불가.
- **후속 필요(컨버전/Wave-D 후보):** 후니 day-1 의류·부자재 판매 확정 시 clothes2025_price·부자재 가격 스윕 캡처 → fixture 교체 → PRICE>0 round-trip 검증. 현 시점은 **옵션 SHAPE·분기 동등성만 검증됨**(가격 동등성은 미검증, 가격 날조 안 함으로 안전).

---

## 6. 게이트 재현 (내가 직접 실행)

```
cd 04_build
npx tsc --noEmit  → tsc_rc=0
npx vitest run    → Test Files 16 passed, Tests 136 passed (123→136, +13 Wave-C 회귀가드)
npx vite build    → build_rc=0, dist/widget.js 893KB (Wave-B 831KB +62KB: AccPanel+apparel+acc-config+의류 fixture)
```
`test/parity-wave-c.test.ts` 13케이스 정독: 의류(itemGroup 분기/PRINT_TYPE 3/print_area KOI attb/color-chip+size/PTP_SLK 토글 hidden→visible/cascade) 6 + ACC 단순(SUB_MTR finish-button) 1 + ACC 다단(K_ 상수 정확값/CASCADE 2단/dependsOn 동적/MULTI 3그룹/미등록 undefined) 6. **전부 실 소스값(K_)·실 fixture(apparel_info) 대조 — 타우톨로지 아님.**

---

## 7. 최종 판정

### Wave-C: **GO**
- RESOLVED 2(의류·ACC) / PARTIAL 0 / NOT-RESOLVED 0.
- 신규 leaf 정확히 2(D4 정당), 신규 dispatcher case 1(acc-panel), accFilterConfigMap·apparel price 날조 0, fixture trim 진짜 subset, 의류 토글 Wave-A 재사용(cascade 무변경).

### MAJOR 라운드 최종(A·B·C 전 웨이브): **ALL GO**
| 웨이브 | 검증 결과 | 잔여 |
|--------|-----------|------|
| Wave-A | GO (9갭, P4 회귀 0, L-4 Shadow-DOM 입증) | C-A concern → Wave-B서 해소 |
| Wave-B | GO (L-3b GSSCDPOP-only/L-1 2-shape/C-A 해소+과잉disable 0) | 신규 concern 0 |
| Wave-C | GO (의류·ACC, 신규 leaf 2 확정) | apparel/ACC **가격 미검증**(shape만, 컨버전 후속) |

**신규 leaf 총계: 정확히 2 (MultiCheckGroup + AccPanel) = D4 사전정당 그대로.**
**누적 신규 concern: 0** (Wave-A의 C-A는 Wave-B서 닫힘).

**검증 통찰(회의적):** Wave-C는 가장 큰 신규 어댑터 경로(의류 apparel.ts + ACC acc-config.ts/AccPanel)임에도 cascade.ts를 1줄도 안 건드렸다 — Wave-A P4 인프라(visibilityRules)를 재사용해 의류 PTP_SLK 토글을 구현한 것이 핵심 절제. accFilterConfigMap·반경(Wave-B)·apparel은 모두 Red 번들/소스를 직접 열어 fabrication 가능성을 원천 차단했다. **유일하게 미검증으로 남는 것은 의류·ACC의 "가격 동등성"**인데, 이는 캡처 부재가 솔직히 명시됐고 PRICE=0→ok:false로 침묵주문을 막아 안전하게 격리됐다(가격 날조 안 함). 후니 day-1 판매 확정 시 가격 캡처로 마감하면 됨 — MAJOR 라운드 GO를 막지 않음.

**→ MAJOR 라운드 전 웨이브 GO. 빌더 웨이브 종료. 잔여는 (a) 의류/ACC 가격 캡처(판매 확정 시), (b) 후니 컨버전(옵션마스터 수령 시 어댑터 데이터소스 교체).**
