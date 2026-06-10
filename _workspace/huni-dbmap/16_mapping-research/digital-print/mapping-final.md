# 디지털인쇄 — 매핑 확정 (round-12 mapping-final)

> **작성** 2026-06-10 · round-12(매핑 확정 리서치). 설명 한국어, 식별자/컬럼/코드값/SQL 영어.
>
> **목적:** 디지털인쇄 시트 44 composite 컬럼이 라이브 t_* 기초데이터에 "정확히 어디로·어떻게" 매핑되는지를 4 내부 권위(round-11 산출 + 실무진 확정 Q1~Q15 + schema-design-intent-map + loadspec) 결합 + 라이브 실측 + 외부 갭헌팅으로 확정. round-4/5 적재본 조립의 직접 입력. **DB 적재 없음.**
>
> **권위 순서(HARD):** ① 실무진 확정 ② 후니 PDF/문서 ③ 라이브 DB 실측 ④ webadmin 소스 ⑤ 내부 KB(round-11·schema-intent·07_domain) ⑥ 외부(보조).
> **확정도:** ✅ 4소스 일치+라이브 실측 검증 · 🟡 부분/도출 · 🔴 미확정(컨펌 질문 동반).
> **CONFLICT 표기:** 4소스 불일치는 별도 CONFLICT 행에 명시(침묵 선택 금지).

---

## 0. round-12 핵심 정정 (라이브 실측이 round-11 초안을 이긴 것)

| ID | round-11 초안 | 라이브 실측(2026-06-10) | 영향 |
|----|--------------|------------------------|------|
| **R12-1** | C3 → `t_prd_products.mes_item_cd`(소문자) | **컬럼명 = `"MES_ITEM_CD"`(대문자·쌍따옴표 quoted identifier)** — 소문자 컬럼 부재 | 적재 SQL은 `"MES_ITEM_CD"` 인용 필수. 소문자 사용 시 `column does not exist` 에러(실증) |
| **R12-2** | C16 자재 usage = USAGE.01 본체 | **라이브 PRD_000016 자재 21행 전부 USAGE.07(공통)** | 낱장 종이 usage = **USAGE.07 공통**(.01 아님). loadspec §4 "usage=본체" 정정 |
| **R12-3** | C26 건수 → 신규 "건" 코드 가설 | **라이브 디지털인쇄 5상품 전부 `qty_unit_typ_cd=QTY_UNIT.02`(매)** | "건"이 아니라 **QTY_UNIT.02 매**. CONFIRM-DP-5 RESOLVED |
| **R12-4** | C30 모서리 → 귀돌이(PROC_000026 단일) | **귀돌이=PROC_000026 root, 직각=PROC_000027, 둥근=PROC_000028**(family) | 모서리 값 = PROC_000027/028 자식 연결(root 아님) |
| **R12-5** | C37 박칼라 = 공정 param vs 포일 자재(미정) | **라이브 박색 16종 전부 PROC_000033 자식**(금034·은035·홀로그램037·금유광038·은유광039·먹유광040·동박041·트윙클044…) | 박칼라 = **공정(박 자식)**. Q2 확정과 정합. CONFIRM-DP-1 RESOLVED |
| **R12-6** | C18~22 별색 PROC_000008~012(family 추정) | **PROC_000007 별색인쇄 root + 008화이트/009클리어/010핑크/011금색/012은색 자식 실재** | 별색 family 전수 검증. CONFIRM-DP-4 RESOLVED |
| **R12-7** | addon tmpl_cd 예시 `TMPL_000005`(`_`) | **라이브 `TMPL-000005`(하이픈)** | tmpl_cd separator = 하이픈(코드전략 `_`와 CONFLICT — §CONFLICT 참조) |

---

## 1. 컬럼별 확정 매핑 (44 composite 컬럼 전수 — M1 커버리지)

> 의미축 = round-11 `column-dictionary.md` C번호 인용. 목표 = 라이브 실측 검증된 t_*.컬럼. 라이브상태: 존재=마스터/코드 실재, 적재=상품행 적재됨, 미적재=적재 대상, 미저장=의도적 DB 밖, GAP=귀속처 부재.

| C | 엑셀 컬럼 | 의미축(round-11) | 목표 t_*.컬럼 | 변환 규칙 | 코드값/FK (라이브 실측) | 라이브 상태 | 권위 | 확정 | 비고 |
|---|-----------|------------------|---------------|-----------|-------------------------|-------------|------|:--:|------|
| 1 | 구분 | 상품군 분류 | `t_prd_product_categories.cat_cd`(B) | 시트 그룹 라벨→카테고리 연결 | cat_cd FK→`t_cat_categories` | 적재(일부) | round-11·loadspec | 🟡 | 시트 편의 그룹 ≠ 판매 카테고리. 판매분류 매핑은 카테고리 트리 별도 |
| 2 | ID | 외부 식별자 | (매핑 보조키 — t_* 컬럼 없음) | 출처 추적용, prd_cd 아님 | — | 미저장(의도) | round-9 코드전략 | ✅ | prd_cd로 오인 금지. 적재 비대상 |
| 3 | MES ITEM_CD | MES 품목코드 | **`t_prd_products."MES_ITEM_CD"`**(A·대문자 quoted) | 원형 대문자 보존, NULL 허용 | 컬럼 실재(대문자). 디지털 5상품 전부 NULL | 적재(값=NULL) | 라이브 실측·webadmin D-05 | ✅ | **R12-1: 소문자 `mes_item_cd` 부재 — 반드시 `"MES_ITEM_CD"`.** 값 NULL 정상(MES 미연동) |
| 4 | 상품명 | 상품 정체 | `t_prd_products.prd_nm`(A) | 그대로(멱등 키) | — | 적재(7상품 전수 실재) | 라이브 실측 | ✅ | PRD_000016/024/027/031/041/043/047 매칭 확인 |
| 5 | 사이즈(필수) | 재단치수(완성품) | `t_siz_sizes.cut_width/cut_height` + `t_prd_product_sizes`(prd_cd+siz_cd)(A→B) | "73 x 98 mm"→(w=73,h=98) 파싱·siz_cd 멱등 | siz_cd FK | 적재(엽서 7행 < 엑셀 13 — D-1 변형 미적재) | round-11·라이브 | 🟡 | **D-1: 행존재만 — 엽서 사이즈 13종 중 7종만 적재. 변형 커버리지 미적재(적재 대상)** |
| 6 | 사이즈>판수 | 판걸이수(임포지션) | **미저장 — 앱 런타임 계산** | t_* 매핑 금지 | — | 미저장(의도) | 메모리 compute-in-app·CIP4 LayoutPreparationParams | ✅ | 가격공식 분모. CIP4/XJDF도 imposition=plate-prep 계산단계로 확인(외부 corroborate). GAP 아님 |
| 7 | 파일사양>블리드 | 재단 여유 | `t_siz_sizes`(work−cut 도출, 별 컬럼 부재) | work_width−cut_width=2×블리드 | margin_* 또는 도출 | 도출(별 저장 불요) | **Q14 확정** | ✅ | **Q14: 별도 관리 불요 — 작업/재단으로 도출.** CONFIRM-DP-3 RESOLVED. 단 impos 사이즈는 인쇄영역 여백 필요 맥락 |
| 8 | 파일사양>작업사이즈 | 작업치수(블리드 포함) | `t_siz_sizes.work_width/work_height`(A) | "75 x 100"→(w,h). 같은 siz_cd 행 | — | 적재 | round-11·라이브 | ✅ | 재단(C5/C9)과 별 슬롯, 같은 siz_cd 행에 공존 |
| 9 | 파일사양>재단사이즈 | 재단치수 | `t_siz_sizes.cut_width/cut_height`(A) | C5와 동일값→한 siz_cd 통합 | — | 적재 | round-11·라이브 | ✅ | C5 중복 표기. 한 siz_cd로 통합 |
| 10 | 파일사양>출력용지규격 | 출력판형(전지) | `t_prd_product_plate_sizes.output_paper_typ_cd`(A→B) | "316x467"→**OUTPUT_PAPER_TYPE 코드**(치수 아님) | **OUTPUT_PAPER_TYPE.01 국전계열**(엽서 PRD_000016 실측) | 적재 | 라이브 실측·메모리 platesize-is-output-paper | ✅ | **라이브 확인: 316x467→.01 국전계열·output_file_typ 빈값.** 출력판형=전지규격 |
| 11 | 파일사양>파일명약어 | 생산 메타 | **GAP(견적 밖) — note 옵션** | t_* 컬럼 없음 | — | GAP | **Q1 확정** | ✅ | **Q1: 견적 제외(내부 생산용).** 적재 비대상 확정. CONFIRM-DP-2(a) RESOLVED |
| 12 | 파일사양>출력파일 | 접수 파일포맷 | `t_prd_product_plate_sizes.output_file_typ`(B) | PDF/AI 자유텍스트(코드 아님) | CharField | 미적재(엽서 plate 빈값) | round-11·loadspec | 🟡 | PDF(+W)=화이트별색 동반→C18 교차. 자유텍스트. 엽서는 미입력 상태 |
| 13 | 파일사양>폴더 | 생산 라우팅 | **GAP(견적 밖)** | t_* 컬럼 없음 | — | GAP | **Q1 확정** | ✅ | **Q1: 견적 제외.** `*아이마크`=별색 라우팅 신호(생산). 적재 비대상 |
| 14 | 주문방법>업로드 | 주문 채널 | `t_prd_products.file_upload_yn`(A) | Y/N | char(Y). 디지털 5상품 전부 Y | 적재(Y) | 라이브 실측 | ✅ | 전 상품 업로드 지원 |
| 15 | 주문방법>편집기 | 주문 채널 | `t_prd_products.editor_yn`(A) | Y/N(빈값=N) | 엽서 N·포토카드 Y(실측) | 적재 | 라이브 실측 | ✅ | 일부만 Y(포토카드 Y, 엽서 N) |
| 16 | 종이(필수) | 자재(종이) | `t_mat_materials`(mat_typ_cd=MAT_TYPE.01) + `t_prd_product_materials`(prd_cd+mat_cd+**usage_cd=USAGE.07**)(A→B) | 종이명+평량→mat_nm. `*별도설정`=공통풀 IMPORT | MAT_TYPE.01 종이·**USAGE.07 공통**(엽서 21행 실측) | 적재(엽서 21행) | 라이브 실측·시트 footnote | ✅ | **R12-2: usage=USAGE.07 공통**(.01 본체 아님). 시트 footnote "모든 디지털인쇄 종이는 MES 통합관리·별도설정" 정합 |
| 17 | 인쇄(옵션) | 인쇄면 도수 | `t_prd_product_print_options.print_side`+front/back_colrcnt_cd(B) | 단면→back=CLR_000001(인쇄안함)·양면→both CLR_000005 | 엽서 실측: opt1 단면(front CLR_000005/back CLR_000001)·opt2 양면(both CLR_000005) | 적재(2행) | 라이브 실측 | ✅ | **별색을 여기 넣지 말 것**(별색=공정). 도수 사전 CLR_000001~005 확인 |
| 18 | 별색>화이트 | 공정(별색) | `t_proc_processes`(**PROC_000008**) + `t_prd_product_processes` + prcs_dtl_opt(면)(A→B) | (없음/단면/양면)=적용면 param | PROC_000007 root → **PROC_000008 화이트**(실재) | **마스터 존재·엽서 미적재**(D-1) | 라이브 실측·07_domain §3-2 | ✅ | **print_side 아님(공정).** 엽서 process 6행에 별색 부재=미적재(적재 대상) |
| 19 | 별색>클리어 | 공정(별색) | `t_proc_processes`(**PROC_000009**) + product_processes(A→B) | 〃 | PROC_000009 클리어(실재) | 마스터 존재·미적재 | 라이브 실측 | ✅ | R12-6: family 실측 검증 |
| 20 | 별색>핑크 | 공정(별색) | `t_proc_processes`(**PROC_000010**) + product_processes(A→B) | 〃 | PROC_000010 핑크(실재) | 마스터 존재·미적재 | 라이브 실측 | ✅ | CONFIRM-DP-4 RESOLVED(가설→실측) |
| 21 | 별색>금색 | 공정(별색) | `t_proc_processes`(**PROC_000011**) + product_processes(A→B) | 〃 | PROC_000011 금색(실재) | 마스터 존재·미적재 | 라이브 실측 | ✅ | **별색금(잉크) ≠ 박금**(C37 PROC_000034 금). 물리적 분리 |
| 22 | 별색>은색 | 공정(별색) | `t_proc_processes`(**PROC_000012**) + product_processes(A→B) | 〃 | PROC_000012 은색(실재) | 마스터 존재·미적재 | 라이브 실측 | ✅ | 〃 |
| 23 | 코팅(옵션) | 공정(코팅) | `t_proc_processes`(**PROC_000013** root, 유광014/무광015) + product_processes + prcs_dtl_opt(면)(A→B) | 무광/유광×단/양면 | PROC_000013 코팅·014 유광·015 무광(실재) | 마스터 존재·엽서 미적재 | 라이브 실측·Q9 | ✅ | **Q9: 코팅=공정**(자재 아님). ★180g조건→constraint_json |
| 24 | 커팅(옵션) | 공정(완칼)+형상 | `t_proc_processes`(**PROC_000053** 완칼) + prcs_dtl_opt(모양)(A→B) | 형상 25종→prcs_dtl_opt.모양 | PROC_000053 완칼{모양 string}(실측 param) | 마스터 존재·미적재 | 라이브 실측·OM-7 | 🟡 | **형상=공정 param**(size축 drop 금지). prcs_dtl_opt `{모양:string}` 실재 |
| 25 | 접지(옵션) | 공정(접지)+단수 | `t_proc_processes`(**PROC_000056** 접지 family, 6단오시접지=073) + prcs_dtl_opt(A→B) | 단수/방향→접지 자식 + param | PROC_000056 접지·자식 16종(2단059…073 6단오시접지·074 6단미싱접지) 실재 | 마스터 존재·미적재 | 라이브 실측·07_domain §2-3 | ✅ | 6단오시접지=PROC_000073(오시+접지 복합 leaf, 실재). ★사이즈종속 캐스케이드 |
| 26 | 제작수량>건수(옵션) | 수량 단위 | `t_prd_products.qty_unit_typ_cd`(A) | Y→QTY_UNIT.02 매 | **QTY_UNIT.02 매**(디지털 5상품 전수 실측) | 적재 | 라이브 실측 | ✅ | **R12-3: "건"이 아니라 QTY_UNIT.02 매.** CONFIRM-DP-5 RESOLVED |
| 27 | 제작수량>최소 | 수량 하한 | `t_prd_products.min_qty`(A) | 정수 | 엽서 15·포토카드 20·명함 100·전단 2(실측) | 적재 | 라이브 실측 | ✅ | 판걸이수 배수. 상품 단위 대표값 |
| 28 | 제작수량>최대 | 수량 상한 | `t_prd_products.max_qty`(A) | 정수 | 엽서 10000·전단 100000(실측) | 적재 | 라이브 실측 | ✅ | — |
| 29 | 제작수량>증가 | 수량 증가단위 | `t_prd_products.qty_incr`(A) | 정수 | 엽서 15·전단 1(실측) | 적재 | 라이브 실측 | ✅ | 최소=증가 동일 다수(판걸이수 배수) |
| 30 | 후가공>모서리 | 공정(귀돌이) | `t_proc_processes`(직각=**PROC_000027**·둥근=**PROC_000028**, 귀돌이 root=026) + product_processes(A→B) | 직각/둥근→자식 연결 | PROC_000026 귀돌이 root·027 직각·028 둥근(실재·엽서 적재됨) | **적재**(엽서 027/028 실재) | 라이브 실측 | ✅ | **R12-4: 직각/둥근=PROC_000026 자식**(root 아님). 엽서 process에 실재 |
| 31 | 후가공>오시 | 공정(오시)+줄수 | `t_proc_processes`(**PROC_000029**) + prcs_dtl_opt(줄수)(A→B) | 없음/1~3줄→줄수 param | PROC_000029 오시(실재·엽서 적재됨) | 적재 | 라이브 실측·07_domain §2-3 | ✅ | 오시→접지 선행 의존. 줄수=param |
| 32 | 후가공>미싱 | 공정(미싱)+줄수 | `t_proc_processes`(**PROC_000030**) + prcs_dtl_opt(줄수)(A→B) | 없음/1~3줄→줄수 param | PROC_000030 미싱(실재·엽서 적재됨) | 적재 | 라이브 실측 | ✅ | 절취선 |
| 33 | 후가공>가변(텍스트) | 공정(VDP) | `t_proc_processes`(**PROC_000031** 가변텍스트) + prcs_dtl_opt(개수)(A→B) | 없음/1~3개→개수 param | PROC_000031 가변텍스트(실재·엽서 적재됨) | 적재 | 라이브 실측 | ✅ | VDP. 개수=param. 텍스트/이미지 별 proc(031/032) |
| 34 | 후가공>가변(이미지) | 공정(VDP) | `t_proc_processes`(**PROC_000032** 가변이미지) + prcs_dtl_opt(개수)(A→B) | 없음/1~3개→개수 param | PROC_000032 가변이미지(실재·엽서 적재됨) | 적재 | 라이브 실측 | ✅ | 〃 |
| 35 | 박/형압>박/형압 가공 | 공정(박/형압) | `t_proc_processes`(박=**PROC_000033**·형압=**PROC_000050**) + product_processes + prcs_dtl_opt(음각/양각)(A→B) | 박(없음/있음)·형압(없음/음각/양각) | PROC_000033 박·PROC_000050 형압(실재) | 마스터 존재·엽서 미적재 | 라이브 실측·07_domain §3-2 | ✅ | 박(포일 압착)≠별색금(잉크). 형압 음각/양각=param |
| 36 | 박/형압>크기 | 공정 param(박 면적) | `t_proc_processes`(PROC_000033).prcs_dtl_opt `{크기 number mm}` — **면적→등급 앱계산** | 크기범위=입력UX | prcs_dtl_opt `{"key":"크기","type":"number","unit":"mm"}`(실측) | 마스터 param 실재 | 라이브 실측·메모리 compute-in-app | 🟡 | **박 면적→등급=앱 계산**(DB는 등급별 가격만). prcs_dtl_opt 크기 param 실재 |
| 37 | 박/형압>박칼라 | 공정(박 색상) | `t_proc_processes`(PROC_000033 자식 16종) + product_processes(A→B) | 박색→박 자식 연결 | **금034·은035·핑크036·홀로그램037·금유광038·은유광039·먹유광040·동박041·적박042·청박043·트윙클044·펄박045·백박046·녹박047·금무광048·은무광049**(전수 실재) | 마스터 존재·미적재 | **라이브 실측·Q2 확정** | ✅ | **R12-5: 박칼라=공정(박 자식)** — param도 자재도 아님. Q2 "박 그룹→색상" 정합. CONFIRM-DP-1 RESOLVED |
| 38 | 추가상품>추가상품 | 추가상품(완제 부속) | `t_prd_product_addons`(prd_cd+**tmpl_cd**) + `t_prd_templates`(base_prd_cd)(B) | 봉투명→tmpl_cd 연결 | 엽서 TMPL-000005(OPP접착봉투·base PRD_000001) 실측 | 적재(엽서 1행) | 라이브 실측·Q8(둘다)·models.py:218 | 🟡 | addon=tmpl_cd(addon_cd DROP). ★사이즈선택=봉투 사이즈 캐스케이드. tmpl_cd separator=하이픈(§CONFLICT) |
| 39 | 추가상품>추가가격 | 추가상품 가격 | (빈값 — template/가격 트랙) | 디지털인쇄 시트 미기재 | — | 미저장(시트 빈값) | round-11·loadspec | 🔴 | 디지털인쇄 시트 전부 빈값. **컨펌 Q-DP-A**(template 추가가격 미구현 GAP) |
| 40 | 가격공식 | 가격 공식 | `t_prc_price_formulas`(PRF_DGP_A~F) + `t_prd_product_price_formulas`(prd_cd+frm_cd)(A→B) | 공식 텍스트→PRF_DGP 매핑 | **PRF_DGP_A(엽서·상품권)·B(모양엽서·라벨택)·C(배경지·헤더택)·D(전단지)·E(접지카드)·F(썬캡 미출시)** 전수 실재(FRM_TYPE.01) | 적재(엽서 1행) | 라이브 실측·round-2 | ✅ | round-2 적재됨(308행 COMMIT). 엽서=PRF_DGP_A. |
| 41 | 가격공식(파일명 규칙) | 생산 파일명 토큰 | **GAP/note(가격 아님)** | C40 가격공식과 별 축 | — | GAP/미저장 | round-11·시트 footnote(AN열 무시) | 🟡 | **시트 footnote "AN열은 무시해주세요" — 견적 비대상.** 가격≠파일명 분리 |
| 42~44 | AO/AP/AQ/AR(잔여) | (빈 컬럼) | (적재 비대상) | 전부 빈값 | — | 미저장(빈 컬럼) | L1 실측·시트 footnote | ✅ | L1 CSV에서 AO~AR 전부 빈값. footnote "AN열 무시"+빈 트레일링 컬럼. 적재 비대상 |

**M1 커버리지:** L1 44 composite 컬럼(A~AR) 전수 표에 존재. 제외 사유 명기분: C2(보조키·미저장)·C11/C13(Q1 견적제외)·C39(빈값)·C41(파일명 footnote)·C42~44(빈 컬럼). 누락 0.

---

## 2. CONFLICT 행 (4소스 불일치 — 침묵 선택 금지)

| # | 컬럼 | 소스 A | 소스 B | 처리(권위로 닫음) |
|---|------|--------|--------|-------------------|
| **CONFLICT-1** | C38 tmpl_cd separator | 코드전략(`dbmap-code-identifier-strategy`): separator=`_` 통일(CPQ 하이픈 폐기) | 라이브 실측: `TMPL-000005`(하이픈) | **라이브가 현재 상태 권위** — 기존 tmpl_cd는 하이픈으로 적재됨. 코드전략 `_` 통일은 *신규 채번*에만 적용 의도였으나 templates는 하이픈 잔존. → **컨펌 Q-DP-B**(기존 하이픈 유지 vs 마이그레이션). 매핑은 라이브 형식(`TMPL-NNNNNN`) 따름 |
| **CONFLICT-2** | C16 usage_cd | round-11·loadspec: USAGE.01 본체 | 라이브 실측: USAGE.07 공통(엽서 21행 전수) | **라이브 권위** — 디지털인쇄 종이는 USAGE.07 공통(시트 footnote "MES 통합관리" 정합). round-11 초안 정정(R12-2). CONFLICT 아닌 **정정**으로 닫힘 |
| **CONFLICT-3** | C3 컬럼명 | round-11·loadspec: `mes_item_cd`(소문자) | 라이브: `"MES_ITEM_CD"`(대문자 quoted) | **라이브 권위** — 소문자 컬럼 부재(실증 에러). 적재 SQL은 quoted 대문자. 정정(R12-1)으로 닫힘 |

---

## 3. 라이브 실측 상태 요약 (M5)

| 상태 | 컬럼 수 | 컬럼 |
|------|:--:|------|
| **적재됨**(상품행 실재) | 14 | C1·C4·C5(부분)·C8·C9·C10·C14·C15·C16·C17·C26·C27·C28·C29·C30·C31·C32·C33·C34·C38·C40 |
| **마스터 존재·상품 미적재**(D-1 변형 미적재=적재 대상) | 8 | C18·C19·C20·C21·C22·C23·C24·C25·C35·C36·C37 (별색/코팅/커팅/접지/박/형압) |
| **미저장**(의도적 DB 밖·GAP) | — | C2·C6·C11·C13·C39·C41·C42~44 |

> **D-1 교훈 적용:** 적재됨 = 행 존재만 의미하지 않음. 엽서 PRD_000016은 사이즈 7행(엑셀 13종)·process 6행(별색/코팅/커팅 부재)으로 **변형 커버리지 미달**. 별색·코팅·커팅·박 마스터는 전부 라이브 실재하나 **상품 연결행 미적재** = round-4/5 적재 대상.

---

## 4. 오모델(OM-1~7) 재발 점검 (M4)

| OM | 패턴 | 디지털인쇄 재발 여부 | 근거 |
|----|------|---------------------|------|
| OM-1 | 색=siz | **없음** — 별색은 공정(C18~22→PROC_000007 family), 박색은 공정(C37→PROC_000033 자식). siz는 치수만 | 라이브 실측 |
| OM-2 | size→option | **없음** — 디지털인쇄 사이즈는 전부 이산 치수형(폰기종 같은 옵션성 variant 부재). 단 엽서 사이즈 미적재분(D-1)은 size로 적재(옵션 아님) | column-dictionary C5 |
| OM-3 | 입력UX≠가격격자 | **없음** — 디지털인쇄=원자합산형(PRF_DGP). 면적 연속범위 없음(이산 사이즈) | schema-intent §3.1 |
| OM-4 | 두께 소실 | **N/A** — 디지털인쇄 종이 두께=평량(mat_nm에 인코딩), 별 mat_cd. 아크릴류 두께 아님 | — |
| OM-5 | UV/별색 위치 혼동 | **없음** — 디지털=PROC_000004(인쇄방식), 별색=PROC_000007 공정(도수칸 아님), print_side는 단/양면만. 라이브 print_options 검증(엽서 단/양면 2행, 별색 부재) | 라이브 실측 |
| OM-6 | CPQ 옵션 레이어 미적재 | **해당**(횡단) — 디지털인쇄 option_items도 전역 미적재(L2). 별색 다중선택·코팅 캐스케이드는 round-6 CPQ 대상 | schema-intent OM-6 |
| OM-7 | 공정 param 보존 부재 | **해당**(GAP-PARAM) — 커팅 모양·박 크기·오시 줄수·가변 개수가 prcs_dtl_opt에 보존. 라이브 prcs_dtl_opt 실재(박 크기·완칼 모양 확인). `ref_param_json` 미구현은 dbm-ddl-proposer | 라이브 실측·OM-7 |

> **OM 재발 0**(디지털인쇄 고유). OM-6·OM-7은 전 시트 횡단 이슈(디지털인쇄 특유 오모델 아님) — 라우팅만, 본 시트 매핑 수정 불요.

---

## 5. 🔴 컨펌 질문 (인간 결정 대기)

- **Q-DP-A [🔴] C39 추가상품 추가가격** — 디지털인쇄 시트 전부 빈값. 봉투 추가가격을 (a) `t_prd_templates` 추가가격(미구현 GAP·ddl-proposer) (b) base_prd 가격으로 흡수 (c) 견적 시 합산 안 함 — 어디로 둘까요?
- **Q-DP-B [🔴] C38 tmpl_cd separator(CONFLICT-1)** — 기존 templates는 라이브에 하이픈(`TMPL-000005`)으로 적재됨. 코드전략은 `_` 통일을 정했습니다. (a) 기존 하이픈 유지(신규도 하이픈) (b) `_`로 마이그레이션 — 어느 쪽인가요?

> **나머지 round-11 컨펌은 라이브 실측으로 전부 RESOLVED:** CONFIRM-DP-1(박칼라=공정 R12-5)·DP-2(파일명/폴더=Q1 견적제외)·DP-3(블리드=Q14 도출)·DP-4(별색 family R12-6)·DP-5(건수=QTY_UNIT.02 R12-3).

---

## 6. 적재 순서 (FK 위상정렬 — round-4 정합·라이브 검증)

```
1. 마스터(surface A 선적재 — 라이브 전수 실재 확인):
   t_cod_base_codes(MAT_TYPE/USAGE/OUTPUT_PAPER_TYPE/QTY_UNIT/PRD_TYPE 등)
   → t_siz_sizes → t_mat_materials → t_proc_processes(별색007·코팅013·박033·완칼053·접지056 family)
   → t_clr_color_counts(CLR_000001~005) → t_prc_price_formulas(PRF_DGP_A~F) → t_prd_templates(TMPL-NNNNNN)
2. 상품(surface A): t_prd_products (prd_nm 멱등, "MES_ITEM_CD" quoted)
3. 상품 하위(surface B): _sizes → _plate_sizes(output_paper_typ_cd) → _materials(usage_cd=USAGE.07)
   → _print_options(단/양면) → _processes(별색/코팅/커팅/접지/박/형압/모서리/오시/미싱/가변) → _addons(tmpl_cd) → _price_formulas
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(prd_nm/mat_nm/proc_nm). 감사컬럼 비입력. **마스터 코드/공정은 전부 라이브 실재 — 신규 mint 불요**(search-before-mint 충족).
