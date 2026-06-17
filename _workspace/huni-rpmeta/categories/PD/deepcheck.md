# PD codex-cli 심층보강 (deepcheck) — 외부 second-opinion triage

> 후니 RP-Meta 하네스 Phase 4.5 (rpm-deepcheck). PD(스툴·슬리퍼·강아지계단 = 봉제 구조물/3D 조립 완제품)
> 분석(reverse + metamodel + gap §XIX)을 **독립 OpenAI 모델(codex-cli)** 에 주고 놓친 옵션/자재/공정/관리축/제약/
> 엣지케이스/도메인 정보를 발굴한 second-opinion 후보 triage.
> **★환각 경계 [HARD]: codex 제안은 외부 의견·가설 — 후니 라이브/엑셀/실 캡처 권위로 검증되기 전 사실 아님.
> 모든 후보 `unverified`. 채택 0건(검증 트리거로만).** AC layer-stack REFUTED 교훈(검증 전 distinct 신뢰 금지) 적용.

## 호출 메타
- **preflight:** `AVAILABLE model=gpt-5.5` (2026-06-17 세션 확인).
- **명령:** `cat context.md | codex exec -m gpt-5.5 --sandbox read-only --output-last-message out.md -` (stdin pipe·arg hang 회피·read-only 샌드박스·EXIT=0·tokens 24,911).
- **입력 컨텍스트:** PD reverse 요약(3상품 census)·17축·PD-1~PD-6 facet 판정·라이브 후니 t_* 실측(봉제 PROC_000080/088 2행·t_siz_sizes shape 컬럼 0·addons 그릇·usage_cd .07 639행·직물 자재행 실재/물성 컬럼 부재)·AC layer-stack REFUTED 주의.
- **codex 응답 품질:** 양호. ★**codex가 #18을 단정하지 않음** — "PD에 조립이 있는가?는 결정적 질문이 아니다(있다). 결정적 질문은 *construction을 재사용 가능한 정규화 객체로 관리하는가, 완제 템플릿에 박힌 고정 콘텐츠인가*"로 정확히 우리 data-gap vs vessel-gap 판별 프레임과 수렴. 검증 패턴까지 구체 제시("마케팅 카피만 있으면 #18 없음·독립 spec 행이 가격/가용성/리드타임/템플릿/법적카피를 좌우하면 #18 plausible"). AC layer-stack류 무근거 distinct 푸시 아님.

## 총괄
- **codex 후보 수: 17건** (HIGH 5 · MED 8 · LOW 4 + 총평 1). 전부 `unverified`.
- **#18 distinct 축 후보였는가:** ★있었음 — codex가 "construction/technical-pack 축"(C-1·HIGH)을 #18 최강 후보로 제기. **단 codex 스스로 "지금은 #18을 확신 못함" 명시** + 우리 PD-4 분산 facet 판정의 *바로 그 갈림길*(재사용 정규화 객체냐 고정 템플릿 콘텐츠냐)을 결정 기준으로 제시 = **우리 data-gap 판정과 프레임 일치**. 기각 예상이나 **검증 트리거로 살림**(reverse infoCall 캡처 + 엑셀 spec 컬럼 grep 1회로 판별 가능·HIGH).
- **가장 가치 있는 발굴:** codex가 우리 분석에 *전혀 없던* 도메인 정보군을 다수 제기 — ① **internal core/fill 자재**(스툴/계단 내부 폼·MDF·솜·밀도/경도·하중) ② **footwear fit system**(길이 외 폭/좌우 페어/밑창 두께/insole) ③ **textile care/safety/regulatory metadata**(세탁라벨·난연·KC·하중경고). 이들은 우리가 "구조물=고정 제조 사양(옵션 미노출)"으로 닫아버려 *역공학 슬롯 밖*이라 안 본 영역. **옵션은 아닐 가능성 높으나(우리 판정과 정합), data-gap/spec 그릇 관점에서 PD-4 내재BOM의 구체 attribute 목록을 제공** — gap-analyst가 PD-4 data-gap 적재 명세에 흡수할 후보.

---

## HIGH 후보 (검증 가능성 + 진짜 누락 가능성 높음)

### H-1. Construction Spec / Technical-Pack 축 (★#18 최강 후보 — 기각 예상이나 검증 트리거)
- **claim (codex):** 봉제/upholstery/footwear 카테고리는 옵션·자재·공정·부속물·사이즈와 *구별되는* "construction spec / tech-pack" 정규화 엔티티가 필요할 수 있다 — cover 패턴·seam type·zipper 위치·filling/core type·sole construction·non-slip 처리·removable cover·assembly method. 이들이 *재사용 정규화 spec*으로 템플릿/사이즈 variant에 붙어 SKU 유효성·가격·리드타임·QC·법적라벨을 좌우하면 #18 real.
- **`unverified`.**
- **우리 기존 판정 대조:** 우리 PD-4 = 분산 facet(부속물#8 + 자재 usage + 생산형태#15 + 가격#11)·data-gap. codex의 결정 기준("재사용 정규화 객체냐 고정 콘텐츠냐")이 **우리 data-gap vs vessel-gap 프레임과 정확히 일치** — codex도 "마케팅 카피만 있으면 #18 없음"이라 우리 판정에 동조하는 방향. 단 우리는 *RP에서 옵션 미노출=고정*만 보았고, codex는 *RP가 내부적으로 construction을 정규화 spec으로 운영할 가능성*을 적대 제기.
- **왜 갭일 수 있나:** PD-5(THO_CUT/SUB_MTR 상세 enum·price 결합)가 `unobserved`(infoCall AJAX 후행) — 우리가 SSR 슬롯만으로 distinct 0을 확정했으나, infoCall 후행 데이터에 construction spec 차원(core type·cover removability)이 *독립 선택/가격기여*로 숨어 있으면 PD-4 분산 facet이 아니라 spec 객체일 수 있음.
- **검증 방법:** ① **reverse**: PD 3상품 infoCall AJAX 캡처(node monitor/widget 재현·날조 금지) → THO_CUT_SUB_SELECT·SUB_MTR 상세 enum이 "core type/cover/seam/sole construction"을 *독립 차원·가격기여*로 노출하는지 실측. ② **gap**: 상품마스터/가격표 엑셀에서 `spec·pattern·cover·core·zipper·sole·seam·inner·outer·filling·foam·density·non-slip·assembly·pack` 컬럼 grep. ③ 사이즈 variant가 서로 다른 internal spec을 참조하는지 확인.
- **라우팅:** reverse-engineer (infoCall 캡처) → metamodel-architect (spec 객체 distinct 재판정) / vessel-designer (정규화 spec 그릇 설계 필요 시).
- **기각 예상 근거:** RP가 SSR에서 construction을 옵션 슬롯에 *전혀* 안 띄우고 마케팅 카피로만 둠(우리 §0.1 실측)·`price_gbn=tmpl_price`(완제 단가 1건) = construction이 독립 가격기여 안 함의 강증거. infoCall에서도 옵션 미노출이면 codex 결정 기준상 "#18 없음"으로 우리 판정 확정. **단 1회 캡처로 판별 가능 = HIGH(checkable).**

### H-2. Internal Core / Fill 자재 + 밀도/경도/하중 (★PD-4 data-gap attribute 보강 후보)
- **claim (codex):** 스툴/강아지계단은 내부 폼·스펀지·목재/MDF/플라스틱 코어·배팅·솜 충전재를 *밀도/경도/무게/하중* spec과 함께 가짐. 자재축이 fabric은 담아도 구조 softgoods의 *inner core 자재 + 물리속성*(density/compression/resilience/load capacity)을 못 담을 수 있음.
- **`unverified`.**
- **우리 기존 판정 대조:** 우리 PD-4 = 솜/지퍼=자재#1 usage_cd(.07 공통 639행 슬롯 보유) + data-gap. PD-2 = 직물 물성 차원(번수/신축성) 분해 컬럼 부재=WEAK(V-3). codex는 이를 *inner core 자재*로 구체화 + 물리속성 차원(밀도/경도/하중) 명시 — 우리 V-3(직물 물성)·PD-4(솜/지퍼 usage)를 **합쳐 "구조 softgoods inner-material 물성 그릇"으로 확장**하는 구체 attribute 제공.
- **왜 갭일 수 있나:** 후니 자재모델은 `width/height/depth/weight` 물리치수만 — 폼 밀도(kg/m3)·경도(쇼어)·하중(kg)을 담을 컬럼 부재. PD-4 내재BOM을 data-gap으로 적재할 때 *어떤 attribute 컬럼*이 필요한지 우리 분석에 미명세.
- **검증 방법:** **gap** — 마케팅 카피/옵션시트/가격로직/자재테이블에서 `스펀지·폼·우레탄·EPE·PP솜·MDF·목재·충전·솜·density·hardness·kg/m3·하중·load-bearing` grep. 후니 `t_mat_materials`에 폼/코어 자재행 + 물성 컬럼 유무 확인(현재 직물행만 일부 적재 확인).
- **라우팅:** gap-analyst (data-gap attribute 명세 — PD-4 §XIX-2/`_data-gaps-noted.md §9` 보강) → vessel-designer (자재모델에 inner-material 물성 차원이 V-3 확장으로 필요한지).
- **참고:** 우리 V-3(자재 분해축·직물 물성)이 이미 WEAK로 잡힘 = 신규 vessel-gap 아님 가능성 높음. codex가 더한 것 = *적재할 data-gap의 구체 attribute 목록*(밀도/경도/하중) — gap 적재 명세 풍부화.

### H-3. Footwear Fit System (길이 외 폭/좌우 페어/밑창 두께/insole) — ★PD-6 보강
- **claim (codex):** 슬리퍼는 길이(230-280mm) 외에 폭/fit grade·좌우(L/R) 페어 의미·밑창 두께·instep 높이·outsole/insole 분리·size-run 가용성을 가질 수 있음. footwear 사이즈는 항상 스칼라 길이가 아님. "pair product"는 L/R 템플릿/배치 제약을 가질 수 있음.
- **`unverified`.**
- **우리 기존 판정 대조:** 우리 PD-3 = 신발치수 230-280mm = 사이즈#13 치수 프리셋(스칼라)·PD-6 = 밑창색×사이즈 12-variant SUB_MTR. codex는 footwear fit가 *스칼라 길이 초과*(폭/L-R/insole)일 가능성 적대 제기 — 우리가 슬리퍼 사이즈를 단순 치수 프리셋으로 본 것을 challenge.
- **왜 갭일 수 있나:** PDWRSLP 디자인 업로드가 L/R 2캔버스인지·밑창(SLB*/SLW*)이 색 외 두께/경도 attribute를 가지는지 `unobserved`. 좌우 페어 = 사이즈#13 프리셋이 못 담는 별 의미(L/R 페어링 제약·템플릿 2면)일 수 있음.
- **검증 방법:** **reverse** — PDWRSLP 디자인 업로드 캔버스 수(L/R 분리?)·사이즈에 폭/밑창치수 동반 여부·SLB*/SLW* 자재행이 사이즈별 템플릿/자재코드 보유하는지 라이브 캡처. 가격표에서 슬리퍼 사이즈 축 확인.
- **라우팅:** reverse-engineer (L/R 캔버스·폭 차원 캡처) → gap-analyst (사이즈#13이 footwear fit 못 담으면 WEAK 추가).
- **기각 예상 근거:** RP SSR size select가 230-280mm 단일 치수 enum(폭/L-R 없음·우리 실측)·밑창은 색×사이즈만(SUB_MTR). 좌우 페어는 "켤레" 수량 단위(H-16)로 흡수 가능. 단 디자인 업로드 캔버스 수는 미관측 = 캡처로 확정 필요.

### H-4. Care Label / 세탁·관리 spec (textile 컴플라이언스 attribute)
- **claim (codex):** 섬유/softgoods는 관리 지침(세탁가능/드라이금지/커버분리/물세탁만/건조기금지/다림질제한)을 가짐. 고객 옵션은 아니나 자재·카테고리에 묶인 관리/컴플라이언스 attribute일 수 있음.
- **`unverified`.**
- **우리 기존 판정 대조:** 우리 분석에 care/세탁 라벨 attribute *전무*. 우리는 "지퍼처리·솜과 커버 분리 세탁"을 `[live:SSR-marketing]` 카피(non-axis)로만 기록. codex는 이를 *관리 가능한 spec attribute*로 격상 가능성 제기.
- **왜 갭일 수 있나:** 후니가 봉제 완제품 취급 시 세탁/관리 라벨을 어딘가 관리해야(상품 상세 표시·생산 라벨). 우리 PD-4 내재BOM data-gap에 *care metadata* 차원 미포함.
- **검증 방법:** **gap** — PD 상품 상세 페이지·DB/엑셀에서 `세탁·손세탁·드라이·건조기·다림질·오염·관리·care·label` grep. 후니 스키마에 care/관리 텍스트 그릇(note/tags 쉬운 한국어 라벨?) 유무.
- **라우팅:** gap-analyst (care metadata = 표시 라벨 note/tags 흡수 vs 별 그릇).
- **기각 예상 근거:** care label은 *옵션/관리 축*이 아니라 상품 상세 *표시 텍스트*일 공산 — round-15 "실무진 표시 필드=note/tags 쉬운 한국어 라벨"로 흡수 예상(신규 축 아님). 단 적재 대상 데이터로는 유효 = gap 노트.

### H-5. Safety / Regulatory / Usage Constraint 축 (하중·KC·난연·반려동물 경고)
- **claim (codex):** 강아지계단/스툴은 하중 제한·연령/체중 경고·미끄럼방지 경고·난연·아동/반려동물 안전 면책·제품 인증(KC) 데이터를 가질 수 있음. 제약축#5가 *주문 제약*은 담아도 법적/안전 제약은 *별 lifecycle 객체*(상품 가용성·라벨·클레임 좌우 시)일 수 있음.
- **`unverified`.**
- **우리 기존 판정 대조:** 우리 제약축#5 = disable/force/match/exclude/essential/min-max (주문 제약). safety/regulatory 제약 *전무*. codex가 *법적/안전 제약 = 별 lifecycle*일 가능성 제기 = #5와 구별되는 #18 후보의 한 갈래.
- **왜 갭일 수 있나:** 하중(최대하중 kg)이 사이즈/템플릿 variant별로 다르면(H-13) 비주문 제약이나 critical spec. KC 인증/난연은 카테고리 판매 자격 게이팅일 수 있음.
- **검증 방법:** **gap** — `하중·최대하중·미끄럼방지·안전·난연·KC·어린이·반려동물·주의사항·인증` grep. 한국 소비자제품 라벨링이 PD 카테고리(가구/upholstery)에 적용되는지 확인.
- **라우팅:** gap-analyst (safety/regulatory metadata 적재 대상 여부) → metamodel-architect (주문제약#5와 *구별되는* 법적/안전 제약 lifecycle이면 distinct 재판정).
- **기각 예상 근거:** safety/regulatory는 *옵션 관리 메타모델*(주문옵션 구성) 범위 밖일 공산 — 상품 상세 표시/생산 컴플라이언스(note/tags 또는 별 운영 데이터)로 흡수. 단 codex 지적대로 "사이즈별 하중 차이가 제약을 게이팅"하면 #5 확장 검토 가치 = HIGH.

---

## MED 후보

### M-6. Pattern Piece / Printable-Area 매핑 (다중 패턴 조각·인쇄면)
- **claim (codex):** 봉제 완제품은 여러 패턴 조각(top/side/front/back/L-R/strap/vamp/sole-facing/계단 riser·tread 패널)을 가질 수 있음. RP가 디자인 업로드 1개만 노출하면 갭 없음·내부적으로 아트워크를 다수 fabric 패널에 매핑하면 템플릿이 sub-region/패턴조각 필요.
- **`unverified`.**
- **우리 대조:** 우리 §0.1 "발판과 옆면 모두 이미지 적용"(PDSRPPY)을 `[live:SSR-marketing]` 디자인 영역 설명(non-axis)으로만 기록. codex는 이를 *다중 인쇄면/패턴 조각*으로 격상 가능성 제기.
- **검증 방법:** **reverse** — AI/PDF 템플릿 명명 artboard/layer·업로드 수·미리보기 surface·스툴 원형/사각·계단 단별 인쇄 패널 수 캡처.
- **라우팅:** reverse-engineer → (다중 인쇄면이면 공정#2 멀티슬롯/입력채널#16 — CL print_area 6위치 동형으로 흡수 예상).
- **참고:** CL 인쇄위치 멀티슬롯(§XV·gap §477 WEAK)과 동형 흡수 예상 = 신규 축 아님 가능성. 단 패턴조각 수는 미관측.

### M-7. Seam / Bleed / Safe-Zone (봉제 특화 재단 규칙·시접)
- **claim (codex):** 봉제 fabric 템플릿은 시접(seam allowance)·접힘 여유·트림 여유·박음질 안전영역·왜곡 경고를 가짐. 사이즈축의 work/cut/margin과 *다른* 패널별 봉제 여유일 수 있음.
- **`unverified`.**
- **우리 대조:** 우리 사이즈#13 = work/cut width·height·margin. codex는 봉제 시접이 *인쇄 bleed와 다른 패널별 여유*라 사이즈축 margin이 못 담을 가능성 제기.
- **검증 방법:** **reverse/gap** — 템플릿 파일에서 `재봉선·시접·박음질·접힘·여유분·안전영역·bleed·sewing line` 확인. 후니 t_siz_sizes margin 컬럼이 봉제 시접을 담는지.
- **라우팅:** reverse-engineer (템플릿 시접 실측) → gap-analyst (사이즈 margin이 봉제 시접 못 담으면 사이즈#13 WEAK 보강).
- **기각 예상:** 시접은 사이즈#13 margin_* 컬럼 또는 입력채널#16 템플릿 리소스(에디터 가이드라인)로 흡수 예상.

### M-8. Product Orientation / Surface Placement (윗면/측면/계단면/좌우 방향)
- **claim (codex):** 3D 굿즈는 디자인 방향 규칙(스툴 윗면만 vs 측면·계단 tread vs riser·슬리퍼 L/R 방향·결/nap 방향)을 가질 수 있음. 템플릿축에 숨거나 print-surface role로 정규화되면 입력채널 인접 축일 수 있음.
- **`unverified`.**
- **검증 방법:** **reverse** — 템플릿/미리보기 메타에서 surface 명/면 식별자·`앞면/뒷면/측면/윗면/좌/우/발등/계단면` 확인.
- **라우팅:** reverse-engineer → 공정#2 멀티슬롯/입력채널#16 흡수 예상(M-6과 동근).

### M-9. Fabric Direction / Stretch / Grain / Nap (원단 결·신축·기모·폭)
- **claim (codex):** 섬유 인쇄/재단은 결 방향·신축 방향·기모/nap 방향·가용 원단폭을 관리. 자재테이블이 치수/무게는 있으나 textile 물성 필드가 없으면 layout·인쇄/재단 방향 제약을 못 담음.
- **`unverified`.**
- **우리 대조:** PD-2 직물 물성 차원(번수/신축성) 분해 컬럼 부재=WEAK(V-3)와 직접 합류. codex가 결/nap/원단폭으로 attribute 확장.
- **검증 방법:** **gap** — 자재 메타/템플릿에서 `원단폭·결·방향·신축·텐션·기모·털방향·grain·stretch·width` 확인.
- **라우팅:** gap-analyst (V-3 직물 물성 차원 attribute 보강) → vessel-designer.
- **참고:** H-2·PD-2(V-3)와 합쳐 "직물 물성 차원" 단일 vessel 검토 항목으로 통합 권고.

### M-10. Sole Compound / Hardness / Anti-Slip Grade (밑창 = 색 외 다속성)
- **claim (codex):** 슬리퍼는 outsole 자재·경도·tread/미끄럼방지 등급·실내외·두께·색을 구별할 수 있음. 밑창색을 SUB_MTR로 본 것은 색이 sole 컴포넌트 variant의 *한 속성*일 뿐일 수 있음.
- **`unverified`.**
- **우리 대조:** 우리 PD-6 = 밑창색(검정/흰색)×사이즈 12-variant SUB_MTR. codex는 밑창이 색 외 자재/경도/두께/미끄럼등급을 가질 가능성 제기 = PD-6 밑창 sole의 attribute 풍부화.
- **검증 방법:** **gap** — `SLB01-06`/`SLW01-06` 명명·자재행·`EVA·PVC·rubber·TPR·미끄럼방지·경도·두께·실내용` 확인.
- **라우팅:** gap-analyst (PD-6 밑창 자재 attribute — 부속물#8/자재 sub_mtrl 적재 명세).
- **기각 예상:** SLB*/SLW*가 색×사이즈만이면 PD-6 판정 유지. 단 자재코드에 compound/경도 인코딩 시 자재#1 합성 차원으로 흡수.

### M-11. Packaging / Shipping Dimensional Weight (부피·박스·오버사이즈)
- **claim (codex):** 3D 조립 완제품은 상품 사이즈/수량과 독립한 배송 부피 제약(박스 크기·묶음수·부피무게·오버사이즈 요금)을 가질 수 있음.
- **`unverified`.**
- **검증 방법:** **gap** — 배송테이블/상품상세에서 `박스·포장·부피·배송비·묶음배송·택배불가·개별포장` 확인.
- **라우팅:** gap-analyst.
- **기각 예상:** 배송/물류는 *옵션 관리 메타모델* 범위 밖(주문옵션 구성 아님)·Shopby/주문 런타임 영역(메모리 shopby-excluded). 단 PD 완제품 부피가 가격#11/포장 공정#2에 묶이면 노트 가치.

### M-12. Removable Cover / Replacement Cover (커버분리·교체커버 부모-자식)
- **claim (codex):** upholstery 강아지계단/스툴은 분리/세탁 커버·지퍼·교체커버 옵션을 가질 수 있음. 커버와 inner body가 별도 주문/교체되면 부속물/자재축이 부모-자식 상품 lifecycle을 못 담을 수 있음.
- **`unverified`.**
- **우리 대조:** 우리 §0.1 "커버에 지퍼처리·솜과 커버 분리 세탁"(PDSRPPY)을 고정 사양 마케팅 카피로 기록. codex는 *교체커버가 별 주문단위*면 부모-자식 lifecycle 제기.
- **검증 방법:** **reverse** — `커버분리·탈부착·지퍼·교체커버·속커버·외피` + 커버 별도 주문 가능 여부 캡처.
- **라우팅:** reverse-engineer → metamodel-architect (커버 별 주문단위면 템플릿#4/부속물#8 부모-자식 검토).
- **기각 예상:** RP가 커버 분리를 *제조 고정 사양*으로만 둠(우리 §0.1)·별 주문단위 미노출이면 PD-4 분산 facet 유지.

### M-13. Load Rating as Size-Variant Constraint (단수/사이즈별 최대 하중)
- **claim (codex):** 스툴/강아지계단 사이즈는 단별/사이즈별 최대 하중·권장 반려동물 체중이 다를 수 있음. 비주문이나 사이즈/템플릿 variant에 붙는 critical 제약.
- **`unverified`.**
- **우리 대조:** 우리 PD-3 모호 지점 "단수→생산BOM(2단 vs 3단 자재량/공정량) 게이팅 unobserved" 기록. codex는 이를 *하중 제약*으로 구체화(H-5와 연결).
- **검증 방법:** **gap** — 상세 페이지 kg 한도·2단 vs 3단 카피/spec 표 비교.
- **라우팅:** gap-analyst (사이즈→하중 게이팅 = 제약#5 또는 표시 metadata).
- **기각 예상:** 하중은 표시 metadata(note)일 공산·사이즈#13이 하중을 게이팅하지 않으면(가격/가용성 무관) 비축 데이터.

---

## LOW 후보

### L-14. Colorfastness / Abrasion / Rub-Test metadata (견뢰도·마찰·보풀)
- **claim:** 섬유는 견뢰도·내마모·pilling·UV저항·이염을 관리할 수 있음. 주문 메타모델보다 공급사/QA일 공산이나 자재 선택이 내구성 클레임 노출 시 관련.
- **`unverified`.** **검증:** `마찰·이염·견뢰도·보풀·내구성·colorfast·abrasion` grep. **라우팅:** gap-analyst. **기각 예상:** 내부 QA·옵션 아님.

### L-15. Flammability / Upholstery Compliance (난연·방염)
- **claim:** 쿠션 가구류는 난연 등급 필요할 수 있음 — 가구/upholstery 판매 시 컴플라이언스 축 시사.
- **`unverified`.** **검증:** `난연·방염·flammability·KC` + 한국 라벨링 적용 여부. **라우팅:** gap-analyst. **기각 예상:** H-5와 합류·옵션 아님·컴플라이언스 운영 데이터.

### L-16. Pair / Set Count Semantics (켤레/세트 수량 단위)
- **claim:** 슬리퍼=켤레·강아지계단/스툴=단품. 수량이 슬리퍼는 "켤레"를 뜻해 개별 piece가 아닐 수 있음 — 수량모델이 너무 generic하면 단위 의미가 템플릿/가격/재고/생산 카운트에 영향.
- **`unverified`.**
- **우리 대조:** 우리 §2 note "켤레 단위(슬리퍼)·1켤레 주문 가능(검정)" 이미 기록·수량모델#10. codex가 단위 의미(개/켤레/세트)가 별 attribute일 가능성 제기.
- **검증:** 주문 라벨 `개·켤레·세트·pair`·가격 단위·생산시트 수량. **라우팅:** reverse-engineer. **기각 예상:** 수량모델#10의 unit 라벨 facet으로 흡수(이미 §2 기록·신규 축 아님).

### L-17. Tolerance / Handmade Variance (제작 오차·±·수작업)
- **claim:** 봉제 완제품은 원단 신축·충전·재봉·재단으로 치수 오차를 고지. 상품/자재/공정별 관리 시 사이즈 외 spec 필드 필요할 수 있음.
- **`unverified`.** **검증:** `오차·±·수작업·재봉·제작공정상·사이즈 차이` grep. **라우팅:** gap-analyst. **기각 예상:** 표시 metadata(note)·사이즈#13 tolerance facet으로 흡수.

---

## triage 종합 — validator/owning-agent 인계

| # | 후보 | rank | 라우팅 | 기각/채택 예상 | 검증 트리거 |
|---|------|:----:|--------|--------------|------------|
| H-1 | Construction Spec/tech-pack 축(#18) | HIGH | reverse→metamodel/vessel | **기각 예상**(우리 data-gap 판정과 codex 결정기준 일치) | PD infoCall 캡처 + 엑셀 spec 컬럼 grep |
| H-2 | inner core/fill 자재+밀도/경도/하중 | HIGH | gap→vessel | **PD-4 data-gap attribute 보강 채택 가능** | 자재테이블/카피 폼·코어·density grep |
| H-3 | footwear fit(폭/L-R/insole) | HIGH | reverse→gap | 기각 예상(SSR 단일 치수)·**L-R 캔버스 미관측** | PDWRSLP 업로드 캔버스·폭 캡처 |
| H-4 | care label/세탁 spec | HIGH | gap | 기각 예상(표시 라벨 note/tags)·**적재 데이터 유효** | 세탁/관리 grep |
| H-5 | safety/regulatory 제약(하중/KC/난연) | HIGH | gap→metamodel | 기각 예상(범위 밖)·**사이즈별 하중 게이팅이면 #5 확장** | 하중/KC/난연 grep |
| M-6 | pattern piece/인쇄면 | MED | reverse | CL print_area 동형 흡수 예상 | 인쇄 패널 수 캡처 |
| M-7 | seam/시접 규칙 | MED | reverse→gap | 사이즈 margin/입력채널#16 흡수 예상 | 템플릿 시접 실측 |
| M-8 | orientation/면 방향 | MED | reverse | 공정#2/입력채널#16 흡수 예상 | surface 식별자 캡처 |
| M-9 | fabric grain/stretch/원단폭 | MED | gap→vessel | **V-3 직물 물성 attribute 보강(H-2와 통합)** | 결/신축/폭 grep |
| M-10 | sole compound/경도/등급 | MED | gap | PD-6 밑창 attribute 보강 가능 | SLB*/SLW* 자재코드 grep |
| M-11 | packaging/부피무게 | MED | gap | 기각 예상(옵션 범위 밖·Shopby) | 배송/포장 grep |
| M-12 | removable cover 부모-자식 | MED | reverse→metamodel | 기각 예상(고정 사양) | 교체커버 주문 가능 캡처 |
| M-13 | load rating size-variant | MED | gap | 기각 예상(표시 metadata)·H-5 연결 | 2단 vs 3단 하중 비교 |
| L-14 | colorfastness/마모 | LOW | gap | 기각(QA·옵션 아님) | 견뢰도 grep |
| L-15 | flammability/난연 | LOW | gap | 기각(H-5 합류·컴플라이언스) | 난연 grep |
| L-16 | pair/set 단위 | LOW | reverse | 수량#10 unit facet 흡수(이미 기록) | 켤레/세트 라벨 |
| L-17 | tolerance/수작업 오차 | LOW | gap | 표시 metadata 흡수 | 오차/± grep |

**★핵심 메시지(owning agent용):**
1. **#18(H-1)은 기각 예상이나 검증 살림** — codex 스스로 단정 안 함 + 결정기준이 우리 data-gap vs vessel-gap 프레임과 일치. **PD-5 infoCall `unobserved`가 유일 미관측 진입점** — reverse infoCall 1회 캡처로 "construction이 독립 선택/가격기여인가"를 판별하면 distinct 0 확정 또는 #18 재개. AC layer-stack REFUTED 교훈대로 *캡처 전 채택 금지*.
2. **codex의 진짜 기여 = PD-4 data-gap attribute 풍부화** — H-2(inner core 밀도/경도/하중)·M-9(원단 결/신축/폭)·M-10(밑창 compound/경도)·H-4(care)·H-5(하중/KC)가 우리 §XIX-2 PD-4 data-gap 적재 명세에 *어떤 attribute 컬럼이 필요한지* 구체 목록 제공. **신규 vessel-gap 아님 가능성 높음(전부 기존 #1 V-3·#8·#5에 흡수 예상)이나 gap-analyst가 data-gap 적재 attribute 보강에 흡수 검토.**
3. **채택 0건 — 전부 `unverified`.** validator는 M-gate에서 본 후보 중 어느 것도 *검증 없이* 메타모델/갭에 silently 채택되지 않았음을 확인. 검증 후 확정/기각 시 본 표 status 갱신.

## 검증 라우팅 (SendMessage 대상)
- **reverse-engineer:** H-1(infoCall construction enum)·H-3(L-R 캔버스/폭)·M-6/M-7/M-8(인쇄면/시접/방향)·M-12(교체커버)·L-16(단위 라벨) — PD 3상품 infoCall AJAX 라이브 캡처(날조 금지·미관측분만).
- **gap-analyst:** H-2/H-4/H-5·M-9/M-10/M-11/M-13·L-14/L-15/L-17 — 엑셀/라이브 grep으로 PD-4 data-gap attribute 보강 검토(직물 물성 V-3·care/하중/밑창 compound). PD-4 §XIX-2가 *어떤 attribute*를 적재해야 하는지 명세 풍부화.
- **metamodel-architect:** H-1·H-5 — infoCall 캡처/하중 게이팅 결과 받아 #18(construction spec) / #5 확장(safety 제약) distinct 재판정. 검증 전 distinct 신축 0 유지.
- **vessel-designer:** H-2·M-9 — 직물/inner-material 물성 차원이 V-3 확장으로 vessel 필요한지(현재 WEAK·신규 vessel 아님 가능성).
- **validator:** 본 후보 17건 전건 `unverified` 확인·silently 채택 0 검증(M-gate).
