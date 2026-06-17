# 아크릴 가로/세로 구간 동형 전환 실행본 — 독립 검증 게이트 (round-23 · dbm-validator)

> **검증일** 2026-06-17 · `dbm-validator` (생성자 `dbm-load-builder`와 독립). 라이브 `railway` 읽기전용 + 롤백전용 DRY-RUN 직접 재실측 · 가격표 `acrylic-import.xlsx` field-for-field 재대조. **COMMIT 0 · 채번 0 · 비밀값 미출력.**
> 검증 대상: `_exec_acrylic/`(A1~A3·AW·apply.sql·apply.sh·acrylic-blocked.BLOCKED.sql·live121.json·gap96.json). 권위: live(2026-06-17) > 가격표 RU/GAP > 정립.

## 최종 판정: **GO**

R1~R6 전건 PASS. siz_nm 파싱 정확(돈-크리티컬) · verbatim(날조 0) · 골든 재현 전건 일치. BLOCKED 5건 분리 정당. self-approve 아님(생성자 주장 비신뢰·전건 독립 재측정). 실 COMMIT은 인간 승인 + 엔진 evaluate_price 동시배포 선결(BLOCKED-1 .02 계약).

---

## R게이트 PASS/FAIL (독립 재현 근거)

| Gate | 결과 | 독립 근거 |
|------|:--:|------|
| **R1 멱등성** | **PASS** | 라이브 롤백전용 DRY-RUN 2-pass 직접 실행: PASS-1 `UPDATE 121 / INSERT 0 96 / UPDATE 1 / UPDATE 1 / UPDATE 1`, PASS-2 전건 `0` (delta 0). 멱등키(comp_price_id+siz_cd NOT NULL&siz_width NULL / 자연키 NOT EXISTS / use_dims@>[siz_cd] / disp_seq·addtn_yn NULL) 전환 후 재매칭 0. |
| **R2 트랜잭션 원자성** | **PASS** | `apply.sql` 단일 `BEGIN`(L8)·단일 `ROLLBACK`(L23)·중간 COMMIT 0·`\set ON_ERROR_STOP on`(L7). FK 위상순 A1→A2→A3→AW. 부모 라이브 선존재 실측: COMP_ACRYL_CLEAR3T·MIRROR3T·PRF_CLR_ACRYL·MAT_000042/043 전건 present. |
| **R3 실행가능성** | **PASS** | DRY-RUN 0 syntax error. 라이브 information_schema 실측: `siz_width`/`siz_height` = numeric(정수값 적합)·`dim_vals` = jsonb·`apply_ymd` varchar NOT NULL(A2 명시 '2026-06-01'). A2 14차원 자연키 가드 컬럼 전건 실재(plt_siz_cd·clr_cd·proc_cd·opt_cd·print_opt_cd·coat_side_cnt·bdl_qty·min_qty·dim_vals). use_dims jsonb 라이브 일치. |
| **R4 영향행수** | **PASS** | DRY-RUN 직접 재현: A1 **UPDATE 121** · A2 **INSERT 96** · A3 **UPDATE 2**(comp별 1+1) · AW **UPDATE 1**. 라이브 A1 술어 매칭 독립 카운트 = 121(CLEAR3T 84 + MIRROR3T 37). 전환 후 본체 매트릭스 217(121+96·충돌 0). |
| **R5 siz_nm 파싱 정확성 ★돈-크리티컬** | **PASS** | A1 121행 W=앞/H=뒤 파싱 독립 재계산: siz_nm↔(siz_width,siz_height) **오류 0**, 비대칭쌍 93건 전건 정확(50x30→W50/H30 ≠ 30x50). live w/h 필드와도 121/121 일치. **work 미오염 라이브 실증**: SIZ_000045(`140x80`) work=144/84 vs A1=140/80 · SIZ_000058(`100x140`) work=104/144 vs A1=100/140 → 블리드 가산 작업사이즈 미사용. 비주석 SQL work_width/height 참조 **0**(4파일 grep). siz_nm dirty(`!~ ^[0-9]+x[0-9]+$`)=0(라이브 실측). 두께 3T(MAT_000043)/1.5T(MAT_000042)=mat_cd 직교(면적축 미오염). |
| **R6 verbatim + 골든 룩업 ★** | **PASS** | **A2 GAP 96 ↔ 가격표 `4b_component_prices_GAP` field-for-field: A2-only 0 · xlsx-only 0**(W=G·H=S·Q-ACR-AC1 mat 매핑 전건 일치). **A1 121 unit_price ↔ 가격표 `4_component_prices_RU` 재대조: mismatch 0**(값 불변 verbatim). 골든(라이브+DRY-RUN 재현): 30×30 3T=**3,100**·1.5T=**2,480**(×0.8 ✓) / 50×50=4,800·3,840(✓) / 100×100=12,700·10,160(✓) / GAP 20×40=3,000·2,400(✓). off-grid 25×25 단가행 **0**→엔진 '이하 상한' 30×30(3,100) ceiling(DB 미저장 철학 보존). GAP↔live121 자연키 충돌 **0**. |

추가 검사 전건 통과:
- **채번 0**: DRY-RUN 중 `t_siz_sizes` count=517 불변(A2는 component_prices INSERT·siz 테이블 미접촉).
- **무결성 0위반(라이브 post-transform)**: residual_siz_cd=0·unit_price_null=0·fk_orphan_mat=0·natkey_dup=0.
- **ROLLBACK 실증**: post-rollback residual_siz_cd=121(라이브 무변경)·COMMIT 0.

---

## siz_nm 파싱 · verbatim · 골든 판정

- **siz_nm 파싱**: 정확. W=가로(앞)·H=세로(뒤)를 siz_width/siz_height에 정확 적재. work_width/height(블리드) 미사용을 라이브 비대칭 케이스로 실증. **돈-크리티컬 통과.**
- **verbatim**: 날조 0. A1 값 불변(RU 재대조 0 mismatch)·A2 가격표 GAP셀 field-for-field 일치(96/96)·mat 분기(CLEAR15T→1.5T MAT42·CLEAR3T→3T MAT43·MIRROR3T→NULL) 가격표 충실.
- **골든**: 전건 일치(라이브 실측 + DRY-RUN 재현 + ×0.8 two-thickness 정합 + off-grid ceiling + GAP 신규셀).

## BLOCKED 분리 정당성 (apply.sql 미포함 확인)

`apply.sql` \i 대상 = A1/A2/A3/AW만. `acrylic-blocked.BLOCKED.sql` 활성 SQL **0건**(전 CREATE/UPDATE/INSERT 주석). 라이브 실측이 분리를 뒷받침:
- **Q-ACR-7 (.02→.01 전환)**: CLEAR3T 라이브 prc_typ_cd=PRICE_TYPE.02 실측. 엔진 계약 미확정·추측 금지 — 보류 정당. A3는 min_qty 토큰만 use_dims에서 제거(.02 유지).
- **Q-ACR-9 (미러 공식·바인딩)**: MIRROR3T 단가행만 전환(A1)·GAP(A2). 라이브 `%MIRROR%` 공식 1건 존재하나 본체 바인딩 상품 불명 → 공식/바인딩 신설 0(정당).
- **GAP-COROTTO / GAP-CARABINER**: 라이브 comp 실측 **0** → comp 자체 부재. 신설 별 트랙 정당.
- **Q-ACR-AC2 (nonspec incr 백필)**: 증가단위 미명시·추측 금지 보류 정당.

## undo 충분성

`apply.sh dryrun`이 `backup_comp_prices_pre.csv`(121)·`backup_use_dims_pre.csv`(2)·`backup_wiring_pre.csv`(1) 사전 스냅샷 저장 → siz_cd 복원·GAP 96 DELETE·use_dims/배선 NULL 원복 충분. 단 실 COMMIT 시 `undo.sh` 미작성(인간 승인 시 작성 명시) — 권고: COMMIT 전 undo.sh 선작성.

## 불일치 적발

없음. 생성자 주장(영향행수·멱등·siz_nm 파싱·verbatim·골든·채번 0·COMMIT 0) 전건 독립 재측정으로 확인. dryrun-report.md 수치와 라이브/가격표 실측 byte 일치(날조 0).

## 인간 결정 큐

1. 실 COMMIT(`apply.sh --commit`) — **엔진 evaluate_price 동시배포 선결**(BLOCKED-1 .02 계약 확정·미구현=실청구 0).
2. COMMIT 전 `undo.sh` 선작성 권고.
3. BLOCKED 5건 컨펌/신설 트랙(미러 바인딩 상품·코롯토/카라비너 comp 신설·nonspec incr 실무진 컨펌).
