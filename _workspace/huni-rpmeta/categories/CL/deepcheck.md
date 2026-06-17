# CL 카테고리 — codex-cli 심층보강 (deepcheck)

> 후니 RP-Meta 하네스 Phase 4.5 산출 (rpm-deepcheck).
> 외부 독립 모델(OpenAI gpt-5.5·codex exec read-only)에게 CL 분석(reverse+metamodel+gap) 컨텍스트를 주고
> "우리가 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보"를 second-opinion으로 발굴한 뒤 triage.

## 환각 경계 [HARD]
- codex 제안 = **외부 의견·가설**. 후니 라이브/엑셀/실 캡처 권위로 검증되기 전 **사실 아님**. 전 후보 `unverified`.
- codex가 인용한 URL(Printful·FTC·ISO)은 **외부 표준/경쟁사 자료**이지 RedPrinting/후니 실측 아님 — "checkable" 주장은 검증 트리거로만 사용.
- codex 네트워크 격리 샌드박스(`--sandbox read-only`) — URL 인용은 학습데이터 기반 confabulation 가능성. **실 fetch/실측 전 unverified.**
- **채택 0** — 본 문서는 검증 후보 목록일 뿐. 메타모델/갭/그릇 변경은 owning agent가 검증 후 결정.

## codex 호출 기록
- preflight: `AVAILABLE model=gpt-5.5` (2026-06-17).
- 호출: `cat prompt | codex exec -m gpt-5.5 --sandbox read-only --output-last-message <out> -` (stdin pipe — arg hang 회피, PR/ST 교훈).
- EXIT=0·9,109 bytes·75,326 tokens. 정상 응답.

---

## ★ 최대 관전 포인트 결과: 의류 variant #18 — codex 적대 확인

**codex 판정: 우리의 facet 부결에 동의 ("I mostly agree with your rejection of apparel variant as a standalone axis").**
- codex: `size x color -> MTRL_COD` + garment/material SKU + print method + print position + availability constraints 로 commercial variant 표현 가능 — 별 축 불요.
- **즉 codex는 distinct #18을 다시 밀지 않았다.** 우리 17축 모델 robustness 추가 입증 (PR/ST/TP 패턴 반복 — 외부 모델도 facet 동의).
- 단 codex는 **다른 결의 후보**를 제기: "apparel variant" 축이 아니라 **blank garment program / supplier-style governance entity**(브랜드+공급사 스타일코드+fit block+body pattern+재고/lifecycle)가 matrix 위 *상위 거버넌스 객체*로 누락됐을 수 있다 → HIGH-1로 triage(아래).

---

## Triage 후보 목록 (HIGH/MED/LOW)

총 13 후보. HIGH 3 · MED 6 · LOW 4. 전부 `unverified`.

### HIGH — 검증 우선 (그릇/축에 실질 영향 가능)

#### H-1. Blank garment program / supplier-style 거버넌스 엔티티 (★codex가 든 유일한 "축급" 후보)
- **claim:** 의류 base-data에 `brand + supplier style code + fit block + body pattern + 재고 source + lifecycle(단종/재입고/대체규칙)`을 가진 **상위 부모 객체**가 필요하며, size/color SKU는 그 아래 매달린다. 우리 자재축#1(소재/PTT)이 substrate 추상화만 담으면 이 거버넌스 부모가 누락.
- **why it matters:** Gildan/Printstar/United Athle 완제 블랭크는 "면 + 사이즈 + 색"이 아니라 브랜드 스타일코드·fit·치수표·care-label 기준·평량·혼용률·원산지·재입고 lifecycle·단종색·대체규칙을 *통째로 governing*. CL reverse는 자체(SXSRT)/브랜드(SXZSB)/단체 3분기를 "원단 카탈로그 계열"로만 봤고(C-6) — codex는 그 위에 *공급사 스타일 프로그램* 거버넌스 객체를 제기.
- **routing → metamodel-architect (적대 재검):** 이것이 distinct 축인가, 아니면 생산형태#15(블랭크=완제 공급) + 자재#1(브랜드 카탈로그 계열) + 카테고리#7의 facet 클러스터인가? CL C-6에서 우리는 "원단 라이브러리 3계열=자재"로 판정했으나 codex는 *lifecycle/거버넌스*(단종/재입고/대체)를 강조 — 우리 분석에 재고·lifecycle 거버넌스 차원이 없음. **단 후니는 인쇄소(블랭크 procurement 모델 미정)** — RedPrinting이 이 거버넌스를 실제로 별 그릇으로 갖는지 미관측. 적대 판정 필요(우리는 자재 facet 강등 예상이나 lifecycle 간선은 신규 정보).
- **verify:** ① RedPrinting CL 상품의 `apparel_info`/`product_data`에 브랜드 스타일·재고·단종 필드 존재 여부 (huni-widget 캡처 `major_apparel_*.json` 재확인 — size_color_info 셀 HIDE_RSN/QUICK_ORD_YN이 재고성 신호인지) ② 후니 라이브 t_*에 의류 블랭크 공급사/스타일/재고 그릇 유무 (gap-analyst information_schema). **checkable.**

#### H-2. 장식방식(decoration_method)이 인쇄방식(print_method)보다 상위 — 자수/패치/라벨 누락
- **claim:** 우리 `PRINT_TYPE`(DTF/직접/실크 3종·#12 인쇄방식)이 의류 장식의 전부가 아님. **자수(embroidery)·패치·우븐라벨·넥라벨·소매라벨·행택**은 인쇄위치(#2 공정)도 인쇄방식(#12)도 아닌 별 장식방식 — stitch count·실색·backing·digitizing fee·hoop limit·min line thickness 등 인쇄와 완전히 다른 artwork 검증/가격 모델.
- **why it matters:** CL reverse의 print_area(위치)·print_type(방식)는 *인쇄* 전제. 자수는 위치도 방식도 아닌 third decoration family. 우리 17축이 자수를 공정#2 멤버로 흡수할 수 있으나 stitch-count 가격·digitizing setup은 공정 파라미터#9의 새 도메인. **RedPrinting CL 30상품에 자수 옵션이 실재하는지 미관측** (reverse는 DTF/직접/실크만 포착).
- **routing → reverse-engineer (재캡처) + metamodel-architect:** RedPrinting CL 상품에 자수/패치/라벨 장식 옵션이 있는지 reverse 재확인. 있으면 print_type enum이 "decoration_method"로 일반화돼야 하는지(공정#2 + 파라미터#9 흡수 vs 신규 family) 판정. 없으면 후니 도메인 확장 후보로만 기록.
- **verify:** ① RedPrinting CL `apparel_info.print_type` enum이 DTF/DIR/SLK 3종으로 닫혀있는지 vs 자수/전사 추가종 (huni-widget 캡처 + 라이브 SSR CLAPDFT sodu select 재확인) ② 후니 공정 t_* 트리에 자수/digitizing 멤버 유무. **checkable (캡처 권위).**
- **★VERDICT: REFUTED-for-RP (2026-06-17·reverse-engineer 캡처 실측).** `major_apparel_CLSTSHS.json`·`major_apparel_CLTMSHS.json`의 `apparel_info.print_type` enum이 두 캡처 모두 **인쇄방식 3종으로 닫힘**: PTP_DTF(DTF 열전사)·PTP_DIR(직접인쇄)·PTP_SLK(날염/실크인쇄). 자수(embroidery)·패치(patch)·우븐/넥라벨·와펜 코드 **enum에 부재**. 전 캡처 키워드 전수 스캔(자수/패치/라벨/embroider/patch/와펜/EMB/자카드) **0 hit** ("전사/실크" hit는 print_type COD_NME 자체). pcs_info PCS 그룹도 DIR_MTR(부자재직접인쇄)·PDT_WRK(제품가공·인쇄위치)·PAK_POL(폴리백포장) 3종뿐 — 숨은 장식축 없음. **결론: RedPrinting CL은 비인쇄 장식방식을 옵션으로 미노출 → #12(인쇄방식)를 decoration_method로 일반화할 RP 근거 없음.** 자수/패치는 후니 도메인 확장 후보로만 보류(RP 메타모델에 미반영). metamodel-architect 재진입 불요.

#### H-3. 사이즈×색 매트릭스 위 재고/lifecycle 상태 — 정적 매트릭스 모델의 한계
- **claim:** 우리 size×color 227셀 모델(C-3)은 셀별 HIDE_YN(가용성)만 제약#5로 흡수. codex: 각 셀이 **재고 상태·재입고 ETA·단종 플래그·대체 SKU·공급사 우선순위·백오더 정책**을 가질 수 있음 — 의류 블랭크는 *조달 재고*이지 종이 substrate처럼 무한공급 아님. 정적 매트릭스가 깨짐.
- **why it matters:** CL reverse는 size_color_info의 HIDE_YN/QUICK_ORD_YN/HIDE_RSN을 *셀 가용성 제약*(C-3)으로만 봤다. codex는 그것이 *재고 상태*일 수 있다고 제기 — `QUICK_ORD_YN`(빠른주문)·`HIDE_RSN`(숨김사유)이 재고/단종 신호면 우리 제약#5 흡수는 부분적(상태=정적 disable로 평면화하면 재입고/대체 의미 소실). gap §XV-2가 `option_items.use_yn`을 HIDE_YN 대응으로 봤으나 재고 동역학은 미검토.
- **routing → gap-analyst + metamodel-architect:** size_color_info 셀의 HIDE_RSN/QUICK_ORD_YN 실측값이 재고/단종 의미인지 (이미 reverse가 "셀별 HIDE_YN/QUICK_ORD_YN/HIDE_RSN 데이터는 실측·UI 비활성 캐스케이드 동작 미관측"으로 unobserved 표기 §라이브결과). 재고성이면 제약#5(정적)에 흡수 불가 — 재고 lifecycle 차원 검토(H-1과 연결).
- **verify:** huni-widget 캡처 `major_apparel_*.json`의 size_color_info HIDE_RSN 실제 값 enum 확인 (재고없음/단종/주문제한 등). **checkable (캡처 보유·값만 미파싱).**

### MED — 도메인 보강 후보 (그릇 표현력 검토)

#### M-1. 평량(fabric weight oz/gsm)을 1급 자재 식별자로
- **claim:** 평량(150gsm cotton tee vs 220gsm heavyweight)이 free text가 아니라 1급 자재 속성 — 인쇄방식 호환성·품질·가격·배송중량·수축·불투명도 결정. 같은 "면 티셔츠"라도 평량이 다르면 별 판매 블랭크.
- **우리 분석 상태:** CL reverse가 평량(oz)을 *본체 SKU 차이*로 인식 (CLST 4.01~10.0oz·"원단 평량(oz)이 본체 SKU 차이"·G-1 HARD 분해 `{fabric/PTT, color/CLR, size/WGT}`). **이미 잡힘 — codex 후보가 우리 분해축과 정합.** 단 우리는 oz를 PTT(원단타입)에 융합, codex는 별 `gsm` 컬럼 권고. 분해 granularity 차이.
- **routing → metamodel-architect (확인·재확인):** G-1 분해 `{PTT, CLR, WGT}`의 WGT가 codex의 fabric weight와 동일 개념인지 확인 (우리 WGT=사이즈 자리 추정 vs codex=평량). **★주의: CL reverse는 "사이즈 첫자리도 MTRL_CD에 인코딩(SXSRT1xx=S)"으로 WGT 자리를 사이즈로 추정** — codex의 fabric weight와 충돌 가능. 평량 vs 사이즈 자리 재검 필요.
- **verify:** MTRL_COD 구조(SXSRT326)에서 어느 자리가 평량/사이즈/색인지 huni-widget 캡처 size_info+size_color_info 대조. **checkable.**

#### M-2. 혼용률(fiber composition) 섹션별·예외 로직
- **claim:** 혼용률이 garment 전체 단일 튜플이 아님 — body/sleeve/rib/lining/elastic/trim/decoration이 별 표기 필요(FTC textile labeling guide 인용). 자재합성축#1(D-2)이 섹션별 혼용률을 담아야.
- **우리 분석 상태:** D-2 자재 합성축은 MTRL_CD 다축 합성(PTT/CLR/WGT/인쇄방식)이나 **혼용률·섹션별 구성은 미모델**. 신규 도메인 차원.
- **routing → metamodel-architect (도메인 확장 후보):** 단 — RedPrinting CL이 혼용률을 옵션/관리축으로 노출하는지 미관측 (reverse는 혼용률 옵션 0건). FTC=미국 규제이지 RedPrinting/후니 실측 아님. **후니 라벨링은 KC/한국 규제** — 외부 표준 직접 이식 금지(자가확보 원칙). 도메인 확장 후보로만 기록, 옵션축은 아님.
- **verify:** RedPrinting CL 상품에 혼용률/섹션 구성 옵션/필드 유무 (없을 가능성 높음 — 인쇄소는 블랭크 spec를 옵션화 안 함). **checkable (negative 예상).**

#### M-3. care/wash 라벨 = base data (장식방식 종속)
- **claim:** care-symbol/code가 마케팅 카피 아닌 base data — DTF/DTG/실크/자수/박/퍼프/열전사가 wash/iron/dry 제약을 바꿈(ISO 3758:2023 인용). garment + decoration_method에 묶인 care 메타.
- **우리 분석 상태:** care/wash 라벨 **미모델** — CL 어느 축에도 없음. 단 인쇄소 옵션이라기보다 완제 garment 판매 시 필요(후니가 블랭크 decorating만이면 불요).
- **routing → gap-analyst (후니 사업모델 의존):** 후니가 완제 garment 판매인지 고객 블랭크 decorating인지에 따라 필요성 갈림(H-1·M-7과 연결). RedPrinting CL이 care 라벨을 관리하는지 미관측.
- **verify:** RedPrinting CL 상품 상세에 care 정보 필드 유무 + 후니 사업모델 (사용자 확인 필요). **checkable.**

#### M-4. 실크인쇄 변종 세분 (plastisol/water-based/discharge/puff/foil/spot-color count)
- **claim:** 우리 "silk-screen(PTP_SLK)" 1종이 과소모델 — 실크는 plastisol/수성/발포/금박/형광/고밀도/glow + spot color 수 변종을 가지며 각각 MOQ·screen setup·curing·fabric 호환·가격·durability·artwork rule이 다름.
- **우리 분석 상태:** CL reverse는 PTP_SLK 1종 + Pantone 1124(별색)만 포착. 발포/전사/플로킹/금은박 등 실크 변종 **미관측**. 단 Pantone 1124가 spot-color count를 부분 담음.
- **routing → reverse-engineer (재캡처):** RedPrinting CL `print_type` enum이 PTP_SLK로 단일인지 vs 나염 하위 변종 (발포/금박 등) 존재. 있으면 공정#2 별색/특수인쇄 family 멤버 확장.
- **verify:** huni-widget 캡처 print_type enum 전수 + CLAPDFT SSR sodu/print 옵션 재확인. **checkable (캡처 권위).**

#### M-5. 인쇄위치 geometry — enum이 아닌 치수/anchor/safe-area
- **claim:** print_area 6위치가 단순 enum이 아니라 각 위치별 min/max 치수·anchor point·safe area·회전·adult/child 스케일·garment별 placement offset 필요. 아동 120 셔츠 front vs 성인 3XL vs 앞치마 vs 토트백 vs 소매는 다른 인쇄 사각형.
- **우리 분석 상태:** gap §XV-3가 정확히 이를 잡음 — "위치별 공정 파라미터(앞면 인쇄영역 size·소매 좌표·KOI_NME 에디터 매핑)는 #9 공정파라미터 GAP(ref_param_json 부재)·#16 디자인입력 채널 GAP에 의존". **이미 GAP으로 라우팅됨.** codex가 위치 geometry 중요성 재확인.
- **routing → gap-analyst (이미 잡힘·재확인):** §XV-3 위치 파라미터 GAP(#9)·에디터 매핑 GAP(#16)에 흡수. CLAPDFT의 size select(작업/공방 가슴 150×50·포켓 90×100)가 위치별 치수 실증 — reverse §3에 이미 있음.
- **verify:** CLAPDFT SSR size 옵션(위치별 mm 치수 융합)이 위치 geometry 그릇 필요 입증 — 이미 reverse 보유. 추가 검증 불요(GAP 확정).

#### M-6. 장식방식별 MOQ·setup·stitch-count 가격
- **claim:** 수량모델이 method-specific MOQ 필요 — DTG/DTF 1+·실크 수량/screen setup·자수 digitizing/stitch-count 가격. 우리 이중수량(디자인수×인쇄수량)은 setup amortization·color-count·stitch-count 미포착.
- **우리 분석 상태:** 수량모델#10(D-5)은 이중수량(ORD_CNT×PRN_CNT). MOQ/setup/stitch-count는 **가격기여역할#11 + 공정 파라미터#9 도메인이나 CL에서 미관측** (CLSTSHS 가격캡처는 본체16200+위치3700만·MOQ/setup 미노출).
- **routing → gap-analyst (가격 트랙·미관측):** 인쇄방식별 MOQ/setup이 RedPrinting CL에 실재하는지 미관측 (가격캡처 1조합만). H-2(자수)와 연결 — 자수면 stitch-count 가격이 #9/#11 신규.
- **verify:** RedPrinting CL 인쇄방식별 가격 차이·MOQ 캡처 (실크 MOQ·자수 digitizing). **checkable (재캡처 필요).**

### LOW — 기록만 (후니 사업모델/규제 의존 또는 이미 흡수)

#### L-1. 사이즈 차트 표준화 (body length/chest/shoulder/측정법·KS/US/EU·tolerance)
- **claim:** size_info가 S/M/L 넘어 측정 schema(총장·가슴·어깨·소매·tolerance·단위·측정법·성인/아동/성별/fit) 필요.
- **상태:** CL reverse는 size_info 코드(XS~3XL·GBN adult/child)만 포착·측정값 미관측. 사이즈 차트는 *판매 UX/반품* 관심사이지 base-data 관리축은 아님(우리는 사이즈#13 enum으로 충분). GBN(C-8)은 이미 잡힘.
- **routing → 기록만.** 후니가 사이즈 차트를 옵션 아닌 표시정보로 가질 수 있음 (round-15 "실무진 표시 필드=쉬운 한국어 라벨" note 동형). 관리축 아님.

#### L-2. mockup/proof 워크플로 (garment×색×각도×위치×방식 미리보기 템플릿)
- **claim:** 의류 mockup/proof 템플릿이 operational base data — garment style·color·model angle·print position·decoration method별.
- **상태:** 이는 **디자인입력채널#16(D-11·TP) + 위치 KOI_NME 에디터 매핑** 도메인 — 우리 #16 GAP에 부분 흡수. mockup 생성은 에디터/위젯 런타임 관심사이지 base-data 관리축 신규 아님(D-8 UI 런타임=facet 동근).
- **routing → 기록만 (vessel-designer #16 그릇 참고).** RedPrinting RedEditorSDK가 mockup을 담당 (huni-widget 권위) — base-data 아님.

#### L-3. 컴플라이언스 라벨·원산지 (FTC/KC textile labeling)
- **claim:** 완제 garment 판매 시 원산지/제조사/수입사/혼용률 라벨 필드 필요 (FTC 인용·단 한국은 KC 별도).
- **상태:** 후니 사업모델 의존(블랭크 decorating이면 불요·완제 판매면 필요). codex 스스로 "Korea has its own regime, don't hard-code US rules" 명시. **외부 규제 직접 이식 금지** (자가확보 원칙·메모리 `dbmap-domain-knowledge-before-asking`).
- **routing → 기록만 (사업모델 확정 시 재검).** M-2·M-3·H-1과 동일 사업모델 게이트.

#### L-4. DTG/DTF/sublimation fabric 호환 제약
- **claim:** 인쇄방식 가용성이 fiber 구성·fabric texture·garment 색·두께에 종속 (DTG=천연섬유 강함·DTF=cotton/poly/fleece/nylon 범용·Printful 인용).
- **상태:** 인쇄방식↔자재 게이팅은 **#12 인쇄방식 레시피 → 자재#1 자재풀 게이팅(PR P-7)으로 이미 모델됨** ("PrintMethod gates Material pool"). CL DTF↔fabric 호환은 그 facet의 의류판 — 신규 아님. 제약#5(force/disable)로 표현.
- **routing → 기록만 (이미 흡수·#12/#5).** RedPrinting CL이 방식×fabric disable을 실제 운영하는지는 size_color_info HIDE_YN/disable_pcs로 부분 검증 가능 (H-3과 연결).

---

## codex 제시 스키마 스트레스 테스트 (검증 트리거로 보존)

codex가 제안한 "17축으로 표현 가능한가" 시험 케이스 — **검증용 시나리오로 가치 있음**(채택 아님):

> Gildan-style 성인 티, heather gray, 90/10 cotton/poly, 3XL, front DTF + left-chest 자수 + 넥라벨 + care label override + 실크 MOQ 20 미만 불가 + 아동사이즈 없음 + 3XL은 선택색만 + 공급사 재고 일시품절 + fit block·gsm 동등 시만 대체 블랭크 허용.

- **이 케이스가 우리 모델에 던지는 진짜 질문 3개:** ① 자수+DTF 동시(H-2 decoration_method) ② 재고 일시품절·대체규칙(H-1·H-3 blank governance/inventory) ③ fit/gsm 동등 대체(H-1 supplier-style governance).
- codex 결론: "missing piece is not apparel variant, it is **blank garment program governance + richer decoration/label/compliance constraints**" — **우리 #18 부결을 지지하되, 거버넌스/장식/재고 차원을 보강 후보로 제시.**
- **validator 핸드오프:** 이 케이스는 vessel/gap 검증 시 "17축이 의류 풀 시나리오를 견디는가"의 적대 테스트로 재사용 가능.

---

## 라우팅 요약 (owning agent 검증용)

| 후보 | 등급 | 라우팅 | 검증 방법 | 상태 |
|------|:---:|--------|----------|:---:|
| H-1 blank garment program 거버넌스 | HIGH | metamodel-architect (적대 재검) + gap-analyst | RedPrinting apparel_info 재고/스타일/lifecycle 필드 + 후니 t_* 의류 블랭크 그릇 | unverified |
| H-2 decoration_method (자수/패치/라벨) | HIGH | reverse-engineer (재캡처) + metamodel-architect | RedPrinting CL print_type enum 전수 (DTF/DIR/SLK 외 자수?) | **REFUTED-for-RP** (print_type=DTF/DIR/SLK 3종으로 닫힘·자수/패치 enum 부재·키워드 0 hit·2026-06-17) |
| H-3 size×color 셀 재고 lifecycle | HIGH | gap-analyst + metamodel-architect | size_color_info HIDE_RSN/QUICK_ORD_YN 실측값 파싱 (재고성?) | unverified |
| M-1 평량 1급 식별자 | MED | metamodel-architect (확인) | MTRL_COD 자리 분해 (평량 vs 사이즈 자리 충돌 재검) | unverified |
| M-2 섹션별 혼용률 | MED | metamodel-architect (도메인) | RedPrinting CL 혼용률 옵션 유무 (negative 예상) | unverified |
| M-3 care/wash 라벨 | MED | gap-analyst (사업모델) | 후니 완제판매 vs decorating + RP care 필드 | unverified |
| M-4 실크 변종 세분 | MED | reverse-engineer (재캡처) | print_type 나염 하위 변종 (발포/금박) | unverified |
| M-5 인쇄위치 geometry | MED | gap-analyst (이미 §XV-3 GAP) | CLAPDFT 위치별 mm 치수 (이미 보유) | 흡수확인 |
| M-6 장식방식별 MOQ/setup/stitch | MED | gap-analyst (가격·미관측) | RP 인쇄방식별 MOQ/가격 캡처 | unverified |
| L-1 사이즈 차트 표준 | LOW | 기록만 | (관리축 아님·표시정보) | 기록 |
| L-2 mockup/proof 워크플로 | LOW | 기록만 (#16 참고) | (에디터 런타임·base-data 아님) | 기록 |
| L-3 컴플라이언스 라벨 | LOW | 기록만 (사업모델) | (KC 규제·외부이식 금지) | 기록 |
| L-4 DTG/DTF fabric 호환 | LOW | 기록만 (이미 #12/#5 흡수) | (PR P-7 자재풀 게이팅 의류판) | 흡수확인 |

## 종합
- **★의류 variant #18: codex도 facet 부결 동의 — 모델 robustness 추가 입증** (외부 독립 모델이 distinct 안 밀음·PR/ST/TP 패턴 반복).
- **신규 결의 후보 1건(H-1 blank garment governance)** — codex가 든 유일한 "축급" 후보. 단 후니=인쇄소(블랭크 procurement 모델 미정)·RedPrinting 거버넌스 그릇 미관측 → 적대 검증 후 자재#1/생산형태#15 facet 흡수 예상이나 **재고/lifecycle 간선은 우리 분석에 없던 신규 정보**.
- **의류 특화 도메인 보강 6건(H-2 자수·M-1 평량·M-2 혼용률·M-3 care·M-4 실크변종·M-6 MOQ)** — 대부분 *RedPrinting CL 미관측분 재캡처*로 falsifiable. H-2(자수)가 가장 actionable (print_type enum이 3종으로 닫혔는지 캡처 권위로 즉시 확인 가능).
- **이미 잡힌/흡수 4건(M-5 위치geometry=§XV-3·L-4 fabric호환=#12/PR P-7·L-2 mockup=#16·L-1 사이즈차트=표시정보)** — codex 후보 중 우리 분석이 이미 커버.
- **채택 0** — owning agent 검증 전 사실 아님. validator에 후보 리스트 핸드오프 (M-gate: 무단 채택 0 확인).
