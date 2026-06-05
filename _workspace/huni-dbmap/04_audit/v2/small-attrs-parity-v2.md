# 잔여 5속성 정합 재검증 v2 — 공정택일그룹·판형·묶음수·페이지룰·추가상품

작성 2026-06-05 · DB read-only. 1차 판정 재확인(자동 expected 산출 불가/보류 속성 포함).

---

## ① 공정택일그룹(process_select_group) — **N/A 보류 (BLOCK-3)**

- DB actual 13행, 전부 `sel_typ_cd=SEL_TYPE.01`(단일선택).
- **엑셀 원천 부재**: 택일그룹 직접 컬럼이 엑셀에 없음(공정 옵션-컬럼 구조에서 도출한 추론값). → expected 자동산출 불가.
- **추론 대조 금지(HARD)**: DB 13행 내부정합(sel_typ_cd 유효·일관)만 기술. MISSING 자동검출 대상 제외.
- 판정 = **N/A 보류**. 후니 확인(공정 옵션-컬럼=택일그룹 의도 일치 여부, 다중선택 SEL_TYPE.02 필요 상품) 필요. 1차 CONFIRM 유지.

## ② 판형사이즈(plate_size) — **CONDITIONAL (의미축 상이)**

- DB actual 509행(`siz_cd`=작업사이즈축). 엑셀 plate 값=전지(`316x467` 등).
- **속성 정의 불일치**: 엑셀=전지 vs DB=작업사이즈. 동일 자연키 공간 아님 → set 자동대조 시 전건 MISMATCH 오탐.
- C §⑥ 배제 #7대로 **set 자동대조 보류**(자동 MISSING 산출 안 함). 의미축 매핑표(전지↔작업사이즈) 확정 전 CONDITIONAL.
- 판정 = **CONDITIONAL**. 1차 유지. DB plate는 작업사이즈축 내부 정합.

## ③ 묶음수(bundle_qty) — **MAJOR (적재결손)**

- DB actual **4행 / 2상품**(PRD_000097·182 각 50·100, QTY_UNIT.03 권).
- 엑셀 묶음수 보유 상품 다수 대비 DB 2상품뿐. 1차 MAJOR(22상품 대비 결손) 재확인.
- **자동 expected 보류 사유**: 엑셀 묶음수 데이터가 명함 `Y`(플래그?)·조각수·페이지 등 의미 미확정 도메인 혼재 → 자동 expected 신뢰도 낮음(false 위험). 1차 판정(MAJOR) 유지, 의미 확정 후 정량화.
- 판정 = **MAJOR**. 후니 확인: 명함 Y 의미, 조각→QTY_UNIT 매핑, 단위유형 확정.

## ④ 페이지룰(page_rule) — **GO**

- DB actual 11행(1상품 1행, page_min/max/incr). 1차 11/11 완전 정합 재확인.
- 가변 페이지구조 상품(책자/포토북)과 1:1. MISSING/EXTRA/MISMATCH 0.
- 판정 = **GO**.

## ⑤ 추가상품(addl_product) — **MAJOR (적재결손)**

- DB actual 34행(addon_prd_cd FK). 1차 MAJOR(실addon 7 미적재 + 가격전용 4 오분류) 재확인.
- **자동 expected 보류 사유**: 엑셀 봉투명(`OPP접착봉투 110x160mm 50장`) ↔ DB addon_prd_cd 매칭이 상품명 정규화 의존(brittle, 신뢰도 C). 자동 산출 시 false 다발 위험 → 1차 판정 유지.
- 판정 = **MAJOR**. 후니 확인: 실addon 7(배너거치대·만년스탬프잉크·현수막끈·족자고리·아크릴스탠드) 적재, 가격전용 4(방수/접착방수포스터·폼보드·지비츠★) round-2 재분류.

---

## 요약

| 속성 | 판정 | 근거 | 1차 대비 |
|------|------|------|---------|
| 공정택일그룹 | **N/A 보류** | 엑셀 원천 부재(BLOCK-3) | CONFIRM 유지 |
| 판형사이즈 | **CONDITIONAL** | 의미축 상이(전지↔작업사이즈) | 유지 |
| 묶음수 | **MAJOR** | DB 2상품뿐, 엑셀 의미 미확정 | 유지 |
| 페이지룰 | **GO** | 11/11 완전정합 | 유지 |
| 추가상품 | **MAJOR** | 실addon 7 미적재, brittle 매칭 | 유지 |
