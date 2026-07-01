# design-cardfoil-260701 — 실무진 추가 옵션(코팅/모서리/가변/접지) 가격0 배선 설계

대상: PRD_000024 포토카드 · PRD_000025 투명포토카드 · PRD_000030 지그재그엽서 · PRD_000031 프리미엄명함
입력: `staff-edit-scan-260701.json` B_unpriced_option_refs / C_missing_dim_wiring
권위: 인쇄상품 가격표 260527 · 상품마스터 260610 · pricing.py(엔진 계약)
상태: **DRY-RUN까지. 실 COMMIT 금지(인간 승인 후).**

## 0. 근본원인 (한 줄)
"참조 공정에 단가행이 없다"는 진단은 **오진**. 단가행은 **전용 후가공 컴포넌트에 이미 적재**돼 있고
그 컴포넌트가 **해당 상품 공식에 미배선(고아)**이라 가격0. 명함 교훈 [[namecard-orphan-component-wiring-260630]] 동일 패턴.

## 1. 공정 실명(라이브 t_proc_processes)
| proc_cd | proc_nm | 성격 | 단가행 소재(search-before-mint) |
|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | 코팅 | COMP_COAT_GLOSSY (138행·.01·plt_siz+판수) |
| PROC_000015 | 무광라미네이팅 | 코팅 | COMP_COAT_MATTE (138행·.01·plt_siz+판수) |
| PROC_000027 | 직각(모서리) | 후가공 | COMP_PP_CORNER_RIGHT (직각=0원) |
| PROC_000028 | 둥근(모서리) | 후가공 | COMP_PP_CORNER_RIGHT (둥근 tier 2000@100…11000@1000) |
| PROC_000031 | 가변텍스트 | 후가공 | COMP_PP_VARTEXT_1EA (.03·dim_vals={"개수":N}) |
| PROC_000032 | 가변이미지 | 후가공 | COMP_PP_VARIMG_1EA (.03·dim_vals={"개수":N}) |
| PROC_000073 | 6단오시접지 | 접지 | COMP_FOLD_CARD_6CR (이미 배선·48행 min_qty) |
| PROC_000074 | 6단미싱접지 | 접지 | COMP_FOLD_CARD_6CR (동일) |

> ※ del_yn=Y 중복본(COMP_PP_CORNER_ROUND, VARTEXT/VARIMG_2EA/3EA) 존재 → **활성 canonical만** 재사용.

## 2. 상품별 판정·설계

### PRD_000031 프리미엄명함 — 배선(핵심)
현 바인딩 PRF_NAMECARD_PREMIUM(4comp) + PRF_NAMECARD_PREMIUM_FOIL(7comp). 베이스라인 실측:
base(단면A·qty100)=4,500 / +둥근 delta=0 / +가변텍스트 delta=0 → **미배선 확정**.

- **가변텍스트/가변이미지 [GO-READY]**: COMP_PP_VARTEXT_1EA·COMP_PP_VARIMG_1EA = **PRICE_TYPE.03(고정·수량무관)**
  → 이중과금 없음. 양 공식(NORMAL+FOIL)에 배선. dim_vals `{"개수":N}` → 옵션이 개수 detail 전달(기본1).
- **모서리 직각/둥근 [CONFIRM]**: COMP_PP_CORNER_RIGHT는 **prc_typ=PRICE_TYPE.01(단가형)** →
  엔진이 tier총액 × **주문수량** 곱 = 이중과금. **★형제 실측 증명**: 엽서 둥근@100 = 200,000원(=2000×100),
  @1000 = 11,000,000원(=11000×1000). 기대값은 각 2,000 / 11,000. 즉 **공유 컴포넌트에 이미 잠재 과대청구 버그**
  (COMP_CUT_FULL_DIECUT .01×판수 버그 계열 [[digital-print-base-proc-missing-260701]]). **배선 전 .01→.03 교정 필수**
  (교정 시 형제 PRF_DGP_A/PRF_DGP_D 과대청구도 동시 해소 = 순효과 긍정, 그러나 공유변경 → CONFIRM).

### PRD_000024 포토카드 · PRD_000025 투명포토카드 — [CONFIRM·제외]
세트고정가 모델(PRICE_TYPE.02·siz_cd·20장세트·판수 개념 부재).
- **코팅**: COMP_COAT_*(.01·plt_siz+판수)는 세트모델에 판수 환산 불가 → **세트단위 .03 정액표 신설** 또는
  권위 엑셀 세트 코팅단가 확인 필요. 판형 매핑(SIZ_000499/522)은 output-paper용이지 세트가 판수 아님.
- **모서리**: BLOCK B 코너 .03 교정 후 배선 가능하나 세트수량(qty=20)↔코너 tier(1/100/…) 정합 확인.
- **종이(아트지300g/PET)**: 세트가격이 mat_cd로 분기 안 됨(opt_grp:OPT_000084 = **'제작방식'**, 종이 아님)
  → C_missing_dim_wiring "mat_cd 미배선"은 세트모델상 설계상 정상. 종이별 가격차 유무를 권위에서 확인,
  차이 없으면 무료선택(무배선), 있으면 종이축 신설. **추측 적재 금지 → CONFIRM.**

### PRD_000030 지그재그엽서 접지 — [위양성·NO-OP]
COMP_FOLD_CARD_6CR가 PRF_DGP_C_6CR에 **이미 배선+발현**(실측 30,000@100·75,000@500). 6단미싱/오시는
fold비 동일(proc 무관·min_qty). B_unpriced 플래그는 옵션 proc_cd에 직접 단가행이 없다는 것일 뿐, fold비가
min_qty 컴포넌트로 이미 가격됨. **배선 불필요.**
- **CONFIRM(비금액)**: 옵션 라벨 스왑 — 스캔 "6단미싱접지→PROC_000073" 이나 DB PROC_000073 = '6단오시접지'.
  6단미싱접지는 PROC_000074가 맞음. 라벨/ref 교정 별건.
- 인접(범위 외): 지그재그 디지털인쇄비=0(matched False) = base-proc 미바인딩 계열 [[digital-print-base-proc-missing-260701]].

## 3. 이중과금/오배선 위험 점검
| 배선 | prc_typ | 공유공식 | 위험 | 판정 |
|---|---|---|---|---|
| VARTEXT/VARIMG_1EA → 명함 | .03 고정 | (신규만) | 없음 | GO-READY |
| CORNER_RIGHT → 명함 | .01→**.03** 필요 | PRF_DGP_A/D 공유 | .01 방치 시 ×수량 과대 | CONFIRM(교정 선행) |
| COAT → 포토카드 | .01 plt기반 | — | 세트=판수부재 환산불가 | CONFIRM(제외) |

## 4. 산출·dryrun 실측
- `cardfoil-fix-dryrun.sql`: BEGIN…ROLLBACK. **실행 검증 완료**(INSERT 4[BlockA]+2[BlockB], UPDATE 1[코너 .03], 코너 .03 반영 확인, ROLLBACK).
- `cardfoil-backup-260701.csv`: 대상 formula_components(4공식+형제 DGP_A/D) + 컴포넌트 prc_typ 스냅샷.
- `cardfoil-undo.sql`: 배선 6행 삭제(+코너 .03 원복은 전면롤백 시만·형제 버그 부활 주의).

## 5. COMMIT 후 시뮬 기대치 (★procs = dict 리스트 `[{"proc_cd":"PROC_00xxxx"}]`)
프리미엄명함 단면A·qty=100 base=4,500 기준:
- `procs=[{"proc_cd":"PROC_000031","개수":1}]` 가변텍스트 → **19,500** (4,500+15,000)
- `procs=[{"proc_cd":"PROC_000032","개수":1}]` 가변이미지 → **19,500**
- `procs=[{"proc_cd":"PROC_000028"}]` 둥근(.03 교정 후) → **6,500** (4,500+2,000)
- `procs=[{"proc_cd":"PROC_000027"}]` 직각 → **4,500** (0원)
- 가변텍스트+둥근 → **21,500**
> DRY-RUN(BEGIN…ROLLBACK)은 별 커넥션 sim에 안 보이므로 위는 단가행 기반 해석값. 실 COMMIT 후 sim 재확인 필수.

## 6. 인간 컨펌 큐
1. **[돈-크리티컬] 코너 COMP_PP_CORNER_RIGHT .01→.03 공유 교정 승인?** (형제 PRF_DGP_A/D 과대청구도 동시 해소)
2. 포토카드/투명포토카드 코팅 = 세트 .03 정액표 신설 vs 권위 엑셀 코팅단가 — 방향?
3. 포토카드 종이(아트지/PET) 가격차 유무(권위) — 무료선택 vs 종이축 신설?
4. 지그재그 옵션 라벨 미싱↔오시 스왑 교정(별건).
