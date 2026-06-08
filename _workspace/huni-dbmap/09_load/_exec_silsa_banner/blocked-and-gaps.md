# 차단 / GAP — 일반현수막(PRD_000138) round-5 적재 실행본

> 작성 2026-06-08 · **[v2 옵션 자재+공정 BUNDLE 갱신]** · dbm-load-builder. 차단행 = 별도 `*_BLOCKED.csv`/`_blocked/` SQL 로 격리(주 트랜잭션 미포함). 각 항목에 차단 사유 + 해소 조건(unblock) 명시. 발명 금지 — 미적재 데이터는 보여주되 침묵 back-fill 안 함.
> **[v2 변경]** 옵션 = 자재(.03)+공정(.04) BUNDLE. B-3(열재단 공정) 불변. **B-4(자재 BLOCKED-LINK)·B-5(자재 BLOCKED-MINT+LINK) 신규**(v1 B-4 각목 셋트.07 폐기 → 각목=material 재귀속). G-1 R-GAKMOK var=mat_cd 정정. 가격/siz BLOCKED(B-1/B-2)·G-2 불변.

---

## 1. BLOCKED — 인간 승인 선행 후 적재 가능

### B-1. siz 77규격 신규 등록 (master-data)

| 항목 | 내용 |
|------|------|
| 대상 | `t_siz_sizes` 77행 (SIZ_000538~000618) |
| 입력 | `load/t_siz_sizes_BLOCKED.csv` · 적재 SQL `_blocked/B01_t_siz_sizes.sql` |
| 사유 | 면적매트릭스 80셀 중 77 치수가 라이브 미등록(라이브 MAX siz_cd=SIZ_000510, search-before-mint 확인). siz 채번 = 후니 master-data 등록 = 인간 승인 |
| 선례 | acrylic 면적매트릭스(`02_mapping/load_price_correction/areamatrix-siz-registration.csv`·`load_price/_acryl_siz_match.csv`): 기존 siz → 재사용(EXACT/REVERSED), 미등록(NONE) → 신규 mint. 본 트랙 동일 — 3 기존(SIZ_000320/323/403) 재사용 / 77 신규 mint(`{가로}x{세로}` 명명, 가격트랙 채번) |
| **해소(unblock)** | 후니가 siz 77규격 등록(인간 승인) → `_blocked/apply_blocked.sql` 실행 → 77 area-cell 활성화 |
| 실증 | siz 등록 후 area-cell 적재 통과(DRY-RUN TEST2: new_siz 77, banner area 80, 멱등 delta 0) |

### B-2. 면적매트릭스 area-cell 77행 (siz 의존)

| 항목 | 내용 |
|------|------|
| 대상 | `t_prc_component_prices` 77행 (COMP_POSTER_BANNER_NORMAL × siz × 단가) |
| 입력 | `load/t_prc_component_prices_BLOCKED.csv` · 적재 SQL `_blocked/B02_t_prc_component_prices.sql` |
| 사유 | siz_cd FK(`fk_prc_comp_prices_siz_cd`→t_siz_sizes) — 77 치수 siz 미등록 시 FK 위반(DRY-RUN TEST1 실증: SIZ_000554 부재 ERROR) |
| **해소(unblock)** | B-1(siz 77 등록) 선행 → B-2 FK 충족 → 적재. 면적매트릭스 80셀 완결(3 INSERTABLE + 77) |

### B-3. 열재단 option_item (신규 공정 PROC_000084 — DDL 의존)

| 항목 | 내용 |
|------|------|
| 대상 | `t_prd_product_option_items` 1행 (OP-GAGONG-YEOLJAEDAN, ref_dim_cd=OPT_REF_DIM.04, ref_key1=PROC_000084) |
| 입력 | `load/t_prd_product_option_items_BLOCKED.csv` (block_reason 컬럼) |
| 사유 | 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.04 → t_prd_product_processes EXISTS) 가 REJECT — 열재단 전용 공정 PROC_000084 가 라이브 미존재(MAX proc_cd=PROC_000083). 완칼 PROC_053 차용 폐기(M-1 ① 확정: 천 매질 부적합). **OP-GAGONG-YEOLJAEDAN 은 가공 dflt(기본 가공)** 라 기본 옵션이 차단 상태 |
| DDL 제안 | `11_ddl_proposals/heat-cut-process-proposal.sql`(재사용, 재발명 금지) — t_proc_processes 1행 + t_prd_product_processes 링크 1행. `proc_cd=PROC_000084` `[CONFIRM-CHANNEL]`(적용 직전 라이브 MAX 재확인 후 후니 배정) |
| **해소(unblock)** | ① 후니가 DDL 제안 검토·적용(인간 승인) → t_prd_product_processes(PRD_000138, PROC_000084) 생성 → ② 열재단 item INSERTABLE 승격(트리거 통과). 가격(열재단 추가가 3000)은 **이미 INSERTABLE**(COMP_BANNER_FIN_HEATCUT, 가격은 공정 신설과 독립) |

### B-4. [v2] 자재 seq option_item — BLOCKED-LINK only (master 실재·링크만 부재)

| 항목 | 내용 |
|------|------|
| 대상 | `t_prd_product_option_items` 4행 (자재 .03): 끈 MAT_000070 ×3(OP-CHUGA-STRING4 seq1·각목LE seq2·각목GT seq2) + 양면테입 MAT_000069 ×1(OP-GAGONG-YANGMYEONTAPE seq1) |
| 입력 | `load/t_prd_product_option_items_BLOCKED.csv` (ref_dim_cd=OPT_REF_DIM.03) · 활성화 SQL `_blocked/B03b`(자재 링크)·`B04`(자재 seq item) |
| 사유 | 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.03 → t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS) REJECT — 끈 MAT_000070·양면테입 MAT_000069 는 **master 실재**(라이브 t_mat_materials 직접 조회·mint 불요)이나 **PRD_000138 자재 링크 0행**(t_prd_product_materials 직접 조회). 라이브 DRY-RUN B1 실증: `자재 mat_cd=MAT_000070/usage_cd=USAGE.07 가 상품 PRD_000138에 없음` EXCEPTION |
| **해소(unblock)** | PRD_000138 `t_prd_product_materials (mat_cd, USAGE.07)` 링크 선적재(`B03b`, mint 불요) → 자재 seq INSERTABLE(`B04`). 라이브 DRY-RUN B2 실증: 링크 후 끈 BUNDLE(자재 .03 seq1 + 공정 .04 seq2) 2행 성립·멱등. **단 옵션헤더(06/07) 선행 필요**(B04 FK fk_prd_opt_items_opt) — `apply_blocked_options.sql` 이 06/07 멱등 선포함 |

### B-5. [v2] 자재 seq option_item — BLOCKED-MINT+LINK (master 부재·mint 필요)

| 항목 | 내용 |
|------|------|
| 대상 | `t_prd_product_option_items` 4행 (자재 .03): 큐방 ×1(OP-CHUGA-QBANG4 seq1) + 각목900이하 ×1(각목LE seq1) + 각목900초과 ×1(각목GT seq1) + 봉제사(실) ×1(OP-GAGONG-BONGMISING seq1) |
| 입력 | `load/t_prd_product_option_items_BLOCKED.csv` (ref_key1=`[CONFIRM-MAT ...]`) · 활성화 SQL `_blocked/B03a`(자재 mint 제안)·`B03b`(링크)·`B04`(자재 seq item, mint분 주석) |
| 사유 | ① 자재 master 부재 — 라이브 t_mat_materials 직접 조회 0행(search-before-mint 재증명: 큐방=큐/방/하토메/고리 검색 0, 각목=각목/사각목 0[우드봉 MAT_000225 차용 배제·각목=사각단면 목재], 봉제사=실/봉제사 검색 0[실버/실사소재만]). ② PRD_000138 자재 링크 0행. ref_key1=`[CONFIRM-MAT ...]` placeholder(NOT NULL ref_key1 미충족) |
| mint 제안 | `_blocked/B03a_t_mat_materials_MINT.sql`(4건, MAT_TYPE.07 부속, mat_cd=`[CONFIRM-CHANNEL]` 라이브 MAX(mat_cd)=MAT_000336 재확인 후 후니 채번·발명 금지). 주석 처리(채번 전 실행 SQL 아님) |
| **해소(unblock)** | ① 후니가 자재 mint(인간 채번, `B03a`) → ② `B03b`/`B04`의 placeholder 를 실 mat_cd 로 치환 → ③ 자재 링크 + 자재 seq INSERTABLE. 라이브 DRY-RUN D2 실증(봉제사 mint+링크 후 봉미싱 BUNDLE 성립). 가격(각목+끈 4000/8000·큐방 3000·봉미싱 4000)은 **이미 INSERTABLE**(가격 component, 자재 mint 와 독립) |
| 미해결 | 각목 2규격(900이하/초과) = 별 mat_cd 2개 vs 단일 mat_cd+규격 param(D-2) · 큐방 = 자재 mint + 부착 enum 확장 둘 다 [CONFIRM] · 봉제사 실 규격 param 보존처(GAP-PARAM) |

---

## 2. GAP — 손실 없이 표현 불가 → 에스컬레이션

### G-1. R-GAKMOK-HEIGHT constraint (GAP-DEFER)

| 항목 | 내용 |
|------|------|
| 대상 | `t_prd_product_constraints` 1행 (R-GAKMOK-HEIGHT, rule_typ_cd=RULE_TYPE.01 호환) |
| 입력 | `load/t_prd_product_constraints_GAP.csv` (status=GAP-DEFER, logic_target_spec → 라이브 `logic` jsonb 매핑) |
| 의도 | 각목(900이하)↔세로변≤900 siz 집합 / 각목(900초과)↔세로변>900 siz 집합 호환(사용자 확정: 900mm=세로변). **[v2] var = `mat_cd`**(각목 material 재귀속, v1 sub_prd_cd 폐기). `logic`(jsonb NOT NULL)에 mat_cd↔siz_cd 집합 멤버십으로 표현 가능 |
| 사유(차단 3중) | ① **[v2] 각목 자재 mint+링크 미등록**(B-5, mat_cd 미상) ② siz 77규격 미등록(B-1) — siz_cd 집합을 실코드로 열거 불가 ③ 라이브 admin 폼빌더의 **배열-멤버십 입력 지원 미검증**(F-1: LV-1 실측=단일 코드값 2항만). DB `logic` jsonb 저장은 가능하나 폼빌더 입력방식 미확정 |
| **해소(unblock)** | ① **[v2] 각목 자재 mint + PRD_000138 자재 링크**(B-5) → mat_cd 실코드 확정 ② siz 77 등록(B-1) → siz_cd 집합 실코드 확정 ③ 폼빌더 입력방식 확정(배열 1행 `in`-멤버십 직접입력 vs 75 단일행 분해). 세 선행 충족 시 logic jsonb 확정·적재 → t_prd_products.constraint_json 1건 채움 |
| 재정합 | R-SIZE-NONSPEC=폐기(사이즈=이산 매트릭스, 유효성=가격 셀 존재). R-BONGJE=불요(사이즈 필수는 공통 전제). → constraint 잔존 GAP은 R-GAKMOK 1건뿐 |

### G-2. 옵션 파라미터 보존처 (GAP-PARAM)

| 항목 | 내용 |
|------|------|
| 대상 | 타공 구수(4/6/8) · 각목 규격(900이하/초과) param |
| 사유 | `t_prd_product_option_items` 에 `ref_param_json` 컬럼 라이브 부재(LV-5: admin 폼에도 param 입력 필드 없음). 타공 3옵션은 동일 PROC_000079 재사용하나 구수 N 보존 불가. qty 에 smear 금지(구수≠소비수량) |
| 영향 | 가격은 분리 흡수됨(타공 개수별 COMP_BANNER_FIN_EYELET4/6/8 별 component — 가격은 손실 없음). param 은 **표시/추적용 메타만 손실**. 적재 item 자체는 INSERTABLE(ref_key1=proc_cd EXISTS) |
| **해소** | ddl-proposer GAP-PARAM(ref_param_json 컬럼 신설, `11_ddl_proposals/ref-param-json-proposal` 초안 존재) = 인간 승인. 본 트랙은 미적재 param 을 침묵 drop 안 하고 GAP 으로 명시 |

---

## 3. 인간 결정 필요 (리드 에스컬레이션)

| ID | 결정 사항 | 옵션 | 차단 직결 |
|----|----------|------|----------|
| **[v2] D-MAT-MINT** | 큐방·각목(LE/GT)·봉제사 자재 mint 채번·승인 | `_blocked/B03a` 4건(MAT_TYPE.07, mat_cd=[CONFIRM-CHANNEL] 라이브 MAX 재확인 후 채번). search-before-mint 재증명 완료(각목=우드봉 차용 배제) | B-5·G-1 |
| **[v2] D-2 각목 2규격** | 각목 900이하/초과 = 별 mat_cd 2개 vs 단일 mat_cd+규격 param | 별 mat_cd 2개(현 설계) vs 단일+param(GAP-PARAM 종속). v1 D-각목-MODEL(set vs material)은 v2에서 material 확정으로 **종결** | B-5·G-2 |
| **[v2] D-MAT-LINK** | 끈/양면테입 자재 링크 적재 승인 | `_blocked/B03b` live 2(MAT_000069/070, mint 불요·링크만). 옵션헤더(06/07) 커밋 선행 | B-4 |
| D-열재단-DDL | 열재단 PROC_000084 DDL 적용 승인 | `11_ddl_proposals/heat-cut-process-proposal.sql` 적용. proc_cd 채번=라이브 MAX 재확인 후 후니 배정 | B-3 |
| D-siz-REG | siz 77규격 등록 승인 | SIZ_000538~000618 master-data 등록 | B-1·B-2·G-1 |
| D-formbuilder | R-GAKMOK 폼빌더 입력방식 | 배열 1행 `in`-멤버십 직접입력 vs 75 단일행 분해(F-1 미검증) | G-1 |
| D-POSTER-FIXED | 기존 PRF_POSTER_FIXED 바인딩 정리 | PRD_000138 이 적재 후 2공식(PRF_POSTER_FIXED + PRF_BANNER_NORMAL) 공존. 기존 sparse 바인딩 정리(파괴적 DELETE/use_yn)는 본 트랙 밖·인간 승인 | (품질) |
| D-큐방-enum | 큐방 부착 enum 확장 | 큐방 ∉ 부착 enum(라벨/맥세이프/끈/테입) → 자재 mint(D-MAT-MINT) + 부착 `대상` enum 큐방 추가 [CONFIRM] | B-5 |

> [HARD] 본 차단/GAP 은 발명·침묵 back-fill 0. 미적재 데이터는 명시 분리(`*_BLOCKED.csv`/`_GAP.csv`/`_blocked/`)하고 해소 조건을 행마다 기재. **[v2] 가격(옵션 추가가)은 자재 mint·공정 차단과 독립으로 INSERTABLE**(옵션 레이어 차단이 가격 적재를 막지 않음). v1 대비 BLOCKED 증가(자재 seq 노출)는 결함 아니라 **정직**(v1이 자재 의미 누락 과소계상한 것을 v2가 자재 차원으로 드러냄).
