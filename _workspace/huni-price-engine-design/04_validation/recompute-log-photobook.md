# recompute-log-photobook.md — 포토북 골든 재계산 로그 (E6)

> **hpe-validator 독립 재계산 — 설계값 비사용·권위 CSV verbatim 직독·pricing.py 동치 재구현.**
> 골든 출처[순환참조 금지]: 상품마스터260610 `포토북(가격포함)` 시트 `photobook-l1.csv`(`24_master-extract-260610/`) 셀 직독 base24/per2p + row17 명문 산식.
> 재계산 엔진 = pricing.py `component_subtotal`(단가형 .01 = `unit_price × qty`·:191-192) + row17 `base24×Q + per2p×ceil((N−base_min)/2)×Q`.
> 라이브 단가행(COMP_BIND_PUR·COMP_PAPER·COMP_COAT_MATTE) = 실측(아래 §3).

---

## 0. 재계산 방법 (순환참조 차단)

1. **base24/per2p를 설계서가 아닌 권위 CSV에서 직독**(`photobook-l1.csv` 행 3~14·`가격_기본(24P)`·`가격_추가(2P)당`). 설계가 만든 값으로 골든 만들지 않음.
2. **pricing.py 동치 재구현**: 단가형(.01) `subtotal = Decimal(unit_price) × Decimal(qty)`(:191-192) + row17 산식(증분횟수=`math.ceil((N−base_min)/2)`·앱 ceil).
3. python 독립 산출 vs 설계 기대값(상품마스터 verbatim) 수치 대조(허용오차 0).

### 권위 CSV 직독 결과 (verbatim·날조 0 검증)

| (사이즈, 표지) | base24 | per2p | 설계 단가행(§4.1·4.2) | 일치 |
|----------------|-------:|------:|----------------------|------|
| 8x8 하드커버 | 15,000 | 500 | 15,000 / 500 | ✅ |
| 8x8 레더하드커버 | 23,000 | 500 | 23,000 / 500 | ✅ |
| 8x8 소프트커버 | 12,000 | 500 | 12,000 / 500 | ✅ |
| 10x10 하드커버 | 22,000 | 1,000 | 22,000 / 1,000 | ✅ |
| 10x10 레더하드커버 | 32,000 | 1,000 | 32,000 / 1,000 | ✅ |
| 10x10 소프트커버 | (공란) | (공란) | BLOCKED(row8) | ✅ |
| A5 하드커버 | 12,000 | 300 | 12,000 / 300 | ✅ |
| A5 레더하드커버 | 19,000 | 300 | 19,000 / 300 | ✅ |
| A5 소프트커버 | 10,000 | 300 | 10,000 / 300 | ✅ |
| A4 하드커버 | 16,000 | 600 | 16,000 / 600 | ✅ |
| A4 레더하드커버 | 26,000 | 600 | 26,000 / 600 | ✅ |
| A4 소프트커버 | 13,000 | 600 | 13,000 / 600 | ✅ |

**설계 단가행 = 상품마스터 inline verbatim 전건 일치(날조 0).** base24=`[siz,mat]` 2차원·per2p=`[siz]` 1차원(8x8/10x10/A5/A4 = 500/1000/300/600·표지 무관) 정확.

---

## 1. 골든 재계산 (GC-PB-1~10·python 독립 산출·허용오차 0)

산식: `price = round_won(base24×Q + per2p × ceil((N−base_min)/2) × Q)`

| 골든 | 사이즈 | 표지 | N | Q | base_min | base24 | per2p | incr | **재현값** | 기대값 | 결과 |
|------|--------|------|---|---|---------|-------:|------:|-----:|----------:|-------:|------|
| GC-PB-1 | 8x8 | 하드 | 24 | 1 | 24 | 15,000 | 500 | 0 | **15,000** | 15,000 | **PASS** |
| GC-PB-2 | 8x8 | 레더하드 | 24 | 1 | 24 | 23,000 | 500 | 0 | **23,000** | 23,000 | **PASS** |
| GC-PB-3 | A5 | 소프트 | 4 | 1 | **4** | 10,000 | 300 | 0 | **10,000** | 10,000 | **PASS**※ |
| GC-PB-4 | A4 | 하드 | 24 | 1 | 24 | 16,000 | 600 | 0 | **16,000** | 16,000 | **PASS** |
| GC-PB-5 | 8x8 | 하드 | 40 | 1 | 24 | 15,000 | 500 | 8 | **19,000** | 19,000 | **PASS** |
| GC-PB-6 | A4 | 레더하드 | 50 | 1 | 24 | 26,000 | 600 | 13 | **33,800** | 33,800 | **PASS** |
| GC-PB-7 | 8x8 | 하드 | 150 | 1 | 24 | 15,000 | 500 | 63 | **46,500** | 46,500 | **PASS** |
| GC-PB-8 | 10x10 | 하드 | 40 | 1 | 24 | 22,000 | 1,000 | 8 | **30,000** | 30,000 | **PASS** |
| GC-PB-9 | A5 | 하드 | 40 | 1 | 24 | 12,000 | 300 | 8 | **14,400** | 14,400 | **PASS** |
| GC-PB-10 | 8x8 | 하드 | 40 | 10 | 24 | 15,000 | 500 | 8 | **190,000** | 190,000 | **PASS** |

**GC-PB-1~10 전건 PASS (허용오차 0).**

※ GC-PB-3은 `base_min=4`(소프트커버 시트 페이지 `4/6/8/10/12/14` 권위) 가정으로 재현. 라이브 page_rule은 부모 PRD_000100만 24/150/2 보유·소프트 base_min=4는 라이브 미저장(아래 Q-PB-PAGEBASE) → **조건부 PASS(소프트 base_min=4 인간 컨펌 후 확정)**. 24P 기준 오적용 시 소프트 페이지 증분 시작점 오류(§2 돈크리티컬).

---

## 2. 돈크리티컬 가드 재계산 입증

### G-PB-PAGE (페이지 곱 누락 = 내지비 소실)
- GC-PB-7: 정답 **46,500** vs 페이지 곱 누락 시 base24만 = **15,000** → 32.3%(**3.1배 과소청구**). per2p×63×1 = 31,500 소실. **돈크리티컬 입증.**

### GC-PB-10 양방향 (base24·per2p 둘 다 ×부수)
- 정답 (15,000+4,000)×10 = **190,000**. base만 ×부수 오답 = 150,000+4,000 = **154,000**(per2p 부수 누락). 둘 다 ×Q 정합.

### Q-PB-PAGEBASE (소프트 base_min 24 오적용·돈크리티컬·미해소)
- 소프트 A5 14P: base_min=4 → incr=5 → **11,500** / base_min=24 → incr=0 → **10,000** → **1,500원 차이**(N 커질수록 확대). 라이브 page_rule에 소프트 base_min=4 미저장(부모 24/150/2만) → **honest 미해소 컨펌큐 정당**.

### GC-PB-11 (10x10 소프트·row8 공란) BLOCKED 정당
- CSV row8 `가격_기본/추가` 공란 실측 확인. 보간 후보 8x8=12,000 / A5=10,000 / A4=13,000 = **비단조** → 10x10 보간은 추측. **추측 INSERT 금지·BLOCKED 정직 옳음.**

### GC-PB-12 (base24 부품 역산) 부분 BLOCKED 정당
- base24=완제 통합값(권위 verbatim). 부품 정확 역산(표지 코팅/면지 단가 직매칭)은 미권위 → 통째 적재로 골든 GC-PB-1~10 재현되므로 부품 분해 불요. honest 부분 BLOCKED.

---

## 3. 라이브 단가행 실측 (재사용 comp·verbatim 대조)

```
-- COMP_BIND_PUR (제본 PUR·base24 internalize·외부 미배선)
SELECT comp_cd,prc_typ_cd,use_dims,del_yn FROM t_prc_price_components WHERE comp_cd='COMP_BIND_PUR';
  COMP_BIND_PUR | PRICE_TYPE.01 | ["proc_cd","min_qty","proc_grp:PROC_000017"] | del_yn=Y  ★논리삭제
SELECT comp_cd,proc_cd,min_qty,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_BIND_PUR' ORDER BY min_qty;
  PROC_000020 q1=5000 / q4=5000 / q10=5000 / q30=4000 / q50=3000 / q70=2500 / q100=2000 / q1000=1500  (8행·verbatim)
SELECT frm_cd FROM t_prc_formula_components WHERE comp_cd='COMP_BIND_PUR';  → 0행(어느 공식에도 미배선=internalize 정합)

-- COMP_PAPER (내지·표지 용지)
SELECT comp_cd,mat_cd,siz_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND mat_cd IN ('MAT_000105','MAT_000081');
  COMP_PAPER | MAT_000105(몽블랑130) | SIZ_000499 | 77.03   ✅
  COMP_PAPER | MAT_000081(아트지250) | SIZ_000499 | 77.75   ✅ ★cartographer "아트250 0행" stale 정정 확인

-- COMP_COAT_MATTE (표지 무광코팅·★설계 stale 정정 #2 확인)
SELECT comp_cd,prc_typ_cd,use_dims,del_yn FROM t_prc_price_components WHERE comp_cd='COMP_COAT_MATTE';
  COMP_COAT_MATTE | PRICE_TYPE.01 | ["siz_cd","coat_side_cnt","min_qty"] | del_yn=N
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_COAT_MATTE';  → 92행  ★comp 존재 AND 단가행 충전 확인(E1 핵심)
```

**설계 §0.1 stale 정정 2건 독립 확인**: ① 아트250 용지 단가행 실재(77.75) ② COMP_COAT_MATTE 실재 + 단가행 92행 충전. 단 둘 다 base24에 internalize되어 직접 배선 안 함(외부 노출 0)이라 골든 재현에는 무영향(base24 통째).

---

## 4. 결론

- **GC-PB-1~10 허용오차 0 재현**(권위 CSV verbatim·pricing.py 동치·순환참조 0).
- 단가행 = 상품마스터 inline verbatim 전건 일치(날조 0).
- GC-PB-3(소프트)만 base_min=4 가정 의존 → 조건부 PASS(Q-PB-PAGEBASE 컨펌). GC-PB-11/12 BLOCKED 정직.
- 돈크리티컬 G-PB-PAGE(3.1배)·양방향·Q-PB-PAGEBASE(1,500원~) python 재계산 입증.
