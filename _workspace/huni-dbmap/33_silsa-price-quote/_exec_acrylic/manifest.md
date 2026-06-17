# 아크릴 가로/세로 구간 동형 전환 — 적재 매니페스트 (round-23·_exec_acrylic)

> arbiter `acrylic-wh-isomorph-design.md`(A1~A4+배선보정) 실행본. 단일 트랜잭션·FK 위상순·롤백전용 DRY-RUN. **실 COMMIT·DDL·코드행등록·BLOCKED는 인간 승인.**

## 산출물

| 파일 | 단위 | 테이블 | 조치 | 행수 | 멱등키 |
|------|------|--------|------|:--:|--------|
| `A1_convert_sizcd_to_wh.sql` | A1 | t_prc_component_prices | siz_cd → siz_width/siz_height 전환(siz_nm 파싱·값 불변) | UPDATE 121 | comp_price_id & siz_cd NOT NULL & siz_width IS NULL |
| `A2_gap_unitprices.sql` | A2 | t_prc_component_prices | GAP 96 좌표 verbatim INSERT(채번 0) | INSERT 96 | 자연키(comp,apply_ymd,siz_width,siz_height,mat) NOT EXISTS |
| `A3_use_dims_switch.sql` | A3 | t_prc_price_components | use_dims [siz_cd] → [siz_width,siz_height(,mat_cd)] | UPDATE 2 | use_dims @> [siz_cd] |
| `AW_wiring_fix.sql` | 배선 | t_prc_formula_components | PRF_CLR_ACRYL→CLEAR3T disp_seq=1·addtn_yn=N | UPDATE 1 | disp_seq/addtn_yn IS NULL |
| `apply.sql` | — | — | 단일 트랜잭션 \i 조립·끝 ROLLBACK | — | — |
| `apply.sh` | — | — | psql 로더(기본 DRY-RUN·`--commit` 인간 승인·백업 선행) | — | — |
| `acrylic-blocked.BLOCKED.sql` | BLOCKED | — | 차단 항목(apply.sql 미포함) | — | — |
| `gen_load_sql.py` | — | — | 결정적 생성기(live121.json + gap96.json) | — | — |
| `live121.json`·`gap96.json` | provenance | — | A1/A2 입력 원천(행별 출처) | 121/96 | — |

## 적재 순서 (FK·단일 트랜잭션)

`A1(전환) → A2(GAP INSERT) → A3(use_dims) → AW(배선)`. A1/A2가 A3(모델 전환) 전에 데이터를 채워 가격 공백 0. comp_cd/frm_cd 부모 라이브 선존재(실측).

## ★핵심 제약 준수

- **work_width/height 미사용** — 아크릴 면적축 권위 = siz_nm WxH 문자열(가격표 매트릭스 헤더). 실 SQL work 참조 0.
- **두께 = mat_cd 직교** — 3T(MAT_000043)/1.5T(MAT_000042) 면적축과 직교 유지.
- **좌표 siz 채번 0** — siz_nm in-place 파싱(A1) + GAP verbatim 수치(A2). t_siz_sizes 미접촉.
- **단가 verbatim** — A1 값 불변·A2 가격표 셀 verbatim(날조 0).
- **멱등·단일 트랜잭션·백업+undo·COMMIT 0.**

## BLOCKED (인간 승인/컨펌 후·`acrylic-blocked.BLOCKED.sql`)

| ID | 항목 | 사유 |
|----|------|------|
| Q-ACR-7 | prc_typ_cd .02→.01 전환 | 엔진 evaluate_price 계약 미확정(min_qty 룩업 후 ×수량 vs 총액). 추측 금지 |
| Q-ACR-9 | 미러 공식·바인딩 신설 | COMP_ACRYL_MIRROR3T 단가행 실재하나 본체 상품 불명. 단가행 축 전환(A1)·GAP(A2)만 |
| GAP-COROTTO | 아크릴코롯토 comp 신설 | B06 면적매트릭스·comp 자체 부재. 별 신설 트랙 |
| GAP-CARABINER | 아크릴카라비너 comp 신설 | B07 4형상 고정가·comp 자체 부재. 별 신설 트랙 |
| Q-ACR-AC2(A4) | nonspec_width/height_incr 백필 | 가격표/도메인 증가단위 미명시. 추측 적재 금지·실무진 컨펌 |

## undo

`apply.sh dryrun` 이 `backup_*_pre.csv`(comp_prices 121·use_dims 2·wiring 1) 사전 스냅샷 저장. 실 COMMIT 후 원복 = 백업 CSV로 siz_cd 복원·GAP 96 DELETE·use_dims/배선 NULL 원복(인간 승인 시 undo.sh 작성).

## 다음 (인간 승인 큐)

1. dbm-validator R1~R6 + G1~G9 carry-forward 독립 게이트 → load-execution-gate.md.
2. 라이브 실 COMMIT(`apply.sh --commit`) — 엔진 evaluate_price 동시배포 선결(엔진 미구현=실청구 0).
3. BLOCKED 5건 컨펌/신설 트랙.
