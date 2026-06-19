# apply-plan — 공정 축 safe-merge 실행 명세 (9 thin-mirror 논리삭제)

생성: 2026-06-19 / hbd-dedup-analyst / 대상: **thin-mirror 자식 9건 논리삭제 (참조 0·무손실)**
권위: 라이브 t_* 직접 재실측(dedup-report.md §②③) · 논리삭제 권위 [[dbmap-del-yn-soft-delete-authority]]
실행 주체: **인간 승인 후 hbd-load-execution / dbm-load-execution 위임** (본 문서는 명세까지)

## 0. 범위 (안전분만)

- ✅ 포함: thin-mirror 자식 **9건** — PROC_000087·088·089·091·093·094·095·096·097.
  전부 2026-06-17 00:54 일괄 INSERT·dtl_opt 공란·authority 부재·**total_refs=0**(prd_proc+comp_prices+option_items+child 전부 0)·del_yn=N·leaf. 라이브 실측 입증.
- ❌ 제외(BLOCKED·오적재): 미싱 086(comp 30)·오시 090(comp 50)·타공 092(comp 18) — 자식이 가격행 보유·option↔price proc_cd 단절. 논리삭제 시 가격 98행 전손 → 가격축 재배선 escalate(dbm-price-arbiter/경로 Y).
- ❌ 제외(④ 정당구분): 핑크 010/036·UV 002/016 — 부모/의미축 상이. 통합 금지.
- ❌ 제외(현황): PROC_000025 레이플랫제본 — 이미 del_yn=Y.

## 1. 사전 실측 (라이브 확정값 — 2026-06-19)

| 멤버(thin) | 정본(부모) | total_refs | del_yn |
|---|---|:---:|:---:|
| PROC_000087 반칼 | PROC_000054 | 0 | N |
| PROC_000088 봉제 | PROC_000080 | 0 | N |
| PROC_000089 부착 | PROC_000081 | 0 | N |
| PROC_000091 완칼 | PROC_000053 | 0 | N |
| PROC_000093 족자제작 | PROC_000082 | 0 | N |
| PROC_000094 스티커완칼 | PROC_000055 | 0 | N |
| PROC_000095 에폭시 | PROC_000083 | 0 | N |
| PROC_000096 열재단 | PROC_000084 | 0 | N |
| PROC_000097 UV | PROC_000002 | 0 | N |

★ 각 멤버는 외부 참조(상품바인딩·단가행·option_items·자식) 0 → **재배선 불필요**. 정본(부모)은 이미
authority·바인딩·dtl_opt 보유 → 무손실. 단순 논리삭제만.

## 2. 백업 대상 (실행 전 필수)

```sql
-- 물리 백업(타임스탬프 테이블) — undo 안전망
CREATE TABLE bak_proc_dedup_merge_20260619 AS
  SELECT * FROM t_proc_processes
  WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097');
```

## 3. 적용 SQL (단일 트랜잭션 · 멱등 가드 · dryrun/apply 분리)

★ [HARD] 내장 BEGIN/COMMIT 금지(round-24 비인가 COMMIT 사고 재발방지). 아래는 **본문만** —
실행 래퍼(BEGIN/검증/COMMIT 또는 ROLLBACK)는 hbd-load-execution이 분리 관리.

```sql
-- thin-mirror 자식 9건 논리삭제 (권위=del_yn) · 멱등 가드 WHERE del_yn='N'
UPDATE t_proc_processes
   SET del_yn='Y', upd_dt=now()
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
   AND del_yn='N';
-- 예상 delta: 9행 (재실행 시 0)
```

주: 바인딩 재배선·단가행 이동 없음(멤버 참조 0). 정본(부모)은 무변경. 물리삭제 0.

## 4. 사후검증 (GO 게이트)

```sql
-- V1 멤버 9건 논리삭제 확정 + 정본 활성
SELECT proc_cd, del_yn FROM t_proc_processes
WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097',
                  'PROC_000054','PROC_000080','PROC_000081','PROC_000053','PROC_000082','PROC_000055','PROC_000083','PROC_000084','PROC_000002')
ORDER BY proc_cd;
--   기대: 087~097 자식 9건 → Y ; 부모(054/080/081/053/082/055/083/084/002) → N

-- V2 멤버 외부 참조 여전히 0 (CASCADE 무발생)
SELECT proc_cd,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.proc_cd=t.proc_cd) AS cp,
  (SELECT count(*) FROM t_prd_product_processes p WHERE p.proc_cd=t.proc_cd AND p.del_yn='N') AS prd
FROM (VALUES ('PROC_000087'),('PROC_000088'),('PROC_000089'),('PROC_000091'),('PROC_000093'),('PROC_000094'),('PROC_000095'),('PROC_000096'),('PROC_000097')) t(proc_cd);
--   기대: 전부 0, 0

-- V3 멱등: 위 UPDATE 재실행 시 delta=0
```

## 5. 예상 delta 요약

| 변경 | 테이블 | 행수 | 가역 |
|---|---|:---:|---|
| thin-mirror 논리삭제 | t_proc_processes | 9 (upd del_yn) | del_yn='N' 복귀 |
| INSERT / 물리 DELETE / 재배선 | — | 0 | — |

총 안전 적재(교정) 건수: **9 UPDATE (del_yn=Y)**. 단가행·정본·상품바인딩·option_items 무영향.

## 6. 잔여(미적용 — BLOCKED/컨펌)

- **오적재 BLOCKED 3건**: 미싱 086(comp30)·오시 090(comp50)·타공 092(comp18). 자식이 가격행 보유·
  option(부모)↔price(자식) proc_cd 단절. **논리삭제 금지**(가격 98행 전손). 가격축 재배선
  (자식 comp.proc_cd→부모 교정 또는 option→자식 재배선)을 dbm-price-arbiter/경로 Y로 escalate.
- **④ 정당구분 keep**: 핑크 010/036·UV 002/016 — 통합 금지(부모/의미축 상이).
- **UV 016 컨펌**: 코팅 옵션축 보존 keep(참조0이나 코팅의 UV타입 소멸 방지).
