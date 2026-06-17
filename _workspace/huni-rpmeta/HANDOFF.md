# Huni-RP-Meta 하네스 — HANDOFF

> RedPrinting 옵션 관리 메타모델 역공학 → 후니 기초데이터 관리 "그릇" 설계 하네스.
> 트리거·변경이력 = CLAUDE.md §11 · 메모리 [[huni-rpmeta-harness]].
> 최종 갱신: 2026-06-17 (PR·ST·CL·AC·PD 5개 카테고리 종단 + PH reverse·17축 수렴)

---

## 진행 현황 (8 종단 GO + PH reverse·26 카테고리 중)

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
| 9 | **PH 포토보드·액자** | 30 | **reverse만 완료** (1차 예측 facet·미확정) | ⚠️ reverse 후 중단 |

상품 커버리지 누적 ≈ 327/479 (68%). 메타모델 = **17축**(7정적 + 발굴 10; #16 TP·#17 ST).

---

## 다음 시작점 (fresh 세션이 바로 할 것)

### 1순위 — **PH 파이프라인 재개** (reverse 완료·metamodel부터)
PH는 `categories/PH/reverse.md`(266줄·완결)까지만 산출되고 **API 529로 이후 단계 중단**. 남은 것:
- **metamodel** (`rpm-metamodel-architect`) — PH-1~PH-5 판정. 1차 예측 = **distinct 0(facet)**:
  액자 프레임 재질=pdtCode 분기(자재#1)·사진인화 매체=자재 surface-finish·보드=PR포스터 동형·포토북=PR책자 동형·포토굿즈=GS 동형.
- **★PH 고유 블로커**: 액자 11상품·사진인화 8상품 라이브가 **전부 SSR-negative(Vue client-render)** —
  마운팅/거치(벽걸이/탁상)·전면 보호재(유리/아크릴)·후면 받침 옵션 **미관측(unobserved·날조 금지)**.
  **distinct #18(마운팅 축) 판정의 결정적 미싱데이터** → metamodel/gap이 ① chrome MCP client-render 재캡처
  또는 ② 후니 도메인 권위로 PH-1/PH-2 확정해야. 현 상태로는 "facet 1차 예측·미확정".
- 이어서 gap → deepcheck(codex gpt-5.5) → vessel → visualize → M1~M6. (PR/CL/AC/PD 경량 패턴)
- **`_index.md`에 PH 커버리지 행 미추가** — reverse 에이전트가 529로 못 함. metamodel 재개 시 또는 직접 추가.

### 2순위 — 선별 잔여 (사용자 "신규 축 가능성 높은 것만 선별" 모드)
- **FS 패브릭(21)** — 직물/봉제 굿즈. CL 의류·PD 봉제·GS 소재 facet과 겹침 예상(distinct 가능성 낮음).
- 그 외 18개 미분석은 17축 검증 성격(새 축 가능성 낮음). 전수는 사용자가 보류함.

### 3순위 — carry-forward 미검증 후보 (라이브 실측 대상)
- **AC deepcheck**: H-1 layer-stack(D-13) = REFUTED-for-RP 완료. H-2~H-7(엣지가공·렌티큘러·hole geometry) unverified 잔존.
- **PD deepcheck**: H-1 Construction Spec = data-gap 프레임(기각 예상). inner core 물성·footwear fit·care/safety = PD-4 data-gap 적재 attribute 후보.
- **BN deepcheck PENDING** (codex 해소 전 산출) — `categories/BN/_tmp/` 컨텍스트 보존, 재실행 가능.
- **TP H-3** (에디터 preflight 프로파일) 미검증 carry-forward.

### 4순위 — open decision (인간 결정)
- `04_vessel/_vessel-roadmap.md` 참조. 특히 **A-4 단일 부자재 마스터**(AC 고리/받침·ST SUB_MTR 동일코드·D링 4버킷 분산·3중복) = round-22 ④자재 B-3 조율 필요(designer 단독 mint 금지).
- 신규 테이블 mint 후보 = V-11(TemplateAsset)·V-12(형상축 SHAPE) 2건만. 나머지 전부 컬럼/코드행.

---

## 이번 세션 결정 (relitigate 금지)

- **★메타모델 수렴 = 17축** — 16축이 BN/GS/TP/PR 4카테고리 안정 → ST에서 형상 #17 정직 승격 → CL/AC/PD
  연속 재포화(각각 가장 강한 #18 후보를 적대 검증으로 부결). 외부 모델(codex gpt-5.5)도 #18 부결에 독립 동의.
- **★승격/부결 일관 기준 [HARD]** — distinct 축 승격 = ① 전용 슬롯이 라이브에 실재 + ② 후니 KB가 "기존 축이
  못 담음" 결함 명시. 둘 다면 승격(ST 형상=shape_info 슬롯+KB G-SK-2), 기존 축이 왜곡 없이 담으면 부결
  (AC 가공방식·layer-stack·CL 의류variant·PD 내재BOM). "외형이 이질적"은 기준 아님.
- **★vessel-gap vs data-gap [HARD]** — 축 부재=vessel-gap(신규 그릇 필요·ST 형상 V-12), 축 있으나 미적재
  =data-gap(dbmap 적재 트랙·PD-4 내재BOM=addons/usage 그릇 실재). 라이브 그릇 실재 여부로 판별.
- **신규 그릇 = ST V-12(형상축 SHAPE: base_code 6코드행+컬럼2·테이블0) 1건만.** PR/CL/AC/PD = 0건(기존 V 흡수).
- **codex 모델 = gpt-5.5** (config.toml 영구). codex "라이브 인용→checkable" 신뢰 금지(네트워크 격리
  confabulation). 모든 후보 unverified·검증 트리거로만. AC layer-stack(D-13) 캡처 실측으로 REFUTED가 실증.
- **카테고리별 Low 결함 정정 완료** — PR D-6/D-7·ST(none)·CL D-CL-1/2/3·AC D-AC-1·PD D-PD-1(밑창색
  six_clr→SUB_MTR 재귀속). PD D-PD-2(Low·태그 슬랙·무영향)만 open.

---

## 건드리지 말 것 (검증완료·보존)

- **8 카테고리 종단 산출** — `categories/{BN,GS,TP,PR,ST,CL,AC,PD}/` + 02~05 cross-cutting(v8.0) = M1~M6 GO.
- **PH reverse** — `categories/PH/reverse.md`(266줄·완결·1차판정 facet). metamodel 입력으로 보존.
- **그릇 처방** — `04_vessel/` V-1~V-12 + DDL 제안 `_workspace/huni-dbmap/11_ddl_proposals/ddl-proposal-{design-input-channel,template-asset,shape-axis}.sql` (DRY-RUN 0 leaked·DB 미적재·인간 승인 대기).
- **커밋** — f48d368(PR)·fac0d16(ST)·622c6e0(CL)·cf6e73c(AC)·0a3b018(PD). 되돌리지 말 것.
- **codex config** — `~/.codex/config.toml` model=gpt-5.5 (백업 보유).
- **에이전트 7 + 스킬 7** — `.claude/agents/huni-rpmeta/` · `.claude/skills/{rpm-*,huni-rpmeta-orchestrator}`.

---

## 핵심 발견 (요약)

- 메타모델 **17축** = 7정적 + 발굴 10 distinct(#16 디자인입력채널=TP·#17 형상=ST 기여).
- **수렴 입증** — 8 카테고리(상품 68%)에서 ST만 새 축 1개 추가, 나머지 전부 재포화. 모델이 증거에 양방향
  정직(과잉승격·과소강등 모두 적대 검증). 남은 카테고리는 검증 성격(새 축 가능성 낮음).
- **신규 그릇 최소** — 신규 테이블 mint 2건(V-11 TemplateAsset·V-12 SHAPE)뿐. 나머지 facet은 기존 t_*
  컬럼/코드행/JSONB로 무손실 수용(search-before-mint 8연속 통과). 후니 17축 그릇이 RedPrinting 카탈로그
  전반을 견딘다는 강한 신호.
