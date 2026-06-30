# 사후 재실측 — 하드커버 링책자(PRD_000082) 셋트 COMMIT 후 검증

실측: 2026-07-01 0041 · 라이브 읽기전용 SELECT + 결정론 재계산 + 멱등 재-dryrun(ROLLBACK) · COMMIT 후

| # | 항목 | 결과 |
|---|---|---|
| ① | PRF_HC_TWINRING_SET·PRD_000286 실재·차원 충전 | ✅ 286 실재(prd_typ.02·하드커버 링책자-내지) · PRF_HC_TWINRING_SET use_yn=Y · 차원 siz3/popt2/mat9/plate1 정확 |
| ② | 082 셋트행 5→6행 | ✅ 6행·disp_seq **1~6 단조**(표지083 seq1·내지286 seq2·면지084~087 seq3~6)·내지286 min8/max100/incr2 정확 |
| ③ | evaluate_set_price 견적 0원→PRICE≠0 | ✅ **44,123원**(A5·page30·qty1·양면·백모조100). 제본 30,000(COMP_BIND_HC_TWINRING@min_qty1) + 내지(인쇄 3,500×4매=14,000 + 용지 30.73×4=122.92) = base_total 44,122.92 → round_won 44,123. fn_calc_pansu(SIZ_000499,A5)=4 라이브 실측 확인. 게이트 G1 값과 일치. |
| ④ | ★S8 제본 오염 0 (COMMIT 후) | ✅ **pollution=0** — PRF_HC_TWINRING_SET 비목 = COMP_BIND_HC_TWINRING 단 1개. 무선 COVERBIND·일반 TWINRING·MUSEON·PUR·JUNGCHEOL 미배선. COMP_BIND_HC_TWINRING 단가행 proc_cd=PROC_000024 단독(다른 제본 comp와 무중첩). 링≠무선≠일반트윈링 격리. |
| ⑤ | 멱등(재-dryrun delta 0) | ✅ COMMIT 후 재적용 27행 전부 **INSERT 0 0**(ROLLBACK) |
| ⑥ | 기존 셋트 무손상(회귀 0) | ✅ 077 셋트 5행·072 셋트 5행 유지. 077/072 공식 PRF_HC_MUSEON_SET 무손상(082 신설 PRF_HC_TWINRING_SET와 별개 frm_cd). |

## 가격경로 단가행 재확인 (라이브 verbatim·COMMIT 후)
- 제본 COMP_BIND_HC_TWINRING [PROC_000024]: 6밴드 30000/20000/15000/10000/8000/7000 (min_qty 1/4/10/50/100/1000)
- 내지 인쇄 COMP_PRINT_DIGITAL_S1 [SIZ_000499·POPT_000002 양면]: qty1=6000·qty4=3500·qty8=2100
- 내지 용지 COMP_PAPER [SIZ_000499·MAT_000072 백모조100]: 30.73/장
- 부모공식 비목 = COMP_BIND_HC_TWINRING(addtn_yn=Y) · 내지공식 PRF_DGP_INNER = DIGITAL_S1(seq1)+PAPER(seq2)
- 이중합산 0: set_eval=제본만 · 내지=인쇄+용지만 · 면지=0 · frm_cd 분리

## 잔존 저청구(BLOCKED·본 COMMIT 밖·인지됨)
- 표지/면지 ×2 인쇄·코팅 미반영(BLOCKED-COVER-MYUNJI-PRINT·BLOCKED-COVERMULT-X2) — 단가행 부재·엔진 ×2 미지원. 저청구 잔존하나 0원 아님(44,123).
- 면지 유료 결판(CONFIRM-MYUNJI-PAID) — 현 무료 보존.
- 좀비 자재 link(BLOCKED-MAT-REWIRE·dbmap)·C-TRACK(엔진·set_procs proc_cd 호출자 계약)·BOUNDARY-CSV-082(큐레이터).

## 판정: 사후검증 6/6 PASS · 무손상 입증 · undo 불요(정상 적재)
