# photobook-propagation.md — 포토북 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · 경량 전파(동형판정+델타+대표+갭, 전체 재유도 금지·코드 0줄).
> **지시 클래스** = C1(accessories) 대비 전파. **라이브 권위 판정 결과 = C1 동형 깨짐 → C5(셋트조립·book) 동형으로 재귀속.**
> **외형 권위** = `docs/design/11가지상품옵션/product-photobook-option/Configurator.jsx`(126줄·3필드 — 사이즈·커버타입·제작수량·에디터 전용).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01).
> **대표 명세(상속)** = C5 `../book/book-form-spec.md`(PRD_000069 무선책자·evaluate_set_price). ※ C1 `../accessories/accessories-form-spec.md`는 동형 아님(사유 §1).
> **가격 권위** = 서버 `pricing.py:evaluate_set_price`(:844) 불투명 결과. PRICE=0=결함.
> 대표 상품 = **PRD_000100 포토북** (셋트 부모·7구성원·PRF_PHOTOBOOK_FIXED+INNER·readiness L2+ 76.6%·W-SET·calc=PRICED).

---

## 1. 동형 판정 — **C1 동형 ❌ / C5 동형 ⭕ (클래스 재귀속)**

지시는 C1(accessories·고정가-단순) 전파였으나 **라이브 데이터가 권위**다. 라이브 PRD_000100 실측 결과 C1과 동형이 깨지고 C5(셋트조립)와 동형이다.

### 1.1 C1 동형 깨짐 (사유)
| C1(accessories·PRD_000055) 동형 기준 | photobook(PRD_000100) 라이브 | 동형 |
|----------------------------------------|------------------------------|:---:|
| prd_typ = 완제품 **단일** (셋트 아님·sets 0행) | PRD_TYPE.01 **셋트 부모** — `t_prd_product_sets` **7구성원**(내지101·표지102/103/105/106/107·면지104) | ❌ |
| 가격모델 = 고정가 by siz (단일 component lookup) | **evaluate_set_price** — 부모공식 PRF_PHOTOBOOK_FIXED(기본24P×부수) + 내지 구성원 PRF_PHOTOBOOK_INNER(추가2P당) | ❌ |
| 옵션 사실상 size+qty(부가옵션 무·1항목 자동선택) | **커버타입 3종 실선택**(OPT_000079 표지타입 = 셋트 구성원 선택) — 손님 실분기 | ❌ |
| 면 분해 없음(default 단일) | 표지/내지/면지 = 셋트 멤버(면별 분해 성격·ProductSide) | ❌ |
| editor_yn=N·PDF 업로드 | **editor_yn=Y**(포토북=에디터 전용·디자인 JSX:91 "에디터로 디자인하기" 단독) | ❌ |
| readiness W-FIX·L3 | readiness **W-SET·L2+** | ❌ |

→ **C1 동형 0/6.** photobook은 고정가-단순이 아니라 셋트조립이다.

### 1.2 C5 동형 성립 (book-form-spec PRD_000069 대표 대비)
| C5(book·PRD_000069) 동형 기준 | photobook(PRD_000100) 라이브 | 동형 |
|--------------------------------|------------------------------|:---:|
| 셋트 부모 ← 반제품 구성원(t_prd_product_sets) | ⭕ 7구성원(내지/표지5/면지) | ⭕ |
| 부모공식(셋트) + 구성원 공식(내지 페이지) = evaluate_set_price | ⭕ PRF_PHOTOBOOK_FIXED(부모·기본24P) + PRF_PHOTOBOOK_INNER(내지101·추가2P당) | ⭕ |
| 커버/표지타입 = 구성원 선택(부모 차원 또는 멤버 택) | ⭕ OPT_000079 표지타입(하드/레더하드/소프트) = base24 단가행 opt_cd 차원 | ⭕ |
| 내지 페이지 = page_rule + 구성원 qty 파생 | ⭕ page_rule 24~150/+2 · 내지 추가2P당 PAGE comp | ⭕ |
| 면별 = ProductSide[default,inner] 기존 계약 | ⭕ 표지=default·내지=inner | ⭕ |
| PRICE≠0(이중합산 0 목표) | ⭕ base24+page comp 단가행 적재(§4)·calc=PRICED | ⭕(주의: 이중합산 의심 §5) |

→ **C5 동형 6/6.** book-form-spec(PRD_000069) 매핑 규칙 상속. **isomorphism-classes.md 갱신 권고: photobook = C5 멤버(W-SET), C1 아님.**

### 1.3 C5 대표(069)와의 1차 변이 (서브패턴)
photobook은 C5지만 069 무선책자와 **표지 처리 방식**이 다르다(델타 §2):
- 069: 표지=별도 member(PRF_BOOK_COVER 3비목)·내지=별도 member. **표지 자재/인쇄/코팅 손님 선택**.
- 100: 표지 비목을 **부모공식 COMP_PHOTOBOOK_BASE에 통합**(siz×표지타입 단가행). 손님은 **표지타입 1택**(하드/레더하드/소프트)만, 표지 종이/코팅 세부 미노출. = "통합형 셋트"(C5 하위 변이·book-form-spec §0 072/077 COVERBIND 통합형과 동궤). 동형 유지(같은 evaluate_set_price·표지타입→단가행 차원).

---

## 2. 그룹 델타 — 대표(C5/069)에 없는/다른 옵션만 추가 매핑

photobook 디자인 폼은 **3필드**(C5 069의 20필드 superset 대비 극히 단순)다. 069 대비 **추가 옵션은 없고**(델타 음수), 매핑 변이는 표지타입 처리 1건뿐.

| 델타 항목 | photobook 라이브 | 계약 필드 | componentType | DB 출처 | 069 대비 |
|----------|------------------|-----------|---------------|---------|----------|
| **커버타입(표지타입)** | OPV_000484 하드(dflt)/485 레더하드/486 소프트 (3택1) | `OptionGroup(multiple=false, required)` | `option-button` | OPT_000079 ⋈ option_items | **변이** — 069는 표지=member 자재선택, 100은 표지타입=부모 단가행 opt_cd 차원(통합형). 어댑터가 OPT_000079를 가격요청 `optionSelections[{opt_cd}]`로 운반(A) |
| 사이즈 | SIZ_000269 8x8 / 274 10x10 / 170 A5 / 172 A4 (4종·전부 dflt_yn=Y 충돌) | `OptionGroup` | `option-button` | product_sizes ⋈ siz_sizes | 동형(069 A4·A5와 동일 직매핑·dflt 충돌은 A 흡수) |
| 제작수량 | min1·max1000·incr1·unit=QTY_UNIT.03(권) | InputSpec | `counter-input` | products qty | 동형(★디자인 min/step 미명시·DB 권위) |
| **페이지(내지)** | page_rule 24~150/+2 | `page-counter-input` | page-counter-input | page_rules | **디자인 미노출** — design JSX는 페이지 필드 없음(기본24P 가정). 라이브는 24~150 가변. 어댑터가 page-counter 노출(A·DB 권위) 또는 기본24P 고정. design-calendar(페이지 노출)와 대비 |
| (069에 있던) 제본방식/링/투명커버/박/형압/면지선택 | **없음**(포토북은 제본방식 분기 없음·면지=면지104 자동 member) | — | — | — | **델타 음수** — 069 대비 폼이 훨씬 단순. 박/형압/투명커버 일절 없음 |
| 에디터 CTA | editor_yn=Y·file_upload_yn=N(추정·재확인) | `cta.designEditor` | — | editor_yn | **변이** — 069는 PDF 업로드, 100은 에디터 전용(디자인 JSX:91 일치) |

**델타 요약:** 069 대비 **추가 옵션 0·제거 옵션 다수(제본/링/박/형압/투명커버)·변이 2(표지타입=부모차원·에디터 CTA)·디자인-DB 갭 1(페이지 노출)**. 전부 어댑터 흡수(A)·계약 신규 슬롯 0.

---

## 3. 라이브 대표 상품 — PRD_000100 포토북 (데이터 완비)

라이브 포토북 상품군은 PRD_000100 단 1개(완제품)이며 구성원 101~107. 데이터 완비도 = readiness **L2+ 76.6%·W-SET·calc=PRICED·frm=PRF_PHOTOBOOK_FIXED·OPT_000079 적재·base24/page 단가행 적재**. 대표 = **PRD_000100**(유일 부모·완비분).

**라이브 실측(스냅샷 2026-07-01):**
```
PRD_000100 포토북 (PRD_TYPE.01 완제품·셋트 부모·editor_yn=Y·min1/max1000/incr1·QTY_UNIT.03권)
부모공식 PRF_PHOTOBOOK_FIXED → COMP_PHOTOBOOK_BASE(PRICE_TYPE.01·use_dims=[siz_cd,opt_cd,min_qty]·11행)
sets(7): 101 내지(몽블랑130·SEMI_ROLE.01) / 102 표지하드 /103 표지아트250무광 /105 레더하드 /106 레더 /107 소프트(SEMI_ROLE.02) / 104 면지그레이(SEMI_ROLE.03)
  └ 내지 PRD_000101 공식 PRF_PHOTOBOOK_INNER → COMP_PHOTOBOOK_PAGE(use_dims=[siz_cd,min_qty]·4행·추가2P당)
sizes(4): 8x8 / 10x10 / A5 / A4 (전부 dflt_yn=Y 충돌)
option_groups(1): OPT_000079 표지타입(SEL_TYPE.01·하드484 dflt/레더하드485/소프트486)
page_rule: 24~150/+2 · constraints: 0행 · addons: 0행
```

---

## 4. evaluate_price 골든 (PRICE≠0) — base24 단가행 verbatim 상속

photobook은 evaluate_set_price 경로(부모 base24 + 내지 page). 단가행은 스냅샷 verbatim:

| 케이스 | siz_cd | 표지타입(opt_cd) | base24(라이브 verbatim) | page 추가(2P당) | 산식(개략) | 출처 row |
|--------|--------|------------------|-------------------------|-----------------|-----------|----------|
| A4 하드·24P·1부 | SIZ_000172 A4 | OPV_000484 하드 | **16,000** | — | 16,000×1 | #40341 |
| A4 레더하드·24P | SIZ_000172 | OPV_000485 레더하드 | **26,000** | — | 26,000×1 | #40342 |
| A4 소프트·24P | SIZ_000172 | OPV_000486 소프트 | **13,000** | — | 13,000×1 | #40343 |
| 8x8 하드·24P | SIZ_000269 8x8 | OPV_000484 | **15,000** | — | 15,000×1 | #40333 |
| 10x10 레더하드·24P | SIZ_000274 | OPV_000485 | **32,000** | — | 32,000×1 | #40337 |
| A4 하드·40P·1부 | SIZ_000172 | OPV_000484 | 16,000 | A4 600/2P (#40347) | 16,000 + 600×⌈(40−24)/2⌉=16,000+4,800 = **20,800** | #40341+#40347 |

> base24 단가·page 추가단가 모두 라이브 스냅샷 verbatim(날조 0). evaluate_set_price 결합(부모×부수 + 내지qty×추가2P당)은 pricing.py:844 권위 — **정확 final은 서버/시뮬레이터 권위**(VAT 별산·부수 곱). 본 명세는 단가행 verbatim + readiness `calc=PRICED`를 권위로 함. 인증세션 시뮬 직호출은 hw-qa 이관.

✅ **PRICE≠0 게이트 통과** — base24 13,000~32,000(전 케이스 >0)·page 300~1,000. **대표 PRICE 값 = base24 13,000~32,000(표지타입×사이즈)·페이지 추가가 가산.**

---

## 5. 갭 (A)/(B)/(C) + 주문가능 4조건

### 5.1 갭 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (8)**: A1 셋트 evaluate_set_price 경로(C5 069 상속)·A2 표지타입 OPT_000079→부모 opt_cd 차원 운반(통합형 변이)·A3 사이즈 dflt_yn 4건 충돌→disp_seq 최소 기본(A)·A4 페이지 page-counter 노출/기본24P(디자인 미노출이나 DB 가변·A)·A5 면지104=자동 member(손님 미선택)·A6 에디터 CTA(editor_yn=Y→designEditor)·A7 unit 라벨(권)·A8 sides[default,inner] 기존 계약.
- **(B) 계약 변경 필요 (0)**: 위젯 계약(OptionGroup·page-counter-input·ProductSide[default,inner]·counter-input·summary·cta.designEditor)이 photobook 폼을 **전부 기존 슬롯 수용** → C5 대표가 이미 검증한 계약으로 0건. **목표 달성**.
- **(C) DB 작성·교정 — §7/§23 인간 승인 (2)**:
  - **C-1 이중합산 검증** (🟡 readiness `calc=PRICED(★이중합산 의심)`): 부모 base24(표지타입 단가에 표지 비목 통합)와 표지 member(102/103/105/106/107) 공식이 **동시 합산**되면 표지가 2번 청구. 라이브 표지 member는 공식 바인딩 0행(§확인)이라 현재 미발현 가능성 높으나, evaluate_set_price가 member 0공식을 어떻게 처리하는지 **hw-qa 재계산 검증 필요**(book-form-spec §23 "셋트 이중합산 해소=부모공식만"과 동일 가드). 돈크리티컬.
  - **C-2 editor_yn/file_upload_yn 정합** (🟢 비차단): 포토북=에디터 전용이면 file_upload_yn=N 확인. CTA 분기 정합.
  - (참고) sets STALE 충돌: §23 set-product 산출(2026-06-28)은 "BLOCKED·base24 comp 0행"으로 기록했으나 **라이브 스냅샷 2026-07-01에 base24 11행·page 4행·OPT_000079 적재 완료** → set-product 보고가 STALE(이후 §18/§7 적재됨). 본 전파가 라이브 권위로 정정.

### 5.2 주문가능 4조건 (PRD_000100 현재)
| 조건 | 충족 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 구동 | **충족** | 사이즈 4종·표지타입 3종(OPT_000079)·수량·페이지(page_rule) 전부 라이브 구동 ✅ |
| ⓑ 제약 6종 강제 | **충족** | ⑤택1(사이즈·표지타입)·⑥필수·②quantity·page_rule 강제 ✅ / 차별제약(constraints 0행) = C5 069 대비 더 단순(제본/박/링 없음) ✅ |
| ⓒ PRICE≠0 | **충족(주의)** | base24 13,000~32,000·page 300~1,000 >0 ✅ / 단 이중합산 의심(C-1·hw-qa 재계산 필수) ⚠ |
| ⓓ 유효 페이로드 | **충족** | NormalizedCartHandoff(셋트·표지타입·페이지) 조립 가능 ✅ / 에디터 CTA(editor_yn=Y)·커머스 §24 경계 |

**판정: 주문가능(ORDER-CAPABLE·조건부).** C5 069(무선책자)와 동형으로 셋트 가격·옵션 라이브 완비 → 즉시 주문가능. 위젯/계약/어댑터 준비 완료(B 0건). 잔여 = **이중합산 검증(C-1·hw-qa 재계산)** 1건이 유일 차단후보 — 해소 시 완전 ORDER-CAPABLE. (069·068 등 형제 동형이 이미 COMMIT 동작분이므로 신뢰도 높음.)

**다음 권고:** ① hw-qa 인증세션 evaluate_set_price 골든 실측(이중합산 0 확인·base24+page 재현) → ② isomorphism-classes.md에 photobook=C5(W-SET·통합형 표지 변이) 귀속 정정 → ③ hw-architect data-adapter 후니 arm에 표지타입→부모 opt_cd 운반 규칙(통합형) 명시 → ④ hw-builder createHuniAdapter. 코드 구현은 승인 후.
