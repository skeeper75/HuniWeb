# 코드 레벨 구조 정합 — 갭 전체 지도 (S1 종합)

**작성:** 2026-06-03 | **입력:** P1(정규화) + D1(가격) + D2(상태·캐스케이드) + D3(에디터) + D4(내부캐스케이드)
**정합 기준:** 책임·로직·분기 재현 동등 (라인 답습 아님). React/Vue 구현차 허용.
**한 줄 결론:** 위젯은 "선택값 운반"은 무손실이나, **선택의 부가의미(ATTB·복합축·멀티·VIEW_YN 토글·내부 캐스케이드·서버 주문가능 판정)를 구조적으로 버린다.** 캡처 게이트(GO)가 못 본 코드 레벨 결함.

## 갭 인벤토리 (심각도순)

### 🔴 BLOCKER (가격 직결 — 실 BFF 배선 시 오작동)
| ID | 갭 | 처방 위치 | 재현 스펙 (S3) |
|----|----|----------|----------------|
| **L-1** | ATTB 전손실 (직렬화 `ATTB:''` 하드코딩) — 링색·반경·수량 단가차 왜곡 | 계약+store+직렬화 | `SelectedFinish.attb/attb2/attb3?` 추가(불투명 문자열 운반, 위젯 무계산) + store 3유형 수집(속성칩=선택, 반경=cascade DIV_SEQ 룩업, 수량=echo) + `ATTB:f.attb??''` echo. 5종 후가공 한정 |
| **L-2** | COT_DFT/SCO_DFT 복합축 소멸 (단/양면×코팅 평면화) | 어댑터+직렬화 | 어댑터가 PCS_DTL_CD를 `side=slice(-1)`/`coating=slice(0,4)` 2축 분해→2 OptionGroup, 직렬화 시 `coating+side` 재합성. **신규 컨트롤 불필요** |

### 🟠 MAJOR
| ID | 갭 | 발현 조건 | 처방 |
|----|----|----------|------|
| **L-3** | ROU_DFT 멀티+4귀토글+사이즈연동 반경 | 귀처리 상품 | `multiple:true` 컨트롤(계약 `multiple` 기존재) + attb 반경 + size→반경 cascade(roundingConfigMap 이식) |
| **L-4** | END_PAP color-chip hex 미이식 ("산출0" 오판 정정) | 색칩 상품 | 어댑터가 hex 상수맵(10색 mod_07:2511) 보유→color-chip 라우팅. **ColorChip.colorHex 이미 렌더 가능, 데이터만 주입** |
| **D-L2** | itemGroup 분기 부재 (`isBook` 휴리스틱이 대체, **clothes2025 PRINT_TYPE 분기 없음**) | 의류·오분기 | NormalizedProduct에 `itemGroup` 불투명 echo |
| **D-L3 / L-D3-1** | **침묵 PRICE=0 미차단** (어댑터 `ok:retCode===200`만) + **isReadyToOrder(서버 주문가능) 누락** | 전 상품 | 양쪽 확인됨 → canOrder가 PRICE>0 && 서버 doc_rev orderable 둘 다 게이트 |
| **L-D2-1 (P4)** | VIEW_YN 런타임 add/remove + 필수후가공 자동선택 + 연동 가격재계산 | 동적옵션 상품 | cascade를 disable전용→동적 add/remove로 확장 |
| **L-D3-5** | buildIframeSrc `cmd=create` 고정, EDIT(open)/reform 분기 누락 | 재편집 | 에디터 진입 분기 추가 |
| **L-12 (acc-order)** | ACC 부자재 분기(M1.has·$1 인스턴스) 전무 + onOptionChange 통지 미재현 | 부자재 (현 무증상) | 컨버전 단계 |
| **C-1~C-6** | 컴포넌트 내부 캐스케이드 전손실 (ROU 반경·COT disable폴백·Apparel 자동구성·PRT_WHT·DosuColor) | 의류·일부 (현 일부 무증상) | 정적파생→adapter, 동적→cascade.ts |
| **에디터 3액션** | page-count-changed(가격)·request-user-token(토큰)·prod-var-changed(커스텀탭 가격) 무처리 | 에디터 가격연동 | 핸들러 추가 |

### 🟡 MINOR / 컨버전 발현
P6 이중 debounce(결과 등가) · setLocale 액션 · deferred 액션명 불일치 · ATTB_2/3 슬롯(후니 채우면 손실)

### 🟢 개선 (Red 초과 — 유지, bug-for-bug 답습 안 함)
origin allowlist 보안 · 에디터 토큰 미보관 · PRICE=0 명시적 ok:false 의도

## S3 보정 우선순위 (D1·D4 합의)
1. **가격직결 BLOCKER**: L-1 ATTB, L-2 COT_DFT, D-L3 침묵0차단 — 실 BFF 정확성 전제
2. **현 상품군 발현 MAJOR**: L-4 color-chip, L-3 ROU_DFT, P4 VIEW_YN
3. **컨버전/미지원 발현**: L-12 ACC, C-3~C-5 의류, itemGroup, 에디터 EDIT분기

## 단순성 가드 (D4)
신규 leaf 컨트롤은 **2개만 정당화**(멀티선택 후가공, ACC 부자재 패널). 나머지는 어댑터 파생 + 직렬화 재합성 + cascade 확장으로 흡수. 계약은 대부분 슬롯 기존재(multiple·SelectionValue[]·colorHex·ATTB?) — 어댑터가 안 채우는 게 본질.

## 미완 (S2)
전 상품 분기 커버리지: itemGroup(book2025/clothes2025/vDigital/ACC) × 컴포넌트조합 전수 vs 우리 커버 — 보정 범위 확정용. 의류·부자재 전경로가 코드엔 있으나 우리 미지원·무증상이라 S2가 "어느 상품이 어느 갭에 걸리는지" 확정.
