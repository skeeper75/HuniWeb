# round-3 처리(적재) 설계 — 전수 통합 대시보드 (11시트)

> **목적:** `08_remediation/` 11시트 결함 진단을 입력으로, 결함을 처리(적재)하는 **적재 설계서 + 적재용 CSV + 자동대조 게이트**를 FK순으로 산출한 전수 결과를 종합한다.
> **방법:** digital-print 파일럿(패턴+게이트 정립) → Wave A(5시트)/Wave B(4시트) 병렬 적재설계(`dbm-mapping-designer`) → 독립 적대 검증(`dbm-validator`) → NO-GO/CONDITIONAL 2시트 보정.
> **권위(HARD):** 라이브 DB > 08_remediation 기록 라이브결과 > ref-*.csv(stale 2026-06-04). L1 엑셀 > 정규화. 추정 0(provenance).
> **DB 미적재(HARD):** INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 게이트뿐. **실제 적재는 별도 인가.**
> **작성** 2026-06-05 · 식별자/테이블/컬럼/코드/SQL 영어, 설명 한국어.

---

## 0. 한 줄 현황

11시트 전수 적재 설계 완료. **전 시트 self-check 게이트 PASS(누락0·날조0)**. 독립 검증: **GO-WITH-FINDINGS 9시트 + 보정 후 GO 2시트(calendar·acrylic)**. NO-GO 블로커 0(보정 해소). active 적재 ~835행 + UPDATE-set 다수. **DB 미적재 유지** — 적재 직전 라이브 export 게이트 재실행 + 시트별 컨펌 해소가 적재 전 조건.

---

## 1. 전수 적재 행수 매트릭스 (시트 × 주요 산출)

| 시트 | active INSERT 핵심 | UPDATE-set | 보류(conditional/deferred/blocked) | 검증 |
|------|-------------------|-----------|------------------------------------|------|
| **digital-print**(파일럿) | material 180·process 26·addon 2 | qty 36 | 016 process 4(DROP확정)·038 deferred·엽서봉투 flag | GO-W-F |
| **booklet** | material 83(내지/표지 IMPORT)·process 4(형압) | qty 11 | PUR/하드커버 자재 6(소스부재)·page잡음 flag | GO-W-F |
| **stationery** | process 13(제본6+코팅7) | qty 11 | 097 정정후보·excl 보류 | GO-W-F |
| **sticker** | process 3(화이트별색) | qty 16 | 066 원형 11(BLOCKED master부재)·064 deferred | GO-W-F |
| **product-accessory**(대조군) | (정합양호 — 적재 최소) | qty 15 | bundle 9 deferred | GO-W-F |
| **photobook** | (거의 기적재 no-op) | qty 1 | 책등 param(스키마 슬롯 부재)·복합분해 proposal | GO-W-F |
| **calendar** | material 43·excl_link 4(택일연결) | qty 5 | material 4 conditional(보정)·장수/링칼라 12·미연결멤버 6 | **보정후 GO** |
| **design-calendar**(신규 등록) | t_prd_products 5(신규)·size 5·material 5·print 5·page_rule 5·addon 2·process 2 | — | editor_yn UPDATE 철회(라이브 정정)·placeholder prd_cd(후니 부여)·삼각대/링칼라 flag·가격 round-2 | **신규등록 GO·Q-DC-0 승인 대기** |
| **acrylic** | process 29(완칼14·UV14·부착1)·material 10·bundle 6 | 두께 20·UV정정 20·nonspec 12·qty 23 | 완칼 over-reach 3·151 conditional(보정)·★/use_yn=N | **보정후 GO** |
| **silsa** | process 1(화이트별색)·addon 1 | nonspec 13·qty 28 | 보드자재 7·addon flag 9·★ 2(발명회피) | GO-W-F |
| **goods-pouch** | addon 1 | qty 98 | **size 77 BLOCKED-LEGIT**·폰케이스 5 비활성 | GO-W-F |

- **마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`·sets)는 전 시트 무변경** — 상품 연결 테이블(`t_prd_product_*`)만 적재. 모든 prd_cd FK 라이브 실재 확인.
- **UPDATE-class 산출**(컬럼 갱신, INSERT 아님): qty_unit(전시트)·excl_grp_cd(calendar 택일연결)·두께/UV/nonspec(acrylic)·nonspec(silsa). 별도 `*_update.csv`로 분리(현재값+목표값+provenance). (~~editor_yn(calendar/dc)~~ **철회 2026-06-05** — 디자인캘린더는 신규 별도 prd_cd 등록 INSERT-class로 재분류, `09_load/design-calendar/`).

---

## 2. 독립 검증 종합 (적대적 — dodge/발명 적발 우선)

| Wave | 검증자 | 시트 | 판정 | 쟁점 UPHELD/OVERTURN |
|------|--------|------|------|----------------------|
| 파일럿 | dp-load-validator | digital-print | GO-W-F | 6 UPHELD / 0 |
| A1 | val-A1 | booklet·stationery·photobook | GO-W-F | 11 UPHELD / 0 (과소적재 dodge 0) |
| A2 | val-A2 | sticker·product-accessory | GO-W-F | 11 UPHELD / 0 (대조군 합리화 0) |
| B1 | val-B1 | calendar·goods-pouch | calendar NO-GO→보정·gp GO-W-F | size BLOCKED-LEGIT·택일 PARTIAL·material PK충돌4 |
| B2 | val-B2 | acrylic·silsa | acrylic CONDITIONAL→보정·silsa GO-W-F | 완칼 14 grounded/3 over-reach·151 BLOCKER |

**검증이 잡은 실결함(보정 완료):**
1. **calendar material 4행 라이브 PK충돌** — stale 게이트가 못 본 중복 INSERT. → conditional 이동(47→43), 게이트 PASS.
2. **calendar 택일 H5 PARTIAL** — 110·112 단일멤버 택일(기능 미성립). → "부분해소+컨펌"으로 정직 표기(미연결 6멤버 발명 금지).
3. **acrylic 151 PROC_000081 중복PK** — 맥세이프 부착 기적재. → conditional 이동.
4. **acrylic 완칼 over-reach 3건(161·168·169)** — RULE은 grounded하나 product-level 근거 부재 blanket. → deferred 이동(17→14), `R1-diecut-overreach 0` 가드 신설.

**핵심 교훈(메서드 결함):** acrylic 완칼 게이트는 생성기·검증기 둘 다 `diecut=True` 하드코딩 = **순환 검증**(과적용 검출 불가). 보정 게이트는 per-product 근거 리스트 독립 대조로 강화. → 타 시트 게이트도 "생성기 출력 미신뢰 독립 재생성" 원칙 재확인.

---

## 3. 공통 처리 패턴 (시트 횡단)

1. **비활성(use_yn=N·★·그레이밴딩)≠MISSING (C-1)** — 전 시트 active 제외, `_deferred/` 기록만. ref-products.csv 교차확인(가정 금지). 적재는 출시 시점.
2. **IMPORT 자재 (C-3)** — `*별도설정`→출력소재 IMPORT ● 종이→mat_nm exact 매치. **digital-print 180·booklet 83·calendar 43 집중**. usage_cd: 낱장=.07공통 / 책자=.01내지·.02표지. 직접명 자재(stationery·sticker·silsa)는 IMPORT 우회.
3. **variant 분해 (C-8 관리용이성)** — 두께→material(acrylic MAT_042~044)·색상→material·사이즈→size·표지타입→sub_prd. 과세분화 금지(금색열쇠고리 통합). 평면화 해소.
4. **완칼=공정+조각수=bundle_qty (C-7)** — acrylic/sticker. 조각수 bundle_qty 차원, 위젯표시 조각수. 가격은 round-2.
5. **캐스케이드 제약 (benchmark §9, 신설 1)** — digital-print "180g 미만→코팅 disable"가 유일 grounded. `constraint_json`(jsonb 컬럼 실존) 인코딩 권고. 타 시트 grounded disable 없으면 발명 금지.
6. **UPDATE성 처리** — excl_grp_cd(택일연결)·print_side 정정(UV)·qty_unit은 기존행 컬럼 갱신 → 별도 update-set CSV(INSERT 아님). (~~editor_yn(design-cal)~~ 철회 2026-06-05 — 디자인캘린더 신규 별도 prd_cd 등록 INSERT로 재분류).
7. **모범 재적재 금지** — silsa 봉제/타공/족자/부착/코팅(정합 적재)·photobook 9속성·sticker 커팅·product-accessory 분기는 **정상**, 재적재 0(기계 보증).

---

## 4. BLOCKER 3건 최종 처리

| BLOCKER | 시트 | 처리 결과 |
|---------|------|----------|
| **H1 size 77상품** | goods-pouch | **BLOCKED-LEGIT** — L1 `재단사이즈` 컬럼 전 공란(재단치수 원천 부재). plate 복제·siz_cd 발명 거부 정당. **진짜 과제 = 비치수 사이즈 마스터 모델링 미정**(후니 컨펌, 라이브로도 해소 안 됨). 125행 reference 보존. |
| **H5 calendar 택일그룹** | calendar | **PARTIAL** — excl_link 4행 UPDATE로 멤버 연결(타깃 실재). 단 110·112는 단일멤버라 기능상 택일 미성립. 미연결 6멤버는 master proc_cd 부재(발명 금지) → 컨펌. |
| **(H2 폰케이스)** | goods-pouch | **해제** — C-1로 그레이밴딩=미출시/보류=비활성(결함 아님). 신규행 0 가드 PASS. |

---

## 5. 적재 직전 HARD 조건 (DB 쓰기 전)

1. **[HARD·전 시트] 라이브 export 게이트 재실행** — 본 게이트는 use_yn·기적재·중복PK를 **stale ref(2026-06-04)**에서 읽는다. PASS="추출본 기준 누락0·날조0"일 뿐. 적재 직전 동일 `verify_expected.py`를 **라이브 export 기반**으로 1회 재실행해 stale 격차를 닫아야 무위험(검증 권위반전 원칙). calendar PK충돌 4행이 이 한계의 실증.
2. **[HARD] conditional 행 라이브 재확인** — digital-print 016(DROP확정)·calendar material 4·acrylic 151은 라이브 기적재 의심분. 적재 직전 라이브 SELECT로 중복 여부 확정 후 active 승격/폐기.
3. **FK 적재순서 준수** — (상품등록 n/a) → size → material(IMPORT/두께 선행) → process(excl_group 연결) → addon → page_rule. UPDATE-set은 해당 단계 내.

---

## 6. 미해소 컨펌 통합 (DB 적재 전 해소 — 시트별 load-spec §컨펌 권위)

### A. 도메인 모델링 (사용자 판단 — 라이브로 해소 안 됨)
- **goods-pouch D-1**: 비치수 size 77상품 = 마스터 siz_cd 신설 vs nonspec 인코딩 (BLOCKER 본질).
- **sticker D-1/2**: 066 원형 11종 master mint + 058~062 형상 enum 축 귀속(size보조 vs 신규테이블 vs process param).
- **calendar 택일 PARTIAL**: 미연결 6멤버(가공없음/제본없음/우드거치대/삼각대) 처리 + 장수=page_rule vs variant.
- **acrylic D-AC-8**: 완칼 over-reach 3(161/168/169) 적재 여부 + 053(종이완칼) 차용 vs 레이저커팅 proc_cd 신설.
- **photobook D-PB-2**: 책등 param 적재위치(process param JSON DDL 확장 vs size variant) + 레이플랫 미운영 확인.
- **booklet D-BK-1(최우선)**: PUR/하드커버 5상품 내지종이 자재소스(IMPORT 컬럼 부재).

### B. 적재 정책 (소수 확인)
- **qty_unit 단위**: 낱장=매·책자=권·굿즈=EA — 시트별 일괄값 최종 확인(C-4 충실).
- **봉투/부속 addon 매칭**: digital-print 엽서봉투 신규등록 vs 매핑(C-6 이중성).
- **use_yn=N 미출시 처리 시점**: 출시 시 일괄 vs 지금(컬럼 무해).
- **stationery D-ST-1**: 097 제본 mand_proc_yn N→Y 정정.
- **silsa D-SL-1**: 보드/액자 자재 MAT master 부재(MAT_TYPE.08 미포함) 소스 확정.

> 상세는 각 `09_load/<sheet>/load-spec.md` §컨펌목록 + `03_validation/{dp,waveA1,waveA2,waveB1,waveB2}-load-validation.md` 권위.

---

## 7. 다음 단계

1. **미해소 컨펌 해소**(§6 A 도메인 모델링 우선 — goods-pouch size·calendar 택일·acrylic 완칼·booklet PUR자재).
2. **DB 적재 인가 시**: 적재 직전 라이브 export 게이트 재실행(§5) → FK순 적재 → conditional 라이브 재확인.
3. **가격정보(round-2 t_prc_*)**: 9속성 정제 후 이연(`06_extract/price-info-deferred.md`). round-1 구간할인 완료.

## 산출물 지도

```
09_load/
├ _load-dashboard.md        (이 문서)
├ digital-print/  load-spec.md·load/*.csv·verify_expected.py·expected-vs-load.md·_deferred·*conditional.csv
├ booklet/ stationery/ sticker/ product-accessory/ photobook/   (Wave A)
├ calendar/ acrylic/ silsa/ goods-pouch/                        (Wave B, calendar+acrylic 보정완료)
03_validation/  dp-·waveA1-·waveA2-·waveB1-·waveB2-load-validation.md  (독립 검증 5종)
```
