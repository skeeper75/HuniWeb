# 스티커 5상품 실무진 신규자재 → 단가행 신설 설계 (§27 배선 · 260701)

- 대상: PRD_000052 반칼자유형·053 반칼자유형투명·055 낱장자유형·058 반칼원형·067 타투.
- 결함: 실무진이 오늘 신규 mat_cd/proc_cd 옵션을 추가했으나 공유공식 컴포넌트에 그 mat 단가행 0 → 견적 0.
- 입력: `staff-edit-scan-260701.json` B_unpriced_option_refs + C_missing_dim_wiring · 라이브 실측 · 가격표 260527 스티커시트.
- 산출: **dryrun 까지**(실 COMMIT 없음·DB 미적재·생성≠검증). 단가=canonical verbatim(날조 0).

---

## 0. 현황 실측 (라이브 SELECT)

| 상품 | 공식 | 활성 mat(product_materials del_yn=N) | 커팅 proc |
|---|---|---|---|
| 052 반칼자유형 | **PRF_STK_FIXED**(공유) | 584 유포80g·585 무광·586 유광·609 미색·611 아트 | 054 반칼 |
| 053 반칼투명 | **PRF_STK_FIXED**(공유) | 371 투명백색후지·372 투명후지 | 054 반칼 + 008 화이트인쇄 |
| 055 낱장자유형 | **PRF_STK_FIXED**(공유) | 593 유포+무광쿨코팅 | 053 완칼 |
| 058 반칼원형 | **PRF_STK_FIXED**(공유) | 584·585·586·609·611 | (커팅옵션 없음) |
| 067 타투 | PRF_STK_TATTOO | 594 타투스티커 | — |

- PRF_STK_FIXED → **COMP_STK_PRINT** (단가형 PRICE_TYPE.01·`use_dims=[siz_cd,mat_cd,min_qty]`). 2838행·mat 7종(084/153/155/156/162/163/242).
- PRF_STK_TATTOO → COMP_STK_TATTOO (합가형 PRICE_TYPE.02·mat=MAT_000167 1종·333행).
- **신규 mat_cd(584/585/586/609/611/371/372/593/594) 는 COMP_STK_PRINT·TATTOO 에 단가행 0행**(전수 확인).

## 1. ★근본원인 규명 — 시뮬레이터 mat 소스 = product_materials (option_items 아님)

`price_views.py:1385-1392`: prod_dims `mat_cd` 드롭다운 = `TPrdProductMaterials.filter(prd_cd).exclude(del_yn='Y')`.
- 실무진이 **product_materials 를 신규 mat_cd 로 마이그레이션**: 구 canonical(153/155/156/162/242/167)=`del_yn='Y'` 논리삭제, 신규(584+)=`del_yn='N'` 활성.
- 손님이 활성 신규 mat 선택 → 엔진이 COMP_STK_PRINT 에서 (siz_cd,신규mat,min_qty) 조회 → **단가행 0 → `_row_matches` 실패 → 견적 0**.
- **실측 입증**: 052 유포(MAT_000584)·A5(SIZ_000170)·qty100 → `price=0 matched=False`. 같은 상품에 canonical MAT_000153 주입 → `price=520000 matched=True`. 055(593)=0/153=360000. 067(594)=0/167=6000.
- ★교훈 정정: memory [[sticker-pipeline-260628]]는 "시뮬=option_items.ref_key1"이라 했으나, 그건 **옵션그룹이 sim에 노출된 상품**(opt_groups≠[]) 한정. 052 등은 sim_meta `opt_groups=[]`·종이그룹이 prod_dims mat_cd 로 붕괴 → **소스=product_materials**. 두 경로 병존.

## 2. ★핵심 심의 — 재키잉(A) vs 단가행 신설(B)

| | A: option_items ref_key1 → canonical 재키잉 | **B(권고): 신규 mat_cd 에 단가행 신설(canonical verbatim 클론)** |
|---|---|---|
| 가격 작동 | ✗ **무효**(시뮬은 product_materials 봄·option_items 무시) | ✓ 활성 신규 mat 이 직접 매칭 |
| search-before-mint | 코드 재사용이나 소스틀림 | 컴포넌트·공식·**단가값 재사용**(mat_cd 키만 신규) |
| 실무진 마이그레이션 정합 | ✗ del_yn=Y 삭제코드 부활 | ✓ 활성코드 가격완성 |
| 손님 표시명 | canonical generic 로 회귀 | 실무진 상세명(유포80g) 유지 |
| 행수 | 14 UPDATE | 2,733 INSERT |

- **권고=B**. A는 이 상품군에선 **가격이 안 작동**(§1 소스 규명) → 실효 배제. 가격표 260527 은 generic 명(유포스티커…)을 쓰고 그 권위단가는 이미 canonical 코드에 verbatim 적재(prior round 검증) → canonical→신규 클론 = **권위단가 전파**(날조 0). 태스크 directive "신규 자재별 단가행 필요시 가격표 verbatim" 정합.
- **dedup 부채**: 같은 자재가 canonical+신규 2코드 → §17 dedup 후속(구 canonical use_yn=N 정리). 이번 범위 밖·명시.

## 3. ★disjoint 입증 (공유공식 PRF_STK_FIXED 4상품)

신규행은 `mat_cd` 로만 매칭(use_dims·ROW mat_cd non-NULL) → **신규 mat 선택시만 매칭**.
- 584/585/586/609: 052·058 공유(동일 물리자재·동일가·정상) · 다른상품 미제공 → 무영향.
- 371/372: 053 전용 · 594: 067 전용 · 각 배타.
- 타 스티커상품(056/057/066 등 canonical 코드)은 신규 mat_cd 미선택 → 매칭0 → 무영향. **이중청구 0**(dryrun 검증4: 신규 mat 은 COMP_STK_PRINT·TATTOO 에만·2400+333행).

## 4. 실행 매핑 (dryrun) + 골든

| 상품 | 신규 mat | ← canonical src | 행수 | 골든(A5 SIZ_000170) |
|---|---|---|---|---|
| 052/058 | MAT_000584 유포80g | MAT_000153 유포 | 504 | qty1=6,000 qty100=520,000(unit5,200) |
| 052/058 | MAT_000585 무광코팅 | MAT_000155 무광 | 468 | qty1=7,000 |
| 052/058 | MAT_000586 유광코팅 | MAT_000156 유광 | 468 | qty1=7,000 |
| 052/058 | MAT_000609 미색 | MAT_000242 미색 | 468 | qty1=6,000 |
| 053 | MAT_000371 투명백색후지 | MAT_000162 투명 | 246 | qty1=7,000 |
| 053 | MAT_000372 투명후지 | MAT_000162 투명 | 246 | qty1=7,000 |
| 067 | MAT_000594 타투 | MAT_000167 타투(TATTOO) | 333 | 90x190 SIZ_000060 min3=6,000 min6=10,000 |

- dryrun 실증(BEGIN…ROLLBACK·RC0): 신설 504/468/468/468/246/246/333 = 기대 일치 · **클론=원본 diff 0행**(verbatim) · CONFIRM분(611/593) 0행.
- **시뮬레이터 실측 기대(COMMIT 후 검증대상)**: 052 유포(584)·A5·qty100 → **520,000** / 052 미색(609)·A5·qty1 → 6,000 / 053 투명(371)·A5·qty1 → 7,000 / 058 무광(585)·A5·qty1 → 7,000 / 067 타투(594)·qty3 → 6,000. (procs 는 커팅 비가격이라 불요·모드 lenient)

## 5. 제외 — CONFIRM (권위 미정·추측 적재 금지)

1. **MAT_000611 아트스티커 90g** (052·058): 가격표 260527·라이브 어디에도 "아트스티커" 단가행 없음(canonical MAT_000610 도 무가격). → **보스 단가 컨펌** 또는 근사자재(084 비코팅/242 미색) 매핑 의사결정. 미해소시 이 옵션만 견적0 잔존.
2. **MAT_000593 유포+무광쿨코팅** (055): canonical MAT_000165(유포지+엠보코팅) 무가격. 쿨코팅 프리미엄 모호(153 유포 6,000 vs 155 무광코팅 7,000). memory 선례는 055→153 재키잉이나 코팅 저청구 위험 → **단가 원천 컨펌**(153 클론 / 155 클론 / 보스단가). 055 는 유일자재라 미해소시 상품 전체 견적0.

## 6. 무조치 — 커팅 proc (비가격 선택수단·이중청구 가드)

- PROC_000054 반칼(052/053)·PROC_000053 완칼(055): COMP_STK_PRINT `use_dims` 에 **proc_cd 없음** — 커팅은 **사이즈에 내재**(SIZ_000520=A4반칼 은 별도 siz_cd). 단가행 신설 시 **이중청구** → 신설 금지(C_missing_dim_wiring 의 proc_cd 결손은 이 상품군에선 by-design·결함 아님).
- PROC_000008 화이트인쇄(053): 별색component 영역(자재 범위밖) → 별도 검토 CONFIRM([[whiteprint-material-4color-unified-spot-component]]).

## 7. 동반 CONFIRM — 사이즈 dedup (별건)

052/053(057·196·258·426)·055(198·258·315)·058(258·426) 은 **가격원천 없는 중복/비권위 사이즈** — 자재 신설 후에도 이 사이즈 선택은 견적0 잔존. memory(보스 '중복사이즈 빼기' 승인) 선례로 §26/§17 사이즈 dedup 라우팅(본 범위 밖).

## 8. 산출물 / 라우팅

- `design-sticker-material-260701.md`(본) · `sticker-material-backup-260701.csv`(대상·CONFIRM·무조치 결정표·pre-state 0행) · `sticker-material-fix-dryrun.sql`(BEGIN…ROLLBACK·검증1~5·멱등 NOT EXISTS) · `sticker-material-undo.sql`(mat_cd+마커 정확삭제).
- 실 COMMIT: **인간 승인 후** sticker-material-fix.sql(dryrun의 BEGIN/ROLLBACK만 제거·§7 트랙) + **webadmin 가격시뮬레이터 실화면 확인 필수**(제외0·PRICE≠0) [HARD].
- 검증(생성≠검증): 본 설계=생성측. dbm-validator/codex 교차·evaluate_price 실호출 disjoint·§17 dedup 부채는 후속.
