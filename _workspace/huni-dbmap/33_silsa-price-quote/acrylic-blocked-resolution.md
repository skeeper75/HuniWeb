# 아크릴 BLOCKED 3건 마무리 정립 — Q-ACR-7·미러·코롯토/카라비너 (round-23)

> **작성** 2026-06-17 · round-23 확장 `dbm-price-arbiter`(심의자·돈-크리티컬). 입력 = `acrylic-wh-isomorph-design.md`(A1~A4 COMMIT 완료·BLOCKED 정의)·`webadmin-change-mapping-v2.md` + **webadmin `pricing.py` 코드 직접 확인** + 라이브 read-only psql + `20_price-import/acrylic/acrylic-import.xlsx`(가격표 verbatim).
> **DB 미적재 · 실 COMMIT 0** — 설계·검증까지. 실 적용 = 인간 승인. webadmin 코드 수정 0(read-only oracle).

---

## 0. 핵심 5줄

1. **Q-ACR-7 해소 = 적재 정합 확정(가격 오류 0).** `pricing.py:177-192 component_subtotal` 코드 확인: 합가형(.02) = `unit_price ÷ tier_min_qty × qty`. 아크릴 CLEAR3T는 **min_qty 전건 1** → `unit_price ÷ 1 × qty = unit_price × qty` = **단가형(.01)과 수학적으로 동일**(가격 차이 0·실증 검산). 엔진 .02 계산 구현됨·면적 구간 + .02 조합 정확 산출. ★단 잠재 가드: tier_min_qty가 0/NULL이면 ValueError raise — CLEAR3T는 전건 1이라 안전. **추가 컨펌 1건(시맨틱)**: .02 의도(왜 .01 아닌가)는 webadmin 개발자 컨펌(가격 무영향이라 LOW).
2. **미러 바인딩 = 정직 BLOCKED 유지.** `COMP_ACRYL_MIRROR3T`(37행) 단가행 실재하나 **라이브에 미러3T 본체 상품 0개**(미러 명칭 = PRD_000143 미러아크릴스티커=완제품 별 트랙·PRD_000153 골드실버명찰=use_yn=N). 미러는 본체 옵션(소재 선택)일 가능성 — CPQ 옵션레이어 전무(GAP-CPQ-ZERO)라 어느 상품이 미러 소재를 선택하는지 미확정. **바인딩 대상 상품 불명 → 공식/배선 신설 보류**(돈-크리티컬·추측 금지).
3. **코롯토 comp 신설 GO(면적매트릭스 동형).** 가격표 B06 21조합 verbatim(siz_cd 17 + GAP 4 `(미채번:GxS)`). `COMP_ACRYL_COROTTO` 신설(.01 단가형·use_dims `["siz_width","siz_height"]`·WH 동형·채번 0). 바인딩 상품 = 코롯토 4(PRD_000164/168/226/165 — 정체 컨펌).
4. **카라비너 comp 신설 설계 완료·opt_cd 채번 BLOCKED.** 가격표 B07 4형상 고정가(5800~6900). `COMP_ACRYL_CARABINER` 신설(.06 완제품비·use_dims `["opt_cd"]`·고정가형·search-before-mint=`COMP_POSTEROPT_LINEN_FINISH` opt_cd 패턴). **단 형상 opt_cd 미채번**(라이브 shape base code 0·OPV_NNNNNN 채번 필요) → opt_cd 채번 후 적재.
5. **여전한 BLOCKED**: 미러 바인딩 상품 불명(BLOCKED 유지)·카라비너 opt_cd 채번(채번 후 GO)·Q-ACR-7 .02 시맨틱 개발자 컨펌(가격 무영향·LOW)·CPQ 옵션레이어 전무(미러/소재선택 노출 선결).

---

## 1. Q-ACR-7 — 엔진 .02 계산 검증 (돈-크리티컬·코드 근거)

### 1.1 엔진 코드 확인 (pricing.py)

```python
# pricing.py:48-49
PRC_TYPE_UNIT  = "PRICE_TYPE.01"   # 단가형 = 장당가
PRC_TYPE_TOTAL = "PRICE_TYPE.02"   # 합가형 = 구간 총액

# pricing.py:177-192  component_subtotal
def component_subtotal(prc_typ, unit_price, tier_min_qty, qty):
    up = Decimal(unit_price); q = Decimal(qty)
    if prc_typ == PRC_TYPE_TOTAL:           # .02 합가형
        base = tier_min_qty or 0
        if base <= 0:
            raise ValueError("합가형 단가행에 수량구간(min_qty)이 없어 장당가 환산 불가")
        per_item = up / Decimal(base)        # 총액 ÷ 구간 min_qty = 장당가
        return per_item * q, per_item        # 장당가 × 수량
    return up * q, up                        # .01 단가형 = 단가 × 수량
```

- `_evaluate_formula`(pricing.py:409)가 comp의 `prc_typ_cd`를 읽어 `component_subtotal`에 전달. `tier_min_qty`(pricing.py:174·422·466) = `match_component`이 선택한 **min_qty 구간 임계값**.

### 1.2 아크릴 CLEAR3T 실측 + 계산 검산

| 사실 | 라이브 실측 | 엔진 계산 |
|------|------------|----------|
| CLEAR3T prc_typ | `PRICE_TYPE.02`(합가형) | `unit_price ÷ tier_min_qty × qty` |
| CLEAR3T min_qty | **전건 1**(84행) | `tier_min_qty=1` 선택 |
| → 산출 | unit_price=3,100(30×30 3T) | `3,100 ÷ 1 × qty = 3,100 × qty` |
| **.01과 비교** | — | **동일**(÷1 = 무연산) |

**골든 검산(키링 30×30 3T 100개):** `3,100 ÷ 1 × 100 = 310,000`. 단가형(.01)이라면 `3,100 × 100 = 310,000`. **차이 0.**

### 1.3 판정: **적재 정합 확정(가격 오류 0)·시맨틱 컨펌 LOW**

- **엔진 .02 구현됨**(미구현 아님)·**면적 구간(siz_width/siz_height) + .02 조합 정확 산출**(match_component이 면적축으로 행 특정 → component_subtotal이 .02 환산). A1~A4 COMMIT(siz_width/height 217행)이 .02 comp에 적재돼도 **min_qty=1이라 가격 정확**.
- **★잠재 리스크(가드 확인)**: `component_subtotal`은 .02 + `tier_min_qty ≤ 0`(NULL/0)이면 **ValueError raise → 합산 제외**(pricing.py:466-470 calc_error 경고). 아크릴 CLEAR3T는 **전건 min_qty=1**이라 이 경로 미발생. 단 A2 GAP 96 INSERT 시 **min_qty=1 명시 필수**(NULL이면 .02 환산 실패). → load-builder 가드: GAP/RU 단가행 min_qty=1(NULL 금지).
- **시맨틱 컨펌(LOW·가격 무영향)**: CLEAR3T가 왜 .01 아닌 .02인지 = round-21 wire-batch가 use_dims에 min_qty 추가하며 .02 세팅한 의도. 면적매트릭스 개당단가는 .01이 자연스러우나 **min_qty=1에선 결과 동일**이라 실청구 무영향. webadmin 개발자 컨펌(.01 정정 vs .02 유지)은 가격 무관·우선순위 LOW.

> **결론**: Q-ACR-7 **RESOLVED(가격 정합)** — 엔진 .02 계산 정확·min_qty=1로 단가형과 동일·골든 검산 일치. load-builder 가드 1건(GAP min_qty=1 명시). 개발자 컨펌 LOW(시맨틱·가격 무영향).

---

## 2. 미러 바인딩 — 상품 식별 (정직 BLOCKED 유지)

### 2.1 라이브 미러 상품 탐색 (전수)

| 후보 | prd_cd | use_yn | 판정 |
|------|--------|:--:|------|
| 미러아크릴스티커 | PRD_000143 | Y | ❌ `PRF_POSTER_ACRYLSTK_MIRROR` 바인딩(완제품 스티커 별 트랙·본체 매트릭스 아님) |
| 아크릴명찰(골드실버) | PRD_000153 | **N** | 🟡 비활성·골드/실버=미러? 정체 불명 |
| 틴거울/컴팩트거울/카드거울/사각손거울 | PRD_000183~187 | Y | ❌ 거울 완제품(아크릴 본체 매트릭스 아님·별 상품군) |
| 투명 본체 15상품 | PRD_000146~170 | Y | ❌ 소재=투명3T/1.5T(미러 아님) |

### 2.2 판정: **BLOCKED 유지 (바인딩 대상 상품 불명)**

- **라이브에 미러3T 본체 상품 0개**: 미러 명칭 상품은 전부 (a)완제품 스티커(143) (b)거울 완제품(183~187·별 상품군) (c)비활성(153). 어느 것도 `COMP_ACRYL_MIRROR3T`(가로×세로 면적매트릭스 본체) 매칭 안 됨.
- **가설**: 미러는 **본체 소재 옵션**(투명/미러 택1)일 수 있음 — 투명 본체 상품(키링 등)이 소재로 미러를 고르면 MIRROR3T 단가 적용. 그러나 **아크릴 CPQ 옵션레이어 전무**(GAP-CPQ-ZERO·option_groups/items 0)라 소재선택이 미구현 → 어느 상품이 미러를 선택하는지 **미확정**.
- **돈-크리티컬·추측 금지**: 미러 단가행(37행)은 A1에서 siz_width/height 축 전환만 완료(가치 보존). **공식(`PRF_MIRROR_ACRYL`)·배선·바인딩 신설은 보류** — 바인딩 대상 상품을 추측으로 정하면 틀린 상품에 미러 가격. **컨펌 Q-ACR-9 유지**(미러 본체 상품 식별 = 골드실버명찰 활성화? vs 투명상품 소재옵션? — 사이트/실무진).

> **결론**: 미러 **BLOCKED 유지** — 단가행 축 전환(A1)만 됨·공식/바인딩은 상품 식별 후. CPQ 소재옵션(미러 택1) 노출이 선결일 가능성(round-6 dbm-option-mapper).

---

## 3. 코롯토 comp 신설 (면적매트릭스 동형 GO)

### 3.1 가격표 verbatim (B06 코롯토 21조합)

| 출처 | 좌표 | 행수 | WH 도출 |
|------|------|:--:|---------|
| acrylic-import `5_korotto_NEW` siz_cd | SIZ_000330(30×30)=3,600 등 17 | 17 | siz_nm WxH 파싱 |
| `(미채번:GxS)` | 30×60=5,200·40×70=6,400·50×60=6,400·70×80=8,400 | 4 | siz_width=G·siz_height=S 직접 |
| **합계** | | **21** | 채번 0 |

> 라이브 korotto siz_cd 전건 clean WxH(SIZ_000493=50×30 등 §검증)·단가 = 가격표 B06 verbatim.

### 3.2 comp 신설 구조 (search-before-mint)

| 항목 | 값 | 근거 |
|------|----|------|
| comp_cd | `COMP_ACRYL_COROTTO`(신규) | 라이브 부재(search 확인)·아크릴 comp 네이밍 패턴(COMP_ACRYL_*) |
| comp_nm | 아크릴코롯토 인쇄가공비 | CLEAR3T 패턴 |
| comp_typ_cd | `PRC_COMPONENT_TYPE.01` 인쇄비 | 코롯토=인쇄가공물(CLEAR3T 동일) |
| prc_typ_cd | `PRICE_TYPE.01` 단가형 | 개당 면적단가·min_qty 무관(CLEAR3T .02 함정 회피·신규라 .01 자연) |
| use_dims | `["siz_width","siz_height"]` | **WH 동형**(siz_cd 아님·채번 0) |

### 3.3 바인딩 (코롯토 상품 → 공식)

| prd_cd | 상품명 | use_yn | → frm_cd | 비고 |
|--------|--------|:--:|---------|------|
| PRD_000164 | 아크릴코롯토 | N | `PRF_COROTTO_ACRYL`(신규) | 매트릭스 본체(nonspec Y) |
| PRD_000168 | 아크릴입체코롯토 | Y | `PRF_COROTTO_ACRYL`? | 🟡 입체=코롯토 매트릭스? 컨펌(정체) |
| PRD_000226 | 아크릴쉐이커코롯토 | N | `PRF_COROTTO_ACRYL`? | 🟡 컨펌 |
| PRD_000165 | 포카코롯토 | (미확인) | `PRF_COROTTO_ACRYL`? | 🟡 신규 발견·컨펌 |

> **GO 범위**: comp+단가행 21+공식 신설(면적매트릭스 동형·채번 0). **바인딩은 코롯토 4상품 정체 컨펌 후**(입체/쉐이커/포카가 같은 매트릭스인지 — 컨펌 Q-ACR-CO1). 활성 PRD_000168만 우선 바인딩 가능(정체 확인 시).

---

## 4. 카라비너 comp 신설 (고정가형·opt_cd 채번 BLOCKED)

### 4.1 가격표 verbatim (B07 4형상 고정가)

| 형상 | 치수 | 단가 |
|------|------|:--:|
| 사각자물쇠(자물쇠변형) | 40×69 | 5,800 |
| 하트자물쇠(하트A) | 43×71 | 5,800 |
| 하트(하트B) | 59×54 | 6,300 |
| 원형(원형B) | 68×70 | 6,900 |

> 치수(40×69 등)는 **명칭 설명용**(형상 식별)·면적축 아님(고정가형). 카라비너=투명3T+3T 접합 완제품.

### 4.2 comp 신설 구조

| 항목 | 값 | 근거 |
|------|----|------|
| comp_cd | `COMP_ACRYL_CARABINER`(신규) | 라이브 부재·아크릴 패턴 |
| comp_typ_cd | `PRC_COMPONENT_TYPE.06` 완제품비 | 접합 완제품 통가격(POSTER_ACRYLSTK .06 패턴) |
| prc_typ_cd | `PRICE_TYPE.01` 단가형 | 형상별 고정 개당단가 |
| use_dims | `["opt_cd"]` | 형상=opt_cd 분기(search-before-mint=`COMP_POSTEROPT_LINEN_FINISH` opt_cd 패턴·OPV_NNNNNN) |

### 4.3 ★opt_cd 채번 BLOCKED

- 엔진 `match_component`은 opt_cd를 **NON_QTY_DIMS 정확매칭**(pricing.py:38)으로 처리 — 형상 4종 각각 opt_cd 필요.
- **라이브 형상 base code 0**(t_cod_base_codes에 자물쇠/하트/원형 없음). opt_cd 값 형식 = `OPV_NNNNNN`(린넨마감 OPV_000025~027 선례).
- **→ 형상 4 opt_cd 채번 선행**(코드 채번 트랙·dbm-code-identifier-strategy). 채번 후 단가행 4 INSERT(comp,opt_cd,unit_price)·공식 `PRF_CARABINER_ACRYL` 신설·PRD_000166(use_yn=N) 바인딩.

> **GO 범위**: comp 구조·공식 설계 완료. **opt_cd 채번 후 적재**(채번 0 불가능 — 형상은 좌표 아닌 옵션값). PRD_000166 비활성이라 우선순위 LOW.

---

## 5. load-builder 인계 단위 + 여전한 BLOCKED 정직 분류

### 5.1 인계 단위 (신규)

| 단위 | 테이블 | 조치 | 행수 | 상태 |
|------|--------|------|:--:|------|
| **B1** Q-ACR-7 가드 | (A2 GAP 재확인) | GAP/RU 단가행 min_qty=1 명시(.02 환산 ValueError 방지) | 검증 | RESOLVED(가드) |
| **B2** 코롯토 comp | t_prc_price_components | `COMP_ACRYL_COROTTO`(.01·`["siz_width","siz_height"]`) INSERT | 1 | GO |
| **B3** 코롯토 단가행 | t_prc_component_prices | 21조합 verbatim(siz_width/height·채번 0) INSERT | 21 | GO |
| **B4** 코롯토 공식+배선 | formulas/formula_components | `PRF_COROTTO_ACRYL`+배선(disp_seq=1·addtn_yn=N) | 2 | GO |
| **B5** 코롯토 바인딩 | product_price_formulas | 코롯토 상품 → PRF_COROTTO_ACRYL | ≤4 | 🟡 정체 컨펌 후 |
| **B6** 카라비너 comp | t_prc_price_components | `COMP_ACRYL_CARABINER`(.06·.01·`["opt_cd"]`) INSERT | 1 | opt_cd 채번 후 |
| **B7** 카라비너 단가행 | t_prc_component_prices | 4형상 고정가(opt_cd) INSERT | 4 | opt_cd 채번 후 |
| **B8** 카라비너 공식+바인딩 | formulas/.../ppf | `PRF_CARABINER_ACRYL`+PRD_000166 | 3 | opt_cd 채번 후 |

### 5.2 여전한 BLOCKED / 컨펌

| ID | 항목 | 상태 | 사유·라우팅 |
|----|------|------|------|
| **Q-ACR-7** | .02 엔진계약 | ✅ **RESOLVED**(가격 정합·min_qty=1) | 가드 B1·시맨틱 컨펌 LOW(개발자) |
| **Q-ACR-9** | 미러 본체 바인딩 상품 | 🔴 **BLOCKED 유지** | 라이브 미러 본체 상품 0·CPQ 소재옵션 선결·추측 금지 |
| **Q-ACR-CARA-OPT**(신규) | 카라비너 형상 opt_cd 채번 | 🔴 **BLOCKED**(채번 선행) | 형상 4 OPV 채번(코드 트랙)·PRD_000166 비활성 LOW |
| **Q-ACR-CO1**(신규) | 코롯토 4상품 정체(입체/쉐이커/포카=매트릭스?) | 🟡 컨펌 | 바인딩 전 정체 확인(사이트/실무진) |
| **Q-ACR-7b**(신규) | CLEAR3T .02 시맨틱(.01 정정 vs 유지) | 🟢 LOW | 가격 무영향·개발자 컨펌 |
| **GAP-CPQ-ZERO** | 아크릴 CPQ 옵션레이어 전무(미러/후가공/소재선택) | 🟡 | round-6 dbm-option-mapper·미러 식별 선결 |

> **GO 범위 = 코롯토(B2~B4)·Q-ACR-7 가드(B1).** 미러(BLOCKED 유지)·카라비너(opt_cd 채번 후)·코롯토 바인딩(B5 정체 컨펌 후)은 정직 보류. **돈-크리티컬: min_qty=1 가드·미러 추측 바인딩 금지·opt_cd 채번 선행.**

---

## 6. read-only 준수

- 라이브 SELECT(미러/코롯토/카라비너 상품·CLEAR3T min_qty·opt_cd 패턴·base codes·korotto siz_nm)·**pricing.py 직접 확인**(component_subtotal .02 계산·_evaluate_formula prc_typ·match_component tier_min_qty)·acrylic-import.xlsx(코롯토/카라비너 verbatim) 직접 확인. INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 설계·검증까지 — B1~B8 멱등 SQL·DRY-RUN·게이트는 dbm-load-execution/validator·opt_cd 채번은 코드 트랙·실 COMMIT 인간 승인. webadmin 코드 수정 0.
