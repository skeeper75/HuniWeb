# OT (상자·패키징) — codex-cli 심층 발굴 (deepcheck)

> **RP-Meta Phase 4.5 · 12번째 카테고리 · 외부 second-opinion(발굴측)**
> codex(OpenAI gpt-5.5)에 OT 분석을 독립 검토로 넘겨 "놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보" 발굴.
> ★[HARD] codex 주장 = 가설(환각 경계). **전부 `unverified`** — 라이브/후니 스키마/권위 엑셀 검증 전 채택 금지. 본 문서는 *검증 후보 목록*이지 finding이 아니다.
> codex 가용성: `AVAILABLE model=gpt-5.5`(preflight 통과·foreground `codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check`·exit 0). 원본 = `_tmp/deepcheck-OT-out.md`.

---

## 0. codex consult 요약

- **★codex도 distinct #18 부결에 독립 동의** — "Confirmed new axis: 없음. 캡처된 5박스 기준 기존 결론 유지." → 우리 전개도/dieline #18 부결(흡수) 판정을 외부 모델이 12번째로 재확인(distinct 0 재포화 입증).
- **★가장 강한 발굴 = 이미 우리가 아는 dieline-template** — codex 본인이 명시: "Strong gap: structural dieline asset type. 이미 알려진 항목이지만 가장 실질적인 vessel-gap 후보." (directive 예측 "전개도 외 없음" 적중).
- **단, structural dieline을 generic TemplateAsset과 *구분*하는 정밀화는 신규** — codex가 `TemplateAsset.kind = artwork|structural_dieline|production_tooling` subtype 또는 별 `t_prd_structural_dieline_assets`를 제안(Esko ArtiosCAD 근거). 이건 우리 §13/V-11이 "unobserved·1차 불요"로 미룬 지점의 *구체적 검증 질문*으로 격상 가치.
- **나머지 = 전부 흡수 동의 또는 data-gap/unobserved** — window-cut·divider·lid style·handle·food-coating·emboss/foil = "새 axis 아님", 기존 축(material/process/addon/constraint) 라우팅. codex도 캡처 5박스엔 부재 인정.

---

## 1. Triaged 후보 목록

### (a) 신규 검증 후보 → 라우팅 (unverified)

| # | 후보 (claim 1줄) | 분류 | 라우팅 | 검증법 |
|---|---|---|---|---|
| **DC-1** | **structural dieline asset ≠ generic 디자인 TemplateAsset** — 접지선/풀칠탭 좌표·cut/crease/perf line type·2D/3D 접힘·CAD/CF2/ARD export를 가지면 별 자원 타입(`TemplateAsset.kind` subtype 또는 별 테이블). 현 V-11 TemplateAsset DDL이 "디자인 시안" 전용이라 structural data 주입 시 의미 오염. | unverified·**vessel 정밀화 후보**(우리 §13 "1차 불요" 재검 트리거) | **vessel-designer**(V-11 TemplateAsset subtype 재검) + **validator**(makers 응답 스키마 실측) | `makers.../templates/{OTPKCAK}` 응답에 fold-line/glue-tab 좌표·line semantics(cut/crease/perf)·3D preview·CAD layer export 유무 실측 → 있으면 structural subtype, 단순 PNG/SVG guide면 generic asset 확정. ddl-proposal-template-asset.sql:7 의미 오염 검토. |
| **DC-2** | **custom box W/D/H parametric 입력** — OTPKENV "커스텀 제품"이 preset이 아니라 width/depth/height 직접입력 3슬롯이면 size가 parametric(비규격 size parameter)이 되어 "박스=preset size" 결론 깨짐. | unverified·**엣지케이스**(현 결론 일반화 점검) | **reverse-engineer**(OTPKENV 재캡처) + **gap-analyst**(parametric size data-gap 여부) | OTPKENV `/{code}/detail` 라이브 재캡처 → size select가 preset 라벨인지 W/H/D input 3개인지. input이면 `t_siz_sizes` nonspec parameter 또는 structural template parameter 라우팅. |
| **DC-3** | **flat-ship vs glued/assembled 출고형태 flag** — rigid setup box(싸바리)·접착출고·완성출고가 SKU별 갈리면 "ships flat, customer assembles" 비대칭이 note에 묻히지 않는 출고/생산형태 관리 플래그(`fulfillment_form_cd`) 후보. | unverified·**관리축 후보**(생산형태#15 vs 신규 플래그) | **metamodel-architect**(생산형태#15가 담는가 vs 신규 플래그) + **reverse-engineer**(rigid/싸바리 상품 존재) | RP OT 카탈로그에 `rigid`·`gift box`·`싸바리`·`상하싸바리`·`접착출고`·`완성출고` 상품/라벨 검색 → 있으면 평면출고/접착출고/완성출고 SKU 분기 실측. ★우리 #14 형태가공(RP가 입체생성) vs OT(고객조립) 비대칭이 SKU별 갈리는지가 핵심. |
| **DC-4** | **골판(corrugated) flute/liner/ply material taxonomy** — OTCPHOL(컵홀더)·배송박스가 골판이면 단일 `paper+weight` 슬롯으로 E/B/F골·양면/편면·outer/inner liner 표현 약함(material taxonomy gap). | unverified·**data/자재 taxonomy gap**(vessel 아님 추정) | **gap-analyst**(자재 taxonomy data-gap) + **reverse-engineer**(OTCPHOL 캡처) | OTCPHOL payload에 E골/B골/F골·양면/편면·kraft/white liner 유무. huni `t_mat_materials`가 복합재 적층을 mat_nm 문자열로만 때우는지(round-22 ④자재 조율). |
| **DC-5** | **식품접촉/내유 coating constraint** — 케이크상자(OTPKCAK)는 식품접촉/내유/무형광 소재가 현실 제약. 옵션 아닌 판매가능성/주의문구/소재인증 constraint(또는 `food_contact_yn` 품질 플래그). | unverified·**제약#5/운영 플래그**(흡수 추정·단 미모델) | **gap-analyst**(constraint#5 data-gap) | OTPKCAK 상세에 "식품용"·"내유"·"무형광"·"식품지" 고시. huni 자재 note·mat_typ_cd·가격표 소재명에 식품성 구분 유무. ★흡수 가능하나 현 분석이 미언급 = 보강 후보. |

### (b) 기존 흡수로 폐기 (codex도 "새 axis 아님" 동의)

| 후보 | 폐기 사유 (codex 동의 포함) |
|---|---|
| **window-cut + PVC patch** | codex: "새 axis 아님" — 창문타공=공정#2·PVC/PET film=material/addon·식품호환=constraint#5. 캡처 5박스 부재. 후니 그릇으로 무왜곡 흡수. (단 창문박스 상품 *존재 시* DC-4류 자재 확인은 reverse 큐) |
| **interior divider/insert/partition** | codex: "새 axis보다 addon/BOM facet" — 칸막이=`t_prd_product_addons`/`t_prd_templates`/template_selections BOM. 우리 부속물#8(Addon) + 템플릿#4 그릇이 담음. 캡처 5박스 부재. |
| **lid/lock/auto-bottom/sleeve style** | codex: "새 schema axis 아님" — product-code split + size preset 흡수(우리 §7 박스형태=size 프리셋 라벨+pdtCode 동일 판정). 같은 상품 내 select 슬롯 관측 시만 option(미관측). |
| **handle/rope/ribbon/magnetic closure** | codex: "새 axis 아님" — addon/template + process + material. 우리 부속물#8 + 공정#2 흡수. 캡처 5박스 부재. |
| **emboss/foil/spot-UV/varnish on box** | codex: "전부 process #2" — 박/형압/UV=공정#2(우리 ST/PR/AC 동형 판정·round-22 별색=공정 경계). 금/은박색=option이 공정 참조. 캡처 5박스 부재. |
| **side-seam gluing / window patching / perforation / scoring vs creasing** | codex: "process #2 members" — 전부 공정#2 멤버. scoring/creasing 구분·perf 선수는 공정 파라미터#9(`ref_param_json`). 우리 §13 칼틀/오시접지 PROC family 판정과 동형. |
| **cut vs work 2D display (#13 흡수)** | codex 명시: "단일 size row에 work/cut/margin 있으면 5박스 충분·새 axis 아님" → 우리 §13 PASS(t_siz_sizes work/cut/margin 단일행) 외부 재확인. |
| **inside-print / die-cut-only(무인쇄) box** | codex: sodu/print_side·print process off로 흡수 가능(단 가격사슬 별도) — 기존 도수#6/공정#2 슬롯. 캡처는 단면 고정이나 그릇 부재 아님. data-gap. |
| **tooling/die-plate fee(목형비/칼비)** | codex: "새 axis 아님 — price component + constraint" — 가격#11 구성요소 + MOQ constraint#5. dbmap 가격 트랙. |

### (c) 오류/부적용 거부

| 후보 | 거부 사유 |
|---|---|
| (없음) | codex가 distinct 신규 축을 *주장하지 않음*(전부 흡수/data-gap/unobserved 동의). 우리 라이브 실측 판정과 충돌하는 주장 0건 → 거부할 적대 주장 없음. ★contradiction 로그 0. |

---

## 2. 종합 판정 (발굴측)

- **★신규 distinct #18 후보 유무 = 없음(예상 적중).** codex가 새 관리축을 1건도 확정하지 않음 — "전개도 외 없음·전부 흡수/data-gap" directive 예측 적중. **12번째 외부 재포화**(distinct 0·17축 안정). 우리 전개도/dieline #18 부결을 OpenAI 모델이 독립 동의.
- **최강 발굴 = 이미 아는 dieline-template** — codex 본인 인정. 단 **DC-1(structural dieline ≠ generic TemplateAsset subtype)** 으로 *구체적 검증 질문 격상* = 우리 §13/V-11 "unobserved·1차 불요"를 validator가 makers 응답 스키마 실측으로 닫을 트리거.
- **나머지 5 후보(DC-2~DC-5 + 식품 constraint) = 전부 data-gap/엣지케이스/unobserved** — vessel-gap 아닌 *데이터 미적재* 또는 *미캡처 일반화 경계* 성격(우리 §13 결론과 정합). vessel 신설 압박 0.
- **★박스 조립=고객 수작업 비대칭(#14와 정반대) 유지** — codex가 이를 깨지 않음. 단 DC-3(rigid/싸바리 출고형태)이 *SKU별로 갈리면* 생산형태#15 재검 필요분으로 metamodel-architect 라우팅(현 5박스 = 전부 flat-ship 동질).

---

## 3. 라우팅 SendMessage 큐 (검증·incorporate는 owning agent 몫)

- **vessel-designer**: DC-1(V-11 TemplateAsset structural subtype 재검·우리 1차 불요 판정 재검 트리거)
- **validator**: DC-1(makers 응답 스키마 실측·structural vs design asset 확정)·후보 목록 전건(M-gate에서 unverified 후보가 무단 채택 안 됐는지 확인)
- **reverse-engineer**: DC-2(OTPKENV custom W/H/D 재캡처)·DC-3(rigid/싸바리 상품 존재)·DC-4(OTCPHOL 골판 캡처)
- **gap-analyst**: DC-4(골판 자재 taxonomy data-gap)·DC-5(식품접촉 constraint#5 data-gap)·DC-2(parametric size data-gap)
- **metamodel-architect**: DC-3(출고형태 flag — 생산형태#15가 담는가 vs 신규 플래그)

> ★전 후보 `unverified`. 어느 것도 finding 아님 — owning agent가 라이브/스키마/엑셀로 검증 후에만 incorporate. validator는 M-gate에서 무단 채택 0 확인.
