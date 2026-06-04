# 정규화 규칙 사전 (산출물 B) — 엑셀 칸 → DB 코드/구조 변환 기준

작성: 2026-06-05 · round-3 매핑 정합 검증 방법론 재설계 산출물 B.
설명 한국어, 식별자/컬럼/코드/SQL 영어. **DB read-only**(t_prd_product_sets 1회 추출 수행, 그 외 ref-*.csv 재사용).

---

## ① 요약

### 무엇을 만들었나
"엑셀 시트 칸 → DB 코드/구조" 변환규칙을 **도메인 의미**로 도출한 규칙 사전이다. 프레임은 핸드오프 §3 교정대로 **"DB 정규화 규칙 = 기준"**(엑셀=권위 단순 집합대조 폐기). 엑셀≠DB가 곧 DB 오류가 아니라, **정규화 변환규칙을 엑셀에 적용해 기대 DB 행을 산출**하고 실제 DB와 대조하는 것이 검증의 본질이다.

### 핵심 원칙 (오버피팅 금지 — HARD)
- **6 기초데이터 마스터 전체가 규칙의 기준 축·권위**다. 표본 상품(프리미엄엽서 외 3종)은 규칙 도출의 **진입점**일 뿐이다.
- 도출한 각 규칙을 반드시 해당 마스터 테이블 **전체**(sizes/materials/processes/color_counts/base_codes/sets)에 대조해 마스터 코드 체계 전반과 일관됨을 확인하고 규칙마다 명시했다.

### MISSING 재정의
> **MISSING = 정규화 규칙대로 엑셀을 변환하면 적재돼야 하는데 누락된 행.** (엑셀O·DB X 단순집합차가 아니라, "규칙 적용 후 기대행 − 실제행")

### 프리미엄엽서 결함 — 규칙으로 검출됨 (검증 완료)
- DB `t_prd_product_processes`(PRD_000016) = `PROC_000027`(직각)·`PROC_000028`(둥근) = **귀돌이만**.
- 엑셀 공정칸 = `직각 \| 둥근 \| 없음 \| 1줄 \| 2줄 \| 3줄 \| 없음 \| 1줄 \| 2줄 \| 3줄 \| 없음 \| 1개 \| 2개 \| 3개 \| 없음 \| 1개 \| 2개 \| 3개`.
- 1차 검증은 `1줄/2개`를 "과적재 옵션→제외"로 처리해 **4종 누락**(오시 PROC_000029·미싱 PROC_000030·가변텍스트 PROC_000031·가변이미지 PROC_000032)을 못 봤다.
- **규칙 R-PROC-2(줄수/개수=공정 존재 신호)** 적용 시: 엑셀의 `1줄~3줄` 블록 2개 → 오시·미싱 / `1개~3개` 블록 2개 → 가변텍스트·가변이미지로 변환되어, 기대행 6개(27/28/29/30/31/32) vs 실제 2개(27/28) → **MISSING 4건 자동 검출**. 결함이 규칙만으로 재현·해소됨. **명함(PRD_000031)에서도 동일 결함 추가 발견**(가변텍스트/가변이미지 누락).

### 규칙 수
| 기초데이터 | 규칙 수 |
|-----------|:------:|
| 사이즈 (t_siz_sizes) | 6 |
| 자재 (t_mat_materials) | 5 |
| 공정 (t_proc_processes) | 7 |
| 도수 (t_clr_color_counts) | 3 |
| 상품셋트 (t_prd_product_sets) | 3 |
| 기초코드 (t_cod_base_codes) | 4 |
| **합계** | **28** |

### 라이브 추출 수행 여부
- **수행 1회**: `t_prd_product_sets` 스키마+28행 → `00_schema/ref-product-sets.csv` 저장(ref 미추출 상태였음). 그 외 모든 대조는 기존 `ref-*.csv` 재사용.

---

## ② 표본 상품 선정 (다면체 진입점)

`excel-sheet-attr-map.md` 기준으로 **공정유형·구조가 다른 대표 4종**을 골랐다. 표본은 규칙 도출 진입점이며 규칙의 권위는 마스터 전체다.

| # | 표본 | prd_cd | 시트 | 선정 근거 (구조 다양성) |
|---|------|--------|------|----------------------|
| 1 | **프리미엄엽서** | PRD_000016 | 디지털인쇄 | 결함 증거 보유(공정 줄수/개수 신호). 단일자재(`*별도설정`)·치수사이즈·판형·추가상품 다면 |
| 2 | **프리미엄명함** | PRD_000031 | 디지털인쇄 | 박 색상 자식(PROC_000033 family)+가변텍스트/이미지 동시. 공정 정규화의 부모/자식 패턴 표본 |
| 3 | **중철책자** | PRD_000068 | 책자 | 상품셋트(내지/표지 2축)·페이지룰·제본 택일그룹. parent 자재 비어있고 sub_prd로 분해되는 패턴 표본 |
| 4 | **아크릴키링** | PRD_000146 | 아크릴 | 비치수 사이즈(가로/세로 입력)·조각수 묶음수·`*가격표참고` 노이즈·소재형 자재(MAT_TYPE.03 아크릴) |

보조 대조: 굿즈파우치(거울류 — 비치수 사이즈·variant), 실사(코팅 enum)도 규칙 일반화 한계 점검에 인용.

---

## ③ 6 기초데이터별 변환규칙 사전

각 규칙 형식: **[엑셀 칸/표기] → [DB 코드/구조/컬럼]** + 도메인 의미 + **마스터 전체 정합 확인** + MISSING 검출 신호.

---

### A. 사이즈 (t_siz_sizes ↔ t_prd_product_sizes)

마스터 권위: `ref-sizes.csv`(siz_cd, siz_nm, work_*, cut_*, margin_*, impos_yn, note). 브리지: 가격표 `판걸이수` 시트.

#### R-SIZE-1 — 치수문자열 정규화 매칭
- **[엑셀 E `73 x 98 mm`]** → **[DB `t_siz.siz_nm = '73x98'`(cut 기준)]**, 상품연결 `t_prd_product_sizes(prd_cd, siz_cd)`.
- 도메인 의미: 엑셀은 표시용 표기(공백+`mm`), DB는 정규화 재단치수명. 변환 = `lower(replace(replace(엑셀,' ',''),'mm',''))` 후 `siz_nm` 매치.
- 마스터 정합: 프리미엄엽서 7사이즈(`73 x 98 mm`…`148 x 210 mm`) → SIZ_000001~007과 **cut_width/height 전건 일치**(73x98=cut 73·98, work 75·100). 마스터 497행 전체가 동일 `siz_nm`(cut) 표기 규칙 → 규칙은 마스터 전반과 정합.
- MISSING 신호: 엑셀 세로리스트 N사이즈 중 정규화 매치되는데 `t_prd_product_sizes`에 prd_cd+siz_cd 행 없는 것.

#### R-SIZE-2 — work/margin 분리 (판걸이수 브리지)
- **[가격표 `판걸이수` B(재단)·C(블리드)·D(작업)]** → **[`t_siz.cut_*` / `margin_*` / `work_*`]**.
- 도메인 의미: 상품마스터 E는 재단치수만 노출, 작업사이즈·여백은 가격표 브리지가 권위.
- 마스터 정합: SIZ_000001 work=75x100, cut=73x98, margin 1/1/1/1 → 작업=재단+여백×2 일관(73+1+1=75). 마스터 전건 동일 산식.

#### R-SIZE-3 — 규격명 사이즈
- **[엑셀 `A4 (210 x 297 mm)`]** → 괄호 안 치수 추출 후 R-SIZE-1 적용. 규격명(A4)은 `note`/`siz_nm` 보조.

#### R-SIZE-4 — 비치수 옵션 = 사이즈 아님 (옵션축 분기)
- **[엑셀 E `사용자입력`·`아이폰15프로맥스★`·`핑크 (3개1팩)`·`11온스`]** → **사이즈 마스터 매핑 금지**. 폰모델/색상/재질형은 별도 옵션축(print_option/material/variant)으로 분기하거나 비매핑.
- 도메인 의미: E컬럼은 `사이즈(필수)`로 라벨됐으나 의미 오버로드(133종 비치수). 치수정규형이 아니면 size 적재 대상 아님.
- MISSING 검출 제외: 이 값들은 `t_prd_product_sizes` MISSING으로 집계하면 **거짓 MISSING**. 규칙이 사전에 배제.

#### R-SIZE-5 — 비규격(가로/세로 입력형) → nonspec
- **[실사·아크릴 F(가로)/G(세로) 수치 또는 범위 `200~3000`]** → `t_siz`에 고정행 아님. 사용자입력 치수 = `impos_yn`/nonspec 사이즈 또는 면적계산축(round-2 가격영역). 고정 siz_cd 매핑 대상 아님.
- 마스터 정합: ref-sizes.csv는 고정 규격만 보유 → 가변치수는 마스터 부재가 정상(MISSING 아님).

#### R-SIZE-6 — 복합·다중 사이즈 분해
- **[엑셀 한 칸에 `73x98 / 100x150`]** → 분리 토큰별 R-SIZE-1. 세로리스트 = prd당 다행.
- 마스터 정합: `t_prd_product_sizes`는 prd_cd+siz_cd 다행 PK → 분해 후 행수 대조.

---

### B. 자재 (t_mat_materials ↔ t_prd_product_materials)

마스터 권위: `ref-materials.csv`(336행). 브리지: 가격표 `출력소재(IMPORT)`.C(종이명). 코드: MAT_TYPE(base_codes), USAGE.

#### R-MAT-1 — 종이명 직접 매칭
- **[엑셀 P/M/X `아트250`·`스노우300`]** → **[`t_mat.mat_nm` 매치]**, 연결 `t_prd_product_materials(prd_cd, mat_cd, usage_cd)`.
- 마스터 정합: `excel-attrs-normalized.md` 정확매치 74/110. mat_nm 표기차(`지`/`g`)는 정규화 후 매치.

#### R-MAT-2 — `*별도설정` = 가격표 IMPORT 실자재 신호 (플레이스홀더 아님) [HARD]
- **[엑셀 자재칸 `*별도설정`]** → **DB 빈값이 정상 아님**. 핸드오프 §7대로 가격표 `출력소재(IMPORT)` 시트(종이마스터120 × 상품15컬럼 ●)에서 **해당 상품 컬럼에 ● 표시된 종이들**이 실자재. 그 종이명들을 `t_mat.mat_nm`로 매치해 `t_prd_product_materials` 다행 적재.
- 도메인 의미: `*별도설정`은 "자재 선택지가 가격표에 별도 정의됨"의 포인터. 1차 검증이 이를 "플레이스홀더→제외"로 오처리하면 자재 MISSING 전량을 가린다(프리미엄엽서 자재 DB **0행** = `*별도설정`인데 IMPORT 미해소 → MISSING 후보).
- 마스터 정합: import-paper-extract.csv·import-resolution.csv가 IMPORT 해소본. 종이마스터 120 ⊂ t_mat 336.
- MISSING 신호: `*별도설정` 상품인데 `t_prd_product_materials`에 IMPORT ● 종이 행이 누락. **프리미엄엽서 PRD_000016 = DB 자재 0행 → 규칙상 IMPORT ● 종이 수만큼 MISSING 후보**(IMPORT 컬럼 매핑은 C 전수단계 확정).

#### R-MAT-3 — 복합·소재형 분해
- **[엑셀 `아트250+무광코팅`]** → 자재(`아트250`=t_mat)+공정(`무광코팅`=PROC_000015 무광)로 **2축 분해**. `투명아크릴 3mm` → MAT_TYPE.03 아크릴 + 두께속성.
- 도메인 의미: 복합 표기는 자재+공정 합성. 자재축만 보면 MISSING/MISMATCH 오판. 36종 복합(`excel-attrs-normalized.md`).
- 마스터 정합: 분해 후 자재토큰은 t_mat, 공정토큰은 t_proc로 각각 라우팅. 아크릴키링 소재=MAT_TYPE.03와 정합.

#### R-MAT-4 — 내지/표지 2축 → 상품셋트 경로 (parent 자재 비어있음이 정상)
- **[책자/포토북/문구 M(내지종이)·X/Z(표지종이사양)]** → parent 상품의 `t_prd_product_materials`가 아니라 **`t_prd_product_sets`의 sub_prd_cd(내지/표지 반제품)에 자재 적재**. R-SET-1 참조.
- 도메인 의미: 책자는 내지·표지가 독립 반제품(PRD_TYPE.02). 자재는 sub_prd에 붙는다.
- 마스터 정합: 중철책자 PRD_000068 `t_prd_product_materials` **0행**이지만, 이는 R-SET-1상 정상(sub_prd로 분해). **단 PRD_000068은 sets도 0행** → §⑤ 미해결 케이스(중철책자 셋트 미적재 의심).
- MISSING 신호: 2축 상품인데 sets도 materials도 없으면 자재 전량 MISSING.

#### R-MAT-5 — 굿즈파우치 선택(O)·variant 자재
- **[굿즈파우치 O `선택(옵션)`]** → 파우치 색상/소재 → MAT_TYPE.09 파우치 또는 variant축. 거울 S/M/L·머그 색상은 round-2 결정상 `component_prices` 차원 → 자재 매핑 분기.

---

### C. 공정 (t_proc_processes ↔ t_prd_product_processes) — 결함 핵심 영역

마스터 권위: `ref-processes.csv`(83행, 부모/자식 계층 `upr_proc_cd`, 파라미터 `prcs_dtl_opt` JSON).

#### R-PROC-1 — 명칭 enum 직접 매칭 (자식 leaf 우선)
- **[엑셀 공정칸 `직각`·`둥근`]** → **[자식 leaf `PROC_000027`(직각)·`PROC_000028`(둥근)]**, 부모 `PROC_000026`(귀돌이)는 연결 안 함(자식만 적재). 연결 `t_prd_product_processes(prd_cd, proc_cd)`.
- 마스터 정합: ref-processes 계층 = 부모(upr 빈값)+자식(upr=부모). 프리미엄엽서 DB가 27·28만 적재 = "자식 leaf 적재" 패턴과 정합. 명함도 박색상 자식(37~44)만 적재(부모 33 미적재) = 동일 패턴 확인.

#### R-PROC-2 — 줄수/개수 표기 = 공정 **존재 신호** [HARD · 결함 검출 규칙]
- **[엑셀 `없음 \| 1줄 \| 2줄 \| 3줄`]** → **[`PROC_000029`(오시) 존재]** + 파라미터 `prcs_dtl_opt.줄수`(max 3).
- **[엑셀 두 번째 `없음 \| 1줄 \| 2줄 \| 3줄`]** → **[`PROC_000030`(미싱) 존재]** (오시와 미싱은 둘 다 줄수형, 블록 순서로 구분).
- **[엑셀 `없음 \| 1개 \| 2개 \| 3개`]** → **[`PROC_000031`(가변텍스트) 존재]** + 파라미터 `개수`(max 3).
- **[엑셀 두 번째 `없음 \| 1개 \| 2개 \| 3개`]** → **[`PROC_000032`(가변이미지) 존재]**.
- 도메인 의미: `1줄/2개`는 "옵션값"이 아니라 **그 공정이 이 상품에 존재한다는 신호**다. 줄수=오시/미싱(누름선/절취), 개수=가변텍스트/가변이미지(VDP). 1차 검증은 이를 "과적재 옵션→제외"로 처리해 4종 누락을 가렸다(결함 근원).
- 마스터 정합: ref-processes의 `prcs_dtl_opt` JSON이 권위 — `PROC_000029 {줄수 max:3}`·`PROC_000030 {줄수 max:3}`·`PROC_000031 {개수 max:3}`·`PROC_000032 {개수 max:3}`가 엑셀 `1~3줄`/`1~3개` 범위와 **정확 정합**. 즉 줄수/개수 표기는 마스터 파라미터 스키마가 직접 뒷받침. 同 패밀리 PROC_000079(타공 구수 max:8)도 `N개` 표기→공정+개수 규칙으로 일반화.
- **MISSING 검출 신호 (결함 자동검출)**: 엑셀에 `N줄`/`N개` 블록이 있는데 해당 공정코드가 `t_prd_product_processes`에 없으면 MISSING. 프리미엄엽서: 줄수블록2+개수블록2 → 기대 29·30·31·32, 실제 없음 → **MISSING 4건**. 명함: 개수블록2 → 기대 31·32, 실제 없음 → **MISSING 2건**.

#### R-PROC-3 — 별색 인쇄칸 = 공정 (도수 아님) [HARD · 이중성 분기]
- **[엑셀 인쇄옵션 별색 5컬럼 `화이트/클리어/핑크/금색/은색`]** → **[공정 `PROC_000007`(별색인쇄) 부모 + 자식 `PROC_000008~012`]** (`t_prd_product_processes`), **도수(clr) 아님**.
- 도메인 의미: 핸드오프 §7. 별색은 인쇄옵션 컬럼 위치에 있으나 DB 도메인상 공정. R-CLR과 충돌 방지 위해 인쇄칸 중 별색 5종은 공정으로 라우팅.
- 마스터 정합: ref-processes PROC_000007(별색인쇄, note "선택유형=다중") + 5자식. note의 "다중"이 SEL_TYPE.02와 연결 → R-PSG-2.
- MISSING 신호: 별색칸 값 있는데 PROC_000008~012 미연결.

#### R-PROC-4 — 박(foil) 부모/자식 + 박색상 enum
- **[엑셀 `박(있음) \| 금유광 \| 은유광 \| 동박 \| 홀로그램 …`]** → **[자식 박색상 `PROC_000034~049`]** (부모 PROC_000033 박 미적재). `박크기(가로x세로)` → 파라미터 `crc_dtl_opt.크기`.
- 도메인 의미: 박은 색상별 자식이 leaf. 명함 PRD_000031 DB = 37·38·39·40·41·42·43·44 적재 = 정합 확인. `박(없음)`은 비적재.
- 마스터 정합: ref-processes PROC_000033 `{크기 number mm}` + 자식 16종. 엑셀 박색상명 ⊂ 자식명.

#### R-PROC-5 — 코팅 (면 파라미터)
- **[엑셀 `무광코팅(단면) \| 유광코팅(양면)`]** → **[`PROC_000015`(무광)·`PROC_000014`(유광)]** + 파라미터 `면`(단면/양면). 부모 PROC_000013(코팅, 다중).
- 마스터 정합: ref-processes PROC_000014/015/016 `{면 enum:[단면,양면]}` → 괄호 안 면값이 파라미터.

#### R-PROC-6 — 제본 enum + 책등/방향 파라미터
- **[엑셀 `중철제본 \| 무선제본 \| PUR제본 …`]** → **[`PROC_000018~025`]** (부모 PROC_000017). 파라미터 `방향/묶음단위/책등/고리형`.
- 마스터 정합: PROC_000017 prcs_dtl_opt 4입력. 책자 제본은 R-PSG-1 택일그룹 동반.

#### R-PROC-7 — 비명칭 노이즈 배제
- **[엑셀 `*가격표참고`·`10 / 12 / 14 /16`·`0.0`]** → **공정 마스터 매핑 금지**(가격연동/안내문/빈값). 아크릴키링 `*가격표참고` 다수 = 비공정.
- MISSING 검출 제외: 거짓 MISSING 방지.

---

### D. 도수 (t_clr_color_counts ↔ t_prd_product_print_options.front/back_colrcnt_cd)

마스터 권위: `ref-color-counts.csv`(5행). 도수는 독립 9속성 컬럼이 아니라 **인쇄옵션 행의 front/back 도수코드**로 연결.

#### R-CLR-1 — 인쇄면(단면/양면) → 도수코드 쌍
- **[엑셀 인쇄옵션 `단면`]** → **[`t_prd_product_print_options(print_side='단면', front_colrcnt_cd=CLR_000005, back_colrcnt_cd=CLR_000001)`]**. **[`양면`]** → front·back 모두 `CLR_000005`(CMYK 4도).
- 도메인 의미: 단면 = 앞면 4도+뒷면 "인쇄 안 함"(CLR_000001). 양면 = 양쪽 4도.
- 마스터 정합: ref-color-counts CLR_000001(인쇄 안 함, chnl 0, note "단면 인쇄 시 뒷면도수코드")·CLR_000005(CMYK 4도, default). 프리미엄엽서 print-options 2행이 정확히 이 패턴(단면=05/01, 양면=05/05) → **전건 정합**.

#### R-CLR-2 — 도수 명시 표기
- **[엑셀 `1도(흑백)`·`2도`]** → **[`CLR_000002`·`CLR_000003`]**. chnl_cnt로 매치.
- 마스터 정합: 5행 = 0/1/2/3/4도 전부. 엑셀 도수 표기 ⊂ 마스터.

#### R-CLR-3 — 도수 미표기 default
- **[엑셀 도수 미기재]** → default `CLR_000005`(CMYK 4도). 마스터 note "기본 default" 근거.

---

### E. 상품셋트 (t_prd_product_sets) — 내지/표지/면지 합성

마스터 권위: `ref-product-sets.csv`(28행 — 본 작업서 신규 추출). 구조: `(prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note)`, PK(prd_cd, sub_prd_cd). sub_prd_cd는 반제품(PRD_TYPE.02) FK.

#### R-SET-1 — 2축(내지/표지/면지) 상품 → sub_prd 분해
- **[책자/포토북/문구 내지축 M·표지축 X/Z]** → **[`t_prd_product_sets`에 parent prd_cd → sub_prd_cd(내지 반제품)·(표지 반제품) 행]**. note에 `표지=레더(화이트)`·`면지=화이트면지` 역할 표기.
- 도메인 의미: 책자류는 내지·표지·면지가 각각 독립 반제품. 자재/인쇄/도수는 sub_prd에 붙고, parent는 셋트로 합성. R-MAT-4와 한 쌍.
- 마스터 정합: ref-product-sets 28행 패턴 = `PRD_000072→073(표지)/074~076(면지)` 등. SEMI_ROLE(내지01/표지02/면지03/간지04/투명커버05) base_code와 note 역할 정합.
- MISSING 신호: 엑셀 2축 상품(책자12·포토북·문구12)인데 sets에 sub_prd 행 없음. **중철책자 PRD_000068 = sets 0행** → MISSING 의심(§⑤).

#### R-SET-2 — sub_prd_qty (구성 수량)
- **[엑셀 셋트 구성 N개]** → `sub_prd_qty`. 현재 마스터 전건 qty=1.

#### R-SET-3 — 표지타입 다중(레더/소프트/하드커버)
- **[엑셀 표지사양 `레더/소프트커버/하드커버`]** → 표지 sub_prd 다행(PRD_000100=표지 6종). USAGE.06 표지타입.

---

### F. 기초코드 (t_cod_base_codes) — 코드 FK 정규화

마스터 권위: `ref-base-codes.csv`(58행, 부모/자식 `upr_cod_cd`).

#### R-COD-1 — 묶음단위 → QTY_UNIT
- **[엑셀 묶음수 단위 `매/권/세트/EA`]** → **[`t_prd_product_bundle_qtys.bdl_unit_typ_cd = QTY_UNIT.01~04`]**.
- 마스터 정합: QTY_UNIT.01 EA·02 매·03 권·04 세트. ref-product-bundle-qtys 현재 2상품(97/182)만 권(QTY_UNIT.03) → 묶음수 보유 27상품 대비 대량 MISSING 신호(핸드오프 round-3 예측과 정합).

#### R-COD-2 — 판형 출력용지유형 → OUTPUT_PAPER_TYPE
- **[엑셀 출력용지규격]** → `t_prd_product_plate_sizes.output_paper_typ_cd = OUTPUT_PAPER_TYPE.01(국전)/.02(46)/.03(기타)`.
- 마스터 정합: 프리미엄엽서 plate 7행 중 1행 OUTPUT_PAPER_TYPE.03, 나머지 빈값 → 코드 부여 일관성 점검 대상.

#### R-COD-3 — 공정택일그룹 선택유형 → SEL_TYPE
- **[공정 컬럼 단일/다중 성격]** → `t_prd_product_process_excl_groups.sel_typ_cd = SEL_TYPE.01(단일)/.02(다중)`. R-PSG 참조.

#### R-COD-4 — 자재유형 → MAT_TYPE / 용도 → USAGE
- **[자재 종류·용도(내지/표지)]** → `t_mat.mat_typ_cd = MAT_TYPE.01~11`, `t_prd_product_materials.usage_cd = USAGE.01~07`.
- 마스터 정합: MAT_TYPE 11종·USAGE 7종 전부 base_codes 존재.

---

### (부속) 공정택일그룹 — t_prd_product_process_excl_groups (엑셀 원천 부재 → 추론 규칙)

#### R-PSG-1 — 단일선택 공정군 → 택일그룹
- **[공정의 한 옵션-컬럼이 상호배타 enum(제본: 중철/무선/PUR…)]** → `excl_grp_cd` 1개 + `sel_typ_cd=SEL_TYPE.01`. 엑셀에 "택일그룹" 명시 컬럼 **없음** → 컬럼 구조에서 추론(노트 필수).
- 마스터 정합: ref-product-process-excl-groups 실재행 = `GRP-BOOK-제본`(SEL_TYPE.01) 책자류만. note `trigger=중철제본` 등.
- **한계**: 엑셀 원천 부재 → 자동 검출 불가, "추론 vs DB 실제" 명시 대조만. 프리미엄엽서·명함 excl-groups **0행**(귀돌이/박은 단일그룹화 안 됨).

#### R-PSG-2 — 다중선택 공정(별색·코팅·박) → SEL_TYPE.02
- 별색(PROC_000007 note "다중")·코팅·박은 다중허용 → `sel_typ_cd=SEL_TYPE.02`, `max_sel_cnt`. 단정 금지(추론).

---

## ④ 프리미엄엽서 다면체 워크스루 (결함 재현·해소)

PRD_000016 한 상품의 6 기초데이터를 입체적으로 변환규칙 적용한 결과:

| 속성 | 엑셀 원천 | 규칙 | 기대 DB 행 | 실제 DB | 판정 |
|------|----------|------|-----------|---------|------|
| 사이즈 | 7치수(`73 x 98 mm`…) | R-SIZE-1/6 | SIZ_000001~007 (7행) | 7행 | ✅ MATCH |
| 자재 | `*별도설정` | R-MAT-2 | IMPORT ● 종이 N행 | **0행** | 🔴 MISSING(IMPORT 미해소) |
| 인쇄옵션·도수 | `단면 \| 양면` | R-CLR-1 | 단면(05/01)·양면(05/05) 2행 | 2행 정확 | ✅ MATCH |
| 공정(귀돌이) | `직각 \| 둥근` | R-PROC-1 | PROC_000027·028 | 27·28 | ✅ MATCH |
| 공정(오시/미싱) | `1줄~3줄` ×2블록 | **R-PROC-2** | PROC_000029·030 | **없음** | 🔴 **MISSING 2** |
| 공정(가변텍스트/이미지) | `1개~3개` ×2블록 | **R-PROC-2** | PROC_000031·032 | **없음** | 🔴 **MISSING 2** |
| 판형 | `316x467`(전지) | R-COD-2 | plate 7행 | 7행 | ✅ (의미축 주의) |
| 묶음수 | (없음) | — | — | 0행 | ✅ |
| 추가상품 | 봉투 6종 | (addon) | 6 addon | **3행** | 🟠 MISSING 3(트레싱지·카드블랙·OPP 일부) |
| 상품셋트 | (단일상품) | R-SET-1 미해당 | 0행 | 0행 | ✅ |
| 페이지룰 | (없음) | — | — | 0행 | ✅ |

**결함 재현·해소 확정**: 1차 검증이 놓친 공정 4종(29/30/31/32)이 **R-PROC-2 적용만으로 MISSING 자동 검출**됨. 추가로 자재(R-MAT-2)·추가상품에서 MISSING 신호 동반 발견. 명함 PRD_000031에서도 R-PROC-2가 가변텍스트/이미지(31/32) MISSING 2건을 동일하게 검출 → 규칙이 표본 넘어 일반화됨.

---

## ⑤ 규칙의 일반화 한계 · 미해결 케이스

1. **R-MAT-2 IMPORT 컬럼 매핑**: `*별도설정` → 가격표 IMPORT 시트의 어느 ● 종이가 어느 상품에 붙는지 컬럼-상품 매핑이 C 전수단계에서 확정 필요. 현 규칙은 "MISSING 후보"까지만 단정 가능.
2. **중철책자 PRD_000068 sets 0행**: R-SET-1상 2축 상품인데 셋트·자재 모두 0행. 다른 책자(PRD_000072 등)는 sets 보유 → **중철책자 셋트 미적재 의심**이나, 중철책자가 단일 반제품 구조일 가능성도 있어 라이브 prd 구조 확증 필요(미해결).
3. **공정택일그룹(R-PSG)**: 엑셀 원천 컬럼 부재 → 규칙은 추론. 자동 MISSING 검출 불가. DB 실제행과 "추론 매핑"의 일치만 점검 가능(반자동).
4. **줄수형 오시/미싱 블록 순서 의존**: R-PROC-2가 동일 `1줄~3줄` 블록 2개를 순서(첫=오시·둘째=미싱)로 구분 → 시트마다 블록 순서가 다르면 오매핑 위험. C단계에서 시트별 컬럼 헤더(AD~AH 등)로 공정명 앵커 필요.
5. **비치수 사이즈 옵션축(R-SIZE-4/5)**: 폰모델/색상/사용자입력 133종은 size 아님으로 배제하나, 이 중 일부가 print_option/material/variant 어느 축인지 상품별 재판정 필요(자동 분기 불완전).
6. **굿즈파우치 variant(거울 S/M/L·머그 색상)**: round-2 결정상 component_prices 차원 → 9속성 매핑축과 교차. 본 규칙 사전 범위 밖(가격 round-2).
7. **추가상품 addon 매칭**: 엑셀 봉투명(`OPP접착봉투 110x160 mm 50장`) ↔ DB addon_prd_cd(PRD_000001…) 매칭은 상품명 정규화 필요. note 텍스트로 brittle 매칭.

---

## ⑥ C(전수설계)에 넘길 규칙 코드화 입력 명세

C단계(전수 자동 대조 스크립트)가 구현할 규칙→코드 변환 명세:

### 입력
- 엑셀 파싱본: `04_audit/excel-{size,material,print-option,process,plate-size,bundle-qty,page-rule,addl-product}.csv` (컬럼 `sheet,gubun,prd_nm,mes_item_cd,source_values` 파이프 리스트).
- DB 적재본: `00_schema/ref-product-{sizes,materials,print-options,processes,process-excl-groups,plate-sizes,bundle-qtys,page-rules,addons,sets}.csv` + 마스터 `ref-{sizes,materials,processes,color-counts,base-codes,product-sets}.csv`.
- JOIN KEY = `prd_nm` → `ref-products.csv`로 prd_cd 해소.

### 규칙 코드화 우선순위 (결함 검출력 순)
1. **R-PROC-2 (줄수/개수 → 공정 존재)** — 최우선. `source_values`를 `\|`로 토큰화 → `\d+줄` 패턴 발견 시 오시(29)·미싱(30) 기대행, `\d+개` 패턴 시 가변텍스트(31)·가변이미지(32) 기대행 생성. 블록 순서로 부모공정 매칭(시트 헤더 앵커 병용). 실제 `ref-product-processes`와 차집합 → MISSING.
2. **R-MAT-2 (`*별도설정` → IMPORT)** — `*별도설정` 토큰 발견 시 IMPORT 해소표(`import-resolution.csv`)에서 상품 ● 종이 기대행 생성 → MISSING.
3. **R-PROC-1/3/4/5/6 (명칭 enum → leaf proc_cd)** — 엑셀 공정명 토큰을 `ref-processes.csv` leaf `proc_nm` 매치(부모 미적재 규칙). 별색 5종은 강제 공정 라우팅(R-PROC-3).
4. **R-SIZE-1/3/6 (치수 정규화 매칭)** — `lower(replace(' '/'mm',''))` 후 `siz_nm` 매치. 비치수(R-SIZE-4/5)는 배제 사전(폰모델/색상/사용자입력 패턴 정규식)으로 거짓MISSING 차단.
5. **R-CLR-1/2/3 (인쇄면 → 도수쌍)** — 단면=(05,01)·양면=(05,05) 매핑 후 print-options 도수컬럼 대조.
6. **R-SET-1 (2축 → sub_prd)** — 책자/포토북/문구 시트 상품은 sets 보유 기대, 0행이면 MISSING(중철책자 예외 플래그).
7. **R-COD-1~4** — 단위/유형 코드 FK는 마스터 enum 매핑표로 정규화.

### 배제 사전 (거짓 MISSING/EXTRA 차단 — HARD)
- 공정 비명칭: `^\*`(가격표참고)·순수수치(`^[\d/ .]+$`)·`0.0` → 배제.
- 사이즈 비치수: `사용자입력`·`★`·`온스`·`ml`·`팩`·폰모델 토큰 → size 매핑 배제.
- 자재 `*별도설정` → 빈값 아닌 IMPORT 포인터로 라우팅(빈값 처리 금지).

### 출력 (C 산출 예상)
- 상품×속성 매트릭스: 각 셀 = {MATCH n / MISSING n / EXTRA n / MISMATCH n} + 명세 CSV(prd_nm, attr, 분류, 엑셀토큰, 기대코드, 실제코드).
- 속성별 집계 + 마스터 정합 헤더(R-*별 적용 건수·검출 MISSING 수).

---

## 부록 — 라이브 추출 산출

- `00_schema/ref-product-sets.csv` (신규, 28행 + 헤더) — t_prd_product_sets 전체. read-only SELECT, DB 무변경.
- 스키마: `(prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note)`, PK(prd_cd, sub_prd_cd), sub_prd_cd FK→t_prd_products. 내지/표지/면지 합성 패턴 확인.
