# 면적매트릭스 좌표 siz 등록 + 면적 component_prices 마이그레이션

> **트랙**: round-5 적재 실행본 — 가격(면적매트릭스). round-4 GO 적재본을 실 적재 가능한
> 멱등 SQL + 로더로 완성. **권위**: `02_mapping/price-correction-poster-sign.md`(round-2 면적-좌표 정정),
> `02_mapping/load_price_correction/areamatrix-siz-registration.csv`(308 좌표 결정본).
> **HARD**: DB 쓰기·DDL·COMMIT 0(인간 승인 전). 롤백전용 DRY-RUN까지만. 비밀번호 미출력.

---

## 1. 무엇을 추가하는가

| 산출 | 대상 테이블 | 행수 | 멱등 충돌키 |
|------|------------|:----:|------------|
| **좌표 siz 등록** | `t_siz_sizes` | **211 NEW** | `ON CONFLICT (siz_cd)` |
| **면적 component_prices** | `t_prc_component_prices` | **907** (POSTER 670 + ACRYL 237) | `ON CONFLICT (comp_price_id)` |

- **신규 siz_cd**: `SIZ_000511 .. SIZ_000721` (211연번). 라이브 max(`SIZ_000500`) 직후 블록에서
  **501~510은 round-5 sticker 원형 예약** → 면적은 **511부터** 시작(교차등록 조율, §10). 충돌 0 검증.
- **재사용 siz**: 97종(EXACT 68 + REVERSED 29) — **재등록하지 않음**(기존 라이브 siz 재사용).
- **면적 prices**: source `02_mapping/load_price/t_prc_component_prices.csv`의 `SIZ_PENDING_POSTER_*`(670) +
  `SIZ_PENDING_ACRYL_*`(237) 행을 등록/재사용 좌표 siz로 치환. `comp_price_id`는 source CSV 값 명시(committed `_exec_price` 04 패턴 일치).

## 2. 왜 (정정 배경)

- round-2가 포스터사인 면적매트릭스 가격을 `SIZ_PENDING_*` placeholder로 적재(좌표 siz 미등록).
  **면적매트릭스 = [세로mm][가로mm] 행렬이고, 가격셀 자체가 사이즈**다 — 좌표마다 실 siz_cd가 필요하다.
- 면적매트릭스 = 실사 11(PRD_000118~128) + 현수막 2(PRD_000138/139) + 아크릴 3소재(투명3T/1.5T·미러3T).
- **search-before-mint 완료**: 308 distinct 좌표를 라이브 497 siz와 양방향(EXACT/REVERSED) 대조 →
  **211종만 부재(신규 등록)**, 97종은 기존 재사용. 발명 0.

## 3. 후니 결정 사항 (FLAG — 인간 승인 대상)

> **211 신규 master 좌표 siz 등록 = 후니 master-data 등록 결정.** 본 산출은 **준비만** — 직접 적재(COMMIT)는 인간 승인.

- 211 `t_siz_sizes` INSERT(`SIZ_000511..SIZ_000721`)는 후니 마스터데이터에 신규 좌표 사이즈를 추가하는 결정이다.
- `siz_nm = 'WxH'`(라이브 컨벤션 `316x467`·`60x40`와 일관). `cut/work_width = width_mm`, `cut/work_height = height_mm`,
  `margin = 0`(면적 직접입력형), `impos_yn='N'`, `use_yn='Y'`, `del_yn='N'`. **치수는 areamatrix의 W×H 데이터에서만**(발명 0).
- 승인 시 `./apply.sh --commit` (사전 `./backup.sh` 권장).

## 4. 면적 13 + 아크릴 = 재바인딩 없음

- 면적 13(실사11+현수막2)은 **이미 `PRF_POSTER_FIXED`에 바인딩**되어 GO 커밋됨 → **재바인딩하지 않는다.**
  migrate.sql STEP 0 가드가 13 바인딩 존재를 확인(미만이면 WARNING만, 재바인딩 INSERT 없음).
- 아크릴 3소재도 면적매트릭스 단가를 component_prices로 추가할 뿐, 공식 바인딩은 건드리지 않는다
  (아크릴 = 인쇄가공비 매트릭스. 수량할인·후가공은 별도 적용단 — 본 마이그레이션 범위 외).
- 본 마이그레이션은 **좌표 siz 등록 + 면적 단가 추가**만 한다. 공식/바인딩 변경 0.

## 5. 안전 절차 (재실행 안전·롤백전용)

```
# 0) (권장) 적재 전 백업 스냅샷 — 읽기전용
./backup.sh
#    → backup_new_siz_range.csv (신규 siz_cd 범위=undo 권위)
#      backup_existing_collisions.csv (0행=신규 siz_cd 라이브 부재 확증)
#      backup_area_component_prices_before.csv (영향 comp_cd 적재 전 상태)

# 1) DRY-RUN (기본) — migrate.sql 실행 후 강제 ROLLBACK. DB 무변경.
./apply.sh
#    → [assert] 본 적재 907행 FK 고아(siz 미해소, 0이어야 PASS): 0   ← 확인 포인트

# 2) 실제 적재 (인간 승인 시에만)
./apply.sh --commit          # 211 siz + 907 면적 단가 COMMIT

# 3) 되돌리기 (필요 시)
./undo.sh                    # DRY-RUN (롤백)
./undo.sh --commit           # comp_price_id IN(907) DELETE + 211 siz DELETE
```

- `migrate.sql`은 단일 `BEGIN…COMMIT`(원자성). `apply.sh` DRY-RUN이 마지막 `COMMIT;`→`ROLLBACK;` 치환.
- 모든 INSERT는 `ON CONFLICT … DO NOTHING`(멱등) — 2회 적용 시 2회차 행변경 0(라이브 DRY-RUN 실증).
- 자격증명은 `.env.local`(`RAILWAY_DB_*`)에서만. 비밀번호는 어떤 스크립트도 stdout/로그/`_workspace`에 출력하지 않는다.

## 6. 라이브 롤백전용 DRY-RUN 결과 (실증)

> `BEGIN … 01_siz_register … 02_component_prices … assert … (재적용) … ROLLBACK` 로 라이브에서 검증. **COMMIT 0.**

| 항목 | 결과 |
|------|------|
| siz INSERT | **211** (`SIZ_000511..721`. 라이브 500 → 711) |
| 면적 prices INSERT | **907** (라이브 3292 → 4199) |
| **본 적재 907행 FK 고아(siz)** | **0** (등록 211[511~721] + 재사용 97로 전건 해소) |
| FK 고아(comp_cd) | 0 (전건 `t_prc_price_components` 존재) |
| **멱등성(R1) 2회 적용** | siz 711=711, prc 4199=4199 → **2회차 델타 0 (PASS)** |
| comp_price_id PK 충돌 | 0 (907 distinct, 라이브 부재 확증) |
| ROLLBACK 후 라이브 | 500 siz / 3292 prc (무변경 확인) |
| **제약 위반 합계** | **0** |

> 주: siz 누적 카운트 711 = 라이브 500 + 211. 신규 siz_cd 값은 `SIZ_000511..721`(501~510은 sticker 예약, 미사용).

## 7. off-grid ceiling = 런타임 (DB 미저장)

- 가로×세로가 매트릭스 셀에 정확히 없으면 **한 단계 큰 크기 가격**을 적용 — 이는 **가격계산 런타임(위젯/엔진) 로직**이다.
  DB에는 **매트릭스 셀(좌표 단가)만 저장**한다. off-grid 보간/올림은 저장하지 않는다.

## 8. 알려진 플래그 (정직 보고)

| # | 항목 | 상태 |
|---|------|------|
| AM-1 | **REVERSED 29종 siz 재사용** | areamatrix CSV(결정본)가 REVERSED→existing_siz_cd로 확정(면적 동일·직접입력형이라 정당). 단 source row note 일부에 `[에스컬레이션: 역방향만 존재 …교체 보류]` 잔존 문구 — CSV가 후행 권위라 CSV 따름. 의미축(가로/세로) 엄밀 보존 필요 시 후니 재검토 여지. |
| AM-2 | **21건 (comp_cd,siz_cd) 동일행** | REVERSED siz 수렴(WxH↔HxW 같은 siz_cd)으로 동일 (comp_cd,siz_cd) 21쌍 발생. **전건 SAME-PRICE**(룩업 모순 0) — comp_price_id로 distinct 적재. ACRYL 면적가는 면적만으로 결정되므로 정상. |
| AM-3 | **고정가 placeholder 10행 제외** | source `SIZ_PENDING_POSTER_{A1,5x5,5x7,8x8,8x10}` 10행은 면적 아님(고정가형) → areamatrix 부재 → 본 마이그레이션 **제외**. 별도 `_migrate_fixedprice`가 처리(§6.5.4). |
| AM-4 | **라이브 선존재 17 고아 (범위 외)** | `COMP_POSTEROPT_BANNER_*`(현수막 가공·추가옵션) 17행이 `siz_cd=NULL`로 **이미 라이브에 존재** — 본 마이그레이션이 만든 것 아님. authority §6 F-6(현수막 가공옵션 별도 add-on 처리)대로 본 범위 외. |

## 9. 산출 파일

| 파일 | 내용 |
|------|------|
| `gen_migrate_sql.py` | 생성기(입력 CSV verbatim → 멱등 SQL, 재현성. 손편집 금지) |
| `01_siz_register.sql` | 211 NEW 좌표 siz INSERT (`ON CONFLICT (siz_cd) DO NOTHING`) |
| `02_component_prices.sql` | 907 면적 단가 INSERT (`ON CONFLICT (comp_price_id) DO NOTHING`) |
| `migrate.sql` | 단일 트랜잭션 래퍼(BEGIN → 가드 → 01 → 02 → assert → COMMIT) |
| `apply.sh` | 로더(기본 DRY-RUN/rollback, `--commit`=인간 승인). `.env.local`만. 비번 미출력 |
| `backup.sh` / `backup.sql` | 읽기전용 백업 스냅샷(undo 권위) |
| `undo.sh` / `undo.sql` | 역실행(comp_price_id IN 907 DELETE + 211 siz DELETE) |
| `migrate.provenance.csv` | 생성행 → source CSV 출처(검증 역대조) |

## 10. 교차등록 번호 조율 (pending siz 충돌 회피 — HARD)

> 라이브 max siz_cd = `SIZ_000500`. 여러 트랙이 **각각 신규 siz_cd를 라이브 직후 블록**에서 발급하려 하므로,
> **단일 연속 블록을 트랙별 구간으로 분할**해 번호 충돌을 원천 차단한다. 아래는 **조율된 제안**이며,
> **후니가 최종 코드를 직접 배정**(제안 번호와 다를 수 있음)할 수 있다 — 그 경우 빌더가 의존 적재행의 siz_cd를 실번호로 교체 후 재조립.

| 구간 | 트랙 | 종수 | 출처 | 상태 |
|------|------|:----:|------|------|
| `SIZ_000501 ~ 510` | **round-5 sticker 066 원형** (신설 10종) | 10 | `09_load/_assembled/code-row-preload.md §2` | pending 후니 등록 (원형35mm=`SIZ_000422` 재사용, 미소비) |
| `SIZ_000511 ~ 721` | **면적매트릭스 좌표** (본 마이그레이션, 211종) | 211 | 본 트랙 | pending 후니 등록 |
| `SIZ_000722 ~` | **향후 GP 직경 / ENV / STK 등** (미정) | TBD | 차기 트랙 | 미발급 (721 이후부터) |

- **왜 면적이 511부터인가:** 라이브 직후 첫 10블록(501~510)을 sticker 원형이 선점 예약했으므로,
  본 면적 트랙은 **그다음 511부터** 211연번을 발급한다. (이전 빌드는 501부터 시작 → sticker 501~510과 충돌 → 본 정정.)
- **후속 트랙(GP 직경·ENV·STK 등)은 `SIZ_000721` 이후**부터 이어서 발급한다 — 본 두 트랙이 501~721을 점유함을 기준으로.
- **본 트랙 collision-free 검증(read-only):** 라이브 `t_siz_sizes`에 `SIZ_000511..721` **부재(count 0)** 확인 +
  sticker 예약 구간(501~510)과 **불교차**(511 > 510) 확인. 충돌 0.
- 최종 코드는 후니 마스터데이터 등록 결정이다. 본 표는 트랙 간 **번호 조율 제안**일 뿐, 실배정 권위는 후니에 있다.
