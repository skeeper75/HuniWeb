# 058~061 반칼 가능분 (BK6) — Phase D 독립 검증 verdict (R1~R6) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-18 · 생성자(load-builder)와 독립. **A4 분리 교정이 돈-크리티컬.**
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. A5/A4 단가는 sticker-import.xlsx `4_component_prices` openpyxl 독립 추출 후 SQL과 field-for-field 대조(생성자 산출 비신뢰). COMMIT 0·비밀값 비노출.

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

R1~R6 전건 PASS(라이브+xlsx 독립 재현). **INSERT365/UPDATE4=369 일치·2-pass delta 0·A5/A4 단가 360행 verbatim(mismatch 0)·★A4 반칼 5000≠B02 낱장 4000 분리(오청구 0)·완칼 055/056 무접촉·동시매칭 0·FK고아 0·SIZ_000520 search-before-mint·064 BLOCKED 정당·COMMIT 0** 모두 실측. BLOCKER 0·불일치 0.

---

## R1 멱등성 (2-pass·UPDATE 포함) — **PASS**
2-pass: PASS1(INSERT 1·180·180 / UPDATE 4 / INSERT 4) · **PASS2 전건 0**. 멱등키: BK6a/e=PK NOT EXISTS · BK6b/c=자연키(comp,apply_ymd,siz,mat,min_qty) NOT EXISTS · BK6d=`siz_cd='SIZ_172' AND NOT EXISTS 520`(교정 후 520이라 재매칭 0).

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i BK6a→BK6b→BK6c→BK6d→BK6e; ROLLBACK`. `ON_ERROR_STOP on`. 5 유닛 BEGIN/COMMIT/ROLLBACK 0건 → 중첩 0. **FK 위상: SIZ_520 채번(BK6a) → A4 단가(BK6c)·product_sizes 교정(BK6d) 선행** = 단가/교정 FK 충족.

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 라이브 일치: SIZ_170=A5(148x210)·SIZ_172=A4(210x297)·t_siz_sizes/product_sizes/component_prices 스키마 정합·058~061 등록 소재 5종 실측.

## R4 영향행수 — **PASS (보고와 일치)**
독립 실측: BK6a INSERT 1·BK6b 180·BK6c 180·BK6d UPDATE 4·BK6e INSERT 4 = **INSERT 365 + UPDATE 4 = 369**. 매니페스트와 전건 일치.

## R5 ★A4 오청구 회피 (돈-크리티컬·핵심) — **PASS**
- **SIZ_000520 search-before-mint**: max siz=SIZ_000519 → 520 무충돌(라이브 0건 확인).
- **분리 입증(post-state 실측)**: A4 반칼 SIZ_520 유포153 mq1 = **5,000**(B01 col2 verbatim) · B02 낱장 SIZ_172 유포153 mq1 = **4,000 무변경**. 5000≠4000 분리 확정.
- **058~061 교정 실측**: SIZ_170 + **SIZ_520**(SIZ_172 제거) → 반칼 전용 5,000 청구·낱장 4,000 오청구 회피.
- **★완칼 낱장 055/056 SIZ_172 무접촉 = 2**(BK6d `prd_cd IN 058~061` 한정 실측). ERR_DUPLICATE 위험 0.
- **동시매칭 0**: SIZ_170/520 같은 (siz,mat,min_qty) 자연키 중복 0(dup_naturalkey=0). orphan_price_siz 0(SIZ_520 부모 선존재).

## R6 ★verbatim + 골든 — **PASS**
xlsx `4_component_prices` openpyxl 독립 추출(A5(4판) 180·A4(2판) 180·MAT5 필터) → SQL field-for-field:
```
BK6b A5(SIZ_170):    xls 180 = sql 180 · only_xls 0 · only_sql 0 · mismatch 0
BK6c A4반칼(SIZ_520): xls 180 = sql 180 · only_xls 0 · only_sql 0 · mismatch 0
```
- **골든 G1** A5 유포153 mq1 = **6,000**(B01 col1 verbatim) · **G3** A4 반칼 유포153 mq1 = **5,000**(col2).
- **G2 A5=124x186 동일가**: xls A5 180셀 vs 라이브 124x186(SIZ_059) 5소재×36mq **mismatch 0**(사용자 컨펌 Q-DC-1 실측 검증).
- **소재 5종만**(유포153·비코084·미색242·무광155·유광156) — 058~061 라이브 등록분(투명162/홀로163 미등록·과적재 0). A5/A4 각 5mat×36mq=180.

## 064 BLOCKED 분리 정당성 — **PASS**
BK6 SQL 전 5파일 **executable PRD_000064 0건**(grep "064" hits 전부 주석 `bankal-058-064-deepcheck` 문서명). BK6e 바인딩 INSERT = PRD_000058/059/060/061만(SQL 본문 확인). 064 소량자유형=가격표 단가 부재(전 시트 scan·근거 없는 추측 금지)·apply.sql 미포함 — 정당.

## undo / 안전성 — **충분**
백업 4 CSV. INSERT(BK6a/b/c/e)=신규 행 DELETE·UPDATE(BK6d)=SIZ_520→172 역복원(백업 product_sizes). 물리 손실 0. apply.sh `^ROLLBACK;` 1건 sed 치환(SAFE)·비밀값 비노출.

## 생성자 주장 vs 검증자 실측
| 항목 | 생성자 | 실측 | 판정 |
|------|--------|------|:--:|
| 369(INSERT365·UPDATE4) | 보고 | 동일 | 일치 |
| A5/A4 360행 verbatim | 주장 | **xls 독립 추출 mismatch 0** | 일치 |
| A4 반칼 5000≠낱장 4000·완칼 무접촉 | 주장 | **post-state 실측 확인** | 일치 |
| A5=124x186 동일가(G2) | 주장 | **라이브 SIZ_059 대조 mismatch 0** | 일치 |
| 소재 5종·동시매칭0·FK고아0·2-pass0 | 주장 | 확인 | 일치 |
| 064 BLOCKED·SIZ_520 채번 | 주장 | **executable 0·max+1 확인** | 일치 |
| 불일치 | — | 없음 | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·A5/A4 단가 xls 독립 추출 대조·A4 분리 post-state 실측·완칼 무접촉·064 SQL 본문 확인.

### 최종: **GO — 실 COMMIT 가능**
R1~R6 전건 PASS·BLOCKER 0·돈-크리티컬 A4 분리 입증(5000≠4000·완칼 무접촉). 인간 승인 시 `apply.sh --commit`. 사후검증(A4 SIZ_520=5000·낱장 SIZ_172=4000 유지·055/056 무접촉·058~061=SIZ_170+520·바인딩 4) 권고. 064는 가격 출처 컨펌 후 별 트랙.
