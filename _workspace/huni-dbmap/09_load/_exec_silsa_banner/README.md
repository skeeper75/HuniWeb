# _exec_silsa_banner — 일반현수막(PRD_000138) round-5 적재 실행본

round-4/round-6 GO 매핑(가격엔진 + **[v2] CPQ 옵션 레이어 자재+공정 BUNDLE**)을 **재실행 안전한 멱등 적재 SQL + 로더 + 롤백전용 DRY-RUN**으로 실행본화한 패키지.

> [HARD] **DB COMMIT·DDL적용·자재 mint·코드행등록·siz등록 = 인간 승인.** 본 패키지는 멱등 실행본 + 롤백전용 DRY-RUN 까지만. 실제 INSERT/COMMIT 미수행.
> **[v2 갱신 범위]** 옵션 부분만(`silsa-option-layer-v2.md` + `load_silsa_v2/` 기준). 가격(01~05)·siz BLOCKED(B01/B02)·열재단 PROC 제안 = 변경 없음.

---

## 실행법

```bash
cd 09_load/_exec_silsa_banner

# 1) SQL 재생성 (CSV → 멱등 SQL, 재현성. load/*.csv 변경 시에만)
python3 gen_load_sql.py

# 2) DRY-RUN (기본, 롤백전용 — 아무것도 커밋 안 됨)
./apply.sh             # = ./apply.sh dryrun

# 3) [인간 승인] 실제 COMMIT (영구 적재)
./apply.sh commit
```

- 로더는 `.env.local`(프로젝트 루트)에서 `RAILWAY_DB_*` 로드. 비밀번호 stdout/_workspace 기록 안 함.
- `apply.sql` 은 `BEGIN` 으로 열고, COMMIT/ROLLBACK 은 로더가 주입(기본 ROLLBACK).

## BLOCKED 활성화 (siz 등록 후, 인간 승인)

```bash
cd _blocked
# (가격/siz) B01 siz 77 등록 → B02 area-cell 77 활성화. 기본 apply 경로 밖.
psql ... -f apply_blocked.sql -c "ROLLBACK;"           # DRY-RUN. 실제는 인간 승인 COMMIT
# [v2] (자재 BUNDLE) 자재 mint(B03a)→자재 링크(B03b)→자재 seq item(B04). 옵션헤더(06/07) 선행.
psql ... -f apply_blocked_options.sql -c "ROLLBACK;"   # 끈/양면테입=즉시·큐방/각목/봉제사=mint 후
```

---

## 파일 구성

| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | CSV→멱등 SQL 생성기(R3·G8 재현성, 손편집 금지) |
| `apply.sql` | 주 트랜잭션 래퍼(\i 00~09) |
| `apply.sh` | psql 로더(기본 dryrun, `commit` 인간 승인) |
| `00_preload_markers.sql`~`09_t_prd_product_constraints.sql` | per-step 멱등 SQL(INSERTABLE 58행). **08=[v2] 공정 seq 9** |
| `_blocked/B01_t_siz_sizes.sql`·`B02_t_prc_component_prices.sql`·`apply_blocked.sql` | 가격/siz BLOCKED 활성화(siz 77 + area 77, 인간 승인) |
| `_blocked/B03a_t_mat_materials_MINT.sql`·`B03b_..._LINK.sql`·`B04_..._option_items_MAT.sql`·`apply_blocked_options.sql` | **[v2]** 자재 seq BUNDLE 활성화(자재 mint 제안→링크→자재 seq item, 인간 승인) |
| `load/*.csv` | 입력 GO 적재본(가격엔진 + **[v2] load_silsa_v2 옵션 레이어**, 재현성용 사본) |
| `load.provenance.csv` | INSERT→source CSV/ref 추적(검증 역대조) |
| `load-manifest.md` | FK 위상정렬 적재 순서 + 행수 + 충돌키 + INSERTABLE/BLOCKED/GAP 집계 |
| `blocked-and-gaps.md` | BLOCKED(B-1~B-5) + GAP(G-1/2) + 인간 결정 8건(사유·해소 조건) |
| `ddl-proposals.md` | DDL/mint 제안 인덱스(열재단 PROC_000084 + **[v2] 자재 mint 4** + NULLS-DISTINCT 발견) |
| `dryrun-log.md` | 라이브 롤백전용 DRY-RUN 2-pass 결과(R1/R2/R3/R5 + **§2A [v2] 자재 BUNDLE**) |

---

## 적재 요약 (v2: 옵션=자재+공정 BUNDLE)

| 트랙 | INSERTABLE(주 트랜잭션) | BLOCKED(인간 승인) | GAP |
|---|:--:|:--:|:--:|
| 가격(price) — **불변** | 36 (formula 1·comp 10·wiring 11·comp_prices 13·binding 1) | 77 (area-cell, siz 의존) | 0 |
| 상품마스터(CPQ) — **[v2]** | 22 (groups 2·options 11·**옵션아이템 공정 seq 9**) | **109** (siz 77·자재 mint 4·자재 링크 6·자재 seq item 8·열재단 1) | 1 (R-GAKMOK var=mat_cd) |
| **합계** | **58** | **186** | **1** |

> **[v2 변경: 옵션 부분만]** v1 공정-only/셋트(.07) → v2 자재(.03)+공정(.04) BUNDLE. 주 트랜잭션 INSERTABLE 58 **불변**(옵션아이템 9=공정 seq). BLOCKED 157→186 — v1이 자재 의미 누락(과소계상)한 것을 v2가 자재 seq·자재 mint·자재 링크로 정직하게 노출. 가격(01~05)·siz BLOCKED·열재단 PROC 제안 = **변경 없음**.

## DRY-RUN 결과 (자기점검 — 최종 판정은 dbm-validator)

| 게이트 | 결과 |
|---|:--:|
| R1 멱등성 (2-pass delta=0, 8테이블) | PASS |
| R2 원자성 (단일 BEGIN…ROLLBACK) | PASS |
| R3 실행성 (전 .sql 파싱·실행 exit 0) | PASS |
| R5 라이브 DRY-RUN (제약위반 0) | PASS |
| COMMIT 금지 (롤백 후 라이브 banner 0행) | 준수 |

> R4(DDL 정합)·R6(독립 검증)는 `dbm-validator` 가 `03_validation/`에서 수행. 본 패키지는 자기승인 아님.

---

## 핵심 설계 결정 (라이브 직접 확인)

1. **`t_prc_component_prices` = surrogate IDENTITY PK + 자연키 UNIQUE 인덱스가 NULLS DISTINCT** → 옵션 flat 행(차원 NULL) `ON CONFLICT` 미발화 → **변형 C(WHERE NOT EXISTS + IS NOT DISTINCT FROM)** 로 NULL-safe 멱등. `ddl-proposals.md`에 surface.
2. **BLOCKED 분리** — 주 트랜잭션엔 INSERTABLE 만. siz 미등록 area-cell 77·siz 77·열재단·**[v2] 자재 seq(.03)·자재 mint·자재 링크**는 `_blocked/`/`*_BLOCKED.csv`로 격리(침묵 drop 0). DRY-RUN 으로 FK/트리거 의존 실증.
3. **[v2] 옵션 = 자재(.03)+공정(.04) BUNDLE** — 한 옵션이 자재 의미+공정 의미를 동시에 가짐(예 양면테입=자재+부착). 주 트랜잭션 옵션아이템 9=공정 seq(INSERTABLE), 자재 seq 8=BLOCKED(자재 링크/mint 후 활성화). 끈 MAT_000070·양면테입 MAT_000069=master 실재(링크만)·큐방/각목/봉제사=mint+링크. 각목=material(.03, v1 셋트.07 폐기). R-GAKMOK var=mat_cd.
4. **D-WIRE** — PRD_000138 전용 합산형 PRF_BANNER_NORMAL 신설(기존 공유 PRF_POSTER_FIXED sparse 와 공존, 정리는 인간 승인).
5. **열재단 = 신규 공정**(완칼 차용 폐기) — DDL 제안 재사용(`11_ddl_proposals/heat-cut-process-proposal.sql`).
