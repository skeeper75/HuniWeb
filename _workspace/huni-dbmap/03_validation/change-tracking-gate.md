# 변경추적 게이트 V1~V8 — 상품마스터 260527 → 260610 (round-10)

검증 주체: `dbm-validator` (독립 적대 게이트). 생성(change-tracker)과 게이트(validator) 분리 = V8 독립성.
권위: `dbm-change-tracking` 스킬 V1~V8 정의. 라이브 DB는 **읽기전용**(SELECT/information_schema)만 사용, COMMIT·쓰기 0건.
검증 대상 번들: `_workspace/huni-dbmap/14_change-tracking/260527-to-260610/`.

---

## 0. 최종 평결: **GO** — V1~V8 전건 PASS (8/8)

| Gate | 판정 | 한줄 근거 |
|------|------|-----------|
| V1 키매칭·키무결성 | ✅ PASS | 키=정규화 ID(col B), 위치비교 아님. dup_key 정직 처리(스티커 22852 변경0·계산공식집초안 5건=공식라벨 N/A). rename 0 |
| V2 분류 완전성 | ✅ PASS | diff 독립 재실행 → `_diff-raw.json` **byte-identical**. 정규화 적대검증: 무정규화로 뜬 350셀 전부 int→float 노이즈, 의미변경 0 |
| V3 REMOVED 비파괴 | ✅ PASS | `_delta/00_apply.sql` 활성 write문 0건(BEGIN/ROLLBACK만). DELETE/DROP/TRUNCATE 0 |
| V4 영향매핑 정확성 | ✅ PASS | 라이브 read-only 실측으로 impact 전건 확인(레더라벨 3행·합판도무송 옵션그룹0·미니파츠 1행·클립보드 2행) |
| V5 멱등성 | ✅ PASS | 매니페스트 INSERT/UPDATE 0행·`_delta` 활성 적용문 0 → 자명한 멱등(2-pass delta 0) |
| V6 변경로그(upd_dt) | ✅ PASS | UPSERT 0건 → upd_dt 갱신 대상 0. 누락 UPDATE 없음(V8 입증) |
| V7 추적성 | ✅ PASS | 매니페스트 **527행** = diff 변경 527 **1:1**(누락0). ESCALATE 526·GAP 1. 전 행 cell_ref·key 보유 |
| V8 라이브 수렴(독립) | ✅ PASS | option_items 전역 **18건 전부 PRD_000138(silsa)** 실측. "거의 미적재" 사실 |

라이브 DB는 1회 시도로 도달 — "(라이브 미검증)" 플래그 불요.
적재 종착점 = 검증된 델타 + 롤백전용 DRY-RUN까지. 실 COMMIT·CPQ L2 적재·논리삭제는 **인간 승인 대기**.

---

## 1. 게이트별 상세 + 재측정 증거

### V1 키매칭·키무결성 — ✅ PASS

- 키 = 정규화 ID(엑셀 col B surrogate, 없으면 col D 상품명). `diff_versions.py`는 ID 비공백 행을 블록 앵커로 삼고, 같은 블록 내 ID 공백 후속행을 variant로 처리 — 위치 기반 비교 아님(V1 충족).
- **dup_key 정직 처리 재측정**:
  - 스티커 dup_key `22852` 1건 → 해당 키의 modified cell **0건** 확인(델타 무영향). 침묵 first-won 아니라 경고 표기만.
  - 계산공식집초안 dup_keys 5건 = 공식 텍스트 라벨(예 `(1) 내지인쇄비 = [총내지매수행][도수열] x 총내지매수`) — 상품 엔티티 아님, 시트 modified 0 → 키 무결성 N/A 정당.
- rename 의심쌍 전 시트 0. ADDED 0 / REMOVED 0 → rename(ADDED+REMOVED 쌍) 발생 불가.

### V2 분류 완전성 — ✅ PASS

- **독립 재실행**: `python3 scripts/diff_versions.py --outdir /tmp/v8gate` 실행 → 산출 `diff/_diff-raw.json`이 커밋본과 `diff -q` 결과 **IDENTICAL(byte-identical)**.
- **재측정 셀 카운트** (커밋본·재실행본 동일):

  | 시트 | ADDED | REMOVED | MODIFIED | block_resized | dup |
  |------|-------|---------|----------|---------------|-----|
  | 계산공식집초안 | 0 | 0 | 0 | 0 | 5(N/A) |
  | MAP | 0 | 0 | 0 | 0 | 0 |
  | 디지털인쇄 | 0 | 0 | 0 | 0 | 0 |
  | 스티커 | 0 | 0 | **37** | 0 | 1 |
  | 책자 | 0 | 0 | 0 | 0 | 0 |
  | 포토북 | 0 | 0 | 0 | 0 | 0 |
  | 캘린더 | 0 | 0 | 0 | 0 | 0 |
  | 디자인캘린더 | 0 | 0 | 0 | 0 | 0 |
  | 실사 | 0 | 0 | **1** | 0 | 0 |
  | 아크릴 | 0 | 0 | **41** | 1 | 0 |
  | 문구 | 0 | 0 | 0 | 0 | 0 |
  | 굿즈파우치 | 0 | 0 | **448** | 0 | 0 |
  | 상품악세사리 | 0 | 0 | 0 | 0 | 0 |
  | **합계** | **0** | **0** | **527** | **1** | — |

- **정규화 적대검증(노이즈가 진짜 변경을 숨기는지)**: 정수/부동소수 정규화를 끄고(raw string 비교) 재diff한 결과 포토북 82셀·상품악세사리 268셀이 "변경"으로 떴으나, 셀단위 추적 결과 **전부 int→float 타입 드리프트**였다:
  - 포토북: `2`→`2.0`, `24`→`24.0`, `150`→`150.0`, `1000`→`1000.0` 등 (260527 int → 260610 float)
  - 상품악세사리: OPP비접착봉투 `1`→`1.0`, `100`→`100.0`, `600`→`600.0` 등
  - 의미 변경(REAL-DIFF) **0건**. 정규화는 정당하며 진짜 변경을 숨기지 않음 → 헤드라인 주장 #4(ID 타입 드리프트·부동소수 노이즈 차단) 입증.

### V3 REMOVED 비파괴 — ✅ PASS

- `_delta/00_apply.sql` 활성(비주석·비공백) 라인 = `\set ON_ERROR_STOP on` / `BEGIN;` / `ROLLBACK;` **3줄뿐**.
- 활성 DELETE/DROP/TRUNCATE/UPDATE/INSERT **0건**. 모든 escalate 항목은 주석 처리(설계 명세이지 실행문 아님).
- REMOVED 상품 0 → 논리삭제 제안 대상 0. 아크릴미니파츠 변형행 감축도 라이브 1행 정합상 hard-delete 없이 escalate(사람 판단)로 처리.

### V4 영향매핑 정확성 — ✅ PASS (라이브 read-only 실측)

라이브 DB(`db railway`, 읽기전용 SELECT)로 impact 주장 직접 대조:

| 검증 항목 | 주장 | 라이브 재측정 | 일치 |
|-----------|------|----------------|------|
| 레더라벨제작 PRD_000280 size 행 | 3행(레더15x30/20x40/30x50) | `t_prd_product_sizes` 3행: **SIZ_000492=레더15x30 · SIZ_000494=레더20x40 · SIZ_000496=레더30x50** | ✅ |
| 전역 option_groups | 5 | **5** | ✅ |
| 전역 options | 16 | **16** | ✅ |
| 전역 option_items | 18 | **18** | ✅ |
| option_items 소유 상품 | silsa(PRD_000138)만 | `GROUP BY prd_cd` → **PRD_000138=18 (유일)** | ✅ |
| 합판도무송스티커 PRD_000066 size | 37행, 커팅=size 적재 | size **37행** | ✅ |
| 합판도무송스티커 옵션그룹 | 0(커팅 옵션그룹 없음) | option_groups **0** | ✅ |
| 아크릴미니파츠 PRD_000163 size | 1행 | size **1행** | ✅ |
| 클립보드 PRD_000215 size | 2행 | size **2행** | ✅ |

→ 굿즈파우치 size→option 주장 검증 핵심: **레더라벨제작 PRD_000280이 실제로 t_prd_product_sizes에 size 3행(레더15x30/20x40/30x50)으로 적재돼 있음**을 라이브에서 확인. 따라서 신규 권위가 이 값을 옵션으로 재분류하는 변경은 "이미 적재된 차원행을 CPQ 옵션레이어로 재구성"하는 것이지 단순 스칼라 갱신이 아님 → ESCALATE 분류 정당.

### V5 멱등성 — ✅ PASS

- 매니페스트 apply_class INSERT/UPDATE **0행**. `_delta/00_apply.sql` 활성 INSERT/UPDATE **0줄**.
- 적용문 부재 → DRY-RUN 1·2회차 모두 delta 0 = **자명한 멱등**.

### V6 변경로그(upd_dt) — ✅ PASS

- 자동 UPSERT 0건이므로 `upd_dt = now()` 갱신 대상도 0. 일관됨(누락된 UPDATE 아님 — V8에서 in-place 스칼라 변경 전수 점검으로 입증).
- 전용 변경이력 테이블 부재 → 매니페스트(`change-manifest.csv`)가 감사 권위. DB 이력 테이블은 GAP(선택 DDL 제안).

### V7 추적성 — ✅ PASS

- `change-manifest.csv` 데이터 행 = **527행**, diff 변경 527과 **1:1**(누락 0).
- apply_class 집계: **ESCALATE 526 · GAP 1** (주장과 정확히 일치). change_type 전건 MODIFIED 527.
- 전 행 cell_ref provenance 보유(missing 0)·key 보유(missing 0).

### V8 라이브 수렴(독립) — ✅ PASS

- 라이브 옵션레이어 실측: groups 5 / options 16 / option_items 18이며 **items 18건 전부 PRD_000138(silsa)** 소유. "전역 거의 미적재"는 사실 → size→option 재분류가 escalate(L2 설계 선행)인 판단이 라이브 현실과 정합.
- 적재된 size 행이 라이브에 실재(레더라벨 3행 등)하므로, 기계적 size 삭제는 적재된 size/price 사슬을 파손 → 보류·escalate가 옳음.

---

## 2. "0 auto-UPSERT / escalate-everything" 독립 판단 — **정직한 평결(dodge 아님)**

**점검 방법**: 527 MODIFIED 셀을 전수 도지헌트. "진짜 in-place 스칼라 변경"(before≠'' AND after≠'' = 기존 값이 다른 값으로 바뀜 = 깔끔한 UPDATE 후보)을 골라내, 그것이 ESCALATE로 부당하게 뭉뚱그려졌는지 확인.

**재측정 결과 (변경 형태별 분해)**:

| 형태 | 컬럼 | 건수 | 성격 |
|------|------|------|------|
| EMPTY→VALUE (획득) | 굿즈파우치 상품(옵션) | 224 | 옵션 컬럼으로 값 이동(쌍이동의 후반부) |
| VALUE→EMPTY (클리어) | 굿즈파우치 사이즈(필수) | 224 | size 컬럼 비움(쌍이동의 전반부) |
| VALUE→EMPTY | 스티커 커팅(옵션) | 37 | 커팅 텍스트 제거 |
| VALUE→EMPTY | 아크릴 사이즈/상품명/가격/가공 등 | 41 | block_resized(LOW) tail-shift |
| **VALUE→VALUE (진짜 in-place 스칼라)** | **실사 MES ITEM_CD** | **1** | **범례/주석 텍스트가 길어짐** |

- 굿즈파우치 224 size-clear = 224 option-gain (쌍 균형 완전 일치) → 순수 컬럼 마이그레이션, 스칼라 UPDATE 아님.
- 스티커 37·아크릴 41 = 전부 value→EMPTY 클리어 / tail-shift, 스칼라 in-place 변경 아님.
- **전체 527셀 중 진짜 in-place 스칼라 변경은 단 1건** = 실사 MES ITEM_CD 헤더영역 범례 텍스트(가격표 참조 안내문 추가). 이는 t_* 상품속성이 아닌 주석 → GAP으로 올바르게 분류(적용 대상 엔티티/컬럼 없음).

**판단**: 깔끔한 UPDATE로 처리됐어야 할 적용가능 스칼라 속성 변경(자재코드·플래그·수치 스펙 등)이 escalate에 잘못 섞인 사례 **0건**. 유일한 in-place 변경은 비적용 주석. 따라서 **"0 auto-UPSERT / escalate-everything"은 회피가 아니라 정직한 평결**이다. 기계적 size 삭제 금지(적재된 size/price 사슬 파손, schema-design-intent-first)라는 근거도 V4 라이브 실측(레더라벨 3행 실재)으로 뒷받침됨.

---

## 3. change-tracker로 환원한 finding

**NO-GO 유발 결함: 0건.**

비차단 관찰 1건 (차기 보정 시 `dbm-change-tracker` 라우팅 가능, 게이트 판정 무영향):

- **OBS-1 (Low·비차단)**: `impact/t_prd_product_sizes-impact.csv` 파일명-내용 어긋남 소지. `build_manifest.py`가 target_entity 문자열을 `split(" ")[0].split("/")[0]`로 파일명을 만드는데, 아크릴 ESCALATE 행의 target_entity가 `t_prd_product_sizes (+ 변형행)`이라 파일명은 `t_prd_product_sizes-impact.csv`가 되지만 실제 내용은 아크릴 변형행 ESCALATE만 담긴다(실제 size UPSERT 행 아님). 추적성·1:1 매핑·게이트 판정에는 영향 없음 — 파일명 가독성 개선 사항.

---

## 4. 안전 준수 확인

- 라이브 DB: SELECT/information_schema 읽기전용만. 쓰기·COMMIT·DDL **0건**. 자격증명 비노출(`.env.local` `RAILWAY_DB_*`만 사용).
- `_delta` 기본 ROLLBACK·`--commit` 차단 게이트 확인. 번들 미수정(게이트는 검증만, 빌더가 빌드 = V8 분리 준수).
- 실 COMMIT·CPQ L2 옵션레이어 적재·논리삭제·DDL 적용은 **전부 인간 승인 대기**.

---

검증 재현 명령:
- diff 재현: `python3 _workspace/huni-dbmap/14_change-tracking/260527-to-260610/scripts/diff_versions.py --outdir /tmp/v8gate` → `_diff-raw.json` byte-identical 확인
- 라이브 실측: `.env.local` 로드 후 read-only psql로 PRD_000280 size / option_items GROUP BY prd_cd / PRD_000066·PRD_000163·PRD_000215 size count
