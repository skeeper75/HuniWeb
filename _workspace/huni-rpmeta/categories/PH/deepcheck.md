# PH codex-cli 심층보강 (deepcheck) — 외부 second-opinion triage

> 후니 RP-Meta 하네스 Phase 4.5 (rpm-deepcheck). PH(포토보드·액자·사진인화·포토북·포토굿즈 = "사진을 어떤 물성으로 출력하느냐"로 묶인 출력매체 카테고리·5개 이질 상품군 공존·9번째 종단)
> 분석(reverse + §0.5 client-render 재캡처 + metamodel PH-1~PH-5+형태축 + gap §XXI)을 **독립 OpenAI 모델(codex-cli gpt-5.5)** 에 주고
> 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보를 발굴한 second-opinion 후보 triage.
> **★환각 경계 [HARD]: codex 제안은 외부 의견·가설 — 후니 라이브/엑셀/실 캡처 권위로 검증되기 전 사실 아님.
> 모든 후보 `unverified`. 채택 0건(검증 트리거로만).** AC layer-stack·PD construction-spec REFUTED 교훈(검증 전 distinct 신뢰 금지·codex "no live access" 자기admission) 적용.

## 호출 메타
- **preflight:** `AVAILABLE model=gpt-5.5` (2026-06-17 세션 확인). gpt-5-codex/gpt-5는 ChatGPT 계정 400(미지원).
- **명령:** `cat ph_deepcheck_context.txt | codex exec -m gpt-5.5 --sandbox read-only --output-last-message ph_deepcheck_out.md -` (stdin pipe·arg hang 회피·read-only 샌드박스·EXIT=0·출력 11,613 bytes).
- **입력 컨텍스트:** PH reverse 요약(5 이질 상품군 census)·17축·승격 HARD 기준·§0.5 client-render 재캡처 실측(거치 OBSERVED·전면재 별도옵션 미관측·형태축 OBSERVED·[재고부족] disabled)·PH-1~PH-5+형태축 facet 판정·라이브 후니 t_* 실측(gap §XXI: option_groups 134/option_items 469/constraints.logic 10·templates 12+selections 14·surface-finish 컬럼 0·main_cat_yn 다중분류·bundle_qtys 28)·unobserved 목록(원목/알루미늄 스타일진입·전면재 다른액자·포토북·매팅/패스파르투·현상/ICC)·AC/PD REFUTED 주의 + 5개 표적 질문(#18 적대 재도전·프레이밍 도메인·사진인화 도메인·포토북 도메인·엣지케이스).
- **codex 응답 품질:** 우수·구조화 양호. ★**codex가 #18을 단정하지 않음** — 첫 문장부터 "I mostly agree with the #18 refutation"·verdict "**#18 still refuted, conditionally**". 모든 PH 항목을 기존 17축 매핑으로 명시 분해(거치→#3+#4+#13·프레임→#1+#4·전면재→#1 facet/#8·인화매체→#1+#12·포토북→#14+#9+#10·매팅→#1+#2/#14+#8). **단 1건 강한 적대 후보 = "content-container/assembly-role 축"**(인쇄 콘텐츠 ≠ 받는 그릇의 2-파트 합성 역할)을 #18 최강 후보로 제기·**그러나 "구조적 슬롯(content part vs container part 구별 재사용 vessel) 증거 없으면 승격 안 함"으로 우리 data-gap vs vessel-gap 프레임과 정확히 수렴.** AC layer-stack류 무근거 distinct 푸시 아님.

## 총괄
- **codex 후보 수: 16건** (HIGH 3 · MED 5 · LOW 8) + 독립 #18 평가 1.
- **★#18 distinct 축 후보였는가:** ★있었음 — codex가 "**Content vs Container Assembly Role**"(#1·content-container 합성역할 축)을 #18 최강 후보로 제기. **그러나 codex 스스로 "mounting 단독·photo-print medium 단독은 #18 자격 없음" 명시 + content-container도 "RedPrinting/Huni가 content part vs container part를 구별하는 *재사용 라이브 슬롯*을 보유/필요-but-부재할 때만 승격"으로 단서** = 우리 PH-1(완제 액자=인쇄물 끼우는 빈 그릇)을 정확히 같은 갈림길로 재명세하면서 **우리 data-gap 판정과 결정 기준 일치**(우리: 완제SKU#4·옵션#3·자재#1 그릇 실재·후니 KB 결함 없음 → facet). 기각 예상이나 **검증 트리거로 살림**(aperture/window 슬롯·content↔container price-component 분리 1회 확인으로 판별 가능·MED).
- **가장 가치 있는 발굴:** codex가 우리 unobserved 영역(원목/알루미늄 스타일진입·전면재 다른액자·포토북 PHBK*·매팅)을 *framing/photo-print industry-standard 렌즈*로 구체 checkable 항목으로 재명세 — ① **매팅/패스파르투(mat board)**: 우리 분석에 *전무*했던 클래식 프레이밍 차원(인쇄물과 프레임 사이 마운트 보드·색/폭/창크기/단복수/보존등급) ② **aperture/opening 기하**(듀얼/양면/멀티 = PHFRHDU/ASD/MUL의 창 개수·레이아웃·창 컷치수가 외곽 사이즈와 별개) ③ **glazing(전면 보호재) 다형성**(유리/아크릴/무반사/UV/미술관유리 — 디아섹 외 다른 액자 미관측) ④ **포토북 페이지 모델**(min/max/증분 step·spread·extra-page 가격) ⑤ **content↔container 사이즈 호환 제약**(인쇄물 크기 vs 창 개구부). 옵션 미관측분 다수 = reverse-engineer 추가 캡처 표적 제공.

---

## Triage — 후보별 분류 (claim · unverified · 라우팅 · 검증방법)

> 분류: **(a) 신규 후보** = 우리 분석에 없거나 약하게만 다룬 것 → 라우팅. **(b) 이미 다룸** = discard with note. **(c) 부적용** = reject with reason.
> 모든 claim = `unverified` (codex 가설·"no live access" self-admission).

### HIGH 후보 (진짜 누락 가능성 × checkability 높음)

#### H-1. ★Content vs Container Assembly Role (콘텐츠-그릇 합성역할 축) = #18 최강 후보 — 기각 예상이나 검증 트리거
- **claim (codex):** 액자·포토북·머그·마운트보드는 모두 *유저 이미지 콘텐츠 + 물리 수신 객체*를 결합. **액자가 특히 다른 이유 = 빈 그릇(empty container)으로 판매 가능하고 인쇄물(print)은 별개/부재일 수 있음.** 기존 완제SKU#4는 "상품 = 인쇄된 물건"을 가정하나, 액자/북/머그는 *content part(인쇄물) vs container part(프레임/북/머그)* 이중성을 가짐. → checkable: RedPrinting/Huni에 `content/insert/inner print/photo/image area` vs `container/frame/case/body/shell` 구별 필드·"프레임 사이즈" vs "인쇄/이미지 사이즈" 별도 option_group·프레임 본체 vs 삽입 인쇄물 별도 price_component가 있는가. 있으면 #4 완제SKU가 "too flat"임을 드러냄.
- **분류:** (a) 신규 후보 — 우리 PH-1과 *바로 그 갈림길*. 우리 PH-1 = 완제SKU#4(거치+마감+사이즈 인코딩)+자재#1(프레임재질)+생산형태#15(C 완제품)·facet·data-gap.
- **`unverified`.** 라우팅 → **metamodel-architect (content-container 이중성 = distinct #18인가, 완제SKU#4 facet인가 적대 재검) · reverse-engineer (프레임 사이즈 vs 이미지 사이즈 별도 option_group 캡처)**.
- **우리 기존 판정 대조:** codex 결정 기준("구조적 재사용 슬롯 증거 없으면 승격 안 함·marketing/SKU 라벨만으론 부족")이 **우리 vessel-gap vs data-gap 프레임과 정확히 일치** — PD H-1 construction-spec과 동형(codex가 우리 판별 프레임에 수렴). 우리 §0.5 실측: PHFRDIA에서 거치+마감+사이즈가 **완제 SKU combobox 1개에 인코딩**·별도 "이미지 사이즈" select 미관측·후니 KB "content/container 어느 축에도 없음" 결함 부재.
- **왜 갭일 수 있나:** §0.5는 PHFRDIA 1상품 + 거치/마감/사이즈만 캡처. **"프레임 사이즈 ≠ 삽입 인쇄물 사이즈" 별도 차원이 다른 액자(멀티프레임·매팅 있는 액자)에서 노출되거나, 빈 프레임만 단독 주문(인쇄물 별개)되면** content-container 이중성이 완제SKU#4의 flat variant로 안 담길 수 있음.
- **검증 방법:** ① **reverse** — PHFRMUL(멀티)·PHFRHDU(듀얼)·매팅 있는 액자 client-render 캡처: "프레임 외곽 사이즈" vs "삽입 이미지/창 사이즈"가 *독립 선택*인지·빈 프레임 단독 주문 가능한지. ② **gap** — 후니/엑셀에서 `content·insert·inner·image area·창·개구부·삽입` vs `container·frame·shell·body` 컬럼 grep·프레임 본체 vs 인쇄물 별도 price_component 유무. ③ 완제SKU#4 그릇(t_prd_templates/template_selections)이 "container shell + 다수 image slot"을 표현 가능한지.
- **기각 예상 근거:** §0.5 PHFRDIA에서 거치+마감+사이즈가 단일 완제SKU combobox·별도 이미지사이즈 select 미관측·`price_gbn=tmpl_price`(완제 단가)·후니 KB content/container 결함 부재 = codex 결정 기준상 "재사용 슬롯 없음 → #18 없음"으로 우리 판정 확정. **단 멀티/매팅 액자 미관측 = aperture/window 1회 캡처로 판별 가능 = HIGH(checkable).** AC layer-stack·PD construction REFUTED 교훈대로 *캡처 전 채택 금지*.

#### H-2. ★매팅 / 패스파르투 (mat board) = 우리 분석에 전무한 클래식 프레이밍 차원 — HIGH
- **claim (codex):** 프레이밍에서 mat board(인쇄물과 프레임 사이 마운트 보드·패스파르투)는 클래식한 *독립 spec* — 색·두께·창 크기(window size)·창 개수(openings)·reveal(여백 노출)·보존등급(acid-free/conservation). → checkable: 액자 상품이 mat board yes/no·mat color·mat width·window/opening size·single/double mat·acid-free/conservation mat을 *선택 가능*하게 노출하는가.
- **분류:** (a) 신규 후보 — 우리 PH 분석에 매팅/마운트보드 차원 *0건*. §0.5도 거치/마감/사이즈만·매팅 미캡처.
- **`unverified`.** 라우팅 → **reverse-engineer (RP 액자에 mat board 옵션 유무 캡처) → gap-analyst (mat=자재#1+공정#2/#14 창컷+부속물#8 / 컴파운드 컴포넌트 vessel-gap?)**.
- **왜 갭일 수 있나:** codex 지적 — "**후니가 프레임 어셈블리에 2차 자재/공정(mat)을 붙일 방법이 없으면, 'matting' 자체가 아니라 *컴파운드 컴포넌트* vessel-gap을 드러냄.**" 이는 H-1(content-container)과 동근 — 액자가 단일 완제SKU가 아니라 *프레임 + mat + glazing + 인쇄물* 다부품 합성이면 완제SKU#4 flat이 약함.
- **검증 방법:** **reverse** — 액자 client-render에 mat board select·mat 색/폭/창 옵션 유무. **gap** — `매트·매트지·마운트보드·패스파르투·창·여백·acid-free·보존·archival` grep·후니 자재모델에 mat 자재행 유무·한 prd_cd가 frame자재+mat자재+glazing자재 다중 mat_cd를 usage_cd role로 갖는 구조 실재 여부(AC M-2 다부품·PR usage_cd 역할전파 동근).
- **기각 예상 근거:** RedPrinting 액자가 mat 옵션 미노출(저가 포토프레임 중심)이면 future gap(현재 누락 아님). 단 매팅은 *실측 가능한 갭 후보*로 가치 — 우리 unobserved와 겹침. AC M-2(role-scoped 다중자재)·PD H-2(inner core 자재)와 합쳐 "다부품 합성 자재 그릇" 검토 항목으로 통합 권고.

#### H-3. Aperture / Opening Count + Window Geometry (창 개수·레이아웃·창 컷치수) — HIGH
- **claim (codex):** 듀얼/양면/멀티 프레임(PHFRHDU/PHFRASD/PHFRMUL)은 사진 *개구부(opening) 개수*와 레이아웃을 인코딩·이는 외곽 프레임 사이즈와 *다름*. → checkable: single/double/multi opening count·aperture size(외곽과 별개)·aperture layout(2-up/3-up/콜라주)·window cut dims·frame당 photo count.
- **분류:** (a) 신규 후보 — 우리 reverse §3 보조군 note "듀얼/양면형/멀티 = 다면(multi-aperture) variant(형태#14 후보이나 옵션 미관측)"로 *약하게* 기록·정착 안 됨. §0.5 미캡처.
- **`unverified`.** 라우팅 → **reverse-engineer (PHFRHDU/ASD/MUL 창 개수·레이아웃 캡처) → metamodel-architect (창 개수=완제SKU#4 split인가·옵션#3 선택인가·사이즈#13 창치수인가·#14 창컷공정인가)**.
- **검증 방법:** **reverse** — 멀티/듀얼 프레임 client-render: 창 개수가 *선택 가능*인가(옵션#3)·*상품 split*인가(완제SKU#4·각 pdtCode)·창 치수가 명시(사이즈#13)인가·창컷 공정 구동(#14)인가. frame당 photo count·콜라주 레이아웃 유무.
- **기각 예상 근거:** 창 개수가 pdtCode split(PHFRHDU=듀얼·PHFRMUL=멀티 = 각 별 상품)이면 완제SKU#4 흡수·신규 축 아님. 단 *한 상품 내 창 개수/레이아웃 선택 + 창별 image slot*이면 H-1 content-container와 합류해 #13+#14로 흡수 가능 여부 적대 재검 필요 = MED-HIGH(codex 평가 "Medium-high·#13+#14 흡수 가능, 단 후니 dedicated aperture/window 슬롯 있으면 별개").

### MED 후보

#### M-4. Glazing / Front Protector 다형성 (유리/아크릴/무반사/UV/미술관유리) — 디아섹 외 다른 액자 미관측
- **claim (codex):** 프레이밍은 보통 glass/acrylic/anti-glare/UV-protective/non-reflective/museum glass를 구별. **디아섹이 전면재 내재라고 다른 프레임이 glazing 옵션 노출 안 한다는 보장 없음.** → checkable: 원목/알루미늄/한나무/멀티 프레임에 glass vs acrylic·무반사·UV·glazing 없음·교체 전면시트 옵션 유무.
- **분류:** (a) 신규 후보(부분 적대) — 우리 §0.5 PH-2 = "전면 보호재 별도 옵션 미관측(디아섹은 상품 내재)"·**디아섹 1상품만 캡처**. codex가 디아섹≠전 액자임을 정확히 지적.
- **`unverified`.** 라우팅 → **reverse-engineer (원목/알루미늄/한나무/멀티 액자 glazing 옵션 캡처)**.
- **우리 기존 판정 대조:** 우리 PH-2 = 전면재=자재#1 내재(facet)·"별도 옵션 미관측"·#18 부결. codex는 *디아섹 외 액자*에서 glazing이 *선택 가능*이면 자재#1 선택(facet) 또는 부속물#8(add-on)일 수 있다고 — 어느 경우든 distinct 축은 아님(codex "Low-medium·likely material/process").
- **검증 방법:** **reverse** — PHFRWOD/PHFRALU/PHFRHAN/PHFRMUL client-render(스타일 진입 펼침 포함)에 glazing select 유무. 있으면 자재#1 선택 facet·없으면 PH-2 판정 유지.
- **기각 예상 근거:** glazing 선택돼도 자재#1 facet/부속물#8 흡수(codex 동의)·distinct 축 아님. 단 **§0.5가 디아섹 1상품만 = 전면재 차원이 다른 액자에 실재하는지는 미관측** → reverse 추가 캡처로 PH-2 "전면재=내재 facet" 일반화 검증 가치.

#### M-5. Mounting Hardware vs Mounting Mode (거치 모드 ≠ 실제 하드웨어 spec)
- **claim (codex):** "탁상용/벽걸이"는 고객대면 *모드*일 뿐·기저 실제 spec은 easel-back/hanger/sawtooth/wire/D-ring/stand leg/adhesive pad·가로/세로 사용가능 하드웨어·포함 vs 옵션. → checkable: 프레임 옵션이 easel back/wall hanger/sawtooth/wire/D-ring/stand leg·포함 vs 옵션 하드웨어를 노출하는가.
- **분류:** (b) 대부분 이미 다룸(약한 적대) — 우리 §0.5 거치(탁상용/벽걸이)=옵션#3 캐스케이드 상위 차원·PH-2 후면 받침=부속물#8 후보(미관측). codex가 더한 것 = 거치 모드 *아래* 실제 하드웨어 spec·우리 약함.
- **`unverified`.** 라우팅 → **gap-analyst (거치 하드웨어 = 부속물#8/옵션#3 흡수 vs 횡단 "installation/mounting spec" 재사용 슬롯)**.
- **검증 방법:** **reverse/gap** — 거치 선택 후 하드웨어 세부(easel/wire/D-ring) 노출 여부·`easel·이젤·고리·와이어·D링·받침·스탠드` grep. **codex 핵심 단서: "frames·signs·panels·banners·acrylic stands를 *횡단하는* dedicated 재사용 'installation/mounting spec' 슬롯이 있을 때만 distinct."** AC 등신대 받침·BN 거치대·PD 자립과 합류 검토.
- **기각 예상 근거:** codex "Low·mounting remains a facet unless 횡단 재사용 슬롯" — 거치=옵션#3 캐스케이드·하드웨어=부속물#8 흡수·우리 #18 부결 유지. 단 *횡단 마운팅 spec 슬롯*(AC받침/BN거치대/PD자립/PH거치 공통) 검토는 vessel 단계 가치(gap-analyst가 cross-category 판단).

#### M-6. Page Count / Spread Count 모델 (포토북 = 우리 under-captured PHBK*) — 페이지 증분·extra-page 가격
- **claim (codex):** 포토북은 거의 확실히 페이지 수 제약 + 증분 가격 보유 — min/max pages·증분 step(+2/+4)·spread count·extra page pricing·고정 템플릿 페이지수. → checkable: PHBK* min/max pages·증분·spread·extra-page 가격.
- **분류:** (a) 신규 후보 — 우리 reverse 그룹 D = "면수/제본방식 client-render 미노출(PHBKMYB 양면만 실측)"·**포토북 페이지 모델 미캡처**. gap §XXI도 포토북 제본=#14·PR 책자 동형으로만 처리.
- **`unverified`.** 라우팅 → **reverse-engineer (PHBK* 페이지 옵션 캡처) → gap-analyst (페이지수=수량모델#10 / 공정파라미터#9 / 가격#11 라우팅)**.
- **검증 방법:** **reverse** — PHBKMYB/BKS/SMP/PRM/STA client-render 페이지 옵션. **gap** — `페이지·면수·spread·증분·추가페이지·min/max` + 가격표 페이지축. PR 책자(digital_price·면수 모델) 동형 흡수 예상.
- **기각 예상 근거:** codex "Low·#10 quantity-like 또는 #9/#11" — 페이지수는 수량모델#10(PR 책자 동형) 흡수·신규 축 아님 예상. 단 **포토북 PHBK* 자체가 우리 미캡처** = reverse 보강 가치(직물 물성 V-3처럼 data-gap attribute 풍부화).

#### M-7. File Resolution Constraint (업로드 해상도 vs 출력 사이즈·DPI/PPI 검증)
- **claim (codex):** 사진 상품은 업로드 이미지 해상도를 출력 사이즈·DPI/PPI·종횡비에 대해 검증 — min pixel·DPI 경고·종횡비 불일치 경고·저해상 차단 vs 경고·사이즈별 권장 픽셀. → checkable: RP 에디터/업로드 + 후니 constraints에 min pixel/DPI/종횡비 검증 유무.
- **분류:** (a) 신규 후보(약) — 우리 분석에 해상도 검증 *전무*. 단 주문시점 검증(에디터 런타임) 경계.
- **`unverified`.** 라우팅 → **gap-analyst (제약#5 JSONLogic + 디자인입력#16 + 사이즈#13 — 단 주문런타임 경계)**.
- **검증 방법:** **reverse/gap** — 에디터 업로드 플로우의 min pixel·DPI 경고·종횡비 경고·`해상도·dpi·ppi·픽셀·저화질` grep. 후니 constraints.logic이 해상도 검증 담는가.
- **기각 예상 근거:** codex "Low but important operationally" — 해상도 검증은 *주문시점 검증(에디터 런타임)*이라 base-data 관리축 경계(AC M-7·PD-aware·TP H-1 STATE 류로 일부 out-of-scope 가능). 운영상 중요하나 옵션 관리 메타모델 축 아닐 공산.

#### M-8. Pack / Set Semantics (600매 = 일반 수량 ≠ image count vs sheet count 분기)
- **claim (codex):** "600매" 상품은 일반 수량처럼 행동 안 할 수 있음 — fixed pack/sheet-count bundle/photo-count selection. → checkable: 사진인화 수량이 order quantity·photo 개수·pack당 sheet·고정 bundle·mixed-image count·same-image repeat count 중 무엇으로 모델되는가.
- **분류:** (b) 이미 다룸(부분 적대) — 우리 PH-4 = set/sheets 단위(600매·4/5sheets)=수량모델#10 set 배수 + base_quant#6·gap WEAK(bundle_qtys 28). codex가 더한 것 = **image count vs physical sheet count 분기**(같은 이미지 반복 vs 다른 이미지 혼합).
- **`unverified`.** 라우팅 → **gap-analyst (PH-4 보강 — image-count ≠ sheet-count 분기가 수량모델#10에 담기는가)**.
- **검증 방법:** **reverse/gap** — 600매 상품이 "같은 디자인 600매"인가 "600개 다른 이미지"인가·PHPTPRM 건수(orderCnt)×매수(printCnt) 이중 수량과의 관계. `매·장·set·켤레·image count` 단위.
- **기각 예상 근거:** codex "Low-medium if image count와 physical sheet count diverge" — 우리 이미 PHPTPRM 건수(디자인 수)×매수 이중 수량 기록·수량모델#10 흡수. **단 image-count vs sheet-count 분기는 PH-4 set 모델 WEAK 보강 attribute** = gap 적재 명세 풍부화(TP 포토카드 "set=20장 같은디자인 판매단위" 동형).

### LOW 후보

#### L-9. Color Management / ICC / Color Correction (sRGB/AdobeRGB·자동보정·흑백모드)
- **claim:** 사진 출력은 sRGB 가정·자동보정·무보정·ICC 프로파일·밝기/색 경고 포함 가능. → checkable: 업로드/에디터가 sRGB/AdobeRGB 가이드·ICC·자동보정 on/off·밝기보정·모니터 캘리브레이션 면책·흑백 사진 모드 노출하는가.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버. **`unverified`.** 라우팅 → **gap-analyst (인쇄방식레시피#12 또는 공정파라미터#9 멤버 풍부화)**. **검증:** `sRGB·ICC·색보정·자동보정·흑백·캘리브레이션` grep. **기각 예상:** codex "Low-medium·#12 풍부화이지 신규 축 아님" — 사진인화가 distinct #12 멤버(은염/잉크젯/dye-sub 캘리브레이션 워크플로) 추가 후보·표적 질문 (c)에 codex 직답 "**photo-print medium은 #18 자격 없음·#12+#1 강화**".

#### L-10. Photo Paper Weight + Surface (gsm·RC·은염 vs 잉크젯·brand/grade)
- **claim:** "인화용지(반광-러스터)/유광"은 paper brand·weight·RC paper·pearl/luster/gloss·premium/silk을 숨길 수 있음. → checkable: 자재master/엑셀에 paper gsm·RC/photo paper·luster/gloss/matte/silk·brand·은염/잉크젯/디지털프레스.
- **분류:** (b) 이미 다룸 — 우리 PH-3 = 인화지×마감 surface-finish facet(자재#1·mat_nm 융합)·gap WEAK(surface-finish 컬럼 0건). codex가 더한 것 = paper weight/gsm/RC/은염 attribute. **`unverified`.** 라우팅 → **gap-analyst (PH-3 자재 attribute 보강·V-3 surface-finish 합성축)**. **검증:** `gsm·RC·은염·실버할라이드·잉크젯·grade` grep. **기각 예상:** codex "Low·#1 material facet" — 우리 PH-3 자재#1·V-3 흡수·신규 축 아님. AC A-2·ST S-4와 합쳐 surface-finish 합성 vessel 검토.

#### L-11. Border / Borderless / White Margin (테두리/무테/이미지 fit 모드)
- **claim:** 사진인화는 borderless/bordered/white-margin·image fit(crop/fit/fill)·trim-safe 경고 제공 흔함. → checkable: 사진 상품에 borderless·white border·margin width·fit mode·trim-safe 경고.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버. **`unverified`.** 라우팅 → **gap-analyst (사이즈#13 margin 또는 공정파라미터#9)**. **검증:** `테두리·무테·여백·border·crop·fit·fill` grep. **기각 예상:** codex "Low" — 사이즈#13 margin/공정파라미터#9 흡수·신규 축 아님.

#### L-12. Binding Type / Lay-Flat (포토북 제본 — hard/soft/premium/lay-flat/PUR/saddle)
- **claim:** 포토북은 hard/soft/premium/lay-flat/perfect/saddle stitch/PUR/wire 구별 가능. → checkable: PHBK가 binding type·lay-flat·cover type·spine width·gutter 경고 노출하는가.
- **분류:** (b) 이미 다룸 — 우리 gap §XXI 포토북 제본(소프트/하드/프리미엄)=#14·PR 책자 동형. **`unverified`.** 라우팅 → **gap-analyst (PHBK 제본 = #14 본체형태가공·PR 동형)**. **검증:** `제본·lay-flat·소프트/하드커버·PUR·중철·spine` grep. **기각 예상:** codex "Low·#14+#4" — #14 본체형태가공·완제SKU#4 split 흡수·신규 축 아님(PR 책자 동형).

#### L-13. Cover Material / Cover Finish (포토북 표지 자재/라미·내지/면지 분리)
- **claim:** 포토북은 내지/표지 stock/라미네이트/하드커버 보드 분리 가능. → checkable: PHBK 표지 자재·라미·matte/gloss·가죽/패브릭/포토 커버·면지 옵션.
- **분류:** (a) 신규 후보(약·포토북 보강) — 우리 reverse 그룹 D = 자재(표지/내지)·공정(제본)으로 약하게만. **`unverified`.** 라우팅 → **gap-analyst (PHBK 표지=자재#1+공정#2+#14)**. **검증:** `표지·커버·내지·면지·라미·가죽/패브릭 커버` grep. **기각 예상:** codex "Low·#1+#2+#14" — 자재#1/공정#2/본체형태가공#14 흡수·신규 축 아님.

#### L-14. Orientation (가로/세로·동일 사이즈 회전 vs 고정)
- **claim:** 프레임/사진은 portrait/landscape 거동 보유 흔함·같은 물리 사이즈 회전 가능 vs 거치대/고리가 방향 고정. → checkable: orientation이 선택 가능인가 사이즈/템플릿에서 추론되는가.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버(형태축=일반/정사각/파노라마 비율은 PH-4 형태축 흡수). **`unverified`.** 라우팅 → **gap-analyst (사이즈#13 aspect 또는 옵션#3)**. **검증:** `가로·세로·portrait·landscape·방향` 옵션. **기각 예상:** codex "low" — 사이즈#13 aspect/옵션#3 흡수·형태축(PH-4·일반/정사각/파노라마)과 동근·신규 축 아님.

#### L-15. Depth / Rabbet / Object Framing (프레임 내부 깊이·두꺼운 인쇄물/캔버스·spacer)
- **claim:** 프레임은 rabbet depth에 따라 flat print만 vs 두꺼운 보드/캔버스 지원. → checkable: 프레임 spec이 inner depth·호환 인쇄물 두께·spacer·"object frame" 지원 노출하는가.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버. **`unverified`.** 라우팅 → **gap-analyst (제약#5 + 사이즈#13 치수 + 자재#1 body spec)**. **검증:** `깊이·depth·두께·spacer·rabbet·object frame` 옵션. **기각 예상:** codex 명시 없음(LOW로 분류)·제약#5/사이즈#13/자재#1 흡수 예상. H-1 content-container 호환제약(인쇄물 두께 vs 프레임 깊이)과 동근 — content↔container 사이즈/두께 호환 제약.

#### L-16. Archival / Conservation Grade (acid-free/lignin-free/UV-safe/museum/보존등급)
- **claim:** 사진/프레이밍 산업은 acid-free·lignin-free·UV-safe·archival-grade 컴포넌트 분류. → checkable: 상품spec/자재master에 acid-free·archival·UV·conservation·museum 용어.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버. **`unverified`.** 라우팅 → **gap-analyst (자재#1 facet 또는 기초코드#6 enum)**. **검증:** `acid-free·무산성·보존·archival·UV차단·미술관` grep. **기각 예상:** codex "Low·#1 facet 또는 #6 enum" — 자재#1 facet/기초코드#6 흡수·신규 축 아님(매팅 H-2 보존등급과 합류·RedPrinting 저가 포토프레임 중심이면 미운영 future gap).

---

## triage 종합 — validator/owning-agent 인계

| # | 후보 | rank | 라우팅 | 기각/채택 예상 | 검증 트리거 |
|---|------|:----:|--------|--------------|------------|
| H-1 | Content-Container assembly-role 축(#18) | HIGH | reverse→metamodel | **기각 예상**(우리 PH-1 data-gap 판정과 codex 결정기준 일치) | 멀티/매팅 액자 캡처: 프레임사이즈 vs 이미지사이즈 별도 option·빈프레임 단독주문·content/container price-component 분리 |
| H-2 | 매팅/패스파르투(mat board) | HIGH | reverse→gap | **신규 캡처 가치·다부품 합성 자재 vessel 검토**(AC M-2·PD H-2 합류) | 액자 mat board 옵션·mat 색/폭/창·다중 mat_cd usage_cd role |
| H-3 | aperture/opening 개수·창 기하 | HIGH | reverse→metamodel | 기각 예상(#4 split / #13 / #14 흡수)·**창개수 선택+창별 slot이면 H-1 합류** | PHFRHDU/ASD/MUL 창개수·레이아웃·창컷 치수 캡처 |
| M-4 | glazing 다형성(디아섹 외 액자) | MED | reverse | 기각 예상(자재#1 facet/#8)·**PH-2 일반화 검증** | 원목/알루미늄/한나무/멀티 glazing 옵션 캡처 |
| M-5 | 거치 모드 ≠ 하드웨어 spec | MED | gap | 기각 예상(부속물#8/옵션#3)·**횡단 mounting spec 슬롯 검토**(AC받침/BN거치/PD자립 합류) | easel/wire/D-ring 하드웨어 노출·횡단 재사용 슬롯 |
| M-6 | 포토북 페이지 모델(under-captured) | MED | reverse→gap | 기각 예상(#10/#9/#11·PR 책자 동형)·**PHBK* 미캡처 보강** | PHBK* min/max/증분/spread/extra-page 캡처 |
| M-7 | 파일 해상도 검증 | MED | gap | 기각 예상(주문런타임 경계·out-of-scope) | min pixel/DPI/종횡비 경고 |
| M-8 | pack/set semantics(image vs sheet count) | MED | gap | **PH-4 set 모델 WEAK attribute 보강** | 600매=같은디자인 반복 vs 다른이미지 혼합 |
| L-9 | color mgmt/ICC | LOW | gap | 기각(#12 풍부화·신규 축 아님·codex 직답 photo medium≠#18) | sRGB/ICC/색보정/흑백 grep |
| L-10 | photo paper weight/surface | LOW | gap | PH-3 자재 attribute 보강(V-3·surface-finish) | gsm/RC/은염 grep |
| L-11 | border/borderless | LOW | gap | 기각(#13 margin/#9) | 테두리/무테/fit 모드 |
| L-12 | binding/lay-flat | LOW | gap | 기각(#14+#4·PR 책자 동형) | 제본/lay-flat/spine |
| L-13 | cover material/finish | LOW | gap | 기각(#1+#2+#14·포토북 보강) | 표지/커버/면지 grep |
| L-14 | orientation | LOW | gap | 기각(#13 aspect/#3·형태축 동근) | 가로/세로 옵션 |
| L-15 | depth/rabbet/object framing | LOW | gap | 기각(#5+#13+#1·H-1 호환제약 동근) | 깊이/두께/spacer |
| L-16 | archival/conservation grade | LOW | gap | 기각(#1 facet/#6 enum·매팅 H-2 합류) | acid-free/보존/archival grep |

**★핵심 메시지(owning agent용):**
1. **codex가 #18 부결에 동의(conditionally) — 강한 적대 도전 1건(H-1 content-container)이나 우리 프레임에 수렴.** codex 첫 문장 "mostly agree"·verdict "still refuted, conditionally"·"mounting 단독·photo-print medium 단독은 #18 자격 없음" 명시. 유일 적대 후보 H-1(콘텐츠-그릇 합성역할)도 **"재사용 라이브 슬롯(content part vs container part 구별·aperture/window·per-slot image) 증거 없으면 승격 안 함"**으로 우리 PH-1(완제SKU#4 그릇 실재·후니 KB 결함 없음 → facet/data-gap) 결정 기준과 정확히 일치. **PD H-1 construction-spec과 동형(codex가 우리 data-gap vs vessel-gap 판별 프레임에 자율 수렴)·AC layer-stack류 무근거 distinct 푸시 아님.** ST 형상#17처럼 KB 결함+전용 슬롯 둘 다 충족하는 후보 0건. → **9번째 카테고리 distinct 0·17축 재포화 부결을 codex 독립 동의.**
2. **codex의 진짜 기여 = 우리 unobserved 영역의 framing/photo industry-standard 재명세.** H-2(매팅/패스파르투·우리 분석 전무)·H-3(aperture/창 기하)·M-4(glazing 다형성·디아섹 외 미관측)·M-6(포토북 페이지 모델·PHBK* 미캡처)가 reverse-engineer 추가 client-render 캡처의 *표적*. **신규 vessel-gap 아님 가능성 높음(전부 기존 #1/#4/#13/#14에 흡수 예상)이나, H-1+H-2+H-3이 합류하면 "액자=프레임+mat+glazing+인쇄물 다부품 합성"이 완제SKU#4 flat을 넘는지가 유일한 vessel 압박점** — AC M-2(role-scoped 다중자재)·PD H-2(inner core)와 합쳐 "다부품 합성 자재/컴포넌트 vessel" 검토 항목으로 통합 권고(gap-analyst).
3. **채택 0건 — 전부 `unverified`.** validator는 M-gate에서 본 후보 16건 중 어느 것도 *검증 없이* 메타모델/갭에 silently 채택되지 않았음을 확인. 검증 후 확정/기각 시 본 표 status 갱신.

## validator 핸드오프 (M-gate 확인용·carry-forward unverified 후보)
- **채택 0** — 위 후보 16건 전부 `unverified`. metamodel-architect/gap-analyst/reverse-engineer가 라이브/엑셀/캡처로 검증하기 전 어떤 후보도 메타모델/갭에 반영 안 됨.
- **재포화(distinct 0·17축) 적대 압박점:** codex가 **H-1 content-container를 #18 최강 후보로 제기**(단 "conditionally·구조적 슬롯 증거 없으면 부결"). validator는 metamodel-architect가 H-1을 *적대적으로* 재검했는지(완제SKU#4가 content↔container 이중성·aperture/window·per-slot image를 무손실 표현 여부·후니 KB content/container 결함 부재 확인) 확인. **예상: AC layer-stack·PD construction REFUTED처럼 기각 — codex는 라이브 RP 캡처 없이 framing 도메인 추론(self-admitted no live access)·§0.5 PHFRDIA 실측이 거치+마감+사이즈 단일 완제SKU·별도 이미지사이즈 select 미관측·후니 KB content/container 결함 부재를 이미 보임.** 단 **H-1/H-2/H-3은 §0.5 미캡처 영역(멀티/매팅/aperture)과 정확히 겹쳐 *실측 가능한 갭 후보*로 가치** — 멀티/매팅 액자 client-render 1회 캡처가 검증 권위.
- **carry-forward(다음 재consult까지 open):** H-1(content-container 슬롯)·H-2(mat board 옵션)·H-3(aperture 개수/창)·M-4(glazing 다형성)·M-6(포토북 페이지 모델) — 전부 reverse-engineer 추가 client-render 캡처 대기. 캡처 결과로 facet/distinct 최종 확정 시 status 갱신(채택/기각).
- **codex 환각 경계 준수:** codex 어떤 항목도 "라이브 확인했다" 주장 안 함(self-admission "no live access"·전부 framing/photo 도메인 지식 추론·inference vs checkable 명시 구분). checkable 후보(H-1~H-3·M-4·M-6·매팅/aperture/glazing/페이지)는 RedPrinting client-render 캡처·업로드 가이드로 검증 가능, 불가검증/범위외(M-7 해상도검증=주문런타임·L-16 archival=RP 미운영 가능)는 경계/미관측으로 기각 예상.

## 정직 기록
- codex 호출 성공(EXIT 0·gpt-5.5·11.6KB). 데드락/오류 없음. preflight `AVAILABLE model=gpt-5.5`.
- codex 출력은 풍부·구조화 우수하나 *일반 framing/photo-printing 도메인 지식* 기반(라이브 RedPrinting 미접속·self-admission) — RedPrinting PH가 실제 운영하는 것 vs 일반 액자/사진샵이 운영하는 것의 갭은 **client-render 캡처/가이드 검증 전 미확정.** HIGH 후보도 "검증 가능한 가설"이지 "확인된 누락"이 아님.
- ★codex 독립 #18 평가 = **부결 동의(conditionally)** — "mounting·photo-medium 단독 #18 자격 없음·유일 credible 후보=content-container이나 재사용 슬롯 증거 필요"로 우리 PH-1/PH-2 판정과 결정 기준 일치. **8 카테고리(BN/GS/TP/PR/ST/CL/AC/PD) + PH 9번째 = codex가 #18 부결에 독립 동의한 패턴 유지**(ST 형상#17만 승격·나머지 재포화에 codex 일관 동조).
- 가장 큰 가치 = codex가 우리 §0.5 미캡처 unobserved(원목/알루미늄 스타일진입·전면재 다른액자·포토북·매팅)를 *framing industry-standard 렌즈*로 구체 checkable 항목(mat board·aperture/window·glazing 다형성·페이지 증분·content↔container 호환제약)으로 재명세 → reverse-engineer 추가 client-render 캡처 시 표적 제공.
