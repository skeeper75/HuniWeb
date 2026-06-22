# codex-reconcile-batch3.md — 배치3(스티커·아크릴·실사) codex 독립 2차 교차검증

> **Phase 6.5 — hcc-codex-verifier** · 2026-06-23 · §21 배치3
> codex(gpt-5.5·reasoning effort=high·`-s read-only`) 독립 2nd opinion ↔ 3 인스펙터 결함 보드 reconcile.
> ★독립성: codex에 Claude 인스펙터의 판정 결론 비노출(원시 데이터·권위·결함 후보만 work-spec 제시).
> ★환각 경계[HARD]: codex 주장=가설(라이브/권위 검증 전 사실 아님). codex 인용 근거 전건 캐시 대조 완료(날조 0).
> 입력: `codex-prompt-batch3.txt` / 원문: `codex-raw-batch3/codex-output.txt`(비밀값 비노출 확인).

## 0. 가용성·요약

- **codex 가용** (preflight=AVAILABLE model=gpt-5.5, exit 0). 폴백 불필요.
- **합의 6 · 불일치 0 · codex 신규발굴 0(인스펙터 이미 보드化) · false-positive 적발 0 · codex 신규 가설(hypothesis) 2**.
- codex가 인용한 모든 근거(COMP_STK_PRINT proc/print_opt NULL · COMP_POSTER_ARTPRINT_PHOTO mat NULL ·
  아크릴 147~166 미바인딩 20 · TMPL-000013 테스트 잔재 · 69 option_items ref_dim NULL 0)는 **인스펙터 셀/보드
  캐시에 실재**(대조 완료). codex 환각 0.

## 1. 쟁점별 reconcile

### 쟁점1 — 과대청구 NULL 와일드카드 (★배치3 최중점)

| 면 | Claude 인스펙터 판정 | codex 독립 판정 | 합의/불일치 | 근거 실재성 |
|----|---------------------|----------------|------------|-----------|
| **(a) 스티커 COMP_STK_PRINT proc/print_opt NULL** | SAFE — 단면·커팅 동일단가라 판별차원 아님(과대청구 0) | **SAFE** — NULL 두 컬럼이 가격 판별축 아님, wildcard 합산 구조 없음 | **합의** | ✅ 셀 PRD_000052 확인 |
| **(b) 실사 공유공식 COMP_POSTER_ARTPRINT_PHOTO mat NULL** | MATCH — 4소재 동일가가 권위 의도·comp count=1이라 교차합산 없음(Q-SILSA-SHARE 해소) | **SAFE** — material 비판별축·제품은 자기 frm_cd 1개만 평가하므로 cross-summation 아님 | **합의** | ✅ 셀 PRD_000118/120 확인 |
| **(c) 기타 NULL 와일드카드** | (스캔 적출 0) | **HYPOTHESIS** — 아크릴 orphan comp(COROTTO/MIRROR3T/KEYRING) proc_cd/mat_cd/piece-count NULL 분포 미제시·재실측 필요 | 보강(가설) | ⚠ 가설(라이브 재측정 큐) |

- **결론**: 과대청구 면 SAFE 양자 합의 — 인스펙터 "NULL_WILDCARD 0·과대청구 0" 비준. codex가 놓친 silent 합산 **없음**.
- **★codex 신규 가설 2건(채택 전 게이트 라이브 재실측 필요)**:
  1. **스티커 (siz_cd, mat_cd, min_qty) tuple 중복** 여부 — 중복 단가행이면 동일 tuple 다중 매칭→합산 가능. (인스펙터는 2,694행 판별차원 충전만 확인, tuple 유일성 미명시.)
  2. **실사 4 formula 내 COMP_POSTER_ARTPRINT_PHOTO 중복 연결**(formula_components 중복행) 여부 — 한 공식에 같은 comp가 2번 묶이면 double-count. (인스펙터 "comp count=1"은 공식당 comp 종류 수·중복행은 별개 검사.)
  → **라우팅**: 게이트 K4 evaluate_price 재계산 시 ① `t_prc_component_prices` (comp_cd,siz_cd/siz_w,siz_h,mat_cd,min_qty) GROUP BY having count>1 ② `t_prc_formula_components` (frm_cd,comp_cd) 중복 카운트 — 둘 다 0이면 가설 기각, >0이면 신규 결함 승격.

### 쟁점2 — 실사 면적그리드 하한 600mm (R-B3-2)

| Claude 인스펙터(R-B3-2) | codex 독립 | 합의/불일치 | 근거 실재성 |
|------------------------|-----------|------------|-----------|
| **조건부 과대**(+5,000/매·sub-600 허용 시에만)·확정 아님·게이트 K4 재측정 | **조건부 confirmable overcharge** — 동일 결론. 단일 결정체크=PRD_000118~145 size constraint가 min(w,h)≥600 / A3·A2 선택불가를 강제하는지 | **합의(완전 일치)** | ✅ 600x600=12000 최소행·권위 A3/A2=7000 일치 |

- **합의**: R-B3-2는 "조건부 과대·게이트 선행"으로 양자 동일. codex가 결정체크(최소사이즈 제약 존재여부)를 명시 — 인스펙터 라우팅(K4 제약 대조)과 정합.
- **게이트 큐**: K4가 ① 실사 4상품 제약축(width/height min) 라이브 조회 ② sub-600 주문 허용 시 evaluate_price 재계산으로 +5,000 실증/기각.

### 쟁점3 — 아크릴 147~166 미바인딩 20건 (D-B3-1 / Q-ACR-MISSING20)

| Claude 인스펙터(D-B3-1) | codex 독립 | 합의/불일치 | 근거 실재성 |
|------------------------|-----------|------------|-----------|
| **MISSING_BIND=차단**(가격0·견적불가). 단 결함이 아니라 needed=Y 미충족·고정가형 vs 가공가산형 권위모델 인간 확정(Q-ACR-MISSING20) | **현재 엔진계약 기준 genuine DEFECT/blocked**. "intended fixed-price bypass"이려면 evaluate_price가 formula 없이 `가격` 읽는 별도 branch가 실재해야 함 — 없으면 `가격`컬럼 존재는 미적재 증거 | **합의(+ 결정체크 보강)** | ✅ 미바인딩 20건·COROTTO orphan 캐시 확인 |

- **합의**: 양자 모두 "현 상태=차단(blocked quote)". codex가 고정가형 의도 여부의 **결정체크를 날카롭게 명시** — `evaluate_price`에 formula 외 `가격` 직접 읽는 코드 경로 존재여부. 인스펙터의 Q-ACR-MISSING20(인간 확정)과 정합.
- **게이트/라우팅 보강**: codex 결정체크를 게이트가 흡수 — `raw/webadmin/.../pricing.py evaluate_price` source 우선순위(직접단가→PRODUCT_PRICE→FORMULA)에서 아크릴 고정가가 PRODUCT_PRICE(순위2)로 적재 가능한지가 모델 확정의 자. **인스펙터 임의선택 금지 유지**(인간 확정).

### 쟁점4 — 부속물 BUNDLE 부착공정 누락 4건 (MISSING — false-positive 의심면)

| Claude 인스펙터(basedata HARD 4) | codex 독립 | 합의/불일치 | 근거 실재성 |
|--------------------------------|-----------|------------|-----------|
| **MISSING**(부속물 자재 등록·부착공정 proc 누락=BUNDLE 절반결함). 돈영향 없음(미바인딩이라 가공가 안 흐름)·confidence med | **defect 가능성 높음**(material+process BUNDLE 권위인데 반쪽만 등록). 돈영향=현재 직접 없음·Q3(미바인딩)에 가려짐·바인딩 복구 후 2차 결함 | **합의** | ✅ 148/149/152/154 mat 등록·proc 누락 보드 확인 |

- **합의**: false-positive **아님** — codex도 "반쪽 등록=결함"으로 동의. 자재만으로 불충분(BUNDLE 권위). 다만 **돈영향은 Q3 미바인딩에 가려진 2차 결함**이라는 codex의 위계 분석이 인스펙터 "돈영향 없음(가격엔진 미바인딩)"과 정확히 합치 — 가격 복구 시점 동반 교정 라우팅 비준.
- **게이트 재실측 권고 유지**: 부속물 mat_cd가 진짜 부속물인지(소재 아크릴과 구분)·153/166 자재 부재(MISSING 아님) 구분 — 인스펙터 권고 그대로.

## 2. codex 추가 발굴 (인스펙터 보드 대비)

| 항목 | codex 판정 | 인스펙터 보드 대조 | 결론 |
|------|-----------|-------------------|------|
| **TMPL-000013 테스트 잔재** | "missed defect — 데이터 오염" | 인스펙터 D-B3-CPQ-6 [EXTRA ×1]로 **이미 적발** | **합의(신규 아님)**. codex 독립 재발견=인스펙터 EXTRA 판정 교차 비준 |
| **dead option link 0** | "false-positive 후보 — 69 전건 active resolve, dead link 주장은 데이터상 반증" | 인스펙터 1.1 옵션→차원 100% 해소(DEAD_LINK 0)와 **동일** | **합의**. 배치3 dead link 결함 없음 양자 확인 |

- codex **신규 결함 발굴 0**(인스펙터가 이미 전부 보드化). codex **false-positive 적발 0**(인스펙터 판정 모두 정당).

## 3. 환각 경계 점검 (codex 주장=가설)

- codex 인용 근거 **전건 캐시 실재 대조 완료**: COMP_STK_PRINT(PRD_000052 셀)·COMP_POSTER_ARTPRINT_PHOTO(PRD_000118/120 셀)·
  미바인딩 20(price-engine 셀 grep=20)·TMPL-000013(cpq 보드)·69 option_items(cpq 보드). **날조/환각 0**.
- codex가 명시적으로 **HYPOTHESIS 표기**한 2건(스티커 tuple 중복·formula_component 중복)은 사실로 채택하지 않고 **게이트 라이브 재실측 큐**로 라우팅(쟁점1 결론).
- codex의 "결정체크" 제안(Q2 최소사이즈 제약·Q3 evaluate_price branch)은 게이트 검증 절차 보강으로 흡수(가설→검증 절차化).

## 4. 라우팅 종합 (게이트 K1~K8 입력)

| 항목 | reconcile 결과 | 게이트 액션 |
|------|---------------|-----------|
| 과대청구 SAFE (스티커·실사 공유) | 합의·고신뢰 | K4 비준(과대청구 0) |
| **★codex 신규 가설 — 스티커 tuple 중복 / 공유 comp formula_component 중복** | 가설(미확정) | **K4 라이브 재실측**(GROUP BY 중복 카운트 2건) — 0이면 기각, >0이면 신규결함 승격 |
| R-B3-2 실사 600 하한 | 합의(조건부 과대) | K4 제약축 조회+evaluate_price 재계산 |
| D-B3-1 아크릴 20 미바인딩 | 합의(차단) | Q-ACR-MISSING20 인간 확정 → codex 결정체크(evaluate_price branch) 적용 |
| 부속물 BUNDLE proc 누락 4 | 합의(결함·2차) | 가격 복구 시점 동반 교정·게이트 mat 부속물성 재실측 |
| TMPL-000013 EXTRA · dead link 0 | 합의 | 비준(신규 없음) |

- 합의=고신뢰(게이트 부담 경감). 불일치=0. codex 가설=조사 큐(K4). 실 COMMIT/DDL은 인간 승인 후 dbmap 위임.
