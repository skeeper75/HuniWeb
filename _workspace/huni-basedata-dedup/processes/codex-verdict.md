# codex-verdict — 공정축 표시중복 정리 codex(gpt-5.5) 2차 독립 교차검증 원문 + 환각 경계 주석

생성: 2026-06-19 / hbd-codex-verifier / codex 가용성: **AVAILABLE model=gpt-5.5** (preflight EXIT=0)
호출: `hqv-codex-cross-verify/scripts/codex-review.sh codex-prompt.txt gpt-5.5 <workdir>` · `-s read-only` · session 019edd08
입력: work-spec(4축·canonical·무손실·BLOCKED 정의) + 라이브 실측(부모/자식 행·외부참조 카운트) + Claude Phase 2 판정 + 의심 지점 Q1~Q3
★Claude verdict는 프롬프트에 넣되 codex가 독립 재판정하도록 적대적 의심 지점 명시(독립성 보존).

---

## codex 원문 요약 (전문은 tool-results/bj3lz5kiu.txt:451~578)

codex는 추가 파일/DB 조회 없이 제공 SELECT 실측만 권위로 판정. 핵심 기준 2개를 명시 채택: ① upr_proc_cd 상이=다른 의미축, ② component_prices.proc_cd 보유=논리삭제 금지.

| 그룹 | codex VERDICT | codex 근거 |
|---|---|---|
| A. 진짜중복 9 (087~097) | **AGREE** | thin mirror·dtl_opt 공란·총참조 0·crosswalk 부재·부모 rich. "단 merge 표현 위험 — del_yn='Y'만, 단가이동/재배선 없이" |
| B. 정당구분 핑크 010/036 | **AGREE** | 부모 상이(별색007 vs 박033)·010 comp 212행·"036 미사용 슬롯은 010 중복 근거 아님" |
| B. 정당구분 UV 002/016 | **AGREE** | 016 upr=013 코팅(형제 014/015 active)·097과 부모 다름·"016 삭제 금지" |
| C. 오적재 BLOCKED 3 | **AGREE(삭제금지) / UNCERTAIN(런타임 단정)** | comp 30/50/18 자식 키·옵션 부모 참조. "삭제 금지 맞다. 단 '엔진 부모조회 0행=가격미산출' 런타임 결론은 SELECT만으론 단정불가 — proc_grp 확장조회 가능성" |
| Q1-a 016 merge? | **DISAGREE(016 merge)** | 016 keep·097 merge. 부모 의미축 상이 → 같은 삭제규칙 금지. **Claude의 keep과 일치** |
| Q1-b 가변데이타 085 | **AGREE(out-of-scope/keep)** | 085·031·032 표시명 상이·중복 아님 |
| Q2 핑크 false-positive | **AGREE** | 박=색 child enum·형제도 prd_proc 0·"036 죽은행 여부는 별도 박 옵션축 감사" |
| Q3-a 런타임 단절 | **UNCERTAIN** | 불일치(가격=자식·옵션=부모)는 확정. 부모→자식 fallback/proc_grp 확장은 pricing.py/골든 확인 필요 |
| Q3-b 교정방향 | **AGREE** | 자식 삭제 금지. "더 안전 = comp.proc_cd를 부모로 옮기기(옵션·바인딩·dtl_opt·authority 전부 부모). 단 이번 범위 아님" |
| Q3-c 의도 vs 사고 | **UNCERTAIN but suspicious** | "자식에 dtl_opt 없고 옵션/바인딩/authority 전부 부모 → 사고 가능성 높음. 단 가격행 있는 한 삭제 금지" |

### codex 최종 목록
- **SAFE-TO-MERGE**: 087·088·089·091·093·094·095·096·097 (조건: del_yn='Y'만·단가이동/재배선 없이)
- **BLOCKED**: 086·090·092 (comp 30/50/18·논리삭제 금지)
- **KEEP**: 010·036·002·016·085·031·032 + 모든 rich parent
- **추가 결함**: ① Claude "런타임 가격 미산출" 단정 과함(proc_grp 확장 확인 필요) ② 단 086/090/092 삭제금지는 맞음 ③ 016을 참조0 이유로 097과 같은 삭제후보에 넣으면 false-positive
- **총평**: "삭제/보존 최종 목록 기준 신뢰 가능. 단 미싱/오시/타공 '가격 미산출 확정'은 과단정 — pricing.py/실견적 별도 검증"

---

## Claude 환각 경계 주석 [HARD]

codex 주장은 외부 의견·가설이다. 라이브/코드 검증 전엔 사실 아님. 아래는 각 codex 주장의 검증 상태.

### ✅ 검증됨 (라이브 실측 캐시와 일치)
- **A 9건 safe-merge·B keep·C BLOCKED 목록**: codex 목록 = Claude 목록과 **완전 동일**. 근거 사실(thin mirror 배치·upr 상이·comp 카운트 30/50/18·참조 0)은 Phase 1 라이브 캐시(`live.csv`·`_price_dep.csv`·`_prd_bind.csv`)와 byte 단위 일치. codex 환각 0(인용 사실 전부 실재).
- **016≠097**: codex가 016 merge를 DISAGREE한 것은 Claude의 keep 판정과 **합의**(겉으로 DISAGREE지만 Claude도 016 keep). 016 upr=PROC_000013·097 upr=PROC_000002는 live.csv:16·97에서 실재 확인. 형제 014/015 active(상품바인딩 21/30)는 `_prd_bind.csv`:3~4 실재.

### 🔬 codex 우려 — Claude가 라이브 코드로 추가 검증함 (Q3-a)
codex의 유일한 적대적 지적: "엔진 부모조회 0행=가격미산출" 단정이 SELECT만으론 과하다(proc_grp 확장조회 가능성). **Claude가 pricing.py를 직접 읽어 해소**:
- `pricing.py:404,466` — `match_component(rows, sel, ...)`은 `sel["proc_cd"]`(선택 공정코드)로 component_prices를 **정확 일치(exact-match)** 조회. 부모→자식 fallback **없음**.
- `pricing.py:460` — `proc_grp:` use_dim은 `":" in d` 필터로 **제외(stripped)** — 매칭축 아님·메타데이터. 즉 codex가 가설한 "proc_grp 확장조회"는 엔진에 **존재하지 않음**.
- 결론: 엔진은 `proc_sels`가 전달하는 proc_cd로만 조회. option이 부모(030/029/079)를 ref하면 부모 proc_cd로 조회 → component_prices(자식 086/090/092 키) **0행 → 가격 0**. 단절은 **실재**(codex가 우려한 자동해소 경로 부재).
- ★단, 이 검증은 **codex 우려를 기각하되 codex의 실무 결론을 강화**한다 — 단절이 실재할수록 자식 삭제는 더더욱 금지(가격 98행이 유일한 미싱/오시/타공 단가). 양쪽 모두 BLOCKED 합의.
- ★잔여 미확정: 런타임에 UI가 부모를 ref한다는 것은 option_items.ref_key1 실측이나, "실제 견적에서 부모 proc_cd가 proc_sels로 전달되는지"는 위젯/뷰 레이어 확인이 추가로 필요. 단 이는 **dedup 액션과 무관**(삭제금지는 어느 경우든 동일).

### ⚠️ 미검증 가설 (codex 단독·채택 보류)
- **Q3-b "comp.proc_cd를 부모로 옮기는 게 더 안전"**: codex 의견. 그럴듯하나 가격축 재배선은 본 dedup 범위 밖이고, dbm-price-arbiter 심의 대상. 채택 보류(escalate 라우팅만 수용).
- **Q3-c "사고 가능성 높음"**: codex 추정. component_prices가 자식 키로 적재된 게 의도인지 사고인지는 v03 적재 oracle 확인 필요. 판정 영향 없음(양쪽 합의: 삭제금지). 미검증 가설로 분류.

---

## 환각 경계 종합

codex는 제공 실측만 사용·날조 0·인용 사실 전부 라이브 캐시와 일치. 유일한 적대적 지적(Q3-a 과단정)은 Claude가 pricing.py 라이브 코드로 검증 → **단절 실재 확인(codex 가설 경로 부재)**. codex 단독 가설(Q3-b/c 교정방향·의도판정) 2건은 미검증으로 채택 보류(BLOCKED 액션엔 영향 0). 적재 액션(9 merge·3 BLOCKED·keep) 전건 합의.
