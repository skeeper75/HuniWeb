<!-- companion nodes for product-049 와이드 접지리플렛 — 공유 축/형제 노드에 없는 상품 전용 마스터 노드만 신설. -->
<!-- ★공유 파일(index.md·axis/*·formula/*·rule/*) 절대 수정 금지 규칙에 따라, 기존에 없는 것만 여기(자기 네임스페이스) 신설. -->
<!-- ★신규 mint = category-CAT_000058·size-SIZ_000055·material 4(083/093/111/112)·process 2(060 3단접지·071 병풍접지). -->
<!--    ★재사용(L-3 중복 금지): material-MAT_000110·plate-OUTPUT_PAPER_TYPE_03 = 형제 030(지그재그엽서)이 이미 정의 → 재사용. -->
<!--    공정 004/014/015/031/032·printopt POPT_000002·공식 PRF_DGP_E·category CAT_000003 = 전부 기존 전역 노드 재사용(L-3). -->
<!--    ★신규 mint 중 axis 승격 후보(CAT_000058·PROC_000060/071·SIZ_000055·material 4)는 needed_shared_nodes로 통합 단계에 보고. -->
<!-- ★수치(치수·사양·판형)는 전사 스크립트 transcribe_product_049.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-049 전용 노드 (와이드 접지리플렛 — 상품 전용 마스터 축)

[[product-049-wide-folded-leaflet]]가 연결하는 축 중, **기존 전역 노드(공유 축 axis/* ·
formula/digital-formulas)에 아직 없는 것만** 신설한다. 와이드 접지리플렛은 형제 접지카드
([[product-027-bifold-card]]·[[product-029-trifold-card]])와 **같은 원자합산형 공식(PRF_DGP_E)**
을 쓰지만, ① 인쇄홍보물 카테고리(전단지/리플랫)·② 단일 와이드 사이즈(640×297)·③ "3절" 지질
5종·④ 3단접지/병풍접지 공정·⑤ 국전 초과라 **출력용지 "기타"(.03) 판형**이라는 점이 다르다.

## 재사용 목록 (신규 mint 아님 — 전역 노드 참조)

전사표(transcribe_product_049.py)로 라이브 실재를 확인하되, 아래는 이미 다른 파일이 정의한
전역 노드이므로 여기서 재정의하지 않는다(L-3 중복 금지). product-049의 relations 엣지가 그 노드로 해소된다.

- **카테고리 상위**: `category-CAT_000003`([[axis/categories]] 인쇄홍보물·lvl1). 신규 없음.
- **인쇄옵션**: `printopt-POPT_000002`([[axis/print-options]] 양면). 신규 없음.
- **공정 5종**: base `PROC_000004`·라미네이팅 `PROC_000014`(유광)/`PROC_000015`(무광)·가변
  `PROC_000031`/`PROC_000032` — 전부 [[axis/processes]] 정의 재사용. 신규 없음.
- **가격공식**: `formula-PRF_DGP_E`([[formula/digital-formulas]]·frm_nm "…접지카드·접지리플렛"·
  formula_components 11 배선 보유). 형제 접지카드가 정의한 공식을 그대로 재사용(신규 공식·구성요소 없음).

---

## 카테고리 (category) — ★신규 mint 1종 (전단지/리플랫)

와이드 접지리플렛은 인쇄홍보물(CAT_000003·기존) 아래 **전단지/리플랫(CAT_000058·lvl2)** 에 속한다.
CAT_000058은 아직 공유 축([[axis/categories]])에 없어 여기서 신설하되, **axis/categories 승격 후보**
로 통합 단계에 보고한다(needed_shared_nodes).

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories prd_cd=PRD_000049 @ 2026-07-03 -->
| cat_cd | 분류명 | lvl | 상위 | 노드 정의처 |
|---|---|---|---|---|
| CAT_000003 | 인쇄홍보물 | 1 | - | axis/categories |
| CAT_000058 | 전단지/리플랫 | 2 | CAT_000003 | product-049-nodes (신규) |

### [category-CAT_000058] 전단지/리플랫 {verified}
- type: category
- anchor: t_cat_categories/CAT_000058
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000058 (cat_lvl=2·upr_cat_cd=CAT_000003·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "전단지/리플랫", cat_lvl: 2, upr_cat_cd: "CAT_000003", note: "인쇄홍보물(CAT_000003) 하위 lvl2 — axis/categories 승격 후보"}

---

## 사이즈 (size) — ★신규 mint 1종 (640×297 와이드)

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). ★와이드 리플렛은 재단 640×297의
**단일 사이즈**(펼침 기준·접지 전 전개면). 3단/병풍 접지의 폴딩 기하는 master(t_siz_sizes) 재단값이
권위이며, 여기서 접지 산식을 재구성(날조)하지 않는다. 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생
(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes prd_cd=PRD_000049 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | 노드 정의처 |
|---|---|---|---|---|---|
| SIZ_000055 | 640x297 | 646x303 | 640x297 | Y | product-049-nodes (신규) |

### [size-SIZ_000055] 640x297 (와이드 리플렛) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000055
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000055 (work 646x303·cut 640x297)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000049 siz_cd:SIZ_000055 dflt_yn=Y del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm: "640x297", 재단: "640x297", 작업: "646x303", note: "와이드 리플렛 단일 사이즈·재단 640mm가 국전 출력용지(467) 초과 → 판형 기타(.03)"}

---

## 자재 (material) — ★신규 mint 4종 + 재사용 1종 ("3절" 계열·USAGE.07)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5·낱장 단일 본문). ★[HARD] 실무진이
IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
형제 접지카드 자재와 **다른 mat_cd("3절" 변형)** 이다. ★MAT_000110(몽블랑130g 3절)은 형제
지그재그엽서([[product-030-zigzag-postcard-nodes]])가 이미 정의 → **재사용**(L-3 중복 금지). 나머지
4종만 신규 mint(axis/materials 승격 후보).

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials prd_cd=PRD_000049 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처 |
|---|---|---|---|---|---|---|
| MAT_000083 | 아트지 150g (3절) | MAT_TYPE.01 | 316x467 | 150 | USAGE.07 | product-049-nodes (신규) |
| MAT_000093 | 스노우지 250g (3절) | MAT_TYPE.01 | 316x467 | 250 | USAGE.07 | product-049-nodes (신규) |
| MAT_000110 | 몽블랑 130g (3절) | MAT_TYPE.01 | 316x467 | 130 | USAGE.07 | product-030-nodes (재사용) |
| MAT_000111 | 몽블랑 190g (3절) | MAT_TYPE.01 | 316x467 | 190 | USAGE.07 | product-049-nodes (신규) |
| MAT_000112 | 몽블랑 240g (3절) | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 | product-049-nodes (신규) |

### [material-MAT_000083] 아트지 150g (3절) {verified}
- type: material
- anchor: t_mat_materials/MAT_000083
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000083 (평량 150·규격 316x467)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000049 mat_cd:MAT_000083 usage_cd:USAGE.07 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "마스터 t_mat_materials/MAT_000083(아트지 150g 3절)", 사용: "049 와이드 접지리플렛 본문(USAGE.07)"}

### [material-MAT_000093] 스노우지 250g (3절) {verified}
- type: material
- anchor: t_mat_materials/MAT_000093
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000093 (평량 250·규격 316x467)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000049 mat_cd:MAT_000093 usage_cd:USAGE.07 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "마스터 t_mat_materials/MAT_000093(스노우지 250g 3절)", 사용: "049 본문(USAGE.07)"}

> **material-MAT_000110(몽블랑130g 3절)은 여기서 재정의하지 않는다** — 형제 지그재그엽서
> [[product-030-zigzag-postcard-nodes]]가 이미 정의(L-3 중복 금지). product-049의 `uses_material`
> 엣지가 그 전역 노드로 해소된다.

### [material-MAT_000111] 몽블랑 190g (3절) {verified}
- type: material
- anchor: t_mat_materials/MAT_000111
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000111 (평량 190·규격 316x467)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000049 mat_cd:MAT_000111 usage_cd:USAGE.07 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "마스터 t_mat_materials/MAT_000111(몽블랑 190g 3절)", 사용: "049 본문(USAGE.07)"}

### [material-MAT_000112] 몽블랑 240g (3절) {verified}
- type: material
- anchor: t_mat_materials/MAT_000112
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000112 (평량 240·규격 316x467)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000049 mat_cd:MAT_000112 usage_cd:USAGE.07 del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "마스터 t_mat_materials/MAT_000112(몽블랑 240g 3절)", 사용: "049 본문(USAGE.07)·형제 MAT_000109 몽블랑240g(비-3절)와 다른 mat_cd"}

---

## 공정 (process) — ★신규 mint 2종 (3단접지·병풍접지)

접지 방식 2종만 [[axis/processes]]·형제 접지카드(027/029 PROC_000065~068)에 없어 새로 필요하다.
★[HARD] 접지·라미·가변은 도수가 아니라 "공정"으로 들어온다(팩 §3.3·[[rule/rules#RULE_dosu_is_printopt]]).
아래 2종은 axis/processes 승격 후보다(needed_shared_nodes로 통합 단계 보고).

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes prd_cd=PRD_000049 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | disp_seq | 노드 정의처 |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | -1 | axis/processes |
| PROC_000014 | 유광라미네이팅 | N | 1 | axis/processes |
| PROC_000015 | 무광라미네이팅 | N | 1 | axis/processes |
| PROC_000060 | 3단접지 | N | 1 | product-049-nodes (신규) |
| PROC_000071 | 병풍접지 | N | 1 | product-049-nodes (신규) |
| PROC_000031 | 가변텍스트 | N | 10 | axis/processes |
| PROC_000032 | 가변이미지 | N | 11 | axis/processes |

### [process-PROC_000060] 3단접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000060
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000060", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000049 proc_cd:PROC_000060 mand_proc_yn=N del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "3단접지", role: "접지(fold) — 3단(리플렛)·mand N·형제 029 PROC_000067/068(3단접지카드)와 다른 proc_cd(리플렛 계열)"}

### [process-PROC_000071] 병풍접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000071
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000071", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000049 proc_cd:PROC_000071 mand_proc_yn=N del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "병풍접지", role: "접지(fold) — 병풍(accordion/Z-fold 계열)·mand N·와이드 리플렛 접지 방식"}

---

## 판형 (plate_size) — 재사용 1종 (.03 기타·국전 초과 와이드)

★[HARD 도메인] 판형 = 출력용지규격(작업사이즈 아님)·종이류에만 유효·고객 미선택
(`fn_best_plate` 자동선택·[[rule/rules#RULE_plate_paper_only]]). 와이드 리플렛은 재단 640mm가
국전 출력용지(316×467)의 467을 **초과**해 국전(.01)에 앉힐 수 없어 **출력용지 "기타"(OUTPUT_PAPER_TYPE.03)**
를 쓴다(활성 출력용지 규격 SIZ_000475=330×660). 팩 §3.8의 "디지털 전 상품 = .01 국전"은
파일럿 8상품 일반화이며, 와이드 리플렛은 그 예외(라이브 현재값·결함 아님). ★.03 판형 노드는 형제
지그재그엽서([[product-030-zigzag-postcard-nodes]])가 이미 정의 → **재사용**(L-3 중복 금지·신규 mint
아님). product-049의 `has_plate_size` 엣지가 그 전역 노드로 해소된다.

<!-- transcribed-by: _meta/scripts/transcribe_product_049.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes(+t_siz_sizes 출력용지규격) prd_cd=PRD_000049 @ 2026-07-03 -->
| 출력용지유형 | 출력용지 siz_cd | 출력용지 규격 | dflt | 노드 정의처 |
|---|---|---|---|---|
| OUTPUT_PAPER_TYPE.03 | SIZ_000475 | 330x660 | Y | product-030-nodes (재사용) |

---

## 추가상품 (addon) / 제약 (constraint) — 라이브 0건

live-snapshot 20260702_1119 실측: PRD_000049의 `t_prd_product_addons`·`t_prd_product_constraints`
(활성 del_yn=N) **모두 0건**. 봉투/케이스 addon도, 정형 제약규칙도 등록돼 있지 않다("현재값"·
결함 아님·필요 제약 도출은 §31 거버넌스 소관). 따라서 addon·constraint 노드를 만들지 않는다.

---

## CPQ 옵션그룹 미등록 → GAP (손님 선택 경로 끊김)

형제 접지카드(027/029)는 인쇄·종이·후가공·접지·박칼라 옵션그룹으로 손님 선택 축을 갖지만,
와이드 리플렛(049)은 `t_prd_product_option_groups` **라이브 0행**이다. 즉 3단접지/병풍접지·유광/무광
라미·가변텍스트/이미지 공정이 `has_process`로 상품에 부착돼 있으나, **손님이 이를 고를 CPQ 옵션그룹이
없다** — 옵션 선택→차원 환원 경로가 끊긴다. 지어내지 않고 GAP으로 정직 선언한다.

### [gap-049-cpq-optiongroups] CPQ 옵션그룹 미등록 (손님 선택축 부재) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_option_groups 라이브 0행 — 부착된 공정을 손님이 고를 옵션그룹이 없음
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000049 활성 옵션그룹 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.9 CPQ·§4-E 인쇄홍보물 3절 라인 미출시 동형처리 대기", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "049 와이드 접지리플렛은 접지(3단/병풍)·라미(유광/무광)·가변 공정이 has_process로 부착됐으나 t_prd_product_option_groups 0행이라 손님 선택 옵션그룹(인쇄/종이/후가공/접지 등)이 미등록. 형제 027/029는 5 옵션그룹 보유 — 049는 옵션→차원 환원 CPQ 경로가 끊김"
- gap_fill_from: "형제 접지카드(027/029) 옵션그룹을 동형 참조해 049에 인쇄·종이(5 자재)·후가공(가변)·접지(3단/병풍)·라미 옵션그룹 설계·적재(§31 CPQ 거버넌스·인간 승인). 팩 §4-E '3절 라인 미출시 동형처리 대기'와 함께 결정"
- gap_owner: 설계
