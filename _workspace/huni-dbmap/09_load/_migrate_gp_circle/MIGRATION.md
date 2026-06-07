# GP 합판도무송 원형 직경 siz 등록 + GP 가격 + 066 size link 마이그레이션

> **트랙**: round-5 적재 실행본 — 자율 quick win(HANDOFF 다음시작점 #1). round-4에서 차단(blocked)으로
> 분리된 GP(합판도무송) 원형 직경 100 가격행을 실 적재 가능하게 닫는 마이그레이션.
> **권위**: `09_load/_assembled/code-row-preload.md §2`(siz_cd 배정), `09_load/_assembled_price/blocked-and-gaps.md §A-1`(100행 차단 명세),
> `09_load/sticker/_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv`(직경 치수 L1), `02_mapping/load_price/t_prc_component_prices.csv`(GP 가격).
> **HARD**: DB 쓰기·DDL·COMMIT 0(인간 승인 전). 롤백전용 DRY-RUN까지만. 비밀번호 미출력.

---

## 1. 무엇을 추가하는가

| 산출 | 대상 테이블 | 행수 | 멱등 충돌키 |
|------|------------|:----:|------------|
| **(step 00) 시퀀스 재동기화** | `t_prc_component_prices_comp_price_id_seq` | — | `setval` (idempotent) |
| **원형 직경 siz 등록** | `t_siz_sizes` | **10 NEW** | `ON CONFLICT (siz_cd)` |
| **GP 원형 가격** | `t_prc_component_prices` | **100** (10직경×2mat×5수량밴드) | **auto-IDENTITY + 자연키 NOT EXISTS** |
| **066 원형 size link** | `t_prd_product_sizes` | **11** (신규 10 + 재사용 1) | `ON CONFLICT (prd_cd, siz_cd)` |

- **신규 siz_cd**: `SIZ_000501 .. SIZ_000510` (10연번). 직경 10/15/20/25/30/40/45/50/55/60mm.
- **재사용 siz**: 원형35mm = `SIZ_000422`(committed _exec_price GO 번들에 이미 적재) — **재등록하지 않음**.
- **GP 가격 100행**: source `t_prc_component_prices.csv`의 `SIZ_PENDING_GP_원형*`(35mm 제외) 행을
  실 siz_cd(501~510)로 치환. `comp_price_id`는 **auto-IDENTITY**(명시 폐지, 아래 §6 수정 참조).

> **[수정 2026-06-07 — 라이브 DRY-RUN 적발]** 기존 02 는 명시 `comp_price_id`(2956~3065) +
> `ON CONFLICT (comp_price_id) DO NOTHING` 이었으나, `comp_price_id` 는 IDENTITY(BY DEFAULT)·시퀀스
> stale(last_value=2 vs MAX=4805)이라 (1) 명시 ID 는 시퀀스를 무시해 향후 auto-IDENTITY 와 충돌·비멱등,
> (2) ON CONFLICT(comp_price_id) 가 명시 ID 가 우연히 라이브에 있으면 자연키 무관하게 가격행을 silently
> skip(under-load) 하는 결함이 있었다. → **02 를 auto-IDENTITY(comp_price_id 생략) + 자연키 NOT EXISTS
> 멱등 가드**로 전환하고, migrate.sql **step 00 에 setval**(시퀀스→MAX)을 추가. 라이브 2-pass DRY-RUN 실증:
> GP 가격 100행이 `comp_price_id` 4806~ 발급(충돌 0), 2회차 0행(멱등), 35mm committed 10행 무간섭.

## 2. 왜 (배경 — 동일 상품의 같은 원형 직경)

- **GP = `COMP_GANGPAN_PRINT`**(합판도무송 인쇄가공비). 스티커 상품 **PRD_000066(합판도무송스티커)**의
  원형 size 옵션과 GP 가격 component는 **같은 상품의 동일 원형 직경**을 가리킨다.
- round-2 가격 추출 시 원형 직경 siz가 라이브 부재라 `SIZ_PENDING_GP_원형{N}mm` placeholder로 보존(발명 회피·정당 blocker).
- round-4 G9 검증이 **원형35mm = 라이브 `SIZ_000422` 실재**를 적발 → 35mm 10행은 committed GO 번들로 승격(이미 적재).
- 잔여 **비-35mm 10 직경 = 100행**(`blocked-and-gaps.md §A-1`: "후니가 직경 siz 10종 등록(의미축=직경)") = 본 트랙 대상.

## 3. 후니 결정 사항 (FLAG — 인간 승인 대상)

> **10 신규 master 원형 siz 등록 = 후니 master-data 등록 결정.** 본 산출은 **준비만** — 직접 적재(COMMIT)는 인간 승인.

- 10 `t_siz_sizes` INSERT(`SIZ_000501..SIZ_000510`)는 후니 마스터데이터에 신규 원형 사이즈를 추가하는 결정이다.
- `siz_nm = '원형{w}x{h}'`(라이브 형제 `SIZ_000419 원형13x13`·`SIZ_000420 원형19x19`·`SIZ_000421 원형24x24`·`SIZ_000422 원형35x35` 컨벤션 추종).
- `cut_width=cut_height=직경`, `work=cut 동일`, `margin=0`, `impos_yn='N'`, `use_yn='Y'`, `del_yn='N'`.
  **치수는 BLOCKED CSV의 직경 데이터에서만**(발명 0). 판당 EA(8/8/6/3/2/2/1/1/1/1)는 **bundle_qty 차원**이라 siz엔 미인코딩(note에 보존).
- 승인 시 `./apply.sh --commit` (사전 `./backup.sh` 권장).

## 4. search-before-mint 재사용 (siz 1회만 등록 — 중복 0)

> **핵심**: 원형 직경 siz는 **sticker 066 size 옵션**과 **GP 가격 component** 양쪽이 같은 siz_cd를 공유한다.
> 따라서 직경 siz는 **STEP 1에서 단 한 번 등록**하고, STEP 2(가격)·STEP 3(size link) 둘 다 그 siz_cd를 참조한다.
> **중복 등록 없음** — register ONCE, reference TWICE.

- **search-before-mint 완료**(`code-row-preload.md §2`): 11 원형 직경 siz_nm을 라이브 `t_siz_sizes` **전수 매칭** →
  원형35x35만 매치(`SIZ_000422`), 나머지 10종 무매치 → 신규. 라이브 max=`SIZ_000500`.
- **35mm 재사용**: 가격 35mm(10행)은 committed `_exec_price/04`에 `SIZ_000422`로 이미 적재 → 본 트랙 가격 STEP 2에서 제외.
  size link STEP 3은 35mm도 포함하되 `SIZ_000422` 재사용(신규 등록 아님).

## 5. siz 번호 조율 (교차등록 충돌 회피 — HARD)

> 라이브 max siz_cd = `SIZ_000500`. 여러 트랙이 각각 신규 siz_cd를 라이브 직후 블록에서 발급하므로,
> **단일 연속 블록을 트랙별 구간으로 분할**해 충돌을 원천 차단한다(HANDOFF §18 번호 조율 준수).

| 구간 | 트랙 | 종수 | 상태 |
|------|------|:----:|------|
| `SIZ_000501 ~ 510` | **본 트랙 — sticker 066 원형 / GP 가격 공유** (신설 10종) | 10 | 본 마이그레이션 (원형35mm=`SIZ_000422` 재사용, 미소비) |
| `SIZ_000511 ~ 721` | **면적매트릭스 좌표** (`_migrate_areamatrix`, 211종) | 211 | 별도 트랙 (본 트랙 501~510과 **불교차**: 511 > 510) |
| `SIZ_000722 ~` | **향후 ENV / STK 등** (미정) | TBD | 미발급 |

- **왜 501~510인가**: 라이브 직후 첫 10블록을 본 sticker/GP 원형이 선점 예약. 면적매트릭스 트랙(`_migrate_areamatrix`)은
  이를 인지하고 **511부터** 시작하도록 이미 조정됨(`_migrate_areamatrix/MIGRATION.md §10` 확인). **충돌 0.**
- 최종 코드는 후니 마스터데이터 등록 결정이다. 후니가 다른 번호를 배정하면 빌더가 의존 적재행의 siz_cd를 실번호로 교체 후 재조립.

## 6. comp_price_id 시퀀스 + reg_dt 처리 (라이브 DRY-RUN 교훈 준수)

### 6.1 comp_price_id IDENTITY 시퀀스 재동기화 (step 00 — 수정 2026-06-07)

- **라이브 확증**: `t_prc_component_prices.comp_price_id` = IDENTITY(BY DEFAULT), 시퀀스
  `public.t_prc_component_prices_comp_price_id_seq` 가 `last_value=2`(stale)인데 `MAX(comp_price_id)=4805`·`count=3292`.
  2026-06-06 적재가 명시 ID 로 넣고 시퀀스를 전진시키지 않은 것이 근인.
- **결함**: 02 가 auto-IDENTITY(또는 명시 ID)로 INSERT 할 때 시퀀스가 1,2,…를 발급 → 기존 행과 PK 충돌.
- **수정**: migrate.sql **step 00** 에 `setval('…comp_price_id_seq', (SELECT COALESCE(MAX(comp_price_id),0) …), true)` 추가.
  → 시퀀스를 현재 MAX(4805)로 동기화. 02 의 GP 가격 100행은 4806~ 발급(충돌 0). setval 은 idempotent·롤백 시 영구 미반영.
- **02 멱등 가드**: `comp_price_id` 생략(auto-IDENTITY) + 자연키(8) `IS NOT DISTINCT FROM` NOT EXISTS.
  (GP 가격은 clr/coat/bdl 차원 NULL 이고 자연키 UNIQUE 가 NULLS DISTINCT 라 ON CONFLICT 무력 → NOT EXISTS 로 NULL-safe 매칭.)

### 6.2 reg_dt NOT NULL DEFAULT 처리

- **component_prices(STEP 2)**: `reg_dt`(NOT NULL DEFAULT now()) 컬럼을 **INSERT 컬럼 목록에서 생략** →
  DB DEFAULT now() 발화. (명시 NULL 금지 — round-5 라이브 DRY-RUN이 적발한 함정.)
- **product_sizes(STEP 3)**: `reg_dt`(NOT NULL DEFAULT now())에 BLOCKED CSV의 **실값 `'2026-06-05 00:00:00'` 명시**.
  공란이 아니라 실값이므로 NULL 위험 없음. source가 공란이면 생성기가 `DEFAULT` 키워드를 쓰도록 설계(`sql_ts` 헬퍼).
- `del_yn`(NOT NULL DEFAULT 'N')은 STEP 3에서 생략 → DEFAULT 발화. `upd_dt`/`del_dt`(NULL 허용)도 생략.

## 7. 안전 절차 (재실행 안전·롤백전용)

```
# 0) (권장) 적재 전 백업 스냅샷 — 읽기전용
./backup.sh
#    → backup_new_siz_range.csv (신규 siz_cd 범위 501~510 = undo 권위)
#      backup_existing_collisions.csv (0행=신규 siz_cd 라이브 부재 확증)
#      backup_gp_component_prices_before.csv (COMP_GANGPAN_PRINT 적재 전 상태, committed 35mm 포함)
#      backup_066_product_sizes_before.csv (PRD_000066 적재 전 size link)

# 1) DRY-RUN (기본) — migrate.sql 실행 후 강제 ROLLBACK. DB 무변경.
./apply.sh
#    → [guard0] 신규 원형 siz(501~510) 라이브 부재(0) — search-before-mint 정상.   ← 확인
#      [assert] GP 가격 100행 FK 고아(siz 미해소, 0=PASS): 0                       ← 확인
#      [assert] comp_cd COMP_GANGPAN_PRINT 라이브 존재(1=PASS): 1                  ← 확인
#      [assert] 066 size link siz FK 고아(0=PASS): 0 / PRD_000066 존재(1=PASS): 1  ← 확인

# 2) 실제 적재 (인간 승인 시에만)
./apply.sh --commit          # 10 siz + 100 GP 단가 + 11 size link COMMIT

# 3) 되돌리기 (필요 시)
./undo.sh                    # DRY-RUN (롤백)
./undo.sh --commit           # GP 가격(자연키 comp_cd+siz 501~510) DELETE + 066 link(501~510) DELETE + 10 siz DELETE
```

- `migrate.sql`은 단일 `BEGIN…COMMIT`(원자성). step 00 setval → 가드0 → 01·02·03 → assert. `apply.sh` DRY-RUN이 마지막 `COMMIT;`→`ROLLBACK;` 치환.
- siz/link = `ON CONFLICT … DO NOTHING`, 가격 = **자연키 NOT EXISTS** (멱등) — 라이브 2-pass DRY-RUN 실증 완료(2회차 0행, §10).
- **undo 가격 DELETE 는 자연키(comp_cd=COMP_GANGPAN_PRINT + siz 501~510)** — `comp_price_id` 명시 폐지로 PK IN 불가.
  35mm(`SIZ_000422`)는 siz IN 절에서 빠지므로 committed 분 보존(무간섭).
- 자격증명은 `.env.local`(`RAILWAY_DB_*`)에서만. 비밀번호는 어떤 스크립트도 stdout/로그/`_workspace`에 출력하지 않는다.
- **35mm(`SIZ_000422`)는 committed 분** → undo는 35mm size link·siz를 절대 제거하지 않음(IN 절에서 제외).

## 8. 알려진 플래그 (정직 보고)

| # | 항목 | 상태 |
|---|------|------|
| GP-1 | **소재묶음(mat 대표값)** | source CSV note "소재묶음=대표mat" 보존. MAT_000084(비코팅 계열 대표)·MAT_000153(유포 계열 대표) 2 대표 mat. 원천 가격표가 소재 그룹별 단가라 대표 mat로 묶음 — round-2 추출 결정(본 트랙 불변, verbatim 승계). |
| GP-2 | **판당 EA = bundle 차원** | 원형 직경별 판당 EA(8/8/6/3/2/2/1/1/1/1)는 size축 아님 → siz_cd에 미인코딩, siz note + provenance에만 보존. K-4 의미축 결정(`code-row-preload.md §2`)과 일치. |
| GP-3 | **35mm 비대칭 처리** | 가격 35mm = committed(STEP 2 제외) · size link 35mm = 본 트랙 포함(STEP 3, `SIZ_000422` 재사용). 이유: 가격은 이미 적재됐고, size link는 round-4 BLOCKED(전체 11행 미적재)라 본 트랙이 11행 일괄 처리. 중복 적재는 `ON CONFLICT (prd_cd, siz_cd)`로 멱등 방지. |
| GP-4 | **siz 등록 = 인간 승인** | 10 신규 siz는 후니 master-data 등록 결정. COMMIT·등록 둘 다 인간 승인 전 0. |

## 9. 산출 파일

| 파일 | 내용 |
|------|------|
| `gen_migrate_sql.py` | 생성기(입력 CSV/권위표 verbatim → 멱등 SQL, 재현성. 손편집 금지) |
| `01_siz_register.sql` | 10 NEW 원형 siz INSERT (`ON CONFLICT (siz_cd) DO NOTHING`) |
| `02_component_prices.sql` | 100 GP 가격 INSERT (**auto-IDENTITY + 자연키 NOT EXISTS** 가드, 수정 2026-06-07) |
| `03_product_sizes.sql` | 11 066 원형 size link (`ON CONFLICT (prd_cd, siz_cd) DO NOTHING`) |
| `migrate.sql` | 단일 트랜잭션 래퍼(BEGIN → **step00 setval** → 가드0 → 01 → 02 → 03 → assert ×4 → COMMIT) |
| `apply.sh` | 로더(기본 DRY-RUN/rollback, `--commit`=인간 승인). `.env.local`만. 비번 미출력 |
| `backup.sh` / `backup.sql` | 읽기전용 백업 스냅샷(undo 권위) |
| `undo.sh` / `undo.sql` | 역실행(가격 자연키 DELETE + link 10 + siz 10 DELETE, 35mm 보존) |
| `migrate.provenance.csv` | 생성행 → source CSV/권위표 출처(검증 역대조) |

## 10. 라이브 2-pass DRY-RUN 실증 (수정 검증, 2026-06-07)

롤백전용 단일 트랜잭션 내 2회 적재 + 강제 ROLLBACK(COMMIT 0, DB 영구 무변경):

| 점검 | PASS 1 | PASS 2 | 판정 |
|------|:------:|:------:|:----:|
| setval (시퀀스→MAX) | 4805 | 4905 | OK (재동기화 발화) |
| siz 501~510 | 10 | 10 | 멱등 (2회차 0행) |
| GP 가격 (501~510) | 100 | 100 | **멱등 + under-load 0** |
| GP 가격 comp_price_id 범위 | 4806~ | — | **충돌 0** (>MAX 4805) |
| 066 size link | 11 | 11 | 멱등 |
| 35mm(SIZ_000422) committed | 10 | 10 | **무간섭** |
| ROLLBACK 후 잔존 | — | 0 | DB 영구 무변경 |

→ 수정(auto-IDENTITY+자연키 가드+setval) 실증 완료. **GP 가격 정확히 100행 적재(under-load 해소), 2회차 0행(멱등).**

## 11. 검증 핸드오프 (자기 승인 금지)

`dbm-validator`에게 R1~R6 최종 게이트(위 §10 라이브 DRY-RUN 결과 포함 재확인)를 요청한다. 빌더는 자기 승인하지 않는다.
별도 디렉터리이며 committed `_exec_price`/`_exec`/`_migrate_fixedprice`/`_migrate_areamatrix`와 무간섭.
