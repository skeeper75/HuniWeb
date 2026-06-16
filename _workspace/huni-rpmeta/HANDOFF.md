# Huni-RP-Meta 하네스 — HANDOFF

> RedPrinting 옵션 관리 메타모델 역공학 → 후니 기초데이터 관리 "그릇" 설계 하네스.
> 트리거·변경이력 = CLAUDE.md §11 · 메모리 [[huni-rpmeta-harness]].
> 최종 갱신: 2026-06-17 (TP 종단 완주 + codex 데드락 해소)

---

## 다음 시작점 (fresh 세션이 바로 할 것)

**★ codex 데드락 해소됨 — deepcheck·시각화 PNG 둘 다 이제 가용.** 우선순위 순서:

1. **다음 카테고리 확대** (codex 가용·즉시 진행) — 미발굴 축을 드러낼 카테고리:
   - **PM(화보책자 2)·PH(포토북 30)** — 책자 제본 계층(페이지수·내지/표지·imposition)
   - **옵셋류 NC/HL/SK** — 인쇄방식 1급화 open decision(D-7) 실증 해소
   - **OT(상자 7)** — 전개도/구조 축
   `huni-rpmeta-orchestrator`에 "{카테고리} 옵션 분석" → reverse→metamodel→gap→deepcheck→vessel→
   visualize. 풀 파이프라인(deepcheck/PNG 포함) 가능.

2. **BN 심층보강 재개** (codex 해소로 차단 풀림) — `categories/BN/deepcheck.md` PENDING.
   `huni-rpmeta-orchestrator`에 "BN 심층보강 다시" → `rpm-deepcheck`가 보존 컨텍스트
   `categories/BN/_tmp/rpm-bn-context.md`(갭발굴 질문 A~E)로 즉시 재실행.

3. **TP carry-forward 후보 검증** — `categories/TP/deepcheck.md` H-3(에디터 preflight 프로파일·
   bleed/safe-zone/DPI)이 base-data 가능성으로 유지된 미검증 후보. 라이브 실측 검증 대상.

4. **open decision 해소** (인간 결정) — `04_vessel/_vessel-roadmap.md` 참조: TP editor_yn 운명·
   VDP 변수 스키마 본문(관측 전 mint 금지)·에디터 종류 백필 출처·MAT_TYPE.09/.10 교정 순서(dbmap B-3).

---

## 미해결 / 블로커

- **🟢 codex 데드락 = 해소** — 근본원인이 핸드오프 오진단(버전 0.38.0)이 아니라 **모델 선택**이었음:
  codex 바이너리는 이미 0.140.0(`~/.local/bin/codex`, npm 글로벌 0.38.0과 별개 경로), 데드락 원인은
  기본 모델 `gpt-5-codex`(ChatGPT 계정 400 미지원). **`~/.codex/config.toml` 기본 모델을 `gpt-5.5`로
  교체**(백업 `config.toml.bak_gpt5codex`)하여 영구 해소. `gpt-5`·`gpt-5-codex` 미지원·`gpt-5.5` 지원.
  검증=trivial ping PONG. **codex 모델 변경 시 gpt-5.5만 사용.**
- **🟡 BN deepcheck PENDING** — 이제 실행 가능(위 2순위). 컨텍스트 `categories/BN/_tmp/` 보존.
- **🟡 TP H-3 미검증 carry-forward** — 위 3순위.
- **🟡 시각화 = mermaid (PNG 아님)** — BN·TP viz는 `.mmd`. codex 가용해졌으니 동일 파일명 PNG로
  덮어쓰면 summary.md 링크 무손상(선택).

---

## 이번 세션 결정 (relitigate 금지)

- **codex 모델 = gpt-5.5** — config.toml 영구 설정. gpt-5-codex/gpt-5는 ChatGPT 계정 미지원(400).
- **★codex "라이브 인용 보유 → 즉시 checkable" 분류 = 증거로 신뢰 금지 [HARD 교훈]** — codex는 네트워크
  격리 샌드박스(`mcp_servers='{}'`)로 실행돼 라이브 fetch 불가. "라이브 인용"은 confabulation일 수 있음.
  **검증 트리거로만 쓰고 실측 전엔 unverified**(H-8 기각이 실증).
- **TP = 16번째 축 #16 "디자인 입력 채널" distinct 승격** — BN·GS 미발굴. 15축→16축(7버킷+발굴 10).
  결정적 증거 = TPCLSTD(TP) vs HLCLSTD(옵셋) 트윈 대조(본체 동일·입력채널만 차이).
- **템플릿 이중의미 분리 [HARD]** — TP 디자인시안(가격0 에디터 리소스)을 후니 `t_prd_templates`(완제SKU)에
  적재 금지(의미 오염). 별 엔티티 `TemplateAsset`(V-11 신규테이블).
- **HIGH 3건 검증 전부 기각·모델 무변동** — H-6 VDP(facet 유지·SDK 메서드 종속)·H-8 포토카드 set
  (수량모델#10 충분)·H-1 STATE축(주문 런타임=out-of-scope·dbmap MES 영역). 모델 robustness 입증.

---

## 건드리지 말 것 (검증완료·보존)

- **TP 분석 산출** — `categories/TP/`(reverse·deepcheck·summary·viz) + 02~05 extend = M1~M6 전건 GO.
- **BN·GS 분석 산출** — `categories/{BN,GS}/` + 02~05(메타모델 16축·갭·그릇) = M1~M6 전건 GO.
- **그릇 처방 V-10/V-11** — `04_vessel/vessel-design-input-channel.md`·`vessel-template-asset.md` +
  DDL 제안 `_workspace/huni-dbmap/11_ddl_proposals/ddl-proposal-{design-input-channel,template-asset}.sql`
  (DRY-RUN 0 leaked·DB 미적재·인간 승인 대기).
- **codex config** — `~/.codex/config.toml` model=gpt-5.5 (되돌리지 말 것·백업 보유).
- **에이전트 7 + 스킬 7** — `.claude/agents/huni-rpmeta/` · `.claude/skills/{rpm-*,huni-rpmeta-orchestrator}`.

---

## 핵심 발견 (요약)

- 메타모델 **16축** = 7정적 + 발굴 10 distinct(#16 디자인 입력 채널 = TP 기여).
- **#16 디자인 입력 채널 = 후니 vessel-GAP** — `t_prd_products`에 editor_yn/file_upload_yn 불리언 2개뿐,
  item_gbn/에디터종류/koi_template_resource_id/VDP 그릇 0건. dbmap 미터치 순신규 갭(충돌 0).
- **TP가 추가하는 단 하나 = 디자인 입력 레이어** — 자재·사이즈·후가공·가격은 동종(옵셋 등) 100% 공유.
- 실 그릇 처방 = V-10 컬럼(채널 1:1·신규테이블 0) + V-11 신규테이블 2(시안 1:N·이중의미). 인간 승인 + dbmap 트랙.
