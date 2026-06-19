# FS(패브릭·봉제 완제 직물 굿즈) — codex-cli 심층 발굴 (deepcheck)

> 후니 RP-Meta 하네스 Phase 4.5 산출물 (rpm-deepcheck).
> codex(gpt-5.5)에 FS 분석을 독립 second-opinion으로 넘겨 "우리가 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보"를 발굴.
> **★이것은 발굴(생성측) — Phase 6.5 codex 게이트검증(결론 검증)과 별개.**
> **★[HARD] codex 주장 = 가설(환각 경계). 라이브 인용 신뢰 금지. 전 후보 `unverified` — 후니 라이브 t_*/권위 엑셀/RP 라이브 검증 전 채택 금지.**

## codex 가용성 / consult 메타

- **preflight:** 공용 `codex-preflight.sh` 백그라운드 실행이 행(hang) → 직접 `codex exec -m gpt-5.5 --sandbox read-only --output-last-message /tmp/rpm-deepcheck-FS.md`로 가용성 동시 확정. **AVAILABLE model=gpt-5.5** (exit 0·52줄 consult 산출).
- **consult 입력:** FS 17축 facet 매핑 + FS-1~8 판정 + 타일링 #18 부결 결론을 codex에 제시하고 "놓친 것"을 6개 카테고리(옵션축/직물 물성/봉제 마감/완제 부자재/엣지케이스/거버넌스)로 발굴 요청.
- **codex 외부 대조 출처(codex 자체 인용 — `unverified`):** Contrado(fabrics·tote·wall-hanging·fabric-labels), FTC textile/care labeling rule. **★이 인용은 codex의 주장이며 본 하네스가 검증하지 않음.** RedPrinting FS 라이브 슬롯과 후니 t_* 그릇이 권위.
- **consult 원본:** `/tmp/rpm-deepcheck-FS.md` (휘발성·재실행 가능).

---

## 핵심 발굴 (codex 한 줄 결론)

> codex: "`TILING`보다 더 위험한 누락 후보는 **cut-and-sew construction / panel semantics**(앞판/뒤판/옆판/안감/손잡이/심지/충전재를 따로 자르고 봉제하는 순간 종이 인쇄식 17축이 갈라진다)."

★이것이 codex의 핵심 도전(challenge)이며, 우리 #18 distinct 후보 판정(타일링만)에 대한 외부 반론이다. 아래 triage에서 우리 PD/FS 봉제 판정(봉제=공정#2 family·완제 구조=카테고리#7)과 대조해 평가한다.

---

## Triage — 33 후보 (codex 발굴 → 분류·라우팅·검증법)

분류: **(A) 신규 후보**(검증 필요·라우팅) / **(B) 기존 흡수**(폐기·근거) / **(C) 오류/부적용**(거부·사유).
★전 (A) 항목 `unverified` 태그. distinct #18 신규 후보 여부는 별도 표시.

### (A) 신규 후보 — 검증 후 편입 대상 (전부 `unverified`)

| # | codex 주장 | 분류·라우팅 | 검증법 | distinct #18? |
|---|-----------|------------|--------|---------------|
| A-1 | **패널 구성(panel: front/back/side/bottom/gusset/handle/label 각각 별도 디자인·원단·공정)** = cut-and-sew 핵심 | `unverified` · **gap-analyst** (data-gap 후보·후니 디자인 채널 V-10/완제 SKU 그릇 실재 여부) | 후니 라이브: 직물 굿즈가 다면 디자인 업로드를 받는가? RP FS infoCall에 면별(panel) 디자인 슬롯 실재? `t_prd_templates`/디자인 입력 채널이 면 분리 표현 가능한지 실측 | **약(weak) #18 후보** — 우리는 "봉제 완제=카테고리#7 내재 레시피"로 봤으나 codex는 "면별 독립 디자인=구조축"이라 주장. ★우리 PD 부결 근거(봉제=공정)와 충돌 가능 → 적대 검증 필요 |
| A-2 | **결방향(grain/nap direction)** — W/H 본체방향과 별개·벨벳/파일·무늬 상하 | `unverified` · **metamodel-architect** (사이즈#13 방향 facet 확장 vs 신규 제약축) | RP FS 라이브에 grainline/방향 슬롯이 PAPER_WH 외 별도 존재? 후니 면직물 1종(면사수)이라 nap 무관할 수 있음(면≠파일) | facet 우세(우리 면직물은 nap 없는 평직 추정·FS-2 방향과 합류) |
| A-3 | **시접(seam allowance) / safe-area** — 완성 사이즈 ≠ 재단 사이즈·print safe-zone 변경 | `unverified` · **metamodel-architect** (사이즈#13 cascade param vs 공정#2 재단 param) | RP FS 템플릿이 seam allowance/safe-zone 레이어를 노출하는가? 후니 `t_proc_processes` 재단(CUT_ZUN·열재단)에 시접 param 그릇? | facet(재단/사이즈 cascade) 우세 — 단 우리가 명시 안 한 생산 param |
| A-4 | **안감(lining)** — 겉감과 독립 원단·색·인쇄 | `unverified` · **gap-analyst** (자재#1 sub_mtrl vs 신규 sub-material 섹션) | RP FS 파우치/가방 UI에 lining 슬롯? 후니 MAT_TYPE.09 봉제부자재에 안감 행 적재 가능? | facet(자재#1 sub_mtrl·FS-6 완제 부자재와 합류) 우세 |
| A-5 | **심지(interfacing)** — 형태유지 부직포/접착심지·별도 BOM | `unverified` · **gap-analyst** (자재#1 sub_mtrl·data-gap) | RP structured tote/pouch에 padded/structured 옵션? 후니 자재 그릇에 심지 행? | facet(자재#1 sub_mtrl) 우세 |
| A-6 | **insert vs cover-only / filling type·weight** — 쿠션 커버만 vs 완제·솜 종류/중량 (가격·배송부피 영향) | `unverified` · **gap-analyst** (FS-6 솜 충전 확장·옵션 노출 모드·data-gap) | RP 쿠션 UI에 insert/filling 옵션 실재(우리 SUB_MTR TN001 사각쿠션솜 관측)? filling 중량/종류 분기? | facet(FS-6 부속물#8 선택형 확장) — 우리가 솜=관측했으나 중량/종류 분기는 미관측 |
| A-7 | **gusset/맞주름 폭(bottom width·flat vs gusseted)** — 용량·패턴피스 변경 | `unverified` · **metamodel-architect** (사이즈#13 형태 facet vs 신규 construction) | RP tote/pouch에 flat/gusseted·bottom width 슬롯? 후니 사이즈 그릇이 폭 차원 담는가 | facet(사이즈#13·FS 가방 형태=프리셋과 합류) 우세 |
| A-8 | **포켓 구조(inner/outer·count·zipper pocket)** — 우리는 POC_FBR(포켓가공) 관측·단일 Y/N | `unverified` · **gap-analyst** (FS-6 부속물#8·옵션#3 확장·data-gap) | RP 가방 UI에 포켓 개수/종류 분기? 우리 POC_FBR_CHK는 Y/N만 관측 | facet(공정#2 포켓봉제+자재·이미 관측) — 단 개수/종류 차원은 미관측 |
| A-9 | **세탁법 라벨(wash-care label)** — 단순 안내 아닌 판매 요건 가능(FTC Care Labeling Rule) | `unverified` · **metamodel-architect** (신규 거버넌스축 후보·기초코드#6 vs 별축) | 후니가 직물 굿즈 세탁법 라벨을 상품 데이터로 관리해야 하는가? 한국 시장 규제 vs 미국 FTC(codex 인용=미국). RP FS에 care label 슬롯 부재 확인 | **거버넌스 #18 후보(약)** — codex 주장 강하나 RP FS 라이브 미관측·한국 규제 미확인 |
| A-10 | **섬유혼용률/원산지 라벨(fiber-content·country-of-origin)** — 겉감/안감/충전 섹션별 표시 | `unverified` · **metamodel-architect** (거버넌스축 후보) | 한국 전자상거래/품질경영법상 직물 굿즈 표시 의무? 후니 상품 데이터에 혼용률 컬럼 필요성 | 거버넌스 facet(기초코드#6·자재 메타) 우세 — A-9와 묶음 |
| A-11 | **인증축(OEKO-TEX/GOTS/유기농면)** — 소재선택 이상·B2B 필터 | `unverified` · **metamodel-architect** (자재#1 메타 facet vs 거버넌스축) | RP FS 소재 페이지에 인증 표기? 후니 자재 마스터에 인증 메타 컬럼 필요? B2B 필터 요구 실재? | facet(자재#1 메타) 우세 — RP FS 미관측 |
| A-12 | **dye-lot/batch lot** — 동일주문·재주문 색차 관리 | `unverified` · **gap-analyst** (생산 거버넌스·MES 영역·RP-Meta 범위 경계) | 후니 생산/MES가 lot 추적하는가? 견적·옵션 모델 축인가 생산 추적 속성인가 | **거부 경계** — 견적 옵션축 아닌 생산 추적(MES)·RP-Meta(vessel) 범위 밖 가능성 높음 |

### (B) 기존 17축/FS facet으로 이미 흡수 — 폐기 (근거)

| codex 주장 | 흡수처 (우리 기존 판정) |
|-----------|----------------------|
| **GSM/평량** | 자재#1 WGT 차원 — FS-3에서 "면사 수=평량 다의(번수)"로 이미 측정타입 흡수. codex GSM은 측정단위 차이일 뿐 동일 WGT 차원 |
| **weave/짜임(plain/twill/canvas/satin)** | 자재#1 PTT(직물 계열) — FS-3 PTT 확장. 후니 면직물 1종이나 그릇은 PTT로 흡수 |
| **stretch/신축·shrinkage/수축·color-fastness·opacity·hand/drape** | 자재#1 measure_type/물성 메타 — FS-3 WEAK(직물 물성 measure_type=V-3 vessel). codex 물성 6종 = 동일 V-3 물성차원 다발(개별 신규축 아님) |
| **print method(pigment/reactive/sublimation)** | 공정#2 인쇄방식 facet — 우리 별색(SID_FBR)·도수 슬롯과 동근. 후니 면직물 날염=단일 공정 추정 |
| **stitch type(lockstitch/overlock/coverstitch)·SPI/땀수·double-needle·bartack·topstitch** | 공정#2 봉제 family(FS-5 SEW_FBR·PDT_WRK·형태가공#14) — 봉제 마감 세부 = 공정 인스턴스 param |
| **실색(thread color)** | 공정#2 마감봉제 param(FS-5) 또는 기초코드#6 색 — codex도 Contrado "black/white" 언급=2값 enum·미세 facet |
| **closure type(zipper/snap/velcro/drawcord)·zipper spec·drawcord type** | 부속물#8 BUNDLE+공정#2 부착(FS-6) — 우리 LIN_PRT(끈)·WRK_MTR(자석)·SEW_FBR(벨크로) 관측과 동근. 자재(부자재)+공정(부착) |
| **handle length/drop·material/color·printability** | 부속물#8 + 자재(끈)(FS-6) — 우리 LIN_PRT 끈 관측. 길이/색=부자재 facet |
| **D-ring/carabiner/snap/eyelet hardware** | 부속물#8(FS-6·AC WRK_MTR 동형) — 우리 자석(WRK_MTR)·현수막 고리(icon_txt) 관측과 동근 |
| **piping/cording(쿠션 edge)** | 공정#2 마감봉제 family(FS-5) — 가장자리 마감 변형 |
| **quilting/padding layer** | 공정#2 + 자재 facet(FS-6 솜과 합류) |
| **label type/placement** | 부속물#8 + 자재(라벨)(FS-6 LAB_FBR 관측) — 단 거버넌스 성격은 A-9/A-10으로 분리 라우팅 |
| **full-bleed/all-over print limit(edge loss·seam fold·pole pocket)** | 공정#2 prepress facet + 현수막 봉/고리(FS §0.7 BN family 상속) — 우리 봉 가공 관측 |
| **registration across seams(2-3mm 오차)** | 공정#2 QA tolerance — 생산 품질 param·옵션축 아님(codex도 "QA tolerance axis"라 자인) |
| **repeat placement origin/scale/offset/half-drop** | 공정#9 인쇄 배치 파라미터(FS-1 타일링 흡수처) — codex도 "독립축까지는 아님"이라 자인. ★타일링 #18 부결 결론 보강(repeat 세부 param도 #9 흡수) |
| **mirrored backs(same/mirror/different)** | A-1 패널 의미와 합류 — 면별 디자인 슬롯의 한 facet. 단독으론 도수#6/디자인채널 facet |
| **MOQ per fabric/finish** | 수량모델#10 거버넌스 facet — codex도 "quantity governance facet"이라 자인 |
| **packaging/presentation(gift wrap·tin)** | 공정#2 포장(FS PAK_POL 관측) — 우리 폴리백 개별포장 관측. 선물포장=포장 facet 확장 |

### (C) 오류/부적용 — 거부 (사유)

| codex 주장 | 거부 사유 |
|-----------|----------|
| **flammability/FR/NFPA701 난연 인증** | RP FS·후니 면직물 굿즈(쿠션/에코백/스카프) 모집단에 난연 요구 미관측. codex가 "event textile/outdoor banner"로 일반화했으나 우리 FS=실내 소품·면. 후니 BN(현수막) 트랙이면 검토할 수 있으나 FS 범위 밖. (모집단 오추정) |
| **asymmetric/irregular shape = 신규 shape/pattern axis** | ST에서 **형상(shape #17)이 이미 distinct 축으로 승격**됨(`vessel-shape-axis`·V-12). codex가 "신규축"이라 본 곡선/패턴피스는 우리 #17 형상축이 이미 담음. 신규 아님(이미 17축 내 #17). 단 FS 스크런치/스카프 형상이 #17에 적재되는지는 data-gap(reverse §5 FSBDSCR M/L=사이즈 흡수 판정과 대조) |
| **care-risk compatibility 제약 매트릭스** | 구성품별 세탁 호환 = A-9 wash-care 거버넌스의 파생·독립 거버넌스축으로 중복. A-9에 흡수(별도 #18 아님) |
| **orientation vs grain 충돌 제약** | A-2 결방향의 파생 제약 — 면직물(평직)에선 grain 충돌 미미. A-2에 흡수 |

---

## 종합 — 신규 distinct 후보 유무 / 라우팅

**★신규 distinct #18 후보 유무: 예상대로 "타일링 외 강후보 없음"이나, codex가 1건의 진지한 도전을 제기.**

1. **A-1 패널 구성(cut-and-sew panel semantics)** — codex의 핵심 도전. 우리는 "봉제 완제=카테고리#7 내재 레시피·봉제=공정#2"로 #18 부결했으나, codex는 "면별 독립 디자인 업로드=구조축"이라 반론. **★약(weak) #18 후보로 metamodel-architect+gap-analyst 적대 검증 필요** — 핵심 질문: RP FS infoCall/후니 디자인 채널이 면별(front/back/handle/label) 독립 디자인 슬롯을 실제 노출하는가, 아니면 단일 디자인 업로드 후 자동 배치인가. 전자면 V-10 디자인 입력 채널(TP distinct) 확장 또는 신규 패널축, 후자면 #18 부결 유지. **(우리 PD 봉제 부결과의 일관성 점검 필수)**
2. **A-9/A-10 거버넌스(wash-care·섬유혼용률·원산지 라벨)** — codex 강주장(FTC 인용)이나 미국 규제·RP FS 라이브 미관측. **약 거버넌스 #18 후보** — 한국 시장 규제 + 후니 직물 굿즈 취급 의도 확인 후 metamodel-architect 판정. 인증(A-11)·MOQ는 facet으로 약화.
3. **나머지 28건 = 17축/FS facet 흡수(B)** + 4건 거부(C). 우리 reverse 결론(타일링만 #18 후보·전부 흡수)과 **대체로 일치** — 단 codex가 "panel semantics"라는 우리가 명시 안 한 각도를 제기한 것이 순(純) 기여.

**★directive 1순위 답(타일링):** codex도 repeat placement(scale/offset/half-drop)를 "독립축까지는 아님"이라 자인 → **타일링 #18 부결 결론 외부 동의(독립 보강).** codex의 더 강한 후보는 타일링이 아니라 A-1 패널이라는 점이 핵심 발견.

### 라우팅 (SendMessage 대상)

- **metamodel-architect:** A-1(패널·★최우선 적대 검증), A-2(결방향), A-3(시접), A-9/A-10(거버넌스 라벨), A-11(인증) — distinct vs facet 재판정.
- **gap-analyst:** A-1(디자인 채널 그릇 실재), A-4(안감), A-5(심지), A-6(filling 분기), A-8(포켓 개수) — data-gap vs vessel-gap 라이브 실측. + (C)의 형상축(FS 스크런치/스카프 #17 적재 여부).
- **reverse-engineer:** A-6/A-8 등 미관측 분기(filling 중량·포켓 개수·면별 디자인)는 RP FS **infoCall AJAX 캡처**(node monitor)로 보강 가능(FS-8 unobserved와 묶음·날조 금지).
- **vessel-designer:** A-1이 패널 디자인 채널로 확정 시 V-10 확장 영향 / A-9 거버넌스 확정 시 신규 그릇 영향 분석.
- **validator:** 본 후보 목록 전달 — M-gate에서 어느 후보도 `unverified` 상태로 silent 편입되지 않았는지 확인.

**★전 후보 `unverified`. codex 인용(Contrado·FTC) 신뢰 금지. RP FS 라이브 + 후니 t_*/권위 엑셀이 검증 권위. 어느 것도 검증 전 reverse/metamodel/gap에 편입 금지.**
