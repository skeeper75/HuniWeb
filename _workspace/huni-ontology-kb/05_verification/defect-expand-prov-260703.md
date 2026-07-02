# 결함 보드 — 배정축 확장(출처 실재성 · 권위 정합 · 오염) 전 36상품

> 작성: 2026-07-03 · okb-adversarial-verifier (독립 재실측 — 생성자 리포트 비신뢰)
> 대상: `03_kb/`(노드 466·엣지 1521·상품 36) · 04_graph 산출 · live-snapshot `snap_20260702_1119`
> 스크립트: `05_verification/scripts/prov_expand_260703.py`(신규·resolver 교정+행 재조회+오염 4종) +
>   기존 `wiring_vs_live.py`·`product_axis_vs_live.py`·`audit_integrity_r2_260703.py` 재실행(전 36상품 자동 스케일)
> 방법: 기계 대조 우선(전수) · 자연어 판단은 의심 노드 표본. **모든 노드=틀렸다 가정 후 반증.**

---

## 0. 판정 요약

| 축 | 전수 대상 | 결함 | 판정 |
|----|-----------|------|------|
| 출처 실재성(A1) | 소스 619·파일 43·live CSV 행 재조회 | **1 (LOW)** | 파일 실재 0결함·행 실재 1건(범위 off-by-one) |
| 권위 정합(A2) | priced_by 39·has_component 23공식·4축×36상품 | 0 | KB-only 0·frm불일치 0·날조엣지 0 |
| 오염(A3) | STALE·구권위·환각·라이브오적재 | 0(KB) · **1 원천** | KB 오염 0·라이브 자체 오적재 1(KB가 정직 defect 표기) |

**결론:** 배정 3축에서 KB 자체 결함 = **LOW 1건**(교정 가능). 라이브 오적재 1건은 KB가 이미 `defect` 배지+GAP로 정직 표기 → **원천(라이브 DB) 컨펌 큐**. 나머지 전 항목 반증 실패(생존). ★범위: 배정 3축 전 36상품 결정론 전수 + 의심 노드 표본 자연어. 그래프 무결성·연결 완전성·종단 질의는 타 검증자 소관(본 보드 밖).

---

## 1. 결함 상세

### D-1 [LOW] optgroup-OPT_000038 source_locator 범위 off-by-one

| 항목 | 내용 |
|------|------|
| 노드 | `optgroup-OPT_000038` (PRD_000029 3단접지카드·박칼라 옵션그룹) |
| 축 | 출처 실재성(A1.2 — live CSV 행 재조회) |
| 결함 | source_locator `opt_cd:OPV_000137~145`의 시작 코드 **OPV_000137이 라이브 어디에도 없음**(t_prd_product_option_items 0행). PRD_000029 옵션아이템은 OPV_000136 → **OPV_000138**로 건너뜀. 실제 박칼라(ref_dim_cd=OPT_REF_DIM.04·PROC_000037~044) 8종 = **OPV_000138~145**. |
| 증거 | `python3 05_verification/scripts/prov_expand_260703.py` → `ROWMISS optgroup-OPT_000038 ... ['OPV_000137']`. 재현: live-snapshot t_prd_product_option_items.csv에서 `OPV_000137 anywhere = NONE`, PRD_000029 실아이템 `OPV_000138~145`(8종·전부 use=Y·del=N) |
| 심각도 | **LOW** — 서술형 locator의 범위 시작값 오기. 의미 주장("박칼라 8종")은 정확·가격 영향 0·엣지/노드 배선 정상(product_axis_vs_live 029 전축 OK). |
| 교정안 | source_locator `OPV_000137~145` → `OPV_000138~145`(8종). |
| 라우팅 | **builder**(locator 문자열 정정) |

### D-2 [원천 컨펌] PRD_000042 굿즈 자재 라이브 오적재 (KB 정직 표기 — 라이브 교정 대상)

| 항목 | 내용 |
|------|------|
| 노드 | `material-MAT_000128/129/240/241`(defect 배지) · `GAP_paper_material_042` · PRD_000042 uses_material/option_refs 엣지 |
| 축 | 오염(A3.4 — 라이브 오적재 verified 표기 위반 여부) |
| 발견 | 프리미엄 쿠폰/상품권(042)에 **비종이 굿즈 자재**가 라이브 활성(del_yn=N)으로 잔존: MAT_000128 면끈(MAT_TYPE.17)·MAT_000129 아크릴키링고리(.03)·MAT_000240 보드스탠딩(.16)·MAT_000241 핀버튼(.12) |
| KB 처리 | **위반 아님(정직).** 4개 자재 노드 전부 `badge: defect` · source_locator note "굿즈 오적재 잔존" · `GAP_paper_material_042`로 잔존 선언. 라이브 오적재를 verified로 표기하지 **않음** → 양면 표기 규칙 준수. |
| 증거 | live t_mat_materials 자재명/타입 실측(면끈·키링고리 등) · nodes.jsonl badge=defect 4건 · 유사 굿즈오염 교훈([[goods-material-contamination-260630]]) |
| 심각도 | 원천(라이브 DB) 결함 — KB 교정 불가(그릇 밖). 가격 영향 가능(굿즈 자재가 가격사슬에 들어가면 오청구) → 실무진 판단 필요 |
| 교정안 | 라이브 DB에서 042 굿즈 자재 정리(논리삭제) 여부 = **실무진/인간 승인**. KB는 현 상태(defect+GAP)로 정직 유지 |
| 라우팅 | **원천 컨펌 큐**(라이브 오적재 정리·실무진) — KB 측 조치 없음(이미 정직 표기) |

---

## 2. 반증 실패(생존) 항목 — 전수 결정론

### A1 출처 실재성
- **파일 실재 0결함**: 619 소스·43 distinct file 전부 실재(resolver 교정 후). ★기존 `provenance_audit_260703.py`가 502 "부재" 오탐한 것은 **스크립트 자체 버그**(`live-snapshot/`→repo root, `MEMORY/`→repo root 오해석). `prov_expand_260703.py`가 prefix 교정(live-snapshot→`_foundation`, MEMORY→auto-memory dir) 후 0.
- **행 실재**: live CSV 출처의 locator 선두 코드를 CSV에서 재조회 → 긍정 사실 인용 중 미실재 1건(D-1)만. 나머지 GAP/부재 인용은 자연어 판단(표본)에서 전부 정직(부재를 부재로 인용).
- **손전사 수색 0**: 가격/치수 숫자 리터럴 든 파일 전수 스캔 → 전사 마커 무 파일 0. 실측 리터럴은 전부 수량스칼라(10,000매 등·`lint-allow src=SR-5-livesnap`) 또는 `transcribed-by:` 주석 있는 전사표(047 자재 46행 등). 표본 3건(042·050·033 수량) 라이브와 정확 일치.

### A2 권위 정합
- **priced_by(39)**: KB-only=**0**(날조 바인딩 없음). LIVE-only=1 `(PRD_000042,PRF_DGP_A_FOIL)` → **정직 선언됨**(042 node line 99/116: 공식 미mint→끊긴링크 회피 위해 엣지 미배선·`needed_shared_nodes` 반환·통합단계 mint 계획). 조용한 누락 아님.
- **has_component(23 공식)**: 전부 MATCH·frm 불일치 **0**. KB 인용 component 중 라이브 del_yn=Y/use_yn=N/부재 **0**.
- **4축×36상품**(process/material/print_option/size): "KB에만(라이브부재)" = **0**(날조 축엣지 없음·모든 KB 축엣지가 라이브 활성행에 대응). "라이브에만(미배선)" DIFF(016/018/019/021/022/047/048 등)는 전부 **대표축노드 설계 + GAP 노드 + 전사표**로 정직 선언(예 047: "대표 7종만 배선·46종 전수는 전사표 유일원천" + 46행 transcribed-by 표; 048: gap-048-material "14노드·30미민팅·2비종이"). 교차확인: DIFF 상품 7종 전부 gap 노드 보유.
- **날조 노드/엣지 0**: `audit_integrity_r2` 재실행 → recon 466==jsonl 466·비ref엣지 1037==1037·jsonl-only(날조) 0.

### A3 오염
- **STALE 인용 0**: §8 금지 패턴(v03·price-engine-ddl·prcx01·huni-db-mapping·후가공_박(백업) 등) 전 소스 스캔 0.
- **구권위 260610/260527 무대조 0**: diff/260702 미동반 인용 0.
- **환각 개체 0**: product/material/process/size/component/formula/category anchor 코드 전수 → 라이브 부재 0.
- **라이브 오적재 verified 0**: 오적재(굿즈 자재 4)는 defect 배지(D-2)·candidate(047 자재오염 후보)로 표기·verified 아님.
- **use_yn=N 미출시 정직 표기**: 라이브 use_yn=N 6상품(021·022·023·028·038·051) 전부 KB가 미출시 상태 명시(props+본문). 별색/박 미배선은 **결함 아닌 라이브 상태**로 GAP 선언 — gap-021-pink-process(PROC_000010 미배선)·gap-022-spotcolor-unwired·gap-028-foil-price-path(PRF_DGP_E_FOIL 미바인딩)·gap-038-skeleton-bindings(형압 PROC_000050 미바인딩). 조용한 누락 0.

---

## 3. 검증 범위·한계(정직 명시)

- **전수(결정론)**: 파일 실재·행 실재·priced_by·has_component·4축×36상품·STALE/구권위/환각/날조엣지 = 스크립트 전수.
- **표본(자연어)**: GAP 노드의 의미 정당성(부재를 부재로 인용했는지)·전사표 값 정확성은 표본(047 자재·042/050/033 수량·042 굿즈오염). 전 GAP 67개의 의미 반증은 미전수 — 표본 전부 정직이나 "무결" 단정 아님.
- **범위 밖**: 그래프 무결성 재실행(멱등·고아·타입위반)·연결 완전성(가격 경로 종단 탐색)·종단 질의 재현·evaluate_price 가격 오차 대조 = 본 배정 밖(타 검증자/축).
- **결함 0 단정 금지**: 배정 3축 전 36상품에서 KB 자체 결함 = LOW 1건. 라이브 원천 오적재 1건은 KB 밖. 이 범위에 한해 O1(출처)·O2(권위)·O3(오염) 반증 실패로 생존.
