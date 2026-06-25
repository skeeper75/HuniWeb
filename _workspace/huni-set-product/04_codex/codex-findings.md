# codex 독립 판정 — 엽서북(PRD_000094) 셋트 구성 (04_codex)

생성: hsp-codex-verifier · 검증가=Codex gpt-5.5(reasoning effort=high·`-s read-only`) · 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`
**codex 가용여부**: AVAILABLE (preflight=`AVAILABLE model=gpt-5.5`). 폴백 불필요.
**독립성**: Claude(설계가/게이트) 판정은 codex에 비노출. 같은 입력(설계·권위·적재본)만 제공·codex 단독 판정.
**경계[HARD]**: codex 주장 = **가설**(라이브/권위 확인 전 사실 아님·환각 경계). 전부 "확인 필요 후보"로 라우팅, 최종 판정은 S 게이트.

프롬프트 원본: `_codex-prompt.md` · raw 출력: `~/.claude/projects/.../tool-results/btr2lpqgb.txt`(80,392 tokens).

---

## codex 6질문 판정표 (verbatim 요지)

| 질문 | codex 판정 | codex 근거·이유 |
|---|---|---|
| 1. 구성원 유형 | **PASS** | 95·96 모두 PRD_TYPE.02(반제품)로 권위 체크리스트 명시(`set-checklist.csv:20-21`). 완제품/기성/디자인 혼입 근거 없음. |
| 2. 가격 가능성 | **FAIL** | 20P 한정으로만 PRICE≠0. 권위는 20/30P 택1인데 PRF_PCB_FIXED 구성요소가 `COMP_*_20P` 2개뿐·30P 단가행 부재(`design:103`·`blocked-board:2`). "엽서북 전체 가격 가능"=FAIL, "20P 한정"=PASS. **이중합산은 위험 낮음**(구성원 공식 0·셋트 자기공식 단독). |
| 3. 무결성 | **확인필요** | 복합PK (94,95)/(94,96) CSV상 중복 0·FK 구성원 존재 Y·유형 UPDATE `IS DISTINCT FROM` 가드로 멱등. **단** 셋트 UPSERT는 `ON CONFLICT DO UPDATE`에서 항상 `upd_dt=now()`라 재실행 시 물리 변경행/타임스탬프 계속 발생. **또** `sub_prd_qty=1` vs `min_cnt=20/max_cnt=30` 의미 상이 — `base=sub_prd_qty`로 보면 min20≤base≤max30 불일치. |
| 4. 권위 정합 | **PASS** | 내지 몽블랑240·표지 스노우300·페이지 20~30/+10 모두 권위 row61 일치. 경쟁사 naming/code 유입 근거 없음. |
| 5. false-positive | **PASS** | "구성원가 0 + 셋트공식 단독견적" 구조를 정상으로 인정(결함 오판 없음). always-add/택1 함정 없음 분리 타당. 30P 누락은 false-positive 아니라 **실재 가격 갭**. |
| 6. 면지 정규화 스펙 | **PASS** | 엽서북=MAT_000092·109(종이 2종)만 참조·면지 N/A 정확. MAT_000001~004 면지 4종을 확장 phase로 분리 타당. 논리삭제+출력소재 귀속+용도축 분리 방향 합리적. **단** 실제 재배선 대상 소재 확정은 확인 필요. |

---

## codex 추가 발굴 (설계가 놓친/과장한 것)

codex가 6질문 외 독립 발굴한 4건:

- **F-1 [본문 과장] 가격 결론 과대 표현** — §0 요약은 "가격 사슬 GO"라 쓰는데 같은 문서가 30P 견적 불가를 인정(`design:15`·`design:18`·`design:103`). → GO를 "20P 한정 GO"로 정정 권고.
- **F-2 [본문 부정확] page 차원 부재** — "사이즈/면/페이지/수량별 단가"라 설명하나 실제 `use_dims`=`[siz_cd, min_qty, print_opt_cd]`뿐·**page 차원 없음**(`design:71` vs `design:79-80`). 페이지는 comp 자체(20P/30P)로만 구분 → 권위 명세 문구가 실 차원과 불일치.
- **F-3 [본문↔SQL 불일치] UPDATE vs INSERT** — 본문/CSV는 "기존 행 UPDATE·신규 mint 0"인데 apply.sql은 `INSERT … ON CONFLICT DO UPDATE`라 행 부재 시 INSERT(`design:157` vs `apply.sql:26-30·41-45`). 안전장치일 수 있으나 산출물 설명과 실행 의미 상이.
- **F-4 [멱등성] UPSERT upd_dt 무가드** — 셋트 UPSERT에 값 변경 여부 가드 없어 반복 적용 시 `upd_dt` 계속 변경(`apply.sql:30-38·45-53`). 유형 UPDATE(`IS DISTINCT FROM`)와 비대칭.

---

## codex 종합 (verbatim)

> **엽서북 셋트 구성 메타데이터 보정만이라면 조건부 적용 가능.** 다만 "엽서북 견적 완결"로 적용하는 것은 **NO-GO**.
> 30P 가격이 권위 범위인데 단가/컴포넌트가 없고, 문서의 가격 GO 표현도 20P 한정으로 낮춰야 한다.
> 적용 전 최소 수정 = ① 30P BLOCKED를 적용 조건에 명시 ② 가격 GO 문구 정정 ③ UPSERT 멱등성 가드 여부 결정.

→ codex는 **셋트 행 보정(95·96 UPSERT·유형 04→01)은 적용 가능**으로, **"엽서북 견적이 완결된다"는 주장은 NO-GO**로 분리 판정. 핵심은 설계가 이미 BLOCKED로 정직하게 분리한 30P 갭을, §0 요약의 "가격 사슬 GO" 표현이 가린다는 것.
