# Wave 1 교정 실행본 (적재 매니페스트) — 후니 기초코드 거버넌스

> **트랙** hbg Phase 5 Wave 1 → `dbm-load-execution` 실행본화. **작성** 2026-06-18.
> **입력 권위:** `remediation-roadmap.md`(R1~R18·Wave 1=R1~R6)·`_approval-queue.md`(Wave 1 승인)·
> `price-chain-impact.md`(가격 0참조 실측)·`03_registration/regspec-{size,category,process,material}.md`.
> **[HARD] 실 COMMIT 0** — 본 디렉터리는 멱등 SQL + 백업 + 롤백전용 DRY-RUN 실증까지. 실 적재는 인간 최종 승인.

---

## 0. 한 줄 평결

**Wave 1 6항목 전건 라이브 롤백전용 DRY-RUN GO — 영향 36행·멱등 2-pass 델타 0·제약위반 0·가격사슬 0참조.**
INSERT 0(전부 기존 행 in-place 교정). 실 COMMIT 0(BEGIN..ROLLBACK까지만). 백업 6 CSV 보유.

---

## 1. 적재 매니페스트 (항목별 행수·경로·DRY-RUN 결과)

| # | 교정 | 대상 t_* | 조치 | 영향 행수(DRY-RUN 실측) | 멱등 2회차 | 가격사슬 | 경로 |
|---|------|---------|------|:--:|:--:|:--:|------|
| R1 | SZ-1 색오염 정규화 | `t_siz_sizes` | siz_nm UPDATE | **2** | 0 | 0참조(cp 0) | 라이브 직접 + 경로 Y 백로그 |
| R2 | 카테고리 빈 고아 소프트삭제 | `t_cat_categories` | del_yn='Y'+del_dt | **11** | 0 | 무관(cat 미참조) | 라이브 직접 + 경로 Y 필수 |
| R3 | 카테고리 재연결 | `t_cat_categories` | upr_cat_cd UPDATE | **2**(302→134·304→198) | 0 | 무관 | 라이브 직접 + 경로 Y |
| R4 | 레이플랫 소프트삭제 | `t_proc_processes` | del_yn='Y'+del_dt | **1** | 0 | 0참조(연결0·cp0) | 라이브 직접 + 경로 Y |
| R5 | .10→.07 부자재 교정 | `t_mat_materials` | mat_typ_cd UPDATE(자재유지) | **16** | 0 | 0참조(typ 무관) | 라이브 직접 + 경로 Y |
| R6 | 봉투/헤더 정리 | `t_mat_materials` | del_yn='Y'+del_dt | **5**(봉투)+0(헤더 이미 Y) | 0 | 0참조(BOM 0) | 라이브 직접 + 경로 Y |

**합계: 영향 36행**(R1 2 + R2 11 + R3 2 + R4 1 + R5 16 + R6 5·헤더 6은 이미 del_yn='Y' 멱등 skip).

### 행수 정정(명세 ↔ 라이브 실측)
- **R5:** 명세 "~17" → **라이브 실측 16**(MAT_000211 와이어링 헤더가 이미 del_yn='Y'라 R6 헤더 버킷·R5 부자재 del_yn='N'은 16). 정직 표기.
- **R6:** 명세 "11(봉투/머리글/빈칸)" → 봉투 5(del_yn='N'·소프트삭제) + 헤더 6(MAT_000211/218/223/225/229/233 전건 **이미 del_yn='Y'** → `WHERE del_yn='N'` 가드로 멱등 skip). 11노드 = 5 신규 처리 + 6 기처리. 매니페스트는 신규 5만 영향.

---

## 2. DRY-RUN 실증 결과 (라이브 롤백전용·2026-06-18)

### 2.1 영향 행수 (1-pass) — `apply_wave1.sh dryrun`
```
R1_siz_정규화       2
R2_cat_소프트삭제   11
R3_cat_재연결_302   1
R3_cat_재연결_304   1
R4_proc_소프트삭제  1
R5_mat_typ교정      16
R6_봉투_정리        5
R6_헤더_정리(잔여N) 0   ← 이미 del_yn='Y' 멱등 skip
```

### 2.2 멱등성 (2-pass) — `apply_wave1.sh idempotent`
| item | pass1 | pass2 |
|------|:--:|:--:|
| R1 | 2 | **0** |
| R2 | 11 | **0** |
| R3a/R3b | 1/1 | **0** |
| R4 | 1 | **0** |
| R5 | 16 | **0** |
| R6env/R6hdr | 5/0 | **0** |

**pass2 합계 = 0 → 멱등 PASS.** 가드(`WHERE del_yn='N'`·`IS DISTINCT FROM`)로 2회차 전건 no-op.

### 2.3 제약위반 어서션 — 전건 0
| 검사 | 위반 | 의미 |
|------|:--:|------|
| FK_orphan_R3 | 0 | 재연결 부모 CAT_000134/198 실재(고아 0) |
| FK_mattyp07 | 0 | mat_typ_cd='MAT_TYPE.07' base_code 실재 |
| R2_cat_link | 0 | 소프트삭제 11카테고리 상품 링크 0 |
| R6_env_bomlink | 0 | 봉투 placeholder 5 BOM 링크 0 |

**제약위반 0(type/length/NOT NULL/CHECK/FK/PK) — 라이브 BEGIN..ROLLBACK 실증.**

---

## 3. 멱등 메커니즘 (ON CONFLICT 아닌 WHERE 가드)

본 wave는 **INSERT 0·전부 기존 행 in-place UPDATE** → 멱등성은 `ON CONFLICT`가 아니라 **WHERE 가드**:
- **소프트삭제(R2/R4/R6):** `WHERE del_yn='N'` — 이미 'Y'면 0행(skip). del_yn·use_yn 둘 다 추적.
- **값 교정(R1/R3/R5):** `... IS DISTINCT FROM 목표값` 또는 `mat_typ_cd='MAT_TYPE.10'` 선행조건 — 이미 교정값이면 0행.

[HARD] `del_yn='Y'`(조회/BOM/가격 선택지 차단 권위·`admin.py`·`views.py` 필터)·**use_yn 아님**([[dbmap-del-yn-soft-delete-authority]]).

---

## 4. 경로 혼합 권고 (라이브 직접 ↔ 경로 Y·침묵 선택 금지)

| 항목 | 라이브 직접(경로 X·즉효) | 경로 Y(근본·영구) |
|------|--------------------------|-------------------|
| R2/R4/R6 소프트삭제(del_yn='Y') | 즉효·가역. **★TRUNCATE 재적재 시 'N' 휘발**(load_master del_yn 미명시→DEFAULT 'N') | v03 오염행/고아/placeholder 제거·재적재 = 영구 |
| R1/R3/R5 in-place UPDATE | 즉효·멱등. TRUNCATE 재적재 시 v03 원값으로 휘발 | v03 셀(siz_nm 색·카테고리 부모·mat_typ) 교정 후 재적재 |

> **★권위(round-22 v2):** load_master=무변환 전파기 → 오류 진원 ⓐ(v03) → 근본=경로 Y(교정 v03 재적재).
> 라이브 직접은 즉효이나 휘발(특히 del_yn='Y'). **소프트삭제·값교정 전건 경로 Y 백로그 필수**(휘발 방지).
> webadmin 코드 수정 금지(개발자 GitHub 배포·read-only). 경로 Y 백로그 = `05_remediation/_backlog/`(개발자 협업).

---

## 5. 산출 파일

| 파일 | 역할 |
|------|------|
| `apply_wave1.sql` | 멱등 교정 SQL(8 UPDATE 블록·BEGIN/COMMIT 없음·로더가 래핑·provenance 주석) |
| `apply_wave1.sh` | 로더(기본 dryrun·idempotent 2-pass·backup·commit[인간승인]). 비밀번호 stdout 미노출 |
| `backup_wave1.sql` | 현재 상태 read-only 스냅샷(\copy → backup_*.csv) |
| `backup_R{1..6}_*.csv` | 교정 대상 행 현재 상태(undo 근거·2026-06-18) |
| `undo_wave1.sql` | 실 COMMIT 후 원복용(백업 스냅샷 기준) |
| `README.md` | 본 매니페스트 |

### 실행법
```
./apply_wave1.sh backup       # 백업 스냅샷(read-only)
./apply_wave1.sh dryrun       # 롤백전용 DRY-RUN(영향행수+제약위반)
./apply_wave1.sh idempotent   # 2-pass 멱등 증명(pass2=0)
./apply_wave1.sh commit       # 실 COMMIT (★인간 최종 승인 시에만)
```

---

## 6. 차단/에스컬레이션 (인간 승인 대기)

- **실 COMMIT** — DRY-RUN GO·백업 보유. 사용자 최종 승인 시 `apply_wave1.sh commit`.
- **경로 Y 백로그** — del_yn='Y' 휘발 방지 위해 개발자 v03 재적재 병행 권고(`_backlog/`·개발자 협업).
- **R3 재연결 1회 시각 확인(권장)** — 부모 매칭이 *근접*(동명 부재·regspec-category §2.1) → 적용 시 운영자 "데스크소품/응원·시즌 산하 맞는지" 1회 확인.
- **Wave 2~4** — 본 트랙 범위 외(축이동·UV 돈크리티컬·BOM load-bearing). 별도 wave 승인 후.
