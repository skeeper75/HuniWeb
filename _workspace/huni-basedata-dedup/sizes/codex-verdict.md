# codex 교차검증 원문 + 환각 주석 — 사이즈 축 Phase 3

생성: 2026-06-19 / 검증가: hbd-codex-verifier / 모델: **gpt-5.5** (codex exec, read-only, exit 0)
세션: 019edce0-71e4-7383-84bb-fd6e1816290d / reasoning effort: high / tokens: 49,267
입력: codex-prompt.txt (38 내부값 충돌그룹 + inch 이중라벨 + SIZ_000499, index.csv에서 추출한 실증거)

> 가용성: **AVAILABLE** (codex 정상 응답). Claude 단독 폴백 불필요.

---

## codex 원문 (verbatim 요지)

**Q1 (가드 증거 부재 그룹?): YES, 최소 2~3 그룹**
- `[165x115]` SIZ_000104 vs SIZ_000105: 둘 다 `'165x115mm(10장)'`·same dims·pd=N·plate0, shape/pack 차이 없음. pack도 둘 다 `(10장)` 동일 = 구분축 아님.
- `[297x420]` SIZ_000174 'A3(297x420mm)' vs SIZ_000315 'A3': 둘 다 active·pd=Y·동일 내부값. SIZ_000052만 plate19(가드), 174/315 사이엔 가드 증거 없음. pd=Y라 live merge BLOCKED·path Y 후보.
- 유사: `[420x594]` SIZ_000197 'A2(420x594mm)' vs SIZ_000317 'A2'도 동일 구조. (hypothesis, needs live check)

**Q2 (104/105 진짜 중복?): TRUE duplicate가 맞음.** Claude가 놓친 가장 강한 false-negative. CASCADE block 없음(pd=N) → cleanup 후보.

**Q3 (del_yn='Y' twin?): out of scope가 맞음.** 논리삭제 행을 "kept distinct"로 표현한 건 애매하나 실질 cleanup 누락 아님. status-only.

**Q4 (inch×mm 이중라벨?): sound.** SIZ_000308 '8x8(203x203mm)'=8inch≈203.2mm로 내부 203x203 정합. 나머지 5건은 siz_cd/dims 미제공 → hypothesis, needs live check.

**Q5 (SIZ_000499?): intentional plate modeling 판정이 더 강함.** 라벨 316x467 vs 내부 306x457(각축 -10mm)·impos_yn=Y·plate32·pd=Y. mis-load 단정 증거 없음·live fix BLOCKED.

**Q6 (PASS(NO-OP) 성급?): premature.** 가장 강한 divergence = SIZ_000104+SIZ_000105 (동일 display·dims·flags·pd=N·plate0 = 가드 없는 TRUE duplicate).

**최종 권고: DIVERGENCE — PASS(NO-OP) 불승인. 최소 104/105 merge 후보 flag, A3/A2 plain active twins는 path Y 후보로 live check.**

---

## 환각 경계 [HARD] — codex 인용 근거 실재성 대조 (index.csv)

| codex 인용 siz_cd | 주장 | index.csv 실재? | 데이터 일치? | 판정 |
|---|---|---|---|---|
| SIZ_000104 | '165x115mm(10장)'·165x115·pd=N·plate0 | ✅ 실재 | ✅ 정확 일치 (cut 165x115·pd=N·prd1/plate0) | **근거 실재 — 채택 가능** |
| SIZ_000105 | '165x115mm(10장)'·165x115·pd=N·plate0 | ✅ 실재 | ✅ 정확 일치 (104와 byte-identical) | **근거 실재 — 채택 가능** |
| SIZ_000174 | 'A3(297x420mm)'·297x420·pd=Y | ✅ 실재 | ✅ 일치 (pd=Y·prd22·cp12) | **근거 실재** |
| SIZ_000315 | 'A3'·297x420·pd=Y·plate0·prd1 | ✅ 실재 | ✅ 일치 (pd=Y·prd1·plate0·cp18) | **근거 실재** |
| SIZ_000197 | 'A2(420x594mm)'·420x594·pd=Y | ✅ 실재 | ✅ 일치 | **근거 실재** |
| SIZ_000317 | 'A2'·420x594·pd=Y·plate0·prd1 | ✅ 실재 | ✅ 일치 | **근거 실재** |
| SIZ_000308 | '8x8(203x203mm)'=inch 정합 | ✅ 실재 | ✅ 8inch≈203.2mm 정합 | **근거 실재 — Claude와 합의** |
| SIZ_000499 | 316x467 / 306x457 plate | ✅ 실재(BLOCKED) | ✅ 일치 | **근거 실재 — Claude와 합의** |

**환각 적발: 0건.** codex가 인용한 모든 siz_cd·치수·플래그가 index.csv에 실재하고 정확히 일치한다.
codex는 스스로 미제공 데이터(inch 나머지 5건·197/317 가드)를 "hypothesis, needs live check"로 정직하게 표기 — 환각 없음. 단 codex 주장(특히 104/105 merge·A3/A2 가드 부재)은 **가설→채택 전 라이브 재실측 권고**(아래 reconcile 참조).
