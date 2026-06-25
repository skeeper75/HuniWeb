# W1 계층 부활 독립 검증 — w1-verdict

검증자: dbm-validator(독립) · 라이브 Railway DB 읽기전용 SELECT + 롤백전용 DRY-RUN(2026-06-24) · 생성측 주장 비신뢰·직접 재실측 · DB 미적재(GO/NO-GO 판정만)
대상: `07_prereq/remediation/apply.sql` 중 **W1 계층 부활분만**(돈/좀비배선 제외) = 전용지 MAT_000246 부활 + 종이 root 9 부활 = 자재 10행 `del_yn='Y'→'N'`
권위 순서: 라이브 스키마/데이터 > 설계 spec. 9 root·전용지 del_yn·자식수·고아·돈영향·선택로직 전부 라이브 재실측.

> **종합: GO (조건부) — W1 10행 부활 GO. 단 ★선택목록 부작용 1건 적발(spec 누락): 투명/반투명 2 root는 굿즈 상품 자재 선택지로 배선돼 있어 부활 시 상품 자재 선택목록에 재노출됨. 7개 순수그룹 root는 부작용 없음. 부활 자체는 셋트 FK·계층 복구에 정당하나, 투명/반투명 2건은 굿즈 USAGE.07 배선 오염(종이 root가 굿즈 재질로 배선)이 별도로 깔려 있어 대응 권고.**

---

## 검증 항목별 판정

| # | 항목 | 판정 | 근거(라이브 재실측) |
|---|---|---|---|
| 1 | 부활 대상 정합 | **PASS** | 9 root + 전용지 전부 라이브 del_yn='Y' 확인. 9 root 활성 자식수 3·8·8·5·2·9·2·2·2 = **41**(spec 일치). 자식 전부 del_yn='N' |
| 2 | ★선택목록 재노출 부작용 | **PARTIAL FAIL(spec 누락 적발)** | 선택목록 로직 = `del_yn='Y'` 제외(소스 확정). 7 root=순수그룹(미배선·무부작용), **투명/반투명 2 root=굿즈 배선됨(재노출)** |
| 3 | 무결성·멱등 DRY-RUN | **PASS** | BEGIN…ROLLBACK: APPLY 1+9=10·제약위반0·멱등 2차 delta0·고아 64→23·ROLLBACK 후 무변경 |
| 4 | 돈영향 0 | **PASS** | 10 대상 자재 `t_prc_component_prices` 참조 = **0행** |
| 5 | search-before-mint | **PASS** | apply.sql = UPDATE만. 10 mat_cd 전부 기존 행. 신규 mint **0**·DDL 0·물리 DELETE 0 |

---

## 항목 1 — 부활 대상 정합 [PASS]

재현 SQL:
```sql
SELECT mat_cd, mat_nm, del_yn, sel_typ_cd, use_yn FROM t_mat_materials
WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094',
                 'MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146');
```
결과: 전 10행 `del_yn='Y'`, `use_yn='Y'`. 9 root는 `sel_typ_cd='SEL_TYPE.01'`(단일), 전용지는 NULL.

자식 활성수(재현):
```sql
SELECT p.mat_cd, count(c.*) FILTER (WHERE c.del_yn='N') active_child
FROM t_mat_materials p LEFT JOIN t_mat_materials c ON c.upr_mat_cd=p.mat_cd
WHERE p.mat_cd IN (...9 root...) GROUP BY p.mat_cd;
```
→ 백모조3·아트8·스노우8·앙상블5·랑데뷰2·몽블랑9·띤또2·투명2·반투명2 = **41 활성 자식**(deleted_child 0). spec 주장과 정확히 일치. **자식 없는 root 부활 보류 권고 해당분 = 0**(9 root 전부 활성 자식 보유 → 부활 정당).

---

## 항목 2 — ★선택목록 재노출 부작용 [핵심·PARTIAL FAIL]

### 선택로직 권위(소스 확정)
- `price_views.py:717-718, 1314-1315, 1515-1516`: 선택목록 생성 시 공통 패턴
  `if "del_yn" in fields: qs = qs.exclude(del_yn="Y")` → **del_yn='Y' 자재는 선택지에서 자동 제외**.
- `views.py:719-721`(자재정보 master_detail 트리): `roots = filter(parent__isnull, del_yn="N")`, `children = filter(parent__notnull, del_yn="N")` → root 부활 시 **트리에 그룹노드로 재노출**.
- `admin.py:88 SELF_PARENT_TREES upr_mat_cd="parents_only"`: 상위자재 FK 드롭다운(부모 후보)은 del_yn 미필터(전체 노출) — 단 이건 changeform "상위자재" 선택용이라 본 부작용과 별개.

### 판정 — root별 두 갈래
**(A) 7개 순수그룹 root = 부작용 없음(spec 옳음).**
재현:
```sql
SELECT mat_cd, count(*) FROM t_prd_product_materials
WHERE mat_cd IN ('MAT_000071','MAT_000075','MAT_000085','MAT_000094',
                 'MAT_000100','MAT_000103','MAT_000122') GROUP BY mat_cd;
```
→ **빈 결과**. 7 root는 product_materials에 직접 배선 0 = 순수 그룹노드. 부활해도 상품 자재 선택목록엔 안 나옴(자식 종이가 선택지). 자재정보 트리 그룹노드 재노출은 의도한 계층 복구.

**(B) 투명(MAT_000143)·반투명(MAT_000146) 2 root = ★재노출됨(spec 누락).**
spec(material-remediation-spec.md §P3-A "sel_typ_cd 부작용 검토")은 *"root는 product에 배선 안 됨 → 부작용 없음"* 으로 9 root 전부를 단언했으나 — 재실측 결과 거짓:
```sql
SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, pm.usage_cd, pm.del_yn wire, m.del_yn mat_del
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.mat_cd IN ('MAT_000143','MAT_000146');
```
→ **3행**: 머그컵(PRD_000193) 투명·반투명 USAGE.07, 미니우치와키링(PRD_000227) 반투명 USAGE.07. 전부 wire del_yn='N'(활성 배선)·mat use_yn='Y'.
- 즉 투명/반투명은 **종이 root이면서 동시에 굿즈 상품(머그컵·키링)의 재질 선택지로 활성 배선**됨. 부활하면 그 선택지가 "사멸 라벨 → 활성 선택지"로 바뀜 → **상품 자재 선택목록에 재노출**.
- 머그컵 USAGE.07 자재군 전체 = 투명(del_yn=Y)·반투명(Y)·화이트255(Y)·화이트머그268(N). 살아있는 건 화이트머그(11온스)뿐 = 이 굿즈 재질 선택군은 이미 대부분 사멸자재를 가리키는 **깨진 배선**(별도 데이터 결함, W1 범위 밖).

### 대응 판정
- **계층 복구가 목적인 부활은 정당**(자재정보 트리·셋트 FK 정합). 하지만 투명/반투명 2건은 **종이 root가 굿즈(MAT_TYPE.12 머그) 재질로 잘못 배선**된 오염 위에 놓여 있어, 부활하면 그 오배선이 활성 선택지로 살아남.
- **비선택(그룹노드) 처리 필요 여부**: 후니 스키마에 sel_typ_cd "비선택" 코드 없음(SEL_TYPE.01 단일/.02 다중뿐). 따라서 root를 그룹노드로 두면서 선택 배제하는 메커니즘은 **product_materials 배선 부재**(7 root처럼)뿐. 투명/반투명은 배선이 있어 이 가드가 안 먹음.
- **권고**: ① 7 root는 부작용 0 → 즉시 GO. ② 투명/반투명 2 root는 부활은 하되, **머그컵·키링 USAGE.07의 투명/반투명 배선을 논리삭제하거나 굿즈 전용 재질 자재로 재배선**하는 후속(별도 트랙·confirm)을 동반해야 굿즈 자재 선택목록 오염 회피. 미동반 시 부활만으로는 굿즈 선택지에 종이 root가 노출됨.

---

## 항목 3 — 무결성·멱등 DRY-RUN [PASS]

BEGIN…ROLLBACK 단일 트랜잭션 실측(라이브 무변경):

| 측정 | 기대 | 실측 | 판정 |
|---|---|---|---|
| PRE 사멸 10 | 10 | **10** | OK |
| PRE FK 고아(자식N·부모Y) | 64 | **64** | 기준선 |
| APPLY P2-A(전용지) | 1 | **1** | OK |
| APPLY P3-A(root 9) | 9 | **9** | OK |
| POST 활성 10 | 10 | **10** | OK |
| POST FK 고아 | 23 | **23** | OK(64→23, 41 복구) |
| 멱등 2차 delta(IS DISTINCT FROM 가드) | 0 | **0** | ✅ |
| CHECK 위반(del_yn/use_yn 도메인) | 0 | **0** | ✅ |
| ROLLBACK 후 라이브 여전히 사멸 | 10 | **10** | ✅ 무변경 |

FK 고아 64→23 = 9 root 자식 41건이 살아있는 부모를 가리킴. 잔여 23 = 비종이 root(P3-B CONFIRM)·자식0 root 산하 = W1 범위 밖(누락 아님·의도적 미부활).
트리거: `trg_t_mat_materials_upd_dt`(BEFORE UPDATE → fn_upd_dt) 1개뿐 = upd_dt 갱신만, 부작용 0. CHECK 제약 = del_yn/use_yn `IN ('Y','N')` 2건, 부활이 위반 안 함.

---

## 항목 4 — 돈영향 0 [PASS]

```sql
SELECT count(*) FROM t_prc_component_prices
WHERE mat_cd IN (...10 대상...);   -- → 0
```
10 부활 대상 자재 자체는 단가행 0행. 부활은 가격 무변경(돈 제외 경계 준수). 참고: 9 root의 활성 자식 중 단가행 보유 자재 32개 존재하나 — 부활 대상은 root 10개뿐이라 무관(자식은 이미 활성·단가행 손 안 댐).
(spec이 쓴 `component_prices` 테이블명은 라이브에 없음 = `t_prc_component_prices`가 정명. 검증자가 정명으로 재실측.)

---

## 항목 5 — search-before-mint [PASS]

apply.sql = `UPDATE … SET del_yn='N'` 2문(P2-A·P3-A)뿐. INSERT/CREATE/ALTER/DELETE 0. 대상 10 mat_cd 전부 라이브 기존 행(부활=토글). **신규 mint 0·DDL 0·물리 DELETE 0.**

---

## 종합 GO/NO-GO

| 구분 | 판정 |
|---|---|
| W1 부활 10행 무결성·멱등·돈0·mint0 | **GO** |
| 7개 순수그룹 root(백모조·아트·스노우·앙상블·랑데뷰·몽블랑·띤또) | **GO**(부작용 0) |
| 전용지 MAT_000246(셋트 072·082 표지 FK 해소) | **GO**(배선 2행 자동 정합) |
| 투명·반투명 2 root | **GO(조건부)** — 부활은 정당하나 굿즈 USAGE.07 오배선 동반 정리 권고 |
| 부활 보류분 | **0**(9 root 전부 활성 자식 보유) |

### 적재 GO 큐 (인간 승인 후 dbm-load-execution COMMIT)
`UPDATE t_mat_materials SET del_yn='N', del_dt=NULL WHERE mat_cd IN (...10...) AND del_yn IS DISTINCT FROM 'N';`
→ **10행 UPDATE**(전용지 1 + 종이 root 9). BEGIN/COMMIT 래핑·backup.sql 선실행 권장.

### 후속(W1 범위 밖·escalate)
- **투명/반투명 굿즈 오배선**: 머그컵(193)·키링(227) USAGE.07의 투명·반투명 종이 root 배선 = 종이 root가 굿즈 재질로 잘못 박힘. 부활 동반 정리(배선 논리삭제 or 굿즈 재질 재배선) 권고. → confirm/별도 트랙.
- 잔여 FK 고아 23 = 비종이 root(P3-B)·NO_ROOT(P3-C) = 이미 CONFIRM 분리(누락 아님).

**최종 판정: W1 10행 부활 GO. 선택목록 부작용은 7/9 root 무해, 투명/반투명 2 root만 굿즈 오배선 동반 정리 조건. NO-GO 사유 없음 — 단 spec의 "전 9 root 부작용 없음" 단언은 부정확(검증자가 정정).**
