# 출력소재(IMPORT) import 게이트 — paper-import-gate (round-16)

> **검증** 2026-06-13 · 독립 검증자(`dbm-validator`, 생성자≠검증자) · 게이트 P1~P6.
> **권위 실측:** 원본 시트 `출력소재(IMPORT)`(openpyxl `data_only` 직접 재카운트, 120 소재행) + 라이브 `t_prc_*`·`t_mat_materials`·`t_siz_sizes` (`.env.local` `RAILWAY_DB_*` 읽기전용 `db railway`). **DB 미적재.**
> **빌더 산출:** `20_price-import/paper-import/{structure,decomposition,mapping-flow}.md` + `paper-import-import.xlsx`.

---

## 0. 종합 평결: **CONDITIONAL-GO (보정 필요)**

빌더의 **핵심 설계 판정은 모두 라이브 실측으로 입증**됐다 — 목적지(COMP_PAPER source-of-truth)·단가형(.01)·use_dims(siz_cd,mat_cd)·8차원 NULL·동시매칭0·6공식 배선 완결·디지털인쇄비 중복0. 가격 그릇으로서 **구조적으로 GO**.

그러나 독립 실측에서 **빌더 문서의 수치·분류 결함 3건**을 적발했다(설계는 옳으나 카운트/분류가 라이브와 어긋남):
1. **[MAJOR] COMP_PAPER 행수 — 문서 "51행" 6회 반복 주장은 거짓. 라이브 실측 = 49행.** (빌더 자신의 mapping-flow §4 표는 "49 RU"로 적어 문서 내 자기모순.)
2. **[MAJOR] BLOCKED 11행 중 3행(아이보리·뉴크라프트·팬시크라프트)은 라이브에 자재 등록됨 → GAP으로 재분류돼야.** "자재 미등록" 분류 오류 = 라이브 자재 미조회.
3. **[MINOR] 디지털 블록 행수 — 문서 "83행" vs 실측 85행** (56~60 그문드/마테리카 5종 + 88 타투전용지 = 가격없는 디지털 소재가 카운트에서 누락/혼동).

설계 그릇은 적재 가능하나, **숫자·분류 보정 후 GO**. 보정 대상은 빌더(`dbm-price-import-builder`)에게 라우팅.

---

## P1. 그릇 = 라이브 1:1 — **PASS**

라이브 `t_prc_price_components` 실측:
```
COMP_PAPER | comp_nm=용지비(종이별 절가) | prc_typ_cd=PRICE_TYPE.01 | use_dims=["siz_cd","mat_cd"] | use_yn=Y
```
빌더 그릇 엑셀 시트 4종(price_components·formula_components·component_prices·materials)이 라이브 컬럼과 정합. 10차원 자연키 반영(8차원 NULL 와일드카드). **누락·잉여 0.**

## P2. stale 차단 — **PASS**

round-2 잔재(8차원·단가형 암묵) 없음. `prc_typ_cd`·`use_dims`·10차원(`proc_cd`·`opt_cd` 포함) 전부 반영. 라이브 use_dims 실측 일치.

## P3. 무손실 — **CONDITIONAL (카운트 보정)**

openpyxl 직접 재카운트:
| 항목 | 빌더 주장 | 독립 실측 | 판정 |
|------|----------|----------|------|
| 시트 총 소재행(C열) | 120 | **120** | ✅ |
| 디지털 블록(4~88) | 83 | **85** | ❌ MINOR |
| 국4절 숫자값 보유 | 47+14+11=72 | **72** (합계 일치) | ✅ |
| 3절(J) 숫자값 | 5 (51~55) | **5 (51~55)** | ✅ |
| Roll(86,87) | 2 | **2** | ✅ |
| 가격없는 디지털 소재 | "9 미상" | **6** (56~60 그문드/마테리카·88 타투) + 2 Roll | ❌ 분류모호 |

부유/note 보존 원칙 준수(L~Y ● 매트릭스·합판/실사/아크릴 37행 = 별 트랙 보존). **무손실 자체는 성립하나 디지털 블록 행수(83→85)와 "9 미상" 내역이 실측과 불일치 → 카운트 보정 필요.**

> **컬럼 매핑 주의(검증자 발견):** 시트 실제 헤더 = F 구매정보·G 전지·**H 연당가·I 가격(국4절)·J 가격(3절)**·K 종이사이즈. 빌더 structure 문서는 "F 연당가·H 국4절·G 전지"로 표기(한 칸 어긋남) — **단, decomposition/대조 로직에서는 올바른 값(H=연당가 DB미저장·국4절가=unit_price)을 사용**해 결과는 정합. 문서 헤더 라벨만 정정 권장.

## P4. 단가/합가 — **PASS**

라이브 실측 `COMP_PAPER.prc_typ_cd = PRICE_TYPE.01`(단가형). use_dims=`["siz_cd","mat_cd"]`. component_prices 8차원(clr/proc/opt/coat/bdl/**min_qty**) **전건 NULL**(49/49) 실측 → 수량구간 없음·절가 고정 거동 입증. 합가형(.02) 없음. **근거=가격표 헤더 "가격(국4절)" 장당환산가 + 라이브 min_qty NULL. 추정 0.**

## P5. 동시매칭 0 + 목적지 판정 — **PASS**

**동시매칭:** `GROUP BY siz_cd,mat_cd HAVING count>1` → **빈 결과**. siz_cd 전건 SIZ_000499(49행). 같은 (siz,mat) 1행 → 동시매칭 0 ✅.

**목적지 판정(빌더 핵심 주장 직접 대조):**
| 빌더 주장 | 독립 실측 | 판정 |
|-----------|----------|------|
| 이 시트 = COMP_PAPER source-of-truth | 라이브 49행 전부 시트 디지털 행과 매칭 | ✅ |
| 국4절가(=I열) = unit_price 전건 일치(mismatch 0) | **49행 자동대조 일치** (MAT_000072=30.73·73=36.88·74=70.64 등) | ✅ (검증자 초기 mismatch 1건은 정규화 아티팩트 — row73 특수지 백색모조지를 row6 백색모조지220g와 충돌시킨 것, 철회) |
| 연당가(H열) = DB 미저장 | COMP_PAPER unit_price = 국4절가, 연당가 컬럼 무대응 | ✅ |
| **COMP_PAPER 51행** | **라이브 49행** | ❌ **MAJOR** |

## P6. 가격사슬 — **PASS**

라이브 `formula_components` COMP_PAPER 배선:
```
PRF_DGP_A(seq15) · PRF_DGP_B(3) · PRF_DGP_C(3) · PRF_DGP_D(5) · PRF_DGP_E(5) · PRF_DGP_F(1) — 전부 addtn_yn=Y
```
**6공식 전부 배선 완결** ✅ (아크릴 시트의 가격사슬 단절과 대조적). GAP 14행 채우면 배선 추가 불요·즉시 조회 가능 — **입증**.

**디지털인쇄비 시트(COMP_PRINT_DIGITAL) 중복0:** use_dims=`["siz_cd","clr_cd","min_qty"]` (mat_cd 차원 미사용) → COMP_PAPER(siz,mat)와 매칭 차원 직교. 시트 '디지털인쇄비' = 도수×면×수량 단가(용지 무관). **중복0 정당** ✅ 상호보완.

---

## 1. GAP/BLOCKED 라이브 재검증 (빌더 분류 직접 대조)

**PRICE-GAP 14행 — PASS:** 14 mat_cd 전부 라이브 등록 + 전부 COMP_PAPER 단가 없음 → GAP 정당 ✅ (채움후보·배선불요).

**BLOCKED 11행 — 부분 오류 (3행 재분류):**
| 행 | 종이명 | 빌더 분류 | 라이브 실측 | 정정 |
|----|--------|----------|------------|------|
| 72 | 아이보리 | BLOCKED | **MAT_000149 등록** | → **GAP** |
| 74 | 뉴크라프트 | BLOCKED | **MAT_000150 등록** | → **GAP** |
| 75 | 팬시크라프트 | BLOCKED | **MAT_000151 등록** | → **GAP** |
| 73 | 백색모조지(평량220·가격136) | BLOCKED | MAT_000074(220g·70.64) 가격충돌 | BLOCKED 유지(Q-PAP-2 정체 컨펌) |
| 76~85 | 스티커류 7종 | BLOCKED | MAT_TYPE.01 미등록(스티커용지 별 타입) | BLOCKED 유지(타입/트랙 분리) |

→ **BLOCKED 11 → 실질 GAP 3 + BLOCKED 8.**

**3절 GAP 5행 — PASS:** SIZ_000077(300x625) 라이브 존재 + COMP_PAPER에 SIZ_000077 단가 0행 → 3절 GAP 정당 ✅ (mat_cd 컨펌 Q-PAP-3).

**보조 실측:** MAT_TYPE.01 용지 = **107행**(빌더 주장 일치 ✅).

---

## 2. 뒤집힌 / 보정 항목 표

| ID | 빌더 주장 | 검증 결과 | 심각도 | 라우팅 |
|----|----------|----------|--------|--------|
| F-PAP-1 | COMP_PAPER **51행** | 라이브 **49행** (문서 내 49 RU와 자기모순) | **MAJOR** | builder (수치 정정) |
| F-PAP-2 | BLOCKED 11행 전부 자재 미등록 | 아이보리/뉴크라프트/팬시크라프트 **등록됨 → GAP** (11→GAP3+BLOCKED8) | **MAJOR** | builder (분류 정정·라이브 자재 재조회) |
| F-PAP-3 | 디지털 블록 83행·"9 미상" | 실측 **85행**·가격없는 디지털 6행(그문드/마테리카/타투) | MINOR | builder (카운트 정정) |
| F-PAP-4 | structure 헤더 "F연당가·H국4절·G전지" | 실제 H연당가·I국4절·F구매정보 (한 칸 어긋남, 결과는 정합) | MINOR | builder (헤더 라벨 정정) |
| — (철회) | 검증자 초기 "mismatch 1건(백색모조지220)" | 정규화 아티팩트 — H(국4절)=unit_price 전건 일치 재확인 | 철회 | — |

**검증자 자기철회:** 자동대조 1차에서 백색모조지220 mismatch가 떴으나, row73(특수지 백색모조지·가격136)을 row6(백색모조지220g·70.64)와 정규화 충돌시킨 매칭 아티팩트로 확인. 실제 국4절가↔unit_price는 **전건 일치**. 빌더의 "mismatch 0" 주장이 옳음 — 철회한다.

---

## 3. 인간 결정 큐 (Q-PAP — 빌더 컨펌 승계)

- **Q-PAP-1** 14 PRICE-GAP(+ 재분류 GAP 3 = 17) 채움 = 정책 누락인지 의도적 미적재인지.
- **Q-PAP-2** BLOCKED 백색모조지(73행·평량220·가격136)는 MAT_000074(220g·70.64)와 별개 자재인지(가격 2배 차이 — 다른 소재 가능성).
- **Q-PAP-3** 3절 5종 = 국4절 동일 mat_cd의 siz만 다른 단가인지, 3절 전용 자재인지.
- **Q-PAP-4** Roll 단가 2건(유포지+엠보·투명접착PVC) 단위 환산(단가형/합가형 판별 불가).

---

## 4. 한 줄 평결

**CONDITIONAL-GO** — 그릇 설계(목적지·단가형·use_dims·동시매칭0·6공식 배선·디지털인쇄비 중복0)는 라이브 실측 전건 입증, 가격 그릇으로 **적재 가능**. 단 빌더 문서의 **51행(→49)·BLOCKED 11(→GAP3+BLOCKED8)·83행(→85)** 수치/분류 결함 보정 후 GO. 실 적재·GAP 채움·DDL은 인간 승인. **insertable: GAP 14+재분류3=17 / BLOCKED: 8 / GAP(3절): 5 / Roll-special: 2 / RU(재현): 49.**
