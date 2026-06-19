# OT (상자·패키징) — codex 독립 교차검증 판정 (Phase 6.5)

> RP-Meta Phase 6.5 · codex-cli 독립 2nd-opinion(결론 검증 레인) · 2026-06-20
> 모델: **gpt-5.5** (preflight `AVAILABLE`·foreground `codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check`·exit 0).
> ★[HARD] codex 판정 = 가설. **전 주장 `unverified`** — 라이브/후니 스키마/권위 엑셀 재검 전 채택 금지. rpm-validator의 mgate-verdict는 프롬프트에 **비노출**(독립성 보장) — codex는 증거(박스 원자추출 + 17축 frame)만 받고 자체 판정.
> 원본: `_workspace/huni-rpmeta/_tmp/ot-codex/{prompt.md,verdict.md}`.

---

## codex 독립 판정 원문 (verbatim·각 주장 unverified)

**판정: ABSORBED** `[unverified]`

### 1. NEW-AXIS 아님 `[unverified]`
승격 규칙 기준으로 `dieline / structural-net` 축은 성립하지 않음:
- **전용 option slot 관측 없음** — 박스 5종 live slot = `paper·paper_sub_select·sodu·size·number2_sel·number1_sel`뿐. `dieline·box_type·structure·net·glue_tab` 같은 별도 선택축 없음.
- **KB defect 없음** — 기존 축으로 왜곡 없이 흡수. 사용자는 "케이크박스 소/중/대" 같은 size preset만 고르고, bracket 값 = flat work-size. 3D 치수는 표시/파생 정보이지 선택축 아님.

### 2. 축 매핑 `[unverified]`
| 대상 | codex 귀속 축 | 이유 |
|---|---|---|
| flat work-size / cut-size / margin | **#13 사이즈** | t_siz_sizes가 work/cut/margin을 한 row에 담는 구조라 정확히 맞음 |
| 3D product W×D×H | **#13 사이즈의 표시/파생 속성** | 선택값은 size preset 하나. vessel에 depth/height 표시 필드 없다면 "Size 축 표현력 보강" 문제이지 새 축 아님 |
| die-cut knife line | **#2 공정** | 도무송/칼선 = 공정 facet |
| crease / fold line | **#2 공정** | 오시/접힘선 = 공정 facet. 박스 구조라고 별도 관리축 안 됨 |
| glue tab | **#2 공정 또는 TemplateAsset 표현 요소** | RP가 접착/조립 안 하므로 #14 형태가공 아님. 접착 탭 = dieline geometry 또는 후가공 지시의 일부 |
| box shape(케이크/납작/반달/봉투/답례) | **#7 카테고리 / product-code split** + 보조 **#13 size preset label** | 5박스 별도 product code 분기·내부 차이는 size preset label/dimension. dedicated shape slot 없으므로 #17 승격 사유 아님 |
| editor dieline artwork/template | **#16 TemplateAsset** | makers `template_uri/resource_id/token` = editor seed resource. 가격 0 디자인 자산으로 보는 게 맞음 |
| flat→3D assembly | **축 아님 / #14 아님** | "ships folded flat, customer assembles"이므로 RP가 3D 형태 제작하는 positive form-processing 아님 |

### 3. Soundness Flags `[unverified]`
- **Fabrication 경고:** "응답 surface에 CAD/line-type 필드 없다"는 안전. 단 `template_uri` 내부 GCS JSON 미해석이므로 "dieline geometry가 존재하지 않는다"까지 말하면 fabrication.
- **Overfit 경고:** `structural-net`을 새 축으로 만들면 박스군 전용 asset/size 표현을 관리축으로 과승격하는 오버핏. 라이브 slot 일반화 없음.
- **Implausible PASS 없음:** 이 증거만으로는 ABSORBED가 print-domain expectation에 맞음. 박스는 인쇄+도무송+오시된 평면 전개도 상품이고, 조립형 3D 제조 상품 아님.

**codex 결론:** dieline / structural-net = NEW-AXIS 아니라 기존 **#13 Size + #2 Process + #16 TemplateAsset + #7 Category**로 흡수.

---

## ★독립성 확인
- 프롬프트에 mgate-verdict(M1~M6 GO·"전개도 #18 부결"·"distinct 0") **미노출**. codex는 17축 frame(#2/#6/#7/#8/#13/#14/#16/#17) + 박스 6캡처 원자추출 + 승격 2조건 규칙만 받음.
- codex가 동일 결론(ABSORBED)에 **독립 도달** = reconcile 신호(에코 아님). 두 모델이 같은 증거에서 같은 부결 → 고신뢰.
