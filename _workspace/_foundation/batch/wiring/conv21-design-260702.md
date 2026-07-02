# §27 전수 수렴 round21 — 진단·판정·교정 설계 (2026-07-02)

사용자 directive: "전체 상품 — 구성요소·가격공식·가격구성요소 전수 진단·교정 → 적대적 검증 루프(오류 0까지) → 라이브 적재 후 webadmin 실화면 검증 후 단계 진행."

## 0. 측정 (결정론·신선 스냅샷 snap_20260702_1034)
- `wiring_scan --round 21`: **결함 10** = 고아 3 · 빈배선 6(*_TBD) · 삭제오염 1 · 미배선공식 0. legit_unused 7(정본 유지).
- `contribution_sim_scan`(단순 120상품 F층): HIGH 13건/7상품 · REVIEW 108.
- `set_full_scan`(셋트 19): §23 전수진단 정본과 정합 — 신규 결함 0 (094/097/100 "0원"은 set_selections 미충전 스캐너 한계 = §23에서 오진단 정정 완료된 FP · 082 gold차는 수량 위상).

## 1. 진짜 결함 판정 (5건 — 교정 SQL: conv21-260702-fix-dryrun.sql)

| # | 대상 | 결함 | 증거 | 교정 |
|---|---|---|---|---|
| ① | COMP_BIND_HC_TWINRING | 삭제오염(del_yn=Y 6/17)인데 082 셋트 공식(6/30 신설)이 참조 | 스냅샷 price_components del_yn=Y·formula_components 배선 실재 | del_yn=N 복원(가격 무변화·위생) |
| ② | PRD_000110 엽서캘린더 | PROC_000004(디지털인쇄 base) 미등록 → 인쇄비 영구0 | 실측 qty100 = **1,057원**(용지만)·108/109는 7/1 등록됨(동형 누락) | product_processes 1행(Y,-1) |
| ③ | PRD_000020 화이트인쇄엽서 | 인쇄옵션 0건 → SPOT(print_opt_cd 차원) 영구 미발현 | 권위=별색 화이트/클리어 전용·SPOT 단가 proc008×POPT1/2 각 53행·판형 국4절 실재 | 021/022 동형 POPT 단면(dflt Y)/양면(N) 등록 |
| ④ | 고아 3 + stale 1 | FOLD_CARD_3H=중복(리플렛 3FOLD 48/48 verbatim 동일)·FOAMBOARD BLACK/WHITE=BOARD(mat×siz)로 대체(BLACK siz단독=배선 시 이중합산·WHITE=구 사이즈 키 영구 NO_MATCH 지뢰) | design-foldcard-260701 §1·폼보드 4조합 실측 골든 일치(6000/8500/12000/14000) | use_yn=N 은퇴 3comp + WHITE stale 배선 DELETE |
| ⑤ | PRD_000130 포맥스 5mm | 권위상 두께=손님 선택인데 5mm 판매 불가(주문완전성 갭)·구 5mm comp 고아 | 실무진 등록 자재 4종(MAT_000022/554/23/555·mint 0) 실재·폼보드 BOARD 패턴 검증 완료 | BOARD comp(mat×siz) 신설+단가 4행 verbatim(8500/13000/10000/16000)+배선·구 WHITE3MM 배선 DELETE(이중합산 차단)+구 comp 2종 은퇴 |

DRYRUN: 전 어서션 PASS (V1~V7·포맥스 disjoint 4/4=정확히 1비목). 백업=conv21-backup-260702.txt·undo=conv21-260702-undo.sql.

## 2. FP 판정 (교정 대상 아님 — 실측 반증 확보)
- **코팅 PROC_ZERO 8건**(017/026/047/049 COAT_GLOSSY/MATTE): 스캐너가 coat_side_cnt detail 미전달. 실측(017): base 9,467 → +유광 detail{1} = 16,667(코팅 7,200) / detail{2} = 23,867(14,400) 정상 발현.
- **020 COMP_PRINT_DIGITAL_S1 CORE_ZERO**: 권위상 CMYK 미제공 상품(별색 전용) — 공식 공유(PRF_DGP_A)로 배선만 있고 상품 레벨 비활성 = 정상.
- **040 WHITE_S1W_CL/S2W_CL CORE_ZERO**: 클리어 별색 택1(OPT_000081) opt_cd 판별차원 — 7/1 커밋 골든 4/4 verbatim(16,000/19,000) 기검증. 스캐너 옵션그룹 미선택 아티팩트.
- **셋트 094/097/100 "0원"**: set_selections(옵션차원) 미충전 스캐너 한계 — §23 전수진단에서 정상 확정(450k/135k/1.5M).

## 3. BLOCKED (실무진 대기 — 임의 단가 금지)
- 아크릴 *_TBD 빈배선 6건(3D블록·3D코롯토·포토코롯토·쉐이커·시향코롯토·지비츠2) = "단가/구성 확인필요" 시그널 바인딩. 실무진 답변 후 해소.
- 결함 0 목표의 잔여분모 — 데이터로 닫을 수 없는 유일 항목.

## 4. 컨펌큐 갱신 (report-only·이번 COMMIT 범위 밖)
- 포맥스 A1 3종 미적재(가격표: 3mm 23,000·5mm 30,000·폼보드 블랙 24,000) — 상품 사이즈에 A1 자체가 미제공. §26/실무진.
- 포맥스 3mm 권위 충돌: 마스터(8,300/11,500) vs 가격표·DB(8,500/13,000) — 별건 컨펌(현행 유지).
- 폼보드/포맥스 mat×siz 모델의 교차 조합(A2 사이즈+A3 자재 등)=0원 — 위젯/뷰어 제약(§6) 소관.
- 028 미니접지카드: 접지 옵션그룹 부재(미출시 상품) — 출시 시 방향선택 UI 필요 여부 실무진.

## 5. codex 독립 교차검증
- 프롬프트=conv21-codex-prompt-260702.md(판정 8항+SQL 부작용+누락 발굴 Q3). 결과·reconcile → conv21-codex-reconcile-260702.md.

## 6. 종료 척도 추적
- 목표: 배선 결함 0(BLOCKED 6 제외) + PRICE≠0 + webadmin 실화면 확인.
- COMMIT 후: conv21_postverify.py(110/020/130/129회귀/048회귀) → gstack 실화면 → 신선 스냅샷 round 22 재스캔 → contribution_sim_scan 재실행(110/020 HIGH 소멸 확인).
