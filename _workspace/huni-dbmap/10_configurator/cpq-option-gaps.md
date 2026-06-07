# CPQ 옵션 레이어 GAP 레지스터 (→ dbm-ddl-proposer) — round-6

> **목적:** 속성→엔티티 마스터 지도(`attribute-entity-map.md`)가 발굴/집약한 **라이브 스키마 GAP 전건**을 dbm-ddl-proposer 입력으로 등록한다. 발명 금지 — 플래그만. 실 컬럼/테이블 추가는 search-before-mint(사다리: 코드행 < 컬럼 < JSONB < 테이블) 후 인간 승인.
>
> **상태/이력** 작성 2026-06-07 · `dbm-option-mapper` 산출. DDL 무적용·DB 미적재.
> **권위:** `00_schema/cpq-schema.md §4`(design↔live 정합·ref_param_json 미구현) · `cascade-rules.md`(RedPrinting 6종) · `banner/postcard-walkthrough.md`(GAP-5) · `huni-goods-option-mapping.md §5.2`(GAP-SHAPE/COUNT/OPT) · round-5 `11_ddl_proposals`(비치수 size 선식별).
> 식별자/컬럼/코드 English, 설명 Korean.

---

## GAP 레지스터 (8건)

### GAP-PARAM — 공정 파라미터 보존 컬럼 부재 (= ref_param_json 미구현) 🔴 핵심

- **내용:** 같은 공정 1행을 파라미터로 재사용해야 하는데 보존처가 없다. 타공 `{구수:4/6/8}`, 오시/미싱 `{줄수:0~3}`, 가변 텍스트/이미지 `{개수:0~3}`, 박 `{크기:mm}`, 조각수 `{N}`. 라이브 `t_prd_product_option_items`엔 `qty`만 있고 설계의 `ref_param_json`(jsonb) **미구현**.
- **영향:** 미보존 시 타공 4/6/8을 **공정 3행으로 복제**(마스터 오염) 또는 `qty`에 구수 인코딩(의미 오용). 디지털인쇄 후가공·박·아크릴 조각수 전반.
- **라이브 권위:** cpq-schema §4 🔴8 (banner 7회·postcard 2회 인용된 설계가 라이브 미구현).
- **제안 후보(미확정):** `t_prd_product_option_items.ref_param_json jsonb` 컬럼 추가 vs `qty` 재사용(단일 정수 파라미터만 가능). 공정 `prcs_dtl_opt` 스키마와 짝.
- **금지:** `qty`에 다축 파라미터 smear 금지(구수≠qty).

### GAP-HIDDEN — hidden-essential(자동적용·미표시) 플래그 부재

- **내용:** RedPrinting ESN_YN=Y/VIEW_YN=N(필수이나 자동적용·미표시, 예 재단 CUT_DFT). 후니 `t_prd_product_option_groups`엔 `mand_yn`은 있으나 "auto-apply hidden" 구분 플래그 없음.
- **영향:** 필수 자동 후가공(재단 등)을 UI 노출 없이 주문에 자동 포함하는 동작을 표현 불가.
- **라이브 권위:** cascade-rules §5 (GSTGMIC pcsInfo: WRK_MTR/COT_DFT/PDT_WRK/PAK_POL 모두 VIEW_YN:N ESN_YN:Y 관찰).
- **제안 후보:** `t_prd_product_option_groups.auto_apply_yn`(또는 hidden_yn) 컬럼 vs option_items 레벨 플래그.

### GAP-OPT — 포장/각인/자유옵션 그릇 부재 (WowPress optioninfo 대응)

- **내용:** OPT_REF_DIM 7종에 "자유 텍스트/포장/구성" 차원 없음. 개별포장(전 시트 `개별포장(옵션)`), goods-pouch `선택(옵션)_선택`, 만년스탬프 잉크색팩 등 자유 가공/포장 옵션을 담을 정규 차원 부재.
- **영향:** WowPress `optioninfo`(쉬링크/수축포장·각인) 류를 후니 차원 어디에도 매핑 못 함.
- **라이브 권위:** huni-goods §5.2 GAP-OPT(신규 식별).
- **제안 후보:** ① 신규 OPT_REF_DIM 차원(.08 자유옵션) + 전용 테이블 vs ② `t_prd_product_bundle_qtys` 재사용(N개팩만) vs ③ optioninfo 전용 테이블.

### GAP-SHAPE — 비치수 형상/용량 siz 등록 시 width/height 부재

- **내용:** 형상(원형/하트/별 — 말랑키링), 용량(11온스 — 머그)을 `t_siz_sizes`에 siz로 등록 시 width/height가 없다(부피/형상은 직사각 치수 아님).
- **영향:** 굿즈 형상·용량 옵션. GAP-SHAPE 미해소 시 형상/용량을 siz로 못 올림 → 옵션화 불가.
- **라이브 권위:** round-5 `11_ddl_proposals` 'goods 비치수 size' 선식별.
- **제안 후보:** ① siz width/height NULL 허용(이미 nullable일 가능성 — 확인 필요) + siz_nm에 형상/용량 라벨 vs ② 형상 enum 컬럼 vs ③ 용량 전용 컬럼.
- **연계:** §5.2 ambiguous(용량=규격 vs 별 사양축)와 종속.

### GAP-COUNT — 개수형 공정의 개수 N 보존 (GAP-PARAM 굿즈 특수형)

- **내용:** 1구~4구(키캡키링), 칼선 N개(도무송) 등 개수형 공정의 N. GAP-PARAM의 굿즈 케이스 — 동일 메커니즘.
- **영향:** 키캡키링·LED투명키캡키링 구수.
- **라이브 권위:** huni-goods §5.2 GAP-COUNT (= cpq-schema §4 🔴8 동근원).
- **제안 후보:** **GAP-PARAM과 통합 처리**(ref_param_json `{구수:N}`) vs option_items.qty 재사용.

### GAP-COMPOSITE — 복합옵션 항목 간 관계(AND동반/계층종속) 표현 부재

- **내용:** 복합옵션의 item_seq 다행이 어떤 관계인지 모델에 없다 — 각목+끈(AND 동반필수), 박색상⊂박가공(계층종속, 박 없이 박색상 무의미). 현재는 "한 옵션의 모든 item은 동반"으로 암묵 가정.
- **영향:** 디지털인쇄 박/형압(계층), 면적형 각목+끈(동반).
- **라이브 권위:** banner §5.2(b)·postcard §5.2(c)(정정: 박=박가공+박색상[종속]+형압[별트리]).
- **제안 후보:** `t_prd_product_option_items.item_combine_typ`(AND동반/OR택일) 및/또는 `parent_item_seq`(계층종속) 컬럼.

### GAP-DEFER — 미적재 차원 옵션 등록 시 EXISTS 트리거 위반

- **내용:** "별도설정" 종이(엽서 material 0행), 미적재 공정(열재단 PROC_000053, 후가공 PROC_000029~032)을 option_item으로 등록하면 `fn_chk_opt_item_ref`가 "등록된 차원행만 참조" 강제 → 트리거 위반 → 등록 불가.
- **영향:** digital-print 종이=별도설정 다수, silsa 열재단, postcard 후가공 4종.
- **라이브 권위:** banner GAP-5(열재단 053)·postcard GAP-5(종이 전체 + 후가공 4종).
- **제안 후보:** ① 차원행 **선적재**(정석, FK-topo 순서) vs ② "별도설정"=deferred 센티넬(mat_cd=NULL 허용 + MES 단계 수기지정 + 트리거 EXISTS 면제 예외).
- **주의:** 이는 DDL이 아니라 **적재 순서/센티넬 규약** 결정 — dbm-load-builder와 공유.

### GAP-PANSU — 판수(사이즈별 판걸이)=가격축이나 차원 7종에 전용축 없음

- **내용:** 판수(73x98→15, 100x150→8…)는 사이즈마다 다르고 제작수량 증가단위(incr)와 결합. 차원 7종 어디에도 "판수" 전용축 없음 → size 행 부속속성(SIZ note 판걸이)으로만 존재.
- **영향:** digital-print 전반(수량=판수 배수 R-QTY-PANSU constraint로 우회 검증).
- **라이브 권위:** postcard §5.2(b).
- **판정:** **이미 결정 — size 부속속성**(가격엔진 입력). DDL 불요, 단 size 행 pansu 보존(컬럼 or note 구조화)은 가격엔진 트랙과 공유. **본 GAP은 정보용**(옵션 레이어 밖).

---

## 처리 우선순위 (dbm-ddl-proposer)

| 우선 | GAP | 사다리 후보(search-before-mint) | 차단도 |
|:----:|-----|--------------------------------|--------|
| **High** | GAP-PARAM (+GAP-COUNT) | 컬럼(ref_param_json jsonb) — 가장 광범위, 공정 재사용 핵심 | 후가공·박·구수 전반 차단 |
| **High** | GAP-DEFER | 적재순서/센티넬 규약(DDL 아님) — load-builder 공유 | 별도설정 종이·미적재 공정 차단 |
| Medium | GAP-SHAPE | siz width/height NULL 허용 확인 → 라벨 | 굿즈 형상·용량 |
| Medium | GAP-OPT | 사다리 신중(코드행→컬럼→테이블) | 포장·자유옵션 |
| Medium | GAP-COMPOSITE | 컬럼(item_combine_typ/parent_item_seq) | 박/형압·복합옵션 정합 |
| Low | GAP-HIDDEN | 컬럼(auto_apply_yn) | 자동 후가공 표현 |
| — | GAP-PANSU | 정보용(이미 결정·옵션 밖) | — |

> [HARD] 전 GAP **발명 금지**. 라이브 컨벤션 정합 최소 신규엔티티 제안만(코드행 < 컬럼 < JSONB < 테이블). DDL 직접 적용·COMMIT 금지(인간 승인).

---

## 파일럿 행사 기록 — 프리미엄엽서(PRD_000016) 옵션 레이어 (2026-06-07)

`postcard-option-layer.md` 적재본 파일럿이 실 행으로 행사/노출한 GAP. **라이브 스키마 실측(`_live-schema-dump-260606.txt`)으로 컬럼 부재 확정**(설계 문서 추정 아님).

| GAP | 파일럿 행사 양상 | 실측 근거 | 차단 영향 |
|-----|-----------------|-----------|-----------|
| **GAP-PARAM** 🔴 | 후가공 오시/미싱 `{줄수:0~3}`·가변텍스트/이미지 `{개수:0~3}` 4종. option_items 라이브 컬럼 = `prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn,...` — **`ref_param_json` 실부재 확정**. 파라미터 *스키마*는 `ref-processes.csv prcs_dtl_opt`에 실재(PROC_000029 `{"inputs":[{"key":"줄수","max":3,"min":0,...}]}`)하나 *선택값* 보존처 없음 | `_live-schema-dump` option_items 컬럼 실측 | 후가공 4종 환원 시 줄수/개수 소실(MES 트레이스 미완). qty smear 금지 |
| **GAP-DEFER** 🔴 | ① 종이=`*별도설정` → material **0행** ② 후가공 PROC_000029~032 → process **0행**. OP-JONGI-DEFAULT + OP-HUGA-* **5 option_item이 트리거 REJECT 예정 = BLOCKED** | ref-product-materials.csv(PRD_000016 부재) · ref-product-processes.csv(027/028만) | 9 option_items 중 5행 적재 불가(insertable 4/9). 차원 선적재 vs 센티넬 규약 D-2 결정 의존 |
| **`price` 미구현** 🟡 | 봉투 template 3종에 추가가격 보관처 없음 → `[CONFIRM 가격]`. **`t_prd_templates.price` 컬럼 실부재 확정**(워크스루는 price 컬럼 가정) | `_live-schema-dump` templates 컬럼 = `tmpl_cd,base_prd_cd,tmpl_nm,dflt_qty,use_yn,...`(price 없음) | 봉투 가격 가격엔진 t_prc_* 연계 필요(cpq-schema §4 🟡9) |
| **GAP-C**(마스터 정합) | SIZ_000104 명칭 "(10장)" vs template_selections.qty=50 충돌. siz 명칭 baked-in 장수 | ref-sizes.csv vs ref-product-addons.csv note | 비차단(마스터 정합 권고) |
| **GAP-B**(동적 freeze) | L1 row1 "엽서봉투 ★사이즈선택 : 100x150" = 본체연동 동적 addon. template 고정 freeze 미지원 | digital-print-l1.csv row1 col45 | 비차단(설계 한계 기록) |
| **GAP-COMPOSITE** | 박/형압 계층종속 — **L1 박 컬럼 전 공백이라 미인스턴스화**(발명 금지). 본 파일럿 미행사, 별색/박 보유 상품 필요 | digital-print-l1.csv col42~44 공백 | 본 파일럿 범위 밖 |
| **GAP-A**(진짜 max-N) | 후가공 max_sel_cnt=4=전체4 → 상한 무의미(위반 불가). '다중선택'만 행사, 진짜 max-N(전체>상한) 미실증 | postcard-walkthrough-validation GAP-A 승계 | 본 파일럿 범위 밖(박색상 16종 중 N 필요) |

> **파일럿이 추가로 라이브 실측 확정한 것:** ① `ref_param_json` 컬럼 실부재(GAP-PARAM = 설계 추정 → **실측 확정**). ② `templates.price` 컬럼 실부재(🟡9 = 설계 추정 → **실측 확정**). ③ option_items 트리거가 **행단위 REJECT** → BLOCKED 5행이 적재 차단(GAP-DEFER 차단도 = 실 행 5/9). 둘 다 dbm-ddl-proposer 입력 확정 강화(추정→실측).
</content>
