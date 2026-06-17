# 아크릴 가로/세로 구간 동형 전환 — 라이브 롤백전용 DRY-RUN 리포트 (round-23·_exec_acrylic)

> **작성** 2026-06-17 · `dbm-load-builder`. 입력 권위 = `acrylic-wh-isomorph-design.md`(arbiter A1~A4+배선보정) · 라이브 2026-06-17 직접 재실측 · `20_price-import/acrylic/acrylic-import.xlsx` 시트 `4b_component_prices_GAP` verbatim.
> **실 COMMIT 0 · DDL 0 · 채번 0 · 비밀값 미출력.** 설계+DRY-RUN GO까지. 실 적용 = 인간 승인.

---

## 0. 결론 5줄

1. **영향행수**: A1 UPDATE **121**(siz_cd→siz_width/height 전환) · A2 INSERT **96**(GAP verbatim) · A3 UPDATE **2**(use_dims) · AW UPDATE **1**(배선) = 총 220행 영향. 전환 후 아크릴 본체 매트릭스 단가행 **217 distinct**(121+96, 충돌 0).
2. **멱등 2-pass delta 0**: PASS-2 전건 0행(`UPDATE 0` / `INSERT 0 0` / `UPDATE 0`×3). 단일 트랜잭션·롤백전용.
3. **골든 재현 GO**: 30×30 3T=3,100·1.5T=2,480 / 50×50 3T=4,800·1.5T=3,840 / 100×100 3T=12,700·1.5T=10,160 (**1.5T=3T×0.8 전건 정확**·two-thickness mat_cd 직교). off-grid 25×25 = 단가행 부재→엔진 '이하 최소 임계' 30×30 ceiling 매칭(DB 미저장). GAP 신규 20×40 3T=3,000·1.5T=2,400 적재 확인.
4. **siz_nm 파싱 검증(work 미사용)**: 라이브 121행 siz_nm 전건 clean `^[0-9]+x[0-9]+$`(dirty 0). A1 SET 절 = `v.siz_width/v.siz_height`(siz_nm 파싱값 직접)·**실 SQL work_width/height 참조 0**(주석 경고만). 비대칭쌍 `140x80`→W=140·H=80(work 144/84와 분리 확인).
5. **채번 0 · COMMIT 0**: `t_siz_sizes` 미접촉(신규 siz INSERT 0)·실 SQL COMMIT 문 0(apply.sql 끝 ROLLBACK)·FK 고아 0·자연키 중복 0·unit_price NULL 0.

---

## 1. 영향행수 (단위별)

| 단위 | 테이블 | 조치 | 영향행수 | 근거 |
|------|--------|------|:--:|------|
| A1 | t_prc_component_prices | siz_cd → siz_width/siz_height 전환(siz_nm 파싱·값 불변·siz_cd=NULL) | **UPDATE 121** | 라이브 CLEAR3T 84 + MIRROR3T 37 |
| A2 | t_prc_component_prices | GAP 좌표 96 verbatim INSERT(siz_width=G·siz_height=S·mat 분기) | **INSERT 96** | 4b_GAP: CLEAR3T(3T) 66 + CLEAR15T→1.5T 15 + MIRROR3T 15 |
| A3 | t_prc_price_components | CLEAR3T→[siz_width,siz_height,mat_cd]·MIRROR3T→[siz_width,siz_height] | **UPDATE 2** | use_dims [siz_cd] 토큰 행 |
| AW | t_prc_formula_components | PRF_CLR_ACRYL→CLEAR3T disp_seq=1·addtn_yn=N | **UPDATE 1** | 라이브 NULL→값 보정 |

전환 후 아크릴 본체 매트릭스 단가행 = **217**(siz_width 전건 NOT NULL·siz_cd 잔존 0).

## 2. 멱등성 증명(R1) — DRY-RUN 2-pass (단일 트랜잭션)

```
=== PASS 1 ===     UPDATE 121 / INSERT 0 96 / UPDATE 1 / UPDATE 1 / UPDATE 1
=== PASS 2 ===     UPDATE 0   / INSERT 0 0  / UPDATE 0 / UPDATE 0 / UPDATE 0   ← delta 0
```
- A1 멱등키: `comp_price_id` + `siz_cd IS NOT NULL & siz_width IS NULL`(전환되면 재매칭 0).
- A2 멱등키: 자연키 `(comp_cd, apply_ymd, siz_width, siz_height, mat_cd, 그외 차원 NULL)` `NOT EXISTS` 가드(`mat_cd IS NOT DISTINCT FROM` NULL-safe).
- A3 멱등키: `use_dims @> '["siz_cd"]'`(전환되면 토큰 사라져 재매칭 0).
- AW 멱등키: `disp_seq IS NULL OR addtn_yn IS NULL`(보정되면 재매칭 0).

## 3. 골든 재현 — 아크릴 가로×세로 구간 룩업 + off-grid + two-thickness

| 좌표 | mat=3T(MAT_000043) | mat=1.5T(MAT_000042) | ×0.8 정합 | 출처 |
|------|:--:|:--:|:--:|------|
| 30×30 | 3,100 | 2,480 | ✅ 3,100×0.8=2,480 | A1(라이브 siz_nm 전환) |
| 50×50 | 4,800 | 3,840 | ✅ ×0.8 | A1 |
| 100×100 | 12,700 | 10,160 | ✅ ×0.8 | A1 |
| 20×40 | 3,000 | 2,400 | ✅ ×0.8 | A2(GAP 신규 INSERT) |

- **off-grid ceiling**: 25×25 = 단가행 부재(`offgrid_25x25_exists=0`) → 엔진 `match_component` '이하 최소 임계'(pricing.py TIER_UPPER)로 다음 큰 구간 30×30(3,100) 자동 매칭. 단가행 ceiling 행 미생성([[dbmap-compute-in-app-db-stores-lookup]] 철학 보존).
- **two-thickness mat_cd 직교**: 동일 좌표가 3T/1.5T 두 행으로 분기(면적축 siz_width/height와 두께축 mat_cd 직교). use_dims CLEAR3T=`[siz_width,siz_height,mat_cd]`로 면적+두께 매칭, MIRROR3T=`[siz_width,siz_height]`(단가행 mat NULL).

## 4. siz_nm 파싱 검증 (★work 미사용 — 돈-크리티컬)

- 라이브 121 단가행 siz_nm 전건 clean `^[0-9]+x[0-9]+$` (실측 dirty 0).
- A1 source = `siz_nm` WxH 파싱: `split('x')[0]`=siz_width(가로·앞)·`[1]`=siz_height(세로·뒤). 비대칭쌍 `100x140`→W=100·H=140(work 104/144 ≠)·`140x80`→W=140·H=80(work 144/84 ≠) — **work_width/height(블리드 가산 작업사이즈)는 가격축 아님·미사용**.
- 실 SQL(비주석) work_width/height 참조 **0**(grep 검증). A1 SET = `v.siz_width/v.siz_height`(파싱값 직접).
- 포스터 V1b(work 기준 전환) 패턴 답습 안 함 — 아크릴은 work≠매트릭스축이라 work 전환 시 ① 틀린 단가 ② work NULL 5 siz_cd 15행 소실 위험. siz_nm 파싱이 무손실.

## 5. 무결성 (R5 라이브 DRY-RUN — 제약위반 0)

| 검사 | 결과 |
|------|:--:|
| FK 고아(mat_cd → t_mat_materials) | **0** |
| FK 고아(comp_cd → t_prc_price_components) | **0** |
| 자연키 중복(comp,siz_width,siz_height,mat,apply_ymd) | **0** |
| unit_price NULL | **0** |
| GAP 96 ↔ 라이브 121 자연키 충돌 | **0**(사전 실측) |
| 신규 siz_cd 채번(t_siz_sizes INSERT) | **0** |
| 실 SQL COMMIT 문 | **0**(apply.sql 끝 ROLLBACK) |

## 6. undo / 백업

- `apply.sh dryrun` 이 변경 대상 사전 스냅샷 저장: `backup_comp_prices_pre.csv`(121행·siz_cd·siz_width·siz_height·mat·unit_price) · `backup_use_dims_pre.csv`(2) · `backup_wiring_pre.csv`(1).
- 실 COMMIT 후 undo = 백업 CSV로 siz_cd 복원·GAP 96 DELETE·use_dims 원복·배선 NULL 원복(인간 승인 시 별 undo.sh 작성).

## 7. R1~R6 종합 (load-builder 자기 검증 — 최종 GO는 dbm-validator)

| Gate | 결과 | 근거 |
|------|:--:|------|
| R1 멱등성 | PASS | 2-pass delta 0 |
| R2 트랜잭션 원자성 | PASS | 단일 BEGIN…ROLLBACK·partial-commit 경로 0 |
| R3 실행성 | PASS | A1~A3·AW 0 syntax error·apply.sh psql 정상 |
| R4 DDL 제안 | N/A | 본 트랙 신규 엔티티 0(전환·재사용·verbatim 적재만) |
| R5 라이브 DRY-RUN | PASS | 제약위반 0·골든 재현·롤백 |
| R6 독립 검증 | 대기 | load-builder 생성·dbm-validator 게이트(self-approve 금지) |
