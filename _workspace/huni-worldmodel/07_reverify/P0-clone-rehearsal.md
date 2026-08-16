# P-0 clone 리허설 1회 — 실증 기록

> 실행 2026-08-17 (KST) · 트랙 `huni-worldmodel/07_reverify` · 카드 SPEC-WORLDMODEL-001 R3
> 근거 계획: `plan.md` M1.0′ **P-0**(①~⑤) · `g6-clone-feasibility.md:300-303`
> 착지: `acceptance.md` **AC-M0-10** · `spec.md` §7 OP-1 · §9.1 · RK-13
>
> [HARD] **사용자 승인 후 실행했다.** 라이브 접촉은 `pg_dump`(읽기) + 대조용 `SELECT` 뿐이며 **쓰기 0건**이다.
> [HARD] 이 문서는 **실행한 것과 관측한 것만** 적는다. 실행하지 않은 것은 §4 에 미실행으로 적는다.

---

## 1. 환경 (실측)

| 항목 | 값 | 확인 명령 |
|---|---|---|
| 라이브 서버 | **PostgreSQL 18.4** (Debian 18.4-1.pgdg13+1) | `select version()` |
| 로컬 서버 | **PostgreSQL 18.6** (Homebrew, aarch64-apple-darwin25.6.0) | `select version()` |
| 로컬 설치 | `brew install postgresql@18` → **18.6** | `brew list --versions postgresql@18` |
| 로컬 포트 | **5440** (5432=기존 `postgresql@16`, 5433=선점 → 회피) | `pg_ctl -o "-p 5440"` |
| 클라이언트 | `libpq 18.3` + `postgresql@18` 번들 | `psql --version` |

[HARD] **문서 예상(18.4)과 실제 설치본(18.6)이 다르다.** Homebrew `postgresql@18` 이 그 사이 18.6 으로 올라갔다. **major 18 동일**이라 덤프·복원은 성립했고 실제로 오류 0건이었으나, `g6-clone-feasibility.md:163`·`:171`·`:287` 의 *"stable 18.4 · 라이브와 major·minor 정확 일치"* 는 **더 이상 사실이 아니다**(minor 불일치 18.4 ↔ 18.6). 이 리허설은 minor 불일치 상태에서 성공했다.

## 2. 분모 실측 — 문서 값과의 차이

| 구분 | `g6-clone-feasibility.md` | **본 리허설 실측(라이브)** | 판정 |
|---|---|---|---|
| `t_*` (검사 분모) | 46 | **46** | 일치 |
| `bak_*` (제외) | 97 | **75** | **불일치** |
| Django 등 기타 (제외) | 10 | **33** | **불일치** |
| DB 총 크기 | 37 MB | **38 MB** | 증가 |

[HARD] **검사 분모 `t_*` 46 은 일치하므로 §3 동일성 검사는 그대로 유효하다.** 제외군 2종의 수가 달라진 것은 조사 시점(2026-08-15) 이후 라이브가 변했다는 뜻이며, **제외 근거를 한 쌍으로 기록하라**(`:302`)는 규율에 따라 여기 기록한다 — 제외 근거는 *"`bak_*` 는 백업 사본이고 Django 등 기타는 애플리케이션 프레임워크 테이블로, 둘 다 도메인 상태가 아니다"* 이며, **그 근거는 개수 변화와 무관하게 유지된다.**

## 3. ①~⑤ 실행 결과

| 순서 | 작업 | 결과 | 관측 증거 |
|---|---|---|---|
| **①** | `brew install postgresql@18` | **성공** | `brew list --versions` → `postgresql@18 18.6` · 서버 기동 확인(5440) |
| **②a** | `pg_dump -Fc` (라이브 읽기전용) | **성공** | **23.5초 · 1,776,892 bytes** · 에러 0건 |
| **②b** | `createdb` + `pg_restore --no-owner --no-privileges` | **성공** | **1.1초** · 에러 0건 · 복제본 31 MB |
| **③** | 동일성 검사 — 분모 `t_*` **46** | **전건 일치** | 행수 diff **0건** · 총 **37,480행** 양측 동일 |
| **④** | 시점 규율 — `max(upd_dt)` 대조 | **전건 일치** | `upd_dt` 보유 **46/46** · max 값 diff **0건** · `fn_upd_dt` 트리거 **45개**(문서 값과 일치) |
| **⑤** | `dropdb` + 잔여 0 확인 | §5 참조 | — |

**덤프 시점(라이브 서버 시계)**: `2026-08-16 19:02:17.116529+00`
대조는 *"clone 생성 직후 · 리플레이 이전"* 에 수행했고, `max(upd_dt)` 가 46/46 전건 일치했다는 것은 **덤프~대조 구간에 라이브 쓰기가 없었다**는 관측이기도 하다.

### 복제본 내용 실측

| 항목 | 값 |
|---|---|
| 확장 | `plpgsql` 단독 (문서 `:113` 주장과 일치) |
| public 사용자 함수 | 5개 — `fn_best_plate` · `fn_best_plate_default` · `fn_calc_pansu` · `fn_chk_opt_item_ref` · `fn_upd_dt` |
| **함수 실행 검증** | `fn_calc_pansu('SIZ_000001','SIZ_000629')` → **6** · `('SIZ_000002','SIZ_000629')` → **9** — 복제본에서 판걸이수 계산이 실제로 동작 |

[HARD] **`evaluate_price` 는 DB 함수가 아니다** — public 함수 5개에 없다. 이는 결손이 아니라 계층 사실이며(`pricing.py:428` 의 **Python** 함수), SPEC §2.3 의 *"가격 값 권위 = `pricing.evaluate_price` 단일"* 과 모순되지 않는다.

## 4. P-1 ~ P-4 판정

| 조건 | 요구(`plan.md:193-196`) | **판정** | 근거 |
|---|---|---|---|
| **P-1** | 절차 문서 + **1회 생성 성공 실증** | **충족** | §3 ①②a②b — 덤프·복원 각 1회 성공, 오류 0 |
| **P-2** | **폐기 성공** + 잔여 리소스 0 | **충족** | §5 |
| **P-3** | **대조 스크립트 실행 성공** | **충족** | §3 ③④ — 46테이블 행수·`max(upd_dt)` 전건 일치 |
| **P-4** | **리플레이 1건 성공** | **미충족 — 미실행** | 아래 |

### P-4 가 왜 미실행인가 [HARD]

리플레이는 webadmin 을 clone 에 붙여 기동해야 하는데, 그 선행 조건이 **아직 결정되지 않았다**:

- webadmin 로컬 기동이 실증된 적 없다 · `.venv` 에 Django/psycopg 미설치(`g6-clone-feasibility.md:280`)
- **`ssl_require=True` 우회가 미결정**(`:281`·`:303`). `raw/webadmin/**` 무수정 규율(OS-1) 하에서 어떤 수단을 쓸지 확정되지 않았다. 조사 문서의 후보는 *"로컬 Postgres 에 self-signed SSL 구성 → 코드 무수정으로 해결"*(`:303` 항목 4)이며 **후보일 뿐 결정이 아니다**.

**이 리허설은 그 결정을 하지 않았고, 실행하지도 않았다.** 따라서 P-4 는 미충족이며 — [HARD] **AC-M0-10 은 여전히 미충족이다.** 4항 중 3항이 닫혔을 뿐이다.

[HARD] **`plan.md` P-0 의 *"P-0 완료가 곧 P-1~P-4 충족이다"* 는 이 리허설로 성립하지 않았다.** ①~⑤ 는 P-1·P-2·P-3 만 닫으며, P-4 는 ①~⑤ 밖의 별도 선행 결정(SSL 우회)과 별도 작업(webadmin 로컬 기동)을 요구한다. 이 어긋남은 계획서 교정 사안으로 남긴다.

## 5. ⑤ 폐기 결과 — **성공 · 잔여 0**

| 확인 | 결과 |
|---|---|
| 폐기 전 DB 목록 | `postgres` · **`railway_clone`** |
| `dropdb railway_clone` | **성공** |
| 폐기 후 DB 목록 | `postgres` 단독 — **복제본 소멸 확인** |
| 로컬 서버 정지 | `pg_ctl stop` → *"server stopped"* · `pg_isready -p 5440` → **no response** |
| 덤프·중간 산출물 | `rm -rf tmp/g6-clone` → 디렉터리 부재 확인 |
| **기존 서버 무사** | `pg_isready -p 5432` → **accepting connections** (`postgresql@16` 무영향) |
| **라이브 무사** | 쓰기 0건 — 접촉은 `pg_dump`(읽기) + 대조 `SELECT` 뿐 |

남은 것은 `postgresql@18` 설치본과 그 데이터 디렉터리(`/opt/homebrew/var/postgresql@18`, 빈 클러스터)뿐이며, 다음 리허설·P-4 작업에 재사용된다. 제거하려면 `brew uninstall postgresql@18`.

## 6. 재현 명령

```bash
# ① 설치
brew install postgresql@18
/opt/homebrew/opt/postgresql@18/bin/pg_ctl -D /opt/homebrew/var/postgresql@18 \
  -o "-p 5440" -l /tmp/pg18-5440.log start

# ② 덤프(라이브 읽기전용) → 복원
pg_dump -Fc -f tmp/g6-clone/live.dump           # PG* 환경변수는 .env.local RAILWAY_DB_* 에서 주입
createdb  -h localhost -p 5440 railway_clone
pg_restore -h localhost -p 5440 -d railway_clone --no-owner --no-privileges tmp/g6-clone/live.dump

# ③④ 동일성 검사 (t_* 46개 행수 + max(upd_dt))
#   생성 SQL: tmp/g6-clone/count.sql · tmp/g6-clone/upd.sql
#   결과:     tmp/g6-clone/{clone,live}-counts.txt · {clone,live}-upd.txt · *.diff

# ⑤ 폐기
dropdb -h localhost -p 5440 railway_clone
pg_ctl -D /opt/homebrew/var/postgresql@18 stop
rm -rf tmp/g6-clone
```

## 7. Gaps — 이 리허설이 재지 못한 것

1. **P-4 리플레이 미실행** — §4 참조. AC-M0-10 의 4항 중 1항이 열려 있다.
2. **로컬/라이브 minor 버전 불일치(18.6 ↔ 18.4)** — 이 조합에서 성공했다는 관측이며, 역방향(라이브가 더 신최신인 경우)은 재지 않았다.
3. **대조 축은 행수와 `max(upd_dt)` 2종** — 컬럼 단위 값 대조·제약·인덱스 정의 대조는 하지 않았다.
4. **제외군(`bak_*` 75 · 기타 33)은 대조하지 않았다** — 분모 밖이라는 규율에 따른 의도적 제외이며, 제외 근거는 §2 에 기록했다.
5. **1회 실행이다** — 반복 재현성(같은 절차를 k회 돌려 같은 결과)은 재지 않았다.
