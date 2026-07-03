# 그래프 빌드 리포트 — 스티커 공유 축 통합·index·빌드 (2026-07-03)

> okb-knowledge-builder(통합 패스) · 정본 `03_kb/` → `04_graph/`. 생성=빌드(검증은 별도 레인·okb-adversarial-gate).
> 선행: 병렬 스티커 빌더 16종(052~067)이 각자 product-local companion에 공유 원자를 중복 mint → 빌드 하드 L-3 26건.

## 판정
- **PASS · 하드 위반 0 · 소프트 313** (직전 26 하드·365 소프트 → 통합 후 0·313)
- 노드 652 · 엣지 2124
- 멱등 해시: nodes.jsonl=`954f899645a87062` · edges.jsonl=`6c864143cd246e9e` (2회 빌드 바이트 동일 = idempotent true)

## 무결성 6검사 (전부 0 = PASS)
- I-1 고아(product/formula/component): 0
- I-2 끊긴 링크: 0
- I-3 타입 위반: 0
- I-4 필수 엣지(O5/O6): 0 — 16 스티커 상품 전부 `priced_by` 실재
- I-5 멱등: 재현 동일
- I-6 오염(blocklist): 0

## 1) 공유 축 통합 (단일 소유권·중복 id 0)
병렬 product-local 중복(L-3 26건)을 `_meta/scripts/consolidate_sticker_axes.py`가 결정론 이관(블록 verbatim·값 손전사 없음). 55 원자를 shared 축/공식으로 단일 소유권 승격, 전 product-local 사본 제거:

| target | 승격 원자 수 | 원자 |
|---|---|---|
| `axis/categories.md` | 5 | CAT_000002 스티커·CAT_000309 자유형·CAT_000037 규격·CAT_000311 특수·CAT_000312 스티커팩 |
| `axis/sizes.md` | 19 | SIZ_000057/170(defect)/520/197/199/515/514/068/212/224/501/058/059/060/061/062/063/064/065 |
| `axis/materials.md` | 18 | 점착지 MAT_000584/611/585/586/609·153/084/242/155/156·170/171·163·371·162(defect)/372(defect)·593·594 |
| `axis/processes.md` | 4 | PROC_000122 반칼커팅·PROC_000055 스티커완칼·PROC_000054 반칼 Kiss Cut·PROC_000114 쿨코팅 |
| `axis/plate-sizes.md` | 1 | OUTPUT_PAPER_TYPE.02 46전지(330x470) |
| `formula/sticker-formulas.md`(신규) | 4 | PRF_STK_FIXED·PRF_GANGPAN_FIXED·PRF_STK_PACK·PRF_STK_TATTOO |
| `formula/sticker-components.md`(신규) | 4 | COMP_STK_PRINT·COMP_GANGPAN_PRINT·COMP_STK_PACK·COMP_STK_TATTOO |

- 결과: L-3 중복 id 0. 전 16 스티커 상품의 `priced_by`/`has_size`/`uses_material`/`in_category`/`has_process`/`has_plate_size` 엣지가 shared 단일 노드로 해소(product 메인 파일 relations 무변경 — 이관은 노드 소유권만 이동).
- L-1 교정: `sticker-spec-rectangle.md` id `product-060-rectangle-sticker`→`sticker-spec-rectangle`(형제 컨벤션 정합)·교차참조 2건 갱신.
- product-047-small-flyer의 SIZ_000170 로컬 선언도 제거 → 스티커/디지털 공용 단일 defect 노드 참조(라이브 실측 master del_yn=Y 확인).

## 2) index 통합
- `03_kb/index.md` 스티커 계열 = 3 → **16 상품 전수 등재**(O4 소프트: 스티커 main 파일 잔여 0). 공유 축 통합 note·헤더 상태·categories(8→13)·formula/component 스티커 4/4 bullet 갱신.
- `03_kb/rule/gaps.md` 스티커 GAP 색인 절 신설(16상품·노드 정의는 각 product/*-nodes.md·여기는 링크만).

## 3) 스티커 16상품 가격경로 연결 현황 (전부 연결·O5=0)
| 공식 | 상품 |
|---|---|
| PRF_STK_FIXED → COMP_STK_PRINT (완제품가 고정룩업) | 052·053·054·055·056·057·058·059·060·061·062·063·064 (13) |
| PRF_GANGPAN_FIXED → COMP_GANGPAN_PRINT (합판도무송·1,110행) | 066 |
| PRF_STK_PACK → COMP_STK_PACK (팩 합가형·54장1세트) | 065 |
| PRF_STK_TATTOO → COMP_STK_TATTOO (타투 합가형·3장1세트) | 067 |

- 스티커 gap 노드 63건(정직 공백). 공통 열린질문: 코팅 3원천 CONFLICT(BATCH-3)·연당가 원가 저장처(§4-B)·형상 저장 모델(058 옵션값 vs 066 siz_nm)·조각수 저장처(OM-7).

## 4) 양면(defect) 노드 = 연당가/사이즈 재적재 워크리스트 (실무진+인간 승인 대기)
어느 쪽도 삭제 금지·current_value(라이브 현재값) vs authority_value(260702 권위) 양면 보존. 스티커 defect 6:
- `matcost-053-white-backing` — 투명스티커(백색후지 MAT_000371) 원가: 라이브 미저장 vs 260702 연당가 149,500·국4절 499·평량 50 [price-diff 전사]
- `matcost-053-clear-backing` — 투명스티커(투명후지 MAT_000372) 원가: 코드만 mint vs 260702 신규행 연당가 222,000·국4절 740
- `matcost-054-hologram` — 홀로그램 원가: 라이브 미저장 vs 260702 연당가 253,700·국4절 846
- `material-MAT_000162` — 투명스티커: 현재값 명'투명스티커'/평량105/원가미저장 vs 권위 '투명스티커(백색후지)'/평량50/연당가149,500
- `material-MAT_000372` — 투명스티커(투명후지): 코드만 존재 vs 권위 신규행 연당가222,000
- `size-SIZ_000170` — A5 148x210: current junction 활성·단가행 실재(견적 가능) vs authority master del_yn=Y(2026-06-17·A5 재키잉 정리)
- ★false-defect 방지: 완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경 → dual 금지(원가/속성 축만 defect·pack §4-D). 052/055/057/059/060/061/064/065/066/067 소재는 260702 substantive 연당가 변경 교집합 0 = clean(dual 없음).

## 5) 전사·산출물
- 이관 스크립트: `_meta/scripts/consolidate_sticker_axes.py` (재실행 멱등)
- 정본 수정: axis/{categories,sizes,materials,processes,plate-sizes}.md·formula/{sticker-formulas,sticker-components}.md(신규)·index.md·rule/gaps.md·16 product companion(-nodes) 및 product-047(중복 블록 제거)·sticker-spec-rectangle.md(id)
- 그래프 산출: `04_graph/nodes.jsonl`·`edges.jsonl`·`graph.db` · 빌드 리포트 `05_verification/build-report-20260703.md`

## 6) BLOCKED / 후속 (내 레인 밖)
- 연당가 재적재 실 COMMIT = 실무진 답변(원가 저장처 신설 여부) + 인간 승인(§4-D 돈-크리티컬).
- 코팅 CONFLICT·형상 저장 모델·조각수 저장처 = 실무진(Q-ST-A/C) + §31 제약/모델링.
- 옵션참조 매달림(052/053/055 cut-optref)·A5 사이즈 재키잉 = 라이브 교정(개발·인간 승인 후 dbmap).
- 검증은 별도 레인(okb-adversarial-gate) — 본 리포트는 생성 산출이며 자기 승인 아님.
