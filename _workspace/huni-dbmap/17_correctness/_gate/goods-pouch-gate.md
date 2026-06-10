# 굿즈파우치 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자 = 게이트 무결성). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/goods-pouch/` 5종.
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 read-only psql SELECT) 동반. oracle 인용은 `raw/webadmin/` 소스 직접 Read로 실존·내용 일치 확인. 라이브 값은 auditor SELECT를 신뢰하지 않고 **검증자가 다시 SELECT**로 재현. 발견 결함은 라우팅만(산출물 직접 수정 금지).
> **기준선:** `17_correctness/_gate/digital-print-gate.md`(K0~K6 포맷·증거밀도).

---

## 0. 최종 판정: **GO** (F-GP-GATE-1 보정 재게이트 후 — 2026-06-11)

> **갱신 이력:** 1차(06-11) = CONDITIONAL-GO(K4 ⚠️·F-GP-GATE-1 발견). `dbm-correctness-auditor` 보정 후 **K4 재게이트(06-11) = PASS** → 굿즈파우치 **GO**. K0~K3·K5·K6은 1차 PASS carry-forward(재검 불요). 상세 재판정은 §11.

방법론(라이브=피고·oracle=정답)·정체 확정·oracle 인용 실재성·적재로직 재구성·교정 비파괴성이 디지털인쇄 파일럿 수준으로 견고하고(K0/K1/K2/K3/K5/K6 PASS), 1차에서 적발한 K4 결함(F-GP-GATE-1 "CPQ 전면 미적재" 과대 단언)이 보정 완료·검증자 독립 재실측으로 정확성 확인됨(굿즈 범위 183~290=0행 한정, 전역 잔재 6행 별기). 교정 17건·GP-C-10 라우팅 불변·scope 보존 확인 — round-5/6/10 적재 트랙 진입 안전(컨펌 5건 인간 승인 대기, DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ PASS | 19 상품군·9 대표 정체표가 범주(굿즈/패션잡화)·구성(단품)·생산방식·출처(product-bom §·product-master) 명기. "정체 오분류 0"(라이브 결함=속성축 적재 결함이지 범주 아님) 주장이 round-11 BOM 권위와 정합. 거울/머그/티셔츠 등 일상 굿즈=비전형 부재(사이트 재크롤 불요)가 타당 |
| **K1** 추출규칙 커버리지 | ✅ PASS | 10 대표상품 × 5속성축 + 굿즈 3축(카테고리·CPQ옵션·추가상품) = §0 매트릭스 전수, N/A 사유 명기(도수=만년스탬프만·추가상품=볼체인/리필잉크만), 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ PASS | 표본 11건(load_master 39/164-178/261/269/324/326/415/436·RELATIONS 469-481·fix_size_dims) 전건 Read 실존·내용 일치. round-11 G-1 날조 재발 0 |
| **K3** 적재로직 근거 | ✅ PASS | "load_master=순수 전파기·진원=v03 마이그레이션" 주장이 코드 근거로 정당(변환 로직 실제 부재를 §1~§5에서 입증). "적재경로 부분 불명"(v03 미동봉) 정직 표기 |
| **K4** 라이브 실측 독립 재현 | ✅ **PASS**(재게이트) | 1차 핵심 14건 일치. F-GP-GATE-1 보정(GP-C-10 "굿즈 183~290=0행" 범위 한정·전역 잔재 6행 별기)을 검증자 독립 재실측으로 확인(굿즈 0·전역 6 일치). 분류 17건·라우팅 불변·scope 보존(§11) |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0. EXTRA(고아노드)=논리삭제(use_yn=N) 제안. 정상노드 재연결(165~169·213~221 실재 입증)·볼체인/리필잉크 별 PRD 재사용 = search-before-mint 준수 |
| **K6** 오모델 정합 | ✅ PASS | 색≠자재(본체색 2축)·별색=공정·판수=앱·size↔option 경계(기계적 size 삭제 금지)·이중역할 — OM-2/메모리 권위와 정합 |

---

## 1. K0 — 상품 정체 확정 (PASS)

- product-identity가 19 상품군 × 9 대표 정체표를 범주(굿즈 009 액세서리/패션잡화 파우치·에코백)·구성(단품)·생산방식(UV/전사/패브릭→봉제/이지굿즈 PVC고주파/만년도장)·출처(product-bom §1~§13·process-recipe·wowpress 대조)로 명기.
- **"정체 오분류 0" 주장의 타당성:** 디지털인쇄(배경지=포장세트 오분류 적발)와 달리 굿즈파우치는 정체가 round-11 BOM에서 이미 확정됐고 라이브 결함은 정체가 아닌 **속성축 적재 결함**(F-ID-1~5)이라는 주장 — 거울/머그/핀버튼/티셔츠/파우치 전부 일상 굿즈로 비전형 부재가 타당. 정체 불명을 추측 단정한 곳 없음(🔴 Q-GP-1 폰기종 size/option은 컨펌으로 정직 보류).
- **독립 확인:** CAT_000010=라이프(lvl1 ROOT)·CAT_000011=에코백(lvl1)·CAT_000009=아크릴(lvl1) 라이브 실측으로 거울→라이프·레더→에코백 정체 트리 권위 확인.

## 2. K1 — 추출규칙 커버리지 (PASS)

- extraction-plan §0 매트릭스 = 10 대표상품 × 8축(size·자재·공정·도수·인쇄옵션·카테고리·CPQ옵션·추가상품). 각 축 §1~§8에 엑셀 출처(C5/C7·C15/C12·C12/C17·C5·C11·C1·C5·C22)·변환·목표 t_*·oracle 근거 동반.
- N/A 사유 명기: 도수=굿즈 대부분 N/A(만년스탬프 잉크색만)·추가상품=볼체인/리필잉크만·미저장(판수=앱·블리드/재단/출력용지규격=굿즈 리지드 무의미). **빈칸 0 확인.**

## 3. K2 — oracle 인용 실재 (PASS)

표본 11건 전건 Read로 실존·내용 일치(MIS-LOADED/MISSING 인용 포함):

| 인용 | 파일:라인 | 주장 내용 | 실측 결과 |
|------|----------|----------|:--:|
| 적재원 v03 | load_master.py:39 | `XLSX="...prdmaster_full_migration_v03_20260518.xlsx"` | ✅ 정확 |
| 카테고리 upr NULL→UPDATE | load_master.py:170-178 | INSERT upr=NULL(171) 후 상위코드 있는 행만 UPDATE(175-177) | ✅ 정확 |
| MES 무조건 None | load_master.py:261 | `None # MES_ITEM_CD: 전량 NULL` | ✅ 정확 |
| qty_unit None | load_master.py:269 | `None # qty_unit_typ_cd: 시트10에 원천 컬럼 없음` | ✅ 정확 |
| usage 빈값→공통 | load_master.py:324 | `enum_code("USAGE", r["용도"] or "공통")` | ✅ 정확 |
| 자재 무변환 전파 | load_master.py:326 | params.append(...MAT...usage...) 변환 없음 | ✅ 정확(인접 :324 enum이 변환 전부) |
| MAT_TYPE 라벨변환 | load_master.py:237-239 | enum_code("MAT_TYPE", 자재구분) | ✅ 정확(MAT_TYP_OVERRIDE는 책자/레더 전용·굿즈 무관) |
| 공정 무변환 1:1 | load_master.py:415 | params.append(...PROC...) | ✅ 정확(범위 내 무변환) |
| addon 시트20만 | load_master.py:436-444 | `read_sheet(wb,"20_상품별추가상품")`만 | ✅ 정확 |
| CPQ 옵션 로더 부재 | RELATIONS 469-481 | 11 RELATIONS에 옵션 로더 없음 | ✅ 정확(option_groups/items 로더 전무) |
| 치수 파싱 | fix_size_dims.py | size명 치수 파싱 NULL 보정 | ✅ 정확(사각손거울 work=cut 정상) |

**round-11 G-1 권위 날조 재발 0** — 인용 전건 실존·일치.

## 4. K3 — 적재로직 근거 (PASS)

- **핵심 주장 "load_master=순수 전파기·진원=v03 마이그레이션 정규화 단계(레포 미동봉)" 정당성 판정:** loadlogic-notes §0~§5가 자재(`:326` 무변환)·사이즈(`:307` 1:1)·카테고리(`:170/175` 빈 상위코드 무추론)·공정(`:415` 무변환)·도수/addon(v03 입력 부재) 전 경로에서 **load_master에 변환 로직이 실제 부재함**을 코드로 입증. 검증자 Read 결과 동일 확인 — `load_rel_materials`(:318-333)는 `MAPS["MAT"]`로 코드 remap만, 색상/형상/사이즈를 자재로 분류·폭증시키는 로직 없음. `load_categories`는 상위코드 빈 행을 NULL로 둘 뿐 부모 추론 없음. **따라서 "F-ID-1/2/3의 1차 진원은 v03, load_master는 충실 전파"는 추측이 아니라 코드 부재의 정직한 결론** — 정당.
- **"적재 경로 부분 불명"(L-GP-1~5 v03 vs load 진원):** v03 xlsx(`data/raw/` 미동봉) 부재로 v03 단계 vs load 단계 진원 구분이 단정 불가함을 정직 표기(침묵 추정 아님). finding 자체로 인정.
- **MES/qty_unit(L-PA-A 동형):** load_master가 None 적재인데 라이브 일부 채워짐 → "webadmin 밖 후속 손작업=적재경로 불명" 정직 표기. 라이브 실측(MES 일부 채움)이 이를 뒷받침.

## 5. K4 — 라이브 실측 독립 재현 (CONDITIONAL — 1건 어긋남)

검증자 독립 read-only SELECT로 14건 재현. **13건 일치, 1건 어긋남:**

| 측정 | 매니페스트 주장 | 검증자 독립 재현 | 일치 |
|------|----------------|----------|:--:|
| 굿즈 횡단 집계(183~290) | sizes28·mats130·procs6·printopts0·addons0·optgrp0·sets0 | 28\|130\|6\|0\|0\|0\|0 | ✅ |
| 반팔티셔츠 자재 | 8행·MAT_TYPE.09·USAGE.07 | 8\|MAT_TYPE.09\|USAGE.07 | ✅ |
| 카테고리 분포(183~290) | NORMAL56·ORPHAN35·ROOT8 | 56\|35\|8 | ✅ |
| 거울 5상품 카테고리 | CAT_000301 소품(NULL·lvl3 고아) | 5상품 전부 CAT_000301 소품 NULL 3 | ✅ |
| 거울 정상노드 165~169 | upr=010 라이프·lvl2 실재 | 165~169 전부 upr=CAT_000010·lvl2 | ✅ |
| CAT_000010 정체 | 라이프 | 라이프(lvl1 ROOT) | ✅ |
| 사각손거울 size | S/M/L 치수형 정상 | SIZ_000384 S(75x130)·386 M·388 L work=cut | ✅ |
| 굿즈 공정 6행 | 전부 캔버스류 PROC_000081 부착 | 캔버스 심플백/에코백/필통2/파우치2 전부 081 부착 | ✅ |
| 고아 노드 전수 | CAT_000293~306 14개·lvl3·NULL | 14개 전부 lvl3 | ✅ |
| 굿즈 고아별 연결수 | 소품5·데스크9·말랑9·레더9·디지털악세2·에코백부자재1 | 301=5·302=9·303=2·304=9·305=9·306=1 | ✅ |
| 레더파우치 정상노드 213~221 | upr=011 에코백·lvl2 실재 | 213/215/221 upr=CAT_000011·lvl2 | ✅ |
| 볼체인 자재(악세 연계) | 8행 MAT_TYPE.10 | 8\|MAT_TYPE.10 | ✅ |
| 굿즈(183~290) option_groups | 0 | 0 | ✅ |
| **"색상 옵션 전무" 일반 서술** | **option 0행** | **PRD_000001/002 테스트 잔재 optgrp 2행 실재** | ❌ **F-GP-GATE-1** |

- **F-GP-GATE-1 상세:** product-identity F-ID-4·extraction-plan §7·correction-manifest GP-C-10은 "option_groups=0(굿즈 전체)"·"CPQ 레이어 전면 미적재"를 주장. **굿즈 범위(PRD_000183~290)는 검증자 재현으로 0 확인 — 정확.** 그러나 전 DB 옵션그룹 분포 측정 시 `PRD_000001 OPT-000003 "테스트"`·`PRD_000002 OPT-000001 "제본방식"` 2행이 실재(둘 다 봉투 부자재인데 봉투와 무관한 테스트/잔재). 굿즈파우치 산출물은 굿즈 범위만 다루므로 이 잔재는 **굿즈파우치 진단에 영향 0**이나, 상품악세사리(PRD_000001~015)와 범위가 겹치고 악세 산출물이 "옵션 0"을 단언한 것과 연결 — **상품악세사리 게이트의 F-PA-GATE-2와 동일 결함의 다른 표면**. 굿즈 게이트에서는 "굿즈 범위 0행 정확, 단 전역 'CPQ 전면 미적재' 단언은 봉투 영역 테스트 잔재 2행 반례 존재"로 정밀화 권고(경미).

## 6. K5 — 비파괴·search-before-mint (PASS)

- correction-manifest §2: COMMIT/DDL/DELETE 0. 교정은 UPDATE(카테고리 재연결·자재유형 정정)·INSERT(공정/도수/addon)·논리삭제(use_yn=N) **제안**.
- EXTRA(GP-C-02 잉여 고아 노드 6개)=hard-delete 아닌 `use_yn='N'` 논리삭제 제안.
- **search-before-mint 입증(검증자 재현):** 거울 정상노드 CAT_000165~169(upr=010)·레더 CAT_000213~221(upr=011) 라이브 실재 확인 → 신규 부모 부여보다 기존 정상노드 재연결이 정답. 볼체인 PRD_000006·리필잉크 PRD_000015 별 PRD 실재(addon 재사용). ddl-proposer 라우팅 = GP-C-02(고아 정리) 1건뿐(option_items/sets/addons 테이블 실재 — 스키마 부족 없음).

## 7. K6 — 오모델 정합 (PASS)

- **색≠자재:** 축② "본체색=재질행 합성(색×규격 2축 분리)"·F-ID-2 "8행 직교 폭증=과분할" — 메모리 dbmap-material-option-normalization 정합.
- **size↔option 경계:** GP-C-11 "치수형 22행 보존·기계적 size 삭제 금지(OM-2 가격사슬 파손)"·GP-C-15 폰기종=size vs option 컨펌 보류 — OM-2 정합.
- **판수=앱:** §9 "다면 임포지션=앱 런타임 DB 미저장" 명기.
- **별색=공정·usage=USAGE.07:** GP-C-12 "USAGE.01=내지 가정 정정, 공통이 정답"(round-11 CONFIRM-GP-5 정정) — 라이브 실측(티셔츠 USAGE.07) 정합.

---

## 8. 적발한 게이트 결함

| ID | 결함 | 심각도 | 어느 산출물·어느 주장 | 독립 증거 | 라우팅 | 상태 |
|----|------|:--:|------|------|------|:--:|
| **F-GP-GATE-1** | "option_groups=0(굿즈 전체)"·"CPQ 레이어 전면 미적재" 일반 서술이 PRD_000001/002 테스트 잔재 옵션그룹 2행 존재를 누락. 굿즈 범위(183~290)는 0 정확하나 봉투 부자재 영역(001/002)에 "테스트"·"제본방식" optgrp 실재 | Low | product-identity F-ID-4·extraction-plan §7·correction-manifest GP-C-10 — "CPQ 레이어 전면 미적재" 단언 | `SELECT prd_cd,opt_grp_cd,opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015'` → `PRD_000001\|OPT-000003\|테스트`·`PRD_000002\|OPT-000001\|제본방식` (2행). 굿즈 183~290 = 0행(주장 정확) | `dbm-correctness-auditor`(서술 정밀화: "굿즈 범위 0·봉투 영역 테스트 잔재 2행 별도") | 미보정(권고) |

> **부정확/날조/추측 여부 판정:** F-GP-GATE-1은 **날조 아님**(굿즈 범위 0행은 정확). **추측 아님**(코드 근거 정직). **부정확한 일반화** — "굿즈 전체 0"은 맞으나 산출물이 동일 prd_cd 범위를 공유하는 봉투 영역까지 "CPQ 전면 미적재"로 확대 단언한 것이 반례에 걸림. 진단 결론(굿즈 색상 옵션 미적재→round-6 신규 적재 필요)은 유효.

## 9. 독립 재현이 어긋난 측정

- **1건(F-GP-GATE-1):** 옵션그룹 전역 0행 단언 ↔ 실제 봉투 부자재(001/002) 테스트 잔재 2행. 굿즈 핵심 범위는 일치. 그 외 13건 전건 일치(횡단집계·자재 행수·카테고리 분포·고아노드·공정·정상노드 실재 등 — 검증자 SELECT가 매니페스트 값과 byte 수준 동일).

## 10. 권고 — GO 인계 가능 여부

- **CONDITIONAL-GO.** 라이브 정합 교정 방법론·정체 확정·oracle 실재성·적재로직 재구성·비파괴 교정이 디지털인쇄 파일럿 수준으로 견고. K4 어긋남 1건은 경미(굿즈 진단 결론 무영향·옵션 잔재는 봉투 영역). **F-GP-GATE-1 서술 정밀화 후 GO 인계 가능** — 인계 차단 사유 아님(잔재 2행은 굿즈 교정 매니페스트 어느 항목도 바꾸지 않음).
- **잔존 컨펌 5건(인간 결정 대기):** Q-GP-1(폰기종/등급 size vs CPQ option)·Q-GP-2(본체색×규격 2축 분리·글리터/멜란지)·Q-GP-3(굿즈 가공 택일그룹·excl_grp_cd sql/23 삭제)·Q-GP-4(잉여 고아 노드 재연결/논리삭제/부모부여)·Q-GP-5(인쇄방식 7종 PROC root·외주 표현). 전건 적재/DDL/논리삭제는 인간 승인 — DB 미적재 유지.
- **DB 쓰기 0** — 본 게이트 read-only SELECT + 소스 Read만.

### 최종 매트릭스 (1차)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ⚠️ COND(F-GP-GATE-1) | ✅ PASS | ✅ PASS |

---

## 11. K4 재게이트 — 정식 검증자 판정 (2026-06-11, `dbm-validator` 독립)

> 1차(§0~10)는 K4 ⚠️CONDITIONAL. `dbm-correctness-auditor`가 F-GP-GATE-1을 보정 → **K4만 재게이트**(K0~K3·K5·K6 1차 PASS carry-forward). 아래는 생성자와 분리된 검증자가 **라이브 독립 재실측**으로 보정 정확성을 판정한 정식 판정(이 판정이 권위).

### K4 재판정: ✅ **PASS** — 3개 재게이트 기준 전건 충족

**① 굿즈 범위(183~290) option_groups 0행 한정 — 독립 SELECT 대조:**
```sql
SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290';
-- → 0
```
보정된 GP-C-10 "굿즈(183~290) option_groups=0행"이 라이브 정확. 1차 "CPQ 레이어 전면 미적재" 과대 단언이 범위 한정으로 정정됨.

**② 전역 잔재 6행 별기 정확 — 독립 SELECT:**
```sql
SELECT prd_cd, count(*) FROM t_prd_product_option_groups GROUP BY prd_cd ORDER BY prd_cd;
-- → PRD_000001|1  PRD_000002|1  PRD_000066|1  PRD_000138|3   (총 6행)
```
보정 서술 "전역 6행은 001/002 테스트 잔재·066·138 = 굿즈 무관"이 라이브와 일치. 001(테스트)·002(제본방식)은 봉투 부자재 영역(악세 게이트 F-PA-GATE-2와 동일 표면), 066/138은 굿즈 범위(183~290) 밖 = 굿즈 무관 정확.

**③ 분류 17건·GP-C-10 라우팅 불변·scope 보존:** correction-manifest §1 분류 분포 = CORRECT 4·MIS-LOADED 6·MISSING 4·EXTRA 1·AMBIGUOUS 2 = **17건 불변**(1차와 동일). GP-C-10 라우팅 = "round-6 옵션 매핑+컨펌" **불변**(분류도 MISSING 유지 — 굿즈 옵션형 사이즈는 실제 미적재이므로 MISSING 정확, 보정은 서술 범위만 정밀화). GP-C-01~09·11~17 미변경 = scope 위반 0. 보정이 새 결함·새 BLOCKED/GAP 생성 0.

### 최종 매트릭스 (K4 재게이트 후)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS(재게이트) | ✅ PASS | ✅ PASS |

**굿즈파우치 최종 판정: GO.** K0~K6 전건 PASS. 잔존 컨펌 5건(Q-GP-1~5)은 인간 결정 대기. 교정 실행(재연결 UPDATE·MIS-LOADED 정정·MISSING INSERT·CPQ round-6 신규 적재)은 round-5/6/10 트랙 + 인간 승인 — DB 미적재 유지. **본 재게이트 DB 쓰기 0**(read-only SELECT + 산출물 Read만).
