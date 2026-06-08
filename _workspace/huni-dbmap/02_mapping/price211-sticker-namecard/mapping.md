# price-211 슬라이스 C1 — 스티커(F4·12) + 명함(F5·7) MATRIX 가격 매핑 설계서

| 항목 | 값 |
|------|----|
| 트랙 | price-211 Phase-1, slice C1 (STICKER F4 + NAMECARD F5) |
| 작성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 성격 | **GENERATION ONLY** — 적재 실행본(멱등 SQL + DRY-RUN *plan*). DB 무쓰기. 검증은 dbm-validator 별도. |
| 권위 순서 | 가격표 엑셀 명시값 > `06_extract` L1 > 설계. **라이브 존재/바인딩 = 라이브 권위.** DDL = `00_schema/price-engine-ddl.md`(C-1~C-9). |
| SOURCE | F4 = `06_extract/price-sticker-price-l1.csv`(7블록) · F5 = `06_extract/price-namecard-photocard-l1.csv`(12블록) |

---

## 0. 핵심 발견 — 이 슬라이스는 "재적재"가 아니라 "바인딩 완성"이 본질

라이브 read-only 실측(`BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK`) 결과, **round-5가 스티커·명함의 공식/구성요소/단가 스캐폴딩을 이미 대량 구축**해 두었다. 12+7 무가격 상품은 그 스캐폴딩에 **바인딩(상품↔공식)만 안 된 잔여(residue)** 이다. 따라서:

- **대부분의 작업 = `t_prc_formula_components` 배선 + `t_prd_product_price_formulas` 바인딩.** 단가(`t_prc_component_prices`)는 이미 존재하는 경우가 다수 → **재적재 금지(중복·R² 회귀)**.
- 라이브에 단가가 **부재한 블록만** 신규 `component_prices` mint. search-before-mint 적용.

### 라이브 기존 스캐폴딩 (round-5 적재분, read-only 확인)

| frm_cd | frm_typ | wired comp_cd | 바인딩된 상품(기존) |
|--------|---------|---------------|---------------------|
| `PRF_STK_FIXED` | .02 단순형 | `COMP_STK_PRINT`(258행·6siz×3mat×36mq) | PRD_000052 반칼자유형, PRD_000053 반칼자유형투명, PRD_000055 낱장자유형 |
| `PRF_NAMECARD_FIXED` | .02 단순형 | `COMP_NAMECARD_STD_S1/S2`(4행) | PRD_000031 프리미엄, PRD_000032 코팅, PRD_000033 스탠다드 |
| `PRF_GANGPAN_FIXED` | .02 단순형 | `COMP_GANGPAN_PRINT`(370행) | PRD_000066 합판도무송 |

**명함 구성요소는 거의 전부 이미 mint+단가 적재됨**(라이브 `t_prc_price_components` 27종 COMP_NAMECARD_*): PEARL/COAT/CLEAR/WHITE/SHAPE/MINISHAPE/PREMIUM/FOIL/FOIL_SETUP. 단 `PRF_NAMECARD_FIXED`에는 **STD만 wired**, 7개 상품 components는 unwired·unbound.

---

## 1. STATUS — prd_nm→prd_cd 해소 + 바인딩 현황 (read-only 실측)

JOIN KEY = `prd_nm` only(MES_ITEM_CD NULL). 카테고리 링크 = `t_prd_product_categories`.

### 1.1 STICKER (CAT_000002) — 17행 중 12 무가격 대상

| prd_cd | prd_nm | nf | np | 상태 | L1 블록 |
|--------|--------|:--:|:--:|------|---------|
| PRD_000052 | 반칼 자유형 스티커 | 1 | 0 | **이미 바인딩(round-5)** — 제외 | B01 |
| PRD_000053 | 반칼 자유형 투명스티커 | 1 | 0 | **이미 바인딩** — 제외 | B01(투명열) |
| PRD_000055 | 낱장 자유형 스티커 | 1 | 0 | **이미 바인딩** — 제외 | B02 |
| PRD_000066 | 합판도무송스티커 | 1 | 0 | **이미 바인딩(GANGPAN)** — 제외 | (별도) |
| PRD_000002 | OPP비접착봉투 | 0 | 0 | **봉투 오분류** — 본 트랙 제외(F7 envelope) | — |
| PRD_000058 | 반칼원형스티커 | 0 | 0 | **무가격 대상** | B01 반칼 규격 |
| PRD_000059 | 반칼정사각스티커 | 0 | 0 | **무가격 대상** | B01 |
| PRD_000060 | 반칼직사각스티커 | 0 | 0 | **무가격 대상** | B01 |
| PRD_000061 | 반칼띠지스티커 | 0 | 0 | **무가격 대상** | B01 |
| PRD_000062 | 반칼팬시스티커 | 0 | 0 | **무가격 대상** | B01 |
| PRD_000063 | 반칼팬시투명스티커 | 0 | 0 | **무가격 대상** | B01(투명열) |
| PRD_000054 | 반칼 자유형 홀로그램스티커 | 0 | 0 | **무가격 대상** | B01(홀로그램열) |
| PRD_000064 | 소량자유형스티커 | 0 | 0 | **무가격 대상** | B06 기본가 |
| PRD_000057 | 대형 자유형 스티커 | 0 | 0 | **무가격 대상** | B04 대형(완칼) |
| PRD_000056 | 낱장 자유형 투명스티커 | 0 | 0 | **무가격 대상** | B03 낱장(완칼)투명 |
| PRD_000067 | 타투스티커 | 0 | 0 | **무가격 대상** | B05 타투 |
| PRD_000065 | 스티커팩 | 0 | 0 | **무가격 대상** | B07 스티커팩 |

→ **무가격 스티커 = 17 − 4(기바인딩) − 1(봉투 오분류) = 12.** 계획서 일치(VERIFIED).

### 1.2 NAMECARD (CAT_000294) — 10행 중 7 무가격 대상

| prd_cd | prd_nm | nf | np | 상태 | L1 블록 |
|--------|--------|:--:|:--:|------|---------|
| PRD_000031 | 프리미엄명함 | 1 | 0 | **이미 바인딩** — 제외 | B02 |
| PRD_000032 | 코팅명함 | 1 | 0 | **이미 바인딩** — 제외 | B03 |
| PRD_000033 | 스탠다드명함 | 1 | 0 | **이미 바인딩** — 제외 | B01 |
| PRD_000034 | 펄명함 | 0 | 0 | **무가격 대상** | B04 펄명함(스타드림) |
| PRD_000035 | 모양명함 | 0 | 0 | **무가격 대상** | B07 모양명함(90x50) |
| PRD_000036 | 미니모양명함 | 0 | 0 | **무가격 대상** | B08 미니모양명함(50x50) |
| PRD_000037 | 오리지널박명함 | 0 | 0 | **무가격 대상** | B09 오리지널박명함 |
| PRD_000039 | 투명명함 | 0 | 0 | **무가격 대상** | B05 투명명함 |
| PRD_000040 | 화이트인쇄명함 | 0 | 0 | **무가격 대상** | B06 화이트인쇄명함(큐리어스스킨) |
| PRD_000038 | 형압명함 | 0 | 0 | **무가격 대상(차단 후보)** | **L1 블록 없음** |

→ **무가격 명함 = 10 − 3(기바인딩) = 7.** 계획서 일치(VERIFIED). 단 PRD_000038 형압명함은 가격표에 블록이 없음 → **BLOCKED**(§6).

---

## 2. MATRIX → long-form 추출 (구성요소 차원)

### 2.1 변환 규칙 (skill 매트릭스 평면화)

L1 banded 2D → long-form `component_prices`(comp_cd, siz_cd, mat_cd, coat_side_cnt, clr_cd, bdl_qty, min_qty, unit_price, apply_ymd).

- **수량축(`row_key`) = `min_qty`.** 상향개방(max 없음·C-3). L1 "100000" 행 = 무제한 구간(round-5 동형 처리 확인 — COMP_STK_PRINT가 min_qty=100000 사용).
- **규격축(옵션 사이즈) = `siz_cd`.** L1 라벨(124x186/90x190 등)은 **판걸이 임포지션 규격**(출력효율 grouping)이지 상품표시 사이즈가 아니다 — 라이브 COMP_STK_PRINT가 정확히 이 의미로 적재됨(상품은 표시사이즈 A5/A4 링크, 가격행은 임포지션 키). **이 의미를 보존**(round-2 면적-좌표 오모델 금지).
- **소재축 = `mat_cd`.** L1 coating 밴드("유포/비코팅/미색" / "무광코팅/유광코팅" / "투명/홀로그램")는 **소재 그룹**. round-5 COMP_STK_PRINT는 그룹대표 3 mat(유포 MAT_000153 / 무광코팅 MAT_000155 / 투명데드롱 MAT_000170) 사용 — 본 슬라이스는 **기존 COMP_STK_PRINT 차원을 그대로 재사용**(재매핑·재적재 금지).
- **단/양면**: 명함은 단면=S1·양면=S2 별도 comp_cd(skill 규칙2, 양면≠단면×2). 스티커는 단/양면 축 없음.
- **clr_cd = NULL**(스티커·명함 가격행은 도수 무관, 별색은 공정·skill 규칙1).

### 2.2 매트릭스→long 행수 요약 (신규 mint 분만)

| 블록 | 신규 comp_cd | siz×mat×mq 셀 | 신규 long 행 | 비고 |
|------|--------------|---------------|:--:|------|
| B06 기본가 | (재사용 불요·완제품 단일가) | — | — | 소량자유형=고정 4000 base(§3) |
| B05 타투 | (단일가) | — | — | 3장마다 4000(메모, §6 BLOCKED-검토) |
| B07 스티커팩 | **재사용 `COMP_STK_PACK`(기존 2행)** | — | 0 | 단가 이미 적재, 배선만 |
| B04 대형(완칼) | 재사용 COMP_STK_PRINT(SIZ_000199/400x600·유포) | — | 0 | 이미 6행 적재 |
| B03 낱장투명(완칼) | 재사용 COMP_STK_PRINT(A4/A3/A2·투명) | — | 0 | 이미 적재(B02/B03 collapse) |
| 명함 7종 | **재사용 기존 COMP_NAMECARD_***(전부 적재됨) | — | 0 | 배선+바인딩만 |

**결론: 본 슬라이스 신규 `component_prices` 행 ≈ 0** (기존 단가 재사용). 적재물 = formula_components 배선 + product_price_formulas 바인딩이 핵심. (단가 부재 블록은 §6 BLOCKED.)

> [상세 셀↔행 검증은 dbm-validator가 원본셀 역대조로 수행 — 본 설계는 "기존 단가 재사용·재적재 금지" 결정을 권위로 명문화.]

---

## 3. FORMULA / component / binding 설계

### 3.1 STICKER — `PRF_STK_FIXED` 재사용 + 변형 바인딩

12 무가격 스티커 중 **반칼-cut 규격 변형(원형/정사각/직사각/띠지/팬시/팬시투명/홀로그램)** 은 B01 반칼 자유형/규격 매트릭스를 공유한다(이미 PRD_000052가 그 정답 패턴). → **`PRF_STK_FIXED`에 그대로 바인딩**(COMP_STK_PRINT 재사용).

| prd_cd | prd_nm | 매핑 결정 | frm_cd | 상태 |
|--------|--------|-----------|--------|------|
| PRD_000058 | 반칼원형스티커 | 반칼 규격 매트릭스 공유 | PRF_STK_FIXED | INSERTABLE |
| PRD_000059 | 반칼정사각스티커 | 〃 | PRF_STK_FIXED | INSERTABLE |
| PRD_000060 | 반칼직사각스티커 | 〃 | PRF_STK_FIXED | INSERTABLE |
| PRD_000061 | 반칼띠지스티커 | 〃 | PRF_STK_FIXED | INSERTABLE |
| PRD_000062 | 반칼팬시스티커 | 〃(팬시=동일가, 컷형상만 상이) | PRF_STK_FIXED | INSERTABLE |
| PRD_000063 | 반칼팬시투명스티커 | 반칼 투명열 매트릭스(PRD_000053와 동형) | PRF_STK_FIXED | INSERTABLE |
| PRD_000054 | 반칼 자유형 홀로그램스티커 | 반칼 홀로그램열(=투명/홀로그램 그룹가) | PRF_STK_FIXED | INSERTABLE |
| PRD_000057 | 대형 자유형 스티커 | B04 대형(완칼) — COMP_STK_PRINT SIZ_000199 재사용 | PRF_STK_FIXED | INSERTABLE |
| PRD_000056 | 낱장 자유형 투명스티커 | B03 낱장(완칼)투명 — COMP_STK_PRINT A4/A3/A2 투명 재사용 | PRF_STK_FIXED | INSERTABLE |
| PRD_000065 | 스티커팩 | B07 — **COMP_STK_PACK wire 필요**(미배선) + 바인딩 | PRF_STK_FIXED | INSERTABLE(배선+바인딩) |
| PRD_000064 | 소량자유형스티커 | B06 기본가(2000/4000 base, 비매트릭스) | — | **BLOCKED**(§6: base가 매트릭스 아님·구조 상이) |
| PRD_000067 | 타투스티커 | B05 타투(3장마다 4000·세트단가) | — | **BLOCKED**(§6: 3장단위 세트 단가, component_prices 부재) |

**배선 추가**: `PRF_STK_FIXED`에 `COMP_STK_PACK`(disp_seq 2, addtn_yn N — 별도 팩가)를 wire? → **아니오.** 스티커팩은 base 매트릭스와 다른 가격구조(세트가). 깔끔한 분리 위해 **신규 공식 `PRF_STK_PACK_FIXED`** 1행 mint + COMP_STK_PACK wire + PRD_000065 바인딩. (한 공식에 의미 다른 comp 혼재 회피.)

> [HARD] 반칼변형 7종 바인딩 시 **COMP_STK_PRINT의 siz/mat 차원이 그 상품의 표시사이즈와 다름**(가격=임포지션 키, 상품=표시 키)은 **라이브 정답 패턴(PRD_000052) 그대로** — 바인딩만으로 충분하며 새 차원 적재 불요.

### 3.2 NAMECARD — `PRF_NAMECARD_FIXED` 배선 확장 + 바인딩

7 무가격 명함은 components가 이미 적재됨. **각 상품의 components를 `PRF_NAMECARD_FIXED`에 wire + 바인딩**. (round-5가 STD만 wire한 것을 완성.)

| prd_cd | prd_nm | wire할 기존 comp_cd | 단가 존재? | 상태 |
|--------|--------|---------------------|:--:|------|
| PRD_000034 | 펄명함 | COMP_NAMECARD_PEARL_S1/S2 | YES(4행) | INSERTABLE(배선+바인딩) |
| PRD_000035 | 모양명함 | COMP_NAMECARD_SHAPE_S1/S2 | YES(2행) | INSERTABLE |
| PRD_000036 | 미니모양명함 | COMP_NAMECARD_MINISHAPE_S1/S2 | YES(2행) | INSERTABLE |
| PRD_000039 | 투명명함 | COMP_NAMECARD_CLEAR_S1 | YES(1행) | INSERTABLE |
| PRD_000040 | 화이트인쇄명함 | COMP_NAMECARD_WHITE_S1W_CL/NOCL/S2W_CL/NOCL | YES(4행) | INSERTABLE |
| PRD_000037 | 오리지널박명함 | COMP_NAMECARD_FOIL_S1_STD/S1_HOLO/S2_STD/S2_HOLO + FOIL_SETUP_S1_STD/S2_STD | YES(38행) | INSERTABLE(다중배선·.06+.05) |
| PRD_000038 | 형압명함 | (없음·L1 블록 없음) | NO | **BLOCKED**(§6) |

**배선 설계**: `PRF_NAMECARD_FIXED`는 모든 명함 공식을 담는 shared formula. addtn_yn: 단일 완제품가 components(S1/S2/SHAPE…)는 **택일 단가**이므로 `addtn_yn='N'`(합산 아님 — 단/양면·소재 선택 시 1개 단가 조회). 박명함만 FOIL(완제품가 .06)+FOIL_SETUP(동판셋업 .05)= **합산**(`addtn_yn='Y'` 둘 다, base+setup). disp_seq는 라이브 기존(STD=1,2) 이어서 채번.

> **펄명함 mat_cd 불일치(라이브 권위 사항·flag)**: PRD_000034 링크 mat = MAT_000240/241/128/129(스타드림 다이아/로츠/실버/골드), 그러나 COMP_NAMECARD_PEARL 단가 mat = MAT_000127(다이아몬드)/MAT_000130(로즈쿼츠). round-5가 다른 스타드림 코드로 적재. **본 설계는 단가 재적재 안 함**(배선만) → 불일치는 라이브 데이터 사안으로 §7에 기록, validator가 판정. 발명·수정 금지.

---

## 4. siz/dim 해소 (search-before-mint) — INSERTABLE vs BLOCKED

신규 component_prices를 만들지 않으므로(기존 재사용) 신규 siz mint는 **0**. 다만 BLOCKED 블록이 향후 적재되려면 필요한 siz를 기록:

| 차원 | L1 라벨 | 라이브 siz | 결과 |
|------|---------|-----------|------|
| 반칼/완칼 규격 | 124x186, 90x190 | SIZ_000059, SIZ_000060 | EXISTS(재사용) |
| 완칼 규격 | A4/A3/A2/400x600 | SIZ_000172/174/197/199 | EXISTS(재사용) |
| 완칼 규격 | **B4, B3** | **부재** | **BLOCKED-siz**(B02 낱장 B4/B3열 — 단 라이브 COMP_STK_PRINT는 A4/A3/A2만 보유, B4/B3 원래 미적재) |
| 명함 모양 | 90x50, 50x50 | SIZ_000008, SIZ_000011 | EXISTS(재사용) |
| 스티커팩 | 75x110 | SIZ_000068 | EXISTS(재사용) |
| 타투 | 90x190 | SIZ_000060 | EXISTS |
| 소량자유형 | 94x94/80x80/50x70… | SIZ_000036/043/061… EXISTS | 단 base가 비매트릭스 → BLOCKED 사유는 siz 아님 |

[HARD] **B4/B3 라이브 부재** → 신규 siz mint 금지(search-before-mint). 단 본 슬라이스 INSERTABLE 분은 B4/B3 불요(반칼변형은 124x186/90x190·완칼대형은 400x600·명함은 90x50/50x50, 전부 EXISTS).

---

## 5. ASSEMBLE — 적재물 (FK 위상정렬·멱등)

신규 단가 적재 ≈ 0, **공식 헤더 1행 mint(PRF_STK_PACK_FIXED) + 배선(formula_components) + 바인딩(product_price_formulas)** 이 적재물 본체.

### 적재 순서 (price-engine-ddl §3)
```
[단계 1] t_prc_price_formulas   ← PRF_STK_PACK_FIXED 1행 mint (frm_typ_cd=FRM_TYPE.02)
[단계 2] t_prc_formula_components ← 신규 배선 (frm_cd·comp_cd 선존재)
[단계 3] t_prd_product_price_formulas ← 17 바인딩 (prd_cd·frm_cd 선존재)
```

### 적재물 카운트

| 테이블 | 행수 | 내용 |
|--------|:--:|------|
| `t_prc_price_formulas` | 1 | PRF_STK_PACK_FIXED (스티커팩 세트가) |
| `t_prc_formula_components` | 13 | 명함 7상품 components 배선(STD 제외 신규) + 스티커팩 1 + (반칼변형은 STK_PRINT 이미 wired→배선불요) |
| `t_prd_product_price_formulas` | 17 | 스티커 10(INSERTABLE) + 명함 6(INSERTABLE) + 스티커팩 1 → 실제 §load CSV 기준 |
| `t_prc_component_prices` | 0 | **신규 단가 없음**(기존 재사용·재적재 금지) |

> 정확한 행수는 `load/*.csv` 권위(중복배선 제거·기존 wired 제외 후). 본 표는 설계 추정.

### 멱등성 (C-2·R5 IDENTITY trap 회피)
- `price_formulas`: PK `frm_cd` → `ON CONFLICT (frm_cd) DO NOTHING`.
- `formula_components`: PK `(frm_cd,comp_cd)` → `ON CONFLICT DO NOTHING`.
- `product_price_formulas`: PK `(prd_cd,frm_cd)` → `ON CONFLICT DO NOTHING`.
- `component_prices` 신규 0행이므로 IDENTITY 시퀀스 stale 무관(단가 미적재).
- `reg_dt`/`upd_dt` = **OMIT**(DEFAULT now() 발화·R5 reg_dt NOT NULL 함정 회피).

---

## 6. BLOCKED (발명·추정 금지) — 정직 분리

| prd_cd | prd_nm | 차단 사유 | 분류 | 라우팅 |
|--------|--------|-----------|------|--------|
| PRD_000038 | 형압명함 | 가격표 L1에 형압명함 블록 **부재**. 라이브 component_prices도 부재. 공정(직각/둥근)만 링크 — 가격 원천 없음 | DATA-GAP | 후니 input 대기. 발명 금지 |
| PRD_000064 | 소량자유형스티커 | B06 "기본가" = base 2000 + 3매당 4000(비매트릭스 base 구조). component_prices 부재·매트릭스 아님 | STRUCTURE | base 가격모델 결정 대기(§ decision) |
| PRD_000067 | 타투스티커 | B05 "타투 스티커(3장단위)" = 3장마다 4000원(세트/번들 단가). component_prices 부재·bdl_qty 구조 필요 | STRUCTURE | 번들단가 모델 결정 대기(bdl_qty 차원) |

[HARD] BLOCKED 3건은 INSERTABLE CSV에서 **분리**(`load/*_BLOCKED.csv`). over-block 검토: B4/B3 siz 부재는 INSERTABLE 분에 영향 없음(해당 셀 미사용) → over-block 아님.

---

## 7. live-vs-doc 모순 / 모호 flag (validator·lead 에스컬레이션)

1. **[MAJOR·구조] COMP_STK_PRINT 매트릭스 불완전**: L1 B01은 6규격(124x186·A4판·A3판·90x190·100x148·90x110)×3소재그룹×40수량 = 720셀이나, 라이브 COMP_STK_PRINT는 6 siz(124x186·90x190·A4·A3·A2·400x600)×혼합mat×최대36구간만 보유. **100x148·90x110 규격 및 그 외 B01 옵션이 미적재.** round-5가 B01·B02·B03·B04를 한 comp로 collapse하며 일부 옵션 누락. → 본 슬라이스는 **기존 분만 재사용 바인딩**(누락분 신규적재는 별도 트랙). 반칼변형 바인딩은 기존 정답(PRD_000052)과 동일하므로 무해.
2. **[MINOR·데이터] 펄명함 mat_cd 불일치**: 상품 링크 mat(MAT_000240/241/128/129) ≠ 단가 mat(MAT_000127/130). round-5 적재 시 다른 스타드림 코드 사용. 본 설계 단가 재적재 안 함 → 라이브 데이터 사안. validator 판정.
3. **[MINOR·소재] COMP_STK_PRINT mat = 유포/무광코팅/투명데드롱(MAT_000170)** 이나 상품은 MAT_000162 투명/MAT_000163 홀로그램 링크 — 투명데드롱(MAT_000170) ≠ 투명스티커(MAT_000162). 가격행 소재축과 상품 소재링크 어휘 상이. 라이브 정답 패턴이므로 바인딩엔 무해하나, 의미정합은 §1 flag.
4. **[모호] 반칼팬시투명/홀로그램 단가 출처**: L1 B01 "투명/홀로그램" 밴드가 한 가격열(7000 등). 라이브 COMP_STK_PRINT는 투명데드롱(MAT_000170) 1열만 보유. 팬시투명·홀로그램이 정확히 동일 단가인지 validator 역대조 필요. 본 설계는 **동일 투명/홀로그램 그룹가** 가정(L1 밴드 일치) — 바인딩 대상.

---

## 8. 설계결정 필요 (lead→사용자)

- **D-1 소량자유형스티커(PRD_000064) base 가격모델**: B06 기본가(2000 base + 3매당 4000)는 매트릭스가 아닌 base+증분 구조. component_prices로 담으려면 base/증분 2 component 또는 product_prices 단일가? → 결정 대기(BLOCKED).
- **D-2 타투스티커(PRD_000067) 번들단가**: "3장마다 4000원"=세트단가. bdl_qty=3 차원 + COMP 신규 mint 필요. bdl 모델 확정 대기(BLOCKED).
- **D-3 형압명함(PRD_000038)**: 가격원천 자체 부재 → 후니 input 필수(BLOCKED).
- **D-4 COMP_STK_PRINT 미적재 옵션(100x148·90x110 규격)**: 별도 보완 트랙 여부. 본 슬라이스 스코프 밖.
