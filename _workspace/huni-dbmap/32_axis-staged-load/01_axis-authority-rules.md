# 6축 매핑 정답 규칙 (Axis Authority Rules) — staged 적재·교정 도메인 토대

> **작성** 2026-06-16 · `dbm-domain-researcher`(round-22 토대). 설명 한국어, 식별자/컬럼/코드/t_*/SQL = English.
>
> **목적:** 상품마스터 엑셀을 라이브 `t_*`에 적재할 때, **6개 기초데이터 축**(① 기초코드 ② 사이즈 ③ 도수 ④ 자재 ⑤ 공정 ⑥ 카테고리) 각각에 대해 "무엇이 이 축에 속하고(경계), 어느 엑셀 컬럼이 권위이며, 모호할 때 무엇으로 판별하고, 경쟁사는 어떻게 표현하며, 코드/멱등/FK는 어떻게 정규화하고, 적재 선후 의존이 무엇인가"를 **모호함 0**으로 정립한다. 신설 round-22 하네스(6축 staged 적재·교정)의 도메인 토대.
>
> **권위 순서 [HARD]:** ① 후니 공식 PDF(공정관리·주문프로세스) + 라이브 DB 실측 → ② 07_domain KB(`entity-semantic-model` L3 의미축·`process-recipe-tree` L2 레시피)·round-11 산출·`schema-design-intent-map` → ③ 경쟁사(RedPrinting 역공학·WowPress) 갭헌팅·합리성 오라클 → ④ 국내외 표준(CIP4/JDF 등) 보조. **엑셀 명시값이 최우선 권위. 추정 0** — 미지는 가설+출처+컨펌ID. 표준·경쟁사 충돌 시 후니 권위.
>
> **재사용(중복 리서치 금지):** 본 문서는 6축의 의미축·오모델·경쟁사 패턴을 **재유도하지 않고 인용·종합**한다. 출처: `schema-design-intent-map.md`(②각 t_* WHY·③삼중바인딩·④오모델 OM-1~7)·`entity-semantic-model.md`(§1 9속성 의미축·§2 variant·§3 UV/별색)·`process-recipe-tree.md`(§1 인쇄방식·§3 제본·§4 생산방식)·`code-values.md`(BASE_CODE_GROUP 11그룹 47자식)·`code-identifier-strategy.md`(D1~D5 비준)·`benchmark-competitors.md`(RP/WP 패턴).
>
> **확정도 범례:** ✅ PDF/DB 권위 · 🟡 PDF부분+표준 · 🔴 미수록(가설·컨펌 필요).

---

## 0. 6축 ↔ t_* 대응 (감사 확정)

| 축 | 마스터 t_* (행수 06-06) | 핵심 컬럼 | 코드 prefix | BASE_CODE_GROUP 의존 |
|----|------------------------|-----------|-------------|----------------------|
| ① 기초코드 | `t_cod_base_codes` (71) | cod_cd PK · upr_cod_cd(self-ref) · cod_nm · disp_seq | (그룹명.NN) | **자기 자신**(11 부모 → 47+ 자식 평탄) |
| ② 사이즈 | `t_siz_sizes` (500) | siz_cd PK · work_w/h(작업) · cut_w/h(재단) · margin_* · impos_yn | `SIZ_` | — |
| ③ 도수 | `t_clr_color_counts` (5) | clr_cd PK · clr_nm · **chnl_cnt**(채널수 0~4) | `CLR_` | — (고정 5행, 신규 발급 없음) |
| ④ 자재 | `t_mat_materials` (336) | mat_cd PK · **mat_typ_cd**(MAT_TYPE 11) · upr_mat_cd(self-ref) · sel_typ_cd · width/height/depth/weight/bdl_qty | `MAT_` | MAT_TYPE · SEL_TYPE |
| ⑤ 공정 | `t_proc_processes` (83) | proc_cd PK · **upr_proc_cd**(self-ref family) · **prcs_dtl_opt**(JSON param) | `PROC_` | — |
| ⑥ 카테고리 | `t_cat_categories` (306) | cat_cd PK · upr_cat_cd(self-ref tree) · cat_lvl(1~3) | `CAT_` | — |

> **공통 원리(전 축):** 6축은 모두 **마스터(공유 사전) ↔ 상품연결행(`t_prd_product_*`)** 2계층이다. 본 문서는 *마스터 축*의 정답을 정립한다. 상품연결행(L1 차원)·CPQ 옵션 레이어(L2)는 마스터 축이 선존재해야 적재 가능(§통합 적재 순서). 동일 값을 잘못된 축에 넣지 않는 것이 핵심(`schema-design-intent-map` round-9 directive — 기계적 매핑 금지).

---

# ① 기초코드정보 축 — `t_cod_base_codes`

## 1.1 정의·경계

- **속하는 것:** 시스템 전역에서 재사용되는 **enum 사전 값**. 자기참조형으로 부모 그룹(`upr_cod_cd IS NULL`)이 코드 그룹(BASE_CODE_GROUP)을 정의하고, 자식이 실제 enum 값을 담는다. 11 부모 그룹(`code-values.md`): PRD_TYPE·SEMI_ROLE·CUS_GRADE·MAT_TYPE·PRC_COMPONENT_TYPE·OUTPUT_PAPER_TYPE·DSC_TYPE·SEL_TYPE·USAGE·QTY_UNIT·FRM_TYPE.
- **속하지 않는 것(오염 금지):**
  - **데이터성 값을 코드 그룹으로 만들지 말 것** — 사이즈(SIZ)·자재(MAT)·공정(PROC)·도수(CLR)·카테고리(CAT)는 별도 마스터다. base_codes는 "그 마스터들이 *분류*에 쓰는 작은 enum"만 담는다(예: MAT_TYPE은 자재의 *유형 분류*이지 자재 자체가 아니다).
  - **상품별 변동값 금지** — base_codes는 전역 불변 사전. 상품 1건만의 값은 여기 오지 않는다.

## 1.2 권위 소스 (상품마스터 컬럼)

base_codes는 **엑셀 컬럼에서 직접 적재되지 않는다** — 다른 축의 컬럼 값이 *분류될 때* 참조되는 백본이다. 권위는:
- 라이브 `t_cod_base_codes` 71행(이미 적재·SEED 완료, `ref-base-codes.csv`).
- 신규 enum이 필요한 경우만(예: 새 MAT_TYPE), 해당 축 엑셀 컬럼의 값 분포가 권위(예: 굿즈파우치 시트의 소재가 MAT_TYPE.09 파우치를 정당화).

## 1.3 인쇄도메인 판별 규칙 (모호 시)

- "이 값이 **여러 상품에서 반복되는 분류 라벨**인가, 아니면 **개별 자원**인가?" — 반복 분류 라벨(완제품/반제품, 내지/표지, 정률/정액)이면 base_codes, 개별 자원(특정 종이·특정 칼틀)이면 해당 마스터.
- **부분집합 함정(`code-values.md` 권위):** `dsc_typ_cd`·`bdl_unit_typ_cd`는 FK가 부분집합을 강제하지 않는다. `DSC_TYPE`은 부모 그룹으로, `bdl_unit_typ_cd`는 `QTY_UNIT` 그룹을 **재사용**(BDL_UNIT 부모 없음). 로더가 일관성 유지 책임.

## 1.4 경쟁사 벤치마크

- **RedPrinting:** ESN_YN/VIEW_YN(필수/표시)·sel_typ(radio/select) 같은 메타를 PCS 항목에 인라인. 후니는 이를 SEL_TYPE(단일/다중) base_code + 택일그룹으로 분리 — **후니가 더 정규화**(`benchmark-competitors` §5).
- **WowPress:** type=select/radio/checkbox를 awkjob에 인라인. 후니 SEL_TYPE가 동등 표현.
- **CIP4/JDF(보조):** JDF는 ResourceType/ProcessType enum을 XML 네임스페이스로 관리. 후니 base_codes 자기참조 트리가 동일 역할(평탄 enum). **후니 흡수 충분 — 답습 불요.**

## 1.5 정규화 원칙

- **코드 형식:** `<그룹명>.NN`(예 `MAT_TYPE.09`). 부모는 그룹명만(`MAT_TYPE`). 순차 surrogate 아님 — **의미 코드**(예외적, base_codes만 의미코드 PK 유지).
- **멱등:** (cod_cd) 자연키로 NOT EXISTS. 신규 자식 enum은 `<그룹>.` + lpad(MAX(suffix)+1, 2). 신규 부모 그룹 신설은 인간 승인(스키마 확장급).
- **FK:** 다른 모든 축이 base_codes를 참조(MAT_TYPE←materials, USAGE←product_materials, OUTPUT_PAPER_TYPE←plate_sizes 등). self-ref `upr_cod_cd` ON DELETE RESTRICT.

## 1.6 적재 선후 의존

**최상위 SEED. FK 위상의 뿌리.** 다른 5축·모든 상품연결행·가격엔진이 base_codes를 참조하므로 **반드시 가장 먼저**(이미 71행 적재됨). 신규 enum이 필요하면 그 enum을 쓰는 마스터/연결행 적재 *전에* 선적재.

---

# ② 사이즈정보 축 — `t_siz_sizes`

## 2.1 정의·경계 (이중축 — 작업치수 ↔ 재단치수)

- **속하는 것:** **물리 치수**만. 한 마스터에 **두 치수 축이 공존**(`entity-semantic-model` §1.1·`schema-design-intent-map` §2.1):
  - **작업치수**(`work_width/work_height`) = 블리드 포함 인쇄·재단 전 치수.
  - **재단치수**(`cut_width/cut_height`) = 고객이 고르는 완성품 치수.
  - **여백**(`margin_*`) = 작업−재단 차(도련/블리드, 보통 1~5mm).
  - **`impos_yn`** = 조판(임포지션) 가능 여부.
- **속하지 않는 것(오염 금지) — 가장 빈번한 결함:**
  - **색상을 `siz_nm`에 인코딩 금지**(OM-1, 카드봉투 `SIZ_000104`="화이트165x115mm" — 색은 자재/옵션, siz는 165x115만).
  - **형상(원형/하트) enum을 siz에 drop 금지**(OM `size축에 형상` — 형상은 공정 칼틀 또는 공정 param, 단 합판도무송은 칼틀=siz 1:1 Q7).
  - **수량(10장)을 siz_nm에 인코딩 금지** — 수량은 묶음수/주문수량 축.
  - **출력판형(전지/절수)을 완성품 size로 혼동 금지** — 출력판형은 같은 마스터의 work_* 슬롯이지만 **상품연결은 `t_prd_product_plate_sizes`**(별 연결축), 완성품은 `t_prd_product_sizes`.

## 2.2 권위 소스 (상품마스터 컬럼)

| 엑셀 컬럼 | → siz 슬롯 | 권위 |
|-----------|-----------|------|
| `사이즈(필수)` / `재단사이즈` | `cut_width/cut_height` (완성품) | ✅ round-11 digital-print C5/C9 |
| `파일사양>작업사이즈` | `work_width/work_height` | ✅ round-11 C8 |
| `파일사양>블리드` | margin (도출: work−cut의 절반) | 🟡 별 컬럼 없음, 도출/note |
| `사이즈>판수`(판걸이수) | **siz에 적재 안 함** — note 또는 앱 (§2.3) | ✅ |
| `사용자입력`/비규격 | siz 행 아님 → `t_prd_products.nonspec_*_min/max` | ✅ |

> **라이브 note 구조(실측):** `SIZ_000001` note=`판걸이=18.0 / 전지=316x467 / 적용=엽서`. 즉 **판걸이수·전지(출력판형)·적용상품**이 `note`에 텍스트로 보존됨. 이는 정규 컬럼이 아닌 메타 — 가격엔진·임포지션은 이 note를 파싱하지 않고 앱이 런타임 계산(아래).

## 2.3 인쇄도메인 판별 규칙 (모호 시)

- **"이 값이 mm 물리 치수인가?"** — Yes면 siz, No면 다른 축. 색·형상·수량·재질이 치수와 한 셀에 묶여 있으면 **분리**(치수만 siz, 나머지는 자기 축).
- **판걸이수(판수) = 앱 계산, DB 미저장**(`compute-in-app-db-stores-lookup`, round-11 C6): 출력용지 인쇄가능영역 + 작업사이즈 → 임포지션/네스팅 런타임 산출. siz 컬럼에 매핑 금지(note 보존은 가능).
- **완성품 vs 출력판형:** 고객이 주문하는 치수 = 완성품(`product_sizes`), 한 판에 앉히는 출력 치수 = 판형(`product_plate_sizes`, output_paper_typ_cd 분류). 완성품 7종 ↔ 판형 1종이 정상.
- **비규격(연속범위):** 실사·현수막의 `사용자입력`은 siz 이산 행이 아니라 `nonspec_*` 범위(OM-3). 가격·유효성은 별도 포스터사인 면적매트릭스(가격축, 본 문서 범위 밖).

## 2.4 경쟁사 벤치마크

- **RedPrinting:** size를 `pdt_size_info` 독립 데이터셋 + `MIN/MAX_CUT` 비규격 슬롯. 후니 work/cut 이중축 + nonspec_*가 동등(`benchmark-competitors` §2).
- **WowPress:** sizeinfo에 `non_standard:0/1` 플래그 + `req_width/req_height`(비규격 min/max). 후니 nonspec_*가 1:1 대응 — **후니도 채워야**(현재 NULL 결함).
- **CIP4/JDF(보조):** Media/Layout의 Dimensions(작업)와 TrimSize(재단)를 분리 — **후니 work/cut 이중축과 정확히 동형**. 표준이 후니 모델을 검증.
- **흡수 판정:** 후니 사이즈 모델(작업/재단 이중 + impos_yn + nonspec_*)은 경쟁사·표준을 **흡수·능가**. 결함은 모델 부재가 아니라 ① 오염 적재(색/형상/수량을 siz_nm에) ② nonspec_* NULL.

## 2.5 정규화 원칙

- **코드:** `SIZ_NNNNNN` 순차 surrogate(D1 비준). 멱등 키 = **치수 조합**(work_w,work_h,cut_w,cut_h) 또는 `siz_nm`(치수 문자열). 같은 치수 재발급 금지(search-before-mint — OM-1 후속 발견 SIZ_000422 원형35mm 사례).
- **이중 등록 주의:** 한 물리 사이즈가 완성행(impos=Y + 판걸이 note)과 작업사이즈 중복행으로 두 번 등록될 수 있음(`platesize-is-output-paper` 메모리) — 적재 전 중복 점검.
- **FK:** `t_prd_product_sizes.siz_cd`·`t_prd_product_plate_sizes.siz_cd` RESTRICT, **`t_prc_component_prices.siz_cd` ON DELETE CASCADE** → 가격 siz는 반드시 마스터 선존재(placeholder `SIZ_PENDING_*` 적재 시 100% FK 위반, `schema-design-intent-map` §1.3 HARD).

## 2.6 적재 선후 의존

base_codes(OUTPUT_PAPER_TYPE) 다음, **상품·product_sizes·plate_sizes·component_prices보다 먼저**. 가격사슬이 CASCADE FK로 siz에 묶이므로 siz는 가격 적재 전 완비 필수.

---

# ③ 도수정보 축 — `t_clr_color_counts`

## 3.1 정의·경계

- **속하는 것:** **잉크 색 채널 수**(ink color count)만. `chnl_cnt`로 0~4(라이브 실측 5행 고정): `CLR_000001` 인쇄안함(0)·`CLR_000002` 1도흑백(1)·`CLR_000003` 2도(2)·`CLR_000004` 3도(3)·`CLR_000005` CMYK4도(4·default).
- **속하지 않는 것(오염 금지) — [HARD 핵심 원칙]:**
  - **별색(화이트/클리어/핑크/금/은)을 도수 칸에 넣지 말 것.** 별색 = **공정**(`PROC_000007` family, `clr_cd=NULL`), 도수 아님(`entity-semantic-model` §3.2·OM-5). CMYK 4도에 별색을 더하면 "5도/9도"로 늘지만(PDF p5), **DB 인코딩 위치는 공정칸**이다.
  - **UV 변형(배면양면/풀빼다)을 print_side에 넣지 말 것** — UV=`PROC_000002` param(OM-5).
  - **단/양면(인쇄면)을 도수와 혼동 금지** — 인쇄면(앞/뒤)은 `t_prd_product_print_options.print_side`, 도수는 그 행의 front/back_colrcnt_cd. 도수 *마스터*(이 축)는 채널수만.

## 3.2 권위 소스 (상품마스터 컬럼)

- 도수 *마스터*는 엑셀에서 신규 적재되지 않음(고정 5행 SEED 완료). 엑셀 `인쇄>도수`(예 4도/CMYK·1도) 컬럼은 **상품연결행** `t_prd_product_print_options.front_colrcnt_cd/back_colrcnt_cd`(opt_id별)로 가고, 그 값이 CLR_000001~005를 참조.
- 단면 시 뒷면도수 = `CLR_000001`(인쇄안함, note 권위).

## 3.3 인쇄도메인 판별 규칙 (모호 시)

- **"이 색이 CMYK 프로세스 채널인가, 그 외 별도 잉크인가?"** — CMYK 채널수면 도수(clr), CMYK 외 별도 잉크(화이트/형광/메탈/바니시)면 **별색 공정**.
- **별색 vs 박 vs 도수 3분(`entity-semantic-model` §3.2):** 별색=잉크 인쇄(PROC_000007 family) · 박=금형 압착 포일(PROC_000033) · 도수=CMYK 채널수(clr). 별색금 ≠ 박금.
- **앞면/뒷면 도수 분리:** print_options는 opt_id 행마다 front/back_colrcnt를 각각 보유(단면=back이 CLR_000001).

## 3.4 경쟁사 벤치마크

- **RedPrinting:** 도수(dosu)를 독립 축, 별색은 PCS(PRT_WHT) 또는 도수 혼재 — **후니의 "별색=공정 분기"가 더 일관**(`benchmark-competitors` §7).
- **WowPress:** colorinfo의 colorno + addtype(별색). 후니 clr+PROC_000007 분리가 동등 이상.
- **CIP4/JDF(보조):** ColorantControl의 ProcessColorModel(CMYK)과 SpotColor를 분리 정의 — **후니 도수(CMYK)/별색(공정) 분리와 정확히 동형**. 표준이 후니 분리 검증.
- **흡수 판정:** 후니 도수 모델은 표준·경쟁사를 흡수. 5행 고정이 충분(채널수는 0~4가 물리 상한).

## 3.5 정규화 원칙

- **코드:** `CLR_NNNNNN` 순차. 단 **5행 고정 — 신규 발급 사실상 없음**(채널수 도메인 폐쇄). 멱등 = (chnl_cnt) 또는 (clr_cd) 자연키.
- **FK:** `t_prd_product_print_options.front/back_colrcnt_cd` · `t_prc_component_prices.clr_cd` → clr_color_counts. NULL 허용(가격 차원에서 도수 무관 시).

## 3.6 적재 선후 의존

base_codes 다음(또는 병렬). **이미 완비(5행)** — 신규 적재 대상 아님. print_options·component_prices가 참조하므로 그들보다 선존재(이미 충족).

---

# ④ 자재정보 축 — `t_mat_materials`

## 4.1 정의·경계

- **속하는 것:** **물리 재료**(종이/소재/부속) + 분류·물성. `mat_typ_cd`(MAT_TYPE 11: 종이/필름/아크릴/금속/원단/가죽/부속/실사소재/파우치/악세사리/스티커) · `upr_mat_cd`(self-ref, 자재 계열) · `width/height/depth/weight/bdl_qty`(물성) · `sel_typ_cd`. **두께도 자재 식별자**(아크릴 1.5/3/8mm = 별 mat_cd).
- **속하지 않는 것(오염 금지) — [HARD, MAT_TYPE.08~10 오염 실증]:**
  - **색상을 자재 행으로 과분할 금지** — 단 **본체색은 재질행 합성이 정답**(파우치 블랙 = 자재 분기, 과분할 아님, `material-option-normalization`). 잉크색·인쇄색은 도수/별색.
  - **형상(원형/하트)을 자재로 금지** — 형상은 공정 칼틀/param 또는 size.
  - **사이즈를 자재로 평면화 금지** — 사이즈 variant(M/L/XL)는 size 축(OM `티셔츠 size=0 material 평면화`).
  - **코팅·박 포일을 자재로 금지** — 코팅(Q9)·박(Q2)은 **공정**. 복합표기 `아트250+무광코팅`은 자재(아트250)+공정(무광코팅) 분해(OM `자재축에 공정 섞임`).
  - **라이브 실증 오염(`ref-materials.csv` 분포):** MAT_TYPE.09 파우치 75행·.10 악세사리 43행·.08 실사소재 22행에 색/형상/사이즈/구수가 자재로 적재된 흔적(`material-option-normalization`) — 이것이 교정 대상.
  - **두께는 소실시키지 말 것**(반대 오염, OM-4): 아크릴 22상품을 MAT_000192 단일로 평면화 = 두께(자재 식별자) drop. 1.5/3/8mm = MAT_000042/043/044 별 행.

## 4.2 권위 소스 (상품마스터 컬럼)

| 엑셀 컬럼 | → mat 처리 | 권위 |
|-----------|-----------|------|
| `종이`/`소재`(직접명: 아트지250·스노우지) | mat_cd 직접 매핑 + usage_cd | ✅ round-11(sticker/silsa 직접명 정상) |
| `*별도설정` | **자재 IMPORT 포인터**(빈값 아님) — 가격연동 출력소재 | ✅ `entity-semantic-model` §6, OM `*별도설정` |
| `두께`(아크릴) | 별 mat_cd(MAT_000042~044) | ✅ OM-4 |
| `본체색`(파우치) | 재질행 합성(자재 분기) | ✅ |
| `usage` 슬롯(표지/내지/면지) | `t_prd_product_materials.usage_cd`(USAGE.01~07) | ✅ Q4 |

## 4.3 인쇄도메인 판별 규칙 (모호 시)

- **"이것이 입고·재고되는 물리 재료인가?"** — Yes면 자재. No(공정·치수·색채널)면 다른 축.
- **자재 권위 = 항상 parent + usage_cd**(`schema-design-intent-map` §2.2). B 셋트상품(하드커버)도 sub_prd가 아니라 parent에 usage_cd로 자재 적재(sub_prd는 빈 껍데기, `process-recipe-tree` §4).
- **두께/색/사이즈 variant 분해(`entity-semantic-model` §2):** 두께→material(별 mat_cd)·색상→material(본체색 합성, 잉크색은 도수)·사이즈→size·표지타입→반제품 sub_prd. 복합(색×사이즈)=2차원 분리.
- **우드거치대 함정(Q13):** 가공 컬럼에 있어도 거치대=**자재**(공정 아님).

## 4.4 경쟁사 벤치마크

- **RedPrinting:** 자재=`pdt_mtrl_info`(표지)+`inner_pdt_mtrl_info`(내지) 코드 직접명, 두께=자재 코드 변형. 후니 mat_cd+usage_cd가 동등(`benchmark-competitors` §6/§7).
- **WowPress:** paperno 키. 비규격/색상은 별 축. 후니 mat_typ + 본체색 합성이 동등.
- **CIP4/JDF(보조):** Media 리소스(MediaType·Thickness·Dimension). **두께를 Media 속성으로 둠 → 후니 "두께=mat_cd 또는 mat.weight/depth" 정합**. 표준이 두께=자재 속성 검증(OM-4 교정 방향 지지).
- **흡수 판정:** 후니 자재 모델(MAT_TYPE 11 + usage_cd + 물성 + self-ref)은 RP/WP 6축을 흡수(`material-option-normalization`: 후니 5축 보유 + 1축 GAP). **결함은 모델 부재 아닌 오염 적재**(색/형상/사이즈가 자재로) — round-22 교정 핵심.

## 4.5 정규화 원칙

- **코드:** `MAT_NNNNNN` 순차(D1·라이브 MAX 000336, 신규 mint=000337~). 멱등 = (mat_nm) 또는 (mat_nm, mat_typ_cd). 같은 자재 재발급 금지.
- **본체색 합성 규칙:** 파우치 블랙/화이트 = mat_nm에 색 포함한 별 자재 행(과분할 금지 — 색만 다르고 동일 소재면 자재 variant). 잉크색은 절대 자재 아님.
- **FK:** mat_typ_cd→base_codes(MAT_TYPE) · upr_mat_cd self-ref · `t_prd_product_materials.mat_cd`(+usage_cd=ref_key2) · `t_prc_component_prices.mat_cd`.

## 4.6 적재 선후 의존

base_codes(MAT_TYPE·SEL_TYPE·USAGE) 다음, **상품·product_materials·component_prices보다 먼저**. self-ref(upr_mat_cd)는 부모 자재 선적재 후 자식.

---

# ⑤ 공정정보 축 — `t_proc_processes`

## 5.1 정의·경계

- **속하는 것:** **공정**(coating·binding·foil·emboss·cutting·sewing·perforation·attach 등) + **인쇄방식**(self-ref: `PROC_000001` 인쇄 부모 → UV/옵셋/디지털/실크/실사 자식) + **별색**(`PROC_000007` family) + **`prcs_dtl_opt`** JSON param(타공 구수·오시 줄수·봉제 유형·UV 변형 등). 라이브 실측: `PROC_000002` UV의 prcs_dtl_opt = `{"inputs":[{"key":"변형","type":"enum","values":["일반","배면양면","풀빼다","투명테두리","단면"]}]}`.
- **속하지 않는 것(오염 금지) — [HARD]:**
  - **공정 파라미터를 공정 행 분리로 비대화 금지**(OM-7/GAP-PARAM) — 타공 구수·오시 줄수·조각수·박 크기는 **1 공정행 + param**(`prcs_dtl_opt`), 구수마다 별 proc_cd 신설 금지.
  - **자재(거치대·종이)를 공정으로 금지** — Q13 우드거치대=자재.
  - **칼틀(물리 모양)을 공정 prcs_dtl_opt에 중복 금지** — 합판도무송은 siz_cd가 칼틀 식별자(Q7), 형상을 공정 param에 또 넣지 말 것.
  - **별색을 도수로 금지**(역방향, §3.1) — 별색은 공정.
  - **순수 공정 vs 자재동반:** 열재단·타공(bare-hole)은 자재 없는 순수 공정 — 자재 억지 부여 금지(`option-material-process-bundle`).

## 5.2 권위 소스 (상품마스터 컬럼)

| 엑셀 컬럼 | → proc 처리 | 권위 |
|-----------|------------|------|
| `코팅`(무광/유광) | PROC_000014~016 + 면 enum param | ✅ Q9(코팅=공정) |
| `박`(금/은/홀로 16종) | PROC_000033 family + 색상 param | ✅ Q2(박=공정) |
| `별색인쇄`(화이트/클리어/핑크/금/은) | PROC_000007 family(008~012), **clr_cd=NULL** | ✅ §3 |
| `제본사양>제본`(중철/무선/PUR/트윈링/떡) | PROC_000017 family(018~025) + 택일그룹 | ✅ `process-recipe-tree` §3 |
| `커팅`(완칼/반칼/도무송) | PROC_000053~055 + 모양/조각수 param | ✅ |
| `접지/오시/미싱/타공/봉제/부착` | 각 proc + param | ✅ B8 |
| `UV`(아크릴 변형) | PROC_000002 + 변형 enum param | ✅ OM-5 |
| `인쇄방식`(디지털/실사/UV) | PROC_000002~006(인쇄 자식, 1상품=1방식) | ✅ `process-recipe-tree` §1 |

## 5.3 인쇄도메인 판별 규칙 (모호 시)

- **"이것이 재료를 *변형/가공하는 행위*인가?"** — Yes면 공정. 행위의 *대상 재료*는 자재 축, 행위의 *수치*는 prcs_dtl_opt param.
- **1상품 = 1인쇄방식**(Decision 14 v3, PDF p3·p8) — 인쇄방식이 가능 후가공 부분집합을 게이팅(디지털=코팅·제본 / 실사=봉제·족자 / UV=레이저커팅·아크릴가공).
- **공정 순서 의존(PDF 17 Case):** 출력→(코팅)→재단→후가공→포장. 선행 완료 후 후행(오시→접지, UV출력→레이저커팅→아크릴가공). 위젯 캐스케이드 토대.
- **별색/박 화이트 구별:** UV flatbed 화이트(PROC_000002 `풀빼다`) ≠ 별색 화이트(PROC_000008). 인쇄방식이 UV면 변형 param, 디지털/실사면 별색 공정.
- **형상 귀속 분기(`schema-design-intent-map` §3.2):** 칼틀 물리존재 시 size(Q7), 규격형 반칼/완칼은 형상=공정 param. "형상은 무조건 공정" 일률규칙 틀림.

## 5.4 경쟁사 벤치마크

- **RedPrinting:** 후가공=PCS(`PCS_DTL_COD`+`QTY_INPUT_YN`+`SUB_MTRL_YN`), 캐스케이드 disable(`disable_pcs`). 후니 prcs_dtl_opt JSON이 PCS_DTL+메타 흡수(`benchmark-competitors` §5).
- **WowPress:** awkjob `namestep1/2`(2단계 하위옵션)+`req_joboption`+`rst_awkjob`(규격제약). 후니 JSON이 namestep 2단계 흡수.
- **CIP4/JDF(보조):** Process(Cutting/Folding/Stitching/...)별 리소스 + 파라미터 노드. **후니 proc + prcs_dtl_opt가 JDF Process+Parameter와 동형**. 표준이 "공정 1행+param" 모델(OM-7 교정 방향) 검증.
- **흡수 판정:** 후니 공정 모델(self-ref family + prcs_dtl_opt JSON)은 RP/WP/JDF를 **흡수·능가**(`benchmark-competitors` §9 한줄요약). **단 1가지 보강 — 캐스케이드 제약**(자재/사이즈→공정 disable, RP disable_pcs·WP rst_awkjob 둘 다 보유) = 후니 약점, `t_prd_product_constraints`(JSONLogic) 신설 권고.

## 5.5 정규화 원칙

- **코드:** `PROC_NNNNNN` 순차(라이브 MAX 000083). 멱등 = (proc_nm) 또는 (proc_nm, upr_proc_cd). **param 변동은 신규 proc 금지**(같은 공정행 prcs_dtl_opt 갱신).
- **self-ref family:** 별색(007→008~012)·박(033 family)·인쇄(001→002~006)·제본(017→018~025)은 부모 선적재 후 자식.
- **FK:** upr_proc_cd self-ref · `t_prd_product_processes.proc_cd`(+mand_proc_yn) · `dep_proc_cd`(자재의존 공정, SET NULL).
- **param 보존(미구현 GAP):** prcs_dtl_opt(JSON) 또는 신설 `ref_param_json`(OM-7) — dbm-ddl-proposer 결정.

## 5.6 적재 선후 의존

base_codes 다음. **self-ref 부모(인쇄/별색/박/제본 family head) → 자식 순.** 상품·product_processes·가격(후가공비 component)보다 먼저. 자재의존 공정(dep_proc_cd)은 자재 선적재 참조.

---

# ⑥ 카테고리 축 — `t_cat_categories`

## 6.1 정의·경계 (트리)

- **속하는 것:** **판매 분류 트리**(self-ref `upr_cat_cd`, `cat_lvl` 1~3). 고객 사이트 네비게이션·상품 그룹핑.
- **속하지 않는 것(오염 금지):**
  - **시트 `구분`(엽서/명함…)을 카테고리와 동일시 금지** — `구분`=시트 편의 그룹(행 그룹핑 키), 카테고리=판매 분류(별개, round-11 C1 함정).
  - **상품 속성(소재·공정)을 카테고리로 금지** — 카테고리는 분류 노드, 속성 아님.
  - **고아 카테고리 금지**(round-13 횡단 발견: 카테고리 고아) — 모든 cat은 트리에 연결.

## 6.2 권위 소스 (상품마스터 컬럼)

- 상품마스터에 명시적 카테고리 컬럼은 약함 — `구분`/상품군이 후보이나 판매 분류는 **라이브 `t_cat_categories` 306행 + `t_prd_product_categories`(main_cat_yn)**가 권위. 시트 `구분`은 매핑 힌트일 뿐 1:1 아님.

## 6.3 인쇄도메인 판별 규칙 (모호 시)

- **"이것이 고객이 메뉴에서 탐색하는 분류 노드인가?"** — Yes면 cat. 상품의 *제조 속성*이면 다른 축.
- **트리 레벨:** lvl1(대분류 인쇄/굿즈) → lvl2(엽서/명함/스티커) → lvl3(세부). 상품은 leaf cat에 `main_cat_yn='Y'`로 1개 주카테고리 + 보조.

## 6.4 경쟁사 벤치마크

- **RedPrinting/WowPress:** 카테고리=상품 catalog 분류(jobgroup/category). 후니 self-ref 트리가 동등.
- **CIP4/JDF(보조):** JDF는 카테고리 개념 없음(생산 표준) — 카테고리는 **커머스 축**(JDF 범위 밖). 후니 트리로 충분.
- **흡수 판정:** 표준 비교 무의미(생산 표준엔 없음). 후니 self-ref 트리 + main_cat_yn이 커머스 분류로 충분.

## 6.5 정규화 원칙

- **코드:** `CAT_NNNNNN` 순차. 멱등 = (cat_nm, upr_cat_cd) 경로 유일. 같은 경로 노드 재발급 금지.
- **FK:** upr_cat_cd self-ref(트리) · `t_prd_product_categories.cat_cd`(+main_cat_yn).

## 6.6 적재 선후 의존

base_codes 다음, **상품·product_categories보다 먼저.** self-ref 부모 노드(lvl1) → 자식(lvl2/3) 순. 고아 방지 위해 트리 완비 후 상품 연결.

---

# 6축 통합 적재 단계 순서 (FK 위상정렬)

```
[STAGE 0 — SEED 마스터 코드] (FK 위상의 뿌리·이미 적재)
  ① t_cod_base_codes (71)  ── 11 부모 그룹 → 47+ 자식 (self-ref 부모 먼저)
       │ (PRD_TYPE·MAT_TYPE·USAGE·OUTPUT_PAPER_TYPE·SEL_TYPE·QTY_UNIT·DSC_TYPE·FRM_TYPE·SEMI_ROLE·PRC_COMPONENT_TYPE·CUS_GRADE)
       ▼
[STAGE 1 — L1 마스터 축 (base_codes 의존, 상호 독립 → 병렬 가능)]
  ② t_siz_sizes (500)        ── OUTPUT_PAPER_TYPE 참조. 치수 중복 점검. CASCADE FK 대비 완비
  ③ t_clr_color_counts (5)   ── 완비(신규 없음)
  ④ t_mat_materials (336)    ── MAT_TYPE·SEL_TYPE·USAGE 참조. self-ref(upr_mat) 부모 먼저. 오염 교정(색/형상/사이즈 제거)
  ⑤ t_proc_processes (83)    ── self-ref family(인쇄/별색/박/제본 head) 먼저. dep_proc는 ④ 참조
  ⑥ t_cat_categories (306)   ── self-ref 트리(lvl1→2→3)
       │ ②③④⑤⑥ 전부 완비 후
       ▼
[STAGE 2 — 상품 core]
  t_prd_products (275)        ── prd_typ_cd·semi_role_cd·qty_unit·nonspec_* (base_codes 의존)
       │
       ▼
[STAGE 3 — 상품 ↔ 축 연결행 (L1 차원, 상품+마스터 둘 다 선존재 필요 → 병렬 가능)]
  t_prd_product_categories (cat_cd)      t_prd_product_sizes (siz_cd 완성품)
  t_prd_product_plate_sizes (siz_cd 판형) t_prd_product_materials (mat_cd+usage_cd)
  t_prd_product_print_options (clr_cd)   t_prd_product_processes (proc_cd+param)
  t_prd_product_page_rules · bundle_qtys · sets(반제품)
       │
       ▼
[STAGE 4 — CPQ 옵션 레이어 (L2, 연결행 polymorphic 포인터)]
  option_groups → options → option_items(ref_dim_cd→STAGE3 행) · templates · constraints(JSONLogic)
       │
       ▼
[STAGE 5 — 가격 엔진 (siz_cd CASCADE FK → ② 필수 선존재)]
  price_formulas → formula_components → price_components → component_prices(siz·clr·mat 차원)
  product_price_formulas(바인딩) · product_prices(직접단가) · t_dsc_*(할인)
```

> **위상 핵심:** ① 최상위 SEED → STAGE1 5축(②~⑥ 상호 독립, 단 각 self-ref는 부모 먼저) → STAGE2 상품 → STAGE3 연결행(상품+축 교차) → STAGE4 CPQ(연결행 포인터) → STAGE5 가격(siz CASCADE 의존). **STAGE를 건너뛰면 FK 위반**(특히 가격 component_prices.siz_cd CASCADE).

---

# 축 간 경계 충돌 케이스 표 (어느 축이 정답인가)

| 충돌 값 | 후보 축 | **정답 축 (정답 근거)** | 오모델 ID·확정도 |
|---------|---------|------------------------|------------------|
| **별색**(화이트/클리어/금/은) | 도수축 vs 공정축 | **공정축**(`PROC_000007` family, clr_cd=NULL). CMYK 외 별도 잉크는 공정 | OM-5 · ✅ |
| **형상**(원형/하트/도무송) | 자재축 vs 사이즈축 vs 공정축 | **칼틀 물리존재 시 사이즈축**(siz=칼틀 1:1, Q7) / **규격형은 공정 param**. "무조건 공정" 일률 틀림 | `schema-design-intent-map` §3.2 · ✅ |
| **색상**(카드봉투 화이트/블랙) | 사이즈축 vs 자재축 | **자재축**(본체색=재질행 합성) 또는 옵션 variant. siz_nm에 색 인코딩 금지 | OM-1 · ✅ |
| **본체색 vs 잉크색** | 자재축 vs 도수축 | **본체색=자재**(파우치 블랙=mat 분기) / **잉크색=도수 또는 별색 공정**(만년스탬프 7색=설계결정 컨펌) | §3.2 · 🟡 |
| **두께**(아크릴 1.5/3/8mm) | 자재축 vs 공정축 vs 무시 | **자재축**(별 mat_cd 000042~044). 단일 평면화로 두께 소실 금지 | OM-4 · ✅ |
| **코팅/박**(무광·금박) | 자재축 vs 공정축 | **공정축**(코팅 Q9·박 Q2). 복합표기 `아트250+무광코팅`=자재+공정 분해 | OM `자재축에 공정` · ✅ |
| **UV 변형**(배면양면/풀빼다) | 인쇄면(도수)축 vs 공정축 | **공정축**(`PROC_000002` 변형 param). print_side 오적재 금지 | OM-5 · ✅ |
| **판걸이수**(판수) | 사이즈축 vs DB미저장 | **DB 미저장 — 앱 런타임 계산**(임포지션). siz/가격 컬럼 매핑 금지, note 보존만 | round-11 C6 · ✅ |
| **출력판형**(국4절/전지) | 완성품 사이즈 vs 판형 | **판형축**(`t_prd_product_plate_sizes`, output_paper_typ_cd). 완성품 size와 별 연결축 | `platesize-is-output-paper` · ✅ |
| **수량**(10장/50장1권) | 사이즈축 vs 묶음수/주문수량 | **묶음수**(bundle_qtys) 또는 주문수량(min/max). siz_nm 인코딩 금지 | OM-1 · ✅ |
| **사이즈 variant**(M/L/XL·폰기종) | 자재축 vs 사이즈축 vs 옵션 | 치수형=**사이즈축** / 옵션형(폰기종)=**CPQ option**(ref_dim). material 평면화 금지. 기계적 size 삭제도 금지 | OM-2 · 🟡(컨펌) |
| **우드거치대** | 자재축 vs 공정축(가공컬럼 위치) | **자재축**(Q13, 가공컬럼에 있으나 자재) | Q13 · ✅ |
| **거치대/봉투 부속**(완제 add-on) | 자재축 vs 추가상품(template) | **추가상품 template**(완제 SKU) vs 자재(부착 부속) — usage·완제 여부로 분기 | §자재 vs addon · 🟡(PA-1 컨펌) |
| **시트 `구분`** | 카테고리축 vs 그룹핑 | **카테고리 아님**(시트 편의 그룹). 판매분류는 `t_cat_categories` 별도 | round-11 C1 · ✅ |
| **떡제본 page** | 페이지축 vs 묶음수축 | **묶음수**(권). page_rule 적재 금지(잡음) | `process-recipe-tree` §3 · ✅ |

---

# 컨펌 필요 항목 (🔴 미해소 — 엑셀 명시값/실무진 회신 대기)

| ID | 충돌 | 가설 | 출처 | 컨펌 질문 |
|----|------|------|------|-----------|
| **AX-1** | 잉크색(만년스탬프 7색) 귀속 | 별색 공정 vs 자유옵션 vs 도수 | `attribute-entity-map` §5·OM 본체색vs잉크색 | "만년스탬프 잉크색 7종은 도수(CMYK채널)인가, 별색공정인가, 자유선택옵션인가?" |
| **AX-2** | 굿즈파우치 size→option 재분류 | 치수형 22=size·옵션형 202=CPQ option | OM-2·round-10 | "사이즈등급(M/L)/폰기종을 size 행에서 CPQ option으로 옮길 때 적재된 size/price 사슬을 어떻게 보존하나?" |
| **AX-3** | 비규격 사이즈(실사) 좌표 vs 면적함수 | nonspec 범위=입력UX·가격=면적매트릭스 | OM-3·`schema-relationship-analysis` §5 | "실사/현수막 비규격 사이즈는 이산 면적매트릭스 셀(siz 다수 등록)인가 연속 nonspec 범위(앱 ceiling)인가?" |
| **AX-4** | 부자재 이중등록(악세사리 PA-1) | 자재(부착 부속)+template(완제 SKU) 양면 | round-11 PA-1 | "악세사리 부자재를 자재행과 추가상품 template에 둘 다 등록하나, 한 축으로 통일하나?" |
| **AX-5** | 공정 param 보존 메커니즘(OM-7) | prcs_dtl_opt(JSON) vs 신설 ref_param_json | OM-7·cpq-schema §4 | "타공 구수·오시 줄수 등 공정 param을 prcs_dtl_opt JSON으로 충분한가, 신규 컬럼이 필요한가?" |
| **AX-6** | 포토북 제본 PUR vs 레이플랫 | 후니 운영=PUR, 레이플랫=미운영 마스터 | `process-recipe-tree` §3.3 | "포토북 제본은 PUR인가 레이플랫(PROC_000025)인가? 025는 미운영 마스터인가?" |
| **AX-7** | 캐스케이드 제약(자재/사이즈→공정 disable) | 후니 약점, JSONLogic constraints 신설 | `benchmark-competitors` §9 | "RP disable_pcs·WP rst_awkjob 같은 무효조합 차단 데이터를 constraints에 신설할 것인가?" |

---

## Sources (표준 보조 — 기존 KB 인용, 신규 WebSearch 0)

본 문서는 6축 의미·오모델·경쟁사 패턴을 기존 KB에서 **인용·종합**했으며 신규 외부 리서치 0건이다(중복 금지 원칙). 표준 출처는 `entity-semantic-model.md §Sources`(제본 lay-flat/PUR·UV flatbed 화이트잉크·spot color 표준 12건)에 통합 기재됨. CIP4/JDF 대조는 도메인 원리 보강용 일반 지식 인용(Media/ColorantControl/Process 리소스 모델 — 후니 축과 동형 확인). 경쟁사 패턴 = `benchmark-competitors.md`(RedPrinting 역공학 `[RP-rev]`·WowPress API `[WP-doc]` 권위 인용).
