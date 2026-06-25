# codex 독립 판정 — 남은 6셋트 셋트 구성(책자류5+떡메모지·동형 전파 2차)

생성: hsp-codex-verifier · 검증가=Codex gpt-5.5(reasoning effort=high·`-s read-only`) · 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`
**codex 가용여부**: AVAILABLE (preflight=`AVAILABLE model=gpt-5.5`). 폴백 불필요.
**독립성**: Claude(설계가/게이트)·엽서북 판정은 codex에 비노출. 같은 입력(설계·권위·적재본 -ext)만 제공·codex 단독 판정.
**경계[HARD]**: codex 주장 = **가설**(라이브/권위 확인 전 사실 아님·환각 경계). 전부 "확인 필요 후보"로 라우팅, 최종 판정은 S 게이트.

대상: PRD_000072·077·082·088·097·100. 프롬프트 원본: `_codex-prompt-ext.md` · raw 출력: `~/.claude/projects/.../tool-results/b9z9y3lnw.txt`(144,597 tokens).

---

## codex 6질문 판정표 (verbatim 요지)

| 질문 | codex 판정 | codex 근거·이유 |
|---|---|---|
| 1. 구성원 유형 | **부분 PASS / 부모유형 확인필요** | 26 sub_prd_cd 전부 PRD_TYPE.02 정합(`set-checklist.csv:2-19,22-29`·`product-type-board.csv:3`)·혼입 0. **단** 부모 04→01 교정은 권위가 아직 CONFIRM-1(미확정)인데 설계가 "확정"으로 승격(`set-authority-spec.md:96`·`product-type-board.csv:5` directive↔webadmin 충돌 기록) → 즉시 PASS 불가. |
| 2. 택1 함정 | **PASS / 포토북 권위 확인필요** | 면지·표지 다중행=택1 카탈로그 판정 타당(SUM 해석 틀림·`set-authority-spec.md:67-70`). members=런타임 배열·행삭제=선택지 손실(`design-ext:84-86`). GUARD-1(가격 신설 시 평면합산 과대청구) 정확 식별(`design-ext:90-92`·`blocked-ext:5`). **단** 포토북 표지5종 택1은 CONFIRM-3 권위행 미특정(`set-authority-spec.md:98`). |
| 3. 가격 가능성 | **PASS** | 6셋트 PRICE=0 견적불가 정합(부모 공식0·구성원 공식0·사이즈/공정0·`set-authority-spec.md:80-88`·`design-ext:124-129`). 현 이중합산 0(더할 값 전부 0). **단** "진성 부재(comp 카탈로그 자체 없음)" 표현은 주어진 파일만으로 가격공식 바인딩 부재까지만 확실·comp 카탈로그 부존재까지는 직접 증명 안 됨 → 결론 "현 견적불가"는 충분. |
| 4. 무결성 | **부분 PASS / UPSERT 멱등성 FAIL** | 복합PK 26개 유일·중복0·행수 4+4+5+5+1+7 정합·FK 고아0(member_exists_live=Y). disp_seq 단조(072/077=1-4·082/088=1-5·097=1·100=1-7). 유형 UPDATE=`IS DISTINCT FROM` no-op 멱등. **단** 셋트 UPSERT는 `ON CONFLICT DO UPDATE`마다 `upd_dt=now()`라 값은 수렴해도 재실행 시 timestamp 계속 변경 → "변경 0" strict 멱등 깨짐(`apply-ext.sql:32-86`). |
| 5. 개수규칙 미충전 | **확인필요** | 떡메 NULL 유지 타당(50/100=묶음수 별테이블). **단** 하드커버/링책자 NULL은 판단 보류 — 권위가 내지 페이지 24~300/+2·8~100/+2를 명시하고 "set-designer가 채워야 할 셀"이라 기록(`set-authority-spec.md:58-62`)·CONFIRM-5 미해결(`:100`). NULL이 구조 오염은 아니나 이 설계가 갭을 "해소"했다고 볼 수는 없음. 포토북=CONFIRM-3. |
| 6. false-positive / 누락 | **부분 PASS / 일부 누락** | 택1 정상구조 결함 오판 0(PASS). 떡메1행·포토북7행·disp_seq/note 본문↔CSV↔SQL 불일치 없음. **놓친 결함 3건**(아래 F-1~F-3). |

---

## codex 추가 발굴 (설계가 놓친/과장한 것)

codex가 6질문 외 독립 발굴한 3건:

- **F-1 [본문 과장] 부모 04→01 권위 미확정인데 "확정" 승격** — 설계 §0(`design-ext:20`)이 "RM-3 정책=완제품 교정 확정"으로 쓰는데, 권위 파일은 아직 CONFIRM-1(인간 확인 필요·`set-authority-spec.md:96`·`product-type-board.csv:5`). directive↔webadmin "반제품만 제외" 정책 충돌이 권위 레벨에서 미해소. → 유형 UPDATE를 보류하거나 별도 승인으로 분리 권고.
- **F-2 [본문↔SQL 불일치] UPDATE 주장 vs INSERT…ON CONFLICT** — apply-ext.sql 헤더/주석은 "신규 mint 0·전부 보정/UPDATE"인데 실제 SQL은 `INSERT … ON CONFLICT DO UPDATE`라 선행 행 부재 시 INSERT 발생(`apply-ext.sql:20-23,27`). 기존 26행 존재 근거는 reuse-map·search-before-mint에 있으나 **SQL 자체에 preflight 가드는 없음**.
- **F-3 [멱등성] UPSERT upd_dt 무가드** — 셋트 6블록 전부 `DO UPDATE … upd_dt=now()` 무조건 실행 → 재실행 시 물리 변경행/timestamp 계속 발생. 유형 UPDATE(`IS DISTINCT FROM`)와 비대칭. (엽서북 1차 F-4와 동일 패턴 — 동형 전파됨.)

---

## codex 종합 (verbatim)

> 이 6셋트 적재본은 **그대로 적용 비권장**이다. 구성원 26행의 타입·택1 구조·row mapping 자체는 대체로 타당하지만,
> 부모 유형 04→01은 권위상 미확정이고, apply-ext.sql은 "신규 0/멱등" 주장과 달리 missing row 삽입 가능성과 upd_dt 반복 변경이 있다.
> 최소 수정 = ① 부모 유형 UPDATE를 보류하거나 별도 승인으로 분리 ② 셋트 UPSERT에 기존행 preflight 또는 UPDATE-only + timestamp no-op 가드를 넣은 뒤 적용.

→ codex는 **구성원 행 보정(26행 택1·row mapping)·가격 BLOCKED·택1 판정**은 타당으로, **부모 유형 04→01 승격**과 **SQL 멱등성 주장**은 비권장으로 분리 판정. 핵심: 설계가 정직하게 분리한 BLOCKED·택1은 인정하되, ① 부모 유형교정의 권위 근거 강도(CONFIRM-1 미해소), ② SQL이 본문의 "UPDATE·멱등" 주장과 다른 점을 지적.
