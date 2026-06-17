# 실사 가격 견적화 — round-23 Phase C 적재/교정 매니페스트

> 작성 2026-06-17 · dbm-load-builder. 입력 = Phase B `silsa-quote-design.md`(U1~U8) + 라이브 실측 정정.
> **롤백전용 DRY-RUN 완료(R1~R6). 실 COMMIT은 인간 승인(`apply.sh --commit`).**
> 권위: 라이브 read-only SELECT(2026-06-17). 비밀값 비노출·DB 쓰기 0.

## 적재 순서 (FK 위상정렬 · 단일 트랜잭션 `apply.sql`)

| 순 | 단위 | 테이블 | 조치 | 영향행수(PASS1 실측) | 멱등키 | 위험 |
|:--:|------|--------|------|:---:|--------|:--:|
| 1 | **U1** | t_siz_sizes | 신규 좌표 siz INSERT (SIZ_000518~623) | **INSERT 106** | siz_cd (NOT EXISTS) | 저 |
| 2 | **U3** | price_components / formula_components | C-1/2/3 통합: 레거시 6 comp use_yn=N · 배선 정본 교체 | **UPDATE 6 · INSERT 0 · DELETE 12** | comp_cd / (frm_cd,comp_cd) | 저 (재적재 0) |
| 3 | **U4** | price_components / component_prices / formula_components | C-4 미싱: prc_typ .02→.01 · opt_cd→dim_vals 재정규화 30행 · 2L/3L use_yn=N · 배선 교체 | **UPDATE 1+30+2 · INSERT 0 · DELETE 4** | comp_cd / comp_price_id / (frm_cd,comp_cd) | 중 (값동일·신규 0) |
| 4 | **U5** | t_prc_component_prices | 별색 WHITE_S1 잉여 4색 proc 단가행 hard-delete | **DELETE 424** (530→106 유지) | proc_cd<>PROC_000008 | **🔴 고** (백업+undo) |
| 5 | **U6** | price_formulas / formula_components / product_price_formulas | 가격사슬 공식 분리: 28 유형별 공식 + 28 배선 + 바인딩 교체(FIXED DELETE 28 → 신규 INSERT 28) | **INSERT 28+28 · DELETE 28 · INSERT 28** | frm_cd / (frm_cd,comp_cd) / (prd_cd,apply_bgn_ymd) | 중 |
| 6 | **U8** | t_prc_price_components | 가독성 정비 comp_nm/note 한국어 | **UPDATE 15** | comp_cd (조건부) | 저 (비-가격) |

**합계 실 적재 영향(PASS1):** INSERT 162 · UPDATE 54 · DELETE 468 (제본 배선 DELETE 12 + 미싱 4 + WHITE 424 + 바인딩 28).

## BLOCKED (apply.sql 제외 · 별 파일)

| 단위 | 사유 | 해소 경로 | undo |
|------|------|-----------|------|
| **U2** 면적 단가행 (~687) | 면적매트릭스 13블록 (가로×세로)=단가 언피벗 CSV 부재(설계 §5 GAP). 가격표 셀 날조 금지(돈-크리티컬) | dbm-price-import-prep(round-16 poster-sign decomposition) → 검증 CSV → NOT EXISTS INSERT. U1 선행 후 좌표 siz 매핑 | n/a (미실행) |
| **U7** 제본 고아 배선 (10) | 대상 공식 라이브 부재 + 제본 종류 상호배타(단일 합산 배선=가격 이중계상) + 1:1 매핑 silsa 스코프 밖 + 실사 직결 아님 | 책자/캘린더 상품별 공식 PRF_BIND_<TYPE> 1:1 신규(U6 동형·별 트랙) | n/a (미실행) |

## undo / 백업

- **U5 hard-delete**: `apply.sh`가 COMMIT/DRY-RUN 무관 항상 백업 SELECT → `backup_U5_white.csv`(undo 근거 14컬럼). 복원 = 백업 CSV를 component_prices에 재INSERT.
- U1/U3/U4/U6/U8: 비파괴(INSERT·use_yn=N·UPDATE) → COMMIT 전 DRY-RUN ROLLBACK이 안전망. 실 COMMIT 후 undo는 역-SQL(신규 siz/공식 DELETE·use_yn=N→Y·바인딩 FIXED 복원) 필요 시 생성.

## ★설계 대비 정정 (라이브 실측 권위)

1. **U4 이설 불요** — 설계 "2L/3L 단가행 20행 1L 이설"은 라이브와 불일치. PERF_1L이 이미 30행(opt_cd OPV-000007/8/9 = 줄수 1/2/3) 보유 → 이설 0, **opt_cd→dim_vals 재정규화**(값 불변)만.
2. **U5 530→53 오류 정정** — 설계 "키별 1행 53 유지"는 POPT_000002(6,000원) 단/양면 단가티어를 파괴(돈-크리티컬). 정답 = 화이트 자기 공정 **PROC_000008만 유지 → 106행**(53밴드 × 2 print_opt), 잉여 4색 proc 424 DELETE. 값 무손실 입증(동일 (print_opt,min_qty) 5 proc 단가 동일).
3. **U6 PK 정정** — `t_prd_product_price_formulas` PK = **(prd_cd, apply_bgn_ymd)**(DDL 문서 (prd_cd,frm_cd) stale). apply_bgn_ymd NOT NULL → 바인딩 교체 = DELETE(FIXED) 선행 후 INSERT(신규·동일 '2026-06-01'·이중계상 방지).

## 컨펌 인계 (Phase B Q-A 미해소)

- Q-A3 좌표 siz 전건 106 — 채택(설계 권고, DRY-RUN 무손실 입증).
- Q-A4 REVERSED 2종 — 보수적 신규 제외(EXACT 4만 재사용, 106 신규에 REVERSED 미포함). 컨펌 시 추가 재사용/신규 조정.
- Q-A5 귀돌이 통합 — 보류(별 comp 유지, U-단위 미생성). 형상=공정종류.
- Q-A7 WHITE 유지 규칙 — **PROC_000008(화이트) 유지로 확정**(설계 "임의 1행"을 정정).
- Q-A8 U6 공식 = 소재별 분리 채택. webadmin Phase11 엔진 미구현 시 실청구 0(배선은 견적 성립 전제).
