# 실사 상품군 지식 구축·그래프 빌드 리포트 — 2026-07-03

> okb-knowledge-builder consolidation 패스. 입력=병렬 실사 빌더 28상품(PRD_000118~145) + 확정 스키마 v1.0.1 + pack-silsa. 산출=공유축 dedupe·index/gaps 통합·그래프 빌드 hard 0. 검증은 별도 레인(okb-adversarial-gate) — 본 리포트는 생성 통계이며 자기 승인 아님.

## 판정
- **PASS(하드 위반 0)** · 소프트 경고 428 · 멱등 True
- 노드 **976** · 엣지 **3060**
- 멱등 해시: nodes.jsonl=0315cfad494397b3 · edges.jsonl=b0cb4ee965846a86
- index dead-link(O4b): **0** · silsa O4 미등재: **0**

## 이번 패스에서 처리한 것 (consolidation)

### 1) 하드 위반 7 → 0 (single ownership·중복 id 0)
직전 빌드는 병렬 실사 빌드로 hard 7. 전부 해소:
- **L-3 중복 id ×5**: product-143-mirror-acrylic-sticker-nodes가 category-CAT_000092(141 소유)·size-SIZ_000324/325/326/327(142 소유)을 중복 mint → 143에서 블록 제거하고 참조([[ ]])로 전환. canonical=141(CAT_000092)·142(SIZ_000324~327). 143 product의 in_category/has_size 엣지는 canonical 노드로 해소.
- **L-6 출처 5필드 미비 ×1**: material-MAT_000185(캔버스·125-nodes) 2번째 src의 source_locator 내부 중첩 큰따옴표(`"원단"`)로 YAML 파싱 절단 → 작은따옴표(`'원단'`)로 교정. 5필드 복원.
- **L-17 앵커 미실재 ×1**: optgroup-143-color anchor가 `t_prd_product_option_groups/OPT-000046`(opt_grp_cd·닫힌세계 col0=prd_cd 불일치) → 컨벤션대로 `.../PRD_000143`로 교정.

### 2) index.md 통합
- 실사 계열 섹션에 미등재 20상품 등재(118/119/120/121/123/124/125/128/129/130/132/133/135/136/138/139/140/141/142/144) — 각 상품 .md + companion -nodes.md 링크로 블록 노드 전부 index-listed.
- 결과: 실사(118~145) O4 미등재 248 → **0**. index dead-link(O4b) **0**(실제 파일명과 링크 일치·스티커 교훈 준수).
- 아키타입 표기: 면적매트릭스형(use_dims=[siz_width,siz_height]·off-grid ceiling)과 고정가형(use_dims=[siz_cd] 또는 [mat_cd,siz_cd] 또는 [siz_cd,min_qty] 룩업) 구분 명시.

### 3) rule/gaps.md 통합
- "실사 계열 GAP 색인(118~145 28상품)" 섹션 신설 — 링크 전용(노드 본문은 각 product/*-nodes.md·재정의 금지 L-3).
- 공유 열린질문 5축(롤 소재 가격 산정 암묵지·min_qty 차원·패브릭/메쉬 자재유형·부속 귀속·삭제 마스터 드리프트) 정리.
- 양면 defect 워크리스트(실무진+인간 승인 대기) 명시.

## 실사 상품군 통계 (PRD_000118~145)

- 실사 상품 노드: **28** (완제품 PRD_TYPE.01·전부 use_yn=Y)
- 가격사슬 연결: **28/28 priced_by 실재** (O5 끊긴 가격사슬 0·전 상품 견적 경로 완결)
- 실사 가격공식(PRF_POSTER_*): 29종 (+ 공유 PRF_POSTER_FIXED)
- 실사 GAP 노드: **69** (전부 badge=unknown·정직 공백·gap 3필드 L-10 충족)
- 실사 양면 defect 노드: **8** (+ 공유 size-SIZ_000170 A5=axis/sizes 소유·144 활성 참조자)

### 가격 아키타입별 분류
- **면적매트릭스형**([siz_width,siz_height]·off-grid ceiling): 118 아트프린트·119 아트페이퍼·120 방수·121 접착방수·122 접착투명·123 아트패브릭·124 린넨·125 캔버스·126 레더·127 타이벡·128 메쉬 + base(138 일반현수막·139 메쉬현수막). ★[동형결합 4소재] 통합 comp COMP_POSTER_ARTPRINT_PHOTO(118/120/121/123)·COMP_POSTER_CANVAS_FABRIC(125/126/127/128).
- **고정가형**([siz_cd] 단일축·[mat_cd,siz_cd] 2축·[siz_cd,min_qty] 룩업): 129 폼보드·130 포맥스보드·131 프레임리스액자·132 레더액자·133 캔버스행잉·134 린넨우드봉·135 족자·136 PET배너·137 메쉬배너·140/141 시트커팅·142/143 아크릴스티커·144 미니보드·145 미니배너. 수량축 실충전=144(규격3×수량5밴드=15셀)·145(규격2×수량5=10셀).
- **비종이류=판형 없음**([[rule/rules#RULE_plate_paper_only]]): 실사 전 상품 공통(plate=파일사양 JPG placeholder 또는 논리삭제). 종이류 절수 판형 아님.

## 무결성 6검사 (build_graph.py)
- I-1 고아(하드 유형 product/formula/component): 0
- I-2 끊긴 링크: 0
- I-3 타입 위반: 0
- I-4 필수 엣지(O5 가격사슬·O6 고아공식): 0
- I-5 멱등: 2회 빌드 해시 동일 True
- I-6 오염(blocklist): 0 (원천 실재)
- ★ index dead-link(O4b): 0

## 잔존(소프트·검증/후속 레인)
- 소프트 428: 대부분 O4 미등재(비-실사 디지털/스티커 축 노드 58)·L-12/L-16 본문 수치 마커(값=evaluate_price 권위·D-18 경계)·I-1 floating GAP(연결 완전성 라운드 재판정).
- 실사 축 정식 승격(needed_shared): 병렬 빌더들이 각 companion에 남긴 "axis/*·formula/silsa-* 승격 후보"는 후속 consolidation 패스 대상. 본 패스는 hard 0·single ownership(중복 id 0)·index/gaps 통합까지. 스티커 선례(consolidate_sticker_axes.py) 동형 스크립트로 실사 축(카테고리/사이즈/자재/공정 + silsa-formulas/silsa-components 신설) 이관은 별도 승인 후.
- 양면 defect 8 + GAP 69: 실무진/개발팀 답변 대기(롤 소재 산정·자재유형 교정·부속 귀속·삭제 마스터 드리프트·min_qty 차원). 라이브 실 교정은 인간 승인 후 dbmap/§26/§31 위임(본 KB는 읽기전용 관찰·DB 미적재).

## 원천·안전
- 원천: 실사 팩(pack-silsa.md) + live-snapshot/latest CSV(닫힌세계 앵커 검사) + 스크립트 전사(transcribed-by 마커). STALE 미인용·라이브="현재값"·읽기전용 SELECT만·DB 미적재.
- 생성≠검증: 본 리포트는 빌드 통계. "검증 완료" 자기 승인 아님 — 적대 검증은 okb-adversarial-gate 레인.
