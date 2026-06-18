# Dimension Mapping Matrix — 3원 정합 (use_dims ↔ 단가행 충전 ↔ 권위 가격축)

> **Phase 2 — hpq-price-chain-inspector** · 2026-06-18 · 라이브 읽기전용 실측.
> 각 셀 3원: ① `use_dims` 선언(t_prc_price_components) ② 단가행 실제 충전(t_prc_component_prices non-NULL count / total) ③ 권위 가격축(authority-golden).
> 표기: ✅ 3원 일치 · ⚠️ 선언≠충전 또는 권위≠라이브 · ❌ 결함 · — 해당없음.
> 차원: siz=siz_cd · plt=plt_siz_cd · pop=print_opt_cd · mat=mat_cd · proc=proc_cd · opt=opt_cd · coat=coat_side_cnt · bdl=bdl_qty · mq=min_qty · sw=siz_width · sh=siz_height · dv=dim_vals · clr=clr_cd.

---

## 1. 엽서 PRF_DGP_A (합산형)

| comp_cd | 행수 | use_dims 선언 | 충전 차원(non-NULL) | 권위 가격축 | 정합 |
|---------|:--:|---------------|---------------------|-----------|:--:|
| COMP_PRINT_DIGITAL_S1 | 212 | proc,plt,pop,mq,proc_grp:001 | plt(212)·pop(212)·proc(212)·mq(212) | 출력판형(국4절)·도수면·수량 | ✅ |
| COMP_PRINT_DIGITAL_S2 | 212 | proc,siz,pop,mq,proc_grp:001 | siz(212)·pop(212)·proc(212)·mq(212) | 출력판형(3절)·도수면·수량 | ✅ (S1/S2 분기→D-5 CONFIRM) |
| COMP_PRINT_SPOT_WHITE_S1 | 530 | plt,proc,pop,mq,proc_grp:007 | plt(530)·pop(530)·proc(530)·mq(530) | 별색(화이트/클리어/핑크/금/은)·면·수량 | ✅ (엽서 별색 정당) |
| COMP_COAT_GLOSSY | **0** | siz,coat,mq | — (행 0) | 코팅 유광단/양 | ❌ D-4 단가행 0 |
| COMP_COAT_MATTE | 92 | siz,coat,mq | siz(92)·coat(92)·mq(92) | 코팅 무광단/양·수량 | ✅ |
| COMP_PAPER | 56 | siz,mat | siz(56)·mat(56) | 종이(자재)·사이즈 | ✅ |
| COMP_PP_CREASE_1L | 30 | proc,mq,proc_grp:029 | proc(30)·mq(30)·**dv 줄수1/2/3(30)** | 오시(후가공) | ❌ D-1 dv 과충전(줄수 2/3 중복) |
| COMP_PP_CREASE_2L | 10 | proc,mq,proc_grp:029 | proc(10)·mq(10)·dv 줄수2(10) | 오시 | ❌ D-1 중복배선 |
| COMP_PP_CREASE_3L | 10 | proc,mq,proc_grp:029 | proc(10)·mq(10)·dv 줄수3(10) | 오시 | ❌ D-1 중복배선 |
| COMP_PP_PERF_1L | 30 | proc,mq,proc_grp:030 | proc(30)·mq(30)·dv 줄수1/2/3(30) | 미싱(후가공) | ⚠️ PERF는 형제 2L/3L 미배선이라 family 중복 없음. dv 줄수 단일 comp 처리(정상 패턴) |
| COMP_PP_VARTEXT_1EA | 69 | proc,mq,proc_grp:085 | proc(69)·mq(69)·dv 개수1/2/3(69) | 가변텍스트 | ❌ D-2 dv 과충전 |
| COMP_PP_VARTEXT_2EA | 23 | proc,mq,proc_grp:085 | proc(23)·mq(23)·dv 개수2 | 가변텍스트 | ❌ D-2 |
| COMP_PP_VARTEXT_3EA | 23 | proc,mq,proc_grp:085 | proc(23)·mq(23)·dv 개수3 | 가변텍스트 | ❌ D-2 |
| COMP_PP_VARIMG_1EA | 69 | proc,mq,proc_grp:085 | proc(69)·mq(69)·dv 개수1/2/3 | 가변이미지 | ❌ D-2 |
| COMP_PP_VARIMG_2EA | 23 | proc,mq,proc_grp:085 | proc(23)·mq(23)·dv 개수2 | 가변이미지 | ❌ D-2 |
| COMP_PP_VARIMG_3EA | 23 | proc,mq,proc_grp:085 | proc(23)·mq(23)·dv 개수3 | 가변이미지 | ❌ D-2 |
| COMP_PP_CORNER_RIGHT | 18 | proc,mq,proc_grp:026 | proc 027(9)**+028(9)**·mq(18) | 귀돌이 직각 | ❌ D-3 둥근(028) 오염 |
| COMP_PP_CORNER_ROUND | 9 | proc,mq,proc_grp:026 | proc 028(9)·mq(9) | 귀돌이 둥근 | ✅ (자체는 정상, RIGHT 오염이 문제) |

> **PERF vs CREASE 비대칭(설계 단서):** PERF_1L은 줄수 param 단일 comp(2L/3L 미배선) = **정상 그룹핑**. CREASE는 1L에 줄수 param 다 넣고도 2L/3L 또 배선 = **중복**. → 정합 정답 = CREASE도 PERF처럼 1L 단일화(2L/3L 배선 제거). PERF가 정상 레퍼런스.

---

## 2. 현수막 PRF_POSTER_BANNER_N (면적매트릭스)

| comp_cd | 행수 | use_dims 선언 | 충전 차원 | 권위 가격축 | 정합 |
|---------|:--:|---------------|----------|-----------|:--:|
| COMP_POSTER_BANNER_NORMAL | 79 | sw,sh | sw(79)·sh(79) | 가로(열)·세로(행) 면적매트릭스 | ✅ |
| COMP_PP_CREASE_1L | (공유) | proc,mq,proc_grp:029 | (D-1 동일) | 오시 | ❌ D-1 |
| COMP_PP_CORNER_ROUND | (공유) | proc,mq,proc_grp:026 | proc 028 | 귀돌이 둥근 | ✅ |
| COMP_PP_CORNER_RIGHT | (공유) | proc,mq,proc_grp:026 | proc 027+028 오염 | 귀돌이 직각 | ❌ D-3 |
| COMP_PP_VARTEXT_1EA | (공유) | proc,mq,proc_grp:085 | dv 개수1/2/3 | 가변텍스트 | ❌ D-2 |
| COMP_PP_VARIMG_1EA | (공유) | proc,mq,proc_grp:085 | dv 개수1/2/3 | 가변이미지 | ❌ D-2 |
| COMP_PRINT_SPOT_WHITE_S1 | (공유) | plt,proc,pop,mq,proc_grp:007 | plt·pop·proc·mq | **현수막 권위에 별색 없음** | ⚠️ D-6 불필요배선(CONFIRM·현재 무발화) |
| COMP_PP_PERF_1L | (공유) | proc,mq,proc_grp:030 | dv 줄수 | 미싱 | ✅ |

> **본체 COMP_POSTER_BANNER_NORMAL 3원 일치 ✅** — use_dims=[siz_width,siz_height] 선언·충전·권위 가로(열)/세로(행) 면적매트릭스 정합([[dbmap-area-matrix-wh-dimension]]). 그리드: 폭 17구간(900~5000) × 높이 5구간(900~1750), 79행 sparse. authority-gap Q-POSTER-MAXTIER(최대 초과=ERR_ABOVE_MAX, P3-5/P7-3 비치명) 정합.

---

## 3. 아크릴 PRF_CLR_ACRYL (면적매트릭스+두께)

| comp_cd | 행수 | use_dims 선언 | 충전 차원 | 권위 가격축 | 정합 |
|---------|:--:|---------------|----------|-----------|:--:|
| COMP_ACRYL_CLEAR3T | 165 | sw,sh,mat | sw(165)·sh(165)·mat(165)·mq(165 전부=1) | 가로(열)·세로(행)·두께(mat)·수량할인 | ✅ |

> **3원 일치 ✅** — use_dims=[siz_width,siz_height,mat_cd] 선언·충전 완전. 두께축=mat_cd(MAT_000042=1.5mm·MAT_000043=3mm) → 권위 "투명3T/투명1.5T 두께 직교"와 정합(골든 3T 30×30=3100·1.5T=2480, ×0.8 직교). prc_typ=PRICE_TYPE.02 합가형·min_qty 전건=1 → P4-3 ValueError 무위험.
> **권위 미반영(comp 자체 결함 아님):** ① 수량할인(authority §3.2 인쇄가공비에만)은 comp use_dims가 아니라 `t_dsc_*` 할인 트랙(엔진 P6). 본 comp는 면적+두께만 — 정당. ② 수량할인 개당/총액 엔진계약 = authority-gap Q-ACR-ENGINE 미확정(검증자 케이스3c 100개=248,000 가설 대조).
> **미배선 comp(D-7):** COMP_ACRYL_MIRROR3T·COROTTO는 PRF_CLR_ACRYL에 미배선(파일럿 무관·CONFIRM).

---

## 4. 불일치 유형 집계

| 유형 | 정의 | 해당 | ID |
|------|------|------|----|
| 충전했으나 권위 외 중복 | dv가 형제 comp와 의미 중복 | CREASE_1L·VARTEXT/VARIMG_1EA | D-1·D-2 |
| 권위 외 차원 오염 충전 | comp 의미와 다른 차원값 행 | CORNER_RIGHT(둥근 028) | D-3 |
| 선언했으나 미충전(행 0) | 배선·use_dims 있으나 단가행 0 | COMP_COAT_GLOSSY | D-4 |
| 동일값 이중 차원키 | 같은 SIZ를 plt와 siz 양쪽 | DIGITAL S1/S2 | D-5(CONFIRM) |
| 권위 축 없는 comp 배선 | 현수막 별색 | SPOT_WHITE@현수막 | D-6(CONFIRM) |
| 선언=충전=권위 완전일치 | 3원 OK | BANNER_NORMAL·ACRYL_CLEAR3T·PAPER·COAT_MATTE·DIGITAL_S1/S2·SPOT@엽서·CORNER_ROUND·PERF_1L | — |

> **요약:** 본체 면적매트릭스(현수막·아크릴)·용지비·무광코팅·디지털인쇄 본체는 3원 완전 일치. 결함은 전부 **후가공 add-on 레이어**(오시·귀돌이·가변데이타·유광코팅)에 집중 — 그룹핑 미정리(D-1/D-2)·오염(D-3)·누락(D-4).
