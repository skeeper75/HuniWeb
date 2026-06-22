# post-verify.md — 포토카드 V3 교정 COMMIT 후 사후검증

> §21 카탈로그 정합 · 2026-06-23 · ★별도 연결(트랜잭션 종료 후)로 영속성 재실측. 전 항목 PASS.

## 사후검증 결과 (별도 psql 연결·COMMIT 영속 확인)

| # | 검증 | 기대 | 실측 | 판정 |
|:-:|------|------|------|:--:|
| PV-1 | 신규 공식 영속 | NORMAL/CLEAR use_yn=Y·FIXED use_yn=N | 일치 | ✅ |
| PV-2 | FC 배선 영속 | NORMAL←SET·CLEAR←CLEAR_SET·FIXED 보존 | 일치(4행) | ✅ |
| PV-3 | 바인딩 재배선 영속 | 024→NORMAL·025→CLEAR·apply=2026-06-01 | 일치 | ✅ |
| PV-4 | **가격 재계산** | 024 base=6,000·025 base=8,500 | **6,000.00·8,500.00** | ✅ |
| PV-5 | verbatim 단가행 | SET=6,000·CLEAR_SET=8,500 불변 | 일치 | ✅ |
| PV-6 | FK 고아 | BIND_orphan=0·FC_orphan=0 | 0·0 | ✅ |

## 핵심

- **과대청구 해소 실증**: 024 포토카드 14,500→**6,000**(−8,500/세트)·025 투명포토카드 14,500→**8,500**(−6,000/세트).
- evaluate_price가 각 상품의 바인딩 공식(NORMAL/CLEAR)의 formula_components만 평가 → 자기 comp만 합산.
- 단가값 0변경(verbatim)·기초코드/공유 마스터 무수정·webadmin 코드 무수정.
- 트랜잭션 종료 후 별도 연결에서도 동일 → COMMIT 영속 확인.

→ **사후검증 통과 → 교정 완료(라이브 운영 DB 반영).**
