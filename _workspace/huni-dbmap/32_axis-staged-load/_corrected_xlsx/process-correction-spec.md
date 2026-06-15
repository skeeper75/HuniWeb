# ⑤ 공정 교정 명세서 (P2·가격 무관·누락 지배) — round-22 v2 경로 Y

> **작성** 2026-06-16 · dbm-correctness-auditor(round-13 방법론·dbm-axis-staged-load round-22 v2). 6축 staged 종단의 ⑤ 공정축(`t_proc_processes`·`t_prd_product_processes`) 교정 명세서. ⑥카테고리·④자재 mat_typ 명세와 동일 패턴(라이브 실측 → 권위 대조 → 가역 안전분 / 경로 Y / BLOCKED 분리).
>
> **권위순서(라이브=교정대상):** ① 상품마스터 260610 + 인쇄상품가격표(`docs/huni/`·`24_master-extract-260610/`) ② webadmin 적재 oracle(`raw/webadmin/tools/load_master.py`·`sql/`) ③ 스키마 설계의도 ④ 확정 도메인(round-11/12 Q1~Q15). **v03 마이그레이션=오염원·정답 아님.**
>
> **[HARD] 비파괴·읽기전용:** 라이브 SELECT만 수행(INSERT/UPDATE/DELETE/DDL 0건). hard-delete 금지(del_yn='Y'). webadmin 코드 수정 0. 실 변경·COMMIT 인간 승인.
>
> **경로:** 경로 Y(교정 엑셀 재적재)가 1순위(진원=ⓐ 입력 v03). v03 입력 엑셀 실물은 우리 repo 부재(HuniProductPrice2 별도 레포) → 엑셀 직접 빌드 불가·적용 가이드로 산출.

---

## 0. 한 줄 결론 (★실측이 진단을 정정)

⑤ 공정 교정은 **누락(MISSING)이 지배**하며, **가격사슬에 0건 묶여 완전 안전**(component_prices.proc_cd 참조=0행·아래 §1-0). 02 진단의 핵심 가정 3건을 라이브 실측이 정정한다:
1. **02 진단 "봉제(080)·부착(081)·에폭시(083) 자식0=상품 미연결"** → 실측: **봉제 5상품·부착 10상품 이미 연결**, 에폭시만 연결0. "자식0"은 hierarchy 자식이 없다는 뜻이지 상품 연결 0이 아니다.
2. **02 진단 "맥세이프 신규 공정 mint"** → 실측: **PROC_000081 부착의 prcs_dtl_opt에 대상=`["라벨","맥세이프","끈","테입"]` 이미 보유** → 맥세이프는 별도 mint 불요(부착+param).
3. **02 진단 "PUR mand N→Y 정정"** → 실측: **포토북(PRD_000100) PUR은 이미 mand=Y**(PB-C3 라이브 부분 교정 완료). PUR책자(070)만 N(메인제본인데 N=의심).

따라서 공정 교정 핵심 = **(a) 봉제 누락 대량 연결**(파우치/필통/백류 49상품 공정0) **(b) 봉제↔부착 오연결 정정**(캔버스 6상품) **(c) 에폭시 연결**(아크릴 입체 3상품) **(d) 보드마운팅·미싱제본 신규 mint**(마스터 부재 search-before-mint 입증).

---

## 1. 라이브 전수 실측 (2026-06-16·읽기전용 재현 SELECT)

### 1-0. ★핵심 안전 실측 — 가격사슬 proc_cd 참조 0건 (공정축 교정 완전 안전)

```sql
SELECT cp.proc_cd, count(*)
FROM t_prc_component_prices cp WHERE cp.proc_cd IS NOT NULL GROUP BY cp.proc_cd;
-- 결과: 0행 (component_prices에 proc_cd 채워진 행 없음)
```

> **판정:** `t_prc_component_prices`(3,396행)는 proc_cd를 **단 1건도 참조하지 않는다**. 공정 마스터 INSERT·연결 INSERT·mand UPDATE·논리삭제 어느 것도 **가격사슬을 파손하지 않는다**(⑥ 카테고리와 동일·완전 안전). 04 재실측이 proc_cd를 차원 컬럼으로 명시했으나 실제 채워진 행은 0 = 공정축 교정 가격 무위험.

### 1-1. 연결상품 0 + 자식 0 공정 (마스터 있으나 미사용 — 31공정)

```sql
SELECT p.proc_cd, p.proc_nm, COALESCE(p.upr_proc_cd,'(root)')
FROM t_proc_processes p
WHERE (SELECT count(*) FROM t_prd_product_processes r WHERE r.proc_cd=p.proc_cd)=0
  AND (SELECT count(*) FROM t_proc_processes c WHERE c.upr_proc_cd=p.proc_cd)=0
ORDER BY COALESCE(p.upr_proc_cd, p.proc_cd), p.proc_cd;
```

| 분류 | 미사용 공정(연결0·자식0) | 판정 |
|------|--------------------------|------|
| 인쇄방식 자식 | 옵셋(003)·디지털(004)·실크(005)·실사(006) | 정상(1상품=1인쇄방식·미사용 방식 보존·CORRECT) |
| 별색 자식 | 클리어(009)·핑크(010)·금색(011)·은색(012) | 정상(별색 옵션 보존·CORRECT) |
| 코팅 자식 | UV코팅(016) | 정상(미사용 옵션·CORRECT) |
| 제본 자식 | 레이플랫제본(025) | AMBIGUOUS(AX-6 포토북 PUR vs 레이플랫 컨펌) |
| 박 자식 | 금(034)·은(035)·핑크(036)·펄박(045)·백박(046)·녹박(047)·금무광(048)·은무광(049) | 정상(박 색상 옵션 보존·CORRECT) |
| 접지 자식 | 가로/세로/2단/4단/5단/6단/8단/4단가로/4단세로/롤접지(057~072 일부) | 정상(접지 변형 옵션 보존·CORRECT) |
| 포장 자식 | 낱개(077)·묶음(078) | 정상(포장 옵션 보존·CORRECT) |
| **굿즈 공정** | **에폭시(083)** | **MISSING**(아크릴 입체 3상품 연결 필요·아래 §2-D) |

> **판정:** 미사용 공정 31개 중 30개는 **옵션 보존(CORRECT)** — 인쇄방식/별색/박색/접지변형은 선택지로 마스터에 있어야 정상이고 미연결이 결함 아니다. **유일한 MISSING = 에폭시(083)**(아크릴 입체에 연결돼야).

### 1-2. 봉제(080)·부착(081)·에폭시(083) 연결 상품 실측 (02 진단 정정)

```sql
SELECT r.proc_cd, pr.proc_nm, r.prd_cd, p.prd_nm, r.mand_proc_yn
FROM t_prd_product_processes r JOIN t_proc_processes pr ON r.proc_cd=pr.proc_cd
JOIN t_prd_products p ON r.prd_cd=p.prd_cd
WHERE r.proc_cd IN ('PROC_000080','PROC_000081','PROC_000083') ORDER BY r.proc_cd, r.prd_cd;
```

| 공정 | 연결 상품수 | 연결 상품 | 02 진단 vs 실측 |
|------|:--:|------|------|
| 봉제(080) | **5** | 린넨패브릭포스터(124)·캔버스패브릭포스터(125)·캔버스 행잉포스터(133)·린넨 우드봉 족자(134)·일반현수막(138) | 02 "자식0=미연결" **정정**: 이미 5상품 연결(패브릭 봉제 정답) |
| 부착(081) | **10** | 일반현수막(138)·메쉬현수막(139)·아크릴마그넷(147)·맥세이프 스마트톡(151)·**캔버스 플랫/삼각 파우치(239/240)·캔버스 플랫/삼각 필통(261/262)·캔버스심플백(268)·캔버스에코백(270)** | 02 "자식0=미연결" **정정**: 이미 10상품 연결. 단 캔버스 6상품=봉제 오연결 의심(§2-B) |
| 에폭시(083) | **0** | (없음) | 02 "자식0" CONFIRMED — 연결0(§2-D 대상) |

### 1-3. PROC param 보유 실측 (variant 표현 가능 여부)

```sql
SELECT proc_cd, proc_nm, prcs_dtl_opt FROM t_proc_processes
WHERE proc_cd IN ('PROC_000079','PROC_000080','PROC_000081','PROC_000082','PROC_000083','PROC_000084','PROC_000030','PROC_000020');
```

| proc_cd | proc_nm | prcs_dtl_opt(param) | 시사점 |
|---------|---------|---------------------|--------|
| PROC_000079 | 타공 | `{구수:int 1~8개}` | param 보유 |
| PROC_000080 | 봉제 | `{유형:enum[오버로크,말아박기,봉미싱], 폭:number mm}` | **봉제 variant 이미 표현 가능**(silsa C-06 봉제 5종 param) |
| PROC_000081 | 부착 | `{대상:enum[라벨,맥세이프,끈,테입]}` | **맥세이프 별도 mint 불요**(부착+대상=맥세이프) |
| PROC_000082 | 족자제작 | `{모양:enum[사각,원형]}` | 족자 variant 표현 가능 |
| PROC_000083 | 에폭시 | (없음·NULL) | param 없는 단순 공정 |
| PROC_000084 | 열재단 | (없음) | 단순 공정·현수막 2상품 정상 연결 |
| PROC_000030 | 미싱 | `{줄수:int 0~3줄}` | **후가공 재봉선**(제본 아님·미싱제본과 의미 충돌) |
| PROC_000020 | PUR제본 | (없음) | 제본 |

### 1-4. 봉제 제품군 공정0 정량 (누락 규모)

```sql
SELECT count(*) FILTER(WHERE procs='(공정0)') AS 공정0, count(*) AS 전체
FROM (SELECT p.prd_cd,
  COALESCE((SELECT string_agg(pr.proc_nm,',') FROM t_prd_product_processes r JOIN t_proc_processes pr ON r.proc_cd=pr.proc_cd WHERE r.prd_cd=p.prd_cd),'(공정0)') procs
  FROM t_prd_products p
  WHERE p.prd_nm ~ '파우치|필통|에코백|토트백|숄더백|클러치|심플백|백팩|보틀백|미니백|코스터' AND p.use_yn='Y') t;
-- 결과: 공정0=49 / 전체=55
```

> **판정:** 패브릭 봉제 제품군(레더/타이벡/메쉬/린넨 파우치·필통·백 등) **55상품 중 49상품이 공정 0행**(봉제 미연결). 캔버스 6상품만 부착으로(오)연결. 봉제 제품군 전반 봉제 공정 누락이 최대 규모 결함.

### 1-5. 코팅=자재 오적재 + PUR mand 실측

```sql
SELECT m.mat_cd, m.mat_nm, m.mat_typ_cd, (SELECT count(*) FROM t_prd_product_materials r WHERE r.mat_cd=m.mat_cd)
FROM t_mat_materials m WHERE m.mat_nm LIKE '%코팅%' ORDER BY m.mat_cd;
```

| mat_cd | mat_nm | mat_typ | 연결 | 판정 |
|--------|--------|:--:|:--:|------|
| MAT_000084 | 비코팅스티커 | .11 | 9 | 자재 정당(비코팅 점착지) |
| MAT_000155 | 무광코팅스티커 | .11 | 8 | 🟡 코팅=자재 vs 공정 CONFLICT(C-ST-04·Q9 미해소) |
| MAT_000156 | 유광코팅스티커 | .11 | 8 | 🟡 동상(AMBIGUOUS) |
| MAT_000165 | 유포지 + 엠보코팅 | .01 | 0 | 코팅 평면화·연결0 고아 |
| MAT_000172 | 하드커버전용지+무광코팅 | .01 | 0 | 코팅 평면화·연결0 고아 |
| MAT_000250 | 아트250+무광코팅 | .01 | 1 | 코팅 평면화(공정 흡수·PB-C2) |
| MAT_000260 | 아트250 + 무광코팅 | .01 | 7 | 코팅 평면화(공정 흡수·PB-C2) |

> PUR mand: PRD_000100 포토북=**Y(이미 교정)**·PRD_000070 PUR책자=N. **코팅 자재 분해는 ④ 자재축 명세 소관**(공정 측은 PROC_000015 무광 연결만 — 라이브 이미 21/30상품 연결돼 있어 공정 측 결함 아님). 본 ⑤ 명세는 코팅의 **공정 측 정합만 확인**(공정 측 정상)·자재 평면화 정정은 ④ 명세로 라우팅.

---

## 2. 교정 명세표 (대상 proc_cd/prd_cd · 현재 · 정답 · 근거 · v03 적용 위치)

> 형식: 각 발견을 분류(가역 안전분 / 경로 Y / BLOCKED). 재현 SELECT는 §1. v03 시트 = `06_공정정보`(마스터)·`15_상품별공정`(연결).

### 2-A. 에폭시 연결 누락 (PROC_000083 → 아크릴 입체 3상품) — MISSING·가역 안전분

| 대상 | 현재 | 정답 | 근거 |
|------|------|------|------|
| PRD_000168 아크릴입체코롯토 | 공정0 | 에폭시(PROC_000083) 연결 | bom·acrylic 입체=에폭시 충전 공정 |
| PRD_000169 아크릴입체블럭 | 공정0 | 에폭시(PROC_000083) | 동상 |
| PRD_000170 아크릴쉐이커★ | 공정0 | 에폭시(083) + (쉐이커=충전물·정체 BLOCKED B-10) | 정체 미확정 상품(아크릴 쉐이커★)=BATCH-14 |

> 에폭시 마스터 실재(083·param 없음)·연결만 INSERT. **단 PRD_000170 쉐이커★는 정체 미확정(B-10)** → 168/169만 가역 안전분, 170은 BLOCKED.

### 2-B. 봉제↔부착 오연결 (캔버스 6상품 081→080) — MIS-LOADED·경로 Y

```sql
SELECT r.prd_cd, p.prd_nm, r.proc_cd, pr.proc_nm
FROM t_prd_product_processes r JOIN t_proc_processes pr ON r.proc_cd=pr.proc_cd
JOIN t_prd_products p ON r.prd_cd=p.prd_cd
WHERE r.prd_cd IN ('PRD_000239','PRD_000240','PRD_000261','PRD_000262','PRD_000268','PRD_000270') ORDER BY r.prd_cd;
-- 전부 PROC_000081 부착
```

| 대상 PRD | 상품명 | 현재 | 정답 | 근거 |
|----------|--------|------|------|------|
| PRD_000239 | 캔버스 플랫 파우치 | 부착(081) | 봉제(080) | GP-C-06·product-bom §6·process-recipe §9(패브릭→봉제미싱) |
| PRD_000240 | 캔버스 삼각 파우치 | 부착(081) | 봉제(080) | 동상 |
| PRD_000261 | 캔버스 플랫 필통 | 부착(081) | 봉제(080) | 동상 |
| PRD_000262 | 캔버스 삼각 필통 | 부착(081) | 봉제(080) | 동상 |
| PRD_000268 | 캔버스심플백 | 부착(081) | 봉제(080) | 동상 |
| PRD_000270 | 캔버스에코백 | 부착(081) | 봉제(080) | 동상 |

> **why·적재로직 원인:** 진원=ⓐ v03 `15_상품별공정`이 캔버스 봉제품을 `부착` 공정코드로 인코딩. `load_rel_processes`(load_master.py:415)는 무변환 전파 → 라이브 081. **정답=봉제(080)**(패브릭 제조=봉제미싱이 본 공정·부착은 라벨/끈 부속용). 단 캔버스에 라벨/끈 부속이 있으면 봉제+부착 2공정 가능(부착 보존 여지) → §3 컨펌.

### 2-C. 봉제 제품군 봉제 누락 (파우치/필통/백 49상품 공정0) — MISSING·BLOCKED(BOM 미확정)

| 대상 | 현재 | 정답 | 판정 |
|------|------|------|------|
| 레더 파우치 7(230~235·238)·미니 5(251~255) | 공정0 | 봉제(080)+유형 param? | 🔴 BLOCKED — 봉제 vs 접착(레더=접착 가능) 상품별 BOM 미확정 |
| 타이벡 파우치/백 11(244~248·273~278) | 공정0 | 봉제(080) 추정 | 🔴 BLOCKED — 타이벡 봉제 여부 BOM 미확정 |
| 메쉬 파우치/백 4(249·250·278·279) | 공정0 | 봉제(080) 추정 | 🔴 BLOCKED |
| 린넨 파우치/백/코스터 다수(191·241·243·265~267·269·271·272 등) | 공정0 | 봉제(080) | 🔴 BLOCKED — 봉제 유형(오버로크/말아박기) 상품별 미확정 |

> **why BLOCKED:** 49상품 전부 봉제로 일괄 연결하는 것은 **상품별 BOM 미확정 상태의 추측**(레더=접착 제조 가능·봉제 유형 param 상품별 다름). round-13 product-bom이 silsa 패브릭(124/125 등 5상품)만 봉제 확정했고, 굿즈 파우치 49상품은 BOM 미작성. **추측 금지 → BLOCKED(B-7·BATCH-13 BOM 선결)**. 가역 안전분 아님.

### 2-D. 신규 공정 mint 후보 (search-before-mint) — BLOCKED(도메인 컨펌)

```sql
SELECT proc_cd, proc_nm FROM t_proc_processes
WHERE proc_nm ~ '보드|마운|삼각|거치|미싱|스탠딩|맥세이프|에폭시|봉제|부착|족자';
-- 결과: PROC_000030 미싱·074 6단미싱접지·080 봉제·081 부착·082 족자제작·083 에폭시
-- 보드마운팅·삼각대거치·미싱제본·스탠딩 = 부재
```

| mint 후보 | search-before-mint 결과 | 정답 처리 | 판정 |
|-----------|--------------------------|-----------|------|
| **미싱제본** | 제본 family(PROC_000017 자식 8종)에 부재. 기존 미싱류 2개(030 미싱=후가공 줄수 param·074 6단미싱접지=접지 자식) **둘 다 제본 family 아님** | (a) PROC_000017 신규 자식 "미싱제본" mint(PROC_000085~) (b) 030 미싱 후가공 재해석 (c) 무선/중철 변형 | 🔴 BLOCKED(Q-ST-A·stationery 172/175/176) |
| **보드마운팅** | 보드/마운팅/스탠딩 공정 마스터 0개 | PROC_000085~ "보드마운팅"(param 색/두께) mint | 🔴 BLOCKED(Q-SL-3·silsa 폼보드/포맥스/미니보드스탠딩 — 타이벡프린트127·메쉬프린트128·미니보드스탠딩144 공정0) |
| **삼각대거치** | 거치/삼각대 공정 마스터 부재(트윈링021·타공079·포장075 존재·거치 없음) | PROC_000085~ "삼각대거치"(param 삼각대색) mint | 🔴 BLOCKED(Q-CAL·calendar C-CAL-07·탁상/미니 캘린더) |
| **맥세이프** | **불요** — PROC_000081 부착 prcs_dtl_opt 대상=`맥세이프` 이미 보유 | 부착(081)+대상=맥세이프 param(신규 mint 아님) | ✅ 02 진단 정정(mint 후보 아님) |

> **mint 채번:** `SELECT max(proc_cd)` = PROC_000084 → 신규 mint=PROC_000085부터(말미 append·경로 Y 3조건). self-ref 부모: 미싱제본=upr PROC_000017(제본)·보드마운팅/삼각대거치=root.

### 2-E. PUR책자 mand 의심 — AMBIGUOUS

| 대상 | 현재 | 정답 후보 | 판정 |
|------|------|-----------|------|
| PRD_000070 PUR책자 | PUR제본 mand=N | PUR이 메인제본이면 mand=Y? | 🟡 AMBIGUOUS — PUR책자는 PUR이 유일 제본이면 mand Y가 자연스러우나, 택일그룹 내 선택지면 N 정당. 제본 mand 분포(§G)가 family마다 혼재 → 컨펌 |
| PRD_000100 포토북 PUR | mand=Y | (정답) | ✅ CORRECT(PB-C3 라이브 이미 교정) |

---

## 3. 가역 안전분 / 경로 Y / BLOCKED 3분류 + SQL (제안·실행 아님)

### 3-1. 가역 안전분 (상품-공정 연결 INSERT·가역·가격 무관) — 2상품

> 마스터 실재 + 연결만 추가 + 정체 확정 + BOM 확정인 것만. 멱등 `INSERT … ON CONFLICT`. 가격사슬 proc_cd 0건 참조(§1-0)라 완전 안전. **경로 X(라이브 직접) 보조 가능하나 P-TRUNCATE 재적재 시 소멸** → 경로 Y 권장.

```sql
-- 에폭시 연결: 아크릴입체코롯토·블럭(정체 확정·BOM=에폭시 충전 확정). 쉐이커★ 제외(B-10)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
VALUES ('PRD_000168','PROC_000083','Y',10),
       ('PRD_000169','PROC_000083','Y',10)
ON CONFLICT (prd_cd, proc_cd) DO NOTHING;  -- 멱등
```

### 3-2. 경로 Y (교정 엑셀 재적재·근본) — 봉제↔부착 정정 6상품

> 진원=ⓐ v03 `15_상품별공정`. 라이브 직접 UPDATE(경로 X)는 P-TRUNCATE 소멸. 근본=v03 교정 후 재적재.

```sql
-- 경로 X(보조·다음 재적재 전까지만 유효): 캔버스 6상품 부착(081)→봉제(080) 재연결
-- ★단 부착이 라벨/끈 부속용이면 봉제+부착 2공정 — 컨펌 후 결정(§4 Q-PROC-1)
UPDATE t_prd_product_processes SET proc_cd='PROC_000080', upd_dt=now()
WHERE proc_cd='PROC_000081'
  AND prd_cd IN ('PRD_000239','PRD_000240','PRD_000261','PRD_000262','PRD_000268','PRD_000270');
```

**경로 Y(근본) v03 적용:** `15_상품별공정` 시트에서 캔버스 6상품(상품코드)의 `공정코드` 셀을 `부착`→`봉제`로 교정 + 봉제 param(유형) 채움. **시트명/헤더 v03 동일·행순 보존 [HARD]**(load_rel_processes는 surrogate 미발급이라 행 UPDATE 안전·삭제/재정렬 금지).

### 3-3. BLOCKED (신규 mint 도메인 컨펌·BOM 미확정·정체 미확정) — 5종

| # | 항목 | 사유 | 컨펌 ID |
|:--:|------|------|------|
| BL-1 | 봉제 제품군 49상품 봉제 연결 | 상품별 BOM 미확정(레더=접착 가능·봉제 유형 param 미정·추측 금지) | B-7·BATCH-13 BOM 선결 |
| BL-2 | 미싱제본 신규 mint | (a)신규자식 (b)030 재해석 (c)변형 미결정 | Q-ST-A |
| BL-3 | 보드마운팅 신규 mint | 마스터 부재·param 색/두께 미정(타이벡127·메쉬128·미니보드144 공정0) | Q-SL-3 |
| BL-4 | 삼각대거치 신규 mint | 마스터 부재·삼각대색 param 미정 | Q-CAL |
| BL-5 | 아크릴쉐이커★ 에폭시 연결 | 정체 미확정(쉐이커=충전물 종류 불명) | B-10·BATCH-14 |
| BL-6 | PUR책자(070) mand | mand 정답 불명(택일 vs 필수) | Q-PROC-2 |
| BL-7 | 코팅스티커 자재 vs 공정 | C-ST-04 Q9 CONFLICT(④ 자재축 소관) | Q-ST-A(sticker) |

**신규 mint 후보 수 = 3종**(미싱제본·보드마운팅·삼각대거치 — 전부 BLOCKED·search-before-mint 부재 입증·PROC_000085~ 채번). 맥세이프는 mint 불요(부착 param).

---

## 4. v03 시트 적용 가이드 (경로 Y — 개발자 액션)

> v03 입력 엑셀 실물=우리 repo 부재(HuniProductPrice2 별도 레포). 아래는 개발자가 v03에 반영·우리가 실물 확보 후 엑셀화할 때의 적용 위치. **시트명/헤더 v03 동일·행순/surrogate 보존 [HARD] 경로 Y 3조건.**

### 4-1. `15_상품별공정` 시트 (load_master.py:405·헤더 `상품코드·공정코드·택일그룹코드·필수공정여부·표시순서`)
- **봉제↔부착 정정(§2-B):** 캔버스 6상품 행의 `공정코드`를 `부착`→`봉제`(또는 봉제 행 추가·부착 보존은 Q-PROC-1). load_rel_processes는 surrogate 미발급 → 행 UPDATE/추가 안전(행 삭제·재정렬 금지).
- **에폭시 연결(§2-A):** PRD_000168/169 에폭시 연결 행 **말미 append**(PRD_000170은 BL-5 보류).
- **봉제 누락(§2-C·BLOCKED):** BOM 확정 후 49상품 봉제 행 append(현 단계 보류).

### 4-2. `06_공정정보` 시트 (load_master.py:211·헤더 `공정코드·공정명·부모공정코드·공정상세옵션·표시순서·사용여부·비고`)
- **신규 mint(§2-D·BLOCKED):** 컨펌 후 미싱제본(부모공정코드=제본)·보드마운팅·삼각대거치 행을 **말미 append**(기존 행순/surrogate 보존). issue가 엑셀 행순으로 PROC surrogate 발급 → 기존 행 위로 삽입 금지(PROC_000001~084 코드 어긋남). 새 행은 항상 맨 끝.
- 봉제/부착/족자 param은 이미 보유 → 시트 변경 불요(silsa 봉제 5종·맥세이프는 기존 param 활용).

### 4-3. 경로 X(라이브 직접 SQL·보조·다음 재적재 전까지만 유효)
- §3-1 에폭시 INSERT·§3-2 봉제 UPDATE는 가역. **load_master --all 재적재 시 소멸**(P-TRUNCATE·B-1) 명시 필수. 권장=경로 Y.

---

## 5. 적재 로직 근거 (loadlogic — why)

- **공정 발생 진원 = ⓐ v03 입력**(03 분석 CONFIRMED). `load_processes`(load_master.py:210-224)는 06시트 셀을 무변환 INSERT + 부모공정 UPDATE만 수행 — 공정 누락·오연결을 만들지 않고 전파만. `load_rel_processes`(:404-421)도 15시트 prd↔proc 페어를 무변환 INSERT(택일그룹 고아만 NULL+inspect).
- **봉제↔부착 오연결 진원:** v03 15시트가 캔버스 봉제품을 `부착` 공정코드로 적음 → 무변환 전파. **코드 결함 아님**(load_rel_processes는 충실 전파자).
- **봉제 누락 진원:** v03 15시트에 굿즈 파우치 49상품의 공정 행 자체가 없음(load 무도출) → 라이브 공정0. **정답=상품마스터/BOM 권위로 봉제 행 신설**(v03 보완).
- **신규 mint 진원:** v03 06시트에 미싱제본/보드마운팅/삼각대거치 공정 행 부재 → 마스터 부재. 정답=상품마스터 가공 컬럼 권위로 공정 mint(v03 06시트 append).
- **why 정답 기준:** round-11/12 product-bom + process-recipe-tree(§9 패브릭=봉제·§3 제본) + Q9(코팅=공정). v03 미참조.

---

## 6. 개발자 액션 요약

1. **(가역 안전분)** PRD_000168/169 에폭시 연결(경로 X 가능·가격 무관·즉시 안전) 또는 경로 Y 15시트 append.
2. **(경로 Y·근본)** v03 `15_상품별공정` 캔버스 6상품 부착→봉제 정정(Q-PROC-1 봉제 단독 vs 봉제+부착 컨펌 후). `load_master --all` 재적재.
3. **(BLOCKED·컨펌)** 봉제 49상품 BOM 선결(B-7)·미싱제본/보드마운팅/삼각대거치 mint(Q-ST-A·Q-SL-3·Q-CAL)·쉐이커★ 정체(B-10)·PUR책자 mand(Q-PROC-2)·코팅스티커(Q9).
4. **(검증)** 재적재 후 §1-2 SELECT 재실행 → 봉제 연결·에폭시 연결 발효 확인. dbm-validator X1~X6 독립 게이트.

---

## 7. 분류 분포 + 컨펌 큐

| 분류 | 건수 | 항목 |
|------|:--:|------|
| CORRECT(정정·반증) | 3 | 미사용 옵션 공정 30개(인쇄방식/별색/박색/접지/포장 보존)·포토북 PUR mand=Y(PB-C3 이미 교정)·코팅 공정 측 정합 |
| MIS-LOADED | 1 | 봉제↔부착 오연결 캔버스 6상품(§2-B·경로 Y) |
| MISSING | 2 | 에폭시 연결 아크릴 입체(§2-A 가역)·봉제 누락 49상품(§2-C BLOCKED) |
| EXTRA | 0 | (공정 잉여 적재 없음·미사용 옵션은 정상 보존) |
| AMBIGUOUS | 2 | PUR책자 mand(§2-E)·레이플랫제본 미사용(AX-6) |

**가역 안전분 수 = 2상품**(에폭시 168/169) · **경로 Y 수 = 6상품**(봉제↔부착 캔버스) · **BLOCKED 수 = 7종**(봉제49·미싱제본·보드마운팅·삼각대거치·쉐이커★·PUR책자mand·코팅스티커) · **신규 mint 후보 수 = 3종**(미싱제본·보드마운팅·삼각대거치·전부 BLOCKED·search-before-mint 부재 입증).

### 컨펌 큐 (인간 승인·escalate)
- **Q-PROC-1** [🟡·핵심] 캔버스 6상품 부착→봉제 정정 시 **봉제 단독**인가 **봉제+부착(라벨/끈 부속)** 2공정인가? (부착 param 대상=라벨/끈 존재)
- **Q-PROC-2** [🟡] PUR책자(070) PUR제본 mand=N → 메인제본이면 Y? (제본 mand family 혼재)
- **B-7/BATCH-13** [🔴] 봉제 49상품 BOM 확정(레더=봉제 vs 접착·봉제 유형 param 상품별).
- **Q-ST-A/Q-SL-3/Q-CAL** [🔴] 미싱제본·보드마운팅·삼각대거치 신규 mint(PROC_000085~·search-before-mint 부재 입증 완료).
- **B-10/BATCH-14** [🔴] 아크릴쉐이커★ 정체 확정 후 에폭시 연결.

---

## 8. 비파괴·게이트

- **DB 미적재 [HARD]:** 본 명세는 교정 제안까지. 실 COMMIT/연결 INSERT/공정 mint/mand UPDATE/논리삭제(del_yn)는 round-5·개발자 협업·인간 승인.
- **hard-delete 금지:** product_processes는 use_yn 부재·**del_yn 보유** → 논리삭제=del_yn='Y'. 단 본 명세에 EXTRA 0건 = 논리삭제 대상 공정 없음(미사용 옵션은 보존).
- **생성≠검증:** 본 명세는 dbm-validator X1~X6 독립 게이트 대상(X1 권위정합·X2 freshness·X3 경계오염0·X4 구조보존·X5 재적재검증·X6 비파괴·코드불변).
