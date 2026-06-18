# Confirmed Defects — 비준/기각/신규 + dbmap 라우팅

> **Phase 3 — hpq-quote-gate-validator** · 2026-06-18 · `huni-price-quote`
> 생성측 주장을 라이브 엔진/psql 독립 재현으로 **비준(CONFIRMED) / 기각·정정(REJECTED·CORRECTED) / 신규(NEW)** 분류.
> 실 교정은 본 에이전트가 하지 않음 — **GO된 결함만 인간 승인 후 dbmap 트랙 위임**.

---

## A. 비준된 결함 (독립 재현으로 진짜 확정)

| ID | 상품 | 결함 | 재현 증거(엔진/psql) | 심각도 | dbmap 라우팅 |
|----|------|------|----------------------|:--:|--------------|
| **D-1** | 엽서·현수막 | 오시 줄수 이중합산 (CREASE_1L 줄수1/2/3 + 2L/3L 별배선) | 엔진: 줄수2→2,400,000(=2배), 줄수1→1,000,000 | 🔴 High | dbm-axis-staged-load(배선축소 use_yn=N, 단가행 보존) |
| **D-2** | 엽서·현수막 | 가변데이타 개수 이중합산 (VARTEXT/VARIMG_1EA + 2EA/3EA) | 엔진: 개수2→40,000(=2배) | 🔴 High | 동상(D-1) |
| **D-3** | 엽서·현수막 | 귀돌이 직각 comp에 둥근(028) 오염행 → 둥근 이중합산 | 엔진: 둥근→400,000(=2배), psql RIGHT proc028=9행 | 🔴 High | dbm-correctness-audit(CORNER_RIGHT 028행 제거/use_yn=N) |
| **D-4** | 엽서 | 유광코팅 단가행 0건 → 유광 무료(침묵 0원) | psql GLOSSY=0행, MATTE=92행 | 🟡 Med | dbm-price-import(코팅 유광2열 추출·적재) |
| **D-5** | 엽서 | 디지털 인쇄비 S1/S2 양키 동시제공 시 이중합산 | 엔진: plt+siz→35,500(=11,750+23,750). price_simulate(:1270) 가드 없음 | 🟡 Med (조건부) | 엔진/호출측 단일키 가드 or 배선정리. **위젯 키구성 점검 필요** |
| **D-6** | 현수막 | 별색인쇄비(SPOT_WHITE) 현수막 공식 배선(권위 별색축 없음) | psql 배선존재·use_dims에 sw/sh 없음→현 무발화 | ⚪ Info | CONFIRM(현수막 별색 도메인) → 부재 확정 시 배선제거 |
| **EOP-1** | 엽서 | 인쇄 도수(.06) 미매핑 → 단/양면 가격 미반영 | 엔진: POPT1=11,750 vs POPT2=27,000(가격축), .06 미설정→0원. _opt_maps:1171 | 🔴 High | 옵션해석규칙(.06→print_opt_cd) or raw 드롭다운 |
| **EOP-2** | 엽서 | 코팅(.04 proc)↔coat comp(coat_side_cnt) 차원불일치 → 코팅비 0원 | 엔진: coat_side_cnt 미설정→0원, =1→30,000 | 🔴 High | 옵션모델 + comp 차원정합 |
| **EOP-3** | 현수막 | 가공/추가 옵션 전부 가격 component 부재 → 침묵 0원 | psql: PRF_POSTER_BANNER_N에 타공/부착/열재단/봉미싱 comp 0 | 🔴 High | dbm-price 가격사슬 component 신설 |
| **EOP-4/EPJ-2** | 현수막 | 타공 구수(4/6/8) dtl_opt NULL → 판별 소실 | psql OPV_000007/8/9 dtl_opt 전부 공란 | 🟡 Med | 옵션 dtl_opt + 타공 comp 신설 |
| **EPJ-1** | 린넨(파일럿외) | 봉제 마감유형 dim_vals 누락 → 마감유형별 단가 선택불가 | psql LINEN_FINISH 5행 dim_vals 전부 NULL·dtl_opt는 정확 | 🔴 High | 단가행 dim_vals 적재 |
| **ETP-1** | 전역 | template_prices 0행 → SKU 1순위 단가 미적재, 본품공식 재계산 | psql template_prices=0 | 🔴 High | dbmap 가격적재(SKU 단가) |
| **EOC-1** | 전역 | 사용자 3유형(사이즈→추가상품/접지/박min·max) 0건 표현 | psql 활성제약 8=nonspec치수7+junk1 | 🔴 High | ①미적재(RULE_TYPE.03), ②③ 그릇한계→rpmeta |
| **GAP-ACR-OPT** | 아크릴 | CPQ 옵션 레이어 전무(후가공·두께 미적재) | psql PRD_000146 option_groups/items=0 | 🔴 High | dbmap CPQ 적재 |
| **SIZ-DUP** | 전역 | 사이즈 동의어 중복 SIZ_000104/105(165x115mm) | psql del_yn=N 중복1건·가격사슬 참조0 | 🟡 Med | dbm-axis-staged-load ②사이즈(잉여 use_yn=N) |

---

## B. 기각·정정된 주장 (생성측 부정확 — 검증측 적발)

| ID | 생성측 주장 | 검증 실측 | 처분 |
|----|------------|----------|------|
| **N-2 (EOC-2)** | PRD_000001 금지테스트 "RULE_001/002 use_yn=Y 활성 junk" | RULE_001/002 = **del_yn=Y(논리삭제·런타임 제외)**. 활성 junk는 **RULE_003**(RULE_TYPE.03·err_msg `11111`) | **정정** — 결함 본질(junk 잔존) 유지, 활성 룰 ID 교정. template-constraint-board §2.2 표 보정 |
| **N-3 (D-7)** | "COMP_ACRYL_COROTTO·MIRROR3T 둘다 미배선(wired=0)" | COROTTO **wired=1**(PRF_COROTTO_ACRYL 배선). MIRROR3T만 0 | **정정** — D-7은 MIRROR3T에만 적용. COROTTO는 견적가능(미사용 아님) |
| **EOP-2 메커니즘** | "ERR_AMBIGUOUS 또는 strict ok=False" | 실측 = **no-match 0원**(coat_side_cnt non-NULL행이 NULL선택과 불일치 탈락). AMBIGUOUS 아님 | **메커니즘 정정** — 결함(코팅비 미반영) 유지 |
| **EPJ-1 메커니즘** | "5행 동시매칭 → ERR_AMBIGUOUS" | 실측 = **단일 combo·tier충돌 no-match**(5행 같은 combo_key). AMBIGUOUS 아님 | **메커니즘 정정** — 결함(마감유형 선택불가) 유지 |

> **날조(부존재 라인 인용·거짓 GO) 0건.** 생성측은 정직한 CONFIRM(D-5/D-6/D-7) 표기로 과단정 회피. 위 4건은
> 데이터 상태(del_yn/wired) 또는 엔진 거동 세부 오독이지 날조 아님. 생성측 검사 품질은 전반적으로 높음.

---

## C. 신규 결함 (검증측이 발굴 — 생성측 미포착)

### N-1 [🔴 High] 엽서 골든(인쇄비 20,000 / full 22,119.2) 라이브 재현 불가
- **증거**: 라이브 엔진 엽서 인쇄비 = 11,750(470×25) ≠ 골든 20,000(800×25).
  - ① 단가표 값 불일치: 라이브 DIGITAL_S1 min_qty25=470 vs 골든 `디지털인쇄비:D16`=800. min_qty1=3,500 vs D4=4,000 등 체계적 불일치.
  - ② 임포지션 변환 부재: pricing.py·price_views.py에 판걸이수→출력매수(ceil(qty/판걸이)) 변환 **grep 0건**. 엔진은 qty 직접 티어.
- **함의**: 합산형(엽서류) 가격사슬이 골든 권위와 정합하지 않음. 생성측 chain-defect-board는 후가공 add-on 결함(D-1~D-4)에
  집중했으나 **본체 인쇄비 단가표/엔진 정합 자체의 불일치를 놓침**(authority-gaps Q-ROUND로만 다룸).
- **라우팅**: dbm-price-arbiter(돈 크리티컬 심의) — 엽서 인쇄비 단가행 재적재 + 임포지션 변환 위치 결정(엔진 vs 공식 vs 입력측).
  authority-gaps에 **Q-IMPOSITION**(판걸이수 변환 위치) 신설 권장.
- **주의**: 용지비는 일치(70.64=골든 I6) — 인쇄비 단가행만 갈림. 면적매트릭스(실사·아크릴)는 무관(완전 재현).

---

## D. CONFIRM 큐 잔존 (도메인/인간 확인 필요)

| ID | 항목 | 확인 주체 |
|----|------|----------|
| Q-IMPOSITION (N-1) | 판걸이수→출력매수 변환을 엔진/공식/입력 어디서? 엽서 인쇄비 단가표 권위 재확정 | 사용자/도메인 |
| Q-ACR-ENGINE | 아크릴 수량할인 개당×수량 vs 총액(케이스3c 100개=248,000 가설) — 본 검증은 qty1 앵커만 확인 | 사용자 |
| D-5 위젯 키구성 | 위젯/시뮬레이터가 plt_siz_cd·siz_cd를 동시 보낼 수 있는가(엔진 가드 없음) | 라이브 admin/위젯 재캡처 |
| CONFIRM-EOP1 | 도수가 raw print_opt_cd 드롭다운으로 별도 노출되는가 | 라이브 admin |
| CONFIRM-EOC3 | 박 min/max = 제약 logic vs 앱/공식 계산 | 사용자/rpmeta |
| CONFIRM-EOC4 | 현수막 PRD_000138 vs 139 치수범위 제약 비대칭 | 라이브 화면 |

---

## 요약

- **비준 결함 15건**(D-1~D-6·EOP-1~4/EPJ-1·EPJ-2·ETP-1·EOC-1·GAP-ACR-OPT·SIZ-DUP) — 전부 라이브 재현.
- **정정 4건**(N-2 EOC-2 활성룰·N-3 COROTTO·EOP-2/EPJ-1 메커니즘) — 결함 본질 유지, 세부 교정.
- **신규 1건**(N-1 엽서 골든 미재현) — 검증측 dodge-hunt 발굴.
- **날조 0건.** 실 COMMIT 0(인간 승인 후 dbmap 위임).
