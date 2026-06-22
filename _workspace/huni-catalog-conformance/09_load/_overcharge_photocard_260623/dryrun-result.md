# dryrun-result.md — 포토카드 V3 교정 DRY-RUN 결과

> §21 카탈로그 정합 · 2026-06-23 · 라이브 읽기전용 + 롤백전용 트랜잭션. 실 COMMIT 없음(이 문서 시점).
> 대상: PRD_000024(포토카드)·PRD_000025(투명포토카드) · 공식 PRF_PHOTOCARD_FIXED · 권고①(상품별 공식분리).

---

## 1. search-before-mint (신규 공식 신설 vs 기존)

| 항목 | 실측(2026-06-23) | 판정 |
|------|------------------|------|
| PRF_PHOTOCARD_NORMAL/CLEAR 실재 | **0** (PRF_PHOTOCARD_FIXED만 실재) | **신규 신설 필요** |
| 동명 frm_nm('일반/투명포토카드 세트 고정가') | 0 | 멱등 INSERT 안전 |
| 채번 | frm_cd 명명형(순차 surrogate 아님) → 충돌 0 확인 | NORMAL/CLEAR 유효 |
| 024/025 현재 바인딩 | 둘 다 PRF_PHOTOCARD_FIXED·apply_bgn_ymd=2026-06-01·각 1행 | 재배선 대상 |
| 두 comp(SET/CLEAR_SET) 공유 범위 | PRF_PHOTOCARD_FIXED **에만** 배선(타 공식 0) | **클래스 A·공유충돌 0** |
| comp 단가행 차원 | SET/CLEAR_SET 둘 다 siz=SIZ_000012·bdl=20·min=1·판별축(proc/opt/print_opt) 전부 NULL | silent 합산 구조 확정 |

→ **각 comp가 한 상품 전용**(SET=일반·CLEAR_SET=투명)이라 공식분리로 깨끗이 분리 가능.

## 2. 교정 매핑 — 무엇을 (단가 불변)

| Phase | 액션 | 대상 | 단가 변경 |
|------|------|------|:--:|
| A | 신규 공식 INSERT | PRF_PHOTOCARD_NORMAL·CLEAR (use_yn=Y) | — |
| B | FC 배선 INSERT | NORMAL←COMP_PHOTOCARD_SET(6,000)·CLEAR←COMP_PHOTOCARD_CLEAR_SET(8,500) | **0(재사용)** |
| C | BIND 재배선 UPDATE | 024→NORMAL·025→CLEAR (frm_cd만·PK 불변) | **0** |
| D | 고아 비활성 UPDATE | PRF_PHOTOCARD_FIXED use_yn=Y→N | **0** |

→ t_prc_component_prices를 SET하는 구문 **0개**. comp use_dims 미변경(V1/V2와 다름).

## 3. DRY-RUN 실증 결과 (evaluate_price 로직 SQL 재현 + ROLLBACK)

라이브 트랜잭션 안에서 교정 적용 → pricing.py `_evaluate_formula`(:537-596) 충실 재현 → ROLLBACK.
재현 인과: evaluate_price가 BIND에서 prd_cd의 frm_cd 조회(:413-419) → 그 공식의 FC만 평가
(`TPrcFormulaComponents.filter(frm_cd=frm_cd)` :551) → included subtotal 합산(:591-595).

| 상품 | BEFORE (현 라이브) | AFTER (교정) | 기대 | 판정 |
|------|:--:|:--:|:--:|:--:|
| **024 포토카드** | **14,500** (SET 6,000 + CLEAR_SET 8,500 silent 합산) | **6,000** (NORMAL=SET만) | 14,500→6,000 | ✅ |
| **025 투명포토카드** | **14,500** (동일 합산) | **8,500** (CLEAR=CLEAR_SET만) | 14,500→8,500 | ✅ |

DRY-RUN NOTICE: `✅ DRY-RUN PASS: 14500→6000(024)·14500→8500(025)·verbatim 불변`

**★공식분리의 우월성(foldcard P8-1 함정 대비)**: 공식분리는 evaluate_price가 **공식 단위로 어느 comp를
보는지** 결정하므로 판별축이 불필요하고 부분교정 함정이 없다(foldcard는 4 comp 전부 proc_cd 충전돼야
P8-1 분리됐으나, V3는 바인딩 1건 재배선만으로 그 상품이 자기 comp만 봄). 구조적으로 silent 합산 제거.

## 4. verbatim 게이트

| 검증 | 결과 |
|------|------|
| apply.sql 내장 G-1(적재 전후 행수·합 동일) | ✅ **PASSED** |
| SET 단가합 / CLEAR_SET 단가합 | **6,000.00 / 8,500.00 — 불변** |
| unit_price SET 구문 수 | **0** |

→ verbatim-guard.md 참조.

## 5. 멱등성

| 검증 | 결과 |
|------|------|
| 한 트랜잭션 내 교정 2회 연속 적용 | 2회차 전부 `INSERT 0 0`·`UPDATE 0` (no-op) |
| ON CONFLICT (frm_cd)·(frm_cd,comp_cd) DO NOTHING | 재실행 안전 |
| IS DISTINCT 가드(BIND·FIXED UPDATE) | 수렴·재실행 0행 |

→ **멱등 확인.** 재실행해도 추가 변경 0.

## 6. FK 위상·가드

| 가드 | 결과 |
|------|------|
| G-2 WIRE: 신규 공식 각 comp 1개만 배선 | ✅ PASSED |
| G-2 BIND: 024→NORMAL·025→CLEAR 재배선 완료 | ✅ PASSED |
| FK: FC.frm_cd→FRM·FC.comp_cd→PC·BIND.frm_cd→FRM 부모 선행 | A→B→C→D 위상 충족 |

## 7. 판정 종합

- **공식분리 메커니즘·교정 방향 검증 완료**: 14,500→6,000/8,500 분리·verbatim 불변·멱등 전부 실증.
- **클래스 A 확정**: comp 상품전용·공유충돌 0·공유 마스터(단가행/comp) 무수정.
- **막힌 것 없음**(foldcard와 달리 코드 등록 선행 불요 — 신규 공식 frm_cd 명명형 채번·기존 comp 재사용).
- → 인간 승인(momentum) 완료 전제로 **COMMIT 진행** (commit-log.md 참조).
