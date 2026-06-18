# Gate Verdict — P1~P7 냉철한 게이트 판정

> **Phase 3 — hpq-quote-gate-validator (검증측·생성과 독립)** · 2026-06-18 · `huni-price-quote`
> 생성측(chain-inspector·option-constraint-mapper) 주장을 **비신뢰**하고 라이브 `evaluate_price` 직접 호출 +
> 읽기전용 psql 재현으로 독립 재실측. 근거: `recompute-log.md`, `confirmed-defects.md`.
> 파일럿: 엽서 PRD_000017 · 현수막 PRD_000138 · 아크릴 PRD_000146 (+골든 실사 PRD_000118 · 린넨 PRD_000124).
> 라이브 DB 쓰기 0 · 실 교정 0.

---

## 종합 판정: **CONDITIONAL-GO**

- **생성측 결함보드(데이터 결함 D-1~D-7·E계열)는 대부분 진짜** — 라이브 엔진 재계산으로 이중합산·침묵0원
  **정량 발화 확정**. 생성측 검사 품질 높음(재현 SQL 동반·엔진 거동 정확 예측).
- **그러나 골든 P3(엽서 full)은 라이브 재현 불가** = 엽서 가격사슬 미완성(신규 결함 N-1). 면적매트릭스(실사·아크릴)는
  골든 완전 재현. → **면적매트릭스 상품군은 GO, 합산형(엽서) 상품군은 NO-GO(가격 미완성).**
- 정직한 CONDITIONAL: 검증된 면적매트릭스는 신뢰, 엽서는 결함 잔존으로 거짓 GO 주지 않음.

---

## P1~P7 게이트 판정표

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **P1 엔진계약 충실성** | ✅ **PASS** | 재구현 아닌 **라이브 evaluate_price 직접 호출**(Django shell). 엔진 자체가 권위 → 동치 입증 불요. engine-contract.md line 인용도 pricing.py와 충실 일치(독립 대조). |
| **P2 골든 재현성** | ⚠️ **PARTIAL PASS** | 면적매트릭스 4앵커(실사 1000×1000=20,000·off-grid 600×900=20,000·아크릴 3T=3,100·1.5T=2,480) **오차 0 재현**. 엽서 인쇄비 앵커 20,000 **재현 실패**(라이브 11,750·N-1). |
| **P3 차원매핑 정확성** | ✅ **PASS** | dimension-mapping-matrix 독립 재실측 — 본체 면적매트릭스·용지비·무광코팅·디지털본체 3원 일치 비준. 결함셀(D-1~D-4)도 라이브와 일치. |
| **P4 불필요분 실재성** | ✅ **PASS** | D-1(줄수 이중) ·D-2(개수 이중)·D-3(귀돌이 오염 이중)·D-4(유광 0행) 재현 SQL + **엔진 발화 정량 확인**. 동의어중복 1건·고아 0 비준. |
| **P5 옵션/템플릿/제약/공정 정합** | ⚠️ **PARTIAL PASS** | R-2(옵션→가격 미도달) 비준(EOP-1/2 엔진 실측). BUNDLE 무결성·트리거 PASS. ETP-1(template_prices 0) 비준. **단 EOC-2 어느 룰이 활성인지 생성측 오기(N-2)**, EPJ-1 메커니즘 부정확. |
| **P6 사이즈 무중복** | ✅ **PASS** | 이산↔구간 혼동 0·상품군별 단일축·동의어중복 1건(파일럿 가격사슬 참조 0)·S1/S2 판형분기 정당. 전부 독립 재현 비준. |
| **P7 생성-검증 독립성** | ✅ **PASS** | 라이브 직접 재실측(엔진+psql)·생성측 주장 비신뢰. **dodge-hunt로 3건 부정확 적발**(N-1 골든 미재현 미포착·N-2 EOC-2 활성룰 오기·N-3 COROTTO 미배선 오기). 날조(존재하지 않는 라인 인용) 0건. |

> **하나라도 FAIL이면 NO-GO 규칙**: FAIL 없음. PARTIAL 2건(P2·P5)은 면적매트릭스 범위에선 PASS,
> 엽서 범위에선 결함 잔존. → 전체 = **CONDITIONAL-GO**(상품군별 분기).

---

## 게이트별 상세

### P1 — 엔진계약 충실성 ✅ PASS
- 임시 venv(Django 5.2.15 + psycopg3 + unfold)로 `catalog.pricing.evaluate_price`를 라이브 Railway DB에 부트스트랩,
  실제 호출 성공. **메모리 [[huni-price-quote-harness]] "evaluate_price 미구현(round-18)"은 STALE** — 현재 라이브 구현·호출 가능.
- engine-contract.md의 명제(C1~C9·P1~P8)를 pricing.py 라인과 독립 대조: line 인용 정확(예 NON_QTY_DIMS:38-39,
  TIER_UPPER:46, component_subtotal:185-190, _quantity_discount:478-505). **날조 인용 0건.**
- 검증 방법이 재구현이 아니라 엔진 자체라, 동치 입증 단계 생략 가능(정의상 충실).

### P2 — 골든 재현성 ⚠️ PARTIAL PASS
- **PASS 부분(면적매트릭스)**: 실사·아크릴 4앵커 전부 final_price = 골든 정확 일치(오차 0). off-grid ceiling
  (600×900→1000행=20,000) 엔진 발화 입증. 두께축 ×0.8(2,480) 직교 입증.
- **FAIL 부분(합산형 엽서)**: 엽서 인쇄비 라이브 11,750 ≠ 골든 20,000.
  - 갈린 지점①: 단가표 값 불일치(라이브 470@min_qty25 vs 골든 800@출력매수25).
  - 갈린 지점②: 엔진에 판걸이수→출력매수 변환 부재(pricing.py grep 0건) — 엔진은 qty 직접 티어 사용.
  - → **N-1 신규 결함.** 엽서 가격사슬은 골든 권위와 정합하지 않음. **막힌 게이트 보정 대상: chain-inspector가
    엽서 인쇄비 단가행 재적재(골든 `디지털인쇄비` 시트 값) + 임포지션 변환을 엔진/공식 어디서 할지 정립**(authority-gaps에
    Q-IMPOSITION 신설 권장).

### P3 — 차원매핑 정확성 ✅ PASS
- dimension-mapping-matrix의 3원(use_dims↔충전↔권위) 셀을 라이브 재실측. 본체 comp(BANNER_NORMAL=[sw,sh]·
  ACRYL_CLEAR3T=[sw,sh,mat]·PAPER=[siz,mat]·COAT_MATTE=[siz,coat,mq]·DIGITAL_S1/S2) 선언=충전 일치 비준.
- 결함셀(CREASE_1L dv 과충전·CORNER_RIGHT 028 오염·GLOSSY 0행)도 생성측 표와 라이브 일치.

### P4 — 불필요분 실재성 ✅ PASS
- D-1~D-4 재현 SQL 독립 재실행 + **엔진 발화 정량 확인**(recompute-log §3). 줄수2 정확히 2배(2,400,000),
  개수2 2배(40,000), 둥근 2배(400,000), 유광 0원. 전부 실재.
- 동시매칭(ERR_AMBIGUOUS)·중복(ERR_DUPLICATE) 클린(파일럿 본체). 고아 옵션/아이템 0.

### P5 — 옵션/템플릿/제약/공정 정합 ⚠️ PARTIAL PASS
- **비준**: R-2(라이브=ref_dim 차원풀이·7종 중 4종만 가격연결) — EOP-1(.06 도수 미매핑→print_opt_cd 미충족)·
  EOP-2(.04 코팅→coat_side_cnt 미충족) 엔진 실측. EOP-3(현수막 가공 component 부재) 비준. EPJ-2(타공 dtl_opt NULL) 비준.
  BUNDLE 무결성(양면테입·봉미싱·큐방·끈·각목+끈 자재+공정) 트리거 PASS. ETP-1(template_prices 0) 비준.
- **정정(생성측 부정확)**: EOC-2 — 생성측은 "RULE_001/002 금지테스트가 use_yn=Y 활성"이라 했으나 실측은
  RULE_001/002=**del_yn=Y(논리삭제·런타임 제외)**, 활성 junk는 **RULE_003**(RULE_TYPE.03 필수동반·err_msg `11111`).
  결함 본질(junk 제약 잔존)은 맞으나 **어느 룰이 활성인지 틀림**(N-2). EPJ-1 "ERR_AMBIGUOUS" 메커니즘 부정확(실제 no-match).

### P6 — 사이즈 무중복 ✅ PASS
- size-dedup-report 독립 재현: 이산↔구간 혼동 comp 0, 상품군별 단일축, 동의어중복 SIZ_000104/105 1건
  (component_prices 참조 0=영향 없음), S1/S2 판형 이중키는 정당 분기(이중합산 위험은 D-5로 별도 기록).

### P7 — 생성-검증 독립성 ✅ PASS
- 생성측 보고서를 신뢰하지 않고 전 결함을 엔진/psql로 직접 재실행. **dodge-hunt 성과**:
  - N-1: 생성측이 **골든 P3(엽서 full) 재현 실패를 미포착**(authority-gaps Q-ROUND로만 처리, 단가표 불일치·임포지션
    미구현은 누락). 검증측이 라이브 재계산으로 적발.
  - N-2: EOC-2 활성 룰 오기(del_yn 무시).
  - N-3: D-7 "COROTTO 미배선" 오기 — 실측 COROTTO wired=1(PRF_COROTTO_ACRYL).
- **날조(부존재 라인 인용·거짓 GO) 0건.** 생성측은 정직한 CONFIRM 표기(D-5/D-6/D-7)로 과단정 회피 — 양호.

---

## 보정 인계 (NO-GO/PARTIAL 해소 경로)

| 막힌 부분 | 보정 대상 산출 | 무엇을 |
|----------|--------------|--------|
| P2 엽서 골든 미재현 (N-1) | chain-inspector + authority-curator | 엽서 인쇄비 단가행을 골든 `디지털인쇄비` 시트값으로 재적재 + 판걸이수→출력매수 변환 위치 정립(Q-IMPOSITION 컨펌) |
| P5 EOC-2 활성룰 오기 (N-2) | option-constraint-mapper | template-constraint-board §2.2 표 정정(RULE_003 활성·RULE_001/002 del_yn=Y) |
| P7 D-7 COROTTO (N-3) | chain-inspector | chain-defect-board D-7 정정(COROTTO=PRF_COROTTO_ACRYL 배선됨, MIRROR3T만 미배선) |
| 실 교정 (D-1~D-4·EOP·EOC-2 junk) | **인간 승인 후 dbmap 트랙** | dbm-axis-staged-load / dbm-load-execution / dbm-price-arbiter 위임. 본 게이트는 비준만, COMMIT 0. |
