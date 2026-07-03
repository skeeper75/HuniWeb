# reconcile — Claude(라이브 실측) ↔ codex(코드 가설) · 072 면지 통합 재설계

> §23 · 2026-07-03 · 라이브 읽기전용(`RAILWAY_DB_*`) evaluate_set_price 실호출 + 스키마/코드 실측.
> 원칙[HARD]: codex 주장=가설. 합의=고신뢰. codex UNCERTAIN·신규 후보는 **라이브로 최종 판정**. 판정 권위=라이브/골든/권위, codex 아님.

## 0. 종합 판정
- **codex DISAGREE 0** — 재설계 방향 합의. codex가 낸 UNCERTAIN 2건·완결성 갭 3건(Top3)을 **라이브 실측으로 전부 닫음**.
- **골든 무손상 = 수렴 CONFIRMED** · **오차단 0 = 수렴 CONFIRMED**.
- **S1~S8 게이트로 넘길 준비 = 됨**(게이트는 evaluate_set_price 독립 재계산 + 롤백 DRY-RUN으로 재판정).

## 1. 라이브 실측 근거 (핵심 사실)

| 사실 | 라이브 실측값 | 출처 |
|---|---|---|
| set_contrib(034100/159100/796900) | BASELINE(5멤버)=REDESIGN(3멤버)=SANITY(2멤버) **전부 동일** | `_repro.py PRD_000072` 실호출 |
| 면지 074/075/076 기여 | 각 **0**(전 케이스) | 동상 members contribution |
| 074/075/076 공식 행 | 0 / 0 / 0 | t_prd_product_price_formulas |
| 074/075/076 직접단가 행 | **0 / 0 / 0** (codex#1 갭) | t_prd_product_prices |
| 073 표지: 자재1개·공식0 → 기여 | 자재 있음·공식0 → **기여 0**(실측) | 멤버-무공식=0 **실증 오라클** |
| PRF_HC_MUSEON_SET use_dims | `["min_qty"]` 자재 미종속 | t_prc_formula_components(COMP_HC_MUSEON_COVERBIND) |
| 부모 072 면지자재/옵션 | MAT_382/383/384 USAGE.03 + OPT_064(OPV_434/435/436→382/383/384) 실재 | t_prd_product_* |
| fn_chk_opt_item_ref | OPT_REF_DIM.03=같은 prd_cd의 (mat_cd,usage_cd) 실재검사·**del_yn 무필터**·BEFORE INS/UPD | pg_get_functiondef |
| 075/076 전역 역참조 | sub_prd_cd(072)만·opt_item ref0·tpl_sel ref0·constraint logic0·owned payload 0(11테이블) | 전수 스윕 |

## 2. codex 항목별 reconcile

### #1 골든 무손상 — codex AGREE(일부 안일) → **라이브 CONFIRMED (갭 닫음)**
- codex의 정당한 지적: evaluate_price가 공식 전 **직접단가 우선**(pricing.py:468-474) → 공식0만으론 기여0 미보장.
- **라이브 판정**: 074/075/076 **직접단가 0행 + 공식 0행** 확증 → base_amount=0(pricing.py:490-496 NONE 경로). 073(자재보유·공식0→기여0)이 "멤버-무공식=0"을 **실증**. 자재를 074에 이관해도 074는 공식·직접단가 모두 없음 → 기여 정확히 0. set_contrib 불변(라이브 실호출). **이중합산 0·누락 0.**
- 설계 문구 정정 권고(비차단): spec의 "면지 멤버는 공식이 없어 기여 0" → "**공식 없음 + 직접단가 없음** → 기여 0"으로 정밀화(결론 동일).

### #2 트리거 순서 — codex AGREE → **라이브 CONFIRMED**
- 트리거 실본문 확인: OPT_REF_DIM.03은 같은 prd_cd 자재 실재 검사. apply [2]자재→[5]옵션아이템 순서로 트리거 통과. 부모 은퇴 [6]옵션(자재 아직 실재)→[7]자재 순서 안전. 트리거 del_yn 무필터라 은퇴 후에도 미래 UPDATE 트리거 통과(물리행 존재). undo도 [7→]자재복원→[6→]옵션복원 순서 안전. FK 파손 0.

### #3 075/076 은퇴 무결성 — codex UNCERTAIN → **라이브 CONFIRMED (갭 닫음)**
- codex가 요구한 전역 역참조를 전수 스윕: 075/076은 **오직 072의 sub_prd_cd**로만 참조(=은퇴 대상). option_items ref_key1(셋트ref) 0·template_selections ref 0·constraint logic 0·11개 t_prd_product_* 테이블 owned-row 0. → del_yn=Y(셋트링크)+use_yn=N(마스터) 안전. 고아·댕글링 0.

### #4 색 택1 자재 드롭다운·오차단 — codex AGREE → **라이브/코드 CONFIRMED · 오차단 0**
- `_set_members_meta`(price_views.py:1740-1753)는 멤버 materials 동봉·opt_groups 미동봉. renderInsts(price_simulator.html:686-710)가 멤버 카드에 "용지" 드롭다운 렌더 + defaultDimValue로 dflt(화이트) 사전선택. 제출 시 mat_cd 멤버 selection 전송.
- **오차단 판정[HARD]**: 이관 후 074 멤버 카드에 화(dflt)/블/그 3자재 드롭다운 발현 → 손님 택1 **가능**. **선택지 손실 0**. 오히려 현재(빈멤버 3장=혼란) → 1멤버+드롭다운으로 **UX 개선**. 이관 옵션그룹은 시뮬레이터 휴면이나 색 택1은 자재가 담당하므로 무해.
- **잔여(비차단)**: 위젯/주문 경로가 구성원 materials/opt_groups를 읽는지는 별개 = **D-1 DEV-REQUEST**(설계가 이미 격상). 074 무공식이라 mat 선택은 가격중립 → 실효는 생산 descriptor.

### #5 계열 전파 — codex UNCERTAIN → **부분 수렴 (072만 GO)**
- 072 파일럿: 라이브 GO. 077/082/088 전파는 설계도 "per-set 골든 재현 선행 필수"로 명시(spec:109). codex 우려 타당 → 전파 시 각 셋트 per-set: ① 면지멤버 직접단가+공식 0 확인 ② 은퇴 대상 전역 역참조 스윕 ③ USAGE.07 불가침(082 MAT_013/14/15·088 MAT_247/248/249) ④ 088은 표지멤버 재설계(089/싸바리) **적재 승인 대기와 조율**(충돌 회피). MAT_385 인쇄면지 인쇄비0=D-3 선존이슈(무손상 보존만·차단 아님).

## 3. 조사 큐 → 라우팅

| 후보 | 상태 | 라우팅 |
|---|---|---|
| C-1 직접단가 0 확인(codex#1) | **CLOSED**(074/075/076=0행 실측) | — |
| C-2 075/076 전역 역참조(codex#2) | **CLOSED**(전수 스윕 0) | — |
| C-3 위젯/주문 경로 materials/opt 보존(codex#3·#4) | OPEN(비차단·가격중립) | D-1 DEV-REQUEST(§6·코드 보강) |
| C-4 spec 문구 "공식없어 0"→"공식+직접단가 없어 0" | 정정 권고(비차단) | set-designer 미세 보정 |
| C-5 077/082/088 per-set 전파(codex#5) | OPEN(계획됨) | 072 GO 후 동형 4스텝·per-set 골든 |

## 4. 게이트 인계
- **S1~S8 넘길 준비 = 됨.** codex DISAGREE 0·UNCERTAIN 전부 라이브로 닫힘.
- 게이트 필수 재판정(독립): ① apply.sql 롤백 DRY-RUN(BEGIN…ROLLBACK) 멱등·트리거 통과 ② 재설계 후 evaluate_set_price 재계산 34,100/159,100/796,900 일치 ③ 074 자재 드롭다운·fn_chk_opt_item_ref 위반0 ④ 075/076 역참조0(재확인) ⑤ 인간 승인 후 webadmin 실화면(제외0·PRICE≠0·판형 자동선택).
- COMMIT 승인 전제: C-4 문구 정정(선택)·C-3/C-5는 후속 트랙(비차단).
