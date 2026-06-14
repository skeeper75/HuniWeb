# 카테고리 잔존고아 마무리 — 적용 완료 기록 (APPLIED)

> **적용 2026-06-14** · round-13 라이브 정정 후속 · 인간(사용자) 승인 후 COMMIT.
> 권위 = 라이브 실측(동명 정상노드 1:1 실재). 검증 = `17_correctness/_gate/category-orphan-final-gate.md`(dbm-validator 독립 8/8 PASS·GO·뒤집힘 0).

## 적용 결과

| 대상 | 정정 전 | 정정 후 | 실행 로그 |
|------|---------|---------|-----------|
| 명함 10상품(PRD_000031~040) | 고아 CAT_000294(명함·부모없음) main=Y | 정상 동명노드 CAT_000048~057 main=Y + 294 강등 main=N | `INSERT 0 10`+`UPDATE 10` |
| 상품권 2상품(PRD_000041/042) | 고아 CAT_000295(상품권·부모없음) main=Y | 정상 동명노드 CAT_000063/064 main=Y + 295 강등 main=N | `INSERT 0 2`+`UPDATE 2` |

## 검증 (COMMIT 후 라이브 재조회)

- 12상품 전부 정상 동명노드 main=Y 1:1 연결 확인 ✓
- 고아 CAT_000294·CAT_000295 main=Y 잔존 0건 ✓
- **멱등 2회차: `INSERT 0 0`+`UPDATE 0`(완전 무동작)** — `ON CONFLICT…WHERE IS DISTINCT FROM`·`WHERE main='Y'` 가드로 재실행 0행 ✓

## 안전망

- 백업: `backup-before-commit.txt`(12상품 정정 전 상태·대상 12노드 비어있음 실측)
- 롤백: `rollback.sql`(정상연결 12행 DELETE + 고아 main=Y 복귀·dbm-validator 원복 실증)
- 비파괴: hard-delete 0·노드 use_yn 불변(연결만 재배치)
- 타임스탬프: 신규 연결 reg_dt=now()·고아강등 upd_dt=now()

## 핵심 — Q-ID-B/W-05 해소

상품권 "정상 상위노드 미확정"(digital-print Q-ID-B·W-05)이던 것을 **라이브 실측으로 해소** — 쿠폰/상품권(CAT_000062) 하위에 동명 정상노드 CAT_000063/064 실재 확인.

## 누적 (카테고리 정상화)

- 2026-06-14 즉시적용(11시트) 106상품 + **본 12상품 = 118상품** — BATCH-1(카테고리 재연결) 거의 완결.
- 잔존 = 부자재 2상품(타이벡북커버 PRD_000218·이미지피켓 PRD_000229) = **동명노드 부재(Q-GP-7 컨펌)**. 빈 임시함 숨김은 전역정리 별도 트랙.

## MINOR

- PRD_000042 "프리미엄 쿠폰/상품권" ↔ CAT_000064 "프리미엄 상품권/쿠폰" 어순 스왑(의미 동일·적재 무해). apply.sql 주석 명시.
