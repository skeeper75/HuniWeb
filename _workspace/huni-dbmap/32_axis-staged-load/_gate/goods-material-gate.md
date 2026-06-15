# GPM-1/2 굿즈/파우치 본체 자재 명확분 41행 적재본 — X1~X6 독립 게이트 (round-22 · 자재축 ④)

> **검증** 2026-06-16 · `dbm-validator`(생성자와 독립·2-pass DRY-RUN 직접 실행). 라이브 read-only SELECT만.
> **대상** `_exec_goods_material/gpm12-mapping.md`(41상품 매핑) + `apply.sql`(멱등 INSERT).
> **판정 한 줄: 41행 라이브 적용 GO. X1~X6 전건 PASS. 오매핑 0 · 모호분 혼입 0 · 멱등 2-pass(41→0) 실증.**

---

## 0. 라이브 재측정 핵심 수치 (독립 SELECT · 2026-06-16)

| 항목 | 생성자 주장 | 검증자 독립 실측 | 일치 |
|------|------------|------------------|:--:|
| 자재 6종 실재·use_yn=Y | 6종 Y | 6종 전부 use_yn=Y | ✅ |
| 레더 mat_typ | MAT_TYPE.06 가죽 | MAT_000008=레더 MAT_TYPE.06 | ✅ |
| 메쉬/린넨/캔버스/타이벡 mat_typ | MAT_TYPE.05 원단 | 183/184/185/187/188 전부 .05 | ✅ |
| usage 분포 | .07=597 .02=67 .01=49 .03=15 .05=2 | byte-identical | ✅ |
| USAGE.07=공통 실재 | 본체 슬롯 | cod_nm='공통' 실재 | ✅ |
| PK 컬럼 | (prd_cd,mat_cd,usage_cd) | 동일 | ✅ |
| 41 prd_cd 실재 | 41 | DISTINCT 41 | ✅ |
| 현재 본체 .05/.06 link | 0건 | **0건** | ✅ |
| 41상품 기존 link | .09(형상/사이즈)·.08 | MAT_TYPE.09 39 link(일부 미연결) | ✅ |
| reg_dt/del_yn DEFAULT | now()/'N' | NOT NULL+DEFAULT 실측 | ✅ |
| 신규 mint | 0 | 최대 자재코드=MAT_000340 → 188까지 재사용·신규 0 | ✅ |
| 생성자 SQL COMMIT 여부 | 미COMMIT | 굿즈 본체 link 0·MAT_000008 라이브 연결 0행 → 미COMMIT 확인 | ✅ |

---

## 1. X1~X6 게이트 PASS/FAIL

### X1 권위 정합 — PASS
- 41 명확분 + 14 BLOCKED 상품명 **전부** `goods-pouch-l1.csv`(103 distinct) 실재. v03 미참조.
- **키워드별 전수 대조(권위 CSV)**:
  - 레더 25개 = 명확분 23 + BLOCKED 2(레더라벨제작=부자재 라벨·레더스트랩키링=키링 부속). 정확.
  - 캔버스 10개 = 명확분 9 + BLOCKED 1(캔버스 스트랩 라벨파우치). 정확.
  - 린넨 5개 = 전부 명확분 5. 정확.
  - 메쉬 4개 = 전부 명확분 4. 정확.
  - 타이벡 11개 = 전부 BLOCKED(하드/소프트 모호). 명확분 0. 정확.
- **라이브 41 prd_cd→prd_nm 전수 대조**: 41/41 apply.sql 주석 prd_nm과 정확 일치. **오매핑 0.**
- 모호분(라벨·키링·스트랩라벨)이 명확분에 **혼입 0**.

### X2 freshness — PASS
- 착수 시점 라이브 전수 재실측. 자재 6종·usage 분포·USAGE.07·PK 전부 실측 일치. stale 인용 0.

### X3 경계오염 0 — PASS
- 41행은 진짜 본체 소재(원단/가죽) 매핑 — 형상(.09)/색(.08) 오염행과 무관(다른 mat_typ·다른 PK).
- BLOCKED 14 정당: 타이벡 11=하드(187)/소프트(188) 2행 실재로 상품명만으로 미확정 → 추측 회피 정당. 모호 3(라벨/키링/스트랩라벨)=본체 소재 판정 불가 → escalate 정당(PRD_000241 라이브 .08 1건만).

### X4 구조 보존 — PASS
- apply.sql `ON CONFLICT (prd_cd,mat_cd,usage_cd)` = 라이브 PK 정확 일치.
- usage_cd=USAGE.07 = 라이브 굿즈파우치 본체 슬롯 컨벤션 정합(분포 597).
- dflt_yn='Y'·disp_seq=1 = 단일 본체 소재 컨벤션 정합.

### X5 적용 안전성 [핵심] — PASS
- **(a) FK 정합**: prd_orphan 0 · mat_orphan 0 · usage_orphan 0.
- **(b) 멱등**: 독립 2-pass DRY-RUN — PASS1 INSERT 41 · PASS2 재실행 INSERT **0**. 현재 link 0이라 skip 0.
- **(c) 제약위반0·NOT NULL**: null_regdt 0 · null_delyn 0(전부 'N'). reg_dt/del_yn DEFAULT 발효.
- **(d) 가역**: DELETE 41행 정확 제거 가능(기존 .09/.08 무영향).

### X6 비파괴·독립·코드불변 — PASS
- 생성자 SQL 미재실행 — 검증자가 매핑표 §1에서 독립 페어 구성해 별도 INSERT로 재현.
- 신규 mint 0(자재행 재사용·최대코드 MAT_000340 불변).
- 생성자 미COMMIT 확인(굿즈 본체 link 0·MAT_000008 라이브 연결 0행). 라이브 무변경.

---

## 2. 41상품 매핑 비준/반증

- **비준: 41/41 정확.** 오매핑 0 · 모호분 혼입 0.
- 레더23(MAT_000008 .06)·캔버스9(MAT_000185 .05)·린넨5(MAT_000184 .05)·메쉬4(MAT_000183 .05) — 라이브 prd_nm·mat_typ 전수 정합.
- BLOCKED 14 정당 분리(타이벡 11 모호·모호 3).

## 3. 41행 라이브 적용 GO/NO-GO

**GO.** 멱등 INSERT 41행(현재 .05/.06 link 0 → skip 0)·FK고아0·제약위반0·NOT NULL 충족·가역. 독립 2-pass(41→0) 멱등 실증. 실 COMMIT은 인간 승인(경로 Y 개발자 재적재 권장 — 라이브 직접 SQL은 P-TRUNCATE 소멸 전제).

## 4. 발견 오류

- **CRITICAL/MAJOR 0건.**
- (MINOR·문서) apply.sql GUARD0는 4종(008/183/184/185)만 검사 — 본 INSERT 대상은 4종뿐이라 정합(187/188은 BLOCKED라 미사용). 결함 아님.
- (관찰) 41상품 기존 .09 link도 dflt_yn='Y' — 본체 소재 선적재 후 GPM-4(비소재 link 제거·dflt 정리)가 후속 처리해야 dflt 중복 해소(매핑표 §3 명시·본 단계 범위 외). 순서 [HARD] 준수됨.
