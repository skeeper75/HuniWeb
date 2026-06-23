# RC-5 실사 아크릴/폼보드 단가 교정 — R1~R6 독립 검증 게이트

> dbm-validator · 2026-06-23 · §21 catalog-conformance RC-5
> 검증 대상: `09_load/_rc5_acrylic_foamboard_260623/` (apply.sql·undo.sql·manifest.md·dryrun-result.md)
> 권위[HARD]: `24_master-extract-260610/silsa-l1.csv` (price col24·별색옵션 col26)
> 방법: 생성자(arbiter·load-builder) 주장 비신뢰 — 라이브 읽기전용 SELECT + 롤백전용 2-pass DRY-RUN으로 직접 재실측. **파괴적 쓰기 0·COMMIT 0.**
> 자격: `.env.local RAILWAY_DB_*` (chmod 600·gitignore IGNORED 확인).

---

## 종합 판정: **GO** (R1~R6 전건 PASS · BLOCKER/MAJOR 0 · MINOR 1)

10행(UPDATE 9 + INSERT 1) 전부 권위 verbatim 일치·라이브 정합·멱등·무결성·범위제한·생성검증 독립 확인. 단일 FAIL 없음.
MINOR 1건(빌더 manifest의 IDENTITY 시퀀스 last_value 기재 오차)은 적재 안전성·결론에 무영향(아래 R4 §주의).

---

## R1 권위 충실성 — **PASS**

silsa-l1.csv에서 ID 14587(유광)·14588(미러)·14575(폼보드) 행을 직접 추출(`csv` 파싱, 생성자 표 미참조). 적재본 단가값 = 권위 price(col24) verbatim 일치. 날조·임의값 0.

| 상품 | 사이즈 | 권위 price(col24) | 적재본 목표값 | 일치 |
|---|---|---|---|---|
| 유광아크릴 14587 | 290x90 | 12000 | 12000 | ✅ |
| 〃 | 290x190 | 18000 | 18000 | ✅ |
| 〃 | 390x290 | 28000 | 28000 | ✅ |
| 〃 | 590x390 | 47000 | 47000 | ✅ |
| 미러아크릴 14588 | 290x90 | 15000 | 15000 | ✅ |
| 〃 | 290x190 | 22000 | 22000 | ✅ |
| 〃 | 390x290 | 36000 | 36000 | ✅ |
| 〃 | 590x390 | 62000 | 62000 | ✅ |
| 폼보드 14575 | A3 297x420 | 6000 | 6000 (UPDATE) | ✅ |
| 〃 | A2 420x594 | 12000 | 12000 (불변) | ✅ |
| 〃 | A1 594x841 | 20000 | 20000 (INSERT) | ✅ |

- 권위 화이트별색(col26) **3상품 전행 공란** → 별색 추가단가 부재. 본체 price만 교정 대상(진단 CONFIRM-2 PASS 재확인).
- 권위 A1=20000(col24)·vat 22000(col25) 실재 확인 → A1 INSERT 단가 정당. "사용자입력" 행(col25=52800)은 커스텀 면적형으로 RC-5 범위 밖(CONFIRM-5b 보류·교정에 미포함=정상).

---

## R2 라이브 정합 — **PASS**

라이브 직접 SELECT(`comp_price_id IN (10건)`)로 현재값·comp_cd·apply_ymd·siz_cd·차원컬럼 재실측. 핀포인트 오타·잘못된 행 타격 0.

```sql
SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, opt_cd, proc_cd,
       print_opt_cd, plt_siz_cd, dim_vals, siz_width, siz_height, unit_price
FROM t_prc_component_prices WHERE comp_price_id IN (4780,4781,4792..4799) ORDER BY comp_cd, comp_price_id;
```

| comp_price_id | comp_cd | apply_ymd | siz_cd | 차원컬럼(clr/mat/opt/proc/print_opt/plt_siz/dim_vals/w/h) | 현재 unit_price | 적재본 명세 |
|---|---|---|---|---|---|---|
| 4792 | GLOSS | 2026-06-01 | SIZ_000324 | 전부 NULL | 9000 | →12000 |
| 4793 | GLOSS | 2026-06-01 | SIZ_000325 | 전부 NULL | 14000 | →18000 |
| 4794 | GLOSS | 2026-06-01 | SIZ_000326 | 전부 NULL | 32000 | →28000 |
| 4795 | GLOSS | 2026-06-01 | SIZ_000327 | 전부 NULL | 37000 | →47000 |
| 4796 | MIRROR | 2026-06-01 | SIZ_000324 | 전부 NULL | 11000 | →15000 |
| 4797 | MIRROR | 2026-06-01 | SIZ_000325 | 전부 NULL | 18000 | →22000 |
| 4798 | MIRROR | 2026-06-01 | SIZ_000326 | 전부 NULL | 29000 | →36000 |
| 4799 | MIRROR | 2026-06-01 | SIZ_000327 | 전부 NULL | 50000 | →62000 |
| 4780 | FOAM | 2026-06-01 | SIZ_000315 | 전부 NULL | 7000 | →6000 |
| 4781 | FOAM | 2026-06-01 | SIZ_000317 | 전부 NULL | 12000 | 불변(타격 안함) |

- 라이브 현재값 = 진단/적재본 "현재값" 칸과 10건 전건 1:1 일치 → 잘못된 행 타격 없음.
- comp use_dims/prc_typ 재실측: 3 comp 전부 `use_dims=["siz_cd"]·PRICE_TYPE.01·use_yn=Y·del_yn=N` → 단가축 단일 차원, 별색/옵션 차원 부재. 본체단가 단순 교정 안전.
- 4781(A2)는 apply.sql에 SET 대상 없음 → 불변 보장.

---

## R3 멱등성 (2-pass DRY-RUN) — **PASS**

라이브 `BEGIN … ROLLBACK` 한 트랜잭션 내 apply 본문 2회 연속 실행(직접 실행, dryrun-result.md 미참조).

| Pass | UPDATE | INSERT |
|---|---|---|
| PASS1 (적용) | **UPDATE 1 × 9** | **INSERT 0 1** (영향행 합 10) |
| PASS2 (재실행) | **UPDATE 0 × 9** | **INSERT 0 0** (영향행 0) |

- 교정 후 11행 전부 권위값(post-state SELECT 확인): GLOSS 12000/18000/28000/47000·MIRROR 15000/22000/36000/62000·FOAM A3 6000/A2 12000/A1 20000.
- A1행 count=1 (중복·이중계상 0).
- `unit_price IS DISTINCT FROM <권위값>` UPDATE 가드 + `NOT EXISTS(comp_cd+siz_cd)` INSERT 가드 유효 → 완전 멱등 재현.
- 트랜잭션 ROLLBACK → 라이브 불변 확인.

---

## R4 제약·무결성 — **PASS** (MINOR note 1)

라이브 직접 SELECT로 FK·NOT NULL·PK·IDENTITY·apply_ymd 재실측.

| 점검 | 실측 | 결과 |
|---|---|---|
| siz FK 기존재 (294/315/317/324~327) | 전건 존재·del_yn=N | ✅ FK 위반 0 |
| **A1 siz_cd 정합** | SIZ_000294 = `A1 (594X841)` cut 594×841(세로형). 폼보드 A3(297×420)·A2(420×594) 모두 세로형 → 시리즈 정합. SIZ_000302(841×594 가로형)는 부적합 | ✅ SIZ_000294 선택 옳음 |
| A1행 기존재 가드 | `comp_cd=FOAMBOARD ∧ siz_cd=SIZ_000294` count=**0** | ✅ INSERT 정당 |
| NOT NULL | NOT NULL = comp_price_id(IDENTITY)·comp_cd·apply_ymd·reg_dt(DEFAULT now()). INSERT가 comp_cd·apply_ymd 채움·reg_dt DEFAULT | ✅ 위반 0 |
| PK 충돌 | comp_price_id IDENTITY BY DEFAULT 자동채번·미지정 INSERT | ✅ 충돌 0 |
| apply_ymd 이중계상 | A1 INSERT apply_ymd=`2026-06-01` = 기존 폼보드 4780/4781과 동일 적용일 → 분기 없음. evaluate_price 동일 apply_ymd 단가행 일관 매칭 | ✅ 이중계상 0 |
| 2-pass INSERT 결과 | PASS1 `INSERT 0 1`·PASS2 `INSERT 0 0` (제약 전건 통과) | ✅ |

**MINOR-1 (적재 안전 무영향):** 빌더 manifest §0·apply.sql 주석은 IDENTITY 시퀀스를 "last_value=38231·MAX=38231 동기"로 기재했으나, **라이브 실측 last_value=38234·is_called=t·MAX(pk)=38231**. last_value(38234) > MAX(38231) 이므로 다음 채번=38235 → 충돌 위험 0·stale 아님(setval 불요 결론은 동일). 빌더 기재값의 사소한 부정확이며 INSERT 안전성·게이트 결론에 영향 없음. → load-builder에 manifest 수치 정정 권고(차단 아님).

---

## R5 부작용 범위 — **PASS**

| 점검 | 실측 | 결과 |
|---|---|---|
| comp별 전체 단가행 수 | GLOSS=4·MIRROR=4·FOAM=2 → apply 타격행이 곧 comp 전체(범위 밖 행 없음) | ✅ |
| 10행 외 component_prices | apply.sql WHERE는 전부 `comp_price_id` 핀포인트 또는 `comp_cd+siz_cd` 한정 → 다른 상품/comp 단가행 무간섭 | ✅ |
| 기초코드 마스터 t_siz/t_mat | apply.sql에 t_siz/t_mat 쓰기문 0 (코드값 SELECT 참조만) | ✅ 불변 |
| 신규 채번 | siz/mat/comp 코드 신규 mint 0. component_prices PK만 IDENTITY 자동채번(데이터행) | ✅ search-before-mint 충족 |
| undo 정확성 | apply→undo 라운드트립 후 _before 스냅샷 대비 diff **0행**·A1 잔여 **0** | ✅ 정확 원복 |

apply→undo 검증은 라이브 롤백 트랜잭션 내에서 스냅샷 비교로 직접 수행. 교정 전 값(9000/14000/32000/37000·11000/18000/29000/50000·A3 7000·A1 삭제)으로 완전 복원 확인.

---

## R6 생성-검증 독립성 — **PASS**

- 본 검증은 라이브 DB(읽기전용 SELECT + 롤백 DRY-RUN)와 권위 원본(silsa-l1.csv 직접 csv 파싱)에서 재실측 — 생성자 산출(dryrun-result.md 영향행수·manifest 실측표)을 결론 근거로 재사용하지 않음.
- 독립 재실측 중 **MINOR-1 결함 적발**: 빌더 manifest의 IDENTITY last_value 기재(38231)가 라이브 실측(38234)과 불일치 → 생성자 주장 비신뢰 검증의 실효성 입증(생성≠검증).
- 검증자(dbm-validator)는 생성(dbm-price-arbiter 진단·dbm-load-builder 적재본)과 분리된 역할 — self-approve 없음.

---

## 근거 SQL (재현용)

```sql
-- R2: 10행 현재값·차원
SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, opt_cd, proc_cd,
       print_opt_cd, plt_siz_cd, dim_vals, siz_width, siz_height, unit_price
FROM t_prc_component_prices WHERE comp_price_id IN (4780,4781,4792,4793,4794,4795,4796,4797,4798,4799) ORDER BY comp_cd, comp_price_id;
-- R2b: comp use_dims/prc_typ
SELECT comp_cd, prc_typ_cd, use_dims, use_yn, del_yn FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_POSTER_ACRYLSTK_GLOSS','COMP_POSTER_ACRYLSTK_MIRROR','COMP_POSTER_FOAMBOARD_WHITE');
-- R4: siz FK + A1 정합
SELECT siz_cd, siz_nm, cut_width, cut_height, del_yn FROM t_siz_sizes
 WHERE siz_cd IN ('SIZ_000294','SIZ_000302','SIZ_000315','SIZ_000317','SIZ_000324','SIZ_000325','SIZ_000326','SIZ_000327');
-- R4: A1 미존재·IDENTITY seq
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_FOAMBOARD_WHITE' AND siz_cd='SIZ_000294';  -- 0
SELECT last_value, is_called FROM public.t_prc_component_prices_comp_price_id_seq;  -- 38234|t
SELECT max(comp_price_id) FROM t_prc_component_prices;  -- 38231
-- R3/R5: BEGIN … (apply ×2 / apply+undo+diff) … ROLLBACK (본 보고서 실행 로그 참조)
```

---

## 라우팅 / 다음 단계

- **GO** — 인간 승인 후 hbd-load-executor(또는 dbm-load-execution)가 `apply.sql`의 ROLLBACK을 COMMIT으로 전환 적용(돈 크리티컬·실 COMMIT 인간 게이트).
- **MINOR-1 → dbm-load-builder**: manifest.md §0·apply.sql L66 주석의 IDENTITY 시퀀스 수치(38231)를 라이브 실측값(last_value=38234)으로 정정 권고. 차단 사유 아님(다음 채번>MAX 보장·setval 불요 결론 동일).
- 라이브 파괴적 쓰기 0 수행(전 SELECT + 2회 롤백 트랜잭션). COMMIT 없음.
