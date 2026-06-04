# 데이터 불일치 599건 × round-2 가격매핑 영향 교차분석

후니 "데이터 불일치 뷰어"(`product-viewer`) 전수 스캔 **599 findings**(4 dim · 10 rule)를 round-2 가격엔진(`t_prc_*`/`t_prd_*`) 매핑 영향과 기존 어색데이터 목록(AWK-1~9)에 교차한 분석. 권위=`dbm-price-formula` 규칙1~9 + `price-engine-ddl.md` + `price-awkward-data.md`. 식별자/컬럼/코드는 영어, 해석은 한국어.

> 핵심: 599건은 우리가 파일럿에서 손으로 발견한 AWK 항목의 **모집단(superset)**이다. 전수 스캔으로 AWK-3/5/6이 어디까지 일반화되는지, 그리고 AWK에 아직 없던 NEW 패턴이 무엇인지 확정한다. **DB 미적재·스키마 무변경** 원칙 하에 분류만 수행한다.

---

## 0. 한 줄 결론

599건 중 **DIRECT 246 · INDIRECT 272 · NONE 81**. 가격매핑을 실제로 막는(variant→차원 매핑 또는 공식 입력 결손) 항목은 **DIRECT 246건**이며, 이 중 핵심 차단은 **mat 차원 160건**(색상/형태/용량/속성조합이 자재 슬롯에 들어가 mat_cd 미해소)과 **면적상품 작업·재단 치수 결손 SIZE_DIMS_NULL 86건**이다. **후니 결정이 필요한(needs_huni=Y) 항목은 328건**, 결정 유형은 5종으로 수렴한다.

---

## 1. Rule → price_impact 매핑표 (왜 DIRECT/INDIRECT/NONE인가)

| dim | rule | 건수 | price_impact | 근거 (round-2 매핑 관점) |
|-----|------|------|--------------|--------------------------|
| siz | SIZE_DIMS_NULL | 233 | **DIRECT(86) / INDIRECT(147)** | 작업·재단 치수가 비어 **면적기반 가격(면적매트릭스형: 실사/아크릴/포스터/보드/액자/패브릭/매트)**의 입력이 없다 → 해당 상품은 DIRECT(area pricing 불가). 봉투/파우치/책자/노트 등 **고정가형**은 면적으로 단가를 산출하지 않으므로 치수 결손이 가격에 직접 영향 없음 → INDIRECT(fallback=siz_cd 룩업·고정가). 규칙 §5(면적형 곱셈=공식외부)·차원표 siz_cd(§4)에 따라 면적상품만 차단 |
| siz | SIZE_NAME_NOISE | 81 | **NONE** | 사이즈명에 '장수' 등 수량 noise 포함은 **표시(display) 위생** 문제일 뿐. 수량은 round-1(t_dsc 구간할인)·판걸이수 변환에서 처리하며 단가행(min_qty=출력매수)과 무관(규칙 §6·§9). 가격 모델 입력이 아니다 |
| mat | MAT_COLOR_IN_NAME | 68 | **DIRECT** | 색상/마감(투명/홀로그램/유광/레더/골드실버)이 자재명에 박힘. variant별 단가 차이를 `t_prc_component_prices.mat_cd` 차원으로 분해하려면 정규화된 mat_cd가 필요(규칙③). 미해소 시 variant 가격행 키 부재 → 매핑 차단 |
| mat | MAT_COLOR_ONLY | 27 | **DIRECT** | 자재명이 순수 색상(실버/화이트/투명)뿐. 색상=mat_cd variant 축(규칙③). 자재 마스터에 해당 색상 자재 미등록 시(AWK-6) variant 단가 적재 불가 |
| mat | MAT_SIZE_ONLY | 45 | **DIRECT** | 자재명이 용량/개수/사이즈(11온스·350ml·2구·2개1세트·S/M/L)뿐 = variant 가격축이 자재 슬롯에 위치. 용량/개수→mat_cd 또는 신규 siz_cd, 파우치 S/M/L→siz_cd(규칙③, product_sizes 기존 링크). 미해소 시 variant 단가행 차원 키 부재 |
| mat | MAT_PRINTSIDE_ONLY | 19 | **INDIRECT** | 단면/양면이 자재로 등록됨. 인쇄 단/양면은 자재가 아니라 **상품옵션**(`t_prd_product_print_options.print_side`)으로 해소 가능(DDL G-2 해소). 단가가 단/양면별로 다르면 별도 comp_cd 필요(규칙②)하나 fallback 존재 → INDIRECT |
| po | PRINTSIDE_INVALID | 63 | **INDIRECT** | 인쇄면 값이 표준(단면/양면) 아님('배면양면·투명테두리·풀빼다') = 아크릴 특유 인쇄모드. 가격축일 수 있으나 옵션 정규화로 회수 가능(별색=공정 G-1, 단/양면 G-2 패턴). 면적단가는 siz_cd로 별도 산출되므로 가격 직접차단 아님 → INDIRECT |
| plt | PLATE_FILETYPE_FREEFORM | 43 | **INDIRECT** | 출력파일유형 자유서술 'PDF(+W)/(+WC)/(+P)/(+GS)' = **별색 마커**(W=화이트·WC=화이트클리어·P=핑크·GS=금은). 별색=공정(PROC_000007~012, 규칙①)이며 별색 **단가는 디지털인쇄비 F~O 시트**에서 오므로 이 필드가 가격 원천이 아님. 별색 축 존재만 재확인 → INDIRECT(가격 fallback=별색단가 시트) |

**요약 카운트**: DIRECT 246 = SIZE_DIMS_NULL(면적) 86 + MAT_COLOR_IN_NAME 68 + MAT_SIZE_ONLY 45 + MAT_COLOR_ONLY 27 + MAT_SHAPE_ONLY 10 + MAT_ATTR_COMBO 10. INDIRECT 272 = SIZE_DIMS_NULL(고정가) 147 + PRINTSIDE_INVALID 63 + PLATE_FILETYPE_FREEFORM 43 + MAT_PRINTSIDE_ONLY 19. NONE 81 = SIZE_NAME_NOISE 81.

(MAT_SHAPE_ONLY/MAT_ATTR_COMBO는 각 10건; 위 표 dim=mat 행에 통합 — SHAPE_ONLY=형태가 자재(원형/사각)=옵션/siz variant, ATTR_COMBO=색상+크기 복합(화이트 M)=의류 결합 variant. 둘 다 variant 가격축 결손이라 DIRECT.)

---

## 2. 599건 → AWK-1~9 커버리지 (전수 스캔이 무엇을 확증·확장하는가)

| AWK | 기존 정의(파일럿 발견) | 전수 스캔 매핑 | 확증/확장 |
|-----|------------------------|----------------|-----------|
| AWK-1 | prd_cd 미존재 5종(폰케이스류·★표식) | 직접 findings 없음(뷰어는 등록상품 기준 스캔). 단 '지비츠★'(PRD_000171)·'아크릴쉐이커★'(PRD_000170) ★표식 상품이 mat/siz findings에 등장 → ★=작성자 미확정 표식 가설 **재확인** | 확증(간접) |
| AWK-2 | MES_ITEM_CD 부재(variant 연속행 자체 ID 없음) | 모든 mat/siz finding이 prd_cd+target(siz_cd/mat_cd)로만 앵커 = MES 없이 JOIN KEY=prd_nm·코드 의존 **전수 재확인** | 확증 |
| **AWK-3** | 다중가격 variant 35종(손거울/머그/키캡 등) | mat dim 160건 + 면적 siz 86건이 variant 가격축의 모집단. **35종은 (가격포함)100종 표본**이었고 전수 스캔은 variant 패턴이 **거울/머그/키캡을 넘어 파우치 14종·아크릴 30+종·책자/캘린더/의류로 확산**함을 보임 | **대폭 확장** |
| AWK-4 | 사이즈 descriptor 불일치 150건(시트 E열 ↔ siz_nm) | SIZE_DIMS_NULL 고정가형 147건이 동일 본질(siz_nm은 있으나 work/cut 치수 결손) → AWK-4를 전수 좌표(prd_cd·siz_cd)로 확정 | 확장(좌표화) |
| **AWK-5** | 색상/용량=사이즈 아님(머그 11온스·워터북 350ml·"사이즈 필수"칸 이종 혼재) | MAT_SIZE_ONLY 45 + MAT_SHAPE_ONLY 10 = **이종이 "사이즈 칸"이 아니라 "자재 슬롯"에 들어간 패턴**까지 확장. 용량(11온스/350ml/500ml)·개수(2구/3구/4구/2개1세트)·형태(원형/사각)·치수(S/M/L/XL)가 모두 자재로 등록 | **대폭 확장** |
| **AWK-6** | 머그 색상 mat_cd 부재(화이트/반투명/투명) | MAT_COLOR_IN_NAME 68 + MAT_COLOR_ONLY 27 + MAT_ATTR_COMBO 10(색상축) = **105건**이 색상/마감 자재 미등록 모집단(awk_ref=AWK-6). 머그(PRD_000193)는 빙산의 일각 — 아크릴 투명/홀로그램/유광/미러, 책자 레더, 캘린더 색상, 의류 색상 전반으로 확장 | **대폭 확장** |
| AWK-7 | comp_typ_cd 완제품가 유형 부재 | 직접 findings 아님(스키마 코드 갭). 단 위 mat/면적 DIRECT 상품 대다수가 완제품가(고정가/면적) 상품 → AWK-7 적용 범위가 넓음을 **간접 확증** | 확증(간접) |
| AWK-8 | apply 일자 형식 불일치(yyyyMMdd vs yyyy-MM-dd) | 직접 findings 아님(라운드 간 정합). 가격 적재 전 전역 결정 — findings와 독립이나 모든 DIRECT 상품 적재 시 영향 | 독립(불변) |
| AWK-9 | 가격=단가+round-1 구간할인 | 직접 findings 아님(라운드 통합). MAT_SIZE_ONLY 파우치 S/M/L은 round-1이 이미 product_sizes 링크 → round-2는 base 단가만, 구간할인 재매핑 금지 **재확인** | 확증 |

### NEW 어색 패턴 (AWK-1~9에 없던 것, awk_ref=NEW 211건)

| NEW 패턴 | rule | 건수 | 내용 | round-2 처리 |
|----------|------|------|------|--------------|
| N-1 면적상품 치수 전결손 | SIZE_DIMS_NULL(면적) | 86 | 실사/아크릴/포스터/보드/액자/패브릭/매트가 work/cut 치수 비어있음 → 면적매트릭스형 가격 입력 부재 | siz_cd에 치수 등록 후 component_prices(siz_cd) 면적단가. **DIRECT 차단** |
| N-2 인쇄면 비표준 모드 | PRINTSIDE_INVALID | 63 | 아크릴 '배면양면·투명테두리·풀빼다·풀배면' 등 단/양면 외 인쇄모드 | 옵션 정규화(option/process), 가격축이면 comp_cd. INDIRECT |
| N-3 별색 마커가 파일유형 필드에 | PLATE_FILETYPE_FREEFORM | 43 | 'PDF(+W/+WC/+P/+GS)' = 별색(화이트/클리어/핑크/금은) 마커가 출력파일유형 자유서술로 표기 | 별색=공정(규칙①), 단가=디지털인쇄비 F~O. 파일유형 필드는 가격원천 아님. INDIRECT |
| N-4 단면/양면이 자재로 등록 | MAT_PRINTSIDE_ONLY | 19 | 인쇄면이 t_mat_materials에 자재로 잘못 등록(벨벳쿠션/폰스트랩 등) | print_options로 회수(G-2). 단가차이 시 comp_cd. INDIRECT |

---

## 3. DIRECT-impact 요약 (가격매핑을 막는 상품 목록)

### 3.1 rule별 DIRECT 건수·상품수

| rule | DIRECT 건수 | 영향 상품수 | 차단 본질 |
|------|-------------|-------------|-----------|
| SIZE_DIMS_NULL(면적) | 86 | 29 | 면적단가 입력(work/cut 치수) 부재 |
| MAT_COLOR_IN_NAME | 68 | 49 | 색상/마감 variant → mat_cd 미해소 |
| MAT_SIZE_ONLY | 45 | 21 | 용량/개수/사이즈 variant → 차원 미해소 |
| MAT_COLOR_ONLY | 27 | 11 | 순수 색상 자재 미등록 |
| MAT_SHAPE_ONLY | 10 | 4 | 형태 variant(원형/사각) |
| MAT_ATTR_COMBO | 10 | 3 | 색상+크기 복합 variant(의류) |

### 3.2 mat 차원 DIRECT 상품군 (variant→mat_cd 차단, AWK-5/6 모집단)

- **아크릴 30+종**(PRD_000146~169, 226): 투명/홀로그램/유광/미러/골드실버 색상·마감이 자재명. 면적매트릭스형 + 색상 variant 이중 차단.
- **책자/다이어리 6종**: 트윈링책자·하드커버책자·레더하드커버책자·하드커버링책자·레더링바인더·만년다이어리(레더). 커버 색상/소재 variant.
- **캘린더 8종**(PRD_000108~117): 색상 variant.
- **스티커 5종**: 반칼/낱장 투명·홀로그램·팬시투명·합판도무송. 소재(투명/홀로그램) variant.
- **굿즈/생활 다수**: 머그컵(11온스+색상)·워터북보틀(350/500ml)·키캡키링(2/3/4구)·미니매트/피크닉매트(색상)·만년스탬프(잉크색)·천정고리(2개1세트)·자석북마크(2개1팩)·와이어링(색상)·말랑키링(원형/사각).
- **파우치 14종**(PRD_000230~274): S/M/L/XL 사이즈가 자재 슬롯에 등록(MAT_SIZE_ONLY). round-1 product_sizes 링크 기존재 → siz_cd로 해소 가능.
- **의류 3종**: 반팔티셔츠·후드티셔츠(화이트 M/L 복합)·캔버스포켓심플백.

### 3.3 SIZE_DIMS_NULL 면적상품 DIRECT 29종 (면적단가 차단)

아트프린트포스터·아트페이퍼포스터·방수포스터·접착방수포스터·접착투명포스터·아트패브릭포스터·린넨패브릭포스터·캔버스패브릭포스터·레더아트프린트·타이벡프린트·메쉬프린트·폼보드·포맥스보드·프레임리스우드액자·레더아트액자·캔버스행잉포스터·린넨우드봉족자·족자포스터·무광시트커팅·홀로그램시트커팅·미니보드스탠딩·아크릴지비츠·아크릴코스터·아크릴포카스탠드·아크릴카라비너·아크릴쉐이커★·미니매트·피크닉매트·클립보드 (각 prd_cd는 §findings-classified.csv·§awkward-crossmap §3 참조).

이 29종은 **work_width/work_height/cut_width/cut_height가 모두 NULL** → `t_prc_component_prices.siz_cd` 면적 룩업의 키가 없다. 후니가 각 siz_cd에 치수를 등록해야 면적매트릭스형 매핑 착수 가능(규칙⑤: 기존 t_siz_sizes 활용 + 부족분 추가).

---

## 4. 처리 경로 요약 (스키마 무변경 원칙 하)

| 처리 | 대상 | 방법 |
|------|------|------|
| 후니 데이터 등록 후 가능 | mat 색상/마감 105건(AWK-6, ATTR_COMBO 색상축 포함), 면적 치수 86건(N-1) | t_mat_materials 색상자재 추가 / t_siz_sizes 치수 등록 (스키마 무변경, 데이터 추가) |
| 후니 분류 결정 후 가능 | MAT_SIZE_ONLY 45건 + MAT_SHAPE_ONLY 10건 = AWK-5 55건 | "용량/개수/형태/치수"를 siz_cd/mat_cd/bdl_qty/옵션 중 어디로 귀속할지 결정 |
| 매핑 로직 흡수(결정 불요) | SIZE_NAME_NOISE 81(NONE), PLATE_FILETYPE 별색 43, MAT_PRINTSIDE 19, PRINTSIDE_INVALID 63 | 별색=공정(규칙①)·단양면=옵션(G-2)·noise 무시. 가격 fallback 존재 |
| 라운드 간 전역 결정 | AWK-8 일자형식 | go-live 전 yyyyMMdd vs yyyy-MM-dd 1개 확정 |

**HARD 재확인**: 위 어떤 처리도 `t_prc_*`/`t_prd_*` 스키마(컬럼/제약) 변경 없음. variant는 component_prices 6차원으로, 완제품가는 product_prices/comp_typ_cd NULL로, 별색/단양면은 공정/옵션으로 흡수. 결손 데이터는 후니 등록(데이터 추가) 또는 적재 보류로 처리.
