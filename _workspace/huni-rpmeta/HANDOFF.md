# Huni-RP-Meta 하네스 — HANDOFF

> RedPrinting 옵션 관리 메타모델 역공학 → 후니 기초데이터 관리 "그릇" 설계 하네스.
> 트리거·변경이력 = CLAUDE.md §11 · 메모리 [[huni-rpmeta-harness]].
> 최종 갱신: 2026-06-17 (커밋 `95d8cf9`)

---

## 다음 시작점 (fresh 세션이 바로 할 것)

우선순위 순서:

1. **codex 심층보강 재개 (환경 해소 후)** — BN deepcheck가 PENDING. codex 데드락 해소 시
   `huni-rpmeta-orchestrator`에 **"BN 심층보강 다시"** → `rpm-deepcheck`가 보존된 컨텍스트
   `categories/BN/_tmp/rpm-bn-context.md`(갭발굴 질문 A~E 포함)로 즉시 재실행. **해소 조건**:
   `OPENAI_API_KEY` 설정 후 codex API 모드, 또는 codex가 gpt-5.5 지원 버전 출시. (아래 블로커 참조)

2. **다음 카테고리 확대** (codex 무관하게 진행 가능) — 미발굴 축을 드러낼 카테고리:
   - **TP(디자인템플릿 23)** — 템플릿/에디터 축 (BN·GS 미발굴)
   - **PM(화보책자 2)·PH(포토북)** — 책자 제본 계층
   - **옵셋류 NC/HL/SK** — 인쇄방식 1급화 open decision(D-7) 실증 해소
   - **OT(상자 7)** — 전개도/구조 축
   `huni-rpmeta-orchestrator`에 "{카테고리} 옵션 분석" → reverse→metamodel→gap→(deepcheck)→vessel→
   visualize(mermaid 폴백 가능). 시각화는 codex 없이 mermaid로 즉시 가능.

3. **open decision 해소** (vessel 설계가 남긴 인간 결정) — `04_vessel/_vessel-roadmap.md` 참조:
   인쇄방식 1급화 여부·본체색 목적지·MAT_TYPE.09/.10 교정 순서(dbmap B-3 강결합)·용량 슬롯 등.

---

## 미해결 / 블로커

- **🔴 codex 데드락 (HARD)** — `codex-cli 0.38.0`이 npm 최신인데 ChatGPT 계정에서 `gpt-5-codex` 등은
  `400 not supported`, 계정이 요구하는 `gpt-5.5`는 `requires newer Codex`로 거부. 버전-계정 불일치라
  `npm update`로 안 풀림(이미 최신). 같은 시도 반복 금지. → **codex-cli 심층보강 + codex-image PNG 둘 다 차단.**
  해소: API 키 모드 or 신버전 대기. (`codex login status`는 만료 토큰도 "Logged in"으로 오보고 → 두 스킬에
  trivial ping 사전점검 추가됨)
- **🟡 BN 심층보강 PENDING** — `categories/BN/deepcheck.md`가 PENDING 상태. codex 해소 후 재실행.
- **🟡 시각화 = mermaid (PNG 아님)** — BN viz 4종은 `.mmd`(mermaid 소스). codex/gpt-image2 가용 시
  동일 파일명 PNG로 덮어쓰면 summary.md 링크 무손상.

---

## 이번 세션 결정 (relitigate 금지)

- **산출 구조 = 하이브리드** — `categories/{CAT}/`(reverse·deepcheck·summary·viz) 카테고리 집약 +
  `02~05` 횡단 누적 + `_index.md`. (메타모델·갭·그릇은 전 카테고리 누적이라 단계별이 본질)
- **codex 활용 = 7인 팀** — rpm-visualizer(codex-image 시각화)·rpm-deepcheck(codex-cli 심층보강) 신설.
- **환각경계 [HARD]** — codex(OpenAI) 제안 = unverified 가설. 라이브/엑셀 검증 후 채택. 실패 시 후보 날조 0.
- **mermaid 폴백 ladder** — codex-image→gpt-image2→mermaid. raster 막히면 mermaid(텍스트·환각0)로 시각화.
- **에이전트 ≠ 스킬명** — rpm-deepcheck(에이전트) vs rpm-deep-augment(스킬). rpm-visualizer vs rpm-visualize.
- **RedPrinting = 검증된 참조** — 모델은 흡수, naming/codes는 후니 유입 금지. 대표샘플(전수수집 금지).

---

## 건드리지 말 것 (검증완료·보존)

- **BN·GS 분석 산출** — `categories/{BN,GS}/reverse.md` + `02~05`(메타모델 15축·갭·그릇) = M1~M6 전건 GO.
- **BN 시각화** — `categories/BN/viz/*.mmd` 4종 (분석 충실·환각0 검증됨).
- **커밋** — `ccf257a`(하네스 신설+BN/GS 종단), `95d8cf9`(강화+BN 시각화). undo 금지.
- **에이전트 7 + 스킬 7** — `.claude/agents/huni-rpmeta/` · `.claude/skills/{rpm-*,huni-rpmeta-orchestrator}`.

---

## 핵심 발견 (요약)

- 메타모델 **15축** = 7정적(자재/공정/옵션/템플릿/제약/기초코드/카테고리) + 발굴 8 distinct.
- **굿즈 본체자재 결함 = vessel-gap** — `t_mat_materials`에 분해축(body_color/capacity/thickness) 컬럼 부재
  → 소재가 상품명 의존. (데이터 미적재 아님)
- **MAT_TYPE.09 "파우치"·.10 "악세사리"** = 자재유형을 상품군명으로 만든 vessel-level 오라벨(112행 비자재).
- 실 그릇 처방은 최소(코드행/컬럼, 신규 테이블 0). 실 적용은 인간 승인 + dbmap 트랙.
