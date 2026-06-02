# build-plan.md — hw-builder 구현 계획 (GATE)

> 파이프라인 ③ GATE 산출물. `03_spec/*`가 구현의 단일 소스. hw-builder는 추가 추측 없이 이 순서로 구현.
> 우선순위: Priority High(핵심 경로) / Med(완결성) / Low(최적화·엣지). 시간 추정 금지.

---

## 0. 단일 소스 통지

hw-builder에게: `_workspace/huni-widget/03_spec/`의 10개 문서가 구현 단일 소스다.
- 데이터 모델 = `data-contract.md`(정규화 타입). [HARD] 위젯 코드는 정규화 타입만 import, Red/후니/커머스 raw shape 직접 참조 금지.
- 어댑터 = `data-adapter.md`. BFF 레이어. 위젯 번들에 미포함.
- 컴포넌트 = `component-tree.md` 14 매핑 + `DESIGN.md` 8 Critical Rules.
- [HARD] Shopby 등 특정 커머스 바인딩 금지. 장바구니는 `/cart-handoff`에서 종료(UNDECIDED).

---

## 1. 구현 순서 (의존성 기반)

### Phase A — 계약·골격 [Priority High]
1. `contract/` — data-contract.md의 TS 타입 전체. 의존성 그래프 최하단. **먼저 고정**.
2. `adapters/red/` — Red fixture(`01_reverse/captures/*.json`, `02_analysis/captures/*.json`)로 5 어댑터 구현. data-adapter §2 매핑표. 검증: fixture → 정규화 타입 스키마 통과(계약 테스트).
3. BFF stub — api-contract.md 6 엔드포인트. Red 어댑터 연결. 위젯이 붙을 정규화 응답 제공.
4. `widget-loader/` — Shadow Host·adoptedStyleSheets·동적 import·콜백/CustomEvent 브리지 (shadow-dom §1·2, bundle §3).

### Phase B — 상태·렌더 코어 [Priority High]
5. `widget/stores/` — Zustand 단일 store + slice (state-management §1). `createWidgetStore()` 팩토리.
6. `widget/components/` 14 componentType — component-tree §2 매핑. **DESIGN 8 Critical Rules 내재화**:
   - RULE-1 native select 금지(Popover+Command), RULE-2 선택=흰배경+보라테두리, RULE-3 직사각형 카운터, RULE-4 50×50 원형 칩, RULE-5 라벨 하드코딩 금지(`.map()`), RULE-5-EXT Radix Slider, RULE-6/7/8-EXT 칩 규격.
7. `OptionControl` 디스패처 (component-tree §3) + `OptionPanel` 4-Zone.
8. 캐스케이드 룰엔진 (state-management §4, cascade-rules 6종) — 자재변경→disable→해제→재계산 순서 보존.

### Phase C — 가격·표시 [Priority High]
9. 가격 흐름 (price-engine §1·3): buildPriceRequest + debounce 300ms + 캐시 30s + BFF /price.
10. `PriceSummary` (component-tree #13, DESIGN 7.13): 공정별 분해 + 합계 24px/600 보라.
11. 초기 자동 가격 (price-engine §6).

### Phase D — 입력(업로드/에디터) [Priority High]
12. `PdfUploader` (api-contract #3·4): presigned → S3 PUT 직접 → file-meta.
13. `editor-bridge/` + `EditorOverlay` (editor-integration): createProject + from-edicus 핸들러 + origin 검증.
14. 면별 uploadType 분기 (표지=editor, 내지=pdf) — runtime §3.

### Phase E — 주문·완결 [Priority Med]
15. `canOrder` 셀렉터 (state-management §5) + `OrderCTA` (component-tree #14, DESIGN 7.14 3종).
16. cart-handoff (api-contract #6, data-contract §6) — NormalizedCartHandoff → BFF. 커머스 바인딩 미구현(UNDECIDED).

### Phase F — 번들·멀티인스턴스·격리검증 [Priority Med]
17. Vite library mode 3청크 (bundle §2). 크기 측정.
18. 멀티 인스턴스 (bundle §5, store 팩토리·message 라우팅).
19. 격리 검증 (shadow-dom §6) — 호스트 CSS 누수 양방향 0.

### Phase G — 최적화·엣지 [Priority Low]
20. adoptedStyleSheets 폴백, 가격 캐시 튜닝, 에러 바운더리·재시도.

---

## 2. DESIGN 8 Critical Rules 체크리스트 (QA 게이트)

| Rule | 검증 |
|------|------|
| RULE-1 | native `<select>` 0건, ▼ 텍스트 캐럿, 키보드 접근성 |
| RULE-2 | 선택=흰배경+border-2 #553886, 컬러배경 채움 0건 |
| RULE-3 | 카운터 223×50 직사각 3-part, 원형/스피너 0건 |
| RULE-4 | ColorChip 50×50 원형, 선택 ring-2 |
| RULE-5 | JSX 한국어 옵션 라벨 하드코딩 0건(전부 `.map()`) |
| RULE-5-EXT | Radix Slider, native range 0건 |
| RULE-6/7/8-EXT | image 50×50 / mini 32×32 / large grid-cols-5 |
| 공통 | Noto Sans only, 자간 -5%, 본문색 #424242/#553886/#979797/#000 |

---

## 3. 컨버전 게이트 (키스톤 검증)

- [HARD] 위젯 코드에 `PCS_COD`/`MTRL_CD`/`ORD_INFO`/`price_gbn`/Shopby 필드 grep → 0건이어야 함(전부 어댑터 내부).
- Red 어댑터로 위젯 동작 검증(fixture). 후니 어댑터 작성 시 위젯/계약 0 변경으로 동일 동작 = 무손실 컨버전 증명.
- 계약 테스트: 양 어댑터 출력이 정규화 타입 스키마 일치.

---

## 4. OPEN 항목 (미해결 — 출처 명시)

| # | 항목 | 출처 | 영향 | 폴백 |
|---|------|------|------|------|
| O1 | 비책자(굿즈/아크릴) 가격 ORD_INFO 정확 필드 | [역공학 미검증] | 어댑터 분기 | 책자 계약+정적, 후니 데이터로 검증 |
| O2 | 회원등급 할인 워터폴 실데이터 | [역공학 미검증] | 어댑터 finalPrice | 워터폴 정적 확정 |
| O3 | save-doc-report/goto-cart/close 실시간 캡처 | [동작분석 부분] | 에디터 완료 경로 | 정적+핸들러, hw-qa 실편집 검증 |
| O4 | goto-cart `case` 값 종류 | [동작분석 미검증] | pass-through 흡수 | 위젯 무해석 |
| O5 | presigned PUT 정확 헤더(checksum) | [역공학 미검증] | uploader 헤더 | Content-Type만으로 PUT 성공 검증됨 |
| O6 | 커머스 백엔드 바인딩 (/cart-handoff 뒤) | [스코프 UNDECIDED] | 주문 완료 | 어댑터 stub, DB·커머스 확정 후 |
| O7 | BFF 인증 모델(세션/토큰) | [결정 미정] | 위젯 결합 안 함 | credentials:include 위임 |
| O8 | 런타임 번들 실측 크기 | [bundle OPEN] | 성능 | 빌드 후 측정 |
| O9 | adoptedStyleSheets 폴백 매트릭스 | [리서치 후합류 검토] | 구형 브라우저 | <style> 폴백 1단계 |
| O10 | targetOrigin 명시 vs "*" (Edicus redirect) | [리서치 후합류 검토] | postMessage 송신 | 명시 우선, 필요시 "*" |
| O11 | 모바일 반응형 브레이크포인트 | [DESIGN 부록B TBD] | 레이아웃 | 데스크톱 px 우선 |
| O12 | 부자재(ACC) 라이브 미구동 | [역공학·동작분석 미관찰] | order slice 흡수 가정 | 후니 ACC 상품 검증 |

---

## 5. [리서치 후합류 검토] 태그 (02_research 입수 시 재검토)

- adoptedStyleSheets Tailwind 주입 (shadow-dom §2) — established practice로 잠정 확정.
- postMessage origin 보안 (editor-integration §4) — 명시 origin 검증, targetOrigin 명시.
- React 18 createRoot in shadowRoot 마운트 패턴 — 표준 적용.
- 번들 분리·CDN 캐시 전략 (bundle) — 일반 best practice.

> 02_research 입수 시 위 4건 + O9·O10을 재검토하고 변경점을 본 문서에 기록.

---

## 6. 변경 이력

| 날짜 | 변경 | 사유 |
|------|------|------|
| 2026-06-02 | 03_spec 10문서 초안 (architecture/data-contract/data-adapter/component-tree/state-management/price-engine/shadow-dom-strategy/editor-integration/api-contract/bundle-strategy/build-plan) | Phase 1·2 + DESIGN.md 종합. Shopby 제외, 커머스 UNDECIDED, 정규화 계약+어댑터 키스톤 확정. 02_research 미입수(잠정 확정 [리서치 후합류 검토] 태그) |
