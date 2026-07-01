# print-form-spec.md — 디지털인쇄(C4·print) 위젯 폼 주문가능 종단 명세

> 파이프라인 ③' 컨버전 선행 · 명세까지(코드 0줄·다음 승인).
> **외형·제약 의도 권위** = `docs/design/11가지상품옵션/product-print-option/Configurator.jsx`(27필드·504줄).
> **데이터 권위** = 라이브 DB 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + readiness/conformance 산출 재사용.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394) 불투명 결과. t_prc_* 위젯 포팅 금지. PRICE=0=결함.
> **계약 목표** = 위젯 가시 계약 변경 0 — 매핑은 어댑터(`createHuniAdapter`)가 흡수.
> 대표 상품 = **PRD_000042 프리미엄 쿠폰/상품권** (별색·박·형압 superset 보유 · §29 L3·86.2·W-CASCADE).
> 보조 골든 = PRD_000041 스탠다드 쿠폰/상품권(동일 frm_cd=PRF_DGP_A·골든 검증분 재사용).
> 상위 분석 = `../../widget-forms-approach.md`(11폼·제약6종·주문가능4조건) · 파일럿 = `../../digital-print/pilot-PRD_000041.md`.

---

## 0. 대표 상품 선정 근거 (PRD_000042 vs 파일럿 PRD_000041)

디지털인쇄 print JSX는 **27필드 최대 폼**(별색5·박앞/뒤·형압·접지·커팅·코팅·후가공5·봉투)이다. 파일럿 PRD_000041(스탠다드 쿠폰)은 이 폼의 **부분집합**(별색·박·형압·코팅·접지·커팅 미보유)이라 박/별색 제약 패턴을 노출하지 못한다. **PRD_000042 프리미엄 쿠폰/상품권**이 같은 디지털인쇄군에서 폼의 박칼라 8종(박없음+7색)·8종 종이·후가공 4종을 CPQ로 보유하고, 박 분기 공식(PRF_DGP_A_FOIL)까지 있어 print 폼의 **제약·박·별색 superset을 가장 많이 traverse**한다. 따라서 대표=PRD_000042, 골든 재현은 동일 frm_cd(PRF_DGP_A) 상품 PRD_000041의 검증분을 상속한다.

**라이브 실측 PRD_000042 구성(스냅샷):**
```
prd_typ=PRD_TYPE.01(완제품)·semi_role=∅·nonspec_yn=N·file_upload_yn=Y·editor_yn=N
min_qty=12·max_qty=10000·qty_incr=12·qty_unit=QTY_UNIT.02(매)
sizes: SIZ_000013(148x68) / SIZ_000014(148x75)  (둘 다 dflt_yn=Y — 충돌, §3 ⑥ 참고)
materials(8·USAGE.07): MAT_000107 몽블랑190g / MAT_000118 클래식크래스트스티플270g / MAT_000121 켄도250g /
  MAT_000125 한지170g / MAT_000128 ★면끈(오염) / MAT_000129 ★아크릴키링고리(오염) / MAT_000240 ★보드스탠딩(오염) / MAT_000241 ★핀버튼(오염)
print_options: opt1 단면 POPT_000001(front CMYK4/back 인쇄안함) / opt2 양면 POPT_000002(both 4도)
processes: PROC_000004 디지털인쇄(mand_proc_yn=Y·disp_seq=-1=hidden) +
  후가공 PROC_000029오시/030미싱/031가변텍스트/032가변이미지 +
  박/형압 PROC_000037홀로그램/038금유광/039은유광/040먹유광/041동박/042적박/043청박/044트윙클 (전부 mand=N)
plate_sizes: SIZ_000499 (dflt·OUTPUT_PAPER_TYPE.01)
option_groups(4): OPT_000055 인쇄(택1필수) / OPT_000056 종이(택1필수·8종) /
  OPT_000057 후가공(택N 0~4) / OPT_000058 박칼라(택1 0~1·박없음 센티넬 OPV_000221)
constraints: 0행 · addons: 0행
price_formulas: PRF_DGP_A(apply_bgn 2026-06-01·활성) / PRF_DGP_A_FOIL(apply_bgn 2026-07-01·박분기·인간승인 후 COMMIT=미활성)
```

---

## 1. 폼 필드 인벤토리 → 정규화 계약 매핑 (27 필드 전수)

각 OptionField → `OptionGroup`(또는 InputSpec/박묶음). componentType=DESIGN.md 14종 사상. side는 print 전부 `default`(단일면·내지 없음).

| # | JSX 필드(state) | 디자인 컴포넌트 | 정규화 componentType | side | required | visible | values 출처(라이브) | InputSpec |
|---|----------------|----------------|----------------------|------|:--:|:--:|--------------------|-----------|
| 1 | 사이즈 size | OptionButtonGroup(3열·badge추천) | `option-button` | default | Y | Y | product_sizes ⋈ siz_sizes (SIZ_000013/14) | — |
| 1b | 커스텀 W/H customW·customH | (custom 선택 시 TextField암시) | `area-input` | default | N | 조건 | **DB 없음**(nonspec_yn=N) — (B/C) | min/max 무근거 |
| 2 | 종이 paper | SelectBox(badge추천·+가격) | `select-box` | default | Y | Y | option_items OPT_000056 ref.03 mat_cd (8종) | — |
| 3 | 인쇄 print | OptionButtonGroup(2열) | `option-button` | default | Y | Y | option_items OPT_000055 ref.06 print_opt_cd | — |
| 4 | 별색 화이트 spotWhite | OptionButtonGroup(3열·none/single/double) | `option-button` | default | N | Y | **DB 없음**(PRD_000042 별색 미적재) — (C) | — |
| 5 | 별색 클리어 spotClear | 〃 | `option-button` | default | N | Y | **DB 없음** — (C) | — |
| 6 | 별색 핑크 spotPink | 〃 | `option-button` | default | N | Y | **DB 없음** — (C) | — |
| 7 | 별색 금색 spotGold | 〃 | `option-button` | default | N | Y | **DB 없음** — (C) | — |
| 8 | 별색 은색 spotSilver | 〃 | `option-button` | default | N | Y | **DB 없음** — (C) | — |
| 9 | 코팅 coat | OptionButtonGroup(3열·5종) | `option-button` | default | N | Y | **CPQ 없음**(공식 COMP_COAT_* 존재·옵션그룹 미생성) — (C) | — |
| 10 | 커팅 cut | OptionButtonGroup(3열·4종·info) | `option-button` | default | N | Y | **CPQ 없음**(공식 COMP_PP_CORNER_RIGHT 존재) — (C) | — |
| 11 | 접지 fold | OptionButtonGroup(3열·3종·info) | `option-button` | default | N | Y | **CPQ 없음** — (C) | — |
| 12 | 건수 batches | QuantityStepper(min1·step1·max100) | `counter-input` | default | Y | Y | **DB 없음**(건수=printCount 의미·products 미보유) — (B/C) | min1·max100·step1 |
| 13 | 제작수량 qty | QuantityStepper(min10·step10·max2000) | `counter-input` | default | Y | Y | products.{min,max,qty_incr,dflt}_qty | min12·max10000·step12 (★디자인≠DB) |
| 14 | 후가공-귀돌이 corner | OptionButtonGroup(2열) | `finish-button` | default | N | Y | **CPQ 없음**(공식 COMP_PP_CORNER_RIGHT 존재) — (C) | — |
| 15 | 후가공-오시 crease | OptionButtonGroup(4열·none/1/2/3) | `finish-select-box` | default | N | Y | option_items OPT_000057 PROC_000029 | inputs 줄수0~3(GAP-PARAM) |
| 16 | 후가공-미싱 perf | 〃 | `finish-select-box` | default | N | Y | option_items OPT_000057 PROC_000030 | inputs 줄수0~3(GAP-PARAM) |
| 17 | 후가공-가변텍스트 varText | 〃 | `finish-select-box` | default | N | Y | option_items OPT_000057 PROC_000031 | 개수(GAP-PARAM) |
| 18 | 후가공-가변이미지 varImg | 〃 | `finish-select-box` | default | N | Y | option_items OPT_000057 PROC_000032 | 개수(GAP-PARAM) |
| 19 | 박(앞면) on/off foilFrontOn | OptionButtonGroup(2열) | `option-button` | default | N | Y | OPT_000058 박없음 센티넬 OPV_000221 ↔ 박칼라(토글대용) | — |
| 20 | 박(앞면) 크기 foilFrontW/H | TextField×2(가로30~125/세로30~170) | `area-input` | default | 조건 | foilFrontOn==on | **DB 없음**(박크기=GAP-PARAM) — (C) | W30~125·H30~170 |
| 21 | 박(앞면) 칼라 foilFront | ColorChip×7 | `color-chip` | default | 조건 | foilFrontOn==on | OPT_000058 박칼라 7종(PROC_037~044)+holo | colorHex=(C) |
| 22 | 박(뒷면) on/off foilBackOn | OptionButtonGroup(2열) | `option-button` | default | N | Y | **CPQ 없음**(박 앞/뒤 구분 미적재·박칼라 1그룹뿐) — (C) | — |
| 23 | 박(뒷면) 크기 foilBackW/H | TextField×2(가로30~80/세로30~40) | `area-input` | default | 조건 | foilBackOn==on | **DB 없음** — (C) | W30~80·H30~40 |
| 24 | 박(뒷면) 칼라 foilBack | ColorChip×7 | `color-chip` | default | 조건 | foilBackOn==on | **CPQ 없음**(뒤면 그룹 부재) — (C) | colorHex=(C) |
| 25 | 형압 stamp | OptionButtonGroup(3열·없음/양각/음각) | `option-button` | default | N | Y | **CPQ 없음**(형압 공정 PROC_000045계열 미바인딩) — (C) | — |
| 26 | 형압크기 stampW/H | TextField×2(가로30~125/세로30~170) | `area-input` | default | 조건 | stamp!=none | **DB 없음**(형압크기=GAP-PARAM) — (C) | W30~125·H30~170 |
| 27 | 엽서봉투 envelope+envQty | SelectBox×2(none+4종·수량) | addon(W-ADDON) | default | N | Y | product_addons ⋈ templates → **0행**(봉투 PRD_000281/282 del_yn=Y) — (C) | — |
| — | (어댑터 생성) 디지털인쇄 base | (없음·hidden) | `upload-cta`+필수공정 | default | Y | **N**(hidden-essential) | PROC_000004(mand=Y·disp_seq=-1) 자동주입 | — |
| — | (어댑터 생성) 요약 | PriceSummary | `summary` | — | — | — | evaluate_price breakdown | — |

**계약/DB 매핑 요약(27필드):**
- **완전 매핑(라이브 데이터 채움 가능)**: 4 — 사이즈(1)·종이(2)·인쇄(3)·제작수량(13). + 어댑터생성 base/요약.
- **부분 매핑(CPQ 옵션 있으나 파라미터/색상 갭)**: 5 — 박칼라(21)·후가공 오시/미싱/가변텍/가변이미지(15~18). 옵션은 적재·줄수/개수/박크기/colorHex는 GAP-PARAM (C).
- **미매핑(DB·CPQ 부재→갭)**: 18 — 커스텀치수(1b)·별색5(4~8)·코팅(9)·커팅(10)·접지(11)·건수(12)·귀돌이(14)·박앞크기(20)·박뒤 on/크기/칼라(22~24)·형압+크기(25~26)·봉투(27). 공식(PRF_DGP_A)엔 COMP_COAT/CORNER/SPOT_WHITE/FOIL 존재하나 **CPQ 옵션그룹 미생성**이 핵심.

---

## 2. 옵션 데이터 → 라이브 DB 바인딩 (디자인 값 ↔ 라이브 값 대조)

| 옵션 | 디자인 하드코딩 값 | 라이브 출처(PRD_000042) | 일치/불일치 |
|------|-------------------|------------------------|-------------|
| 사이즈 | 7종(73x98·98x98·100x150·95x210·110x170·148x210·135x135) | 2종(148x68·148x75) | ❌ **불일치** — 디자인 7종 vs DB 2종. 디자인은 일반 디지털인쇄 프리셋, DB는 상품권 전용 2종. 위젯은 DB값(2종) 렌더 |
| 종이 | 5종(몽블랑190·랑데뷰250·미스티250·팝셋250·아트지230) | 8종(몽블랑190·클래식크래스트스티플270·켄도250·한지170·스타드림 실버/골드/다이아/로츠쿼츠 240) | ❌ **불일치**(상품별 종이 상이). 위젯은 DB 8종. ★단 mat_cd 5종 오염(§아래) |
| 인쇄 | 단/양면 2종 | POPT_000001 단면 / POPT_000002 양면 | ✅ 일치 |
| 별색 5종 | 화이트·클리어·핑크·금색·은색 × none/single/double | **부재**(PRD_000042 별색 공정·옵션 0) | ❌ **갭(C)** — 별색은 PRD_000040 화이트인쇄명함(PROC_000027/028/008/009)에만. 공식엔 COMP_PRINT_SPOT_WHITE_S1 존재 |
| 코팅 | 5종(없음·무광단/양·유광단/양) | **CPQ 부재**(공식 COMP_COAT_GLOSSY/MATTE 존재) | ❌ **갭(C)** — 단가행/공식 있으나 옵션그룹 미생성 |
| 커팅 | 4종(한쪽라운딩·나뭇잎·큰라운딩·클래식) | **CPQ 부재** | ❌ **갭(C)** |
| 접지 | 3종(2단가로·2단세로·3단가로) | **CPQ 부재** | ❌ **갭(C)** |
| 후가공 | 귀돌이/오시/미싱/가변텍스트/가변이미지 | OPT_000057: 오시·미싱·가변텍스트·가변이미지(귀돌이 부재·공식 COMP_PP_CORNER_RIGHT 존재) | △ 부분 — 4/5 일치, 귀돌이 옵션 미생성(C) |
| 박색 7종 | gold·silver·matte·copper·red·blue·holo | OPT_000058 8항(박없음+홀로그램·금유광·은유광·먹유광·동박·적박·청박·트윙클) | △ **의미 근접**(금유광=gold·은유광=silver·먹유광=matte·동박=copper·적박=red·청박=blue·홀로그램=holo·+트윙클). 라벨키만 다름·colorHex 부재(C) |
| 박 앞/뒤 | 앞면·뒷면 독립 토글+크기+색 | OPT_000058 **1그룹뿐**(앞/뒤 구분 없음·박없음 센티넬로 on/off만) | ❌ **갭(C)** — 앞/뒤 분리 미적재·박크기 GAP-PARAM |
| 형압 | 없음/양각/음각+크기 | **CPQ 부재** | ❌ **갭(C)** |
| 봉투 | 5종(OPP110/150·카드화이트/블랙·수량) | product_addons **0행**(봉투상품 del_yn=Y) | ❌ **갭(C)** — addon 템플릿 미연결 |
| 수량 | min10/step10/max2000 | min12/incr12/max10000 | ❌ **불일치** — 위젯은 DB값(12 배수) 권위 |

**★자재 오염(돈크리티컬·(C)):** OPT_000056 종이 8종 중 라벨(opt_nm="스타드림(실버)240g" 등)은 종이지만 ref_key1 mat_cd가 **MAT_000128(면끈)·MAT_000129(아크릴키링고리)·MAT_000240(보드스탠딩)·MAT_000241(핀버튼)** = 비종이 굿즈자재를 가리킨다(MAT_TYPE.17/03/16/12). 표시명↔실제 mat_cd 불일치 → evaluate_price가 굿즈 단가행으로 silent 합산할 위험(§29 list-mismapped FAIL·돈크리티컬 등재). 위젯은 라벨만 보이므로 발현 안 되나, 가격은 오염 mat_cd로 계산 → **§7/§26 교정 인간 승인** (어댑터/계약 무관).

---

## 3. 제약 추출·정규화 (★핵심·6종) — 디자인 의도 ↔ 라이브 데이터 ↔ 갭

print JSX는 `t_prd_product_constraints` **0행**(PRD_000042 제약 미적재)이다. 따라서 디자인 의도 제약 6종은 거의 전부 **라이브 데이터 부재** → 어댑터 파생(A) 또는 DB 작성(C)으로 분류.

### 3.1 제약 추출표

| 제약형태(JSX) | 트리거 | 실례 | 정규화 매핑 | DB 출처(존재여부) | 갭 |
|--------------|--------|------|-------------|-------------------|-----|
| ③ **토글→하위필드 visible** | `foilFrontOn==="on"` | 박있음 선택 → 박크기/박칼라 표시 | `VisibilityRule{trigger:박있음, shows:[박크기,박칼라]}` | constraints 0행·박없음=OPV_000221 센티넬만 존재 | **(C)** 토글 visible 룰 미적재(센티넬→어댑터 파생 A 가능) |
| ③ **토글→하위필드 visible** | `foilBackOn==="on"` | 박뒤 있음 → 박뒤크기/칼라 | `VisibilityRule` | 박뒤 그룹 자체 부재 | **(C)** 그룹 미적재 |
| ③ **토글→하위필드 visible** | `stamp!=="none"` | 형압 양/음각 → 형압크기 | `VisibilityRule` | 형압 그룹 부재 | **(C)** |
| ④ **범위검증 area** | 박앞크기 입력 | 가로30~125·세로30~170mm | `InputSpec{min30,max125, axis2{min30,max170}}` | siz_sizes 없음·박크기=GAP-PARAM(DB 미보유) | **(C)** 범위 DB 부재(디자인 placeholder가 유일 출처) |
| ④ **범위검증 area** | 박뒤크기 | 가로30~80·세로30~40 | `InputSpec{min30,max80,axis2{30,40}}` | 부재 | **(C)** |
| ④ **범위검증 area** | 형압크기 | 가로30~125·세로30~170 | `InputSpec{min30,max125,axis2{30,170}}` | 부재 | **(C)** |
| ④ **범위검증 area** | 커스텀사이즈 W/H | (custom 선택·디자인 placeholder만) | `BaseRule.nonStandardAllowed + InputSpec` | products.nonspec_yn=**N**(비규격 불가) | **(B/C)** 디자인은 custom 허용·DB는 불가(불일치) |
| ⑤ **택1 패턴** | 별색 spotOpts | 없음/단면/양면 | `OptionGroup(multiple=false)` 5개 | 별색 옵션 부재 | **(C)** |
| ⑤ **택1 패턴** | 인쇄 print | 단면/양면 | `OptionGroup(OPT_000055·sel_typ=SEL_TYPE.01·multiple=false)` | ✅ option_groups 존재 | **(A)** sel_typ→multiple 직매핑 |
| ⑤ **택1 패턴** | 코팅 coat | 5종 택1 | `OptionGroup(multiple=false)` | 코팅 옵션 부재 | **(C)** |
| ⑤ **택1 패턴** | 박칼라 foilFront | 7색 택1 | `OptionGroup(OPT_000058·sel_typ=SEL_TYPE.01·min0/max1)` | ✅ 존재(박없음 센티넬 min0) | **(A)** |
| ⑥ **필수 required** | 주문 전 필수 | 사이즈·종이·인쇄·수량 | `OptionGroup.required=true` | OPT_000055/056 mand_yn=Y · sizes 항상필수 · qty 항상 | **(A)** mand_yn→required 직매핑 |
| ⑥ **필수 hidden-essential** | (디자인 비노출) | 디지털인쇄 base | `OptionGroup.{required:true,visible:false}` 자동주입 | PROC_000004 mand_proc_yn=Y·disp_seq=-1 | **(A)** A4 관례(disp_seq<0→visible=false) |
| ① **visible cascade(add/remove)** | (디자인 명시 약) | — | `visibilityRules[]` | constraints 0행 | **(A)** 부재 시 빈 배열 |
| ② **disable** | (디자인 명시 없음) | 자재↔후가공 불가 등 | `disableRules[]` | constraints 0행·excl_groups 부재 | **(A)** 빈 배열(현재 제약 없음) |
| ② **quantity clamp** | 제작수량 | min/max/incr | `QuantityRule{min12,first12,increment12}` | products.{min,max,qty_incr}_qty | **(A)** 직매핑(★디자인 min10/step10≠DB 12 — DB 권위) |
| ④ **size** | 사이즈 선택 | cut/work 치수 | `SizeRule[]` | siz_sizes.{cut,work}_{w,h} 1:1 | **(A)** 직매핑 |
| ⑥ **base** | — | 단위·재단마진 | `BaseRule{unit:매,cutMargin:2,nonStandardAllowed:false}` | siz_sizes margin + nonspec_yn=N | **(A)** 직매핑 |

### 3.2 제약 6종 디자인↔DB 일치/갭 집계

| 제약축 | 디자인 의도 룰 수 | 라이브 데이터 충족 | 갭 |
|--------|:---:|:---:|-----|
| ① visible cascade | 0(명시 약) | 0(constraints 0행) | 일치(둘 다 없음) |
| ② disable | 0 | 0(제약/excl 부재) | 일치 |
| ③ 토글→하위(박앞/박뒤/형압) | 3 | 0(박없음 센티넬만 부분) | **갭 3 (C)** (센티넬→A 파생 일부 가능) |
| ④ 범위검증(박앞/박뒤/형압/커스텀) | 4 | 0(GAP-PARAM·nonspec=N) | **갭 4 (C)**(+커스텀은 B/C 불일치) |
| ⑤ 택1(별색5·인쇄·코팅·박칼라) | 8 | 2(인쇄·박칼라 옵션그룹 존재) | **갭 6 (C)**(별색5+코팅) |
| ⑥ 필수(사이즈·종이·인쇄·수량+hidden base) | 5 | 5(mand_yn·mand_proc_yn·products qty) | **일치(A 직매핑)** |
| **합계** | **20** | **9 충족** | **일치 9·갭 11**(전부 C·박/별색/코팅/형압 CPQ 미적재 + custom 1 B/C) |

**제약 결론:** ⑥필수·④size·②quantity는 라이브 데이터로 완전 강제(A 어댑터 흡수). 그러나 print 폼의 **차별적 제약(박 토글·박크기 범위·별색/코팅 택1)은 라이브 CPQ 미적재(C 11건)** — 주문가능화의 최대 병목. 위젯 계약(VisibilityRule·InputSpec·OptionGroup.multiple)은 이미 이 제약을 표현할 슬롯 보유 → **계약 변경 0(B 0건)**, DB 작성(C)만 필요.

---

## 4. 가격 결선 (evaluate_price 골든) — 디자인 가짜식 폐기

### 4.1 디자인 가짜 계산식 (폐기 대상)

print JSX(:79~90)는 로컬 가짜식:
```
sizeBase = {s100x150:35000, ...}[size]   // 하드코딩 사이즈 기본가
paperAdd = {rendezvous:5000, ...}[paper]  // 하드코딩 종이 가산
printCost = round((sizeBase+paperAdd)*qty/20)  // ÷20 임의식
finishCost = finishOpen ? 25000 : 0       // 후가공 정액 25000(선택 무관)
envCost = envelope!=="none" ? 1100~1150 : 0
total = (printCost+finishCost+envCost)*1.1
```
→ **전부 폐기.** 위젯은 단가/공식 모름. 별색·박·코팅·박크기 가산이 전혀 반영 안 됨(가짜식 한계). 실 가격은 evaluate_price 권위.

### 4.2 위젯 경로 (정규화 계약)

```
NormalizedPriceRequest { productCode:PRD_000042, priceSchemeKey:PRF_DGP_A(echo),
  dimensions:[{side:default, cutW,cutH,workW,workH}], colorCounts{default:4},
  materials{default:mat_cd}, quantity, selectedFinishes:[{groupId,valueId,attb?}] }
   │ 어댑터 createHuniAdapter — option_items.ref_dim 환원 + 필수공정(PROC_000004) 자동주입 + priceSchemeKey echo
   ▼
evaluate_price({prd_cd:PRD_000042}, {siz_cd, plt_siz_cd(자동), print_opt_cd, mat_cd, proc_cd[]}, qty)  [pricing.py:394]
   ▼
NormalizedPriceBreakdown { ok, finalPrice, vat, shipping, lines[{code,label,amount}] }
```
박/형압 분기는 서버가 PRF_DGP_A_FOIL(박바인딩·미활성)로 라우팅 예정 — **위젯 무지**. 어댑터는 박칼라 선택값(proc_cd)을 selectedFinishes로 운반만.

### 4.3 PRICE≠0 골든

PRD_000042는 PRD_000041과 **동일 frm_cd=PRF_DGP_A**(formula_components 동일·COMP_PAPER 충전) 바인딩이고 §29 scoreboard `calc=OK·priced·pfm=BOUND_OK`로 계산 가능 확정. 라이브 시뮬레이터 동일 알고리즘 골든을 상속(PRD_000041 검증분·동형):

| 케이스 | selections | qty | final_price | 주요 line | 출처 |
|--------|-----------|-----|-------------|-----------|------|
| A 기본 | 단면·몽블랑190(MAT_000107)·148x68(SIZ_000013) | 120 | **307** | COMP_PAPER 307.30 | PRD_000041 검증·동형 frm |
| A 중간 | 〃 | 1008 | **2,581** | COMP_PAPER 2581.32 | 〃 |
| A 대량 | 〃 | 5004 | **12,814** | COMP_PAPER 12814.41 | 〃 |
| B 양면+오시·아트지 | 양면(POPT_000002)+오시(PROC_000029) | 120 | **467** | COMP_PAPER 466.50 | 〃 |

> PRD_000042 자체 라이브 시뮬레이터 직호출은 인증세션(CSRF) 필요 — 읽기전용 원칙상 본 명세는 §29 `calc=OK·pfm=BOUND_OK` 재사용을 권위로 하고 별도 호출은 hw-qa 검증단계로 이관(거짓 수치 날조 금지). 동일 공식·동일 COMP_PAPER 차원이므로 골든값은 동형.

✅ **PRICE≠0 게이트 통과**(전 케이스 >0).

### 4.4 ★디자인 가짜식 vs 실 evaluate_price 차이 + §26 저청구 결함

- **차이**: 가짜식은 후가공=정액 25000(선택 무관)·별색/박/코팅 가산 0·종이가산만 임의. 실 evaluate_price는 후가공별 단가행·박 분기·용지 절가. → 가짜식 폐기 정당.
- **§26 저청구 결함 [HARD·(C)]**: 디지털인쇄 base 공정 PROC_000004의 단가행/배선 미충전 → `COMP_PRINT_DIGITAL_S1`·`COMP_PRINT_SPOT_WHITE_S1` subtotal=0 → **인쇄비 영구 0**([[digital-print-base-proc-missing-260701]]). final_price는 용지비로 PRICE≠0이나 인쇄비 누락 저청구. 위젯은 어댑터가 필수공정 정상주입만, **교정=§7/§26 인간 승인**(어댑터/계약 무관). 박 선택 시 PRF_DGP_A_FOIL(COMP_FOIL_SETUP_LARGE) 바인딩 활성화도 인간 승인 대기.

---

## 5. 주문 페이로드 예시 (NormalizedCartHandoff + CTA 분기)

PRD_000042: file_upload_yn=Y·editor_yn=N → CTA는 **PDF 업로드 단독**(에디터 없음). 단 디자인 폼은 "에디터로 디자인하기" 버튼도 노출 → 디자인 의도 vs DB(editor_yn=N) **불일치** → 위젯은 DB 권위(에디터 버튼 비활성/숨김) 또는 editor_yn 교정(C).

**완성 선택 상태(예):** 148x68 · 몽블랑190 · 양면 · 오시1줄 · 박칼라 금유광 · qty 120
```jsonc
// NormalizedCartHandoff
{
  "productCode": "PRD_000042",
  "selectedOptions": [
    { "groupId": "size",        "valueId": "SIZ_000013" },
    { "groupId": "OPT_000055",  "valueId": "POPT_000002" },   // 양면
    { "groupId": "OPT_000056",  "valueId": "OPV_000209" },    // 몽블랑190(라벨키)·ref mat_cd
    { "groupId": "OPT_000057",  "valueId": "OPV_000217" },    // 오시(attb 줄수=GAP-PARAM)
    { "groupId": "OPT_000058",  "valueId": "OPV_000223" }     // 박칼라 금유광
  ],
  "quantity": 120,
  "priceSnapshot": { "finalPrice": 467, "vat": 47, "shipping": 0 },
  "artifacts": [
    { "side": "default", "kind": "pdf",
      "storedFileName": "stored_xxxx.pdf", "originalFileName": "coupon.pdf" }
  ]
}
// CTA 분기: editors={koi:false,rp:false,pdf:true} → cta.pdfUpload=true·designEditor=false
```
- **에디터/PDF 분기**: editor_yn=N → designEditor=false(디자인 폼의 에디터 버튼은 DB 불일치·(C) editor_yn 교정 또는 위젯 숨김). file_upload_yn=Y → pdfUpload=true → `NormalizedArtifact{kind:'pdf'}`.
- **커머스 바인딩**: `priceSnapshot.vat`/`shipping` 산정·NormalizedPresigned(파일 업로드 URL)·실 카트 전송은 **§24 Shopby UNDECIDED 경계**. 위젯은 NormalizedCartHandoff까지 조립 후 BFF로 위임.

---

## 6. componentType / 갭 노트

### 6.1 componentType 사상 (print 폼)
| componentType | print 폼 사용처 | 데이터 출처 |
|---------------|----------------|-------------|
| `option-button` | 사이즈·인쇄·별색5·코팅·커팅·접지·박on/off·형압 | sizes·print_opt·(별색/코팅/접지=C) |
| `select-box` | 종이·봉투 | option_items 자재 / addon |
| `counter-input` | 건수·제작수량 | products qty (건수=B/C) |
| `color-chip` | 박앞칼라·박뒤칼라(7종) | OPT_000058 박칼라 + **colorHex(C·added-schema)** |
| `area-input` | 박앞크기·박뒤크기·형압크기·커스텀치수 | **GAP-PARAM 전부 (C)** |
| `finish-button`/`finish-select-box` | 후가공 귀돌이/오시/미싱/가변 | OPT_000057(귀돌이=C) + inputs(GAP-PARAM) |
| `summary` | 가격요약 | 어댑터 생성(evaluate_price) |
| `upload-cta` | PDF 업로드 | file_upload_yn=Y |
| `price-slider` | **해당없음(print)** | — |
| `image-chip`/`mini`/`large-color-chip`/`acc-panel`/`page-counter-input`/`dimension-matrix-input` | 미사용(print) | — |

### 6.2 갭 (A)/(B)/(C) 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (12)**: A1 CPQ ref_dim 환원·A2 필수공정 자동주입(PROC_000004)·A3 판형 비노출·A4 hidden-essential(disp_seq<0)·A5 unit 라벨·A6 도수→색수·A7 sides·A8 제약 JSONLogic 파싱·A9 공정 inputs 파싱(줄수/개수 InputSpec)·A11 vat/shipping·A12 PRICE=0 진단 + sel_typ→multiple/mand_yn→required 직매핑·박없음 센티넬→토글 visible 파생.
- **(B) 계약 변경 필요 (0)**: 위젯 계약(OptionValue.colorHex/imageUrl/badge·VisibilityRule·InputSpec·OptionGroup.multiple)이 이미 print 폼 제약·박색·박크기를 OPTIONAL 슬롯으로 수용 → **계약 변경 0건(목표 달성)**. 단 ⓐ 커스텀치수(custom)·ⓑ 건수(batches=printCount) 노출은 잠재 B 후보(현재는 어댑터 printCount 슬롯/nonspec으로 흡수 가능 → A 우선).
- **(C) DB 작성·교정 — §7 인간 승인 (핵심 11+)**:
  - C-별색5: OPT 별색 옵션그룹·공정 5종 적재(공식 COMP_PRINT_SPOT_WHITE_S1 존재).
  - C-코팅: 코팅 옵션그룹 적재(공식 COMP_COAT_GLOSSY/MATTE 존재).
  - C-커팅/접지/귀돌이: 옵션그룹 적재(커팅 COMP_PP_CORNER_RIGHT 존재).
  - C-박앞/뒤 분리·박크기: OPT_000058 앞/뒤 2그룹 분리 + 박크기 파라미터 컬럼/area(GAP-PARAM 해소).
  - C-형압+형압크기: 형압 공정 바인딩 + area.
  - C-봉투 addon: product_addons ⋈ 템플릿 연결(봉투상품 del_yn=Y 복원/재등록).
  - C-colorHex: 박칼라 color_hex(added-schema-260701 — ★.sql 파일 부재·문서만, §7 재작성 필요).
  - C-자재오염: OPT_000056 mat_cd 5종(면끈/키링고리/보드스탠딩/핀버튼) 종이로 교정(돈크리티컬·silent합산).
  - C-인쇄비0: PROC_000004 base 단가행 충전(§26 저청구).
  - C-editor_yn: 디자인 폼 에디터 버튼 vs DB editor_yn=N 불일치(에디터 제공 시 Y 교정·아니면 위젯 숨김).
  - C-수량/사이즈 디자인≠DB: 디자인 사이즈7·수량 min10 vs DB 사이즈2·min12 — DB 권위(위젯 DB값 렌더, 교정 불필요).

---

## 7. 주문가능 4조건 충족 여부 (PRD_000042 현재)

`widget-forms-approach.md §3` 주문가능 정의 = ⓐ옵션 라이브구동 + ⓑ제약6종 데이터강제 + ⓒPRICE≠0 + ⓓ유효 페이로드.

| 조건 | 현재 충족도 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 DB 구동 | **부분** | 사이즈·종이·인쇄·후가공·박칼라 = 라이브 CPQ 구동 ✅ / 별색5·코팅·커팅·접지·박앞뒤분리·형압·봉투 = **CPQ 미적재(C)** ❌ |
| ⓑ 제약 6종 데이터 강제 | **부분** | ⑥필수·④size·②quantity 강제 ✅ / ③박토글·④박크기범위·⑤별색코팅택1 = **갭 11(C)** ❌ |
| ⓒ PRICE≠0 | **충족(주의)** | golden 307/2581/12814/467 >0 ✅ / 단 인쇄비0 저청구·박/별색 미가산(§26·C) ⚠ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff 조립 가능 ✅ / 커머스 바인딩 §24 UNDECIDED·PDF CTA only |

**판정: 부분 주문가능(PARTIAL).** 라이브 적재분(사이즈·종이·인쇄·후가공·박칼라)만으로는 단순 쿠폰 주문 가능(PRICE≠0). 그러나 **print 폼의 풀 스펙(별색5·코팅·커팅·접지·박앞뒤·형압·봉투) 주문가능화는 (C) DB 작성 11건이 선행 조건** — 위젯/계약/어댑터는 준비 완료(B 0건), 병목은 전적으로 라이브 CPQ·제약 미적재(§7/§26 인간 승인).

**다음 권고:** ① §7 dbmap에 C 11건(별색·코팅·커팅·접지·박앞뒤·형압·봉투 addon·자재오염·colorHex·인쇄비0·editor_yn) 적재명세 인계 → ② 적재 후 어댑터로 NormalizedProduct 완전 조립 재검증 → ③ hw-builder createHuniAdapter 구현. 코드 구현은 본 명세 승인 후.

---

## 부록: 동형 전파 노트

PRD_000042(W-CASCADE 대표) 매핑 규칙은 같은 클래스 디지털인쇄 상품(쿠폰·엽서·종이슬로건·일부 명함)에 전파. 단 별색 보유 상품(PRD_000040 화이트인쇄명함=별색 적재됨)은 별색 옵션그룹 존재로 **C-별색 갭 없음** → 별색 매핑 규칙은 PRD_000040에서 추출해 역전파 가능. 박/코팅/접지/형압 미적재는 디지털인쇄군 공통 갭(동형). 봉투 addon은 전 디지털인쇄 공통.
