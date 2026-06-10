# 아크릴 — 적재 로직 재구성 + 결함 (round-13 · C1)

> **작성** 2026-06-11 · round-13. 라이브 아크릴 상태가 **어떻게 그 값을 얻었는가**를 `tools/load_master.py` + v03 시트로 재구성하고, 발견된 적재 로직 결함을 file:line으로 기록.
>
> **권위 구분(HARD):** `sql/` = 스키마 구조 권위. `load_master.py` = 적재로직 진단 재구성용(정답 아님). **v03 마이그레이션 파일(`data/raw/prdmaster_full_migration_v03_20260518.xlsx`)의 데이터값·전파 결과 = 정답 참조 금지(피고).** `models.py`(inspectdb) = 미사용.

---

## 0. 적재 파이프라인 큰 그림 — **load_master는 v03 시트를 충실 INSERT(변환 거의 없음)**

`load_master.py`(527 LOC, line 3 주석 "Phase 4 single-pass loader (prdmaster v03 excel → Railway PostgreSQL)")는:
- **입력:** `XLSX = "data/raw/prdmaster_full_migration_v03_20260518.xlsx"`(line 39). 사용자 directive가 지목한 **그 v03 파일**.
- **처리:** 각 정규화 시트(`10_상품정보`·`13_상품별사이즈`·`14_상품별자재`·`15_상품별공정`·`16_상품별인쇄옵션` 등)를 읽어 surrogate FK remap(`MAPS[...]`) 후 `executemany` INSERT. **도메인 변환은 거의 없음** — 자재코드·공정코드·사이즈코드를 v03 시트가 준 그대로 매핑.

> **[HARD·근본원인] 결함의 1차 원인은 v03 시트의 정규화가 잘못된 것이고, load_master는 그것을 충실히 전파했다.** 즉 라이브의 두께 소실·UV변형 print_side·usage 미분화는 **load_master 코드의 변환 버그가 아니라, v03 시트(`14_상품별자재`가 192를 주고·`16_상품별인쇄옵션`이 DEFAULT 1행만 주고·`14`가 usage 빈값을 줌)가 그렇게 만들어졌기 때문**이다. 단 일부는 load_master의 하드코딩(line 359)이 결함을 **증폭**한다(아래 D-AC-1).

---

## 1. 속성축별 적재 로직 재구성 (실제 라이브가 그 값을 얻은 경로)

### print_options (UV변형 → print_side) — `load_rel_print_options`, line 352-382

```
357  # 아크릴 굿즈는 도수인쇄가 아니라 UV '변형' 3종으로 나뉨 (사용자 결정 2026-06-03):
358  # 빈 '{PRD}-PRINT-DEFAULT' 행 1개를 아래 3행으로 전개. (print_side, 앞면, 뒷면, 기본여부)
359  ACRYLIC = [("배면양면", c4, c4, "Y"), ("풀빼다", c4, c0, "N"), ("투명테두리", c4, c0, "N")]
366  if str(_norm(r["옵션ID"]) or "").endswith("DEFAULT"):
367      for side, fr, bk, dflt in ACRYLIC:
369          params.append((prd, seq[prd], side, fr, bk, dflt, seq[prd]))
374  params.append((prd, seq[prd], _norm(r["인쇄면"]), cl[f]..., cl[b]..., ...))
379  INSERT INTO t_prd_product_print_options (..., print_side, front_colrcnt_cd, back_colrcnt_cd, ...)
```

**재구성:** v03 `16_상품별인쇄옵션` 시트가 각 아크릴 상품에 `{PRD}-PRINT-DEFAULT` 옵션ID 1행만 부여 → load_master가 그 DEFAULT 1행을 **하드코딩 `ACRYLIC` 3종**(배면양면/풀빼다/투명테두리)으로 전개해 `print_side` 컬럼에 적재(도수=c4 4도/c0 0도 쌍 부여). 그래서 **print_option 보유 20상품이 동일 3행**을 갖는다(검증 SELECT count(DISTINCT prd_cd)=20·각 변형 20건씩). v03 `16`이 머리끈(154)·입체코롯토(168)·입체블럭(169)엔 DEFAULT 행 자체를 안 줘서 이 3상품은 print_option 0행.

**스키마 충돌:** `sql/01b_tables_relations.sql:108` — `print_side varchar(20) -- 인쇄면 (단면/양면)`. UV 변형명(배면양면/풀빼다/투명테두리)은 인쇄"면"이 아니다. **의미축 오적재.**

**[D-AC-1·근본원인 증폭]** line 359 하드코딩은 v03 결함을 **증폭**한다: 코드 작성자가 주석(357-358)에서 "도수 아님·UV 변형"임을 **명시 인지**했음에도, ① 올바른 위치(PROC_000002 변형 param)가 아닌 print_side에 적재했고 ② **상품별 실제 변형을 무시**하고 전 상품에 동일 3종 하드코딩했다. L1 실측(아래 §2)은 상품마다 변형이 다르다(마그넷=단면인쇄/투명테두리/풀빼다, 명찰=풀빼다만, 키링=배면양면만). → 라이브는 상품별 변형 진실을 잃었다.

### materials (두께·부속·usage) — `load_rel_materials`, line 318-333

```
323  # usage_cd는 PK 멤버(NOT NULL); 빈 용도 → USAGE.공통 (사용자 결정 2026-06-03)
324  usage = enum_code("USAGE", r["용도"] or "공통", ref=_norm(r["상품코드"]))
326  params.append((MAPS["PRD"][상품코드], MAPS["MAT"][자재코드], usage, dflt, seq))
```

**재구성:** v03 `14_상품별자재` 시트가 (상품코드·자재코드·용도) 행을 주면 load_master가 그대로 INSERT. **두께·부속 매핑 정확성은 전적으로 v03 시트에 달림.**
- **두께(G-AC-3):** 라이브 실측은 round-3보다 **개선**됨 — 미니파츠=042(1.5mm)·코롯토/포카코롯토=044(8mm)·나머지=043(3mm). 이는 v03 `14` 시트가 두께 구분 자재코드를 주도록 **수정됐음**을 의미(round-3 192 일괄 → 현재 042/043/044). **잔존: 입체블럭(169)만 192**(라미 10T 자재 부재 → 192 폴백).
- **usage(D-AC-2):** v03 `14` 시트가 `용도` 빈값을 주면 line 324가 `USAGE.공통`(USAGE.07)으로 채움. **본체 아크릴(MAT_TYPE.03)도 부속(MAT_TYPE.07)도 전부 USAGE.07** — 본체/부속 용도 미분화. 라이브 실측: 아크릴 33 material 행 전부 USAGE.07.

### processes (UV·완칼·부착) — `load_rel_processes`, line 404-421

```
415  params.append((MAPS["PRD"][prd], MAPS["PROC"][공정코드], eg, _yn(필수공정여부), seq))
```

**재구성:** v03 `15_상품별공정` 시트가 (상품코드·공정코드) 행을 주면 그대로 INSERT(택일그룹 고아는 line 412-414 NULL+inspect). **공정 적재 정확성=전적으로 v03 `15` 시트.**
- **UV(PROC_000002):** 라이브 **14상품** 적재(검증 SELECT count(DISTINCT prd_cd)=14: PRD_000146~152·155·157·158·160~163) — round-3("맥세이프 1상품만")보다 **대폭 개선**(v03 `15` 시트 수정). **잔존: 머리끈(154)·입체코롯토(168)·입체블럭(169) + use_yn=N 6상품(153/156/159/164/165/166) UV 미연결.**
- **완칼(PROC_000053):** **아크릴 전 상품 0건** — v03 `15` 시트가 완칼 행을 **전혀 주지 않음**. master prcs_dtl_opt(`모양 string`)는 존재하나 상품 연결 전무. G-AC-1 미해결.
- **부착(PROC_000081):** 맥세이프(151)+마그넷(147) 2상품만. v03 `15`가 나머지 부속 상품(뱃지/명찰/집게/머리끈)에 부착 행 미부여.

### bundle_qtys (조각수) — `load_rel_bundle_qtys`, line 294-304

**재구성:** v03 `12_상품별묶음수` 시트 기반. 라이브 실측: 자유형스탠드(160)=2~6조각·미니파츠(163)=10조각 적재됨. round-3("0행")보다 **개선**(v03 `12` 수정). G-AC-2 bundle 부분 RESOLVED. 단 **완칼 조각수 param(prcs_dtl_opt)은 별개로 여전히 전무**(완칼 process 자체가 0건이므로).

### addons (볼체인) — `load_rel_addons`(미확인) + Phase7 구조변경

**재구성:** round-3엔 키링/포카키링 addon=PRD_000006 볼체인 1행씩 있었으나, **현재 라이브 addon 0행**. 원인: Phase7 마이그레이션(`sql/10~15`)이 `t_prd_product_addons`를 `addon_prd_cd` → `tmpl_cd`(템플릿 참조)로 재구조화(라이브 실측 컬럼=`prd_cd·tmpl_cd·disp_seq·note`). **구 addon 행이 새 tmpl_cd 구조로 이관되지 않아 소실**(볼체인 전용 template 부재 — t_prd_templates 9행 전부 봉투류). G-AC-7 악화(REMOVED).

### plate_sizes — `load_rel_plate_sizes`, line 336-349

```
340  # 출력용지유형코드는 용지 치수로 들어옴 → 전부 OUTPUT_PAPER_TYPE.기타 (사용자 결정)
346  other if _norm(r["출력용지유형코드"]) is not None else None
```

**재구성:** v03 `17_상품별판형사이즈` 시트 기반. 라이브: 키링/마그넷/뱃지 등 16상품 plate 적재, 코롯토/포카코롯토/카라비너/지비츠/포카스탠드 plate 0행. UV 평판은 전지규격 무의미(L1 출력용지규격 숨김·빈값) — plate 누락이 결함 아닐 수 있음(코롯토류 외주).

### products (nonspec·qty_unit) — `load_products`, line 250-275

**재구성:** v03 `10_상품정보` 기반.
- **nonspec(G-AC-6):** 라이브 실측 — 키링/마그넷/뱃지/집게/스마트톡/맥세이프/명찰/명찰골드실버/머리끈/볼펜/지비츠/코롯토 12상품에 `nonspec_*_min/max` 적재됨(키링 20~100 등). round-3("전 NULL")보다 **개선**(v03 `10` 수정). G-AC-6 대부분 RESOLVED.
- **qty_unit(G-AC-9):** line 269는 `qty_unit_typ_cd=None`(시트10에 원천 컬럼 없음)으로 NULL 적재하나, **라이브 실측은 전 23상품 `QTY_UNIT.01`** — load_master **이후** 별도 backfill(sql 또는 수동)로 채워짐. G-AC-9 RESOLVED.

---

## 2. v03 vs L1 충돌 핵심 — 상품별 인쇄사양 (D-AC-1 증거)

L1(정답 권위) 상품별 실제 `인쇄사양` distinct vs 라이브 print_side(하드코딩 3종 일괄):

| 상품 | **L1 인쇄사양(정답)** | 라이브 print_side(하드코딩) | 충돌 |
|------|----------------------|----------------------------|------|
| 키링(146) | 배면양면 | 배면양면·풀빼다·투명테두리 | 풀빼다·투명테두리 **잉여** |
| 마그넷(147) | **단면인쇄·투명테두리·풀빼다** | 배면양면·풀빼다·투명테두리 | **단면인쇄 누락·배면양면 잉여** |
| 뱃지(148) | 투명테두리·풀빼다 | 배면양면·풀빼다·투명테두리 | 배면양면 잉여 |
| 스마트톡(150) | 투명테두리 | 배면양면·풀빼다·투명테두리 | 배면양면·풀빼다 잉여 |
| 명찰(152) | 풀빼다 | 배면양면·풀빼다·투명테두리 | 배면양면·투명테두리 잉여 |
| 머리끈(154) | (인쇄사양 공백=일반) | (print_option 없음) | UV 공정 자체 누락 |
| 네임택/포카키링/코스터/스탠드류 | 배면양면 | 배면양면·풀빼다·투명테두리 | 풀빼다·투명테두리 잉여 |
| 지비츠★(미등록) | 투명테두리★ | (미등록) | — |

> **핵심:** load_master:359 하드코딩 `ACRYLIC=[배면양면,풀빼다,투명테두리]`가 v03 DEFAULT 1행을 전 상품에 동일 전개 → **상품별 변형 진실 소실**. 이것이 G-AC-5의 적재로직 원인(위치 오류 + 하드코딩 무차별 증폭).

---

## 3. 적재 로직 결함 요약 (file:line)

| ID | 결함 | file:line | 근본원인 | round-3 대비 |
|----|------|-----------|----------|--------------|
| **D-AC-1** | UV변형을 print_side에 하드코딩 3종 일괄 적재(상품별 변형 무시) | `load_master.py:357-369` | 코드 작성자 인지(357 주석)했으나 위치 오류+하드코딩. v03 `16` DEFAULT 1행이 발단 | G-AC-5 동일·미해결 |
| **D-AC-2** | 본체 아크릴도 usage=USAGE.07(공통)로 적재(본체/부속 미분화) | `load_master.py:324` | v03 `14` 시트 `용도` 빈값 → 코드가 공통 폴백. 본체축(USAGE 본체) 부재 | round-3 미규명·신규 |
| **D-AC-3** | 완칼(PROC_000053) 아크릴 전 상품 미적재 | v03 `15_상품별공정`(미부여) | v03 `15` 시트가 완칼 행 전무. load_master는 충실 전파 | G-AC-1 동일·미해결 |
| **D-AC-4** | 입체블럭(169) material=192(두께 소실 잔존) | v03 `14`(라미 자재코드 부재) | 라미(10T) 자재 마스터 부재 → v03이 192 폴백. master에 아크릴 라미 없음 | G-AC-3 잔존(1상품) |
| **D-AC-5** | 볼체인 addon 소실(Phase7 구조변경 미이관) | `sql/10~15`(Phase7) + 미이관 | addon `addon_prd_cd`→`tmpl_cd` 재구조화 시 볼체인 행 미이관(볼체인 template 부재) | G-AC-7 악화 |
| **D-AC-6** | 머리끈(154)·입체코롯토(168)·입체블럭(169) UV 공정 미연결(use_yn=Y 활성) | v03 `15`(미부여) | v03 `15` 시트가 이 상품에 UV 행 미부여 | 부분(round-3 글로벌 UV갭, 현재 잔존 3) |

> **적재 경로 불명 없음** — 모든 라이브 아크릴 값의 출처가 load_master + v03 시트로 재구성됨. (단 qty_unit backfill·nonspec backfill은 load_master 외부 별도 작업으로 추정 — 라이브가 코드 기본값(NULL)과 다른 값을 가짐.)

---

## 4. 라이브가 round-3 이후 진화한 부분 (피고가 일부 개선됨)

round-3 remediation(2026-06-05) 이후 라이브가 **상당 부분 교정됨**(v03 시트 또는 별도 작업 수정):
- 두께: 192 일괄(22상품) → 042/043/044 구분(입체블럭 1상품만 192 잔존).
- 부속 자재: 맥세이프 1상품만 → 키링/뱃지/집게/스마트톡/명찰/머리끈 등 다행 적재.
- UV 공정: 1상품 → 14상품(검증 실측 DISTINCT prd_cd=14).
- 조각수 bundle: 0행 → 자유형스탠드 5행·미니파츠 1행.
- nonspec: 전 NULL → 12상품 적재.
- qty_unit: 전 NULL → QTY_UNIT.01.

**미해결 잔존:** D-AC-1(UV변형 print_side·상품별 무시)·D-AC-2(usage 미분화)·D-AC-3(완칼 전무)·D-AC-4(입체블럭 두께)·D-AC-5(볼체인 소실)·D-AC-6(머리끈/입체 UV 누락)·부속 일부(카라비너 고리/볼펜대/네임택 와이어링 미연결).
