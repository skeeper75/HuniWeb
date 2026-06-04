# 가격 매핑 파일럿 — 굿즈파우치 (round-2)

첫 통합 매핑 파일럿. 굿즈파우치(가격포함) 상품으로 **단가 경로 + 사이즈 variant 경로**를 end-to-end 검증하고, **round-1(수량구간할인)과 통합**해 본다. **스키마 변경 0 · DB 무접촉**(읽기전용 참조 CSV + 적재용 CSV만, 실제 적재 미수행). 식별자/컬럼/코드는 영어.

> [HARD 원칙] ① 완제품을 "고정가" 등 하나의 유형으로 **단정하지 않는다**(완제품은 수량×단가·구간할인·결합 등 여러 방향으로 쓰임). ② **스키마를 변경하지 않고** 기존 구조로 매핑한다. ③ 각 매핑에 **왜 그렇게 했는지(근거)**를 남긴다.

## 0. 가격 계산의 전체 구조 (왜 이 매핑인가)

후니 가격은 3형태가 결합한다: **(가) 수량×단가**, **(나) 수량구간할인**, **(다) 여러 유형 결합**. 굿즈/파우치·문구·아크릴은 (가)+(나) 형태다:

```
최종가 = base 단가(상품/사이즈/옵션별)  ×  수량  ×  (1 − 수량구간할인율)
          └ round-2 (이 작업)              └ 주문        └ round-1 (이미 매핑 완료)
```

→ 그래서 round-2는 **base 단가만** 적재한다. 구간할인은 round-1이 이미 `DSC_GOODSA/B`·문구·아크릴 할인테이블 + 상품링크로 매핑했으므로 **재매핑하지 않는다**(중복 방지). 완제품을 "고정가"로 보면 이 구조가 깨지므로 단정하지 않는다.

## 1. 파일럿 상품 (3종, 경로별 근거)

| 상품 | prd_cd | 시트 단가 | round-1 할인 | 적재 경로 · 근거 |
|------|--------|-----------|--------------|------------------|
| 레더코스터 | PRD_000188 | 3300 (원형90mm 단일) | DSC_GOODSA | `t_prd_product_prices`. **근거**: 사이즈/옵션 variant 없음 → 단일 단가 1행. 단가이지 합가/고정가 아님(수량·할인은 외부) |
| 사각손거울 | PRD_000186 | S/M/L=5000/5500/6000 | DSC_GOODSA | `t_prc_component_prices`(siz_cd). **근거**: 사이즈별 단가 상이 → product_prices PK(2컬럼) 불가, siz_cd 차원 필요(결정③) |
| 머그컵 | PRD_000193 | 화이트/반투명/투명=6500/7500/7500 | DSC_GOODSB | **보류**. **근거**: 색상→mat_cd인데 머그 색상 자재 부재(AWK-6). 자재 등록 후 적재 |

## 2. 매핑 설계 (근거 포함)

### 경로 A — 단일 단가 → `t_prd_product_prices` (레더코스터)
- `(PRD_000188, 2026-06-01, unit_price=3300)`. 1행.
- **왜 product_prices?** variant가 없어 한 상품에 단가 1개뿐 → PK(prd_cd, apply_ymd)로 충분. 차원 테이블 불필요.
- **왜 3300이 고정가 아닌가?** 구간할인적용테이블=굿즈A타입(round-1). 100개 주문 시 3300×100×(1−할인). 즉 per-item 단가.

### 경로 B — 사이즈 variant 단가 → 공식 + `component_prices`(siz_cd) (손거울)
- `PRF_GDS_SQMIRROR`(FRM_TYPE.02 단순형) ← **왜 단순형?** base가 단일 단가(인쇄+코팅 등 합산 아님). 단 "고정가"로 단정 아님 — 수량·할인이 붙는다.
- `COMP_GDS_SQMIRROR`(comp_typ_cd=**`PRC_COMPONENT_TYPE.06` 완제품비**) ← **왜 .06?** 완제품 통가격(인쇄/코팅 비분해) 구성요소 = 규칙10 경로②. **D-D 확정으로 AWK-7 해소**(당초 NULL). 코드행은 `t_cod_base_codes.csv` 선적재(FK 부모).
- `component_prices` 3행: siz_cd=SIZ_000384/386/388, unit_price=5000/5500/6000, 그 외 차원 NULL ← **왜 siz_cd?** 사이즈가 가격 결정축. SIZ 코드·product_sizes 링크 기존재(파일 해소).
- `t_prd_product_price_formulas`: PRD_000186→PRF. 구간할인은 round-1 `t_prd_product_discount_tables`(DSC_GOODSA)가 별도 링크.

### apply 일자 — `2026-06-01`
- **왜 이 값?** round-1 `t_prd_product_discount_tables`와 라운드 정합. **형식 표준 = `yyyy-MM-dd`(D-E 확정, AWK-8 해소)** — DDL comment(`yyyy-MM-dd`)와 정합. round-1 적재 CSV도 `2026-06-01`로 정정 완료.

## 3. 검증 (파일 기반, DB 무접촉)

- recompute(시트값=CSV값): 레더코스터 3300, 손거울 5000/5500/6000 일치
- FK 존재(참조 CSV): prd_cd·siz_cd·frm_typ_cd 부모 존재
- 제약: 자연키 UNIQUE8 무중복·apply_ymd NOT NULL·use_yn/addtn_yn∈Y/N·PK 유니크
- round-1 통합: 손거울/레더 → DSC_GOODSA, 머그 → DSC_GOODSB 링크 기존(중복 매핑 안 함)

## 4. 어색한 데이터 (→ `03_validation/price-awkward-data.md` 상세)

AWK-1 미등록 상품 5종 · AWK-3 variant 35종 · AWK-5 "사이즈 필수"칸에 옵션(11온스/색상) 혼재 · AWK-6 머그 색상 mat_cd 부재 · ~~AWK-7 완제품가 comp_typ_cd 부재~~ ✅ **해소(D-D: `.06` 신설)** · ~~AWK-8 apply 일자 형식 불일치~~ ✅ **해소(D-E: yyyy-MM-dd)** · AWK-9 가격=단가+round-1 할인.

## 5. 산출물 · 다음

- `02_mapping/load_price_pilot/` 적재용 CSV 7종(DB 미적재) — `t_cod_base_codes.csv`(`.06` 코드행) 신설 포함. 적재순서: `t_cod_base_codes`(코드) → `t_prc_price_components` → 나머지(FK 부모 선존재)
- `00_schema/ref-*.csv` 읽기전용 참조 5종
- 다음: AWK-6(머그 자재)·AWK-7/8 해소 → 색상 variant 보강(AWK-6 후니 등록 대기) → 고정가형 확대 → 원자합산형(엽서) 파일럿. (AWK-7=`.06` 확정, AWK-8=`yyyy-MM-dd` 확정.)
