---
id: SPEC-STAFFBRIEF-001
doc: plan
version: "0.1.1"
updated: 2026-09-08
status: in-progress
tier: M
---

# 실행 계획 — SPEC-STAFFBRIEF-001

> 마일스톤 순서 원칙: **번복 가능성이 큰 결정을 앞에** 둔다. 본 카드에서 가장 번복 가능성이 큰 것은 본문 내용(구성 · 서사 · 수치 배치)이고, 가장 기계적인 것은 검증 · 증거 체결이다 → M1(내용) → M2(렌더) → M3(검증).
> 확인 필요 항목: **없음** — 발표 환경(프로젝터 vs 인쇄) 미확정은 인쇄 안전 기본값(REQ-SB-016 · REQ-SB-025)으로 방어 가능하며, 나머지 결정은 전부 아래 §B 에서 확정됐다.

## §A Tier 판정 — Tier M

아티팩트 3종(spec.md + plan.md + acceptance.md) + 진행 원장(progress.md, Tier 불문 항상 발행). research.md 는 plan-phase Phase 6 산출으로 이미 승계됐다. 코드 구현이 없는 문서 산출 카드이므로 design.md 를 더 붙이지 않는다(Tier L 아님).

## §B 결정 기록 (run-phase 에서 재논의 금지)

| # | 결정 | 값 | 근거 |
|---|---|---|---|
| D-1 | 렌더 모드 | `status` | 종합 현황 브리핑의 정석(research §4.1). 시스템 "개념 설명" 비중이 절반을 넘으면 explainer 대안이 있으나 본 카드는 현황이 주 목적 → 확정 봉쇄(REQ-SB-012) |
| D-2 | 오디언스 | `basic` | 청중=비개발자 실무진(카드 지시). 카드가 요구하는 원문 정의 · mermaid · worked example 은 basic 티어 계약 |
| D-3 | 팔레트 정본 | primary `#5538B6` (SKILL.md 본문) | 팔레트 이원화 갈등(research §4.2) — tailwind-tokens.md `#553886` 계열은 기각 |
| D-4 | 폰트 | Noto Sans KR(`--sans`/`--serif` 오버라이드) | 후니 디자인시스템 "Noto Sans 유일" 규칙이 모드 기본(Pretendard)에 우선 |
| D-5 | output_path · slug | `.moai/reports/t45/` · `huni-staffbrief-260909` | 스킬 기본값(`<cwd>/reports/…`)과 t43/t44 카드 증거 관행의 충돌 해소(research §4.4) — 카드 디렉터리 우선 |
| D-6 | 크기 예산 판정 | 120KB = **122,880 바이트**(1024 진법) | 이진 판정을 위한 단위 확정 |
| D-7 | 발표 환경 미확정 대응 | **인쇄 안전 기본값**(SVG/산문 병지 + 백업 자산) | 발표 환경을 물어봐도 인쇄 안전 설계가 상위 호환 — 차단 사유 없음 |
| D-8 | 카드 판정 정본 | `verdict.md` | t43/t44 관행 승계(리드는 verdict.md 를 판독해 카드를 진행) |
| D-9 | 스킬 판독 방식 | Skill() 로딩과 메인 체크아웃 절대경로 판독 **둘 다 허용** | 워크트리에서 스킬이 미트래킹이라 절대경로가 확실한 경로, Skill() 이 로드되면 그것이 더 저렴(research §8) |

## §C 상시 절차 — 새 세션이 이 절만 읽고 착수할 수 있어야 한다

1. **스킬·설정 판독**(메인 체크아웃 절대경로 — 워크트리에 없음):
   - `/Users/innojini/Dev/HuniWeb/.claude/skills/moai-domain-html-report/SKILL.md` (v1.1.0)
   - `/Users/innojini/Dev/HuniWeb/.moai/config/sections/report.yaml` — `report: format: html+md` 확인(읽기만, 복사 금지)
2. **재실측**(LiveDB 읽기전용): 자격증명은 메인 체크아웃 `.env.local` 의 `RAILWAY_DB_*` 키 · psql · `SELECT` 만. 대상은 「현재값」 지표 4종 — ①운영 활성 상품(`t_prd_products` del_yn/use_yn 조합) ②게시 위젯(`t_wgt_widgets` 상태 구분) ③공식 바인딩 상품(`t_prc_*` 바인딩) ④주문 수(프리런치 확인). 쿼리 원문 · 실행 시각 · 결과를 증거에 그대로 남긴다(as-of 라벨의 근거).
3. **원고 작성**: research §6 뼈대 → §1~§5 + 서사 재료(고객 여정 5단계 §2.6 · 개념 8개 §1.3 · 증상 점검표 Q&A §1.3 · 개선 곡선 §2.5). 모든 스냅샷 수치에 날짜 라벨, 7종 금지 조항(REQ-SB-006~011) 대조하며 작성.
4. **렌더**: 스킬 계약 — 입력 markdown · `mode=status` · `audience=basic` · `slug=huni-staffbrief-260909` · `output_path=.moai/reports/t45/`. 토큰 적용은 mustache 템플릿 `:root` CSS 변수 오버라이드(status.html.mustache:20-46) + 폰트 링크 · `--sans`/`--serif` 교체(Pretendard→Noto Sans KR) + mermaid themeVariables 동일색 — React 위젯 구현 규칙(RULE-1 등)은 정적 리포트에 무관(적용 단위=토큰뿐).
5. **humanize 최종 패스**: moai-domain-humanize 스킬로 납품 전 윤문 — **수치·사실 verbatim 불변(전후 수치 diff로 확인)**.
6. **검증·증거**: acceptance §A~§D 전수 판정 → `verdict.md` 작성 → 백업 자산 확보 → 카드 커밋(산출물 포함 · 미트래킹 자산 제외).

## §D 마일스톤

### M1 — 브리핑 원고 작성 + 렌더일 재실측 (번복 가능성 최상 — 리뷰에서 가장 많이 바뀐다)

- **M1.1 재실측**: §C-2 의 지표 4종 `SELECT` + as-of 기록(실행 시각). DB 접속 불가 시 REQ-SB-005 폴백(9/7 값 + 시점 라벨 + 머리 고지).
- **M1.2 원고 md**: 뼈대 구성(§B D-5 경로) + 서사 재료 배치 + 날짜 라벨 · 과대포장 금지 7종 · 전문용어 인라인 정의 반영.
- 게이트: REQ-SB-001~011, 023, 024 / AC-SB-007~016, 021, 022.

### M2 — HTML 렌더 + 디자인 토큰 적용

- **M2.1 렌더 파라미터 확정·실행**: mode=status · audience=basic · output_path 카드 증거 디렉터리(기본값 금지).
- **M2.2 토큰 오버라이드**: #5538B6 팔레트 · Noto Sans KR · radius/패딩 토큰. mermaid/SVG 배치 점검(발표 필수 정보의 SVG/산문 병치).
- **M2.3 md twin 생성·정합**: 핵심 사실만 — 부풀림 재수록 금지.
- 게이트: REQ-SB-012~017 / AC-SB-001~006.

### M3 — 검증·증거·판정 (가장 기계적)

- **M3.1 AC 전수 판정** → `verdict.md` 판정 정본 작성(판정표 · 렌더 파라미터 · 크기 · as-of · 재실측 쿼리).
- **M3.2 오프라인 백업 자산 확보**(PDF 또는 전체 스크린샷).
- **M3.3 증거 디렉터리 정돈 + 카드 커밋 준비**(산출물 포함 · 미트래킹 스킬/report.yaml 제외).
- 게이트: REQ-SB-018~022, 025 / AC-SB-017~020, 023.

## §E 리스크

| # | 리스크 | 방어 |
|---|---|---|
| R1 | 폰트 CDN 오프라인 → 발표 당일 기본 폰트로 강등(파손은 아님) | REQ-SB-025 백업 자산(PDF/스크린샷) + 발표 전 온라인 확인 |
| R2 | 120KB 예산 초과(원고 풍부 + SVG 증가) | 부록 분리 · 섹션 축소. 선례 79.9KB(가격엔진 해설서)로 여유 있음 |
| R3 | 재실측일(렌더일)과 발표일(9/9) 사이 수치 변동 | as-of 라벨로 「N월 N일 기준」 명시 — 정확성 장치가 곧 방어 |
| R4 | 발표 환경 미확정(프로젝터 vs 인쇄) | 인쇄 안전 설계 기본값(REQ-SB-016) — 인쇄에서 되는 화면은 프로젝터에서도 된다 |
| R5 | LiveDB 접속 불가(렌더일) | REQ-SB-005 폴백 — 9/7 실측값 + 시점 라벨 + 머리 고지 |

## §F 제약 9건 (research §4.5 — run-phase 준수 목록)

1. **스킬·report.yaml 메인 전용(미트래킹)** — run 프롬프트에 절대경로 명시 + 산출물은 카드 커밋에 포함(스킬 본체는 커밋하지 않는다).
2. **mermaid 인쇄 불가** — 발표 필수 정보는 인라인 SVG/산문에 배치(온라인 브라우저에서만 렌더됨).
3. **폰트 CDN 오프라인 리스크** — 발표 전 온라인 확인 or 백업 자산(REQ-SB-025).
4. **크기 예산 basic ≤120KB** — 초과 시 섹션 축소/부록 분리(예산 상향 금지).
5. **팔레트 이원화** — 정본 지정 #5538B6(D-3).
6. **Noto Sans 단일 규칙 vs 모드 기본(Pretendard)** — `--sans`/`--serif` Noto Sans KR 오버라이드(D-4).
7. **md twin 무결성 [HARD] + 카드 판정 정본=verdict.md** 관행 유지(D-8).
8. **스킬 내 design-tokens.md 참조 깨짐(부재)** — 토큰 SSOT는 스킬 SKILL.md 본문으로 읽는다.
9. **dataviz · artifact-design 불필요** — html-report 자체 규약으로 충분(별도 로딩 금지).

## §G 교차참조

- spec.md §5(요구사항) · acceptance.md(AC-SB-001~023) — 같은 디렉터리.
- research.md §4(Lens D) — 렌더 인프라 상세 · §6(권장 뼈대) · §2.7(과대포장 금지 7종).
- progress.md — 진행 원장(§E.1 plan 신호 서술 완료).
