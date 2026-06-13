# 코팅 시트 게이트 (coating-gate) — round-16 (B) 독립 검증

> **검증자** dbm-validator (생성자 아님 · 빌더 의심 · 직접 실측). **2026-06-13.**
> **권위 입력:** 원본 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 시트 `코팅`(openpyxl `data_only=True`·전수 카운트) + 라이브 `t_prc_*`·`t_siz_sizes` information_schema 실측(`.env.local RAILWAY_DB_*` 읽기전용·`db railway`). **DB 미적재.**
> **종합 평결: GO** (P1~P6 전건 PASS · 빌더 주장 184·.01·siz 매핑·가격사슬 완결·siz_nm 라벨 — 전부 라이브/원본 실측으로 재확인. 뒤집힌 항목 0 · 보정 0).

---

## P1 — 그릇 = 라이브 1:1 · **PASS**

빌더 산출 import.xlsx 4시트(`price_formulas`·`formula_components`·`price_components`·`component_prices`)가 라이브 4테이블과 1:1. 1행=DB컬럼·2행=한글 규약 준수.

라이브 information_schema 실측으로 그릇 컬럼 전건 실재 확인:
- `t_prc_component_prices`: comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·**coat_side_cnt(integer)**·bdl_qty·min_qty·unit_price(numeric)·proc_cd·opt_cd — 전부 실재.
- `t_prc_price_components`: comp_cd·prc_typ_cd·**use_dims(jsonb)** — 실재.

`coat_side_cnt`가 빌더가 "신설"이라 표현했으나 **라이브에 이미 실재**(integer 컬럼). 미적재 결함 아님 — 정상.

---

## P2 — stale 점검 · **PASS**

round-2/round-14 변경(8→10차원·단가/합가) 반영분만 인용, frm_typ_cd 등 라이브 부재 개념 미사용. 산출물이 라이브 실측을 권위로 삼음(추정 0). stale 인용 없음.

---

## P3 — 무손실: 빌더 주장 **국4절92 + 3절92 = 184행** · **PASS (재카운트 일치)**

**원본 openpyxl 직접 전수 덤프(A1:E56):**
- B01 코팅(국4절) A1:E26 — 수량 23행(R4~R26) × 4 데이터열(무광단/무광양/유광단/유광양) = **92셀**.
- B02 코팅(3절) A31:E56 — 수량 23행(R34~R56) × 4 데이터열 = **92셀**.
- 합 = **184 데이터셀**. 빌더 주장 일치.
- 머지: A1:E1·B2:C2·D2:E2 (B02 동형 A31:E31·B32:C32·D32:E32) — 전부 차원 헤더(데이터 아님). 침묵 삭제 0.

**import.xlsx 실데이터 재카운트:** `component_prices` 시트 = 헤더 3행(노트·DB컬럼·한글) + **데이터 184행**(8그룹 × 23). comp_cd not-null 기준 정확히 184. (앞선 185 카운트는 R3 한글라벨 포함 오산 — 정정.)

**셀단위 cross-check(원본 184셀 ↔ import 184행):** 키 (comp_cd, siz_cd, coat_side_cnt, min_qty) 전수 대조 → **MATCHED 184 · MISMATCH 0**. 무손실 입증.

---

## P4 — 단가/합가: 빌더 **단가형(PRICE_TYPE.01)** 판정 · **PASS (정당)**

라이브 실측: `COMP_COAT_MATTE`·`COMP_COAT_GLOSSY` 둘 다 `prc_typ_cd = PRICE_TYPE.01`. 빌더 3중 근거 독립 재검증:
1. **라이브 실측** — 둘 다 .01 확인.
2. **단가 거동 감소** — 원본 직접 확인: 국4절 무광단면 2000→1500→1200→…→100 (수량 증가에 단가 감소). 합가형(구간총액)이면 단가 증가해야 함 → 단가형 확정.
3. **장당 단위** — 헤더 "수량(국4절)"별 장당 단가, 구간총액 표기 없음.

**합판/인쇄후가공(합가형)과 다른 .01이 맞는가:** 합판·인쇄후가공은 구간총액(합가)이지만, 코팅은 셀값이 명백히 장당 단가(수량 증가에 단조 감소)라 **.01이 정당**. 오적재 아님.

---

## P5 — 동시매칭 0 + 차원 매핑 · **PASS**

라이브 실측 차원 매핑 검증:
- 코팅종류(무광/유광) = **comp_cd 분리**(COMP_COAT_MATTE / COMP_COAT_GLOSSY) — collapse 금지 정당.
- 인쇄면(단/양면) = **coat_side_cnt**(1/2). 라이브: side2 = side1×2 정확(국4절 무광 1매 side1=2000·side2=4000 …).
- 출력판형(국4절/3절) = **siz_cd**(SIZ_000499 / SIZ_000077).
- 수량 = **min_qty**(23구간, 1000000=무한대 대용).

**동시매칭 검증(라이브):** 그룹별 distinct min_qty = 23(중복 0). 8 키조합군 × 23 = 184, 자연키 중복 없음. NULL 와일드카드행과 전용행 공존 없음 → **동시매칭 0**.

**proc_cd=NULL 정당성(검토 요구 항목):** 코팅은 공정(후가공)이지만 무광/유광을 **별개 comp_cd로 분리**했으므로 한 comp 안에서 공정종류로 단가가 갈리지 않음 → `proc_cd` 차원 불필요. 라이브 실측: COAT 184행 전부 **proc_cd=NULL · clr_cd=NULL · mat_cd=NULL**(notnull 카운트 0/0/0). 와일드카드 정당, 과분할 없음. **PASS.**

---

## P6 — 가격사슬: 빌더 **완결(13상품 → PRF_DGP_A/D/E 배선·184행)** · **PASS (라이브 직접 확인)**

라이브 4단 전건 실재:
| 단계 | 라이브 실측 | 상태 |
|------|-----------|------|
| component_prices | COAT 184행 (8×23) | ✅ |
| price_components | COMP_COAT_MATTE·GLOSSY 정의(.01·use_dims=[siz_cd,coat_side_cnt,min_qty]·comp_typ=PRC_COMPONENT_TYPE.02) | ✅ |
| formula_components 배선 | PRF_DGP_A(seq13·14)·PRF_DGP_D(seq3·4)·PRF_DGP_E(seq3·4) → GLOSSY/MATTE, addtn_yn=Y (6행) | ✅ |
| product_price_formulas 바인딩 | PRF_DGP_A 9상품 + PRF_DGP_D 1 + PRF_DGP_E 3 = **distinct 13상품** | ✅ |

빌더 주장 "13상품" — 라이브 distinct prd_cd = **13** 정확 일치(A:PRD_000016~018,020~022,026,041,042 / D:PRD_000047 / E:PRD_000027~029). 가격사슬 완결 입증(아크릴 트랙의 단가행 적재됐으나 배선0 단절과 대조 — 코팅은 끝까지 연결).

**round-trip 손계산(import mermaid 예):** 국4절 유광 양면 100매 = 1000원/매. 라이브 SIZ_000499 glossy side2 min_qty=100 = 1000 ✅.

---

## 컨펌 항목 — siz_nm 라벨 출력판형 명칭 불일치 (빌더 주장 = 정당 확인)

라이브 실측: `SIZ_000499 = 316x467` · `SIZ_000077 = 300x625` — "국4절/3절" 출력판형 명칭과 불일치.
- 단가 round-trip 완전 일치(국4절 무광단면 2000·1500·1200·1000·800 = SIZ_000499 실측 / 3절 3000·2500·2000·1500·1200 = SIZ_000077 실측)이므로 **매핑은 정당**.
- siz_nm 라벨이 작업사이즈/캘린더 명칭으로 남아있는 **데이터 위생 이슈**(메모리 `dbmap-platesize-is-output-paper.md` "국4절=출력용지규격" 원칙상 정정 권장). round-16 범위 외 · 미적재 결함 아님. **인간 컨펌 항목으로 유지.**

---

## 빌더 주장 검증 결과표 (뒤집힌/보정 항목)

| 빌더 주장 | 독립 실측 결과 | 판정 |
|-----------|---------------|------|
| 국4절92 + 3절92 = 184행 | openpyxl 전수 184셀 · 셀단위 cross-check MATCHED 184/MISMATCH 0 | ✅ 확인 (뒤집힘 0) |
| 단가형 .01 정당 | 라이브 .01 + 단가 단조감소 + 장당단위 3근거 재확인 | ✅ 확인 |
| siz 매핑(SIZ_000499/SIZ_000077) | 단가 round-trip 라이브 완전 일치 | ✅ 확인 |
| 가격사슬 완결(13상품·6배선행) | 라이브 distinct prd_cd=13 · formula_components 6행 정확 | ✅ 확인 |
| siz_nm 라벨 불일치(316x467/300x625) | 라이브 실측 일치 · 위생 이슈로 컨펌 유지 | ✅ 확인 |
| proc_cd=NULL 정당 | COAT 184행 proc/clr/mat 전부 NULL | ✅ 확인 |

**뒤집힌 항목: 0. 보정 항목: 0.** (검증자 자체 오산정정 1건 — import 데이터행 185→184, R3 한글라벨 포함 오산이었고 빌더 산출은 정확.)

---

## 종합 평결: **GO**

- P1~P6 전건 PASS. 코팅 = 라이브 전량 적재·배선·바인딩 완료된 가격사슬의 **재현(신규 0)**. import.xlsx는 라이브 184행을 webadmin 복붙 그릇으로 무손실 재정리.
- **컨펌 1건:** siz_nm 라벨(SIZ_000499/SIZ_000077)을 출력판형 명칭으로 정정 권장(위생·범위 외).
- DB 미적재 — 실 COMMIT/라벨 정정은 인간 승인.
