# FINDING — digital PRICED-0 6건 개별 진단 (round-13 라이브 정합 교정)

> 2026-06-29. 빌드스크립트(score_batch) 전수 sweep 가 `PRICED-0`(공식 있는데 0원=진짜 결함)로
> 적발한 디지털인쇄 6건을 라이브 읽기전용으로 종단 진단. 권위=인쇄상품가격표260527·상품마스터260610.
> 라이브=교정 대상. 실 COMMIT 인간 승인. 값 날조 0(미상=BLOCKED, 추정 교정 금지).

## 결론 요약 (6건 분류)

| # | 상품 | 공식 | 근본원인 | 분류 | 교정방향 | 돈영향 |
|---|------|------|----------|------|----------|--------|
| 1 | 투명포토카드025 (PRD_000025) | PRF_PHOTOCARD_CLEAR | **bundle_qtys 행 누락** (bdl_qty=20 미적재) | MIS-LOADED(MISSING) | 형제 024 패리티로 bundle_qtys 1행 INSERT | 0 → 170,000(qty20) |
| 2 | 썬캡051 (PRD_000051) | PRF_DGP_F | **신규·미출시 상품·권위 가격데이터 부재**(출력용지규격 공란·MES 없음·"Figma 참고") | BLOCKED(AMBIGUOUS) | 교정 불가(권위 없음)·인간 확인 | 산정 불가 |
| 3 | 2단접지카드027 (PRD_000027) | PRF_DGP_E | **SIZ_000124(150x100) work_width/height NULL** → fn_calc_pansu NULL | MIS-LOADED(데이터) | work 치수 충전(형제 패리티) | SIZ_000124만 0 → 정상 |
| 4 | 미니접지카드028 (PRD_000028) | PRF_DGP_E | **SIZ_000133(86x52) work_width/height NULL** → fn_calc_pansu NULL | MIS-LOADED(데이터) | work 치수 충전(형제 패리티) | SIZ_000133만 0 → 정상 |
| 5 | 3단접지카드029 (PRD_000029) | PRF_DGP_E | **SIZ_000124(150x100) work NULL**(027과 동일 공유코드) | MIS-LOADED(데이터) | #3 교정에 포함(같은 siz_cd) | SIZ_000124만 0 → 정상 |
| 6 | 모양엽서023 (PRD_000023) | PRF_DGP_B | **SIZ_000119(90x90) work_width/height NULL** → fn_calc_pansu NULL | MIS-LOADED(데이터) ★프롬프트의 C트랙 가설 반증 | work 치수 충전(형제 패리티) | 0 → 정상 |

**교정 가능 = 4건(데이터)** [#1 bundle_qtys / #3·#4·#5·#6 work 치수 — 공유 siz_cd 3종]
**BLOCKED = 1건** [#2 썬캡051 권위 부재]
**C트랙(엔진 코드) = 0건** ← ★프롬프트는 023을 C트랙(fn_calc_pansu 함수결함)으로 봤으나,
실제는 fn_calc_pansu 가 **입력 사이즈의 work 치수 NULL** 때문에 정상적으로 NULL 반환한 것(데이터 결함).
함수 자체는 정상(32_fn_calc_pansu.sql L46-53: item work_width/height NULL → RETURN NULL). 데이터 충전으로 해소.

---

## 1. 투명포토카드025 — bundle_qtys 행 누락

- 공식 PRF_PHOTOCARD_CLEAR = 단일 comp `COMP_PHOTOCARD_CLEAR_SET`, use_dims=`[siz_cd, bdl_qty, min_qty]`.
- 단가행: `siz_cd=SIZ_000012 · bdl_qty=20 · min_qty=1 · 8,500원` (1행, 정상 존재).
- **결함**: `t_prd_product_bundle_qtys` 에 025의 행이 **0건**. → sim-meta `prod_dims` 에 묶음수 옵션이 없음
  → 손님이 bdl_qty=20 선택 불가 → 엔진이 bdl_qty 미해석(기본 1) → 단가행 미매칭 → 0.
- **형제 패리티(오라클)**: 일반포토카드024(PRD_000024)는 `bundle_qtys(bdl_qty=20, bdl_unit_typ_cd=QTY_UNIT.06, dflt_yn=Y, disp_seq=1)` 보유 → bdl_qty=20 선택 시 정상 가격(120,000). 025만 이 행이 누락.
- **권위 정합**: 가격표260527 row49 투명포토카드 제작수량 최소=20·증가=20 = 묶음 20 단위 = bdl_qty=20 확정.
- **검증(라이브 실측)**: `sim.simulate(PRD_000025,{siz_cd:SIZ_000012,bdl_qty:20},20)` = **170,000**
  (단가행 8,500×bdl_qty20). bdl_qty 미선택 시 0. → bundle_qtys 1행 추가하면 손님이 선택 가능 → 해소.
- **교정**: `t_prd_product_bundle_qtys` INSERT (024 verbatim 패리티). 단가행 불변.

## 2. 썬캡051 — 권위 가격데이터 부재 (BLOCKED)

- 공식 PRF_DGP_F = "디지털인쇄 원자합산형F 썬캡(미출시)". PRD_000051 유일 바인딩.
- size=313x400(SIZ_000195)·material=아이보리(MAT_000149)·plate=313x400(SIZ_000195 자기자신).
- **결함 표면**: plate=완제품사이즈(전지 아님) → fn_calc_pansu(499,195)=0(313x400은 306x457 전지에 0장)
  + 단가행 plt_siz_cd 도 전지(SIZ_000499)에만 존재 → 전 구성요소 미매칭 → 0.
- **★권위 진단**: 가격표/상품마스터(digital-print-l1 row223-232) — 썬캡 = **신규상품(노랑배경)·MES ITEM_CD 없음·
  출력용지규격 공란·"모든 항목은 Figma 참고"**. 즉 권위에 **출력용지규격(전지)·가격행이 아직 정의 안 됨**.
- **판정**: 019(전지 단가행 존재·소형판형만 오적재) 패턴과 다름. 019는 권위가 완비됐고 판형만 오적재였으나,
  051은 **권위 자체가 미완성**. 형제 상품도 없음(PRF_DGP_F 단독). → 정답값 도출 불가 = 값 날조 위험.
- **교정 금지**: 출력용지규격(전지 판형)·단가행을 추정 주입하면 값 날조. **BLOCKED → 인간 확인**:
  ① 썬캡 출시 여부 ② 출력용지규격(전지) 확정 ③ 가격행 권위(가격표 갱신/Figma). 확정 후 019 패턴 재적용 가능.

## 3·4·5·6. 접지카드027/028/029·모양엽서023 — 사이즈 work 치수 NULL (fn_calc_pansu)

- **공통 메커니즘**: 디지털인쇄 원자합산형(E/B)은 `fn_calc_pansu(전지 SIZ_000499, 완제품 siz_cd)` 로
  판걸이수를 구해 (전지 단가행 × 판수)로 가격. `fn_calc_pansu`(32_fn_calc_pansu.sql L46-53)는
  **아이템(완제품) 사이즈의 work_width/work_height 가 NULL 이면 RETURN NULL** → "판수 환산 불가" → 0.
- **결함**: 아래 3개 공유 사이즈코드의 `t_siz_sizes.work_width/work_height` 가 **공란(NULL)**:

  | siz_cd | siz_nm | cut(W×H) | work(현재) | 영향 상품 | 정상 형제 패리티 |
  |--------|--------|----------|-----------|-----------|------------------|
  | SIZ_000124 | 150x100 | 150×100 | **NULL** | 027·029·094 | SIZ_000003(100x150) work=102×152·margin 1/1/1/1 |
  | SIZ_000133 | 86x52  | 86×52   | **NULL** | 028·031·032·033 | SIZ_000135(52x86) work=52×86·SIZ_000008(90x50) work=92×52 |
  | SIZ_000119 | 90x90  | 90×90   | **NULL** | 023·097 | SIZ_000004(135x135) work=137×137(=cut+2) |

- **형제 정상 입증(라이브 실측)**: 같은 공식·work 치수가 채워진 형제 사이즈는 정상 가격:
  - 027: SIZ_000003=848·SIZ_000004=1,201·SIZ_000006=1,766·SIZ_000129=1,766 / **SIZ_000124=0**
  - 028: SIZ_000008=353·SIZ_000132=283·SIZ_000135=283 / **SIZ_000133=0**
  - 029: SIZ_000003=848·SIZ_000004=1,201 / **SIZ_000124=0**
  - 023: 유일 사이즈 SIZ_000119 = **0**(형제 없음·전건 0)
- **work 치수 도출 규칙(형제 패리티·추정 아님)**: 정상 형제는 모두 `work = cut + 2mm`(가로·세로 각 +1mm 도련/여분),
  margin 1/1/1/1. → 누락 3개 충전값:
  - SIZ_000124: work_width=152, work_height=102, margin 1/1/1/1
  - SIZ_000133: work_width=88,  work_height=54,  margin 1/1/1/1
  - SIZ_000119: work_width=92,  work_height=92,  margin 1/1/1/1
- **충전 후 fn_calc_pansu 양수 확인(수계산)**: 전지 SIZ_000499 인쇄영역 306×457.
  - 90x90(work 92×92): floor(306/92)×floor(457/92)=3×4=**12** > 0 → 023 가격 가능.
  - 150x100(work 152×102): floor(306/152)×floor(457/102)=2×4=8, 회전 floor(306/102)×floor(457/152)=3×3=9 → **9** > 0.
  - 86x52(work 88×54): floor(306/88)×floor(457/54)=3×8=24, 회전 4×5=20 → **24** > 0.
- **비파괴·무회귀**: work 치수 NULL→양수 충전은 **현재 0인 케이스만 가격 가능하게** 함. 현재 가격되는
  형제 사이즈는 영향 0(자기 행 별도). 같은 코드를 공유하는 다른 상품(094·031·032·033·097)도 동일하게
  가격 가능해짐(부수 긍정효과·회귀 아님).
- **기초마스터 코드 정책 정합**: t_siz_sizes 공유 코드를 **DELETE/이름변경 없이 NULL 컬럼만 UPDATE 충전** —
  base-master-code-no-delete 규칙 준수(추가/보정 가능·삭제 금지).

## 잔여·주의

- 교정 후 잔여 가격 갭(이전사이트 대비)이 있으면 = fn_calc_pansu 임포지션 과다 가능성
  ([[pansu-authority-fn-calc-pansu-260628]]·실무진 엑셀 판걸이수 lookup 우선·C트랙 코드). 데이터로 교정 금지.
- 051 썬캡은 권위 확정 전 교정 금지(값 날조 방지).
- 모든 교정은 DRY-RUN(BEGIN/ROLLBACK) 선검증 후 인간 승인 → COMMIT.
