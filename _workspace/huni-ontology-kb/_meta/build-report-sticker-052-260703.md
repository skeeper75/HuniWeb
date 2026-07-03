# 구축 리포트 — 반칼 자유형 스티커 (PRD_000052) · 2026-07-03

> okb-knowledge-builder · 스티커 파일럿 2번째 상품군 첫 상품. 입력=`01_curation/pack-sticker.md`·
> live-snapshot 20260702_1119·260702 diff. 정본=`03_kb/product/product-052-sticker-halfcut-freeform.md`
> (+ companion `-nodes.md`). 전사 스크립트=`_meta/scripts/transcribe_product_052.py`(멱등·손전사 0).

## 산출 노드 (22개 — 전량 라이브/팩 앵커·출처 5필드·badge)

| 유형 | id | badge | 비고 |
|------|----|-------|------|
| product | product-052-sticker-halfcut-freeform | verified | PRD_000052·완제품 단일·use_yn=Y |
| category | category-CAT_000002 / category-CAT_000309 | verified | 스티커 root·자유형스티커(needed_shared) |
| size | size-SIZ_000057 / size-SIZ_000520 | verified | A6·A4반칼(needed_shared) |
| size | **size-SIZ_000170** | **defect(양면)** | A5·junction 활성 vs master del_yn=Y |
| material | MAT_000584/585/586/609/611 | verified | 유포/무광코팅/유광코팅/미색/아트·MAT_TYPE.11 |
| process | process-PROC_000122 | verified | 반칼커팅(구 PROC_000054 이관) |
| plate_size | plate-OUTPUT_PAPER_TYPE_02 | verified | 46계열 표준전지(SIZ_000521) |
| bundle_qty | qty-052 | verified | 8/10000/8·bundle_qtys 0행 정상 |
| price_formula | formula-PRF_STK_FIXED | verified | 완제품가 고정가 룩업(needed_shared) |
| price_component | component-COMP_STK_PRINT | verified | use_dims=[siz_cd,mat_cd,min_qty](needed_shared) |
| option_group | optgroup-052-paper / -print | verified | 종이(5자재)·인쇄(단면) 정합 |
| option_group | optgroup-052-cut | candidate | 반칼·option_refs 매달림(gap) |
| gap | gap-052-coating-conflict | unknown | 코팅 자재 vs 공정 미해소 |
| gap | gap-052-cut-optref-dangling | unknown | OPV_000023→PROC_000054(삭제) |
| gap | gap-052-liandan-out-of-scope | unknown | 052 연당가 clean·워크리스트 포인터 |

## 가격 경로 (연결됨)
`product-052 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
완제품가 룩업(원자합산 아님). 052 활성 15조합(siz×mat) 전부 단가행 실재(조합당 36 수량구간행·
전사표 행수요약·D-22 접기). **끊긴 가격사슬 0·고아 공식 0**.

## 양면(defect) 노드 = 1
- **size-SIZ_000170** — current=junction 활성+priced / authority=master 논리삭제(del_yn=Y). A5 재키잉
  정리 워크리스트(어느 쪽도 삭제 금지).

## GAP 목록 = 3 (정직 선언)
- gap-052-coating-conflict (BATCH-3·Q-ST-A·양면 자재/공정·단정 금지)
- gap-052-cut-optref-dangling (fn_chk_opt_item_ref·PROC_000054 매달림)
- gap-052-liandan-out-of-scope (052 소재 연당가 clean·진짜 워크리스트=투명/홀로/크라프트/투명후지→063 등)

## 연당가 판정 (돈-크리티컬·팩 §4)
- **052 소재(유포/아트/미색/무광코팅/유광코팅) = 260702 substantive 연당가 변경 대상 아님**
  (전사표 "연당가 대조" 전행 NO·N2 라벨/무변). COMP_PAPER 0행(연당가 원가 미저장)·완제품가 260702 무변경.
  ⇒ **retail dual 금지(false-defect 방지)**. 진짜 연당가 양면 워크리스트(투명 149,500/홀로 253,700/
  크라프트 81,500/투명후지 222,000)는 투명 베이스 스티커(063 등) 몫 → gap-052-liandan-out-of-scope 포인터.

## needed_shared_nodes (공유 축 승격 대상 — 공유 파일 미수정)
스티커 첫 상품이라 스티커 공유 축을 companion에 local mint. 아래는 16 스티커가 공유하는 축 →
공유 통합(consolidation) 패스에서 axis/·formula/로 승격 대상:
category-CAT_000002·CAT_000309 · size-SIZ_000057·SIZ_000520·SIZ_000170 ·
material-MAT_000584/585/586/609/611 · process-PROC_000122 · plate-OUTPUT_PAPER_TYPE_02 ·
formula-PRF_STK_FIXED · component-COMP_STK_PRINT.

## 빌드 무결성 (내 파일 국한)
- **052 내부 하드 위반 = 0** — 끊긴 링크 0·고아 0·L-18(option_refs 부모정합) PASS·O5(priced_by≥1) PASS·
  O6(has_component≥1) PASS·L-9(defect 양면 필드) PASS·L-10(gap 3필드) PASS.
- ★전역 빌드 hard=45는 **병렬 스티커 빌더(053/055/057/circle/rectangle/square) 동시 mint에 의한 L-3
  공유노드 중복**(PRF_STK_FIXED·COMP_STK_PRINT·CAT_000002·size/material 등) + 047(SIZ_000170) 기존
  충돌. 052 단독 결함 아님 — **스티커 공유축 consolidation 패스 대기**(디지털 파일럿 "공유축 통합 260703"과 동형).
  공유/피어 파일 수정 금지 규칙에 따라 이 빌더는 수정하지 않고 needed_shared_nodes로 반환.
- L-12 소프트(raw 수량 8/10000/8 등)는 기존 36 디지털 상품과 동일 패턴(단일 스칼라·src 명시)·빌드 무중단.

## BLOCKED = 0
스키마(v1.0.1) 밖 유형/관계 불요 — 전 축이 기존 17유형·19관계로 표현됨.
