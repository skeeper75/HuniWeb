# 문구(stationery) — 적재 로직 + 라이브 재측정 델타 (loadlogic-notes)

> **작성** 2026-06-14 · round-13 라이브 정정 트랙. `17_correctness/stationery/loadlogic-notes.md`(2026-06-11)를 토대로, **2026-06-14 라이브 직접 재측정으로 stale 보정**.
> **[HARD] oracle 용도:** `sql/`=스키마 구조 권위. `load_master.py`=적재로직 진단 재구성용(정답 아님). v03 데이터값=정답 참조 금지(피고). 정답=원본 엑셀 L1 260610.
> **핵심:** load_master.py가 읽는 소스는 **v03 마이그레이션 엑셀**(피고). 결함 다수가 v03 셀 자체 결함의 전파다. load_master는 v03을 TRUNCATE+재적재한 거울 → DB 직접 정정(v03 우회·멱등).

---

## 1. 재구성된 적재 규칙 (round-13 산출 계승 — 변동 없음)

전체 파이프라인·R-CAT/R-MAT/R-PMAT/R-PROC/R-PAGE 규칙은 `17_correctness/stationery/loadlogic-notes.md` §0~1과 동일(재유도 금지). 요지:

- **R-PMAT usage(`load_rel_materials:324` `r["용도"] or "공통"`):** v03 용도 셀 공란 → USAGE.07 공통 fallback = 종이 결함 원천(L-ST-A).
- **R-CAT(`load_categories:175` + `load_rel_categories:288`):** v03 상위코드 공란 → upr=NULL 고아 노드(CAT_000300) + 상품을 고아에 연결(L-ST-C).
- **R-MAT 코팅 분해 부재:** `아트250 + 무광코팅`을 한 자재행으로 평면화(L-ST-B).
- **R-PROC(`load_rel_processes:415`):** v03 `필수공정여부` 그대로 → 떡제본 mand 097=N·179=Y 비일관 전파(L-ST-E). 미싱제본 행 부재 → 라이브 0행(L-ST-F).
- **R-PAGE(`load_rel_page_rules:453`):** 잡음 검증 없이 떡메모 3/3/3 적재(L-ST-G).
- **가격:** load_master 미관여(round-2 트랙) → 라이브 0행(L-ST-J).

---

## 2. 라이브 재측정 델타 (2026-06-14 — round-13 대비 변동·확인)

| 결함 ID | round-13(06-11) 기록 | 라이브 재측정(06-14) | 판정 변동 |
|---------|----------------------|----------------------|-----------|
| **ST-04 레더** | MAT_000186=MAT_TYPE.08 실사소재 (AMBIGUOUS) | **MAT_000186=MAT_TYPE.06 가죽** (USAGE.02·174/175 연결) | **AMBIGUOUS → CORRECT** — 레더 BATCH-4(.08→.06) 선적용분 반영. round-13 .08 주장은 **stale**. 정정 불요 |
| **ST-01 카테고리** | 172~176 고아 CAT_000300 | 동일 확인(172~176 main=Y CAT_000300·upr=NULL·lvl3) | 변동 없음 — 정정 유효 |
| **ST-01 노드순** | F-ST-G1 노드순≠prd_cd순 | 실측 확인(119=레더소프트·120=레더하드·121=소프트·122=하드·123=먼슬리) | 변동 없음 — 의미 매칭 필수 재확인 |
| **ST-02 종이 usage** | 백모조 USAGE.07 공통 | 동일 확인(176~181 .07·097 .01+.07 중복) | 변동 없음 — 정정 유효 |
| **ST-05 떡제본 mand** | 097=N·179=Y 불일치 | 동일 확인 | 변동 없음 |
| **ST-06 미싱제본** | 172=코팅만·175=0행·176=코팅만 | 동일 확인(172=무광만·175=0행·176=무광만) | 변동 없음 — MISSING 유효 |
| **ST-07 page_rule** | 097 3/3/3 | 동일 확인(097=3/3/3·176=28/28/0) | 변동 없음 |
| **ST-12 B세트** | 173/174 sets 0행 | 동일 확인(097→098만) | 변동 없음 |
| **ST-13 가격** | 0행 | 동일 확인(0) | 변동 없음 |
| **ST-15 bundle dflt** | 50/100 둘 다 Y | 동일 확인 | 변동 없음 |

> **핵심 stale 정정 1건:** ST-04 레더 — round-13 분석 시점(06-11)은 레더 일괄 교정(BATCH-4 .08→.06, CHANGELOG 06-14) **이전**이라 .08로 기록. 06-14 재측정 결과 이미 .06 정합 → 정정 대상에서 제외. **교훈: load_master TRUNCATE 재적재가 직접 교정을 회귀시킬 수 있으나, 본 건은 회귀 없이 .06 유지 확인**(직접 정정 안정).

---

## 3. 스키마 실측 보정 (apply.sql 정확성에 영향)

| 발견 | 라이브 information_schema 실측 | apply.sql 반영 |
|------|-------------------------------|----------------|
| `t_prd_product_materials` PK | (prd_cd, mat_cd, usage_cd) 복합 | usage_cd는 PK 일부 → in-place UPDATE 불가 → **새 .01행 INSERT + 구 .07행 논리삭제(del_yn)** |
| `t_prd_product_materials` note | **컬럼 부재** (del_yn/del_dt 보유) | 종이 정정 변경이력은 reg_dt/del_dt + 매니페스트로 추적(note 미사용) |
| `t_prd_product_categories` note | 컬럼 실재(nullable) | 카테고리 재연결 note에 "정정 …" 변경이력 기록 |
| `t_prd_product_categories` PK | (prd_cd, cat_cd) 복합 | cat_cd UPDATE 불가 → INSERT 신규 + 고아 논리강등 |
| 제본 family(PROC_000017 자식) | 8종(미싱제본 부재) + PROC_000030 미싱(후가공·upr=NULL) + PROC_000074 6단미싱접지(접지 자식) | 미싱제본 search-before-mint 후보 0 입증 → mint=ddl-proposer(Q-ST-A) |

> **round-13 가정 검증:** round-13 correction-manifest의 "PK=(prd_cd,mat_cd,usage_cd)"·"materials note 부재" 가정이 06-14 information_schema로 **확정**. apply.sql은 이 실측에 맞춰 INSERT+논리삭제 패턴(in-place usage UPDATE 회피)으로 작성.

---

## 4. 적재 경로 불명 / 트랙 외 (finding 자체)

- **plate output_paper_typ_cd 전부 NULL:** load_rel_plate_sizes가 폴더(디지털인쇄/특수인쇄)를 출력용지규격으로 적재 안 함. 출력용지규격 vs 견적밖 라우팅 미결(Q-ST-C=Q-BK-C).
- **가격(ST-13):** load_master 밖(round-2 책임). 본 라운드는 매핑 경로만(고정형 PRF·떡메모 매트릭스).
- **미싱제본 신설:** v03 15시트에 미싱제본 행 부재 → 라이브 0행. seed에도 제본 family 미싱제본 부재. 신설은 ddl-proposer + 인간 컨펌(Q-ST-A).

---

## 5. 적재로직 정합(결함 아님) — 라이브가 정답과 일치

- 상품 12행·prd_cd 채번·만년다이어리 4 별상품 적재 = L1 별 MES 정합.
- 무지내지(MAT_000261) USAGE.01·트윈링/중철/떡/하드커버무선 제본 enum→PROC 정합.
- 먼슬리 page 28/28/0·떡메모 bundle 50/100권·단양면 인쇄면 정합.
- 떡메모지 sub_prd(098)·sets(097→098) 정합(내지 반제품·자재 권위=parent).
- **레더(174/175) MAT_TYPE.06 가죽 = 정합(06-14 재측정·BATCH-4 적용분).**
