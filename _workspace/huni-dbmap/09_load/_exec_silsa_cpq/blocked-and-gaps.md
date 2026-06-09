# 차단·GAP — 일반현수막(PRD_000138) CPQ v2 + mint 패키지

> 침묵 드롭 0 원칙. 본 패키지(`apply.sql`)에 들어가지 않은 행/결정은 전부 여기에 사유+해소조건과 함께 명시.
> mint 마스터(자재 4·공정 1)는 본 라운드 적재 대상(사용자 "BLOCKED master-data 결정·적재" 승인)이므로 차단 아님.

## 1. BLOCKED — 본 트랜잭션 미포함

| 항목 | 테이블 | 차단 사유 | 해소 조건(unblock) | 위치 |
|---|---|---|---|---|
| R-GAKMOK constraint (RULE_001) | t_prd_product_constraints | ~~siz 76규격 의존~~ → **폐기(2026-06-09 사용자 확정)**. 각목을 방향(세로/가로) 옵션으로 재모델하니 각목 길이가 변 치수에서 도출돼 높이-매칭 제약이 원천 불필요. 900이하/초과=길이 가격구간→가격엔진 length-tier(제약 아님). | **RESOLVED — 제약 폐기.** 라이브 미적재(0행)였으므로 DB 조치 없음. 재모델=`09_load/_exec_silsa_cpq_remodel/`(COMMIT 완료) | `_blocked/08`(폐기·미적용) |

> 본 패키지가 prior `_exec_silsa_banner` 대비 BLOCKED를 **9 items → 0 items**로 줄인 이유: 자재 4 mint + 공정 1 mint + 링크 7을 같은 트랜잭션에 선행시켜 트리거 `fn_chk_opt_item_ref`의 자재(.03)·공정(.04) 차원행 EXISTS 선행조건을 충족 → 자재 seq 9 + 열재단 1이 INSERTABLE로 승격. 잔존 BLOCKED는 constraint 1건뿐(siz 차원 의존).

## 2. [CONFIRM] — 적재되나 의미 라벨 미확정 (인간 결정 잔존, 적재 차단 아님)

| # | 항목 | 적재 상태 | 잔존 결정 |
|---|---|---|---|
| C-1 | 큐방 부착 enum | 자재 MAT_000337 mint·링크·옵션아이템(큐방 .03 + 부착 .04) 전부 적재 | 공정 `PROC_000081 {대상}` enum에 `큐방` 부재(라이브). enum 확장 vs 기존 라벨 환원 = 인간 결정. option_items의 부착 공정 행은 `대상` 파라미터를 저장하지 않으므로(트리거는 proc_cd EXISTS만 검사) 적재엔 무영향 — note에 보존. |
| C-2 | 양면테입→테입 enum | 자재 MAT_000069 링크·옵션아이템 적재 | 공정 param `{대상:테입}` 해석(enum `양면테입` 추가 vs `테입` 환원). 적재 무영향(note 보존). |

## 3. GAP

| # | GAP | 본 적재 처리 | 근본 해소(타 트랙) |
|---|---|---|---|
| GAP-PARAM (D-1) | 타공 구수(4/6/8)·각목 규격(900이하/초과) 의미 라벨 보존처(`ref_param_json`) 부재 | **우회 표현**: 타공은 별 옵션 3개(타공4/6/8 = OPV_000007~9), 각목은 별 mat_cd 2개(MAT_000338/339). 의미가 코드/이름에 흡수돼 손실 없음 | `ref_param_json` 컬럼 신설 = `dbm-ddl-proposer` 트랙(제안·인간승인) |
| 사이즈 76규격 | siz 4 존재·76 미등록(가격트랙) | option_items에 size(.01) seq 미포함(가격트랙 소관) — silsa 옵션레이어는 size를 가리키지 않음. R-GAKMOK constraint만 siz 의존(위 BLOCKED) | 가격트랙 siz 등록(인간승인) |

## 4. 적재된 mint (차단 아님 — 본 라운드 승인 대상)

| 코드 | 이름 | search-before-mint(2026-06-09 live) |
|---|---|---|
| MAT_000337 큐방 / MAT_000338 각목(900이하) / MAT_000339 각목(900초과) / MAT_000340 봉제사 | (MAT_TYPE.07 부속) | `mat_nm ~ 큐방|각목|봉제사…` → **0행** 재확인 → mint 정당(발명 아님) |
| PROC_000084 열재단 | (공정·flat) | `proc_nm ~ 열재단` → **0행** → mint(M-1 ①) |

> 실재 자재(끈 MAT_000070·양면테입 MAT_000069)는 live EXISTS 재확인 → **LINK only(mint 안 함)**. 과적재·중복 mint 0.
