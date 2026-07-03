# 077 레더 하드커버책자 — 면지 통합 재설계 골든 재현(무손상 입증) DRY-RUN

> §23 · 2026-07-03 · 라이브 엔진 `evaluate_set_price` 실호출(`_workspace/_foundation/batch` lib_huni·`.env.local`). 라이브 읽기전용.
> 072 파일럿 동형 전파. 재현 스크립트 = 072 `_repro.py PRD_000077`(구조 diff) + 본 문서 조건별 실측.

## 1. 현행 골든 = 라이브 실측 (재설계 전)

077 셋트공식 = **PRF_HC_MUSEON_SET**(= 072와 동일 공유공식) → 단일 comp **COMP_HC_MUSEON_COVERBIND**(use_dims=`["min_qty"]`, 자재 미종속). 면지 멤버 079/080/081 = 공식 없음 → 기여 **정확히 0**.

### 1-a. 하네스 골든 스캐너 (`set_full_scan.py` · COPIES=100 · 내지 derived24) — 권위 스캔
| prd | final | set_eval | 멤버 기여 |
|---|---|---|---|
| PRD_000077 | **806,119** | 796,900 | 078:0 · 285(내지):9,219 · 079:0 · 080:0 · 081:0 |

- final 806,119 = set_eval(796,900) + 내지 285(9,219). 표지 078·면지 079/080/081 = 전부 0.
- ※ `set_full_scan.py` GOLDEN 딕셔너리의 51146은 **A4·30p·qty1 조건의 동작화 골든(2026-07-01 [[leather-hardcover-077-live-commit-260701]])** — 스캐너 COPIES=100 조건과 달라 `!=gold` 플래그가 뜨는 건 조건 차이(스테일 엔트리)이지 결함 아님. 무손상 판정은 **동일 조건 전후 대조**로 한다.

### 1-b. 동작화 골든 조건(qty1·30p·derived) 재현 — `_repro077g.py`
| 케이스 | 멤버 | final(qty1·30p) | 면지 기여 |
|---|---|---|---|
| BASELINE | 078+285+079+080+081 | 34,346 | 0/0/0 |
| REDESIGN | 078+285+079 | 34,346 | 0 |
| SANITY | 078+285 (면지 0) | 34,346 | — |

## 2. 재설계 후 = 참 골든 불변 (구조 diff 실증)

면지 멤버 3→1→0 전 케이스에서 final **완전 동일**(2개 조건 교차):

| 조건 | BASELINE(면지3) | REDESIGN(면지1=079) | SANITY(면지0) | 판정 |
|---|---|---|---|---|
| qty1 · 30p derived | 34,346 | **34,346** | 34,346 | 불변 ✓ |
| qty100 · 24p derived | 815,338 | **815,338** | 815,338 | 불변 ✓ |
| 하네스 스캔 qty100 · 24p (set_procs 포함) | 806,119 | **806,119(예상)** | 806,119 | 불변 ✓ |

→ 면지 멤버 079/080/081 기여 = 정확히 0(공식 없음 → 자재 유무·색 선택 무관). 3→1 통합 가격영향 0.
- ※ 절대값이 조건별로 다른 이유(34,346 vs 815,338 vs 806,119)는 copies·pages·set_procs·coat 등 **시뮬레이션 파라미터** 차이이지 재설계와 무관. 무손상의 자 = **같은 조건 내 BASELINE=REDESIGN=SANITY 동일성**(전 조건 성립).

## 3. 부모 077 자재/옵션 은퇴 무손상 (구조적 증명)

- 셋트공식 comp **COMP_HC_MUSEON_COVERBIND** use_dims=`["min_qty"]` — siz_cd/print_opt_cd/bdl_qty/mat_cd 없음. `set_selections_for(077)` = **빈 셀렉션** → 부모 077 USAGE.03 면지자재·OPT_065는 셋트공식 입력에 **전혀 안 들어감**.
- 하네스 스캔 golden 806,119 = set_eval(796,900·COVERBIND@min_qty) + 내지 285(9,219). 둘 다 부모 077 면지자재·면지옵션 미참조 → 은퇴 가격중립.
- **077 부모엔 USAGE.07 자재 없음**(082/088과 달리) → USAGE.03만 은퇴, 불가침 자재 이슈 0. 072와 완전 동형.

## 4. 롤백전용 DRY-RUN 실증 (BEGIN…ROLLBACK · 2026-07-03)

`apply-077.sql` 2회 연속 apply 후 상태 검사 → ROLLBACK. 결과:
- pass1: UPDATE1 / INSERT3·1·3·3 / UPDATE3·3·1·3·2·2 (11스텝 정상).
- **pass2 멱등**: 리네임 UPDATE 0·부모은퇴 UPDATE 0·ON CONFLICT INSERT delta 0 → 2회차 상태 변화 없음.
- **트리거 fn_chk_opt_item_ref 통과**(에러 0) — 자재[2] 선행 → 옵션아이템[5] 참조 무결.
- 사후 상태: 079='레더 하드커버책자-면지'·자재3·옵션3·아이템3 활성 / 077 USAGE.03=0·OPT_065=0(은퇴) / 활성멤버=078·285·079 / 080·081 use_yn=N.
- ROLLBACK 후 비영속(이전상태 유지: 079/080/081 del_yn=N 전부 복원).

## 5. 무손상 판정

- **final_price 불변**: 전 조건 BASELINE=REDESIGN=SANITY 동일(면지 기여 0).
- **셋트공식 자재 미종속**(COVERBIND use_dims=[min_qty]) → 부모 면지자재/옵션 은퇴 가격중립.
- **이중합산 0**: 면지비 이중 계상 없음(면지=제본비 포함 도메인·기여 0).
- **PRICE≠0**: 806,119(하네스)·34,346(qty1)·전 케이스 final>0.
- **이전 077 동작화 COMMIT 보존**: PRF_HC_MUSEON_SET 바인딩·내지 285·COVERBIND 미변경.

→ **S4(가격 e2e) 무손상 통과 예상.** 실 게이트는 `hsp-set-gate-validation`이 evaluate_set_price 독립 재계산 + DRY-RUN으로 재판정.

## 6. 게이트 인계 체크리스트
- [x] apply-077.sql 롤백전용 DRY-RUN 멱등·트리거 통과 확인(§4).
- [ ] 재설계 후 라이브 골든(하네스 스캔 806,119) 재계산 일치 — 게이트가 커밋 DRY-RUN 상태에서 set_full_scan 재실행으로 확인.
- [ ] 079 자재 드롭다운(화/블/그) 렌더·fn_chk_opt_item_ref 위반 0.
- [ ] 인간 승인 후 webadmin 실화면(제외 0·PRICE≠0·판형 자동선택).
