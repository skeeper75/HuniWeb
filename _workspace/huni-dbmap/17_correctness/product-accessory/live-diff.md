# 상품악세사리 — 라이브 전수 실측 vs 정답 diff (round-13 C3)

> **작성** 2026-06-11 · round-13. 각 부자재의 라이브 t_* 행을 읽기전용으로 전수 측정하고, extraction-plan(C2) 정답값과 field-for-field 대조.
> **[HARD] read-only:** SELECT만. 비밀값 비노출. 재현 SELECT 동반.
> **상품행 + TMPL- template행 둘 다 측정**(이중등록·봉투 세트).

---

## 0. 재현 환경 (모든 SELECT 공통 prefix)

```bash
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAF'|' -c "<SQL>"
```

부자재 prd_cd 집합(P15) = `'PRD_000001'..'PRD_000015'` · 이중등록 = `'PRD_000281','PRD_000282','PRD_000283'`.

---

## 1. 상품행 (`t_prd_products`) — 정체·MES·qty_unit·use_yn

**재현:** `SELECT prd_cd,prd_nm,COALESCE("MES_ITEM_CD",'NULL'),prd_typ_cd,min_qty,max_qty,qty_incr,qty_unit_typ_cd,use_yn FROM t_prd_products WHERE prd_cd ~ 'PRD_00000[1-9]|PRD_0000(1[0-5])|PRD_00028[1-3]' ORDER BY prd_cd;`

| prd_cd | prd_nm | 라이브 MES | 정답 MES(L1) | qty_unit | use_yn | diff |
|--------|--------|-----------|--------------|----------|--------|------|
| PRD_000001 | OPP접착봉투 | 012-0004 | 012-0004 | QTY_UNIT.05 팩 | Y | ✅(MES·qty_unit=후속 손작업) |
| PRD_000002 | OPP비접착봉투 | 012-0005 | 012-0004/0005 | QTY_UNIT.05 | Y | ✅ |
| PRD_000003 | 트래싱지 카드봉투 | 012-0009 | 012-0009 | QTY_UNIT.05 | Y | ✅ |
| PRD_000004 | 카드봉투 | 012-0007 | 012-0007 | QTY_UNIT.05 | Y | ✅ + 이중등록 |
| PRD_000005 | 캘린더봉투 | 012-0008 | 012-0008 | QTY_UNIT.05 | Y | ✅ |
| PRD_000006 | 볼체인 | 012-0015 | 012-0015 | QTY_UNIT.05 | Y | ✅ |
| PRD_000007 | 와이어링 | 012-0016 | 012-0016 | QTY_UNIT.01 EA | Y | ✅ |
| PRD_000008 | 천정고리 | **NULL** | 012-0016 | QTY_UNIT.04 세트 | **N** | 🟡 MES NULL·use_yn=N |
| PRD_000009 | 투명케이스 | 012-0006 | 012-0006 | QTY_UNIT.05 | Y | ✅ |
| PRD_000010 | 행택끈 | **NULL** | 012-0017~0019 | QTY_UNIT.05 | Y | 🟡 MES NULL |
| PRD_000011 | 자석고정용고무판 | 012-0011 | 012-0011 | QTY_UNIT.05 | Y | ✅ |
| PRD_000012 | 우드거치대 | 012-0012 | 012-0012 | QTY_UNIT.01 | Y | ✅ |
| PRD_000013 | 우드봉 | **NULL** | 012-0012 | QTY_UNIT.01 | Y | 🟡 MES NULL |
| PRD_000014 | 우드행거 | 012-0013 | 012-0013 | QTY_UNIT.01 | Y | ✅ |
| PRD_000015 | 만년스탬프 리필잉크 | **NULL** | 012-0013 | QTY_UNIT.01 | Y | 🟡 MES NULL |
| PRD_000281 | 카드봉투(화이트) | NULL | (추가상품) | QTY_UNIT.01 | Y | 이중등록 PRD_TYPE.05 |
| PRD_000282 | 카드봉투(블랙) | NULL | (추가상품) | QTY_UNIT.01 | Y | 이중등록 PRD_TYPE.05 |
| PRD_000283 | 트레싱지봉투 | NULL | (추가상품) | QTY_UNIT.01 | Y | 이중등록 PRD_TYPE.05 |

> **상품행 정합:** 15 부자재 전부 라이브 적재(PRD_000001~015)·prd_nm L1 일치. MES는 7/15 채워짐·8/15 NULL(load_master:261 None과 불일치→후속 손작업). qty_unit·MES는 load_master 산물 아님(L-PA-A·적재 경로 불명). 천정고리 use_yn=N(컨펌). 이중등록 281/282/283 별 PRD.

---

## 2. 카테고리 (`t_prd_product_categories`) — 잉여 고아 노드 오연결

**재현:** `SELECT pc.prd_cd,cc.cat_cd,cc.cat_nm,COALESCE(cc.upr_cat_cd,'NULL'),cc.cat_lvl FROM t_prd_product_categories pc JOIN t_cat_categories cc ON pc.cat_cd=cc.cat_cd WHERE pc.prd_cd ~ 'PRD_00000[1-9]|PRD_0000(1[0-5])|PRD_00028[1-3]' ORDER BY pc.prd_cd;`

| prd_cd 범위 | 라이브 cat | 라이브 upr | 정답 cat | diff |
|-------------|-----------|-----------|----------|------|
| PRD_000001~015 (15 전부) | **CAT_000293 상품악세사리** | **NULL**(lvl3 고아) | 봉투/케이스→CAT_000276·자석→285·부속→287 | 🔴 **MIS-LOADED** |
| PRD_000283 (이중등록) | **CAT_000276 봉투/케이스** | CAT_000012 포장(lvl2) | CAT_000276 | ✅(반례·교정 패턴 입증) |

**정상 노드 실재 증거:** `SELECT cat_cd,cat_nm,COALESCE(upr_cat_cd,'NULL'),cat_lvl FROM t_cat_categories WHERE cat_cd='CAT_000012' OR upr_cat_cd='CAT_000012';` →
`CAT_000012 포장|NULL|1` · `273 인쇄배경지OPP|012|2` · `274 투명케이스타입|012|2` · `275 인쇄헤더택|012|2` · `276 봉투/케이스|012|2` · `283 라벨/포장스티커|012|2` · `285 포장부자재|012|2` · `287 상품액세서리|012|2` · (고아) `293 상품악세사리|NULL|3` · `295 상품권|NULL|3` · `296 배경지|NULL|3`.

> **결함:** 15 부자재가 정상 노드(276/285/287)를 두고 잉여 고아 293에 묶임. 디지털인쇄 배경지(296)·상품권(295)과 동형. PRD_000283만 정상 연결(반례).

---

## 3. 묶음수 (`t_prd_product_bundle_qtys`) — 단위 혼선·누락

**재현:** `SELECT prd_cd,bdl_qty,bdl_unit_typ_cd,dflt_yn FROM t_prd_product_bundle_qtys WHERE prd_cd ~ 'PRD_00000[1-9]|PRD_0000(1[0-5])|PRD_00028[1-3]' ORDER BY prd_cd,disp_seq;`

| prd_cd | 라이브 bundle | 정답 | diff |
|--------|---------------|------|------|
| PRD_000001 | 50·**QTY_UNIT.01 EA** | 50·매(장) | 🟡 단위 불일치 |
| PRD_000002 | 50·매, 20·매 | 50·20 매 | ✅ |
| PRD_000003 | 100/30/40/20·매 | 4 bundle 매 | ✅ |
| PRD_000004 | 10·매 | 10·매 | ✅ |
| PRD_000005 | 10·매 | 10·매 | ✅ |
| PRD_000009 | 10·EA | 10·개 | ✅ |
| PRD_000011 | 20·EA | 20·개입 | ✅ |
| PRD_000283 | 50·EA | 50 | ✅ |
| **PRD_000006 볼체인** | **0행** | 3·팩(3개1팩) | 🔴 MISSING |
| **PRD_000007 와이어링** | **0행** | (단품) | ✅(묶음 없음) |
| **PRD_000008 천정고리** | **0행** | 2·세트(2개1세트) | 🔴 MISSING |
| **PRD_000010 행택끈** | **0행** | 100·개 | 🔴 MISSING |
| PRD_000012~015 우드/리필 | 0행 | (단품/용량) | ✅(묶음 없음) |

> **결함:** PRD_000001 단위 불일치(EA vs 매). 볼체인 3개1팩·천정고리 2개1세트·행택끈 100개 = bundle 미적재(L-PA-G).

---

## 4. 사이즈 (`t_siz_sizes`+`t_prd_product_sizes`) — 3축 합성 (치수+묶음수+색상 평면화)

**재현:** `SELECT ps.prd_cd,count(*),string_agg(DISTINCT s.siz_nm,' / ') FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd ~ 'PRD_00000[1-9]|PRD_0000(1[0-5])|PRD_00028[1-3]' GROUP BY ps.prd_cd ORDER BY ps.prd_cd;`

| prd_cd | 라이브 siz 행수·siz_nm 샘플 | 정답 치수 행수 | diff |
|--------|-----------------------------|----------------|------|
| PRD_000001 | 11 · `"70x200mm(50장)"` | 11(치수만, "50장" 제거) | 🟡 묶음수 siz_nm 잔존 |
| PRD_000002 | 11 · `"60x90mm(20장)"`·`"60x90mm(50장)"` | 11 | 🟡 잔존(60x90 2묶음은 정당) |
| PRD_000003 | **8** · `"160x110mm(20장)"`·`"160x110mm(40장)"`·`"160x110mm(100장)"` | **3 치수**(묶음수=축②) | 🔴 치수×묶음수 평면화(3치수×묶음 = 8행) |
| PRD_000004 | **2** · `"화이트165x115mm(10장)"`·`"블랙165x115mm(10장)"` | **1 치수**(색상=축③) | 🔴 색상 siz_nm 합성 |
| PRD_000005 | 2 · `"240x230mm(10장)"` | 2 | 🟡 묶음수 잔존 |
| PRD_000009 | 3 · `"PP투명케이스42x57x20mm(10개)"` | 3(3D depth 분해) | 🟡 묶음수·접두 잔존 |
| PRD_000011 | 1 · `"20x20(20개입)"` | 1 | 🟡 묶음수 잔존 |

**치수 분해 증거(OPP접착봉투):** `SELECT s.siz_cd,s.siz_nm,s.cut_width,s.cut_height FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000001';` → SIZ_000078~088, siz_nm="70x200mm(50장)"·cut_width=70·cut_height=200. **치수는 cut_*로 정상 분해됐으나 siz_nm 텍스트에 "(50장)" 묶음수 잔존**(3축 미완분해).

> **결함:** ① 묶음수가 cut_*+bundle_qty 분해됐음에도 siz_nm에 중복(전 봉투). ② 트래싱지(003)는 3치수×묶음수가 8 siz로 평면화(곱셈 오모델). ③ 카드봉투(004)는 색상이 siz_nm에 합성(색상은 축③이어야).

---

## 5. 색상 자재 (`t_prd_product_materials`+`t_mat_materials`) — 색상=자재 오염

**재현:** `SELECT pm.prd_cd,m.mat_cd,m.mat_nm,m.mat_typ_cd,pm.usage_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000006','PRD_000015','PRD_000012','PRD_000007','PRD_000010') ORDER BY pm.prd_cd;`

| prd_cd | 라이브 material | 정답 | diff |
|--------|-----------------|------|------|
| PRD_000006 볼체인 | 8행 MAT_TYPE.10 `"오렌지 (3개1팩)"`~`"화이트 (3개1팩)"` | 색상 8 = option_items | 🔴 색상=자재(MAT_TYPE.10) |
| PRD_000015 리필잉크 | 7행 MAT_TYPE.10 `"청보라 (5cc)"`~`"노랑 (5cc)"` | 색상 7 = option_items | 🔴 색상=자재 |
| PRD_000007 와이어링 | **3행 MAT_TYPE.10** `"실버"`(MAT_000210)·`"화이트"`(212)·`"블랙"`(213) | 색상 3 = option_items | 🔴 색상=자재(GATE-1 정정: 직전 "0행"은 실측 누락) |
| PRD_000010 행택끈 | **3행 MAT_TYPE.10** `"사각검정 (100개)"`(MAT_000217)·`"사각백색 (100개)"`(219)·`"사각마사 (100개)"`(220) | 색상 3 = option_items | 🔴 색상=자재(GATE-1 정정: 직전 "0행"은 실측 누락) |
| PRD_000012 우드거치대 | 1행 MAT_TYPE.10 `"120mm (4mm홈) 내추럴"` | 치수+색상 합성 | 🟡 치수/색상 자재 합성 |

**재실측 증거(GATE-1, 2026-06-11 read-only):** `SELECT pm.prd_cd,m.mat_cd,m.mat_nm,m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000007','PRD_000010') ORDER BY pm.prd_cd,m.mat_cd;` →
PRD_000007: `MAT_000210 실버|MAT_TYPE.10` · `MAT_000212 화이트|MAT_TYPE.10` · `MAT_000213 블랙|MAT_TYPE.10` (3행) · PRD_000010: `MAT_000217 사각검정 (100개)|MAT_TYPE.10` · `MAT_000219 사각백색 (100개)|MAT_TYPE.10` · `MAT_000220 사각마사 (100개)|MAT_TYPE.10` (3행).
색상 자재 오염군 집계: `SELECT pm.prd_cd,count(*) FILTER (WHERE m.mat_typ_cd='MAT_TYPE.10') FROM … WHERE pm.prd_cd IN ('PRD_000006','PRD_000007','PRD_000010','PRD_000012','PRD_000015') GROUP BY pm.prd_cd;` → **006=8·007=3·010=3·012=1·015=7**(전부 MAT_TYPE.10).

> **GATE-1 정정[HARD]:** 직전 본 §5는 007/010을 IN절에 포함했음에도 "0행"으로 기록했다 = 실측 누락(검증자 적발). 재실행 결과 **와이어링 3색·행택끈 3종이 볼체인·리필잉크와 동형으로 색상=자재(MAT_TYPE.10) 오염 적재**. 즉 색상 부자재는 어디에도 없는 게 아니라 **전부 자재로 오염**. 와이어링/행택끈은 MISSING(미적재)이 아니라 MIS-LOADED(색상=자재) — correction-manifest PA-08 재분류 참조.

**옵션 확인(GATE-2 정밀화):** `SELECT og.prd_cd,og.opt_grp_cd,og.opt_grp_nm,count(oi.*) FROM t_prd_product_option_groups og LEFT JOIN t_prd_product_options o ON og.opt_grp_cd=o.opt_grp_cd LEFT JOIN t_prd_product_option_items oi ON o.opt_cd=oi.opt_cd WHERE og.prd_cd IN ('PRD_000001','PRD_000002','PRD_000006','PRD_000007','PRD_000010','PRD_000015') GROUP BY og.prd_cd,og.opt_grp_cd,og.opt_grp_nm;` →
**PRD_000001 OPT-000003 "테스트" items=0** · **PRD_000002 OPT-000001 "제본방식" items=0** · 006/007/010/015 = 옵션그룹 0.

> **결함:** ① 색상 부자재(볼체인 8·리필잉크 7·와이어링 3·행택끈 3) 전부 자재(MAT_TYPE.10)로 오염, 묶음/용량까지 자재명에 합성. ② **테스트 잔재 2행(PRD_000001 "테스트"·PRD_000002 "제본방식", 둘 다 items 0) 제외하면 색상 부자재 정상 옵션 레이어는 0**(GATE-2 정밀화 — 테스트 잔재는 부자재 색상 옵션 아님·논리삭제 후보). 결론 불변: 색상이 옵션으로 안 들어가고 자재로 오염.

---

## 6. template / addon (`t_prd_templates`+`t_prd_product_addons`) — 봉투 세트 (Q-ID-A)

**재현(template):** `SELECT tmpl_cd,base_prd_cd,tmpl_nm,use_yn,del_yn FROM t_prd_templates WHERE base_prd_cd IN ('PRD_000001','PRD_000002','PRD_000281','PRD_000282','PRD_000283') ORDER BY tmpl_cd;`

| tmpl_cd | base_prd_cd | tmpl_nm | del_yn | 정답·diff |
|---------|-------------|---------|--------|-----------|
| TMPL-000004 | PRD_000001 | 봉투(사이즈700x200 50) | **Y** | 봉투 template(삭제됨) |
| TMPL-000005 | PRD_000001 | OPP접착봉투 110x160 mm 50장 | N | ✅ 활성·엽서 addon 참조 |
| TMPL-000006 | PRD_000002 | OPP비접착봉투 110x160 mm 50장 | N | ✅ 활성·참조 0 |
| TMPL-000007 | PRD_000281 | 카드봉투(화이트) 165x115 mm 50장 | **Y** | 삭제됨 |
| TMPL-000008 | PRD_000282 | 카드봉투(블랙) 165x115 mm 50장 | **Y** | 삭제됨 |
| TMPL-000009 | PRD_000283 | 트레싱지봉투 160x110 mm 20장 | N | ✅ 활성·참조 0 |

(TMPL-000001~003 = base PRD_000002 "테스트 템플릿" del_yn=Y — 테스트 잔재.)

**재현(addon):** `SELECT a.prd_cd,p.prd_nm,a.tmpl_cd,t.base_prd_cd,t.tmpl_nm FROM t_prd_product_addons a JOIN t_prd_templates t ON a.tmpl_cd=t.tmpl_cd LEFT JOIN t_prd_products p ON a.prd_cd=p.prd_cd ORDER BY a.prd_cd;` → **PRD_000016(프리미엄엽서)→TMPL-000005(OPP접착봉투) 1행만**(전 DB).

**sets 확인:** `SELECT prd_cd,sub_prd_cd FROM t_prd_product_sets WHERE prd_cd IN ('PRD_000043','PRD_000044') OR sub_prd_cd IN ('PRD_000001','PRD_000002','PRD_000009');` → **0행**(배경지 세트·봉투 하위 없음). 전 sets=28행(PRD_000072 등 타 상품).

> **Q-ID-A 라이브 실체:** 봉투 template **준비됨**(TMPL-000005/006/009 활성). 그러나 ① 배경지(043/044)→봉투 addon=0·sets=0 ② 봉투→배경지 사이즈 매칭 캐스케이드 0 ③ 실 addon 연결은 엽서 1건뿐. **봉투 세트 적재 모델이 결정·적용 안 됨**(MISSING). template은 재사용 가능(search-before-mint).

---

## 7. 가격 (`t_prd_product_price_formulas`+`t_prc_component_prices`) — 전무

**재현:** `SELECT * FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000001','PRD_000006','PRD_000009','PRD_000015','PRD_000281');` → **0행**.
`SELECT count(*) FROM t_prc_component_prices WHERE siz_cd IN ('SIZ_000078','SIZ_000079','SIZ_000080');` → **0**(봉투 사이즈 component 가격 0).

> **결함:** 부자재 15상품 전부 가격 공식 바인딩 0·component 가격 0. **L1 "가격포함" 시트에 단가(1100/3000/16000원 등) 명시인데 라이브 전무**(L-PA-F·MISSING High). round-2 트랙이 부자재를 커버 안 함.

---

## 8. diff 요약

| 축 | 정합 | MIS-LOADED/MISSING | 비고 |
|----|------|---------------------|------|
| 상품행(정체) | 15 적재·prd_nm 일치 | MES 8/15 NULL·천정고리 use_yn=N | 후속 손작업·컨펌 |
| 카테고리 | 1(283 반례) | 15 부자재 고아 293 오연결 | 정상 노드 재연결 |
| 묶음수 | 8 | 001 단위·볼체인/천정고리/행택끈 누락 | — |
| 사이즈 | 치수 분해 OK | 묶음수 siz_nm 잔존·003 평면화·004 색상 합성 | 3축 미완 |
| 색상 | — | 볼체인8·리필7·와이어링3·행택끈3 = 전부 자재 오염(GATE-1) | 정상 옵션 0(테스트잔재 2 제외) |
| template/addon | 봉투 준비 | 배경지 addon/sets 0·Q-ID-A 미결 | search-before-mint |
| 가격 | — | 15상품 전무(L1 단가 있음) | round-2 미커버 |
