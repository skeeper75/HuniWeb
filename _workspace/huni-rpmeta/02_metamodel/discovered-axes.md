# 발굴 축 (discovered-axes) — 7버킷 외 관리 메타모델

> rpm-metamodel-architect. 사용자 directive(HARD): **알려진 7버킷(자재/공정/옵션/템플릿/제약/기초코드/카테고리) 외에 더 많은 관리 축이 있는지 심도 발굴.**
> 입력 = BN(현수막류) 6상품 역공학(`01_reverse/`) + 인쇄 도메인 KB(`07_domain/`).
> 판정 기준(SKILL §3 distinctness test): **고유 속성/lifecycle/관계가 있어 기존 축이 왜곡 없이 못 담으면 distinct, 아니면 facet.**
> ⚠️ BN 단일 카테고리 추출 — 오버피팅 경계(SKILL §5): "한 상품만 필요한 축" 거부. distinct 판정은 *횡단 패턴 + 후니 도메인 동형*으로만.

---

## 발굴 결과 한눈에

7버킷은 "정적 객체 버킷"(무엇을 등록하나)에 치우쳐 있다. RedPrinting 역공학이 드러낸 추가 관리 축은 대부분 **관계·동역학 축**(객체들이 *어떻게 결합·게이팅·매개변수화되나*)이다.

| ID | 발굴 축 | distinct/facet | 한 줄 정체 | 7버킷 중 가장 가까운 것 | 왜 그것으로 안 되나 |
|---|---|:---:|---|---|---|
| **D-1** | 부속물(Addon) | **distinct** | 본체와 분리된 완제 부속 부품(거치대) | 템플릿/SKU·옵션 | 템플릿=묶음단위, 옵션=본체속성. 부속물은 독립 SKU·재고·본체 비귀속 |
| **D-2** | 자재 합성 & usage & 공정결합 | **distinct(메타규칙)** | MTRL_CD 다축 합성 + usage 슬롯 + 공정의 자재소비 | 자재 | 단순 자재 enum이 아니라 *합성 규칙*과 *공정↔자재 FK*가 본질 |
| **D-3** | 제약 논리유형(Constraint Logic) | **distinct** | disable/force/require/match/exclude/essential의 *유형화된 어휘* | 제약 | 7버킷 "제약"은 객체일 뿐, *논리 유형 거버넌스*가 누락 |
| **D-4** | 공정 파라미터(Process Parameter) | **distinct** | 공정 멤버에 종속된 매개변수 슬롯(줄수·mm·색·수량) | 옵션·공정 | 옵션=독립선택, 공정=멤버. 파라미터=부모공정 종속 자식 |
| **D-5** | 수량 모델(Quantity Model) | **distinct** | 건수×수량 다중 수량 슬롯 + 공정종속 수량 | 옵션(수량) | 단일 qty 스칼라로 평면화 시 가격 의미 소실 |
| **D-6** | 가격기여 역할(Pricing Role) | **distinct(횡단 메타)** | 각 선택이 가격에 *어떻게* 기여하는가(면적/곱수/고정/단가) | (7버킷 없음) | 7버킷 어디에도 "가격기여 방식" 축 부재 — RP는 price_flag로 전 축에 부착 |
| **D-7** | 인쇄방식/생산 레시피 | **distinct(조건부)** | 인쇄방식이 가능 공정·파일·팀을 게이팅 | 공정·기초코드 | RP는 자재 facet으로, 후니는 1급 레시피 축으로 — 게이팅 lifecycle 보유 |
| **D-8** | UI 런타임/표현 바인딩 | **facet(거부)** | Vue vs jQuery 두 런타임 | (없음) | 동일 base-data 모델 공유 → 관리 축 아님(표현 계층) |
| **D-9** | 생산형태(Production Type) | **distinct (GS v2.0)** | 완제품/반제품/통합/기성/디자인이 본체 모델링을 governing | 카테고리·템플릿 | 카테고리=기능 트리(직교), 템플릿=번들. 생산형태는 그 둘을 *governing*(본체=SKU vs 자재행 결정) |
| **D-10** | 본체 형태가공(Body Form-Assembly) | **distinct (GS v2.0)** | 평면→입체 본체를 *생성*하는 조립/봉제/지퍼 | 공정 | 일반 후가공=본체에 작업, 형태가공=본체 *생성*(없으면 본체 부재). lifecycle 구별 |
| **D-11** | 디자인 입력 채널(Design-Input Channel) | **distinct (TP v3.0)** | 디자인을 *어떻게 입력받나*(KOI/Edicus/PDF) — 본체 옵션 트리와 직교, 가격 0 | 템플릿/SKU·옵션·공정 | 옵션=본체속성·공정=본체작업·템플릿=완제번들. 입력채널은 본체와 무관·동종 비-TP와 옵션/가격 동일·`item_gbn` 게이팅 lifecycle 보유 |
| **D-12** | 형상(Shape) | **distinct (ST v5.0) ★16축 포화 붕괴** | 인쇄물 외곽 형상(SQ/CL/EL/RC/FR)이 *사이즈와 분리된 전용 enum 슬롯*으로 칼틀/사이즈 선택을 게이팅 | 사이즈#13·기초코드#6 | 사이즈#13은 형상을 *1:1 칼틀=사이즈 프리셋*으로만 흡수(어깨띠·GS THO_CUT·TP M/I). ST는 형상↔사이즈 **1:多**(한 형상 CL이 CL001~CL100 칼틀 enum span)·전용 `shape_info` 슬롯·5형상 superset(STDCFBR)·후니 KB가 size축 미수용(G-SK-2) 확증 |

**발굴 distinct 축 = 11개**(D-1~D-7 BN + D-9·D-10 GS + D-11 TP + **D-12 ST**), facet 강등 = D-8 + GS facet 4종(G-1/G-2/G-4/G-3) + TP facet 5종(T-A 템플릿자산·T-B VDP·T-C 페이지계층·T-D 형태variant·T-E 특수인쇄) + **PR facet 9종(P-1~P-9 전부·distinct 0)** + **ST facet 9종(S-2 칼선·S-3 재단입자·S-4 점착·S-5 인쇄방식·S-6 가격엔진·S-7 화이트강제·S-8 disable·S-9 넘버링·S-10 완제SKU)** + **CL facet 9종(C-1~C-9 전부·distinct 0·★의류 variant #18 부결)** + **AC facet 9종(A-1~A-9 전부·distinct 0·★가공방식 그룹핑 A-8 #18 부결)** + **PD facet 5종(PD-1~PD-5 전부·distinct 0·★완제 구조물 내재BOM PD-4 #18 부결)** + **PH facet 6종(PH-1~PH-6 전부·distinct 0·★완제 액자 그릇/마운팅 PH-1·PH-2 #18 부결)** + **FS facet 9종(FS-1~FS-8 + ★codex 패널 구성 FS-A1 전부·distinct 0·★타일링 TILL_WH_GBN #18 부결 + ★cut-and-sew 패널 구성 FS-A1 #18 부결[codex 강도전·Phase 4.5])** + **NC facet 5종(N-1~N-5 전부·distinct 0·★인쇄방식(옵셋 vs 디지털) #18 부결·이산 부수 tier=data-gap)** + **OT facet 4종(O-1~O-4 전부·distinct 0·★전개도/dieline #18 부결·3D 제품치수=파생·재단/작업 2치수=size#13+plate_size data-gap·dieline 템플릿=#16)**. 7버킷 + 발굴 = **총 18 관리 축**(단 D-2는 자재 버킷 심화, D-6/D-7은 횡단). 메타모델 사전(`metamodel-dictionary.md`)은 **7 정적 축 + 4 관계/동역학 축 + 2 횡단 축 + GS 신축 2(#14·#15) + TP 신축 1(#16) + ST 신축 1(#17 형상) = 17 dictionaried 축**으로 정리(D-8 제외). **11 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS·NC) 증거로 검증 — PR distinct 0(4군 포화)→ST distinct 1(형상·5군 포화 붕괴)→CL distinct 0(6군 재포화)→AC distinct 0(7군 재포화·신규 강후보 A-8 무손실 흡수)→PD distinct 0(8군 재포화·봉제 구조물 완제품·PD-4 완제 내재BOM 부결)→PH distinct 0(9군 재포화·완제 액자/출력매체·PH-1/PH-2 완제 그릇/마운팅 부결·★§0.5 거치 OBSERVED 블로커 해소 후에도 옵션 캐스케이드 구현)→FS distinct 0(10군 재포화·직물 풀프린팅+봉제 완제 굿즈·유일 신규 후보 타일링 TILL_WH_GBN 무손실 흡수=공정#2 인쇄 배치 파라미터)→NC distinct 0(11군 재포화·옵셋 명함/카드·★최강 #18 후보 인쇄방식(옵셋 vs 디지털)이 이미 #12 D-7로 흡수·별도 가격엔진 offset2023_price=#11 라우팅·이산 부수 tier=수량#10/제약#5/가격#11 분산 data-gap)→OT distinct 0(12군 재포화·상자/패키징·★평면 인쇄물에 없던 입체/전개 차원을 가진 첫 상품군의 #18 후보 전개도/dieline이 사이즈#13(작업치수)+공정#2(도무송 칼틀·오시 접지)+카테고리#7(상품 분기)로 무손실 분배 흡수·3D 제품치수=size 파생 표시값·재단/작업 2치수=size#13+plate_size 2축 data-gap·dieline 에디터 템플릿=#16 TemplateAsset)=모델은 카테고리 증거에 정직.**

> **★v10.0 (FS 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL·AC·PD·PH 패턴 반복·★타일링 TILL_WH_GBN #18 부결):** FS(패브릭·봉제 완제 직물 굿즈 = 면직물에 풀프린팅 후 재단/봉제/마감하는 직물 굿즈·코스터/포스터(현수막형)/쿠션/파우치/에코백/테이블보/스카프/스크런치) 역공학의 8 fragment(FS-1~FS-8) 적대 판정 — **distinct 승급 0종·전부 facet.** FS reverse가 1차 예측한 "distinct 0~1(타일링 유일 후보)"를 적대 판정으로 비준 — 가장 이질적인 *직물 풀프린팅+봉제 완제 굿즈*조차 17축 무손실 흡수. ★directive 1순위 적대 판정(타일링이 distinct #18인가) = **(FS-1 타일링 TILL_WH_GBN)=공정#2 인쇄 배치(조판/imposition) 파라미터(#9 종속)** — 직물 풀프린팅의 "디자인 패턴 세로/가로 반복(tiling/repeat) 배치"가 BN/GS/TP/PR/ST/CL/AC/PD/PH 전 9 카테고리 어디에도 없던 *전용 라디오 슬롯*(유일 #18 후보)이나, 후니 KB `plate_size`(#6·`entity-semantic-model.md:27` "임포지션·판걸이·돔보"·`pdf-domain-knowledge.md:146` 조판)가 인쇄 배치를 *이미 1급 모델링*해 타일링=그 배치 차원의 고객 선택값(공정 배치 파라미터·접지 FLD_DFT 면분할·오시 줄수 동형)으로 *왜곡 없이 담김*. ★PH-1/PH-2(거치)·ST 형상(#17)과 같은 HARD 양방향 기준 = **① 전용 슬롯 라이브 실재(TILL_WH_GBN OBSERVED=충족) + ② 후니 KB 무왜곡 흡수 불가(결함)** → **②불충족**(plate_size/공정 파라미터가 담음·ST 형상 G-SK-2 "어느 축에도 없음" 같은 KB 결함 명시 없음) → distinct 0. **★핵심 경계(HARD): 타일링≠판걸이수** — 타일링=*고객측 디자인 반복 배치 입력 파라미터*(공정#9 등재), 판걸이수=*앱 계산 파생값*(DB 미저장·등재 금지·`dbmap-compute-in-app-db-stores-lookup`). 임포지션=N개 *다른* 작업물을 원판에(다도안 판걸이), 타일링=한 디자인 *반복* 배치(직물 면 채움). 나머지 FS fragment 전부 facet: **(FS-2 방향 PAPER_WH)=사이즈#13 방향 facet** · **(FS-3 면사 수)=자재#1 PTT/WGT 다의**(CL oz·AC mm·PD 번수 동형) · **(FS-4 별색 SID_FBR 6색×3농도)=공정#2 별색 family**(CL Pantone 1124 축소판) · **(FS-5 마감봉제/제품가공)=공정#2 봉제 family/형태가공#14**(PD SEW_LTR·GS PDT_WRK 동형) · **(FS-6 솜/끈/자석)=자재#1 sub_mtrl+부속물#8 선택형**(PD-4 고정 ESN=Y와 노출 차원만 분기) · **(FS-7 가격모델)=가격#11 라우팅**(real_calc_price) · **(FS-8 PCS 상세)=infoCall unobserved**. RP가 타일링을 공정 배치 라디오로 둠 = *data-gap(후니가 직물 타일링 취급 시 공정#2 인쇄 배치 파라미터에 적재)이지 vessel-gap(축 부재) 아님*(PD-4 data-gap·갭분석가). **10번째 카테고리(직물 풀프린팅+봉제 완제 굿즈)가 distinct 0 = 모델 재포화 재확인** — directive 1순위 관전(타일링 반복 배치) 무손실 흡수.
>
> **★Phase 4.5 환류 — codex(gpt-5.5) 패널 구성(cut-and-sew panel semantics) FS-A1 적대 재검증 = #18 부결(타일링보다 강한 도전이라 codex 자평했으나 동일 결론):** FS deepcheck 살아남은 후보로 codex가 타일링보다 강한 distinct #18 도전으로 **A-1 패널 구성**(front/back/side/gusset/handle/label 면별 독립 디자인·원단·공정 = 봉제완제 굿즈가 면별 독립 아트워크/소재/공정을 가진다)을 제기. 승격 양방향 기준 적대 판정: **① 전용 슬롯 라이브 OBSERVED = UNOBSERVED(부결).** FS reverse 실측(2026-06-19 `[live:SSR]` 5상품 전수·legacySelects 44~61)에 **면별(panel) 독립 디자인 입력 슬롯 부재** — FS 정체=면직물 *풀프린팅(단일면 래핑)* 후 재단/봉제(reverse §0·§7)·디자인 입력은 단일 풀프린팅 업로드·쿠션 양면(`sodu`=SID_D)도 면별 디자인 슬롯 아닌 단일 **도수(#6) 토글**·front_design/back_design/panel_info 0건. codex 인용(Contrado fabrics/tote·FTC)=*codex 산업추론·본 하네스 미검증*이며 RP FS 라이브엔 패널별 독립 디자인 UI *실재하지 않음*(라이브 읽기전용 재확인·panel 슬롯 부재 확정). PH H-1·PD-4 unobserved-pending 패턴과 동일 → ①불충족. **② 후니 KB 무왜곡 흡수 불가 = 흡수 가능(부결 보강):** RP FS가 실제 쓰는 만큼은 전부 기존 축 무왜곡 흡수 — 면별 디자인(노출된다면)=디자인입력채널#16 다중면 facet(CL 인쇄위치 C-4 print_area 6위치 멀티슬롯=한 본체 여러 영역 독립 디자인의 검증된 선례)·안감/심지=자재#1 sub_mtrl usage(겉감/안감 2 usage 인스턴스·PR P-2 역할 전파 동형)·포켓/거싯/손잡이=공정#2 봉제 family/형태가공#14(FS-5·PD SEW_LTR 동형)+부속물#8(끈/자석/라벨 reverse §0.8 실측). 후니 KB에 "패널 구성 어느 축에도 없음" 결함 명시 **없음**(ST 형상 G-SK-2와 정반대) → ②불충족. **★ST 형상(#17)과 결정적 차이:** 형상=①OBSERVED+②KB결함 둘 다 충족(승격), 패널=①UNOBSERVED+②결함없음 둘 다 불충족(PH-2 거치보다 더 약함=①조차 미관측·부결). **★PD/PH 봉제·완제 부결과 일관:** cut-and-sew=PD가 이미 적대 검증한 봉제 구조물 완제품 패턴의 직물판(PD-1 SEW_LTR=형태가공#14·FS-5 SEW_FBR 흡수)·면별 독립 아트워크는 PD에도 FS에도 없음. codex의 panel semantics=산업적으로 그럴듯하나 RP FS 모집단(면직물 풀프린팅 굿즈)에 실재하지 않는 모집단 오추정. **★타일링 #18 부결 불변 확인** — FS-A1은 타일링(FS-1)과 별개의 codex 신규 도전이나 동일하게 #18 부결, 타일링 공정#2 인쇄 배치 파라미터#9 흡수 판정 무변동. **FS 최종 distinct = 0(타일링·패널 둘 다 부결)** — 후속 면별 디자인 슬롯이 *실재 관측*되면 디자인입력채널#16 다중면 facet 적재(data-gap)이지 신축 아님(validator/Phase 6.5 재확인 대상).

> **★v9.0 (PH 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL·AC·PD 패턴 반복·★완제 액자 그릇/마운팅 PH-1·PH-2 #18 부결):** PH(포토보드·액자·사진인화·포토북·포토굿즈 = 사진을 어떤 물성으로 출력하느냐로 묶인 출력매체 카테고리·5개 이질 상품군 공존) 역공학의 6 fragment(PH-1~PH-6) 적대 판정 — **distinct 승급 0종·전부 facet.** PH reverse가 1차 예측한 "distinct 0(facet)·미확정(SSR-negative 블로커)"를 **§0.5 client-render 재캡처(gstack browse 2026-06-17)가 블로커 해소 + 적대 판정으로 비준** — 가장 distinct로 *보이던* 완제 액자(인쇄물 + 별도 프레임 2-파트 조립)조차 17축 무손실 흡수. ★directive 최대 관전(완제 프레임·마운팅/거치·전면 보호재=distinct #18인가) 적대 판정: **(PH-1 완제 프레임)=완제SKU#4(거치+마감+사이즈 인코딩)+자재#1 프레임재질 variant+생산형태#15**(AC 두께/소재 variant·GS 완제 본체 SKU G-1 동형·프레임재질 pdtCode 분기=GS 코스터 G-2 동류) · **(PH-2 거치 RESOLVED OBSERVED)=옵션#3 캐스케이드 상위 차원**(§0.5 탁상용/벽걸이 버튼 토글·거치→마감→완제SKU사이즈→수량·전면재=자재#1 디아섹 내재·후면받침=부속물#8 미관측) · **(PH-3 인화지×마감)=자재#1 surface-finish**(§0.5 "인화용지(반광-러스터)/유광" 합성·ST S-4/AC A-2 동형) · **(PH-4 set 단위)=수량#10 set 배수+완제SKU#4 base_quant**(GS 텀블러 동형) · **(PH-5 머그·화분)=카테고리#7 다중분류**(GS 코드접두≠본질 동형) · **(PH-6 형태 일반/정사각/파노라마)=사이즈#13 비율 프리셋 흡수·형상#17 부결**(§0.5 OBSERVED·1:1·ST 1:多 미충족·PD-3 동형). ★PH-1/PH-2가 ST 형상(#17)과 정반대로 부결된 결정적 근거(HARD 기준 양방향) = **형상은 ① 전용 슬롯(shape_info) 실재 + ② 후니 KB G-SK-2 "어느 축에도 없음" 결함 둘 다 충족(승격), PH 완제 그릇/마운팅은 ① 거치 전용 슬롯 OBSERVED(§0.5 미싱데이터 해소)되었으나 ② 후니 KB 결함 명시 없음**(완제SKU#4·옵션#3·자재#1·사이즈#13이 왜곡 없이 담음) → ②가 불충족 → distinct 0. **★§0.5 재캡처가 블로커를 OBSERVED로 해소했음에도 거치가 옵션 캐스케이드 + 완제 SKU variant로 구현됨이 실측 → facet 결론이 미싱데이터 해소 후에도 강화**(추정이 아닌 관측 기반 부결). RP가 완제 프레임/거치를 완제 SKU combobox + 옵션 캐스케이드로 둠 = *data-gap(완제 SKU/거치 캐스케이드 그릇 미적재)이지 vessel-gap(축 부재) 아님*(PD-4 data-gap·AC A-3 PASS 동형·갭분석가). **9번째 카테고리(완제 액자/출력매체)가 distinct 0 = 모델 재포화 재확인** — directive 최대 관전(완제 그릇/마운팅/거치) 무손실 흡수.

> **★v8.0 (PD 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL·AC 패턴 반복·★완제 구조물 내재BOM PD-4 #18 부결):** PD(스툴·슬리퍼·강아지계단 = 봉제 구조물/3D 조립 완제품) 역공학의 5 fragment(PD-1~PD-5) 적대 판정 — **distinct 승급 0종·전부 facet.** PD reverse가 1차 예측한 "distinct 0(8번째 재포화)"를 비준 — 가장 이질적인 *봉제 구조물 완제품*조차 17축 무손실 흡수. ★directive 최대 관전(조립·구조·3D폼·완제 내재BOM이 distinct #18인가) 적대 판정: **(PD-1 봉제/제품가공=본체 형태가공#14[GS D-10] 봉제 family 신규 멤버**·SEW_LTR=새 멤버·PDWRSLP PDT_WRK=GS 동일 코드·기존 PCS 슬롯 인코딩) · **(PD-2 직물/PU 원단=자재#1 PTT 차원**·AC 아크릴·CL 의류원단 동형·비종이 자재 이미 관측) · **(PD-3 단수/형상=사이즈#13 프리셋 흡수**·계단 2단=495×320 1:1·스툴 원형↔305×305 1개=ST 형상 1:多 미충족=구조 distinct 부결 결정적 증거) · **(★PD-4 완제 구조물 내재BOM[다리/받침/솜/지퍼/논슬립]=부속물#8+생산형태#15+가격#11 분산 facet·#18 부결**) · **(PD-5 모양커팅/추가부자재 enum=공정#2/부속물#8·infoCall unobserved·축 판정 무영향).** ★PD-4가 ST 형상(#17)과 정반대로 부결된 결정적 근거 = **형상은 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함이 distinct 강제, 완제 내재BOM은 후니 KB가 부속물(addl_product #9)·자재 usage·생산방식 A/B/C를 이미 1급 모델링(결함 없음·왜곡 없이 담음).** PD가 던진 진짜 질문(완제품 내재BOM을 옵션과 분리해 어디 두는가)의 답 = **부속물#8(다리/받침/논슬립=고정 ESN=Y 완제 부속·AC 등신대 받침 동형)+자재#1 usage(솜/지퍼)+생산형태#15(C 완제품 governing)+가격#11(tmpl)**. RP가 내재BOM을 마케팅 카피로만 둠 = *data-gap(부속물/생산BOM 그릇 미적재)이지 vessel-gap(축 부재) 아님*. **8번째 카테고리(봉제 구조물 완제품)가 distinct 0 = 모델 재포화 재확인** — directive 최대 관전(조립/구조/3D폼) 무손실 흡수.
>
> **★v7.0 (AC 통합) 핵심 판정 — 17축 재포화(distinct 0·PR·CL 패턴 반복·신규 강후보 A-8 부결):** AC(아크릴·키링·코롯토·명찰·등신대) 역공학의 9 fragment(A-1~A-9) 적대 판정 — **distinct 승급 0종(★가공방식 그룹핑 A-8 #18 부결)·전부 facet.** AC reverse가 "가공방식 그룹핑 슬롯(GRP_OPTION_CD/production_method)=distinct #18 강후보"를 강하게 제기(자재행을 가공방식 그룹으로 묶는 전용 슬롯·라미=두께/표면 능동 변환)했으나 **세 기존 축으로 무손실 분해** — ① 라미네이션=공정#2(합지 family) ② 라미 결과(라미된 자재행)=자재#1 합성(D-2·두께/표면) ③ GRP_OPTION_CD 그룹핑=옵션#3 polymorphic cascade(production_method→자재 subset 게이팅·G-4 채널 동형). **★ST 형상(#17)과 정반대 — 형상은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 distinct 강제, 가공방식은 기존 축이 왜곡 없이 담음(라미=공정 멤버 이미 수용·KB 결함 없음)** = 형상 승격·가공방식 부결의 결정적 분기. directive 4 관전 적대 판정: **(① 두께=자재#1 WGT facet)** WGT 슬롯 다의성(평량/두께)·[huni-ref] 후니가 투명3T/1.5T를 mat_cd 차원 통합(1.5T=3T×0.8) 동형 · **(② 소재variant=자재#1 surface-finish facet)** 글리터/거울/자개/홀로그램이 ST S-4 점착/내후 합성 차원 동형·거울 별공식=#11 라우팅(자재 분류 아님) · **(③ 입체/스탠드=분산 facet)** 받침=부속물#8(평면본체 유지=생산형태#15 아님·본체 생성 아님=형태가공#14 아님)·코롯토 두께블록=자재#1·양면=옵션#3·입체조형=공정#2 · **(④ 가공방식 그룹핑=공정#2+자재#1 합성+옵션#3 cascade·#18 부결).** 나머지 A-4(부착물=부속물#8+공정#2 부착·고리 KR/CN/CR ST 공유=단일 부자재 마스터)·A-5(인쇄면+화이트=옵션#3+공정#2+제약#5·ST S-7 동형)·A-6(3 가격엔진=가격#11 acrylic2025 라우팅)·A-7(명찰 PET+합지=자재#1+공정#2·G-1/CL C-2 라벨 융합)·A-9(ACTPKEY=#16 TemplateAsset·T-A 이중의미). **7번째 카테고리(아크릴 두께/입체/가공방식)가 distinct 0 = 모델 재포화 재확인** — 가장 강한 새 후보 A-8조차 무손실 흡수.

> **★v6.0 (CL 통합) 핵심 판정 — 17축 재포화(distinct 0·PR 패턴 반복):** CL(의류·티셔츠·앞치마·가방류) 역공학의 9 fragment(C-1~C-9) 적대 판정 — **distinct 승급 0종(★의류 variant #18 부결)·전부 facet.** CL reverse가 "의류 variant=distinct #18"를 강하게 제기(item_gbn=clothes2025 별 분기·apparel_info 전용 그릇·size×color 2D 매트릭스·Pantone 1124)했으나 **네 근거 전부 기존 17축으로 무손실 분해** — ① item_gbn=구현 discriminator(PR P-4·ST S-5·GS G-1 정책패턴 동형) ② apparel_info=구현 컨테이너 뷰(여러 축 담음·D-8 동형) ③ size×color matrix=사이즈#13×색상(자재 CLR #1) Cartesian + 셀가용성=제약#5(ST disable 227=S-8 정점의 2D판) ④ Pantone=별색 공정#2(round-22 경계). **의류 variant = GS variant 축(G-4)의 2D 일반화 facet** — GS는 1D-per-channel(DTL/ATTB/CUT), CL은 2D 매트릭스(size×color→단일 MTRL_COD)로 해소·둘 다 같은 기존 축으로 분해. 주 귀속=자재#1 SKU matrix(G-1 본체 SKU 라벨 융합 동형·★[HARD] {fabric/PTT,color/CLR,size/WGT} 분해 요구). ST(5번째·형상 1종)가 PR 포화를 깼으나 CL(6번째·distinct 0)이 **모델 안정성 재확인** — 의류처럼 전용 그릇·전용 모델을 가진 가장 이질적 카테고리조차 17축 무손실 흡수.

> **★v5.0 (ST 통합) 핵심 판정 — 16축 포화 붕괴(distinct 1종):** ST(스티커) 역공학의 4 distinct 후보를 적대 판정 — **distinct 승격 1종(D-12 형상)·facet 강등 3종(칼선·재단입자·점착).** PR이 16축 포화를 입증(4번째 카테고리 distinct 0)했으나 **ST가 그 포화를 정직하게 깨뜨림** — 5번째 카테고리가 *형상(shape)* 1종을 도입. 이는 오버피팅이 아니라 **사이즈축(#13)이 형상을 1:1 칼틀로만 흡수해 온 전제가 ST에서 1:多로 분리됨**을 증거가 강제한 결과. 4 후보 적대 판정: **(① 형상=★distinct #17)** ST `option_info.shape_info`가 사이즈와 분리된 *전용 enum 슬롯*(SQ/CL/EL/RC/FR)·한 형상이 다수 칼틀 span(CL→CL001~100)·STDCFBR 5형상 superset·**후니 KB G-SK-2 "size축에 형상 enum drop·어느 축에도 없음"**(`entity-semantic-model.md:39`)이 size#13 미수용 확증 → 사이즈축이 *왜곡 없이 못 담음* = distinct. **(② 칼선 2메커니즘=facet of 공정#2)** THO_GRA(자유/도무송) vs THO_DFT(프리셋칼틀)는 *모양커팅 공정의 두 모드*(도메인 KB: 도무송=칼선 자유모형 컷팅·완칼/반칼 계열·공정 멤버). 프리셋칼틀이 사이즈를 겸함 = 공정#2 + 사이즈#13 cascade. PR THO_GRA·GS THO_CUT 합류. **(③ 재단 입자 반칼/완칼=facet of 공정#2)** 도메인 KB 결정적: 반칼=PROC_000054(종이만)·완칼=PROC_000053(종이+후지)·스티커완칼=PROC_000055 *전부 공정 멤버*. CUT_DFT 묶음재단(반칼시트)/개별재단(완칼낱장)=공정#2 멤버 + 배치 facet. GS THO_CUT 합류. **(④ 점착/내후 소재=facet of 자재#1)** 강접/리무버블/옥외/저온/자석/메탈/한지=*자재 합성 차원*(색상→material·두께→material 동형·`entity-semantic-model.md:51-53`). 자재모델에 adhesion/weatherability 합성축 추가(자재#1 강화·신축 아님). 양면 트레이드오프 펼침 = D-12 형상(아래)·S-4 점착(`_resolved-fragments.md`).

> **v4.0 (PR 통합) 핵심 판정:** PR(인쇄물·책자·리플렛·포스터) 역공학이 발굴한 새 패턴 9종(P-1~P-9) 중 **distinct 승격 0종.** 전부 기존 16축의 facet/family/cascade/정책으로 흡수. 이것이 *오버피팅 회피의 정직한 결과이자 16축 모델 포화(saturation) 입증* — **4번째 카테고리(BN 면적·GS 완제·TP 디자인입력·PR 다면/제본/접지)가 새 관리축을 0개 도입** = 16축이 RedPrinting 카탈로그 shape를 견디는 강한 검증 신호. PR이 더한 것은 새 *축*이 아니라 기존 축의 *새 facet/family/cascade*: **(P-1) 공정#2 "접지(folding)" family + 접지↔오시 cascade** · **(P-2) 자재#1 usage_cd "역할 전파"**(태그→자재/도수/가격/평량 전파 격상·★침묵선택 거부 트레이드오프) · **(P-3) page_rule 엔티티 정밀**(INN_PAGE=수량#10 슬롯+후니 별 엔티티·TP T-C 합류) · **(P-4) 공정방식=상품분기 정책패턴**(GS G-2·TP T-4 동류) · **(P-5) 면지=자재+공정 bundle**(D-2 동형) · **(P-6) 가격#11 digital_price 라우팅**(pricing_model 5종) · **(P-7) 인쇄방식#12 "자재풀 게이팅" 관계 간선** · **(P-8) 용도=카테고리#7 태그/마케팅 라벨** · **(P-9) 공정#2 멤버**(스코딕스 입체UV·레이저커팅·합지). 판정 근거 = "BN·GS·TP·PR 네 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = P-2/P-4(아래). ★directive 핵심 충족: distinct 신축 강요 0(facet 오분류 금지)·P-2 침묵선택 거부.

> **v2.0 (GS 통합) 핵심 판정:** GS 역공학이 발굴한 새 패턴 6종 중 **distinct 승격은 2종(D-9 생산형태·D-10 형태가공)**뿐. 나머지 4종(완제 본체 SKU·본체소재 pdtCode 분리·variant 3채널·기종 enum)은 **기존 축 facet/확장으로 흡수**(과잉 일반화 거부, SKILL §5). 판정 근거 = "BN(평면)·GS(완제/입체) 두 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = G-1/G-2(아래).

> **v3.0 (TP 통합) 핵심 판정:** TP 역공학이 발굴한 새 패턴 6종 중 **distinct 승격은 1종(D-11 디자인 입력 채널)**뿐. 나머지 5종은 facet/확장으로 흡수: **(a) 템플릿 자산**=D-11 입력채널의 *리소스 facet*(에디터가 로드하는 디자인 시안 — 완제SKU 템플릿#4와 *같은 단어 다른 의미*, 분리 명시) · **(b) VDP**=D-11 입력채널의 *데이터바인딩 facet* × 수량(#10 변수행) · **(c) 페이지 계층 INN_PAGE**=수량모델(#10)/사이즈(#13) 확장 · **(d) 티켓 형태 variant**=사이즈/형상(#13)+칼틀(#2)(GS THO_CUT 동형) · **(e) 특수인쇄 PRT_WHT/PRT_MAG·박**=공정(#2 별색 family). 판정 근거 = "BN(면적)·GS(완제)·TP(디자인입력) 세 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = T-A/T-D(아래). **★directive 핵심 충족: 에디터 채널은 distinct 승격(가장 강한 vessel-gap), 템플릿 자산은 distinct 신축이 아니라 입력채널 facet + 템플릿#4 이중의미 분리.**

---

## D-1. 부속물 축 (Addon) — distinct ✅

**정체:** 인쇄 본체와 *분리된 완제 부속 부품*. 거치대(X배너 8종·롤업 3종), 후니 도메인의 우드봉·볼체인·이젤.

**증거(BN):**
- BNSTDFT CDL_DFT = [PTIDF 뉴포인트, PT005 L거치대, PT004 W거치대, … 8종], BNRLSLV = [RLU01/02/03 롤업거치대].
- PCS_COD(후가공) 그룹으로 묶이지만 **본체에 가하는 작업이 아니다** — 독립 완제품.

**distinctness:**
- vs **템플릿/SKU:** 템플릿 = "본체+부속의 묶음 주문 단위(번들 SKU)". 부속물 = "묶음에 들어가는 부속 부품". 거치대는 부품(D-1), "현수막+거치대 1세트" = 템플릿. 둘 다 필요(서로 못 담음).
- vs **옵션:** 옵션 = 본체 속성 선택. 부속물 = 본체 외부 객체(자체 코드·재고·가격).
- vs **공정:** 공정 = 본체 변형. 부속물 = 비변형 첨부.
- **후니 동형(권위):** entity-semantic-model 9속성 #9 `addl_product`(`t_prd_product_addons`) "완제 부속: 거치대·우드봉·볼체인 — 부착공정과 축 분리". → RP CDL_DFT = 후니 addons의 RP 표현. distinct 확정.

**오버피팅 검토:** BN에서만 거치대가 보였으나, 후니 도메인 KB가 거치대·우드봉·볼체인·이젤을 횡단 부속물로 확증 → 단일상품 아님, distinct 정당.

**관계:** 부속물 → 본체 상품(belongs-to, 번들), 부속물 ↔ 사이즈(match 제약, D-3). 부속물 자체가 size variant 보유(롤업거치대 600/850/1000).

---

## D-2. 자재 합성 & usage & 공정결합 축 (Material Composition) — distinct(메타규칙) ✅

**정체:** "자재"는 단순 enum이 아니라 **(a) 다축 합성코드 + (b) usage 슬롯 + (c) 공정의 자재소비 FK**라는 세 규칙을 가진 메타 구조.

**증거(BN):**
- (a) **합성:** MTRL_CD = MTRL_TYPE(P) + PTT_CD(BFC현수막/MAS매쉬/TFC텐트천) + CLR_CD(X기본) + WGT_CD(XXX) + 인쇄방식(수성C/라텍스L). 하나의 코드가 4~5축 인코딩(BNBNFBL note, A-4).
- (b) **usage:** BN은 substrate 단일 usage이나, 후니 entity-semantic-model #2 usage_cd(.01내지/.02표지/.03면지/.07공통) = 자재가 *어느 슬롯에 쓰이나*.
- (c) **공정결합:** SUB_MTRL_YN=Y(아일렛=금속링, 각목, 로프, 큐방) = 공정이 부자재를 소비(A-6). "순수공정(재단)" vs "자재소비공정(아일렛)"을 플래그로 분리.

**distinctness:**
- 단순 "자재 버킷"(자재 행 등록)은 (a)(b)(c) 규칙을 못 담음. 합성코드를 평면 문자열로 두면 본체색(CLR)·소재(PTT)·인쇄방식 분리 불가 → 위젯 옵션 캐스케이드·가격 분기 붕괴.
- **후니 권위 정합(HARD):** entity-semantic-model §1-1 "자재축에 공정 섞임"(아트250+무광코팅) = 결함. 메모리 `dbmap-material-option-normalization`: 후니 자재 오염(색/형상/구수가 자재행에) — RP 합성코드 분해가 *정답 모델*. 별색=공정·본체색=자재 CLR축(도메인 사실 준수).
- **공정↔자재 FK는 자재 버킷 단독으로 표현 불가** — 공정 엔티티가 `consumes_material`/`material_ref`를 가져야 함. 자재와 공정 양쪽에 걸친 메타규칙 → distinct.

**관계:** 자재(합성) → 본체, 자재 CLR → 본체색(variant), 공정(SUB_MTRL_Y) → 자재(consumes FK), 자재 → 공정(force, PET→코팅필수 D-3).

**경계 준수(도메인 HARD):** 별색≠자재(별색=공정 PROC_000007), 본체색=자재 CLR 분해축, 두께=자재 식별자. RP MTRL_CD의 CLR/WGT는 자재축, 인쇄방식은 자재 facet 또는 D-7로.

---

## D-3. 제약 논리유형 축 (Constraint Logic Typing) — distinct ✅

**정체:** 7버킷 "제약"은 *제약 객체*만 가리킨다. 발굴 핵심 = 제약이 **유형화된 논리 어휘**를 가진다는 것 — disable / force(=require) / match / exclude / essential / min-max.

**증거(BN) — 6 논리유형 실관측:**
| 논리유형 | BN 증거 | 방향 | 후니 동형 |
|---|---|---|---|
| **disable** | `pdt_disable_pcs_info`(자재→공정 비활성, BN 0건·책자 24건) | 자재→공정 (−) | round-6 material→pcs disable |
| **force/require** | PET→코팅 ESN_Y 필수, 텐트천→PKG_RUP 포장 필수(A-5) | 자재→공정 (+) | ESN_YN=Y, force 규칙 |
| **essential(필수)** | CUT_ZUN 재단 ESN_YN=Y(택1 필수), COT_DFT 코팅 ESN_Y | 그룹 내 필수 | excl_group 필수 |
| **match(캐스케이드)** | 롤업 size 600 ↔ 거치대 RLU01 1:1(A-1) | 사이즈↔부속물 | 부속물 size 종속 |
| **exclude(택1)** | 재단 그룹 [정사이즈/방풍/모양] 택1, SEL_TYPE.01 | 그룹 내 배타 | process_excl_group SEL_TYPE.01 |
| **min-max(범위)** | nonspec size MIN/MAX_CUT_WDT/HGH(0~5000) | 값 범위 | nonspec_*_min/max |

**distinctness:**
- 제약을 단일 객체 버킷으로 두면 "어떤 논리인가"를 못 표현 → 위젯 런타임이 캐스케이드를 못 구동. 6유형은 *거버넌스된 어휘*(JSONLogic op 집합)여야 함.
- **후니 권위:** entity-semantic-model #5 process_excl_group(택일), 메모리 `dbmap-cpq-option-mapping` "RedPrinting 캐스케이드 6종 → JSONLogic constraints", `dbmap-live-admin-product-viewer` constraints.logic NOT NULL. → 제약 논리유형이 후니 CPQ의 1급 구조. distinct 확정.
- **force = disable의 역방향**(사용자 directive 명시 후보): RP가 disable(−)과 force(+)를 *대칭 쌍*으로 운영 → 제약 축이 방향성을 가진 그래프임을 입증.

**관계:** 제약은 모든 축을 잇는 *간선(edge)* — 자재→공정(disable/force), 사이즈↔부속물(match), 공정 그룹 내(exclude/essential), 값 범위(min-max). 제약 축 = 메타모델의 관계 엔진.

---

## D-4. 공정 파라미터 축 (Process Parameter) — distinct ✅

**정체:** 공정 *멤버*가 선택됐을 때만 활성되는, 그 공정에 종속된 매개변수 슬롯.

**증거(BN):**
- BNTNHVY number_sel_ROP_DFT: 로프 공정에 종속된 수량 select(USER/1~10) (A-7).
- SUB_MTR QTY_INPUT_YN=Y: 추가부자재 수량 입력.
- (후니 횡단) UV 변형 5종(풀빼다/배면양면 = PROC_000002 param), 오시 줄수 0~3, 접지 16종, 책등 mm, 링컬러/D링 mm, 조각수.

**distinctness:**
- vs **옵션:** 옵션은 독립 선택축. 파라미터는 *부모 공정 종속*(공정 미선택 시 비존재).
- vs **수량:** 수량 슬롯 중 일부(로프 수량)는 파라미터지만, 파라미터는 수량 외 도메인(줄수/mm/색/조각수)도 가짐 → 수량의 상위가 아니라 별개.
- **후니 권위:** entity-semantic-model #4 "prcs_dtl_opt param — 줄수/개수/조각수=공정 신호(옵션값 아님)", process-recipe-tree §2-3 "param이 캐스케이드 입력값", 메모리 `dbmap-cpq-option-mapping` ref_param_json. → distinct 확정.
- **lifecycle:** 조건부 활성(부모 공정 선택 시), 자체 값 도메인, 가격에 공정과 함께 기여. 기존 옵션/공정 어느 쪽도 단독으로 못 담음.

**관계:** 파라미터 → 공정 멤버(belongs-to), 파라미터 → 가격(공정과 결합 기여, D-6), 파라미터 ↔ 캐스케이드(오시 줄수 → 접지 단수, D-3 match).

**도메인 경계 준수:** 판걸이수(impos)는 *앱 계산*(DB 미저장) — 파라미터 축에 넣지 말 것(entity-semantic #6 plate_size note, 메모리 `dbmap-compute-in-app-db-stores-lookup`). 파라미터 = *입력* 매개변수만.

---

## D-5. 수량 모델 축 (Quantity Model) — distinct ✅

**정체:** 단일 qty 스칼라가 아니라 **다중 의미적 수량 슬롯**(주문 건수 × 인쇄 수량 + 공정종속 수량).

**증거(BN):**
- 전 BN: ORD_CNT="디자인 수(건수)" + PRN_CNT="수량" 이중축(quantityGroup, A-2). SSR number1_sel(1~10) + number4_sel("N배").
- 공정종속: ROP_DFT 수량, SUB_MTR 수량(D-4와 교차).

**distinctness:**
- "옵션(수량)"으로 평면화하면 건수(세팅비 곱수)와 수량(선형)의 가격기여 차이 소실 → 가격 모델 붕괴(D-6과 연결).
- vs **bundle_qty(후니):** entity-semantic-model #7 bundle_qty = 묶음수(권/세트), page_rule ≠ bundle. RP ORD_CNT(디자인 건수)는 후니 bundle과 또 다른 의미 → 수량 축은 *복수의 이질적 슬롯*을 갖는 축임이 확증.
- lifecycle: 상품마다 노출 슬롯 다름(건수만/수량만/둘다/공정수량). distinct.

**관계:** 수량 슬롯 → 가격기여 역할(D-6: 건수=곱수, 수량=선형), 공정종속 수량 → 공정 파라미터(D-4 교차).

**오버피팅 검토:** 이중 수량은 BN 전 6상품 + Vue/jQuery 양 런타임 일관 관측 → 단일상품 아님, distinct.

---

## D-6. 가격기여 역할 축 (Pricing Role) — distinct(횡단 메타) ✅

**정체:** 7버킷 어디에도 없는 횡단 축 — **각 선택축이 가격에 *어떻게* 기여하는가**의 역할 태그.

**증거(BN):**
- 전 축에 `price_flag`/`price_gbn=real_price`가 부착: MTRL_CD→면적단가 분기키, CUT_WDT/HGH→SizeMatrix2D 면적, DOSU_COD→도수가, PCS_INFO[]→후가공가, ORD_CNT→세팅곱수.
- item_gbn=real_item·price_gbn=real_price = "대형 실사/배너 = 면적 기반 SizeMatrix2D 가격모델"(BN 공통 계약).

**distinctness:**
- 7버킷은 "무엇을 등록하나"(객체)만 다룬다. "그 선택이 가격에 면적단가인지/곱수인지/고정인지/단가매트릭스인지"는 별도 메타정보 → RP가 모든 축에 price_flag로 부착한 것이 증거.
- **후니 권위 정합:** 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형), `dbmap-price-class-benchmark`(가격공식 15클래스), round-2 t_prc_* 4단(price_components.prc_typ_cd 단가/합가). → 후니도 가격기여 *유형*을 1급 데이터로 운영(prc_typ_cd, frm_typ). distinct 확정.
- 횡단성: 자재·사이즈·도수·공정·수량 *모든 축*이 가격기여 역할을 가짐 → 단일 버킷 귀속 불가, 횡단 메타.

**관계:** 가격기여 역할은 각 축 엔티티에 *부착되는 태그*(자재.price_flag, size→면적, qty→곱수/선형) + 면적기반 상품은 SizeMatrix2D 가격모델 바인딩.

**경계:** 본 하네스 산출(메타모델)에서는 *역할 분류*까지만 — 실제 가격 *값/공식*은 dbmap 가격 트랙·갭분석가 영역. PRICE=0 캡처(비로그인)는 가격 *구조* 추출에 무관(BN note).

---

## D-7. 인쇄방식 / 생산 레시피 축 (Print-Method / Production Recipe) — distinct(조건부) ✅

**정체:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 **가능 공정 부분집합·파일포맷·생산팀·기초데이터를 게이팅**하는 최상위 레시피 축.

**증거:**
- (BN/RP) 인쇄방식이 MTRL_CD 끝자리로 인코딩(수성C/라텍스L, A-4) — RP는 *자재 facet*으로 표현.
- (후니 권위) process-recipe-tree §1: 인쇄방식 5종 = 최상위 축, "1상품=1인쇄방식이 가능 공정 부분집합 결정"(레시피 게이팅). §2 PDF 17 Case = 방식별 공정 시퀀스.

**distinctness 판정(조건부):**
- **RP 표현에서는 facet**(자재코드 분기) — BN 단독으로 보면 자재 합성의 일부(A-4 1차 판정).
- **후니/도메인 표현에서는 distinct 1급 축** — 인쇄방식이 공정·파일·팀·기초데이터를 게이팅하는 *lifecycle*을 가짐. 단순 자재 분기가 담을 수 없는 게이팅 관계.
- **메모리 `dbmap-print-method-not-absolute-axis`:** 인쇄방식 절대축 아님(강제 분리 금지) — 그래서 *조건부* distinct: 메타모델은 인쇄방식을 (a) 자재 facet으로 인코딩하거나 (b) 1급 레시피 축으로 게이팅하는 *양면 표현*을 인정해야 함.
- **결론:** distinct 등재하되 "RP=자재 facet / 후니=1급 게이팅 축" 갭을 명기. 메타모델 사전에서는 게이팅 관계를 1급으로 그림(갭분석가가 후니 흡수 위치 결정).

**관계:** 인쇄방식 → 가능 공정 집합(gates), → 파일포맷, → 생산팀, → 기초데이터 요구. 자재와 부분 중첩(RP 인코딩).

---

## D-8. UI 런타임/표현 바인딩 — facet, **축 아님(거부)** ❌

**정체 후보:** Vue3 위젯 vs 레거시 jQuery 두 런타임(BN §0).

**거부 근거:**
- BN §0 핵심 발견: "UI 런타임이 둘이어도 **base-data 스키마는 하나**"(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info` 공유).
- 후니가 흡수할 대상은 UI가 아니라 공통 관리 축 — 런타임은 *표현 계층*이지 관리 축이 아님.
- distinctness test 실패: 고유 관리 *데이터*가 없음(같은 base-data를 다르게 렌더할 뿐). → facet of presentation, 메타모델 사전에서 제외.

**메타모델 시사:** 메타모델은 런타임 중립이어야 함 — 같은 base-data가 어떤 위젯으로도 렌더되도록(후니 위젯 컨버전 전략 정합, 메모리 `huni-widget-conversion-strategy`).

---

## ═══ GS 통합 발굴 (v2.0) ═══

## D-9. 생산형태 축 (Production Type) — distinct ✅ (GS 신축)

**정체:** 상품의 생산 구조 분류(완제품 C / 반제품·셋트 B / 통합 A / 기성 / 디자인)가 **본체 모델링·자재 usage·형태가공을 governing**하는 상위 직교 축.

**증거(GS + 도메인 권위):**
- GS: 텀블러/코스터/효자손/장패드 = **C 완제품**(본체=DIR_MTR 완제 SKU 항목, 내지/표지 개념 없음), 스프링노트/스케치북 = **A 통합 또는 B 셋트**(표지+내지 usage 다중슬롯). 같은 "노트" 기능군에 통합책자·하드커버 공존.
- 도메인 권위(entity-semantic §4 "C-9 해결"): 생산방식 3구조 **A 통합 / B 셋트·반제품 / C 완제품·단일** 확정·11군 매핑. "B 셋트라도 자재 권위=parent+usage_cd, sub_prd 0행=정상".

**distinctness:**
- vs **카테고리:** 카테고리=기능 트리(코스터·노트). 생산형태는 *직교* — 같은 카테고리에 A·B·C 공존(노트=통합책자[A]+하드커버[B]). 카테고리가 생산형태를 못 담음(다대다 직교).
- vs **템플릿/SKU:** 템플릿=번들 주문 단위. 생산형태는 *본체가 자재행인가 완제 SKU 항목인가*를 결정하는 분류 — 템플릿의 상위.
- **lifecycle/governing:** 생산형태가 #1(본체 모델링)·#14(형태가공 활성)·#1 usage(셋트=다중)를 게이팅. 1상품 1생산형태. 기존 어느 축도 이 governing을 단독으로 못 함 → distinct.
- **오버피팅 검토:** BN(전부 C형 단일)에선 단일값이라 미발굴이었으나, **도메인 권위가 11군 매핑으로 1급 확정** + GS가 A/C 다수 노출 → 단일상품 아님(횡단). distinct 정당.

**관계:** 생산형태 → 상품(classifies 1:1), → 본체 모델링(governs #1/#4), → 형태가공(#14 C 입체 활성), → 자재 usage(#1 B 다중슬롯), ⊥ 카테고리(직교).

**★후니 갭(갭분석가 주목):** 메모리 `dbmap-grid-binding-round15` "라이브 prd_typ_cd ≠ 생산형태(굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속)" — 후니 라이브가 이 축을 *오모델링* 중. RP/GS가 정합 참조 제공.

---

## D-10. 본체 형태가공 축 (Body Form-Assembly) — distinct ✅ (GS 신축)

**정체:** 평면 인쇄물을 *입체 완제 굿즈로 조립/봉제/지퍼/형성*하는 공정. 본체 *형태 자체를 생성*(일반 후가공=기존 본체에 작업).

**증거(GS):**
- GSPUFBC: `PDT_WRK`(노트북-태블릿 파우치가공) + `FLX_ZIP`(지퍼가공 세로형). GSTGMIC: `PDT_WRK`(마이크텍 조립). 평면 패브릭/인쇄물 → 입체 파우치/마이크텍.
- BN(평면 배너)엔 *전무* — 굿즈 특유 축.

**distinctness:**
- vs **공정(#2):** 일반 후가공(코팅·재단·아일렛)=기존 본체에 작업 가함. 형태가공=본체 *생성*(파우치는 PDT_WRK 없으면 평면지로 본체 미완성). lifecycle 구별.
- vs **자재소비공정(D-2):** 지퍼(FLX_ZIP)는 부자재 소비 동반(아일렛 패턴)이나, PDT_WRK(봉제/조립)는 순수 형성 — 형태가공은 자재소비공정의 부분집합 아닌 별 카테고리.
- **lifecycle:** 본체 정체와 결합된 필수 공정 + 방향 variant(세로/가로). 생산형태(D-9 C 입체)에서만 활성.
- **오버피팅 검토:** GSPUFBC·GSTGMIC 2상품 + 효자손/폰케이스 추정 → 단일상품 아님. 후니 굿즈 BOM "평면→입체 조립 단계"(메모리 round-22 본체 자재 BOM) 동형. distinct 정당.

**관계:** 형태가공 → 상품(belongs, 본체 형성), → 자재(consumes 지퍼, #1), → 생산형태(D-9 governs), → 공정 seq(인쇄→재단→형태가공).

---

## ═══ GS facet/확장 판정 (distinct 거부 — 양면 트레이드오프) ═══

## G-1. 완제 본체 SKU (DIR_MTR/WRK_MTR) — **자재축 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 굿즈 본체(텀블러/실리콘끈/장패드/스펀지)가 `DIR_MTR`(부자재직접인쇄)/`WRK_MTR`(부자재작업) PCS 항목으로 등장하고 result PRICE 주체.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) 별도 distinct "완제 본체 SKU" 축으로 신설:**
  - 찬성: BN 본체=`ORD_INFO.MTRL_CD`(자재행)와 GS 본체=`DIR_MTR`(PCS 항목)는 *DB 위치가 다름*(ORD vs PCS). PRICE 주체·완제 SKU 라벨이라는 별 성격.
  - 반대: 위치가 달라도 *둘 다 "본체 소재를 가리키는 참조"*라는 같은 의미축. 신축으로 두면 자재축이 BN/GS로 쪼개져 메타모델 일관성 붕괴(같은 개념 2축). PRICE 주체는 가격기여 역할(#11)이 담음·완제 SKU성은 템플릿(#4)·생산형태(#15)가 담음.
- **(나) 자재축(#1)의 두 표현 facet + 템플릿(#4)·생산형태(#15) 결합 [채택]:**
  - 본체 = 자재참조(#1)이며, 생산형태(#15)가 *표현을 governing*: C 완제품→DIR_MTR PCS 항목(완제 SKU 라벨), A/B→ORD_INFO 자재행. 가격 주체성=#11, SKU성=#4.
  - 이점: 자재축 단일 유지·기존 발굴 축(#11/#4/#15)이 나머지 성격 흡수·BN/GS 통일.

**판정: facet (distinct 거부).** 완제 본체는 *기존 축들의 결합*으로 왜곡 없이 표현됨(자재#1 + 가격기여#11 + 템플릿#4 + 생산형태#15). 신축은 자재축 중복. **단 [HARD] 분해 요구:** PCS_DTL_NME 라벨 융합("미르 와이드마우스 보틀 화이트 20oz")을 `{body_material, body_color, capacity, thickness, brand}`로 분해해야(평면 라벨=의미축 drop). 이것이 후니 "굿즈 본체소재 부재" 결함의 RP판 정답.

---

## G-2. 본체 소재 = pdtCode 분리 (코스터 6소재) — **자재+카테고리 복합 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 같은 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 6개 별도 pdtCode.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) RedPrinting 방식 답습 — 소재=상품 분리(pdtCode 6개 유지):**
  - 찬성: RP 검증 모델·소재가 본체정체(다른 소재=다른 생산라인/단가)·아크릴 코스터만 형상 추가처럼 소재가 후속 옵션 캐스케이드.
  - 반대: 카탈로그 6→1 기회 상실·소재 추가 시 신상품 생성 운영부담·후니 "굿즈 본체소재 컬럼 부재"라 현재 상품명에만 → 6 pdtCode 답습 시 결함 고착.
- **(나) 소재=옵션화 — 한 "코스터" 상품 + 소재 차원(자재 variant):**
  - 찬성: 카탈로그 축소·소재=자재축 variant(entity-semantic §2 "색상 variant→material" 동형으로 소재 variant→material)·관리용이.
  - 반대: 소재별 후속 옵션 분기(아크릴=형상, 규조토=흡수 무인쇄?)를 옵션 캐스케이드로 풀어야 — variant×후속옵션 복잡도. 소재별 단가가 매트릭스로.

**판정: facet — 자재축(#1 소재 variant) + 카테고리(#7 코스터=공통 기능 노드) 복합 (distinct 거부).** "본체 소재"는 자재축이 담고(소재=mat_cd 분기), "코스터 공통 기능"은 카테고리가 담음 → 신축 불요. **분리 vs 옵션화는 메타모델 판정이 아닌 후니 카탈로그 *정책 결정*(갭분석가/실무)** — 메타모델은 둘 다 표현 가능(소재=pdtCode면 카테고리 다대일, 소재=옵션이면 자재 variant). RP는 (가) 채택, 후니 관리용이성은 (나) 우세하나 아크릴 코스터 형상 캐스케이드가 (나)의 난점. **권고: 정형 소재(종이/펠트/코르크/규조토/레더)=옵션화, 형상 동반 소재(아크릴)=별 pdtCode** 하이브리드.

---

## G-3. 폰케이스 기종(device) enum — **사이즈 프리셋 facet (distinct 거부)**

**정체 후보:** 폰케이스 기종(갤럭시/아이폰 수십종)별 칼틀·사이즈 분기(GSCAPHN, 옵션 상세 unobserved).

**판정: facet — 사이즈 축(#13) 대규모 프리셋 인스턴스 (distinct 거부).** 기종 = 사이즈/칼틀 프리셋의 *대규모 enum*일 뿐 고유 lifecycle 없음(소재처럼 본체정체를 바꾸지 않음·기능 동일). 기종↔칼틀 캐스케이드 = 제약축(#5 match). "일반/터프"(케이스 구조)는 자재축 본체타입 variant(#1)와 직교. **단 enum 규모(수십~수백)가 질적으로 커 위젯 UX는 검색형 select 필요**(메타모델 데이터 구조는 사이즈 프리셋 동일·표현만 다름). unobserved라 규모/캐스케이드 방향 확정 불가(`unobserved`).

---

## G-4. variant 3채널(DTL/ATTB/CUT) — **기존 축 분배 facet (distinct 거부)**

**정체 후보:** 같은 variant 개념이 DTL코드·ATTB·CUT_WDT/HGH 3채널로 분산.

**판정: facet — 3채널을 기존 축으로 분배 (별 "variant 축" distinct 거부).** ① DTL코드→옵션축(#3) polymorphic option_item(다차원 합일 시 다중 ref_dim_cd), ② ATTB→공정 파라미터(#9, 링색·반경), ③ CUT→사이즈축(#13 프리셋). entity-semantic §2 "variant 분해 원칙(색상→material·사이즈→size·두께→material)"이 이미 채널 분배를 규정 → 신축 불요. **★난점 명기:** GSTGMIC TG001/3처럼 *한 DTL코드가 자재+사이즈+칼틀+가격 동시 결정*(강결합) — 후니 CPQ polymorphic ref가 한 option_item에서 복수 차원을 게이팅하도록 표현(메모리 `dbmap-cpq-option-layer-mapping`). 정규화 난점이지 신축 사유 아님.

---

## G-5/G-6/G-7/G-8 — 기존 축 확장 (요약 판정)

| frag | 정체 | 판정 | 귀속 축 |
|---|---|---|---|
| **G-5** | INN_DFT/RIN_DFT/RIN_COL/STA_DFT (내지 usage + 제본방식) | **facet/확장** | 내지=자재 usage 다중슬롯(#1 GS 확인 ✅), 제본=공정(#2) + 자재(링/코일) bundle + 택1 그룹. 제본방식이 PCS_COD 레벨 분리(그룹 메타 없음) → 후니 옵션그룹(택1)으로 묶을 메타 추가 필요 |
| **G-6** | PDT_WRK/FLX_ZIP (형태 조립) | **distinct → D-10** | 본체 형태가공 신축(위 D-10). FLX_ZIP은 자재소비(지퍼) bundle |
| **G-7** | tmpl/vTmpl/tiered_price (가격모델 3종) | **확장** | 가격기여 역할(#11) — pricing_model enum 4종 확장(면적/tmpl/vTmpl/tiered). 옵션↔가격모델 라우팅 |
| **G-8** | PAK_ETC/PAK_POL (포장 다중 + 유료/무료) | **facet** | 공정(#2 포장) — 방식별 PCS_COD + 가격기여(#11 유료/무료 분기). BN PKG_GB(강제 제약 A-5)와 달리 GS=선택+개당과금 |

---

## ═══ TP 통합 발굴 (v3.0) ═══

## D-11. 디자인 입력 채널 축 (Design-Input Channel) — distinct ✅ (TP 신축) ★directive 핵심

**정체:** 상품의 디자인을 *어떻게 입력받는가*를 결정하는 축 — 에디터 채널(KOI 웹에디터 / Edicus SDK / 없음=PDF 업로드) + 입력방식 플래그(PDF 직접·기성 템플릿 다운로드·디자인수 산정 출처). 본체(자재·공정·사이즈·수량)와 **직교**하며, 본체 옵션 트리(`pdt_pcs_info`)를 오염시키지 않고 `item_gbn` + `product_option.option`의 플래그 묶음으로 인코딩된다.

**증거(TP — ★직접 대조):**
- **같은 base-data 스키마, 옵션 트리 밖 플래그 묶음:** TP 상품은 BN·GS와 동일한 `pdt_mtrl_info`/`pdt_size_info`/`pdt_pcs_info`/`pdt_dosu_info`를 그대로 쓴다(reverse §0). 차이는 옵션 트리가 아니라 `product_option.option`의 `item_gbn`·`useKoiEditor`·`useRPEditor`·`useTemplateDownload`·`usePDF`·`usePDFordCnt`/`useEditorOrdCnt`·`koi_template_resource_id`·`koiOption[]` 플래그 묶음.
- **★비-TP 트윈 직접 증거(reverse §0.1):** 같은 "탁상 세로 캘린더"가 **TPCLSTD(TP)** = `vDigital_item`·`useKoiEditor=Y`·`useTemplateDownload=Y`(KOI에디터+기성템플릿) vs **HLCLSTD(비-TP)** = `offset2023_item`·`useKoiEditor=N`·`useTemplateDownload=N`·`usePDF=Y`(에디터0·PDF전용). **자재·사이즈·후가공·가격은 완전 동일**, TP가 추가하는 단 하나 = 디자인 입력 레이어. → 입력 채널이 본체 옵션과 *완전 분리 가능*(orthogonal)함을 1:1 트윈으로 입증.
- **가격 0(reverse §3 가격 실측):** TPCLWLB priceCall(`vTmpl_price`) — CUT_DFT 0 + STA_CLD 0 + PAK_POL 0 + PRT_DFT(인쇄) 11900 → PRICE=11900. 에디터/템플릿 PCS는 PRICE=0. **디자인 입력은 가격에 기여하지 않음**(가격 주체=인쇄/자재/후가공). → 입력채널이 가격기여역할(#11)을 갖지 않는 별 성격.
- **에디터 3채널 = item_gbn 분기(reverse §0.2):** `vDigital_item`(KOI·TPCL*/TPTKDFT) / `edicus_item`(Edicus SDK·GSCLMGN/TPBCDFT) / `offset2023_item`(없음·HL). KOI는 `koi_template_resource_id`로 템플릿 리소스 바인딩, Edicus는 VDP(가변데이터).

**도메인 정초(huni-widget 역공학 권위 — 신규 리서치 불요, 기존 KB 재사용):**
- `seed-redprinting-sdk-analysis.md:1` 3계층 아키텍처: 브릿지(`productRedWidgetSDK.js`) ↔ 런타임(`widget.js` Vue3) ↔ **에디터(`RedEditorSDK.min.js` 45메서드)**. 브릿지 글로벌 함수에 `sdkOpenEditor`·`fnKoiEditorInit/fnKoiEditor`·`fnRpEditorInit/fnRpEditor`·`sdkEditorCheck` = **에디터 채널이 호스트 통합 API의 1급 계약**(seed §7).
- `editor-bridge-protocol.md`: Edicus iframe URL 명령 `cmd: create | open | edit-template | create-design-project | open-design-project`. 공통 파라미터 `editor_type·parent_type·run_mode·master_mode·edit_mode` = 에디터 채널 메타. **즉 RedPrinting은 에디터 채널·모드를 명시 1급 파라미터로 운영**(브릿지 계약). → D-11이 후니 위젯에도 1급 통합 경계임이 확증(huni-widget 컨버전 전략 정합).

**distinctness(distinctness test §3):**
- vs **템플릿/SKU(#4):** 템플릿#4 = 완제 주문 단위(본체+부속 번들·봉투결합 엽서·OTC). 입력채널 = 디자인을 *생성/입력*하는 방식. 둘 다 필요(서로 못 담음). TP 템플릿 자산(디자인 시안)은 #4의 완제SKU가 아니라 *입력채널의 리소스 facet*(아래 T-A·이중의미 분리).
- vs **옵션(#3):** 옵션 = 본체 속성 선택(자재/공정/사이즈 polymorphic ref). 입력채널 = 본체 *외부*의 입력 메커니즘. `item_gbn`은 어느 차원 행도 가리키지 않음(ref_dim_cd 부재).
- vs **공정(#2):** 공정 = 본체 변형 작업. 디자인 입력 = 본체 *생성 전* 디자인 데이터 확보(인쇄 입력물). PRICE=0(공정은 가격기여). 비변형.
- vs **인쇄방식 레시피(#12):** 인쇄방식(디지털/옵셋)은 *가능 공정·파일포맷·팀*을 게이팅(생산 측). 입력채널은 *고객 디자인 입력 UX*(주문 측). 단 둘은 상관 — `offset2023_item`(옵셋 인쇄방식)이 흔히 에디터0·PDF전용과 동반. **그러나 동일 아님**: `vDigital_item`(디지털 인쇄)이라도 에디터 유무가 갈림(KOI vs PDF), `edicus_item`은 명함 VDP. 인쇄방식이 입력채널을 *제약*하나 결정하진 않음 → 별 축(상관 간선).
- **lifecycle:** 1상품에 입력채널 1구성(item_gbn 1값 + 플래그 묶음). 입력채널이 (a) 디자인수 산정(`usePDFordCnt`/`useEditorOrdCnt` → 수량모델#10 ORD_CNT) (b) 템플릿 자산 노출(`useTemplateDownload`) (c) VDP 가능 여부(Edicus)를 *게이팅* → 다운스트림 영향 보유. 기존 어느 축도 이 게이팅을 단독으로 못 함.

**오버피팅 검토(SKILL §5):** TP 단일 카테고리지만 — ① **비-TP 트윈(HL 캘린더)** 직접 대조로 "본체 동일·입력채널만 추가" 입증(단일상품 아님·횡단 대조) ② 에디터 채널은 GS(`edicus_item` GSCLMGN)·BN(전 상품 PDF 업로드)에도 *값으로* 존재 — TP는 그 축을 *전면화*했을 뿐, BN/GS도 입력채널 값을 가짐(전 카테고리 횡단) ③ **후니 동형 권위:** huni-widget RedEditorSDK 45메서드 + Edicus 브릿지 = 후니 위젯도 동일 에디터 채널 통합 필요(메모리 `huni-widget-conversion-strategy`·`widget-monitor-live-testbed`). → distinct 정당.

**관계:**
- DesignInputChannel → Product(classifies — 1상품 1입력구성).
- DesignInputChannel → TemplateAsset(provides — 에디터가 로드하는 디자인 시안 카탈로그, T-A facet).
- DesignInputChannel → QuantitySlot(#10, gates — `usePDFordCnt`/`useEditorOrdCnt`가 ORD_CNT "디자인 수(건수)" 산정 출처 결정).
- DesignInputChannel ↔ PrintMethod(#12, 상관 — offset2023↔에디터0 동반 경향, 결정 아님).
- DesignInputChannel ⊥ 본체 옵션 트리(자재#1·공정#2·사이즈#13·옵션#3 — 직교, 가격 0).

**★후니 갭(갭분석가 주목):** 후니 t_*에 "디자인 입력 채널" 그릇 **부재 가설(vessel-gap 1순위)**. `item_gbn`/에디터 플래그/템플릿 리소스 ID에 대응할 컬럼·테이블이 라이브에 있는지 갭분석가 확인 필요(huni-widget이 Edicus 통합을 *코드 계약*으로만 가지고 DB 그릇은 미정). 후니 위젯이 Edicus 어댑터를 쓰므로 입력채널 메타(에디터 타입·템플릿 리소스·VDP 변수 스키마)를 담을 그릇 설계가 vessel 단계 과제.

---

## ═══ TP facet 판정 (distinct 거부 — 양면 트레이드오프) ═══

## T-A. 템플릿 자산(에디터 디자인 시안) — **입력채널 리소스 facet + 템플릿#4 이중의미 분리 (distinct 거부)** ★핵심 의사결정

**정체 후보:** `useTemplateDownload=Y` + `koi_template_resource_id`/`koiOption[]` + RedEditorSDK `getTemplateList`/`setCurrentTemplate`/`changeTemplate` = 에디터가 별도 카탈로그에서 로드하는 기성 디자인 시안(가격 0).

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) 별도 distinct "템플릿 자산" 축 신설:**
  - 찬성: 옵션도 SKU도 아닌 별 성격(에디터 종속·가격 0·런타임 카탈로그 로드). reverse T-2가 "1순위 분리 필요" 제기.
  - 반대: 템플릿 자산은 *독립 lifecycle/governing이 없음* — 항상 에디터 채널(D-11)이 있을 때만 존재(`useKoiEditor=N`이면 템플릿 자산도 0). 즉 D-11의 *하위 리소스*이지 동급 축 아님. 신축 시 D-11과 1:1 종속 축 2개로 분열(중복).
- **(나) 입력채널(D-11)의 리소스 facet + 템플릿#4 이중의미 명시 분리 [채택]:**
  - 템플릿 자산 = D-11 에디터 채널이 제공하는 디자인 시안 카탈로그(`TemplateAsset` 그릇·D-11 종속). 가격 0·런타임 SDK 로드.
  - **★[HARD] 템플릿 "이중의미" 분리:** 후니 `t_prd_templates`(완제SKU·봉투결합 엽서·OTC = 메타모델 #4)와 **같은 단어 다른 의미**다. TP 템플릿 자산 = *디자인 시안*(에디터 입력 리소스), #4 템플릿 = *완제 주문 단위*(번들 SKU). 사전(#4)에 이 이중의미를 명시 구분(아래).

**판정: facet — D-11 입력채널의 리소스 facet (distinct 거부). 단 [HARD] 템플릿#4와 의미 분리 명시.** 신축은 D-11과 종속 중복. 단 메타모델 #4 "템플릿/SKU"가 *두 의미*(완제SKU vs 에디터 디자인 자산)를 갖지 않도록 — **#4=완제SKU 번들(주문단위)**, **TemplateAsset=에디터 입력 디자인 시안(D-11 종속·가격0)**로 별 엔티티 분리. RedPrinting `koi_template_resource_id`는 후자, `t_prd_templates`는 전자.

## T-B. VDP(가변데이터 인쇄) — **입력채널 데이터바인딩 facet × 수량 (distinct 거부)**

**정체 후보:** RedEditorSDK `openVdpViewer`/`setVariableData`/`getCurrentTemplateVdpList`(seed §10) + Edicus `data_row`/`data_feed`/`ddp_block` 핸드셰이크(bridge §3~4) = 명함 이름·직함, 상장 수상자명 등 *변수 데이터로 다건 인쇄*.

**판정: facet — D-11 입력채널의 데이터바인딩 능력 facet × 수량모델(#10) (distinct 거부).** VDP = 에디터 채널(특히 Edicus)이 *제공하는 능력*(D-11 facet)이며, 변수 데이터 행수는 *디자인 수(ORD_CNT)/인쇄 수량*으로 이미 수량모델(#10)이 담음. 별 lifecycle 없음(에디터 없으면 VDP 없음). **도메인 정합:** bridge §3 `create-design-project`/`data_feed` = VDP 프로젝트 = 입력채널 모드. 명함(TPBCDFT)·상장(TPPOAWD)이 강한 VDP 후보(reverse §1·§4-E). 미관측(`koiOption[]` 빈배열·VDP 변수 스키마 unobserved) → 갭 단계 확정.

> **★[검증 확정 2026-06-17] facet 판정 옳음(codex H-6 "VDP=독립 1급축" REFUTED).** 실측: VDP = RedEditorSDK **45메서드 중 3개**(`openVdpViewer`/`setVariableData`/`getCurrentTemplateVdpList`·seed §10)이지 독립 엔티티 아님 · `getCurrentTemplateVdpList`="**현재 템플릿의** VDP"=리소스 종속 · `data_feed`/`ddp_block`=Edicus iframe deferred 파라미터(에디터 떠야 흐름·bridge:37) · `edicus_item`에서만 VDP(offset/PDF전용엔 없음)=**#16 ⊃ VDP 포함관계(직교 아님)** · 라이브 VDP 컬럼/테이블/enum 0건이 **#16 GAP에 완전 포함**(분리 흔적 없음). codex가 든 "필드정의·CSV·넘버링·PII"는 base-data가 아니라 *주문 시점 에디터 런타임 데이터* → 1급 관리축화는 오버피팅. **T-B facet 유지 확정.** (판정 상세 = `categories/TP/deepcheck.md` "## 검증 결과 — H-6·H-1".)

## T-C. 페이지 계층(INN_PAGE) — **수량모델(#10)/사이즈(#13) 확장 facet (distinct 거부)**

**정체 후보:** `pdt_prn_cnt_info` MIN/MAX/STEP_INN_PAGE(TPCLECO 2~200·STEP1, TPCLWLB 1) = 캘린더 월수·북 대수 페이지수 입력.

**판정: facet — 수량모델(#10) 다중슬롯 확장 + 제약(#5 min/max/step) (distinct 거부).** INN_PAGE = "내지 페이지수"라는 *수량성 슬롯*으로, ORD_CNT(디자인건수)/PRN_CNT(인쇄수량)/bundle_qty(묶음)과 나란한 **수량모델(#10)의 또 다른 의미 슬롯**(평면화 금지 원칙 동형). 값 범위(min/max/step)는 제약(#5 min-max). **도메인 정합:** seed §3 책자 "내지장수(2~130)" + bridge `num_page·max_page·min_page·unit_page`(에디터 공통 파라미터) = 후니/RP 모두 페이지수를 수량성 입력으로 운영. 가격 결합(TPCLECO tiered_price ↔ INN_PAGE)은 unobserved → 갭 단계. distinct 신축 불요(수량모델이 이미 다중슬롯 축·#10).

## T-D. 티켓 형태 variant(M/I/보딩·캘린더 탁상/벽걸이) — **사이즈/형상(#13) + 칼틀 공정(#2) facet (distinct 거부)**

**정체 후보:** 티켓 M형/I형/보딩, 캘린더 탁상/벽걸이타공/벽걸이걸이 = 형태 variant → 사이즈·칼틀·제본 캐스케이드.

**판정: facet — 사이즈축(#13 형상 흡수) + 칼틀 공정(#2 THO_EXC) + 제본(#2) 캐스케이드 (distinct 거부).** GS THO_CUT 형상 variant(하트/여권 = 사이즈 칼틀 1:1)와 **완전 동형**(reverse §2 note). 형태 = 사이즈 프리셋/칼틀의 enum이지 고유 축 아님(BN 어깨띠 형상=사이즈 흡수 A-3, GS 폰케이스 기종=사이즈 G-3 동일 판정). 형태↔칼틀/사이즈 = 제약(#5 match). 신축은 오버피팅(SKILL §5).

## T-E. 특수인쇄(PRT_WHT/PRT_MAG)·박(TPTKFOI FOI)·미싱/넘버링 — **공정(#2) facet (distinct 거부)**

**판정: facet — 공정 축(#2)의 멤버 (distinct 거부).** ① **PRT_WHT(화이트언더베이스)** = 공정(별색 family·화이트 후공정, 도메인 경계규칙 "별색=공정·잉크색≠자재" 정합·entity-semantic #2). ② **PRT_MAG(메탈릭/마그넷 인쇄)** = 공정(특수인쇄). ③ **박(FOI·TPTKFOI)** = 공정 확정(GS/AC 박 동형). ④ **미싱(절취선)·넘버링(일련번호)** = 공정(#2) + (넘버링이 순차 증분이면 VDP=T-B 데이터바인딩일 수 있음). reverse T-3 "순차/절취 공정축" 가설은 — *절취선*은 공정#2(기존), *순차번호*는 VDP(T-B)/공정#2로 분배되어 **신축 불요**. 단 넘버링 규칙(가변 증분)은 unobserved → 갭 단계 확정(VDP vs 공정 귀속 라이브 확인). **도메인 경계(HARD):** PRT_WHT를 도수(별색)나 자재(백색잉크)로 오적재 금지 — 별색=공정(round-22 경계규칙·메모리 `dbmap-axis-staged-load-round22`).

---

## TP 판정 요약표

| 발굴 | 1차 귀속 | 판정 | distinct/facet | 등재 |
|---|---|---|---|---|
| 에디터 채널(item_gbn+플래그) | **디자인 입력 채널** | 본체와 직교·가격0·비-TP 트윈 대조 | **distinct** ★ | D-11 / #16 |
| 템플릿 자산(koi_template_resource) | D-11 facet + 템플릿#4 이중의미 | 에디터 종속 리소스·#4와 다른의미 | **facet(거부)** ★ | T-A |
| VDP(setVariableData) | D-11 facet × 수량#10 | 에디터 데이터바인딩 | facet(거부) | T-B |
| 페이지계층(INN_PAGE) | 수량#10 + 제약#5 | 수량성 슬롯+범위 | facet(거부) | T-C |
| 형태 variant(M/I/보딩) | 사이즈#13 + 칼틀#2 | 사이즈/형상 흡수 | facet(거부) | T-D |
| 특수인쇄/박/미싱·넘버링 | 공정#2 (+VDP) | 별색=공정 경계 | facet(거부) | T-E |
| 이중수량 ORD_CNT(디자인수) | 수량#10(기존 D-5) | usePDFordCnt 연동 | 기존 흡수 | #10 |
| 제본 쫄대(STA_CLD) | 공정#2+자재#1 bundle | 링/쫄대 consumes | 기존 흡수 | #1·#2 |

**TP 강제 분류 회피(SKILL §3·§5):** distinct 승급 = **D-11 디자인 입력 채널 1종**(BN·GS·TP 세 군 견디는 게이팅 lifecycle + 비-TP 트윈 직접 대조). T-A~T-E는 양면 트레이드오프(특히 T-A 템플릿 자산) 펼친 뒤 facet 강등. 단일 카테고리 전용 축 신설 0건. ★T-A는 침묵 선택 거부하고 "템플릿 이중의미" 명시 분리.

---

## ═══ PR 통합 발굴 (v4.0 — 다면·제본·접지·인쇄방식) ═══

> `categories/PR/reverse.md` P-1~P-9 판정. 4 상품군(BN·GS·TP·PR) 증거. **distinct 승급 0건 — 전부 facet/family/cascade/정책.** 상세 판정 = `_resolved-fragments.md` PR 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(자재 usage_cd 7종·page_rule 엔티티) + reverse 실측(FLD_DFT 7종·제본 5방식·pdtCode prefix). domain-researcher 신규 호출 불요(추정 0).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **P-1** | 접지(FLD_DFT 7종)의 면 인코딩 | 공정#2 family + 파라미터#9 + 제약#5 | 면수=파생값(축 아님)·접지↔오시 cascade·평면 종이 면가공 family | **facet(거부)** |
| **P-2** | 표지/내지 역할 자재 슬롯 | 자재#1 usage_cd 슬롯 | role 전파(자재→도수→가격→평량) 격상·★트레이드오프 | **facet(거부)** ★ |
| **P-3** | 페이지수 INN_PAGE | 수량#10 슬롯 + 제약#5 = page_rule | TP T-C 합류·후니 page_rule 엔티티 정밀 | **facet(거부)** |
| **P-4** | 제본/인쇄방식/도수 분기 | 인쇄방식#12·공정#2·기초코드#6 | 공정방식=상품분기 정책패턴(GS G-2·TP T-4 동류) | **facet/정책** ★ |
| **P-5** | 면지 END_PAP bundle | 자재#1(usage.03)+공정#2 | 컬러지+삽입 bundle(D-2 동형) | **facet(거부)** |
| **P-6** | 규격 vs 면적 경계 | 가격#11 라우팅 + 사이즈#13 | 같은좌표·다른엔진(digital_price/면적) | **facet(거부)** |
| **P-7** | 인쇄방식 종속 자재(YWM) | 인쇄방식#12 → 자재#1 게이팅 | 자재풀 게이팅 관계 간선 강화 | **facet(거부)** |
| **P-8** | 용도별 책자 분류 | 카테고리#7 태그/마케팅 라벨 | 본체 불변·용도 라벨만 | **facet/정책** |
| **P-9** | 스코딕스/레이저커팅 | 공정#2 멤버 (+칼틀 사이즈#13) | 새 멤버 family·축 아님 | **facet(거부)** |

### P-2 양면 트레이드오프 (침묵 선택 거부) ★핵심 의사결정

표지/내지 role(cover/inner)이 자재뿐 아니라 도수·가격·평량제약 *전부를 role-paired*로 전파(`inner_pdt_*` 평행 스키마, F_CVR vs K_INN, COV_MIN_WGT vs INN_MAX_WGT)하는 것을 보고 **별 "역할(role) 차원" 축 신설**(찬성=pricing-role#11처럼 횡단 전파)을 검토했으나 **거부**: role=*새 관리대상이 아니라 기존 usage_cd 차원의 값*(.01내지/.02표지/.03면지)으로, 후니 도메인 권위(`entity-semantic-model.md:23` USAGE 7종)가 이미 슬롯으로 모델링. 도수/가격이 role-paired인 것은 usage_cd가 그 축들로 *전파*된 간선이지 별 축 아님(신축 시 usage_cd와 1:1 중복). **채택=자재#1 usage_cd 슬롯 facet + role 전파 명시 격상**(RP `inner_pdt_*`=usage 슬롯의 물리 구현). PR이 추가한 것 = usage_cd가 "태그"에서 "자재→도수→가격→평량 전파 역할"로 격상됨을 입증(#1·#6·#11·#13 반영).

### P-4 양면 트레이드오프 (정책 라우팅)

책자 19상품(윤전/토너 × 무선/스프링/트윈링/스테플러/실제본 × 컬러/흑백 매트릭스를 개별 pdtCode로 펼침)의 **상품분기 vs 옵션화**는 메타모델 판정 아닌 **후니 카탈로그 정책**(GS G-2·TP T-4 동류). (가) RP 답습(pdtCode 분리·자재풀/가격엔진 다름이 정당화) vs (나) 옵션화(카탈로그 축소·관리용이). 권고 하이브리드: **도수=옵션화(자재풀 동일)·인쇄방식=별 pdtCode(#12 자재풀·가격엔진 게이팅·P-7)·제본방식=캐스케이드 정도 따라**. 메타모델은 양쪽 표현 가능(인쇄방식#12·공정#2·기초코드#6 분배). → gap/실무 정책.

---

## ═══ ST 통합 발굴 (v5.0 — 형상·칼선·재단입자·점착소재·인쇄방식) ═══

> `categories/ST/reverse.md` S-1~S-10 판정. **5 상품군(BN·GS·TP·PR·ST) 증거.** ★**distinct 승급 1종(D-12 형상) = 16축 포화 붕괴 — #17.** 나머지 9 fragment 전부 facet/family/cascade/정책. 상세 판정 = `_resolved-fragments.md` ST 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(형상 G-SK-2·variant 분해·usage_cd·material 두께),pdf-domain-knowledge.md(반칼 PROC_000054·완칼 053·스티커완칼 055·도무송·Case2 스티커 레시피),db-domain-structure-live.md(공정 멤버 트리)}` 실측 — **domain-researcher 신규 호출 불요**(칼선 반칼/완칼/도무송·인쇄방식 UV/DTF·점착 의미 전부 후니 KB에 확정 존재).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **S-1** | 형상(shape_info SQ/CL/EL/RC/FR) | **신규 형상축 #17** | 사이즈와 분리된 전용 enum 슬롯·1:多 칼틀 span·후니 KB G-SK-2 size축 미수용 | **distinct(★#17)** ★ |
| **S-2** | 칼선 2메커니즘(THO_GRA/THO_DFT) | 공정#2 family + 사이즈#13 | 모양커팅 공정의 두 모드·도무송=공정 멤버·프리셋칼틀이 사이즈 겸함 | **facet(거부)** |
| **S-3** | 재단 입자(반칼/완칼/낱장) | 공정#2 멤버 | 반칼=PROC_054·완칼=053·스티커완칼=055 전부 공정 멤버(KB 결정적) | **facet(거부)** |
| **S-4** | 점착/내후 소재(강접/리무버블/옥외/저온/자석/메탈/한지) | 자재#1 합성 차원 | 색상/두께→material 동형·adhesion/weatherability 합성축 추가 | **facet(거부)** ★ |
| **S-5** | 인쇄방식(일반/UV/DTF/후지) | 인쇄방식레시피#12 | PR 윤전/토너/인디고와 합류·pdtCode 분기·자재풀/도수/화이트/가격엔진 게이팅 | **facet(거부·PR P-4/P-7 합류)** |
| **S-6** | 판/die-cut/정가 3가격엔진 | 가격#11 라우팅 | digital_price/vTmpl/tmpl(PR P-6·GS G-7 합류) | **facet(거부)** |
| **S-7** | 화이트강제(PRT_WHT 일반선택/DTF강제) | 공정#2 + 제약#5 | 별색=공정·DTF→화이트 force cascade(TP T-E 합류) | **facet(거부)** |
| **S-8** | disable_pcs 227건 룰엔진 | 제약#5 disable | BN 강제·PR 24건의 정점 케이스·룰엔진 일반화 검증 | **facet(거부·#5 정점)** |
| **S-9** | 넘버링(NUM_DFT 가변 일련번호) | 공정#2 (+VDP#16) | TP T-3/T-E 동형·절취=공정·순차=VDP/공정 | **facet(거부)** |
| **S-10** | 완제SKU형(테이프/밴드/카드스티커) | 템플릿#4 + 생산형태#15 | GS tmpl 완제SKU 합류·die-cut/판도 아닌 규격 완제 | **facet(거부)** |

---

## D-12. 형상 축 (Shape) — distinct ✅ (ST 신축·#17) ★16축 포화 최초 붕괴

**정체:** 인쇄물의 *외곽 형상*(사각/원형/타원/사각라운드/자유형)을 사이즈와 *분리된 전용 enum 슬롯*으로 관리하는 축. 형상이 ① 칼틀(THO_DFT) enum의 *부분집합을 게이팅*하고 ② 자유형(FR)이면 자유칼선(THO_GRA)을 강제하며 ③ 상품 분기(원형=STTHCIC)와 한상품 옵션(STDCFBR 5형상)을 모두 인코딩.

**증거(ST — ★직접 실측):**
- **전용 슬롯:** `option_info.shape_info`가 형상 코드(SQ/CL/EL/RC/FR)를 *옵션 트리 밖 별도 슬롯*으로 보유(reverse §0.1·§1·§2 실측). 자재/사이즈/공정과 다른 인코딩 위치.
- **★형상↔사이즈 1:多 (distinct 핵심):** 한 형상이 *다수 칼틀/사이즈를 span* — CL 원형 → THO_DFT/CL001~CL010(10X10~100X100) + CLFRE(자유원형), RC 사각라운드 → RC001~RC025(40X20~100X100) + RCFRE(reverse §0.2 실측). 즉 형상은 사이즈 프리셋의 *상위 분류자*이지 사이즈 자체가 아님.
- **★5형상 superset 1상품:** STDCFBR(패브릭 데코)가 SQ/CL/EL/RC/FR *5형상 전부*를 한 상품에 담음(reverse §0.1) — 형상이 사이즈와 독립한 *선택 차원*임을 단일 상품으로 입증(형상=사이즈면 한 상품에 5사이즈군이 공존할 수 없음).
- **형상→칼선 게이팅:** shape=FR이면 칼선이 THO_GRA(자유 도무송)로 자동 강제(VIEW_YN=N), shape=SQ/CL/RC면 THO_DFT(형상별 프리셋칼틀)로 강제(reverse §0.1·§0.2). 형상이 칼선 메커니즘을 결정.

**도메인 정초(후니 KB 권위 — ★결정적):**
- `entity-semantic-model.md:39` **"size축에 형상 enum drop(sticker G-SK-2): 도형/치수 enum(원형 25~90mm)이 *어느 축에도 없음*"** — 후니 자신이 형상 enum을 담을 축이 부재함을 결함으로 명시. = 사이즈축(#13)이 형상을 *왜곡 없이 못 담음*의 1급 증거(distinctness test §3 충족).
- `entity-semantic-model.md:22` size = "재단치수(고객 선택 완성품 치수)" — 치수(width×height)이지 *형상(원/사각)*이 아님. 형상은 치수의 상위 분류이며 별 의미축.

**distinctness(distinctness test §3) — 적대 판정:**
- **vs 사이즈축(#13)[핵심 반론 검토]:** 기존 메타모델은 형상을 *사이즈에 흡수*해왔다 — 어깨띠(A-3 "폭좁고 김"=사이즈), GS THO_CUT(하트/여권=칼틀↔사이즈 1:1), TP 티켓 M/I/보딩(T-D=사이즈/칼틀 1:1). **이 흡수의 전제 = "형상=사이즈 프리셋 1:1"**. ST가 이 전제를 깬다: 형상↔사이즈 **1:多**(CL 형상 1개 ↔ CL001~100 칼틀 10+종), 전용 `shape_info` 슬롯, 5형상 superset. 사이즈축으로 형상을 표현하면 "원형이라는 사실"을 매 사이즈 프리셋에 중복 인코딩해야 함(정규화 붕괴) → 형상은 사이즈의 *상위 분류축*이지 흡수 대상 아님. **단 이전 BN/GS/TP/PR 흡수 판정을 번복하지 않음** — 그들은 진짜 1:1(형상이 사이즈 프리셋 1개와 동치)이라 사이즈 흡수가 정당. ST만 1:多 분리가 *명시 슬롯으로* 드러나 distinct 승격. (메타모델 정답: 형상축은 1:1이면 사이즈에 흡수 표현·1:多면 별 분류 슬롯 — ST가 후자를 강제.)
- **vs 기초코드(#6):** 형상 enum 자체는 기초코드 도메인(코드값 거버넌스). 그러나 형상은 *칼선/사이즈/칼틀을 게이팅하는 분류 lifecycle*을 가짐(단순 코드 도메인 아님) → 기초코드는 형상의 *값 도메인 공급자*이지 형상의 게이팅 관계를 못 담음.
- **vs 공정(#2 칼선):** 형상은 칼선을 *게이팅*(FR→THO_GRA, SQ→THO_DFT)하나 칼선 자체는 아님. 형상=분류(무엇을 만드나)·칼선=공정(어떻게 자르나). 별 lifecycle.
- **lifecycle:** 형상이 (a) 칼틀 enum 부분집합(b) 칼선 메커니즘(c) 사이즈 입력 모드(자유형=자유사이즈/정형=프리셋)를 게이팅. 1상품에 형상 1개(상품분기) 또는 N개(STDCFBR 옵션) — 인코딩 유연. 기존 어느 축도 이 게이팅을 단독으로 못 함.

**오버피팅 검토(SKILL §5):** ST 단일 카테고리지만 — ① **STDCFBR 5형상 superset** 단일 상품 내 입증(형상=옵션 차원) ② **전용 `shape_info` 슬롯**(RP가 형상을 사이즈와 분리해 1급 슬롯화) ③ **후니 KB가 형상 enum 미수용을 결함으로 명시**(G-SK-2 — 단일 상품 사유 아닌 도메인 1급 갭) ④ 형상은 BN 어깨띠·GS 하트·TP 티켓·PR 카드형에도 *값으로* 존재(전 카테고리 횡단)이나 ST가 그것을 *사이즈와 분리해 전면화*. → 단일상품 아님, distinct 정당. **단 1:1 흡수 가능 카테고리(BN/GS/TP/PR)는 사이즈 표현 유지** — 형상축은 1:多 분리가 필요한 곳(ST·도무송 자유형·칼틀 enum 깊은 상품)에서만 별 슬롯.

**관계:**
- Shape → Product(classifies — 상품분기 1:1 또는 한상품 N형상 옵션).
- Shape → SizePreset(#13, **gates** — 형상이 칼틀/사이즈 프리셋 부분집합 결정: CL→CL001~100).
- Shape → ProcessMember(#2 칼선, **gates** — FR→THO_GRA 자유칼선·정형→THO_DFT 프리셋칼틀).
- Shape → 사이즈 입력모드(자유형=nonspec 자유사이즈·정형=프리셋 enum).
- Shape ⊂ 기초코드(#6, 값 도메인 공급).

**★후니 갭(갭분석가 주목):** 후니 t_*에 "형상" 그릇 **부재 확정**(KB G-SK-2가 "어느 축에도 없음" 명시). 도형/치수 enum(원형 25~90mm)이 size축에 drop됨 = vessel-gap. 갭분석가가 라이브 information_schema에서 shape 컬럼/테이블 유무 확인 + 형상이 칼틀(완칼 PROC_053 `모양`·반칼 PROC_054 `모양`)과 어떻게 연결되는지(형상→칼틀 게이팅 그릇) 설계 필요. **단 1:1 흡수 카테고리는 size 프리셋 유지(형상축 강제 적용 금지·오모델 회피).**

---

## 종합 — 7버킷 재평가

| 7버킷 | 발굴로 인한 재평가 |
|---|---|
| 자재 | **심화** — 단순 enum이 아닌 합성+usage+공정결합 메타규칙(D-2) |
| 공정 | **확장** — 자재소비 플래그(D-2) + 파라미터 종속(D-4) |
| 옵션 | **분화** — 수량은 별도 다중슬롯 모델(D-5), 파라미터는 공정종속(D-4)로 분리 |
| 템플릿/SKU | **인접 축 분리** — 부속물(D-1)은 별개(템플릿=번들단위, 부속물=부품) |
| 제약 | **유형화** — 객체가 아닌 6 논리유형 거버넌스(D-3) |
| 기초코드 | (유지) — enum 도메인 거버넌스, 사이즈 프리셋·도수 enum. GS: 도수 enum에 SID_X(무인쇄·텀블러) 확인 |
| 카테고리 | **GS 보강** — 공통 기능 그룹화(코스터 6 pdtCode=1 노드) 확인. 생산형태는 직교 distinct로 분리(D-9) |
| 신축(GS) | **생산형태(D-9)·본체 형태가공(D-10)** — 완제/입체 굿즈가 드러낸 distinct 2축 |
| 템플릿/SKU | **TP 이중의미 분리** — #4=완제SKU 번들(주문단위) vs TemplateAsset=에디터 디자인 시안(D-11 종속·가격0). 같은 단어 다른 의미 명시(T-A) |
| 신축(TP) | **디자인 입력 채널(D-11)** — KOI/Edicus/PDF 에디터 채널이 본체 옵션과 직교한 입력 레이어. 가장 강한 vessel-gap |
| 사이즈/기초코드 | **★ST 형상축 분리** — 사이즈#13가 형상을 1:1 칼틀로 흡수해온 전제가 ST에서 1:多로 깨짐(CL→CL001~100). 형상=사이즈 상위 분류축(D-12·#17). 후니 KB G-SK-2 "형상 어느 축에도 없음" 확증 |
| 신축(ST) | **★형상(D-12·#17)** — 전용 shape_info 슬롯·형상↔사이즈 1:多·5형상 superset. **16축 포화 붕괴**(5번째 카테고리가 distinct 1종 도입·오버피팅 아님) |

**TP로 해소/추가된 갭:** ① **디자인 입력 채널 = 1급 distinct 축 확정**(비-TP 트윈 HLCLSTD 직접 대조 + huni-widget RedEditorSDK 계약). ② **템플릿 이중의미 분리**(완제SKU vs 에디터 디자인 자산) — 후니 `t_prd_templates` 매핑 시 혼동 방지. ③ **여전히 미관측(TP):** 템플릿 자산 카탈로그·VDP 변수 스키마(`koiOption[]` 빈배열·로그인 에디터 필요)·티켓 넘버링 규칙(VDP vs 공정 귀속)·INN_PAGE↔가격 결합 → 갭/검증 단계로 라우팅.

**PR로 해소/추가된 것 (v4.0):** ① **16축 포화 입증** — 4번째 카테고리가 distinct 신축 0 → 모델이 RedPrinting 카탈로그 shape를 견딤(강한 검증). ② **공정#2 "접지(folding)" family** — BN/GS/TP 미발굴 평면 종이 면가공(2단=4면…) + 접지↔오시 동반 cascade 신규 등재. ③ **자재#1 usage_cd 역할 전파 격상** — BN substrate 단일·GS 다중슬롯에서 PR이 표지/내지를 *별 평행 스키마(`inner_pdt_*`)*로 구현 + role이 도수/가격/평량으로 전파됨을 입증(usage_cd=태그→전파 역할). ④ **page_rule 엔티티 정밀** — INN_PAGE=수량#10 슬롯이자 후니 `_page_rules`(min/max/incr) 별 엔티티(TP T-C 합류). ⑤ **인쇄방식#12 자재풀 게이팅** — 윤전→YWM pool(가능 공정뿐 아니라 가능 자재 부분집합도 게이팅). ⑥ **가격#11 digital_price 라우팅** — 같은 좌표(CUT_WDT/HGH) 입력이 포스터=digital_price(규격/자유)·BN=면적매트릭스로 분기(pricing_model 5종).

**GS로 해소된 BN 갭:** ① **자재 usage 다중슬롯** — GS 스프링노트(표지+내지+링) 실관측으로 BN substrate 단일 한계 해소(#1 GS 확인 ✅). ② **생산형태** — GS C 완제품 다수 노출로 distinct 확정(D-9·도메인 권위 C-9 정합). ③ **완제 SKU 본체 모델링** — GS DIR_MTR로 패턴 확정(G-1 facet 판정).

**ST로 해소/추가된 것 (v5.0·★포화 붕괴):** ① **16축 포화 붕괴 — 형상축(#17) distinct 승격** — 5번째 카테고리(ST)가 새 관리축 1개 도입. PR(v4.0)이 입증한 16축 포화를 ST가 정직하게 깸. 이는 오버피팅이 아니라 *사이즈축이 형상을 1:1 칼틀로 흡수해온 전제가 ST의 전용 shape_info 슬롯·형상↔사이즈 1:多로 깨진* 증거 강제 결과. **단 PR 포화 입증(distinct 0)도 여전히 유효** — PR은 형상을 1:1로만 가져 흡수가 정당했고, ST가 1:多 분리를 *명시 슬롯으로* 드러내 차이를 만듦(모델 진화는 카테고리 증거에 정직). ② **칼선/재단입자=공정#2 family 확정** — THO_GRA/THO_DFT·반칼/완칼이 후니 KB(PROC_053/054/055·도무송)로 공정 멤버 확정(신축 거부·도메인 권위 결정적). ③ **점착/내후=자재#1 합성 차원 추가** — adhesion/weatherability가 색상/두께처럼 material 합성축(자재#1 강화·신축 아님). ④ **인쇄방식 횡단 통합** — ST 일반/UV/DTF/후지 + PR 윤전/토너/인디고가 #12 "인쇄방식=상품분기" 횡단 패턴 합류(S-5↔P-4/P-7). ⑤ **disable 룰엔진 정점(227건)** — ST disable_pcs가 BN 강제·PR 24건의 정점 케이스로 #5 룰엔진 일반화 검증(S-8).

**여전히 미발굴(2 상품군 한계):** ① **카테고리 트리 깊이/다중분류** — GS도 옵션 트리 라이브 추출 불가(신규 Vue client-render)로 다중분류(한 상품 여러 트리) 직접 미관측. ② **템플릿 template_selections 구조** — 완제 SKU 번들 구성 선택 묶음 상세(봉투결합 엽서·OTC) 미관측. ③ **코드 채번 거버넌스** — pdtCode/PCS_COD/DTL 채번 규칙. → 책자(booklet, A통합+B셋트 명시)·문구(stationery) 샘플로 확대 권고.

---

## ═══ PD 통합 발굴 (v8.0 — 봉제 구조물 완제품·조립·3D폼·단수·완제 내재BOM) ★조립 distinct(#18) 적대 판정·재포화 ═══

> `categories/PD/reverse.md` PD-1~PD-5 판정. **8 상품군(BN·GS·TP·PR·ST·CL·AC·PD) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 4번째·CL 6번째·AC 7번째 패턴 반복).** PD reverse가 1차 예측한 "distinct 0(8번째 재포화)"를 적대 판정으로 비준 — 가장 이질적인 *봉제 구조물 완제품*(스툴·슬리퍼·강아지계단)조차 17축 무손실 흡수. PD-1~PD-5 전부 기존 17축 facet/family/cascade로 분해. 상세 판정 = `_resolved-fragments.md` PD 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(addl_product 부속물·생산방식 A/B/C·자재 usage·두께=자재) + AC §0.3(입체/스탠드 분산 facet)·GS(완제 본체 G-1·형태가공 D-10/#14)·ST(형상#17) 직접 대조. **★domain-researcher 신규 호출 불요** — 봉제/제품가공(=공정#2/형태가공#14)·완제 구조물 BOM(=부속물#8+생산형태#15+가격#11)·단수(=사이즈#13 프리셋)가 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PD 핵심 판정 — directive 최대 관전(조립·구조·3D폼·완제 내재BOM): distinct #18 부결(전부 기존 축).** PD가 던진 진짜 질문은 새 옵션축이 아니라 "완제품 내재 제조레시피를 옵션과 분리해 어디에 두는가"(PD-4) — 답=**부속물#8 + 생산형태#15 + 가격#11(tmpl)이 분담**(별 "완제 BOM 축" 불요). 봉제=형태가공#14(GS D-10 이미 distinct, SEW_LTR=새 family 멤버)·단수=사이즈#13 프리셋·3D폼=AC §0.3 분산 facet 동형.

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **PD-1** | 봉제/제품가공(SEW_LTR·PDT_WRK) | 본체 형태가공#14(GS D-10) + 공정#2 | SEW_LTR=#14 봉제 family 신규 멤버·PDT_WRK=GS 동형·기존 PCS 슬롯 인코딩 | **facet(거부)** ★ |
| **PD-2** | 직물/PU 원단 자재(종이 아님) | 자재#1 PTT 차원 값 확장 | AC 아크릴·CL 의류원단 동형·비종이 자재 이미 다 관측·면10수=수단위 평량 다형성 | **facet(거부)** |
| **PD-3** | 단수(2단/3단)·스툴 형상 | 사이즈#13 프리셋 흡수 | 단수=구조이나 사이즈 프리셋 1:1 인코딩·형상=ST 1:多 미충족(원형↔305×305 1개) | **facet(거부)** ★ |
| **PD-4** | ★완제 구조물 내재 제조BOM(다리/받침/솜/지퍼/논슬립) | 부속물#8 + 생산형태#15 + 가격#11(tmpl) | 옵션 미노출=고정 제조사양·후니 KB "완제 BOM 어느 축에도 없음" 결함 부재(addon/usage/생산형태 담음)·형상#17과 정반대 | **분산 facet(거부·#18 부결)** ★강후보 |
| **PD-5** | 모양커팅 enum·추가부자재 enum·가격 결합 | 공정#2(THO_CUT)·부속물#8(SUB_MTR)·가격#11 | infoCall 후행 unobserved·축 판정 무영향(SSR 슬롯으로 확정) | **facet(거부·unobserved)** |

### PD-4 양면 트레이드오프 (침묵 선택 거부) ★directive 핵심 의사결정 — 완제 구조물 내재BOM

PD reverse가 명시한 directive 핵심: "후니가 완제 구조물(스툴/슬리퍼/반려동물용품)을 취급하려면 *고정 제조 BOM*(다리 종류·솜 충전·논슬립 원단)을 어딘가 관리해야 — 옵션으로는 안 띄우되 생산정보로는 보유. 별 '완제 구조물 BOM' 그릇이 필요한가 = vessel-gap 후보." 적대 판정:

- **(가) distinct "완제 구조물 내재BOM 축 #18" 신설:**
  - 찬성: 봉제 구조물의 고정 부품(다리/받침/솜/지퍼/논슬립)이 옵션 슬롯에 *없으면서도* 생산정보로 존재 — 옵션축(노출)·자재축(본체 substrate)·공정축(작업)이 "옵션 미노출 고정 제조 부품 명세"를 직접 담지 않음. RP가 마케팅 카피로만 둠 = 관리 그릇 부재 신호(ST 형상 shape_info 전용 슬롯처럼 "전용 관리 대상" 가설).
  - 반대: ★세 갈래로 무손실 분해 — distinct가 요구하는 "기존 축이 *왜곡 없이* 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 완제 부속 부품(다리·받침·논슬립 패드)** = **부속물 축#8**(addl_product). 후니 KB `entity-semantic-model.md:30` "addl_product(`_addons`) 추가상품(완제 부속: 거치대·우드봉·볼체인)·부착공정(process)과 축 분리" — 다리/받침/논슬립도 *본체와 분리된 완제 부속 부품*으로 부속물#8이 왜곡 없이 담음(BN 거치대·AC 등신대 받침 횡단 동형). 옵션 미노출=부속물의 *고정(필수 ESN=Y·고객 미선택)* facet이지 새 축 아님(AC 받침 ESN=Y 동형).
    - **② 솜 충전·지퍼·논슬립 원단** = **자재#1 sub_mtrl(usage_cd 슬롯) + 공정#2(봉제 consumes)**. 솜=충전 자재(usage), 지퍼=FLX_ZIP consumes 부자재(GS D-10 형태가공 #14 자재소비 동형), 논슬립 원단=바닥 자재행. 후니 자재 usage_cd 7종 + 공정 consumes FK(D-2)가 담음.
    - **③ "옵션 미노출 고정 제조" 성격 자체** = **생산형태#15(C 완제품) governing + 가격#11(tmpl_price 완제 단가)**. 완제품(C)은 본체 모델링을 *완제 SKU*로 governing(GS D-9)·내재 BOM은 그 완제품 정체에 묶인 *고정 레시피*. tmpl_price가 "내재 BOM 포함 완제 개당단가"를 담음(BN 면적가와 다른 완제 SKU 가격). 즉 "옵션 미노출"은 생산형태#15가 결정하는 *본체 모델링 결과*(완제품→내재 BOM 고정)이지 별 관리 축이 아님.
- **(나) 부속물#8 + 자재#1/공정#2 + 생산형태#15 + 가격#11 분산 facet [채택]:** 완제 구조물 내재BOM = 네 기존 축의 결합(부속 부품=#8·sub자재/봉제=#1/#2·완제품 governing=#15·완제 단가=#11). PD가 더한 것 = 부속물#8이 "고정(미노출·ESN=Y) 완제 부속"까지 포함함을 입증(AC 받침 ESN=Y 합류)이지 새 *축* 아님.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·완제 내재BOM은 부결(역방향 오류 점검):** 형상(#17)은 *사이즈축(#13)이 형상을 1:1 칼틀로 흡수해온 전제가 ST 1:多로 깨져* 기존 축이 *왜곡 없이 못 담음*이었고, **후니 KB G-SK-2 "형상 enum 어느 축에도 없음"이 결함으로 명시**되어 distinct가 강제됐다. 완제 내재BOM은 **정반대** — 후니 KB가 완제 부속(addl_product #9·`:30`)·자재 usage(#2·`:23`)·생산방식 A/B/C(#15·`:113`)를 *이미 1급으로 모델링*하며, "완제품 고정 BOM이 어느 축에도 없음" 같은 결함 명시 **없음**(부속물·usage·생산형태가 왜곡 없이 담음). → 형상=축 부재(distinct)·완제 내재BOM=축 충분(facet). **역방향 오류(distinct를 facet으로 숨김) 점검:** "옵션 미노출 고정 부품 명세"가 유일 잔여 후보였으나, 부속물#8의 *고정(ESN=Y·고객 미선택) 완제 부속* facet(AC 등신대 받침 ESN=Y 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음). **단 vessel 단계 주목:** RP가 내재BOM을 마케팅 카피로만 두는 것은 *부속물#8/생산 BOM 그릇에 적재해야 할 데이터를 미적재*한 것(관리 축 부재가 아니라 데이터 갭) — 후니가 완제 구조물 취급 시 부속물#8(다리/받침/논슬립·고정 ESN=Y)·자재 usage(솜/지퍼)에 적재 = **data-gap이지 vessel-gap 아님**(갭분석가 주목).

### PD-1 봉제/제품가공 = 본체 형태가공#14(GS D-10) family 멤버

SEW_LTR(레더재봉)·PDT_WRK(제품가공)은 평면 원단/인쇄물을 *봉제·조립해 입체 완제 구조물 본체를 생성* — GS D-10(#14 본체 형태가공·PDT_WRK 파우치가공/FLX_ZIP 지퍼)과 **동일 lifecycle**(본체 형태 자체를 생성·없으면 본체 부재). PD-1 = **#14 형태가공 축의 새 family 멤버(SEW_LTR 봉제)** 추가이지 새 축 아님. PDWRSLP PDT_WRK는 GS PDT_WRK와 *동일 코드*(슬리퍼 조립 마감)·PDCHSTL/PDSRPPY SEW_LTR(레더재봉)은 #14에 "봉제(sewing)" family 멤버 신규 등재. THO_CUT(모양커팅)=공정#2(ST/GS 동형)·SUB_MTR(추가부자재)=부속물#8(AC/ST 동형). PD가 #14를 입증 강화(GS 굿즈 형태가공이 봉제 구조물 완제품으로 횡단 확장).

### PD가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC 패턴 반복)** — 8번째 카테고리(봉제 구조물 완제품)가 distinct 신축 0 도입. PR(4번째 0)→ST(5번째 형상 1)→CL(6번째 0)→AC(7번째 0)→**PD(8번째 0)** = 모델 안정성 재확인. 가장 이질적인 봉제 구조물(스툴/슬리퍼/계단)조차 17축 무손실 흡수.
2. **본체 형태가공#14 봉제 family 확장** — GS PDT_WRK/FLX_ZIP(파우치/지퍼)에 SEW_LTR(레더재봉) 봉제 멤버 추가. #14가 굿즈→봉제 구조물 완제품 횡단 입증.
3. **부속물#8 "고정(미노출·ESN=Y) 완제 부속" facet** — 완제 구조물 내재BOM(다리/받침/논슬립)이 부속물#8의 고정 부속(고객 미선택·AC 등신대 받침 ESN=Y 동형). 옵션 미노출이 부속물의 필수성 차원.
4. **자재#1 비종이 원단 차원 확장** — 면10수/슬리퍼원단/PU폴리우레탄(직물·합성수지) = AC 아크릴·CL 의류원단 합류. 면10수="수(번수)"단위 평량 다형성(AC mm 두께·종이 g 평량 동류 WGT 다의성).
5. **사이즈#13 단수/구조 프리셋 흡수 입증** — 계단 2단/3단(층수=구조 요소)이 사이즈 프리셋 1:1(2단=495×320) 인코딩 → *구조 distinct 부결의 결정적 증거*(형상#17과 달리 1:多 분리 없음).
6. **생산형태#15 + 가격#11(tmpl) 완제품 governing 재확인** — 봉제 구조물=C 완제품(tmpl_price)·내재 BOM 고정·옵션 미노출. GS 완제 굿즈 governing 패턴 합류.

## ═══ CL 통합 발굴 (v6.0 — 의류 variant·인쇄위치·인쇄방식·size×color 매트릭스) ═══

> `categories/CL/reverse.md` C-1~C-9 판정. **6 상품군(BN·GS·TP·PR·ST·CL) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 패턴 반복).** CL reverse가 강하게 제기한 "의류 variant=#18 후보"는 **facet 클러스터**로 강등(GS variant 축의 2D 일반화). 9 fragment 전부 기존 17축 facet/family/matrix/정책. 상세 판정 = `_resolved-fragments.md` CL 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(본체색→자재 CLR·variant 분해·material usage·생산방식),pdf-domain-knowledge.md(별색=공정),db-domain-structure-live.md}` + GS reverse(variant 3채널 G-4·완제 본체 G-1) 직접 대조. **★domain-researcher 신규 호출 불요** — 의류 인쇄방식(전사/실크/나염/DTF=공정#2/인쇄방식#12)·size×color SKU(=사이즈#13×색상자재CLR Cartesian)·Pantone(=별색=공정#2·round-22 경계)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★CL 핵심 판정: 의류 variant = facet (distinct #18 거부).** "clothes2025 별도 분기 + apparel_info 전용 그릇 + size×color 2D 매트릭스 + Pantone 1124 + 인쇄위치 6 + 인쇄방식 3"이라는 의류 차원군 전체가 **기존 축으로 무손실 분해** — item_gbn=구현 discriminator(정책패턴·PR P-4 동형), apparel_info=구현 컨테이너 뷰(여러 기존 축을 담음·D-8 동형), size×color matrix=사이즈#13×색상(자재 CLR #1) Cartesian + 셀가용성=제약#5(ST S-8 disable 227 정점의 2D판). distinct를 강요하면 자재/사이즈/색/공정/제약을 "의류"라는 카테고리 라벨 아래 중복 재포장 = 오버피팅. **단 [HARD] G-1 동형 분해 요구: MTRL_COD를 {fabric/PTT, color/CLR, size/WGT}로 분해(평면 라벨 금지).**

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **C-1** | apparel_info 전용 구조(6키) | 구현 컨테이너 뷰(여러 축 담음) | print_type→#12·area→#2·color→#1CLR·size→#13·size_color→#1matrix+#5·pantone→#2별색 | **facet(거부·D-8 동형)** |
| **C-2** | ★의류 variant #18 후보 | 자재#1+사이즈#13+색상#1CLR+제약#5 클러스터 | GS variant(G-4)의 2D 일반화·item_gbn=정책·apparel_info=컨테이너 | **facet(거부·#18 부결)** ★ |
| **C-3** | size×color → MTRL_COD 매트릭스 | 자재#1(SKU matrix facet)+사이즈#13×색상+제약#5 | 사이즈×색 Cartesian·셀 MTRL_COD=G-1 본체 SKU 동형·셀가용성=#5 | **facet(거부·HARD 분해)** ★ |
| **C-4** | 인쇄위치(print_area 6·다중) | 공정#2 멀티슬롯 + #11 + #16 KOI매핑 | 위치별 PDT_WRK 가산·GS 귀돌이 4슬롯/ROP 동형 | **facet(거부)** |
| **C-5** | 카테고리 내부 2모델(clothes2025/tmpl) | 생산형태#15 + item_gbn 정책 discriminator | 본체정체가 가격/옵션 패러다임 결정=생산형태·item_gbn=구현 | **facet(거부)** |
| **C-6** | 인쇄방식(실크/전사/DTF/나염) | 인쇄방식레시피#12 (PR P-4/ST S-5 합류) | 상품내 옵션 인코딩(ST/PR=상품분기)·#12 양면표현 | **facet(거부·#12 합류)** |
| **C-7** | Pantone 1124 별색 | 공정#2 별색 family + 기초코드#6 도메인 | 실크인쇄 spot color·별색=공정(round-22)·1124=#6 거버넌스 | **facet(거부)** |
| **C-8** | GBN(adult/child) | 사이즈#13 + 기초코드#6 하위속성 | 사이즈 enum의 연령 분류 속성·단체티만 child 활성 | **facet(거부)** |
| **C-9** | CLST 가방/모자/에이프런 모델 | 생산형태#15 + 카테고리#7(경계) | 비의류=tmpl 굿즈형·CL 카테고리 내 비의류=카테고리 경계 | **facet(거부)** |

### C-2 양면 트레이드오프 (침묵 선택 거부) ★최대 directive 의사결정

CL reverse가 "의류 variant = distinct #18"를 ① item_gbn=clothes2025 별도 분기 ② apparel_info 전용 그릇 ③ size×color 2D 매트릭스(GS 단일 DTL 초과) ④ Pantone 1124·인쇄위치 6·인쇄방식 3 의류 전용 차원군 네 근거로 강하게 제기. 적대 판정:

- **(가) distinct "의류 variant 축 #18" 신설:**
  - 찬성: 그릇(item_gbn=clothes2025)·차원(size×color·위치·방식·Pantone)이 GS variant(tmpl/vTmpl·3채널)와 *별도 분기*로 보임. apparel_info가 BN/GS/TP/PR/ST 전무한 전용 구조. reverse §15 #1~4가 "vessel-gap 정점·distinct 가설 강화" 제기.
  - 반대: ★네 근거 전부 *기존 축의 표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 왜곡 없이 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① item_gbn=clothes2025** = RedPrinting의 *구현 discriminator*(어느 가격 SP·어느 옵션 skin을 쓸지 선택하는 분기 키)이지 관리 축이 아님. PR "인쇄방식=pdtCode 분기"(P-4)·ST "인쇄방식=상품분기"(S-5)·GS "DIR_MTR vs ORD_INFO 본체 위치"(G-1)와 **정확히 동형인 정책/구현 패턴**(dictionary 명제 #19 "공정방식이 상품을 가른다=정책"). 메타모델 명제 #20(PR distinct 0)이 이미 "분기 discriminator는 축 아님"을 확정.
    - **② apparel_info 전용 그릇** = *구현 컨테이너 뷰*(skinInfo에서 paper/size/dosu를 view_yn=N으로 숨기고 6키로 재담음). 6키는 깔끔히 분해: print_type→#12·print_area→#2(+#16 KOI)·apparel_color→#1 CLR·size_info→#13·size_color_info→#1 SKU matrix+#5·pantone→#2 별색. **컨테이너는 축이 아니다** — D-8(UI 런타임=facet) 판정과 동근(같은 base-data를 다른 구조로 담을 뿐).
    - **③ size×color 2D 매트릭스** = 두 *기존 축*(사이즈#13 × 색상[자재 CLR·D-2 "본체색=자재 CLR"])의 **Cartesian product + 셀별 가용성**. 셀→MTRL_COD 해소는 G-1 "완제 본체 SKU=자재 facet"(PCS_DTL_NME 라벨 융합)의 의류판(2D). 227셀 HIDE_YN/QUICK_ORD_YN 셀가용성 = **제약#5의 2D 정점**(ST disable 227건=#5 정점·S-8과 동일 규모/패턴). 2D-ness는 *cardinality 속성*이지 새 관리 관심사 아님 — GS G-4가 variant 1D-per-channel을 facet 강등했듯 CL은 *2D matrix*이나 동일하게 기존 축으로 분해.
    - **④ Pantone/위치/방식** = 전부 기존 축: Pantone=별색 공정#2(C-7)·위치=공정#2 멀티슬롯(C-4·GS 귀돌이 4슬롯 동형)·방식=인쇄방식#12(C-6·PR/ST 합류).
- **(나) facet 클러스터 — GS variant(G-4) 축의 2D 일반화 + G-1 본체 SKU + #5 셀가용성 정점 [채택]:** 의류 variant = 자재#1(size×color SKU matrix·본체 fabric)·사이즈#13·색상(자재 CLR)·제약#5(셀가용성 227)·인쇄방식#12·공정#2(위치·별색)의 *결합*. GS variant와의 관계 = **CL은 GS variant 인코딩의 2D 일반화** — GS는 variant를 1D-per-channel(DTL/ATTB/CUT·G-4)로 해소, CL은 2D 매트릭스(size×color→단일 MTRL_COD)로 해소. 둘 다 같은 기존 축으로 분해되는 facet이며, CL이 더한 것은 *2D cardinality + 셀별 가용성 정점*(새 축 아님).

**판정: facet — distinct #18 거부.** 의류 variant는 GS variant 축의 facet(2D 일반화)이며, 어느 단일 축의 facet이 아니라 **자재#1 + 사이즈#13 + 색상(자재 CLR) + 제약#5 의 facet 클러스터**(주 귀속=자재#1 SKU matrix·G-1 동형). **★[HARD] G-1 동형 분해 요구:** MTRL_COD(SXSRT326="6.2oz 프리미엄 화이트 L")를 `{body_fabric/PTT, body_color/CLR, size/WGT}`로 분해(평면 SKU 라벨=의미축 drop). 이것이 후니 굿즈 본체소재 부재 결함(round-22 GPM)의 의류판 정답이며 GS G-1과 동일 처방. **역방향 오류 점검:** distinct를 facet으로 숨기는 오류 여부 — size×color 셀가용성 매트릭스가 유일한 잔여 후보였으나 ST S-8(disable 227=#5 정점)과 동일 패턴으로 제약#5에 무손실 흡수(2D subject). 기존 축이 *왜곡 없이* 담음 → facet 정당(숨김 아님).

### CL이 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR 패턴 반복)** — 6번째 카테고리(의류)가 distinct 신축 0 도입. PR(4번째·distinct 0)이 입증한 포화를 ST(5번째·형상 1종)가 깼으나, CL(6번째)이 다시 distinct 0으로 **모델 안정성 재확인**. 의류처럼 "전용 그릇(apparel_info)·전용 모델(clothes2025)"을 가진 가장 이질적으로 보이는 카테고리조차 17축으로 무손실 흡수 = 강한 검증 신호.
2. **자재#1 size×color 2D SKU 매트릭스 facet** — GS variant 1D-per-channel(G-4)의 2D 일반화. 셀→단일 MTRL_COD(G-1 본체 SKU 라벨 융합 동형) + 셀별 가용성(#5 정점).
3. **제약#5 2D 셀가용성 정점** — 227셀 size×color HIDE_YN/QUICK_ORD_YN = ST disable 227(S-8)과 동일 규모, 단 2D subject(사이즈×색 axis-pair). 제약#5 룰엔진의 2D 일반화 검증.
4. **인쇄방식#12 "상품내 옵션" 인코딩 추가** — ST/PR(상품분기 pdtCode)와 달리 CL은 한 상품 안 ORD_INFO.PRINT_TYPE 차원(DTF/직접/실크 택1). #12가 (a)자재 facet(BN 수성/라텍스) (b)상품분기(ST/PR) (c)상품내 옵션(CL) 3표현을 가짐을 확정(양면→삼면 표현).
5. **공정#2 인쇄위치 멀티슬롯 facet** — print_area 6위치 다중선택·위치별 PDT_WRK 가산(#11)·KOI_NME→입력채널#16 에디터 매핑. GS 귀돌이 4슬롯·ROP 동형.
6. **카테고리#7 경계 명시** — CL 카테고리 안에 비의류(가방/모자/에이프런=tmpl 굿즈형) 포함 = 카테고리=기능 트리이나 생산형태#15(item_gbn)가 본체 그릇 결정. 카테고리⊥생산형태(#15·D-9) 재확인.

---

## ═══ AC 통합 발굴 (v7.0 — 두께·소재variant·입체/스탠드·가공방식 그룹핑·부착물) ★가공방식 그룹핑(A-8) 적대 판정·재포화 ═══

> `categories/AC/reverse.md` A-1~A-9 판정. **7 상품군(BN·GS·TP·PR·ST·CL·AC) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 4번째·CL 6번째 패턴 반복).** AC reverse가 강하게 제기한 "가공방식 그룹핑 슬롯(A-8)=distinct #18 강후보"는 **facet 클러스터**로 강등(공정#2 라미 + 자재#1 합성 + 옵션#3 cascade). 9 fragment 전부 기존 17축 facet/family/cascade/정책. 상세 판정 = `_resolved-fragments.md` AC 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(두께=자재 식별자·variant 분해·합지/별색=공정),pdf-domain-knowledge.md(완칼/도무송·합지),db-domain-structure-live.md}` + **[huni-ref] `31_acrylic-price-link/{acrylic-chain-design,confirms-and-gaps}.md`**(후니 아크릴 두께/소재/가격 모델 직접 대조·동형 확정). **★domain-researcher 신규 호출 불요** — 두께(아크릴 mm=자재 식별자)·라미네이션(=공정#2 합지)·표면효과(글리터/거울=자재 surface-finish·ST S-4 동형)·코롯토 입체(자립 블록=자재 두께)가 후니 KB+[huni-ref]+기존 17축에 확정 존재(추정 0).
> **★AC 핵심 판정 4 관전: 두께=자재#1 WGT facet · 소재variant=자재#1 surface-finish facet · 입체/스탠드=분산 facet(부속물#8+자재#1+옵션#3+공정#2) · 가공방식 그룹핑=공정#2(라미)+자재#1 합성+옵션#3 cascade facet(#18 부결).**

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **A-1** | 두께(3T/5T/8T·WGT_CD 슬롯) | 자재#1 WGT 차원 | WGT 슬롯 다의성(평량/두께)·[huni-ref] mat_cd 통합 동형·두께=자재 식별자 | **facet(거부)** ★관전1 |
| **A-2** | 소재 variant(글리터/거울/자개/홀로그램/렌티큘러/파스텔/유색) | 자재#1 surface-finish 합성 | ST S-4 점착/내후 동형·거울 별공식=#11 라우팅(자재 분류 아님) | **facet(거부)** ★관전3 |
| **A-3** | 입체/스탠드(3D) | 분산: 부속물#8+자재#1+옵션#3+공정#2 | 받침=부속물(본체 생성 아님=#14 아님·평면본체 유지=#15 아님)·코롯토=자재 두께·양면=인쇄면 | **분산 facet(거부)** ★관전2 |
| **A-4** | 부착물(고리/받침/자석/핀 SUB_MTR/WRK_MTR) | 부속물#8 + 공정#2 부착 bundle | KR/CN/CR ST 공유=단일 부자재 마스터·받침=#8·D-1/D-2 동형 | **facet(거부)** |
| **A-5** | 인쇄면(print_data) + 화이트 | 옵션#3 + 공정#2(화이트) + 제약#5(투명종속) | ST S-7 동형·별색=공정·"양면" 3축(도수/인쇄면/코롯토) 분산 | **facet(거부)** |
| **A-6** | 3 가격엔진(vTmpl/acrylic2025/tmpl) | 가격#11 pricing_model 라우팅 | ST S-6·GS G-7·PR P-6 합류·acrylic2025 추가([huni-ref] PRF_CLR_ACRYL 정합) | **facet(거부)** |
| **A-7** | 상품명 소재≠본체 자재(명찰 PET+합지) | 자재#1(PET) + 공정#2(합지) | G-1·CL C-2 라벨 융합 동형·합지=공정 | **facet(거부)** |
| **A-8** | ★가공방식 그룹핑(production_method 일반/라미·GRP_OPTION_CD) | 공정#2(라미)+자재#1 합성+옵션#3 cascade | GRP_OPTION_CD=옵션 cascade·라미=공정·합성=자재·형상#17과 정반대(축 충분) | **facet(거부·#18 부결)** ★강후보 |
| **A-9** | ACTPKEY 키링 템플릿 | 디자인입력채널#16 TemplateAsset + 카테고리#7 | T-A 이중의미 분리 동형·#4 완제SKU 아님 | **facet(거부)** |

### A-8 양면 트레이드오프 (침묵 선택 거부) ★directive 신규 강후보 의사결정

AC reverse가 "가공방식 그룹핑 슬롯(GRP_OPTION_CD/production_method)=distinct #18 강후보"를 ① 자재행을 가공방식 그룹(MTG_DFT 일반/MTG_LAM 라미)으로 묶는 *전용 명시 슬롯* ② `option_info.production_method` 전용 인코딩 ③ 라미가 두께 합성(3T→2T+1T)+홀로그램 부여라는 *능동 변환*(단순 옵션 초과) 세 근거로 강하게 제기. 적대 판정:

- **(가) distinct "가공방식 그룹핑 슬롯 #18" 신설:**
  - 찬성: GRP_OPTION_CD가 자재를 가공방식으로 *그룹핑*하는 명시 메커니즘·ST 형상(#17)처럼 "전용 슬롯=distinct 신호"·라미=능동 변환(두께/표면 합성).
  - 반대: ★세 근거 전부 기존 축의 *표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 왜곡 없이 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 라미네이션 자체** = 공정#2 멤버(라미=합지 후가공·BON_PAP/합지 family·deterministic 공정). 후니 KB가 합지/UV를 이미 공정 멤버로 수용.
    - **② 라미 결과(라미된 자재행 PXAATL01~04)** = 자재#1 *합성*(D-2 "MTRL_CD 다축 합성·두께/표면 분해")·두께 합성=WGT 차원(A-1)·홀로그램=surface-finish(A-2). 라미는 *합성 자재행을 만드는 공정*이고 그 결과는 자재행.
    - **③ GRP_OPTION_CD 그룹핑** = 옵션#3 polymorphic cascade(production_method 선택→호환 MTRL_CD subset 게이팅)·G-4 "한 DTL/옵션코드가 자재 subset 결정" 동형·CL size×color 매트릭스가 자재 SKU 게이팅과 동근(제약#5 match). "자재를 가공방식으로 그룹핑하는 슬롯"=옵션#3이 자재#1 subset을 게이팅하는 *관계 간선*이지 별 관리 축 아님.
- **(나) 공정#2(라미) + 자재#1 합성(라미 결과) + 옵션#3 cascade(가공방식→자재 subset) facet 클러스터 [채택]:** 세 기존 축의 결합. AC가 더한 것=가공방식이 공정(라미)·자재(합성결과)·옵션(cascade) 셋에 걸친 bundle(GS 제본·PR 면지·TP 쫄대 bundle 동류)이지 새 *축* 아님.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·가공방식은 부결(역방향 오류 점검):** 형상(#17)은 *사이즈축(#13)이 형상을 1:1 칼틀로 흡수해온 전제가 ST 1:多로 깨져* 기존 축이 *왜곡 없이 못 담음*(후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 확증)이 distinct 강제 근거였다. 가공방식은 **정반대** — 기존 축이 *왜곡 없이 담음*: 라미=공정#2(이미 합지 멤버)·합성결과=자재#1(이미 합성 규칙 D-2)·그룹핑=옵션#3 cascade(이미 G-4 채널). 후니 KB에 "가공방식 어느 축에도 없음" 같은 결함 명시 **없음**(라미네이션=공정 멤버로 이미 수용). → 형상=축 부재(distinct)·가공방식=축 충분(facet). 역방향 오류(distinct를 facet으로 숨김) 점검: GRP_OPTION_CD 그룹핑 슬롯이 유일 잔여 후보였으나 옵션#3 polymorphic 게이팅(G-4/CL 매트릭스 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).

### AC가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL 패턴 반복)** — 7번째 카테고리(아크릴)가 distinct 신축 0 도입. PR(4번째·distinct 0)→ST(5번째·형상 1종)→CL(6번째·distinct 0)→**AC(7번째·distinct 0)** = 모델 안정성 재확인. 가장 강한 새 후보(A-8 가공방식 그룹핑)조차 세 기존 축으로 무손실 흡수 = 강한 검증 신호.
2. **자재#1 surface-finish 합성 차원 facet** — 글리터/거울/자개/홀로그램/렌티큘러/파스텔이 ST S-4 점착/내후(adhesion/weather)와 합류한 자재 합성 분해축(`surface_finish`). 거울 별 가격공식(PRF_MIRROR)은 #11 라우팅(자재 분류 아님).
3. **자재#1 WGT 슬롯 다의성 명시** — WGT 슬롯이 평량(종이 g)·두께(아크릴 mm) 다의 사용·[huni-ref]가 두께를 mat_cd 차원으로 통합(1.5T=3T×0.8) 동형 입증. 자재 합성코드 WGT 차원의 정당한 다형성.
4. **부속물#8 횡단 확장** — 등신대 받침(AB 12 SKU·형상×크기·ESN=Y)이 BN 거치대(D-1)·우드봉·이젤 동형 부속물·고리(KR/CN/CR)가 ST SUB_MTR 코드 공유 = **단일 부자재 마스터 시사**(후니 부자재 카탈로그 단일화·갭분석가 주목).
5. **옵션#3 가공방식 cascade** — production_method(일반/라미)→호환 자재 subset 게이팅이 G-4 variant 채널·CL size×color 매트릭스 자재 게이팅과 합류한 polymorphic cascade.
6. **가격#11 pricing_model acrylic2025 라우팅** — 아크릴 전용 면적·두께·소재 산정엔진([huni-ref] PRF_CLR_ACRYL/MIRROR/COROTTO/CARABINER 소재·형태별 공식)이 ST 3엔진·GS G-7·PR P-6와 같은 "2025세대 전용 가격엔진" 패턴.

---

## ═══ PH 통합 발굴 (v9.0 — 완제 액자 그릇·마운팅/거치·전면 보호재·인화지×마감·set 단위·다중분류) ★완제 그릇/마운팅(PH-1·PH-2) 적대 판정·재포화 ═══

> `categories/PH/reverse.md` PH-1~PH-6 판정. **9 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR 4번째·CL 6번째·AC 7번째·PD 8번째 패턴 반복).** PH reverse가 강하게 제기한 "완제 액자 = 인쇄물 끼우는 빈 프레임(2-파트 완제 그릇)·마운팅/거치 distinct #18"은 **facet/variant 클러스터**로 강등(완제SKU#4 + 자재#1 프레임재질 variant + 옵션#3 거치 캐스케이드 + 생산형태#15). 6 fragment 전부 기존 17축 facet/family/cascade/정책. 상세 판정 = `_resolved-fragments.md` PH 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(완제SKU 템플릿·addl_product 부속물·생산방식 A/B/C·자재 surface-finish 합성·형상 #17 [HARD] 경계) + GS(완제 본체 SKU G-1·생산형태 D-9)·AC(소재 variant A-2·두께 WGT A-1·받침 부속물 A-3)·ST(형상 #17·점착 surface-finish S-4)·PD(완제 내재BOM PD-4·단수 사이즈 1:1 PD-3) 직접 대조. **★domain-researcher 신규 호출 불요** — 완제 프레임(=완제SKU#4+자재#1 variant)·거치(=옵션#3 캐스케이드)·인화지×마감(=자재#1 surface-finish)·형태 비율(=사이즈#13 프리셋)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PH 핵심 — §0.5 client-render 재캡처(gstack browse 2026-06-17)가 reverse 1차의 SSR-negative 블로커(거치/마운팅 미관측)를 OBSERVED로 해소. 거치(탁상용/벽걸이)는 실재하나 옵션 캐스케이드 상위 차원 + 완제 SKU variant로 구현됨 → 미싱데이터 해소 후에도 facet 결론 강화(추정 아닌 관측 기반 부결).**

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **PH-1** | ★완제 프레임(인쇄물 끼우는 빈 그릇·2-파트 완제 구조) | 완제SKU#4(거치+마감+사이즈)+자재#1 프레임재질 variant+생산형태#15 | §0.5 완제 SKU combobox 1개 인코딩·AC variant·GS G-1 동형·후니 KB 결함 없음·HARD ② 불충족 | **분산 facet/variant(거부·#18 부결)** ★강후보 |
| **PH-2** | ★마운팅/거치(탁상용/벽걸이)·전면 보호재·후면 받침 | 거치=옵션#3 캐스케이드 상위 차원·전면재=자재#1 내재·후면받침=부속물#8(미관측) | §0.5 거치 OBSERVED(블로커 해소)·옵션 캐스케이드 구현·전면재 디아섹 내재·후면받침 unobserved | **facet(거부·#18 부결)** ★블로커 해소 |
| **PH-3** | 인화지×마감(유광/반광/스노우/홀로그램) | 자재#1 surface-finish 합성 | §0.5 "인화용지(반광-러스터)/유광" 합성·ST S-4/AC A-2 동형·마감=매체 종속 | **facet(거부)** |
| **PH-4** | set/sheets 단위(600매·4/5sheets) | 수량#10 set 배수 + 완제SKU#4/기초코드#6 base_quant | 상품명 인코딩 고정 set·1주문=1 set·GS 텀블러 base_quant 동형 | **facet(거부)** |
| **PH-5** | PHMG/PHPO(머그·화분) PH vs GS | 카테고리#7 다중분류 | 출력매체(PH)⊥물성(컵&홀더)·GS 코드접두≠본질·다중분류 | **facet(거부)** |
| **PH-6** | ★형태(일반/정사각/파노라마) | 사이즈#13 비율 프리셋 흡수 | §0.5 OBSERVED·비율(aspect ratio)·형상↔사이즈 1:1·ST 1:多 미충족·PD-3 동형 | **facet(거부·형상#17 부결)** ★형상축 강제 금지 |

### PH-1/PH-2 양면 트레이드오프 (침묵 선택 거부) ★directive 최대 관전 의사결정

PH reverse가 "완제 액자 = 인쇄물 끼우는 빈 프레임(2-파트 완제 그릇)·마운팅/거치 distinct #18"를 제기. 단 reverse 1차에는 거치/마운팅이 **SSR-negative(Vue client-render)로 미관측 = 판정 불가 블로커**였고, **§0.5 client-render 재캡처(gstack browse)가 거치(탁상용/벽걸이)를 OBSERVED로 해소**한 뒤 적대 판정:

- **(가) distinct "완제 그릇/마운팅 축 #18" 신설:**
  - 찬성: ① 완제 프레임은 인쇄 본체가 아니라 *인쇄물을 담는 그릇*(역할 역전·AC 직접인쇄·GS 완제굿즈와 다른 2-파트 조립)·② §0.5 거치(탁상용/벽걸이)가 *전용 버튼 토글 슬롯*으로 실재(ST 형상 shape_info처럼 "전용 슬롯=distinct 신호")·③ 거치방식이 캐스케이드 상위 차원(거치 토글 시 마감/사이즈 풀 통째 교체).
  - 반대: ★세 근거 전부 기존 축의 *표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 왜곡 없이 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 완제 프레임(2-파트 그릇)** = 완제SKU#4 — §0.5 거치+마감+사이즈가 *완제 SKU 라벨 1개*(combobox 값·탁상용유광 127X177 ~ 벽걸이유광 1000X1000)로 등장 = AC 두께/소재 variant·GS 완제 본체 SKU(G-1) "미르 화이트 20oz" 라벨 융합 동형. 프레임재질(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹)=자재#1 variant(AC 소재 variant·pdtCode 분기=GS 코스터 G-2 동류).
    - **② 거치방식(탁상용/벽걸이)** = 옵션#3 polymorphic cascade — §0.5 거치 토글 시 마감 prefix·사이즈 풀이 통째로 교체(탁상용=소형 3종·벽걸이=대형 15종) = AC GRP_OPTION_CD 가공방식→자재 subset 게이팅(A-8)·G-4 variant 채널·CL size×color 매트릭스 게이팅과 동형. "거치=캐스케이드 상위 차원"이지 별 관리 축 아님.
    - **③ 전면 보호재(유리/아크릴)** = 자재#1 내재 — §0.5 마감 combobox는 표면처리(유광/무반사/자작나무)만·전면 보호재 별도 옵션 미관측·디아섹은 전면재가 상품 내재(아크릴 마운팅). 후면 받침=부속물#8 후보(미관측·AC 받침·BN 거치대 동형·unobserved).
- **(나) 완제SKU#4 + 자재#1 프레임재질 variant + 옵션#3 거치 캐스케이드 + 생산형태#15 facet/variant 클러스터 [채택]:** 네 기존 축의 결합. PH가 더한 것=완제 프레임이 완제SKU#4(거치+마감+사이즈 인코딩)·자재#1(프레임재질 variant)·옵션#3(거치 캐스케이드)·생산형태#15(C 완제품 governing) 넷에 걸친 bundle(AC 입체/스탠드 분산 facet·PD 완제 내재BOM 분산 facet 동류)이지 새 *축* 아님.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·완제 그릇/마운팅은 부결(HARD 기준 양방향):** 형상(#17)은 ① 전용 슬롯(shape_info) 실재 + ② 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 **둘 다 충족** → 승격. PH 완제 그릇/마운팅은 **① 거치 전용 슬롯 §0.5 OBSERVED(미싱데이터 해소)되었으나 ② 후니 KB 결함 명시 없음**(완제SKU#4·옵션#3·자재#1·사이즈#13이 왜곡 없이 담음·형상#17의 G-SK-2 같은 KB 결함 부재) → ②가 불충족 → distinct 0. **★결정적 — §0.5 재캡처가 블로커를 OBSERVED로 해소(① 충족시킴)했음에도 거치가 옵션 캐스케이드 + 완제 SKU variant로 구현됨이 실측 → ②가 여전히 불충족이라 facet 결론이 미싱데이터 해소 후에도 강화**(reverse 1차 "판정 불가"가 "관측 기반 부결"로 격상). 역방향 오류(distinct를 facet으로 숨김) 점검: "2-파트 완제 그릇·거치 전용 슬롯"이 유일 잔여 후보였으나 완제SKU#4(거치+마감+사이즈 인코딩 = AC variant·GS 완제SKU 동형) + 옵션#3 cascade로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).

### PH가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC·PD 패턴 반복)** — 9번째 카테고리(완제 액자/출력매체)가 distinct 신축 0 도입. PR(4)→ST(5·형상 1종)→CL(6)→AC(7)→PD(8)→**PH(9)** = 모델 안정성 재확인. §0.5 재캡처가 핵심 블로커(거치/마운팅 SSR-negative)를 OBSERVED로 해소했음에도 가장 distinct로 보이던 "2-파트 완제 그릇·마운팅/거치"조차 네 기존 축으로 무손실 흡수 = 강한 검증 신호.
2. **완제SKU#4 "거치+마감+사이즈 인코딩 완제 SKU combobox" 강화** — AC 두께/소재 variant·GS 완제 본체 SKU(G-1)와 합류한 완제 SKU 라벨 융합. **★[HARD] 분해 요구:** 완제 SKU 라벨("탁상용유광 127X177")을 `{mount_type(탁상/벽걸), finish(유광/무반사/자작나무), frame_material, size}`로 분해(평면 라벨=의미축 drop·G-1/AC variant 동일 처방).
3. **자재#1 프레임재질 variant + 인화지×마감 surface-finish 확장** — 프레임재질(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹)=AC 소재 variant 합류·인화지×마감("인화용지 반광-러스터/유광")=ST S-4 점착/AC A-2 surface-finish 합성축(V-3 합류·`{ptt, surface_finish}` 분해).
4. **옵션#3 "거치방식 캐스케이드 상위 차원" 강화** — 거치→마감→완제SKU사이즈→수량 캐스케이드가 AC GRP_OPTION_CD cascade·G-4 variant 채널·CL size×color 매트릭스 게이팅과 합류한 polymorphic cascade(거치방식 = 상위 게이팅 차원).
5. **사이즈#13 비율(aspect ratio) 프리셋 흡수 입증** — 형태(일반/정사각/파노라마)가 형상↔사이즈 1:1(비율 프리셋)·ST 1:多 미충족·PD-3 단수/형상 1:1 합류 = **형상축 #17 강제 금지 재확인**(형상이 1:1이면 사이즈 흡수·오모델 회피·HARD 경계).
6. **제약#5 [재고부족]disable + 카테고리#7 다중분류 + 가격#11 라우팅** — §0.5 PHPRDFT [재고부족]홀로그램 disabled OBSERVED(ST disable·AC 명찰 cascade 합류)·머그/화분 출력매체 vs 물성 다중분류(GS G-2 합류)·tmpl/digital_price 라우팅(PR 책자 동형)·생산형태#15 완제품 governing 재확인.

---

## ═══ FS 통합 발굴 (v10.0 — 면직물·타일링·마감봉제·완제 직물 굿즈 부자재) ★타일링(FS-1) 적대 판정·재포화 ═══

> `categories/FS/reverse.md` FS-1~FS-8 판정. **10 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR·CL·AC·PD·PH 패턴 반복·★타일링 TILL_WH_GBN #18 부결).** FS reverse가 "타일링(반복패턴 인코딩)=distinct #18 유일 후보"를 강하게 제기(BN/GS/TP/PR/ST/CL/AC/PD/PH 전 9 카테고리 어디에도 없던 `TILL_WH_GBN` 전용 라디오·5상품 전수)했으나 **공정#2 인쇄 배치(조판/imposition) 파라미터로 무손실 흡수.** 8 fragment(FS-1~FS-8) 전부 기존 17축 facet/family/cascade. 상세 판정 = `_resolved-fragments.md` FS 섹션.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(plate_size 임포지션/판걸이 #6·자재 usage·두께=자재·variant 분해),pdf-domain-knowledge.md(조판/임포지션 §4-2·판걸이=원판당 작업물 개수),process-recipe-tree.md(봉제 공정)}` + PD(봉제 SEW_LTR·완제 내재BOM)·CL(원단/oz)·AC(WGT mm)·BN(현수막 가공)·GS(PDT_WRK 형태가공) 직접 대조. **★domain-researcher 신규 호출 불요** — 타일링(=인쇄 배치/조판 파라미터·plate_size 임포지션 도메인)·면직물(=자재#1 PTT)·면사 수(=WGT 번수 다의)·마감봉제(=공정#2)가 후니 KB+기존 17축에 확정 존재(추정 0).
> **★FS 핵심 판정 — directive 1순위(타일링): distinct #18 부결(공정#2 인쇄 배치 파라미터).** 타일링이 던진 진짜 질문은 새 옵션축이 아니라 "직물 풀프린팅 반복 배치를 어디 두나" — 답=**공정#2 인쇄 배치 파라미터#9**(접지 면분할·오시 줄수·UV 변형 동근). ★타일링≠판걸이수(타일링=입력 파라미터·판걸이수=앱계산 파생·DB미저장) 경계가 결정적.

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **FS-1** | ★타일링(TILL_WH_GBN 없음/세로/가로) | 공정#2 인쇄 배치 파라미터#9 | 전 9 카테고리 미관측 전용 슬롯이나 plate_size(임포지션/조판) 이미 1급·KB 결함 없음·타일링≠판걸이수 | **facet(거부·#18 부결)** ★유일 강후보 |
| **FS-2** | 방향(PAPER_WH W/H) | 사이즈#13 방향 facet | 본체 직물 방향(가로/세로 치수)·타일방향과 분리 슬롯 | **facet(거부)** |
| **FS-3** | 면직물 자재(면사 수 PXFBW0NN) | 자재#1 PTT 직물 + WGT 다의(번수) | CL oz·AC mm·PD 번수 동형·비종이 자재 이미 관측 | **facet(거부)** |
| **FS-4** | 별색(SID_FBR 6색×3농도) | 공정#2 별색 family + 기초코드#6 색 enum | CL Pantone 1124 축소판·직물 날염 제한 도메인·round-22 별색=공정 | **facet(거부)** |
| **FS-5** | 마감봉제(SEW_FBR)·제품가공(PDT_WRK) | 공정#2 봉제 family·본체형태가공#14 | PD SEW_LTR·GS PDT_WRK 동형·동일 PCS 슬롯·상품별 인스턴스 | **facet(거부)** |
| **FS-6** | 솜/끈/자석/라벨/포켓(완제 부자재) | 자재#1 sub_mtrl + 부속물#8 선택형 | 옵션 노출(view_yn=Y)=PD-4 고정 ESN=Y와 노출 차원만 분기·AC SUB_MTR 동형 | **facet(거부)** |
| **FS-7** | 가격모델(real_price/real_calc_price) | 가격#11 라우팅 | 완제 봉제 굿즈도 면적/실계산·PD tmpl과 분기·도메인 현실 | **facet(거부)** |
| **FS-8** | PCS 상세 enum·단가·infoCall | unobserved | infoCall 후행·축 판정 무영향(SSR 슬롯으로 확정) | **facet(거부·unobserved)** |

### FS-1 양면 트레이드오프 (침묵 선택 거부) ★directive 1순위 의사결정 — 타일링(반복 배치)

FS reverse가 명시한 directive 1순위 관전: "타일링(TILL_WH_GBN: 없음/세로/가로)은 BN/GS/TP/PR/ST/CL/AC/PD/PH 전 9 카테고리 어디에도 없던 전용 라디오 슬롯 — 직물 풀프린팅 특유의 '패턴 반복 배치' 차원이 distinct #18인가, 아니면 인쇄 공정의 facet인가." 적대 판정:

- **(가) distinct "타일링/반복 배치 축 #18" 신설:**
  - 찬성: ① TILL_WH_GBN이 전 9 카테고리 어디에도 없던 *전용 명시 라디오 슬롯*·5상품 전수 OBSERVED(ST 형상 shape_info처럼 "전용 슬롯=distinct 신호") ② 반복 배치가 인쇄 면적/방식을 바꿔 가격에 영향(능동 변환 추정) ③ 직물 풀프린팅에만 등장하는 고유 차원.
  - 반대: ★세 근거 전부 기존 축의 *표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 *왜곡 없이* 못 담는 고유 lifecycle/governing"이 **없음**.
    - **① 타일링 = 인쇄 배치(조판/임포지션) 공정 파라미터:** 타일링(세로/가로 반복 배치)은 *작업물을 인쇄 면에 어떻게 배치하나*의 고객 선택값. 후니 KB `plate_size`(#6·`entity-semantic-model.md:27` "작업/전지 판형·**임포지션·판걸이**·돔보")·`pdf-domain-knowledge.md:146` "조판(임포지션)=작업물을 원판에 판걸이 개수만큼 앉히는 행위"가 *인쇄 배치를 이미 1급 모델링*. 타일링=그 배치 차원의 고객 입력(반복 방향) = 공정#2 인쇄 배치 파라미터(#9·접지 FLD_DFT 면분할·오시 줄수 동형). 후니 KB에 "패턴 반복/배치 어느 축에도 없음" 같은 결함 명시 **없음**(plate_size/공정 파라미터가 담음·ST 형상 G-SK-2와 정반대).
    - **② 가격 영향** = 가격기여역할#11(공정 파라미터가 공정과 함께 가격 기여·D-6)·unobserved(infoCall 후행). 가격 영향이 있다고 distinct가 아님(모든 공정 파라미터가 가격 기여).
    - **③ 직물 전용성** = 카테고리별 노출 차이(BN 어깨띠 형상이 BN에만 등장해도 사이즈 facet인 것과 동형). 타일링이 직물에만 등장=인쇄 배치 파라미터의 *직물 매체 인스턴스*이지 새 축 아님(종이는 접지·직물은 타일링·둘 다 인쇄 배치 family).
- **(나) 공정#2 인쇄 배치 파라미터(#9 종속) facet [채택]:** 타일링 = 공정#2 인쇄 배치(조판/임포지션) 공정에 종속된 매개변수(접지 면분할·오시 줄수·UV 변형 동근). FS가 더한 것 = 공정 파라미터#9에 "인쇄 타일링(반복 배치)" 멤버 추가이지 새 *축* 아님.

**★ST 형상(#17)·PH 거치(부결)와의 HARD 양방향 기준 적용 — 왜 형상은 승격·타일링은 부결:** 형상(#17)은 ① 전용 슬롯(shape_info) 실재 + ② 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 **둘 다 충족** → 승격. 타일링은 **① TILL_WH_GBN 전용 슬롯 OBSERVED(충족)이나 ② 후니 KB 결함 명시 없음**(plate_size #6·공정 파라미터#9가 인쇄 배치/조판을 이미 1급 모델링·왜곡 없이 담음) → ②불충족 → distinct 0. PH 거치(PH-2)와 정확히 동일 구조(①충족·②불충족=부결). **★핵심 경계(HARD) — 타일링≠판걸이수:** 타일링은 *고객측 디자인 반복 배치 입력 파라미터*(없음/세로/가로 라디오·공정#9 등재), 판걸이수(imposition count)는 *앱 계산 파생값*(DB 미저장·`pdf-domain-knowledge.md:149` "판걸이=원판당 앉히는 작업물 개수"·메모리 `dbmap-compute-in-app-db-stores-lookup`). 임포지션=N개 *다른* 작업물을 한 원판에(다도안 판걸이), 타일링=한 디자인 *반복* 배치(직물 면 채움)·둘 다 plate_size/조판 도메인의 facet이나 타일링=입력 파라미터·판걸이수=앱계산 파생. 역방향 오류(distinct를 facet으로 숨김) 점검: "전 9 카테고리 미관측 전용 슬롯"이 유일 잔여 후보였으나 plate_size(#6 임포지션)·공정 파라미터(#9 접지/오시)가 인쇄 배치를 왜곡 없이 담음 → facet 정당(숨김 아님·새 관리 관심사 없음). **★[중요·갭분석가] RP가 타일링을 공정 배치 라디오로 둠 = data-gap(후니가 직물 타일링 취급 시 공정#2 인쇄 배치 파라미터#9에 적재해야 할 반복 배치 선택을 미적재)이지 vessel-gap(축 부재) 아님**(PD-4 data-gap·갭분석가).

### FS가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC·PD·PH 패턴 반복)** — 10번째 카테고리(직물 풀프린팅+봉제 완제 굿즈)가 distinct 신축 0 도입. PR(4)→ST(5·형상 1종)→CL(6)→AC(7)→PD(8)→PH(9)→**FS(10)** = 모델 안정성 재확인. 유일 신규 후보(타일링 TILL_WH_GBN·전 9 카테고리 미관측 전용 슬롯)조차 공정#2 인쇄 배치 파라미터로 무손실 흡수 = 강한 검증 신호.
2. **공정#2 인쇄 배치 파라미터#9 "타일링(반복 배치)" 멤버 추가** — 접지(FLD_DFT 면분할·PR)·오시 줄수·UV 변형과 합류한 인쇄/면가공 배치 파라미터(plate_size 임포지션 도메인). **★타일링(입력)≠판걸이수(앱계산 파생) 경계 확정**(공정 파라미터 축은 입력만·파생값 등재 금지 재확인).
3. **자재#1 직물 물성 차원 입증** — 면직물(면사 수 PXFBW0NN)이 종이(지종×평량)·아크릴(mm)·의류(oz)·PD 직물(번수)과 합류한 비종이 자재 PTT + WGT 다의(번수). 자재 합성코드 WGT 차원의 직물판 다형성(`measure_type` 평량/두께/oz/번수 구분 vessel 검토·갭분석가).
4. **공정#2 마감봉제(edge finish) family 멤버 추가** — 오버로크/말아박기/벨크로가 PD SEW_LTR(레더재봉) 봉제 family에 직물 가장자리 마감 멤버로 합류·제품가공(PDT_WRK)=형태가공#14 직물 굿즈 봉제 완제 횡단(GS/PD 합류).
5. **부속물#8 선택형(옵션 노출) facet 추가** — 직물 굿즈 부자재(끈/자석/솜·view_yn=Y 옵션 노출)가 PD-4 고정 부속(ESN=Y·view_yn=N)과 *노출 차원만 분기* = 부속물#8이 (a)고정 부속 (b)선택형 부자재 두 노출 모드 보유 입증(필수성×노출 facet).
6. **가격#11 라우팅 재확인** — 완제 봉제 굿즈(쿠션/에코백/파우치)도 real_calc_price(면적/실계산·BN 현수막·실사 동형)·패브릭 포스터=real_price(현수막형) — PD tmpl_price 완제 SKU와 분기(가격모델은 매체/생산형태로 라우팅).

---

## ═══ NC 통합 발굴 (v11.0 — 옵셋 명함/카드·인쇄방식(옵셋 vs 디지털)·별도 가격엔진·이산 부수 tier) ★인쇄방식 #18 적대 판정·재포화 ═══

> `categories/NC/reverse.md` N-1~N-5 판정. **11 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS·NC) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR·CL·AC·PD·PH·FS 패턴 반복·★인쇄방식(옵셋 vs 디지털) #18 부결).** NC는 **선별 모드 핵심 프로브** — 옵셋 명함(NCDFDFT/FLD/PHO)이 디지털 명함(BC·BCSPDFT)과 *동일 상품군이되 인쇄방식만 옵셋*인 자연 실험(디지털 vs 옵셋 변수를 깨끗하게 격리). 옵셋은 **별도 가격엔진(offset2023_price)·이산 부수 tier(MTRL_CD×PRN_CNT)·옵셋전용 자재 pool(RXWMO220)**까지 가진 *가장 강력한 인쇄방식 distinct #18 후보*. 5 fragment(N-1~N-5) 적대 판정 후 **전부 facet/관계 간선.** 상세 판정 = `_resolved-fragments.md` NC 섹션.
> 도메인 정초 = `07_domain/process-recipe-tree.md`(인쇄방식 5종 PROC_000002~6 = 최상위 레시피 축·"1상품=1인쇄방식이 가능 공정 부분집합 결정") + `entity-semantic-model.md`(자재 합성·수량 모델·제약 논리) + BC fixture(디지털 카운터파트 직접 대조) + 메모리 `dbmap-print-method-not-absolute-axis`. **★domain-researcher 신규 호출 불요** — 옵셋 vs 디지털 인쇄 차이(옵셋=판/대수 임포지션 경제성→이산 부수·디지털=출력당 단가→연속 수량·자재풀 분기·별도 가격엔진)가 후니 KB+기존 17축에 확정 존재(추정 0).
> **★NC 핵심 판정 — directive 최강 적대 프로브(인쇄방식이 distinct #18인가): 부결.** ★결정적 — **인쇄방식은 *이미* 메타모델 #12(D-7 인쇄방식/생산 레시피·조건부 distinct)로 v2.0(BN)에 등재됨.** NC가 발견한 옵셋 차이는 *새 #18 축*이 아니라 **기존 #12를 토큰 레벨(`offset2023_*`)로 재확인 + #11 가격모델 라우팅 + #10 수량/#5 제약 분산**으로 전부 흡수. 즉 #18 질문의 답 = "인쇄방식은 신축이 아니라 *이미 #12*이며, NC는 그 #12를 강화(자재풀 게이팅 P-7·가격엔진 라우팅)할 뿐."

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **N-1** | ★`item_gbn`/`price_gbn` 토큰(`offset2023_*`) | 인쇄방식레시피#12(D-7) + 가격#11 라우팅 + 기초코드#6 | 인쇄방식은 이미 #12 등재·토큰=상품분기 discriminator(CL item_gbn=clothes2025 동형)·price_gbn=가격엔진 라우팅 키(#11)·offset2023_item↔price 동반=#12 게이팅 #11 | **facet(거부·#12 재확인)** ★최강 #18 후보 |
| **N-2** | ★`pdt_exp_prn_cnt_info` 이산 부수 tier(MTRL_CD×PRN_CNT 100~500·자유입력 불가) | 수량#10 이산 슬롯 + 제약#5(자재→허용부수) + 가격#11(부수 tier=단가구간) | 한 슬롯에 3의미 합성(자재→허용부수→단가)·후니 수량모델/제약/가격이 분산 흡수·"연속 vs 이산"=수량 표현력 data-gap이지 인쇄방식 신축 아님 | **분산 facet(거부·data-gap)** ★결정적 분기 |
| **N-3** | 별도 가격엔진 `offset2023_price` | 가격#11 pricing_model 라우팅 | digital_price/vTmpl/real_price/tmpl/acrylic2025와 같은 "전용 가격엔진(세대)" 패턴 추가·라우팅 키=price_gbn | **facet(거부·#11 라우팅)** |
| **N-4** | 옵셋전용 자재 pool(3종 vs 디지털 5종·RXWMO220) | 인쇄방식#12 → 자재#1 게이팅(P-7 간선) | 인쇄방식이 가능 자재 부분집합 게이팅·PR 윤전→YWM pool 동형·자재풀 차이=#12 gates-material-pool 간선 | **facet(거부·P-7 합류)** |
| **N-5** | 접지(NCDFFLD 사이즈 SKU 흡수)·오시(OSI_DFT)·귀돌이(ROU_DFT) | 사이즈#13(접지치수 SKU) + 공정#2(오시/귀돌이) + 제약#5(사이즈↔오시 cascade) | PR 리플렛=FLD_DFT 독립 옵션축·NC 명함=접지를 사이즈 SKU+오시 공정으로 분해·같은 개념 상품군별 다른 관리축(둘 다 기존 축) | **facet(거부)** |

### N-1 양면 트레이드오프 (침묵 선택 거부) ★directive 최강 적대 프로브 — 인쇄방식(옵셋 vs 디지털)이 distinct #18인가

NC reverse가 1차 예측한 "인쇄방식 #18 = 부결(흡수)"를 적대 검증. 옵셋은 *별도 가격엔진·이산 부수 tier·옵셋전용 자재 pool*까지 가진 가장 강력한 후보이므로 양방향 적대:

- **(가) distinct "인쇄방식 축 #18" 신설:**
  - 찬성: ① `item_gbn=offset2023_item`/`price_gbn=offset2023_price`가 디지털 `digital_*`와 *별도 분기*로 박힘(전용 인코딩 슬롯처럼 보임) ② 옵셋만의 *별도 가격엔진*(offset2023_price)·*이산 부수 tier*(자재종속 100~500)·*전용 자재 pool*(RXWMO220 모조지)이라는 옵셋 고유 차원군 ③ "옵셋이냐 디지털이냐"가 가격엔진·수량모델·자재풀을 *동반 결정*하는 게이팅처럼 보임.
  - 반대: ★승격 양방향 기준 둘 다 불충족 + 결정적으로 **인쇄방식은 *이미 #12로 등재됨* — 신축 #18은 #12 중복.**
    - **★승격 기준 ① 전용 슬롯 라이브 실재 = 불충족(enum 토큰이지 전용 관리 슬롯 아님):** `item_gbn`/`price_gbn`은 ST 형상 `shape_info`(사이즈와 분리된 *전용 별도 슬롯*)와 달리 — **같은 base-data 스키마 슬롯의 *다른 값***(reverse 차이표 7행 전부 "❌ 같은 슬롯, 값만 다름"). 옵셋 NC와 디지털 BC가 `pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_prn_cnt_info`/`pdt_pcs_info`를 100% 동형으로 공유·**새 스키마 축(슬롯) 추가 0**. `item_gbn`=상품에 박힌 *discriminator enum*(CL item_gbn=clothes2025·PR pdtCode prefix·ST 인쇄방식 prefix와 정확히 동형 정책패턴·명제 #19 "분기 discriminator는 축 아님"). 별도 가격엔진 존재가 ①을 충족시키지 *않음* — 가격엔진 선택은 `price_gbn` enum 값(가격#11 라우팅 키)이지 새 관리 슬롯이 아님(ST 3엔진·AC 3엔진·GS tmpl/vTmpl이 이미 한 price_gbn 슬롯의 다른 값으로 라우팅됨을 입증).
    - **★승격 기준 ② 후니 KB 무왜곡 흡수 불가 = 불충족(전부 무왜곡 흡수·KB 결함 명시 없음):** 옵셋 차이가 기존 축에 *왜곡 없이* 담김 — 인쇄방식=#12 D-7(이미 등재·게이팅 lifecycle 보유)·별도 가격엔진=#11 pricing_model 라우팅(offset2023_price=ST die-cut/AC acrylic2025와 같은 전용 엔진 패턴)·이산 부수 tier=#10 수량/#5 제약/#11 가격 분산(N-2)·자재풀=#12 gates-material-pool 간선(P-7·N-4). 후니 KB에 "인쇄방식 어느 축에도 못 담음" 같은 결함 명시 **없음** — 정반대로 `process-recipe-tree.md §1`이 인쇄방식을 *최상위 레시피 축으로 1급 모델링*(PROC_000002~6·게이팅). ST 형상 G-SK-2 "형상 어느 축에도 없음" 결함과 정반대 → ②불충족.
- **(나) 인쇄방식레시피#12(D-7) 재확인 + 가격#11/수량#10/제약#5/자재#1 분산 facet [채택]:** NC가 더한 것 = #12 인쇄방식 축의 *토큰 레벨 증거*(`offset2023_*`)·가격엔진 라우팅(#11)·자재풀 게이팅(P-7) *강화*이지 새 *축* 아님. 인쇄방식은 v2.0(BN)에서 이미 D-7로 *조건부 distinct* 승급됨(RP=자재 facet 인코딩/후니=1급 게이팅 축 양면 표현). NC는 그 양면 표현의 *세 번째 인코딩*(상품 token 분기·BN=자재 facet·ST/PR=pdtCode prefix·CL=상품내 옵션·**NC=item_gbn/price_gbn 토큰 bundle**)을 추가.

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·인쇄방식 #18은 부결(HARD 기준 양방향):** 형상(#17)은 ① 전용 슬롯(shape_info·사이즈와 분리) 실재 + ② 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 **둘 다 충족** → 승격. 인쇄방식 #18은 **① 전용 슬롯 부재**(item_gbn=enum 토큰·같은 base-data 슬롯의 다른 값·새 슬롯 0) **+ ② KB 결함 부재**(인쇄방식=#12로 이미 1급·왜곡 없이 담음) **둘 다 불충족** → 부결. **★결정적 — 인쇄방식은 이미 #12(D-7)다:** 신축 #18 제안은 *이미 등재된 축의 중복*(같은 개념 2축=메타모델 일관성 붕괴). CL 의류 variant(#18 부결·기존 축 클러스터)·PH 거치(①충족·②불충족 부결)와 같은 부결 계열이되, NC는 **"이미 등재된 축의 토큰 재확인"이라는 더 깨끗한 부결**(신후보가 아니라 기존 축의 증거). 역방향 오류(distinct를 facet으로 숨김) 점검: "별도 가격엔진+이산 tier+전용 자재풀"이 유일 잔여 후보였으나 #11/#10/#5/#12로 무손실 분해 + 인쇄방식 자체가 #12 → facet 정당(숨김 아님·새 관리 관심사 없음).

### N-2 결정적 분기 (이산 부수 tier = distinct vs data-gap) ★directive 핵심 분기

reverse N-2가 명시한 결정적 분기: 옵셋의 "자재종속 이산 부수 tier(MTRL_CD×PRN_CNT 100/200/.../500·자유입력 불가)"가 **(a) 인쇄방식 #18 축의 증거인가, (b) 기존 가격#11/수량#10이 담되 후니가 *아직 이 표현력을 적재 안 한* data-gap("수량 모델 표현력")인가** — ST 형상 vessel-gap vs PD 내재BOM data-gap 판별 기준 적용:

- **(a) 인쇄방식 축 증거 가설 = 기각.** 이산 tier는 인쇄방식 *고유 슬롯*이 아니라 *같은 `pdt_prn_cnt_info`/`pdt_exp_prn_cnt_info` 슬롯의 채움 방식 차이*(디지털=연속 FIR/INC/STEP·옵셋=이산 exp_prn_cnt 매트릭스). 슬롯은 디지털과 100% 공유 → 새 관리 축이 아님.
- **(b) 수량 모델 표현력 data-gap = 채택.** 이산 tier는 한 슬롯에 *3 의미 합성*(자재 MTRL_CD → 허용 부수 → 부수별 단가):
  - **① 허용 부수 집합(자재→{100,200,300,400,500})** = **수량#10(D-5) 이산 슬롯** + **제약#5(자재가 허용부수를 제약·match/disable)**. 후니 수량모델이 "연속 increment"만 가정하면 이산 tier를 못 담을 수 있으나, 이는 *수량축의 이산 모드 표현력 부재*(data-gap)이지 새 인쇄방식 축이 아님.
  - **② 부수 tier = 단가구간** = **가격#11(D-6)** — 옵셋 부수 tier가 곧 대량 단가구간(NCCDPHO "대량"의 의미=이 이산 tier). round-1 t_dsc_*(수량구간 할인)·tiered_price와 동근.
  - **③ 자재종속(MTRL_CD×PRN_CNT 페어)** = **제약#5 자재↔수량 cascade** + **#12 인쇄방식이 부수 이산화를 게이팅**(옵셋 판/대수 임포지션 경제성).
- **결론: data-gap(vessel-gap 아님).** 후니가 옵셋류를 취급하려면 수량축#10에 *이산 tier 모드*(연속 increment 외)·제약#5에 *자재→허용부수 매트릭스*·가격#11에 *부수구간 단가*를 적재해야 — 세 기존 축의 *표현력 적재* 문제이지 새 축 부재 아님. **★PD-4 내재BOM data-gap·FS-1 타일링 data-gap과 동일 계열**(축 충분·데이터/표현력 미적재). 갭분석가 주목: 수량축#10이 이산 tier를 수용하는지(연속 vs 이산 모드)·제약#5가 자재→허용부수를 담는지 라이브 확인.

### NC가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC·PD·PH·FS 패턴 반복) + 최강 #18 후보 정면 격파** — 11번째 카테고리(옵셋 명함/카드)가 distinct 신축 0 도입. PR(4)→ST(5·형상 1종)→CL(6)→AC(7)→PD(8)→PH(9)→FS(10)→**NC(11)** = 모델 안정성 재확인. **★NC는 선별 모드 핵심 프로브** — 별도 가격엔진·이산 부수 tier·전용 자재 pool까지 가진 *가장 강력한 인쇄방식 distinct 후보*조차 이미 등재된 #12 + 분산 facet으로 무손실 흡수 = 가장 깨끗한 부결(신후보가 아니라 *기존 축의 토큰 재확인*).
2. **인쇄방식#12(D-7) 토큰 레벨 + 4번째 인코딩 입증** — `offset2023_item`/`offset2023_price` 토큰이 #12를 *상품에 박는 가장 직접적 신호*. #12가 (a)자재 facet 인코딩(BN 수성/라텍스) (b)pdtCode prefix 상품분기(ST/PR) (c)상품내 옵션 차원(CL) (d)**item_gbn/price_gbn 토큰 bundle(NC)** 네 표현을 가짐 확정.
3. **가격#11 offset2023_price 라우팅 추가** — pricing_model enum에 offset2023(옵셋 자재×부수 룩업·이산 단가구간) 추가 = digital_price·real_price·tmpl/vTmpl·tiered·book2025·acrylic2025와 같은 "전용 가격엔진(세대)" 패턴. 라우팅 키=price_gbn(인쇄방식 종속).
4. **수량#10 이산 tier 모드 data-gap 명시** — 디지털=연속 increment(FIR/INC/STEP) vs 옵셋=자재종속 이산 tier(exp_prn_cnt 매트릭스). 수량축이 *연속·이산 두 모드*를 가져야 함을 입증(후니 적재 표현력 과제·N-2).
5. **#12 자재풀 게이팅 간선(P-7) 재확인** — 옵셋전용 자재 pool(RXWMO220 모조지·3종 vs 디지털 5종)이 PR 윤전→YWM pool(P-7) 동형 = 인쇄방식이 가능 자재 부분집합 게이팅. gates-material-pool 간선 강화.
6. **사이즈#13 접지 SKU 흡수 + 공정#2 오시 cascade** — NCDFFLD 접지(2단/3단×세로/가로)가 *사이즈 SKU 16종으로 베이크* + 오시(OSI_DFT) 공정 동반(사이즈↔오시 cascade) = PR 리플렛 FLD_DFT 독립 옵션축과 *같은 개념 다른 관리축*(둘 다 기존 사이즈#13/공정#2). 상품군별 접지 관리축 분기 입증.

### ★dbmap 정합 (메모리 `dbmap-print-method-not-absolute-axis`와의 관계)

NC 판정과 dbmap 교훈은 **같은 결론, 다른 렌즈** — 상호 강화:
- **dbmap 렌즈(적재/이해 단위):** "인쇄방식은 *절대 최상위 축* 아님 — 시트(상품군)가 1차 이해 단위, 인쇄방식은 시트의 속성으로 따라옴." 후니=주로 디지털+굿즈, "1상품=1방식"이 DB 강제 안 됨(note 선언만).
- **rpmeta 렌즈(메타모델 축):** 인쇄방식은 *distinct 신축 #18이 아니라* — 이미 #12(D-7)로 *조건부 distinct*(RP=자재 facet 인코딩/후니=1급 게이팅 레시피 양면 표현). 신축 강요는 #12 중복.
- **같은 결론:** 둘 다 "인쇄방식을 *과대한 절대 분류축*으로 두지 말라"는 동일 판정. dbmap의 "절대 최상위 축 아님"(taxonomy 과대화 금지) = rpmeta의 "신축 #18 부결·이미 #12로 조건부 등재"(중복 신축 금지). NC 옵셋이 *별도 가격엔진·이산 tier*를 가져도 *시트(명함/카드 상품군)가 1차 단위*이고 인쇄방식은 그 속성(가격엔진·자재풀·수량모드를 게이팅하는 #12 속성)이라는 dbmap 교훈을 rpmeta가 토큰 레벨로 재확인. **★상호 보강:** dbmap은 "후니 라이브 적재 관점"(인쇄방식 미적재가 대세 무영향)·rpmeta는 "RP 메타모델 추상화 관점"(인쇄방식=#12 게이팅 축·신축 아님) — 두 관점이 충돌 없이 같은 "인쇄방식≠독립 절대축" 결론으로 수렴.

---

## ═══ OT 통합 발굴 (v12.0 — 상자/패키징·전개도/dieline·3D 입체치수·재단/작업 2치수·dieline 에디터 템플릿) ★전개도 #18 적대 판정·재포화 ═══

> `categories/OT/reverse.md` O-1~O-4 판정(reverse §7 1차 예측 부결을 적대 비준). **12 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS·NC·OT) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR·CL·AC·PD·PH·FS·NC 패턴 반복·★전개도/dieline #18 부결).** OT는 **선별 모드 핵심 프로브** — 박스/패키징은 *평면 인쇄물에 없던 입체(3D 가로×세로×높이)·전개(평면 net/dieline)·접지(칼틀+오시)·접합* 차원을 가진 **첫 상품군**이라 가장 강력한 "입체/전개 distinct #18" 후보. 5 박스(OTPKCAK/FLT/HMN/ENV/ARP) + 1 비박스(OTPOCLP 클래퍼) `[live:detail]` 실측(2026-06-19·SSR select·infoCall 0·주문/POST 0) 적대 판정 후 **전부 facet/관계 간선.** 상세 = `_resolved-fragments.md` OT 섹션.
> 도메인 정초 = `07_domain/entity-semantic-model.md:22,27`(★**size=재단치수 1급 축 + plate_size=작업/전지 판형[임포지션·판걸이] 별개 1급 축** — 후니가 재단/작업 2치수를 *이미 2축으로 분리 모델링*) + `process-recipe-tree.md`(도무송/오시=공정 멤버) + ST 칼선/PR 접지 reuse. **★domain-researcher(패키징 dieline) 신규 호출 불요** — 박스 차원(작업사이즈=전개도 평면·재단=완성품 외곽·3D=조립 후 파생·도무송=칼틀·오시=접지선·접합=고객 수작업)이 후니 KB+기존 17축에 확정 존재(추정 0). dbm-domain-researcher는 dieline 템플릿 내부 스키마(O-2 unobserved)만 validator 라이브 실측에 부수.
> **★OT 핵심 판정 — directive 최강 적대 프로브(전개도/dieline이 distinct #18인가): 부결.** ★결정적 — 박스 옵션 모델은 평면 인쇄물(PR/NC)과 **100% 동일 슬롯**(paper/paper_sub/sodu/size/number·`[live:detail]` 5박스 일치). 전개도·접지·3D치수 *전용 관리 슬롯 0건* — ST가 가진 `shape_info` 같은 분리 슬롯이 OT엔 없음. 전개도가 발견한 차원은 *새 #18 축*이 아니라 **사이즈#13(작업치수=전개도 평면) + 공정#2(도무송 칼틀·오시 접지선) + 카테고리#7(박스형태=상품 pdtCode 분기)**으로 전부 분배 흡수. ★메모리 핵심 비대칭: **형태가공#14(GS/PD)는 "RP가 평면→입체 *생성*"인데, 박스는 평면(접지된 평면지)까지만 RP 생산 + *입체 조립은 고객 수작업*("납작하게 접힌 상태로 배송") = #14의 *정반대*** → 박스 입체화는 RP 공정도 아님(흡수 불요).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **O-1** | ★3D 제품사이즈 "표시 텍스트"(130×105 높이80) 관리 위치 | 사이즈#13 미저장 파생(앱 계산) | size 프리셋(작업=전개도 평면) 선택 시 *파생 표시*·선택 옵션 아님·비선형 변환(전개도 접기)·메모리 `dbmap-compute-in-app-db-stores-lookup`(판수=앱계산) 동형 | **facet(거부·미저장 파생)** |
| **O-2** | ★dieline 에디터 템플릿(`makers.../templates/{code}` 접지선·풀칠탭 좌표) | 디자인 입력 채널#16 TemplateAsset(D-11) | 박스 dieline=koi 에디터가 로드하는 *디자인 자산*(주문옵션 아님)·#16 TemplateAsset(가격0 시안)·"구조 dieline" sub-type=내부 스키마 unobserved(validator 실측) | **facet(거부·#16)** ★sub-type 미관측 |
| **O-3** | ★재단사이즈(485×270) vs 작업사이즈(495×280) 2치수 동시 표시 | 사이즈#13(재단치수) + plate_size(작업판형) 2축 | ★결정적 — 후니가 재단/작업 2치수를 *이미 2 별개 1급 축*(size=재단·plate_size=작업/임포지션)으로 분리 모델링(`entity-semantic-model.md:22,27`)·박스 여백 10mm=size↔plate 관계·후니가 *아직 박스 2치수 미적재*=data-gap | **facet(거부·★data-gap)** ★결정적 분기 |
| **O-4** | OTPKENV "커스텀 제품" 라벨(봉투상자만) | 카테고리#7 운영 라벨 / 생산형태#15(소량 unobserved) | 옵션 구조는 타 박스와 동일·"커스텀"=주문 운영 분류 마케팅 라벨(PR P-8 용도 태그 동형)·생산형태(C 완제품)는 박스 공통이라 변별 안 됨 | **facet(거부·카테고리#7)** |

### O-1~O-3 양면 트레이드오프 (침묵 선택 거부) ★directive 최강 적대 프로브 — 전개도/dieline이 distinct #18인가

OT reverse §7가 1차 예측한 "전개도/dieline #18 = 부결(흡수)"를 적대 검증. 박스는 *3D 입체·평면 전개도·칼틀·접합*이라는 평면 인쇄물에 전무했던 차원군을 가진 가장 강력한 후보이므로 양방향 적대:

- **(가) distinct "전개도/구조전개(net/dieline) 축 #18" 신설:**
  - 찬성: ① 박스는 평면 인쇄물에 없던 *3종 치수 병기*(제품/재단/작업)·전개도(접지 평면)·칼틀(도무송)·접합(풀칠탭)이라는 입체/구조 차원군 ② "작업사이즈↔제품사이즈"가 *비선형 변환*(전개도 접기·평면→3D)이라 단순 size 프리셋으로 안 보임 ③ dieline 에디터 템플릿이 명함 시안보다 *구조 정보 풍부*(접지선·오시선·풀칠탭 좌표) — "구조 템플릿" 별 자산유형처럼 보임.
  - 반대: ★승격 양방향 기준 둘 다 불충족 — 전개도는 새 슬롯도, KB 결함도 없음.
    - **★승격 기준 ① 전용 슬롯 라이브 실재 = 불충족(전용 슬롯 0·100% 동일 base-data 슬롯):** 박스 옵션 모델은 평면 인쇄물(PR/NC)과 **paper/paper_sub_select/sodu/size/number2_sel/number1_sel 100% 동형**(`[live:detail]` 5박스 일치·새 스키마 슬롯 추가 0). ST 형상 `shape_info`(사이즈와 분리된 *전용 별도 슬롯*) 같은 전개도/접지/3D 전용 관리 슬롯이 OT엔 **0건**. 박스 구조 변형(케이크/납작/반달/봉투·뚜껑/날개/반달)은 전부 **size 프리셋 라벨("케익상자(소) 495×280")** + 표시 텍스트에 융합(별 옵션축 아님)·박스형태=pdtCode 분기(카테고리#7). 3D 제품치수(130×105 높이80)는 *선택 옵션이 아니라 파생 표시값*(O-1·사용자는 작업사이즈=전개도 평면 프리셋만 선택).
    - **★승격 기준 ② 후니 KB 무왜곡 흡수 불가 = 불충족(전부 무왜곡 흡수·KB 결함 명시 없음):** 전개도 차원이 기존 축에 *왜곡 없이* 담김 — 작업사이즈(전개도 평면)=**사이즈#13 + plate_size 작업판형**(후니가 재단/작업 2치수를 *이미 2 별개 1급 축으로 모델링*·`entity-semantic-model.md:22,27`)·도무송 칼틀/오시 접지선=**공정#2 멤버**(ST 칼선·PR 접지 동형)·박스형태=**카테고리#7 상품 분기**·3D 치수=**size 파생**(O-1). 후니 KB에 "전개도/구조전개 어느 축에도 못 담음" 같은 결함 명시 **없음** — ST 형상 G-SK-2 "형상 어느 축에도 없음" 결함과 정반대. → ②불충족.
- **(나) 사이즈#13(작업/재단치수) + 공정#2(도무송 칼틀·오시 접지) + 카테고리#7(상품 분기) 분배 흡수 [채택]:** OT가 더한 것 = 기존 축의 *박스 인스턴스*(작업사이즈=전개도 평면 칼틀·도무송 칼틀=ST 칼선의 박스판·오시 접지=PR 접지의 박스판)이지 새 *축* 아님. 전개도=칼틀의 박스 인스턴스(ST 칼선=공정#2 facet 판정과 동형)·접합(풀칠탭)은 *RP 공정도 아님*(고객 수작업·형태가공#14의 반대·흡수 불요).

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·전개도 #18은 부결(HARD 기준 양방향):** 형상(#17)은 ① 전용 슬롯(shape_info·사이즈와 분리) 실재 + ② 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 **둘 다 충족** → 승격. 전개도 #18은 **① 전용 슬롯 부재**(박스 옵션 모델=평면 인쇄물 100% 동일 슬롯·새 슬롯 0) **+ ② KB 결함 부재**(작업/재단치수=size#13+plate_size·도무송/오시=공정#2·왜곡 없이 담음) **둘 다 불충족** → 부결. ★PH-2 거치(①OBSERVED·②불충족 부결)·FS-1 타일링(①OBSERVED·②불충족 부결)과 같은 부결 계열이되, OT는 **①조차 불충족**(전용 슬롯 자체 부재) = PH-2/FS-1보다 *더 약한 후보의 더 깨끗한 부결*. 역방향 오류(distinct를 facet으로 숨김) 점검: "3D 입체·전개도·칼틀"이 유일 잔여 후보였으나 size#13/plate_size/공정#2/카테고리#7로 무손실 분배 + 입체조립=RP 공정 아님 → facet 정당(숨김 아님·새 관리 관심사 없음).

### O-3 결정적 분기 (재단/작업 2치수 = distinct vs data-gap) ★directive 핵심 분기

reverse fragment 3이 명시한 결정적 분기: 박스의 "재단사이즈(485×270) vs 작업사이즈(495×280) 2치수 동시 표시"가 **(a) 전개도 #18 축의 증거인가, (b) 후니 size축이 *담되 아직 박스 2치수를 적재 안 한* data-gap("사이즈 2치수 표현력")인가** — ST 형상 vessel-gap vs NC 이산tier/PD 내재BOM data-gap 판별 기준 적용:

- **(a) 전개도 축 증거 가설 = 기각.** 재단/작업 2치수는 전개도 *고유 슬롯*이 아니라 **후니가 *이미 2 별개 1급 축*으로 분리 모델링한 두 차원**(`entity-semantic-model.md:22` size=재단치수·`:27` plate_size=작업/전지 판형[임포지션·판걸이]). 평면 인쇄물도 재단치수↔작업사이즈(plate)를 가짐(여백·돔보)·박스의 10mm 여백은 그 일반 관계의 박스 인스턴스 → 전개도 고유 차원 아님.
- **(b) 사이즈 2치수 표현력 data-gap = 채택.** 박스 size 1개 선택에 *재단(485×270)·작업(495×280) 2치수*가 동시 표시:
  - **① 재단치수(완성품 외곽)** = **사이즈#13(size·`_sizes`)** — 고객이 인지하는 완성 외곽.
  - **② 작업사이즈(전개도 펼친 평면 칼틀)** = **plate_size(작업/전지 판형·임포지션)** — 도무송 칼틀이 차지하는 평면 영역(메모리 `dbmap-platesize-is-output-paper`·t_siz 이중등록 동형).
  - **③ 박스 프리셋이 두 치수를 한 라벨로 묶음**("케익상자(소)"→재단·작업·3D 동시) = size↔plate_size *cascade/연계*(후니 2축이 한 프리셋 선택에 묶임).
- **결론: data-gap(vessel-gap 아님).** 후니가 박스류를 취급하려면 size#13에 *재단치수* + plate_size에 *작업/전개도 평면치수*를 한 박스 프리셋으로 묶어 적재해야 — 두 기존 축의 *표현력/연계 적재* 문제이지 새 "전개도 축" 부재 아님. **★NC 이산tier·PD-4 내재BOM·FS-1 타일링·PH-2 거치 data-gap과 동일 계열**(축 충분·데이터/표현력 미적재). 갭분석가 주목: size#13↔plate_size가 박스 1프리셋에 *재단/작업 2치수 묶음*을 수용하는지(t_siz 이중등록 패턴)·3D 제품치수가 size 파생(미저장)인지 별 표시 컬럼인지(O-1) 라이브 확인.

### OT가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC·PD·PH·FS·NC 패턴 반복) + 입체/전개 #18 후보 정면 격파** — 12번째 카테고리(상자/패키징)가 distinct 신축 0 도입. PR(4)→ST(5·형상 1종)→CL(6)→AC(7)→PD(8)→PH(9)→FS(10)→NC(11)→**OT(12)** = 모델 안정성 재확인. **★OT는 선별 모드 핵심 프로브** — *평면 인쇄물에 전무했던 3D 입체·전개도·칼틀·접합* 차원군을 가진 첫 상품군조차 size#13/plate_size/공정#2/카테고리#7 분배로 무손실 흡수 = ①전용 슬롯조차 부재한 가장 깨끗한 부결(PH-2/FS-1은 ①OBSERVED·②불충족이었으나 OT는 ①②둘 다 불충족).
2. **사이즈#13 + plate_size 2축 분리의 재확인** — 박스 재단/작업 2치수가 후니가 *이미 size(재단)·plate_size(작업/임포지션)로 분리 모델링한 2축*에 정확히 매핑(O-3 data-gap). 박스가 두 축의 분리 설계를 *역으로 검증*(평면 인쇄물보다 두 치수 차이가 큰 입체물에서도 같은 2축으로 표현).
3. **공정#2 도무송 칼틀·오시 접지선 = ST 칼선/PR 접지의 박스 인스턴스** — 전개도 칼틀=ST `THO_DFT` 프리셋 칼틀의 박스판·오시 접지선=PR FLD_DFT/OSI_DFT 접지 공정의 박스판. 같은 공정 멤버가 상품군별로 다른 *관리 위치*(스티커=칼선·리플렛=접지옵션·박스=size 프리셋 융합)에 매핑됨 재확인.
4. **★형태가공#14 비대칭 명시 — 박스 입체화는 RP 공정 아님** — GS/PD 형태가공#14는 "RP가 평면→입체 *생성*"(없으면 본체 부재)이나, 박스는 *평면(접지된 평면지)까지만 RP 생산 + 입체 조립은 고객 수작업*("납작하게 접힌 상태 배송"). 형태가공#14의 *정반대* — 박스 접합/조립은 흡수처조차 불요(RP 생산 범위 밖). 형태가공#14가 "본체 생성 공정"이지 "모든 입체화"가 아님을 박스가 음의 사례로 확정.
5. **#16 TemplateAsset(D-11) dieline 자산 = 디자인 입력 채널의 구조 인스턴스** — 박스 dieline(접지선·풀칠탭 좌표 도안)=koi 에디터가 로드하는 디자인 자산(주문옵션 아님)·#16 TemplateAsset. "구조 dieline" sub-type 필요 여부는 `makers.../templates/{code}` 응답 스키마 unobserved(O-2·validator 실측 대상)이나, 디자인 자산 카테고리 자체는 #16으로 흡수(별 축 아님).
6. **3D 제품치수 미저장 파생 = 앱 계산 패턴 재확인** — 제품사이즈(3D 가로×세로×높이)는 작업사이즈(전개도 평면) 선택 시 *파생 표시*(비선형 변환·전개도 접기)·선택 옵션 아님. 메모리 `dbmap-compute-in-app-db-stores-lookup`(판수=앱계산·off-grid ceiling) 동형 — DB는 룩업/저장, 3D 환산은 앱 파생(O-1·갭분석가 라이브 확인: size 파생 vs 별 표시 컬럼).

### ★dbmap 정합 (size↔plate_size 분리·메모리 `dbmap-platesize-is-output-paper`와의 관계)

OT 판정과 dbmap 교훈은 **같은 결론, 다른 렌즈** — 상호 강화:
- **dbmap 렌즈(적재/이해 단위):** size(재단치수)↔plate_size(출력용지규격/작업판형)는 *이미 별개 t_* 축*(goods-pouch G-GP-2 "작업사이즈만 적재·재단치수 누락" 결함·t_siz 이중등록 impos_yn). 박스 2치수=그 분리의 입체물 인스턴스.
- **rpmeta 렌즈(메타모델 축):** 전개도는 *distinct 신축 #18이 아니라* — size#13 + plate_size 2축의 박스 묶음(data-gap)·도무송/오시=공정#2·박스형태=카테고리#7. 신축 강요는 기존 2축 중복.
- **같은 결론:** 둘 다 "박스 입체/전개를 *과대한 전개도 절대축*으로 두지 말라 — 재단/작업 2치수는 후니 size/plate_size 2축이 이미 표현"이라는 동일 판정. 박스가 size↔plate_size 분리 설계를 입체물에서 *역으로 검증*(평면보다 두 치수 차이 큰 박스에서도 같은 2축).

---

## ═══ PO 통합 발굴 (v13.0 — 포맥스/폼보드·제작방식(합지 vs 직접출력)·자립구조(등신대 거치대/피켓)·컷아웃 형상·타일링) ★기재마운팅/자립구조 #18 적대 판정·재포화 ═══

> `categories/PO/reverse.md` PO-1~PO-4 판정(reverse §6 1차 예측 부결을 적대 비준). **13 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS·NC·OT·PO) 증거.** ★**distinct 승급 0건 — 17축 재포화(PR·CL·AC·PD·PH·FS·NC·OT 패턴 반복·★기재마운팅/자립구조 #18 부결).** PO(포맥스/폼보드 경질 기재에 사진/그래픽을 출력한 홍보용 POP·등신대·피켓 = 7상품)는 **선별 모드 13번째 프로브** — 평면 인쇄물에 없던 *제작방식(합지=종이 출력물을 보드에 합지 vs 직접출력=보드에 직접 인쇄)·자립 구조(등신대 자립 컷아웃·피켓 손잡이·거치대 add-on)*를 가진 강력한 "기재마운팅/자립구조 distinct #18" 후보. ★**PO 결정적 우월점 = PH(Vue client-render·SSR-negative)·AC(SSR-negative)와 달리 7상품 전부 레거시 SSR 완전노출**(`<select>`·옵션아이콘·부자재 토글·캐스케이드 1회 GET 실측) → distinct 판정이 *관측 기반*(추정/판정불가 0). 4 fragment(PO-1~PO-4) 적대 판정 후 **전부 facet/관계 간선.** 상세 = `_resolved-fragments.md` PO 섹션.
> 도메인 정초 = `07_domain/{process-recipe-tree.md(인쇄방식 5종 PROC_000002~6 = 최상위 레시피 축·합지/라미=공정 멤버),entity-semantic-model.md(addl_product 부속물 #9·자재 두께/색 합성·면적 사이즈·형상 #17 경계)}` + NC(인쇄방식 #12 token bundle)·PH(거치 옵션 캐스케이드 부결)·AC(두께=자재 facet·소재 variant·받침 부속물)·ST(형상 #17·완칼 공정)·BN(면적 사이즈·대형출력)·PD(완제 내재BOM 부속물#8) 직접 대조. **★domain-researcher(경질 기재 인쇄·합지 도메인) 신규 호출 불요** — 제작방식(합지=종이 인쇄→보드 라미네이트 *공정*·직접출력=보드 직접 인쇄·둘 다 인쇄방식#12 게이팅)·기재(=자재#1 포맥스/폼보드×두께×검정 합성)·자립(=형상#17 모양재단+부속물#8 거치대 add-on)·타일링(=공정#2 대형 분할출력)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PO 핵심 판정 — directive 최대 관전 2건(기재마운팅·자립구조이 distinct #18인가): 둘 다 부결.** ★결정적 — **제작방식(합지/직접출력)은 한 상품 내 "제작방식 select"가 없고**(pdtCode 분기 + paper 옵션값 검정 variant + 코팅 캐스케이드로 인코딩) NC 인쇄방식과 동형으로 **이미 #12(D-7 인쇄방식/생산 레시피)로 등재된 축의 라미네이트 인스턴스 + 자재#1 검정 variant + 공정#2 코팅 가용성**으로 분해 흡수. **자립구조는 등신대=형상#17(모양재단 CUT_ZUN_ZDFRM)+부속물#8(거치대 CDL_DFT add-on·GS/GSSBMTL 독립 부자재 SKU 참조)·피켓=형상#17(손잡이 컷)+부자재 무(자립 add-on 불필요)**로 분해 = PH 거치(옵션 캐스케이드 흡수·#18 부결)와 완전 동형이되 **PO는 거치대가 명시 부자재 SKU·SSR 실측 → 관측 기반 부결로 격상**(PH가 §0.5 재캡처로 OBSERVED 격상한 것을 PO는 1회 GET으로 달성).

| frag | 정체 | 1차 귀속 | 판정 | distinct/facet |
|---|---|---|---|---|
| **PO-1** | ★제작방식(합지 HAP vs 직접출력 PRT) | 인쇄방식레시피#12(D-7·합지=라미 공정 게이팅) + 자재#1 검정 variant + 공정#2 코팅 캐스케이드 | 한 상품 내 "제작방식 select" 부재(pdtCode 분기·NC item_gbn 동형)·합지=종이 인쇄→보드 라미네이트 공정·검정포맥스/검정폼보드=자재#1 색/면 variant·코팅 가용성(HAP=True/PRT=False) 캐스케이드=제작방식이 후가공 게이팅(#12)·후니 KB "제작방식 어느 축에도 없음" 결함 없음 | **분산 facet(거부·#12 재확인·#18 부결)** ★최강 #18 후보 |
| **PO-2** | ★등신대 거치대(CDL_DFT) 다중 귀속(PO add-on vs GS 독립 SKU) | 부속물#8 add-on(독립 부자재 SKU 참조) | `opt_use_yn('CDL_DFT')` 선택형 부자재 토글(PO 상품 add-on)이면서 `GS/GSSBMTL/detail/54`(굿즈 부자재 독립상품) = 한 부자재 두 경로(본상품 add-on + 독립 SKU)·BN 아일렛/AC 받침 add-on 동형·"add-on이 독립 SKU 참조" 정규화는 그릇 단계 | **facet(거부·부속물#8·#18 부결)** ★자립구조 핵심 |
| **PO-3** | number4_sel(1배~10배 면적배수) 수량 vs 가격계수 | 수량#10 / 가격기여역할#11(면적계수) 경계 | number1_sel(디자인 수/건수)와 별도·real_price=면적 기반 → "배수"=출력 면적 배수(가격계수) 가능성·BN 현수막 면적×배수 동형·real_price 가격엔진 실측 unobserved(huni-widget 영역) | **facet(거부·#10/#11 경계·data-gap)** |
| **PO-4** | "사이즈 직접입력"(비규격 면적) 사이즈#5 enum vs 면적 연속차원 | 사이즈#13 면적 연속차원(가로×세로 구간) | size select=1000X1000 1개 고정 + 사이즈 직접입력(CUT_WDT/HGH 가로세로) = 사실상 비규격 면적 연속차원·BN 현수막/실사 면적매트릭스(siz_width/siz_height 구간) 동형·이산 siz_cd 아님 | **facet(거부·면적축·BN 동형)** |

### PO-1/PO-2 양면 트레이드오프 (침묵 선택 거부) ★directive 최대 관전 의사결정 — 기재마운팅(제작방식)·자립구조이 distinct #18인가

PO reverse §6가 1차 예측한 "기재마운팅/자립구조 #18 = 부결(흡수)"를 적대 검증. PO는 *제작방식(합지/직접출력)·자립 컷아웃·거치대 add-on*이라는 평면 인쇄물에 없던 차원군 + 거치대 독립 SKU까지 가진 가장 강력한 후보이고 SSR 완전노출이라 양방향 적대(관측 기반):

- **(가-제작방식) distinct "기재마운팅/제작방식(합지/직접출력) 축 #18" 신설:**
  - 찬성: ① 합지 vs 직접출력이 *상품을 가르는 근본 차원*(검정 기재 variant·코팅 가용성·라미 마감을 동반 결정·인코딩 게이팅처럼 보임) ② "합지(파인아트)"라는 고유 제작 공법(종이 출력→보드 라미네이트)이 평면 인쇄물에 없던 입체 기재 마운팅 ③ 코팅이 합지에만 활성(HAP=True/PRT=False) = 제작방식이 후가공을 게이팅하는 governing.
  - 반대: ★승격 양방향 기준 둘 다 불충족 + 결정적으로 **제작방식=인쇄방식의 일종 → 이미 #12(D-7)로 등재됨 — 신축 #18은 #12 중복**(NC 인쇄방식 #18 부결과 정확히 동형).
    - **★승격 기준 ① 전용 슬롯 라이브 실재 = 불충족(한 상품 내 "제작방식 select" 0·pdtCode 분기 enum):** 합지/직접출력은 ST 형상 `shape_info`(사이즈와 분리된 *전용 별도 슬롯*)와 달리 — **한 상품 내 제작방식 옵션 슬롯이 없음**(reverse §0.1 실측). POMXPRT(직접출력)·POMXHAP(합지)는 *별 pdtCode 상품*이고, 차이는 ① paper select 값(검정 variant 추가·기존 자재 슬롯의 다른 값) ② 코팅 옵션아이콘 활성/비활성(기존 공정 슬롯) ③ 상품명 "파인아트"(라미 마감)로 인코딩 = **새 스키마 축(슬롯) 추가 0.** `item_gbn`/pdtCode=상품에 박힌 *discriminator enum*(NC item_gbn=offset2023·CL clothes2025·PR pdtCode prefix·ST 인쇄방식 prefix 동형·명제 #19 "분기 discriminator는 축 아님").
    - **★승격 기준 ② 후니 KB 무왜곡 흡수 불가 = 불충족(전부 무왜곡 흡수·KB 결함 명시 없음):** 제작방식 차이가 기존 축에 *왜곡 없이* 담김 — 제작방식(합지/직접출력)=**인쇄방식레시피#12 D-7**(이미 등재·게이팅 lifecycle 보유·합지=라미네이트 공정·직접출력=보드 직접인쇄)·검정 기재 variant=**자재#1**(검정포맥스/검정폼보드=색/면 variant·AC 소재 variant·GS 코스터 G-2 동형)·코팅 가용성 캐스케이드=**공정#2 후가공 + #12 게이팅**(인쇄방식이 가능 후가공 게이팅). 후니 KB에 "제작방식 어느 축에도 못 담음" 같은 결함 명시 **없음** — 정반대로 `process-recipe-tree.md §1`이 인쇄방식을 *최상위 레시피 축으로 1급 모델링*(PROC_000002~6·게이팅)·합지/라미는 그 공정 멤버. ST 형상 G-SK-2 "형상 어느 축에도 없음" 결함과 정반대 → ②불충족.
- **(나-제작방식) 인쇄방식레시피#12(D-7) 라미 인스턴스 + 자재#1 검정 variant + 공정#2 코팅 게이팅 facet [채택]:** PO가 더한 것 = #12 인쇄방식 축의 *합지/직접출력 인코딩*(NC offset2023 토큰·BN 자재 facet·ST/PR pdtCode prefix·CL 상품내 옵션·NC item_gbn 토큰에 이은 *5번째 인코딩*: PO=제작방식 pdtCode 분기 + paper variant) *강화*이지 새 *축* 아님. **★합지(라미네이트)는 인쇄방식#12의 게이팅 멤버**(직접출력=보드 직접인쇄·합지=종이 인쇄+라미)이고, 코팅 가용성 캐스케이드는 #12가 후가공을 게이팅하는 D-7 lifecycle의 PO 인스턴스(NC 옵셋이 자재풀을 게이팅한 P-7과 동형 = 인쇄방식이 가능 옵션 부분집합 게이팅).

- **(가-자립구조) distinct "자립구조(등신대 자립/피켓 손잡이) 축 #18" 신설:**
  - 찬성: ① 등신대 자립 컷아웃·피켓 손잡이가 평면 인쇄물에 없던 *자립/거치 구조* 차원 ② 거치대(CDL_DFT)가 *전용 부자재 토글 슬롯*으로 실재(ST 형상 shape_info처럼 "전용 슬롯=distinct 신호")·700/1200/1500mm select ③ 자립방식(등신대=거치대 add-on·피켓=내재 손잡이)이 상품을 가르는 구조 차원.
  - 반대: ★세 근거 전부 기존 축의 *표현/구현*으로 무손실 분해 — distinct가 요구하는 "기존 축이 *왜곡 없이* 못 담는 고유 lifecycle/governing"이 **없음**(PH 거치 부결·동형).
    - **① 컷아웃 형상(등신대 인물형/피켓 형태)** = **형상#17 SHAPE + 공정#2(컷팅)** — `CUT_ZUN_ZDFRM`(모양재단) 옵션아이콘 = ST 완칼/형상#17의 PO 인스턴스(정사이즈재단 ZDINC vs 모양재단 ZDFRM 라디오). 등신대 자립의 "인물형 컷"=형상#17(이미 ST에서 승격된 축이 담음·왜곡 없음).
    - **② 거치대(CDL_DFT)** = **부속물#8 add-on** — `opt_use_yn('CDL_DFT')` 선택형 부자재 토글(부자재 섹션 `sub_opt2_tr`)·700/1200/1500mm select. **★거치대는 별 상품(`GS/GSSBMTL/detail/54` 굿즈 부자재 독립 SKU)으로도 존재** = 본상품에 add-on 결합되는 독립 부자재 SKU(후니 KB `entity-semantic-model.md:30` addl_product "완제 부속: 거치대·우드봉·볼체인·부착공정과 축 분리"·D-1 부속물 distinct가 정확히 이것·BN 거치대·AC 등신대 받침·PD 다리/받침 횡단 동형). **PH 거치(탁상용/벽걸이)가 옵션 캐스케이드로 흡수된 것보다 한술 더 떠 명시 부자재 SKU로 분리관리** → 부속물#8이 무왜곡 흡수.
    - **③ 자립방식이 상품 가름(등신대 vs 피켓)** = **부속물#8 유무 facet** — 피켓(POFMPCK)은 거치대(CDL)·와이어(WIR) 부자재 *없음*(reverse §0.3 실측 `cdl거치대=False·와이어=False`)·손잡이 보드라 자립 add-on 불필요·모양재단만. 등신대는 거치대 add-on 결합. 즉 자립방식=형상#17(컷) + 부속물#8(거치대 유무) 두 기존 축의 조합이지 별 "자립구조 축" 아님.
- **(나-자립구조) 형상#17(모양재단) + 부속물#8(거치대 add-on·독립 SKU 참조) facet [채택]:** PO가 더한 것 = 형상#17(모양재단=ST 완칼의 PO 인스턴스)·부속물#8(거치대=GS/GSSBMTL 독립 부자재 SKU add-on·BN 거치대/AC 받침 합류)이지 새 *축* 아님. PH 거치(옵션 캐스케이드)보다 *더 명시적 부속물 SKU 분리관리*(distinct 부결이 한층 강화).

**★ST 형상(#17)과의 결정적 차이 — 왜 형상은 승격·기재마운팅/자립구조는 부결(HARD 기준 양방향):** 형상(#17)은 ① 전용 슬롯(shape_info·사이즈와 분리) 실재 + ② 후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 **둘 다 충족** → 승격. 기재마운팅(제작방식) #18은 **① 전용 슬롯 부재**(한 상품 내 제작방식 select 0·pdtCode 분기 enum·NC item_gbn 동형) **+ ② KB 결함 부재**(제작방식=#12로 이미 1급·합지=라미 공정·왜곡 없이 담음) **둘 다 불충족** → 부결. 자립구조 #18은 **① 거치대 전용 슬롯 OBSERVED(CDL_DFT·SSR 실측·충족)이나 ② KB 결함 부재**(형상#17·부속물#8이 왜곡 없이 담음·거치대=GS/GSSBMTL 독립 SKU로 후니 addl_product에 정확히 매핑) → ②불충족 부결. **★PO 결정적 우월점 = 관측 기반 양방향 부결** — PH 거치는 §0.5 client-render 재캡처로 OBSERVED 격상이 필요했으나(SSR-negative 블로커), PO는 7상품 전부 SSR 완전노출 1회 GET으로 거치대/모양재단/제작방식 전부 *직접 실측* → distinct 부결이 "판정 불가/추정"이 아니라 **가장 깨끗한 관측 기반 부결**(ST 형상 승격·PH/FS/NC/OT 부결과 같은 결정 기준 적용). 부결 계열 위상: **제작방식=NC 인쇄방식 동형(①②둘 다 불충족·이미 #12)·자립구조=PH 거치 동형(①OBSERVED·②불충족)** — 두 directive 후보가 각각 기존 부결 선례에 정확히 합류. 역방향 오류(distinct를 facet으로 숨김) 점검: "합지 제작방식·등신대 자립 컷아웃·거치대 add-on"이 유일 잔여 후보였으나 #12(인쇄방식)·형상#17·부속물#8로 무손실 분배 + 제작방식 자체가 #12 → facet 정당(숨김 아님·새 관리 관심사 없음).

### PO-3 결정적 분기 (number4_sel 면적배수 = 수량#10 vs 가격#11·data-gap) ★directive 핵심 분기

reverse PO-3가 명시한 분기: `number4_sel`(1배~10배)가 **(a) 수량#10 슬롯인가, (b) real_price 면적 가격계수(가격기여역할#11)인가** — 단, real_price 가격엔진 실측이 unobserved(huni-widget 가격역공학 영역·이번 미확보)라 *경계 표기 + data-gap*:
- **(a) 수량 가설:** `number1_sel`(디자인 수/건수)가 본 수량 슬롯(수량#10 D-5 다중 수량 슬롯). number4는 별도.
- **(b) 면적 가격계수 가설:** PO=real_price(대형실사·면적 기반)·"1배~10배"=출력 면적 배수일 가능성(BN 현수막 면적×배수 동형) = 가격기여역할#11(D-6 곱수형 price_flag).
- **결론: #10/#11 경계 + data-gap(vessel-gap 아님).** number4가 수량이든 면적계수든 둘 다 기존 축(#10 수량 다중 슬롯·#11 곱수형 가격기여)이 담음 — real_price 엔진 실측 후 확정할 *표현력/적재* 문제이지 새 축 부재 아님. **★NC 이산tier·OT 2치수·PD-4 내재BOM data-gap과 동일 계열**(축 충분·데이터/엔진 실측 미확보). 갭분석가 주목: number4_sel이 수량(`product_prices` qty 차원)인지 면적 곱수(formula 계수)인지 real_price 엔진 라이브 확인.

### PO-4 결정적 분기 (사이즈 직접입력 = 면적 연속차원·data-gap) ★directive 핵심 분기

reverse PO-4: "사이즈 직접입력"(비규격 면적)이 **(a) 사이즈#13 이산 enum인가, (b) 면적 연속차원(가로×세로 구간)인가** — BN/AC 면적매트릭스 동형 판별:
- **(a) 이산 enum 가설 = 기각.** size select=`1000X1000` 1개 고정 + `사이즈 직접입력`(CUT_WDT_SEL/CUT_HGH_SEL 가로/세로 직접) = *이산 규격 거의 없음*·사실상 비규격 연속.
- **(b) 면적 연속차원 = 채택.** PO 사이즈=가로×세로 직접입력 비규격 면적 = **사이즈#13의 면적 연속차원 모드**(BN 현수막·실사 동형·dbmap 면적매트릭스 `siz_width`/`siz_height` 구간·메모리 `dbmap-area-matrix-wh-dimension`). 이산 siz_cd 채번 불요·`{siz_width, siz_height}` 구간 단가.
- **결론: 면적축(BN 동형)·data-gap.** PO 사이즈=이산 enum 아니라 면적 연속차원 — 사이즈#13이 *이산 프리셋·면적 연속 두 모드*를 가짐(OT 박스 2치수·NC 이산 부수와 같은 사이즈 표현력 계열). 후니가 PO류 취급 시 면적매트릭스 그릇(siz_width/siz_height 구간)에 적재 = data-gap이지 vessel-gap 아님. distinct 아님(BN과 동형).

### PO가 입증한 것 (축 신설 아닌 *강화* + 17축 재포화)

1. **★17축 재포화(PR·CL·AC·PD·PH·FS·NC·OT 패턴 반복) + directive 최대 관전 2건 정면 격파** — 13번째 카테고리(경질 기재 POP·등신대·피켓)가 distinct 신축 0 도입. PR(4)→ST(5·형상 1종)→CL(6)→AC(7)→PD(8)→PH(9)→FS(10)→NC(11)→OT(12)→**PO(13)** = 모델 안정성 재확인. **★PO는 SSR 완전노출 13번째 프로브** — 가장 강력한 *제작방식(합지/직접출력)·자립구조(등신대/피켓·거치대 add-on)* 후보 2건조차 #12(인쇄방식)·형상#17·부속물#8로 무손실 흡수 = 관측 기반 양방향 부결(추정 0·PH가 §0.5 재캡처로 달성한 OBSERVED 격상을 PO는 1회 GET으로).
2. **인쇄방식#12(D-7) 5번째 인코딩(제작방식 합지/직접출력) 입증** — #12가 (a)자재 facet(BN 수성/라텍스) (b)pdtCode prefix(ST/PR) (c)상품내 옵션(CL) (d)item_gbn/price_gbn 토큰 bundle(NC) (e)**제작방식 pdtCode 분기 + paper 검정 variant + 코팅 게이팅(PO)** 다섯 표현. **★합지=라미네이트 공정이 #12 게이팅 멤버**·코팅 가용성 캐스케이드(HAP=True/PRT=False)=#12가 후가공 게이팅하는 D-7 lifecycle PO 인스턴스(NC P-7 자재풀 게이팅 동형).
3. **자재#1 검정 variant + 기재×두께×색 합성 입증** — paper select 한 값=`검정폼보드 3T`처럼 *기재종류×두께×색 한 리터럴 합성*(별 두께/기재 select 없음·AC 두께 mat_cd 직교 동형)·검정 variant=합지 고유 색/면 facet(GS 코스터 G-2 pdtCode 소재 분기 동류). `{substrate(포맥스/폼보드), thickness(3T~10T), color(흰/검정)}` 분해(평면 라벨=의미축 drop·G-1/AC variant 처방).
4. **부속물#8 "거치대 add-on이 독립 부자재 SKU 참조" 강화** — 거치대(CDL_DFT)=본상품 add-on이면서 `GS/GSSBMTL/detail/54` 독립 부자재 SKU = D-1 부속물 distinct의 가장 명시적 인스턴스(BN 거치대·AC 등신대 받침·PD 다리/받침 합류)·와이어(WIR_DFT/MTR 세트/레일용/피스용)=부속물#8 걸이(BN 고리/아일렛). **★PH 거치(옵션 캐스케이드)보다 강한 부속물 분리관리** — "add-on이 독립 SKU를 참조"하는 정규화(template_selections 결합 vs 옵션값 복제)는 그릇 단계 판정(PO-2).
5. **형상#17 모양재단(컷아웃) PO 인스턴스 + 자립=형상+부속물 분해 입증** — `CUT_ZUN_ZDFRM`(모양재단)=ST 완칼/형상#17의 PO 인스턴스(정사이즈 vs 모양 라디오)·등신대 자립의 인물형 컷=형상#17(왜곡 없음). 자립방식(등신대=거치대 add-on·피켓=내재 손잡이·부자재 무)=형상#17+부속물#8 조합으로 분해 = **별 "자립구조 축" 불필요**(PH 거치 부결 관측 기반 강화).
6. **사이즈#13 면적 연속차원 + 공정#2 타일링(대형 분할출력) 재확인** — PO 사이즈=가로×세로 직접입력 비규격 면적(BN/실사 면적매트릭스 siz_width/siz_height·이산 siz_cd 아님·PO-4)·타일링(TIL_NON/HGH/WDT)=공정#2 대형 분할출력(BN 현수막 대형출력·FS 타일링 인쇄 배치 파라미터 동형·real_item 카테고리 고유 생산옵션). 인쇄면(sodu 단면/양면·등신대=단면 고정)=도수#3/공정#2(인쇄면).

### ★dbmap 정합 (인쇄방식≠절대축·면적매트릭스·메모리 `dbmap-print-method-not-absolute-axis`/`dbmap-area-matrix-wh-dimension`와의 관계)

PO 판정과 dbmap 교훈은 **같은 결론, 다른 렌즈** — 상호 강화:
- **dbmap 렌즈(적재/이해 단위):** "인쇄방식(제작방식 포함)은 *절대 최상위 축* 아님 — 시트(상품군)가 1차 이해 단위." PO=대형실사(real_price·면적 기반) 시트의 한 family·합지/직접출력은 그 시트의 속성. 면적 사이즈=면적매트릭스(siz_width/siz_height 구간·이산 siz 채번 불요).
- **rpmeta 렌즈(메타모델 축):** 제작방식은 *distinct 신축 #18이 아니라* — 이미 #12(D-7·NC 동형)·자립=형상#17+부속물#8·면적=사이즈#13 면적 연속차원. 신축 강요는 #12/형상/부속물 중복.
- **같은 결론:** 둘 다 "제작방식/자립을 *과대한 절대 분류축*으로 두지 말라"는 동일 판정. PO 합지가 *별 가격엔진을 가진 것도 아니고*(NC 옵셋과 달리 real_price 공유) *시트(포맥스/폼보드 POP)가 1차 단위*이며 제작방식은 그 속성(#12 게이팅)이라는 dbmap 교훈을 rpmeta가 관측 기반(SSR 실측)으로 재확인. **★상호 보강:** dbmap은 "후니 라이브 적재 관점"(제작방식 미적재가 대세 무영향·면적매트릭스 그릇 실재)·rpmeta는 "RP 메타모델 추상화 관점"(제작방식=#12·자립=형상#17+부속물#8) — 두 관점이 충돌 없이 "기재마운팅/자립구조≠독립 절대축" 결론으로 수렴.

---

## 갭 — 추가 샘플 필요(과잉 일반화 방지)

1. **카테고리 트리/다중분류:** BN·GS 둘 다 옵션 트리 라이브 추출 불가(신규 Vue) → 한 상품 여러 트리 소속·트리 깊이 미관측. **책자(booklet)·문구(stationery) reuse 캡처 권고.**
2. **템플릿(완제 SKU) 계층:** GS DIR_MTR로 완제 본체는 확인했으나 *번들 구성(template_selections)*은 미관측(봉투결합 엽서·OTC). 완제 SKU + 부속물 묶음 샘플 필요.
3. **vTmpl vs tmpl 가격모델 분기 조건:** GSPDLNG만 vTmpl 단일 샘플 → variant 유무가 가격모델을 어떻게 가르는지 확정 불가. variant 상품 추가 캡처 권고.
4. **생산형태 enum 완전성:** 기성·디자인 형태(D-9)는 도메인 권위로만 확정, RP 직접 관측은 완제품(C)·통합(A)·셋트(B) 위주. 디자인/기성 굿즈 캡처로 보강.
5. **(PR) 인쇄방식별 자재풀·옵션 차이:** 토너(PRBKO*)·인디고(PRIDPRT)·리소(PRPORSO) 책자가 윤전(PRBKYPR)과 내지 자재풀(YWM 미사용 추정)·최소수량·페이지범위·가격모델 어떻게 다른지 unobserved(catalog 상품명만). 로그인 캡처로 P-7 자재풀 게이팅 확정.
6. **(PR) 리플렛 접지 강제여부·면수 cascade:** 리플렛(PRLFXXX) 신규 Vue SSR-negative — 접지 7종은 포스터 실측이나 리플렛의 접지필수/접지방식↔면수↔오시 cascade는 unobserved. P-1 cascade 확정에 필요.
7. **(PR) INN_PAGE↔가격 결합·스코딕스/박 후가공 상세:** 책자 페이지 선형가산은 실측(Δ1,120/page), 캘린더 INN_PAGE↔tiered_price 결합(TP T-7)은 unobserved. 스코딕스 패턴·박색(FOI)·레이저커팅 칼틀값 상품명만(P-9).
8. **(OT) dieline 에디터 템플릿 내부 스키마(O-2):** 박스 dieline(`makers.../templates/{code}` 접지선·오시선·풀칠탭 좌표)이 #16 TemplateAsset(가격0 디자인 시안)으로 충분한가, "구조 dieline(structural)" sub-type 필요한가 — 응답 스키마 unobserved. **validator가 `makers.redprinting.net/v1/templates/{code}` 응답 실측해 #16 단일 자산유형 vs 구조 sub-type 확정.**
9. **(OT) 3D 제품치수 저장/파생(O-1):** 박스 제품사이즈(3D 가로×세로×높이)가 size 프리셋의 *미저장 파생*(앱 계산·전개도 접기)인가 *별 표시 메타데이터 컬럼*인가 — 후니 t_siz에 박스 3D 표시 컬럼 부재 추정이나 라이브 미확인. **갭분석가가 size#13↔plate_size 박스 2치수 묶음 수용력(O-3 data-gap) + 3D 파생 여부 라이브 확인.**
10. **(OT) OTCPHOL 에어홀더 미캡처:** 컵홀더 구조(평면 조립 추정·클래퍼류)·박스 패턴과 다를 가능성 낮으나 unobserved. 출시/접근 가능 시 클래퍼류 동형 확인.
