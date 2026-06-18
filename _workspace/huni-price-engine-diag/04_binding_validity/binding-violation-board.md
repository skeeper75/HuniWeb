# binding-violation-board — 라이브 오배선 전수 적발 (U-7)

> **Phase 3 — hped-binding-validity-designer** · 2026-06-18 · `huni-price-engine-diag/04_binding_validity`
> **기준:** comp-product-validity-matrix(유효 상품군) ↔ 라이브 `t_prc_formula_components` 배선 전수 대조.
> **판정 규칙:** 공식이 바인딩된 상품의 상품군 시트가 comp 유효목록(SOT 1)에 없으면 = 오배선.
> **라이브 읽기전용 실측(2026-06-18).** 직접 교정 금지 — 정답 데이터·재현 SQL까지. 검증=hpq quote-gate-validator 독립 재실측.

---

## 0. 요약 — 위반 전수 (D-1/2/3·D-6 외 신규 포함)

| 위반군 | 위반 comp | 영향 공식 | 영향 상품 | 배선 행수 | 발화 상태 | 기존 D-ID | 심각도 |
|--------|----------|:--:|:--:|:--:|------|:--:|:--:|
| **V-1 종이후가공→포스터 광역 오배선** | 7(오시·귀돌이직각/둥근·미싱·가변텍스트·가변이미지·별색) | **28** PRF_POSTER_* | **28** 포스터/현수막/실사/보드/액자/족자/아크릴스티커 | **196** | 대부분 dormant·일부 latent 발화 | **D-6 확장(×1→×28)** | 🔴 High |
| **V-2 종이후가공 family 이중배선** | CREASE_1L+2L+3L, VAR{TEXT,IMG}_1EA+2EA+3EA | 2 (PRF_DGP_A·D) | 10 종이상품 | (배선은 정당군 내·중복 인코딩) | **active 발화(과대청구)** | **D-1·D-2** | 🔴 High |
| **V-3 귀돌이 둥근 단가행 오염** | CORNER_RIGHT(PROC_000028 9행) | 全 CORNER_RIGHT 배선 | 38 도달 | (단가행 오염·배선 정당) | active 발화 | **D-3** | 🔴 High |
| **V-4 유광코팅 고아 배선** | COMP_COAT_GLOSSY(단가행 0) | PRF_DGP_A·E | 13 종이 | active(0원 침묵) | **D-4** | 🟡 Med |
| **V-5 디지털 S1/S2 이중키 위험** | DIGITAL_S1+S2 동일 SIZ 양키 | PRF_DGP_* | 19 | 조건부(호출측 단일키 의존) | **D-5 CONFIRM** | 🟡 Med |

> **★핵심 신규 발견(D-6의 진짜 규모):** 직전 검증(chain-defect-board)은 현수막 별색(D-6)을 **1건**으로 봤다. 라이브 전수 대조 결과 **별색을 포함한 7개 종이후가공 comp 전체가 28개 포스터 공식에 동일 블록으로 복사 배선(196행)**됨이 드러났다. D-6은 빙산의 일각 — **V-1이 단일 병인(SOT 4 제약부재)의 실제 데이터 규모**다.

---

## 1. ★V-1 — 종이후가공 7-comp 블록의 포스터 광역 오배선 (최대 위반)

### 1.1 구조 — "복사된 후가공 블록"

라이브 실측: **동일한 7-comp 후가공 블록**이 PRF_DGP_A(엽서)에서 28개 PRF_POSTER_* 공식으로 **그대로 복사**됨. 7 comp = `COMP_PP_CREASE_1L`(오시)·`COMP_PP_CORNER_RIGHT/ROUND`(귀돌이)·`COMP_PP_PERF_1L`(미싱)·`COMP_PP_VARTEXT_1EA`·`COMP_PP_VARIMG_1EA`(가변데이타)·`COMP_PRINT_SPOT_WHITE_S1`(별색). 전부 `addtn_yn='Y'`(가산).

**위반 근거(SOT 1):** authority-golden §2 — 실사/현수막/포스터 = **면적매트릭스 단가형, 소재·가로·세로뿐, 완성단가(코팅포함가), 합산 아님, 수량 무관**. 종이 후가공축(오시/귀돌이/미싱/가변데이타/별색)은 포스터 시트에 **부재**. 따라서 이 7 comp는 포스터 상품군에 **유효하지 않다**.

### 1.2 영향 공식·상품 전수 (28 공식 × 7 comp = 196 위반 배선)

| 공식 | 상품 | 상품군 | 위반 comp 수 |
|------|------|------|:--:|
| PRF_POSTER_BANNER_N | 일반현수막 | G-POSTER | 7 |
| PRF_POSTER_BANNER_M | 메쉬현수막 | G-POSTER | 7 |
| PRF_POSTER_ARTPRINT | 아트프린트포스터 | G-POSTER | 7 |
| PRF_POSTER_ARTPAPER | 아트페이퍼포스터 | G-POSTER | 7 |
| PRF_POSTER_ADH_CLEAR | 접착투명포스터 | G-POSTER | 7 |
| PRF_POSTER_ADH_WP | 접착방수포스터 | G-POSTER | 7 |
| PRF_POSTER_WATERPROOF | 방수포스터 | G-POSTER | 7 |
| PRF_POSTER_ARTFABRIC | 아트패브릭포스터 | G-POSTER | 7 |
| PRF_POSTER_CANVAS | 캔버스패브릭포스터 | G-POSTER | 7 |
| PRF_POSTER_CANVAS_HANGING | 캔버스 행잉포스터 | G-POSTER-FIX | 7 |
| PRF_POSTER_LINEN | 린넨패브릭포스터 | G-POSTER | 7 |
| PRF_POSTER_LINEN_WOODBONG | 린넨 우드봉 족자 | G-POSTER-FIX | 7 |
| PRF_POSTER_LEATHER_AP | 레더아트프린트 | G-POSTER | 7 |
| PRF_POSTER_LEATHER_FRAME | 레더아트액자 | G-POSTER-FIX | 7 |
| PRF_POSTER_MESH | 메쉬프린트 | G-POSTER | 7 |
| PRF_POSTER_MESH_BANNER | 메쉬배너 | G-POSTER-FIX | 7 |
| PRF_POSTER_TYVEK | 타이벡프린트 | G-POSTER | 7 |
| PRF_POSTER_FOAMBOARD | 폼보드 | G-POSTER-FIX | 7 |
| PRF_POSTER_FOMEXBOARD | 포맥스보드 | G-POSTER-FIX | 7 |
| PRF_POSTER_FRAMELESS | 프레임리스우드액자 | G-POSTER-FIX | 7 |
| PRF_POSTER_JOKJA | 족자포스터 | G-POSTER-FIX | 7 |
| PRF_POSTER_MINI_BANNER | 미니배너 | G-POSTER-FIX | 7 |
| PRF_POSTER_MINI_STANDBOARD | 미니보드스탠딩 | G-POSTER-FIX | 7 |
| PRF_POSTER_PET_BANNER | PET배너 | G-POSTER-FIX | 7 |
| PRF_POSTER_SHEETCUT_HOLO | 홀로그램 시트커팅 | G-POSTER | 7 |
| PRF_POSTER_SHEETCUT_MATTE | 무광시트커팅 | G-POSTER | 7 |
| PRF_POSTER_ACRYLSTK_GLOSS | 유광아크릴스티커 | G-ACRYLSTK | 7 |
| PRF_POSTER_ACRYLSTK_MIRROR | 미러아크릴스티커 | G-ACRYLSTK | 7 |
| **계** | **28 상품** | — | **196** |

> **클린 대조:** `PRF_POSTER_FIXED`(폼보드/포맥스/액자/족자 고정가 변형)는 후가공 블록 **0** — 정상. `PRF_CLR_ACRYL`(아크릴키링)도 본체 comp 1개만 — 정상. 단가형 본체 comp(`COMP_POSTER_*_완제품가`·`COMP_ACRYL_CLEAR3T`)는 전부 1상품군 귀속 정합(matrix §4).

### 1.3 발화 상태 (돈 임팩트 — latent vs dormant)

라이브 실측으로 발화 메커니즘 확정:

| comp | 단가행 차원 | 포스터 발화 조건 | 현재 상태 |
|------|-----------|----------------|----------|
| CREASE_1L·CORNER_*·PERF_1L·VARTEXT/IMG_1EA | proc_cd + dim_vals(줄수/개수), **size 차원 전부 NULL** | 포스터 selections가 proc_grp(026/029/030/085)을 제공하면 wildcard 매칭→가산 | **dormant→latent.** 포스터 CPQ는 자체 공정(.04=타공/봉미싱/열재단)만 노출(option_items 실측). 종이공정(오시/귀돌이/가변데이타) proc 미노출 → 현재 무발화. **단 운영자가 포스터에 종이공정 옵션을 추가하거나 selections에 해당 proc 유입 시 즉시 과대청구.** |
| SPOT_WHITE_S1 | plt_siz_cd·print_opt_cd **non-NULL**(530행) | 포스터 selections가 plt_siz_cd+print_opt_cd 제공 시 가산 | **dormant.** 포스터 selections는 siz_width/height만 → 차원 미스매치로 무발화(D-6 원진단과 동일). |

> **★판정:** V-1은 **현재 대부분 무발화(latent)**지만 **구조적 오배선**이다 — 제약 장치가 없어(SOT 4) 옵션/selections 한 줄만 바뀌면 196 경로가 과대청구로 전환된다. "지금 손해 없음 ≠ 정합". **정리 대상**(use_yn=N·배선 제거).

### 1.4 재현 SQL

```sql
-- 196 위반 배선 전수
SELECT fc.frm_cd, b.prd_cd, p.prd_nm, fc.comp_cd, fc.addtn_yn
FROM t_prc_formula_components fc
JOIN t_prd_product_price_formulas b ON b.frm_cd=fc.frm_cd
JOIN t_prd_products p ON p.prd_cd=b.prd_cd
WHERE fc.frm_cd LIKE 'PRF_POSTER_%'
  AND fc.comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_CORNER_RIGHT','COMP_PP_CORNER_ROUND',
    'COMP_PP_VARTEXT_1EA','COMP_PP_VARIMG_1EA','COMP_PRINT_SPOT_WHITE_S1','COMP_PP_PERF_1L')
ORDER BY fc.frm_cd, fc.comp_cd;   -- 196 rows

-- wildcard 발화 위험 입증(size 차원 NULL)
SELECT comp_cd, count(*) total,
  count(*) FILTER (WHERE plt_siz_cd IS NULL AND siz_cd IS NULL AND siz_width IS NULL AND siz_height IS NULL) no_size
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_CORNER_RIGHT','COMP_PP_VARTEXT_1EA','COMP_PP_VARIMG_1EA','COMP_PP_PERF_1L')
GROUP BY comp_cd;  -- 전부 total=no_size (size 무차원=wildcard)
```

**라우팅:** comp별 use_yn 보존(엽서 정당 배선), **포스터 공식의 7-comp 배선만 제거**(28×7=196행 DELETE from t_prc_formula_components, 단가행 보존). 메모리 [[dbmap-price-component-grouping]](통합=단가행 보존+배선축소) 정합. 실행=dbmap 위임·인간 승인.

---

## 2. V-2 — 종이후가공 family 이중배선 (D-1·D-2, intra-group)

**G-PAPER 내부 정당 배선이지만 같은 의미축을 2중 인코딩한 과대청구.** comp-product-validity상 유효 상품군(G-PAPER)에는 맞으나, **comp 간 중복**으로 가격이 부풀려진다.

| comp family | 공식 | 증상 | 발화 |
|------|------|------|------|
| CREASE_1L(줄수1/2/3 dim_vals 전부) + CREASE_2L(줄수2) + CREASE_3L(줄수3) | PRF_DGP_A·D | 줄수=2 선택 시 1L의 줄수2행 + 2L 둘 다 매칭→이중(6000→12000) | **active 과대청구** |
| VARTEXT_1EA(개수1/2/3) + 2EA + 3EA / VARIMG 동형 | PRF_DGP_A·D | 개수=2 선택 시 1EA+2EA 이중 | active |

- **정합 정답(레퍼런스):** `COMP_PP_PERF_1L`은 줄수 param 단일 comp(2L/3L **미배선**) = **정상 그룹핑**(dimension-matrix §1 단서). CREASE/VAR도 PERF처럼 1L 단일화(2L/3L 배선 제거 + 단가행 보존).
- **재현 SQL:**
  ```sql
  SELECT frm_cd, string_agg(comp_cd,',' ORDER BY comp_cd) FILTER (WHERE comp_cd LIKE 'COMP_PP_CREASE%') crease,
    string_agg(comp_cd,',' ORDER BY comp_cd) FILTER (WHERE comp_cd LIKE 'COMP_PP_VARTEXT%') vartext
  FROM t_prc_formula_components WHERE frm_cd IN ('PRF_DGP_A','PRF_DGP_D') GROUP BY frm_cd;
  -- 둘 다 1L,2L,3L / 1EA,2EA,3EA 동시 보유
  ```
- **유효성 매트릭스 연결:** 2L/3L·2EA/3EA의 유효 상품군은 G-PAPER이나 **존재 자체가 불필요**(1L이 dim_vals로 전부 표현). 정답=2L/3L·2EA/3EA comp 배선 제거(use_yn=N). 포스터엔 애초 _1L/_1EA만 갔으므로(matrix §5) V-2는 G-PAPER 한정.
- **라우팅:** D-1/D-2 동일 — dbmap [[dbmap-price-component-grouping]].

---

## 3. V-3 — 귀돌이 둥근 단가행 오염 (D-3)

**배선은 정당(귀돌이=종이 후가공·G-PAPER 유효)이나 단가행이 오염.** `COMP_PP_CORNER_RIGHT`(직각)이 PROC_000028(둥근) 단가행 9건을 오보유 → 둥근 선택 시 RIGHT+ROUND 이중.

- **유효성 관점:** comp↔상품군 유효성(본 트랙 초점)은 OK — 귀돌이는 종이 후가공. 결함은 **comp 내부 차원값 오염**(다른 트랙·dbmap 정합교정 round-13). 본 보드엔 완결성 위해 기록만.
- **재현 SQL:** `SELECT comp_cd,proc_cd,count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_PP_CORNER_RIGHT','COMP_PP_CORNER_ROUND') GROUP BY 1,2;` → RIGHT|028|9(오염).
- **라우팅:** [[dbmap-correctness-audit-round13]](단가행 정합) — 본 트랙 외.

---

## 4. V-4 / V-5 — 고아·이중키 (D-4·D-5)

- **V-4(D-4):** `COMP_COAT_GLOSSY` 단가행 0 → 유광코팅 0원 침묵. 유효 상품군(G-PAPER) 정당, 결함=data-gap(단가 누락). 라우팅=가격표 import([[dbmap-price-import-round16]]).
- **V-5(D-5 CONFIRM):** DIGITAL_S1/S2 동일 SIZ를 plt_siz_cd/siz_cd 양키 보유. 유효 상품군 정당(둘 다 G-PAPER 디지털인쇄). 위험=호출측이 양키 동시 제공 시 이중. **유효성 위반 아님**(상품군 정합)·발화는 호출측 단일키 보장 여부. 검증자 재실측 큐.

---

## 5. 비위반 확인 (clean — 위반 0 입증)

| 영역 | 라이브 실측 | 판정 |
|------|------------|:--:|
| 고정가 상품군 공식(NAMECARD/BOOKLET/STICKER/PHOTOCARD/ENV/PCB/GANGPAN/FOLD) | 각 자기 상품군 comp만(외부 comp 0) | ✅ 위반 0 |
| 면적매트릭스 본체 comp(BANNER_NORMAL·ARTPRINT_PHOTO·CANVAS_FABRIC·ACRYL_CLEAR3T) | 자기 상품군 1~4상품 귀속·sw/sh 차원 정합 | ✅ |
| PRF_DGP_B/C/E/F(종이변형) | 자기 종이 후가공(DIECUT/FOLD/PERF)만 | ✅ |
| 결합형 comp(DIGITAL/PAPER/COAT) | 종이상품군만 도달(reach 13~19, 전부 G-PAPER계) | ✅ |
| 독립형 per-product 완제품가 38종 | comp_nm 명명 상품군과 1:1 | ✅ |
| CREASE_2L/3L·VAR_2EA/3EA가 포스터로 누출? | 라이브 0건(포스터엔 _1L/_1EA만) | ✅ V-1은 _1L/_1EA 블록 한정 |

**재현 SQL:** `SELECT frm_cd, string_agg(comp_cd,',') FROM t_prc_formula_components WHERE frm_cd IN ('PRF_NAMECARD_FIXED','PRF_BIND_SUM','PRF_STK_FIXED',...) GROUP BY 1;` → 자기 comp만.

---

## 6. 검증자(P-게이트) 인계 — 독립 재실측 항목

| 위반 | 즉시 재현 | 검증 의도 | 판정 |
|------|----------|----------|:--:|
| V-1 | 196행 배선 SELECT + size차원 NULL | 포스터에 종이후가공 196 오배선 실재·wildcard 발화위험 | 결함(latent) |
| V-2 | CREASE/VAR family 1L+2L+3L 동시 | 줄수/개수=2 이중합산 발화 | 결함(active) |
| V-3 | CORNER_RIGHT PROC_000028 오염행 | 둥근 이중합산 | 결함(active, dbmap) |
| V-4 | COMP_COAT_GLOSSY 0행 | 유광 0원 침묵 | 결함(data-gap) |
| V-5 | S1+S2 양키 동시 | 호출측 단일키 여부 | CONFIRM |

> **돈 임팩트 순위:** V-2(active 과대청구·손님 손해) > V-3(active) > V-1(latent·옵션 한 줄로 활성화) > V-4(과소·회사 손해) > V-5(조건부).
> **단일 병인:** V-1·V-2 공통 = "comp↔상품 유효성 제약 부재(SOT 4)" + "후가공 블록 무차별 복사". V-1=상품군 간 오배선, V-2=상품군 내 중복배선. 둘 다 §validity-constraint-spec 정합 규칙으로 차단.
