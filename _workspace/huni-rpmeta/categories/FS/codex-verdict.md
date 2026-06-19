# codex 독립 교차검증 판정 — FS(패브릭) 카테고리 (Phase 6.5 신규 레인 첫 실증)

> rpm-codex-validator. codex-cli(OpenAI gpt-5.5)의 **독립 2nd opinion** — 증거 전용 프롬프트(우리 mgate-verdict 비노출)로 codex 자체 판정을 받음.
> **★모든 codex 주장 = `unverified` 가설** — 라이브/권위 재검증 전 채택 금지. codex 라이브 인용은 신뢰하지 않음(환각 경계).
> 사용 모델: **gpt-5.5** (`codex exec -m gpt-5.5 --sandbox read-only`, 2026-06-19). preflight 우회(foreground 직접 호출).
> workdir = `categories/FS/`로 한정 — codex가 `05_validation/`(우리 판정)에 접근 불가.

---

## codex 독립 판정 한눈 (verbatim 요약)

| 후보 | codex 판정 | codex 근거(`unverified`) |
|---|:---:|---|
| **전체 FS** | **ABSORBED** | "제공된 증거만 보면 FS는 17축 밖의 신규 관리축을 만들 만큼 독립된 라이브 슬롯을 보이지 않음." |
| **타일링 TILL_WH_GBN** | **ABSORBED** | none/vertical/horizontal = 고객 디자인을 원단 면에 반복 배치하는 값 → 기존 **공정파라미터(#9 print-placement/imposition)**가 그대로 흡수. 독립 자재·공정·템플릿 아님. "인쇄 배치 방식 파라미터"로 보는 게 왜곡 최소. |
| **패널 구성(cut-and-sew)** | **ABSORBED / 근거부족** | front/back/side/gusset/handle 패널별 독립 디자인 업로드·자재·공정 슬롯 없음. FS = "단일 full-print 업로드 → 재단/봉제 완제품화". 봉제 마감=process·부자재=BUNDLE·면사 수=material grade·쿠션 SID_D=양면 디자인 아닌 도수 토글. |

## codex가 지적한 조작/과적합 위험 (각 `unverified` — 우리 판정과 대조용)

1. **패널 구성을 NEW-AXIS로 확정했다면 과적합/근거 비약** — "봉제 완제품"이라는 제조 개념만으로 패널축 신설 불가. 인정하려면 라이브 주문 UI·가격·제약에서 패널 단위 선택/업로드/가격/제약이 관측돼야.
2. **타일링을 별도 축으로 세웠다면 축 분리 과잉** — 현재 값 범위·의미는 기존 공정파라미터에 자연스럽게 들어감.
3. **PASS 판정이 "PCS detail enum / unit prices 미관측"까지 완결됐다 주장하면 WEAK/GAP로 낮춰야** — 가격 모델 종류는 관측됐으나 sewn finished goods PCS 세부 enum·단가는 미관측 명시.
4. **"FS는 패널별 독립 디자인 지원" 결론은 현재 증거 기준 fabrication** — 반대로 "패널 개념 절대 없다"도 과함. 현재는 **"라이브 슬롯 미관측"까지만** 말할 수 있음.

## codex가 제시한 NEW-AXIS 성립 조건 (checkable — 향후 라이브 재실측 트리거)

패널 구성을 신규축으로 인정하려면 최소 다음 중 하나가 라이브에서 관측돼야:
- `panel_cd` 같은 front/back/side/gusset/handle 패널 식별 슬롯
- 패널별 독립 파일 업로드 또는 디자인 템플릿 매핑
- 패널별 자재/면사 수/색상/공정 선택
- 패널별 가격 산식 또는 수량·면적 산정
- 패널 조합 제약(예: gusset 선택 시 side panel 필수)

→ **현재 제공 증거에 모두 부재.** (우리 validator A-1 부결의 ①UNOBSERVED와 동일 결론·독립 도출.)

---

## 가용성 노트

- **codex 가용 = gpt-5.5 AVAILABLE.** `codex exec -m gpt-5.5 --sandbox read-only --output-last-message` foreground 직접 호출 EXIT=0·verdict 2,878 bytes 수집.
- **★preflight 백그라운드 행(hang) 우회:** 공용 codex-review.sh가 preflight를 백그라운드로 부르면 hang(exit 144 실증)이라, preflight를 거치지 않고 foreground에서 codex exec 직접 호출. (gpt-5.5 가용은 직전 세션들에서 이미 확인됨.)
- 1차 시도 `timeout` 래퍼 사용 → EXIT=127(`timeout` 미설치·zsh command not found). 래퍼 제거 후 직접 호출로 성공.
