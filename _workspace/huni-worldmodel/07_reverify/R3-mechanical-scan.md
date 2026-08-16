# R3 기계 실측 — SPEC-WORLDMODEL-001 인용·추적성·코드 앵커 (mechanical scan)

- 측정 대상: `.moai/specs/SPEC-WORLDMODEL-001/spec·plan·acceptance.md` (체크아웃 HEAD a509e52a)
- 방법: 결정론 스크립트(`_scripts/r3_scan_a.py`·`r3_scan_b.py`) — 정규식 인용 추출 → 경로 해석 → 라인 실재 → 토큰/문구 부분문자열 대조. LLM 눈대중 집계 0.
- 규율 준수: `raw/webadmin/**`·SPEC 문서·라이브 DB 읽기 전용(SELECT 0회 접근). 쓰기는 본 파일과 `_scripts/` 산출물뿐.

---

## ① 요약 수치

| 검사 | 결과 |
|---|---|
| A. 인용 좌표(`파일:라인`) 총 추출 | **586건** (spec 318 · plan 165 · acceptance 103) |
| A-OK(좌표+내용 확인) | 기계 216 + 수동 12(MISMATCH 오탐) + 수동 46(py LD 오탐) = **274건** |
| A-OK_COORD(좌표만 확인·내용대조 불가) | 147건 |
| A-LINE_DRIFT(줄 밀림) | 스캔 200건 중 py 대상 48행 전수 대조 → 오탐 46행 제외 → **154건 + 재분류 3건 = 157건**(진짜 확정 예: `widget_api.py:1148`→1150·DF 6사례·plan→spec 3건). **design-FINAL.md 관련 84건이 최대 군집** |
| A-MISMATCH(내용 불부합 확정) | 스캔 15건 중 **진짜 1건**(plan.md:158 `spec.md:178` — `PICK→PR→RG` 문언이 현 spec.md에 0건) · 오탐 12건 OK · 2건 LINE_DRIFT 정정 |
| A-MISSING / UNRESOLVED | 스캔 MISSING 1건·귀속불가 7건 — **전건 수동 귀속·진좌표 특정 완료**(파일·줄 진짜 부재 0건) |
| A-py 인용 좌표 신뢰도 | LD 의심 py 행 48행 전수 원문 대조 — **오탭 46행(95%)·진짜 2행**. 코드 좌표 인용은 사실상 정확 |
| B. 요구사항 재집계 | **SPEC 주장 4종 전부 실측 일치** — 64건(U44·X11·E7·O1·S1) · 직접 51 · 간접 9 · 미커버 4(6.25%) · 유령 ID 0 |
| C. 코드 앵커 6종+CS2-01 좌표 | **전건 실재·좌표 정확** (C 결과표 참조) |

---

## ② A. 인용 좌표 전수 실재성

### 분류 정의

- `OK` — 인용 줄에 주장 토큰/문구가 실재(부분문자열 기계 확인). `OK(수동)` — 스크립트 미탐, 원문 sed/grep 대사로 확인.
- `OK_COORD` — 파일·라인 실재. 내용대조에 쓸 토큰/문구가 근원 문맥에 없어 기계 대조 불가(결함 아님·측정 한계).
- `LINE_DRIFT` — 파일은 맞고 인용 줄에 근거 없음; 주장 토큰/문구가 파일 **내 다른 위치**에 존재(=줄 밀림).
- `MISMATCH` — 줄은 있으나 주장 토큰/문구가 파일 전체에 부재.
- `MISSING` — 파일 부재 또는 인용 줄 > 파일 행수.

### 집계(스캔 원값 → 수동 재판정 보정)

| 분류 | 스캔 | 재판정 보정 | 비고 |
|---|---:|---|---|
| OK | 216 | +12 +46 | MISMATCH 오탐 12건 + py LD 오탭 46행 원문 대사로 OK 확정 |
| OK_COORD | 147 | 불변 | 좌표 실재만 확인 |
| LINE_DRIFT | 200 | −46+3 | py 오탭 46행 제외 · MISMATCH 2건·MISSING 1건 재분류. 별도 수동 확인: plan→spec 3건·py 2행(1148) |
| MISMATCH | 15 | −14 | 진짜 잔여 1건(plan.md:158 `spec.md:178`) |
| MISSING | 1 | −1 | plan.md:94 `:622` — 귀속오류, 진타겟 design-FINAL:903 실재 |
| UNRESOLVED_IMPLICIT | 7 | −7 | 전건 진타겟 design-FINAL로 수동 귀속 |

### design-FINAL.md 인용 — 핵심 위험 실측

design-FINAL.md 인용 총 **104건**(파일 현재 1,203행; 804→1,046→1,123→1,203으로 성장). 내용까지 기계 확인된 것 **2건**, 좌표만 확인 **18건**, **LINE_DRIFT 84건(전체 인용의 80%)** — 개정으로 줄이 밀린 인용이 압도적이다. 수동 확정된 대표 사례(원문 대사):

| 인용(출처) | 인용 줄 현재 내용 | 현재 올바른 좌표(수동 확정) |
|---|---|---|
| `design-FINAL.md:324` (spec.md:100) |   "provenance": {"utterance_id": str, "turn": int, "utteranc | 현재 356-357행(FIX-1 부기 · 주장 1(C1) 판정 기록). 324행은 Intent provenance 스키마 |
| `design-FINAL.md:789` (spec.md:100) | --- | 현재 789-791행 = `## 7. 단계별 도입 순서` 헤딩. 주장 1 반증조건 문언은 §9 부기(후보 926행) |
| `design-FINAL.md:791` (spec.md:100) | ## 7. 단계별 도입 순서 | 상동 |
| `design-FINAL.md:17` (spec.md:69) | (내용 없음/빈 줄) | "사이드카 저장소만" 문구 현재 76-77행 |
| `design-FINAL.md:740` (spec.md:560) | "고급스럽게"는 값이 아니라 `soft_prefs`로 착지한다. "5만원"은 `budget_krw`로 들어가 | "G0~G10 전건" 현재 871/884행(게이트표 RULE-05/RULE-18 행) |
| `design-FINAL.md:281` (spec.md:560) | ｜ F5 ｜ `loop.rollout()` ｜ worldmodel ｜ 후보 배치 부작용 0 실행 ｜ 동일 ｜ | F18 행 현재 295행(`:740` 불일치 자기 인용 포함) |

M0 교정 지시의 암묵 `:N` 인용 7건+1건(스캔 UNRESOLVED/MISSING)도 진타겟이 전부 design-FINAL.md이며 현재 좌표를 특정했다:

| 근원 | 암묵 인용 | 진타겟 현재 좌표(수동 확정) |
|---|---|---|
| plan.md:105 | `:389` | 진타겟 design-FINAL.md — esc_kind 7종 현재 639행(`★ FIX-6 — esc_kind 7종`) |
| plan.md:105 | `:601` | 진타겟 design-FINAL.md — "6종" 문언 현재 639행(`개정 전 6종에 PREMISE_FAIL 누락`) |
| plan.md:106 | `:393` | 진타겟 design-FINAL.md — route_to 게이트별 3행 현재 656-658행(PREMISE_FAIL G0/G0.5a·b/G0.9) |
| plan.md:106 | `:565` | 진타겟 design-FINAL.md — 소비 표면 3열 문언 현재 647-649행(N3 정정 + 매핑표 헤더) |
| plan.md:109 | `:51` | 진타겟 design-FINAL.md — "미보유 셀은 None 명시" 현재 454행(★ FIX-7 폴백 사다리) |
| plan.md:109 | `:598` | 진타겟 design-FINAL.md — 상동 454행(및 877행 RULE-11 행) |
| acceptance.md:319 | `:740` | 진타겟 design-FINAL.md — "게이트표 G0~G10 전건" 현재 871/884행(DF:295에 `:740` 자기 인용 잔존) |

#### design-FINAL.md LINE_DRIFT 전건 목록

| 근원 | 인용 | 스크립트가 찾은 현재 위치 후보 |
|---|---|---|
| spec.md:22 | `design-FINAL.md:1031` | 인용 줄에 근거 없음; 파일 내 위치: 05_gate/*→[1170, 1187]; FIX-1→[18, 22, 36, 44] |
| spec.md:54 | `design-FINAL.md:17` | §12 헤딩 위치 [1108] |
| spec.md:54 | `design-FINAL.md:776` | §12 헤딩 위치 [1108] |
| spec.md:69 | `design-FINAL.md:17` | 인용 줄에 근거 없음; 파일 내 위치: 문구[사이드카 저장소만]→[76] |
| spec.md:71 | `design-FINAL.md:59` | 인용 줄에 근거 없음; 파일 내 위치: 문구[각각 유발하므로 둘 다]→[77]; 문구[과 양립하지 않는다]→[77] |
| spec.md:100 | `design-FINAL.md:324` | 인용 줄에 근거 없음; 파일 내 위치: JointTransition→[201, 277, 494, 799]; 문구[조립만으로 프론티어 스윕이 성립하지 ]→[926] |
| spec.md:100 | `design-FINAL.md:791` | 인용 줄에 근거 없음; 파일 내 위치: JointTransition→[201, 277, 494, 799]; 문구[조립만으로 프론티어 스윕이 성립하지 ]→[926] |
| spec.md:100 | `design-FINAL.md:789` | 인용 줄에 근거 없음; 파일 내 위치: JointTransition→[201, 277, 494, 799]; 문구[조립만으로 프론티어 스윕이 성립하지 ]→[926] |
| spec.md:529 | `design-FINAL.md:930` | 인용 줄에 근거 없음; 파일 내 위치: gap_owner→[165, 647, 880, 1067]; 문구[쌓인 항목을 누가 언제 비우는가]→[660, 1067]; 문구[의 운영 실체는 완전하지 않다]→[1067] |
| spec.md:531 | `design-FINAL.md:1001` | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[77, 230, 299, 426]; /validate→[16, 37, 77, 702]; 문구[의 반증 조건을 측정 없이 남겨 두는]→[1138]; 문구[이며 게이트도 보충 검증도 확인하지 ]→[1138] |
| spec.md:558 | `design-FINAL.md:306` | 인용 줄에 근거 없음; 파일 내 위치: mat_grade→[50, 56, 372, 742]; mat_cd→[346, 350, 383, 592] |
| spec.md:560 | `design-FINAL.md:740` | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[295, 871, 884]; payable_parity→[295, 299, 301, 856]; 문구[자기 선언 갱신]→[57] |
| spec.md:560 | `design-FINAL.md:281` | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[295, 871, 884]; payable_parity→[295, 299, 301, 856]; 문구[자기 선언 갱신]→[57] |
| spec.md:569 | `design-FINAL.md:1043` | 인용 줄에 근거 없음; 파일 내 위치: 문구[이며 게이트가 지시한 교정 범위 밖이]→[1197]; 문구[관측 가능한 부작용 축]→[1197] |
| spec.md:570 | `design-FINAL.md:324` | 인용 줄에 근거 없음; 파일 내 위치: 문구[재배선이며 신규 도메인 규칙 작성이 ]→[567, 922, 924]; 문구[강도는 약화된다]→[357, 922] |
| spec.md:570 | `design-FINAL.md:789` | 인용 줄에 근거 없음; 파일 내 위치: 문구[재배선이며 신규 도메인 규칙 작성이 ]→[567, 922, 924] |
| spec.md:571 | `design-FINAL.md:350` | 인용 줄에 근거 없음; 파일 내 위치: blockers[].id = rule_cd→[516, 519]; _sim_disallowed→[83, 110, 152, 215]; 문구[그것도 비면 문자열]→[501]; 문구[가 반환하는 것은]→[876] |
| spec.md:572 | `design-FINAL.md:459` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294]; projection map→[24, 298, 301, 586]; 문구[단일 정의처 지위]→[301] |
| spec.md:572 | `design-FINAL.md:747` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294]; projection map→[24, 298, 301, 586] |
| spec.md:572 | `design-FINAL.md:725` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294]; projection map→[24, 298, 301, 586]; 문구[단일 정의처 지위]→[301] |
| spec.md:572 | `design-FINAL.md:277` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294]; projection map→[24, 298, 301, 586]; 문구[단일 정의처 지위]→[301] |
| spec.md:572 | `design-FINAL.md:740` | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[295, 871, 884]; payable_parity→[295, 299, 301, 856] |
| spec.md:572 | `design-FINAL.md:281` | §4.0 헤딩 위치 [273] |
| spec.md:596 | `design-FINAL.md:92` | 인용 줄에 근거 없음; 파일 내 위치: CS2-01→[516, 561, 876, 908] |
| spec.md:616 | `design-FINAL.md:745` | 인용 줄에 근거 없음; 파일 내 위치: CS2-01→[516, 561, 876, 908]; rule_cd→[58, 110, 414, 415] |
| spec.md:616 | `design-FINAL.md:757` | 인용 줄에 근거 없음; 파일 내 위치: rule_cd→[58, 110, 414, 415]; CS2-01→[516, 561, 876, 908] |
| spec.md:630 | `design-FINAL.md:1016` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325]; FIX-1→[18, 22, 36, 44] |
| spec.md:631 | `design-FINAL.md:1017` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844]; FIX-3→[24, 114, 164, 294]; 문구[게이트 명세 교정]→[1154] |
| spec.md:683 | `design-FINAL.md:306` | 인용 줄에 근거 없음; 파일 내 위치: mat_grade→[50, 56, 372, 742]; mat_cd→[346, 350, 383, 592] |
| spec.md:710 | `design-FINAL.md:1027` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325]; FIX-1→[18, 22, 36, 44]; 문구[구현 단계에서 이 선언과 어긋나면]→[64, 1166] |
| spec.md:752 | `design-FINAL.md:878` | §12 헤딩 위치 [1108] |
| spec.md:752 | `design-FINAL.md:992` | §12 헤딩 위치 [1108] |
| spec.md:762 | `design-FINAL.md:111` | 인용 줄에 근거 없음; 파일 내 위치: site.register→[129]; admin.site.register→[129] |
| spec.md:762 | `design-FINAL.md:872` | 인용 줄에 근거 없음; 파일 내 위치: site.register→[129]; admin.site.register→[129] |
| spec.md:763 | `design-FINAL.md:111` | 인용 줄에 근거 없음; 파일 내 위치: t_prd_product_constraints→[502, 539, 567, 580] |
| spec.md:764 | `design-FINAL.md:872` | 인용 줄에 근거 없음; 파일 내 위치: 문구[견적 실체 테이블 부재]→[670] |
| spec.md:775 | `design-FINAL.md:111` | 인용 줄에 근거 없음; 파일 내 위치: raw/webadmin→[6, 74, 129, 502]; t_wm_*→[129, 1119]; 문구[에 추가하는 것은]→[129] |
| spec.md:778 | `design-FINAL.md:872` | 인용 줄에 근거 없음; 파일 내 위치: 문구[벌 신설은 채택하지 않는다]→[1009] |
| spec.md:794 | `design-FINAL.md:479-496` | 인용 줄에 근거 없음; 파일 내 위치: soft_prefs→[56, 64, 292, 317]; 문구[의 실질적 방어선이다]→[623]; 문구[가중치에만 들어간다]→[399] |
| spec.md:799 | `design-FINAL.md:865` | 인용 줄에 근거 없음; 파일 내 위치: sim_escalation→[60, 111, 165, 224] |
| spec.md:800 | `design-FINAL.md:875` | 인용 줄에 근거 없음; 파일 내 위치: sim_escalation→[60, 111, 165, 224]; 문구[큐에 항목을 쌓는 수준으로 축소]→[1012] |
| spec.md:808 | `design-FINAL.md:488` | 인용 줄에 근거 없음; 파일 내 위치: Scorer ④→[64, 372, 399, 742]; axis:"mat_grade"→[372, 742, 868] |
| spec.md:821 | `design-FINAL.md:886-888` | 인용 줄에 근거 없음; 파일 내 위치: t_wgt_handoff_logs→[77, 667, 844, 879]; 문구[고객이 실제로 무엇을 골랐고 그 주문]→[670, 1025]; 문구[가 원리적으로 들어오지 않는다]→[1025] |
| spec.md:837 | `design-FINAL.md:865` | 인용 줄에 근거 없음; 파일 내 위치: 문구[인쇄는 비가역이고 금액이 즉시 확정된]→[996] |
| plan.md:11 | `design-FINAL.md:1014-1025` | 인용 줄에 근거 없음; 파일 내 위치: FIX-1→[18, 22, 36, 44]; 문구[두 부류를 섞어 읽지 않는다]→[50] |
| plan.md:22 | `design-FINAL.md:674` | 인용 줄에 근거 없음; 파일 내 위치: 문구[틀린 월드모델의 설명을 정교하게 만드]→[821] |
| plan.md:22 | `design-FINAL.md:690` | 인용 줄에 근거 없음; 파일 내 위치: 문구[틀린 월드모델의 설명을 정교하게 만드]→[821] |
| plan.md:24 | `design-FINAL.md:722` | 인용 줄에 근거 없음; 파일 내 위치: 문구[무엇을 버리는가]→[837, 853, 871, 1049] |
| plan.md:24 | `design-FINAL.md:912` | 인용 줄에 근거 없음; 파일 내 위치: 문구[무엇을 버리는가]→[837, 853, 871, 1049] |
| plan.md:27 | `design-FINAL.md:40` | 인용 줄에 근거 없음; 파일 내 위치: gates/*.py→[1103]; simcore/*→[1103, 1183] |
| plan.md:40 | `design-FINAL.md:246-249` | 인용 줄에 근거 없음; 파일 내 위치: print_opt_cd→[62, 351, 386, 567]; selections→[22, 74, 311, 334] |
| plan.md:41 | `design-FINAL.md:472` | 인용 줄에 근거 없음; 파일 내 위치: print_opt_cd→[62, 351, 386, 567]; FIX-1→[18, 22, 36, 44] |
| plan.md:41 | `design-FINAL.md:472` | 인용 줄에 근거 없음; 파일 내 위치: print_opt_cd→[62, 351, 386, 567]; FIX-1→[18, 22, 36, 44] |
| plan.md:43 | `design-FINAL.md:238-263` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325] |
| plan.md:45 | `design-FINAL.md:479,788` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325] |
| plan.md:45 | `design-FINAL.md:479` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325] |
| plan.md:45 | `design-FINAL.md:788` | 인용 줄에 근거 없음; 파일 내 위치: FIX-2→[23, 44, 323, 325] |
| plan.md:53 | `design-FINAL.md:352` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294] |
| plan.md:53 | `design-FINAL.md:566` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294] |
| plan.md:53 | `design-FINAL.md:54` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294] |
| plan.md:53 | `design-FINAL.md:432` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294] |
| plan.md:54 | `design-FINAL.md:355` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294]; 문구[은 겹치되 동일하지 않으므로]→[602]; 문구[가 선언한 전제 감시는 정작]→[602] |
| plan.md:56 | `design-FINAL.md:59` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844] |
| plan.md:56 | `design-FINAL.md:17` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844] |
| plan.md:56 | `design-FINAL.md:776` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844] |
| plan.md:56 | `design-FINAL.md:568` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844] |
| plan.md:189 | `design-FINAL.md:1001` | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[77, 230, 299, 426]; /validate→[16, 37, 77, 702]; 문구[게이트도 보충 검증도 확인하지 않았다]→[1138] |
| plan.md:208 | `design-FINAL.md:1001` | 인용 줄에 근거 없음; 파일 내 위치: 문구[확정 금액 권위를 위젯에 남기면 루프]→[942]; 문구[의 반증 조건을 측정 없이 남겨 두는]→[1138] |
| plan.md:218 | `design-FINAL.md:306` | 인용 줄에 근거 없음; 파일 내 위치: mat_grade→[50, 56, 372, 742]; IntentValidator→[56, 115, 187, 285]; 문구[값 도메인 화이트리스트]→[56, 370, 1203] |
| plan.md:221 | `design-FINAL.md:488` | 인용 줄에 근거 없음; 파일 내 위치: soft_prefs→[56, 64, 292, 317]; loop.Scorer→[64, 282, 1202] |
| plan.md:294 | `design-FINAL.md:323` | 인용 줄에 근거 없음; 파일 내 위치: FIX-1→[18, 22, 36, 44] |
| plan.md:295 | `design-FINAL.md:434` | 인용 줄에 근거 없음; 파일 내 위치: rule_cd→[58, 110, 414, 415] |
| plan.md:295 | `design-FINAL.md:745` | 인용 줄에 근거 없음; 파일 내 위치: rule_cd→[58, 110, 414, 415] |
| plan.md:428 | `design-FINAL.md:757` | 인용 줄에 근거 없음; 파일 내 위치: FIX-10→[36, 1158, 1198]; FIX-9→[35, 1158, 1198] |
| plan.md:432 | `design-FINAL.md:740` | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[295, 871, 884]; payable_parity→[295, 299, 301, 856] |
| acceptance.md:66 | `design-FINAL.md:461-472` | 인용 줄에 근거 없음; 파일 내 위치: FIX-3→[24, 114, 164, 294] |
| acceptance.md:67 | `design-FINAL.md:59` | 인용 줄에 근거 없음; 파일 내 위치: FIX-4→[25, 77, 667, 844]; t_wgt_handoff_logs→[77, 667, 844, 879]; 문구[오라클 경로 폐기 기록]→[852] |
| acceptance.md:67 | `design-FINAL.md:714` | 인용 줄에 근거 없음; 파일 내 위치: t_wgt_widgets→[77, 844, 845, 852]; t_wgt_handoff_logs→[77, 667, 844, 879]; 문구[오라클 경로 폐기 기록]→[852] |
| acceptance.md:67 | `design-FINAL.md:721` | 인용 줄에 근거 없음; 파일 내 위치: t_wgt_widgets→[77, 844, 845, 852]; t_wgt_handoff_logs→[77, 667, 844, 879]; 문구[오라클 경로 폐기 기록]→[852] |
| acceptance.md:68 | `design-FINAL.md:725` | 인용 줄에 근거 없음; 파일 내 위치: supply_amount→[101, 424, 450, 461]; payable_total→[101, 299, 426, 450]; 문구[필드 전부에 적용]→[903] |
| acceptance.md:121 | `design-FINAL.md:1001` | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[77, 230, 299, 426]; /validate→[16, 37, 77, 702]; 문구[게이트도 보충 검증도 확인하지 않았다]→[1138] |
| acceptance.md:145 | `design-FINAL.md:488` | 인용 줄에 근거 없음; 파일 내 위치: soft_prefs→[56, 64, 292, 317]; str→[1, 60, 104, 110] |
| acceptance.md:154 | `_workspace/huni-worldmodel/04_design/design-FINAL.md:277` | 인용 줄에 근거 없음; 파일 내 위치: simcore/gates/→[294, 295, 296, 297]; payable_parity→[295, 299, 301, 856] |
| acceptance.md:154 | `_workspace/huni-worldmodel/04_design/design-FINAL.md:740` | 인용 줄에 근거 없음; 파일 내 위치: simcore/gates/→[294, 295, 296, 297]; payable_parity→[295, 299, 301, 856] |

#### design-FINAL.md OK/OK_COORD(전건)

| 근원 | 인용 | 분류 | 현재 줄 발췌 |
|---|---|---|---|
| spec.md:184 | `design-FINAL.md:757` | OK_COORD | **T3 · 되묻기 (RULE-14 ①)** — A·C가 남고 `soft_prefs`만으로 갈리지 않는다. 미확정 슬롯이 남았 |
| spec.md:495 | `design-FINAL.md:1023` | OK_COORD | ### 11-1. 관측 채널이 구조적으로 얇다 — 월드모델의 절반이 약하다 |
| spec.md:495 | `design-FINAL.md:1031` | OK_COORD | ### 11-3. G0.5a·G0.5b 는 센서이지 통합이 아니다 — P-16은 남는다 |
| spec.md:578 | `design-FINAL.md:1041-1046` | OK_COORD | `_sim_disallowed`·`_price_gap_errors`·`_sim_dim_candidates`는 밑줄 접두다. w |
| spec.md:615 | `design-FINAL.md:713` | OK_COORD | `TOOL_SPECS` 순서 동결(`assistant_tools.py:872-874`, D4 §(f)-3)과 `SYSTEM_B |
| spec.md:615 | `design-FINAL.md:712` | OK_COORD |  |
| spec.md:615 | `design-FINAL.md:59` | OK_COORD |  |
| spec.md:615 | `design-FINAL.md:720` | OK_COORD |  |
| spec.md:765 | `design-FINAL.md:872` | OK | ｜ **RULE-06** 제약×가격 결합 ｜ MAJOR ｜ **충족** ｜ §4.2 `Outcome` 스키마에서 `feasib |
| spec.md:776 | `design-FINAL.md:872` | OK_COORD | ｜ **RULE-06** 제약×가격 결합 ｜ MAJOR ｜ **충족** ｜ §4.2 `Outcome` 스키마에서 `feasib |
| plan.md:11 | `design-FINAL.md:20-29` | OK | ｜ FIX ｜ 지목 규칙 ｜ 반영 위치 ｜ |
| plan.md:26 | `design-FINAL.md:1027` | OK_COORD | ### 11-2. 시뮬레이터는 의미론 공백을 고치지 못한다 — 탐지는 해결이 아니다 |
| plan.md:440 | `design-FINAL.md:1041-1046` | OK_COORD | `_sim_disallowed`·`_price_gap_errors`·`_sim_dim_candidates`는 밑줄 접두다. w |
| acceptance.md:65 | `design-FINAL.md:20-29` | OK_COORD | ｜ FIX ｜ 지목 규칙 ｜ 반영 위치 ｜ |
| acceptance.md:103 | `design-FINAL.md:40` | OK_COORD | [HARD] RULE-03·RULE-17 의 "검증됨"은 **보충 라운드(`coverage-supplement.md`)에서 사 |
| acceptance.md:103 | `design-FINAL.md:738` | OK_COORD |            budget_krw: 50000 } |
| acceptance.md:103 | `design-FINAL.md:750` | OK_COORD | ``` |
| acceptance.md:112 | `design-FINAL.md:757` | OK_COORD | **T3 · 되묻기 (RULE-14 ①)** — A·C가 남고 `soft_prefs`만으로 갈리지 않는다. 미확정 슬롯이 남았 |
| acceptance.md:495 | `design-FINAL.md:1023` | OK_COORD | ### 11-1. 관측 채널이 구조적으로 얇다 — 월드모델의 절반이 약하다 |
| acceptance.md:495 | `design-FINAL.md:1031` | OK_COORD | ### 11-3. G0.5a·G0.5b 는 센서이지 통합이 아니다 — P-16은 남는다 |

### MISSING / MISMATCH / UNRESOLVED 전건 재판정표

| 근원 | 인용 | 스캔 분류 | 수동 재판정 | 근거 |
|---|---|---|---|---|
| spec.md:28 | `01_research/R2-world-model-theory.md:208` | MISMATCH | OK(수동) | R2:208 = "월드모델이 반드시 신경망 latent일 필요가 없다…SQL 함수도…룩업 테이블도" — 주장 문언 축자 일치 |
| spec.md:53 | `problem-ledger.md:459` | MISMATCH | OK(수동) | 459행 = `| N-16 | raw/webadmin 직접 수정…` — 기각목록 N-16 행 그 자체 |
| spec.md:71 | `gate-report.md:173-180` | MISMATCH | OK(수동) | 173행 = `[FIX-4 / A2] G6 실행 환경을 분리…` — clone DB 전용 절 시작 |
| spec.md:153 | `widget_api.py:135` | MISMATCH | OK(수동) | 135행 = `.update(last_used_dt=timezone.now(), last_used_org=org))` |
| spec.md:182 | `evaluation-rubric.md:76` | MISMATCH | OK(수동) | 76행 = `violation_test: …고객이 옵션 6개 중 5개를 고른 상태에서…` — RULE-03 시나리오 |
| plan.md:94 | `coverage-supplement.md:306` | MISMATCH | LINE_DRIFT(귀속정정) | 진타겟 design-FINAL.md(성질 1) — 현재 450행(`feasible != "PROVEN_OK"`이면 price 3필드 None). 스캔 귀속은 같은 줄 lookback 오류 |
| plan.md:94 | `coverage-supplement.md:622` | MISSING | LINE_DRIFT(귀속정정) | 진타겟 design-FINAL.md §5.6-8번 — 현재 903행(`8 | evaluate_price (d) | …0원 대체 절대 금지`) |
| plan.md:105 | ``:389`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — esc_kind 7종 현재 639행(`★ FIX-6 — esc_kind 7종`) |
| plan.md:105 | ``:601`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — "6종" 문언 현재 639행(`개정 전 6종에 PREMISE_FAIL 누락`) |
| plan.md:106 | ``:393`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — route_to 게이트별 3행 현재 656-658행(PREMISE_FAIL G0/G0.5a·b/G0.9) |
| plan.md:106 | ``:565`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — 소비 표면 3열 문언 현재 647-649행(N3 정정 + 매핑표 헤더) |
| plan.md:109 | ``:51`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — "미보유 셀은 None 명시" 현재 454행(★ FIX-7 폴백 사다리) |
| plan.md:109 | ``:598`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — 상동 454행(및 877행 RULE-11 행) |
| plan.md:123 | `evaluation-rubric.md:76` | MISMATCH | OK(수동) | 상동 |
| plan.md:141 | `price_views.py:2698` | MISMATCH | OK(수동) | 2698행 = `return sorted({str(v) for v in qs.values_list(col, flat=True)…})` |
| plan.md:158 | `spec.md:178` | MISMATCH | MISMATCH(수동) | 현 spec:178 = U-009.1(게이트 5요소). 주장 문언 `PICK→PR→RG`는 현 spec.md 전체에 0건(grep) — 개정으로 문언 자체가 변형됨(U-001.5 :86으로 흡수 추정) |
| plan.md:158 | `spec.md:489` | MISMATCH | LINE_DRIFT(수동) | 현 spec:489 = §4.7.3 정밀도 문언. RenderGuard 숫자 토큰 서술은 현재 :86(U-001.5)·:124(U-004.5) |
| plan.md:312 | `price_views.py:2526` | MISMATCH | OK(수동) | 2526행 = `"nm": r.get("rule_nm") or r.get("err_msg") or "제약",` |
| acceptance.md:57 | `widget_api.py:135` | MISMATCH | OK(수동) | 상동(spec.md:153) |
| acceptance.md:94 | `price_views.py:2698` | MISMATCH | OK(수동) | 상동(plan.md:141) |
| acceptance.md:319 | ``:740`` | UNRESOLVED_IMPLICIT | 귀속정정+진좌표 | 진타겟 design-FINAL.md — "게이트표 G0~G10 전건" 현재 871/884행(DF:295에 `:740` 자기 인용 잔존) |
| acceptance.md:468 | `gate-report.md:30-38` | MISMATCH | OK(수동) | 30행 = `| # | 재실측 대상 | 결과 |` — R-1~R-7 재실측 표 |
| acceptance.md:642 | `pricing.py:655-660` | MISMATCH | OK(수동) | 655행 = `if gap:` … 656-659 data_gap 충전 … 660 `return entry, warns` — no_match 분기 |

### py 인용 좌표 원문 대사 결과(오탐 46행의 근거 — 좌표 23종)

| 좌표 | 원문 대사 |
|---|---|
| `widget_api.py:1677` | 1677행 = `M.TWgtHandoffLogs.objects.create(**row)` (INSERT) |
| `widget_api.py:1733` | 1733행 = `.filter(handoff_id__in=ids).delete()` (DELETE) |
| `widget_api.py:135` | 135행 = `.update(last_used_dt=timezone.now(), last_used_org=org))` |
| `widget_api.py:195-196` | 195-196행 = `cache.get_or_set` + `cache.incr` |
| `widget_api.py:462-463` | 462-463행 = data_gap 정의(미선택·와일드카드 차원 제외) — UNSELECTED_DIM 구분 승계 |
| `widget_api.py:140` | 140행 = `RATE_LIMIT_PER_MIN = 240` |
| `widget_api.py:1410` | 1410행 = `def api_validate(request):` |
| `widget_api.py:1414` | 1414행 = `site, w, ver, err = _gate(request, body)` |
| `widget_api.py:226` | 226행 = `_touch_used(w, request)` |
| `widget_api.py:133` | 133-134행 = TWgtWidgets filter 체인 |
| `pricing.py:106-108` | 106-108행 = dim_vals 대소 비교 매칭 실패 판정(내용 대응) |
| `pricing.py:599-607` | 599행 = `def _no_match_detail(...)` — no_match 진단 |
| `pricing.py:655-660` | 655행 = `if gap:` 분기 + 무경고 return |
| `pricing.py:667` | 667행 = `entry.update({` — 로컬 dict 갱신 |
| `pricing.py:288-291` | 288-291행 = 타이브레이크 docstring + 그룹핑 |
| `pricing.py:428` | 428행 = `def evaluate_price(...)` |
| `pricing.py:626-630` | 626-630행 = included=False·data_gap=[] 조용한 반환(구좌표 — 교체 지시문이 인용) |
| `price_views.py:2520` | 2520-2521행 = `.values("rule_nm", "err_msg", "logic", "rule_typ_cd")` |
| `price_views.py:2526` | 2526행 = `"nm": … or "제약"` |
| `price_views.py:2731` | 2731행 = `dis[cand] = r["nm"]` |
| `price_views.py:1775` | 1775행 = `def _dim_options(d):` |
| `views.py:1888` | 1888행 = `OPT_REF_DIM.06: (TPrdProductPrintOptions, ["opt_id"])` |

`widget_api.py:1148`(spec.md:123·acceptance.md:344)만 진짜 드리프트 — `VAT_RATE = Decimal("0.1")` 정의는 **1150행**. 그 외 py 좌표 인용은 전부 인용 그대로다.

### LINE_DRIFT 전건 목록(design-FINAL 제외 — 스크립트 측정값, 후보 좌표 제시)

수동 확인된 행: plan.md:155 `spec.md:393`·`:395`·`:181`(gap_owner 원용 → 현 spec.md:529, 소비 표면 3열 문언 → 현 :162) — plan→spec 내부 인용도 spec.md 개정으로 밀려 있다.

| 근원 | 인용 | 대상 파일 | 현재 위치 후보 |
|---|---|---|---|
| spec.md:37 | `02_diagnosis/D4-neuro-layer.md:379-387` | _workspace/huni-worldmodel/02_diagnosis/D4-neuro-layer.md | 인용 줄에 근거 없음; 파일 내 위치: evaluate_price→[12, 86, 100, 230]; 문구[다중 후보 비교]→[228] |
| spec.md:55 | `problem-ledger.md:432` | _workspace/huni-worldmodel/03_problem/problem-ledger.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[가격 사슬 배선]→[344] |
| spec.md:71 | `gate-report.md:32-34` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: _gate→[3] |
| spec.md:123 | `widget_api.py:1148` | raw/webadmin/webadmin/catalog/widget_api.py | 인용 줄에 근거 없음; 파일 내 위치: VAT_RATE→[1150, 1157] ｜ 수동 확정: 진짜 드리프트 — VAT_RATE 정의는 1150행 |
| spec.md:141 | `raw/webadmin/sql/12_phase7_seed.sql:27,37-61` | raw/webadmin/sql/12_phase7_seed.sql | 인용 줄에 근거 없음; 파일 내 위치: ref_dim→[7, 14, 28] |
| spec.md:150 | `gate-report.md:32-34` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[리플레이 유발 행 수]→[177]; 문구[예상 조합 수]→[177] |
| spec.md:182 | `gate-report.md:104` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: FIX-9→[231, 235, 377] |
| spec.md:182 | `coverage-supplement.md:150-159` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: frontier→[63, 69, 360]; rollout→[63, 70, 76, 107] |
| spec.md:183 | `gate-report.md:118` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: FIX-10→[233, 235, 377] |
| spec.md:183 | `coverage-supplement.md:232-240` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: FIX-10→[5, 411, 431] |
| spec.md:183 | `evaluation-rubric.md:80` | _workspace/huni-worldmodel/04_design/evaluation-rubric.md | 인용 줄에 근거 없음; 파일 내 위치: temperature→[81] |
| spec.md:491 | `05_gate/gate-report.md:265-278` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[은폐하지 않는다]→[156] |
| spec.md:493 | `gate-report.md:326-328` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[루브릭 개정 안건]→[325] |
| spec.md:531 | `coverage-supplement.md:435` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[76, 125, 137, 139]; /validate→[6, 35, 49, 50] |
| spec.md:544 | `coverage-supplement.md:261-299` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: _gate:218→[366]; FIX-4→[6, 28, 125, 244]; 문구[의 부작용 유무]→[248] |
| spec.md:554 | `gate-rehearing.md:377-381` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | §6.2 헤딩 위치 [375] |
| spec.md:559 | `gate-rehearing.md:196` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: CS2-01→[24, 192, 328, 342] |
| spec.md:559 | `gate-rehearing.md:388` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: CS2-01→[24, 192, 328, 342] |
| spec.md:564 | `gate-rehearing.md:243` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: amend_cleared = false→[257]; 문구[게이트가 지시한 교정을 다 했는데도 ]→[259]; 문구[서로 다른 라운드가 낸 서로 다른 채]→[259] |
| spec.md:568 | `coverage-supplement.md:435` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[76, 125, 137, 139]; /validate→[6, 35, 49, 50] |
| spec.md:601 | `gate-rehearing.md:275-281` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[없는 규칙을 만들어 재면 그것이]→[269]; 문구[루브릭 부재로 판정 불가]→[263] |
| spec.md:611 | `gate-rehearing.md:327-328` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | §5.3 헤딩 위치 [320] |
| spec.md:624 | `gate-report.md:370-379` | _workspace/huni-worldmodel/05_gate/gate-report.md | §6.3 헤딩 위치 [368] |
| spec.md:632 | `coverage-supplement.md:261-299` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /validate→[6, 35, 49, 50]; 문구[실측 의무는 끝났고 교정 의무가]→[412] |
| spec.md:680 | `gate-rehearing.md:239` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[명세의 통과이지 구현]→[422]; 문구[측정의 통과가 아니다]→[422] |
| spec.md:702 | `g6-clone-feasibility.md:52-66` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; createdb→[82, 94, 189, 300]; 문구[라이브 무영향 경로]→[287] |
| spec.md:702 | `g6-clone-feasibility.md:287` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: FEASIBLE_WITH_COST→[285]; stable 18.4→[163] |
| spec.md:706 | `g6-clone-feasibility.md:292` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; 문구[실제 덤프에서만 드러나는 문제]→[311]; 문구[차단 요인 부재의 전수 실측]→[311] |
| spec.md:746 | `R3:313` | _workspace/huni-worldmodel/01_research/R3-leejoohwan-local.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[모든 것을 명세하지 않으면은 심볼릭 ]→[99]; 문구[모든 세계를 완벽하게 명세한다는게 사]→[99] |
| spec.md:748 | `R3:104` | _workspace/huni-worldmodel/01_research/R3-leejoohwan-local.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[갭이 경계 밖으로 나가면 자율모드를 ]→[321] |
| spec.md:750 | `R4:162-167` | _workspace/huni-worldmodel/01_research/R4-leejoohwan-web.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[프레임워크와 월드 모델 캔버스]→[8] |
| spec.md:750 | `R4-leejoohwan-web.md:39` | _workspace/huni-worldmodel/01_research/R4-leejoohwan-web.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[프레임워크와 월드 모델 캔버스]→[8] |
| spec.md:763 | `D8-live-schema.md:130` | _workspace/huni-worldmodel/02_diagnosis/D8-live-schema.md | 인용 줄에 근거 없음; 파일 내 위치: t_prd_product_constraints→[64, 136, 162, 197]; 문구[만 채워져 있다]→[138] |
| spec.md:808 | `gate-rehearing.md:343` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: Scorer ④→[99, 103, 394]; axis:"mat_grade"→[99] |
| plan.md:65 | `coverage-supplement.md:261-299` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /validate→[6, 35, 49, 50] |
| plan.md:123 | `coverage-supplement.md:150-159` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: FIX-9→[5, 411, 431]; 문구[루브릭 시나리오]→[63, 417] |
| plan.md:124 | `coverage-supplement.md:232-240` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: FIX-10→[5, 411, 431] |
| plan.md:143 | `coverage-supplement.md:425` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[건이 재현성을 실제로 변별하는 표본인]→[433] |
| plan.md:155 | `spec.md:393` | .moai/specs/SPEC-WORLDMODEL-001/spec.md | 인용 줄에 근거 없음; 파일 내 위치: gap_owner→[529]; 문구[에스컬레이션 큐의 소비 표면이 일부 ]→[162] |
| plan.md:155 | `spec.md:395` | .moai/specs/SPEC-WORLDMODEL-001/spec.md | 인용 줄에 근거 없음; 파일 내 위치: gap_owner→[529]; 문구[에스컬레이션 큐의 소비 표면이 일부 ]→[162] |
| plan.md:155 | `spec.md:181` | .moai/specs/SPEC-WORLDMODEL-001/spec.md | 인용 줄에 근거 없음; 파일 내 위치: gap_owner→[529]; 문구[에스컬레이션 큐의 소비 표면이 일부 ]→[162] |
| plan.md:189 | `coverage-supplement.md:435` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[76, 125, 137, 139]; /validate→[6, 35, 49, 50] |
| plan.md:205 | `g6-clone-feasibility.md:5` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; createdb→[82, 94, 189, 300]; 문구[라이브 무영향 경로]→[287] |
| plan.md:205 | `g6-clone-feasibility.md:253-255` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; createdb→[82, 94, 189, 300]; 문구[라이브 무영향 경로]→[287] |
| plan.md:205 | `g6-clone-feasibility.md:287` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: brew install postgresql@18→[171, 271, 279, 300]; stable 18.4→[163]; 문구[사용자 승인 필요]→[300] |
| plan.md:206 | `g6-clone-feasibility.md:292` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; 문구[차단 요인 부재의 전수 실측]→[311] |
| plan.md:221 | `gate-rehearing.md:112` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: loop.Scorer→[394]; soft_prefs→[96, 103, 104, 115]; 문구[선언 없는 열린]→[394]; 문구[미반영 상태로]→[196] |
| plan.md:308 | `gate-rehearing.md:380` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: STILL_OPEN→[49, 55, 56, 60] |
| plan.md:314 | `coverage-supplement-2.md:266` | _workspace/huni-worldmodel/05_gate/coverage-supplement-2.md | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[203, 260, 261, 262]; F22 payable_parity→[262] |
| plan.md:426 | `g6-clone-feasibility.md:5` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: brew install postgresql@18→[171, 271, 279, 300]; pg_dump→[27, 72, 93, 99] |
| plan.md:426 | `g6-clone-feasibility.md:253-255` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: brew install postgresql@18→[171, 271, 279, 300]; pg_dump→[27, 72, 93, 99] |
| plan.md:426 | `g6-clone-feasibility.md:292` | _workspace/huni-worldmodel/05_gate/g6-clone-feasibility.md | 인용 줄에 근거 없음; 파일 내 위치: pg_dump→[27, 72, 93, 99]; brew install postgresql@18→[171, 271, 279, 300] |
| plan.md:428 | `coverage-supplement-2.md:327-328` | _workspace/huni-worldmodel/05_gate/coverage-supplement-2.md | 인용 줄에 근거 없음; 파일 내 위치: violation_test→[6, 21, 26, 34] |
| plan.md:430 | `gate-rehearing.md:388` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: nm → rule_cd→[189, 380]; rule_cd→[186, 189, 190, 191] |
| plan.md:432 | `acceptance.md:212` | .moai/specs/SPEC-WORLDMODEL-001/acceptance.md | 인용 줄에 근거 없음; 파일 내 위치: G0~G10→[154, 319, 667]; 문구[가 새 구성물을 도입하면서]→[157]; 문구[표를 또 갱신하지 않으면]→[157] |
| acceptance.md:58 | `coverage-supplement.md:412` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /validate→[6, 35, 49, 50] |
| acceptance.md:85 | `gate-report.md:104` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[개가 미검증인 채로 롤아웃]→[377]; 문구[설계의 중심 논지가 미검증]→[377] |
| acceptance.md:92 | `coverage-supplement.md:174-190` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[요소 전건 존재]→[234] |
| acceptance.md:121 | `coverage-supplement.md:435` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /handoff→[76, 125, 137, 139]; /validate→[6, 35, 49, 50] |
| acceptance.md:146 | `gate-rehearing.md:112` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[미반영 상태로]→[196] |
| acceptance.md:146 | `gate-rehearing.md:394` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[미반영 상태로]→[196] |
| acceptance.md:156 | `gate-rehearing.md:389` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[진행을 막지 않는다]→[210] |
| acceptance.md:256 | `coverage-supplement.md:261-299` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: /validate→[6, 35, 49, 50]; 문구[미확인 통과 금지]→[335] |
| acceptance.md:344 | `widget_api.py:1148` | raw/webadmin/webadmin/catalog/widget_api.py | 인용 줄에 근거 없음; 파일 내 위치: VAT_RATE→[1150, 1157] ｜ 수동 확정: 진짜 드리프트 — VAT_RATE 정의는 1150행 |
| acceptance.md:412 | `gate-rehearing.md:422` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: STILL_OPEN→[49, 55, 56, 60]; 문구[재심 권한은 게이트에 있다]→[8] |
| acceptance.md:478 | `coverage-supplement.md:398-404` | _workspace/huni-worldmodel/05_gate/coverage-supplement.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[이 라운드에서 가장 큰 구조적 공백]→[417] |
| acceptance.md:478 | `gate-report.md:387` | _workspace/huni-worldmodel/05_gate/gate-report.md | 인용 줄에 근거 없음; 파일 내 위치: 문구[이 라운드에서 가장 큰 구조적 공백]→[135] |
| acceptance.md:511 | `gate-report.md:370-379` | _workspace/huni-worldmodel/05_gate/gate-report.md | §6.3 헤딩 위치 [368] |
| acceptance.md:538 | `gate-rehearing.md:243` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: amend_cleared = false→[257] |
| acceptance.md:575 | `gate-rehearing.md:99` | _workspace/huni-worldmodel/05_gate/gate-rehearing.md | 인용 줄에 근거 없음; 파일 내 위치: soft_prefs→[96, 103, 104, 115] |

---

## ③ B. 요구사항 ↔ AC 추적성 재집계 (SPEC 주장 vs 독립 실측)

| 항목 | SPEC/§H 주장 | 독립 실측 | 판정 |
|---|---|---|---|
| §3 요구사항 총건수 | 64 | 64 | **일치** |
| 접두 분포 | U 44 · X 11 · E 7 · O 1 · S 1 | U 44 · X 11 · E 7 · O 1 · S 1 | **일치** |
| H.1 표 행수 / 중복 | 64행 | 64행 · 중복 0건 | **일치** |
| 커버 등급(신설 후) | 직접 51 · 간접 9 · 미커버 4 | 직접 51 · 간접 9 · 미커버 4 | **일치** |
| 미커버율 | 6.3% | 4/64 = 6.25%(반올림 6.3%) | **일치** |
| 정의집합 ↔ H.1 표 집합차 | (암묵: 동일) | 정의↔표 차 0건 | **일치** |
| 유령 ID(§H.4④ 주장 0건) | 0건 | 0건 | **일치 — 주장 재확인** |
| as-found 표(참고) | 43/9/12=64 | 산술 정합(43+9+12=64) | **일치** |

추가 실측: §3 정의행 중복 ID 0건 · H.1 표 중복 행 0건. §H.2의 "간접 9건을 커버로 합산하지 않는다" 원칙은 집계 로직과 정합(직접+간접+미커버=64만 보고).

---

## ④ C. 라이브 코드 앵커 실재성 (`raw/webadmin/**` 읽기전용 실측)

| # | 앵커 | 실측 결과 |
|---|---|---|
| 1 | `pricing.evaluate_price` | **실재** — `catalog/pricing.py:428` `def evaluate_price(target, selections, qty, grade_cd=None, mode="lenient", …)` (spec 인용 `:428` 정확) |
| 2 | `price_views._sim_disallowed` | **실재** — `price_views.py:2701` `def _sim_disallowed(prd_cd, sel):` (plan 인용 `:2701` 정확) |
| 3 | `_price_gap_errors` | **실재** — `widget_api.py:455` `def _price_gap_errors(res, prd_cd):` (plan 인용 `:455` 정확) |
| 4 | `tmpl_combo.resolve` | **실재** — `tmpl_combo.py:245` `def resolve(prd_cd, opt_codes, selections=None, proc_codes=None):` (plan 인용 `:245` 정확) |
| 5 | `qty_rule_error` | **실재** — `price_views.py:1615` `def qty_rule_error(prd_cd, selections, qty):` (plan 인용 `:1615` 정확) |
| 6a | 판걸이수 `sql/32_fn_calc_pansu.sql` | **실재**(64행) — `:30` `STABLE` 확인. `pricing.py:308` `cur.execute("SELECT fn_calc_pansu(%s, %s)")` 확인 |
| 6b | `sql/33_fn_best_plate.sql` | **실재**(60행). 단 SPEC(spec.md:323)의 `:114`·`:115`·`:170-174` 인용은 **60행 파일이라 줄 부재** — 과거 개정본 인용으로 추정(현재 파일 기준 유효하지 않음) |

**CS2-01 근거 좌표 3개 — 전부 코드로 확인:**

| 좌표 | 실측 내용 | CS2-01 주장과의 정합 |
|---|---|---|
| `price_views.py:2731` | `dis[cand] = r["nm"]` (2730 `if not jsonLogic(r["logic"], data):` 직후) | **정확 일치** — 반환값 출처가 `nm`임 |
| `price_views.py:2520-2521` | `.values("rule_nm", "err_msg", "logic", "rule_typ_cd")` | **정확 일치** — 컬럼 4개에 `rule_cd` 부재 (하류 `rule_cd` 복원 불가 주장의 근거 성립) |
| `price_views.py:2526` | `"nm": r.get("rule_nm") or r.get("err_msg") or "제약",` | **정확 일치** — err_msg → 문자열 `"제약"` 폴백 |

보조 확인: `price_views.py:2685-2691`(열거축 5종 dict) · `:2692-2693`(`if not q: return []`) — spec §3.2 U-002.4 인용과 정합. `models.py:463` print_opt_cd nullable · `price_views.py:1832-1841` print_side 우선 라벨 계약 · `:1775` `def _dim_options(d):` 내부 클로저 — 전부 인용 좌표 그대로.

---

## ⑤ 사용한 명령·스크립트

```
python3 _workspace/huni-worldmodel/07_reverify/_scripts/r3_scan_a.py   # A: 인용 586건 추출·분류 → out/a_citations.tsv
python3 _workspace/huni-worldmodel/07_reverify/_scripts/r3_scan_b.py   # B: §3/H.1 재집계 → out/b_traceability.json
python3 _workspace/huni-worldmodel/07_reverify/_scripts/r3_report.py   # 본 리포트 생성
# C + 수동 재판정 근거(전부 읽기전용):
#   grep -n "def evaluate_price" raw/webadmin/webadmin/catalog/pricing.py  등 6종 def grep
#   sed -n '2729,2733p;2518,2527p' raw/webadmin/webadmin/catalog/price_views.py  (CS2-01 좌표)
#   sed -n '30p' raw/webadmin/sql/32_fn_calc_pansu.sql; wc -l raw/webadmin/sql/{32,33}_*.sql
#   grep -n "PICK→PR→RG" .moai/specs/SPEC-WORLDMODEL-001/spec.md  → 0건 (plan.md:158 재판정 근거)
#   grep -n "성질 1\|esc_kind\|route_to\|G0~G10\|미보유 셀" …/design-FINAL.md (UNRESOLVED 진좌표)
```

재현: 스캔 A·B는 위 2개 스크립트 재실행으로 동일 결과(고정 정규식·고정 우선순위). 수동 재판정 — MISMATCH 15행 전수 · py LD 의심 48행 전수(좌표 23종) · DF/plan→spec 진좌표 16건 — 근거 원문은 본 파일 각 표에 인용.

---

## ⑥ Gaps (못 잰 것)

1. **내용 부합 판정은 부분문자열(토큰/한글 문구) 대조** — 의미 수준 대조가 아니므로 OK/LINE_DRIFT에 오탐·미탐이 공존 가능. 오탐률 검증: MISMATCH 15건 전수 대사 **오탭 12/15(80%)**, py 대상 LD 48행 전수 대사 **오탭 46/48(95.8%) — 진짜는 `widget_api.py:1148`→1150 두 행뿐**. md 대상 LD(대부분 design-FINAL·gate 문서)는 오탐률 미검증이나, 수동 검증 표본 6건은 전부 진짜 밀림(파일 성장 804→1,203행이 원인). LINE_DRIFT 표의 '현재 위치 후보'는 후보일 뿐, 수동 확정 열에 있는 값만 확정.
2. **OK_COORD 147건은 좌표 실재만 확인** — 내용 부합 여부는 기계 판정 불가(근원 문맥에 대조 가능한 토큰·문구가 없음). design-FINAL 18건 포함.
3. **design-FINAL LINE_DRIFT 84건 중 수동 확정은 13건**(사례표 6건 + 암묵 인용 진좌표 7건) — 잔여 71건은 스크립트 후보 좌표만 제시. 전건 원문 대사는 이 카드 예산 밖.
4. **과거 버전 정합(인용이 작성 시점엔 정확했는지)은 미측정** — git 이력 대조 없이 현재 파일 기준만 측정. `33_fn_best_plate.sql:114+` 인용의 원본 개정본 확인도 여기 포함.
5. **라이브 DB 미접근** — C는 전부 파일 레벨 실측(카드 규율상 DB 접근 불요). DB 객체(fn_calc_pansu 함수 본체 등)는 SQL 파일 기준만 확인.
6. **R-doc 인용 계열(`R3:104` 등)은 라인 실재만 확인** — 인터뷰 원문 인용의 내용 축자성은 대조 안 함.
7. 병행 세션 `review-huniweb`의 `R3-adversarial-review.md`는 미참조(규율).

