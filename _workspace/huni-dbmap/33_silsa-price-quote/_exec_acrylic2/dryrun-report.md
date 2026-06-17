# 아크릴 마무리 실행본 — 라이브 롤백전용 DRY-RUN 리포트 (round-23·_exec_acrylic2)

> **작성** 2026-06-17 · `dbm-load-builder`. 입력 권위 = `acrylic-blocked-resolution.md`(arbiter A5 가드·코롯토 B2~B4·BLOCKED) · 라이브 2026-06-17 직접 재실측 · `20_price-import/acrylic/acrylic-import.xlsx` 시트 `5_korotto_NEW` verbatim · `webadmin pricing.py`(component_subtotal .02).
> **실 COMMIT 0 · DDL 0 · 채번 0 · 비밀값 미출력.** 설계+DRY-RUN GO까지. 실 적용 = 인간 승인.

---

## 0. 결론 5줄

1. **영향행수**: A5 UPDATE **81**(.02 min_qty NULL→1) · B2 INSERT **1**(코롯토 comp) · B3 INSERT **21**(코롯토 단가행) · B4 INSERT **2**(공식 1 + 배선 1) = 총 105행 영향.
2. **멱등 2-pass delta 0**: PASS-2 전건 0행(`UPDATE 0` / `INSERT 0 0`×4). 단일 트랜잭션·롤백전용.
3. **A5 보정 후 .02 min_qty NULL = 0**(전수 해소·엔진 `÷min_qty` ValueError 견적 불가 제거). CLEAR3T min_qty=1 = 165(84 기존 + 81 보정). 골든 불변(÷1=×1).
4. **코롯토 골든 GO**: 30×30=3,600·50×30=4,400(W앞)·70×80(GAP)=8,400·80×80=8,400 (가격표 B06 verbatim)·siz_width/siz_height 룩업·min_qty=1·use_dims `[siz_width,siz_height]`. 채번 0(siz_cd 17 siz_nm 파싱 + GAP 4 GxS).
5. **FK 고아 0**(comp/wiring comp/wiring frm)·중복 0·price NULL 0·실 SQL work 참조 0·t_siz_sizes 미접촉·COMMIT 0(끝 ROLLBACK)·평문 비밀값 0·백업 3종+undo round-trip diff 0.

---

## 1. 영향행수 (단위별)

| 단위 | 테이블 | 조치 | 영향행수 | 근거 |
|------|--------|------|:--:|------|
| A5 | t_prc_component_prices | .02 + siz_width NOT NULL + min_qty NULL → min_qty=1 (전수) | **UPDATE 81** | 라이브 실측 CLEAR3T(.02) 결함 81행 |
| B2 | t_prc_price_components | COMP_ACRYL_COROTTO 신설(.01·use_dims WH) | **INSERT 1** | search-before-mint: 라이브 코롯토 comp 0행 |
| B3 | t_prc_component_prices | 코롯토 단가행 21 verbatim(siz_width/height·채번 0) | **INSERT 21** | 5_korotto_NEW B06: siz_cd 17 + GAP 4 |
| B4 | t_prc_price_formulas / formula_components | PRF_COROTTO_ACRYL 공식 + 배선(disp_seq=1·addtn_yn=N) | **INSERT 2** | 면적매트릭스 본체 단일 comp |

## 2. A5 긴급 보정 검증 (★돈-크리티컬·이미 COMMIT된 결함)

- **결함**: A2(이전 COMMIT)가 .02 comp(CLEAR3T)에 GAP siz_width 행 81건을 적재하며 **min_qty NULL**. 엔진 `pricing.py:177-192 component_subtotal`: .02 = `unit_price ÷ tier_min_qty × qty`. `tier_min_qty ≤ 0`(NULL)이면 `ValueError` raise → 합산 제외 = **견적 불가**.
- **보정**: `.02 + siz_width NOT NULL + min_qty NULL` 단가행 전건 → `min_qty=1`. 전수(comp 하드코딩 아닌 `prc_typ_cd='PRICE_TYPE.02'` 조인). `.01` 단가형은 `÷min_qty` 안 하므로 제외(MIRROR3T .01 52행 NULL은 안전·보정 안 함).
- **보정 후 검증**: `.02 + siz_width + min_qty NULL` = **0**(견적 불가 행 소멸). CLEAR3T `min_qty=1` = 165(84 라이브 + 81 보정).
- **골든 불변**: `min_qty=1` → `unit_price ÷ 1 × qty = unit_price × qty` = 단가형(.01)과 수학적 동일. 30×30 3T 100개 = `3,100 ÷ 1 × 100 = 310,000`(보정 전후 가격 차이 0).

## 3. 멱등성 증명(R1) — DRY-RUN 2-pass (단일 트랜잭션)

```
PASS 1 :  UPDATE 81 / INSERT 0 1 / INSERT 0 21 / INSERT 0 1 / INSERT 0 1
PASS 2 :  UPDATE 0  / INSERT 0 0 / INSERT 0 0  / INSERT 0 0 / INSERT 0 0   ← delta 0
```
- A5 멱등키: `min_qty IS NULL`(보정되면 재매칭 0).
- B2/B4 멱등키: `comp_cd`/`frm_cd` PK + `(frm_cd,comp_cd)` `NOT EXISTS`.
- B3 멱등키: 자연키 `(comp,apply_ymd,siz_width,siz_height, 그외 차원 NULL)` `NOT EXISTS`.

## 4. 코롯토 골든 — 가로×세로 룩업 (가격표 B06 verbatim)

| 좌표 | unit_price | 출처 | min_qty |
|------|:--:|------|:--:|
| 30×30 | 3,600 | siz_cd SIZ_000330 siz_nm 파싱 | 1 |
| 50×30 | 4,400 | siz_cd SIZ_000493(W앞 비대칭 검증) | 1 |
| 70×80 | 8,400 | GAP `(미채번:70x80)` GxS 직접 | 1 |
| 80×80 | 8,400 | siz_cd SIZ_000043 | 1 |

- comp: `COMP_ACRYL_COROTTO`·prc_typ `.01` 단가형·use_dims `["siz_width","siz_height"]`.
- 공식: `PRF_COROTTO_ACRYL`(use_yn=Y)·배선 disp_seq=1·addtn_yn=N.
- 채번 0: siz_cd 17 라이브 siz_nm 전건 clean WxH 파싱(dirty 0) + GAP 4 GxS 직접. t_siz_sizes 미접촉.
- 21조합 distinct WH(내부 중복 0).

## 5. 무결성 (R5 라이브 DRY-RUN — 제약위반 0)

| 검사 | 결과 |
|------|:--:|
| FK 고아(코롯토 단가행 comp_cd → t_prc_price_components) | **0** |
| FK 고아(배선 comp_cd → price_components / frm_cd → price_formulas) | **0 / 0** |
| 코롯토 자연키 중복(siz_width,siz_height) | **0** |
| 코롯토 unit_price NULL | **0** |
| A5 보정 후 .02 min_qty NULL | **0** |
| 신규 siz_cd 채번(t_siz_sizes INSERT) | **0** |
| 실 SQL work_width/height 참조 | **0** |
| 실 SQL COMMIT 문 | **0**(apply.sql 끝 ROLLBACK) |

## 6. undo / 백업

- `apply.sh dryrun` 백업: `backup_a5_minqty_pre.csv`(81행·보정 전 min_qty NULL·comp_price_id) · `backup_korotto_comp_pre.csv`(0행=신설 전 부재) · `backup_korotto_formula_pre.csv`(0행).
- `undo.sql`/`undo.sh`(기본 DRY-RUN·`--commit` 인간 승인): B4 배선/공식 DELETE → B3 단가행 DELETE → B2 comp DELETE → A5 min_qty 1→NULL 복원(백업 comp_price_id 기준).
- **round-trip 실증**: apply→undo 한 트랜잭션에서 A5 양방향 diff 0·코롯토 comp/단가행/공식/배선 전건 0 복귀(과삭제 0·신설분만). 적재 전 상태로 완전 복원.

## 7. BLOCKED (이번 미적재·`acrylic2-blocked.BLOCKED.sql`)

| ID | 항목 | 사유 |
|----|------|------|
| Q-ACR-9 | 미러 공식·바인딩 | 라이브 미러3T 본체 상품 0개·CPQ 소재옵션 선결·추측 금지(단가행 축전환만 됨) |
| Q-ACR-CARA-OPT | 카라비너 comp/단가행 | 형상 4 opt_cd(OPV) 채번 선행·PRD_000166 비활성 LOW |
| Q-ACR-CO1 | 코롯토 바인딩(B5) | 코롯토 4상품 정체 컨펌 후(입체/쉐이커/포카=매트릭스?)·comp/단가행/공식은 GO |
| Q-ACR-7b | CLEAR3T .02 시맨틱(.01 정정) | 가격 무영향(min_qty=1)·webadmin 개발자 컨펌 LOW |

## 8. R1~R6 종합 (load-builder 자기 검증 — 최종 GO는 dbm-validator)

| Gate | 결과 | 근거 |
|------|:--:|------|
| R1 멱등성 | PASS | 2-pass delta 0 |
| R2 트랜잭션 원자성 | PASS | 단일 BEGIN…ROLLBACK·partial-commit 0 |
| R3 실행성 | PASS | A5·B2~B4 0 syntax error·apply.sh psql 정상 |
| R4 DDL 제안 | N/A | 신규 엔티티 0(코롯토=기존 t_prc_* 스키마 INSERT) |
| R5 라이브 DRY-RUN | PASS | 제약위반 0·A5 결함 해소·코롯토 골든·롤백 |
| R6 독립 검증 | 대기 | load-builder 생성·dbm-validator 게이트 |
