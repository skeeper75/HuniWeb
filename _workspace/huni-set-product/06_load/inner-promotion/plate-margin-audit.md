# 판형 여백(출력가능영역 마진) 적재 정확성 감사 — t_siz_sizes / fn_calc_pansu

**감사일**: 2026-06-26 · **모드**: 라이브 읽기전용 SELECT only · DB 미적재(진단·교정명세까지)
**감사 대상 함수**: `fn_calc_pansu(plate, item)` (raw/webadmin/sql/32_fn_calc_pansu.sql)
**핵심 가설**: 여백 NULL/0 → COALESCE(...,0) → 사용가능영역 과대 → 판걸이수(pansu) 과대 → **과소청구(underbilling)**

---

## 0. 결론 요약 (TIGHT VERDICT)

- **판형 여백은 "돈 경로"에 한해서는 정확히 적재되어 있다.** `fn_calc_pansu`가 실제로 호출되는 단가행은 **단 2개 판형(SIZ_000499 국4절, SIZ_000077)** 만 사용하며, 둘 다 여백이 제대로 적재됨(국4절 5/5/5/5, 077 2/2/2/2). **과소청구 결함 0건.**
- **우리 072 inner/cover 경로(국4절 SIZ_000499)는 안전(CLEAN).** work 316×467, margin 5/5/5/5 → 사용가능 306×457. 프롬프트 검증값(국4절×A5내지=pansu 4) 라이브 재현 일치.
- **여백 누락은 대량(229행)이나 전부 비활성 판형**: t_prd_product_plate_sizes에 등록된 ~246 사이즈 중 **227건이 여백 0/NULL(impos_yn=N)**, **2건이 여백 0/NULL인데 impos_yn=Y**(A2 SIZ_000198, A1 SIZ_000294). 그러나 이 판형들은 단가행(component_prices) plt_siz_cd 자리에 **단 한 행도 적재돼 있지 않아** `fn_calc_pansu`의 돈 경로에 진입하지 못한다 → 과소청구 0.
- **근본원인(적재로직)**: `08_size_dims_fix.sql`(tools/fix_size_dims.py)가 work/cut NULL 행을 siz_nm 파싱으로 채울 때 **work=cut, 여백 미설정(NULL)** 으로 일괄 채움. 여백은 전지류·A3/A4/A5 등 소수 큐레이션 행에만 수동 적재됨. → "여백 없는 사이즈"가 디폴트 상태가 된 원인.

**한 줄**: 판형 여백은 활성 단가경로(국4절·077)에 정확히 적재됨 → 과소청구 없음. 우리 072(국4절) 경로 안전. 나머지 여백 누락은 단가행 부재로 비활성(돈 영향 0)이나, 향후 판형 채택 시 함정이므로 위생 교정 권고(인간 승인 후).

---

## 1. 판형으로 쓰이는 사이즈 식별 (두 출처)

| 출처 | 결과 |
|---|---|
| **t_prc_component_prices.plt_siz_cd** (실제 단가행 = 돈 경로) | **SIZ_000499 (1,357행), SIZ_000077 (258행)** — 이 둘 뿐. 전수 스캔 결과 그 외 plt_siz_cd 값 없음(빈 결과 확인) |
| **t_prd_product_plate_sizes.siz_cd** (상품 판형 등록) | ~246 distinct 사이즈. 대부분 1상품에만 등록(잡다한 완제/내지 사이즈 포함) |

**핵심 구분**: `fn_calc_pansu`의 판형 슬롯에 실제로 들어가 단가를 끌어오는 것은 단가행에 plt_siz_cd가 적재된 사이즈뿐. 단가행이 없는 등록 판형은 가격엔진이 매칭할 행이 없어(0원/누락) **과소청구가 아니라 가격누락 경로**다.

**가격엔진 동작 근거** (raw/webadmin/webadmin/catalog/pricing.py):
- L561 `needs_plate = any("plt_siz_cd" in use_dims for c in comps)` — plt_siz_cd 차원 구성요소가 있을 때만 pansu 계산
- L562 `plate = selections.get("plt_siz_cd")` — 선택된 판형
- L564 `pansu = _calc_pansu(plate, item_siz) if needs_plate else None`
- 단가 매칭은 plt_siz_cd 차원으로 component_prices를 조회 → 해당 plt_siz_cd 단가행이 없으면 매칭 실패(가격 0/제외)

---

## 2. 판형 사이즈 × {work, cut, margin, impos_yn, del_yn} 판정표

### 2-A. 활성 판형 (단가행 보유 = 실제 돈 경로) — **둘 다 CLEAN**

| siz_cd | siz_nm | work | cut | margin(T/B/L/R) | impos_yn | 단가행수 | 판정 |
|---|---|---|---|---|---|---|---|
| SIZ_000499 | 316x467 (국4절) | 316×467 | 306×457 | 5/5/5/5 | Y | 1,357 | **OK** |
| SIZ_000077 | 300x625 | 304×629 | 300×625 | 2/2/2/2 | Y | 258 | **OK** |

> work > cut, 여백 일관 적재. fn_calc_pansu 사용가능영역 = 국4절 306×457, 077 300×625. 정상.

### 2-B. impos_yn=Y 판형 (임포지션 의도) 전수 — 여백 누락 2건이나 비활성

| siz_cd | siz_nm | work | cut | margin | 단가행수 | 판정 |
|---|---|---|---|---|---|---|
| SIZ_000052 | A3 (297x420) | 303×426 | 297×420 | 3/3/3/3 | 0 | OK(여백 있음, 단 비활성) |
| SIZ_000198 | A2 (420x594) | 420×594 | 420×594 | **NULL** | **0** | **MARGIN-MISSING + WORK==CUT (비활성)** |
| SIZ_000294 | A1 (594x841) | 594×841 | 594×841 | **NULL** | **0** | **MARGIN-MISSING + WORK==CUT (비활성)** |
| SIZ_000499 | 316x467 | 316×467 | 306×457 | 5/5/5/5 | 1,357 | OK |
| SIZ_000521 | 330x470 | 330×470 | 320×460 | 5/5/5/5 | 0 | OK(여백 있음, 비활성) |
| SIZ_000522 | 315x467 | 315×467 | 305×457 | 5/5/5/5 | 0 | OK(여백 있음, 비활성) |

### 2-C. 전체 등록 판형 여백 상태 분포 (t_prd_product_plate_sizes)

| 상태 | impos_yn | 건수 |
|---|---|---|
| HAS-MARGIN | Y | 4 |
| HAS-MARGIN | N | 13 |
| MARGIN-ZERO/NULL | Y | **2** (= A2, A1) |
| MARGIN-ZERO/NULL | N | **227** |

> 227건의 impos_yn=N 여백누락은 대부분 완제/내지/케이스 사이즈가 product_plate_sizes에 등록된 것(판형 본연 아님)이거나, 소형 사이즈가 판형으로 등록된 케이스. 어느 것도 단가행 plt_siz_cd 자리에 적재돼 있지 않아 돈 경로 미진입.

---

## 3. 결함 보드 (Defect Board)

| ID | siz_cd | 결함 | impos_yn | 단가행 영향 | 상품 영향 | 돈 영향 | 심각도 |
|---|---|---|---|---|---|---|---|
| D1 | SIZ_000198 (A2) | 여백 NULL + work==cut | Y | **0행** | 포스터/스티커 18상품 등록(전부 면적매트릭스 가격, pansu 미사용) | **없음** (단가행 0 → fn_calc_pansu 돈 경로 미진입) | Low(위생) |
| D2 | SIZ_000294 (A1) | 여백 NULL + work==cut | Y | **0행** | 포스터 12상품 등록(면적매트릭스) | **없음** | Low(위생) |
| D3 | SIZ_000113/114/115/118 | 여백 0 + work==cut, dflt_plt_yn=Y, 투명엽서 등록 | N | **0행** | PRD_000019 투명엽서(SIZ_000499도 함께 등록=정상 단가경로 존재) | **없음** (이 판형들 단가행 0) | Low(위생) |
| D4 | SIZ_000195 | 여백 0 + work==cut, dflt, 썬캡 등록 | N | **0행** | PRD_000051 썬캡(이 판형만 등록) | **없음** (단가행 0 = 가격누락 가능성, 단 과소청구 아님) | Low |
| D5 | SIZ_000077 | (참고) 단가행 258행 보유하나 t_prd_product_plate_sizes 미등록 | Y | 258행 | 어느 상품도 판형목록에 077 미등록 | 바인딩 갭(여백 결함 아님) | Info |

**과대청구→과소청구 비율 정량화**: 활성 판형(499/077) 모두 여백 정상이므로 **과소청구 발생 단가행 0건, 과소청구 비율 0%**. A2/A1 가상 시뮬(100×148 아이템): 여백 NULL이든 3mm든 pansu 12=12로 동일(소형 아이템에선 차이 무발생) — 게다가 단가행이 없어 실제 영향 자체가 성립 안 함.

---

## 4. 국4절(우리 072 경로) 및 형제 판형 청결성

- **국4절 SIZ_000499 = CLEAN**: work 316×467, margin 5/5/5/5 → 사용가능 306×457. `fn_calc_pansu('SIZ_000499','SIZ_000007')` = **4** (라이브 재현, 프롬프트 검증값 일치). 072 inner/cover는 이 판형을 쓰므로 **안전**.
- **전지류 형제 일관성**: 국4절(SIZ_000499 5mm), 형제 SIZ_000521(330x470 5mm)·SIZ_000522(315x467 5mm) 모두 5mm 일관 적재. A3(SIZ_000052 3mm)도 적재. → 임포지션 의도가 있고 단가/실무 경로에 들어가는 전지/판형류는 여백이 일관 적재됨.
- **불일치 1건(전지 의도지만 누락)**: A2(SIZ_000198)·A1(SIZ_000294)만 5mm 형제군과 달리 여백 NULL — 다만 단가행 0이라 돈 영향 없음. 향후 대형 포스터를 pansu 가격으로 전환하면 함정이 되므로 위생 교정 대상.

---

## 5. 근본원인 (적재로직 재구성)

- **여백 미적재의 진원** = `raw/webadmin/sql/08_size_dims_fix.sql` (tools/fix_size_dims.py 생성): work/cut가 모두 NULL인 행을 siz_nm 파싱으로 채울 때 **work=cut=파싱치수, 여백 컬럼은 손대지 않음(NULL 유지)**. 따라서 자동 채움된 사이즈는 전부 work==cut·여백 NULL 상태가 디폴트. 여백은 별도 수동 큐레이션 행(전지류·A3/A4/A5)에만 존재.
- **활성 판형이 깨끗한 이유** = `35_plate_dim_remap.sql`(Phase 11.4) + 전지 등록 작업에서 SIZ_000499/077/521/522/052 등 실제 단가경로 판형은 여백을 명시 적재. 즉 "돈이 흐르는 판형"은 의도적으로 정리됨.
- 결론: 적재로직 결함은 "전수 여백 미부여(fix_size_dims가 여백을 안 씀)"이나, **활성 판형 한정 후속 큐레이션으로 돈 경로는 차단됨**. 남은 누락은 잠재적 위생 부채.

---

## 6. 교정 명세 (DB 미적재 · 인간 승인 후 dbmap/basedata-dedup 위임)

> 어느 것도 현재 과소청구를 일으키지 않으므로 **선택적 위생 교정**. 활성 단가경로 변경 없음.

| 대상 siz_cd | 무엇 | 어떻게(verbatim 출처) | 라우팅 |
|---|---|---|---|
| SIZ_000198 (A2) | margin_top/bot/lft/rgt = 3 (A3 SIZ_000052와 동일 정책) 또는 5(전지류) | 형제 전지(499/521/522=5mm)·A3(052=3mm) 정책 중 실무 확인 후 verbatim. **🔴 컨펌 필요** | dbm-axis-staged-load(siz 축), 인간 승인 |
| SIZ_000294 (A1) | 동상(A2와 동일 정책) | 상동 | 동상 |
| SIZ_000113/114/115/118 (투명엽서 판형) | 판형 본연 여부 확인 → 판형이면 여백 부여, 아니면 product_plate_sizes 등록 del_yn 정리(비파괴 논리삭제) | 실무 확인 | dbmap, 인간 승인 |
| SIZ_000195 (썬캡 판형) | 단가행 0 = 가격누락 별도 트랙. 여백보다 단가 적재가 선결 | — | hcc/가격 트랙 |
| SIZ_000077 | (여백 결함 아님) product_plate_sizes 미등록 = 선택불가 판형인데 단가행 존재. 바인딩 갭 점검 | — | dbmap 바인딩 점검 |

---

## 7. 🔴 컨펌 질문

1. **A2(SIZ_000198)·A1(SIZ_000294)의 인쇄 물림여백 mm 값** = 3mm(A3 정책) / 5mm(전지류 정책) 중 무엇인가? (현재는 단가행 0으로 돈 영향 없음 — 향후 포스터 pansu 가격 도입 시에만 필요)
2. **SIZ_000113/114/115/118(투명엽서)·SIZ_000195(썬캡)** 은 실제 "판형"인가, 아니면 완제품 사이즈가 product_plate_sizes에 잘못 등록된 것인가? (판형이 아니면 등록 논리삭제가 정답)

---

## 재현 SELECT (비밀값 없음)

```sql
-- 활성 판형 식별 (돈 경로)
SELECT plt_siz_cd, count(*) FROM t_prc_component_prices
WHERE plt_siz_cd IS NOT NULL GROUP BY plt_siz_cd;        -- => SIZ_000499, SIZ_000077 뿐

-- 활성 판형 여백 검증
SELECT siz_cd, siz_nm, work_width, work_height, cut_width, cut_height,
       margin_top, margin_bot, margin_lft, margin_rgt, impos_yn
FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000499','SIZ_000077');

-- 국4절×A5 내지 판걸이수 재현 (=4)
SELECT fn_calc_pansu('SIZ_000499','SIZ_000007');

-- impos_yn=Y 등록판형 여백 누락 적발
SELECT s.siz_cd, s.siz_nm, s.margin_top
FROM (SELECT DISTINCT siz_cd FROM t_prd_product_plate_sizes WHERE COALESCE(del_yn,'N')='N') p
JOIN t_siz_sizes s ON s.siz_cd=p.siz_cd WHERE s.impos_yn='Y';
```
