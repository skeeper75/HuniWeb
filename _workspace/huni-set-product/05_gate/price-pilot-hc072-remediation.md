# 072 하드커버책자 — 교정 명세 + 라우팅 (게이트 확정 결함)

생성: hsp-set-gate · 2026-06-25 · 라이브 읽기전용 재실측 근거 · **DB 미적재**(실 COMMIT/DDL은 인간 승인 후 트랙 위임)

> 형식: {결함·권위 정답·교정·대상 t_*·FK 위상·돈영향·라우팅·인간 승인}.

---

## 1. 적재 GO 큐 (→ hsp-load-executor · 인간 승인 후 COMMIT)

| 산출 | 대상 t_* | FK 위상 | 행 | 돈영향 | 승인 |
|---|---|---|---|---|---|
| PRF_HC_MUSEON_SUM 정의 | t_prc_price_formulas | 1(parent) | 1 | 없음(미바인딩=가격 무영향) | 인간 |
| formula_components 4배선 | t_prc_formula_components | 2(child·FK 충족) | 4 | 없음(미바인딩) | 인간 |

- apply.sql = `price-pilot-hc072/apply.sql`(BEGIN/COMMIT 미내장·load-executor 래핑). 멱등 ON CONFLICT DO NOTHING·DRY-RUN PASS.
- **단독 적재 안전**: 072 미바인딩 상태이므로 PRF+fc 적재만으로는 어떤 상품 가격도 바뀌지 않음(그릇 선적재). 바인딩은 §2 BLOCKED 해소 후.

## 2. BLOCKED — 라우팅 (→ dbmap·인간 승인)

### BLK-HC-INNERPRINT (내지인쇄·돈 크리티컬)
- **결함**: 내지인쇄비 비목을 set 공식에 배선 불가. 활성 디지털인쇄 comp=S1 1개·S2 del_yn=Y·formula_components PK=(frm_cd,comp_cd)로 S1 2회 불가.
- **권위 정답**: calc-formula seq65 내지인쇄비 = [총내지매수행][도수열] × 총내지매수(부수×⌈페이지/판걸이⌉).
- **교정**: dbmap에서 `COMP_PRINT_BOOK_INNER` 신규 mint(S1 단가행 verbatim 복제·날조 0) → PRF_HC_MUSEON_SUM seq5 배선. (대안 B=S2 del_yn Y→N 활성화·단 S2 의미 재확인.)
- **대상 t_***: t_prc_price_components(comp 1)·t_prc_component_prices(S1 단가행 복제)·t_prc_formula_components(seq5 1행).
- **FK 위상**: price_components → component_prices → formula_components.
- **돈영향**: 🔴 최대(책자 가격 최대 비목). 미해소 시 바인딩 = 파국적 과소청구.
- **라우팅/승인**: dbmap(dbm-load-execution·dbm-ddl-proposer) · 인간 승인.

### BLK-HC-INNERPAPER (내지 용지비)
- **결함**: 내지 용지비 2번째 COMP_PAPER 평가슬롯 필요(한 comp·한 selections·1회 평가 제약).
- **권위 정답**: calc-formula seq9 용지비 공통산식([크기별기준단가]×[출력매수]+손지)·내지=택1 종이 절가(56행 기적재).
- **교정**: 내지인쇄 해소와 묶음(별 평가슬롯/comp). dbmap.
- **돈영향**: 🔴 내지 종이값 누락=과소청구.
- **라우팅/승인**: dbmap · 인간(BLK-HC-INNERPRINT와 동시).

### BLK-HC-BIND-PRF (바인딩 보류)
- **결함**: 내지인쇄+내지용지비 BLOCKED 상태 바인딩 시 책자 최대 비목 누락.
- **교정**: apply.sql 바인딩 INSERT 주석 유지. 내지 해소 후 주석 해제 + hsp-load-executor.
- **대상 t_***: t_prd_product_price_formulas(PK=prd_cd,apply_bgn_ymd·072 0행·충돌 0).
- **돈영향**: 🔴 가드(보류가 옳음).
- **라우팅/승인**: 내지 해소 후 hsp-load-executor · 인간 승인.

## 3. CONFIRM — 실무진/형식 (돈영향 명시)

| ID | 항목 | 권위 정답/보수안 | 돈영향 | 라우팅 |
|---|---|---|---|---|
| CFM-HC-BIND-DELYN | 제본 comp HC_MUSEON 삭제·SSABARI 대체 | SSABARI(활성·단가 byte동일) 배선 | 없음(단가동일) | 실무진(코드선택) |
| CFM-COVER-MAT | 표지 자재코드 MAT_000078 vs MAT_000246 | 아트150 직접 or 246 복제(46.65) | 없음(단가동일) | 적재 시 택1 |
| CFM-COVER-A4PLT | A4 표지 3절(SIZ_000475) 절가 부재 | 국4절만 실재·3절 적재 or 환산 | 🔴 A4 정확청구 | dbmap |
| CFM-COVER-COAT | 용지비 46.65 코팅 전/후 | 코팅 전 순수(아트150 row9 byte일치·코팅 별 시트) | 없음(현 설계 이중계상0) | 적재 직전 형식 |
| CFM-COVER-SONJI | 손지율 +5장 표지 | 앱 임포지션 | 소액 | 인간 |
| ★CFM-HC-COVER-PANSU | 표지 출력매수 차원(siz_cd 주입값에 따라 pansu 1 vs 4) | 표지=펼침면(390x268) 출력·CPQ가 펼침 사이즈코드 환원해야 옳은 출력매수 | 🔴 표지 비목 청구액 차이 | W7 CPQ option→차원·set-designer 보완 |
| CFM-HC-DSC | 072 할인 | discount_tables 0행=할인없음 | 없음 | RESOLVED |
| CFM-HC-FOIL | 후가공박 | 072 박 공정 미등록(권위+라이브) | 없음 | RESOLVED(N/A) |

## 4. 077/082 전파 선결

- **072 READY 검증 통과** → 077=표지 정액 모델(레더 4000/7000·COMP_PAPER 절가 부적합·표지 정액 comp 별 트랙)+자재 오등록(078=몽블랑130g) CONFIRM-077-MAT.
- **082=면지인쇄+면지코팅 2비목 추가(8비목·×2)** + 면지인쇄도 동일 2번째 인쇄 comp BLOCKED(표지+면지+내지 3 인쇄 슬롯).
- ★**내지인쇄 2번째 활성 인쇄 comp BLOCKED은 3셋트 공통 선결**(BLK-HC-INNERPRINT 해소가 전파 게이트).
