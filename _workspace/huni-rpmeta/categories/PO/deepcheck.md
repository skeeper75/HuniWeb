# PO 카테고리 — codex-cli Deep-Augmentation (외부 second-opinion)

> 후니 RP-Meta 하네스 Phase 4.5 산출 (rpm-deepcheck). PO(포맥스·폼보드·등신대·피켓) 누락 정보 심층 발굴.
> **★HARD: codex(OpenAI gpt-5.5) 주장 = 가설 전부 `unverified`. 라이브(redprinting/후니)·권위 엑셀 검증 전 채택 금지(환각 경계).**
> 생성 자료(reverse.md·02_metamodel PO-1~4·03_gap §14)를 second-opinion으로 넘겨 "놓친 옵션/자재/공정/관리축/제약/엣지케이스" 발굴.

## codex 가용성 / 호출
- **AVAILABLE — gpt-5.5.** 공용 preflight(`codex-preflight.sh`)는 백그라운드 행·exit 144(directive 기지 함정)으로 폴백 → **foreground 직접 호출 성공**: `cat prompt | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check --output-last-message /tmp/rpm-deepcheck-PO.md -` (EXIT=0). 결과는 output 파일 수집(stdout 노이즈 배제).
- 프롬프트 = reverse 요약(7상품·옵션축·17축 매핑·distinct #18 부결 결론) + 갭발굴 5문항(누락 옵션축/자재·공정·마감/엣지케이스/제작방식 반론/추가 관리축). checkable 강제·platitude 거부.
- codex 인용 출처 = signs.com(Foam Board/Plastic Signs/Gatorboard/Falconboard) + Wikipedia(closed-cell PVC foamboard). **★전부 미국 사이니지 e-commerce — 후니/RP 라이브 미검증·도메인 가설로만 취급.**

## codex 핵심 결론 (요약)
> "**18번째 고객 주문축은 아직 필요 없어 보입니다.** 다만 빠진 것은 꽤 있습니다. 특히 mounting/display method·drilled-hole spec·corner/edge finish·durability/rigidity class·construction route는 **base-data 관리축으로는 분리 가치**가 있습니다."

★codex도 **distinct #18(고객 주문축) 부결에 독립 동의** — 우리 reverse §6·PO-1/PO-2 1차 판정과 합치(14번째 카테고리 증거·기재마운팅/자립구조 #18 부결 보강). codex가 더한 것 = **고객 주문 슬롯이 아닌 base-data 관리 facet/속성** 발굴(rigidity grade·environment class·construction route 등) + RP 미관측 옵션(타공·라운딩·이젤백·필기라미·벽부착 액세서리) 다수.

---

## Triaged 후보

### (a) 신규 후보 — `unverified` + 라우팅

> ★전부 가설. 검증법 = ① RP 라이브 PO 7상품 재캡처(옵션 SSR 노출) ② 후니 상품마스터/가격표 PO류 실측 ③ 후니 t_* 그릇 수용력. 채택은 owning agent 검증 후.

| # | codex 후보 | 분류 | 라우팅 | 검증법 |
|---|-----------|------|--------|--------|
| DC-PO-1 | **타공 스펙(hole diameter/location preset/custom)** — 구멍 유무만이 아니라 지름·위치(4코너/상단/측면/custom)가 별 옵션 | RP 미관측 옵션 후보 → 옵션#3+공정#2+제약#5 | reverse-engineer | RP PO 라이브 옵션아이콘에 타공(PCH/HOLE류) 슬롯 실재 여부 재캡처. 후니 PO류 가격표에 타공 가산 행 있는지. **★없으면 (b) RP 미보유로 폐기** |
| DC-PO-2 | **모서리 라운딩 반경(rounded corner 1/4"·1")** — straight/shape-cut만으론 부족·반경값이 가격/가공 옵션 | RP 미관측 옵션 후보 → 형상#17+공정#2 facet | reverse-engineer | RP PO `CUT_ZUN`에 라운딩 반경 하위값 있는지(현재 정사이즈/모양재단 2값만 실측). 후니 도무송/형상 칼틀에 라운딩 표현. **★형상#17 facet으로 흡수 가능성 높음** |
| DC-PO-3 | **이젤백/킥스탠드(easel-back·1개/2개·호환 사이즈 제한)** — 등신대 base와 별개·소형 POP 후면 받침 | RP 미관측 add-on 후보 → 부속물#8 add-on + 제약#5 | reverse-engineer→gap-analyst | RP PO 부자재 토글에 이젤백(CDL 외) 슬롯 실재 여부. 현재 거치대(CDL 700/1200/1500)·와이어만 실측. **★부속물#8 add-on으로 흡수 예상(거치대 동형)·distinct 아님** |
| DC-PO-4 | **벽부착/설치 액세서리 다양화(3M Command·Velcro·screw/washer·rope·ceiling-hang)** — wire-hanger만으론 부족 | RP 미관측 add-on 후보 → 부속물#8 | reverse-engineer | RP PO `WIR`(세트/레일/피스) 외 부착 액세서리 슬롯 실재 여부. **★부속물#8 add-on 흡수 예상(와이어 동형 확장)** |
| DC-PO-5 | **기능성 코팅(dry-erase/writeable laminate·anti-scratch/graffiti 보호 라미)** — 무광/유광과 다른 기능성 | RP 미관측 옵션 후보 → 공정#2 후가공 facet | reverse-engineer | RP PO `COT_DFT`(무광/유광)에 기능성 코팅값 추가 있는지. 후니 코팅 공정 코드에 기능성 라미 분리 등록 여부. **★공정#2 후가공 facet으로 흡수 예상** |
| DC-PO-6 | **소재군 세분화(Foamcore vs PVC foamboard vs Gatorboard vs Falconboard/honeycomb·edge color)** — 같은 "보드" 아님·강성/실내외/파손 차이 | base-data 자재 facet 후보 → 자재#1 facet(substrate type) | gap-analyst→vessel-designer | 후니 PO류가 포맥스/폼보드 외 소재군(허니컴 등) 취급하는지 상품마스터 실측. **★RP는 포맥스/폼보드 2종만 실측 — 후니 미취급이면 data 무관·취급이면 자재#1 substrate facet 확장(distinct 아님)** |

### (a') 신규 base-data 관리축 후보 — codex가 "분리 가치" 주장 (★우리 17축 모델 적대 프로브)

> ★codex가 "고객 주문축(#18)은 아님이나 base-data 관리축으로 분리 가치"라 주장한 항목. **고객 옵션 슬롯이 아니라 자재/제약/물류 메타속성**. 우리 판정 교훈 적용 = 이런 "분류 속성"은 자재#1/제약#5/카테고리#7 facet으로 흡수되거나 **vessel-gap이 아닌 운영 메타데이터**일 공산. 단 후니 그릇 수용력은 검증 대상.

| # | codex 주장 관리축 | 우리 1차 적대 판정 | 라우팅 | 검증법 |
|---|------------------|---------------------|--------|--------|
| DC-PO-7 | **substrate_rigidity_grade(강성 1~5)** — 고객 추천/제약에 활용 | **자재#1 facet 또는 운영 메타데이터(고객 주문축 아님)** — RP/후니 옵션에 강성 select 미실측. 후니가 강성으로 제약/추천 안 하면 vessel-gap 아님 | gap-analyst | 후니 t_mat_materials에 강성/grade 컬럼·PO 제약에 강성 기반 logic 있는지. **★RP 라이브 강성 옵션 부재 → 후니 자체 관리 필요시 자재 facet 컬럼·distinct 축 아님** |
| DC-PO-8 | **environment_class(indoor-dry/damp/outdoor-temp/long-term 내후성)** — Foamcore 실내·PVC 실내외 분리 | **자재#1 facet 또는 카테고리#7 태그(고객 주문축 아님)** — RP PO 옵션에 내후성 select 미실측 | gap-analyst | 후니 PO류에 실내외 구분 옵션/태그 실재 여부. **★RP 미관측·후니 자체 필요시 자재/카테고리 facet·distinct 아님(BN 현수막 실외 동형 — 별 축 아니었음)** |
| DC-PO-9 | **construction_route(direct UV / print-mount / laminated mount / vinyl overlay)** — printing-method#12 하나에만 묻으면 BOM/QC/제약 흐려짐 | **★최강 #18 적대 후보 — 그러나 PO-1과 동일 결론으로 부결 예상.** RP 제작방식(합지/직접출력) = pdtCode 분기 + paper variant + 코팅 게이팅으로 이미 #12 인코딩. codex도 "고객 주문축 아님" 인정 | metamodel-architect (PO-1 재확인) | RP에 "제작방식 select" 슬롯 부재 재확인(실측 0). 후니 인쇄방식#12(D-7)가 라미/직접출력 구분 표현하는지. **★PO-1 판정과 합치 = #12 facet·#18 부결. BOM/QC 분리는 공정#2 레시피 멤버로 표현(별 축 아님)** |
| DC-PO-10 | **display_install_method / logistics_fragility_class / structural_stability_class(자립/지지/현수/수지)** | **부속물#8(거치/걸이) + 제약#5(허용조합) + 운영 메타데이터** — 자립=형상#17+부속물#8 이미 분해(reverse §0.3). 물류/안정성은 고객 주문축 아닌 생산/배송 제약 | gap-analyst | 후니 PO 제약(constraints.logic)에 높이×받침대 허용조합 cascade 실재 여부. **★자립구조 #18 부결과 합치·물류 fragility는 메타모델 비귀속 운영 속성** |

### (a'') 신규 엣지케이스/제약 후보 — `unverified`

| # | codex 엣지케이스 | 분류 | 라우팅 | 검증법 |
|---|-----------------|------|--------|--------|
| DC-PO-11 | **최대 단일판 크기(material × printer bed × sheet × shipping별 max)** — Foam Board 94"×46"·Plastic 48"×96" 등 소재별 다름 | 제약#5(면적 상한) → PO-4 면적축 보강 | gap-analyst | 후니 PO 면적매트릭스(siz_width/height)에 소재별 max 상한 cascade 있는지. **★PO-4 면적 연속차원 data-gap에 "소재별 상한 제약" 추가 = nonspec max 컬럼·data-gap 보강** |
| DC-PO-12 | **custom-cut 분리 조각 금지(contour cut 도안이 여러 독립 조각이면 단일 상품 라인 깨짐)** | 제약#5(형상#17 가공 제약) | gap-analyst | 후니 모양재단에 "단일 연결 조각" 제약 있는지. **★형상#17 가공 제약 메타데이터·옵션 아님** |
| DC-PO-13 | **타공 위치-파손 제약(지름/가장자리거리/두께 부정합=파손·1"·1/2" inset 제한)** | 제약#5(타공-자재 cascade) → DC-PO-1 종속 | gap-analyst | DC-PO-1 타공 실재 시에만 유효. **★타공이 단순 add-on 아닌 가공 제약(자재 두께 cascade)** |
| DC-PO-14 | **대형 보드 휨/처짐·등신대 안정성(height×weight×center-of-gravity로 base 선택 제한)** | 제약#5(높이별 받침대 허용조합) → DC-PO-10 종속 | gap-analyst | RP 등신대 높이 선택 시 받침대 허용값 변하는지 라이브 실측. **★거치대 add-on(부속물#8)에 사이즈 종속 제약 cascade·distinct 아님** |

### (b) 이미 흡수/커버 — 폐기 (재발굴 방지)

- **production-method(합지/직접출력)이 printing-method facet인가 반론** (codex 4번) → **이미 PO-1에서 동일 논거로 적대 판정·#12 facet 확정.** codex 반론(BOM/QC 차이)도 "고객 주문축은 아님" 자인 → DC-PO-9로 재확인 라우팅하되 결론 불변(#18 부결).
- **direct UV vs mounted print 공정 차이** (codex 2번) → reverse §0.1 "합지=종이 인쇄→보드 라미네이트" 이미 공정#2(라미)로 모델링. 흡수됨.
- **size continuous + 소재별 max** (codex 3번 일부) → PO-4 면적 연속차원 data-gap으로 이미 등재. max 상한만 DC-PO-11로 보강.
- **자립구조(등신대 base·picket handle)** → reverse §0.3·PO-2에서 형상#17+부속물#8 분해 확정. codex display/stability 축(DC-PO-10)은 그 메타데이터 표현일 뿐 distinct 아님.

### (c) 오류/부적용 — 거부

- **codex 인용 출처 전부 signs.com(미국 사이니지)·Wikipedia** — RP/후니 라이브 아님. **도메인 일반 가설로만 유효**, RP가 해당 옵션을 *실제 제공하는지*는 별도 라이브 검증 필수. signs.com 옵션 존재가 RP/후니 옵션 존재를 함의하지 않음(거부 근거 아닌 검증 게이트).
- **distinct #18 신축 주장 없음** — codex 자체가 "18번째 고객 주문축 불필요" 명시 → 우리 17축 재포화와 합치, 거부할 #18 주장 자체가 없음.

---

## 종합 판정

- **codex 가용 = YES(gpt-5.5·foreground 직접호출·output 파일 수집).**
- **신규 distinct #18 후보 = 없음.** ★codex 독립 동의("18번째 고객 주문축 불필요") = reverse §6·PO-1/PO-2 distinct #18 부결 보강(14번째 외부 모델 동의·기재마운팅/자립구조 부결 강화). DC-PO-9(construction_route)가 유일한 #18 적대 후보였으나 codex 스스로 "고객 주문축 아님" 자인 → PO-1 #12 facet 결론 불변.
- **codex가 더한 것 = 전부 (a) RP 미관측 옵션 후보(타공·라운딩·이젤백·기능성라미·벽부착 액세서리) 또는 (a') base-data facet/운영 메타속성(강성 grade·내후성 class·construction route·물류 fragility)** — 신축이 아니라 **자재#1/형상#17/부속물#8/제약#5 facet 흡수 또는 data-gap 보강**. 우리 17축 모델로 무왜곡 수용 예상.
- **★핵심 = 검증 게이트.** codex 후보는 전부 signs.com 도메인 가설 → **owning agent가 ① RP PO 라이브 재캡처(해당 옵션 슬롯 실재?) ② 후니 상품마스터/가격표 PO류 실측(취급?) ③ 후니 t_* 그릇 수용력**으로 검증해야 채택. 이 deepcheck는 어떤 후보도 채택하지 않음(가설 라우팅만).
- **라우팅:** reverse-engineer(DC-PO-1~5 옵션 실재 재확인) · gap-analyst(DC-PO-6~14 facet/data-gap/제약) · metamodel-architect(DC-PO-9 PO-1 재확인) · validator(전 후보 unverified 미채택 확인·M-gate).

**검증 라우팅 한 줄:** RP 라이브 재캡처가 1차 게이트(signs.com 옵션 ≠ RP 옵션) → RP 미보유 후보는 폐기, RP 실재 후보만 후니 그릇 수용력(data-gap vs vessel-gap) 판정. distinct #18 = 외부 모델도 부결 = 17축 안정 재확인.
