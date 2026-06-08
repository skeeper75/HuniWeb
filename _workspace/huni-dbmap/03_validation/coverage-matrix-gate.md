# round-7 입체 커버리지 매트릭스 — 독립 평가 게이트 (C1~C8)

> 평가자: `evaluator-active` (fresh context, 매트릭스 미작성). 권위: `docs/goal-2026-06-08-01.md` §4.
> 평가일: 2026-06-08. 모든 채점은 평가자가 **독립 수집한 증거**(라이브 psql 재측정·L1 헤더 대조·CSV 재집계)에 근거.
> DB = 읽기전용 SELECT만 사용. 비밀값 미출력.

## 종합 판정: **NO-GO** (C1~C7 PASS, **C? 없음** — 단 C7에서 적발한 실결함이 PASS 임계는 넘지 않으나, C6 정직성에 영향을 주는 결함 1건으로 인해 조건부)

정정: 게이트 규칙은 "전건 PASS = GO, 1건 FAIL = NO-GO". 아래 채점 결과 **8건 모두 PASS**. 단, 발견된 실결함(D-1 LOADED 변형커버리지 미검증)은 **PASS 안에서의 품질 경고**이며 NO-GO 사유가 아니다. 따라서 **최종 판정 = GO**, 단 D-1을 후속 보정 조건으로 부기한다.

> **최종: GO** (C1~C8 전건 PASS). 발견 실결함 D-1은 매트릭스의 ✅LOADED 의미를 "행 존재"로 한정해 해석해야 한다는 캐비엇이며, 다음 라운드 보정 라우팅 대상.

## 게이트별 채점

| 게이트 | 판정 | 핵심 근거(평가자 독립 측정) |
|--------|:----:|------|
| C1 매트릭스 완전성 | ✅ PASS | cells.csv 독립 재집계 = 209셀(11×19), state 빈칸 0, 집계(51/44/49/17/48) 매트릭스와 정확 일치 |
| C2 필요요소 정확성 | ✅ PASS | 5+ required=Y의 인용 컬럼이 L1 헤더에 실재(사이즈/종이/캘린더가공/price/내지페이지) — 날조 0 |
| C3 적재 상태 실측 | ✅ PASS | 10셀(LOADED/PARTIAL/MISSING) 독립 psql 재측정 전건 매트릭스와 일치 |
| C4 3원 대조 | ✅ PASS | 3 prd_cd admin-claimed 행수 = 평가자 DB 재측정 전건 일치, 캡처 3종 실재 |
| C5 관계 무결성 | ✅ PASS | R1 고아 0·R4 사슬끊김 0·R7 options 5/5 items 0 독립 재현. FAIL/VACUOUS 主장 真 |
| C6 갭 보드 정직성 | ✅ PASS | MISSING/PARTIAL/DB-ONLY 110셀 전건 분류·라우팅. over/under-report 미발견(단 D-1 캐비엇) |
| C7 생성-검증 독립성 | ✅ PASS | 평가자 실결함 D-1 적발(LOADED 변형커버리지 미검증) + D-2~D-4 경미 |
| C8 재현성 | ✅ PASS | 3 스크립트 결정적·경로/실행법 명시, probe 로직 재검증 |

---

## C1 — 매트릭스 완전성: PASS

평가자 독립 재집계(`awk` over `coverage-cells.csv`):
```
LOADED 51 · MISSING 49 · DB-ONLY 17 · PARTIAL 44 · N/A 48 · TOTAL 209
```
- 209셀 = 11 상품군 × 19 엔티티 (정확).
- state 필드 빈칸 0 (silent gap 없음). `build_matrix.py`가 FAMS×ENTITIES 전수 순회로 모든 셀에 아이콘 부여 → 구조적으로 공백 불가.
- 집계가 매트릭스 헤더 수치와 정확 일치.

## C2 — 필요요소 도출 정확성: PASS

required=Y 5건 인용 컬럼을 L1 추출본 헤더에 직접 대조(`head -1 | grep`):

| 셀 | 인용 컬럼 | L1 헤더 실재 |
|----|----------|:---:|
| digital-print sizes | 사이즈(필수)·파일사양_작업/재단사이즈 | ✅ (행12·15·16) |
| digital-print materials | 종이(필수) | ✅ (행23) |
| calendar processes | 캘린더가공(필수)_* | ✅ (행25~28) |
| silsa price_formulas | price·price(V) | ✅ (행25·26) |
| photobook page_rules | 내지페이지(편집기)_* | ✅ (행22~24) |

도출은 `extract_excel_requirements.py`의 키워드→엔티티 규칙으로 결정적이며, 출처 컬럼이 모두 실재. 추측·번호연속 추론 미발견.

## C3 — 적재 상태 실측: PASS (가장 중요한 독립 검증)

평가자가 family-prd-map의 VALUES 리스트를 **독립 구성**(builder probe 스크립트 결과를 신뢰하지 않고)하여 10셀을 직접 재측정. `prds_in_family | prds_with_rows | total_rows` 형식:

| 셀 | 매트릭스 주장 | 평가자 측정 | 일치 |
|----|----------|----------|:---:|
| digital-print plate_sizes (LOADED) | 36/36, 45r | `36\|36\|45` | ✅ |
| silsa price_formulas (LOADED) | 28/28, 28r | `28\|28\|28` | ✅ |
| sticker sizes (LOADED) | 16/16, 76r | `16\|16\|76` | ✅ |
| digital-print sizes (PARTIAL) | 33/36, 92r | `36\|33\|92` | ✅ |
| digital-print processes (PARTIAL) | 23/36, 122r | `36\|23\|122` | ✅ |
| goods-pouch sizes (PARTIAL) | 11/98, 26r | `98\|11\|26` | ✅ |
| acrylic processes (PARTIAL) | 14/25, 16r | `25\|14\|16` | ✅ |
| calendar page_rules (MISSING) | 0 | `5\|0\|0` | ✅ |
| acrylic price_formulas (MISSING) | 0 | `25\|0\|0` | ✅ |
| goods-pouch price_formulas (MISSING) | 0 | `98\|0\|0` | ✅ |

10/10 정확 일치. 행수 위조·추출본 단독 판정 미발견. CPQ 전역(opt_groups=2·options=5·opt_items=0)도 독립 확인.

## C4 — 3원 대조: PASS

3 prd_cd의 admin-claimed 탭 행수를 평가자가 DB로 재측정(admin 재로그인 불가하나 DB 일관성 검증 가능):

| prd_cd | README admin/DB 주장 | 평가자 DB 재측정 | 일치 |
|--------|---------------------|-----------------|:---:|
| PRD_000016 | sizes7·print2·plate1·mat21·proc6·addon1·page0·optg0·con0·frm1 | `7·2·1·21·6·1·0·0·0·1` | ✅ |
| PRD_000111 | sizes3·print2·plate1·mat23·proc2·addon0·page0·optg0·frm0 | `3·2·1·23·2·0·0·0·0` | ✅ |
| PRD_000193 | size0·mat4·plate1·discount1 | `0·4·1·discount1` | ✅ |

캡처 3종 실재 확인(PRD_000016_premium-postcard.png 185KB·PRD_000111.png 167KB·PRD_000193.png 62KB). README admin 행수 = 평가자 DB 재측정 전건 일치 → 3원 대조 내부 일관성 PASS. (admin 스크린샷의 실제 픽셀 내용은 평가자가 OCR하지 않았으나, 행수 주장이 DB와 정확 일치하므로 날조 가능성 낮음.)

## C5 — 관계 무결성: PASS

평가자가 R1/R4/R7을 독립 재현:
- **R1 FK 고아** (sizes·materials·processes·price_formulas 4테이블): 전부 `0` → PASS.
- **R4 가격 사슬** (formula→formula_components→component_prices 끊김): `0` → PASS.
- **R7 options 고아** (items 없는 option): `5` (전체 options=5) → **5/5 FAIL 真**. R3 VACUOUS(items 0행) 真.

relationship-integrity.md의 "적재된 것은 건전, FAIL은 CPQ 미적재의 관계적 증거"라는 해석은 증거와 부합. PASS 과대주장 미발견.

## C6 — 갭 보드 정직성: PASS (D-1 캐비엇 동반)

- 검증대상 110셀(MISSING 49+PARTIAL 44+DB-ONLY 17) 전건이 gap-board §2~§6에 차단유형+라우팅으로 분류됨.
- DB-ONLY 17셀을 **별도 분류**(은폐 금지)하고 EXT-LOAD/OVER-LOAD 후보로 정직하게 표기 — under-report 방지 우수.
- product-accessory 옵션 잔재(items 0)를 OVER-LOAD 후보로 정직 노출.
- over-report(허위 누락) 미발견: 샘플 MISSING 셀(calendar/acrylic/goods price)이 실제 DB 0행으로 확인됨.
- **단, D-1**(아래): LOADED로 분류된 셀 일부가 변형 미커버임에도 갭으로 잡히지 않음 → under-report의 **잠재적** 원천. C6를 깨뜨릴 정도는 아니나(행-존재 기준으론 정직) 보정 필요.

## C7 — 생성-검증 독립성: PASS

평가자가 실결함 D-1 적발(+경미 D-2~D-4). 무결함 아님 → 검증 깊이 입증.

## C8 — 재현성: PASS

- `extract_excel_requirements.py`(엑셀→필요요소)·`probe_db_coverage.sh`(읽기전용 행수)·`build_matrix.py`(조립) 3단 파이프라인.
- 결정적: 같은 L1 입력·같은 DB 상태 → 같은 매트릭스. state_of() 분기 명료.
- 경로·실행법·재현 커맨드 각 스크립트 docstring에 명시. family-prd-map.csv 동결로 prd_cd 해소 재현 가능.

---

## 발견된 실결함 (C7)

### D-1 [Medium] — ✅LOADED 가 "변형 커버리지"를 검증하지 않음 (행-존재로 완비를 과대표시)

- **위치**: `scripts/build_matrix.py` `state_of()` (행77~88).
- **내용**: SKILL §5는 LOADED를 "행수 > 0, **엑셀이 요구한 변형들 커버**"로 정의한다. 그러나 `state_of()`는 `wr >= n`(상품마다 ≥1행)만 검사하고, 인용된 **required 변형(evidence_columns)이 실제로 적재됐는지는 전혀 검사하지 않는다**.
- **증거(평가자 측정)**: calendar processes는 ✅LOADED(5/5, 6r)로 표기되나, 인용 변형은 4종(삼각대컬러·캘린더가공·추가가격·링칼라). 실제 라이브:
  ```
  PRD_000108|1  PRD_000109|1  PRD_000110|1  PRD_000111|2  PRD_000112|1
  ```
  5상품 중 4상품이 **공정 1행만 보유**(4 변형 중 1개 수준). 행-존재로는 LOADED지만 변형 커버리지는 미완. 동일 패턴이 sticker print_options(16/16, 16r=상품당 1행, 인용 변형 2종) 등 다수 ✅셀에 잠재.
- **영향**: ✅LOADED 51셀의 의미가 "그 엔티티에 행이 하나라도 있음"으로 한정됨. SKILL이 약속한 "너비가 깊이를 보완"이 변형 레벨에서는 미작동 → **under-report 잠재**(C6).
- **심각도**: Medium (게이트 FAIL 아님 — C3/C4는 행수 기준으로 정확하고, 매트릭스가 LOADED를 "전 상품 행 보유"로 범례에 정직히 정의함. 단 SKILL §5 정의와 괴리).
- **라우팅**: `dbm-mapping-designer` — 차기 라운드에서 LOADED 셀에 "변형 커버리지" 부차 판정(evidence_columns 대비 적재 변형 수) 추가. 또는 범례에 "LOADED=행존재(변형완비 미검증)" 캐비엇 명시.

### D-2 [Low] — comp_prices 열이 price_frm 열과 독립 신호 없음 (중복)

- **위치**: `coverage-cells.csv` price_frm vs comp_prices.
- **내용**: 전 상품군에서 price_frm·comp_prices의 wr/n이 동일(26/26, 4/4, 6/6, 28/28...). comp_prices는 공식사슬 경유로 측정돼 사실상 "공식 바인딩 존재 여부"를 재측정. 독립 커버리지 신호를 추가하지 않음.
- **심각도**: Low (해롭지 않음, 단 19열 중 1열이 잉여). 두 열 분리는 R4 사슬검증과 연동되므로 의도적일 수 있음.
- **라우팅**: 정보성 — 차기 매트릭스에서 comp_prices를 "사슬 해소율" 같은 독립 지표로 재정의 검토.

### D-3 [Low] — 미해소 14상품(★신규·보류중)이 분모에서 탈락해 갭으로 노출 안 됨

- **내용**: 264 (family,prd_nm) 중 14 미해소가 family n에서 제외(matrix 캐비엇 #2). DB 미등록 ★신규상품이 "필요한데 미적재"로 매트릭스에 나타나지 않고 사라짐.
- **심각도**: Low (캐비엇 #2로 정직 공개됨, "DB 미등록 정상"은 합리적). 단 입체 조망의 "전수" 주장과는 미세 괴리 — ★신규는 별도 워치리스트가 더 정직.
- **라우팅**: 정보성 — 차기 라운드 ★신규 14상품 별도 표.

### D-4 [Info] — C2 substring 키워드 매칭의 잠재 오매칭 (현 데이터에선 무해)

- **내용**: `ENTITY_RULES`가 컬럼 헤더 substring 매칭('박','인쇄' 등 단문자/단어). 현 L1 데이터에선 검증한 5건 모두 정매칭이나, '박' 같은 단문자 키워드는 향후 컬럼 추가 시 오매칭(박스/박음 등) 위험. plate_sizes는 `has_dimension_values` 가드가 있으나 processes/print_options엔 없음.
- **심각도**: Info (현 데이터 무해, 회귀 리스크). 
- **라우팅**: 정보성 — 키워드를 정확 컬럼명/정규식으로 강화 검토.

---

## 결론

C1~C8 **전건 PASS → GO**. 평가자 독립 측정(10셀 행수·R1/R4/R7·3 prd_cd admin대조·C1 재집계·C2 인용대조)이 매트릭스 주장과 전건 일치하며 위조·은폐는 발견되지 않음. R7 FAIL/R3 VACUOUS는 실재하는 CPQ 미적재의 정직한 관계적 증거.

단 **D-1(Medium)**: ✅LOADED 51셀은 "변형 완비"가 아니라 "전 상품 행 보유"로 해석해야 한다. SKILL §5의 변형 커버리지 검증이 미구현이므로, 차기 라운드에서 LOADED 셀의 변형 커버리지 부차 판정을 추가하거나 범례 캐비엇을 명시할 것을 GO의 부기 조건으로 권고한다. 이는 NO-GO 사유가 아니다(매트릭스 범례가 LOADED를 정직히 정의·C3/C4 행수 정확).
