# 디지털인쇄 — 교정 매니페스트 (correction-manifest · round-13 C4)

> **작성** 2026-06-10 · round-13. 각 diff를 CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS로 분류 + why(oracle 근거+적재로직 원인) + how(비파괴 교정 제안) + 심각도 + 라우팅.
> **[HARD] 비파괴:** 교정은 제안까지. COMMIT/DDL/DELETE 없음. EXTRA/REMOVED=논리삭제 제안. search-before-mint(기존 행 재사용 우선).
> **라우팅:** 교정직접(단순 연결행 추가) / ddl-proposer(스키마 부족) / load-execution(적재 실행) / 컨펌(인간 결정).

---

## 1. 분류표 (빈칸 0)

| ID | 상품 | 속성 | 분류 | 라이브 현재값 | 정답값 | why (oracle 근거 + 적재로직 원인) | how (비파괴 교정) | 심각도 | 라우팅 |
|----|------|------|------|---------------|--------|-----------------------------------|-------------------|:--:|------|
| **C-01** | 엽서 016 | size | CORRECT | 7행(73x98~148x210) | 엑셀 nonblank 7행 | 엑셀 L1 프리미엄엽서 사이즈 7행 = 라이브 7행 일치(`SELECT…t_prd_product_sizes`). **round-12 "13종"은 오류** | 유지. mapping-final §1 C5 "13종" 정정 | — | 없음 |
| **C-02** | 엽서 016 | 공정 | CORRECT | 6행(027/028/029/030/031/032) | 모서리·오시·미싱·가변(별색/코팅/커팅 없음) | 엑셀 엽서 후가공 nonblank = 모서리/오시/미싱/가변. load_master.py:404-421 시트15 충실 반영 | 유지 | — | 없음 |
| **C-03** | 엽서 016 | 자재 | CORRECT | 21행 USAGE.07 | 종이 + USAGE.07 공통 | load_master.py:324 빈 용도→USAGE.07 default(정당). seed USAGE.07=공통 | 유지. 도메인 의미는 "본체"이나 코드는 공통(정당) | — | 없음 |
| **C-04** | 엽서 016 | addon | MIS-LOADED | TMPL-000005 1행만 | 엽서봉투·OPP비접착·카드봉투(W/B)·트레싱지 등 다수 | 엑셀 C38 자유텍스트 다수 봉투. load_rel_addons(load_master.py:436)는 시트20만 읽음→일부만. 사이즈별 봉투 매칭 누락 | 누락 봉투 template 연결 추가(`t_prd_product_addons` INSERT, TMPL-000006~009 재사용 — search-before-mint) | Med | load-execution |
| **C-05** | 상품권 041/042 | 카테고리 | MIS-LOADED | CAT_000295 상품권(upr_cat_cd=NULL orphan) | 판매 카테고리 트리에 위상 연결 | load_categories(load_master.py:164-178) 상위코드 NULL→고아. 시트 `구분`→편의 카테고리 | CAT_000295에 적정 상위(03 인쇄홍보물 또는 신설) UPDATE 제안 | Med | 컨펌+load-execution |
| **C-06** | 상품권 042 | 박 공정 | AMBIGUOUS | 박색 자식 8종(037~044) 연결·부모 PROC_000033 미연결 | 박(있음)=부모 PROC_000033 + 박색 자식 | 엑셀 `박(있음)` 단일 신호. 라이브 8색 전개=적재원 과적재 또는 옵션풀. 부모 박 누락 | 부모 PROC_000033 연결 추가 검토 / 8색이 옵션 풀이면 CPQ option_items로 / 엑셀은 "있음"만 | Med | 컨펌 |
| **C-07** | 배경지 043 | 공정(커팅) | MISSING | 0행 | 전용 커팅 ~13형상(기본형/타공형/핀고정형/북마크/스마트톡형/카드고정형/키링형/폰스트랩형) → PROC_000053 완칼 + prcs_dtl_opt(형상) | 엑셀 C24 커팅 22행 실재. load_master 시트15에 배경지 커팅 행 부재(v03)→미적재. 정체=포장 배경지인데 전용 커팅이 핵심 | PROC_000053(완칼) 연결 + 형상=prcs_dtl_opt param(OM-7). search-before-mint(완칼 마스터 실재) | High | load-execution |
| **C-08** | 배경지 043 | 봉투 세트(축⑥) | MISSING | addon=0·sets=0 | 6 사이즈×매칭 OPP봉투 세트(site goods_view_102) | **정체=포장 세트**(product-identity F-ID-1). 봉투가 C38 자유텍스트→load_rel_addons 파싱 범위 밖(loadlogic L-G). migrate_phase7는 없는 행 안 만듦 | 봉투 template(TMPL-000004~006 재사용) → `t_prd_product_addons` 또는 `t_prd_product_sets` 연결. 사이즈 매칭=캐스케이드 | High | 컨펌(Q-ID-A)+load-execution |
| **C-09** | 배경지 043/044/045 | 카테고리 | MIS-LOADED | CAT_000296 배경지(upr_cat_cd=NULL orphan) | CAT_000012 포장 하위 | 정체=카테고리 012 포장(MES 012·product-master:82). load_categories 상위 NULL→고아. 시트 `구분`→편의 카테고리 | CAT_000296 upr_cat_cd=CAT_000012 UPDATE 또는 상품을 012 하위 노드로 재연결 | High | 컨펌+load-execution |
| **C-10** | 배경지 044 | 공정(접지) | MISSING | 0행 | 접지(기본형/상하접지형) → PROC_000056 접지 family | 엑셀 C25 접지(투명케이스타입 접지형). load_master 시트15 배경지 접지 행 부재 | PROC_000056 연결 + prcs_dtl_opt(단수/방향). search-before-mint(접지 마스터 실재) | Med | load-execution |
| **C-11** | 배경지 044 | 케이스 세트(축⑥) | MISSING | addon=0·sets=0 | 2 사이즈×PP투명케이스 세트(site) | C-08과 동형(케이스 버전). 케이스가 C38 자유텍스트 | PP투명케이스 template(라이브 검색 후 없으면 신설 제안=ddl 아님·데이터) → addon/sets 연결 | High | 컨펌(Q-ID-A)+load-execution |
| **C-12** | 라벨택 046 | size | CORRECT | 3행(40x80·50x50·25x110) | 엑셀 3종 | 일치 | 유지 | — | 없음 |
| **C-13** | 라벨택 046 | 공정(커팅) | MISSING | 0행 | 형상 커팅(사각/라운딩/삼각/팔각/원형/사각리본/삼각리본/리본) → PROC_000053 완칼 + 형상 param | 엑셀 C24 형상 다수. load_master 시트15 미적재 | PROC_000053 연결 + 형상 param. C-07과 동형 | Med | load-execution |
| **C-14** | 라벨택 046 | 카테고리 | MIS-LOADED | CAT_000296 배경지(orphan) | CAT_000012 포장(라벨/포장스티커 CAT_000283) | 정체=포장 라벨(product-master:175·388). 잘못된 그룹(배경지)에 연결 | CAT_000283(라벨/포장스티커, 012 하위 실재)로 재연결 UPDATE | Med | load-execution |
| **C-15** | 전 디지털 상품 | qty_unit | CORRECT(경로불명) | QTY_UNIT.02 매 | QTY_UNIT.02 매 | load_master.py:269 None 하드코딩→라이브 값은 후속 보정 산물(loadlogic L-A). 값 자체는 정답 | 유지. 적재 경로는 비공식(finding) | Low | 없음 |
| **C-16** | 전 디지털 상품 | plate output_paper_typ | CORRECT(경로불명) | OUTPUT_PAPER_TYPE.01 | .01 국전계열(316x467) | load_master.py:340 무조건 .기타 적재→라이브 .01은 후속 plate교정(c722c24) 산물(loadlogic L-B). 값 정답 | 유지. 적재 경로는 webadmin 밖 | Low | 없음 |
| **C-17** | 엽서 016 | addon separator | AMBIGUOUS | TMPL-000005(하이픈) | 코드전략은 `_` 통일 | migrate_phase7.py:215,222 `'TMPL-'||addon_prd_cd` 하이픈 결합. 코드전략(`_`)과 CONFLICT | 기존 하이픈 유지(신규도 하이픈) vs `_` 마이그레이션 컨펌(mapping-final Q-DP-B) | Low | 컨펌 |
| **C-18** | 배경지 043 등 | 자재 | AMBIGUOUS | 1행(스노우250) | 스노우250 + 몽블랑240(엑셀 일부) | 엑셀 배경지 종이 일부만 적재 가능. 단 배경지 종이가 단일일 수도 | 엑셀 배경지 종이 행 재확인 후 누락분 연결 | Low | load-execution |

---

## 2. 분류 분포

| 분류 | 건수 | 비고 |
|------|:--:|------|
| CORRECT | 5 | C-01·02·03·12 + (C-15·16 값정답·경로불명) |
| MIS-LOADED | 4 | C-04(addon)·C-05·C-09·C-14(카테고리) |
| MISSING | 5 | C-07·C-08·C-10·C-11·C-13(커팅/접지/봉투세트) |
| EXTRA | 0 | (배경지 과적재 없음. C-06 박색은 AMBIGUOUS로 분류) |
| AMBIGUOUS | 3 | C-06(박부모)·C-17(separator)·C-18(자재) |

> 합계 18건(C-15/16은 CORRECT-경로불명 별도 카운트). EXTRA 0 — 라이브에 잘못 추가된 행은 없음(미적재가 주 결함). 논리삭제 제안 없음.

---

## 3. 라우팅 분포

| 라우팅 | 건수 | 항목 |
|--------|:--:|------|
| 없음(유지) | 6 | C-01·02·03·12·15·16 |
| load-execution | 6 | C-04·C-07·C-10·C-13·C-18 (+C-08/09/11 일부) |
| 컨펌(인간) | 5 | C-05·C-06·C-08·C-09·C-11·C-17(중복) |
| ddl-proposer | 0 | (필요 스키마 부족 없음 — prcs_dtl_opt·sets·addons 전부 실재) |

---

## 4. 🔴 컨펌 질문

- **Q-ID-A [🔴·신규] 배경지 봉투/케이스 세트 적재 모델** — 사이트는 "배경지+봉투/케이스"를 **세트로 판매**(goods_view_102). (a) `t_prd_product_sets`(배경지=상품, 봉투=하위, 사이즈매칭) (b) `t_prd_product_addons`(tmpl_cd, 엽서와 동형) (c) CPQ 옵션(사이즈선택 캐스케이드) — 어디로? 정체상 세트(a/c)가 맞으나 결정 필요.
- **Q-ID-B [🔴·신규] 배경지/상품권/라벨택 카테고리 위상** — CAT_000296 배경지·CAT_000295 상품권은 upr_cat_cd=NULL 고아. 배경지/라벨택은 CAT_000012 포장 하위로 재배치할까요? (상품권은 03 인쇄홍보물 하위?)
- **Q-DP-C [🔴] 상품권 042 박 8색** — 라이브 박색 자식 8종이 부모 PROC_000033 없이 연결. 엑셀은 `박(있음)` 단일. 8색=옵션 풀(CPQ option_items)인가, 부모 박 행 추가 필요인가?
- **Q-DP-B [🔴·기존] tmpl_cd separator** — 하이픈(`TMPL-000005`) 유지 vs `_` 마이그레이션(mapping-final 인계).

---

## 5. 방법론 입증 소견

- **정체 선행이 결함을 잡았다:** 배경지를 "일반 인쇄물"로 본 round-11/12는 봉투 세트·전용 커팅·포장 카테고리를 보지 못했다. C-ID에서 사이트(goods_view_102)·product-master로 "포장 세트"임을 확정하자 **C-07~C-11·C-14(High/MISSING 5건)**가 드러났다 — 이는 5속성축만 보면 안 보이는 정체 레벨 결함이다.
- **라이브=교정대상 프레임의 가치:** round-12 mapping-final은 라이브를 권위로 "엽서 13종(D-1 변형 미적재)"이라 했으나, round-13이 엑셀과 라이브를 모두 7행으로 실측해 **그 주장이 오류**(C-01 CORRECT)임을 밝혔다. 반대로 라이브가 "적재됨"이라 표기한 배경지는 행만 있고 상품은 불완전(C-07~11)임을 드러냈다. 양방향(라이브가 과소·과대 평가된 것 모두) 교정.
- **적재 로직 근본원인까지:** MISSING 결함이 load_rel_addons의 시트20 한정 파싱(L-G)·load_categories 상위 NULL(L-H)·시트15 적재원 결함(L-C)으로 환원됐다 — 증상이 아닌 원인을 짚어 교정이 정밀하다.
- **11시트 확대 가치:** 디지털인쇄 36상품 중 포장재(배경지/헤더택/라벨택 4상품)가 정체 오분류로 다량 미적재. 다른 시트(굿즈파우치=포장·상품악세사리=OTC 등)도 정체 레벨 오분류 가능성이 높아, 정체 선행 감사를 전 시트로 확대할 가치가 크다.
