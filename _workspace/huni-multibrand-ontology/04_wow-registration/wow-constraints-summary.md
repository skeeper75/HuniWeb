# 와우프레스 전 제약 그래프 등록 — 요약 (2026-07-05)

> catalog 326상품 결정론 전사·앵커=catalog:products/<id>.json#raw.prod_info · 생성≠검증·값 지어내기 0

> 현 2종(paper.rst_prsjob·color.req_prsjob) → 전 유형 확장. 원천/wow-components.json 무손상.

## 규모

- 노드→노드 제약 엣지(dedup): **19927** (feasibility 그래프)
- 값-규칙 제약(dedup): **1065**
- GAP 엣지(to_node 미등록 구성요소): 80

## ① 노드→노드 엣지 — 유형(rel)별 엣지수

| rel | kind | 엣지수 |
|---|---|---|
| req_awkjob | req | 6972 |
| rst_awkjob | rst | 6942 |
| rst_paper | rst | 5546 |
| rst_prsjob | rst | 186 |
| req_color | req | 141 |
| req_prsjob | req | 140 |

## ② 값-규칙 — 유형(rel)별 규칙수

| rel | kind | 규칙수 |
|---|---|---|
| rst_jobqty | rst | 493 |
| rst_size | rst | 416 |
| req_height | req | 58 |
| req_width | req | 57 |
| rst_ordqty | rst | 19 |
| rst_cutcnt | rst | 10 |
| req_jobsize | req | 7 |
| req_joboption | req | 5 |

## 공유 상위 — 가장 많은 상품이 공유하는 제약 엣지 (used_by 상위 15)

- `prsjob:3120 -req_color-> color:255` — 45개 상품
- `color:255 -req_prsjob-> prsjob:3120` — 45개 상품
- `prsjob:3120 -req_color-> color:302` — 36개 상품
- `color:302 -req_prsjob-> prsjob:3120` — 36개 상품
- `prsjob:3120 -req_color-> color:256` — 34개 상품
- `color:256 -req_prsjob-> prsjob:3120` — 34개 상품
- `paper:22927 -rst_prsjob-> prsjob:3230` — 32개 상품
- `paper:20246 -rst_prsjob-> prsjob:3230` — 26개 상품
- `prsjob:3110 -req_color-> color:255` — 25개 상품
- `color:255 -req_prsjob-> prsjob:3110` — 25개 상품
- `paper:20239 -rst_prsjob-> prsjob:3230` — 25개 상품
- `paper:22930 -rst_prsjob-> prsjob:3230` — 24개 상품
- `paper:21218 -rst_prsjob-> prsjob:3230` — 21개 상품
- `prsjob:3110 -req_color-> color:256` — 20개 상품
- `color:256 -req_prsjob-> prsjob:3110` — 20개 상품

## GAP — to_node가 등록 구성요소에 없는 엣지 (상위 15)

- `prsjob:3110 -req_color-> color:257` — 3개 상품
- `prsjob:3110 -req_color-> color:258` — 3개 상품
- `prsjob:3130 -req_color-> color:257` — 2개 상품
- `prsjob:3130 -req_color-> color:259` — 2개 상품
- `prsjob:3110 -req_color-> color:259` — 2개 상품
- `prsjob:3110 -req_color-> color:260` — 2개 상품
- `prsjob:3110 -req_color-> color:1333` — 1개 상품
- `prsjob:3110 -req_color-> color:1334` — 1개 상품
- `color:240 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:237 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:1477 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:242 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:241 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:238 -req_prsjob-> prsjob:3240` — 1개 상품
- `color:1476 -req_prsjob-> prsjob:3240` — 1개 상품

(총 80 GAP 엣지. 대상 노드=선택 구성요소 아님/제약 전용 참조. 조사 대상.)