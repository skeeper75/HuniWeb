# TP(디자인템플릿) — codex-cli Deep-Augmentation (deepcheck)

> rpm-deepcheck. RedPrinting TP 카테고리 분석(reverse + metamodel 16축 + gap §VIII~X + vessel V-10/V-11)을
> 독립 OpenAI 모델(codex-cli·gpt-5.5/ChatGPT)에 컨텍스트로 주고, 우리 TP 분석이 놓친
> 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보를 second-opinion으로 발굴한 산출물.
>
> **[HARD] 환각 경계:** codex(OpenAI) 제안 = `unverified` 가설. 후니 라이브/엑셀/RedPrinting 라이브 권위로
> 검증되기 전엔 사실 아님. codex 후보를 deepcheck 자신이 채택하지 않는다(triage까지). 검증 후 살아남는
> 후보만 metamodel-architect(Ph3)·gap-analyst(Ph4)·reverse-engineer(Ph2)로 라우팅.

---

## 상태: ✅ DEEPCHECK 완료 — codex 가용·후보 53건 발굴·triage 완료 · **H-8 검증→REFUTED(2026-06-17)**

> **[2026-06-17 검증 갱신] H-6·H-1 라이브 실측 판정 완료 (rpm-metamodel-architect).**
> codex 비신뢰·실측 권위로 두 후보를 검증한 결과 **둘 다 우리 기존 판정이 옳음**:
> - **H-6 VDP = REFUTED(facet 유지)** — VDP는 에디터 SDK 종속 능력(메서드 3개)이지 독립 lifecycle 1급축 아님. → §HIGH 표 H-6 상태 `rejected`.
> - **H-1 STATE = OUT-OF-SCOPE(주문 런타임)** — 본 하네스(기초데이터 관리축) 범위 밖. → §HIGH 표 H-1 상태 `out-of-scope`.
> 근거·실측은 본 문서 말미 **"## 검증 결과 — H-6·H-1 (2026-06-17 실측)"** 섹션 참조. discovered-axes 반영 = 무변동(facet/축 신설 0).

- **codex 가용 확인:** trivial ping → `PONG`(gpt-5.5, ChatGPT 계정, read-only sandbox, codex v0.140.0). BN deepcheck 당시 블로커(CLI 0.38.0 버전 불일치)는 **해소됨**(config.toml 기본모델 gpt-5.5·CLI 0.140.0).
- **consult:** `cat _tmp/rpm-tp-context.md | codex exec -c mcp_servers='{}' --sandbox read-only --skip-git-repo-check --output-last-message /tmp/rpm-deepcheck-TP.md -`
- **결과:** 178줄·**53 후보**(Q1 에디터/템플릿 관리축 15 · Q2 구조적 차이 상품 18 · Q3 축체계 오류/대안 7 · Q4 도메인 사실 18, 일부 중복). **다수 RedPrinting 라이브 인용 동반**(TPCAPTW 포토카드화이트·TPBLMEO 떡메·TPBLPST 점메 상품페이지 — checkable 강도 높음).
- 비밀값·.env 프롬프트 주입 0(준수). RedPrinting=사용자 본인 시스템·읽기전용.

---

## Triage 요약 (53 후보 → 분류)

| 분류 | 건수 | 비율 |
|---|---:|---|
| **HIGH** 검증가치(신규 축/갭 후보) | **9** | 17% |
| **MED** 검증가치(기존 축 보강·구조 상세) | 19 | 36% |
| **LOW**(샘플 확대 시·우선순위 낮음) | 10 | 19% |
| **이미 커버됨**(우리 분석에 있음) | 12 | 23% |
| **환각의심/부적용** | 3 | 6% |

> 정직 분류: codex가 우리 16축·gap·vessel을 컨텍스트로 받았음에도 **이미 커버된 항목을 23% 재제기**(VDP 승격·페이지계층·item_gbn 어댑터·특수인쇄 레이어순서 등 — 우리가 이미 facet/판정한 것). 이를 "신규"로 채택하지 않고 정직히 폐기. **순 신규 검증가치(HIGH+MED) = 28건.**

---

## HIGH — 검증가치 최상 (신규 축/갭 후보, 라우팅 권고)

> 우리 16축·gap에 **대응 슬롯이 없거나 약한** + checkable. 검증 후 살아남으면 metamodel/gap 재진입.

| # | claim | 상태 | 분류 | 라우팅 | 검증법 |
|---|-------|------|------|--------|--------|
| **H-1** | **승인/교정 워크플로 = 누락된 주문 라이프사이클 STATE 축**(draft→preflight→고객확인→운영자검수→생산잠금). 16축 어디에도 직교한 상태축 부재. 생산은 가변 에디터 draft에서 시작하면 안 됨 | **rejected (out-of-scope)** | **신규 축 후보 → 범위 외** | ~~metamodel-architect~~ → **huni-dbmap MES/주문 트랙** | **[검증 2026-06-17]** 라이브 46 BASE 테이블에 주문/상태/워크플로/승인 그릇 0건(`t_ord_*`/`*_status`/`*_state`/`*_approv` 전무). 주문 인스턴스 *런타임 상태축*이며 base-data 관리축 아님 → **OUT-OF-SCOPE.** [[dbmap-goal-ui-quote-mes]] |
| **H-2** | **교정 라운드 정책**(허용 시안 라운드 수·추가 교정비·마감 영향)이 디자인 상품 1급 관리 데이터. 유·무료 디자인 보조 상품이 이를 인코딩 | unverified | 신규 축/제약 후보 | **metamodel-architect / gap-analyst** | 후니 admin CS/디자인요청 워크플로·상품가이드 "시안/교정/수정" 페이지. 우리 분석 부재 |
| **H-3** | **에디터 preflight 프로파일 = 별도 제약 축**(bleed·safe-zone·trim box·color mode·overprint·DPI·폰트임베딩·투명도). 채널#16과 분리 | unverified | 신규 제약 축 후보 | **metamodel-architect(Ph3)** | RedPrinting 에디터에 저해상 이미지 업로드/세이프존 이탈 시 경고 발생 여부. 우리 #16은 채널만·preflight 규칙 미보유 |
| **H-4** | **저장디자인/my-design 라이브러리 = 고객 자산 축**(saved_design_id·owner·source template·재주문 적격). 템플릿자산(시안 카탈로그)과도 별개 | unverified | 신규 축 후보 | **metamodel-architect / gap-analyst** | RedPrinting "간편 재주문"·로그인 my-design/주문이력·후니 고객 디자인 테이블 유무. 우리 TemplateAsset(V-11)은 *기성 시안*·이건 *고객 생성물* |
| **H-5** | **에디터 채널 ≠ 템플릿자산 카탈로그 = 2개 축으로 분리**해야(lifecycle·ownership·versioning·licensing·search·binding 상이). KOI에디터 有·공개템플릿 無 상품이 존재하면 입증 | unverified | **축 분할 대안**(우리 T-A facet 판정 재검) | **metamodel-architect(Ph3)** | RedPrinting에서 KOI에디터지만 공개템플릿 없는 상품 / PDF+에디터지만 템플릿 옵션인 상품 찾기. 우리는 TemplateAsset을 #16 *종속 facet*으로 판정 — codex는 *동급 축* 주장 |
| **H-6** | **VDP = #16 facet이 아니라 독립 데이터스키마 축**(필드정의·CSV 컬럼매핑·검증·미리보기행·레코드별 렌더·넘버링 할당·PII·에러상태). facet으론 표현 부족 | **rejected (facet 유지)** | ~~축 승격~~ → **T-B facet 유지** | metamodel-architect(검증완료) | **[검증 2026-06-17]** VDP = RedEditorSDK 45메서드 중 *3개 메서드*(openVdpViewer/setVariableData/getCurrentTemplateVdpList)·Edicus iframe deferred 파라미터(data_feed/ddp_block). **에디터 채널(#16) 없으면 호출 불가 = 종속 facet.** 독립 lifecycle 없음 → **REFUTED.** |
| **H-7** | **사진북 = page-hierarchy(INN_PAGE)로 환원 불가**. spread 에디터·표지/본문 분리·제본·표지랩·면지·lay-flat = spread/imposition/book-structure 축 필요 | unverified | **신규 축 후보**(우리 T-C "수량슬롯" 판정 재검) | **metamodel-architect / reverse-engineer** | RedPrinting 사진북 에디터·PDF 가이드. 우리 T-C는 INN_PAGE를 수량슬롯으로 흡수 — codex는 spread/imposition 축 별도 주장 |
| **H-8** | ~~**포토카드화이트: 1세트 = 서로 다른 20장 = set-composition(assortment) 그릇**~~ | **❌ REFUTED**(2026-06-17 라이브 실측) | **기각·신규 그릇 불요** | — 검증 완료(reverse §H-8) | **검증→기각.** `get_digital_product_info?pdt_cod=TPCAPTW` read-only 실측: `quantityGroup.title={"orderCnt":"디자인 수 (건수)","printCnt":"수량"}`=**수량모델#10 그대로**. "20장"=`pdt_pcs_info.NOTICE` "57x90(mm)…1세트(20장) 단위 구매"=**같은 디자인 20매/세트 판매단위**(PDT_UNIT="세트"·SET_CNT=1). "서로 다른 디자인 20종" 구조 **데이터 0건**. **codex "라이브 인용" 자체 거짓**(codex=`--sandbox read-only`+`mcp_servers='{}'` 네트워크0→fetch 불가·"20종" confabulation). TPCASET/TPPHSET 동반 실측도 #10. 판매단위 배수만 수량모델 minor 속성 흡수(신규 축 아님·T-8). |
| **H-9** | **빠른출고(당일/익일) 적격성 = 옵션조합 종속 생산 SLA 제약 축**. 16축 어디에도 납기/SLA 축 부재 | unverified | 신규 제약 축 후보 | **metamodel-architect / gap-analyst** | RedPrinting 모달 "일부 상품/옵션 당일·익일출고 제한"·TPCAPTW 옵션 적격 텍스트(codex 라이브 인용). 우리 분석 완전 부재 |

---

## MED — 기존 축 보강·구조 상세 (검증 후 보강분 흡수)

> 우리 축에 슬롯은 있으나 codex가 *더 세밀한 속성/제약*을 지적. 검증 후 해당 축 attributes 보강.

| # | claim | 상태 | 귀속 축 | 라우팅 | 검증법 |
|---|-------|------|---------|--------|--------|
| M-1 | 템플릿 분류체계(theme/category/tag/occasion/industry/season/language/audience)가 별도 관리축 — `template_resource_id` 단일 ID로 부족 | unverified | TemplateAsset(V-11) 보강 | gap-analyst | RedPrinting 템플릿 피커 필터·후니 admin 템플릿 검색. T-A에 분류 facet 추가 검토 |
| M-2 | 템플릿 versioning(immutable revision·published_at) — 재주문 시 공개템플릿 변경돼도 주문시점 버전 고정 | unverified | TemplateAsset(V-11) 보강 | gap-analyst / vessel-designer | RedPrinting 에디터 open/save/reorder 페이로드·후니 `template_version`/`revision`. 재주문 무결성 핵심 |
| M-3 | 템플릿↔상품 바인딩 규칙(특정 prd_cd+size+orientation+page+finish에만 유효) | unverified | TemplateAsset(V-11)·제약#5 | gap-analyst | RedPrinting 에디터에서 사이즈 바꿀 때 템플릿 사라짐/리사이즈 관찰 |
| M-4 | 폰트 라이선스/임베딩(license scope·print embed 권한·웹프리뷰폰트·fallback) | unverified | TemplateAsset(V-11)·자산 메타 | gap-analyst | 에디터 폰트목록·내보낸 PDF 폰트임베딩·admin 폰트카탈로그 |
| M-5 | 스톡/클립아트 라이선스 메타(source·상업사용·attribution·만료·수량한도) | unverified | TemplateAsset(V-11)·자산 메타 | gap-analyst | RedPrinting 에디터 자산 라이브러리 메타·후니 admin 자산테이블 |
| M-6 | 내보내기 산출물 정책(preview PNG·워터마크 proof PDF·production PDF·imposed PDF·editor JSON = 상이 보존/보안) | unverified | #16/H-1 워크플로 종속 | metamodel-architect | 주문 파일 저장경로·"장바구니/주문" 후 에디터 네트워크콜 |
| M-7 | 다국어/텍스트엔진(KO/EN/JA·CJK fallback·세로쓰기·이모지 제외·overflow) | unverified | TemplateAsset/preflight(H-3) | reverse-engineer | 에디터에 혼합 CJK/Latin/emoji 입력 후 export 거부/래스터화 관찰 |
| M-8 | 객체/레이어 한도(max 페이지·이미지·텍스트박스·업로드MB·캔버스객체·undo) | unverified | preflight(H-3)/#16 | reverse-engineer | RedPrinting 에디터 스트레스테스트·후니 업로드/에디터 config |
| M-9 | 디자인비 모델(무료템플릿/유료프리미엄/유료디자이너편집/유료스톡/수량초과면제) | unverified | 가격기여역할#11 보강 | gap-analyst | RedPrinting 템플릿 카탈로그 가격·후니 디자인노동 가격테이블. 우리 "디자인입력=가격0"의 예외 가능성 |
| M-10 | 법적/IP 동의(업로드 사진·로고 소유권 확인 — 아이돌 포토카드·상장 특히) | unverified | H-1 워크플로 종속 | metamodel-architect | 체크아웃 약관 체크박스·업로드 경고·admin CS정책 |
| M-11 | **상장(TPPOAWD): 인증서 프레임/직인/서명 배치 = 에디터 템플릿 서브구조 + 수상자/날짜/일련번호 = VDP 스키마**(자유텍스트 아님) | unverified | reverse-engineer(상장 미샘플)·VDP(H-6) | reverse-engineer(Ph2) | RedPrinting 상장 에디터/템플릿 필드. 우리 대표3 미포함 상품 |
| M-12 | 상장: 케이스/봉투/프레임 add-on = 패키징/부속물 축(상장케이스) | unverified | 부속물#8 보강 | reverse-engineer/gap-analyst | RedPrinting 상장 옵션·"상장케이스" 부속물 리스팅 |
| M-13 | **데코페이퍼(TPDCPST): 패턴/repeat/tile 방향 = 디자인레이아웃 축**(일반 페이지 아트와 별개·one-up 아님) | unverified | reverse-engineer(데코 미샘플) | reverse-engineer(Ph2) | RedPrinting 데코페이퍼 에디터 — 디자인 반복/원업 여부 |
| M-14 | **엽서북(TPCASET): 절취 perforation + 제본 = parent/child assembly**(book block + 낱장 엽서 leaf·leaf-level 페이지매핑) | unverified | 형태가공#14·페이지계층 확장 | reverse-engineer/metamodel-architect | RedPrinting 엽서북 옵션. 우리 그룹D "북류" 추정만 |
| M-15 | **포토카드화이트: 앞면 코팅 선택(무광/유광/홀로) vs 뒷면 고정 유광 = side-lock 면별 마감 제약** | unverified | 제약#5(match/side-lock)·공정#2 | gap-analyst | RedPrinting TPCAPTW "앞면 코팅 선택·뒷면 기본 유광"(codex 라이브 인용). 우리 면별 lock 제약 미보유 |
| M-16 | **떡메(TPBLMEO)/점메(TPBLPST): 측면인쇄 1~3면(떡메)·1·3·최대4면(점메) = side cardinality 공정파라미터** | unverified | 공정파라미터#9 보강 | gap-analyst | RedPrinting TPBLMEO/TPBLPST 옵션(codex 라이브 인용). #9 GAP에 측면 cardinality 추가 |
| M-17 | 떡메/점메: 측면인쇄 = 조립後 인쇄(post-assembly) = 면인쇄와 다른 setup 제약·공정 라우팅 | unverified | 공정#2 seq·형태가공#14 | gap-analyst | 떡메 job ticket/공정 라우팅. 공정 순서(조립→측면인쇄) 의존 |
| M-18 | 스티커 시트: waste/bleed/cut-spacing 제약(kiss-cut 최소간격·최소반경·시트엣지 최소거리) | unverified | 제약#5(min-max)·공정#2 | gap-analyst | 스티커 가이드/preflight 에러(도형 근접 시) |
| M-19 | 점착 상품: use-case 자재제약(removable/permanent·냉동/저온·실외·식품 간접접촉) | unverified | 자재#1 분해축(V-3)·제약 | gap-analyst | 스티커 자재옵션 가이드·후니 자재마스터 |

---

## LOW — 우선순위 낮음 / 샘플 확대 시

| # | claim | 상태 | 분류 | 비고 |
|---|-------|------|------|------|
| L-1 | 네임/패키지스티커 시트 레이아웃(rows/cols·반복이름·혼합디자인·kiss-cut path 수) | unverified | 사이즈#13/공정#2 보강 | 스티커 카테고리 본격 분석 시(TP 외 ST 카테고리와 중복 가능) |
| L-2 | 스티커 cutline-source 축(사전형상/에디터생성/업로드dieline/무cutline) | unverified | 공정#2(완칼) 보강 | 칼틀 geometry 출처 — 우리 칼틀=공정 판정에 source 차원 추가 |
| L-3 | 와블러(TPWBDFT): 접착arm/스프링 본체 = 하드웨어 조립 축 | unverified | 형태가공#14 흡수 가능 | GS #14가 커버 추정·TP 적용 확인만 |
| L-4 | 캘린더 시작 연/월 = 주문/디자인 시맨틱 필드(페이지수 아님) | unverified | #16/H-1 또는 옵션 | 우리 reverse §3 "에디터 내부 처리 추정"과 부분 중복 |
| L-5 | 캘린더 공휴일/음력 데이터셋 = locale 콘텐츠 버전 | unverified | 기초코드#6/콘텐츠 | 에디터 내부 데이터·관리축 여부 약함 |
| L-6 | 최소 DPI = 배치 물리크기당 계산(원본 업로드크기 아님) | unverified | preflight(H-3) 종속 | H-3 검증 시 함께 |
| L-7 | 저해상 수용 = 고객 책임확인 override 가능 | unverified | preflight(H-3)/H-1 워크플로 | H-3/H-1 종속 |
| L-8 | proof PDF 워터마크/래스터 vs production PDF 벡터/분판 | unverified | M-6 산출물정책 종속 | M-6과 동일 사안 |
| L-9 | 테이블세팅지(TPLFSET): 식품접촉 규정/내유내수 = 자재인증 제약 | unverified | 자재#1 인증 | RedPrinting 적용 [uncertain]·B2B 시 |
| L-10 | 상장: archival/lightfastness(내광성·종이영속성) — 기관 납품 시 | unverified | 자재#1 [uncertain] | codex 스스로 [uncertain] 표기·B2B 한정 |

---

## 이미 커버됨 (우리 분석에 있음 — 중복 신규 주장 폐기)

> codex가 우리 16축/gap/vessel을 컨텍스트로 받았으나 이미 판정한 것을 재제기. 정직히 폐기(중복 채택 0).

| codex 제기 | 우리 분석 위치 | 폐기 사유 |
|---|---|---|
| 템플릿 versioning/재주문 고정(일부) | V-11 TemplateAsset 분리·M-2로 흡수 | 부분 중복(M-2가 보강분) |
| VDP 데이터스키마 필요성(개념) | metamodel #16 attributes·T-B·V-10 ④ VDP 변수스키마 | facet으로 *이미 식별*. 단 "축 승격" 주장만 H-6로 별도 |
| item_gbn = 벤더 어댑터로 취급(비즈니스 SoT 아님) | discovered-axes D-8(런타임 중립)·#16 "RP=인코딩" | 우리 메타모델은 이미 RP naming/codes 후니 유입 금지·런타임 중립 원칙 |
| 페이지계층 ≠ 단순 수량(개념) | T-C 판정·gap §IX-B PASS(page_rules) | 우리가 *이미* 수량슬롯+제약으로 흡수 판정. 단 사진북 spread는 H-7로 별도 승격 |
| white/foil/spot 레이어 순서·분판 | metamodel #2·T-E·gap §IX-E PASS(PROC_000007/008/009/033~049) | 별색=공정 경계 *이미* 준수·후니 공정행 보유 |
| 특수인쇄 면별/레이어(개념) | T-E facet 판정 | 공정#2 흡수 *이미* 판정 |
| 템플릿자산 product-only 저장 부적절(다대다) | V-11 별 테이블 분리(`t_prd_templates` 컬럼흡수 금지) | 우리가 *이미* 별 엔티티 권고 |
| 하이브리드 채널(editor+PDF) enum-only 한계 | gap §VIII-1 "editor_yn+file_upload_yn 4분포 부족"·reverse TPCLECO(Y/Y) | *이미* 식별·단 "채널 policy set" 세분화는 H-5/H-6 종속 |
| 상장/포토카드 IP 동의 | M-10으로 승격(워크플로) | 신규성은 H-1 워크플로에 귀속 |
| 떡메/점메 기본 포장(shrink-wrap) | metamodel #2 포장(PAK_*)·G-8 facet | 포장=공정 *이미* 판정·단 "기본 vs 선택" 구분은 M-15/부속물 default 종속 |
| 포토카드 기본 PVC백 vs 선택 틴케이스 | 부속물#8·G-8(유료/무료 분기) | default vs optional 부속물 *이미* 가격기여 분기로 식별 |
| 와블러 조립 = 형태가공 | #14 본체형태가공(GS distinct) | *이미* 보유·TP 적용만 확인(L-3) |

---

## 환각의심 / 부적용 (거부)

| codex 제기 | 거부 사유 |
|---|---|
| "RedPrinting 공개 nav가 TP 템플릿 그룹핑 노출"(루트 URL 인용 다수) | 루트 `redprinting.co.kr` 인용은 *구체 증거 아님*(홈 네비게이션 추정). TPCAPTW/TPBLMEO/TPBLPST 상품페이지 인용은 checkable이나, 루트 인용 4건은 근거 약함 — claim 자체는 다른 후보로 살아있으나 *이 인용*은 검증 불가 |
| 테이블세팅지 식품접촉 인증(L-9) | codex 스스로 "[uncertain for RedPrinting TP]" — RedPrinting TP가 실제 식품접촉 인증을 옵션화하는지 미확인. 한국 인쇄 일반에선 드묾. 거부(샘플 확인 전 가설로만) |
| 상장 archival/lightfastness(L-10) | codex 스스로 "[uncertain]" — B2B 기관납품 가정. RedPrinting TP 상장이 내광성을 1급 옵션화한다는 증거 없음. 인쇄 도메인 일반사실이나 *관리축*으로는 과적합. 거부 |

---

## 라우팅 종합 (검증 후 재진입 권고)

> [HARD] 아래는 *triage 권고*. 실제 재진입(축 신설/갭 추가)은 각 생성 에이전트가 라이브/엑셀 검증 후 결정.
> deepcheck는 채택하지 않는다. validator에 본 목록을 넘겨 M게이트가 미검증 무단 채택 0을 확인.

### → metamodel-architect (Ph3) — 신규 축/판정 재검 후보 (검증 선행)
- **H-1 승인/교정 워크플로 STATE 축**(주문 라이프사이클·16축과 직교) — 가장 강한 신규 축 후보. 단 **본 하네스 범위 경계 주의**: 주문 워크플로는 *기초데이터 관리 그릇*보다 *주문 런타임*(huni-project-plan/widget 영역)일 수 있음 → architect가 "base-data 관리축인가 주문상태인가" 판정.
- **H-3 에디터 preflight 프로파일 제약 축** — #16 채널과 분리된 검증규칙 축.
- **H-5 에디터채널 vs 템플릿자산 = 2축 분리**(우리 T-A facet 재검) — RedPrinting에서 "KOI에디터 有·공개템플릿 無" 상품 존재 시 codex 주장 성립.
- **H-6 VDP 1급 데이터스키마 축**(우리 T-B facet 재검) — 후니 VDP 그릇 부재 확정이라 vessel 영향 큼.
- **H-7 사진북 spread/imposition/book-structure 축**(우리 T-C 수량슬롯 재검) — 사진북 에디터 검증 후.

### → gap-analyst (Ph4) — 갭/그릇 보강 후보
- **H-2 교정라운드 정책**·**H-4 my-design 라이브러리 그릇**·~~**H-8 set-composition 그릇**~~(**❌ REFUTED 2026-06-17** — 라이브 실측 결과 수량모델#10·신규 그릇 불요·reverse §H-8)·**H-9 빠른출고 SLA 제약 축**.
- M-1~M-5(템플릿자산 메타 보강: 분류·버전·바인딩·폰트·스톡 라이선스 → V-11 attributes)·M-9 디자인비(가격0 예외)·M-15 면별 lock 제약·M-16 측면 cardinality(#9 GAP 보강).

### → reverse-engineer (Ph2) — 미샘플 상품 구조 확인
- **M-11 상장(TPPOAWD)**·**M-13 데코페이퍼(TPDCPST)**·**M-14 엽서북(TPCASET)** — 우리 대표3 미포함·codex가 구조적 차이 지목. 로그인 에디터 캡처로 보강 권고(reverse "미관측" 항목과 정합).

---

## Re-invocation 메모
- TP 분석 변경 시 재consult. 살아있는 HIGH/MED 후보 carry-forward.
- 다른 에이전트가 후보를 검증/기각하면 본 표의 상태 갱신(`verified`/`rejected`)·재발굴 금지.
- **검증 우선순위:** H-1(워크플로 범위 판정)·H-6(VDP vessel 영향) 먼저. ~~H-8~~ **완료(REFUTED 2026-06-17)** — 교훈: codex "라이브 인용 보유" 분류는 **거짓 가정**이었음(codex는 `--sandbox read-only`+`mcp_servers='{}'`로 네트워크 0 → 어떤 "라이브 인용"도 fetch 불가·전부 confabulation 가능성). **앞으로 codex의 "라이브 인용 보유" 자체를 검증 트리거로만 쓰고 증거로 신뢰 금지.**
- codex 인용 중 **상품페이지 인용(TPCAPTW/TPBLMEO/TPBLPST)은 라이브 GET으로 즉시 재확인 가능**, 루트 URL 인용은 근거 약함(환각의심 표 참조).

---

## 검증 결과 — H-6·H-1 (2026-06-17 실측·rpm-metamodel-architect)

> codex 비신뢰. 실측 권위(라이브 `information_schema` read-only SELECT + huni-widget RedEditorSDK 계약 + reverse 실측)로 두 후보 판정. **과승격·과강등 둘 다 경계.**

### H-6 VDP = **REFUTED (T-B facet 유지) ❌축승격**

**판정 기준(스폰서 directive):** 1급축 승격은 "에디터 채널(#16)과 직교하며 독립 lifecycle" 입증 시만. VDP가 ① 에디터 없이 독립 존재 가능하면 1급축 / ② 에디터에 종속된 데이터바인딩이면 facet.

**실측 증거 — ②(facet) 확정:**
1. **VDP는 에디터 SDK 메서드다(독립 엔티티 아님).** huni-widget `seed-redprinting-sdk-analysis.md:88` — VDP = RedEditorSDK **45메서드 중 3개**(`openVdpViewer`/`setVariableData`/`getCurrentTemplateVdpList`). 즉 VDP는 *에디터의 능력*이지 별도 데이터 엔티티가 아니다. `getCurrentTemplateVdpList`는 이름 그대로 "**현재 템플릿의** VDP 리스트" — 템플릿(=에디터 리소스)에 종속.
2. **에디터 채널 없으면 VDP 호출 불가 = 종속 lifecycle.** `editor-bridge-protocol.md:37,48` — `data_feed`/`data_row`/`ddp_block`은 Edicus iframe **deferred 파라미터**(에디터가 `waiting-for-extra-param` 요청 → 호스트가 `send-ddp-data` 응답). 에디터 iframe이 떠야만 흐르는 데이터. reverse §0.2: VDP는 `edicus_item`(Edicus 채널)에서만 — `offset2023_item`(에디터0)·PDF전용엔 VDP 없음. → **에디터 채널(#16) ⊃ VDP** (직교 아님·포함관계).
3. **후니 라이브 VDP 그릇 0건.** `variable|var_data|field_def|csv|record|numbering|data_row|data_feed|pii|merge` 컬럼 전역 검색 0건·VDP 테이블 0건·`item_gbn`/채널 enum 부재. → VDP가 *별도 데이터스키마 축*이었다면 후니 갭도 #16과 분리됐어야 하나, **#16(디자인 입력 채널) GAP에 완전 포함**되어 분리 흔적 없음.
4. **reverse 실측 정합:** `koiOption[]` 빈배열·VDP 변수 스키마 unobserved(로그인 에디터 필요) — VDP는 에디터 런타임 산물이지 base-data 등록 단위가 아님.

**codex 반박:** codex가 든 "필드정의·CSV매핑·검증·넘버링·PII·에러상태"는 전부 *에디터가 VDP 모드에서 다루는 런타임 데이터*다. base-data 관리축(상품 정의 시점에 등록하는 그릇)이 아니라, 주문 시점 에디터가 처리하는 *입력 데이터*. 1급 *관리축*으로 보면 오버피팅(에디터 채널의 한 모드를 축으로 격상). → **T-B "입력채널 데이터바인딩 facet × 수량#10" 판정이 옳음.**

**결론:** VDP는 #16 디자인 입력 채널(D-11)의 **데이터바인딩 facet** 유지. 1급축 승격 거부. discovered-axes 무변동(T-B facet 그대로). vessel 영향 = #16 그릇(V-10) 설계 시 VDP 변수 스키마를 그 *종속 하위*로 포함(별 축 신설 아님) — gap-matrix §IX-B(T-B VDP=#16 GAP 흡수)와 이미 정합.

### H-1 승인/교정 워크플로 STATE = **OUT-OF-SCOPE (주문 런타임) ⊘**

**판정 과제:** base-data(상품 정의·옵션·가격 등 정적 관리축)인가 주문 인스턴스 런타임 상태(주문건별 진행상태)인가.

**실측 증거 — 주문 런타임 확정:**
1. **라이브 DB에 주문/상태 그릇 0건.** 전체 46 BASE 테이블 = Django 10 + bak 1 + **t_* 35(전부 상품정의/옵션/가격/제약/자재/공정/카테고리/고객 마스터)**. `order|status|state|workflow|approv|proof|preflight|review|lifecycle|stage|t_ord` 테이블 0건·`status|state|_stage|approv|proof|review|lifecycle` 컬럼 0건. 본 DB는 **순수 base-data 마스터** — 주문 인스턴스 그릇이 한 개도 없다.
2. **H-1 워크플로의 정체 = 주문 건별 진행상태.** draft→preflight→고객확인→운영자검수→생산잠금은 *특정 주문 1건*이 시간축으로 거치는 상태 전이. 상품/옵션 *정의*(어느 시점에도 동일한 정적 그릇)가 아니라 *주문 인스턴스의 라이프사이클*. 본 하네스 목적("RedPrinting 옵션 관리 메타모델→후니 기초데이터 그릇")의 기초데이터 관리축이 아님.
3. **하네스 경계:** 주문 런타임/상태/MES 생산브릿지는 **huni-dbmap 북극성(MES/주문 트랙)** 영역 — [[dbmap-goal-ui-quote-mes]] "주문→MES 생산정보 전달·MES_ITEM_CD". huni-project-plan(주문 런타임 0개=전부 신규)도 이 경계를 명시. 본 하네스가 다룰 영역이 아니다.

**base-data 측면 잔류분(정적 속성만 in-scope):** H-1 중 *상품별 정적 속성*으로 환원 가능한 부분 — 예: "이 상품은 교정 필수인가"(상품 정의 시점 불리언), "preflight 프로파일(bleed/safe-zone/DPI 규칙)이 무엇인가"(H-3 별도 후보) — 은 base-data일 수 있으나, 이는 H-1의 *상태 전이축*과 별개다. H-1 자체(주문 상태 머신)는 OUT-OF-SCOPE. H-3 preflight 프로파일은 별도 검증 대상으로 carry-forward(본 판정 범위 아님).

**결론:** H-1 = **OUT-OF-SCOPE**(주문 런타임). 메타모델 축/facet 신설 0. discovered-axes 무변동. 라우팅 = huni-dbmap MES/주문 트랙(본 하네스 아님). codex 주장("16축에 STATE축 전무")은 사실이나, *전무한 이유가 본 하네스 범위 밖이기 때문*이다(누락 아님·경계).

### 종합 — discovered-axes 반영

| 후보 | codex 주장 | 실측 판정 | discovered-axes 반영 |
|---|---|---|---|
| **H-6 VDP** | 독립 1급 데이터스키마 축 | **REFUTED** — 에디터 SDK 종속 메서드·#16 포함관계·라이브 VDP 그릇 0 | **무변동** (T-B facet 유지) |
| **H-1 STATE** | 누락된 주문 라이프사이클 STATE 축 | **OUT-OF-SCOPE** — 주문 인스턴스 런타임·라이브 주문 그릇 0·base-data 아님 | **무변동** (축/facet 신설 0·dbmap MES 라우팅) |

> **메타모델 안정성:** 두 후보 모두 기존 16축 판정이 옳음을 실측이 확증. 과승격(H-6 1급화)·범위 침범(H-1 주문축 흡수) 둘 다 거부. `discovered-axes.md`·`metamodel-dictionary.md` 수정 불요(현 T-B facet·#16 distinct 그대로 유효).
