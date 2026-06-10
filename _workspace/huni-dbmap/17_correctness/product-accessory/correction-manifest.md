# 상품악세사리 — 교정 매니페스트 (correction-manifest · round-13 C4)

> **작성** 2026-06-11 · round-13. 각 diff를 CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS로 분류 + why(oracle 근거+적재로직 원인) + how(비파괴 교정 제안) + 심각도 + 라우팅.
> **[HARD] 비파괴:** 교정은 제안까지. COMMIT/DDL/DELETE 없음. EXTRA/REMOVED=논리삭제 제안. search-before-mint(기존 행 재사용 우선).
> **라우팅:** 교정직접(단순 연결행 추가) / ddl-proposer(스키마 부족) / load-execution(적재 실행) / 컨펌(인간 결정).

---

## 1. 분류표 (빈칸 0)

| ID | 상품 | 속성 | 분류 | 라이브 현재값 | 정답값 | why (oracle 근거 + 적재로직 원인) | how (비파괴 교정) | 심각도 | 라우팅 |
|----|------|------|------|---------------|--------|-----------------------------------|-------------------|:--:|------|
| **PA-01** | PRD_000001~015 (15 전부) | 카테고리 | MIS-LOADED | CAT_000293 상품악세사리(upr=NULL·lvl3 잉여 고아) | 봉투/케이스(001~005·009·010)→**CAT_000276**·자석(011)→**CAT_000285**·부속(006/007/008/012/013/014/015)→**CAT_000287** | 정체=카테고리 012 포장(product-master:172~177·L1 MES 012). 정상 노드 276/285/287 이미 upr=012로 실재. load_categories(load_master.py:171,175)가 `구분` 라벨→고아 노드 293 생성·load_rel_categories(:288)가 상품을 거기 연결(L-PA-B). PRD_000283은 정상 276 연결(반례) | **상품을 기존 정상 노드(276/285/287)로 재연결**(`t_prd_product_categories` UPDATE, search-before-mint) + 잉여 고아 293 논리정리(use_yn=N) | High | 컨펌(Q-PA-A)+load-execution |
| **PA-02** | PRD_000006 볼체인·015 리필잉크·**007 와이어링·010 행택끈**(GATE-1 흡수) | 색상 variant | MIS-LOADED | 색상 = `t_mat_materials` MAT_TYPE.10(자재 오염, 묶음/용량 합성)·옵션 0. **006=8·015=7·007=3(실버/화이트/블랙·MAT_000210/212/213)·010=3(사각검정/백색/마사·MAT_000217/219/220)** 전부 MAT_TYPE.10 | 색상 = `option_items`(option_groups 택1·색상) | 메모리 dbmap-material-option-normalization(★HARD — 색상≠자재, MAT_TYPE.10 오염). `05_자재정보` 시트가 색상을 자재 행으로 정의·load_master(:236)가 그대로 적재(L-PA-D). domain-research PA-3·CONFIRM-PA-3. **GATE-1: 007/010도 동형 색상=자재(재실측 확정), 직전 PA-08 "0행 MISSING"은 실측 누락→흡수** | 색상→`t_prd_product_option_groups/options/option_items` 신설 제안(polymorphic OPT_REF_DIM) + 기존 MAT_TYPE.10 색상 자재 논리삭제(006/007/010/015 일괄). **단 묶음/용량("3개1팩"·"100개"·"5cc")은 자재명에서 분리**(축②/시즈) | High | 컨펌(Q-PA-B)+ddl 없음(옵션 테이블 실재)+load-execution |
| **PA-03** | PRD_000001~015 (15 전부) | 가격 | MISSING | 공식 0·component 0 | L1 variant별 고정가(1100/3000/16000원 등) → 고정형 PRF + `t_prc_component_prices` | L1 "가격포함" 시트 단가 명시. 가격은 round-2 트랙(load_master 미관여 :469-481). 부자재가 round-2 커버 밖→전무(L-PA-F) | 부자재 component(예 COMP_ACCESSORY) + 고정형 공식 PRF + variant 단가 적재 제안(round-2 양식). 봉투=치수×묶음 격자·색상부자재=색상별 | High | load-execution(round-2 양식) |
| **PA-04** | PRD_000043/044 배경지 (호스트) ↔ PRD_000001~009 봉투/케이스 | 봉투 세트(축⑥) | MISSING | 배경지 addon=0·sets=0·봉투 template 준비됨 | 6 사이즈×매칭 봉투(043)·2 사이즈×PP케이스(044) 세트 (site goods_view_102) | 봉투 template(TMPL-000005/006/009) 실재하나 배경지가 참조 안 함. 봉투가 디지털인쇄 시트 C38 자유텍스트→load_rel_addons(:436) 시트20만 읽음(디지털 L-G). migrate_phase7는 없는 행 안 만듦 | **봉투 template(TMPL-000005/006/009 재사용, search-before-mint) → 배경지에 addon 또는 sets 연결**. 사이즈매칭=CPQ template_selections. **모델=Q-ID-A** | High | 컨펌(Q-ID-A)+load-execution |
| **PA-05** | PRD_000006 볼체인·008 천정고리·010 행택끈 | 묶음수 | MISSING | bundle 0행 | 볼체인 3·팩(3개1팩)·천정고리 2·세트(2개1세트)·행택끈 100·개 | L1 합성 셀 묶음수("3개1팩"·"2개1세트"·"100개"). `12_상품별묶음수` 시트 미분해→bundle 0(L-PA-G) | `t_prd_product_bundle_qtys` INSERT(볼체인 3 QTY_UNIT.05·천정고리 2 QTY_UNIT.04·행택끈 100 QTY_UNIT.01) | Med | load-execution |
| **PA-06** | PRD_000003 트래싱지 | 사이즈 | MIS-LOADED | 8 siz(3치수×묶음수 평면화: 160x110×20/40/100장 등) | 3 치수 siz + 묶음수 4종=bundle_qty | `04_사이즈정보`가 치수×묶음수를 합성 siz로 정의·load_master 그대로(L-PA-C). 치수와 묶음수가 곱셈 평면화 | siz를 3 치수로 축약 + 묶음수를 bundle_qty로 분리(가격은 치수×묶음 격자 유지) | Med | 컨펌(Q-PA-C·book묶음 정합)+load-execution |
| **PA-07** | PRD_000004 카드봉투 | 색상 + 이중등록 | AMBIGUOUS | 색상 W/B가 siz_nm 합성(2 siz)·별 PRD 281/282도 존재 | 색상=옵션 또는 별 SKU(일관) | 카드봉투 004(기성 PRD_TYPE.03)는 색상을 siz_nm에 합성·281/282(추가 PRD_TYPE.05)는 별 PRD. **색상 처리 방식이 한 상품에서 둘로 갈림**. 09_delete_dup(281/282 삭제 제외=이중등록 의도) | 색상 처리 일원화 컨펌: 004 색상→siz 제거 후 옵션/별SKU 통일·281/282와 역할 정합 | Med | 컨펌(Q-PA-D) |
| **PA-08** | PRD_000007 와이어링·010 행택끈 | 색상 variant | **MIS-LOADED**(GATE-1 정정·PA-02 흡수) | **3행씩 MAT_TYPE.10**(와이어링 실버/화이트/블랙·행택끈 사각검정/백색/마사)·옵션 0 | 색상 3 = option_items | **GATE-1 정정[HARD]:** 직전 본 항목은 "material 0·MISSING"으로 잘못 기록(live-diff §5 SELECT가 007/010을 IN절에 포함했음에도 0행 기록=실측 누락). 재실측 확정: 둘 다 색상이 자재(MAT_TYPE.10)로 적재 = 볼체인·리필잉크와 **동형 MIS-LOADED**. round-10 델타 경로가 INSERT(MISSING)→**UPDATE/논리삭제+옵션 INSERT(MIS-LOADED)**로 바뀜 | **PA-02와 동일 모델로 일괄 처리** — 색상 자재(MAT_TYPE.10) 논리삭제 + option_items 신설. (단독 INSERT 아님·기존 오염 행 정리 동반) | Med | 컨펌(Q-PA-B)+load-execution |
| **PA-09** | PRD_000001 OPP접착봉투 | 묶음수 단위 | MIS-LOADED | bdl_qty=50·**QTY_UNIT.01 EA** | 50·매(또는 팩·후니 통일) | L1 "(50장)". 라이브 002=QTY_UNIT.02(매)인데 001=QTY_UNIT.01(EA) **같은 "장"이 다른 단위**(L-PA-C 혼선) | 001 단위를 후니 통일 단위로 UPDATE(002와 정합) | Low | 컨펌(Q-PA-E·단위 통일)+load-execution |
| **PA-10** | PRD_000001~011 봉투/케이스 | 사이즈 siz_nm | MIS-LOADED | siz_nm에 "(50장)" 묶음수 잔존 | siz_nm=치수만(묶음수 제거) | 묶음수가 cut_*+bundle 분해됐음에도 siz_nm 텍스트에 중복(L-PA-C 3축 미완) | siz_nm 텍스트 정리 UPDATE(묶음수 제거)·또는 표시 전용으로 잔존 허용 | Low | 컨펌(Q-PA-C) |
| **PA-11** | PRD_000008 천정고리 | use_yn·MES | AMBIGUOUS | use_yn=N·MES NULL | 판매 활성 여부 미상 | L1에 천정고리 가격(6500) 있으나 라이브 use_yn=N. MES도 8/15 NULL(load_master:261 None과 불일치=후속 손작업) | use_yn=N이 판매중지 의도면 유지·적재 누락이면 Y로 복원 | Low | 컨펌(Q-PA-F) |
| **PA-12** | PRD_000281/282/283 | 이중등록 | CORRECT(의도) | 추가상품 PRD_TYPE.05 + template base | 이중등록(독립판매 004 + addon SKU 281/282/283) | round-9 OTC 권위(부자재 이중역할). 09_delete_dup_products(중복명 7건 삭제: 099/113~117/167/182)가 281/282/283 **삭제 제외=의도 보존**. mapping-info "OTC TEMPLATE 이중등록" | 유지. 단 004↔281/282 역할 분리는 PA-07 컨펌 | — | 없음(+PA-07 연계) |
| **PA-13** | PRD_000012~014 우드 | 길이 variant | AMBIGUOUS | 우드거치대=material 1행·우드봉/행거=material 0·siz 0 | 길이 3종(270/360/480mm 등) = siz 또는 옵션 | L1 길이 variant("270mm + 면끈"). 라이브 미분해(우드봉/행거 siz·material·option 전부 0) | 길이→siz(치수형) 또는 옵션 신설(우드거치대 C-4 분기, domain-research PA-4) | Med | 컨펌(Q-PA-G·우드 C-4)+load-execution |
| **PA-14** | PRD_000001~015 | MES·qty_unit | CORRECT(경로불명) | MES 7/15 채움·qty_unit 채움 | (값 자체 정답) | load_master.py:261,269 무조건 None 적재→라이브 채워진 값은 후속 손작업 산물(L-PA-A). 값은 L1과 정합 | 유지. 적재 경로는 webadmin 밖(finding) | Low | 없음 |

---

## 2. 분류 분포

| 분류 | 건수 | 항목 |
|------|:--:|------|
| CORRECT | 2 | PA-12(이중등록 의도)·PA-14(MES/qty_unit 값정답·경로불명) |
| MIS-LOADED | 6 | PA-01(카테고리)·PA-02(색상자재 006/015)·PA-06(사이즈평면화)·**PA-08(색상자재 007/010·GATE-1 재분류)**·PA-09(단위)·PA-10(siz_nm 잔존) |
| MISSING | 3 | PA-03(가격)·PA-04(봉투세트)·PA-05(묶음수) |
| EXTRA | 0 | (잘못 추가된 행 없음. 잉여 고아 노드 293은 카테고리 노드이고 상품행은 정상) |
| AMBIGUOUS | 3 | PA-07(카드봉투 색상)·PA-11(천정고리 use_yn)·PA-13(우드 길이) |

> 합계 14건. **GATE-1 정정:** PA-08을 MISSING→MIS-LOADED 재분류(MIS-LOADED 5→6·MISSING 4→3·총 14 불변). EXTRA 0 — 봉투 상품·template 잉여 적재 없음(미적재·오연결이 주 결함). 논리삭제 제안 = PA-01(잉여 고아 293)·PA-02/PA-08(색상 자재 행 006/007/010/015 일괄)·GATE-2 테스트 잔재 옵션그룹 2(PRD_000001 "테스트"·PRD_000002 "제본방식")(hard-delete 금지·use_yn/del_yn).

---

## 3. 라우팅 분포

| 라우팅 | 건수 | 항목 |
|--------|:--:|------|
| 없음(유지) | 2 | PA-12·PA-14 |
| load-execution | 9 | PA-01·02·03·04·05·06·08·09·13 (PA-08 라우팅 불변 — 재분류 후에도 load-execution+컨펌) |
| 컨펌(인간) | 8 | PA-01·02·04·06·07·09·11·13(중복) |
| ddl-proposer | 0 | (option_items·sets·addons·bundle 전부 실재 — 스키마 부족 없음) |

> **GATE-2 추가:** 테스트 잔재 옵션그룹 2(PRD_000001 OPT-000003 "테스트"·PRD_000002 OPT-000001 "제본방식", 둘 다 items 0)는 부자재 색상 옵션 아님 → 논리삭제(use_yn/del_yn) 후보. 부자재 결함 분류와 무관(서술 정밀화만, 라우팅=load-execution 논리삭제). PA-08 MISSING→MIS-LOADED 재분류로 델타 경로가 단독 INSERT에서 **오염 자재 논리삭제+옵션 INSERT**로 바뀌나 라우팅 자체는 불변.

---

## 4. 🔴 컨펌 질문

- **Q-ID-A [🔴·인계 답] 봉투/케이스 세트 적재 모델** — 디지털인쇄 파일럿이 남긴 핵심 컨펌. **라이브 실측 기반 권고(§5):** 봉투 template(TMPL-000005/006/009)은 이미 실재하나 배경지(043/044)가 참조 안 함. (a) `t_prd_product_sets`(배경지=상품·봉투=하위·사이즈매칭) (b) `t_prd_product_addons`(tmpl_cd, 엽서와 동형) (c) CPQ 옵션(사이즈선택 캐스케이드) 중 어디로? **→ §5 권고 = (a) sets + (c) 사이즈매칭 캐스케이드 병행**(아래).
- **Q-PA-A [🔴] 카테고리 재연결 vs 고아 노드 보수** — 15 부자재를 (a) 정상 노드 276/285/287로 재연결 + 잉여 고아 293 논리정리(권장·search-before-mint, PRD_000283 반례 입증) (b) 고아 293의 upr만 012로 UPDATE(잉여 노드 잔존) — 어느 쪽? 디지털인쇄 Q-ID-B와 일괄 결정 후보.
- **Q-PA-B [🔴] 색상 variant 귀속** — 볼체인 8색·리필잉크 7색·와이어링 3색·행택끈 3종을 (a) option_items(권장·메모리 정규화 권위 "색상≠자재") (b) 자재(MAT_TYPE.10) 유지 (c) 색상별 별 SKU — 어디로? 굿즈파우치 GP-2(본체색)·CONFIRM-PA-3과 일괄.
- **Q-PA-C [🔴] 사이즈 3축 분해 깊이** — 트래싱지(003) 치수×묶음수 평면화(8→3치수+묶음)·봉투 siz_nm 묶음수 잔존을 (a) 완전 분해(치수=siz·묶음=bundle, siz_nm 정리) (b) 현 합성 유지(표시 편의) — 어디까지? book/굿즈 묶음수 처리와 정합.
- **Q-PA-D [🔴] 카드봉투 색상·이중등록 역할** — 004(기성, 색상 siz 합성) vs 281/282(추가, 별 PRD) 색상 처리 일원화 + 역할 분리(004=독립판매·281/282=색상별 addon SKU?).
- **Q-PA-E [🟡] 묶음 단위 통일** — "장"을 QTY_UNIT.01(EA)/.02(매)/.05(팩) 중 무엇으로 통일(PRD_000001 EA·002 매 혼선)?
- **Q-PA-F [🟡] 천정고리 use_yn=N** — 판매중지 의도인지 적재 누락인지(L1 가격 6500 존재).
- **Q-PA-G [🟡] 우드 길이 variant + C-4 분기** — 우드봉/행거 길이를 siz vs 옵션, 본체가공 OPTION vs 별매 TEMPLATE(domain-research PA-4·캘린더 CL-2 일괄).

---

## 5. Q-ID-A 권고 — 봉투 세트 적재 모델 (라이브 실측 기반)

**라이브 실체 종합:**
- 봉투 상품(PRD_000001~009)·봉투 template(TMPL-000005/006/009 활성)은 **이미 준비**(search-before-mint 재사용 가능).
- 배경지(043/044)는 supplier(host)로서 봉투를 **세트로 동봉**(site goods_view_102: "배경지(76x100)+투명봉투"·"배경지(74x74)+투명케이스"). 단순 선택 추가상품(엽서 addon)과 다름 — 사이즈가 본체와 **매칭**돼야 함.
- 라이브 `t_prd_product_sets`는 28행으로 정상 작동(타 상품). 모델 자체는 실재.

**권고: (a) `t_prd_product_sets` + (c) CPQ 사이즈매칭 캐스케이드 병행**

| 측면 | 권고 | 근거 |
|------|------|------|
| 세트 구성 | `t_prd_product_sets`(prd_cd=배경지·sub_prd_cd=봉투 상품·sub_prd_qty=1) | 사이트가 "세트"로 판매(동봉)·sets 테이블 실재·load_rel_sets(load_master.py:424) 양식 존재 |
| 봉투 정체 | 봉투=하위상품(sub_prd_cd, PRD_000001/002/009 재사용) | 봉투는 독립 상품(기성 PRD_TYPE.03)·sets는 prd_cd 참조(addon tmpl_cd보다 정체 부합) |
| 사이즈 매칭 | CPQ `template_selections`/constraint로 배경지 siz ↔ 봉투 siz 연동 | "배경지 76x100 ↔ 봉투 80x120" 매칭이 핵심·옵션 캐스케이드 |
| addon(b) 부적합 | 엽서식 단순 addon(tmpl_cd)은 사이즈 매칭·세트 동봉 표현 불가 | 엽서 봉투는 선택(세트 아님)이라 addon 적정·배경지는 세트 |

**비파괴 교정 제안(데이터·DDL 아님):**
1. `t_prd_product_sets` INSERT: 배경지 043/044 × 매칭 봉투(PRD_000001/002/009) — 사이즈별 행. search-before-mint(봉투 상품 실재).
2. CPQ 사이즈매칭 constraint(배경지 siz 선택→봉투 siz 자동): `t_prd_product_constraints` JSONLogic.
3. 단순 선택형 봉투(엽서)는 현행 addon(tmpl_cd) 유지 — 세트와 분리.

> **단, sets vs addon은 인간 결정(Q-ID-A 컨펌)** — 본 권고는 라이브 실측·정체 근거 기반 제안이며 실 적재는 round-5/인간 승인.

---

## 6. 방법론 입증 소견

- **정체 선행이 카테고리 결함을 잡았다:** 상품악세사리를 "별도 부자재 카탈로그"로 보면 카테고리 오연결이 안 보인다. C-ID에서 product-master:172~177로 "카테고리 012 포장재"임을 확정하자 **15 부자재 전부가 잉여 고아 293에 묶인 결함(PA-01 High)**이 드러났다 — 디지털인쇄 배경지(296)·상품권(295)과 완전 동형. **정체 레벨 결함은 5속성축만 보면 안 보인다.**
- **라이브=교정대상 프레임이 색상 오염을 드러냄:** round-11 mapping-info는 색상 variant 귀속을 "미확정(PA-3)"으로 남겼으나, round-13이 라이브를 실측해 **이미 자재(MAT_TYPE.10)로 오염 적재**(PA-02)됨을 밝혔다. "미정"이 아니라 "잘못 채워짐"이 실체 — 교정 방향이 명확해졌다.
- **Q-ID-A를 봉투 원천 시트가 답함:** 디지털인쇄 파일럿이 남긴 Q-ID-A를, 봉투 상품·template의 원천인 상품악세사리 시트가 라이브 실측으로 답했다 — 봉투 template은 준비됐고 배경지가 참조 안 하는 것이 결함이며, sets+CPQ 매칭이 정체 부합 모델(§5).
- **적재 로직 근본원인까지:** 카테고리 고아(load_categories:171,175)·색상 자재(05_자재정보 시트 그대로 적재:236)·봉투 세트 미적재(load_rel_addons 시트20 한정:436)·가격 전무(round-2 미커버:469-481)로 환원 — 증상이 아닌 원인을 짚어 교정이 정밀.
- **이중등록은 결함 아닌 의도(반례 검증):** 09_delete_dup_products가 281/282/283을 삭제 제외한 것을 SQL로 확인 → 이중등록(PA-12 CORRECT)을 "결함"으로 오판하지 않았다. PRD_000283이 정상 카테고리 노드에 연결된 것도 교정 패턴(search-before-mint)의 라이브 입증.
