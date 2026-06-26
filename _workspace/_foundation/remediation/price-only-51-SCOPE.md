# 가격만결손 51 바인딩 — 스코프 브리프 (생성가 입력)

작성 2026-06-26 (main 실측) · 권위 = [[product-type-classification-sot]] · [[product-config-readiness-260626]] · A2 `06_load/a2-price-conformance/`. 목적 = "기초(차원·자재) 완비·가격 바인딩 0"인 완제품 51개를 **검증된 바인딩 보드**로 분류하고 안전 바인딩 SQL을 조립. **DB 미적재(생성)** — 실 COMMIT은 독립 게이트 GO + 인간/자율승인.

## 0. 51 목록 = `price-only-missing-51.csv` (라이브 재도출·검증됨)
- 재현식: prd_typ=PRD_TYPE.01 ∧ del_yn≠Y ∧ (sizes>0 ∨ nonspec_yn=Y) ∧ materials>0 ∧ price_formulas=0. → 정확히 51. 3버킷(견적가능70·가격만결손51·기초부실105)이 라이브와 일치 재현됨.
- 컬럼: prd_cd,prd_nm,nonspec,n_siz,n_mat,n_dosu,n_proc,n_optg.

## 1. 라이브 공식 지형 (실측 2026-06-26 · 전 50 use_yn=Y 공식)
- **고아 공식(바인딩0·단가행>0)**: `PRF_COROTTO_ACRYL`(21행)·`PRF_POSTER_FIXED`(52행). → 바인딩만으로 활성화 후보.
- **공유 아크릴 공식**: `PRF_CLR_ACRYL` = comp `COMP_ACRYL_CLEAR3T`·use_dims=[siz_width,siz_height,mat_cd]·165단가행. 현재 바인딩=PRD_000146 아크릴키링 1개뿐. 투명3T 아크릴군이 공유 후보(★단, 상품별 면적이 165행 매트릭스에 실재하는지 search-before-mint 확인 필수 — 면적 미커버 시 견적불가).
- **고아/미배선 comp**: `COMP_ACRYL_MIRROR3T`(미러3T·52행·**미배선 n_wire=0**·미바인딩, A2 D05) → 배선+바인딩. `COMP_ACRYL_BLACK_HAIR_BAND`(머리끈·0행·0배선)·`COMP_ACRYL_KEYRING`(2행·0배선) → 단가/공식 결손.
- **use_yn=N(설계됨·비활성) 공식**: `PRF_PHOTOCARD_FIXED` 1개뿐 → §18 11시트 설계분은 라이브에 **사실상 미적재**(민팅 대상, "설계됨≠적재됨").
- **명함 공식**: `PRF_NAMECARD_FIXED`(use_dims=[mat_cd,...]·10단가행) 바인딩=일반명함 3종(031 프리미엄·032 코팅·033 스탠다드). 특수명함 6종(034 펄·035 모양·036 미니모양·037 오리지널박·039 투명·040 화이트인쇄)은 자재/형상 상이 → 권위 가격표(260527) 대조 필요(공유 바인딩 가능 여부 불명).
- **디지털 공식**: PRF_DGP_A~F. 엽서·쿠폰·접지·전단지 등 바인딩 다수. 지그재그엽서(030)는 DGP 계열 후보.

## 2. 51 클러스터 (1차 분류 가설 — 생성가가 search-before-mint로 확정·반증)
| 클러스터 | prd | 가설 상태 | 근거/주의 |
|---|---|---|---|
| 아크릴 코롯토 | 164 아크릴코롯토·165 포카코롯토 | **바인딩만?** | PRF_COROTTO_ACRYL 고아. A2 D04. 면적 매칭 확인 |
| 투명3T 아크릴 | 147~163,166,169 다수 | **바인딩만?/면적민팅?** | PRF_CLR_ACRYL 공유 후보. ★각 상품 siz가 165행에 실재해야. 미커버=단가행 민팅 |
| 미러 아크릴 | (해당 시) | 배선+바인딩 | COMP_ACRYL_MIRROR3T 미배선(D05) |
| 머리끈/특수 | 154 머리끈 등 | 민팅 | comp 0행·0배선 |
| 명함 특수 6 | 034·035·036·037·039·040 | 권위대조 | NAMECARD 공유 가능여부 불명 |
| 엽서 | 030 지그재그엽서 | DGP 후보 | DGP 계열 바인딩 확인 |
| 책자 셋트 5 | 072·077·082·088·100 | **민팅 BLOCKED** | comp 0행·§18 미적재·돈크리티컬. price-mint-readiness.md 참조. 이번 세션 제외 |
| 캘린더 5 | 108·109·110·111·112 | **설계보류** | §18 정찰가 역산 비정수 BLOCKED. 단순 누락과 구분 |
| 문구 10 | 172~176·178·179·181·217 | 공식 적재여부 확인 | 다이어리/노트/수첩/스탬프. §18 문구시트 설계분 미적재 가능성 |
| 굿즈 4 | 197·198·202·241 | 공식 적재여부 확인 | 매트/키링/파우치 |

## 3. 산출 요구 (생성가)
1. `price-only-51-binding-board.csv` — 51 전수 × {prd_cd,prd_nm,클러스터,target_frm_cd,상태(BIND_ONLY/WIRE_BIND/MINT/DESIGN_BLOCKED),근거,search-before-mint 증거}.
2. **BIND_ONLY 확정분만** 안전 SQL 세트: `bind-only-fix.sql`(INSERT t_prd_product_price_formulas·멱등 ON CONFLICT/NOT EXISTS·단일 트랜잭션·DO block)·`bind-only-backup.sql`·`bind-only-undo.sql`·`bind-only-dryrun.sql`(롤백전용). apply_bgn_ymd는 동군 기존 바인딩과 정합(추정 회피·CONFIRM 표기).
3. WIRE_BIND/MINT/DESIGN_BLOCKED = 설계 노트 + 라우팅만(SQL 금지·돈크리티컬은 인간 승인).
4. ★[HARD] 가격연결 기초데이터는 이름 수정/추가 가능, **삭제 금지**(사용자). 단가값 verbatim·날조 0. 라이브 읽기전용(COMMIT은 게이트 후).

## 4. 검증 (별도 게이트 — 생성≠검증)
BIND_ONLY 각 건: 대상 공식이 라이브 실재(use_yn=Y)·comp 배선 OK·단가행이 상품 차원(siz/mat)을 **실제 커버**(PRICE≠0)·이중합산 0·apply_ymd 정합. 미커버=BIND_ONLY 강등(MINT).
