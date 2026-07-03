<!-- product-local sub-nodes: E3 size(058/059/060·이 상품이 신설)·E7 plate(062-SIZ_000521)·전사표 for PRD_000062 반칼팬시스티커. -->
<!-- ★공유축 승격 대기 원자. 공유 축 파일(index/axis/*·formula/*·rule/*) 수정 금지라 여기 임시 거처 — needed_shared_nodes로 반환. -->
<!-- ★중복 금지(directive "needed_shared_nodes로 반환만"): 형제 빌더(circle·052·halfcut)가 bare-canonical id로 -->
<!--   이미 정의하는 공유 노드(category 2·formula·component·material 5·process PROC_000122·printopt)는 여기서 -->
<!--   재정의하지 않고 참조만(L-3 중복 회피). 아래 '공유 스티커 노드' 목록 = needed_shared_nodes 반환분. -->
<!-- ★이 파일 단독 소유 = size-SIZ_000058/059/060(팬시 실치수·아무도 미소유·승격 후보)·plate-062-SIZ_000521. -->
<!-- ★수치(치수·평량·수량·격자 행수)는 아래 전사표(transcribed-by·transcribe_sticker_fancy_062.py)에만. props raw 미기입(D-9·L-12). -->

# 반칼팬시스티커(PRD_000062) 하위 노드 — 스티커 전용 축 원자

[[sticker-spec-fancy]] product 노드가 거는 축 원자 중 이 파일 단독 소유분(팬시 사이즈 3종·판형)과,
형제 빌더/승격이 소유하는 공유 스티커 노드 참조 목록. 상품→축 연결은 product 노드가 건다.
062의 소재별 관찰(코팅 CONFLICT·비코팅 드롭)·CPQ 미배선은 product 노드 relation note와 gap에 귀속(공유 노드 오염 없이).

## 공유 스티커 노드 (참조 전용 — 형제 빌더/승격 소유·재정의 안 함·needed_shared_nodes 반환분)

스티커 상품군 공통이라 병렬 형제 파일이 bare-canonical id로 정의한다. 중복(L-3) 회피 위해 **참조만** 한다.
축 소유자가 공유 `axis/*`·`formula/*`로 단일 승격(dedup) 대상:

- `category-CAT_000002` 스티커(root) · `category-CAT_000037` 규격스티커(부모 CAT_000002) — product in_category 타깃(circle·rectangle·052 소유).
- `formula-PRF_STK_FIXED` 스티커 완제품가 고정가 공식(전 스티커 공통) — product priced_by 타깃(052 halfcut 소유).
- `component-COMP_STK_PRINT` 스티커 완제품가 구성요소(use_dims=[siz_cd,mat_cd,min_qty]·PRICE_TYPE.01) — 공식 has_component 타깃(052 halfcut 소유).
- `material-MAT_000584`(유포 80g)·`material-MAT_000609`(미색 모조 80g)·`material-MAT_000611`(아트 90g)·
  `material-MAT_000585`(무광코팅·CONFLICT·candidate)·`material-MAT_000586`(유광코팅·CONFLICT·candidate) — product uses_material 타깃(circle·052 소유·058/062 공유).
- `process-PROC_000122` 반칼커팅(상위 PROC_000121 커팅·Kiss Cut) — product has_process 타깃(circle·052·halfcut-clear 소유). ★062는 이 공정으로 상품명 "반칼" 정합(059의 PROC_000055 불일치 해소).
- `printopt-POPT_000001` 단면(front CLR_000005 4도·back CLR_000001) — product has_print_option 타깃(공유 axis/print-options.md + rectangle 소유). optgroup-062-print의 option_refs 타깃이기도.

## 이 파일 단독 소유 원자 (팬시 사이즈 3종·판형)

### [plate-062-SIZ_000521] 반칼팬시 판형 330x470 (46계열 전지) {verified}
- type: plate_size
- anchor: t_siz_sizes/SIZ_000521
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000062,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02·dflt_plt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000521 (330x470 전지·46계열·반칼 스티커 표준전지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", siz_ref: "전사표 SIZ_000521(330x470 46전지)", note: "점착지=종이류→판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택 fn_best_plate 자동선택. 삭제=SIZ_000200/201/202(파일사양 OUTPUT_PAPER_TYPE.03) 06-30 del_yn=Y. 완제품가 고정가 모델에선 판형이 가격축 아니라 생산 라우팅 메타·공유 축 승격 후보(circle plate-058-SIZ_000521과 동일 규격)"}
- 본문: 062 판형=330x470 전지(46계열·OUTPUT_PAPER_TYPE.02). 스티커 점착지는 종이류라 판형 유효(도메인 규칙 12항). 완제품가 룩업 모델에서 판형은 가격 격자 축이 아니라 생산 라우팅 메타([[component-COMP_STK_PRINT]]와 정합). ★circle의 plate-058-SIZ_000521과 같은 SIZ_000521 규격 — 형제가 SIZ_000521 판형을 canonical로 승격하면 그 id로 정정(현재는 per-product local 노드).

## 전사표 (권위 = 라이브 마스터·전사 스크립트 산출)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | siz_nm | 작업(mm) | 재단(mm) | 판걸이(note) | del_yn |
|---|---|---|---|---|---|
| SIZ_000058 | 100x140 | 104.00x144.00 | 100.00x140.00 | 판걸이=8.0 | N |
| SIZ_000059 | 124x186 | 128.00x190.00 | 124.00x186.00 | 판걸이=4.0 | N |
| SIZ_000060 | 90x190 | 94.00x194.00 | 90.00x190.00 | 판걸이=6.0 | N |
| SIZ_000521 | 330x470 | 330.00x470.00 | 320.00x460.00 | 전지(46계열)·반칼 스티커 표준전지 | N |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | upr_mat_cd | 평량(g) |
|---|---|---|---|---|
| MAT_000584 | 유포스티커 80g | MAT_TYPE.11 | MAT_000153 | - |
| MAT_000609 | 미색스티커 (모조 80g) | MAT_TYPE.11 | MAT_000242 | - |
| MAT_000611 | 아트스티커 90g | MAT_TYPE.11 | MAT_000610 | - |
| MAT_000585 | 무광코팅스티커 (아트지 90g + 무광라미네이팅) | MAT_TYPE.11 | MAT_000155 | - |
| MAT_000586 | 유광코팅스티커 (아트지 90g +유광라미네이팅) | MAT_TYPE.11 | MAT_000156 | - |

★소재 관찰(공유 노드 아닌 062 귀속): 5소재 전부 MAT_TYPE.11(정답·팩 §3.5). 07-01 재키잉 child variant(parent
del_yn=Y). ★비코팅스티커(MAT_000084)는 062 junction del_yn=Y·child 미추가 = **062에서 드롭**(058/059는 보유).
무광/유광코팅(585/586)은 코팅 CONFLICT([[sticker-spec-fancy#gap-062-coating-conflict]]).

<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from live-snapshot/latest (snap_20260702_1119) t_prd_products @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | file_upload | editor |
|---|---|---|---|---|---|
| 8 | 10000 | 8 | QTY_UNIT.02 | Y | Y |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT @ 2026-07-03 -->
| siz_cd | siz_nm | COMP_STK_PRINT 행수(active 5소재) | 상태 |
|---|---|---|---|
| SIZ_000058 | 100x140 | 0 (-) | ★격자 0행(silent-0·미충전) |
| SIZ_000059 | 124x186 | 180 (000584:36,000585:36,000586:36,000609:36,000611:36) | 격자 충전(silent-0 아님) |
| SIZ_000060 | 90x190 | 180 (000584:36,000585:36,000586:36,000609:36,000611:36) | 격자 충전(silent-0 아님) |

가격경로 연결 증거(단가행 존재·★값 미전사·evaluate_price 권위·D-18). 격자 키 = (siz_cd, mat_cd, min_qty).
★SIZ_000058만 미충전 → [[sticker-spec-fancy#gap-062-siz058-price-missing]]. 059/060 각 180행(5소재×수량구간 36).
