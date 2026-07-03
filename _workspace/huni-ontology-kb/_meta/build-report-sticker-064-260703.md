# 구축 리포트 — 소량자유형스티커 (PRD_000064) · 2026-07-03

> okb-knowledge-builder · 스티커 파일럿 상품군. 입력=`01_curation/pack-sticker.md`·
> live-snapshot 20260702_1119·260702 diff. 정본=`03_kb/product/sticker-smallqty-freeform.md`
> (+ companion `-nodes.md`). 전사 스크립트=`_meta/scripts/transcribe_product_064.py`(멱등·md5 검증·손전사 0).

## 산출 노드 (10개 신설 — 전량 라이브/팩 앵커·출처 5필드·badge)

| 유형 | id | badge | 비고 |
|------|----|-------|------|
| product | sticker-smallqty-freeform | verified | PRD_000064·완제품 단일·★use_yn=N(미출시) |
| size | size-SIZ_000061/062/063/064/065 | verified | 소형반칼 50x70~65x65(064만 사용·신설) |
| bundle_qty | qty-064 | verified | 32/1000/32·bundle_qtys 0행 정상 |
| gap | gap-064-cpq-missing | unknown | CPQ 옵션 레이어 0/0/0(BATCH-6) |
| gap | gap-064-coating-conflict | unknown | 코팅=자재(155/156) material-only·Q9 상충 |
| gap | gap-064-liandan-out-of-scope | unknown | 064 소재 연당가 clean·워크리스트 포인터 |

## 재사용 노드 (재-mint 없음·L-3 중복 회피·053 패턴) — needed_shared_nodes 참조만
피어 companion/axis에 이미 실재하는 스티커 공유 노드를 참조만 하고 재정의하지 않았다:
- category-CAT_000002 / CAT_000309 (052 companion 정의)
- material-MAT_000153 / MAT_000084 / MAT_000242 / MAT_000155 / MAT_000156 (spec-rectangle-nodes 정의)
- process-PROC_000054 (halfcut-hologram-nodes 정의)
- plate-OUTPUT_PAPER_TYPE_02 (052 companion 정의)
- printopt-POPT_000001 (axis/print-options)
- formula-PRF_STK_FIXED / component-COMP_STK_PRINT (다수 정의)
- size-SIZ_000043 (product-045-header-tag) / size-SIZ_000036 (product-043-bg-opp)

## 가격 경로 (연결됨)
`sticker-smallqty-freeform --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
완제품가 룩업(원자합산 아님). ★**064 활성 35조합(siz×mat=7×5) 전부 단가행 실재**(조합당 36 수량구간행·
전사표 행수요약 35/35·D-22 접기). **끊긴 가격사슬 0·고아 공식 0**(O5·O6 PASS). ★미출시(use_yn=N)임에도
가격 격자는 완전 충전 — 견적 산출 자체는 가능(막는 것은 CPQ UI 부재).

## 양면(defect) 노드 = 0
- 052의 A5(SIZ_000170) 같은 junction-vs-master 사이즈 defect 없음(064 사이즈 master del_yn 전행 N).
- ★연당가 양면 노드 = **0** — 064 소재(유포153·비코팅084·미색242·무광코팅155·유광코팅156)는 260702
  substantive 연당가 변경 4소재(투명/홀로/크라프트/투명후지) 밖(전사표 "연당가 대조" 전행 NO). 완제품가
  (COMP_STK_PRINT)도 260702 무변경 → **retail dual 금지(false-defect 방지·팩 §4-D)**. 정직한 dual=0.

## GAP 목록 = 3 (정직 선언)
- gap-064-cpq-missing — CPQ 옵션 레이어 전면 부재(option_groups/options/option_items 0/0/0·BATCH-6·
  GAP-ST-6). 052 옵션 3그룹 구조가 동형 적재 청사진. 지어낸 옵션 노드 mint 안 함.
- gap-064-coating-conflict — 코팅=자재(무광155·유광156) material-only(052와 달리 라미공정 014/015 없음)
  vs Q9 공정 권위 상충(BATCH-3·미해소·단정 금지·양면 기록). 064는 공정측 부재라 이중가산 위험 없음이 관찰점.
- gap-064-liandan-out-of-scope — 064 소재 연당가 clean·진짜 워크리스트(투명/홀로/크라프트/투명후지)는
  053/063 등의 matcost-053-* 몫이라는 포인터.

## 연당가 판정 (돈-크리티컬·팩 §4)
- **064 소재 = 260702 substantive 연당가 변경 대상 아님**(전사표 "연당가 대조" 전행 NO·N2 라벨/무변).
- COMP_PAPER에 064 소재 0행(연당가 원가 미저장)·완제품가 260702 무변경 → **dual_nodes=0**(false-defect
  방지). 진짜 연당가 양면 워크리스트는 투명 베이스 스티커(053 matcost-053-white-backing/clear-backing 등)
  몫 → gap-064-liandan-out-of-scope 포인터.

## 라이브 신사실 (위키·round-13에 없던 live-snapshot 20260702_1119 실측)
- **use_yn=N 미출시**(063과 함께 스티커 16 중 비활성 2종·팩 §1.1 정합).
- **PARENT 자재코드 유지**(153/084/242/155/156) — 052의 자식코드 재키잉(584/585/586/609/611) 미반영
  (미출시라 재적재 미진행 관찰·재적재 시 자식코드 정합 확인 필요).
- **커팅 PROC_000054 미이관** — 052는 PROC_000122로 이관, 064는 구 PROC_000054(반칼) 그대로 활성(mand=N).
- **CPQ 0행**·**plate 파일사양 7행 06-30 정리**(SIZ_000521 46전지 단일 활성).
- **소량 수량대**(32/1000/32·052의 8/10000/8보다 좁음 = "소량" 상품명 정합)·**editor_yn=Y**(052는 N).
- **MAT_000084 유형 드리프트 관찰:** mat_typ_cd=MAT_TYPE.13인데 note는 .11 선언(팩 §3.5 정답 .11). 공유
  노드(spec-rectangle candidate·065 gap-065-material-type-label과 공유) 소관 — 064는 재정의 없이 관찰 인계.

## needed_shared_nodes (공유 축 승격 대상 — 공유 파일 미수정)
064 전용 신설 소형 사이즈 5(SIZ_000061~065)는 향후 소형 스티커군이 공유할 수 있어 승격 후보. 재사용한
스티커 공유 노드(category/material/process/plate/formula/component/043·036 size)는 이미 052/053/spec-*가
needed_shared로 반환한 것과 동일 집합 → 공유축 consolidation 패스에서 axis/·formula/로 승격 대상.

## 빌드 무결성 (내 파일 국한)
- **064 내부 하드 위반 = 0** — L-1(파일명↔id: `sticker-smallqty-freeform` == 파일명, 053 패턴 준수) PASS·
  끊긴 링크 0(27 out-edge 전량 resolve)·L-3 중복 0(재-mint 없이 참조만)·O5(priced_by≥1) PASS·O6(공식
  has_component≥1) PASS·L-10(gap 3필드) PASS.
- 소프트: L-12 qty 스칼라 3건=lint-allow 태그 처리·L-16 없음(전 수치표 transcribed-by 마커)·O4(index
  미등재)=index.md 공유 파일 수정 금지(HARD)에 따라 index_entries 반환→통합 단계 등재 소관.
- 전역 빌드 hard(26)는 병렬 스티커 빌더 공유노드 중복/미정의 로컬노드+통합 dedup 소관(064 무관·격리 검증 통과).
- 빌드 멱등: 재실행 hash 동일(nodes=55b67c7593607ef2·edges=200415e309deaf0c).

## BLOCKED = 0
스키마(v1.0.1) 밖 유형/관계 불요 — 전 축이 기존 17유형·19관계로 표현됨.
