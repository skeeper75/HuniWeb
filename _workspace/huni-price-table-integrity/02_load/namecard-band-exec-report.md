# 명함류 NAMECARD/PHOTOCARD .01 18개 밴드총액 ×수량 과대청구 교정 — 실행 리포트 (COMMIT 완료)

> 2026-06-29. load-executor 안전 적재. 사용자 승인 완료·게이트 GO 18/18·dryrun 검증 완료.
> 권위=인쇄상품가격표 260527. webadmin 엔진 코드 미변경(read-only). 단가행 값 verbatim 불변(prc_typ·min_qty만 변경).

## 종합: COMMIT 완료 · 사후 시뮬 4/4 정답 일치 · 무손상 입증

---

## 1. 물리 백업 (선행·원복 가능)
| 백업 테이블 | 행수 | 내용 |
|---|---|---|
| `bak_t_prc_price_components_namecardband_20260629_1749` | 18 | 영향 price_components 18행 full-row 스냅샷(prc_typ 원본 .01) |
| `bak_t_prc_component_prices_namecardband_20260629_1749` | 2 | 그룹C component_prices 2행(min_qty 원본 1·comp_price_id 3439·3440) |

## 2. dryrun 재실행 (ROLLBACK·실행 전 종결자 확인)
- 종결자 = `ROLLBACK`(52행) 육안 확인.
- UPDATE 카운트 = **14 · 2 · 2 · 2**(기대치 정확 일치)·제약위반 0·rc=0.
- 멱등성: 트랜잭션 내 2회 연속 실행 → ROUND1 14·2·2·2 / ROUND2 **0·0·0·0**(재실행 delta 0).

## 3. fix.sql (종결자 COMMIT·dryrun에서 ROLLBACK→COMMIT만 전환)
- `namecard-band-fix.sql` — 단일 트랜잭션 BEGIN…UPDATE 4건…COMMIT.
- 실행 직전 종결자 `COMMIT`(43행) 육안 확인 후 실행.

## 4. COMMIT 실행 (행수)
| 그룹 | 교정 | 대상 t_* | COMMIT 행수 |
|---|---|---|---|
| A 밴드총액 14개 | prc_typ .01→.02 | t_prc_price_components | **14** |
| B 동판셋업 2개 | prc_typ .01→.03 | t_prc_price_components | **2** |
| C 포토카드 세트 2개 | prc_typ .01→.02 | t_prc_price_components | **2** |
| C 포토카드 세트 2개 | min_qty 1→20 | t_prc_component_prices | **2** |

- 합계: price_components 18행(.01→.02×16, .01→.03×2) + component_prices 2행(min_qty 1→20). 트랜잭션 COMMIT·rc=0.

## 5. 사후검증 (라이브 재실측)
- ① 남은 `.01`(명함/포토카드) = **0**(전부 교정).
- ② 분포: 그룹A 14개=.02 / 그룹B 2개(SETUP)=.03 / 그룹C 2개=.02 — 정확.
- ③ 그룹C min_qty=**20**(3439·3440), unit_price verbatim 불변(6000·8500).
- ④ 멱등 재-dryrun = **0·0·0·0**(delta 0).

### 사후 시뮬 재실증 (시뮬레이터 인증 POST 실호출 · 필수)
| 상품 | qty | 교정 전(과대) | 교정 후 | 정답 | 일치 |
|---|---|---|---|---|---|
| PRD_000037 오리지널박명함 | 200 | 1,019,200 (×42) | 24,200 (본체 19,200 + SETUP 5,000) | 24,200 | ✓ |
| PRD_000037 | 1000 | 5,063,000 (×74) | 68,000 (본체 63,000 + SETUP 5,000) | 68,000 | ✓ |
| PRD_000024 포토카드 | 20 | 120,000 (×20) | 6,000 | 6,000 | ✓ |
| PRD_000025 투명포토카드 | 20 | 170,000 (×20) | 8,500 | 8,500 | ✓ |

- 추가 환산 검증(min_qty=20 선형): PRD_025 40장=17,000(8500/20×40)·PRD_024 60장=18,000(6000/20×60) — 정확.
- SETUP(.03)=수량무관 고정 5,000 입증(200매·1000매 모두 5,000).

## 6. undo.sql (보유)
- `namecard-band-undo.sql` — 백업 테이블에서 prc_typ(18행)·min_qty(2행) 원복(종결자 COMMIT). 사후 불일치 시 즉시 실행용.

## 7. 보안
- `.env.local` IGNORED·chmod 600 확인. 비밀값 stdout/산출물 비노출(환경변수로만 사용).

---

## 잔여
- **active 긴급 3건**(037 SETUP·024·025) = 교정·사후 시뮬 검증 완료(과대청구 해소).
- **예방(미바인딩) 15건** = prc_typ는 교정 완료(.02/.03). 바인딩(공식 연결)은 별도 트랙(§18 명함류 가격공식 설계).
  - 그룹A 13개(COAT·FOIL_HOLO/STD·PREMIUM·WHITE·PHOTOCARD_BULK) + SETUP_S2 = 현재 어떤 공식에도 미포함. 바인딩 시점에 .02/.03 prc_typ가 즉시 정상 작동(사전 교정 완료).
- webadmin 엔진 코드 미변경(read-only). 본 교정은 데이터(prc_typ·min_qty)만 정정.

## 산출물 경로
- 백업: 라이브 DB `bak_t_prc_price_components_namecardband_20260629_1749`·`bak_t_prc_component_prices_namecardband_20260629_1749`
- fix: `_workspace/huni-price-table-integrity/02_load/namecard-band-fix.sql`
- undo: `_workspace/huni-price-table-integrity/02_load/namecard-band-undo.sql`
- dryrun: `_workspace/huni-price-table-integrity/02_load/namecard-band-dryrun.sql`
- report: `_workspace/huni-price-table-integrity/02_load/namecard-band-exec-report.md`
