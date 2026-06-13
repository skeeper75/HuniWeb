# 코팅 시트 분해 규칙 (coating-decomposition) — round-16

> **권위:** 라이브 `t_prc_*` 실측(읽기전용) + `coating-structure.md`. **DB 미적재.** 모든 단가/배선/바인딩이 라이브에 이미 존재 → 신규 0(재현).

---

## 0. 한 줄 요약

코팅 = **2 구성요소(무광·유광)** 각각 **단가형(PRICE_TYPE.01)**. 차원 3개(`siz_cd`·`coat_side_cnt`·`min_qty`) 사용, 나머지 7차원 NULL. 가격표 184 데이터셀 ↔ 라이브 184 단가행 **무손실 1:1**. 가격사슬(디지털인쇄 PRF_DGP_A/D/E) 완결.

---

## 1. 차원 매핑 (엔진 매칭 규칙 기준)

| 가격표 축 | component_prices 차원 | 값 | 매칭 근거(§2 엔진 규칙) |
|-----------|----------------------|-----|------------------------|
| 코팅종류(무광/유광) | **`comp_cd`** | COMP_COAT_MATTE / COMP_COAT_GLOSSY | 코팅종류 = 별개 구성요소(서로 다른 단가표·use_dims). 한 공식에 둘 다 배선되고 손님 선택으로 택1 |
| 인쇄면(단면/양면) | **`coat_side_cnt`** | 1 / 2 | 코팅면수 = 신설 차원. 양면=단면 단가×2(라이브 일치) |
| 출력판형(국4절/3절) | **`siz_cd`** | SIZ_000499 / SIZ_000077 | 출력판형 = siz 차원(메모리 출력판형 매핑 원칙). round-trip 확정 |
| 수량 | **`min_qty`** | 1·2·5·…·1000000 (23 구간) | 수량구간. 주문수량 이하 최대 min_qty 구간 매칭 |
| (미사용) | `clr_cd`·`mat_cd`·`proc_cd`·`opt_cd`·`bdl_qty` | **NULL** | 코팅 단가는 색/자재/공정코드/옵션/번들 무관 → 와일드카드(과분할 금지) |

> **proc_cd 미사용 주의:** 코팅이 "공정(후가공)"이지만 `proc_cd` 차원은 **NULL**. 코팅종류 구분은 `proc_cd`가 아니라 **`comp_cd`(별개 구성요소)** 로 처리됨(라이브 실측). proc_cd 차원은 "한 구성요소 안에서 공정 종류로 단가가 갈릴 때" 쓰는 것 — 코팅은 무광/유광을 아예 다른 comp로 나눴으므로 proc_cd 불필요.

---

## 2. 단가형/합가형 판별 → **단가형(PRICE_TYPE.01)**

| 판별 근거 | 내용 |
|-----------|------|
| ① 라이브 실측 | `t_prc_price_components.prc_typ_cd = PRICE_TYPE.01`(무광·유광 둘 다) |
| ② 단가 거동 | 구간 증가에 따라 단가 **감소**(국4절 무광단면 2000→1500→1200→…→100). 합가형(구간총액)이면 단가가 증가해야 함 → 단가형 확정 |
| ③ 헤더 단위 | "수량(국4절)"별 장당 단가(매당 가격). 구간총액 표기 없음 |

→ 엔진: `매칭단가 × 주문수량`. (합가형 환산 `÷min_qty` 불필요.)

**[횡단 가드 — 라이브 .01 오적재 점검]** 셀이 구간총액이면 prc_typ는 .02여야 하나, 코팅은 §2②로 **단가형 .01이 정당**(오적재 아님). 디지털인쇄/스티커 코팅과 동일 판정.

---

## 3. use_dims (라이브 실측 일치)

```
COMP_COAT_MATTE  : use_dims = ["siz_cd", "coat_side_cnt", "min_qty"]
COMP_COAT_GLOSSY : use_dims = ["siz_cd", "coat_side_cnt", "min_qty"]
```

분해 단가행이 쓰는 차원과 **정확히 일치**. comp_typ_cd = `PRC_COMPONENT_TYPE.02`(후가공류).

---

## 4. component_prices long-form 전개

가격표 2블록 × 코팅종류 2 × 인쇄면 2 × 수량 23 = **184 데이터셀** → **184 단가행**:

| comp_cd | siz_cd | coat_side_cnt | min_qty | unit_price | clr/mat/proc/opt/bdl |
|---------|--------|---------------|---------|-----------|----------------------|
| COMP_COAT_MATTE | SIZ_000499(국4절) | 1(단면) | 1 | 2000 | NULL |
| COMP_COAT_MATTE | SIZ_000499 | 1 | 2 | 1500 | NULL |
| … (국4절 무광 단면 23행) | | | | | |
| COMP_COAT_MATTE | SIZ_000499 | 2(양면) | 1 | 4000 | NULL |
| … (국4절 무광 양면 23행) | | | | | |
| COMP_COAT_MATTE | SIZ_000077(3절) | 1 | 1 | 3000 | NULL |
| … (3절 무광 단·양면 46행) | | | | | |
| COMP_COAT_GLOSSY | … (유광 동일 구조 92행) | | | | |

행수 = MATTE 92(국4절 46 + 3절 46) + GLOSSY 92 = **184**. apply_ymd = `2026-06-01`(라이브).

---

## 5. 동시매칭 검증 (Phase11 규칙) → PASS

- 같은 (comp_cd, siz_cd, coat_side_cnt, min_qty) 조합 단가행 **유일**(자연키 중복 0, 라이브 실측 92×2=184 = 4 키조합군 × 23 / comp).
- NULL 와일드카드행과 전용행 **공존 없음**(모든 행이 siz_cd·coat_side_cnt 명시, 공통 NULL 행 없음).
- → 동시매칭 0. PASS.

---

## 6. 가격사슬 (배선 + 바인딩 라이브 실재)

| 단계 | 라이브 실재 | 상태 |
|------|------------|------|
| product_price_formulas | PRD_000016~030 등 **13 상품** → PRF_DGP_A/D/E | ✅ 바인딩 |
| formula_components | PRF_DGP_A(disp_seq 13·14)·PRF_DGP_D(3·4)·PRF_DGP_E(3·4) → COAT_GLOSSY/MATTE, addtn_yn=Y | ✅ 배선 |
| price_components | COMP_COAT_MATTE·GLOSSY 정의(prc_typ=.01·use_dims) | ✅ 정의 |
| component_prices | 184 단가행 | ✅ 단가 |

→ **가격사슬 완결**(아크릴 트랙의 "단가행 적재됐으나 배선 0" 단절과 대조 — 코팅은 끝까지 연결됨).
