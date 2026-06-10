# 스티커 — 외부 갭헌팅 보드 (round-12 P2)

> **작성** 2026-06-10 · round-12. **목적은 답습이 아니라 "후니 시트·스키마에 없는 속성 축"의 적발**이다. 국내외 경쟁사·표준이 스티커를 어떤 축으로 파는가를 조사해, 후니가 놓칠 우려가 있는 축만 갭으로 등록하고 각 갭에 **처분**(매핑 수정 / DDL 제안 / 무시+사유)을 단다.
>
> **재사용 우선:** 기존 KB(`07_domain/benchmark-competitors.md` §2 형상·§3 묶음/조각수, RedPrinting 역공학 s2-sticker-capture, WowPress catalog 40017 도무송)를 먼저 재사용 — 중복 크롤 안 함. 신규 WebSearch는 KB가 다루지 않은 "판매 속성 축"(컷/재질/접착/포맷/마감 기능)만 1건 수행.

---

## 0. 조사 대상 인벤토리

| 풀 | 대상 | 출처 | 신규 크롤 |
|----|------|------|:--:|
| 국내 | RedPrinting(원형/사각/도무송 productCode·THO_DFT 모양 17~37종)·WowPress(40017 도무송 non_standard sizeNo) | `07_domain/benchmark-competitors.md` §2·§3, RP 역공학 s2-sticker-capture, WP catalog | 재사용(0) |
| 해외 | StickerYou·StickerGiant·Sticky Brand·CarStickers·Jukebox·Stickerbeat·PrintRunner·ChinaPrinting4u | WebSearch 1건(신규) | 1건 |
| 표준 | CIP4 JDF/XJDF(CuttingParams·자재 Media), ISO 12647(품질) | KB 인용 | 재사용(0) |

---

## 1. 후니가 이미 흡수한 축 (갭 아님 — 답습 불요)

| 경쟁사/표준 축 | 후니 대응 | 결론 |
|----------------|-----------|------|
| **컷 방식**(die cut / kiss cut) | PROC_000053 완칼·054 반칼·055 스티커완칼(root 공정 분리) | **흡수·우위** — RP는 productCode 분기, 후니는 공정 분리로 더 명확(benchmark §2) |
| **형상/모양**(원형/정사각/직사각 enum) | 합판도무송=size(칼틀 1:1, Q7)·규격형=공정 param 자리 | **흡수** — RP의 PCS+shape_info 2중, WP의 non_standard 플래그보다 명확(benchmark §57) |
| **조각수**(N개/시트) | PROC_000054/055 prcs_dtl_opt.조각수 + bundle_qty(Q8) | **흡수·우위** — RP/WP 명시 슬롯 없음(가격표 흡수, benchmark §102) |
| **화이트 underbase**(투명 인쇄) | PROC_000008 화이트 별색(공정) | **흡수** — RP "별색=PCS/도수 혼재"보다 일관(benchmark §159) |
| **CIP4 CuttingParams / Media** | 공정 prcs_dtl_opt + 자재 t_mat_materials | 표준 모델과 동형 — 신규 축 없음 |

## 2. 발견한 갭 (후니 시트·스키마에 명시 없는 축)

| ID | 갭(축) | 출처 | 후니 영향 | 처분·근거 |
|----|--------|------|-----------|-----------|
| **G-EX-1** | **접착 영구/제거형**(permanent / removable adhesive) — 해외 표준 판매 축(vinyl permanent 3~5y vs removable 1~3y) | StickerYou·StickerGiant·Sticky Brand(WebSearch) | **무시(이미 자재로 흡수)** | 후니는 **수분리스티커(MAT_000161=removable/제거형)**를 별 자재로 보유(라이브 실측). 접착 유형이 자재명에 내장 = 후니 모델로 충분. 별 속성 축 신설 불요. 단 엑셀 스티커 시트엔 수분리스티커가 자재로 노출 안 됨(C16 12종에 미포함) → 시트 자재 목록 확인 권고(매핑 영향 없음) |
| **G-EX-2** | **롤(roll) 포맷** — kiss cut sticker는 해외서 "롤 마감"이 표준 대량 포맷 | StickerGiant·Stickerbeat(WebSearch) | **무시(후니 미운영)** | 후니 스티커는 낱장/시트/스티커팩만(엑셀 C25 조각수·스티커팩=시트째). 롤 포맷 상품 없음(라이브 16상품 어디에도 롤 없음). 후니 운영 사실 우선 — 미운영 축은 신설 불요. 향후 롤 도입 시 재검토 |
| **G-EX-3** | **마감 기능 속성**(방수/UV/스크래치 저항) — 해외서 라미네이션의 판매 소구점 | StickerYou·PrintRunner(WebSearch) | **무시(가공 결과 속성)** | 방수/UV는 코팅·자재(BOPP 등)의 **결과 속성**이지 독립 선택 축 아님. 후니는 코팅(Q9 공정)·자재(유포=내수성)로 표현. 별 속성 축 불요. 마케팅 표기는 견적 밖 |
| **G-EX-4** | **캐스케이드 제약**(자재/사이즈 → 특정 가공 disable) — RP `disable_pcs_info`·WP `rst_awkjob` 둘 다 보유 | benchmark §126(기존 KB) | **DDL/L2 제안(기존 권고 재확인)** | 후니 `constraint_json`이 전 상품 미연결(OM-6). 스티커도 자재→커팅/별색 제약(예 투명전용지→화이트별색 필수)을 데이터로 표현하면 위젯 캐스케이드 정확. **신규 갭 아님** — benchmark가 이미 High 권고, round-6 CPQ/dbm-cpq-option-mapping 트랙으로 라우팅. 본 매핑(L1) 범위 밖 |

## 3. 표준(CIP4/ISO) 점검 — 갭 없음

- **CIP4 JDF/XJDF**: 스티커 커팅은 `Cutting`/`DieCutting` process + `CutBlock`/`Shape` 리소스로 모델링. 후니의 공정(완칼/반칼/스티커완칼) + prcs_dtl_opt(모양·조각수)가 동형 표현. 자재는 `Media`(후니 t_mat_materials)와 대응. **신규 축 없음.**
- **ISO 12647**(인쇄 품질): 색재현 표준 — 견적/상품 구성 데이터 축 아님. 무관.

> 조사했고 **표준 측 신규 갭 0**.

## 4. 종합 처분 분포

- **매핑 수정**: 0건(외부 갭이 L1 매핑을 바꾼 것 없음 — 후니가 이미 흡수).
- **DDL/L2 제안 라우팅**: 1건(G-EX-4 캐스케이드 제약 — 기존 benchmark 권고 재확인, round-6 CPQ 트랙).
- **무시+사유**: 3건(G-EX-1 자재 흡수·G-EX-2 미운영·G-EX-3 결과속성).
- **결론**: 외부 갭헌팅이 스티커 L1 매핑을 바꾸지 않는다. 후니 스키마는 스티커 판매 속성 축에서 경쟁사·표준을 흡수·우위(benchmark 통찰 재확인). 실 결함은 "스키마 부재"가 아니라 "엑셀 옵션→상품 연결행 미적재"(GAP-PARAM·조각수 미적재) — 이는 내부 권위(라이브 실측)에서 다룸.

---

## Sources

- **기존 KB(재사용):** `_workspace/huni-dbmap/07_domain/benchmark-competitors.md` §2(형상 L41~60)·§3/§4(묶음·조각수 L87~104)·§3.X(캐스케이드 제약 L126)·요약표(L175~177). RedPrinting 역공학 `_workspace/huni-widget/01_reverse/s2-sticker-capture.md`(THO_DFT 모양커팅). WowPress catalog 40017(도무송 non_standard).
- **신규 WebSearch(1건, 2026-06-10):**
  - [StickerYou — Custom Die-Cut Vinyl Stickers](https://www.stickeryou.com/products/die-cut-stickers/623)
  - [StickerGiant — Die Cut / Kiss Cut Stickers](https://www.stickergiant.com/kiss-cut-stickers)
  - [Sticky Brand — Custom Kiss Cut Stickers](https://thestickybrand.com/products/kiss-cut-stickers)
  - [CarStickers — Custom Die Cut Stickers](https://www.carstickers.com/products/stickers/custom-stickers/setup/die-cut-stickers/)
  - [PrintRunner — Custom Die-Cut Stickers](https://www.printrunner.com/die-cut-stickers.html)
  - [Stickerbeat — Kiss-Cut Stickers](https://stickerbeat.com/shop/stickers/kiss-cut)
  - [ChinaPrinting4u — Die Cut vs Kiss Cut Stickers 2025](https://www.chinaprinting4u.com/blog/die-cut-vs-kiss-cut-stickers)
- **표준:** CIP4 JDF/XJDF(DieCutting/Cutting·Media·CutBlock — 일반 지식), ISO 12647.
