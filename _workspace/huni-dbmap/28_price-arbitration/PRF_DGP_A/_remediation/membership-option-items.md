# PRF_DGP_A — 멤버십 option_items 적재 설계안 (엽서 016)

> 작성 2026-06-14 · round-18+ Phase 6 정립 ⓑ단계 · 클래스 PRF_DGP_A(디지털인쇄 원자합산형A).
> 입력: [[mapping-integrity]] §2-3 · [[remediation-plan]] §1·§4 · 라이브 실측(읽기전용, 2026-06-14).
> C-2 = 가설 A 확정(option_items + OPT_REF_DIM.08). 권위 = 가격표/상품마스터 엑셀 + 스키마 설계의도.
> **DB 미적재 — 설계안(CSV/매핑표)까지. 실 적용은 인간 승인.**

---

## 0. 라이브 실측 요약 (좌우 코드 확정)

### 0-1. 엽서 016 = `PRD_000016` 프리미엄엽서 (PRD_TYPE.01)
- 동일 클래스 별색 보유 상품: PRD_000021 핑크별색엽서·PRD_000022 금은별색엽서 등(별색 §4 노트).

### 0-2. 옵션 그룹 (라이브 t_prd_product_option_groups, prd_cd=PRD_000016)
| opt_grp_cd | 그룹명 | sel_typ_cd | min/max | mand_yn | disp_seq |
|---|---|---|---|---|---|
| OPT_000005 | 인쇄 | SEL_TYPE.01 (택1) | 1/1 | Y | 1 |
| OPT_000006 | 종이 | SEL_TYPE.01 (택1) | 1/1 | Y | 2 |
| OPT_000007 | 모서리 | SEL_TYPE.01 (택1) | 0/1 | N | 3 |
| OPT_000008 | 후가공 | SEL_TYPE.02 (택N) | 0/4 | N | 4 |

→ **코팅 옵션그룹은 016에 미적재** (인쇄·종이·모서리·후가공 4그룹뿐). §3 참조.

### 0-3. 옵션값 (라이브 t_prd_product_options, prd_cd=PRD_000016) — opt_cd PK=(prd_cd,opt_cd)
| 그룹 | opt_cd | opt_nm | dflt | 기존 option_items ref(.??) |
|---|---|---|---|---|
| 인쇄 | OPV_000017 | 단면 | Y | .06 도수 ref_key1=1 |
| 인쇄 | OPV_000018 | 양면 | N | .06 도수 ref_key1=2 |
| 종이 | OPV_000019~039 (21개) | MAT_xxx | — | **.03 자재 MAT_xxx + USAGE.07** ✅이미 comp 연결 |
| 모서리 | OPV_000040 | 직각 | Y | .04 공정 PROC_000027 |
| 모서리 | OPV_000041 | 둥근 | N | .04 공정 PROC_000028 |
| 후가공 | OPV_000042 | 오시 | N | .04 공정 PROC_000029 |
| 후가공 | OPV_000043 | 미싱 | N | .04 공정 PROC_000030 |
| 후가공 | OPV_000044 | 가변텍스트 | N | .04 공정 PROC_000031 |
| 후가공 | OPV_000045 | 가변이미지 | N | .04 공정 PROC_000032 |

> 참고: 종이 그룹 opt_nm이 코드(MAT_xxx)로 적재된 별개 결함 존재(라벨 누락). 이번 멤버십 범위 밖 — §6 불일치 노트.

### 0-4. comp_cd (라이브 t_prc_price_components) — 확정값
| 용도 | comp_cd | comp_nm |
|---|---|---|
| 인쇄 단면 | `COMP_PRINT_DIGITAL_S1` | 디지털인쇄비(단면) |
| 인쇄 양면 | `COMP_PRINT_DIGITAL_S2` | 디지털인쇄비(양면) |
| 코팅 유광 | `COMP_COAT_GLOSSY` | 유광코팅비 |
| 코팅 무광 | `COMP_COAT_MATTE` | 무광코팅비 |
| 모서리 직각 | `COMP_PP_CORNER_RIGHT` | 모서리 직각 |
| 모서리 둥근 | `COMP_PP_CORNER_ROUND` | 모서리 둥근 |
| 오시 | `COMP_PP_CREASE_1L`/`_2L`/`_3L` | 오시 1/2/3줄 |
| 미싱 | `COMP_PP_PERF_1L`/`_2L`/`_3L` | 미싱 1/2/3줄 |
| 가변텍스트 | `COMP_PP_VARTEXT_1EA`/`_2EA`/`_3EA` | 가변텍스트 1/2/3개 |
| 가변이미지 | `COMP_PP_VARIMG_1EA`/`_2EA`/`_3EA` | 가변이미지 1/2/3개 |
| 용지 | `COMP_PAPER` | 용지비(종이별 절가) — ✅이미 .03 mat 차원 연결 |
| 별색(016 미보유) | `COMP_PRINT_SPOT_{CLEAR/GOLD/PINK/SILVER/WHITE}_{S1,S2}` | §4 노트 |

> **수량변형 발견**: 후가공 comp는 수량변형 분리(1L/2L/3L·1EA/2EA/3EA). 옵션값(OPV_000042~045)은 수량 무관 단일값 → 기본행(1L/1EA)으로 멤버십 표현, 2L/3L·2EA/3EA는 수량변형 2차 트랙([[remediation-plan]] §1 "_nL/_nEA 2차").

### 0-5. OPT_REF_DIM 신규 코드 (ddl-proposer 확정 대상)
- 라이브 패턴: `OPT_REF_DIM.01~.07` (upr_cod_cd=`OPT_REF_DIM`·disp_seq 1~7).
- 신규 = `OPT_REF_DIM.08`·cod_nm=**가격구성요소**(잠정)·upr_cod_cd=`OPT_REF_DIM`·disp_seq=8·use_yn=Y.
- ref_key1 페이로드 = comp_cd 문자열. **본 설계의 `[CONFIRM:REFDIM08]` = ddl-proposer 확정값**(아래 행 ref_dim_cd 열은 잠정 `OPT_REF_DIM.08` 표기, 확정 코드로 일괄 치환 가능).

---

## 1. 멤버십 매핑표 (옵션값 → comp_cd, 라이브 실측 좌우)

| 그룹(sel) | opt_cd | opt_nm | → 활성 comp_cd | 멤버십 유형 | 비고 |
|---|---|---|---|---|---|
| 인쇄(택1) | OPV_000017 | 단면 | COMP_PRINT_DIGITAL_S1 | 차원-단가+옵션-멤버십 | 단가 siz×clr×면수 차원 |
| 인쇄(택1) | OPV_000018 | 양면 | COMP_PRINT_DIGITAL_S2 | 차원-단가+옵션-멤버십 | |
| 종이(택1) | OPV_000019~039 | MAT_xxx | COMP_PAPER (via .03 mat 차원) | 차원=멤버십 일치 | **이미 연결됨 — 신규행 불요** |
| 모서리(택1) | OPV_000040 | 직각 | COMP_PP_CORNER_RIGHT | 순수 선택-멤버십 | 단가 0/고정·차원 NULL |
| 모서리(택1) | OPV_000041 | 둥근 | COMP_PP_CORNER_ROUND | 순수 선택-멤버십 | |
| 후가공(택N) | OPV_000042 | 오시 | COMP_PP_CREASE_1L | 순수 선택-멤버십 | 2L/3L=수량변형 2차 |
| 후가공(택N) | OPV_000043 | 미싱 | COMP_PP_PERF_1L | 순수 선택-멤버십 | |
| 후가공(택N) | OPV_000044 | 가변텍스트 | COMP_PP_VARTEXT_1EA | 순수 선택-멤버십 | |
| 후가공(택N) | OPV_000045 | 가변이미지 | COMP_PP_VARIMG_1EA | 순수 선택-멤버십 | |
| 코팅(택1) | — 미적재 — | — | (유광→GLOSSY / 무광→MATTE / 없음→∅) | — | §3 적재 필요 판단 |

**멤버십 행 수 = 8행** (인쇄2 + 모서리2 + 후가공4). 종이는 0행(이미 연결). 코팅은 그룹 미적재로 0행(§3).

---

## 2. option_items 적재 행 설계 (CSV)

기존 .03/.04/.06 행은 **불변**(차원/공정/도수 참조 유지). 멤버십은 **별도 item_seq=2** 신규 행으로 추가 — 한 옵션값이 (기존 차원/공정 의미) + (가격 comp 멤버십) 두 의미를 polymorphic 다중 item_seq로 보유([[dbmap-option-material-process-bundle]] 원칙과 동형: 한 옵션 다중 seq).

> ref_dim_cd 열 `OPT_REF_DIM.08` = 잠정. ddl-proposer 확정값으로 치환. ref_key1=comp_cd. ref_key2/qty=빈값(NULL). use_yn=Y, del_yn=N.

CSV: `_remediation/load/option_items-membership.csv` (아래 동일 내용)

```csv
prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn
PRD_000016,OPV_000017,2,OPT_REF_DIM.08,COMP_PRINT_DIGITAL_S1,,,Y,N
PRD_000016,OPV_000018,2,OPT_REF_DIM.08,COMP_PRINT_DIGITAL_S2,,,Y,N
PRD_000016,OPV_000040,2,OPT_REF_DIM.08,COMP_PP_CORNER_RIGHT,,,Y,N
PRD_000016,OPV_000041,2,OPT_REF_DIM.08,COMP_PP_CORNER_ROUND,,,Y,N
PRD_000016,OPV_000042,2,OPT_REF_DIM.08,COMP_PP_CREASE_1L,,,Y,N
PRD_000016,OPV_000043,2,OPT_REF_DIM.08,COMP_PP_PERF_1L,,,Y,N
PRD_000016,OPV_000044,2,OPT_REF_DIM.08,COMP_PP_VARTEXT_1EA,,,Y,N
PRD_000016,OPV_000045,2,OPT_REF_DIM.08,COMP_PP_VARIMG_1EA,,,Y,N
```

- **item_seq 결정**: 기존 행 전부 item_seq=1 → 멤버십은 item_seq=2 (PK=(prd_cd,opt_cd,item_seq) 충돌 없음).
- **종이(OPV_000019~039)**: 멤버십 행 추가하지 않음. 기존 .03 자재행이 COMP_PAPER mat 차원과 공유 = 멤버십 자동.
- **disp_seq**: option_items에 disp_seq 컬럼 없음(그룹/옵션 레벨에만 존재). 표시순서는 옵션값(t_prd_product_options.disp_seq=L1 컬럼순서)이 권위, item_seq는 참조 항목 순번.

---

## 3. 코팅 옵션그룹 — [CONFIRM:016-COATING] 해소 (라이브+엑셀 실측 2026-06-14)

### 3-1. 판정 = **016 미충족(코팅 미실재) / 클래스 부분 충족(2상품 실재)**

**권위순서: 상품마스터 엑셀(권위) → 라이브 실측.** 클래스 PRF_DGP_A 9상품 = PRD_000016/017/018/020/021/022/026/041/042 (formula 바인딩 t_prd_product_price_formulas 실측, `PRF_DGP_A`=디지털인쇄 원자합산형A 엽서·상품권·슬로건).

#### 엑셀 권위 (`24_master-extract-260610/digital-print-l1.csv` 컬럼29 `코팅(옵션)`)
| 상품 | 코팅(옵션) 셀값 | 판정 |
|---|---|---|
| **016 프리미엄엽서** | 전 행 공란 | **코팅 미실재** → 016 코팅 멤버십·그룹 불요 |
| **017 코팅엽서** | 무광코팅(단면)·무광코팅(양면)·유광코팅(단면)·유광코팅(양면) | **코팅 실재**(유광/무광 × 단/양면) |
| 018 스탠다드엽서 | 공란 | 미실재 |
| 020 화이트인쇄엽서 | 공란 | 미실재 |
| 021 핑크별색엽서 | 공란 | 미실재 |
| 022 금은별색엽서 | 공란 | 미실재 |
| **026 종이슬로건** | 무광코팅(양면)·유광코팅(양면) | **코팅 실재**(유광/무광, 양면만) |
| 041 스탠다드 쿠폰/상품권 | 공란 | 미실재 |
| 042 프리미엄 쿠폰/상품권 | 공란 | 미실재 |

#### 라이브 실측 (엑셀과 정합)
- 코팅 옵션그룹 적재 상품 = **PRD_000017(OPT_000011)·PRD_000026(OPT_000028) 2개뿐** → 엑셀 실재 2상품과 정확히 일치.
- 016은 코팅 그룹 미적재(그룹 4개=인쇄·종이·모서리·후가공) — 엑셀 공란과 정합. **016 코팅 그룹 신규 적재 불요.**
- COMP_COAT_GLOSSY/MATTE 단가행 = siz_cd × **coat_side_cnt** × min_qty 차원. coat_side_cnt=1(단면)·2(양면) 각 46행 완비.

**결론: `[CONFIRM:016-COATING]` = 016 미충족(억지 적재 금지). 클래스에서 017·026만 코팅 실재 → 그 2상품에 멤버십 적재.**

### 3-2. 017·026 코팅 옵션값·기존 option_items (라이브 실측)
| prd_cd | 그룹 | opt_cd | opt_nm | dflt | 기존 .04 공정 |
|---|---|---|---|---|---|
| PRD_000017 | OPT_000011 | OPV_000050 | 코팅없음 | Y | (없음) → ∅ |
| PRD_000017 | OPT_000011 | OPV_000051 | 유광 | N | PROC_000014 |
| PRD_000017 | OPT_000011 | OPV_000052 | 무광 | N | PROC_000015 |
| PRD_000026 | OPT_000028 | OPV_000087 | 코팅없음 | Y | (없음) → ∅ |
| PRD_000026 | OPT_000028 | OPV_000088 | 유광 | N | PROC_000014 |
| PRD_000026 | OPT_000028 | OPV_000089 | 무광 | N | PROC_000015 |

→ 016 인쇄·모서리와 **동형**: 기존 .04 공정행(item_seq=1) + 멤버십 .08(item_seq=2) 추가. "코팅없음"=option_items 행 없음=∅(합산 비포함, 이미 정답).

### 3-3. coat_side(단면/양면) 처리
- 엑셀은 코팅엽서에 단/양면 4조합 명시하나, **라이브 코팅 옵션값은 유광/무광만**(단/양면 분기 옵션값 없음).
- 단가행이 coat_side_cnt 차원(1·2) 보유 → **coat_side는 멤버십이 아니라 단가 차원**. 멤버십(.08)은 유광/무광 comp만 결정하고, coat_side_cnt는 엔진이 단가 조회 시 차원으로 매칭(인쇄 단/양면 선택 또는 별도 입력에서 파생). 인쇄·모서리 멤버십과 동일 원리(차원-단가는 불변).
- → 멤버십 행에 coat_side 분기 불요. ref_key1=comp_cd만(GLOSSY/MATTE). ([CONFIRM:COAT-SIDE] = 엔진이 coat_side_cnt를 인쇄 면수에서 파생하는지 vs 별도 코팅면수 입력인지는 D-1 변환표/엔진 명세 트랙에서 확정 — 멤버십 설계엔 영향 없음.)

### 3-4. 코팅 멤버십 행 설계 (017·026, CSV)
```csv
prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn
PRD_000017,OPV_000051,2,OPT_REF_DIM.08,COMP_COAT_GLOSSY,,,Y,N
PRD_000017,OPV_000052,2,OPT_REF_DIM.08,COMP_COAT_MATTE,,,Y,N
PRD_000026,OPV_000088,2,OPT_REF_DIM.08,COMP_COAT_GLOSSY,,,Y,N
PRD_000026,OPV_000089,2,OPT_REF_DIM.08,COMP_COAT_MATTE,,,Y,N
```
**코팅 멤버십 행 수 = 4행** (017 유광·무광 + 026 유광·무광). 코팅없음(OPV_000050/087)=행 없음. 016=0행(미실재). 단가행·comp 존재 라이브 검증 OK.

---

## 4. 별색 노트

- 016 프리미엄엽서는 별색 옵션 미보유 → `COMP_PRINT_SPOT_*` 멤버십 행 016에 적재하지 않음.
- 클래스 내 별색 보유 상품(PRD_000021 핑크별색·PRD_000022 금은별색·PRD_000020 화이트인쇄엽서 등) 적재 시 동형:
  - 별색(택1/택N) 옵션값 → `COMP_PRINT_SPOT_{색}_{S1/S2}` 멤버십(.08).
  - S1/S2는 인쇄 단/양면 선택과 연동 → 별색 comp도 면수 분기(라이브에 PINK_S1/S2·GOLD_S1/S2 등 면수쌍 완비 확인).
- 별색 멤버십은 본 016 파일럿 검증(8행) 후 클래스 확대 트랙에서 적재.

---

## 4-A. 클래스 동형 확대 판단 (코팅 기준)

| 상품 | 코팅 실재(엑셀) | 라이브 코팅그룹 | 동형 멤버십 적용 | 처리 구분 |
|---|---|---|---|---|
| 017 코팅엽서 | ✅ 유광/무광×단·양면 | ✅ OPT_000011 | ✅ 016 인쇄·모서리와 동형(.04 공정행 + .08 멤버십) | **동형 — 본 설계 4행에 포함** |
| 026 종이슬로건 | ✅ 유광/무광(양면) | ✅ OPT_000028 | ✅ 동형 | **동형 — 본 설계 4행에 포함** |
| 016·018·020·021·022·041·042 | ❌ 공란 | ❌ 미적재 | 불요(미실재) | **코팅 멤버십 불요** |

- **동형 적용 가능분 = 017·026** (코팅 옵션값 구조 동일: 코팅없음/유광/무광·기존 .04 PROC_000014/015). 멤버십은 ref_key1=COMP_COAT_GLOSSY/MATTE 동일 패턴 → 4행으로 일괄.
- **별도 처리 필요분 = 없음**(코팅 한정). 단 017은 엑셀상 단/양면 4조합이나 라이브 옵션값은 유광/무광 2값 → coat_side는 단가 차원 처리(§3-3), 멤버십 분기 불요 = 026과 완전 동형.
- 코팅 외 별색(021/022/020)은 §4 별색 트랙(comp 면수쌍 분기)으로 별도 — 본 코팅 확대와 무관.

---

## 5. 재검증 워크스루 (보정 하드코딩 없이 활성 comp 재현 — [[remediation-plan]] §4)

엔진(evaluate_price) 멤버십 알고리즘: *선택된 옵션값들의 option_items 중 ref_dim_cd=.08 행의 ref_key1을 활성 comp 집합에 합집합* + *종이 선택의 .03 mat이 COMP_PAPER 차원으로 자동 포함*.

### 시나리오: 단면 + 종이(MAT_000074) + 모서리 직각 + 후가공 오시
| 선택 옵션값 | .08 멤버십 행 | 활성 comp 기여 |
|---|---|---|
| OPV_000017 (단면) | COMP_PRINT_DIGITAL_S1 | COMP_PRINT_DIGITAL_S1 |
| OPV_000019 (MAT_000074) | (없음·.03 자동) | COMP_PAPER (mat_cd=MAT_000074 단가행) |
| OPV_000040 (직각) | COMP_PP_CORNER_RIGHT | COMP_PP_CORNER_RIGHT |
| OPV_000042 (오시) | COMP_PP_CREASE_1L | COMP_PP_CREASE_1L |

→ **활성 comp = {COMP_PRINT_DIGITAL_S1, COMP_PAPER, COMP_PP_CORNER_RIGHT, COMP_PP_CREASE_1L}** ✅
- 양면 미선택 → S2 미포함 ✅ (무차별 합산 0 — D-2 해소)
- 둥근 미선택 → CORNER_ROUND 미포함 ✅
- 미싱/가변 미선택 → PERF/VARTEXT/VARIMG 미포함 ✅
- 코팅 미적재 → 코팅 comp 미포함 ✅
- **`compute_corrected` 보정 하드코딩 없이 option_items .08 매핑만으로 재현** ✅ ([HARD] 충족)

### 시나리오(코팅): 017 코팅엽서 — 양면 + 종이 + 유광코팅
| 선택 옵션값 | .08 멤버십 행 | 활성 comp 기여 |
|---|---|---|
| 양면 | COMP_PRINT_DIGITAL_S2 | COMP_PRINT_DIGITAL_S2 |
| 종이(MAT_xxx) | (.03 자동) | COMP_PAPER |
| OPV_000051 (유광) | COMP_COAT_GLOSSY | COMP_COAT_GLOSSY (단가 coat_side_cnt=2 차원 매칭) |

→ **활성 comp = {S2, COMP_PAPER, COMP_COAT_GLOSSY}** ✅
- 무광 미선택 → COMP_COAT_MATTE 미포함 ✅
- 코팅없음 선택 시 → 코팅 .08 행 없음 = 코팅 comp 비포함 ✅
- coat_side_cnt=2(양면)는 단가 차원에서 매칭(멤버십 분기 없이 인쇄 양면 선택에서 파생/입력) ✅

### 검증 기준 충족
- [x] 택1/택N 선택 시 활성 comp = 그 선택 대응 comp만 (무차별 합산 0).
- [x] 보정 하드코딩 없이 option_items 매핑만으로 활성 comp 재현(인쇄·모서리·후가공·**코팅** 전부).
- [x] 코팅: 유광/무광 멤버십 분기·coat_side는 단가 차원(멤버십 무차별 합산 0).
- [ ] 재계산값=엑셀 known 합산 일치 → **D-1(작업사이즈→출력판형 변환) 적용 후** 검증(별도 트랙·단가행 siz_cd=출력판형 매칭 필요).
- 충족 시 D-2 RESOLVED → G-CALC 진입. D-1은 본 ⓑ 범위 밖(remediation §3.3).

---

## 6. 라이브와 불일치 발견분

| # | 발견 | 범위 |
|---|---|---|
| F-1 | 종이 그룹 옵션값 opt_nm이 코드 문자열(MAT_000074 등)로 적재 — 라벨 누락(사용자 화면에 코드 노출) | 멤버십 범위 밖·별개 결함(라벨 보정 트랙) |
| F-2 | ~~코팅 옵션그룹 016 미적재 — 제공 여부 미확인~~ → **해소**: 엑셀(권위)+라이브 실측, 016 코팅 공란=미실재(정합), 클래스 내 017·026만 실재. `[CONFIRM:016-COATING]`=016 미충족·억지 적재 안 함 | **RESOLVED**(§3) |
| F-5 | 017 엑셀은 단/양면 4조합이나 라이브 코팅 옵션값은 유광/무광 2값 → coat_side는 단가 차원 처리. 엔진이 coat_side_cnt를 인쇄면수에서 파생하는지/별도입력인지 미확정 | `[CONFIRM:COAT-SIDE]`(멤버십엔 무영향·D-1/엔진 명세) |
| F-3 | **트리거 fn_chk_opt_item_ref에 .08 분기 없음** — 현재 .08 행 INSERT 시 ELSE '미지원 ref_dim_cd' 예외 발생. **base_code 1행 추가만으로 적재 불가** — 트리거 함수에 .08 분기(`WHEN 'OPT_REF_DIM.08' THEN ... EXISTS(SELECT 1 FROM t_prc_price_components WHERE comp_cd=NEW.ref_key1)`) 추가 DDL 필수 | **ddl-proposer 필수**(remediation §3.1 보강) |
| F-4 | 후가공 comp 수량변형 분리(1L/2L/3L·1EA/2EA/3EA)인데 옵션값은 단일 → 멤버십은 기본행(1L/1EA)만, 수량변형은 2차 트랙 | remediation §1 명시분 재확인 |

---

## 7. 산출 경로·후속

- 본 문서: `28_price-arbitration/PRF_DGP_A/_remediation/membership-option-items.md`
- 적재 CSV: `28_price-arbitration/PRF_DGP_A/_remediation/load/option_items-membership.csv` (**12행** = 016 기본 8 + 017·026 코팅 4).
- **GAP→ddl-proposer**: F-3(트리거 .08 분기) + base_code OPT_REF_DIM.08 1행. base_code만으로 부족 명시.
- **CONFIRM**: `[CONFIRM:REFDIM08]`(.08 확정 코드) · ~~`[CONFIRM:016-COATING]`~~ **해소(§3)** · `[CONFIRM:COAT-SIDE]`(coat_side 파생방식·멤버십 무영향).
- 후속 ⓒ: D-1 출력판형 변환표 적용 후 G-CALC 재계산. 클래스 확대(별색 021/022/020 — comp 면수쌍).
- **DB 미적재 — 실 적용 인간 승인.**

### 멤버십 행 합계 (016 + 코팅)
| 구분 | 상품 | 행수 |
|---|---|---|
| 016 기본(인쇄2·모서리2·후가공4) | PRD_000016 | 8 |
| 코팅(유광·무광) | PRD_000017·PRD_000026 | 4 |
| **합계** | | **12** |
