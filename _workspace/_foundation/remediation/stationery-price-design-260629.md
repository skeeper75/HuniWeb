# 문구(가격포함) 8 단품 가격공식 설계 — 포토북 BASE 동형 (260629)

작성: 2026-06-29 · 읽기전용 분석 + DRY-RUN · 실 COMMIT/DDL 0
산출 SQL: `stationery-price-260629-dryrun.sql`(BEGIN/ROLLBACK·멱등·검증SELECT)
권위[HARD]: 상품마스터 260610 `문구(가격포함)` 시트 = `huni-dbmap/06_extract/stationery-l1.csv` verbatim

---

## 0. 한눈 요약

| 항목 | 값 |
|---|---|
| 대상 | 만년다이어리4·먼슬리·스프링노트·스프링수첩·메모패드·중철노트 = **8 단품**(떡메097 세트 제외) |
| 가격모델 | **고정 per-unit 단가형(.01) + 사이즈 차원 + 수량할인테이블(DSC_STAT_QTY)** = 포토북 BASE 동형 |
| 신규 공식 | 상품별 1:1 = **8** (`PRF_STN_<상품>_FIXED`) — siz 충돌로 공유 공식 불가 |
| 신규 구성요소 | 상품별 전용 = **8** (`COMP_STN_<상품>`) · comp_typ .06 · prc_typ .01 |
| use_dims | `["siz_cd","min_qty"]` (메모패드만 siz_cd 2값으로 단가 가름) |
| 신규 단가행 | **9** = 7상품×1 + 메모패드×2 (단가 verbatim·min_qty=1 단일밴드) |
| 신규 바인딩 | **8** (PRD ← PRF, apply_bgn_ymd 2026-06-06) |
| 수량할인 연결 | 6상품 **이미 적재됨**(DSC_STAT_QTY)·레더2종(174/175) **미연결=컨펌큐 Q1** |
| BLOCKED | 0 (전 8상품 단가·사이즈·할인 권위 완비) |
| DRY-RUN | 공식8·구성요소8·배선8·단가행9·바인딩8 · PK충돌0 · 멱등 · ROLLBACK |

---

## 1. 권위 매트릭스 (출처: stationery-l1.csv verbatim · 라이브 사이즈 1:1 대응)

| 상품 | prd_cd | siz_cd | 사이즈 | 단가(원/권) | 수량할인 |
|---|---|---|---|---|---|
| 만년다이어리(소프트커버) | PRD_000172 | SIZ_000375 | 130×190 | **9,000** | DSC_STAT_QTY ✅적재됨 |
| 만년다이어리(하드커버) | PRD_000173 | SIZ_000375 | 130×190 | **12,000** | (미연결·Q1) |
| 만년다이어리(레더하드커버) | PRD_000174 | SIZ_000375 | 130×190 | **15,000** | (미연결·Q1) |
| 만년다이어리(레더소프트커버) | PRD_000175 | SIZ_000375 | 130×190 | **15,000** | (미연결·Q1) |
| 먼슬리플래너 | PRD_000176 | SIZ_000170 | A5 148×210 | **12,000** | DSC_STAT_QTY ✅ |
| 스프링노트 | PRD_000177 | SIZ_000170 | A5 148×210 | **4,500** | DSC_STAT_QTY ✅ |
| 스프링수첩 | PRD_000178 | SIZ_000377 | 90×145 | **3,000** | DSC_STAT_QTY ✅ |
| 메모패드(A) | PRD_000179 | SIZ_000379 | 144×206 | **5,000** | DSC_STAT_QTY ✅ |
| 메모패드(B) | PRD_000179 | SIZ_000380 | B5 182×257 | **6,000** | (동일 상품·2행) |
| 중철노트 | PRD_000181 | SIZ_000196 | A6 105×148 | **2,500** | DSC_STAT_QTY ✅ |

가격 있는 조합 = **9 단가행**. siz_cd = 라이브 `t_prd_product_sizes` 등록값 1:1 정확 대응(실측 확인·정본 사용).

★레더소프트커버(175)는 시트상 제본 미싱(*출력+미싱) 단가 15,000 — 레더하드와 동일 단가(권위 verbatim).

---

## 2. 설계 — 왜 상품별 1:1 공식인가 (공유 공식 불가 입증)

### 2.1 핵심 제약: 같은 siz_cd가 여러 상품에 등장 → siz_cd로 단가 못 가름
- 만년다이어리 4종이 **전부 SIZ_000375**인데 단가는 9000/12000/15000/15000 상이.
- 먼슬리(176)·스프링노트(177)도 **둘 다 SIZ_000170**인데 12000/4500 상이.
- ∴ 공유 구성요소 1개 + siz_cd 차원으로는 **같은 siz_cd에 단가 1개만** 들어가 충돌(또는 ERR_AMBIGUOUS).
- **결론: 상품별 전용 공식 + 전용 구성요소 1:1** (메모리 `dbmap-price-chain-dwire-per-product-formula`
  "상품별 공식 PRF_<X> 1:1" 정합). 메모패드만 1상품에 siz_cd 2값 → 1공식 2단가행으로 가름.

### 2.2 search-before-mint
- 라이브 count 0 확인: `PRF_STN_*`·`COMP_STN_*` 기존 부재(신규 mint 정당).
- 단가형 .06/.01 = 떡메 `COMP_TTEOKME`·포토북 `COMP_PHOTOBOOK_BASE`·094 `COMP_PCB_*` 동형(재사용 패턴).
- 채번: 후니 레거시 용어 기반 이름형(PRF/COMP는 라이브에 번호형 0·이름형 100% — `PRF_TTEOKME_FIXED`·
  `COMP_TTEOKME` 동형). separator `_`. comp_price_id = MAX(40353)+1부터(IDENTITY setval은 fix.sql 정석).
- 할인: DSC_STAT_QTY 기존 재사용(신규 할인테이블 mint 0). 정률 50→5%/100→10%/500→15%/1000→20%.

### 2.3 구조 (8 상품 동형·메모패드만 2행)
```
[per-상품 완제품가 공식]  (set 아님·단품 evaluate_price)
PRF_STN_DIARY_SOFT  "만년다이어리(소프트커버) 완제품가"
  └─ COMP_STN_DIARY_SOFT (disp_seq 1, addtn_yn Y)
        comp_typ PRC_COMPONENT_TYPE.06(완제품가) · prc_typ PRICE_TYPE.01(단가형 → unit_price × qty)
        use_dims = ["siz_cd","min_qty"]
        단가행 1: siz_cd=SIZ_000375, min_qty=1, unit_price=9000
  바인딩: PRD_000172 ← PRF_STN_DIARY_SOFT (apply_bgn_ymd 2026-06-06)
... (7개 동형) ...
PRF_STN_MEMOPAD  "메모패드 완제품가"
  └─ COMP_STN_MEMOPAD
        use_dims = ["siz_cd","min_qty"]
        단가행 2: SIZ_000379→5000 / SIZ_000380→6000  (siz_cd로 가름·동시매칭 없음)
  바인딩: PRD_000179 ← PRF_STN_MEMOPAD
```

### 2.4 공식↔구성요소↔상품 매핑 표 (8공식·8구성요소·9단가행·8바인딩)
| 공식(frm_cd) | 구성요소(comp_cd) | prd_cd | 단가행(siz_cd→unit_price) |
|---|---|---|---|
| PRF_STN_DIARY_SOFT | COMP_STN_DIARY_SOFT | PRD_000172 | SIZ_000375→9000 |
| PRF_STN_DIARY_HARD | COMP_STN_DIARY_HARD | PRD_000173 | SIZ_000375→12000 |
| PRF_STN_DIARY_LHARD | COMP_STN_DIARY_LHARD | PRD_000174 | SIZ_000375→15000 |
| PRF_STN_DIARY_LSOFT | COMP_STN_DIARY_LSOFT | PRD_000175 | SIZ_000375→15000 |
| PRF_STN_MONTHLY | COMP_STN_MONTHLY | PRD_000176 | SIZ_000170→12000 |
| PRF_STN_SPRINGNOTE | COMP_STN_SPRINGNOTE | PRD_000177 | SIZ_000170→4500 |
| PRF_STN_SPRINGNOTEBK | COMP_STN_SPRINGNOTEBK | PRD_000178 | SIZ_000377→3000 |
| PRF_STN_MEMOPAD | COMP_STN_MEMOPAD | PRD_000179 | SIZ_000379→5000, SIZ_000380→6000 |
| PRF_STN_JUNGCHEOL | COMP_STN_JUNGCHEOL | PRD_000181 | SIZ_000196→2500 |

---

## 3. 엔진 계약 정합 (pricing.py 실측·E-계약)

- **단가형 .01** (`component_subtotal` pricing.py:214): `subtotal = unit_price × qty`. min_qty=1 단일밴드 →
  qty≥1이면 unit_price 그대로 per-item. base_amount = subtotal(component 1개).
- **수량할인** (`_quantity_discount` pricing.py:714): `t_prd_product_discount_tables`에서 prd_cd로 dsc_tbl_cd
  조회 → DSC_STAT_QTY 정률 → `final_price = base_amount × (1 − rate/100)`. 할인이 **공식 밖·상품 junction**에서
  적용되므로 단가행은 할인 전 정가(9000 등)로 적재(verbatim).
- **차원 자동매칭** (`match_component`): siz_cd = NON_QTY_DIM(정확매칭·행값 NULL=와일드카드). min_qty = TIER(하한).
  메모패드 2행은 손님의 siz_cd 하나만 매칭 → 단일행 → ERR_AMBIGUOUS 없음.
- **시트 차원경계(SOT 1·U-7)**: use_dims=`["siz_cd","min_qty"]`만 — 판별차원 siz_cd가 있어 항상매칭 위반 없음.
  상품별 전용 comp이므로 타상품 단가행 silent 합산 불가(공유 comp 회피가 U-7 핵심 준수).
- **손님 siz_cd 미선택**: 상품당 사이즈 1개(메모패드 2개)뿐이라 위젯이 단일 선택 → 매칭 확정.

---

## 4. 수기 검산표 (설계 단가행 ↔ 권위·엔진 재현)

단가형 .01: `base = unit_price × qty`. 할인 = DSC_STAT_QTY(50→5%/100→10%/500→15%/1000→20%·1~49=0%).

| 상품 | siz_cd | qty | base(=단가×qty) | 할인밴드 | rate | final_price | 권위 근거 |
|---|---|---|---|---|---|---|---|
| 만년다이어리 하드 PRD_000173 | SIZ_000375 | 1 | 12,000 | 1~49 | 0% | **12,000** | 단가 12000 verbatim |
| 만년다이어리 하드 PRD_000173 | SIZ_000375 | 100 | 1,200,000 | 100~499 | 10% | **1,080,000** | 12000×100×0.9 |
| 만년다이어리 소프트 PRD_000172 | SIZ_000375 | 50 | 450,000 | 50~99 | 5% | **427,500** | 9000×50×0.95 |
| 먼슬리플래너 PRD_000176 | SIZ_000170 | 1 | 12,000 | 1~49 | 0% | **12,000** | 단가 12000 |
| 스프링노트 PRD_000177 | SIZ_000170 | 1000 | 4,500,000 | 1000+ | 20% | **3,600,000** | 4500×1000×0.8 |
| 스프링수첩 PRD_000178 | SIZ_000377 | 4 | 12,000 | 1~49 | 0% | **12,000** | 단가 3000×4(min_qty=4·incr4) |
| 메모패드 PRD_000179 | SIZ_000379 | 1 | 5,000 | 1~49 | 0% | **5,000** | 144×206 단가 5000 |
| 메모패드 PRD_000179 | SIZ_000380 | 1 | 6,000 | 1~49 | 0% | **6,000** | B5 단가 6000 |
| 중철노트 PRD_000181 | SIZ_000196 | 4 | 10,000 | 1~49 | 0% | **10,000** | 2500×4 |

★레더 174/175는 할인 미연결이라 qty 무관 rate 0%(컨펌큐 Q1) → 단가×qty 그대로. 15000×qty.

→ 골든값은 `golden-cases.md` 동기화. COMMIT 후 시뮬레이터 simulate 실호출로 재현 검증(OI-SIM).

---

## 5. 열린 이슈 / 컨펌큐

| # | 이슈 | 영향 | 경로 |
|---|---|---|---|
| **Q1** | 레더 만년다이어리 2종(174/175) 수량할인 **미연결** | qty 100권도 정가(15000×qty) = 타 문구 대비 할인 없음 | 권위 시트=174/175 `구간할인적용테이블` **빈칸**(verbatim 미지정)·172는 `문구 구간할인` 명시. → 권위대로 **미연결 유지**(자동주입 금지)가 정설. 단 의도 확인 필요(컨펌). 연결 원하면 junction 2행 추가만(설계 변경 0) |
| OI-SIM | 실 simulate 가격검증 미수행 | DRY-RUN 미COMMIT이라 시뮬레이터(별 connection)서 안 보임 | COMMIT 후 사람이 simulate 실호출(§4 골든 재현)·배치 채점(score_batch general)으로 OK 확인 |
| OI-2 | 메모패드 사이즈 선택 UX | 손님이 2사이즈 중 택1 | 위젯 사이즈 드롭다운(이미 t_prd_product_sizes 2등록)·엔진 정합(단일매칭) |
| OI-3 | 스프링노트(177)=PRD_TYPE.02(반제품) | 세트 부모 없음 → 단품 가격 필요 | 본 설계로 단품 가격 작동(evaluate_price 단독). prd_typ 분류는 SOT 트랙 별개(가격엔 무영향) |

---

## 6. 안전 준수
- 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL/INSERT-COMMIT 0. webadmin 코드수정 0.
- 단가 = 권위 시트(260610) verbatim(날조 0). 빈칸=미지정(Q1 자동주입 금지).
- search-before-mint: DSC_STAT_QTY 재사용·신규 할인 0. 상품별 PRF/COMP 8쌍 신규(공유 불가 입증).
- 정본 siz_cd 사용(라이브 등록값 1:1·이번 세션 silsa 중복본 오적재 교훈 회피).
