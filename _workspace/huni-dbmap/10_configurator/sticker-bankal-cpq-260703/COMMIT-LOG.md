# 스티커 반칼 CPQ COMMIT 로그 (2026-07-03)

> B그룹 돈영향 갭. 반칼정사각(059)·반칼직사각(060)·반칼띠지(061)·반칼팬시(062) 손님선택 옵션 신설.
> ★사용자 확정: 059/060/061 커팅=반칼(등록된 완칼은 오등록)→반칼커팅 교정 후 CPQ.

## COMMIT (load.sql·교정 반영)
1. **커팅 공정 교정**: 059/060/061에 반칼커팅(PROC_000122) 등록 + 스티커완칼(PROC_000055) 은퇴(del_yn=Y). 052 반칼자유형·062 반칼팬시 정답 대조군과 동일 공정.
2. **062 기존 broken partial 은퇴**(sel_typ 부재·option_item 미연결 그룹 2·옵션 6·item 1).
3. **CPQ 신설**: 4상품 × 052 동형 3그룹(종이=자재/인쇄=도수/커팅=공정)·옵션그룹 12·옵션 28·option_items 28. 커팅 옵션명 059/060/061='반칼'(교정)·062='반칼'.
- 신규 mint 0(자재/도수/공정 전부 라이브 활성 차원행 재사용·OPT_/OPV_ PK만 신규).
- DB: `INSERT 0 3(proc)·UPDATE 3(완칼은퇴)·UPDATE 1/6/2(062 partial)·INSERT 0 12(grp)·INSERT 0 28(opt)·INSERT 0 28(item)·COMMIT`

## DRY-RUN·검증
- 트리거 fn_chk_opt_item_ref: option_items 28건 전건 통과(잘못된 키/부재 차원행 0).
- webadmin 실화면:
  - 059 sim-meta 구조 = 정답 052와 동일(prod_dims: siz_cd·**mat_cd(5)** 노출·opt_groups=0은 052도 동일=정상).
  - 059 simulate A5·qty1000: **비코팅 4,000,000 vs 무광코팅 5,000,000**(코팅비 +1,000,000 반영=자재 손님선택 발현).
  - 059/060/061 활성 공정 = 반칼커팅·스티커완칼 은퇴 확인.

## 안전장치
- 백업: `backup/{processes-before.csv·062-groups-before.csv}`. undo: `undo-corrected.sql`(CPQ 제거+062 partial 복원+공정 원복).

## 참고
- sim-meta opt_groups=[]은 정답 052도 동일 — 자재 선택은 admin sim에선 prod_dims mat_cd로, 위젯에선 t_prd_product_option_groups(DB 실재)로 노출.
- 채번: OPT_000160-171·OPV_000639-666(COMMIT 직전 max=OPT_000159/OPV_000638 확인·충돌 0).
