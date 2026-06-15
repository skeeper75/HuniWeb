# ② 사이즈축 교정 명세서 (size-correction-spec) — round-22 v2 경로 Y

> **작성** 2026-06-16 · dbm-correctness-auditor(round-13 방법론 · dbm-axis-staged-load round-22 v2). ②사이즈축(`t_siz_sizes`·`t_prd_product_sizes`·`t_prd_product_plate_sizes`) 교정 명세서. ⑥카테고리·④자재 mat_typ와 동일 패턴(라이브 실측 → 권위 대조 → 가역 안전분 / 경로 Y / BLOCKED 3분류). 본 문서는 **교정 명세서**다 — 실 라이브 변경·COMMIT 없음(읽기전용 SELECT + 명세까지).
>
> **권위순서(라이브=교정대상):** ① 상품마스터 260610 + 인쇄상품가격표(`docs/huni/`·`24_master-extract-260610/`·`06_extract/*-l1.csv`) ② webadmin 적재 oracle(`load_master.py`·`sql/`) ③ 스키마 설계의도(OM-1·`schema-design-intent-map`) ④ 확정 도메인(Q7 도무송 칼틀=siz 1:1·`platesize-is-output-paper`·round-10 size→option). **v03 마이그레이션=오염원·정답 아님.**
>
> **[HARD] 비파괴·읽기전용:** 라이브 SELECT만 수행(INSERT/UPDATE/DELETE/DDL 0건). hard-delete 금지(use_yn='N'/페어 제거 제안). webadmin 코드 수정 0.
>
> **★가격사슬 [HARD]:** `t_prc_component_prices.siz_cd`가 ON DELETE CASCADE로 siz에 묶임 → **기계적 size 삭제·재키 절대 금지**(사슬 파손). 본 명세의 모든 교정 후보는 cp 참조수를 SQL로 실측한 뒤 분류했다(아래 §1).

---

## 0. 한 줄 결론 (★실측이 진단을 정정)

②사이즈축은 **02 진단·04 재실측이 시사한 것보다 훨씬 양호**하다. round-22 ②축 교정 = **가역 안전분 0건 · 경로 Y(근본) 소수 · BLOCKED 다수**다. 핵심 정정 3가지:

1. **size↔option 경계(폰기종/등급)는 siz축에 0건** — 라이브 siz_nm 510행 어디에도 아이폰/갤럭시/등급/사이즈등급 없음(SELECT 0). round-10 size→option 우려는 ②자재축(.09/.10)으로 이미 이전됨(04 §1-④ 정합). **②사이즈축 자체는 경계 오염 없음.**
2. **출력판형 vs 완성품 혼동 0건** — 전지(316x467)는 SIZ_000499로 등록됐으나 **product_sizes(완성품) 0건 · product_plate_sizes(판형) 32건** 연결 → 판형축을 정상 사용 중(`platesize-is-output-paper` 정합). 혼동 행 부재.
3. **평면화 오염은 대부분 가격 종속(BLOCKED)** — 묶음(N장)·색상·구수가 siz_nm에 인코딩됐으나 **상품마스터 권위가 그 (치수+묶음/색)을 하나의 사이즈 옵션으로 정의하고 가격을 거기 종속**(카드봉투 화이트 1000원·블랙 1500원). 기계적 분리 = 가격모델 파손 → BLOCKED. EA(칼틀배열)는 도무송 칼틀(Q7) CORRECT.

→ **가역 안전분 0 / 경로 Y 1군(평면화 표기 정정·가격 무영향분) / BLOCKED 4군.** ②축은 가격사슬·가격모델 의존이 깊어 단독 가역 교정이 거의 없다.

---

## 1. 라이브 전수 실측 (2026-06-16·읽기전용 재현 SELECT)

### 1-0. ②축 기준선

```sql
SELECT count(*) total, count(*) FILTER(WHERE impos_yn='Y') impos,
       count(*) FILTER(WHERE del_yn='Y') del, count(*) FILTER(WHERE use_yn='N') use_n
FROM t_siz_sizes;
-- 결과: total=510 · impos=79 · del=53 · use_n=0  (04 재실측과 정확 일치 CONFIRMED)

SELECT count(*) total, count(DISTINCT siz_cd) dsiz
FROM t_prc_component_prices WHERE siz_cd IS NOT NULL;
-- 결과: total=2601 · distinct_siz=116  (가격사슬이 116개 siz를 직접 참조)
```

> **컬럼 구조(NEW 보정):** `t_siz_sizes` = siz_cd·siz_nm·work_width/height·cut_width/height·margin_top/bot/lft/rgt·impos_yn·use_yn·note·del_yn. **size↔option 경계나 평면화는 siz_nm 텍스트에만 잔존**(별도 컬럼 없음).

### 1-1. 평면화·경계·판형혼동 의심 행 실측표 (cp/ps/pl 참조수 포함)

| 발견군 | siz_cd 표본 | siz_nm 예 | 행수 | cp(가격사슬) | ps(완성품) | pl(판형) | 판정 |
|--------|------------|-----------|:--:|:--:|:--:|:--:|------|
| **A 묶음 인코딩** `(N장)/(N개)/(N개입)` | SIZ_000078~110·111 | `160x110mm(20장)` | **34** | **0** | 1~2 | 0 | 가격 묶음종속 → §3 BLOCKED-1 |
| **B 색상 인코딩** | SIZ_000104·105 | `화이트165x115mm(10장)` | **2** | **0** | 1 | 0 | OM-1 오염, 가격 색종속 → §3 BLOCKED-2 |
| **C 구수(치수 무) 인코딩** | SIZ_000406 | `2x2구` | **1** | **0** | 1 | 0 | 치수없음·구수옵션 → §3 BLOCKED-3 |
| **D EA(칼틀배열)** | SIZ_000212~249 | `정사각10x10mm(8EA)` | **26** | **260**(행당 10) | 1 | 0 | 도무송 칼틀 Q7 → §4 CORRECT |
| **E 형상+치수** | SIZ_000355/356/367~369/419~425/501~510 | `원형35x35`·`100x100mm원형` | 다수 | 일부 10 | 1~2 | 0 | 칼틀 1:1 Q7 → §4 CORRECT |
| **F 전지(출력판형)** | SIZ_000499 | `316x467` | 1 | **880** | **0** | **32** | 판형축 정상 → §4 CORRECT |

**재현 SELECT(군별):**

```sql
-- A 묶음: 34행·cp 0
SELECT count(*), sum((SELECT count(*) FROM t_prc_component_prices cp WHERE cp.siz_cd=s.siz_cd))
FROM t_siz_sizes s WHERE del_yn='N' AND siz_nm ~ '\([0-9]+장\)|\([0-9]+개\)|\([0-9]+개입\)';  -- 34 | 0

-- B 색상: 2행·cp 0
SELECT siz_cd, siz_nm, (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.siz_cd=s.siz_cd)
FROM t_siz_sizes s WHERE del_yn='N' AND siz_nm ~ '화이트|블랙' AND siz_nm ~ 'mm';
-- SIZ_000104 화이트165x115mm(10장) | 0 ;  SIZ_000105 블랙165x115mm(10장) | 0

-- D EA: 26행·cp 260(행당 10) — 스티커 칼틀, 가격사슬에 묶임
SELECT count(*), sum((SELECT count(*) FROM t_prc_component_prices cp WHERE cp.siz_cd=s.siz_cd))
FROM t_siz_sizes s WHERE del_yn='N' AND siz_nm ~ '[0-9]+EA';  -- 26 | 260

-- F 전지: product_sizes 0 · plate_sizes 32 (혼동 아님)
SELECT (SELECT count(*) FROM t_prd_product_sizes WHERE siz_cd='SIZ_000499') ps,
       (SELECT count(*) FROM t_prd_product_plate_sizes WHERE siz_cd='SIZ_000499') pl,
       (SELECT count(*) FROM t_prc_component_prices WHERE siz_cd='SIZ_000499') cp;  -- 0 | 32 | 880
```

### 1-2. ★상품마스터 권위 대조 (왜 BLOCKED인가)

평면화가 "오염"이려면 권위(상품마스터)가 그 묶음/색을 사이즈와 분리해 정의해야 한다. **그러나 상품마스터 L1이 정반대를 말한다:**

```
# 06_extract/product-accessory-l1.csv (상품악세사리 가격포함)
012-0007 카드봉투  "화이트 165 x 115 mm (10장)"  가격 1000   ← 사이즈(필수) 셀 = 색+치수+묶음 복합·가격 색종속
012-0007 카드봉투  "블랙 165 x 115 mm (10장)"    가격 1500
012-0009 트래싱지카드봉투 "160 x 110 mm (20장)" 가격 6000   ← 묶음별 가격 다름
012-0009 트래싱지카드봉투 "160 x 110 mm (40장)" 가격 12000
012-0009 트래싱지카드봉투 "160 x 110 mm (100장)" 가격 28000
# 06_extract/goods-pouch-l1.csv (굿즈파우치 가격포함)
키캡키링 "2구" 가격 10000 / "3구" 10000 / "4구" 12000 / "2x2구" 12000  ← 구수=가격축·치수 무
```

> **판정:** 상품마스터(=회사 의도 1차 권위)가 **"치수+묶음(또는 색·구수)"을 하나의 사이즈(필수) 선택지로 정의하고 가격을 거기 종속**시킨다. siz_nm에 묶음/색/구수가 들어간 것은 v03 무변환 전파(ⓐ)이지만, **그 분리가 곧 가격모델 분리(묶음→bundle_qty + 묶음별 단가, 색→option + 색별 단가)를 요구**한다. OM-1 이상형(치수만 siz)은 옳으나, **단독 가역 교정 불가** — 가격모델 동반 재설계가 선결(BLOCKED). cp 참조 0건이라 **가격사슬 직접 파손은 없으나**, product_prices/가격 행이 이 siz 선택지에 종속되므로 표기 정정만으로는 가격 의미가 깨진다.

---

## 2. 가역 안전분 (경로 X 직접 가능·가격 무영향·완전가역) — **0건**

> 가역 안전분 = (a)가격사슬 0참조 (b)가격모델 무종속 (c)완전가역 (d)라이브 직접 UPDATE 가능. ②축은 (b)를 충족하는 단독 교정이 없다.

| ID | 대상 | 현재값 | 정답값 | 가역? | 판정 |
|----|------|--------|--------|:--:|------|
| (없음) | — | — | — | — | ②사이즈축에 가격 무종속 가역 안전분 **0건** |

> **왜 0건인가:** 평면화 의심 전부가 **cp=0(가격사슬 안전)이지만 가격모델 종속**(묶음/색/구수별 가격 행). 표기만 정정(예 `화이트165x115mm(10장)`→`165x115`)하면 그 siz를 참조하는 가격 행이 색/묶음 구분을 잃어 **두 가격(1000/1500)이 한 siz로 충돌**한다. 따라서 단독 가역 불가 → 전부 §3 BLOCKED 또는 §4 CORRECT. ⑥카테고리(가격 무관 1축 UPDATE)와 달리 ②축은 가역 안전분이 구조적으로 없다.

---

## 3. 경로 Y (교정 엑셀 재적재·근본) + BLOCKED 4군

> 경로 Y = v03 입력을 상품마스터 권위로 바로잡은 교정 엑셀 재적재. ②축은 진원 ⓐ(v03 `04_사이즈정보`·`13_상품별사이즈`)이나, **대부분 가격모델 동반 재설계가 선결**이라 순수 경로 Y로 닫히는 건 표기 정정뿐이고 나머지는 BLOCKED.

### 경로 Y-1 — siz_nm 표기 정규화 (가격 무영향분만·근본·가역)

치수만 보존하고 묶음/색을 siz_nm에서 떼는 것은 **가격모델 재설계가 따라올 때만** 경로 Y로 닫힌다. 가격모델 재설계 없이 표기만 바꾸면 가격 충돌(§1-2). 따라서 경로 Y-1은 **BLOCKED-1/2/3 해소(가격모델 결정) 이후** 동반 실행. 단독 실행 금지.

| v03 시트 | 적용 위치 | 정정 내용 | 선결 |
|----------|----------|-----------|------|
| `04_사이즈정보` | siz_nm 컬럼 | `화이트165x115mm(10장)`→치수만 `165x115` (색·묶음 분리) | BLOCKED-2 가격모델 |
| `04_사이즈정보` | siz_nm 컬럼 | `160x110mm(20장)`→`160x110` (묶음 분리) | BLOCKED-1 bundle_qty |
| `04_사이즈정보` | siz_nm 컬럼 | `2x2구`→ siz 행 제거(use_yn N)·구수=option | BLOCKED-3 |

> **★경로 Y 3조건 [HARD]:** 시트명/헤더 v03 동일 · 행순/surrogate 코드 보존(삭제=use_yn='N'·신규 append) · 개발자 재적재. siz는 `issue`가 **엑셀 행순으로 SIZ surrogate 발급**(load_master.py:194·issue:152) → 행 삭제/재정렬 시 후속 SIZ 코드 어긋나 **가격사슬·관계행 파손**. 따라서 siz_nm 값만 정정(행순·코드 불변), 행 제거는 절대 금지.

### BLOCKED-1 — 묶음(N장/N개) 평면화 34행 (가격 묶음종속)

```sql
SELECT s.siz_cd, s.siz_nm, p.prd_nm
FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd
JOIN t_prd_products p ON ps.prd_cd=p.prd_cd
WHERE s.siz_nm ~ '\([0-9]+장\)|\([0-9]+개\)' ORDER BY s.siz_cd;
-- SIZ_000078 70x200mm(50장) OPP접착봉투 / ... / SIZ_000110 PP투명케이스75x110x15mm(10개) 투명케이스
```

| 항목 | 값 |
|------|----|
| 대상 | SIZ_000078~110(봉투/케이스류 34행) |
| 현재 | siz_nm에 `(N장)/(N개)` 묶음수량 인코딩 |
| 정답(OM-1) | 치수만 siz · 묶음수량 → `t_prd_product_bundle_qtys` 또는 주문수량축 |
| **why** | v03 `04_사이즈정보` 무변환 전파(ⓐ). 단 상품마스터 권위가 묶음별 가격을 정의(트래싱지 20장 6000·40장 12000·100장 28000) → 묶음=가격축 |
| **how(BLOCKED)** | 묶음 분리 = 가격모델 재설계(묶음별 단가 행을 bundle_qty 차원으로 이전) 선결. 단독 size 정정 시 가격 충돌. **B-6/round-2 가격축 트랙으로 escalate** |
| 가격사슬 | cp 0건(직접 파손 없음)·product_prices 종속 |
| 심각도 | 🟡 Medium |
| 라우팅 | 🔴 컨펌(가격모델) + round-2 가격축 |

### BLOCKED-2 — 색상 인코딩 2행 (OM-1·가격 색종속)

| 항목 | 값 |
|------|----|
| 대상 | SIZ_000104 `화이트165x115mm(10장)` · SIZ_000105 `블랙165x115mm(10장)` (카드봉투 PRD_000004) |
| 현재 | siz_nm에 색상(화이트/블랙) 인코딩. 동일치수 정상행 SIZ_000500(`165x115`) **별도 존재** |
| 정답(OM-1) | 색→option_items(또는 자재 본체색 합성)·치수만 siz. siz_nm에 색 인코딩 금지 |
| **why** | v03 무변환 전파(ⓐ). 상품마스터 권위: `화이트 165x115mm(10장)`=1000원·`블랙`=1500원 → **색별 가격 다름**(가격 색종속) |
| **how(BLOCKED)** | 색 분리 = 색별 가격(1000/1500)을 option add-price 또는 색차원 단가로 이전 선결. 단 라이브 option_items에 add_price 컬럼 부재(메모리 아크릴 교훈) → 가격은 항상 사슬 → **색차원 단가 재설계 필요**. 정상행 SIZ_000500 재사용(search-before-mint) |
| 가격사슬 | cp 0건 |
| 심각도 | 🟡 Medium |
| 라우팅 | 🔴 컨펌(색 가격모델) + dbm-cpq-option-mapping |

### BLOCKED-3 — 구수(치수 무) 인코딩 (siz 부적격)

| 항목 | 값 |
|------|----|
| 대상 | SIZ_000406 `2x2구` (키캡키링 PRD_000202) |
| 현재 | 치수가 전혀 없는 순수 구수가 siz 행 |
| 정답 | 구수 → bundle_qty 또는 CPQ option. siz 부적격(치수 없음) |
| **why** | v03 무변환 전파(ⓐ). 상품마스터: 키캡키링 `2구`10000·`3구`10000·`4구`12000·`2x2구`12000 → 구수=가격축 |
| **how(BLOCKED)** | siz 행 use_yn='N' + 구수 option/bundle 적재 선결. cp 0건이나 product_sizes 1건 재배선 필요 |
| 가격사슬 | cp 0건 |
| 심각도 | 🟢 Low(1행) |
| 라우팅 | 🔴 컨펌 + dbm-cpq-option-mapping/round-2 |

### BLOCKED-4 — size↔option 경계 (siz축 0건·정상)

| 항목 | 값 |
|------|----|
| 대상 | (폰기종/등급/사이즈등급) — **siz축 0건** |
| 실측 | `siz_nm ~ '아이폰\|갤럭시\|등급\|사이즈등급\|호환'` → **0행** |
| 판정 | round-10 size→option 우려는 ②자재축(.09/.10)으로 이미 이전(04 §1-④·02 §②). **②사이즈축 자체는 경계 오염 없음** |
| 라우팅 | ④자재축 교정(별 트랙)·②축 해당 없음(N/A·BLOCKED 아님) |

---

## 4. CORRECT (교정 대상 아님·반증) — 실측이 정당성 입증

| ID | 대상 | siz_nm | 왜 CORRECT |
|----|------|--------|-----------|
| C-1 | D군 EA 칼틀 26행 | `정사각10x10mm(8EA)` | **도무송 칼틀=siz 1:1(Q7)**. `(8EA)`=한 칼틀에 앉히는 면 개수(스티커 배열). cp **260건**(행당 10) 가격사슬에 묶임 → 면적/배열 가격 정당. 기계 삭제 절대 금지 |
| C-2 | E군 형상+치수 | `원형35x35`·`100x100mm원형` | **칼틀 물리존재=siz(Q7)**. 규격형 도무송 형상. SIZ_000422 cp 10·SIZ_000501~510 원형 cp 10 → 가격사슬. 형상을 siz_nm에 둠이 정답(칼틀 1:1) |
| C-3 | F군 전지 SIZ_000499 | `316x467` | **출력판형(전지)=판형축 정상 사용**. product_sizes(완성품) **0건** · product_plate_sizes(판형) **32건** · cp 880(면적매트릭스). `platesize-is-output-paper` 정합. 완성품-판형 혼동 부재 |
| C-4 | impos_yn=Y 79행 | `73x98`+note `판걸이=18.0/전지=316x467/적용=엽서` | **완성품 치수 + note에 판걸이/전지/적용 메타 보존**(정규 컬럼 아님·앱 런타임 참조). round-11 C6 판걸이=앱·DB미저장 정합. 정상 |

> **★반증 요지:** 형상·EA·전지가 siz_nm에 들어간 것을 02 진단이 "오염 후보"로 봤으나, **실측 결과 전부 가격사슬에 묶인 칼틀(Q7)·판형(plate)이며 권위 정합** → CORRECT. ②축 실 오염은 **묶음/색/구수(가격 종속·BLOCKED)뿐**이고 가역 안전분은 없다.

---

## 5. 3분류 종합 + 가격사슬 영향 경고

### 5-1. 분류 분포

| 분류 | 건수(군) | 행수 | 내용 |
|------|:--:|:--:|------|
| **가역 안전분** | **0** | 0 | ②축에 가격 무종속 단독 가역 교정 없음(구조적) |
| **경로 Y(근본)** | **1군** | ~37 | Y-1 siz_nm 표기 정규화 — 단 BLOCKED 가격모델 해소 동반 필요(단독 불가) |
| **BLOCKED** | **4군** | 묶음34·색2·구수1 + 경계0 | BLOCKED-1 묶음/BLOCKED-2 색/BLOCKED-3 구수(전부 가격종속) · BLOCKED-4 경계(siz축 N/A) |
| **CORRECT(반증)** | **4군** | EA26·형상다수·전지1·impos79 | 칼틀(Q7)·판형(plate)·판걸이note 전부 권위 정합 |

### 5-2. 가격사슬 영향 경고 [HARD]

- `t_prc_component_prices`가 **116개 siz를 2,601행으로 직접 참조**(ON DELETE CASCADE). ②축 어느 행도 **hard-delete·재키 금지**.
- **EA 칼틀(26행·cp 260) + 전지 SIZ_000499(cp 880) + 형상 원형(cp 10/행)** 은 가격사슬 핵심 → CORRECT로 보존(건드리지 말 것).
- **경로 Y siz_nm 표기 정정**은 행순/surrogate 불변(값만 변경)이라 PK 안전하나, **가격모델 분리 없이 표기만 바꾸면 묶음/색별 가격 행이 한 siz로 충돌** → 단독 실행 금지.
- BLOCKED 묶음/색/구수는 cp 직접 참조 0건이라 **사슬 파손 위험은 없으나** product_prices/option 가격 종속 → 가격축(round-2)·CPQ option(dbm-cpq-option-mapping) 트랙에서 동반 처리.

### 5-3. v03 시트 적용 가이드 (경로 Y — 개발자 액션)

| v03 시트 | load_master | 적용 |
|----------|-------------|------|
| `04_사이즈정보` | load_sizes(:194·issue 행순 발급) | siz_nm 값만 정정(행순·코드 불변). 행 제거 금지(=use_yn N로만, 단 siz엔 use_yn 사용 가능) |
| `13_상품별사이즈` | load_rel_sizes(:307) | 묶음/색/구수 분리 시 product_sizes 페어 재배선(가격모델 결정 후) |

> v03 입력 엑셀 실물은 우리 repo 부재(HuniProductPrice2 별도 레포). 개발자가 권위(상품마스터) 기준으로 `04_사이즈정보` siz_nm 정정 + 가격모델 트랙 동반 → `load_master --all` 재적재. **코드 수정 0.**

---

## 6. 검증·라우팅 (dbm-validator X1~X6 대상)

- 본 명세는 생성물 — **dbm-validator X1~X6 독립 검증 대상**(특히 X3 경계오염 0·X5 가격사슬 cp 참조 독립 재현·X4 행순 보존).
- 실 변경·COMMIT은 인간 승인. BLOCKED는 자동 진행 금지.
- **라우팅 분포:** 🔴 컨펌(가격모델) 3건(BLOCKED-1/2/3) · round-2 가격축 1 · dbm-cpq-option-mapping 2 · CORRECT 보존(교정 0).
