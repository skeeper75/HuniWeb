# AC 카테고리 — codex-cli 심층보강 (rpm-deepcheck)

> 후니 RP-Meta 하네스 Phase 4.5 산출물 (rpm-deepcheck).
> codex(OpenAI gpt-5.5)에게 AC 분석(reverse+metamodel A-1~A-9+gap §XVII)을 주고 **놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보**를 독립 second-opinion으로 발굴.
> **★환각 경계 [HARD]: codex 제안은 외부 의견·가설 — 후니 라이브/엑셀/실 캡처 권위로 검증되기 전 사실 아님. 모든 후보 `unverified`. 채택 0. 검증 트리거로만.** codex "라이브 인용 보유→checkable" 주장 신뢰 금지(네트워크 격리 confabulation·PR/ST/CL/TP 교훈).

## codex 호출 메타
- **preflight:** `AVAILABLE model=gpt-5.5` (2026-06-17 확인). gpt-5-codex/gpt-5는 ChatGPT 계정 400(미지원).
- **호출:** `cat /tmp/ac_deepcheck_context.txt | codex exec -m gpt-5.5 --sandbox read-only --output-last-message <out> -` (stdin pipe — arg hang 회피·PR/ST/CL 교훈). EXIT 0·출력 13,768 bytes.
- **컨텍스트 제공분:** 도메인(아크릴 카테고리) + 17축 메타모델 요약 + AC 9 fragment 판정(특히 A-8 가공방식 그룹핑 #18 부결 근거·형상#17과 대조) + unobserved 목록 + 5개 표적 질문(#18 적대 재도전·아크릴 특화 누락·엣지케이스·도메인 사실·가격모델).

## 후보 수 + HIGH 요약 (한눈에)
- **총 후보 18건** (codex 원 항목): HIGH 7 · MED 8 · LOW-MED 2 · LOW 1.
- **★#18 distinct 축 후보를 codex가 밀었는가? — YES, 강하게.** codex는 A-8 가공방식 그룹핑(우리가 부결)에는 동조하면서도, **"가공방식 그룹핑이 아니라 *ordered composite/layer-stack construction*(순서화된 적층 구성 레시피)이 진짜 놓친 #18"**이라고 강하게 주장(HIGH·confidence HIGH). 우리 분석이 명찰 합지를 process+material+option으로 분해한 것이 단순 케이스엔 맞으나 샌드위치 아크릴·양면(화이트 blocker)·렌티큘러·코롯토에서 *적층 순서/레이어별 허용연산*을 관리객체로 못 담는다는 것. → **D-13 후보(적층구성/레이어스택)로 metamodel-architect 적대 재검 라우팅.**
- **그 다음 강한 distinct-축 후보:** ① 렌티큘러=surface-finish가 아니라 *광학 이미지 변환 워크플로우*(HIGH·우리 A-2 facet 판정 적대) ② 코롯토=volume-form 축(MED-HIGH·우리 A-3 분산 facet 판정 적대) ③ edge-finishing(엣지가공: 폴리싱/프로스트/다이아컷)=공정#2 또는 독립 축(HIGH·우리 미발굴).
- **예상 검증 결과:** TP H-6/H-1처럼 **HIGH 후보 다수가 검증 후 기각될 가능성** — codex는 라이브 RedPrinting 캡처 없이 일반 아크릴 도메인 지식으로 추론(자기 admission "no live access"). 단 **layer-stack·hole-geometry·edge-finishing·white-layer-order·double-sided-registration·lenticular-workflow는 *실측 가능한 갭 후보*로 가치**(우리 unobserved 영역과 정확히 겹침). 라이브 로그인 에디터 캡처/업로드 가이드/가격표가 검증 권위.

---

## Triage — 후보별 분류 (claim · unverified · 라우팅 · 검증방법)

> 분류: **(a) 신규 후보** = 우리 분석에 없거나 약하게만 다룬 것 → 라우팅. **(b) 이미 다룸** = discard with note. **(c) 부적용** = reject with reason.
> 모든 claim = `unverified` (codex 가설).

### HIGH 후보

#### H-1. ★적층구성/레이어스택(composite/layer-stack) = 놓친 #18 강주장 — codex 최우선
- **codex claim:** 아크릴 제품은 "material+process"가 아니라 *순서화된 물리 적층*(앞기재/인쇄층/화이트층/접착·라미/뒤기재/보호필름/부착물)으로 governing됨. 이 스택이 제조가능성·가격·아트워크규칙·두께결과·투명거동·양면정합·내구성을 결정. 기존 축은 *조각*은 담아도 *순서화된 구성 레시피를 관리객체로* 못 담음. 명찰 합지(PET+아크릴) 단순분해는 OK이나 샌드위치(아크릴+인쇄+아크릴)·양면(이미지 사이 화이트 blocker)·렌티큘러·코롯토에서 약화. **놓친 lifecycle 속성 = "순서화된 물리 레이어 스택 + 레이어별 허용 인쇄/가공 연산".**
- **분류:** (a) 신규 후보 — 우리 A-8은 가공방식 그룹핑을 부결했으나 codex는 *다른 각도*(적층 순서)를 제기. A-3 분산 facet·A-5 화이트·A-7 합지를 **횡단하는 새 관리 관심사**일 수 있음.
- **`unverified`.** 라우팅 → **metamodel-architect (distinct vs facet 적대 재검 — D-13 후보)**.
- **검증방법:** RedPrinting/경쟁 아크릴 벤더의 "앞면/뒷면/화이트/이중레이어/샌드위치/렌티큘러/홀로그램 라미" 옵션 테이블 라이브 확인 — *같은 시각 옵션이 필요 아트워크 레이어·두께·생산단계를 바꾸면* layer-stack이 관리 단위. **가격/계산이 자재코드+공정코드가 아니라 스택 레시피에 종속하면 distinct.** 후니 측: 양면 아크릴 화이트 blocker·샌드위치 적재 그릇 유무(라이브 information_schema에 layer/stack/sequence 컬럼). ★적대 검증 시 **기존 17축(공정#2 순서 + 자재#1 합성 + 옵션#3)이 스택을 표현 가능한지** 먼저 — TP T-A/H-6처럼 "기존 축 조합으로 무손실"이면 facet 강등 예상. 단 *레이어별 허용연산 게이팅*이 진짜 새 lifecycle이면 승급 후보.

- **★검증 결과 (2026-06-17 캡처 직접 파싱 — 환각 경계: 리터럴 필드만): `D-13 REFUTED-for-RP`.**
  - **필드명 전수:** 3캡처(major_radius_ACTHDKY·major_acc_ACPDSTD·product_ACNTHAP)에 `layer/레이어/순서/sequence/stack/적층/depth/z-index` 필드 **0건**. 매칭된 건 `DIV_SEQ`(pcs/size 표시순서·전 행 값=0)·`order_yn`/`orderCnt`(주문=order)뿐 — 적층순서 아님.
  - **양면(layer order?):** `option_info.print_data` = 단일 enum 2값(`O 앞뒤 인쇄 같음`/`X 앞뒤 인쇄 다름`)·**순서화 레이어 배열 아님**(ACTHDKY). ACPDSTD·ACNTHAP은 print_data 전부 null.
  - **화이트(레이어 위치 슬롯?):** `PRT_WHT/DFXXX` = 평면 PCS 1행(DIV_SEQ=0·VIEW=Y·ESN=N·MTRL_CD='')·레이어위치/순서 슬롯 **부재**. NOTICE="PDF: 화이트레이어 자동적용 / 에디터: 이미지맞춤" = 주문/출력시점 자동처리이지 관리객체 슬롯 아님.
  - **합지(BON_PAP·ACNTHAP):** 평면 공정 PCS 1행(DIV_SEQ=0·ESN=Y)·스택 위치 슬롯 부재.
  - **라미 적층순서(2T+1T):** `MTRL_NM` 텍스트 문자열에만 인코딩("아크릴_3T 투명 라미(2T+1T)"·"홀로그램3T 깨진유리 라미(1T+2T)")·구조화 per-layer 슬롯 **아님**. GRP_OPTION_CD는 일반/라미 그룹핑만(MTG_DFT/MTG_LAM).
  - **per-layer 허용연산 배열:** `product_data` 키 12종 = 전 카테고리 동일(pdt_base/mtrl/size/dosu/prn_cnt/pcs/add_pcs/disable_pcs/add/option_info)·**레이어별 연산 게이팅 슬롯 부재**.
  - **라이브 ACTHBCO(양면 코롯토)·ACTHFCO(입체 코롯토):** HTTP 200·~354KB·select 2개(전역 km1_size Vue 스텁)·"레이어/Layer/stack/샌드위치" 키워드는 **CSS 클래스명·정적 마케팅·내비링크**("샌드위치 명함/엽서"=타카테고리 메뉴)뿐·`<select>/<option>/<input>/data-*` 레이어 옵션요소 **0건** = `[live:SSR-negative]`.
  - **판정 근거(ST #17 vs A-8 기준 일관 적용):** RP는 레이어를 **자재(MTRL_NM 라미 텍스트)·공정(PRT_WHT/BON_PAP 평면 PCS)·옵션(print_data 단일플래그)으로 분산**하며 "순서화된 적층 관리객체" 1급 슬롯이 **부재**. ST 형상#17은 전용 `option_info.shape_info` 슬롯이 실재해 기존 축이 못 담아 승격됐으나, layer-stack은 **A-8 가공방식처럼 기존 축이 왜곡 없이 담음**(자재 합성 + 공정 순서 + print_data) → **REFUTED-for-RP**(도메인 개념으로는 타당하나 RedPrinting 미운영·#18 distinct 승격 불요). codex의 "no live access" 자기admission대로 일반 아크릴 도메인 지식 추론이었음.
  - **라우팅:** metamodel-architect 재진입 **불요**(D-13 부결 기록까지만). 단 **vessel/gap 단계 참고용**으로 양면 화이트-blocker·샌드위치·렌티큘러 워크플로는 우리 unobserved 영역과 일치 — 후니 그릇 설계 시 "레이어 순서/역할" 컬럼을 신설 vs 분산유지 결정은 gap-analyst가 별도 판단(여기선 RP 미운영 사실만 확정).

#### H-2. 구멍/컷아웃/하드웨어 인터페이스 스펙 under-modeled
- **codex claim:** 부착물을 Addon+공정으로 매핑했으나 키링/뱃지는 geometry-level 인터페이스 관리 필요 — 구멍 개수·지름·가장자리로부터 위치·슬롯vs원형·구멍 주변 최소 bridge 폭·보강·링 방향·구멍유형별 허용 하드웨어. "SUB_MTR 링"은 *본체 아트워크/칼선이 그 링에 유효한지* 인코딩 못함(3mm 아크릴 키링 2mm bridge=깨짐). 단순 addon 선택 아닌 **하드웨어↔칼선 geometry 제약**.
- **분류:** (a) 신규 후보 — 우리 A-4(부착물=Addon#8+공정#2)는 부착물 *선택*만 다루고 hole-geometry 제약(reverse §2 "고리 지름 구멍 2.5mm·와이어링 3.5mm" note는 있으나 제약축 미정착)은 약함.
- **`unverified`.** 라우팅 → **gap-analyst (제약#5 hole-geometry cascade) + metamodel-architect (공정파라미터#9 hole-spec 슬롯)**.
- **검증방법:** RedPrinting 에디터 템플릿/업로드 가이드의 구멍 배치 규칙(최소 구멍 지름·가장자리 최소거리·링 호환성). reverse §2 ACTHDKY NOTICE "고리 지름 2.5mm" 실측분 확장. 후니: 제약#5(constraint logic)에 hole↔cutline match 표현력 유무.

#### H-3. 엣지 가공(edge finishing) = 누락된 관리 생산차원 — HIGH
- **codex claim:** 아크릴 칼선/컷팅을 generic 템플릿/공정으로 봤으나 아크릴 샵은 보통 관리: 레이저컷 엣지(투명/광택·프로스트·탄화/보호)·폴리싱 엣지·베벨/다이아컷 엣지·라운드 코너반경·내부 컷아웃·최소 오목반경·각인/컷팅 순서·보호필름 제거거동. **엣지 마감은 외관·노동·공차·가격에 영향·형상#17과 다름**(형상=외곽 무엇·엣지마감=노출 아크릴 엣지를 어떻게 생산). 공정#2 하위 edge-treatment, 또는 독립 재사용·독립 가격되면 별 축.
- **분류:** (a) 신규 후보 — 우리 분석에 엣지 가공 전무. AC reverse는 완칼(LAS_DFT/FRXXX 자유형 레이저)만 다룸·엣지 finish 차원 0건.
- **`unverified`.** 라우팅 → **reverse-engineer (RP AC 엣지 옵션 재확인) + metamodel-architect (공정#2 멤버 vs 독립 축)**.
- **검증방법:** 벤더 "레이저컷/폴리싱 엣지/베벨 엣지/라운드 코너/코너 R" 옵션 비교. **자재·형상과 독립 선택·독립 가격되면 모델 누락.** RedPrinting AC 20상품 옵션에 엣지 finish select 유무(라이브 로그인 캡처). ★주의: RedPrinting 레이저컷은 기본 투명 엣지일 수 있어 *옵션화 안 됐으면* future gap(현재 누락 아님) — TP 류 기각 가능.

#### H-4. 인쇄 레이어 레시피 too coarse (화이트 순서/역할)
- **codex claim:** D-7 인쇄방식레시피·공정 화이트는 있으나 아크릴 UV인쇄는 더 세밀한 레시피 필요 — CMYK only / 화이트언더+CMYK / CMYK+화이트오버 / 화이트+CMYK+화이트blocker / 앞이미지+뒷미러이미지 / spot화이트 / 바니시 / 부분화이트마스크 / 불투명도 다중패스. **투명기재 규칙이 "PRT_WHT yes/no"가 아님 — 화이트 잉크의 *순서와 역할*이 시각결과를 바꿈.** 양면 아크릴은 화이트=두 이미지 사이 blocker(언더베이스 아님).
- **분류:** (a) 신규 후보 — 우리 A-5는 화이트=공정#2(별색 family) 단일로 봤으나 codex는 *화이트 순서/역할 다형성*(under/over/blocker) 제기. 양면 blocker는 우리 분석 미커버.
- **`unverified`.** 라우팅 → **metamodel-architect (공정#2 화이트 멤버의 role/순서 파라미터#9) + gap-analyst (PROC_000008 화이트가 role 분기 담는가)**.
- **검증방법:** 업로드 템플릿이 별도 `칼선`/`화이트`/`앞면`/`뒷면`/마스크 레이어 요구하는지. 가격/옵션이 화이트언더vs화이트오버vs양면blocker 구분하는지(라이브). 후니: PROC_000008 화이트가 단일인지 role 차원(언더/오버/blocker) 보유인지.

#### H-5. 양면/적층 아크릴 정합 공차(registration tolerance) 누락
- **codex claim:** A-5가 앞뒤 같음/다름은 언급하나 *정합 공차*를 생산제약으로 식별 안 함. 양면/렌티큘러/샌드위치/명찰은 앞뒤 정렬 필요·오정합 공차는 카탈로그 옵션이 아닌 제조규칙·허용 아트워크/최소선폭/bleed/품질주장에 영향.
- **분류:** (a) 신규 후보 — 우리 분석에 정합 공차 전무.
- **`unverified`.** 라우팅 → **gap-analyst (제약#5 생산공차) — 단 data/품질규칙 영역일 수 있음**.
- **검증방법:** 생산 가이드의 앞뒤 정합 공차·bleed 마진·화이트 마스크 choke/spread·"X mm 내 오정합 발생가능" 문구. ★주의: 이는 *생산 품질규칙*(주문 시점 아트워크 검증)이라 base-data 관리축이 아닐 가능성 — TP H-1(STATE=주문런타임 out-of-scope)처럼 dbmap/MES 영역으로 기각 가능.

#### H-6. 렌티큘러 = surface variant 아님 (광학 이미지 변환 워크플로) — A-2 적대
- **codex claim:** 렌티큘러를 자재 surface finish로 본 것이 틀릴 수 있음. 렌티큘러 아크릴은 렌즈 pitch/LPI·시야방향·interlaced 이미지 준비·flip/animation/depth 모드·이미지↔렌즈 정렬·최소해상도·크기/방향 제한 포함. **광학 이미지 변환 워크플로우가 governing(자재 PTT만 아님)·특수 디자인입력+검증 요구.** RedPrinting 렌티큘러가 다중이미지 업로드/interlacing 규칙 있으면 모델이 *별 디자인/생산 레시피* 누락.
- **분류:** (a) 신규 후보 — 우리 A-2는 렌티큘러를 자재 surface-finish facet으로 분류(ACTHLKY/ACTHLCO·unobserved). codex는 디자인입력#16(VDP/다중이미지)+공정 워크플로 제기.
- **`unverified`.** 라우팅 → **metamodel-architect (렌티큘러=자재 surface-finish facet인가, 디자인입력채널#16의 다중이미지 모드+공정 워크플로인가 적대 재검)**.
- **검증방법:** 렌티큘러 상품(ACTHLKY/ACTHLCO) 업로드 스펙 로그인 캡처 — 다중이미지·방향·3D/flip 모드·특수템플릿 요구하면 단순 자재 finish로 못 담음. ★우리 #16(디자인입력채널)이 이미 VDP/다중이미지 모드를 담을 수 있어 *부분 흡수* 가능(렌티큘러 워크플로=#16 모드 + 자재 surface + 공정). 단 unobserved라 라이브 확인 필수.

#### H-7. (H-1 재진술 — Bottom Line) layer-stack이 최우선 놓친 축
- codex 결론: "가장 심각한 놓친 축 후보 = *순서화된 composite/layer-stack 구성*(generic 가공방식 그룹핑 아님). 명찰 합지·렌티큘러·양면·샌드위치·화이트blocker·다부품 아크릴을 사실들을 material/process/option/constraint에 흩뿌리는 것보다 잘 설명." → **H-1과 동일·중복 계상 안 함**(metamodel-architect 라우팅으로 통합).

### MED 후보

#### M-1. 코롯토/두꺼운 아크릴 = volume-form 축 요구 (A-3 적대)
- **codex claim:** A-3가 "본체가 평면 유지"라 3D/스탠드 distinct 거부한 것이 너무 좁을 수 있음. 코롯토는 *자립 volume 객체*로 관리(평면+두께 아님) — 블록 두께(8T+)·footprint 안정성·바닥 평면도·앞/뒤/후면 인쇄배치·엣지 가시성·relief/depth 효과·받침 통합vs분리. 두께-as-자재는 3T/5T 시트엔 OK이나 *volume/자립이 핵심 셀링속성*이면 strained. 평면 키링과 코롯토 블록은 자재 공유하나 body-form governance가 다름.
- **분류:** (a) 신규 후보(약) — 우리 A-3는 코롯토 두께블록=자재#1·입체조형=공정#2 분산 판정. codex는 volume-form governance(#14 형태가공 유사) 제기. (단 우리도 #14 본체형태가공 축 보유 — 부분 흡수 가능.)
- **`unverified`.** 라우팅 → **metamodel-architect (코롯토=자재#1 두께 facet인가, 본체형태가공#14인가, 신규 volume-form인가 적대 재검)**.
- **검증방법:** 코롯토(ACTHDCO/FCO) 상품이 바닥마진·자립안정성·허용실루엣·최소받침폭·인쇄깊이 별 규칙 있는지(라이브 로그인). 있으면 "두께 슬롯" 불충분. ★우리 #14(GS 봉제/지퍼 형태가공)가 이미 평면→입체 생성 lifecycle 담음 — 코롯토 자립이 #14 흡수면 신규 아님.

#### M-2. 혼합두께/다부품 어셈블리 = material-as-single-code 붕괴
- **codex claim:** 3T본체+5T받침·인쇄아크릴+별도투명커버·등신대 본체+받침+지지대·뱃지본체+자석시트+보호코팅·loose insert 샌드위치 charm 같은 다부품 제품에서 단일 `MTRL_CD`+WGT 슬롯이 한 SKU 내 다중 stock 자재를 못 표현(role-scoped 라인아이템 자재구성 없으면).
- **분류:** (a) 신규 후보 — 우리 분석은 받침=부속물#8로 분리(등신대)했으나 *혼합두께 단일제품*(3T본체+5T받침)·role-scoped 자재구성은 미커버.
- **`unverified`.** 라우팅 → **metamodel-architect (자재#1 합성 D-2가 role-scoped 다중자재 line-item 담는가) + gap-analyst (후니 t_mat usage_cd가 한 SKU 다중 자재 role 담는가)**.
- **검증방법:** 등신대/받침 제품이 본체자재·받침자재 별도 선택하는지(라이브). 후니: 한 prd_cd가 다중 mat_cd를 usage_cd role로 갖는 구조 실재 여부. ★우리 D-2(자재 합성·usage 슬롯)·PR usage_cd 역할전파가 부분 담음 — role-scoped면 흡수 가능.

#### M-3. 보호필름/peel state 누락
- **codex claim:** 아크릴은 보통 한면/양면 보호필름 사용 — 레이저커팅·인쇄접착·스크래치보호·고객 peel 지침·인쇄면 노출vs보호·취급결함에 영향. normal surface finish도 addon도 아닌 *생산/포장 상태*로 공정 순서·고객대면 마감을 바꿈.
- **분류:** (a) 신규 후보(약) — 우리 분석 미커버. 단 생산/포장 상태라 base-data 관리축 경계.
- **`unverified`.** 라우팅 → **gap-analyst (공정#2 포장/보호 멤버인가, data인가)**.
- **검증방법:** "아크릴 보호필름 동봉·사용 전 제거·필름면 자재별 상이" 가이드 문구. ★주의: 포장/취급 상태라 관리축 아닐 가능성 높음(공정#2 포장 멤버 또는 note) — 약한 후보.

#### M-4. 접착/마운팅 백킹 = Addon 이상
- **codex claim:** 명찰/마그넷/뱃지/사이니지가 3M폼테이프·투명접착·자석시트·핀클래스프·안전핀·suction cup·받침·벽스페이서·나사구멍 사용. 일부는 물리 sub-material이나 표면호환·하중·배치·사용맥락 제약 부과 — "Addon"만으론 install-context 의미 소실.
- **분류:** (b) 대부분 이미 다룸 — 우리 A-4(부착물=Addon#8+공정#2 부착)가 옷핀/마그넷/받침 커버. codex가 더한 것=install-context 제약(하중/표면호환)·우리 약함.
- **`unverified`.** 라우팅 → **gap-analyst (부착물↔본체 제약#5 표현력) — 단 대부분 A-4 흡수**.
- **검증방법:** 벤더 "접착백킹/자석백킹/핀유형/벽마운트" 옵션의 크기/무게 제약. 후니 A-4 §XVII-2(단일 부자재 마스터 부재·D링 3버킷 중복)와 합류.

#### M-5. 아크릴 stock 관리 누락
- **codex claim:** 도메인 스키마는 시트레벨 현실 알아야 — stock 시트 크기·마진후 가용영역·nesting 효율·offcut/waste factor·두께별 stock 색 가용성·cast vs extruded 아크릴·두께별 공차·배치 가용성. e-commerce 옵션 메타모델은 숨기지만 생산 가격/가능성이 시트 stock에 종속.
- **분류:** (c) 대부분 부적용(범위 외) — 우리 하네스는 *옵션 관리 메타모델*이지 생산 stock/nesting 아님. 단 가격(#11) nesting/waste factor는 가격 트랙 입력 후보.
- **`unverified`.** 라우팅 → **gap-analyst (가격#11 입력 — waste/nesting) — 단 대부분 dbmap 가격 트랙/생산 MES 범위**.
- **검증방법:** 면적범위+두께 가격표가 nesting 함의하는지. ★주의: cast/extruded·stock 시트는 생산/MES 영역 — 메타모델 관리축 아님(범위 외).

#### M-6. 3엔진 너머 가격 입력 누락
- **codex claim:** `vTmpl/acrylic2025/tmpl` 라우팅 너머 더 많은 구조 필요 — 최소주문/최소청구·디자인당 setup비·컷팅 경로길이 surcharge·구멍수 surcharge·내부컷 surcharge·면적매트릭스 size band·시트 nesting/yield factor·자재/표면별 waste rate·두께 multiplier·표면variant multiplier·면적별 화이트잉크 surcharge·양면인쇄 multiplier·하드웨어 단가·조립노동·취약/두꺼운품 포장 surcharge·rush/생산형태 surcharge. "pricing-role 라우팅"은 어느 엔진 실행만 말하지 모든 price driver 보장 안 함.
- **분류:** (a) 신규 후보(가격 트랙) — 우리 A-6(acrylic2025 pricing_model 라우팅·표현력까지만)는 *어느 엔진*만 다룸. codex의 price driver 목록(컷팅 경로길이·구멍수·화이트면적·multiplier)은 dbmap Q-ACR-7과 합류.
- **`unverified`.** 라우팅 → **gap-analyst (가격#11 driver 완전성) → dbmap 31_acrylic 가격 트랙(Q-ACR-7 .02 엔진계산)**.
- **검증방법:** 같은 면적·다른 윤곽복잡도/구멍수/화이트/양면/부착물수 견적 비교 — 독립 변하면 누락 차원. ★가격 *값/엔진계산*은 dbmap 범위(우리는 #11 표현력=frm_typ_cd 그릇까지만). gap-matrix §XVII-3가 이미 Q-ACR-7로 라우팅.

#### M-7. 아트워크 검증 규칙 under-specified
- **codex claim:** 아크릴은 카테고리/템플릿 너머 기술제약 필요 — 칼선밖 bleed·칼선안 safe margin·최소텍스트/선폭·최소 isolated feature·최소 bridge폭·레이저반경 이하 sharp 내부코너 금지·화이트마스크 choke/spread·미러 뒷면 아트워크·투명영역 미리보기 규칙·투명/홀로/미러 기재 색변화. 모델은 제약 있으나 분석이 옵션 게이팅에 집중·geometric/artwork 검증제약 아님.
- **분류:** (a) 신규 후보(약) — 우리 제약#5는 disable/force/match 등 *옵션 게이팅*. codex의 geometric/artwork 검증(최소선폭·bridge·choke/spread)은 미커버.
- **`unverified`.** 라우팅 → **gap-analyst (제약#5가 geometric 검증제약 담는가, 별 검증 레이어인가)**.
- **검증방법:** 업로드 가이드·에디터 경고의 최소선폭·칼선명명·화이트레이어 명명 요구. ★주의: 아트워크 검증규칙은 주문시점 검증(에디터 런타임)이라 base-data 관리축 경계 — TP H-1 류로 일부 out-of-scope 가능.

### LOW-MED / LOW 후보

#### L-1. 광학효과 자재가 generic finish와 별개일 수 있음 (A-2 부분 적대)
- **codex claim:** 홀로/글리터/미러/펄/유색/파스텔/렌티큘러를 surface-finish facet으로 묶음. 이들이 허용 잉크불투명도·색왜곡·화이트잉크요구·불가 인쇄면·시야각거동·특수미리보기/렌더·별 stock조달을 governing하면 under-modeled. "finish"가 너무 약함.
- **분류:** (b) 대부분 이미 다룸 — 우리 A-2(surface-finish 합성 차원)·거울 별공식=#11 라우팅. codex가 더한 것=광학기재가 *디자인 의미/proofing 거동* 바꾸면 promote. 렌티큘러는 H-6으로 별도.
- **`unverified`.** 라우팅 → **metamodel-architect (A-2 surface-finish facet 재확인 — 광학기재가 디자인의미 바꾸면 optical-substrate behavior class 승급?)**.
- **검증방법:** 각 surface variant가 다른 아트워크 가이드·인쇄레이어 가용성 있으면 promote. ★렌티큘러 외엔 LOW(우리 A-2 surface-finish+#11 가격 라우팅으로 흡수 예상).

#### L-2. 레이저 각인 vs UV 인쇄 누락/모호
- **codex claim:** 일부 아크릴 샵은 각인 제공(표면각인·역각인·filled각인·raster vs vector·화이트잉크없는 각인외관). 각인은 단순 인쇄방식 아님 — 자재 제거/변형·다른 아트워크/가격 driver.
- **분류:** (a) 신규 후보(약) — 우리 분석에 각인 전무.
- **`unverified`.** 라우팅 → **reverse-engineer (RP AC에 각인 옵션 있는지 확인)**.
- **검증방법:** RedPrinting 아크릴 카테고리에 각인/명패/사이니지 옵션 유무. ★없으면 future gap(현재 누락 아님) — RedPrinting AC가 인쇄+컷 중심이면 부적용.

#### L-3. LED/라이트베이스 등신대 지원
- **codex claim:** 등신대/디스플레이 아크릴은 LED베이스/라이트박스 포함 가능 — 전기부품·전원옵션·베이스크기·투광 제약·포장제약. Addon이 물리베이스는 담아도 전기/스펙 메타데이터는 못 담음.
- **분류:** (c) 부적용 가능성 높음 — RedPrinting AC 등신대(ACPDSTD)는 평면+받침(비전기)으로 관측. LED는 관측 범위 외.
- **`unverified`.** 라우팅 → **discard 후보(RP AC에 LED 상품 없으면)·reverse-engineer 확인만**.
- **검증방법:** RedPrinting/유사 AC에 LED 아크릴 디스플레이 판매 유무. 없으면 관측범위 외(LOW).

---

## 라우팅 요약 (owning agent별)

| 후보 | 라우팅 | 우선 | 핵심 검증 |
|------|--------|:---:|-----------|
| **H-1/H-7 layer-stack #18** | metamodel-architect (distinct vs facet 적대 — D-13 후보) | HIGH | 양면/샌드위치/렌티큘러 옵션이 스택레시피에 가격/아트워크 종속하는가 (라이브) |
| **H-6 렌티큘러 워크플로** | metamodel-architect (A-2 facet vs #16 다중이미지 모드 적대) | HIGH | 렌티큘러 업로드=다중이미지/방향/flip 모드 요구하는가 (로그인 캡처) |
| **H-3 엣지 가공** | reverse-engineer + metamodel-architect (공정#2 vs 독립 축) | HIGH | RP AC에 폴리싱/베벨/코너R 엣지 옵션·독립가격 유무 |
| **H-2 hole-geometry** | gap-analyst (제약#5) + metamodel-architect (파라미터#9 hole-spec) | HIGH | 에디터 구멍배치 규칙(최소지름·가장자리거리·링호환) |
| **H-4 화이트 순서/역할** | metamodel-architect (공정#2 화이트 role 파라미터) + gap-analyst | HIGH | 업로드가 화이트under/over/양면blocker 구분하는가 |
| **H-5 정합 공차** | gap-analyst (제약#5·단 주문런타임 경계) | MED | 앞뒤 정합공차·화이트 choke/spread 가이드 문구 |
| **M-1 코롯토 volume-form** | metamodel-architect (자재 두께 vs #14 vs 신규) | MED | 코롯토 바닥마진·자립안정성 별 규칙 유무 |
| **M-2 다부품/혼합두께** | metamodel-architect (D-2 role-scoped) + gap-analyst | MED | 한 SKU 다중자재 role 선택 유무 |
| **M-6 가격 driver** | gap-analyst (#11 완전성) → dbmap Q-ACR-7 | MED | 컷팅길이/구멍수/화이트면적 독립가격 (가격표) |
| **M-7 아트워크 검증** | gap-analyst (제약#5 geometric·단 런타임 경계) | MED | 최소선폭·bridge·choke/spread 업로드 가이드 |
| M-3 보호필름 / M-4 백킹 install-context / M-5 stock / L-1 광학 / L-2 각인 / L-3 LED | gap-analyst / reverse-engineer 확인·대부분 discard 후보 | LOW | 범위 외(생산/MES) 또는 RP AC 미관측 — 라이브 확인 후 대부분 기각 예상 |

## validator 핸드오프 (M-gate 확인용)
- **채택 0** — 위 후보 전부 `unverified`. metamodel-architect/gap-analyst가 라이브/엑셀/캡처로 검증하기 전 어떤 후보도 메타모델/갭에 반영 안 됨.
- **재포화(distinct 0·17축) 적대 압박점:** codex가 **H-1 layer-stack을 #18 강후보로 강하게 밀었음**(가공방식 그룹핑 A-8보다 강함). validator는 metamodel-architect가 H-1을 *적대적으로* 재검했는지(기존 공정#2 순서+자재#1+옵션#3 무손실 표현 여부) 확인. **예상: TP H-6/H-1처럼 기각 가능성 — codex는 라이브 RP 캡처 없이 일반 아크릴 도메인 추론(self-admitted no live access)·layer-stack이 generic 아크릴 샵엔 맞으나 RedPrinting AC가 실제로 스택을 1급 슬롯으로 운영하는지 미관측.** 단 H-2/H-3/H-4/H-6은 unobserved 영역과 정확히 겹쳐 *실측 가능한 갭 후보*로 가치 — 로그인 에디터 캡처가 검증 권위.
- **codex 환각 경계 준수:** codex 어떤 항목도 "라이브 확인했다" 주장 안 함(self-admission "do not claim live access"). 전부 도메인 지식 추론. checkable 후보(H-2~H-6·hole/edge/white/lenticular)는 RedPrinting 로그인 캡처·업로드 가이드·가격표로 검증 가능, 불가검증(M-5 stock·L-3 LED)은 범위 외/미관측으로 기각.

## 정직 기록
- codex 호출 성공(EXIT 0·gpt-5.5·13.7KB). 데드락/오류 없음.
- codex 출력은 풍부하나 *일반 아크릴-제조 도메인 지식* 기반(라이브 RedPrinting 미접속) — RedPrinting AC가 실제 운영하는 것 vs 일반 아크릴 샵이 운영하는 것의 갭은 **로그인 캡처/가격표 검증 전 미확정**. 따라서 HIGH 후보도 "검증 가능한 가설"이지 "확인된 누락"이 아님.
- 가장 큰 가치 = codex가 우리 unobserved 영역(소재특화 키링·코롯토 입체·acrylic2025 산정·렌티큘러)을 *industry-standard 렌즈*로 구체적 checkable 항목(hole-geometry·edge-finish·white-layer-order·layer-stack·lenticular-workflow)으로 재명세 → reverse-engineer 로그인 캡처 시 표적 제공.
