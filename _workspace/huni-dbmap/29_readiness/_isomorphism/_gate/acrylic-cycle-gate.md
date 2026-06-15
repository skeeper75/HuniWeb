# 아크릴 면적매트릭스형 3차 사이클 — 독립 검증 게이트 (V1~V6)

> 작성 2026-06-15 · `dbm-validator`(검증 전담·생성자≠검증자) · 라이브 읽기전용 SELECT 실측 + 가격표 엑셀 직접 추출.
> 검증 대상(권위 아님) = `acrylic-class.md`(Sc) · `acrylic-rep-5layer.md`(S0~S5) · `acrylic-cycle-report.md` — 생성자 `dbm-readiness-auditor` NO-GO 판정.
> 1차 권위 = 라이브 `t_*`(2026-06-15 본 세션 SELECT) + `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` `아크릴` 시트(openpyxl 직접) + 토대 §4·§5.
> 적대적 스탠스: 거짓 GO(실은 그릇 빔) + 거짓 NO-GO(실은 다른 명명으로 적재됐는데 못 찾음) 양방향 점검. 보정 하드코딩 0.

---

## 0. 결론 (한 줄)

생성자 NO-GO(ACRYL-CPQ-ZERO + ACRYL-CHAIN-NONE 이중 전무) = **정직한 NO-GO**. 6개 주장 전건 독립 재현. 거짓 GO·거짓 NO-GO·날조·카운트 오류 0. 면적매트릭스형 단가행 골든 정합(불일치 0)이 실증되어 **데이터는 멀쩡하고 그릇(CPQ·공식사슬)만 비었음**이 확인됨. 게이트 = **GO(생성자 판정 승인)**.

---

## 1. 6개 주장 독립 재현 (V1~V6)

### V1 — 동형 클래스 = 면적매트릭스형 · 대표 PRD_000146 superset → **REPRODUCED**

라이브 `t_prd_product_*` 실측(146):
```
sizes=8 · materials=3 · processes=1 · print_options=3 · plate_sizes=8
PRD_000146 아크릴키링 PRD_TYPE.04 use_yn=Y
```
- 사이즈 8·자재 3(투명3T 본체 + 은색/금색 고리 부속)·UV 1공정·CLEAR3T 매트릭스 47행 — 생성자 superset 카운트 전건 일치.
- materials 3 = 본체 MAT_TYPE.03 + 부속 고리 2색(과분할 아님·BUNDLE 정합).
- ✅ 증거: `t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T'` 47행(2,500~22,700) = 생성자 표 일치.
- **정정 1(경미)**: 생성자가 범위를 "146~169·23상품"으로 기술했으나 **PRD_000167은 라이브 부재**(146~169 중 실재 22상품). 결론·게이트에 영향 없음(167은 어차피 미존재). 카운트 표기 보정 권고.

### V2 — ACRYL-CPQ-ZERO (아크릴만 CPQ 전무) → **REPRODUCED**

라이브 실측:
```
아크릴(146~169 범위)  : option_groups=0 · options=0 · option_items=0
DB 전역              : groups=128 · options=477 · items=455
prd_nm '%아크릴%'+'%맥세이프%' join : groups=0 · items=0
```
- 아크릴 0/0/0 정확. DB 전역엔 존재(128/477/455) → **아크릴만 전무**(전역 부재 아님) 확정.
- prd_nm join으로도 0 = **거짓 NO-GO 아님**(다른 prd_cd로 숨어 적재된 것 없음).
- **정정 2(경미)**: 생성자 5layer §2 options 카운트를 "(실재)"로만 표기. 라이브 전역 **options=477**(items 455와 별개). 카운트 명시 권고(거짓 아님·미기재).

### V3 — ACRYL-CHAIN-NONE (공식·배선·바인딩 전무) → **REPRODUCED**

라이브 실측:
```
t_prc_price_formulas frm_cd LIKE '%ACRYL%'          = 0행 (NAMECARD/POSTER는 존재)
t_prd_product_price_formulas (146~169)              = 0행
t_prc_formula_components comp_cd LIKE '%ACRYL%'     = 0행
```
적대적 전수(다른 명명으로 적재됐나):
- ACRYL comp 3종(CLEAR3T/15T/MIRROR3T)이 **어느 frm_cd에도 미배선** = `t_prc_formula_components`에서 0행.
- 아크릴키링군(146~169)은 **어느 공식에도 미바인딩** = 0행.
- ★ 적발: `PRD_000142 유광아크릴스티커`·`PRD_000143 미러아크릴스티커`가 PRF_POSTER_FIXED 바인딩 + `COMP_POSTER_ACRYLSTK_*` 단가행 보유 — 그러나 이는 **포스터사인/스티커 계열**(면적매트릭스형 아크릴키링군과 별개 동형 항)이라 146~169 CHAIN-NONE 반증 아님. 생성자가 키링군에 한정해 판정한 것 정합.

### V4 — 단가행 L1 골든 정합(값 결함 0) → **REPRODUCED (강한 입증)**

가격표 엑셀 `아크릴` 시트 매트릭스(A1=투명3T·A21=1.5T·A35=미러3T) 직접 추출 후 라이브 단가행 전건 프로그램 대조:
```
CLEAR3T (47행)  : 엑셀 셀 일치 47/47 · 불일치 0 · 격자부재 0
CLEAR15T (37행) : 엑셀 셀 일치 37/37 · 불일치 0
MIRROR3T (37행) : 엑셀 셀 일치 37/37 · 불일치 0  (100mm 가로행 r45 포함)
```
- 샘플 검증: 20x20=2,500 · 30x30=3,100 · 30x40=3,400 · 40x40=3,800 · 50x50=4,800 · 60x60=5,900 · CLEAR15T 30x30=2,480 · MIRROR3T 30x30=6,200 — 생성자 §2-2 골든표 전건 일치.
- **값 결함 정말 0** = 데이터는 완전·정합. 빈 것은 **그릇(공식사슬·CPQ)**뿐 — 생성자 정직 판정("데이터 멀쩡·그릇 빔") 입증.

### V5 — off-grid ceiling + 좌표 방향성 → **REPRODUCED (방향성 정밀 보강)**

- **off-grid**: `25x25`·`25x30`·`35x35`·`45x45` 좌표 단가행 DB **부재**(SELECT 빈 결과)·`30x30=3,100` 존재. → 격자외 좌표 미저장 = ceiling은 런타임(과적재 금지·중간계산=앱 철학 정합). 생성자 "25x25→30x30=3,100 ceiling" 주장 메커니즘 정합.
- **좌표 방향성(asymmetry)**: 3 매트릭스 비대칭 좌표 전수 census 결과 — 비대칭 진성 1좌표(`50x30`)만 존재, 나머지는 매트릭스가 거의 대칭이라 양쪽일치(모호). 라이브 `50x30` 라벨이 저장한 값(C3T=3,800·C15T=3,040·MIR=7,600)은 엑셀의 **가로30×세로50** 셀값 → 라이브 라벨 = 세로우선(swap). 생성자 ACRYL-COORD-DIR 함정 실재 확인. **영향 = 매트릭스당 1좌표·손실 아님**(생성자 "asym 소수" 정확).

### V6 — NO-GO 정직성(이중 전무·명함보다 깊은 단절) → **REPRODUCED**

- 명함(2차)은 공식 존재(PRF_NAMECARD_FIXED 라이브 실재 확인)·배선만 막힘. 아크릴은 **PRF_ACRYL* 자체 0 + CPQ 그릇 0** = 두 출력(①UI·③가격)이 통째로 그릇부터 빔.
- 거짓 GO 차단: 단가행 골든 일치(V4)를 "견적가능"으로 쓰지 않고 "공식사슬 전무로 엔진 도달 불가"로 정직 판정 — 검증자 동의(C1-data 2,500 룩업값 맞아도 PRF 바인딩 0이라 엔진 도달 불가).
- 거짓 NO-GO 차단: V2·V3 적대 전수(prd_nm join·comp 전수 배선·frm 무관 바인딩)로 "어딘가 적재됐는데 못 찾은 것" 가능성 배제 → NO-GO는 실재 전무.

---

## 2. 게이트 판정 매트릭스

| 검증 | 주장 | 판정 | 핵심 증거 |
|------|------|:--:|------|
| V1 | 면적매트릭스형·대표 146 superset | REPRODUCED | siz8/mat3/proc1/comp47·라이브 일치 |
| V2 | ACRYL-CPQ-ZERO | REPRODUCED | 0/0/0 vs 전역 128/477/455·prd_nm join 0 |
| V3 | ACRYL-CHAIN-NONE | REPRODUCED | PRF_ACRYL* 0·바인딩 0·배선 0·전수 적대 확인 |
| V4 | 단가행 골든 정합(값 결함 0) | REPRODUCED | 121행(47+37+37) 엑셀 셀 불일치 0 |
| V5 | off-grid ceiling + 좌표방향성 | REPRODUCED | 25x25 부재·50x30 swap 1좌표 |
| V6 | NO-GO 정직(이중 전무) | REPRODUCED | 명함>아크릴 단절 깊이·양방향 거짓 배제 |

### 전체 게이트 = **GO** (생성자 NO-GO 판정 정직·전건 재현·실결함 0)

- 6/6 REPRODUCED. REFUTED 0 · PARTIAL 0.
- 날조 0 · 거짓 GO 0 · 거짓 NO-GO 0.
- 카운트 오류: **MAJOR 0**. 경미 2건(V1 167 미존재로 22상품·V2 전역 options=477 미기재) — 결론·라우팅·게이트에 영향 없음(표기 보정 권고).

---

## 3. 인간 승인 큐(H1~H6) 정직성 점검

생성자 큐 6건 전부 정직(자율 불가 항목·자율 월권 0):
- **H1**(CPQ 신설)·**H2**(공식사슬 신설) = 실 COMMIT 필요 = 자율 불가 정합(V2·V3 전무 입증으로 신설 필요 실재).
- **H3**(좌표 라벨 방향)·**H4**(미적재 좌표 격자정책)·**H5**(후가공 추가단가 귀속) = 도메인 컨펌 = 권위 부재 정합(V5 방향성 모호 실재).
- **H6**(use_yn=N 8상품 출시 여부) = 라이브 use_yn='N' 6상품(153/156/159/164/165/166) 실측 확인 = 범위 외 정합.

→ 인간 승인 큐 6건 = 정직.

---

## 4. 면적매트릭스형 일반성 실제 입증 여부 (한 줄)

**입증됨** — Q-게이트가 면적매트릭스형 고유 구조(`[가로][세로]` 면적 룩업·off-grid ceiling 런타임·좌표 방향성 2축 함정·공식사슬 전무를 단가행 누락과 구분)에 맞춰 라이브에서 올바로 작동함을 독립 재현(단가행 121행 엑셀 셀 불일치 0 + 사슬 전무 PRF_ACRYL* 0 + 거짓 GO/NO-GO 양방향 배제)으로 확인 → 토대 §5 3유형(합산형 엽서·고정가형 명함·면적매트릭스형 아크릴) 파이프라인 일반성 실증.

---

## 5. 산출 경로

- 본 게이트: `_workspace/huni-dbmap/29_readiness/_isomorphism/_gate/acrylic-cycle-gate.md`
- 검증 대상(생성자): `_workspace/huni-dbmap/29_readiness/_isomorphism/{acrylic-class,acrylic-rep-5layer,acrylic-cycle-report}.md`
- 권위: 라이브 `t_*`(읽기전용) + `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` `아크릴` 시트
