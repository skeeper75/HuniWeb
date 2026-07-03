# 결함 보드 — 스티커 그래프 무결성 + 명명·공유노드 단일성 (2026-07-03)

> 배정 축: ① build_graph 멱등·하드0 ② 공유노드 단일소유권 ③ 파일명 비일관→dead-link ④ jsonl↔SQLite↔정본.
> 생성자·리포트 비신뢰 — 전 판정 직접 재실측(build 3회 실행·결정론 스크립트). 대상 652노드/2124엣지·스키마 v1.0.1.
> 재현 스크립트: `05_verification/scripts/sticker_naming_deadlink_260703.py`(신규)·`build_graph.py --idem`.

## 판정 요약

| 축 | 검사 | 결과 | 근거 |
|----|------|------|------|
| ① 그래프 무결성 | build 2회+--idem | **PASS** | 652/2124·hard=0·soft=313·2회 바이트동일(nodes=954f899645a87062·edges=6c864143cd246e9e)·--idem True |
| ② 공유노드 단일소유권 | 6개 명명 공유노드 | **PASS** | 각 단일 정본노드·로컬 재선언 0·중복 anchor 스캔 미출현·다상품 backlink 실재 |
| ③ 명명 비일관→dead-link | index/라우팅 | **NO-GO** | index.md 실 dead-link 1건(404)·노드ID 명명 분열 5:11·O4 부분문자열 false-negative |
| ④ jsonl↔SQLite↔정본 | 대응 | **PASS** | 652=652·2124=2124·차집합0·중복edge0·16상품 전원 SQLite·source 964행 |

전체: **CONDITIONAL** — 무결성 코어(①②④) GO, 명명/dead-link(③)만 builder 교정 필요. 단일 FAIL=NO-GO 원칙상 게이트는 미통과.

## 결함

### D-STK-1 [Medium·라우팅] index.md dead-link — 존재하지 않는 파일 링크
- 노드/파일: `product-059-sticker-spec-square`(PRD_000059) · index.md L112
- 축: ③ 명명 비일관
- 증거: index.md L112 = `[product/product-059-sticker-spec-square.md](product/product-059-sticker-spec-square.md)` — 이 파일 **비존재**. 실제 파일 = `product/sticker-spec-square.md`. `ls product/product-059-sticker-spec-square.md` → No such file. dead-link 스캔: index .md 링크 106건 중 dead 1건(이것 유일).
- 근본원인: 059 파일이 sticker-slug 규칙(`sticker-spec-square.md`)으로 명명됐으나, 파일 내 블록노드 id는 product-NNN 규칙(`product-059-sticker-spec-square`)으로 유지 → index 집필 시 노드ID로 파일링크를 구성해 실파일명과 어긋남.
- 교정: index.md L112 링크 target/text를 `product/sticker-spec-square.md`로 교정. (또는 파일을 `product-059-sticker-spec-square.md`로 rename하여 규칙 통일.)
- 라우팅: **builder**(index.md 교정) + 규칙 통일은 architect 판단.

### D-STK-2 [Medium·라우팅] 스티커 노드ID 명명 2규칙 분열 — 061 index 노드ID 라우팅 갭
- 노드: 스티커 16상품 노드ID — product-NNN 규칙 5개(052/055/057/059/061) vs sticker-slug 규칙 11개(053/054/056/058/060/062~067)
- 축: ③
- 증거: `product-061-band-sticker`(파일 `sticker-spec-band.md`) — 파일링크는 index에 정상 존재(L114)이나 **노드ID 문자열은 index 미등재**(id_in_idx=False). 노드ID로 라우팅하는 질의는 index에서 061을 못 찾음(파일링크 경유는 가능). 형제 060/062는 sticker-slug ID라 파일명과 일치. 파일명 분포도 분열(product-NNN 3 : sticker-slug 13).
- 반증 시도: 그래프 자체는 정합(노드ID로 SQLite/jsonl 조회 시 16상품 전원 해결·차집합0) → **그래프 무결성 결함 아님**. 영향은 index/질의 라우팅 계층에 한정.
- 교정: 스티커 코호트 명명 1규칙으로 통일(product-NNN 권장 — 디지털인쇄 016~051과 동형). 059/061 노드ID를 sticker-slug로 내리거나, 파일/index를 product-NNN로 올려 3계층(파일명·노드ID·index) 정렬.
- 라우팅: **architect**(명명 규칙 정본) → **builder**(일괄 rename+index 재생성).

### D-STK-3 [Low·검증도구] build O4 부분문자열 검사가 dead-link 은폐(false-negative)
- 위치: `build_graph.py` O4 index 등재 검사(L457-459)
- 축: ③(부수) / ④(검증 신뢰)
- 증거: O4는 `os.path.basename(file_path) in idx` 부분문자열 매칭. `"sticker-spec-square.md"`가 dead-link 텍스트 `"product-059-sticker-spec-square.md"`의 부분문자열이라 O4가 059를 "등재됨"으로 통과 → 실제 404 링크를 못 잡음. 즉 D-STK-1을 builder 리포트가 조용히 놓쳤다(생성자 리포트 비신뢰 원칙 실증).
- 교정: O4를 부분문자열이 아닌 링크 target 파일 실재 검사로 강화(본 라운드 신규 스크립트 방식 채택). 
- 라우팅: **architect**(graph-build-spec O4 강화) / builder 재구현.

### D-STK-4 [Low·거버넌스] 공유 process 노드가 product-local 파일에 소유됨
- 노드: `process-PROC_000008`(반칼/화이트 언더베이스) — 소유 파일 `product/product-020-white-print-postcard-nodes.md`
- 축: ②
- 증거: PROC_000008은 11개 참조원(product 020/025/040 + 스티커 053/054/056/062 등)이 공유하는 횡단 노드인데, axis/processes.md가 아닌 product-020 노드파일에 선언. 형제 PROC_000122는 axis/processes.md 소유(정상). 단일소유권·dedup은 정상이나 소유 **위치**가 취약(020 파일 rename/삭제 시 공유노드 소실).
- 교정: PROC_000008을 axis/processes.md로 승격 이관(needed_shared_nodes 반환 패턴). 
- 라우팅: **curator/builder**(축 승격).

### D-STK-5 [Low·위생] 루트 잔여 graph.db(0바이트)
- 위치: `_workspace/huni-ontology-kb/graph.db`(0 bytes) vs 정본 `04_graph/graph.db`(1,032,192 bytes)
- 축: ④
- 증거: KB 루트에 빈 graph.db 존재. 질의 게이트가 경로 오지정 시 빈 DB를 열어 조용한 0결과 위험.
- 교정: 루트 graph.db 삭제 또는 .gitignore/문서에 정본 경로(`04_graph/graph.db`) 명시.
- 라우팅: **builder**(정리).

## 검증 범위·한계 (정직 선언)
- ①②④는 **전수**(스크립트 결정론 대조·652/2124 전체). ③ dead-link는 index.md 마크다운 링크 106건 전수 + 스티커 16상품 노드ID/파일 전수.
- **미검증(범위 밖·타 축 배정)**: 출처 실재성 원문 왜곡(축1)·권위 260702 수치 diff(축2)·오염 STALE/양면표기(축3)·가격 evaluate_price 실측(축6). 본 라운드는 그래프 무결성+명명+공유노드 단일성에 한정.
- L-17 앵커 실재(닫힌세계)는 build hard=0에 포함되어 통과 — 16 스티커 상품 anchor + 6 공유노드 anchor 실재 확인(간접). 원천 CSV 직접 열람은 축1 검증자 몫.
- "무결" 단정 안 함: ③에 실 dead-link 존재 → 게이트 NO-GO. builder 5건 교정 후 재검증 대상은 D-STK-1(필수)·D-STK-2(권장).
