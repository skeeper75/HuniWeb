# G6 clone 실현성 조사

> 대상: SPEC-WORLDMODEL-001 `AC-M0-10` (블로커 후보) · S1 착수 선행 조건
> 관측 시각: 2026-08-15 (KST) · 관측자: 본 조사
> **판정: FEASIBLE** (§4)

---

## 0. 왜 이 조사인가 · 안전 규율

### 0.1 왜

FIX-4 반전으로 G6 의 라이브 오라클 두 축이 모두 폐기됐다.

- **`/handoff` 축** — `t_wgt_handoff_logs` 에 로그를 남기므로 라이브 write 유발 (`gate-report.md:57` A2, `:175`).
- **`/validate` 축** — 공통 게이트 `_gate` 가 `widget_api.py:135` 의 `t_wgt_widgets` UPDATE(`_touch_used`)와 `:195-196` 의 `cache.get_or_set`/`cache.incr` 를 무조건 태운다.

→ **G6 오라클은 clone DB 리플레이 단일 경로에만 의존한다.** 그런데 그 clone 의 생성·폐기·동일성 검사가 실제로 가능한지는 게이트도 보충 검증도 확인하지 않았다 (`coverage-supplement.md:435` — *"G6 의 clone DB 경로 실현 가능성을 검증하지 않았다 … 인프라 사실이며 이 문서가 확인하지 않았다"*).

**clone 이 불가하면 G6 자체가 실행 불가**이고, 설계 주장 4("확정 권위를 위젯에 남기면 안전하다")의 반증 조건이 측정 없이 남는다. 이 조사는 그 인프라 사실을 실측한다.

### 0.2 안전 규율 (이 조사에서 실제로 지킨 것)

| 규율 | 준수 여부 | 증거 |
|---|---|---|
| 라이브 DB 읽기 전용 SELECT 만 | **준수** | 모든 psql 세션에 `SET default_transaction_read_only=on` 선행. INSERT/UPDATE/DELETE/DDL/`CREATE DATABASE`/`DROP` 0건 |
| clone 을 실제로 생성하지 않음 | **준수** | 본 조사는 **가능성 조사**까지. `pg_dump` 를 실행하지 않았고, 로컬 DB 를 만들지 않았고, Railway 에 어떤 서비스도 만들지 않음 |
| 자격증명 비노출 | **준수** | `.env.local` 의 **키 이름과 역할만** 기록. 값은 셸 하위프로세스 환경변수로만 전달, stdout·문서·로그 어디에도 미출력 |
| 비용 발생 조작 미시도 | **준수** | 플랜 변경·인스턴스 추가·PITR 활성화 **미시도**. §2.1·§2.3 에 옵션으로만 기록 |
| `raw/webadmin/**` 무수정 | **준수** | 읽기(`grep`/`sed`)만 수행 |

**사용한 자격증명 키 이름과 역할** (값 비노출):

| 키 이름 | 역할 |
|---|---|
| `RAILWAY_DB_HOST` | 라이브 Postgres 호스트 |
| `RAILWAY_DB_PORT` | 포트 |
| `RAILWAY_DB_USER` | 접속 계정 |
| `RAILWAY_DB_PASSWORD` | 비밀번호 (`PGPASSWORD` 로만 전달) |
| `RAILWAY_DB_NAME` | 데이터베이스명 |

출처: `.env.local` (D8 이 `:128-132` 로 기록한 블록). **`.env.local` 은 실재하며 접속에 성공했다** — 정적 조사 대체 경로는 발동하지 않았다.

---

## 1. 현행 DB 환경 실측

모두 이번 조사에서 직접 관측한 값이다. D8(`02_diagnosis/D8-live-schema.md`) 기록과 대조·갱신한다.

### 1.1 엔진·규모

| 항목 | 이번 실측 (2026-08-15) | D8 기록 | 판정 |
|---|---|---|---|
| 엔진 | **PostgreSQL 18.4** (Debian 18.4-1.pgdg13+1, x86_64) | PG 18.4 | 일치 |
| public 테이블 총수 | **154** | 154 | 일치 |
| 그중 `t_*` 도메인 | **46** | 46 | 일치 |
| 그중 `bak_*`/`z_bak_*` | **97** | 97 | 일치 |
| public 릴레이션 총합 (`pg_total_relation_size`) | **38 MB** | 27 MB | **갱신** (+11 MB) |
| 데이터베이스 총 크기 (`pg_database_size`) | **37 MB** | (미기록) | 신규 |
| 뷰 / matview | **2 / 0** | 2 / — | 일치 |
| 사용자 함수 (public) | **5** | 5 | 일치 |
| 비내부 트리거 | **46** | 46 | 일치 |
| 시퀀스 | **12** | (미기록) | 신규 |
| large object | **0** | (미기록) | 신규 |

> D8 의 27 MB → 38 MB 증가는 이 DB 가 계속 실사용 중이라는 D8 판정(*"어제까지 실사용 중인 운영 DB"*)과 정합한다. **크기가 늘었다는 사실 자체는 clone 논의를 바꾸지 않는다** — 아래 §1.2 참조.

### 1.2 37 MB 라는 크기가 clone 논의에서 갖는 의미

**결정적으로 유리하다.** 판단 근거:

- **`pg_dump` 는 이 규모에서 사실상 즉시 끝난다.** 37 MB 는 논리 덤프 기준 수 초~수십 초 규모다. 병렬 덤프(`-j`)나 특별한 튜닝이 전혀 필요 없다.
- **네트워크가 유일한 변수인데, 그것도 작다.** `railway-support-ticket-cpu-steal.md` 가 기록한 한국↔싱가포르 경로 혼잡(피크시간 10~24% 요청이 >1s)은 **레이턴시** 문제이지 **대역폭** 문제가 아니다. 37 MB 전송은 혼잡 구간에서도 분 단위를 넘지 않는다.
- **로컬 디스크 여유 12 GB 로 충분하다.** 37 MB 덤프 + 복원본은 100 MB 미만이다 (디스크 98% 사용 중이라 여유가 빠듯하지만 3자릿수 배 여유).
- **clone 이 "무거워서 못 한다"는 시나리오는 성립하지 않는다.** 만약 이 DB 가 수십 GB 였다면 로컬 복원 경로가 현실성을 잃고 Railway 유료 인스턴스 경로만 남았을 것이다. 37 MB 는 그 갈림길을 **로컬 무료 경로 쪽으로 완전히 넘긴다.**

### 1.3 접속 계정 권한 실측 [핵심]

읽기 질의만으로 확인했다.

```
SELECT current_user, usesuper, usecreatedb, userepl, usebypassrls FROM pg_user WHERE usename=current_user;
→ postgres | t | t | t | t

SELECT has_database_privilege(current_user, current_database(), 'CREATE'),
       has_database_privilege(current_user, current_database(), 'CONNECT'),
       has_schema_privilege(current_user,'public','CREATE');
→ t | t | t
```

| 권한 | 실측 | clone 관점 함의 |
|---|---|---|
| `usesuper` (슈퍼유저) | **예** | `pg_dump` 가 요구하는 모든 객체(함수 본문·트리거·시퀀스·소유권)에 접근 가능 |
| `usecreatedb` | **예** | **`CREATE DATABASE` 권한 있음** — 원한다면 라이브 서버 상에 scratch DB 생성 가능 (단 §2.3 이유로 비권장) |
| `userepl` (replication) | **예** | 물리 복제/`pg_basebackup` 경로도 원리상 열려 있음 |
| DB `CREATE` / schema `CREATE` | **예 / 예** | 동일 |
| 소속 role | 없음 (직접 슈퍼유저) | 권한 상속 복잡성 없음 |

**pg_dump 에 필요한 읽기 권한 전수 확인:**

```
SELECT count(*) FROM pg_tables t WHERE t.schemaname='public'
  AND NOT has_table_privilege(current_user, ..., 'SELECT');
→ 0
```

→ **읽기 불가 테이블 0개.** 154개 전부 덤프 가능하다.

### 1.4 덤프/복원 시 문제가 될 수 있는 객체

| 객체 유형 | 실측 | 복원 리스크 판정 |
|---|---|---|
| **확장(extension)** | **`plpgsql` 1.0 단 하나** (pg_catalog) | **무위험.** plpgsql 은 모든 PostgreSQL 기본 탑재. 서드파티 확장(postgis·pgcrypto·uuid-ossp 등) **0개** — 이것이 가장 큰 안심 요소다 |
| **사용자 함수** | 5개 — `fn_upd_dt`, `fn_chk_opt_item_ref`, `fn_calc_pansu`, `fn_best_plate`, `fn_best_plate_default`. **전부 `plpgsql`** | **무위험.** 언어가 plpgsql 하나뿐이라 별도 확장·C 라이브러리 의존 없음. `sql/03_triggers.sql`·`sql/32_fn_calc_pansu.sql`·`sql/33_fn_best_plate.sql` 이 실재하는 것과 정합 |
| **트리거** | 46개 (비내부). 내역: `fn_upd_dt` **45개**, `fn_chk_opt_item_ref` **1개**. `fn_upd_dt` 트리거가 달린 테이블 **45개** | **저위험, 단 §3.3 주의.** `pg_dump` 는 트리거를 DDL 로 복원한다. 다만 `fn_upd_dt` 는 UPDATE 시 `upd_dt` 를 자동 갱신하므로 **동일성 검사 시점 규율이 필요하다**(§3.3) |
| **시퀀스** | 12개 | **저위험.** `pg_dump` 가 `setval` 로 현재값을 함께 덤프한다 |
| **뷰** | 2개 (`v_cfg_ref_impact`, `vc_v_product_detail_tabs`) | 무위험 |
| **materialized view** | 0개 | 해당 없음 |
| **large object** | **0개** | 무위험 (`-b` 플래그 고민 불필요) |
| **제약** | PK 46 / FK 86 / CHECK 58 / NOT NULL 228 (D8 기록) | 무위험 — `pg_restore` 가 위상 순서를 처리 |

→ **덤프/복원 관점에서 이 DB 는 "평범하고 착한" 스키마다.** 서드파티 확장 0, C 함수 0, large object 0, matview 0. 복원 실패의 통상적 원인이 하나도 없다.

---

## 2. 경로 후보 3종 평가

### 2.1 후보 1 — Railway 플랫폼 기능

Railway 공식 문서 3건을 실제로 fetch 해 확인했다 (§Sources).

| 기능 | 별도 사본(clone) 생성 여부 | 근거 |
|---|---|---|
| **Volume Backup 복원** | **아니오 — 같은 서비스에 in-place** | 복원은 스테이징 방식으로 *"백업 날짜 스탬프 이름의 새 볼륨이 원래 mount path 에 마운트되고, 이전 볼륨은 언마운트되되 보존된다"*. 즉 **원본 서비스의 데이터를 갈아끼운다** → **라이브 위험. G6 에 사용 금지** |
| **PITR (Point-in-Time Recovery)** | **예 — 별도 서비스 생성** | *"Railway creates a new Postgres service next to the original, named `<source>-restored-YYYYMMDD-HHMM`"* 이며 *"The source service is untouched and keeps serving traffic the whole time."* → **이것이 Railway 네이티브 clone 경로다** |
| **논리 덤프 (pg_dump)** | 예 (수동) | Railway 가이드 자신이 복원 검증에 *"같은 서버에 scratch database 를 만들어라"* 를 권한다 |

**PITR 경로의 실제 조건 (공식 문서 실측):**

- 활성화: Postgres 서비스의 Backups 탭 → **Enable PITR** 버튼. Railway 가 스토리지 버킷 생성 + archive 자격증명 구성 + **서비스 재배포**.
- 복원 창: 주간 full + 일간 incremental, 최근 4 full 보존 → 약 4주. 단 **"복원 창은 활성화 이후 첫 base backup 부터 시작하며 소급되지 않는다."**
- 비용: *"PITR is billed through two existing meters — there's no separate PITR fee"* — 스토리지(아카이브된 WAL + base backup) + egress(서비스→버킷 전송). **복원 트래픽은 무료.**
- 복원 산출물: 브랜드-뉴 Postgres 서비스 = **가동 중인 컴퓨트 인스턴스** (별도 과금 대상).

**미확인 사항 (추측으로 채우지 않음):**

- **이 프로젝트의 Postgres 서비스에 PITR 이 이미 활성화돼 있는지 확인하지 못했다.** Railway 대시보드 접근·`railway` CLI 가 없다 (`which railway` → not found). `.env.local` 에 Railway API 토큰 키가 없다.
- **구체적 금액 미확인.** 공식 문서가 "기존 두 미터로 과금"이라고만 명시하고 GB 단가를 이 페이지에서 제시하지 않았다. **금액을 지어내지 않는다.**
- 프로젝트가 **Pro 플랜**임은 저장소 문서로 확인된다 (`raw/webadmin/docs/railway-support-ticket-cpu-steal.md:11,20` — 2026-07-03 Hobby→Pro 업그레이드). 플랜 업그레이드는 불필요.

**판정: 가능하되 비용·재배포 부담 있음.** PITR 활성화는 **라이브 Postgres 서비스의 재배포를 유발**하므로(운영 순단 가능) 이 조사 범위에서 시도하지 않았다. **후보 2가 있는 한 우선순위는 낮다.**

### 2.2 후보 2 — 로컬 PostgreSQL 로 `pg_dump` → 복원 [권장]

실측 결과:

| 항목 | 실측값 | 판정 |
|---|---|---|
| `pg_dump` | **있음** — `/opt/homebrew/bin/pg_dump` → `libpq/18.3/bin/pg_dump`, **버전 18.3** | **호환 OK** |
| `psql` | 있음, 18.3 | OK |
| `pg_restore` | 있음 | OK |
| **로컬 Postgres 서버** | **PG 18 서버 미설치.** 설치된 것은 `postgresql@15`, `postgresql@16` 뿐 | **유일한 관문 — 해소 가능** |
| Homebrew `postgresql@18` | **`stable 18.4` (bottled), Not installed** | **라이브와 major·minor 완전 일치. 무료 설치 가능** |
| Docker | 설치됨 (v29.6.1) — **데몬 미가동** (`Cannot connect to the Docker daemon`) | 대체 경로. Docker Desktop 기동 시 `postgres:18.4` 이미지로 즉시 가능 |
| 디스크 여유 | 12 GB | 충분 (필요량 <100 MB) |

**버전 호환 — 핵심 관문의 판정:**

- **클라이언트 방향 (덤프):** `pg_dump` 18.3 ← 서버 18.4. **동일 major(18) → 완전 호환.** PostgreSQL 은 pg_dump 가 자기보다 낮거나 같은 major 를 덤프하는 것을 지원하며, 여기서는 같은 major 의 patch 차이(18.3 vs 18.4)에 불과하다.
- **복원 방향 (관문):** 18.4 덤프를 **PG 16 으로 복원하는 것은 다운그레이드라 지원되지 않는다.** 현재 로컬에 PG 18 서버가 없으므로 **지금 이 순간 그대로는 복원 불가**다.
- **해소:** `brew install postgresql@18` → **18.4 정확 일치**. 비용 0, 네트워크 다운로드만. 또는 Docker 데몬 기동 후 `postgres:18` 이미지.

**이 경로의 결정적 이점:**

1. **라이브에 write 를 전혀 유발하지 않는다** — `pg_dump` 는 순수 SELECT + 스냅샷.
2. **폐기가 자명하다** — 로컬 DB 를 `dropdb` 하면 끝. G6 이 요구하는 "clone 폐기 절차"가 한 줄이다.
3. **비용 0.**
4. **§1.4 의 위험 인자가 전부 0** — 서드파티 확장·C 함수·large object 없음.
5. **반복 가능** — G6 을 여러 번 돌려도 매번 신선한 clone 을 만들 수 있다.

**판정: 이것이 확인된 경로다.**

### 2.3 후보 3 — 같은 Railway 프로젝트에 별도 DB 인스턴스

두 가지 하위 형태가 있다.

**(a) 같은 Postgres 서버 안에 별도 데이터베이스 (`CREATE DATABASE`)**

- **권한상 가능하다** — §1.3 에서 `usecreatedb=t`, `has_database_privilege(...,'CREATE')=t` 실측. Railway 가이드 자신이 복원 검증에 이 방법을 권한다.
- **그러나 G6 에는 비권장.** 이유:
  - **같은 인스턴스의 CPU·메모리·디스크를 라이브와 공유한다.** `railway-support-ticket-cpu-steal.md` 가 기록한 이 서비스의 레이턴시 취약성(피크시간 10~24% 요청 >1s)을 고려하면, 리플레이 부하를 운영 인스턴스에 얹는 것은 **운영 리스크**다.
  - **`CREATE DATABASE` 는 DDL 이며 라이브 서버에 대한 쓰기다.** 본 임무의 HARD 규율("라이브 DB 는 읽기 전용 SELECT 만")과 정면 충돌한다. 데이터베이스 격리가 되더라도 **서버 인스턴스는 같다.**
  - 실수로 `-d railway` 를 지정하면 라이브를 덮어쓴다. **오조작 반경이 크다.**
- **비용:** 추가 스토리지 요금만 (37 MB → 무시할 수준). **구체적 금액 미확인.**

**(b) 프로젝트에 새 Postgres 서비스 추가**

- Railway 대시보드에서 Postgres 템플릿 배포 → 새 인스턴스. **가동 중 컴퓨트가 추가되므로 실질 과금 대상.**
- PITR 복원(§2.1)이 사실상 이것의 자동화 버전이므로, 수동으로 할 이유는 적다.
- **구체적 금액 미확인** — Railway 사용량 기반 과금이며 공식 문서에서 이 조사 범위 내로 확인하지 못했다. **금액을 지어내지 않는다.**

**판정: 가능하나 비용·운영 리스크가 후보 2 보다 크다. 후보 2 실패 시의 대안.**

---

## 3. 동일성 검사 성립 여부

설계가 요구하는 검사는 **테이블별 `count` + `max(upd_dt)` 대조**다 (`gate-report.md:175`).

### 3.1 `upd_dt` 실재 여부 — 전수 실측

46개 `t_*` 도메인 테이블 전부에 대해 `information_schema.columns` 로 조회했다.

```
결과: 46 / 46 테이블이 reg_dt, upd_dt 를 모두 보유. 누락 0.
```

전수 목록(46): `t_ast_chat_logs`, `t_ast_issue_reports`, `t_cat_categories`, `t_clr_color_counts`, `t_cod_base_codes`, `t_cus_customers`, `t_dsc_discount_details`, `t_dsc_discount_tables`, `t_dsc_grade_discount_rates`, `t_mat_materials`, `t_prc_component_prices`, `t_prc_formula_components`, `t_prc_price_components`, `t_prc_price_formulas`, `t_prd_edicus_configs`, `t_prd_edicus_templates`, `t_prd_product_addons`, `t_prd_product_bundle_qtys`, `t_prd_product_categories`, `t_prd_product_constraints`, `t_prd_product_discount_tables`, `t_prd_product_materials`, `t_prd_product_option_groups`, `t_prd_product_option_items`, `t_prd_product_options`, `t_prd_product_page_rules`, `t_prd_product_plate_sizes`, `t_prd_product_price_formulas`, `t_prd_product_prices`, `t_prd_product_print_options`, `t_prd_product_processes`, `t_prd_product_sets`, `t_prd_product_sizes`, `t_prd_products`, `t_prd_template_prices`, `t_prd_template_selections`, `t_prd_templates`, `t_prd_tmpl_combo_configs`, `t_proc_processes`, `t_prt_print_options`, `t_siz_sizes`, `t_wgt_handoff_logs`, `t_wgt_sites`, `t_wgt_widget_items`, `t_wgt_widget_versions`, `t_wgt_widgets`

→ **`upd_dt` 결손 테이블은 하나도 없다.** 이 검사로 커버 불가한 도메인 테이블은 **0개**다. 설계가 요구한 검사는 **46개 도메인 테이블 전부에 대해 성립한다.**

### 3.2 어느 테이블 집합에 대해 성립하는가

| 집합 | 테이블 수 | `upd_dt` 보유 | 검사 적용 권고 |
|---|---:|---|---|
| **도메인 `t_*`** | 46 | **46/46** | **적용 — 이것이 G6 분모** |
| `bak_*` / `z_bak_*` 백업 잔해 | 97 | 미조사 | **제외 권고** — 운영 데이터가 아니며, 포함 시 검사 비용만 늘고 신호는 없다 |
| Django 시스템 (`auth_*`, `django_*`) | 10 | 해당 없음 (`upd_dt` 미보유 스키마) | **제외 권고** — `count` 대조만으로 충분. `upd_dt` 부재는 결손이 아니라 **스키마 성격 차이**다 |
| 뷰 2개 | — | 해당 없음 | 제외 (파생물) |

→ **제안: 동일성 검사 분모는 `t_*` 46개.** 나머지 제외는 근거 있는 제외다(위 사유). `gate-report.md:177` 이 요구하는 "근거 없는 제외 금지" 규율에 부합한다.

### 3.3 [주의] `fn_upd_dt` 트리거가 만드는 시점 규율

§1.4 에서 실측: **45개 테이블에 `fn_upd_dt` 트리거가 걸려 있어 UPDATE 시 `upd_dt` 를 자동 갱신한다.**

따라서 `max(upd_dt)` 대조는 **시점을 명시해야 유효하다**:

- **유효:** clone 생성 **직후**, 리플레이 **이전**에 라이브 vs clone 을 대조 → clone 이 라이브의 충실한 사본인지 확인.
- **무효:** 리플레이 **이후** 대조 → 리플레이가 clone 의 `upd_dt` 를 정당하게 바꿨으므로 불일치가 나오는 게 정상. 이때의 불일치를 "clone 결함"으로 읽으면 오판이다.
- **또한:** 라이브는 계속 실사용 중이므로(§1.1), 덤프 시각과 대조 시각 사이에 라이브가 변할 수 있다. → **대조는 "덤프 시각 기준 라이브 스냅샷" 대비**여야 하며, 단순 재조회 대비가 아니다. 실무적으로는 `pg_dump` 후 **곧바로** 대조하고, 불일치 시 해당 테이블의 갱신 시각이 덤프 시각 이후인지 확인하는 2단 판정이 안전하다.

**→ G6 명세에 이 시점 규율을 명문화할 것을 권고한다.** 이것이 §5 의 후속 항목이다.

### 3.4 검사 자체가 라이브에 부작용을 주는가

**주지 않는다.** 검사는 `SELECT count(*)`, `SELECT max(upd_dt)` 두 종류의 순수 읽기 질의다. 트리거는 UPDATE/INSERT/DELETE 에만 걸려 있고(비내부 트리거 46개 전부), SELECT 는 어떤 트리거도 발화시키지 않는다. `SET default_transaction_read_only=on` 을 선행하면 실수로 섞인 쓰기도 서버가 거부한다.

**단, 자원 관점의 미미한 주의:** `t_prc_component_prices` 23,573행 등 전 테이블 `count(*)` 는 순차 스캔이다. 총 37 MB 규모라 무시할 수준이지만, 이 인스턴스의 레이턴시 취약성(§2.3)을 고려하면 피크시간을 피하는 편이 낫다.

---

## 4. 판정

# **FEASIBLE**

### 4.1 확인된 경로

**후보 2 — 로컬 `pg_dump` → 로컬 PostgreSQL 18.4 복원.**

이 경로의 모든 차단 요인을 실측으로 해소했다:

| 잠재 차단 요인 | 실측 결과 | 상태 |
|---|---|---|
| 접속 계정이 덤프에 필요한 읽기 권한을 갖는가 | 슈퍼유저 + 읽기 불가 테이블 0개 | **해소** |
| DB 규모가 로컬 복원에 현실적인가 | 37 MB (디스크 여유 12 GB) | **해소** |
| 서드파티 확장이 복원을 막는가 | 확장 = `plpgsql` 하나뿐 | **해소** |
| 함수·트리거가 복원을 막는가 | 5 함수 전부 plpgsql, 46 트리거 전부 DDL 복원 가능 | **해소** |
| large object / matview 처리 | 각 0개 | **해소** |
| `pg_dump` 클라이언트가 있는가 | 18.3, 서버 18.4 와 동일 major | **해소** |
| 복원 대상 서버 버전이 호환되는가 | 로컬 PG18 미설치 (@15/@16 만) — **단 `brew install postgresql@18` = 18.4 정확 일치, 무료** | **선행 조건** (§4.2) |
| 동일성 검사가 성립하는가 | 46/46 테이블에 `upd_dt` 실재, 결손 0 | **해소** |
| 검사가 라이브에 부작용을 주는가 | 순수 SELECT, 트리거 무발화 | **해소** |

**보조 경로 (후보 2 실패 시):** Railway PITR — 원본 서비스를 건드리지 않고 `<source>-restored-…` 별도 서비스를 만든다. 다만 활성화가 라이브 서비스 **재배포**를 유발하고 스토리지·egress 과금이 붙으므로 차선이다.

### 4.2 필요한 선행 조건 (전부 해소 가능, 비용 0)

1. **`brew install postgresql@18`** — 18.4 정확 일치. (대안: Docker Desktop 기동 + `postgres:18` 이미지)
2. **webadmin 앱 로컬 실행 환경.** `raw/webadmin/.venv` 는 존재하지만 **Django·psycopg·dj-database-url 이 설치돼 있지 않다**(실측: import 실패). G6 리플레이는 앱이 clone 을 바라봐야 하므로 `pip install -r requirements.txt` 가 필요하다.
3. **`DATABASE_URL` 의 `sslmode` 처리.** `settings.py:287` 이 `dj_database_url.parse(_db_url, ssl_require=True)` 로 **SSL 을 강제**한다. 로컬 Postgres 는 기본적으로 SSL 미구성이므로, clone 을 가리킬 때 이 분기를 우회할 수단이 필요하다(환경변수로 SSL 미강제 분기 추가, 또는 로컬에 SSL 구성). **`raw/webadmin/**` 무수정 규율이 있으므로 코드 수정이 아닌 설정·래퍼 경로로 풀어야 한다.**

→ **1·2 는 순수 설치 작업이고, 3 만이 설계 판단이 필요한 항목이다.** 셋 다 G6 을 차단하지 않는다.

### 4.3 왜 FEASIBLE_WITH_COST 가 아닌가

비용이 드는 경로(PITR·별도 인스턴스)가 **유일한 경로가 아니기 때문이다.** 무료·로컬·반복가능·라이브 무영향 경로가 실측으로 확인됐고, 그 유일한 관문(로컬 PG18 부재)이 `brew install` 한 줄로 해소되며 그 설치본이 라이브와 **major·minor 정확 일치(18.4)** 한다.

### 4.4 이 판정이 뜻하지 않는 것

- **G6 이 통과한다는 뜻이 아니다.** clone 이 만들어질 수 있다는 뜻이며, 리플레이 결과가 설계 주장 4 를 지지할지는 별개의 측정이다.
- **clone 을 실제로 만들어봤다는 뜻이 아니다.** 본 조사는 규율에 따라 생성을 시도하지 않았다. 판정은 **차단 요인의 부재를 전수 실측으로 확인한 것**이지, 성공한 실행의 관측이 아니다.

---

## 5. 다음에 할 일

우선순위 순.

1. **[선행·사용자 승인 필요] clone 실제 생성 1회 리허설.** `brew install postgresql@18` → `pg_dump` (라이브, 읽기 전용) → 로컬 `createdb` + `pg_restore` → §3 동일성 검사 46테이블 실행 → `dropdb`. **이 리허설이 §4.4 의 "실행 관측 부재"를 닫는다.**
2. **G6 명세에 §3.3 의 시점 규율을 명문화.** 동일성 검사는 *"clone 생성 직후 · 리플레이 이전 · 덤프 시각 기준 라이브 스냅샷 대비"* 에서만 유효하다는 문장을 `gate-report.md:175` 의 clone 절에 추가.
3. **G6 명세에 §3.2 의 분모를 명문화.** 검사 분모 = `t_*` 46개. `bak_*` 97개·Django 10개 제외와 그 근거를 한 쌍으로 기록 (`gate-report.md:177` 의 "근거 없는 제외 금지" 규율 준수).
4. **선행 조건 3(`ssl_require=True` 우회)의 설계 결정.** `raw/webadmin/**` 무수정 규율 하에서 어떤 수단을 쓸지 확정. (후보: 로컬 Postgres 에 self-signed SSL 구성 → 코드 무수정으로 해결. 이 경로가 규율과 가장 잘 맞는다.)
5. **[선택] `t_wgt_handoff_logs` 0행 기준선 활용.** D8 실측상 이 테이블은 **0행**이다. 즉 clone 리플레이 후 이 테이블의 행 수가 곧 "리플레이가 유발한 행 수"가 되어, `gate-report.md:177` 이 요구한 **G1.1 서브게이트**(리플레이 유발 행 수 == 예상 조합 수 · 종료 시 undo 후 0행 복귀)의 계측이 자명해진다. 0행 기준선은 이 서브게이트에 유리한 조건이다.
6. **[불필요 판정] Railway PITR 활성화는 지금 하지 않는다.** 후보 2 가 열려 있는 한 라이브 재배포 리스크와 과금을 감수할 이유가 없다. 후보 2 리허설이 실패했을 때만 재고.

---

## 6. 이 조사가 하지 못한 것

1. **clone 을 실제로 만들지 않았다.** 안전 규율에 따라 가능성 조사까지만 수행했다. 따라서 이 판정은 **차단 요인 부재의 전수 실측**이며, **성공한 clone 생성의 관측이 아니다.** `pg_dump` 를 단 한 번도 실행하지 않았다 — 실제 덤프에서만 드러나는 문제(권한 엣지케이스, 특정 객체의 덤프 실패)는 미확인이다.

2. **이 프로젝트의 Railway PITR 활성화 여부를 확인하지 못했다.** `railway` CLI 미설치, `.env.local` 에 Railway API 토큰 키 부재, 대시보드 미접근. §2.1 의 PITR 서술은 **공식 문서 기준 일반론**이며 이 서비스의 현재 상태가 아니다.

3. **Railway 과금 금액을 확인하지 못했다.** 공식 문서가 "기존 두 미터(스토리지·egress)로 과금, 별도 PITR 요금 없음"이라고만 명시했고 GB 단가를 이 조사 범위에서 확인하지 못했다. **금액을 추정해 기재하지 않았다.**

4. **`bak_*` / `z_bak_*` 97개 테이블의 `upd_dt` 보유 여부를 조사하지 않았다.** §3.2 에서 이들을 분모 제외로 권고했으므로 조사하지 않았다. 만약 향후 이들을 분모에 포함하기로 한다면 별도 실측이 필요하다.

5. **로컬 복원 후 함수·트리거의 **동작** 동등성을 확인하지 않았다.** DDL 이 복원된다는 것은 구조적 사실이고, `fn_calc_pansu`·`fn_best_plate` 가 clone 에서 라이브와 **같은 값을 반환하는지**는 리허설(§5-1)에서 별도 확인이 필요하다. 특히 `fn_best_plate` 계열은 판형 계산이라 도메인 결과가 달라지면 G6 리플레이 결과 전체가 오염된다.

6. **webadmin 앱을 clone 에 붙여 실제로 기동해보지 않았다.** §4.2 의 선행 조건 2·3 은 코드 정적 확인(`settings.py:285-291`, venv import 실패)에 근거하며, 실제 기동 시 드러날 추가 의존성(예: Redis 미설정 시 LocMem 폴백은 `settings.py:318-328` 로 확인했으므로 무해)은 완전히 검증되지 않았다.

7. **`_gate` 부작용의 대체 우회 가능성을 검증하지 않았다.** 코드 정적 확인에서 흥미로운 관찰이 하나 있다 — `widget_api.py:129-136` 의 `_touch_used` 는 `try: … except Exception: pass` 로 감싸여 있고, `settings.py` 에 `ATOMIC_REQUESTS` 설정이 없다(전 저장소 grep 결과 `.planning/review-260805/FIX-SERVER-SUMMARY.md:79` 의 "미래 대비" 언급뿐). 이는 **읽기 전용 세션에서 리플레이하면 `t_wgt_widgets` UPDATE 가 예외로 떨어지고 조용히 삼켜져 게이트가 그대로 진행될 수 있다**는 가설을 시사한다. 그러나 **이는 코드 독해에서 도출한 가설이며 측정하지 않았다** — Django autocommit 하에서 실패한 문장이 후속 질의를 오염시키지 않는지, `cache.incr` 부작용(LocMem 이면 프로세스 로컬이라 라이브 상태가 아님)이 정말 무해한지는 미확인이다. **clone 경로가 FEASIBLE 로 판정됐으므로 이 우회 경로를 추적할 필요가 없어졌고, 따라서 검증하지 않았다.** 향후 clone 경로가 무너질 경우의 대안 후보로만 기록한다.

8. **`/validate` 부작용 사슬을 재검증하지 않았다.** `coverage-supplement.md` 의 정적 추적 결과를 전제로 받았다. 본 조사는 그 전제 위에서 clone 경로만 다뤘다.

---

## Sources:

WebFetch 로 실제 접속해 내용을 확인한 URL 만 기재한다.

- [Back Up and Restore Postgres — Railway Docs](https://docs.railway.com/guides/postgres-backups-restores) — PITR 이 별도 서비스를 생성하고 원본은 무손상이라는 서술, volume backup 은 in-place 라는 대비, pg_dump scratch database 권고
- [Volume Backups — Railway Docs](https://docs.railway.com/volumes/backups) — 복원이 원래 mount path 에 새 볼륨을 마운트하고 이전 볼륨을 언마운트하는 스테이징 방식이라는 서술, 증분 크기 기준 GB 과금
- [Point-in-Time Recovery — Railway Docs](https://docs.railway.com/volumes/point-in-time-recovery) — Enable PITR 절차, 약 4주 복원 창, "활성화 이후 첫 base backup 부터 시작하며 소급되지 않음", `<source>-restored-YYYYMMDD-HHMM` 명명, "별도 PITR 요금 없음 · 스토리지+egress 두 미터로 과금 · 복원 트래픽 무료"

저장소 내부 근거는 본문에 `파일경로:라인` 으로 인용했다.
