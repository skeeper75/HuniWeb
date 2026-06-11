# 횡단 결함 종합 (crosscut) — round-13 메타 독립 검증 게이트 (X1~X6)

> **검증** 2026-06-11 · `dbm-validator` 독립(생성자 `dbm-correctness-auditor` ≠ 검증자). 검증 대상 = `_crosscut/` 3종(crosscut-synthesis.md·batch-confirmations.md·remediation-roadmap.md).
> **방식:** 집계 핵심 카운트를 라이브 read-only psql SELECT로 **독립 재현**(auditor 수치 맹신 0) + 11 family correction-manifest/gate finding 커버리지 대조 + 2-pass dodge-hunt. **본 게이트 DB 쓰기 0**(SELECT만·COMMIT/DDL/DELETE 0).

---

## 0. 최종 판정: **GO** (X1 최종 재게이트 PASS — 전수 1:1 추적 완성)

> **재게이트 이력:** 1차 CONDITIONAL-GO(X1 6건 명시 누락) → auditor 1차 보정 후 2차 CONDITIONAL-GO(X1 재라우팅·전수 무인용 다수) → **auditor F-XC-1b 보정(§0-bis 전수 171행 1:1 추적표 재작성) 후 3차 최종 재게이트 = X1 PASS → 종합 GO.** X2~X6은 1차 PASS carry-forward(불변).

**F-XC-2 (PRD_000126 명칭)**: ✅ RESOLVED(2차) — "레더아트프린트126[실사/CAT_000298]" 정밀화·MAT_000186 4 family 귀속 불변.

**F-XC-1/F-XC-1b (무인용 누락 0)**: ✅ **RESOLVED.** §0-bis가 개념 분류 → **전 finding 1:1 전수 추적표(171행·1행=1 finding·family·finding-id·분류·귀속)**로 재작성됨. 검증자 독립 재점검:
- **행수 = 정확히 171**(헤더 제외 기계 카운트)·family별 소계 전건 일치(digital-print 18·goods-pouch 17·product-accessory 14·silsa 14·acrylic 22·stationery 18·sticker 17·booklet 13·photobook 17·calendar 21).
- **§0-bis finding-id 집합 = 10 family manifest finding-id 집합**(diff 전건 MATCH). calendar 21(C-CAL 11+C-DC 3+OK 7)·acrylic 22(AC-C8/M3/X6/R1/A4) 정확. photobook DIFF 1(PB-M3)은 **F-PB-1 보정으로 PB-A2 재분류(superseded)** — manifest §0도 PB-A2만 active(합계 17), 정당.
- **finding-id 중복 0**(family+id 조합 uniq -d 빈 결과).
- **2차 지목 14 미귀속 finding 전건 1행씩 명시 귀속**(GP-C-06·C-ST-10/11/12·ST-05/10/11/12/14·AC-M1/M3/X2/X3/X5/X6/A2 → 전부 단발/횡단②연계/AMB-미해소 귀속·빈 셀 0).
- **"67" 정정 정당:** 전수 추출 결과 전 finding 171·결함성 113(CORRECT 계열 58 제외). 사용자 "67"은 메타 착수 추정치였고 전수가 정확 — 검산 해설 명시.

**무인용 누락 0 기계 보증 확인.** 메타 결론·집계 수치·로드맵 FK 순서·14 BATCH 축약 정합.

---

## 1. 게이트 결과 매트릭스

| 게이트 | 판정 | 근거 한 줄 |
|--------|:--:|------|
| **X1 커버리지(최종 재게이트)** | ✅ **PASS** | §0-bis 전수 171행 1:1 추적·family 소계 전건 manifest 일치·finding-id 중복 0·2차 미귀속 14건 전건 귀속·무인용 누락 0 |
| **X2 집계 수치 독립 재현** | ✅ **PASS**(1차 carry) | 14노드·113상품·MAT_TYPE 36/58/8·MAT_000186 6상품 전건 라이브 일치(byte 수준) |
| **X3 결정점 무손실** | ✅ **PASS**(1차 carry) | family 컨펌 합계 ~67(DP4+GP5+PA8+SL7+AC8+ST12+STK5+BK5+PB6+CAL7) → 14 BATCH 축약·매핑 안 된 컨펌 0·중복 과대계상 0 |
| **X4 라우팅 정합** | ✅ **PASS**(1차 carry) | round-5/6/10/2/ddl 배정 + FK 위상순서[0~6] 정확·BATCH-4 레더 mat_typ UPDATE=round-10 FK[1] 정합 |
| **X5 비파괴·search-before-mint** | ✅ **PASS**(1차 carry) | COMMIT/DDL/DELETE 0·재연결 대상(273/274/275/283·119~123·.06 고아행 4) 전건 실재·신설 0 |
| **X6 신규 날조 0** | ✅ **PASS**(1차 carry) | 라이브 SELECT는 검산용·새 finding-id 0·기존 GO finding만 종합 |

---

## 2. X2 집계 수치 독립 재현 (라이브 read-only SELECT)

검증자가 auditor 수치를 보지 않고 라이브에서 직접 재현한 값 ↔ 종합 §7 표:

| 항목 | 종합 주장 | 라이브 독립 재현 | 일치 |
|------|------|------|:--:|
| 잉여 고아 노드(`upr_cat_cd IS NULL AND cat_lvl>=2`) | 14개 | **14개**(CAT_000293~306) | ✅ |
| 고아 노드 연결 상품(distinct) | 113 | **113**(links=113) | ✅ |
| 노드별 상품 수(293=15·294=10·295=2·296=4·298=28·299=14·300=5·301=5·302=9·303=2·304=9·305=9·306=1) | 종합 §7-1 표 | **전건 일치**(297=0=상품아님) | ✅ |
| MAT_TYPE.08 자재행/상품/link | 22/36/42 | **22/36/42** | ✅ |
| MAT_TYPE.09 자재행/상품/link | 75/58/120 | **75/58/120** | ✅ |
| MAT_TYPE.10 자재행/상품/link | 43/8/29 | **43/8/29** | ✅ |
| MAT_TYPE.07 자재행 | 33 | **33** | ✅ |
| MAT_000186 레더(화이트) mat_typ | .08 | **.08**(=MAT_TYPE.08) | ✅ |
| MAT_000186 연결 6상품 | 77·88·100·126·174·175 | **정확히 6상품·동일 prd_cd** | ✅ |
| .06 가죽 고아행 4개 linked | 0(MAT_000008/173/174/175) | **전부 linked=0** | ✅ |
| MAT_000260 코팅 상품(+250) | 7(+1=8) | **MAT_000260=7·MAT_000250=1** | ✅ |
| 코팅 공정 PROC_000014/15 상품 | 21·29 | **21·29** | ✅ |
| 코팅스티커 MAT_000155/156 상품 | 8·8 | **8·8**(mat_typ=MAT_TYPE.11) | ✅ |

> **X2 = PASS.** prompt 명시 기대값(14노드·113상품·MAT_TYPE 36/58/8·MAT_000186 6상품)을 라이브가 정확히 반환. **부풀림·누락 0.**

---

## 3. X1 커버리지 — 누락 6건 (CONDITIONAL 근거)

"67 finding" = 11 family correction-manifest의 결함성 finding(CORRECT·CORRECT-경로불명 제외). family별 결함성 수: DP12·SL8·GP13·PA12·AC14·ST16·STK12·BK8·PB8·CAL13. 종합 §0이 "다수를 패턴축이 흡수·family 단발 ~20"이라 명시했으나, 아래 6건은 **패턴축(①②③/추가A~I)에도 family 단발 표(299~308줄)에도 batch 매핑에도 명시 없음**:

| # | finding | family | 분류·심각도 | 비고 |
|:--:|------|------|------|------|
| 1 | **GP-C-07** 파우치 공정(봉제/에폭시/맥세이프) | goods-pouch | MISSING | 추가-A 코팅공정·삼각대 공정과 별개·family 단발 미기재 |
| 2 | **GP-C-16** 머그=라이프 ROOT 직결(말단 미사용) | goods-pouch | AMBIGUOUS | ①-2 root 직결 패턴(sticker/booklet)에 굿즈 머그 미흡수 |
| 3 | **C-13** 라벨택 046 커팅 형상 → PROC_000053 | digital-print | MISSING Med | C-07 동형(커팅)이나 종합 미인용 |
| 4 | **C-17** 엽서 addon separator(`-` vs `_`) | digital-print | AMBIGUOUS Low | 코드전략 이슈·종합 패턴축 부재 |
| 5 | **C-18** 배경지 043 자재(종이 일부만 적재) | digital-print | AMBIGUOUS Low | 종합 미인용 |
| 6 | **silsa C-12** 보드/우드/레더액자 소재 빈값 | silsa | AMBIGUOUS Low(Q-SL-6) | 종합 family 단발/추가 미인용 |

> **영향:** 6건 모두 교정 방향을 바꾸지 않음(C-13은 완칼/커팅 패턴, GP-C-07은 공정 mint, GP-C-16은 ①, separator/자재/소재는 컨펌). 그러나 종합이 "결함 finding을 빠짐없이 분류"한다는 X1 기준상 **명시 누락 0** 미달 → CONDITIONAL. **수정 권고:** 종합 family 단발 표에 GP-C-07(파우치 공정)·GP-C-16(머그 ROOT)·C-13(라벨택 커팅) 추가 + AMBIGUOUS 컨펌 3건(C-17/C-18/SL-C-12)은 batch-confirmations 부록에 흡수.

---

## 4. X3 결정점 무손실 / X4 라우팅 정합

- **X3 PASS:** family별 잔존 컨펌 합계 ≈ 67(DP4·GP5·PA8·SL7·AC8·ST12·STK5·BK5·PB6·CAL7) → batch 14 BATCH로 축약. 부록(240~253줄) 매핑이 14 BATCH 전부 커버·매핑 안 된 BATCH 0. batch 문서 자체 표기 "개별 ~70(중복 포함 ~84) → 14 결정점"(255줄)과 정합. **중복 과대계상 점검:** Q-ST-A가 sticker(코팅)·stationery(미싱) 양쪽에 쓰이나 BATCH-3(코팅)·BATCH-13(미싱)으로 분리 매핑 — 동명이의 정상 분리(과대계상 아님).
- **X4 PASS:** 로드맵 FK 위상순서[0 mint→1 마스터 UPDATE→2 카테고리 재연결→3 연결 INSERT→4 CPQ→5 가격→6 논리삭제] 정확. BATCH-4 레더 mat_typ UPDATE=round-10 델타 FK[1](마스터 레벨)·논리삭제 마지막[6] 정합(round-10 교훈 "기계적 size 삭제 금지" 준수). 카테고리 재연결[2]이 마스터 UPDATE[1] 후·논리삭제[6] 전 — FK 위반 0.

---

## 5. 2-pass dodge-hunt (round-13 교훈 적용)

1차 PASS여도 표본 독립 재실측:

| dodge 유형 | 점검 | 결과 |
|------|------|------|
| **카운트 과대/과소** | 113상품·36/58/8·MAT_000186 6상품·코팅 8/16/50 | **적발 0** — 전건 라이브 정확(부풀림·누락 없음) |
| **분류 정반대** | 종합 "고아"라 한 노드(296 등)가 실제 고아인가·"정상"이라 한 노드(273/274 등)가 실제 정상인가 | **적발 0** — 296=upr NULL·113상품 연결(진짜 고아)·273/274/275/283·119~123=upr 정상·prods=0(진짜 정상 빈 노드) |
| **재연결 오매핑** | MAT_000186 6상품이 진짜 레더/4 family인가·.06 고아행 끌어오기 오류 | **적발 0** — 77/88=책자·100=포토북·126=실사(CAT_000298)·174/175=다이어리 → booklet/photobook/silsa/stationery 4 family 정확·.06 고아행 4개 linked=0 실재 |

> **dodge-hunt 실결함 0.** photobook MAT_000186 6상품(prompt 명시·이번 세션 재확인)도 정확. 종합 118줄 "4 family 횡단"·184줄 ".06 고아행 4개 linked=0" 라이브 입증.

---

## 6. 발견 사항 (라우팅)

| # | 발견 | 심각도 | 라우팅 | 조치 |
|:--:|------|:--:|------|------|
| F-XC-1 | X1 결함성 finding 6건 패턴축/단발 명시 누락(GP-C-07·GP-C-16·C-13·C-17·C-18·silsa C-12) | Med(CONDITIONAL) | `dbm-correctness-auditor` | 종합 family 단발 표에 GP-C-07·GP-C-16·C-13 추가·AMBIG 3건은 batch 부록 흡수 |
| F-XC-2 | 종합 118줄 silsa 항목을 "포스터(126)"로 표기 — 실제 PRD_000126=레더아트프린트(CAT_000298 실사). 4 family 귀속은 정합이나 명칭 부정확 | Low(정보) | `dbm-correctness-auditor` | 명칭 "레더아트프린트"로 정밀화(귀속 변경 불요) |

> **둘 다 교정 트랙 방향·집계 수치 무변경.** F-XC-1만 X1 "누락 0" 기준 차단·F-XC-2는 정보.

---

## 7. 결론

횡단 결함 종합(crosscut-synthesis·batch-confirmations·remediation-roadmap)은 **집계 수치 정확성(X2)·결정점 축약(X3)·라우팅 정합(X4)·비파괴(X5)·신규 날조 0(X6)** 전건 PASS이고, **dodge-hunt 3종 실결함 0**으로 메타 분석의 핵심(횡단 일괄 교정 > family 개별)이 라이브로 견고하게 입증된다. **X1 커버리지**도 3차 보정(§0-bis 전수 171행 1:1 추적표)으로 PASS — 행수·family 소계·finding-id 집합 전건 manifest 일치·중복 0·2차 미귀속 14건 전건 귀속·무인용 누락 0 기계 보증. **DB 미적재·비파괴 유지**(실 교정 = round-5/6/10 + 인간 승인).

**최종: GO** (X1~X6 전건 PASS).

---

## 8. X1 재게이트 상세 (3차 최종 — §0-bis 전수 171행 1:1 추적 후)

### 8-1. F-XC-2 (Low) — ✅ RESOLVED (2차)
PRD_000126 명칭 정밀화 확인: crosscut-synthesis 130줄·196줄 양쪽 "레더아트프린트126[CAT_000298 실사]"로 교체. MAT_000186 4 family(booklet·photobook·silsa·stationery) 귀속·6상품 카운트 불변.

### 8-2. F-XC-1/F-XC-1b — ✅ RESOLVED (3차)
§0-bis가 개념 분류 → **전 finding 1:1 전수 추적표(171행)**로 재작성됨. 검증자 독립 기계 점검 전건 통과:

| 점검 항목 | 방법 | 결과 |
|------|------|------|
| **행수 171** | 헤더 제외 데이터 행 grep 카운트 | ✅ **정확히 171** |
| **family 소계** | family별 행 카운트 ↔ auditor 회신 | ✅ 전건 일치(DP18·GP17·PA14·SL14·AC22·ST18·STK17·BK13·PB17·CAL21) |
| **§0-bis id 집합 = manifest id 집합** | 10 family diff | ✅ 전건 MATCH(calendar 21=C-CAL11+C-DC3+OK7·acrylic 22 정확) |
| **photobook DIFF 1(PB-M3)** | F-PB-1 재분류 확인 | ✅ 정당 — PB-M3→PB-A2 superseded·manifest §0도 PB-A2만 active(합계 17) |
| **finding-id 중복** | (family+id) uniq -d | ✅ **0** |
| **2차 미귀속 14건 귀속** | 14 finding 행 추출 | ✅ **전건 1행씩 명시 귀속**(GP-C-06·C-ST-10/11/12·ST-05/10/11/12/14·AC-M1/M3/X2/X3/X5/X6/A2 → 단발/횡단②연계/AMB-미해소·빈 셀 0) |
| **"67" 정정** | 전수 추출 결산 | ✅ 전 finding 171·결함성 113(CORRECT 58 제외)·검산 해설 명시 |

> **무인용 누락 0 기계 보증.** 2차 적발한 14건 전부 §0-bis에 명시 귀속됐고, finding-id 집합이 manifest와 1:1 대응(중복·누락 0). X1 PASS.

### 8-3. 최종 발견 상태
| # | 발견 | 1차 심각도 | 최종 상태 |
|:--:|------|:--:|------|
| F-XC-1/1b | §0-bis 1:1 미추적·무인용 누락 | Med | ✅ RESOLVED(전수 171행 추적표·기계 보증) |
| F-XC-2 | PRD_000126 명칭 | Low | ✅ RESOLVED(레더아트프린트[실사] 정밀화) |

> **교정 방향 무변경:** 추적된 finding은 전부 round-5/6/10 트랙에 family manifest로 배정된 GO finding. 종합은 메타 추적 완전성 확보. **X1 PASS → 종합 GO.**
