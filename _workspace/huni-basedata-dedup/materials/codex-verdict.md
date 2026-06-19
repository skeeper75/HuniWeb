# 자재 축 — codex 2차 교차검증 원문 + 환각 경계 주석

- codex 가용성: **AVAILABLE model=gpt-5.5** (codex-preflight EXIT=0)
- 호출: `cat codex-prompt.txt | codex exec -s read-only -` (workdir=materials, sandbox=read-only, reasoning=high, session 019eddcc...)
- work-spec: `codex-prompt.txt` (라이브 실측 facts + C-CAL-01 진단 + Claude Phase2 판정 + Q1~Q4 적대 질문)
- ★codex 주장 = 외부 의견·가설. 아래는 라이브 재실측으로 검증 후 채택 여부 표기.

## codex 원문 응답 (요약·verbatim 취지)

**Q1 (032 stale vs 의미축 분리):** 032=stale mis-load remnant (B 아님). 근거: mat_nm=삼각대(그레이)인데 type=.02 링제본부자재·authority 부재·BOM0·cp0. .02를 보존할 work/cut/plate/unit 의미차 증거 없음. upd_dt=2026-06-19는 "살아있는 정당성"이 아니라 "최근 만졌는데도 여전히 불일치"라는 약한 위험 신호.

**Q2 (★축이동 경계 — 핵심):** Claude의 "252를 canonical material로 확정하면 C-CAL-01과 충돌" 논리는 맞다(252/254를 최종 자재 정본으로 선언 금지). **그러나 032만 soft-delete하는 것은 252를 영구 canonical로 확정하는 행위가 아니다.** 032는 두 미래 시나리오 모두에서 junk: (a) 252가 material로 남으면 032=display-dup stale, (b) 252가 process로 이동해도 032=authority없음+BOM0+wrong-type orphan. → **Claude의 total-hold는 과보수.** 액션을 "032 soft-delete only, 252는 interim target일 뿐 최종 canonical 선언 금지"로 제한하면 C-CAL-01을 pre-empt하지 않는다.

**Q3 (그레이/블랙 평행):** 033/254를 이번 display-dup 하네스 BLOCKED 묶음에 넣은 건 over-extension. 033=`캘린더부자재 삼각대블랙`·254=`삼각대(블랙)`이라 동일 mat_nm display-dup 아님. C-CAL-01 co-target일 수는 있으나, 이 라운드 안전 cleanup 근거는 032/252 동일표시명 중복뿐. 033/254는 별도 normalization/axis-move 트랙으로.

**Q4 (NO-OP 정직성):** 0 safe loads는 정직한 결론이 아니다 — Claude가 safe cleanup 하나 놓침. **032만 soft-delete 후보 A로 승인. 252/254/033은 무변경.**

**최종 권고:** MAT_000032만 A(soft-delete stale)로 처리, 252/254 축이동·033 정리는 별도 C-CAL-01/normalization 트랙.

## 환각 경계 주석 (Claude)

- codex가 인용한 facts(032 type .02·authority 부재·BOM0·cp0·252 BOM1·process 0행)는 **전부 work-spec이 제공한 라이브 실측치** — codex가 새 사실을 날조하지 않음(환각 0). codex의 기여는 **사실 재해석**(032의 독립적 stale 성격)이지 사실 주장이 아니라 채택 위험 낮음.
- codex의 핵심 divergence 주장("032 단독 삭제는 252 canonical을 확정하지 않는다·032는 양 시나리오 junk")은 **검증 필요한 추론**. 아래 라이브 재실측으로 검증:
  - MAT_000032: use_yn=Y·del_yn=N·type .02·parent MAT_000031·**BOM 0(t_prd_product_materials 0행)·cp 0(t_prc_component_prices 0행)·자식 0(upr_mat_cd=032 가리키는 행 0)·option_items ref 0(ref_key1/ref_key2='MAT_000032' 0행)** → 모든 참조 테이블에서 고아. **삭제 시 손실 0 확정.**
  - MAT_000252/254: 각 BOM 1(PRD_000108/109·USAGE.07)·cp 0·option_items 미연결(ref_key 0행) → 아직 자재축에 존재·process param 미이전.
  - process master(거치/삼각대/받침): **0행** → C-CAL-01 mint 여전히 미충족·축이동 BLOCKED 유효.
- 결론: codex 추론은 **라이브로 검증됨**. 032는 어느 미래에서도 잃을 참조가 없는 고아 → 단독 soft-delete가 252의 자재 지위를 확정하지 않음. codex 채택 가능(가설→검증완료).
