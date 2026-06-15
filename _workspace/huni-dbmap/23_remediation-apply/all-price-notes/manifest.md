# 전 상품군 가격테이블 note 교정 — 적재 매니페스트

> 016 가격사슬(PRF_DGP_A, 1,432행)은 이미 COMMIT 완료(`../016-notes/`). 이 번들은 **016 외 잔존
> 전문용어 note** 전수를 라이브 실측 기준으로 쉬운 한국어로 교정한다.
> **빌드 + 롤백전용 DRY-RUN까지.** 실 COMMIT은 독립 게이트(dbm-validator) GO + 인간 승인.

## 1. 범위 (라이브 실측 2026-06-15)

| 테이블 | 전체 | note 보유 | 전문용어 잔존(대상) | 교정 |
|--------|-----:|----------:|--------------------:|-----:|
| `t_prc_price_components` (정의행) | 144 | 144 | **115** | 115 |
| `t_prc_component_prices` (단가행) | 3,488 | 3,481 | **2,057** | 2,057 |
| **합계** | | | **2,172** | **2,172** |

`t_cod_base_codes` 등 다른 가격 코드값 note: 전문용어 잔존 **0** (범위 외 확정).
FLAG_UNCLEAR: **0건** (모든 행이 의미 보존 교정 가능).

## 2. 교정 규칙 (note 컬럼만 · 의미 보존)

### 정의행 (`t_prc_price_components`)
- comp_nm은 이미 후니 용어로 양호 → note를 **"무슨 비용인지 + 축/단위"** 쉬운 한국어로 교체.
- 현재 note 패턴: `round-2 7시트 확대 자동생성` / `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.NN`.
- comp_nm(식별자 `[COMP_xxx]` 제거) 18종 패턴별 라벨(`gen_notes.py` DEF_NM_LABELS, 권위=후니 용어+도메인 KB).

### 단가행 (`t_prc_component_prices`) — 결정적 regexp 체인 (SQL=Python 동치, 라이브 실증)
1. **합가 메모** `(...합가...)` → ` / 작업 1건 고정 금액(수량을 곱하지 않음)` (016 규칙 재사용).
2. **prefix 교정 마커** `[siz...]`·`[siz-corrected...]` 제거.
3. **메모 시그니처 괄호 제거** — 괄호 안에 코드/식별자/내부어휘(`comp흡수·comp_typ·SIZ_N·MAT_N·PRD_N·규칙④·bdl_qty·라이브 siz·완제품비.·중첩서브제품·소재묶음·band=·M-N정정·DIRECT매칭·SIZ_PENDING·대표mat·규격단독·상품구분축·후니확인·추출결함·면당EA` 등)가 있는 괄호 그룹(1단 중첩까지)만 제거.
4. **대괄호 안 mat 코드만 제거** `[설명, mat=MAT_N 대표]` → `[설명]` (설명 보존).
5. **축 한국어화** `A≥N` → `A N 이상` (A = 총제작수량/제작수량/출력매수/수량/장수), 잔여 `≥N` → `N 이상`.
6. **공백 정리** + btrim.
- **보존(의미)**: 소재·색·도수·사이즈 괄호(`(화이트)·(국4절)·(NxN)·(Nmm)·(N도)·(유광/미러)`), `[..포함가]`·`[묶음 동일단가..]`·`[출력가]` 등 실무 정보 대괄호.

## 3. 멱등·불변 보증

- 모든 UPDATE는 `note IS DISTINCT FROM (교정값)` 가드 + `SET note·upd_dt` 둘만. 재실행 delta 0.
- 016 사슬 행은 이미 교정됨 → 동일 텍스트면 가드로 자동 no-op(중복 안전).
- 단가행 SQL은 결정적 regexp 체인(라이브에서 직접 수행) — `gen_notes.py` Python transform과 라이브 2,057행 byte-identical 동치 실증(mismatch 0).
- **[HARD] unit_price·prc_typ_cd·축 컬럼·가격/단가행 절대 불변** — DRY-RUN 지문 before==after 실증.

## 4. 실행 순서 (단일 트랜잭션 · 원자성)

`apply.sql` = `BEGIN; \i 01_update_notes.sql` (COMMIT/ROLLBACK은 로더 주입, 기본 ROLLBACK).
- A) 정의행 115 행별 UPDATE (comp_cd PK).
- B) 단가행 결정적 regexp 치환 1블록 (전문용어 보유 행 + 교정 후 잔존0 행만 대상).

## 5. 산출 파일

| 파일 | 역할 |
|------|------|
| `gen_notes.py` | 생성기(라이브 실측 → note-map + SQL·재현성·손편집 금지) |
| `note-map.csv` | 전수 2,172행 {table·pk·comp_cd·comp_nm·current_note·corrected_note·flag} 대조표 |
| `01_update_notes.sql` | 멱등 UPDATE(note만·IS DISTINCT FROM·upd_dt=now()) |
| `apply.sql` | 단일 트랜잭션 래퍼(ON_ERROR_STOP) |
| `apply_loader.sh` | psql 로더(기본 DRY-RUN·`commit` 인간 승인) |
| `_dryrun_verify.sql` | DRY-RUN 2-pass 멱등·불변·잔존0 검증 SQL |
| `dry-run-result.md` | 라이브 롤백전용 DRY-RUN 실증 결과 |

## 6. 인간 승인 대기

- 실제 COMMIT (`./apply_loader.sh commit`) — **독립 게이트(dbm-validator) GO + 인간 승인** 후에만. 이 에이전트는 자기승인하지 않음.
