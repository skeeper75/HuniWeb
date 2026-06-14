# `_exec_tierA_digitalprint` — BLOCKED · [CONFIRM] · GAP

> round-6 Tier A 14상품. 차원행 0행 참조 option_item = BLOCKED(트리거 REJECT 예정·발명 금지). GAP은 `dbm-ddl-proposer` 입력.

## 1. BLOCKED (차원행 부재 — 적재 대상 아님 · `_blocked/` 격리)

| prd_cd | 옵션 | ref | 차원행 상태 | 사유 |
|---|---|---|---|---|
| PRD_000027 | 접지 2단 가로접지 | .04 PROC_000065 | 라이브 미링크 | 접지공정(065~068) processes 미적재 |
| PRD_000027 | 접지 2단 세로접지 | .04 PROC_000066 | 라이브 미링크 | 동상 |
| PRD_000029 | 접지 3단 가로접지 | .04 PROC_000067 | 라이브 미링크 | 동상 |
| PRD_000029 | 접지 3단 세로접지 | .04 PROC_000068 | 라이브 미링크 | 동상 |
| PRD_000024 | 화이트별색 화이트인쇄(단면) | .04 [CONFIRM] | 라이브 미링크 | 화이트 별색공정 processes 미적재·공정코드 미상 |
| PRD_000025 | 화이트별색 화이트인쇄(단면) | .04 [CONFIRM] | 라이브 미링크 | 동상 |

> BLOCKED 6행 = 접지 4 + 화이트별색 2. **option_groups/options 헤더는 적재**(트리거 없음)되나, option_item(차원행 포인터)만 BLOCKED. L1 선적재(인간 승인) 후 별도 적재.
> **접지 GAP-B(사이즈연동 동적 freeze):** L1 접지는 "2단 가로접지 ★사이즈선택 : 150x100 / 135x135 / 170x110" = 본체 사이즈에 따른 동적 freeze. 현 옵션 모델 미지원(postcard GAP-B 동형).

## 2. [CONFIRM] (라이브 미상 — 발명 금지)

| # | 항목 | 내용 | 해소 경로 |
|---|---|---|---|
| C-1 | 화이트별색 공정코드 | 024/025 "화이트인쇄(단면)" 공정 라이브 미링크·코드 미상 | 화이트 별색공정 L1 선적재 + 코드 확정(dbm-schema-analyst) |
| C-2 | 사이즈 option_group 노출 | 사이즈(차원행 실재)를 option_group 으로 노출할지 — UI 정책. 본 파일럿 미생성(postcard 계승) | UI 정책 결정(리드) |
| C-3 | 종이 opt_nm = mat_cd | 종이 옵션명을 mat_cd 로 부여(이름키 안정). UI 표시명은 별도 mat_nm 조인 | 표시명 정책 — option_nm vs 조인 |

## 3. GAP (→ dbm-ddl-proposer · attribute-entity-map §4 정합)

| GAP | 내용 | 영향(본 14상품) | 상태 |
|---|---|---|---|
| **GAP-PARAM** | ref_param_json 부재 → 코팅 면구분(단/양면)·후가공 줄수(오시/미싱 1~3줄)·가변 개수(1~3개)·박크기 보존 불가 | 017/032/047 코팅 면 · 016/018/041/042 후가공 줄수 · 027/029/031/033/047 가변 · 박칼라 크기 | 신규 컬럼 vs qty(불가·smear 금지) |
| **GAP-JEOPJI-DIM** | 접지 공정(065~068) processes 미적재 → 접지 옵션 BLOCKED | 027/029 | 접지 공정 L1 선적재 |
| **GAP-WHITE** | 화이트 별색공정 미적재 → 화이트별색 BLOCKED | 024/025 | 화이트 별색공정 L1 선적재+코드 |
| **GAP-COATING-SIDE** | 코팅 "유광코팅(단면)/유광코팅(양면)" 4종이 라이브 공정 2개(유광014/무광015)로 면구분 손실 | 017/032/047 | GAP-PARAM 의 코팅 특수형 |
| **GAP-BAK-COMPOSITE** | 박 = 박가공+박크기+박칼라 composite. 라이브는 박칼라 공정 8종만(박가공 토글·크기 param 부재) | 027/029/031/042 | 박크기=GAP-PARAM·박가공 토글=센티넬(박없음)로 표현 |

## 4. 더미 정리 (인간 승인 · `_cleanup_dummy.sql`)

| prd_cd | 더미 | 코드체계 | 처리 |
|---|---|---|---|
| PRD_000016 | OPT-000005(후가공) + OPV-000007~010 + option_items 7행 | OPT-/OPV- 하이픈(우리 설계 아님) | DELETE(인간 승인) |
| PRD_000025 | RULE_001(금지테스트) constraint | — | DELETE(인간 승인) |

> 우리 정식 옵션레이어(OPT_/OPV_ 언더스코어)는 멱등 이름검사라 더미와 **충돌 없음**(공존 가능). 단 더미 잔존은 UI 혼란 → 별도 SQL 인간 승인 정리. **자동 삭제 금지**(apply.sql 미포함).
