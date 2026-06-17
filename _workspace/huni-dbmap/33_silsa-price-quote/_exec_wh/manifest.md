# 신안(siz_width/siz_height 구간) 실행본 manifest — round-23

> 작성 2026-06-17 · dbm-load-builder. 입력 = `poster-sign-component-redesign.md`(V1~V3) + `webadmin-change-mapping-v2.md`(siz_width/height 라이브 상태·'이하' 상한 매칭) + round-16 `poster-sign-import.xlsx`(가격표 verbatim 셀) + 라이브 read-only psql.
> **설계 + 롤백전용 DRY-RUN GO까지 — 실 COMMIT은 인간 승인(`apply.sh --commit`).** 단가행 = 가격표 verbatim(날조 0). 좌표 siz 채번 0(U1 폐기).

## 단위별 대상·행수·순서

| 단위 | 테이블 | 조치 | 행수(PASS1 실측) | 멱등키 |
|------|--------|------|:--:|--------|
| **V1** 면적 단가행 | t_prc_component_prices | 가격표 [가로×세로] 667 셀 → (comp_cd, siz_width, siz_height, unit_price) INSERT | **INSERT 667** | 자연키 15(siz_width/height 포함·NOT EXISTS) |
| **V1b** 라이브 siz_cd 전환 | t_prc_component_prices | 기존 매트릭스 siz_cd 17행 → siz_width/siz_height in-place 전환(값 불변·work_width/height 기준) | **UPDATE 17** | siz_cd IS NOT NULL & siz_width IS NULL |
| **V2** use_dims 전환 | t_prc_price_components | 본체 13 면적 comp use_dims (siz_cd 포함) → ["siz_width","siz_height"] | **UPDATE 13** | comp_cd & use_dims @> [siz_cd] |
| **V3** off-grid nonspec | t_prd_products | 13 면적상품 nonspec_width_incr/height_incr 백필(포스터 200·현수막 100) | **UPDATE 13** | prd_cd & incr IS NULL |
| ~~U1 좌표 siz 채번~~ | — | **폐기**(신안=siz_width/height 직접·채번 0) | 0 | — |

**적재 순서(FK 위상·apply.sql 단일 트랜잭션):** V1(INSERT) → V1b(siz_cd 전환) → V2(use_dims 전환) → V3(nonspec). V1/V1b 가 V2(모델 전환) 전에 데이터를 채워 가격 공백 0.

**총 매트릭스 커버리지:** 667(GAP 신규) + 17(라이브 siz_cd 전환) = **684 distinct 셀**(comp,w,h 충돌 0·내부 dup 0). 설계 "687"은 GAP 667+라이브~20 합산 근사치였고, verbatim 실측은 667+17=684.

## BLOCKED / 정직 분류

| ID | 항목 | 상태 |
|----|------|------|
| (없음·V1~V3 전건 적재가능) | 가격표 셀 667 전건 추출 성공(null price 0·dup 0)·라이브 siz_cd 17 전환 가능·nonspec 컬럼 실재 | — |
| Q-PR-1 | 최대 구간 상한 = 명시값(W max 3000/5000) → 초과 시 ERR_ABOVE_MAX(엔진). NULL ∞ catch-all 미사용 | 적용됨(골든4 실증) |
| Q-PR-3 | 아크릴 동형 전환 | **별 트랙 BLOCKED**(라이브 부분진화 재실측 선행·본 실행본 범위 외) |
| Q-PR-4 | 고정가 15 = siz_cd 유지(구간 아님) | 본 실행본 미포함(면적 13만 전환) |

> ★설계 대비 정정(라이브 실측): ① **WATERPROOF_PET use_dims=["siz_cd","min_qty"]**(잉여 min_qty·실제 행 min_qty 없음=B03 면적매트릭스) → V2 WHERE를 `@> [siz_cd]`로 하여 13 comp 전건 전환. ② **라이브 siz_cd 17행**(600x1800·900x900·900x1200·1500x1000·GAP 667과 비충돌)을 V1b로 in-place 전환 — 설계의 단순 "687 INSERT"는 이 17행을 중복/고아화하므로 분리 처리.

## undo / 백업

- `apply.sh`가 COMMIT/DRY-RUN 무관 사전 백업 3종 저장:
  `backup_matrix_comp_prices_pre.csv`(13 comp 단가행)·`backup_use_dims_pre.csv`(COMP_POSTER_* use_dims)·`backup_nonspec_pre.csv`(상품 nonspec).
- undo SQL(실 COMMIT 후): V1=신규 siz_width/height 행 DELETE(comp_cd IN 13 AND siz_width IS NOT NULL AND apply_ymd='2026-06-01')·V1b=siz_width/height→siz_cd 역전(백업 CSV)·V2=use_dims ["siz_cd"] 복원·V3=incr NULL 복원.
- 비파괴: V1=INSERT·V1b/V2/V3=UPDATE. hard-delete 없음 → DRY-RUN ROLLBACK이 1차 안전망.

## 산출물

- `V1_area_unitprices.sql`(667 INSERT) · `V1b_convert_live_sizcd.sql`(17 UPDATE) · `V2_use_dims_switch.sql`(13) · `V3_nonspec_incr.sql`(13)
- `apply.sql`(FK순 단일 트랜잭션·기본 ROLLBACK) · `apply.sh`(env·백업·--commit 게이트) · `_gen.py`(결정적 재현 생성기)
- `dryrun-report.md`(R1~R6) · `manifest.md`
