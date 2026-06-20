# golden-cases-silsa-banner.md — 실사·현수막 설계 대표 케이스 + 기대 골든값

> **핵심 설계가(hpe-engine-designer) 산출 — 실사·현수막.** 설계 공식으로 계산되는 대표 케이스와 기대 골든값.
> 검증가(hpe-validator)·codex가 라이브 `evaluate_price`를 실호출/재구현해 **이 골든값을 재현**한다(허용오차 0).
>
> **★순환참조 금지[HARD]**: 골든값은 **가격표 셀(=라이브 단가행 verbatim)** 에서 가져온다. 설계가 만든 값이 아니다.
> 출처 = 라이브 `t_prc_component_prices` 실측(2026-06-20 읽기전용 SELECT·가격표260527 적재본)·단가값 verbatim.
> 계산 규칙 = engine-contract(`pricing.py` 직접 확인·§2~§5 of engine-design-silsa-banner).

---

## 0. 골든 케이스 도출 원칙 (실사·현수막)

- **면적매트릭스 본체**(13소재)는 골든 = 단가행 unit_price 직독 → `subtotal = unit × qty`(전건 `.01 단가형`·÷min_qty 미발생·§3 확정).
- **고정가형**(폼보드·액자·시트커팅 등)은 골든 = siz_cd 단가행 unit × qty.
- **수량구간형**(미니류)은 골든 = siz_cd × min_qty 밴드 룩업(주문수량 이하 최대 min_qty 구간) → 개당가 × qty.
- **★디지털과 결정적 차이 — 양면표 불요**: 면적단가는 **1장당가**(묶음총액 아님)·prc_typ 전건 `.01`(÷ 미발생) → "설계 기대값 = 현 라이브 본체 산출값"(본체 결함 없음·§3). 디지털 골든의 "설계 vs 라이브 ×qty 결함" 양면표 불필요.
- **★후가공은 현재 미배선(G-S1)** → "현재 = 후가공 가격 반영 0(본체만), 배선 후 = 본체+후가공" 두 상태 표기. 단 배너 후가공은 **판별차원 충전 선결**(미충전 배선 시 silent 합산 과청구·§5-2).

---

## 1. 면적매트릭스 본체 골든 (.01 단가형·1장당가·라이브 verbatim)

### GC-S1. 캔버스패브릭포스터 600×1800 1장 (PRF_POSTER_CANVAS·라이브 바인딩 실재)
| 항목 | 값 | 출처 |
|------|-----|------|
| 상품 | 캔버스패브릭포스터 PRD_000125 → PRF_POSTER_CANVAS | 라이브 바인딩 실재 |
| selections | `{siz_width: 600, siz_height: 1800, qty: 1}` | — |
| comp | COMP_POSTER_CANVAS_FABRIC(정본A·레더/메쉬프린트/타이벡 동형결합) | 단가행 `siz_width=600·siz_height=1800·unit=37800` (라이브 SELECT verbatim) |
| prc_typ | `.01 단가형` | `subtotal = 37,800 × 1` |
| **기대 골든** | **37,800원** | 가격표 포스터사인 verbatim·라이브 재현 |
| ★10장 골든 | **378,000원** (37,800 × 10·1장가×수량 누적·×qty 폭발 없음) | §3-2 단가형 계약 |

★ **×qty 계약 검증 핵심**: prc_typ `.01`이라 `unit × qty` = 37,800×10 = 378,000(정상). 디지털 ×qty 폭발(명함 3500→350,000) 같은 결함 없음 — 단가가 1장당가이기 때문.

### GC-S2. 아트프린트포스터 600×1800 1장 (동형결합 정본B 검증)
| comp | COMP_POSTER_ARTPRINT_PHOTO(정본B·방수/접착방수/아트패브릭 결합) | unit=**21600** (라이브 verbatim) |
| **기대 골든** | **21,600원** | 가격표 verbatim |

→ 검증가: 방수포스터(PRD_000120→PRF_POSTER_WATERPROOF)·접착방수(PRD_000121)·아트패브릭(PRD_000123) 600×1800도 동일 정본 comp → **21,600**(동형결합 byte-identical 검증).

### GC-S3. 린넨패브릭포스터 600×600 1장 (단독 comp·비대칭 셀 회귀)
| comp | COMP_POSTER_LINEN_FABRIC(단독·결합 금지) | unit=**17000** (600×600 verbatim) |
| **기대 골든** | **17,000원** | 가격표 verbatim |
| ★600×1800 골든 | **32,400원** (비대칭 셀·W=가로600·H=세로1800) | 라이브 verbatim |

★ **축 권위 회귀**: 린넨 600×600=17,000·600×1800=32,400(비대칭). W=가로(앞)=600·H=세로(뒤)=1800. 축이 뒤바뀌면(1800×600) 다른 셀 룩업. 검증가: evaluate_price(린넨, {siz_width:600, siz_height:1800})=32,400이면 축 정합·work 미사용(siz_cd=NULL·WH numeric).

### GC-S4. 접착투명포스터 600×1800 1장 (단독·고단가 검증)
| comp | COMP_POSTER_ADH_CLEAR_PVC(단독) | unit=**59400** (600×1800)·600×600=**16000** | 라이브 verbatim |
| **기대 골든** | **59,400원** | 가격표 verbatim |

→ 검증가: 접착투명은 단독 comp(단가 상이로 결합 금지·정당). 600×600=16,000과 600×1800=59,400 모두 verbatim.

### GC-S5. off-grid ceiling — 일반현수막 가로650×세로650 1장 (엔진 TIER ceiling 검증)
| 상품 | 일반현수막 PRD_000138 → PRF_POSTER_BANNER_N | — |
| selections | `{siz_width: 650, siz_height: 650, qty: 1}` (격자에 650 없음·incr 100 스냅 후에도 700) |
| 엔진 처리 | width 650 → '이하' 임계 없으면 '이상 최소' ceiling(TIER_UPPER)·height 동일 | `pricing.py:144-164` |
| comp | COMP_POSTER_BANNER_NORMAL·siz_width/height ceiling 셀 | unit=가격표 ceiling 셀 verbatim(예 700×700 또는 900×900 첫 행 8,000) |
| **기대 골든** | **한 단계 큰 격자 셀 단가**(ceiling·런타임) | [[dbmap-compute-in-app-db-stores-lookup]] |

→ 검증가: 650×650 주문 시 가격표 다음 큰 구간 단가 적용(보간/ceiling 행 단가행에 없음). nonspec_incr=100mm 입력 스냅 → TIER ceiling. 최대 구간 초과 시 `ERR_ABOVE_MAX`.

---

## 2. 고정가형 골든 (siz_cd·.01)

### GC-S6. 폼보드(화이트) 규격 1개 (PRF_POSTER_FOAMBOARD·라이브 바인딩 실재)
| 상품 | 폼보드 PRD_000129 → PRF_POSTER_FOAMBOARD | 라이브 바인딩 실재 |
| selections | `{siz_cd: <폼보드 규격>, qty: 1}` (면적 아님·이산 규격) |
| comp | COMP_POSTER_FOAMBOARD_WHITE·use_dims=[siz_cd]·2행 | unit=가격표 규격 verbatim |
| prc_typ | `.01 단가형` | `subtotal = unit × qty` |
| **기대 골든** | **가격표 폼보드 규격 단가**(2규격 verbatim) | 가격표 verbatim |

→ 검증가: siz_cd 정확매칭(NON_QTY_DIMS) 1행 → unit×qty. 폼보드 블랙(COMP_POSTER_FOAMBOARD_BLACK)은 별 comp·별 단가.

---

## 3. ★수량구간형 골든 (미니류·min_qty 밴드·아크릴/디지털 비동형)

### GC-S7. 미니배너 30개 주문 (PRF_POSTER_MINI_BANNER·수량밴드 TIER 검증) [HARD]
| 항목 | 값 | 출처 |
|------|-----|------|
| 상품 | 미니배너 PRD_000145 → PRF_POSTER_MINI_BANNER | 라이브 바인딩 실재 |
| selections | `{siz_cd: SIZ_000028, qty: 30}` | — |
| comp | COMP_POSTER_MINI_BANNER·use_dims=[siz_cd,min_qty]·10행 | 단가행 SIZ_000028 밴드: 4=6,500·**19=4,900**·49=4,200·99=3,500·10000=2,800 (라이브 verbatim) |
| 엔진 구간 | min_qty '이상' 하한·주문 30 이하 최대 임계 = **19**(19≤30<49) | `pricing.py:42·144` |
| prc_typ | `.01 단가형` | `subtotal = 4,900(구간 개당가) × 30` |
| **기대 골든** | **147,000원** (개당 4,900 × 30개) | 가격표 미니배너 밴드 verbatim |
| ★4개 골든 | **26,000원** (개당 6,500 × 4·최소구간) | 밴드 4 행 |
| ★100개 골든 | **350,000원** (개당 3,500 × 100·min_qty=99 밴드) | 100개 → 99≤100<10000 ∴ min_qty=**99** 행(3,500) → 350,000 (codex DV-SB1 표기 정정 2026-06-20) |

★ **수량밴드 TIER 검증 핵심**: min_qty는 '이상' 하한(siz_width/height '이하' ceiling과 **방향 반대**). 주문 30개 → 30 이상의 행이 아니라 **30 이하 최대 min_qty=19**(`pricing.py:42` "주문수량 이하의 최대 min_qty 구간"). 검증가: evaluate_price(미니배너, {SIZ_000028, 30})=147,000(개당 4,900×30)이면 정합. **100개는 min_qty=99 행(개당 3,500)×100 = 350,000**(10000 구간은 100<10000이라 미적용) — 검증가 회귀 포인트(방향 혼동 시 틀림).

### GC-S8. 미니보드스탠딩 50개 SIZ_000315 (수량밴드 다규격 검증)
| comp | COMP_POSTER_MINI_STANDBOARD·SIZ_000315 밴드: 4=6,500·19=6,200·**49=6,100**·99=5,900·10000=5,500 | 라이브 verbatim |
| 엔진 구간 | 주문 50 → 49≤50<99 ∴ min_qty=49(개당 6,100) | `pricing.py:42` |
| **기대 골든** | **305,000원** (개당 6,100 × 50) | 가격표 verbatim |

→ 검증가: siz_cd(SIZ_000315) 정확매칭 + min_qty=49 TIER → 6,100×50=305,000. siz_cd별 다른 밴드(SIZ_000258·SIZ_000426)는 별 단가.

---

## 4. ★후가공 배선 골든 (G-S1·배선 후·판별차원 가드)

### GC-S9. 공통 후가공 — 캔버스포스터 600×1800 + 오시 2줄 (배선 후·안전)
| selections | `{siz_width:600, siz_height:1800, qty:1, proc_cd:PROC_000090, dim_vals.줄수:2}` |
| disp1 본체 | COMP_POSTER_CANVAS_FABRIC 매칭 → 37,800 |
| disp2 오시 | COMP_PP_CREASE_1L·proc_cd+dim_vals.줄수=2 매칭 → 6,000 (라이브 verbatim) |
| 미선택 후가공(미싱/귀돌이/가변/별색) | row=None → 제외(무경고) |
| **기대 골든(배선 후)** | **43,800원** (본체 37,800 + 오시 6,000) | 라이브 verbatim 합 |
| ★현재(미배선) | **37,800원** (본체만·오시 가격 반영 0) | G-S1 입증 |

→ 검증가: 현재 오시 선택해도 43,800 아닌 37,800(후가공 미배선). 배선 후 evaluate_price=43,800. 오시는 판별차원(proc_cd) 보유 → silent 합산 없음(다른 후가공 자연 제외).

### GC-S10. ★배너 후가공 silent 합산 가드 — 일반현수막 타공 6개 (판별차원 충전 검증) [HARD·돈크리티컬]
| selections | `{siz_width:900, siz_height:900, qty:1, <타공 6개 선택>}` |
| disp1 본체 | COMP_POSTER_BANNER_NORMAL 900×900 → 8,000 (라이브 verbatim) |
| **★미충전 배선 시(결함 재현)** | PUNCH_4/6/8 셋 다 use_dims=[]·NULL 와일드카드 → **셋 다 합산** 8,000+3,000+4,000+5,000 = **20,000원**(타공 4+6+8 동시 과청구·silent) | §5-2 결함 메커니즘 |
| **★판별차원 충전 후(정답)** | 타공 6개만 매칭 8,000 + 4,000 = **12,000원** | 충전 후 정답 |
| ★현재(미배선) | **8,000원** (본체만) | G-S1 입증 |

★ **silent 합산 가드 핵심**: PUNCH_4/6/8을 충전 없이 한 공식에 배선하면 셋 다 항상매칭 → 20,000 과청구(손님이 6개만 골라도). 검증가: ① 충전 전 배선 시 evaluate_price=20,000(결함 재현·note "판별차원 없음") ② PUNCH 통합 + opt_cd(구멍수) 충전 후 6개 선택=12,000(정답). **충전 없이 배선 절대 금지**(과청구 100%). 큐방/끈/봉미싱/거치(STAND)도 동형(use_dims=[]·충전 선결).

### GC-S11. 거치 부속 — 캔버스행잉 + 우드행거 (판별차원 보유·안전)
| disp1 본체 | COMP_POSTER_CANVAS_HANGING(고정 3규격) → 가격표 verbatim |
| disp2 우드행거 | COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER·siz_cd 매칭: SIZ_000258=16,000·SIZ_000315=18,000·SIZ_000317=20,000 | 라이브 verbatim |
| **기대 골든(배선 후)** | **본체 + 우드행거(siz_cd별 16,000~20,000)** | 라이브 verbatim |

→ 검증가: 우드행거는 siz_cd 판별차원 보유 → 선택 규격만 매칭(silent 합산 없음). 단 캔버스행잉 본체 차원 정합(G-S3b·use_dims [siz_w,siz_h,min_qty] vs 실데이터) 라이브 재확인 필요.

### GC-S12. 린넨 마감가공 (5택1·판별차원 opt_cd 보유·안전)
| disp1 본체 | COMP_POSTER_LINEN_FABRIC 600×600 → 17,000 |
| disp2 린넨마감 | COMP_POSTEROPT_LINEN_FINISH·opt_cd 매칭: OPV_000025=0·OPV-000024=800·OPV_000026=1,000·OPV_000424=2,000·OPV_000027=2,000 | 라이브 verbatim |
| **기대 골든(배선 후·말아박기 1,000 선택)** | **18,000원** (본체 17,000 + 마감 1,000) | 라이브 verbatim |

→ 검증가: 린넨마감 opt_cd 판별차원 보유(5택1) → 선택 opt_cd 1행만 매칭. silent 합산 없음(이미 dbmap round-23 린넨 COMMIT됨).

---

## 5. 검증가 재현 체크리스트

| 골든 | 검증 명제 | engine-contract |
|------|----------|-----------------|
| GC-S1 | 캔버스 600×1800 = 37,800·10장=378,000(1장가×수량·×qty 폭발 없음) | .01 단가형 §3 |
| GC-S2 | 아트프린트=21,600(정본B 동형결합·방수/접착방수/아트패브릭 동일) | byte-identical 결합 |
| GC-S3 | 린넨 600×600=17,000·600×1800=32,400(W×H 축 권위·비대칭) | §2-2 돈크리티컬 |
| GC-S4 | 접착투명 600×1800=59,400(단독·결합 금지 정당) | 단가 상이 |
| GC-S5 | 현수막 650×650 → ceiling 셀(nonspec_incr 100 스냅) | TIER_UPPER §2-3 |
| GC-S6 | 폼보드 규격 = siz_cd 단가×qty | 고정가 §4-A |
| GC-S7 | 미니배너 30개=147,000(min_qty=19 밴드·'이상' 하한)·100개=350,000(min_qty=99) | 수량구간 §4-B·방향 |
| GC-S8 | 미니보드 SIZ_000315 50개=305,000(min_qty=49) | 수량밴드 다규격 |
| GC-S9 | 캔버스+오시2줄 배선 후 43,800(현재 37,800·후가공 미배선) | G-S1 배선 |
| GC-S10 | ★타공6 미충전 배선=20,000(silent 합산 결함)·충전 후=12,000(정답) | §5-2 판별차원 |
| GC-S11 | 캔버스행잉+우드행거(siz_cd 16,000~20,000·안전) | 판별차원 보유 |
| GC-S12 | 린넨+마감(opt_cd 5택1·말아박기 18,000) | dbmap round-23 정합 |

★ **모든 "기대 골든값" 출처 = 라이브 단가행 verbatim(가격표260527)·옳음**(순환참조 0). **본체는 디지털 ×qty 결함·아크릴 .02 미확정이 없으므로**(§3·prc_typ .01) "설계 기대값 = 정상 본체 산출값". 불일치 진원은 **G-S1 후가공 미배선(가격 반영 0)** 또는 **배너 후가공 판별차원 미충전(silent 합산 과청구)** — 본체 단가/엔진 결함 아님.
