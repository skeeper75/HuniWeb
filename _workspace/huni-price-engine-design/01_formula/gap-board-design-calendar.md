# gap-board-design-calendar.md — 디자인캘린더 갭 보드 (designer 작업 큐)

> 현 라이브 미설계/불완전 지점 + inline↔산식 정합 결함 + add-on 귀속 + 컨펌큐.
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-22 · DB 미적재(읽기전용).
> ★시트 전체 판정 = **정찰가 스냅샷 BLOCKED**(formula-map-design-calendar.md §2) → 갭의 본질은 "공식 단절"이 아니라 "inline 권위 처리 결판".

---

## 1. 갭 매트릭스

| 갭 ID | 유형 | 지점 | 현황(실측) | 위험 | 라우팅 |
|-------|------|------|-----------|------|--------|
| **G-DCAL-INLINE-BLOCKED** | inline↔산식 정합 결함 | inline 7건 합산 재현 | 유효판수 1.313/0.486/1.285/1.574/6.104 = **전부 비정수** | 추측 단가 INSERT 시 거짓 공식 | **BLOCKED·인간 컨펌**(추측 단가 금지) |
| **G-DCAL-DUAL** | 이중 정의 충돌 | 동일 prd_cd가 일반 캘린더(공식)+디자인캘린더(정찰가) 두 가격 | 일반 캘린더 PRF_CAL_* 설계 vs 디자인 inline 정찰가 | prd당 가격 2원화 → 견적 비결정 | **designer 결판**(공식 통합 vs 정찰가 병존) |
| **G-DCAL-PRICE-EMPTY** | 그릇 결손 | inline 담을 `t_prd_product_prices` | **전체 0행** | 정찰가 노출 경로 부재 | designer 결판 후 적재(인간 승인) |
| **G-DCAL-FORMULA-WIRE** | 가격사슬 단절 | 5상품 공식 바인딩 | `t_prd_product_price_formulas` 캘린더 **0건** | 견적 불가(공식·정찰가 둘 다 미배선) | 일반 캘린더 PRF_CAL_* 종단에 종속 |
| **G-DCAL-ENVELOPE** | add-on 귀속 | 캘린더봉투 2500/2400 | 독립 PRD_000005 + 본체 addon 이중역할 | 봉투를 본체가격에 합산 시 오과금 | 봉투제작 트랙 위임(일반 캘린더 Q-CAL-ENVELOPE 연계) |
| **G-DCAL-WOODSTAND** | add-on 단가 정합 | 우드거치대 4000 | 일반 캘린더 §4 우드거치대(4000)와 단가 일치 | 동일 add-on 이중 mint 위험 | 일반 캘린더 add-on comp 재사용 |
| **G-DCAL-SIZE-PRICE** | 사이즈별 가격 차이 | 탁상형 220x145=10,400 vs 130x220=9,700 | inline이 사이즈별 다른 값 | 사이즈를 단일가로 뭉개면 700원 오차 | inline 정찰가는 사이즈 단위 보존 |
| **G-DCAL-MINI-FLAT** | 동일가 다른 사이즈 | 미니 90x100=6,500 = 148x60=6,500 | 두 사이즈 같은 정찰가 | (정상·정찰가 단순화) | 정보 — 결함 아님 |

---

## 2. 컨펌큐 (인간 결판 필요)

| 큐 ID | 질문 | 권위 후보 | 영향 |
|-------|------|-----------|------|
| **Q-DCAL-AUTHORITY** | 디자인캘린더 inline 정찰가 = 견적 권위인가, 일반 캘린더 공식으로 흡수하고 폐기인가? | inline=정찰가(비정수) vs 공식(단가행) | 견적 결과 가격이 정찰가(10,400)냐 공식 합산(≠10,400)이냐 |
| **Q-DCAL-LOAD-PATH** | 정찰가를 `t_prd_product_prices` 직접단가로 적재하는가? | 엔진 PRODUCT_PRICE 경로 | 적재 시 FORMULA 우회 silent 위험 → 공식 견적과 비결정 |
| **Q-DCAL-EDITOR-SPEC** | 편집기형이라 spec(종이/인쇄/가공)이 baked·옵션 미노출인가? | CSV 메모(편집기 Y·옵션 단순) | 옵션 레이어 적재 범위 결정 |

★ inline-authority-evidence.md §3 "인간 결판 큐"와 동일 선상 — 디자인캘린더는 **inline=권위(정찰가)·산식 불가**로 이미 결판됨. 남은 결정은 "정찰가를 어느 그릇에·일반 캘린더 공식과 어떻게 공존시킬지"(designer+인간).

---

## 3. 양방향 가드 승계 점검 (공식 통합 경로 채택 시에만 발동)

| 가드 | 발동 조건 | 비고 |
|------|----------|------|
| G-CAL-PAGE | designer가 Q-DCAL-AUTHORITY를 "공식 통합"으로 결판 시 | 페이지수(30/26/12/13) 곱 누락 금지 |
| G-CAL-TWINRING-DOUBLE | 벽걸이/와이드 공식 통합 시 | 트윈링제본이 COMP_BIND_CAL_WALL에 포함 → 별도 합산 금지 |

inline BLOCKED 유지 시 두 가드 N/A(합산 자체 안 함).

---

## 4. designer 작업 우선순위

1. **Q-DCAL-AUTHORITY 결판**(인간) — 정찰가 vs 공식 통합. 모든 후속 작업의 분기점.
2. (정찰가 채택 시) `t_prd_product_prices` 그릇에 사이즈별 정찰가 적재 설계 + 엔진 PRODUCT_PRICE 경로 검증.
3. (공식 통합 채택 시) 일반 캘린더 PRF_CAL_* 종단에 디자인캘린더 5상품 흡수 + 페이지수/트윈링 가드 승계 + inline은 골든 폐기(합산 미재현).
4. add-on(봉투·우드거치대)은 어느 경로든 일반 캘린더 addon 트랙 재사용(신규 mint 금지).

★ **추측 단가 INSERT 금지 [HARD]** — 비정수 역산으로 공식 단가를 날조하면 거짓 견적. BLOCKED 정직 유지.
`확신도: 높음`
