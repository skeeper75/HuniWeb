# RC-5 실사 아크릴/폼보드 단가 교정 — 적재 매니페스트

> dbm-load-builder · 2026-06-23 · §21 catalog-conformance RC-5
> 입력 권위: `_workspace/huni-catalog-conformance/04_price_engine/rc5-acrylic-foamboard-diagnosis.md` (별색혼동 PASS·본체 오적재 확정)
> 대상 테이블: `t_prc_component_prices` (t_prd 상품 구성요소 단가행) — **기초코드 마스터(t_siz/t_mat) 불변·신규 채번 0**
> 단가 verbatim(권위 silsa-l1 260610 price col24, VAT 제외 본체단가)·날조 0
> **실 COMMIT 금지** — dbm-validator R1~R6 통과 + 인간 승인 후 hbd-load-executor 수행. 본 빌더는 COMMIT 안 함.

---

## 0. 빌드 요건 1 — 라이브 재실측 (진단 주장 비신뢰·직접 SELECT)

진단표 값을 그대로 믿지 않고 라이브 직접 SELECT로 comp_price_id·현재값·comp_cd·use_dims·prc_typ·FK·IDENTITY를 재확인. **불일치 0건 → 중단 사유 없음.**

| 실측 항목 | 결과 | 진단 일치 |
|---|---|---|
| PK | `comp_price_id` 단일·IDENTITY BY DEFAULT | — |
| NOT NULL | `comp_cd`, `apply_ymd`, `reg_dt`(DEFAULT now()) | INSERT는 apply_ymd 필수 |
| CHECK 제약 | 0건 | — |
| FK | siz_cd→t_siz_sizes·comp_cd→t_prc_price_components·(mat/clr/proc/opt/print_opt/plt_siz) | leaf 입력 검증만 필요 |
| 10 단가행 현재값·apply_ymd | §1 표와 1:1 일치, apply_ymd 전행 `2026-06-01` | ✅ |
| comp use_dims / prc_typ | 3 comp 전부 `["siz_cd"]` / `PRICE_TYPE.01` / use_yn=Y·del_yn=N | ✅ |
| A1=SIZ_000294 | "A1 (594X841)" cut 594×841(세로형)·del_yn=N | ✅ 정합(SIZ_000302 841×594 가로형은 부적합) |
| A1행 라이브 존재 | 0건(미존재) → INSERT 정당 | ✅ |
| IDENTITY 시퀀스 | last_value=38231·is_called=t·MAX=38231 **동기 일치(setval stale 아님)** | 채번 정상 |

근거 SQL: `manifest.md §4 실측 SQL 보존` 참조.

---

## 1. 교정 매핑표 (10행 1:1 · 현재값 ↔ 권위값)

### [1] 유광아크릴 PRD_000142 · COMP_POSTER_ACRYLSTK_GLOSS · **UPDATE 4**
| comp_price_id | siz_cd (siz_nm) | 현재 unit_price | → 권위 verbatim | 작업 |
|---|---|---|---|---|
| 4792 | SIZ_000324 (290x90)  | 9000  | **12000** | UPDATE |
| 4793 | SIZ_000325 (290x190) | 14000 | **18000** | UPDATE |
| 4794 | SIZ_000326 (390x290) | 32000 | **28000** | UPDATE |
| 4795 | SIZ_000327 (590x390) | 37000 | **47000** | UPDATE |

### [2] 미러아크릴 PRD_000143 · COMP_POSTER_ACRYLSTK_MIRROR · **UPDATE 4**
| comp_price_id | siz_cd (siz_nm) | 현재 unit_price | → 권위 verbatim | 작업 |
|---|---|---|---|---|
| 4796 | SIZ_000324 (290x90)  | 11000 | **15000** | UPDATE |
| 4797 | SIZ_000325 (290x190) | 18000 | **22000** | UPDATE |
| 4798 | SIZ_000326 (390x290) | 29000 | **36000** | UPDATE |
| 4799 | SIZ_000327 (590x390) | 50000 | **62000** | UPDATE |

### [3] 폼보드 PRD_000129 · COMP_POSTER_FOAMBOARD_WHITE · **UPDATE 1 + INSERT 1**
| comp_price_id | siz_cd (siz_nm) | 현재 | → 권위 verbatim | 작업 |
|---|---|---|---|---|
| 4780 | SIZ_000315 (A3 297x420) | 7000 | **6000** | UPDATE |
| 4781 | SIZ_000317 (A2 420x594) | 12000 | 12000 | (불변·권위 일치) |
| (신규 38232+) | SIZ_000294 (A1 594x841) | 행 부재 | **20000** | INSERT |

**합계: UPDATE 9 + INSERT 1 = 10행.** 전부 단가축만 교정(차원 컬럼·소재·별색 미관여).

### INSERT 1행(A1) 동형 승계 명세 (기존 4780/4781 행 패턴)
- comp_cd=`COMP_POSTER_FOAMBOARD_WHITE`, siz_cd=`SIZ_000294`, unit_price=`20000`
- **apply_ymd=`2026-06-01`** (기존 폼보드 행 verbatim 승계 — apply_ymd 분기 시 이중계상 함정 회피)
- clr_cd/mat_cd/coat_side_cnt/bdl_qty/min_qty/dim_vals/opt_cd/proc_cd/print_opt_cd/plt_siz_cd/siz_width/siz_height = **NULL** (기존 행과 동일 패턴, use_dims=["siz_cd"] 단가형)
- comp_price_id = **미지정** → IDENTITY BY DEFAULT 채번(seq 동기 → setval 불요), reg_dt = DEFAULT now()
- note = `폼보드/화이트보드/A1 (594x841) 완제품가[출력+코팅+가공 포함가]` (기존 폼보드 note 패턴 승계)

---

## 2. 멱등성 근거

| 작업 | 멱등 가드 | 재실행 동작 |
|---|---|---|
| UPDATE 9 | `comp_price_id` 핀포인트 + `unit_price IS DISTINCT FROM <권위값>` | 현재값=권위값이면 0행 영향(no-op) |
| INSERT 1 | `WHERE NOT EXISTS (comp_cd='…' AND siz_cd='SIZ_000294')` + comp_price_id 미지정 | A1행 이미 존재 시 0행 INSERT(중복·이중계상 0) |

DRY-RUN 2-pass 실측(§dryrun-result.md): PASS1 = UPDATE 1×9 + INSERT 1, **PASS2 = UPDATE 0×9 + INSERT 0** → 완전 멱등.

---

## 3. FK 위상 / 코드행 선적재

- `t_prc_component_prices`는 leaf(자식 없음) → 코드행 선적재 **불요**.
- FK 대상 전건 라이브 기존재(siz_cd SIZ_000294/315/317/324~327·comp_cd COMP_POSTER_FOAMBOARD_WHITE 등) → FK 위반 가능성 0. 단일 트랜잭션 1단계로 충분.

---

## 4. 실측 SQL 보존 (재현용)

```sql
-- 스키마/제약
SELECT column_name, is_nullable, column_default, is_identity FROM information_schema.columns WHERE table_name='t_prc_component_prices';
SELECT pg_get_constraintdef(con.oid) FROM pg_constraint con JOIN pg_class rel ON rel.oid=con.conrelid WHERE rel.relname='t_prc_component_prices';
-- 10행 현재값·apply_ymd
SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, opt_cd, proc_cd, dim_vals, unit_price
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_POSTER_ACRYLSTK_GLOSS','COMP_POSTER_ACRYLSTK_MIRROR','COMP_POSTER_FOAMBOARD_WHITE')
ORDER BY comp_cd, unit_price;
-- comp use_dims/prc_typ
SELECT comp_cd, prc_typ_cd, use_dims, use_yn, del_yn FROM t_prc_price_components WHERE comp_cd IN (3개);
-- A1 siz 정합 + 폼보드 siz
SELECT siz_cd, siz_nm, cut_width, cut_height, del_yn FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000294','SIZ_000315','SIZ_000317','SIZ_000302');
-- IDENTITY 시퀀스
SELECT last_value, is_called FROM public.t_prc_component_prices_comp_price_id_seq;
```

---

## 5. 산출물 / 다음 단계

| 파일 | 내용 |
|---|---|
| `apply.sql` | 멱등 UPDATE 9 + INSERT 1, BEGIN…ROLLBACK(DRY-RUN 기본·COMMIT 비활성) |
| `undo.sql` | 교정 전 원복(142/143/129 원래값 + A1 INSERT DELETE) |
| `manifest.md` | 본 문서 |
| `dryrun-result.md` | 라이브 DRY-RUN 실행 결과 |

**다음 단계:** dbm-validator R1~R6 독립 게이트 → GO 시 인간 승인 → hbd-load-executor가 `apply.sql`의 ROLLBACK을 COMMIT으로 전환 적용. 본 빌더는 COMMIT 금지.
