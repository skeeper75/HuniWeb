# 아크릴 가로/세로 구간 동형 전환 설계 — siz_width/siz_height (round-23·Q-PR-3 해소)

> **작성** 2026-06-17 · round-23 확장 `dbm-price-arbiter`(심의자·돈-크리티컬). 입력 재사용 = `poster-sign-component-redesign.md`(신안)·`webadmin-change-mapping-v2.md`(siz_width/height·엔진)·`31_acrylic-price-link/`(이전 사슬)·`33/_exec_wh/`(포스터 실행본 패턴) + **라이브 2026-06-17 직접 재실측**(읽기전용 psql) + `20_price-import/acrylic/acrylic-import.xlsx`(가격표 verbatim).
> **DB 미적재 · 실 COMMIT 0** — 분석·설계까지. 실 적용 = 인간 승인. webadmin 코드 수정 0(read-only oracle).

---

## 0. 핵심 5줄

1. **아크릴 재실측 = 31_acrylic 이후 추가 진화 0(stale 아님).** `PRF_CLR_ACRYL`(투명)·`COMP_ACRYL_CLEAR3T`(prc_typ .02·84행·mat 3T 47+1.5T 37)·`COMP_ACRYL_MIRROR3T`(.01·37행)·배선 disp_seq/addtn_yn NULL·바인딩 키링1(PRD_000146 06-15)·siz_width/siz_height 백필 0 — 전부 31_acrylic 그대로. 포스터/사인 신안(siz_width/height 컬럼·엔진 TIER) 인프라는 아크릴에도 그대로 적용 가능.
2. **가로/세로 구간 동형 전환 GO — 그러나 포스터의 V1b(work_width/height) 패턴은 아크릴에 절대 금물(돈-크리티컬).** 포스터는 work_width/height == 가격표 매트릭스 축이라 in-place 전환이 안전했으나, **아크릴 work_width/height = 작업사이즈(블리드/여백 가산: siz_nm "50x50"→work 60x60·"40x80"→work 50x90)이고 47 siz_cd 중 5개는 work 차원 NULL** → work 기준 전환 시 가격축이 틀리고 15행 소실. **아크릴의 면적축 권위 = siz_nm WxH 문자열(=가격표 매트릭스 헤더)** 또는 가격표 verbatim 좌표.
3. **채번 0 입증.** A안 아크릴 좌표 siz 채번 196(105 NONE·GAP 96) → 신안 = INSERT 0 신규 siz + GAP 96 좌표를 siz_width/siz_height 직접 수치로 적재. **좌표 siz 신규 채번 0.** 두께(3T/1.5T)는 mat_cd 유지(면적축과 직교)·미러는 별 comp 유지.
4. **가격표 [가로×세로] verbatim 추출 = RU 84(라이브 재현·siz_nm→W/H)·MIRROR 37·GAP 96 = 217 distinct 셀.** GAP `(미채번:GxS)`는 G=가로(W)·S=세로(H) — 신안에서 siz_width=G·siz_height=S 직접. 단가값은 가격표/라이브 verbatim(날조 0).
5. **BLOCKED 잔존 = Q-ACR-7(prc_typ .02 엔진계약)·코롯토/카라비너 comp 신설·미러 바인딩 상품 불명·CLEAR15T↔3T comp 합치 정합.** 본체 면적축 전환은 GO, 미해소분은 정직 분리.

---

## 1. 아크릴 라이브 재실측 (Q-PR-3 해소 — 부분진화 stale 점검)

### 1.1 31_acrylic(06-15) → 라이브(06-17) 델타 = 0 (추가 진화 없음)

| 항목 | 31_acrylic 실측(06-15) | **라이브 재실측(06-17·권위)** | 델타 |
|------|------------------------|-------------------------------|------|
| `PRF_CLR_ACRYL` | 실재(투명 공식) | ✅ 실재·use_yn=Y | 0 |
| `COMP_ACRYL_CLEAR3T` | .02·use_dims `["siz_cd","mat_cd","min_qty"]`·84행 | ✅ 동일(.02·동일 use_dims·84행) | 0 |
| mat_cd 분기 | MAT_000043(3T) 47 + MAT_000042(1.5T) 37 | ✅ 동일(min_qty 전건 1) | 0 |
| `COMP_ACRYL_MIRROR3T` | .01·`["siz_cd","mat_cd"]`·37행·미배선 | ✅ 동일(mat_cd 차원이나 단가행 mat_cd NULL·37행) | 0 |
| 배선 `PRF_CLR_ACRYL→CLEAR3T` | disp_seq/addtn_yn NULL | ✅ 동일(여전히 NULL) | 0 |
| 바인딩 | PRD_000146 키링만(06-15) | ✅ 동일(키링1·22상품 미바인딩) | 0 |
| siz_width/siz_height 백필 | (당시 미측정) | **0행**(siz_cd 84·siz_width 0·siz_height 0) | — |

> **판정**: 31_acrylic 이후 라이브는 **추가 부분진화 없음**(아크릴은 포스터/사인과 달리 06-17 webadmin WH 작업의 영향을 안 받음 — webadmin이 컬럼·엔진만 신설하고 아크릴 단가행은 미전환). **Q-PR-3 해소 = 재실측 결과 stale 위험 0**. 31_acrylic 설계 토대 유효 + WH 전환 인프라(컬럼·엔진) 추가 가용.

### 1.2 신안 인프라의 아크릴 가용성 (라이브 실측)

| 인프라 | 라이브 상태 | 아크릴 적용 |
|--------|------------|------------|
| `t_prc_component_prices.siz_width/siz_height` numeric(8,2) | ✅ 컬럼 실재 | 아크릴 단가행도 직접 사용 가능 |
| 자연키 14차원(siz_width/height 포함) | ✅ 인덱스 실측 | 아크릴 단가행 멱등키 동일 |
| 엔진 `TIER_DIMS=(siz_width,siz_height,min_qty)`·`TIER_UPPER=(siz_width,siz_height)` | ✅ pricing.py:45-46 | **2축 면적매트릭스 정확 표현·off-grid 내장** |
| `t_prd_products.nonspec_width/height_incr` | ✅ 컬럼·아크릴 nonspec_yn=Y 4상품 min/max 보유·incr NULL | off-grid step |

---

## 2. ★ 돈-크리티컬 심의: 포스터 V1b 패턴을 아크릴에 쓰면 안 되는 이유

포스터/사인 신안 실행본(`_exec_wh/V1b`)은 **라이브 siz_cd 17행을 work_width/work_height로 in-place 전환**했다. 아크릴에 그대로 답습하면 가격이 틀린다. 근거(라이브 실측):

### 2.1 아크릴 work_width/height ≠ 가격표 매트릭스 축 (블리드/여백 가산)

| siz_cd | siz_nm(가격표 매트릭스 축) | work_width | work_height | 차이 |
|--------|--------------------------|:--:|:--:|------|
| SIZ_000045 | 140x80 | 144 | 84 | +4/+4 (블리드) |
| SIZ_000011 | 50x50 | 60 | 60 | +10/+10 |
| SIZ_000047 | 40x80 | 50 | 90 | +10/+10 |
| SIZ_000058 | 100x140 | 104 | 144 | +4/+4 |
| SIZ_000008 | 90x50 | 92 | 52 | +2/+2 |

> **시사**: work_*는 **작업사이즈(인쇄 여백 포함)**이지 가격표가 단가를 가르는 **출력규격 축**이 아니다. 가격표 셀은 "30×30=3,100"인데 work는 40×40 류. work 기준 전환 시 주문자가 "30×30"을 골라도 siz_width=40 구간을 룩업 → **틀린 단가**. (포스터는 우연히 work==매트릭스 축이라 안전했음.)

### 2.2 47 siz_cd 중 5개 work 차원 NULL → 15 물리행 소실 위험

| comp | NULL work-dim 물리행 | siz_cd(siz_nm) |
|------|:--:|--------|
| CLEAR3T | 10 | SIZ_000119(90x90)·336(20x20)·344(70x60)·346(60x20)·350(80x30) ×(3T+1.5T) |
| MIRROR3T | 5 | 동일 5 siz_cd |

> work 기준 V1b는 이 15행을 NULL→미전환으로 **고아·가격 공백**. siz_nm은 멀쩡한 "90x90" 등 → **siz_nm WxH 파싱이 무손실**.

### 2.3 ★권고: 아크릴 면적축 전환 source = siz_nm WxH 문자열 (가격표 매트릭스 축)

- **siz_nm WxH = 가격표 매트릭스 헤더 verbatim**(검증: §1.1 RU 84행 단가가 L1 가격표 셀과 31_acrylic §6 전건 일치). 비대칭 쌍 SIZ_000493="50x30"이 work 50/30과도 일치 → **W=앞·H=뒤(가로우선)** 확정(Q-ACR-4 해소).
- **전환 규칙**: `siz_width = split(siz_nm,'x')[0]`·`siz_height = split(siz_nm,'x')[1]`·`siz_cd=NULL`(전환 후). work_width/height **미사용**(작업사이즈는 가격축 아님).
- **단, siz_nm이 clean WxH(`^[0-9]+x[0-9]+$`)인 행만 자동 전환** — 비정형 siz_nm(예 "A5 (148X210)" 류)은 아크릴 매트릭스에 없으나 가드로 제외(타 상품군 오염 방지).

---

## 3. 가로/세로 구간 동형 전환 설계 (본체·두께·미러·off-grid)

### 3.1 본체 면적 comp — use_dims 전환 (siz_cd 토큰 → siz_width/siz_height)

| comp_cd | 현 use_dims | 신안 use_dims | 두께축 | 비고 |
|---------|------------|--------------|--------|------|
| `COMP_ACRYL_CLEAR3T` | `["siz_cd","mat_cd","min_qty"]` | `["siz_width","siz_height","mat_cd"]` | mat_cd 유지(3T/1.5T) | **min_qty 제거**(전건 1=무의미·면적매트릭스 수량축 없음·Q-ACR-7 연동) |
| `COMP_ACRYL_MIRROR3T` | `["siz_cd","mat_cd"]` | `["siz_width","siz_height"]` | (단가행 mat_cd NULL) | mat_cd 토큰 제거(단가행 mat 무사용) |

> **두께(3T/1.5T) = mat_cd 유지·면적축과 직교**(사용자 directive 충족). 면적축만 siz_cd→siz_width/height. CLEAR3T는 한 comp가 mat_cd로 두 두께 분기(1.5T=3T×0.8 정합·§1.1)를 그대로 보존.

### 3.2 단가행 — siz_width/siz_height 백필

```
면적 매트릭스 셀 (가로 g, 세로 s) = 단가 p
  → component_prices row:
     comp_cd, siz_width=g, siz_height=s, mat_cd=<3T|1.5T|NULL>, min_qty=NULL,
     siz_cd=NULL, (clr/proc/opt/coat/bdl/print_opt/plt=NULL), unit_price=p, apply_ymd='2026-06-01'
```

| 처리 단위 | 대상 | 출처 | 행수 | 채번 |
|-----------|------|------|:--:|:--:|
| **A1 RU 전환**(in-place) | 라이브 CLEAR3T 84·MIRROR3T 37 = 121행 | **siz_nm WxH 파싱**(§2.3) | UPDATE 121 | 0 |
| **A2 GAP 신규**(INSERT) | 미적재 좌표 96(CLEAR3T 66·1.5T 15·MIRROR 15) | acrylic-import `4b_GAP` verbatim `(미채번:GxS)` | INSERT 96 | **0**(직접 수치) |
| **A3 use_dims 전환** | CLEAR3T·MIRROR3T 2 comp | (§3.1) | UPDATE 2 | — |

> **★ 1.5T comp 합치 정합(컨펌 Q-ACR-AC1)**: acrylic-import GAP은 `COMP_ACRYL_CLEAR15T`(별 comp 15행)로 분리됐으나 **라이브는 1.5T를 CLEAR3T의 mat_cd=MAT_000042로 통합**. → A2 GAP 적재 시 CLEAR15T 15행은 `comp_cd=COMP_ACRYL_CLEAR3T, mat_cd=MAT_000042`로 매핑(별 comp 아님). 라이브 통합 모델 따름.

### 3.3 미러 — 별 comp 유지 (면적축만 전환)

- `COMP_ACRYL_MIRROR3T`(.01 단가형·37행)은 두께/도수 체계가 투명과 달라 별 comp 정당. 면적축만 siz_width/height 전환. **단 미러 본체 바인딩 상품 불명**(Q-ACR-9 미해소) → 공식/배선/바인딩 신설은 BLOCKED, 단가행 축 전환만.

### 3.4 off-grid 처리 (엔진 TIER 내장 + nonspec)

| 메커니즘 | 동작 | 라이브 |
|----------|------|--------|
| 가격 룩업 | 엔진 `match_component` siz_width/siz_height 각 축 '이하 최소 임계'(주문 ≤ 임계 중 min) → off-grid=다음 큰 구간 자동 | ✅ pricing.py:144-164 |
| 최대초과 | 전 임계 < 주문 → `ERR_ABOVE_MAX` | ✅ pricing.py:154 |
| 입력 정규화 | nonspec_yn=Y 아크릴 4상품(키링/마그넷/뱃지/스마트톡/코롯토) width/height min/max + **incr 백필**(현 NULL) | ⚠️ incr 미백필(컨펌 Q-ACR-AC2) |

> **A안 런타임 ceiling 불요화**: 31_acrylic §6의 off-grid ceiling(DB 미저장·런타임)이 **엔진 TIER로 흡수**. 단가행에 ceiling 행 안 만듦([[dbmap-compute-in-app-db-stores-lookup]] 철학 보존). nonspec_incr는 **입력 step 검증**(가격축 아님).

### 3.5 후가공/CLR 처리 (G-D2 패턴)

| 후가공 | 처리 | 신안 영향 |
|--------|------|----------|
| 별색(CLR) | clr_cd=NULL(도수 무관·"통용단가") — 별색=공정 시 proc_cd | **siz_width/height 무관**(후가공 사이즈축 아님) |
| 고리/자석/바디(B05 11그룹) | proc_cd 또는 CPQ option(Q-ACR-1 미해소) | 사이즈축 직교·G-D2 W4 배선 패턴(proc_cd+dim_vals) |
| 코롯토(B06)·카라비너(B07) | comp 자체 부재 → 신설 BLOCKED | 코롯토=면적매트릭스(siz_width/height 동형)·카라비너=고정가(opt_cd·면적 아님) |

> **후가공은 본체 면적축 전환과 직교** — G-D2 후가공 배선(proc_cd/dim_vals)을 그대로 적용. 본 설계는 **본체 면적 comp use_dims만** 변경.

---

## 4. 가격표 [가로×세로] verbatim 추출 계획 · 채번 0

### 4.1 verbatim 출처 매핑

| 단위 | source(권위) | 셀 수 | W/H 도출 | 검증 |
|------|-------------|:--:|---------|------|
| RU CLEAR3T(3T) | 라이브 84행 中 MAT_000043 47 | 47 | siz_nm WxH | §1.1 라이브=L1 가격표 일치 |
| RU CLEAR3T(1.5T) | 라이브 MAT_000042 37 | 37 | siz_nm WxH | 1.5T=3T×0.8 정합 |
| RU MIRROR3T | 라이브 37행 | 37 | siz_nm WxH | 가격표 B03 일치 |
| GAP CLEAR3T | `4b_GAP` 66 `(미채번:GxS)` | 66 | G=W·S=H 직접 | 가격표 verbatim 단가 |
| GAP 1.5T | `4b_GAP` CLEAR15T 15 → CLEAR3T mat=1.5T | 15 | 〃 | 〃 |
| GAP MIRROR | `4b_GAP` MIRROR3T 15 | 15 | 〃 | 〃 |
| **합계** | | **217** | | |

### 4.2 채번 0 입증

| A안(좌표 siz) | 신안(siz_width/height) |
|---------------|------------------------|
| RU 좌표 일부 siz 미채번(NULL work 5) → 채번 필요 | siz_nm 파싱·**채번 0** |
| GAP 96 = `(미채번:GxS)` → 좌표 siz 96 채번 | siz_width=G·siz_height=S 직접·**채번 0** |
| A안 총 ~96 신규 siz 채번 | **신규 siz 채번 0** |

> **A안의 96 좌표 siz 채번 전부 불요화.** siz 마스터 무증가. 실무진 입력 = 가로/세로 수치(직관).

---

## 5. load-builder 인계 단위 (포스터 _exec_wh 패턴 동형)

| 단위 | 테이블 | 조치 | 행수 | 멱등키 | 비고 |
|------|--------|------|:--:|--------|------|
| **A1** RU 전환 | t_prc_component_prices | 라이브 121 siz_cd 행 → siz_width/siz_height(**siz_nm 파싱**·siz_cd=NULL·값 불변) | UPDATE 121 | siz_cd NOT NULL & siz_width IS NULL & comp IN(CLEAR3T,MIRROR3T) | **★work_width/height 금지** |
| **A2** GAP 신규 | t_prc_component_prices | `4b_GAP` 96 좌표 verbatim INSERT(siz_width=G·siz_height=S·mat_cd 분기) | INSERT 96 | 자연키(comp,siz_width,siz_height,mat_cd) NOT EXISTS | 채번 0 |
| **A3** use_dims 전환 | t_prc_price_components | CLEAR3T→`["siz_width","siz_height","mat_cd"]`·MIRROR3T→`["siz_width","siz_height"]` | UPDATE 2 | comp_cd & use_dims @> [siz_cd] | min_qty/잉여토큰 제거 |
| **A4** nonspec incr | t_prd_products | 아크릴 nonspec_yn=Y 4상품 incr 백필 | UPDATE ≤4 | prd_cd & incr IS NULL | 컨펌 Q-ACR-AC2(증가단위 값) |
| (배선 보정) | t_prc_formula_components | PRF_CLR_ACRYL→CLEAR3T disp_seq=1·addtn_yn=N | UPDATE 1 | NULL→값 | 31_acrylic GAP-WIRE-META |

**적재 순서(FK·단일 트랜잭션):** A1(전환)→A2(INSERT)→A3(use_dims)→A4(nonspec)→배선보정. A1/A2가 A3 전에 데이터 채워 가격 공백 0.

**DRY-RUN(R1~R6) 골든:**
1. 멱등 delta 0(2-pass).
2. 키링 30×30 3T = siz_width=30·siz_height=30·mat=3T 룩업 → 3,100(L1 일치).
3. 1.5T 30×30 = 2,480(=3,100×0.8).
4. off-grid 25×25 → siz_width 30·siz_height 30 구간(이하 최소) = 3,100(ceiling 엔진).
5. 최대초과(W>200) → ERR_ABOVE_MAX.
6. 채번 0(siz INSERT 0)·work_width/height 미사용(가격축 무오염).

---

## 6. BLOCKED / 컨펌 정직 분류

| ID | 항목 | 상태 | 권고 라우팅 |
|----|------|------|------|
| **Q-PR-3** | 아크릴 부분진화 재실측 | ✅ **해소**(델타 0·stale 아님·§1.1) | — |
| **Q-ACR-4** | 좌표 라벨 방향(가로우선 vs 세로우선) | ✅ **해소**(SIZ_000493 "50x30"=work 50/30·W=앞) | siz_nm WxH(W 앞) |
| **Q-ACR-7** | prc_typ .02 엔진계약(min_qty 룩업 후 ×수량 vs 총액) | 🔴 **BLOCKED**(엔진 미구현·min_qty 전건 1) | 엔진 evaluate_price 계약 확정 후 .01/.02·min_qty 제거 여부(추측 강제 금지) |
| **Q-ACR-AC1**(신규) | acrylic-import의 CLEAR15T 별 comp vs 라이브 mat_cd 통합 | 🟡 컨펌 | 라이브 통합 따름(GAP 1.5T→CLEAR3T mat=MAT_000042)·권고 |
| **Q-ACR-AC2**(신규) | 아크릴 nonspec_width/height_incr 값(증가단위) | 🟡 컨펌 | 가격표/도메인 미명시 → 실무진 컨펌(추측 적재 금지) |
| **Q-ACR-9** | 미러 본체 바인딩 상품 불명 | 🔴 **BLOCKED** | 미러 단가행 축 전환만·공식/바인딩 신설 보류 |
| **GAP-CHAIN-COROTTO/CARABINER** | 코롯토·카라비너 comp 부재 | 🔴 **BLOCKED**(본 설계 범위 외) | 코롯토=면적매트릭스 동형(siz_width/height)·카라비너=고정가 opt_cd — 신설 별 트랙 |
| **GAP-BIND-22** | 아크릴 22상품 미바인딩 | 🟡 | 본체소재 확정(Q-ACR-8) 후 product_price_formulas 바인딩 |
| **GAP-CPQ-ZERO** | 아크릴 CPQ 옵션레이어 전무 | 🟡 | round-6 dbm-option-mapper(별 트랙) |

> **본 설계 GO 범위 = 본체 면적축 siz_cd→siz_width/siz_height 동형 전환(A1~A4+배선보정).** 미러 바인딩·코롯토/카라비너 신설·prc_typ .02·CPQ는 정직 BLOCKED/컨펌 분리. **돈-크리티컬: 추측 적재 금지·work 차원 가격오염 차단.**

---

## 7. read-only 준수

- 라이브 SELECT(아크릴 formula/comp/wiring/binding·CLEAR3T·MIRROR3T 84+37행·siz_width/height 백필 0·work_width/height·nonspec)·pricing.py(TIER_DIMS·match_component·ERR_ABOVE_MAX)·acrylic-import.xlsx(RU/GAP verbatim) 직접 확인. INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 설계·정리까지 — load-builder A1~A4+배선보정 멱등 SQL·DRY-RUN·R1~R6 GO는 dbm-validator·실 COMMIT 인간 승인. webadmin 코드 수정 0.
