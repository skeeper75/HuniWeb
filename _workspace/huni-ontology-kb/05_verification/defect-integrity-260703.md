# 결함 보드 — 그래프 무결성·스키마 정합 (검증 라운드 1) — 2026-07-03

> 검증가: okb-adversarial-verifier · 배정 축: ④그래프 무결성 직접 재실행 + 스키마 정합
> 원칙: 빌더 리포트 비신뢰 — 전부 직접 재실측. 기계 대조 스크립트=`05_verification/scripts/audit_integrity_260703.py`.

## 재실측으로 통과한 것 (반증 실패 = 생존)

- **멱등성(I-5)**: `build_graph.py`를 독립적으로 2회 실행(--idem 플래그 안 믿고 직접 shasum). nodes.jsonl·edges.jsonl 해시 동일. `nodes=19f68f67…`, `edges=dd5c139f…`. 비결정 요소 없음.
- **하드 위반 0**: I-1 고아(하드 유형 product/formula/component)·I-2 끊긴 링크·I-3 타입 위반·I-4 필수 엣지(O5/O6) 전부 0. 직접 재계산으로 확인.
- **L-17 앵커 실재검사 작동**: t_*/코드 앵커 노드 162개 전부 live-snapshot(36 테이블) 대조 — 스킵 0. 닫힌 세계 환각 차단이 실제로 돌아감.
- **블록 헤딩 문법**: `### [ID] … {badge}` 패턴에서 badge 누락으로 조용히 스킵된 헤딩 0.
- **정본 수치 오염 없음**: 표본 product frontmatter props에 raw 가격/치수 없음(L-12 실위반 0). 수치표 transcribed-by 마커 14/14(index.md 매니페스트 표 1건은 오탐).
- **그래프-정본 대응**: 노드 204=jsonl=sqlite, source 229=jsonl=sqlite. 그래프에만 있는 날조 사실 0(alias_of 19 투영은 _glossary 정본 유래·설계대로).

## 결함

| ID | 노드/파일 | 축 | 심각도 | 결함 | 라우팅 |
|----|-----------|-----|--------|------|--------|
| V1-01 | build_graph.py / 05_verification/blocklist.md | 오염(3)·그래프무결성(4) | Medium | blocklist.md 부재 → 오염검사 무력 | curator+architect |
| V1-02 | build_graph.py (I-4 §5.4) | 스키마정합(2) | Medium | 명세 하드 규칙 6종 코드 전무(L-18 하드 포함) | architect+builder |
| V1-03 | build_graph.py serialize / edges.jsonl | 그래프무결성(4) | Low-Med | edges.jsonl 425 ≠ SQLite 420(중복 5)·백링크 이중계산 | builder |
| V1-04 | build_graph.py O4 | 스키마정합(2) | Low | O4 index 검사 명세는 하드, 구현은 soft(약화) | architect |
| V1-05 | build-report-20260703.md 비고 | 그래프무결성(4) | Low | 고아 설명 STALE(상품 8개 집필 완료인데 "미집필") | builder |

### V1-01 [Medium] 오염 검사(O2/I-6)가 blocklist.md 부재로 조용히 무력
- **결함**: `load_blocklist()`는 blocklist.md가 없으면 빈 set을 반환한다. 그런데 `05_verification/blocklist.md`가 실재하지 않는다. 결과적으로 모든 노드의 src_id가 무조건 통과 — STALE/v03/환각 인용 차단(검증 하네스의 핵심 방어축 3)이 전혀 실행되지 않는다. 리포트는 "I-6 오염(blocklist): 0"을 PASS처럼 표기해 검사가 돌아간 것처럼 보이게 한다(빌더 리포트 비신뢰 실증).
- **증거**: `ls 05_verification/blocklist.md` → No such file. 코드 `def load_blocklist(): if not os.path.exists(BLOCKLIST): return set()`. 리포트 라인 `- I-6 오염(blocklist): 0`.
- **교정**: (a) curator가 STALE 금지 목록(source-registry 기반)을 blocklist.md로 실체화. (b) builder는 blocklist.md 부재 시 조용한 통과가 아니라 하드 FAIL 또는 큰 소프트 경고를 내도록 수정("검사 원천 없음"을 PASS로 위장 금지).

### V1-02 [Medium] 명세 24 lint 규칙 중 6종이 코드에 전무 (L-18 하드 포함)
- **결함**: graph-build-spec §5·file-format-spec §5는 lint 24종을 명시하나, 코드 grep 결과 L-1(파일명↔id 접두사)·L-12(raw 수치 스캔)·L-13(badge 불일치)·L-16(transcribed 마커)·L-18(option_refs 부모 정합)·O3(위키 DROP 라벨)이 코드에 전무(각 grep=0). 특히 **L-18은 graph-build §5.4 I-4 표에 하드 규칙**으로 등재("option_group | option_refs 타깃이 같은 부모 product에 실재")인데, 빌더의 필수엣지 검사는 product·price_formula만 돌고 option_group은 없다. fn_chk_opt_item_ref 정합(옵션이 부모에 없는 자재를 가리키면 라이브 거부)이 KB에 몰래 들어와도 못 잡는다.
- **증거**: `grep -c 'L-18' build_graph.py` = 0. option_refs 엣지 70개·option_group 29개 실재하나 부모정합 검사 없음. (직접 재구현 실행 결과 현재 데이터 위반 0 — 잠재 위험이지 현행 오류 아님.)
- **교정**: architect가 명세와 구현 정합(어느 규칙이 실제 하드/soft인지 확정)→ builder가 최소 L-18(하드)을 구현. L-12/L-16/O3(오염·날조 방어)은 현재 위반 0이나 회귀 방어용으로 구현 권고.

### V1-03 [Low-Medium] edges.jsonl(425) ≠ SQLite edge(420) — 중복 references 엣지 5개·백링크 이중계산
- **결함**: 본문 `[[ ]]`가 같은 파일에서 같은 대상을 두 번 언급하면 동일한 references 엣지가 2개 생긴다(dedup 없음). edges.jsonl에는 425행이 남고 SQLite는 PK(src,rel,dst)로 420개만 적재 — ⓑ덤프층과 ⓒ질의층 불일치. 리포트는 len(edges)로 "엣지 425"를 과다계상. 파생 backlinks도 이중계산(gap-016-addon-target=동일 backlink 2회, RULE_price_value_boundary=product-043-bg-opp 2회).
- **증거**: `nodes.jsonl/edges.jsonl` 425행, `sqlite3 graph.db 'SELECT count(*) FROM edge'`=420. 중복키 5개 전부 references(product-016→DEC_qty_audit_260702 등). audit_integrity_260703.py §1.
- **교정**: builder가 references 엣지 추가 시 (src,rel,dst) 기준 dedup(또는 serialize 직전 전역 dedup). 리포트 엣지 수는 고유 엣지로 보고.

### V1-04 [Low] O4 index 등재 검사 — 명세는 하드, 구현은 soft
- **결함**: file-format-spec §5.2는 O4(index.md 등재)를 "의미 lint(하드 — 오염 차단)"로 분류하나, 코드는 `soft.append`로 처리(약화). graph-build-spec는 O4를 I-set에 미포함 — 두 명세 자체가 O4 하드/soft를 다르게 말한다.
- **증거**: `grep -n O4 build_graph.py` → 354행 soft.append. file-format §5.2 표는 O4를 하드 섹션에 등재.
- **교정**: architect가 O4를 하드로 할지 soft로 확정하고 두 명세 통일. (soft가 합리적이면 file-format §5.2에서 O4를 soft 섹션으로 이동.)

### V1-05 [Low] 빌드 리포트 고아 설명 STALE
- **결함**: 리포트 비고 "Phase 3 토대: 상품 노드(E1) 미집필 → 축 노드 다수 고아…Phase 4에서 채워진다"는 이미 상품 노드 8개 집필 완료 상태와 모순. 현행 고아 10개(printopt 2·process 4·size 1·GAP_* 3)는 파일럿 8상품이 안 쓰는 축 항목 + floating GAP 3개이지 "Phase 4 대기"가 아님. 리포트를 그대로 믿으면 고아를 정상으로 오판.
- **증거**: 노드 타입 product=8. 고아 목록에 GAP_product_count·GAP_roll_material_price·GAP_transparent019_pansu(어떤 노드도 링크 안 함).
- **교정**: builder가 비고 문구 갱신. floating GAP 3개는 연결 완전성(축 5) 라운드에서 상품 연결 여부 재판정(조용한 고아 gap 방지).

## 검증 범위·한계 (정직 표기)
- 본 라운드는 **그래프 무결성 재실행 + 스키마 정합**만 담당. 출처 실재성(축1)·권위 260702 diff(축2)·오염 실인용(축3 실데이터)·연결 완전성 경로탐색(축5)·가격 실측(축6)은 별도 라운드.
- 멱등·하드위반·앵커검사·문법은 **전수**. 정본 수치 오염(L-12)·transcribed 마커(L-16)는 **표본+스크립트 스캔**(전 파일 1차 표 기준) — 개별 셀 값 정확성은 축2 소관.
- "무결" 단정 아님: 하드 0이나 위 5개 결함(특히 오염검사 무력 V1-01)은 회귀·잠재 위험. blocklist 실체화 전까지 오염 방어는 비활성으로 간주할 것.
