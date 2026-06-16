# RP-Meta 결함 라우팅 (_defects.md)

> rpm-validator. M1~M6 게이트에서 발견한 결함을 책임 단계로 라우팅.
> 전체 판정 = **GO**(NO-GO 0). 결함은 전부 **Low**(판정 무영향·문서 정합/freshness). 차단 0.

---

## D-1 (Low) — SIZE_0 토큰 표기 정밀도 [M1 → rpm-reverse-engineer]

- **위치:** `01_reverse/rp-option-extract-BN.md:54` `사이즈직접입력(SIZE_0 cut 0x0)`.
- **결함:** 캡처(`s3_BNBNFBL.json`)에 리터럴 `SIZE_0` 부재. 실제 토큰=`사이즈직접입력`+`DIV_NM`/`DIV_CD`. `SIZE_0`은 아키텍트 약어.
- **심각도:** Low — 날조 아님(자유입력 모드는 캡처 실재, 출처규칙이 unobserved 날조 금지 명시). 표기 약어가 리터럴 코드처럼 보일 소지만 있음.
- **조치(선택):** `SIZE_0`을 "(자유입력 모드, 아키텍트 표기)"로 주석하거나 캡처 실토큰(DIV_CD) 병기. 메타모델 §13은 이미 `user_input(SIZE_0 자유)`로 약어 명시 — 일관성 OK.

---

## D-2 (Low) — 부차 행수 freshness 드리프트 [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md` 본문 부차 행수.
- **결함:** 일부 비핵심 행수가 검증자 라이브 재실측(2026-06-17)과 상이:
  | 테이블 | gap 표기 | 검증자 재실측 |
  |---|---:|---:|
  | t_prd_product_materials | 402 | **772** |
  | t_siz_sizes | 497 | **510** |
  | t_prd_product_sizes | 444 | **449** |
  | t_prd_product_plate_sizes | 509 | **424** |
- **심각도:** Low — 이 행수들은 어떤 PASS/WEAK/GAP 판정의 *근거*가 아님(전부 표현력 판정). gap-matrix §0의 핵심 12행수(option_items 등)는 전부 일치. 동일 세션 내 다른 시점 조회 또는 본문 내 옛 인용 혼입 추정.
- **조치(선택):** 부차 행수를 본 verdict 재실측값으로 갱신. 판정 변경 불요.

---

---

# ═══ GS(굿즈) 확장 결함 (v2.0·BN D-1/D-2 보존) ═══

## D-3 (Low) — 형태가공 공정 행 과소카운트 [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md:215` (§V #14) "라이브 `t_proc_processes` 실측: 조립/봉제/지퍼/가공 검색 → `PROC_000080 봉제`·`PROC_000088 봉제` 2행만".
- **결함:** 검색어(조립/봉제/지퍼/가공)가 **부착/족자제작/에폭시를 누락**. 검증자 라이브 재실측(2026-06-17): 형태가공 관련 = PROC_000080 봉제·**081 부착·082 족자제작·083 에폭시**(+중복 088/089/093/095). "봉제 2행만"은 과소.
- **심각도:** Low — **판정 무영향**(#14 GAP 판정 자체는 정확·`proc_typ_cd` 분류축 부재가 진짜 결손). 더구나 **04_vessel/vessel-form-assembly가 자체 라이브 재측으로 이미 정정**(PROC_000080~083 + prcs_dtl_opt 4스키마 정확 인용) → gap의 과소카운트가 vessel에서 교정됨(생성자≠검증자 분리 실작동).
- **조치(선택):** gap-matrix §V #14 행수를 "봉제/부착/족자/에폭시 4축(+중복)·proc_typ_cd 부재가 핵심 결손"으로 갱신. 판정(GAP) 변경 불요.
- **재실측 근거:** `t_proc_processes` proc_nm ~ '봉제|부착|족자|에폭시|조립|지퍼|가공' → 080봉제·081부착·082족자제작·083에폭시·088봉제·089부착·093족자제작·095에폭시. prcs_dtl_opt: 봉제`{유형:[오버로크,말아박기,봉미싱],폭:mm}`·부착`{대상:[라벨,맥세이프,끈,테입]}`·족자`{모양:[사각,원형]}`·에폭시 NULL.

---

---
---

# ═══ TP(디자인템플릿) 확장 결함 (v3.0·BN/GS 보존) ═══

## D-4 (Low) — "ORD_CNT=13" 캡처 미실재 표기 [M1 → rpm-reverse-engineer]

- **위치:** `categories/TP/reverse.md:163` `→ result_sum.PRICE=11900 (개당단가, ORD_CNT=13)`.
- **결함:** TPCLWLB priceCall 캡처(`s6_cal_TPCLWLB.json`) PRICE_LOG 재파싱 = "개당단가:11900.00원, 인쇄수량:1, **주문건수:1**". **ORD_CNT(주문건수)=1**, 13 아님.
- **심각도:** Low — **판정 무영향**(load-bearing 주장 PRICE=11900·PRT_DFT 인쇄 주체·에디터 PCS=0는 field-for-field 정확). "ORD_CNT=13"은 비-load-bearing 보조 주석(효도달력 13면 페이지수를 ORD_CNT로 오기 또는 다른 수량 상태 혼입 추정).
- **조치(선택):** `ORD_CNT=13` 삭제 또는 "(주문건수=1, 비로그인 캡처)"로 정정. 가격 구조 주장 무영향.
- **재실측 근거:** priceCalls[0].respBody.result[3] PRICE=11900(PCS_COD=PRT_DFT 인쇄단면)·result_sum.PRICE=11900·PRICE_LOG 주문건수=1.

---

## D-5 (Low) — 부차 카운트 freshness(proc 96/97·templates 테스트행) [M4 → rpm-gap-analyst]

- **위치:** `03_gap/gap-matrix.md:53`(t_proc_processes 96)·§IX-A(t_prd_templates 12행 봉투 전수).
- **결함:** ① 검증자 라이브 재실측(2026-06-17) `t_proc_processes`=**97**(gap·이전 verdict 인용 96, +1 드리프트). ② `t_prd_templates` 12행 중 **3행이 "테스트 템플릿"**(테스트 더미)·9행이 봉투 완제SKU — gap/vessel이 봉투류만 인용(테스트행 미언급).
- **심각도:** Low — **판정 무영향**. proc 96/97 ±1은 어떤 PASS/WEAK/GAP 근거 행수 아님(공정=PASS 표현력 판정). templates 테스트 3행은 T-A 이중의미 판정(봉투=완제SKU≠디자인 시안)을 바꾸지 않음(테스트행도 디자인 시안 아님).
- **조치(선택):** proc 카운트를 97로 갱신·templates 인용에 "(테스트 3행 포함 12)" 병기. 판정 변경 불요.

---

## 라우팅 요약

| ID | 게이트 | 책임 단계 | 심각도 | 차단? | 군 |
|---|---|---|:--:|:--:|:--:|
| D-1 | M1 | rpm-reverse-engineer | Low | No | BN |
| D-2 | M4 | rpm-gap-analyst | Low | No | BN |
| D-3 | M4 | rpm-gap-analyst | Low | No | GS |
| D-4 | M1 | rpm-reverse-engineer | Low | No | TP |
| D-5 | M4 | rpm-gap-analyst | Low | No | TP |

- **NO-GO 0 / 차단 0** — 재게이트 불요. BN+GS+TP 전 단계 GO 비준.
- D-1~D-5는 정합 개선(선택) — 산출물 신뢰성·판정에 영향 없음.
- **GS vessel(04) 4종 결함 0** — M5 search-before-mint 라이브 입증 통과(신규 테이블 0·이행종속 거부 정당·84상품 load-bearing 확증·컨벤션 drift 0).
- **TP vessel(04) V-10/V-11 결함 0** — M5 search-before-mint 라이브 입증 + 양 DDL BEGIN..ROLLBACK DRY-RUN 0 leaked(INSERT11+ALTER8+UPDATE107+CREATE2 무오류). 신규 테이블 2(V-11 시안 1:N·이중의미) 정당·V-10 테이블 0(채널 1:1) 정당.
- **GS 핵심 직답 확인:** 본체소재 vessel-gap(분해축)+data 양면 · #15 신규 그릇 0 정당(semi_role_cd 28행) · MAT_TYPE.09/.10 오라벨 확정(112 비자재·목적지 선행 필수).
- **TP 핵심 직답 확인:** #16 디자인 입력 채널 = **GAP(vessel-gap)** 라이브 확정(editor_yn 불리언만·item_gbn/채널/리소스/VDP 그릇 전무·base_code 에디터 enum 0·dbmap 미터치 신규) · D-11 = **진짜 distinct**(캡처 cross-tab으로 채널⊥가격·editor_yn 환원불가 동의) · 템플릿#4↔#16 이중의미 분리 정당(t_prd_templates=봉투 완제SKU 실측).
