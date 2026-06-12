# Print-KB Wiki

> 후니프린팅 인쇄 도메인 LLM 위키(Karpathy 모델). 미래 LLM이 위키만 읽고 인쇄상품을 조립(정의→DB 등록→가격→위젯)하기 위한 카탈로그. **쿼리 시 이 파일을 먼저 읽어** 페이지를 지목한다. 스키마=[README](README.md) · 연대기=[log](log.md).
>
> 2레이어: `base/`=인쇄산업 일반 지식(검증된 토대) · `huni/`·`policy/`=후니 분석대상(베이스 위). RECIPES=상품군 레시피 · AXES=횡단 축. base가 권위 토대, 후니 데이터는 그 위에서 매핑·검증.

---

## 🧱 BASE — 인쇄산업 일반 지식 (토대)

> 출처 = 검증된 표준(EPA·Wikipedia·CIP4 등, `_research/base-verification.md` 교차검증). 사실별 [검증]/[단일출처]/[추정] 신뢰도 표기(R-4). 후니 특정 아님.

- [base/printing-methods](base/printing-methods.md): 인쇄방식 5분류(평판/볼록/오목/공판)+무판 디지털·UV·실사 — 전건 [검증]. ✅초안
- [base/sizes](base/sizes.md): 크기 3축(재단/작업/출력판형)·블리드 3mm·임포지션·시그니처·절수·결방향·CIP4 — [검증] 다수
- [base/paper](base/paper.md): 종이 결방향[검증]·평량/전지/종류는 [추정]/GAP(검증 대기)
- [base/finishing](base/finishing.md): 후가공 프레임(CIP4 PostPress)[검증]·코팅/박/형압은 [추정]/GAP
- [base/binding](base/binding.md): 시그니처/결방향[검증]·중철/무선/PUR/트윈링은 [추정]/GAP
- [base/color](base/color.md): CMYK/망점·VDP[검증]·별색/도수/화이트/색관리는 [추정]/GAP
- [base/prepress-file](base/prepress-file.md): 임포지션/판걸이/블리드/CIP4[검증]·PDF/X/해상도는 [추정]/GAP

## 📐 AXES — 횡단 축 (후니, 모든 레시피가 참조)

> 단일 사실 원칙: 횡단 사실은 축 페이지에 1회만, 레시피는 [[링크]]. 6 축 페이지 본문 집필 완료(원자 항목+관계링크+역링크 슬롯) — 레시피가 `uses`/`requires`/`excludes`/`priced-by`/`loaded-via`/`mapped-to`로 참조한다(관계 그래프 원칙 README §3).

- [huni/modeling-axioms](huni/modeling-axioms.md): 후니 모델링 명제(인쇄방식≠최상위 분기축·시트=1차 단위) — 보편 아님. 🟡
- [huni/materials](huni/materials.md): 자재 t_mat_materials·parent+usage_cd·MAT_TYPE .07~10 오염·레더 .06(round-13 양면) — 🟡6·🔴4
- [huni/processes](huni/processes.md): 공정 t_proc_processes·별색=공정(clr_cd=NULL)·코팅 CONFLICT(BATCH-3 미결)·UV=PROC_000002 — ✅1·🟡4·🔴7
- [huni/price-engine](huni/price-engine.md): t_prc_* 4단(차원8/컬럼10)·공식 4유형·단가/합가형·판수=앱 계산. **STALE: price-engine-ddl.md 인용금지** — 🟡10·🔴5
- [huni/cpq-options](huni/cpq-options.md): option_groups/options/items·polymorphic ref_dim_cd 7종·BUNDLE(자재+공정)·전면 미적재. **STALE: constraint_json 삭제** — ✅1·🟡7·🔴4
- [huni/widget-contract](huni/widget-contract.md): 정규화 계약(DB 독립)·어댑터 경계·14 componentType·서버 가격권위(PRICE=0 불가) — ⚪5·🔴4
- [huni/load-path](huni/load-path.md): webadmin sql/tools·FK 위상·멱등 UPSERT·컬럼존재≠백필. **STALE: v03 입력금지·constraint_json/dep_proc_cd** — ✅2·🟡5·🔴5

## 🍳 RECIPES — 상품군 레시피 (11)

> 상품 조립의 1차 진입점. 8절 템플릿(정체→차원→BOM→가격사슬→CPQ→위젯→적재→결함). 조립 뷰(축 항목 [[링크]] 참조). (나머지 차기 집필 — 큐레이션 팩 `_curation/pack-<family>.md` 보유.)

- [recipes/digital-print](recipes/digital-print.md): 디지털인쇄 — 36상품/7구분(엽서·명함·상품권·배경지·라벨택 등)·배경지=포장세트·원자합산형 PRF_DGP·round-13 결함18(C-01~18). 🟡 (✅6·🟡10·🔴8·⚪2)
- [recipes/sticker](recipes/sticker.md): 스티커 16상품(PRD_000052~067)·인쇄방식 5분기·형상=칼틀 size(Q7)·형상×치수×코팅 격자 가격·코팅 자재 오적재(Q9 공정 CONFLICT·BATCH-3)·063 화이트 누락·CPQ 미적재. 🟡 (round-13 GO·결함17)
- [recipes/booklet](recipes/booklet.md): 책자 10완제품+21반제품(PRD_000068~098)·생산구조 3종(A통합/B셋트/떡제본)·제본 합산형 PRF_BIND_SUM·떡제본 고정가·박색/코팅=공정(Q2/Q9)·BK-2 sub_prd 078 몽블랑(레더여야)·BK-CAT 전용잎노드 6개 고아·CPQ 미적재. 🟡 (round-13 GO·결함13·컨펌Q-BK-A~E)
- [recipes/photobook](recipes/photobook.md): 포토북 1논리상품(PRD_000100)+반제품7(101~107)·size4×표지타입5 variant(책자와 정반대)·page-band 합산형 PRF_PBK_PAGEBAND(라이브 미적재·≠엽서북 PRF_PCB_FIXED)·레더 .01/.08→.06(MAT_000186 6상품 횡단)·소프트 page "4~14"=엑셀 공란 GAP(F-PB-1 oracle 날조 적발)·CPQ 미적재. 🟡 (round-13 GO·결함8·컨펌Q1~Q5)
- [recipes/calendar](recipes/calendar.md): 캘린더+디자인캘린더 5 form factor(PRD_000108~112·탁상/미니/엽서/벽걸이/와이드)·디자인캘린더=같은 상품 에디터 surface(별 상품 아님)·장수=고유 축(page_rule 아님·Q12)·캘린더가공 택일그룹 GRP-CAL-가공(excl_groups Phase11 삭제→option_groups 흡수)·캘린더=원자합산형/디자인캘린더=고정가형(둘 다 미적재)·삼각대/링 자재 오적재(정답 공정)·plate .01↔.03 적재경로 퇴행·삼각대거치 공정 mint. 🟡 (round-13 GO·결함20·컨펌CL-A~G)
- _(통합)_ design-calendar: 디자인캘린더는 calendar.md에 통합(팩 결정·같은 5상품 surface)
- [recipes/acrylic](recipes/acrylic.md): 아크릴 23등록 상품(PRD_000146~169)·UV 평판인쇄 굿즈 단품·두께=자재(1.5/3/8mm)·형상=완칼 묵시·가격=가로×세로 면적매트릭스(미러=투명×2)·**UV 변형 print_side 오적재 20상품(정답 PROC_000002)**·완칼 전무·볼체인 소실·CPQ 미적재. 🟡 (round-13 GO·결함14·✅4·🟡10·🔴11·⚪2)
- [recipes/silsa](recipes/silsa.md): 실사 28등록 PRD_000118~145·소재기반 13군·면적매트릭스 13+고정가 16·일반현수막 CPQ(og3/oi18)·카테고리 고아 CAT_000298·자재.08 평면화·레더 .08→.06(MAT_000186 6상품 횡단). 🟡 (round-13 GO·결함14·✅5·🟡10·🔴8·⚪2)
- [recipes/goods-pouch](recipes/goods-pouch.md): 굿즈파우치 103상품·19 상품군·혼합 인쇄방식 7종(패브릭/UV/전사외주/이지굿즈PVC고주파/디지털/만년도장/실사)·사이즈=치수형22 vs 옵션형202(round-10 size→option 448셀)·본체색=재질행 합성(정답 모델)·고정가형+구간할인 굿즈A/B타입·봉제(080)/에폭시(083)/맥세이프 후가공·카테고리 고아 35상품·자재 폭증/오염(.09)·봉제→부착 오적재·CPQ 미적재. 🟡 (round-13 GO·결함17·컨펌Q-GP-1~5)
- [recipes/product-accessory](recipes/product-accessory.md): 상품악세사리 15 부자재(PRD_000001~015)·**전부 카테고리 012 포장재**(인쇄물 아님·인쇄 5축 N/A·시트 라벨일 뿐)·봉투/케이스 11+상품액세서리 4·사이즈=치수×묶음수×색상 3축 복합·**이중등록=의도**(OTC TEMPLATE 281/282/283·09_delete_dup 삭제제외 입증)·우드거치대=자재·색상 4종 MAT_TYPE.10 자재 오염(정답 옵션)·카테고리 고아 293→276/285/287 재연결·가격사슬 0행(round-2 미커버)·봉투세트=sets+CPQ 사이즈매칭(Q-ID-A)·CPQ 미적재. 🟡 (round-13 GO·결함14·컨펌Q-ID-A·Q-PA-A~G)
- [recipes/stationery](recipes/stationery.md): 문구 11완제품(만년다이어리 4·먼슬리·스프링노트/수첩·메모패드·중철노트·떡메모지 097)+반제품1·생산구조 3종(A통합/B셋트/단순·booklet 동형)·고정가형 C29 inline(round-2 미실행·prices 0행)·떡메모지=묶음수×size 매트릭스·**미싱제본 MISSING**(030/074는 제본 family 아님·신규공정 BATCH-13)·종이 usage.07 fallback·카테고리 의미매칭(노드순≠prd_cd순 F-ST-G1)·박 미운영·CPQ 미적재. 🟡 (round-13 GO·결함18·컨펌Q-ST-A~M)

## 🏷️ HUNI — 정책 (policy 레이어)

> 후니 특정 데이터. ✅만 매핑 권위, 🟡=후보(사실로 쓰지 말 것).

- [policy/membership-auth](policy/membership-auth.md): 로그인·SNS·약관·비회원·등급·가입혜택 — 🟡권장5·🔴1
- [policy/mypage](policy/mypage.md): 옵션보관함·프린팅머니·증빙 — 🟡2·🔴1
- [policy/order-payment](policy/order-payment.md): 결제케이스·PG·간편결제·파일입력·장바구니 — ✅1·🟡2·🔴4
- [policy/shipping](policy/shipping.md): 무료기준·기본배송·혼합·제주·도서산간 — 🟡4·🔴2
- [policy/coupon](policy/coupon.md): 신규·리뷰·재구매·VIP·동시사용·유효기간 — 🟡6
- [policy/review](policy/review.md): 등록방식·보상·회수·사진리뷰 — 🟡4
- [policy/product-pricing](policy/product-pricing.md): 출력상품·가격관리 8종·수작브랜드 — 🟡1·🔴2
- [policy/order-mgmt](policy/order-mgmt.md): 작업상태·파일검수·상태변경·권한·오프라인 — ✅3·🔴4·⚪1
- [policy/operations](policy/operations.md): 취소/환불·파일보관·버전·클레임·외주정산 — ✅5(현행)
- [policy/custom-dev](policy/custom-dev.md): 9 CUSTOM 필수개발 — 🔴9

**정책 합계:** 57항목 · ✅8(현행)·🟡25·🔴23·⚪1 (81% 미결정/권장). ✅만 매핑 권위.

## 📄 원천 요약 (sources)

- [sources/policy-checklist](sources/policy-checklist.md): 정책체크리스트 xlsx 요약

---

## 상태·신뢰도 표기
- **huni badge:** ✅결정/사실 · 🟡권장(미확정, 사실로 쓰지 말 것) · 🔴미결정 · ⚪명세.
- **base 출처 신뢰도(R-4):** [검증](2+ 독립출처) · [단일출처] · [추정](외부 근거 부재). base는 huni badge 미사용.

## 빠른 조회 예시
- "옵셋이 뭐고 언제 쓰나?" → [base/printing-methods](base/printing-methods.md)
- "재단/작업/출력판형 차이?" → [base/sizes#BSZ-001](base/sizes.md)
- "인쇄방식이 후니 최상위 축인가?" → [huni/modeling-axioms#HMOD-01](huni/modeling-axioms.md) (🟡 아님·시트가 1차 단위)
- "후니 배송비 무료 기준?" → [policy/shipping](policy/shipping.md) (🟡 10만원 권장)
