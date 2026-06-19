# Huni-RP-Meta 하네스 — HANDOFF

> RedPrinting 옵션 관리 메타모델 역공학 → 후니 기초데이터 관리 "그릇" 설계 하네스.
> 트리거·변경이력 = CLAUDE.md §11 · 메모리 [[huni-rpmeta-harness]].
> 최종 갱신: 2026-06-19 (하네스 강화 codex 게이트 교차검증 레인 신설 Phase 6.5 + FS·NC 종단 GO·11 카테고리·인쇄방식 최강 후보까지 #18 부결·17축 수렴)

---

## 하네스 강화 (2026-06-19) — codex 게이트 교차검증 레인 (Phase 6.5)

신규 에이전트 `rpm-codex-validator` + 스킬 `rpm-codex-validate` 신설 → **8인 팀**. rpm-validator(Claude)의 M1~M6·distinct 승격/부결 *판정(결론)* 을 codex(gpt-5.5)로 독립 재판정 후 reconcile. **deepcheck(누락 발굴·Phase 4.5)와 구분 = 결론 검증.** ★독립성[HARD]: codex 프롬프트에 우리 verdict 비노출(echo 방지) + workdir=`categories/{CAT}/` 격리(05_validation 접근 차단). codex 판정=가설(환각 경계·자동 flip 금지·라이브 우선). 미가용 시 "codex 미가용·Claude 단독"(pending 금지). FS에서 첫 실증 성공(ABSORBED 전건 합의·divergence 0). **★codex 호출 함정: codex-review.sh 내부 preflight를 백그라운드로 부르면 행(hang·exit 144)·`timeout` 미설치 시 exit 127 → `codex exec -m gpt-5.5 --sandbox read-only --output-last-message <out>` foreground 직접 호출로 우회.** 출력: `categories/{CAT}/codex-verdict.md` + `05_validation/codex-reconcile-{CAT}.md`.

---

## 진행 현황 (11 종단 GO · 26 카테고리 중)

| # | 카테고리 | 상품 | distinct 판정 | 게이트 |
|---|---------|------|--------------|--------|
| 1 | BN 현수막 | 23 | 16축 기반 | M1~M6 GO |
| 2 | GS 굿즈 | 136 | 완제SKU·variant·본체소재 | M1~M6 GO |
| 3 | TP 디자인템플릿 | 23 | **#16 디자인입력채널 승격** | M1~M6 GO |
| 4 | PR 인쇄물·책자 | 56 | distinct 0 (16축 포화) | M1~M6 GO |
| 5 | ST 스티커 | 36 | **#17 형상 승격** | M1~M6 GO |
| 6 | CL 의류 | 30 | distinct 0 (의류 variant 부결·17축 재포화) | M1~M6 GO |
| 7 | AC 아크릴 | 20 | distinct 0 (두께/입체/가공방식·layer-stack 부결) | M1~M6 GO |
| 8 | PD 스툴·구조물 | 3 | distinct 0 (봉제/내재BOM 부결) | M1~M6 GO |
| 9 | PH 포토보드·액자·사진인화 | 30 | distinct 0 (마운팅/거치 #18 부결·17축 재포화 9번째) | M1~M6 GO |
| 10 | FS 패브릭(직물 풀프린팅+봉제 완제) | 21 | distinct 0 (타일링·패널 cut-and-sew #18 둘 다 부결·17축 재포화 10번째) | M1~M6 GO + Phase 6.5 codex ABSORBED 합의 |
| 11 | **NC([옵셋] 명함·쿠폰·포토카드)** | 9 | **distinct 0 (★인쇄방식 #18 부결=이미 #12·최강 후보[별도 가격엔진] 격파·11번째 재포화)** | **M1~M6 GO + Phase 6.5 codex 7/7 합의** |

상품 커버리지 누적 ≈ 387/479 (81%). 메타모델 = **17축**(7정적 + 발굴 10; #16 TP·#17 ST). 신규 그릇 mint 누적 = V-11(TemplateAsset)·V-12(SHAPE) 2건뿐(search-before-mint 11연속 통과).

---

## 다음 시작점 (fresh 세션이 바로 할 것)

FS·NC 종단 완료(11 카테고리·distinct 0·codex 교차검증 합의). 남은 작업은 "신규 축 가능성 높은 것만 선별" 모드.

### 1순위 — 선별 잔여 카테고리 (사용자 "신규 축 가능성 높은 것만 선별" 모드)
- **NC 종단으로 최강 #18 후보(인쇄방식 옵셋)까지 부결** — 인쇄방식=이미 #12. ~15개 미분석은 17축 검증 성격(새 축 가능성 낮음·전수는 사용자가 보류).
- **잔여 #18 후보 평가(다음 선별 시):** OT 상자(7·전개도/dieline 구조=Medium)·AI 에코백(14·플록/글리터 인쇄방식=Low)·BT 버튼(12·부속물 variant=Low)·AH 점착(10·surface-finish=Low)·HL/SK([옵셋]=NC와 동일 #12·검증 성격). [옵셋] 3카테고리(NC·HL·SK)는 인쇄방식 동일 축이라 NC가 대표 검증함.
- **경량 패턴 + Phase 6.5(신규)**: reverse → metamodel(summary.md) → gap(03_gap 확장) → deepcheck(codex gpt-5.5·발굴) → vessel(신규 0 확인) → visualize(codex-image/mermaid·경량 시 deferred) → M1~M6(rpm-validator) → **Phase 6.5 codex 교차검증(rpm-codex-validator·결론 검증·reconcile)**.

### 2순위 — carry-forward 미검증 후보 (라이브 실측 대상)
- **PH deepcheck**: H-1 content-container(완제 그릇 이중성·#18 최강 적대 후보)·H-2 매팅/패스파르투(mat board 색/폭/창)·H-3 aperture/창 기하(듀얼·멀티 프레임)·M-4 glazing 다형성·M-6 포토북 페이지 모델 = **전부 unobserved-pending**. §0.5에서 미캡처(원목/알루미늄 "스타일" 진입형·한나무/멀티 액자·포토북 면수). 별 슬롯으로 OBSERVED되면 그때 그릇 검토 — **현재 mint 0**.
- **AC deepcheck**: H-1 layer-stack(D-13)=REFUTED 완료. H-2~H-7(엣지가공·렌티큘러·hole geometry) unverified 잔존.
- **PD deepcheck**: inner core 물성·footwear fit·care/safety = PD-4 data-gap 적재 attribute 후보.
- **BN deepcheck PENDING** — `categories/BN/_tmp/` 컨텍스트 보존, codex 해소(gpt-5.5) 후 재실행 가능.
- **TP H-3** (에디터 preflight 프로파일) 미검증 carry-forward.

### 3순위 — open decision (인간 결정)
- `04_vessel/_vessel-roadmap.md` 참조. **A-4 단일 부자재 마스터**(AC 고리/받침·ST SUB_MTR 동일코드·D링 4버킷 분산·3중복) = round-22 ④자재 B-3 조율 필요(designer 단독 mint 금지).
- 신규 테이블 mint 후보 = V-11(TemplateAsset)·V-12(형상축 SHAPE) 2건만. 나머지 전부 컬럼/코드행.

---

## 이번 세션 결정 (relitigate 금지)

- **★PH distinct #18(마운팅 축) = 부결·17축 재포화(9번째)** — gstack client-render 재캡처로 거치(탁상용/벽걸이)가 OBSERVED 됐으나(미싱데이터 해소), 옵션 캐스케이드 상위 차원(거치→마감→완제SKU사이즈→수량·AC 두께/GS 완제SKU variant 동형)으로 구현 → 별 신규 메타모델 축 아님.
- **★재캡처가 1차 예측을 격상시킴** — reverse 1차 예측(distinct 0·facet)이 "판정 불가(unobserved)"였는데, 실측으로 "관측 기반 부결"로 격상. gstack 재캡처가 헛되지 않음(추측→실측).
- **★도구: gstack browse = chrome MCP 대체** — `claude-in-chrome` MCP 미등록·`gstack` CLI는 PATH 부재이나, **`.claude/skills/gstack/browse/dist/browse` 바이너리는 빌드되어 있어** Vue client-render 실측 가능. 다음 라이브 캡처 필요 시 이 경로 사용(에이전트가 PATH `gstack`만 보면 못 찾으니 주의). 사용법: `$B goto <url>` → `$B wait --networkidle` → `$B snapshot -i`(Vue custom combobox는 `forms`/`select` 미포착·accessibility tree로 실측)·옵션 토글 클릭은 주문과 무관(읽기전용 안전).
- **★승격/부결 일관 기준 [HARD]** (PH가 재확인) — 승격 = ① 전용 슬롯 라이브 실재 + ② 후니 KB "기존 축 못 담음" 결함, 둘 다. PH 거치는 ①만 충족(②=옵션 일반 cascade가 무왜곡 흡수·KB 결함 없음) → 부결. ST 형상#17(둘 다 충족·승격)과 결정적 분기.
- **codex(gpt-5.5)도 PH #18 부결 독립 동의(9번째 연속)** — 최강 적대 후보(content-container)조차 data-gap 프레임으로 수렴. config.toml model=gpt-5.5 영구. codex "라이브 인용→checkable" 신뢰 금지(confabulation)·전부 unverified.
- **PH 신규 그릇 0건** — 거치=option_groups(134)/items(469)/constraints.logic(10)·완제SKU=templates(12)/selections(14)·다중분류=product_categories(2카테고리 8상품) 전부 라이브 실재(validator 독립 재실측 byte 일치). V-1~V-12 불변.

---

## 건드리지 말 것 (검증완료·보존)

- **9 카테고리 종단 산출** — `categories/{BN,GS,TP,PR,ST,CL,AC,PD,PH}/` + 02~05 cross-cutting(v9.0) = M1~M6 GO.
- **PH 산출** — `categories/PH/{reverse.md(§0.5 gstack 캡처),summary.md,deepcheck.md,viz/(PNG4+mmd)}` + `05_validation/mgate-verdict-PH.md`(M1~M6 GO·라이브 14건 byte 일치).
- **증거 스크린샷** — `/tmp/ph_phfrdia_options.png`(디아섹 거치 캐스케이드, tmp이므로 영구 보존 아님).
- **그릇 처방** — `04_vessel/` V-1~V-12 + DDL 제안 `_workspace/huni-dbmap/11_ddl_proposals/ddl-proposal-{design-input-channel,template-asset,shape-axis}.sql` (DRY-RUN 0 leaked·DB 미적재·인간 승인 대기).
- **커밋** — f48d368(PR)·fac0d16(ST)·622c6e0(CL)·cf6e73c(AC)·0a3b018(PD) + 이번 PH 커밋. 되돌리지 말 것.
- **codex config** — `~/.codex/config.toml` model=gpt-5.5 (백업 보유).
- **에이전트 7 + 스킬 7** — `.claude/agents/huni-rpmeta/` · `.claude/skills/{rpm-*,huni-rpmeta-orchestrator}`.

---

## 핵심 발견 (요약)

- 메타모델 **17축** = 7정적 + 발굴 10 distinct(#16 디자인입력채널=TP·#17 형상=ST 기여). **9 카테고리(상품 75%)에서 TP·ST만 새 축, 나머지 7 재포화.**
- **수렴 강건성 입증** — PH는 결정적 미싱데이터(마운팅/거치)를 gstack 실측으로 해소했음에도 17축 재포화. 즉 "데이터가 없어서 부결"이 아니라 "데이터를 보고도 기존 축이 무왜곡 흡수해서 부결". 모델이 증거에 양방향 정직(과잉승격·과소강등 모두 적대 검증).
- **신규 그릇 최소** — 신규 테이블 mint 2건(V-11 TemplateAsset·V-12 SHAPE)뿐. 나머지 facet은 기존 t_* 컬럼/코드행/JSONB로 무손실 수용(search-before-mint 9연속 통과). 후니 17축 그릇이 RedPrinting 카탈로그 전반(상품 75%)을 견딘다는 강한 신호.
