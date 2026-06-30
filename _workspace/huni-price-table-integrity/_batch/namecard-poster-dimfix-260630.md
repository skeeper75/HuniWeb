# 차원정합 MISSING-HIGH 교정 명세 — 프리미엄명함·포스터·아크릴 (260630)

§26 차원정합 전수진단(`dim_conformance.py`) MISSING-HIGH 적발분을 권위(가격표 260527·상품마스터 260610·추출캐시 06_extract) 대조해 분류. 봉투제작 MAT_169(권위 동일단가→단가행 복제)와 동형 점검. **라이브 읽기전용·실 COMMIT 금지(인간 승인 후 상위 §7/§18 위임).** dryrun=`namecard-poster-dimfix-260630-dryrun.sql`(BEGIN…ROLLBACK).

진단 verdict 원본: `dim-conformance-fullscan-260630.tsv`. 단가행 MAX(comp_price_id)=78967 → 신규 78968~.

---

## 분류 요약 (담당 4결함)

| # | 상품 | 차원 누락 | 분류 | 권위근거 | 교정 |
|---|------|----------|------|---------|------|
| 1 | PRD_031 프리미엄명함 | mat_cd MAT_099·119 | **② 잔여고아(cleanup)** | 가격표 B02=14용지(앙상블210·리브스디자인250 권위무근거) | option_items 2건 논리삭제 |
| 2 | PRD_132 레더아트액자 | siz_cd 304·306·308·310 | **① 진짜누락(단가有)** | 포스터사인 B15: 5x5=9000·5x7=10000·8x8=11000·8x10=13000 | 단가행 4건 INSERT |
| 3 | PRD_135 족자포스터 | siz_cd 293(A1) | **① 진짜누락+dedup** | 포스터사인 B17: A1=22000 | product_sizes 재지정 293→294 + 단가행 1건 |
| 4 | PRD_163 아크릴미니파츠 | siz_cd 365(120x50) | **① 진짜누락(단일설정)** | acrylic row103: 120x50=10000 | 단가행 1건 INSERT |

**결과: 진짜누락 3상품(단가행 6 INSERT + product_sizes 1 재지정) · 잔여고아 1상품(option 2 논리삭제) · BLOCKED 0.**

---

## 1. PRD_031 프리미엄명함 — mat_cd MAT_099·119 = ② 잔여고아 (NOT 단가추가)

**진단**: PRF_NAMECARD_PREMIUM·_FOIL 양쪽에서 mat_cd MISSING MAT_099(앙상블210)·MAT_119(리브스디자인250). PREMIUM 등급 component(S1/S2 × MGA/MGB)의 mat_cd UNION = 14용지(101,102,108,109,113,114,115,116,117,118,123,124,125,126)에 099·119 없음.

**권위 대조 — 단가추가 아님(역방향)**:
- MAT_099(앙상블210)·MAT_119(리브스디자인250)는 **t_mat_materials del_yn='Y'**(논리삭제됨) + **t_prd_product_materials del_yn='Y'**(논리삭제됨).
- 메모리 [[namecard-orphan-component-wiring-260630]]: 031 COMMIT(2026-06-30 §18 등급설계)에서 "★권위무근거 2용지(앙상블210·리브스디자인250) 논리삭제(엑셀에 없으면 제거=사용자 원칙)". 가격표 B02 권위 = 14용지(등급A 4500/5500·B 5000/6500).
- **잔여 고아**: option_items `OPV_000148`(ref_dim=mat→MAT_099)·`OPV_000159`(ref_dim=mat→MAT_119)가 **del_yn='N'**으로 손님에게 여전히 노출(16옵션). 단가행은 14용지만 → 손님이 앙상블210/리브스디자인250 선택 시 **견적불가**. 031 COMMIT에서 option_items 정리만 누락된 잔재.

**돈영향**: 견적불가(손님 선택 가능한 2용지에 단가행 0). 양방향 silent 아님 — 단순 누락.
**교정**: 단가행 추가 아님(권위무근거 자재 재유입 금지). **option_items OPV_148·159 논리삭제**(del_yn='Y')로 이미 삭제된 자재/단가행과 정합. 라우팅=§17 dedup/§7 dbmap(인간 승인). _FOIL formula도 동일 component 공유 → 1수정으로 양 공식 해소.

---

## 2. PRD_132 레더아트액자 — siz_cd 304·306·308·310 = ① 진짜누락(권위단가 有)

**진단**: COMP_POSTER_LEATHER_FRAME 단가행 = A4(SIZ_172)=16000·A3(SIZ_174)=21000 2건. product_sizes는 6사이즈 노출(172,174,304,306,308,310 전 del_yn='N'). 누락 304·306·308·310.

**권위 대조 (포스터사인 시트 B15 "사이즈/수량", 206~207행) — 단가형 고정가**:
| 권위 사이즈 | siz_cd | 권위단가 | 라이브 |
|---|---|---|---|
| 5x5 | SIZ_000304(127x127) | **9000** | ❌누락 |
| 5x7 | SIZ_000306(127x178) | **10000** | ❌누락 |
| 8x8 | SIZ_000308(203x203) | **11000** | ❌누락 |
| 8x10 | SIZ_000310(203x254) | **13000** | ❌누락 |
| A4 | SIZ_000172 | 16000 | ✅(verbatim 일치) |
| A3 | SIZ_000174 | 21000 | ✅(verbatim 일치) |

기존 A4/A3 단가가 권위와 정확 일치 = 같은 표(B15)에서 소형 4사이즈만 적재 누락. **MAT_169 동형(권위 단가 有→단가행 INSERT)**.

**돈영향**: 견적불가(손님이 소형 4사이즈 선택 시 단가행 0). **교정**: 단가행 4건 INSERT(siz_cd별 unit_price, prc_typ=단가형 unit_price, min_qty=1). 라우팅=§7 dbmap.

---

## 3. PRD_135 족자포스터 — siz_cd 293(A1) = ① 진짜누락 + dedup 재지정

**진단**: COMP_POSTER_JOKJA 단가행 = A3(174)=13000·A2(197)=15000·300x600(319)=15000·900x1200(320)=32000 4건. product_sizes 노출에 SIZ_293(A1) del_yn='N'. 누락 293.

**권위 대조 (포스터사인 B17, 211~212행)**:
| 권위 사이즈 | siz_cd | 권위단가 | 라이브 |
|---|---|---|---|
| A3 | SIZ_174 | 13000 | ✅ | A2 | SIZ_197 | 15000 | ✅ |
| **A1** | (노출=SIZ_293) | **22000** | ❌누락 |
| 300*600 | SIZ_319 | 15000 | ✅ | 900*1200 | SIZ_320 | 32000 | ✅ |

**dedup 함정**: 노출 중인 `SIZ_000293`(A1 594x841)는 **t_siz_sizes del_yn='Y'**(논리삭제됨). 라이브 정본 A1 = `SIZ_000294`(A1 594x841, del_yn='N'). 즉 product_sizes가 **삭제된 A1 코드를 노출** 중 — dedup 미전파.

**돈영향**: 견적불가(A1 22000 적재 0). **교정(2-statement)**: ① product_sizes 재지정 293→294(정본). ② 단가행 INSERT COMP_POSTER_JOKJA siz_cd=SIZ_294 unit_price=22000. 단가행만 SIZ_293에 넣으면 삭제된 코드 참조라 부적절 → 정본 SIZ_294로 통일. 라우팅=§7 dbmap + §17 dedup.

(참고 REVIEW: 족자 opt_cd OPV_033/034 천정형고리 = **REVIEW-FP**. addon은 별도 component COMP_POSTEROPT_JOKJA_CEILHOOK opt_cd=OPV_000431=6500으로 과금(권위 B16 "천정형고리 포함 6500 *2개1세트"). option_items opt_cd≠단가행 opt_cd는 addon 설계상 정상. 돈샘 아님.)

---

## 4. PRD_163 아크릴미니파츠 — siz_cd 365(120x50) = ① 진짜누락(단일설정 고정가)

**진단**: COMP_ACRYL_MINIPART_TBD 단가행 **0건**(_TBD 스캐폴드). PRF_ACRYL_MINIPART 단일 component(use_dims=[siz_cd,min_qty]), 다른 차원담당 comp 없음(union FP 아님). product_sizes=SIZ_365(120x50) 단 1개 노출.

**권위 대조 (acrylic 시트 row103)**: 아크릴미니파츠 · 사이즈 120x50mm · 투명아크릴1.5mm · 배면양면 · 10조각 · 조합형 · **가격 10000**.

**단일설정 확인**: PRD_163 노출 = materials 1·processes 1·option_groups 0·option_items 0·bundle 1. 손님 선택축 없음(자재·조각수 고정). 권위가 "조합형/10조각"이라도 **현 상품 형태는 단일설정**이라 고정가 10000이 완전한 단가. (★단, 향후 조각수/소재를 손님 옵션으로 노출하면 §18 조합형 재설계 필요 — 현재는 불필요.)

**돈영향**: 견적불가(120x50 단가 0). **교정**: 단가행 1건 INSERT COMP_ACRYL_MINIPART_TBD siz_cd=SIZ_365 unit_price=10000 min_qty=1. 라우팅=§7 dbmap(단일설정이라 §18 불요).

---

## dryrun (DB 미적재 — BEGIN…ROLLBACK)

`namecard-poster-dimfix-260630-dryrun.sql` — INSERT 6 단가행(132×4, 135×1, 163×1) + UPDATE product_sizes 1(135 dedup) + UPDATE option_items 2(031 고아삭제). 사전/사후 SELECT 검증 포함, 마지막 ROLLBACK. 실 적재는 인간 승인 후 ROLLBACK→COMMIT 전환 + undo 보유(상위 §7).
