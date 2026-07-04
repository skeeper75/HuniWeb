# 가격구성요소(comp) 병합 후보 보드 — 진단 전용

> **산출:** `_workspace/_foundation/batch/component_merge_scan.py` (결정론·토큰0·재실행 가능)
> **데이터(읽기전용):** `_workspace/_foundation/live-snapshot/latest/t_prc_price_components.csv`(183) · `t_prc_formula_components.csv`(249) · `t_prc_component_prices.csv`(22,995) · 스냅샷 2026-07-02 11:19
> **판정 [HARD]:** memory `price-component-unify-vs-split-criterion-260630` — 한 상품 안 손님선택(도수·수량·판형·인쇄면·소재) → 차원 통합(병합) / 종류·상품 자체가 다름(제본종류 proc_cd·별색 clr_cd) → 별도 comp 유지(병합 금지, 격자 verbatim 동일 시만 유형 B).
> **범위:** 이번은 **진단 보드만**. 실 병합·재배선·적재는 하지 않음(다음 단계·인간 승인). DB 쓰기 0.
> **날조 0:** comp_cd·unit_price 전부 CSV verbatim. 추정은 "(추정)" 표기.

---

## 0. 요약

| 지표 | 값 |
|---|---|
| 전체 comp | 183 |
| 활성(use_yn=Y) | 158 |
| 은퇴(use_yn=N) | 25 |
| 다중-멤버 클러스터((배선공식집합, use_dims) 동일) | 21 |
| **유형 A 병합 후보(pending)** | **9군 (27 comp → 9 comp, −18)** |
| 유형 B 동형결합 dedup(활성) | 0 |
| 정당 분리(병합 금지) | 7군 |
| 비-sibling 조대키 아티팩트(후보 아님) | 5 |

**상품군별 유형 A 분포:** 명함 8군(STD·COAT·PEARL·SHAPE·MINISHAPE·PREMIUM·FOIL·WHITE) + 엽서북 1군(PCB). **전 유형 A = 엔진코드변경 불요**(분리축이 이미 comp의 `use_dims`에 등재 + 단가행에 값 충전 → evaluate_price가 이미 행매칭). silent 이중합산 위험 = **전건 저**(분리축이 인쇄면/페이지/소재로 행이 상호배타 매칭 → 한 주문에 한 행만 기여).

**완료 선례(은퇴 25건 중):**
- 별색인쇄비 **9 comp**(CLEAR/GOLD/PINK/SILVER 各 단·양면 + WHITE 양면)이 활성 정본 `COMP_PRINT_SPOT_WHITE_S1`(clr_cd·print_opt_cd 차원화)으로 **통합 완료** = 유형-A식 축 차원화의 선례.
- 포스터 **6 레거시**(ADH_WATERPROOF_PVC·ARTFABRIC·LEATHER_ARTPRINT·MESH_PRINT·TYVEK_PRINT·WATERPROOF_PET)가 정본으로 **동형결합 dedup 완료**(round-23) = 유형 B 선례.

---

## 1. 유형 A 병합 후보 보드 (pending)

**정본명 규칙:** 분리축 접미사(_S1/_S2·_20P/_30P·_STD/_HOLO·_CL/_NOCL·_MGA/_MGB·_S1W) 제거한 base 이름.
**분리축 코드 판독(evidence):** POPT_000001=단면 · POPT_000002=양면 / OPV_000491=20p·OPV_000492=30p(엽서북) / OPV_000487=일반박·OPV_000488=홀로그램·트윙클(박명함) / OPV_000489=무코팅·OPV_000490=코팅(화이트명함) / MGA·MGB=프리미엄 종이그룹 A/B.

| 후보군ID | 상품군/시트 | 병합대상 comp들 | 분리축(차원컬럼) | use_dims | 배선공식(PRF) | 유형 | 엔진코드변경 | silent 이중합산위험 | 권장 정본명 | 재배선 규모 |
|---|---|---|---|---|---|---|---|---|---|---|
| MC-01 | 명함/엽서북 시트 · 엽서북 | COMP_PCB_S1_20P · S1_30P · S2_20P · S2_30P | print_opt_cd(면) + opt_cd(페이지 20p/30p) | siz_cd,min_qty,print_opt_cd,opt_cd | PRF_PCB_FIXED | A | 불요(축 use_dims 기존재) | 저 (면·페이지로 행 상호배타·격자충돌 없음) | COMP_PCB | fc 4→1 · 단가행 468 이관 |
| MC-02 | 명함 · 프리미엄명함 | COMP_NAMECARD_PREMIUM_S1_MGA · S1_MGB · S2_MGA · S2_MGB | print_opt_cd(면) + mat_cd(종이그룹 A/B, 값 disjoint) | mat_cd,min_qty,print_opt_cd | PRF_NAMECARD_PREMIUM · _FOIL | A | 불요 | 저 (mat_cd·면 disjoint 타일링·충돌 없음) | COMP_NAMECARD_PREMIUM | fc 8→2 · 단가행 28 이관 |
| MC-03 | 명함 · 오리지널박명함 | COMP_NAMECARD_FOIL_S1_STD · S1_HOLO · S2_STD · S2_HOLO | print_opt_cd(면) + opt_cd(박종류 일반/홀로) | min_qty,opt_cd,print_opt_cd | PRF_NAMECARD_FOIL | A | 불요 | 저 | COMP_NAMECARD_FOIL | fc 4→1 · 단가행 36 이관 |
| MC-04 | 명함 · 화이트인쇄명함 | COMP_NAMECARD_WHITE_S1W_CL · S1W_NOCL · S2W_CL · S2W_NOCL | print_opt_cd(면) + opt_cd(코팅유무) | min_qty,opt_cd,print_opt_cd | PRF_NAMECARD_WHITE | A | 불요 | 저 | COMP_NAMECARD_WHITE | fc 4→1 · 단가행 4 이관 |
| MC-05 | 명함 · 스탠다드명함 | COMP_NAMECARD_STD_S1 · S2 | print_opt_cd(단면3500/양면4500) | mat_cd,min_qty,print_opt_cd | PRF_NAMECARD_FIXED · _FOIL | A | 불요 | 저 | COMP_NAMECARD_STD | fc 4→2 · 단가행 10 이관 |
| MC-06 | 명함 · 코팅명함 | COMP_NAMECARD_COAT_S1 · S2 | print_opt_cd(면) | mat_cd,min_qty,print_opt_cd | PRF_NAMECARD_COAT | A | 불요 | 저 | COMP_NAMECARD_COAT | fc 2→1 · 단가행 4 이관 |
| MC-07 | 명함 · 펄명함(스타드림) | COMP_NAMECARD_PEARL_S1 · S2 | print_opt_cd(면) | mat_cd,min_qty,print_opt_cd | PRF_NAMECARD_PEARL · _FOIL | A | 불요 | 저 | COMP_NAMECARD_PEARL | fc 4→2 · 단가행 8 이관 |
| MC-08 | 명함 · 모양명함 | COMP_NAMECARD_SHAPE_S1 · S2 | print_opt_cd(면) | siz_cd,min_qty,print_opt_cd | PRF_NAMECARD_SHAPE | A | 불요 | 저 | COMP_NAMECARD_SHAPE | fc 2→1 · 단가행 2 이관 |
| MC-09 | 명함 · 미니모양명함 | COMP_NAMECARD_MINISHAPE_S1 · S2 | print_opt_cd(면) | siz_cd,min_qty,print_opt_cd | PRF_NAMECARD_MINISHAPE | A | 불요 | 저 | COMP_NAMECARD_MINISHAPE | fc 2→1 · 단가행 2 이관 |

**합계:** 27 comp → 9 comp(−18) · formula_components 34행 → 12행 · 단가행 재comp_cd 562건.

### 유형 A 판정 근거(공통)
- 클러스터 키 = (배선 공식집합, use_dims 실차원)이 이미 **상품 종류를 분리**한다(STD=`PRF_NAMECARD_FIXED`, COAT=`PRF_NAMECARD_COAT`는 서로 다른 클러스터 → 절대 병합 대상에 안 섞임). 따라서 클러스터 **내부** disjoint 축은 구조상 '한 상품 안 손님선택 축'.
- 각 후보는 분리축이 **정본 상품축**(print_opt_cd/mat_cd/siz_cd) 포함 + 멤버가 분리축 공간을 **고유 타일링**(중복 좌표 0) + 합쳐진 격자 **unit_price 충돌 0**.
- **엔진코드변경 불요 근거:** 분리축이 이미 `use_dims`에 있고 단가행 컬럼에 값이 충전됨(예 STD_S1 rows `print_opt_cd=POPT_000001`, STD_S2 `=POPT_000002`). 병합=단가행 comp_cd 재지정 + formula_components 중복행 정리뿐. 엔진 `NON_QTY_DIMS`/매칭 로직 변경 불필요.
- **silent 이중합산 위험 저 근거:** 현재도 한 공식이 S1·S2를 둘 다 배선하나, 단면 주문은 S1 행(POPT_000001)만 매칭·S2는 POPT_000002 행뿐이라 0 기여(상호배타). 병합 후 1 comp가 올바른 행 1개 매칭 → 결과 불변(가격 무영향·정리 이득).

### 유형 A verbatim 단가 증거(발췌)
- COMP_NAMECARD_STD_S1 `POPT_000001,MAT_000074 = 3500.00` / STD_S2 `POPT_000002,MAT_000074 = 4500.00`(단면<양면·면이 가격축).
- COMP_NAMECARD_WHITE_S1W_CL `POPT_000001,OPV_000490 = 16000.00`(코팅) / S1W_NOCL `OPV_000489 = 14500.00`(무코팅) — 코팅유무=opt_cd 가격축.
- COMP_NAMECARD_FOIL_S1_STD `OPV_000487 = 19200/24800/30400…`(일반박·min_qty 구간).
- COMP_PCB_S1_20P `POPT_000001,OPV_000491,SIZ_000003`(20p 단면) vs S2_30P `POPT_000002,OPV_000492`(30p 양면) — siz_cd·min_qty 격자 공유, 면·페이지만 disjoint.

---

## 2. 유형 B 동형결합 dedup 후보

- **활성 comp 중 격자 verbatim 동일 클러스터: 0건.** (활성에는 완전 중복 comp 없음.)
- **완료 선례(은퇴):** 포스터 6 레거시 comp가 정본(ARTPRINT_PHOTO·CANVAS_FABRIC 계열)으로 round-23 동형결합 dedup 완료 → use_yn=N. 재작업 불필요.

---

## 3. 정당 분리 목록 (병합 금지·[HARD] 기준 증빙)

| 군 | 멤버 | 분리축 | 병합 금지 근거 |
|---|---|---|---|
| 접지리플렛 접지비 | COMP_FOLD_LEAF_3FOLD · 4ACC · 4GATE · HALF | proc_cd | 접지종류(반접지/3단/4단아코디언/4단게이트) = 서로 다른 공정. proc_cd 축 분리·격자 상이 → 별도 유지. |
| 명함박 박가공비(대) | COMP_FOIL_PROC_LARGE_STD · SPECIAL | proc_cd | 박종류(일반박 vs 특수박) 공정 상이. §18 박류 설계 의도(SETUP_L/S + PROC_L/S). |
| 명함박 박가공비(소) | COMP_FOIL_PROC_SMALL_STD · SPECIAL | proc_cd | 동상. |
| 메쉬현수막 추가옵션 | COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4 · STRING_4 | opt_cd | 큐방 vs 끈 = 서로 다른 부자재(정본 상품축 없음·공유 상품격자 없음). 서로 다른 addon 품목 → 별도. |
| 아크릴키링 / 볼체인 | COMP_ACRYL_KEYRING · _BALLCHAIN | opt_cd | 기본키링 vs 볼체인 addon. opt_cd 값영역 상이(키링 크기변이 vs 볼체인). 서로 다른 addon 품목 → 별도(memory 굿즈 addon 배선). |
| 메쉬현수막 타공 | COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4 · 6 · 8 | (미인코딩) | 타공개수 4/6/8이 어느 차원컬럼에도 없음(proc_cd 동일·comp 정체로만 구분). 병합하려면 '타공수' 축 신설 필요 → **REVIEW**(엔진변경 요). 현 상태 별도 유지. |
| PET배너 거치대 | COMP_POSTEROPT_PET_BANNER_STAND_IN · OUT_S1 · OUT_S2 | (혼재) | 실내/실외 거치대 = 서로 다른 품목. OUT_S1/S2(단·양면용)만 부분 병합 여지 있으나 IN 이질 → **REVIEW**·수동 판정. |

> **[HARD] 가드 원리:** 분리축이 proc_cd(제본·접지·박가공 종류)·clr_cd(별색 색상)이면 "종류 자체가 다름" → 병합 금지(격자 verbatim 동일 시에만 유형 B). opt_cd만 분리 + 정본 상품축(print_opt_cd/mat_cd/siz_cd) 없음 + 공유 상품격자 없음이면 서로 다른 addon 품목 → 별도 유지.

### 비-sibling 조대키 아티팩트 (후보 아님·참고)
(배선공식·use_dims는 같으나 comp_cd 공통접두가 'COMP'/'COMP_PP'로 과도 일반 = 이질 comp 우연 동거. 서로 변이 아님.)
- n=12 (frm=[], proc_cd+min_qty): COMP_BIND_CAL_DESK130/220/MINI·HC_MUSEON·SSABARI·PP_CORNER_ROUND·PP_CREASE_2L/3L·PP_VARIMG/VARTEXT_2/3EA — 전부 다른 후가공.
- n=7 (PRF_POSTER_BANNER_N, opt_cd): 일반현수막 addon(끈·큐방·각목·봉미싱·열재단·양면테잎) — 전부 다른 addon.
- n=3 (frm=[], min_qty): CUT_FULL_PERF_1H6·2H6 + BANNER_MESH_PROC_OPT(빈 더미).
- n=2×2 (COMP_PP, proc_cd): CREASE_1L/PERF_1L(오시vs미싱) · VARIMG_1EA/VARTEXT_1EA(가변이미지vs텍스트).

---

## 4. 은퇴(use_yn=N) 25건 — 완료/레거시 별도집계

- **별색인쇄비 통합 완료(9):** COMP_PRINT_SPOT_CLEAR/GOLD/PINK/SILVER _S1·_S2 + WHITE_S2 → 정본 `COMP_PRINT_SPOT_WHITE_S1`(5별색×단·양면 통합·clr_cd+print_opt_cd 차원화). 유형-A식 완료 선례.
- **포스터 동형결합 dedup 완료(6):** ADH_WATERPROOF_PVC·ARTFABRIC_GRAPHIC·LEATHER_ARTPRINT·MESH_PRINT·TYVEK_PRINT·WATERPROOF_PET. 유형 B 완료 선례.
- **기타 은퇴(10):** FOAMBOARD_BLACK/WHITE·FOMEXBOARD_WHITE3MM/5MM(폼/포맥스 재모델)·PP_PERF_2L/3L(미싱)·FOLD_CARD_3H·PUNCH_6/8(일반현수막)·POPT_BNR_GAKMOK_STR_900_4(빈 더미). 후보에서 제외(완료·잔재).

---

## 5. 다음 단계(이 보드 밖·인간 승인)
1. **MC-01(PCB)·MC-03(FOIL)** 우선 파일럿(단가행 이관 최다·다축 타일링 대표). 병합 = ① 단가행 comp_cd → 정본명 재지정, ② formula_components 중복행 정리(1행/공식), ③ 정본 comp use_dims·comp_nm 정리(§34 표준안 채택).
2. 병합 후 evaluate_price 골든 재현 = 병합 전과 verbatim 동일(가격 무영향) 검증. 이중합산 0 재확인.
3. 정당분리 REVIEW 2건(MESH_PUNCH·PET_STAND)은 도메인 확정 후 별도 처리(타공수 축 신설 여부).
