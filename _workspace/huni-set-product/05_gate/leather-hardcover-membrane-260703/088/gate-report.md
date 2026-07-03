# 088 레더 링바인더 — 면지 통합 재설계 · S1~S8 독립 검증 게이트

> §23 hsp-set-gate · 2026-07-03 · **생성자 주장 비신뢰·라이브 psql 직접 재실측·롤백전용 DRY-RUN·DB 미적재.**
> 대상: `03_design/leather-hardcover-membrane-redesign-260703/088/apply-088.sql`(8스텝).
> 종합: **GO** (S1~S8 전부 PASS) — COMMIT 승인 준비 완료 · webadmin 실화면 [HARD] 조건 · 088-redesign 순서 무관.

---

## 종합 판정: **GO** (단일 FAIL 0)

| 게이트 | 판정 | 재실측 증거 |
|---|---|---|
| S1 권위 충실성 | **PASS** | set-checklist.csv `authority_role_qty_rule`=**"면지=옵션택1(CONFIRM-2)"** — 재설계(4멤버→1멤버+4색옵션택1)가 권위 규칙을 실현. base_qty=1·min/max/incr NULL 라이브 일치. 날조 0 |
| S2 구성원 유형 | **PASS** | 라이브 실측: 088=PRD_TYPE.01(셋트 완제품)·089~093=PRD_TYPE.02(반제품). 090=SEMI_ROLE.03 면지. 완제품/기성/디자인 혼입 0 |
| S3 무결성 | **PASS** | 복합PK 중복 0·091/092/093 역참조 0(타셋트·옵션아이템 ref_key1·하위셋트 전부 0)·트리거 `trg_..._chk_ref`(fn_chk_opt_item_ref) 실재·OPT_REF_DIM.03=자재선행 요구 → apply 순서 자재[2]→아이템[5] 준수 |
| S4 가격 e2e [HARD] | **PASS** | 실엔진(pricing.py match_component+component_subtotal) 골든 **34,100/159,100/796,900** 재현. 멤버 기여 0=직접단가 0건+공식 0건 **둘 다 독립 실측**. 부모공식 use_dims=`["min_qty"]` 자재 미종속→면지자재 은퇴 무영향. 이중합산 0·PRICE≠0 |
| S5 오차단/흡수 | **PASS** | 색택1 선택지 손실 0: 090에 자재4(화382/블383/그384/인쇄385)+옵션4+아이템4 전부 이관(DRY-RUN 4/4/4 확증). 경쟁사 naming/codes 유입 0(순수 라이브 구조 통합) |
| S6 적재 가능성 DRY-RUN | **PASS** | `BEGIN;apply×2;ROLLBACK`: 트리거 통과(옵션아이템 예외 0)·멱등(pass2 UPDATE 0·카운트 동일=delta 0)·제약위반 0·예상 카운트 실증·ROLLBACK 후 라이브 무변경 |
| S7 생성≠검증 독립성 | **PASS** | 전 판정 라이브 psql 직접 재실측(인용 아님). codex reconcile DISAGREE 0·신규 리스크 1건(직접단가)을 t_prd_product_prices 0건 직접 재확인. 미해결 0 |
| S8 경계 무오염 [HARD] | **PASS** | 090=자기 면지자재(USAGE.03)만·D링(USAGE.07 MAT_247/248/249) 미유입(격리)·apply DML formula/component 배선 미터치(위험어 6건 전부 주석)·088-redesign 직교(미적재 마커 전부 확증) |

---

## S4 골든 종단 재현 (돈 크리티컬)

실엔진 실행(`_golden-088-current.py` · real pricing.py):
```
# COVERBIND live rows = 6 · discount tables on 088 = 0
copies  parent(COVERBIND)  members(089-093)  base_total  final
1       34100.0            0                 34100.0     34100.0   [tier_min_qty=1  unit=34100.0]  OK
10      159100.0           0                 159100.0    159100.0  [tier_min_qty=10 unit=15910.0]  OK
100     796900.0           0                 796900.0    796900.0  [tier_min_qty=100 unit=7969.0]  OK
```
- 부모공식 배선(라이브 실측): `PRF_LEATHER_RINGBINDER_SET → COMP_HC_MUSEON_COVERBIND`(addtn_yn=Y·prc_typ PRICE_TYPE.01·use_dims=`["min_qty"]`).
- **멤버 기여 0 = 2층 독립 확증**: ① `t_prd_product_prices WHERE prd_cd IN(089~093)` = **0건** ② `t_prd_product_price_formulas` 동일 = **0건**. pricing.py → base_amount=Decimal(0). (codex 신규 리스크 "직접단가 미확인" RESOLVED)
- 재설계 후 골든 불변: apply가 부모공식·COVERBIND 밴드·멤버 공식/단가 전부 미터치. 은퇴 멤버(091~093)=애초 기여 0. 090=자재 부여받아도 공식 0 유지. **이중합산 0**.

## S6 DRY-RUN 실증 (롤백전용)

| 검사 | pass1 | pass2(멱등) | 판정 |
|---|---|---|---|
| 090 면지자재(USAGE.03) | 4 | 4 | 멱등 ✓ |
| 090 옵션그룹/옵션/아이템 | 1/4/4 | 1/4/4 | 멱등·트리거 통과 ✓ |
| 090 rename | UPDATE 1 | UPDATE 0 | 멱등 ✓ |
| 088 OPT_067 활성 | 0(은퇴) | 0 | ✓ |
| 088 USAGE.03 활성 | 0(은퇴) | 0 | ✓ |
| **088 D링 USAGE.07 활성** | **3** | **3(247/248/249 del_yn=N)** | **불가침 보존 ✓** |
| 091~093 셋트 활성 | 0(은퇴) | 0 | ✓ · 090=1 유지 |
| POST-ROLLBACK 라이브 | 090 empty·OPT_067=1·091~93=3 | — | 무변경(미적재) ✓ |

## S8 경계·직교 실증

- **경계**: apply [2] WHERE `usage_cd='USAGE.03'` + mat_cd IN(382~385) → D링(USAGE.07) 격리. DRY-RUN에서 D링 3종 잔존 실증.
- **공유공식**: apply DML 비주석 라인에 089/SSABARI/COVERBIND/PROC_000098/frm_cd/formula_components **등장 0**(위험어 6건 전부 주석). 신규 배선 오염 유입 0.
- **088-redesign 직교 마커**(라이브): COVER_comp=0·088 proc=0·089 formula=0·COMP_BIND_SSABARI 미배선·088 부모 여전히 COVERBIND. → 088-redesign 미적재 확증·겹치는 행 0·**순서 무관(FREE)**.
- **선존 노트(본 건 무손상)**: COMP_HC_MUSEON_COVERBIND는 072/077/088 공유(use_dims min_qty만) — 088-redesign 트랙 소관 선존 상태, 면지 통합 미터치.

## 적재 GO 큐 → load-executor

- `apply-088.sql`(8스텝·멱등·신규 mint 0·물리 DELETE 0) → 인간 승인 후 COMMIT 대상.
- **★COMMIT 후 webadmin 실화면 [HARD]**(CLAUDE.md §1): 제외 0·PRICE≠0·면지색 4택1 렌더(자재 드롭다운) 확인 의무.
- 088-redesign-260702(9,000 표지+SSABARI) apply와 **순서 무관** — 병렬/독립 실행 안전(보류 불필요).
