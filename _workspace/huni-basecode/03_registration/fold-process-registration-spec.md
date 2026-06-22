# 등록 명세 — 접지방식 공정코드 3건 (`t_proc_processes`) — §21 접지카드 과대청구 교정 선행

> **하네스** hbg Phase 3 설계가 · 접지 섹션. **작성** 2026-06-23.
> **입력:** §21 `09_load/_overcharge_foldcard_260623/`(fold-remediation-mapping.csv·apply.sql·README) · `06_gate/overcharge-remediation-spec.md` V2 · `04_price_engine/overcharge-scan-catalog.md` OC-04/05/06.
> **권위:** 인쇄상품 가격표 260527 접지방식 명칭(절대권위) · 라이브 `t_proc_processes`(2026-06-23 read-only SELECT 재실측).
> **재사용:** dbmap `00_schema/code-identifier-strategy.md`(PROC 채번 규칙) · `regspec-process.md`(공정 축 컨벤션).
> **[HARD] 명세 ≠ 적용.** 실 INSERT 0 · 기초코드 공유 마스터 직접수정 0 · webadmin 코드 직접수정 0 · 실 적용 인간 승인 후 dbmap `dbm-load-execution` 위임.

---

## 0. 한 줄 평결

§21 접지카드(PRD_000027/028/029) 과대청구 교정에 필요한 **접지방식 4 comp(택일 분리용 proc_cd)** 중 **3단접지(PROC_000060)만 라이브 실재**. 나머지 3건을 등록 명세로 도출:
- **4단병풍접지(4ACC)** = **PROC_000071(병풍접지) 재사용 권고** (search-before-mint 적중 — 동일물).
- **4단대문접지(4GATE)** = **신규 PROC_000106 등록** (명칭 전무·별개 공정).
- **반접지(HALF)** = **신규 PROC_000107 등록** (명칭 전무·PROC_000059 "2단접지"와 혼동 금지·별개 공정).

→ **신규 mint = 2건**(4GATE·HALF), **재사용 = 1건**(4ACC). 전부 PROC_000056("접지" 그룹) 하위.

---

## 1. 라이브 재실측 (2026-06-23 read-only SELECT)

### 1.1 접지 그룹 현황 (`upr_proc_cd='PROC_000056'` 18 자식)

| proc_cd | proc_nm | disp_seq | use_yn | del_yn | §21 매핑 |
|---------|---------|:--:|:--:|:--:|---------|
| PROC_000056 | **접지**(그룹 head·upr=NULL) | 15 | Y | N | proc_grp 토큰 = `proc_grp:PROC_000056` |
| PROC_000059 | 2단접지 | 3 | Y | N | ★반접지 **아님**(별개·혼동 금지) |
| PROC_000060 | **3단접지** | 4 | Y | N | **3FOLD 재사용**(실재) |
| PROC_000061 | **4단접지** | 5 | Y | N | ★4ACC·4GATE **아님**("단수"만 가리킴·접지방식 형태 미특정) |
| PROC_000071 | **병풍접지** | 15 | Y | N | **4ACC 후보**(재사용 판정 §2.1) |
| (그외 13행) | 가로/세로/2단가로/.../롤/6단오시/6단미싱 접지 | 1~18 | Y | N | 무관 |

> **대문접지·게이트·반접지·아코디언 명칭 전무** 확인(LIKE '%대문%'·'%게이트%'·'%반접%'·'%아코디언%' → 0행, "반칼"은 무관 공정).

### 1.2 채번 기준

```
SELECT max(CAST(substring(proc_cd from 6) AS int)) FROM t_proc_processes WHERE proc_cd ~ '^PROC_[0-9]+$';
→ max_num = 105 (MAX proc_cd = PROC_000105, total 105행)
```
→ **신규 채번 = PROC_000106, PROC_000107** (MAX+1·separator `_`·zero-pad 6자리·dbmap code-identifier-strategy 준수).

### 1.3 FK·가격사슬 참조 (돈 크리티컬 체크)

| proc_cd | component_prices 참조 | product_processes(BOM) 참조 |
|---------|:--:|:--:|
| PROC_000060(3단접지) | **0** | 1 |
| PROC_000061(4단접지) | **0** | 0 |
| PROC_000071(병풍접지) | **0** | 1 |

> **가격사슬 직접 영향 0** — 후보 공정코드 어느 것도 `t_prc_component_prices.proc_cd`에 현재 참조 없음(접지비 단가행은 comp_cd=COMP_FOLD_LEAF_*가 보유·proc_cd 컬럼은 현재 NULL). §21 교정이 그 NULL을 채우는 것. 신규 코드 등록 자체는 단가값 0변경(verbatim 불변).

---

## 2. 등록 명세 — 3건

### 2.1 건① 4단병풍접지(4ACC) → **PROC_000071 재사용 권고** [CONDITIONAL→RESOLVE]

| 명세 단위 | 내용 |
|-----------|------|
| **판정** | **재사용**(신규 mint 0). PROC_000071 "병풍접지" = 가격표 260527 "4단병풍접지(아코디언)"과 **동일물**. |
| **search-before-mint 사다리** | **1단(기존 코드행)에서 정지** — 병풍접지=아코디언폴드의 한국어 표준명. 가격표가 "4단"을 수식어로 붙였을 뿐 형태(병풍/아코디언)는 PROC_000071이 이미 표현. "4단"은 페이지 단수(=4단접지 PROC_000061과 직교)지 별개 공정 형태가 아님. → **신규 그릇 mint 불요**. |
| **★"4단" 한정 우려 해소** | 라이브 PROC_000071이 "4단" 한정 없는 일반 "병풍접지"여도 문제 없음 — 접지카드(027/028/029)는 4페이지 고정 상품이라 이 컨텍스트에서 병풍접지=4단병풍. 단수 분화가 필요하면 prcs_dtl_opt param("단수")으로 표현(신규 코드행 아님·data-gap). |
| **대상 t_* + 코드값** | `t_proc_processes` **PROC_000071**(기존·proc_nm="병풍접지"·upr_proc_cd=PROC_000056). **변경 0**(재사용만). |
| **FK 위상** | 등록 액션 0(이미 실재). §21 단가행에 `proc_cd='PROC_000071'` 충전만(가격 트랙). |
| **영향분석** | 마스터 변경 0. PROC_000071 BOM 참조 1건 — 그 상품의 의미와 충돌 없음(병풍접지 그대로). 롤백 = §21 단가행 proc_cd NULL 복원만(마스터 무관). |
| **컨펌** | **CONF-FOLD-1**: "가격표의 '4단병풍접지(아코디언)' = 라이브 '병풍접지'(PROC_000071)와 같은 공정인지" 인간 1회 확인 → YES면 재사용 확정. 권고=YES. |

### 2.2 건② 4단대문접지(4GATE) → **신규 PROC_000106 등록** [BLOCKED→SPEC]

| 명세 단위 | 내용 |
|-----------|------|
| **판정** | **신규 등록**(mint 1). 대문접지(게이트폴드) 명칭 라이브 전무 — 별개 공정 형태. |
| **search-before-mint 사다리** | **1단(기존 코드행) 불가 입증:** ① 명칭 전무(LIKE '%대문%'·'%게이트%' → 0행). ② PROC_000061("4단접지")은 단수만 가리킴(형태=대문 미특정·매핑 시 의미 오염). ③ PROC_000071(병풍)은 다른 형태(아코디언 ≠ 게이트). → 기존 코드행/컬럼/JSONB/junction 어느 것으로도 "대문접지"라는 **별개 공정 형태**를 표현 불가 → **신규 코드행 mint 정당**. (그릇=기존 t_proc_processes 테이블·신규 테이블/컬럼 0.) |
| **대상 t_* + 코드값** | `t_proc_processes` **PROC_000106** (신규). |
| **등록 행 값** | `proc_cd='PROC_000106'` · `proc_nm='4단대문접지'`(가격표 260527 명칭) · `upr_proc_cd='PROC_000056'`(접지 그룹) · `disp_seq=19`(접지 그룹 자식 마지막 disp_seq=18 다음·MAX+1) · `use_yn='Y'` · `del_yn='N'` · `prcs_dtl_opt=NULL` · `note=NULL` · `reg_dt=now()`(DEFAULT). |
| **채번 규칙** | `PROC_` + lpad(MAX+1=106, 6) = `PROC_000106`. 이름 기반 멱등키 = proc_nm slug(`4단대문접지`) — 재실행 시 동명 행 존재하면 skip(NOT EXISTS 가드). |
| **FK 위상 적재순서** | **① 마스터 행 선적재**(PROC_000106 INSERT to t_proc_processes) → **② §21 단가행 proc_cd 충전**(COMP_FOLD_LEAF_4GATE 48행에 proc_cd='PROC_000106')·use_dims 토큰 등재. self-FK(upr_proc_cd→PROC_000056) 충족(부모 실재). component_prices.proc_cd FK 충족(부모 마스터 선적재). |
| **적재경로(webadmin)** | catalog Django admin **`/admin/catalog/tprocprocesses/add/`**(모델 `TProcProcesses`·db_table=`t_proc_processes`·admin.py 제너릭 ModelAdmin 등록 확인). 폼 입력: proc_nm="4단대문접지"·upr_proc_cd 트리 드롭다운에서 "접지(PROC_000056)" 선택·use_yn=Y 드롭다운·disp_seq=19. proc_cd는 **자동채번 트리거**(미신설 시 수동 PROC_000106 입력·code-identifier-strategy §5 트리거 제안 미적용 상태). |
| **영향분석** | 신규 행 INSERT만(기존 행·FK 파손 0). component_prices 단가값 0변경(verbatim). 백필 0. 롤백 = 행 del_yn='Y' 또는 DELETE(§21 단가행 proc_cd NULL 복원 선행). |

### 2.3 건③ 반접지(HALF) → **신규 PROC_000107 등록** [BLOCKED→SPEC] ★혼동 금지

| 명세 단위 | 내용 |
|-----------|------|
| **판정** | **신규 등록**(mint 1). 반접지 명칭 라이브 전무. |
| **★PROC_000059(2단접지)와 혼동 금지 근거 [HARD]** | "반접지"와 "2단접지"는 **별개 공정**: ① **물리 형태 상이** — 반접지=용지를 절반으로 1회 접어 2면(1폴드·2패널), 2단접지=같은 결과지만 "단(段)" 명명 체계(가격표는 명시적으로 "반접지" 5,000원 별도 단가 부여·"2단접지" 아님). ② **가격표 권위가 둘을 구분** — 260527 접지방식 밴드에 "반접지"가 독립 라벨로 존재(단가 5,000). ③ **PROC_000059로 매핑하면 단가행 proc_cd가 "2단접지"를 가리켜 의미 오염** — 운영자/위젯이 "2단접지" 선택지로 오표시. → **별개 코드 등록 정당**(2단접지 코드 재사용 금지). |
| **search-before-mint 사다리** | **1단(기존 코드행) 불가 입증:** 명칭 전무 + PROC_000059는 다른 공정(위 혼동 금지 근거) → 신규 코드행 mint 정당(기존 테이블·신규 테이블/컬럼 0). |
| **대상 t_* + 코드값** | `t_proc_processes` **PROC_000107** (신규). |
| **등록 행 값** | `proc_cd='PROC_000107'` · `proc_nm='반접지'`(가격표 260527 명칭) · `upr_proc_cd='PROC_000056'`(접지 그룹) · `disp_seq=20`(4GATE 다음) · `use_yn='Y'` · `del_yn='N'` · `prcs_dtl_opt=NULL` · `note='1폴드 2패널(2단접지와 별개)'`(혼동 가드 메모·선택) · `reg_dt=now()`. |
| **채번 규칙** | `PROC_` + lpad(107, 6) = `PROC_000107`. 멱등키 = proc_nm slug(`반접지`)·NOT EXISTS 가드. |
| **FK 위상 적재순서** | **① 마스터 행 선적재**(PROC_000107 INSERT) → **② §21 단가행 충전**(COMP_FOLD_LEAF_HALF 48행 proc_cd='PROC_000107'). self-FK·component_prices FK 충족(부모 선적재). |
| **적재경로(webadmin)** | catalog `/admin/catalog/tprocprocesses/add/`. proc_nm="반접지"·upr_proc_cd="접지(PROC_000056)"·use_yn=Y·disp_seq=20. ★등록 시 "2단접지(PROC_000059)와 별개" 운영자 주의(note 활용). |
| **영향분석** | 신규 행 INSERT만(파손 0). PROC_000059 무변경(2단접지 그대로 보존). 단가값 0변경. 롤백 = 행 제거(§21 단가행 NULL 복원 선행). |

---

## 3. FK 위상 통합 적재순서 (§21 접지카드 교정과 연결)

```
[Phase A — 기초코드 마스터 (본 §12 명세·인간 승인 후 dbm-load-execution)]
  A-1. PROC_000071 재사용 확정 (액션 0·CONF-FOLD-1 YES)
  A-2. INSERT PROC_000106 '4단대문접지' (upr=PROC_000056)   ┐ 마스터 선적재
  A-3. INSERT PROC_000107 '반접지'      (upr=PROC_000056)   ┘ (self-FK 부모 PROC_000056 실재)
         ↓ (component_prices.proc_cd FK 충족 — 부모 마스터 선행)
[Phase B — §21 접지카드 단가행 교정 (apply.sql STEP 2~4 활성·가격 트랙)]
  B-1. COMP_FOLD_LEAF_4ACC  → proc_cd='PROC_000071'  (재사용)
  B-2. COMP_FOLD_LEAF_4GATE → proc_cd='PROC_000106'  (신규)
  B-3. COMP_FOLD_LEAF_HALF  → proc_cd='PROC_000107'  (신규)
  B-4. (STEP 1 기존) COMP_FOLD_LEAF_3FOLD → proc_cd='PROC_000060' (실재)
  B-5. use_dims 4건 전부 ["proc_cd","min_qty","proc_grp:PROC_000056"] 등재
         ↓
[Phase C — 검증]
  C-1. verbatim 가드: 단가행 합 불변(25,000 그대로·proc_cd만 분화)
  C-2. evaluate_price 실호출: 027/028/029 접지비 25,000 → 6,000(택일 1개) 재현
```

> **[HARD] Phase A(마스터) 반드시 Phase B(단가행) 선행** — component_prices.proc_cd → t_proc_processes FK. 부재 코드 충전 시 FK 위반으로 트랜잭션 즉시 실패(apply.sql 주석이 이미 경고).

---

## 4. webadmin 적재경로 요약

| 건 | 화면 | 모델 | 폼 입력 |
|----|------|------|---------|
| 4ACC(재사용) | — (등록 불요) | — | §21 가격 트랙에서 단가행 proc_cd만 충전 |
| 4GATE(신규) | catalog Django `/admin/catalog/tprocprocesses/add/` | `TProcProcesses`(db_table=t_proc_processes) | proc_nm·upr_proc_cd(트리 드롭다운 "접지")·use_yn·disp_seq |
| HALF(신규) | catalog Django `/admin/catalog/tprocprocesses/add/` | `TProcProcesses` | 동일(+note 혼동 가드) |

> proc_cd 자동채번 트리거는 **미신설 상태**(code-identifier-strategy §5는 제안만). 현 admin은 proc_cd 수동 입력 또는 dbm-load-execution 멱등 INSERT(MAX+1 계산). admin.py 제너릭 ModelAdmin이 t_proc_processes 등록 확인(admin.py:42 화이트리스트).

---

## 5. 영향분석 통합 (돈 크리티컬)

| 항목 | 판정 |
|------|------|
| **가격사슬(component_prices)** | 후보 3 proc_cd 현재 단가행 참조 0 → 신규 등록이 기존 가격 0변경. §21 교정은 단가행 proc_cd NULL→충전(verbatim 합 25,000 불변·택일 분리만). |
| **단가값 보존 [HARD]** | unit_price SET 0(apply.sql verbatim 가드 G-1 내장). 신규 코드 등록도 단가값 무관. |
| **BOM(product_processes)** | PROC_000071 BOM 참조 1건 — 재사용이 그 의미 보존(병풍접지 불변). 신규 106/107은 BOM 참조 0(신규). |
| **백필** | 0(신규 행·기존 행 무변경). |
| **롤백** | 신규 행 제거(del_yn='Y' 또는 DELETE)·재사용은 §21 단가행 proc_cd NULL 복원. 마스터 직접 DELETE 전 단가행 FK 참조 해제 선행(위상 역순). |

---

## 6. 컨펌 큐 (escalate)

| ID | 막힌 결정 | 평이한 한국어 질문 |
|----|-----------|--------------------|
| **CONF-FOLD-1** [4ACC 재사용] | 가격표 "4단병풍접지(아코디언)" = 라이브 "병풍접지"(PROC_000071) 동일물 여부 | "가격표의 '4단병풍접지(아코디언)'와 시스템에 이미 있는 '병풍접지'가 같은 접지 방식인가요? 같으면 새로 안 만들고 그대로 씁니다(권장). 단수만 다르면 세부값으로 표현합니다." |
| **CONF-FOLD-2** [신규 2건 승인] | 4단대문접지·반접지 신규 공정코드 2건 등록 승인 | "'4단대문접지'와 '반접지'는 시스템에 없어서 새로 등록해야 합니다(각각 PROC_000106·PROC_000107). '반접지'는 기존 '2단접지'와 다른 별개 공정이라 따로 만듭니다. 등록해도 될까요?" |
| **CONF-FOLD-3** [disp_seq] | 신규 2건의 접지 그룹 내 표시순서(19·20 제안) | "새 접지 방식 2개를 접지 메뉴 맨 뒤에 둘까요, 아니면 비슷한 방식 옆에 둘까요?" (기본=맨 뒤 19·20) |

---

## 7. 인간 승인 시 다음 액션

1. **CONF-FOLD-1/2 확정** → 본 명세 proc_cd 채번값 확정(106·107·재사용 071).
2. **§12 마스터 등록**(인간 승인 후 `dbm-load-execution` 위임): `fold-process-registration-rows.csv` 2 신규행 INSERT(멱등·NOT EXISTS 가드) — 공유 마스터라 인간 승인 필수.
3. **§21 단가행 치환**: `fold-remediation-mapping.csv`의 `__PENDING_GATE__`→`PROC_000106`·`__PENDING_HALF__`→`PROC_000107`·`4ACC`→`PROC_000071`(CONDITIONAL 해소).
4. **§21 apply.sql STEP 2~4 주석 해제** + 확정 proc_cd 기입 → 기본 ROLLBACK 재확인 → COMMIT 모드(dbm-load-execution).
5. **검증 핸드**: `hcc-conformance-gate`/`dbm-validator`가 evaluate_price 실호출로 027/028/029 접지비 25,000→6,000 독립 비준.
6. **028 옵션그룹 0행** = 접지방식 선택 UI 적재 별 트랙(dbm-cpq-option-mapping) 병행.

---

## 8. hbg-validator 통지

- **접지 섹션 = 신규 mint 2건(PROC_000106 4단대문접지·PROC_000107 반접지) + 재사용 1건(PROC_000071 병풍접지=4ACC)**. 검증 포인트:
  ① **search-before-mint 사다리** 각 건 1단(코드행) 판정 — 4ACC=재사용(동일물)·4GATE/HALF=불가 입증 후 신규(기존 테이블·신규 테이블/컬럼 0).
  ② **★PROC_000059(2단접지) ≠ 반접지 혼동 금지** 근거(가격표 독립 라벨·물리 형태·의미 오염).
  ③ **채번 MAX+1**(라이브 MAX_num=105 재실측·106/107)·separator `_`·이름 멱등.
  ④ **FK 위상**(마스터 선적재 → 단가행 충전·self-FK upr=PROC_000056·component_prices FK).
  ⑤ **돈 크리티컬**(후보 단가행 참조 0·verbatim 합 25,000 불변·신규 등록 단가값 0변경).
  ⑥ **적재경로** catalog `/admin/catalog/tprocprocesses/add/`(TProcProcesses 모델 실재 확인·자동채번 트리거 미신설).
- **escalate**: CONF-FOLD-1(4ACC 재사용 확인)·CONF-FOLD-2(신규 2건 승인)·CONF-FOLD-3(disp_seq).
