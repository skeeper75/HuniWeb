# 아크릴 — 라이브 실측 vs 정답 diff (round-13 · C3)

> **작성** 2026-06-11 · round-13. 각 상품의 라이브 t_* 행을 읽기전용으로 전수 측정하고 `extraction-plan.md` 정답값과 field-for-field 대조. 비밀값 비노출. 라이브=피고.
>
> **재현 환경:** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "<SQL>"` (read-only). 측정 시각 2026-06-11.

---

## 0. 라이브 전체 분포 (재현 SELECT)

```sql
-- 아크릴 23상품 + 속성 행수
SELECT p.prd_cd, p.prd_nm, p.use_yn,
 (SELECT count(*) FROM t_prd_product_sizes s WHERE s.prd_cd=p.prd_cd) n_size,
 (SELECT count(*) FROM t_prd_product_materials m WHERE m.prd_cd=p.prd_cd) n_mat,
 (SELECT count(*) FROM t_prd_product_processes pp WHERE pp.prd_cd=p.prd_cd) n_proc,
 (SELECT count(*) FROM t_prd_product_print_options po WHERE po.prd_cd=p.prd_cd) n_print,
 (SELECT count(*) FROM t_prd_product_bundle_qtys b WHERE b.prd_cd=p.prd_cd) n_bdl
FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' ORDER BY p.prd_cd;
```

| prd_cd | 상품 | use_yn | size | mat | proc | print | bundle | 라이브 proc 내역 |
|--------|------|:------:|:----:|:---:|:----:|:-----:|:------:|------------------|
| 146 키링 | Y | 8 | 3(본체+고리2) | 1 | 3 | 0 | UV |
| 147 마그넷 | Y | 7 | 1(본체) | 2 | 3 | 0 | UV+부착 |
| 148 뱃지 | Y | 3 | 3(본체+핀+자석) | 1 | 3 | 0 | UV |
| 149 집게 | Y | 3 | 2(본체+집게) | 1 | 3 | 0 | UV |
| 150 스마트톡 | Y | 3 | 3(본체+바디2) | 1 | 3 | 0 | UV |
| 151 맥세이프 | Y | 3 | 1(본체) | 2 | 3 | 0 | UV+부착 |
| 152 명찰 | Y | 3 | 3(본체+핀+자석) | 1 | 3 | 0 | UV |
| 153 명찰골드실버 | N | 3 | 2(골드+실버) | 0 | 3 | 0 | (없음) |
| 154 머리끈 | Y | 3 | 2(본체+헤어끈) | **0** | **0** | 0 | **(UV 없음)** |
| 155 볼펜 | Y | 3 | 1(본체) | 1 | 3 | 0 | UV |
| 156 지비츠 | N | 5 | 1(본체) | 0 | 3 | 0 | (없음) |
| 157 네임택 | Y | 2 | 1(본체) | 1 | 3 | 0 | UV |
| 158 포카키링 | Y | 1 | 1(본체) | 1 | 3 | 0 | UV |
| 159 코스터 | N | 2 | 1(본체) | 0 | 3 | 0 | (없음) |
| 160 자유형스탠드 | Y | 5 | 1(본체) | 1 | 3 | **5** | UV |
| 161 판아크릴 | Y | 2 | 1(본체) | 1 | 3 | 0 | UV |
| 162 포카스탠드 | Y | 1 | 1(본체) | 1 | 3 | 0 | UV |
| 163 미니파츠 | Y | 1 | 1(본체1.5mm) | 1 | 3 | **1** | UV |
| 164 코롯토 | N | 6 | 1(본체8mm) | 0 | 3 | 0 | (없음) |
| 165 포카코롯토 | N | 1 | 1(본체8mm) | 0 | 3 | 0 | (없음) |
| 166 카라비너 | N | 4 | 1(본체) | 0 | 3 | 0 | (없음) |
| 168 입체코롯토 | Y | **0** | **0** | **0** | **0** | 0 | **(전무)** |
| 169 입체블럭 | Y | 2 | 1(**192**) | **0** | **0** | 0 | **(UV 없음)** |

---

## 1. print_options — UV변형 print_side 오적재 (G-AC-5 핵심 diff)

```sql
SELECT po.prd_cd, po.opt_id, po.print_side, po.front_colrcnt_cd, po.back_colrcnt_cd
FROM t_prd_product_print_options po WHERE po.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' ORDER BY po.prd_cd, po.opt_id;
-- 결과: print_option 보유 20상품 전부 (배면양면, 풀빼다, 투명테두리) 3행 하드코딩, 각 변형 20건씩, 도수=CLR_000005(4도)/CLR_000001(0도)
-- 검증 재실행: SELECT count(DISTINCT prd_cd) ... = 20 / SELECT print_side,count(*) ... GROUP BY = 배면양면20·풀빼다20·투명테두리20
-- 제외 3상품: PRD_000154(머리끈, L1 인쇄사양 공백=일반)·168(입체코롯토)·169(입체블럭) = print_option 0행
```

| 상품 | 라이브 print_side | 정답(L1 인쇄사양→PROC변형) | diff |
|------|-------------------|----------------------------|------|
| 146 키링 | 배면양면·풀빼다·투명테두리 | UV 변형=**배면양면만** | MIS-LOADED: print_side에 변형·풀빼다/투명테두리 잉여 |
| 147 마그넷 | 배면양면·풀빼다·투명테두리 | UV 변형=**단면인쇄·투명테두리·풀빼다** | MIS-LOADED: 단면인쇄 누락·배면양면 잉여 |
| 148 뱃지 | 배면양면·풀빼다·투명테두리 | UV 변형=투명테두리·풀빼다 | MIS-LOADED: 배면양면 잉여 |
| 150 스마트톡 | 배면양면·풀빼다·투명테두리 | UV 변형=투명테두리 | MIS-LOADED: 배면양면·풀빼다 잉여 |
| 152 명찰 | 배면양면·풀빼다·투명테두리 | UV 변형=풀빼다 | MIS-LOADED |
| (전 20상품) | 동일 3종 하드코딩 | 상품별 상이 | **위치(print_side) + 무차별(상품별 무시) 이중 오류** |

**판정:** print_option 보유 20상품 print_side에 UV 변형 욱여넣음(`sql:108` print_side="단면/양면" 위반). load_master:359 하드코딩. **MIS-LOADED.**

---

## 2. materials — usage 미분화 + 두께/부속 (재현 SELECT)

```sql
SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd
FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE pm.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' ORDER BY pm.prd_cd;
-- usage_cd 분포: SELECT usage_cd, count(*) ... GROUP BY → USAGE.07 = 33행 (전부)
```

| 항목 | 라이브 | 정답 | diff |
|------|--------|------|------|
| usage_cd(전 33행) | **USAGE.07(공통)** | 본체=본체축·부속=부속축 분화 | MIS-LOADED: 본체/부속 미분화(D-AC-2) |
| 두께 대부분 | 042(1.5)·043(3)·044(8) 정확 | 동일 | **CORRECT** (round-3 192 일괄 대비 RESOLVED) |
| 입체블럭(169) | **MAT_000192**(두께없음) | 라미10T(master 부재) | AMBIGUOUS: 라미 자재 mint vs 192(D-AC-4) |
| 부속 적재됨 | 키링 고리051/052·뱃지 핀047+자석048·집게056·스마트톡 바디053/054·명찰 핀046+자석049·머리끈 헤어끈057·맥세이프055(부착공정으로) | 동일 | **CORRECT** (대거 RESOLVED) |
| 카라비너(166) 부속 | (고리 미연결, 본체043만) | 카라비너 고리 7색 부속 | MISSING: 고리 7색 미연결(master도 부재) |
| 볼펜(155) 부속 | (본체043만) | 볼펜대 6색(variant) | AMBIGUOUS: 볼펜색=variant 컨펌 |
| 네임택(157) 부속 | (본체043만) | 와이어링/스트랩 부속 | MISSING: 와이어링 미연결 |
| 골드실버(153) | 195(골드)·196(실버) | 골드/실버 3mm | CORRECT(두께없는 195/196이 차선·3mm 코드 부재) |

---

## 3. processes — 완칼 전무 + UV 누락 (재현 SELECT)

```sql
SELECT pp.prd_cd, pp.proc_cd, pr.proc_nm FROM t_prd_product_processes pp
JOIN t_proc_processes pr ON pr.proc_cd=pp.proc_cd
WHERE pp.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' ORDER BY pp.prd_cd;
-- 완칼: SELECT count(*) ... WHERE proc_cd IN ('PROC_000053','PROC_000054','PROC_000055') AND prd_cd BETWEEN ... = 0
```

| 항목 | 라이브 | 정답 | diff |
|------|--------|------|------|
| UV(PROC_000002) | **14상품 적재**(검증 SELECT count(DISTINCT prd_cd)=14: 146~152·155·157·158·160~163) | 전 활성상품 필수 | CORRECT(대거 RESOLVED) — 미적재 9 = use_yn=N 6상품(153/156/159/164/165/166) + 머리끈154·입체코롯토168·입체블럭169 |
| **완칼(PROC_000053)** | **아크릴 전 상품 0건** | 형상 굿즈 묵시 필수(판/입체 제외) | **MISSING(G-AC-1)·BLOCKER급** |
| 부착(PROC_000081) | 맥세이프151·마그넷147만 | 뱃지/명찰/집게/머리끈/네임택도 | MISSING: 부착 부분 적재(D-AC-6) |
| 머리끈(154) UV | **0행**(use_yn=Y) | PROC_000002 변형=일반 | MISSING: 활성상품 UV 미연결 |
| 입체블럭(169) UV | 0행 | UV 필요 | MISSING |
| 입체코롯토(168) | 전무 | (외주 명세 부재) | AMBIGUOUS |

---

## 4. bundle_qty / addon (재현 SELECT)

```sql
SELECT prd_cd, bdl_qty FROM t_prd_product_bundle_qtys WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';
-- 160=2,3,4,5,6 / 163=10
SELECT * FROM t_prd_product_addons WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- 0행
SELECT prd_cd,prd_nm,use_yn FROM t_prd_products WHERE prd_nm LIKE '%볼체인%';  -- PRD_000006 볼체인 use_yn=Y (master 건재)
```

| 항목 | 라이브 | 정답 | diff |
|------|--------|------|------|
| bundle 자유형스탠드(160) | 2~6조각 5행 | 2~6 | CORRECT(RESOLVED) |
| bundle 미니파츠(163) | 10조각 1행 | 10 | CORRECT(RESOLVED) |
| 완칼 조각수 param | (완칼 process 0이라 없음) | bundle + 조각수 param 둘 다 | MISSING: 조각수 param 측 |
| **addon 볼체인** | **0행**(키링·포카키링) | PRD_000006 + 9색 | **REMOVED(G-AC-7 악화)** — round-3엔 1행씩 있었음 |
| 볼체인 master | PRD_000006 use_yn=Y 건재 | — | search-before-mint: 재연결 가능 |

---

## 5. size 형상부기 / 차원 (재현 SELECT)

```sql
SELECT s.prd_cd, sz.siz_cd, sz.siz_nm FROM t_prd_product_sizes s JOIN t_siz_sizes sz ON sz.siz_cd=s.siz_cd
WHERE s.prd_cd IN ('PRD_000159','PRD_000166') ORDER BY s.prd_cd;
-- 159: 100x100mm원형, 100x100mm사각 / 166: 40x69mm자물쇠, 43x71mm하트자물쇠, 59x54mm하트, 68x70mm원형
```

| 항목 | 라이브 | 정답 | diff |
|------|--------|------|------|
| 코스터(159) 형상 | siz_nm=`100x100mm원형`·`100x100mm사각` | 형상=완칼 모양 또는 siz 흡수 | CORRECT(형상 siz 보존) — 단 완칼 모양 param 미연결 |
| 카라비너(166) 형상 | siz_nm 4형상 보존 | 동일 | CORRECT(형상 siz 보존) |
| 키링 size 차원 | 작업>재단(50x50=작업60/재단50)·20x20 작업NULL | 작업>재단 | CORRECT(대부분)·20x20 작업 NULL 경미 |
| nonspec 12상품 | 적재됨(키링20~100 등) | 사용자입력 상품 nonspec | CORRECT(RESOLVED) — 단 네임택/포카키링 등 미적재 잔존 |

---

## 6. diff 요약 (정답 대비 라이브 상태)

| 분류 신호 | 건수 개요 |
|-----------|-----------|
| **CORRECT(RESOLVED)** | 두께 042/043/044·부속 다행·UV 14상품·bundle 조각수·nonspec 12·qty_unit·형상 siz보존·size 차원 |
| **MIS-LOADED** | print_side UV변형(20상품·각 변형 20건)·usage 미분화(33행)·상품별 변형 무시 |
| **MISSING** | 완칼 전 상품(BLOCKER)·부착 부분·머리끈/입체 UV·카라비너 고리·네임택 와이어링·완칼 조각수 param |
| **REMOVED** | 볼체인 addon(키링·포카키링) |
| **AMBIGUOUS** | 입체블럭 192/라미·입체코롯토 전무·볼펜색 variant·★상품 정체 |
