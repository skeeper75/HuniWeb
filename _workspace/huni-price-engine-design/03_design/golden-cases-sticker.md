# golden-cases-sticker.md — 스티커 이산 siz_cd 단가형 + 세트 합가형 설계 대표 케이스 + 기대 골든값

> **핵심 설계가(hpe-engine-designer) 산출 — 스티커.** 설계 공식으로 계산되는 대표 케이스와 기대 골든값.
> 검증가(hpe-validator)·codex가 라이브 `evaluate_price`를 실호출/재구현해 **이 골든값을 재현**한다(허용오차 0).
>
> **★순환참조 금지[HARD]**: 골든값은 **가격표 셀(=라이브 단가행 verbatim)** 에서 가져온다. 설계가 만든 값이 아니다.
> 출처 = 라이브 `t_prc_component_prices` 실측(2026-06-20 읽기전용 SELECT·가격표260527 적재본)·단가값 verbatim.
> 권위: 상품마스터260610·가격표260527. 계산 규칙 = engine-contract(`pricing.py` P2~P4·§2~§3 of engine-design-sticker).

---

## 0. 골든 케이스 도출 원칙 (스티커)

- **이산 siz_cd 단가형**(COMP_STK_PRINT·COMP_GANGPAN_PRINT·.01): 골든 = (siz_cd, mat_cd, min_qty 구간) 정확/구간 매칭 단가행 unit_price 직독 → `subtotal = unit × qty`.
- **세트 합가형**(COMP_STK_TATTOO·COMP_STK_PACK·.02): 골든 = 단가행 unit ÷ min_qty × qty(세트총액 장당 환산).
- **★두 종류 표기 [HARD]**:
  - **(A) 정상 케이스** — 바인딩 정합이 맞아 evaluate_price가 골든값 재현(예 124x186 유포 qty3).
  - **(B) 교정 전후 케이스** — G-STK-1~4 결함이 만든 현 결과(no_match·오청구)와 교정 후 정답을 양면 표기(검증가가 결함 입증·교정 검증).
- **★디지털 ×qty 폭발·아크릴 미바인딩과 다름**: 스티커는 단가 의미↔prc_typ 정합(개당/장당 단가·.02 ÷환산)이라 정상 케이스는 결함 없음. 결함은 **바인딩 정합**(siz/mat 키 불일치)이지 단가/엔진/prc_typ 오류 아님.

---

## 1. 정상 케이스 (바인딩 정합 OK — 골든 재현 확인)

### GC-STK1. 124x186 유포 반칼 qty3 (PRF_STK_FIXED·.01·라이브 재현 확인)
| 항목 | 값 | 출처 |
|------|-----|------|
| 상품 | PRD_000059 반칼정사각스티커 → PRF_STK_FIXED | 라이브 바인딩 실재 |
| selections | `{siz_cd: SIZ_000059(124x186), mat_cd: MAT_000153(유포), qty: 3}` | — |
| comp | COMP_STK_PRINT·siz=059·mat=153·min_qty 구간(qty3) | 단가행 verbatim |
| prc_typ | `.01 단가형` | `subtotal = unit × qty` |
| **기대 골든** | **5,900원** | 가격표 B01 verbatim·dbmap `bankal-058-064-deepcheck` 라이브 재현 |
| ★수량 1개 | **6,000원** (qty1 구간) | B01 A5(4판) col1 유포 verbatim |

→ 검증가: evaluate_price(PRD_000059, {SIZ_000059, MAT_000153, 3})=5,900이면 정합. 정상 바인딩(siz/mat 둘 다 단가행에 존재).

### GC-STK2. 타투 90x190 qty9 (PRF_STK_TATTOO·.02·÷3 환산·라이브 재현 확인)
| 상품 | PRD_000067 타투스티커 → PRF_STK_TATTOO |
| selections | `{siz_cd: SIZ_000060(90x190), mat_cd: MAT_000167(타투전용지), qty: 9}` |
| comp | COMP_STK_TATTOO·siz=060·mat=167·**min_qty=3·unit=4000**(라이브 SELECT verbatim) |
| prc_typ | `.02 합가형` | `per_item = 4000÷3 = 1,333.33`·`subtotal = ×9` |
| **기대 골든** | **12,000원** (4000 ÷ 3 × 9) | 가격표 B05 "3장마다 4000" |
| ★qty3 | **4,000원** (4000÷3×3) | 1세트 단위 |

★ **min_qty 계약 검증 핵심**: .02·min_qty=3이라 `per_item = 4000÷3`·`×9 = 12,000`. ×qty 폭발(4000×9=36,000) 없음 — prc_typ=.02가 세트총액을 장당 환산. 검증가: evaluate_price(타투, {SIZ_000060, MAT_000167, 9})=12,000.

### GC-STK3. 스티커팩 75x110 qty54 (PRF_STK_PACK·.02·÷54·★benchmark 54배 왜곡 우려 해소 검증)
| 상품 | PRD_000065 스티커팩 → PRF_STK_PACK |
| selections | `{siz_cd: SIZ_000068(75x110), qty: 54}` (mat_cd 미사용·use_dims=[siz_cd,min_qty]) |
| comp | COMP_STK_PACK·siz=068·**min_qty=54·unit=4000**(라이브 SELECT verbatim) |
| prc_typ | `.02 합가형` (★라이브 실측 확정·benchmark "01 오적재"는 stale) | `per_item = 4000÷54 = 74.07`·`×54` |
| **기대 골든** | **4,000원** (4000 ÷ 54 × 54) | 가격표 B06 "54장 1세트 4000" |
| ★(if .01 오적재였다면) | ~~216,000원~~ (4000×54·54배 왜곡) | benchmark 우려 — **라이브 .02로 부재** |

★ **prc_typ 결판 검증**: 라이브 COMP_STK_PACK = `PRICE_TYPE.02`(2026-06-20 실측). qty54 = 4000÷54×54 = 4,000(정확). 만약 benchmark 우려대로 .01이면 4000×54 = 216,000(54배 왜곡). **라이브 .02 확정으로 왜곡 부재** — cartographer "교정 완료" 정확·benchmark 인용 stale. 검증가: COMP_STK_PACK prc_typ=PRICE_TYPE.02 직접 확인 + evaluate_price=4,000.

### GC-STK4. 합판도무송 (PRF_GANGPAN_FIXED·.01·별 시트·형상=siz_cd 고정사이즈)
| 상품 | PRD_000066 합판도무송스티커 → PRF_GANGPAN_FIXED |
| comp | COMP_GANGPAN_PRINT·use_dims=[siz_cd,mat_cd,min_qty]·370행·mat 084/153 | 라이브 verbatim |
| prc_typ | `.01 단가형` | `subtotal = unit × qty` |
| **기대 골든** | 형상별 고정사이즈 siz_cd 단가(18,000~189,900 범위) | 합판도무송 시트 verbatim |

★ **형상=siz_cd 고정사이즈(가격축 아님 예외)**: 원형/정사각/직사각이 형상별 고정사이즈 siz_cd로 표현(별 상품·B01 반칼 058~060과 별개). 형상=가격축이 아니라 그 상품이 형상별 고정가형(§2-1 engine-design 예외). 검증가: GANGPAN 370행 siz/mat 정확매칭 1행.

---

## 2. 교정 전후 케이스 (G-STK-1~4 — 결함 입증 + 교정 검증)

### GC-STK5. ★G-STK-1 — 낱장자유형 A4 유포 (소재 불일치 no_match → 재바인딩 정답)
| 상품 | PRD_000055 낱장자유형스티커 → PRF_STK_FIXED |
| selections | `{siz_cd: SIZ_000172(A4), mat_cd: ?, qty: 1}` |
| **현 라이브(결함)** | 상품 바인딩 mat = **MAT_000154(유포지·del_yn=Y)** → COMP_STK_PRINT에 154 단가행 **0행** → 🔴 **no_match(가격 0/오류)** | 라이브 SELECT(154 0행·del_yn=Y) |
| **교정 후(정답)** | mat 재바인딩 154→**MAT_000153(유포스티커)** → SIZ_172×MAT_153 단가행 = **4,000(B02 낱장 A4 유포)** | 058~061·052 정본 패턴·라이브 verbatim |
| 검증 명제 | 현재 055 A4유포 견적 = no_match(0). 153 재바인딩 후 = 4,000(낱장 B02) | G-STK-1 입증 |

★ **정답=재바인딩이지 단가행 추가 아님**: MAT_000154 del_yn=Y(논리삭제)·형제 058~061/052가 정본 153 바인딩·단가행 153은 verbatim 옳음. 검증가: ① COMP_STK_PRINT mat 154/243 단가행 0행 직접 확인 ② 055/057 바인딩 154·056 바인딩 243 직접 확인 ③ 재바인딩 후 153×SIZ_172 = 4,000 재현. 056(투명)은 243→162·057(대형)은 154→153 동형.

### GC-STK6. ★G-STK-2 — 반칼 A4 (SIZ_172 오청구 4000 → SIZ_520 정답 5000·돈크리티컬)
| 상품 | PRD_000052/053/054 반칼 → PRF_STK_FIXED |
| selections | `{A4 사이즈 선택, mat_cd: MAT_000153, qty: 1}` |
| **현 라이브(결함)** | A4 바인딩 = **SIZ_000172(A4 낱장)** → SIZ_172×153 = **4,000(B02 낱장 완칼가)** | 라이브 verbatim |
| **교정 후(정답)** | A4 바인딩 **SIZ_172 → SIZ_000520(A4 반칼)** → SIZ_520×153 = **5,000(B01 반칼 col2)** | 058~061 precedent·라이브 verbatim·SIZ_520 note "반칼 전용가" |
| 검증 명제 | 052 A4유포 현재 = 4,000(낱장 오청구). SIZ_520 재바인딩 후 = 5,000(반칼) | G-STK-2 돈크리티컬 입증 |

★ **돈크리티컬 1,000원/장 과소청구**: 반칼인데 낱장 4000 청구 = 장당 1,000원 손실. 058~061은 이미 SIZ_520(5000) 적용(라이브 실측 precedent) — 052~054만 누락. 검증가: ① SIZ_172 유포 min_qty=1 = 4,000·SIZ_520 = 5,000 직접 확인(둘 다 라이브 verbatim) ② 058~061 SIZ_520 바인딩·052~054 SIZ_172 바인딩 직접 대조.

### GC-STK7. ★G-STK-3 — A6 / 100x140 (단가행 0 → no_match·바인딩 유효성)
| 상품 | PRD_000052~054(A6 SIZ_196)·PRD_000062/063(100x140 SIZ_058) |
| selections | `{siz_cd: SIZ_000196(A6) or SIZ_000058(100x140), ...}` |
| **현 라이브(결함)** | SIZ_196·SIZ_058 = COMP_STK_PRINT(및 모든 comp) **단가행 0행** → 🔴 **no_match** | 라이브 SELECT(0행) |
| 가격표 B01 6사이즈 | A5(124x186)·90x190·100x148·90x110·A4반칼·A3 — **A6·100x140 부재** | 가격표 verbatim |
| **교정 후(정답·택1)** | (a) 바인딩 제거(가격표에 사이즈 없음·권고) / (b) 단가 출처 확인 후 verbatim INSERT(현재 출처 미확인) | Q-STK-SIZ1·추측 적용 금지 |
| 검증 명제 | A6·100x140 선택 시 현재 no_match. 가격표에 해당 사이즈 부재 입증 | G-STK-3 입증 |

★ **추측 적용 금지[HARD·돈크리티컬]**: 가격표 B01에 A6·100x140이 없으므로 단가행 0은 결손이 아니라 binding-validity 위반(가격표에 없는 사이즈 바인딩). 검증가: SIZ_196·SIZ_058 모든 comp 0행 + 가격표 B01 사이즈 목록 대조.

### GC-STK8. ★G-STK-4 — 064 소량자유형 (잠정 단가 + 굿즈 siz 의미혼선)
| 상품 | PRD_000064 소량자유형스티커(use_yn=N) → PRF_STK_FIXED |
| selections | `{siz_cd: SIZ_000036(94x94) 등 7사이즈, ...}` |
| **현 라이브(잠정)** | 7사이즈 전건 **[잠정]** B01 col1 규격가(6000/7000) 사이즈무관 복사 + SIZ_036/043 note=**인쇄배경지/인쇄해더택**(굿즈 siz 재사용) | 라이브 SELECT([잠정] note·굿즈 적용) |
| **교정 후** | 실측 소형반칼 단가 수령 시 교체(소형=판걸이 32 vs 4·단가 다를 개연)·064 전용 siz 별 채번 검토 | 사용자 "우선 적용·추후변경"·Q-STK-064 |
| 검증 명제 | 064 잠정가 일치(현 상태)·use_yn=N(긴급도 낮음)·SIZ_036/043 의미충돌 기록 | G-STK-4 입증 |

★ **064 use_yn=N**: 비활성이라 긴급도 낮음. 활성화 전 실측 단가 + 전용 siz 분리(굿즈 siz 재사용 해소) 선결. 검증가: SIZ_036/043 note 굿즈 의미 + 064 7사이즈 [잠정] note 직접 확인.

---

## 3. 검증가 재현 체크리스트

| 골든 | 검증 명제 | engine-contract | 종류 |
|------|----------|-----------------|------|
| GC-STK1 | 124x186 유포 qty3 = 5,900·qty1=6,000(.01 unit×qty) | §3-1 단가형 | (A)정상 |
| GC-STK2 | 타투 90x190 qty9 = 12,000(4000÷3×9·×qty 폭발 없음) | §3-2 .02 ÷min_qty | (A)정상 |
| GC-STK3 | 팩 75x110 qty54 = 4,000(4000÷54×54)·prc_typ=.02 확정(54배 왜곡 부재) | §0·§3-2·benchmark 우려 해소 | (A)정상 |
| GC-STK4 | 합판도무송 형상=siz_cd 고정사이즈·.01 | §2-1 예외 | (A)정상 |
| GC-STK5 | 055 A4유포 현재 no_match(mat 154 del_yn=Y·0행)→153 재바인딩 후 4,000 | G-STK-1 재바인딩 | (B)교정전후 |
| GC-STK6 | 052 A4 현재 4,000(낱장 오청구)→SIZ_520 재바인딩 후 5,000(반칼) | G-STK-2 돈크리티컬 | (B)교정전후 |
| GC-STK7 | A6(196)·100x140(058) 현재 no_match(0행·가격표 부재) | G-STK-3 binding-validity | (B)교정전후 |
| GC-STK8 | 064 잠정가·굿즈 siz 재사용 의미충돌(use_yn=N) | G-STK-4 잠정·컨펌 | (B)교정전후 |
| 회귀 | 16/16 바인딩 전건·comp 1개씩(이중합산 불가)·단가행 3,066 verbatim | §3-3 동형결함 부재 | 구조 |

★ **모든 "기대 골든값" 출처 = 라이브 단가행 verbatim(가격표260527)·옳음**(순환참조 0). **스티커는 디지털 ×qty 폭발·아크릴 미바인딩·인쇄면 silent 이중합산이 모두 구조적 부재**(§3-3 engine-design). 불일치가 나온다면 진원은 **바인딩 정합 결함(G-STK-1~4)**이지 단가/엔진/prc_typ 오류 아님. 정상 케이스(GC-STK1~4)는 현 라이브가 이미 골든 재현·교정 케이스(GC-STK5~8)는 재바인딩/유효성 처리 후 정답 재현(DB 미적재·dbmap 위임).
