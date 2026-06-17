# 064 소량자유형 가격 적재 (S064) — Phase D 독립 검증 verdict (R1~R6) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-18 · 생성자(load-builder)와 독립.
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. 단가는 INSERT…SELECT가 라이브 SIZ_059(B01 col1)를 복사하므로 **라이브 source 직접 대조**(verbatim). COMMIT 0·비밀값 비노출.

## 종합 판정: **GO (잠정 단가 전제)** → 실 COMMIT 가능 (인간 최종 승인 시)

R1~R6 전건 PASS(라이브 독립 재현). **INSERT 1260+1=1261 일치·2-pass delta 0·B01 col1 verbatim 복사(mismatch 0)·7siz 사이즈무관 동일가(distinct 1)·잠정 note 1260행·소재 5종·동시매칭 0·FK고아 0·채번 0·058~067 가격사슬 완결·COMMIT 0** 모두 실측. BLOCKER 0·불일치 0.
**★단가 잠정 주의**: B01 규격가 차용(064 실측 단가 아님·사용자 결정 "우선 등록 후 추후 변경"). note로 식별·교체 가능 — 적재 정합은 GO이나 단가 정확성은 실무진 실측 수령 시 교체 전제.

---

## R1 멱등성 (2-pass) — **PASS**
2-pass: PASS1(INSERT 1260·1) · **PASS2 전건 0**. 멱등키: S064a=자연키(comp,apply_ymd,siz,mat,min_qty) NOT EXISTS(PK=시퀀스라 ON CONFLICT 불가) · S064b=PK(prd,apply_bgn_ymd) NOT EXISTS.

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i S064a→S064b; ROLLBACK`. `ON_ERROR_STOP on`. 2 유닛 BEGIN/COMMIT/ROLLBACK 0건 → 중첩 0. FK 위상: S064a(단가·comp/siz/mat 기존)→S064b(바인딩·PRF 기존).

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 라이브: PRD_000064(소량자유형스티커)·PRF_STK_FIXED 실존·7 target siz(94x94/80x80/50x70/70x50/50x94/94x50/65x65) 전부 실존(채번 0)·064 소재 5종(084/153/155/156/242) 실측.

## R4 영향행수 — **PASS (보고와 일치)**
독립 실측: S064a INSERT **1260**(7siz × 5mat × 36mq) · S064b INSERT **1**(바인딩) = **1261**. inserted_rows 1260 확인. 매니페스트와 일치.

## R5 ★단가 = B01 col1 동일가 (verbatim) — **PASS**
- **source 실측**: B01 col1 SIZ_059(124x186) 5소재×36mq = 180행(정확). INSERT…SELECT로 7 siz에 CROSS JOIN 복사(하드코딩 0).
- **verbatim_mismatch = 0**: 064 1260행 전부 SIZ_059 동일 (mat,min_qty) 단가와 일치(라이브 source 직접 대조).
- **사이즈무관 동일가**: 유포153 mq1 7siz distinct price = **1**(전부 동일). 골든 G1 50x70 유포153 mq1=**6,000**·G2 94x94 무광155 mq1=**7,000**.
- **소재 5종만**: distinct_mat=5(투명162/홀로163 미적재·과적재 0). 7siz 채번 0(search-before-mint).
- **★단가 정확성 한계(잠정)**: 이 단가는 064 실측이 아니라 B01 규격가 차용. 가격표 스티커 시트 6블록에 064 소형반칼 단가 부재(이전 BK6 BLOCKED 사유) → 사용자가 "우선 등록 후 추후 변경" 결정. 적재 메커니즘은 정합이나 **값은 잠정**.

## R6 note 잠정 + 바인딩 — **PASS**
- **provisional_note_rows = 1260**: 전 단가행 note = `[잠정] 소형반칼 B01 규격가(col1·124x186) 사이즈무관 적용·실측 단가 미수령·추후 변경 (064 소량자유형)` → 실무진 식별·교체 가능(round-17 가독성).
- **바인딩**: 064 → PRF_STK_FIXED 1건·동시매칭 0(dup_naturalkey=0)·FK고아 0(siz·frm 기존).
- **★058~067 가격사슬 완결 실측**: 라이브 052~067 16상품 중 058~063·065~067 전부 바인딩=1·**064만 0**(이 run이 마지막 갭). 064 바인딩 후 스티커 family 전건 완결.

## undo / 안전성 — **충분**
백업 2 CSV. INSERT만(comp/단가행 신규)·undo=신규 1260+1 DELETE(siz/prd predicate). 물리 손실 0. apply.sh `^ROLLBACK;` 1건 sed 치환(SAFE)·비밀값 비노출.

## 생성자 주장 vs 검증자 실측
| 항목 | 생성자 | 실측 | 판정 |
|------|--------|------|:--:|
| 1261(INSERT1260·1) | 보고 | 동일 | 일치 |
| B01 col1 verbatim·mismatch0 | 주장 | **라이브 source 대조 mismatch 0** | 일치 |
| 7siz 동일가(distinct 1)·골든 6000/7000 | 주장 | 확인 | 일치 |
| 잠정 note 1260·소재5·동시매칭0·채번0·2-pass0 | 주장 | 확인 | 일치 |
| 058~067 가격사슬 완결 | 주장 | **052~067 중 064만 미바인딩→완결** | 일치 |
| 불일치 | — | 없음 | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·단가 라이브 source(SIZ_059) verbatim 대조·잠정 note·가격사슬 완결 실측.

### 최종: **GO — 실 COMMIT 가능 (잠정 단가 전제)**
R1~R6 전건 PASS·BLOCKER 0·적재 정합 완전. 인간 승인 시 `apply.sh --commit`. **단, 단가는 B01 규격가 잠정 차용**(064 실측 아님)이므로 실무진 실측 단가 수령 시 note 식별로 교체 필수. 사후검증(7siz 동일가·잠정 note 1260·064 바인딩·가격사슬 완결) 권고.
