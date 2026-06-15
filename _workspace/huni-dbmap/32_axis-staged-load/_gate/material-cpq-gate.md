# ④ 자재축 비소재 오염 → CPQ/siz 축이동 설계 명세 — 독립 게이트 (round-22 v2 · B-3)

> **검증** 2026-06-16 · `dbm-validator`(dbm-axis-staged-load X1~X6 + dbm-cpq-option-mapping L2). 생성자(`dbm-option-mapper`)와 독립 2-pass — 생성자 SQL 미재실행, 라이브 read-only SELECT로 전건 재현.
> **대상:** `_workspace/huni-dbmap/32_axis-staged-load/_corrected_xlsx/material-nonmaterial-cpq-spec.md`
> **라이브 실측 기준일:** 2026-06-16 (psql 읽기전용 SELECT만 · INSERT/UPDATE/DELETE/DDL 0건).
> **판정 성격:** 라이브 적용 0 — 설계 명세 정합 게이트(X5 재적재 검증은 범위 외, 본 명세는 설계까지).

---

## 0. 게이트 종합 판정

| 게이트 | 검사 | 판정 | 핵심 근거 |
|--------|------|:----:|-----------|
| **X1** | 권위 정합(축이동 규칙 ↔ 상품마스터/메모리·v03 미참조) | **PASS** | 본체색 합성·형상 칼틀/규격 분기·구수 bundle·인쇄면 print_side·잉크색 BLOCKED 모두 `01_axis-authority-rules.md`·메모리와 정합 |
| **X3** | 경계오염 판정 정확(색/형상/구수/용량/인쇄면/소재유지 표본·과분할 금지) | **PASS (MINOR 2건)** | .08/.10 분류 100% 행대조 일치·과분할 금지 라이브 입증. MINOR: "양면유광" 색 오분류·.09 색 카운트 13→12 |
| **X4** | 구조·FK 위상 순서(적재→재배선→use_yn='N'·삭제 마지막) | **PASS** | **80/82 상품이 전체 자재 BOM을 .08/.09/.10에 의존** → 삭제 선행 시 본체 BOM 소실 라이브 실증. 색→option round-6 별트랙 분리 정당(webadmin CPQ 적재경로 부재 CONFIRMED) |
| **독립 재실측** | 행수·distinct·link·cp참조·USAGE | **PARTIAL** | 131행·USAGE.07 전건·cp 0참조 **재현 ✓**. 단 **distinct 상품 82(명세 84)·link 172(명세 144) 불일치** |
| **BLOCKED 정당성** | AX-1/AX-2/AX-4/B-7 추측 회피 | **PASS** | 4건 모두 도메인 컨펌 필요·추측 회피 정당. AX-1은 권위 §3.2·메모리도 미해소 |

### 최종 판정: **GO (설계 명세로서)** — 단 §1 수치 정정 2건 반드시 반영 후 재배선 단계 진입

설계 골격(축이동 규칙·FK 위상 순서·3분류·BLOCKED)은 권위·라이브와 정합하며 안전하다. 그러나 **연결 상품수(84)·link 수(144)가 라이브와 불일치**하고, 재배선 계획(§2-3)이 이 틀린 link 수를 추정 분모로 쓰므로, 실 재배선 SQL 작성 전 **상품×자재 join 정밀 재집계 필수**(명세도 §2-3 note에서 "정밀 link 매핑은 재배선 SQL 작성 시 확정"이라 단서 — 그 단서가 본 게이트로 강제됨).

---

## 1. 독립 재실측 수치 (생성자 SQL 미재실행 · fresh SELECT)

### 1-1. 행수 — **명세 비준 ✓**

```sql
SELECT mat_typ_cd, count(*) FROM t_mat_materials
WHERE mat_typ_cd IN ('MAT_TYPE.08','MAT_TYPE.09','MAT_TYPE.10') GROUP BY 1;
```

| mat_typ | 명세 §0 | 독립 재실측 | 판정 |
|---------|:--:|:--:|:--:|
| .08 실사소재 | 14 | **14** | ✓ |
| .09 파우치 | 74 | **74** | ✓ |
| .10 악세사리 | 43 | **43** | ✓ |
| **합계** | **131** | **131** | **✓ 비준** |

### 1-2. 연결 상품수·link 수 — **명세 반증 ✗ (MAJOR)**

```sql
SELECT count(DISTINCT pm.prd_cd), count(*)
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE m.mat_typ_cd IN ('MAT_TYPE.08','MAT_TYPE.09','MAT_TYPE.10')
  AND COALESCE(pm.del_yn,'N')='N';   -- del_yn 필터 적용/미적용 동일
```

| 항목 | 명세 §0 주장 | 독립 재실측 | 판정 |
|------|:--:|:--:|:--:|
| distinct 상품 | **84** | **82** | ✗ |
| link 행 | **144** | **172** | ✗ |
| .08 prd/link | 9 / 14 | **20 / 25** | ✗ |
| .09 prd/link | 52 / 108 | **56 / 118** | ✗ |
| .10 prd/link | 5 / 22 | **8 / 29** | ✗ |
| usage_cd | 전부 USAGE.07 | **172/172 USAGE.07** | ✓ |
| component_prices 참조 | 0 | **0** | ✓ |

**원인 규명:**
- **distinct 84의 정체:** 명세 §0 "84"는 per-typ distinct 합(20+56+8 ≈ 명세 9+52+5=66은 또 다른 수치 — 명세는 .08=9·.09=52·.10=5라 합 66, 재실측 합 84). **진짜 distinct(상품 중복 제거) = 82**. 명세는 per-typ 카운트를 distinct로 혼용했고, 그 per-typ 카운트조차 라이브와 다름(.08 9 vs 20 등).
- **link 144 vs 172:** del_yn 필터를 켜고 꺼도 172 불변. 명세 144는 어느 필터·시점으로도 재현 안 됨 → **명세 수치가 stale 또는 산정 오류**.
- 가격사슬은 cp 0참조로 안전이라 이 수치 오차가 가격을 깨지는 않으나, **재배선 대상이 84상품/144link이 아니라 82상품/172link** — 재배선 계획(§2-3)의 link 추정(색~35·형상~30·구수~8·용량~25·인쇄면~8·유지~30·BLOCKED~7 = 143)이 실제 172와 ~29 link 어긋남. 재배선 SQL 작성 시 정밀 join 재집계로 닫아야.

> **★재현 결론:** 131행·USAGE.07 전건·cp 0참조는 **비준**. 84상품·144link은 **반증(실제 82/172)**. 04 재실측 문서의 "64상품"·명세의 "84상품"·실측 "82상품"이 모두 다름 → **단일 권위 SELECT로 통일 필요**.

---

## 2. X3 — 라벨 분류 표본 비준/반증 (본체색 과분할·소재유지 오판)

### 2-1. 행대조 — 분류 자체는 라이브와 정합

.08(14)·.09(74)·.10(43) **전 mat_nm을 라이브에서 pull하여 명세 §1-A/B/C와 1:1 대조 → 행 귀속 일치**:

| 시트 | 명세 분류 합 | 행수 | 판정 |
|------|:--:|:--:|:--:|
| .08 | 소재 9 + 색 5 | 14 | ✓ |
| .10 | 부속14 + 색3 + 색×묶음8 + 잉크색7 + 묶음4 + 규격7 | 43 | ✓ |
| .09 | (아래 정정 후) | 74 | ✓ (총합) · ✗ (색 라벨 1행 과대) |

### 2-2. 본체색 과분할 금지 — **PASS (라이브 입증)**

명세 §2-2 [HARD] "색을 무조건 분리하지 말 것 — 2~3종=자재유지·4종+=CPQ"가 라이브 색 카운트와 정합:

```sql
-- .08 시트커팅 색(255~259) 상품별 색 개수
SELECT prd_cd, count(*) FROM t_prd_product_materials
WHERE mat_cd IN ('MAT_000255'..'MAT_000259') GROUP BY 1;
-- → 전 상품 최대 2색 (화이트/블랙) = 본체색
-- .09 색(297~303,310,312,314,315,316) 상품별
-- → PRD_000217=7색 · PRD_000226=4색 (선택색) · PRD_000228=1색 (본체색)
```

- 시트커팅(.08) = 상품당 **최대 2색** → 명세 "2~3종 자재유지"로 정확히 떨어짐(과분할 안 함). **✓**
- 파우치(.09) = 7색·4색 상품 존재 → 명세 "4종+ CPQ option"으로 정확히 분기. **✓**
- 명세가 색을 **무조건 분리하지 않고** 상품별 색 카운트로 분기를 미룬 것(§2-2 note: "상품별 분기는 재배선 계획 시 상품 단위로")은 정답. 라이브가 그 임계를 지지.

### 2-3. 소재유지 오판 없음 — **PASS**

진짜 소재(인화지·매트지·PET·PVC·시트류 9행) + 진짜 부속(OPP봉투·우드거치대·와이어링 등 14행) = **23행 유지**가 라이브 mat_nm과 정합. 진짜 자재를 비소재로 오판하여 삭제 대상에 넣지 않음. 우드거치대=자재(Q13)·OPP봉투=부속 모두 유지로 정확 분류. **✓**

### 2-4. MINOR 오류 2건 (반증 — 보정 권고)

- **MINOR-1 (분류 오판):** `MAT_000316 "양면유광"`을 §1-B에서 **색**으로 분류. "양면유광"은 색이 아니라 **양면 유광 마감(코팅/공정)** — 권위 §충돌표 "코팅=공정". 색→option이 아니라 마감 variant(공정 또는 자재 finish)로 가야. 연쇄로 `317/318 "양면유광 M/L"`을 §1-B 색×사이즈 복합에 넣은 것도 "마감×사이즈"라 색축 분리가 부정확. **영향: 미미**(해당 상품 PRD_000217이 7색 보유라 어차피 CPQ 트랙) 하나 라벨 정확도 보정 필요.
- **MINOR-2 (카운트 오류):** §1-D 라벨 집계 .09 색=**13** 주장이나 실제 나열·존재 = **12행**(297~303 7 + 글리터 4 + 양면유광 1). §1-D 라벨 합계가 75(행수 74 초과 1) — 색 12로 정정하면 74 일치. **.09 총 74는 정확**(행 누락 아님·집계 산술 오류).

---

## 3. X4 — FK 위상 순서·색→option 별트랙 정당성

### 3-1. 적재→재배선→use_yn='N' 순서 — **PASS (라이브 실증)**

명세 §4 [HARD] "STAGE4(논리삭제)를 STAGE1~3 앞에 두면 144 USAGE.07 link 끊김 → 본체 자재 소실"을 라이브로 검증:

```sql
-- .08/.09/.10 외 다른 자재가 전혀 없는 상품 (= 이 행 삭제 시 BOM 전손)
WITH tgt AS (SELECT DISTINCT pm.prd_cd FROM t_prd_product_materials pm
  JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE m.mat_typ_cd IN ('.08','.09','.10'))
SELECT count(DISTINCT t.prd_cd) FROM tgt t WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials pm2 JOIN t_mat_materials m2 ON pm2.mat_cd=m2.mat_cd
  WHERE pm2.prd_cd=t.prd_cd AND m2.mat_typ_cd NOT IN ('.08','.09','.10'));
-- → 80
```

- **82상품 중 80상품이 전체 자재 BOM을 .08/.09/.10에만 의존.** 재배선 선행 없이 삭제하면 80상품 본체 자재 전손. **명세의 [HARD] 순서가 이론이 아니라 80/82 상품에 load-bearing.** **✓ 강력 비준.**
- 가격사슬(cp 0참조)은 안전하나 명세가 정확히 짚은 대로 **본체 BOM 손실 위험**은 실재.

### 3-2. siz 가격사슬 보존 — **PASS**

`t_prc_component_prices` 3,396행이 siz_cd 직접 참조. 명세 §4·§2-3이 "신규 siz append만·기존 삭제/재키 금지"로 가드. 신규 siz INSERT는 기존 사슬 무영향이라 안전. **✓**

### 3-3. 색→option round-6 별트랙 분리 — **PASS**

명세 §3-2 Y-4 "색→option은 경로 Y(교정 엑셀)로 안 닫힘 — webadmin load_master에 CPQ 적재경로 부재 → round-6 dbm-cpq-option-mapping 별도"가 정당:
- round-22 스킬 03 분석(load_master=6축만 적재·CPQ 옵션 레이어 미적재)와 정합.
- siz/bundle/print_side는 v03 시트 append로 닫히나 option_groups/options/option_items는 load_master 입력 시트가 없으므로 경로 Y로 못 닫음 → 별트랙 분리는 구조적으로 강제됨. **✓**
- 라이브 트리거 `fn_chk_opt_item_ref` 존재 확인 → STAGE2 option_items 적재 시 ref_dim(siz/bundle) 선존재 강제. 명세 §4 STAGE 순서(STAGE1 siz/bundle 선적재 → STAGE2 option_items)가 트리거 통과 조건과 정합. **✓**
- 단 라이브 global option_items = **468행**(명세·메모리 "거의 0"은 부분 stale) — 그래도 대상 82상품은 items 18로 sparse, 설계 영향 없음.

---

## 4. BLOCKED 정당성 — **PASS**

| ID | 행 | 추측 회피 정당? | 근거 |
|----|----|:--:|------|
| **AX-1** | 잉크색×용량 7행(MAT_000232~239) | **정당** | 잉크색=도수/별색공정/자유옵션 미확정. `01 §3.2`·메모리 [[material-option-normalization]]도 미해소. 추측 시 도수축/공정축 오염 위험 — 동결 정답 |
| **AX-2** | size→siz 이동 시 사슬 보존 | **정당** | cp 3,396행 siz_cd 참조 — 보존법 미확정 상태 이동 금지. 메모리 [[schema-design-intent-first]] "기계적 size 삭제 금지" 정합 |
| **AX-4** | 봉투·(3개1팩)·리필잉크 = 자재/option/template | **정당** | 부자재 귀속 통일 미정(완제 SKU template 여부). 추측 시 template/bundle 오모델 |
| **B-7** | 규격형 형상 칼틀 미존재분 | **정당** | siz(칼틀 1:1) vs 공정 param 분기 = 칼틀 물리존재 확인 필요(Q7). "형상 무조건 공정" 일률 틀림(권위 §342) |

4건 모두 NULL 강제·추측 없이 컨펌 큐로 분리 — round-22 BLOCKED 원칙(추측 금지) 준수. **✓**

---

## 5. 발견 오류·핸드오프 (생성자 `dbm-option-mapper`로 라우팅)

| # | 심각도 | 발견 | 라우팅 | 수정 |
|---|:--:|------|--------|------|
| F-1 | **MAJOR** | 연결 상품수 84·link 144 ≠ 라이브 82·172 (per-typ도 전부 불일치) | dbm-option-mapper | §0/§2-3을 distinct 82·link 172로 정정·재배선 분모 정밀 join 재집계 |
| F-2 | **MINOR** | "양면유광"(316·317·318)을 색/색×사이즈로 오분류 — 실제 마감(공정) | dbm-option-mapper | 마감 variant로 재라벨(색→option 아님) |
| F-3 | **MINOR** | §1-D .09 색=13 집계 오류(실제 12·라벨합 75>74) | dbm-option-mapper | 색 12로 정정(.09 총 74는 정확) |
| F-4 | INFO | 04 재실측 "64상품"·명세 "84"·게이트 실측 "82" 3중 불일치 | dbm-correctness-auditor | 단일 권위 SELECT로 통일 |
| F-5 | INFO | global option_items=468(명세·메모리 "거의 0" 부분 stale) | — | 대상 상품은 sparse·설계 무영향, 참고만 |

**보존 확인(건드리지 말 것):** 131행 분류 골격·본체색 과분할 금지 임계(2~3 vs 4+)·FK 위상 [HARD] 순서·색→option round-6 별트랙·BLOCKED 4건 — 전부 권위·라이브 정합. F-1만 닫으면 재배선 단계 진입 가능.

**실 변경·COMMIT:** 인간 승인 + 개발자 협업(경로 Y 재적재) + round-6 CPQ 트랙. 본 게이트는 라이브 적용 0(읽기전용 SELECT만).
