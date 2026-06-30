# 게이트 — 화이트인쇄명함 PRD_000040 별색 flat 교정 설계 (E1~E7 독립 재검증)

검증가 hpe-validator(Claude) · 2026-07-01 · 라이브 읽기전용(snap_20260701_0305)·DB 쓰기 0·생성자 주장 비신뢰·직접 재실측
대상: `design-whitenamecard-flat-260701.md` + `design-whitenamecard-flat-dryrun.sql` (진단 `diag-whitenamecard-belsaek-260701.md`)
엔진: `raw/webadmin/webadmin/catalog/pricing.py`(958행) 정독 + 동치 재구현 골든 재계산

## 종합 = GO (조건부 — C1·C6 위젯/CONFIRM 잔여, COMMIT 승인 가능)

전 7게이트 PASS. 단일 FAIL 없음. 데이터/모델 교정으로 골든 4건 허용오차 0 재현. 실 COMMIT = 인간 승인 후 §7 dbmap(아래 잔여 컨펌 첨부).

---

## E1 공식 추출 충실성 — PASS
- `t_prc_price_formulas`에 `PRF_NAMECARD_WHITE` **미존재** 실측 확인 → mint 정당(grep 0건).
- 권위 추출 `digital-print-l1.csv` 153~156행: 화이트인쇄명함=**별색명함** 모델·큐리어스스킨(블랙/레드/바이올렛/다크블루)·**화이트인쇄(단/양)×클리어(없음/단/양)** 축. 설계의 "코팅 부활 금지·클리어=별색"이 권위 정합(셀 재대조).
- flat comp 4종 정의 실측: PRC_COMPONENT_TYPE.06·PRICE_TYPE.02·use_dims=`[mat_cd,min_qty,print_opt_cd]`(현). comp_nm에 "코팅" 표기 잔존=cosmetic(C6, 가격 무영향).

## E2 구성요소 분해 정합 — PASS
- 단가행 3343~3346 실측: mat_cd=MAT_000137·**opt_cd 비어있음**·min_qty=100·14500/16000/16000/19000·print_opt POPT_000001/002. note가 "클리어(없음/단/양)"으로 NOCL/CL 의미축 정확.
- 시트 차원경계 안: 단/양면(print_opt)×클리어(opt_cd)×수량(min_qty) = 별색명함 시트 SOT 정합. silent 합산 오배선 없음.
- ★opt_cd NULL(현) = NOCL/CL이 단면주문에 **동시매칭** ambiguous 위험 실재 → 설계의 opt_cd 충전 **필연성 실증**(재계산 모드C에서 30,500 이중합산 재현).

## E3 경쟁사 흡수 타당성 — PASS
- 클리어=별색(RedPrinting BCSPWHT 흰색0 선례·상품마스터 별색명함). 답습 아님·naming/codes 유입 0. 후니 t_prc_* opt_grp 택1 표현력으로 담김.

## E4 엔진 설계 건전성 — PASS (037 박명함 동형 확증)
- 037(오리지널박명함) 실측: PRF_NAMECARD_FOIL 전용 flat·print_options 2건·opt_grp **OPT_000080 "박종류"(SEL_TYPE.01·min1·max1·mand_yn=Y)**·comp use_dims=`[print_opt_cd,opt_cd,min_qty,opt_grp:OPT_000080]`·PRICE_TYPE.02 → 설계 040 구조와 **정확 미러**.
- 엔진 계약 정독: `_row_matches`(94-106)는 **행 저장 NON_QTY_DIMS값**(print_opt_cd·opt_cd·mat_cd)을 selections와 대조·NULL=와일드. `_evaluate_formula`(672-711)는 4 comp 전부 평가·`total += subtotal` 합산. use_dims의 `opt_grp:` 접두는 `non_qty_dims`에서 strip(598-599·675)=UI 스코핑 무해.
- **search-before-mint 정합**: flat comp 4·print_opt 2 재사용, 공식 1+opt_grp 1+opt 2만 mint(무손실 불가 입증). 채번 OPT_000081·OPV_000489/490 = 라이브 MAX(OPT_000080·OPV_000488=037 COMMIT 반영) **+1 충돌 0**(실측 count=0).
- **mat 와일드 필연**: 040 활성자재=자식 MAT_000362~365, flat 행=부모 MAT_000137. 엔진 부모해소 **없음**(grep upr_mat=0) → exact mismatch → mat_cd→NULL 와일드가 유일 매칭경로(설계 정합).
- FK 무결: CLR_000001/000002·POPT_000001/002 실재. 바인딩테이블 del_yn **부재** → unbinding=DELETE 정당(junction row·기초마스터 아님·`base-master-code-no-delete` 비적용).

## E5 재바인딩 정합 [HARD·돈크리티컬] — PASS
- 040 현 바인딩 = **PRF_DGP_A 단 1건** 실측. dryrun: `DELETE … frm_cd='PRF_DGP_A'` + `INSERT … PRF_NAMECARD_WHITE`(NOT EXISTS 가드) → 교정 후 **단 1건**. ★PRF_DGP_A 잔존 시 원자합산 별색/용지 비목이 flat과 이중합산(과대) — DELETE가 명시 제거하므로 차단.
- flat comp 3343~3346 = 현재 **어느 공식에도 미배선** 실측 → 재바인딩 부작용 0.
- DELETE는 hard지만 바인딩 junction이라 적정(소프트삭제 컬럼 없음).

## E6 골든 재현 (허용오차 0) — PASS
엔진 동치 재구현(`_row_matches`+`component_subtotal` PRICE_TYPE.02 verbatim)으로 설계 적용 후 상태 재계산:

| 케이스(q100) | 매칭행 | 기대 | 독립재계산 | 결과 |
|---|---|---|---|---|
| G1 단면·클리어없음 | 3343(P1,489) | 14,500 | **14,500** | PASS(1행) |
| G2 단면·클리어있음 | 3344(P1,490) | 16,000 | **16,000** | PASS(1행) |
| G3 양면·클리어없음 | 3345(P2,489) | 16,000 | **16,000** | PASS(1행) |
| G4 양면·클리어있음 | 3346(P2,490) | 19,000 | **19,000** | PASS(1행) |

- disjoint = (print_opt × opt_cd) 2×2 그리드 → 각 주문 **정확 1행** 매칭(이중합산 0). 색별 자재 임의(362~365) 무관 동일가(와일드 무손실).
- PRF_DGP_A 과대(양면 25,213·양면+클리어 44,213) **소멸** 확인.
- **dodge-hunt**: 설계는 unit_price 무변경(dryrun이 opt_cd·mat_cd만 UPDATE·값 verbatim). 행값=2026-06-06 적재분(설계 선행·순환참조 아님). 단 ultimate 260527 셀앵커는 §26 무결성 트랙(C3)·본 설계 범위 밖. 축당 +1,500 패턴 권위 추출 축구조 정합.
- ★qty≠100 = **§26 선행**(재계산 q200=29,000 프로레이팅·권위 200tier 미보장). 골든 q100 한정 유효(설계 명시).

## E7 생성-검증 독립성 — PASS
- 설계 재유도 안 함. 라이브 스냅샷·엔진코드·권위추출 직접 재실측. 엔진 동치 재구현 골든·037 동형·채번·FK·실패모드 3종 자체 산출. 생성자 "골든 일치" 주장을 행값 재계산으로 교차.

---

## ★E6/위젯계약 의존 판정 (gate 6 — 박명함 037 동형 여부)
- 실패모드 재계산 실증:
  - opt_cd 미공급(클리어 미선택) → 전 comp no-match=**0**.
  - print_opt+opt_cd 둘다 미공급(현 손님흐름) → **0**(PRF_DGP_A 제거+용지 comp 부재).
- 판정 = **박명함 037 동형(회귀 아님)**. 근거: ① 040 현재도 깨짐(6,213 silent 저청구) ② print_opt·클리어는 명함 핵심 **필수선택**(mand_yn=Y) ③ 037이 동일 의존으로 라이브 작동. **거짓 "자동 dflt 안전논거 없음"** 확인 — 설계는 시뮬레이터 dflt 미주입을 부인하지 않고 위젯 필수선택 강제 의존을 정직 표면화. dflt_yn=Y는 프로덕션 위젯 UI 프리선택(주문 payload 포함)으로 실효·시뮬 단독은 미주입.
- **조건**: 위젯이 단/양면(print_side)+클리어(OPT_000081)를 **필수선택 강제**해야 함(C1). 미강제 시 6,213→0 전환(저청구→견적불가). 037 라이브 작동으로 메커니즘 실재.

## COMMIT 승인 가능 여부 = 가능(조건부 CONFIRM)
- 데이터/모델 교정·BLOCKED 0·골든 q100 허용오차 0·disjoint·채번 충돌 0·FK 무결. 인간 승인 후 §7 dbmap COMMIT 가능.
- **선결 CONFIRM**: C1 클리어 기본값(없음 14,500 dflt — 실무진/goods.asp)·위젯 필수선택 강제 확인.
- **잔여(가격무해·후속)**: C3 qty≠100 tier(§26 선행)·C4 white colrcnt 표시메타·C5 PROC_000009 UX 이중노출(§17)·C6 comp_nm "코팅" 라벨 cosmetic.

## 잔여 캐리포워드
- §26: flat comp 4행 q100 단일 tier — qty≠100 골든 미보장(선행 적재).
- §17/상품기획: 클리어 공정(PROC_000009) vs opt 이중노출 UX 정리(가격 무영향).
