# 상품악세사리 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자 = 게이트 무결성). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/product-accessory/` 5종.
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 read-only psql SELECT) 동반. oracle 인용은 `raw/webadmin/` 소스 직접 Read로 실존·내용 일치 확인. 라이브 값은 auditor SELECT를 신뢰하지 않고 **검증자가 다시 SELECT**로 재현. 발견 결함은 라우팅만(산출물 직접 수정 금지).
> **기준선:** `17_correctness/_gate/digital-print-gate.md`.

---

## 0. 최종 판정: **GO** (F-PA-GATE-1·F-PA-GATE-2 보정 재게이트 후 — 2026-06-11)

> **갱신 이력:** 1차(06-11) = CONDITIONAL-GO(K4 ⚠️·F-PA-GATE-1 분류 정반대·F-PA-GATE-2 잔재 누락). `dbm-correctness-auditor` 보정 후 **K4 재게이트(06-11) = PASS** → 상품악세사리 **GO**. K0~K3·K5·K6은 1차 PASS carry-forward(재검 불요). 상세 재판정은 §11.

정체 확정(카테고리 012 포장재)·oracle 인용 실재성·이중등록 의도 입증·적재로직 재구성·봉투세트 Q-ID-A 권고·비파괴 교정이 견고하고(K0/K1/K2/K3/K5/K6 PASS), 1차에서 적발한 K4 결함 2건(F-PA-GATE-1 와이어링/행택끈 색상 MISSING→MIS-LOADED 분류 정반대·F-PA-GATE-2 잔재 옵션그룹 누락)이 보정 완료·검증자 독립 재실측으로 정확성 확인됨. PA-08 재분류(PA-02 색상 오염군 흡수)가 라이브 실측(007/010 각 3행 MAT_TYPE.10)과 일치하고, 색상 오염군 집계(006=8·007=3·010=3·012=1·015=7)·분류 분포(MIS-LOADED 5→6·MISSING 4→3·합계 14 불변)·scope 보존 확인 — round-5/6/10 적재 트랙 진입 안전(컨펌 8건 인간 승인 대기, DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ PASS | 15 부자재 정체표가 범주(카테고리 012 포장재·봉투/케이스·포장부자재·상품액세서리)·구성(완제 부자재 매입/외주)·생산방식·출처(product-master:172~177·L1 MES 012·site goods_view_102) 명기. "상품악세사리=시트 라벨, 실은 포장재" 정체 확정이 MES prefix 012로 다중 뒷받침 |
| **K1** 추출규칙 커버리지 | ✅ PASS | 15 부자재 × 적용 6축(치수·묶음수·색상·가격·카테고리·template) + 인쇄 5축 N/A 사유 명기, 빈칸 0. 완제 부자재라 인쇄축 N/A가 정체 기반으로 정당 |
| **K2** oracle 인용 실재 | ✅ PASS | 표본 11건(load_master 171/175/261/269/288/300-302/324/436·migrate_phase7 215/226·09_delete_dup) 전건 Read 실존·일치. **이중등록=의도 주장이 09_delete_dup_products.sql로 입증**(281/282/283 삭제 대상 제외 확인) |
| **K3** 적재로직 근거 | ✅ PASS | "load_master=순수 전파기·3축 분해 결함=정규화 시트 작성 단계" 주장이 코드 부재로 정당. MES/qty_unit "적재경로 불명"(load None 적재 ↔ 라이브 채움) 정직 표기 |
| **K4** 라이브 실측 독립 재현 | ✅ **PASS**(재게이트) | 1차 핵심 12건 일치. F-PA-GATE-1 보정(PA-08 MISSING→MIS-LOADED·PA-02 흡수)·F-PA-GATE-2(잔재 2행 별기)를 검증자 독립 재실측으로 확인(007/010 각 3행 MAT_TYPE.10·오염군 8/3/3/1/7·잔재 001/002 일치). 분류 14건·라우팅 불변·scope 보존(§11) |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0. 정상노드(276/285/287) 재연결·봉투 template(005/006/009) 재사용·볼체인 별 PRD 재사용 입증. ddl-proposer 0(테이블 실재) |
| **K6** 오모델 정합 | ✅ PASS | 색상≠자재(PA-02)·size↔option 경계·이중등록 의도(PA-12)·봉투세트 sets+CPQ 매칭 — 메모리 정규화 권위·round-9 OTC와 정합 |

---

## 1. K0 — 상품 정체 확정 (PASS)

- product-identity §0~§2가 15 부자재(PRD_000001~015) 전부를 **카테고리 012 포장재**로 확정 — 시트 라벨 "상품악세사리"가 아닌 MES prefix 012(전 15상품)·product-master:172~177 포장 트리 매핑으로 다중 뒷받침. "봉투/케이스 11 + 상품액세서리 4"는 012 하위 구분일 뿐 별 범주 아님이 정확.
- **검증자 독립 확인:** 15 부자재 전부 라이브 prd_nm·MES 012-xxxx 일치(PA-K4-8). 정체 출처(product-master 라인·site goods_view_102) 인용 실재. 정체 불명을 추측 단정한 곳 없음(천정고리 use_yn=N·우드 길이 variant 등 🔴 컨펌 보류).

## 2. K1 — 추출규칙 커버리지 (PASS)

- extraction-plan §0~§1이 15 부자재 × 적용 6축(치수→t_siz·묶음수→bundle_qty·색상→option·가격→고정형 PRF·카테고리→정상노드·template→addon)을 상품별 정답 행수·라이브 실측 병치로 전수. 인쇄 5속성축(자재 본체/공정/도수/판형)은 "완제 부자재=인쇄 안 함" N/A 사유 §2 명기. **빈칸 0 확인.**
- 정체 기반 축 전환(디지털인쇄 인쇄 5축 → 부자재 6축)이 정당 — "이게 무엇인가"가 추출 축을 정한다는 round-13 프레임 충실.

## 3. K2 — oracle 인용 실재 (PASS)

표본 11건 전건 Read로 실존·내용 일치:

| 인용 | 파일:라인 | 주장 내용 | 실측 결과 |
|------|----------|----------|:--:|
| 카테고리 upr NULL 초기 | load_master.py:171 | INSERT ... upr_cat_cd=NULL | ✅ 정확 |
| 상위코드 있는 행만 UPDATE | load_master.py:175-177 | `for r if _norm(r["상위카테고리코드"])` UPDATE | ✅ 정확(빈 행 영구 NULL) |
| MES 무조건 None | load_master.py:261 | None # MES_ITEM_CD 전량 NULL | ✅ 정확 |
| qty_unit None | load_master.py:269 | None # 시트10 원천 컬럼 없음 | ✅ 정확 |
| 상품-카테고리 1:1 | load_master.py:288 | `MAPS["CAT"][r["카테고리코드"]]` 연결 | ✅ 정확 |
| 묶음수 enum | load_master.py:300-302 | bdl_qty + enum_code("QTY_UNIT", 묶음단위명) | ✅ 정확 |
| usage 빈값→공통 | load_master.py:324 | `enum_code("USAGE", r["용도"] or "공통")` | ✅ 정확 |
| 자재 MAT_TYPE 라벨변환 | load_master.py:236-239 | enum_code("MAT_TYPE", 자재구분) | ✅ 정확(색상 자재명은 시트 그대로·변환 없음) |
| addon 시트20만 | load_master.py:436-444 | `read_sheet("20_상품별추가상품")` | ✅ 정확 |
| TMPL- 하이픈 결합 | migrate_phase7.py:215,226 | `'TMPL-'\|\|addon_prd_cd` ON CONFLICT DO NOTHING | ✅ 정확 |
| **이중등록 삭제 제외** | **09_delete_dup_products.sql** | 중복명 7건+쓰레기 삭제, **281/282/283 미포함** | ✅ **정확** — 삭제 목록=099/113~117/167/182(8건), 281/282/283 부재 = 의도 보존 입증 |

**round-11 G-1 권위 날조 재발 0** — 인용 전건 실존·일치. **특히 K3 핵심 주장("이중등록=의도, 결함 아님")이 SQL 직접 Read로 입증** — auditor가 결함으로 오판하지 않았음이 oracle로 확인됨.

## 4. K3 — 적재로직 근거 (PASS)

- **핵심 주장 "load_master=순수 전파기·진원=정규화 시트 작성 단계(v03, 레포 미동봉)" 정당성:** loadlogic-notes §1이 카테고리(171/175 빈 상위코드 무추론)·묶음수(300-302 시트12 그대로)·사이즈(203-205 그대로)·자재(236-242 라벨변환만)·addon(436 시트20만)에서 **변환 로직 부재**를 코드로 입증. 검증자 Read 확인 — `load_rel_materials`(:318-333)는 색상을 옵션으로 분리하는 로직 없음·`load_categories`는 부모 추론 없음. **3축 분해·색상 자재화·카테고리 고아가 load_master 산물이 아니라 정규화 시트 산물이라는 결론은 코드 부재의 정직한 추론** — 정당(추측 단정 아님).
- **MES/qty_unit "적재경로 불명"(L-PA-A):** load None 적재(261/269)인데 라이브 7/15 MES·전 qty_unit 채움 → "webadmin 밖 후속 손작업" 정직 표기. 검증자 재현(MES 분포 7채움/8NULL)이 뒷받침.
- **봉투세트 미적재(L-PA-E):** addon 시트20만 읽고 배경지 C38 자유텍스트 미참조 → 디지털인쇄 L-G와 동형. 코드 근거 정확.

## 5. K4 — 라이브 실측 독립 재현 (CONDITIONAL — 1건 뒤집힘 + 1건 누락)

검증자 독립 read-only SELECT로 13건 재현. **11건 일치, 2건 어긋남:**

| 측정 | 매니페스트 주장 | 검증자 독립 재현 | 일치 |
|------|----------------|----------|:--:|
| 15 부자재 카테고리 | 전부 CAT_000293 상품악세사리(NULL·lvl3 고아) | 001~015 전부 CAT_000293 NULL 3 | ✅ |
| 포장 정상노드 | 276/285/287(upr=012·lvl2) 실재 | 273/274/275/276/283/285/287 전부 upr=012·lvl2 | ✅ |
| PRD_000283 반례 | CAT_000276 봉투/케이스 정상연결 | PRD_000283→CAT_000276 upr=012 lvl2 | ✅ |
| 이중등록 | 004=PRD_TYPE.03·281/282/283=.05 | 004 .03·281/282/283 .05 | ✅ |
| 봉투 template | TMPL-000004~009·del_yn(004/007/008=Y·005/006/009=N) | 정확 동일 (+001~003 테스트 del_yn=Y) | ✅ |
| addon 실연결 | 엽서 PRD_000016→TMPL-000005 1행만 | 프리미엄엽서→TMPL-000005 1행 | ✅ |
| MES·use_yn | 7/15 채움·8/15 NULL·천정고리 use_yn=N | 008/010/013/015 NULL·008 use_yn=N | ✅ |
| 묶음수 | 001=EA·002=매 불일치·볼체인 0행 | 001 QTY_UNIT.01·002 QTY_UNIT.02·006 0행 | ✅ |
| 가격 사슬 | 부자재 0행 | price_formulas 0 | ✅ |
| 트래싱지 003 size | 8행(3치수×묶음수 평면화) | 8행·"160x110mm(20/40/100장)" 등 | ✅ |
| 카드봉투 004 size | 2행(W/B 색상합성) | 화이트/블랙165x115mm(10장) 2행 | ✅ |
| 볼체인/리필잉크 색상자재 | 8/7행 MAT_TYPE.10 | 006=8행·015=7행 MAT_TYPE.10 | ✅ |
| **와이어링/행택끈 색상** | **material 0행·"색상 자체 없음"·MISSING(PA-08)** | **007=3행·010=3행 MAT_TYPE.10**(실버/화이트/블랙·사각검정/백색/마사) | ❌ **F-PA-GATE-1** |
| **"색상 옵션 전무" 일반서술** | **option 0행** | **PRD_000001/002 테스트 잔재 optgrp 2행** | ❌ **F-PA-GATE-2** |

- **F-PA-GATE-1(중요):** product-identity §2·live-diff §5·correction-manifest PA-08이 "와이어링(007) material 0·option 0·색상 자체 없음·**MISSING**", "행택끈(010) material 0·**MISSING**"으로 일관 주장. **검증자 독립 SELECT 결과 정반대** — 007=`MAT_000210 실버`·`212 화이트`·`213 블랙` 3행 MAT_TYPE.10, 010=`217 사각검정(100개)`·`219 사각백색`·`220 사각마사` 3행 MAT_TYPE.10. **둘 다 색상이 자재로 적재돼 있어 PRD_000006(볼체인)·PRD_000015(리필잉크)와 완전 동형의 MIS-LOADED**(MAT_TYPE.10 색상 오염). 산출물이 이를 "MISSING(색상 미적재)"으로 분류한 것은 **사실과 반대**다 — auditor의 live-diff §5 SELECT가 IN ('PRD_000006','PRD_000015','PRD_000012','PRD_000007','PRD_000010')으로 007/010을 포함했는데도 "0행"으로 기록 = **실측 누락 또는 SELECT 미실행 후 추정**으로 의심됨.
- **F-PA-GATE-2(경미):** "색상 옵션 전무"·"option_groups 0" 일반 서술이 PRD_000001(테스트)·PRD_000002(제본방식) 테스트 잔재 옵션그룹 2행을 누락. 색상과 무관한 잔재이므로 색상 옵션 미적재 결론은 유효하나 "전무" 단언이 반례에 걸림(굿즈 게이트 F-GP-GATE-1과 동일 결함의 악세 표면).

## 6. K5 — 비파괴·search-before-mint (PASS)

- correction-manifest §1: COMMIT/DDL/DELETE 0. 교정은 UPDATE(카테고리 재연결·단위 통일)·INSERT(묶음수·가격·봉투세트)·논리삭제(use_yn/del_yn) 제안.
- **search-before-mint 입증(검증자 재현):** 정상노드 276/285/287(upr=012) 라이브 실재 → 고아 293에서 재연결. 봉투 template TMPL-000005/006/009 활성 실재 → 배경지 addon/sets에 재사용(신규 mint 불요). PRD_000283 정상연결 반례가 교정 패턴 입증. ddl-proposer 라우팅 0(option_items/sets/addons/bundle 테이블 전부 실재).
- **EXTRA=0 정직:** 봉투 상품·template 잉여 적재 없음·주 결함은 미적재/오연결. 논리삭제 제안은 PA-01(고아 293)·PA-02(색상 자재 행)뿐.

## 7. K6 — 오모델 정합 (PASS)

- **색상≠자재:** PA-02 "색상→option_items, MAT_TYPE.10 자재는 오염" — 메모리 dbmap-material-option-normalization(★HARD "색상≠자재") 정합. (단 F-PA-GATE-1로 와이어링/행택끈도 동일 오염임이 드러나 PA-02 범위 확대 필요.)
- **이중등록 의도:** PA-12 "281/282/283=의도 보존(09_delete_dup 삭제 제외)" — round-9 OTC TEMPLATE 권위 정합·SQL 입증.
- **봉투세트(Q-ID-A):** §5 권고 = sets + CPQ 사이즈매칭 캐스케이드 — 사이트 "세트 동봉" 정체·sets 테이블 실재 근거. 디지털인쇄 L-G(배경지 봉투 못 받음)와 정확히 맞물림.

---

## 8. 적발한 게이트 결함

| ID | 결함 | 심각도 | 어느 산출물·어느 주장 | 독립 증거 | 라우팅 | 상태 |
|----|------|:--:|------|------|------|:--:|
| **F-PA-GATE-1** | 와이어링(007)·행택끈(010) 색상을 "material 0행·색상 자체 없음·MISSING"으로 분류했으나 실제 각 3행 MAT_TYPE.10 색상 자재 실재 — 볼체인/리필잉크와 동형 **MIS-LOADED**(분류 정반대) | **Med** | product-identity §2(F-PA-3 "와이어링 material 0")·live-diff §5(007/010 "material 0·미적재")·correction-manifest PA-08("material 0·option 0·MISSING") | `SELECT pm.prd_cd,m.mat_nm,m.mat_typ_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd IN ('PRD_000007','PRD_000010')` → 007: 실버/화이트/블랙 3행 MAT_TYPE.10 · 010: 사각검정(100개)/백색/마사 3행 MAT_TYPE.10 | `dbm-correctness-auditor`(PA-08 MISSING→MIS-LOADED 재분류, PA-02에 007/010 흡수) | 미보정(권고) |
| **F-PA-GATE-2** | "색상 옵션 전무"·"option_groups 0" 일반 서술이 PRD_000001/002 테스트 잔재 옵션그룹 2행("테스트"·"제본방식") 누락 | Low | live-diff §5 옵션확인·product-identity F-PA-3 "옵션 0행" | `SELECT prd_cd,opt_grp_cd,opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015'` → 001\|테스트·002\|제본방식 (2행) | `dbm-correctness-auditor`(서술 정밀화: "색상 옵션 0·테스트 잔재 2행 별도") | 미보정(권고) |

> **부정확/날조/추측 여부 판정:**
> - **F-PA-GATE-1 = 부정확(실측 누락 의심).** live-diff §5 SELECT가 007/010을 IN 절에 포함했음에도 "0행·미적재"로 기록 — SELECT를 실제 실행했다면 3행이 나왔어야 한다. **auditor SELECT를 신뢰하지 말고 재실행하라는 게이트 원칙이 정확히 잡아낸 사례.** 날조는 아니나(악의 없음·다른 부자재는 정확) 실측 검증이 불완전. 다만 교정 방향은 PA-02(색상→option)와 동일하므로 보정이 단순(MISSING→MIS-LOADED 재분류·PA-02 흡수).
> - **F-PA-GATE-2 = 부정확한 일반화**(굿즈 게이트와 동일). 색상 옵션 미적재 결론 유효.

## 9. 독립 재현이 어긋난 측정

- **2건:** ① 와이어링/행택끈 색상 자재 3행(주장 0행) — 분류 자체가 뒤집힘(MISSING↔MIS-LOADED). ② 옵션그룹 테스트 잔재 2행(주장 전무). 그 외 11건(이중등록·template·addon·MES·묶음수·가격·카테고리 고아·치수 평면화·볼체인/리필잉크 색상자재 등) 전건 검증자 SELECT와 일치.

## 10. 권고 — GO 인계 가능 여부

- **CONDITIONAL-GO.** 정체 확정(포장재 012)·oracle 실재성(이중등록 SQL 입증)·적재로직 재구성·봉투세트 Q-ID-A 권고·비파괴 교정이 견고. 적발한 K4 결함 2건은 **교정 방향을 바꾸지 않음** — F-PA-GATE-1은 PA-08을 PA-02(색상→option_items)로 재분류하면 흡수되고(오히려 색상 오염 일관성이 강화됨), F-PA-GATE-2는 서술 정밀화로 해소. 어느 쪽도 새 BLOCKED/GAP를 만들지 않음.
- **F-PA-GATE-1 보정(MISSING→MIS-LOADED 재분류) 후 GO 인계 가능.** 보정 전이라도 교정 매니페스트의 색상 귀속 결론(Q-PA-B: 색상→option)은 유효하므로 round-5/6 적재 트랙 진입에 차단 사유는 아니나, 분류 정정은 round-10 델타(MIS-LOADED는 UPDATE·MISSING은 INSERT 경로가 다름)에 영향 있어 보정 권장.
- **잔존 컨펌 8건(인간 결정 대기):** Q-ID-A(봉투세트 sets+CPQ — §5 권고)·Q-PA-A(카테고리 재연결 vs 고아 보수)·Q-PA-B(색상 variant→option/자재/별SKU)·Q-PA-C(사이즈 3축 분해 깊이)·Q-PA-D(카드봉투 색상·이중등록 역할)·Q-PA-E(묶음 단위 통일)·Q-PA-F(천정고리 use_yn=N)·Q-PA-G(우드 길이 variant). 전건 적재/DDL/논리삭제는 인간 승인 — DB 미적재 유지.
- **DB 쓰기 0** — 본 게이트 read-only SELECT + 소스 Read만.

### 최종 매트릭스 (1차)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ⚠️ COND(F-PA-GATE-1/2) | ✅ PASS | ✅ PASS |

---

## 11. K4 재게이트 — 정식 검증자 판정 (2026-06-11, `dbm-validator` 독립)

> 1차(§0~10)는 K4 ⚠️CONDITIONAL. `dbm-correctness-auditor`가 F-PA-GATE-1·F-PA-GATE-2를 보정 → **K4만 재게이트**(K0~K3·K5·K6 1차 PASS carry-forward). 아래는 생성자와 분리된 검증자가 **라이브 독립 재실측**으로 보정 정확성을 판정한 정식 판정(이 판정이 권위).

### K4 재판정: ✅ **PASS** — 4개 재게이트 기준 전건 충족

**① 와이어링(007)·행택끈(010) 색상 자재 3행 MAT_TYPE.10 — 독립 SELECT 대조:**
```sql
SELECT pm.prd_cd, m.mat_cd, m.mat_nm, m.mat_typ_cd, pm.usage_cd
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000007','PRD_000010') ORDER BY pm.prd_cd, m.mat_cd;
```
| prd_cd | mat_cd | mat_nm | mat_typ | usage |
|--------|--------|--------|---------|-------|
| PRD_000007 | MAT_000210 | 실버 | MAT_TYPE.10 | USAGE.07 |
| PRD_000007 | MAT_000212 | 화이트 | MAT_TYPE.10 | USAGE.07 |
| PRD_000007 | MAT_000213 | 블랙 | MAT_TYPE.10 | USAGE.07 |
| PRD_000010 | MAT_000217 | 사각검정 (100개) | MAT_TYPE.10 | USAGE.07 |
| PRD_000010 | MAT_000219 | 사각백색 (100개) | MAT_TYPE.10 | USAGE.07 |
| PRD_000010 | MAT_000220 | 사각마사 (100개) | MAT_TYPE.10 | USAGE.07 |

보정된 PA-08 "와이어링 실버/화이트/블랙·행택끈 사각검정/백색/마사 각 3행 MAT_TYPE.10"이 라이브와 **완전 일치**(mat_cd까지). 1차 게이트가 적발한 "0행 MISSING은 실측 누락" 판정이 정확했고, 보정이 그 정정을 충실 반영함.

**② 색상 오염군 집계 006=8·007=3·010=3·012=1·015=7 — 독립 SELECT:**
```sql
SELECT pm.prd_cd, count(*), string_agg(DISTINCT m.mat_typ_cd,',')
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000006','PRD_000007','PRD_000010','PRD_000012','PRD_000015') GROUP BY pm.prd_cd;
-- → 006|8  007|3  010|3  012|1  015|7  (전부 MAT_TYPE.10)
```
PA-02 색상 오염군 집계가 라이브와 일치. 와이어링/행택끈이 볼체인(8)·리필잉크(7)와 동형 MAT_TYPE.10 오염임이 확정.

**③ 테스트 잔재 옵션그룹 2행(F-PA-GATE-2) — 독립 SELECT:**
```sql
SELECT prd_cd, opt_grp_cd, opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015';
-- → PRD_000001|OPT-000003|테스트   PRD_000002|OPT-000001|제본방식
```
보정 서술 "테스트 잔재 옵션그룹 2(001 테스트·002 제본방식), 부자재 색상 옵션 아님 → 논리삭제 후보"가 라이브 정확. 색상 옵션 미적재 결론 유지.

**④ 분류 분포·라우팅 불변·scope 보존:** correction-manifest §2 = CORRECT 2·**MIS-LOADED 5→6**(PA-08 흡수)·**MISSING 4→3**·EXTRA 0·AMBIGUOUS 3 = **합계 14 불변**. PA-08 라우팅 = "load-execution+컨펌(Q-PA-B)" **불변**(분류만 MISSING→MIS-LOADED, 델타 경로는 단독 INSERT→오염 자재 논리삭제+옵션 INSERT로 정밀화). PA-01·03~07·09~14 미변경 = **scope 위반 0**. 보정이 새 결함·새 BLOCKED/GAP 생성 0. ddl-proposer 라우팅 0 유지(옵션 테이블 실재).

> **검증자 소견:** F-PA-GATE-1 보정이 단순 라벨 교체가 아니라 **델타 적재 경로를 바꾸는 의미 있는 정정**(MISSING=INSERT vs MIS-LOADED=오염 행 논리삭제+옵션 INSERT)임을 auditor가 정확히 반영. 1차 게이트의 "auditor SELECT를 신뢰하지 말고 재실행"이 실측 누락을 잡았고, 재게이트가 보정의 정확성을 라이브로 재확인 — 생성자≠검증자 분리의 가치가 2-pass로 입증됨.

### 최종 매트릭스 (K4 재게이트 후)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS(재게이트) | ✅ PASS | ✅ PASS |

**상품악세사리 최종 판정: GO.** K0~K6 전건 PASS. 잔존 컨펌 8건(Q-ID-A·Q-PA-A~G)은 인간 결정 대기. 교정 실행(정상노드 재연결·색상→option_items·봉투세트 sets+CPQ 매칭·가격 round-2 양식·묶음수 INSERT)은 round-5/6/10 트랙 + 인간 승인 — DB 미적재 유지. **본 재게이트 DB 쓰기 0**(read-only SELECT + 산출물 Read만).
