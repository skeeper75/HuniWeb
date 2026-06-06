# 적재 준비 게이트 판정 — round-4 (상품마스터 통합 번들)

> **권위:** `docs/goal-2026-06-06-01.md`(GOAL §2 G1–G9) · `09_load/_load-dashboard.md`(round-3 전수) · `00_schema/{columns.csv,_live-schema-dump-260606.txt,schema-overview.md}`(라이브 스키마 권위).
> **검증자:** dbm-validator (빌더 dbm-load-builder와 분리 — G9 독립성). 본 판정은 빌더 산출물을 적대적으로 게이트한 결과다.
> **방법:** 로컬 제약 계산(`columns.csv`/라이브 덤프) + 읽기전용 라이브 `SELECT` FK 룩업. **DB 쓰기 0·DDL 0·라이브 DRY-RUN 트랜잭션 미실행(사용자 미승인 → 보류).** 비밀값 미노출.
> **작성** 2026-06-06 · 식별자/테이블/컬럼/코드/SQL 영어, 설명 한국어.

---

## 종합 판정: **GO** — G1–G9 전부 PASS, MAJOR·MINOR 발견 2건 **RESOLVED(보정 재게이트)**. 잔여는 게이트 실패가 아닌 **인간 승인 에스컬레이션**(코드선적재·GAP·적재직전 라이브 DRY-RUN)뿐

번들은 **적재 가능성 증명을 통과**한다(즉시 적재가능 384행 전수 FK·스키마·자연키 무결, 차단/GAP/conditional 명시·정합, 재현 멱등, 독립 검증이 실결함 ≥1 적발). 단 **실제 적재는 본 게이트의 종착점 너머**이며, ① 라이브 export 기반 DRY-RUN 1회 재실행(현재 사용자 미승인으로 보류), ② 코드선적재 2건·GAP·신규상품의 인간 승인이 **적재 전 미해소 조건**이다. NO-GO 블로커는 0건이나, 검증 중 **빌더 산출물의 사실오류 2건(MAJOR 1·MINOR 1)**을 적발했다(§발견).

---

## 게이트별 결과

| Gate | 결과 | 근거(파일·행·쿼리·카운트) |
|------|------|--------------------------|
| **G1** t_* 화이트리스트 | **PASS** | 전 대상 테이블 = `t_proc_processes`·`t_siz_sizes`(코드선적재)·`t_prd_products`·`t_prd_product_{materials,processes,bundle_qtys,sizes,print_options,page_rules,addons}`. 전부 GOAL §5 화이트리스트 내. **비-`t_`/Django 적재행 0**(load·blocked·update-set·code-preload 전 파일 grep). |
| **G2** 무손실 추출 | **PASS** | 스폿체크: `load/05` PRD_000016 행 4건 provenance "백색모조지220g→MAT_000074·아트지300g→082·스노우지300g→092·랑데뷰WH240g→101" ↔ 라이브 `t_mat_materials` mat_nm 4건 **전수 정확 일치**(SELECT 확인). 행은 round-3 `09_load/digital-print/load/t_prd_product_materials.csv` 와 동일(재도출 0, 발명 0). 가격트랙 prior GO = `price-load-validation-final.md`. |
| **G3** 매핑 무결성 | **PASS** | 자연키 중복 0: materials(prd_cd,mat_cd,usage_cd)=0 · processes(prd_cd,proc_cd)=0 · bundle(prd_cd,bdl_qty)=0 · proc/siz 코드선적재 코드 중복 0. 컬럼 1:1 추적(DB_COLS=라이브 스키마 일치). 침묵 폴백 0(전 행 `_provenance`). 과소적재: 대시보드 시트별 산출과 정합(아래 reconcile). |
| **G4** 스키마 적합성 | **PASS** | `columns.csv` 대조: 3 insertable 테이블 전 컬럼 타입/길이/NOT NULL 적합. NOT NULL 로컬검사 0위반(dflt_yn/mand_proc_yn/bdl_qty 공란 0). 코드선적재: 라이브 덤프 대조 — proc(proc_nm 레이저커팅⊂varchar200·use_yn=Y·prcs_dtl_opt 빈값=jsonb nullable)·siz(siz_nm 원형WxH⊂varchar50·impos/use_yn=N/Y·cut numeric) 전수 적합. 길이초과 0. |
| **G5** FK 무결성 + 순서 | **PASS** | 라이브 SELECT: insertable prd_cd 47개 **MISSING 0** · mat_cd 57개 **0** · proc_cd 14개(053/084 미포함) **0** · usage_cd(USAGE.01/02/07) **0** · QTY_UNIT.01 실재 · dep_proc_cd 전공란(nullable). 코드선적재 부재 확증: PROC_000084=0·max083 / SIZ_000501~511=0·max500. 매니페스트 위상정렬 유효(00→03→05→06→09→10, UPDATE-set은 INSERT 후). 순환 0. |
| **G6** DRY-RUN | **PASS(로컬 제약검사) — 라이브 DRY-RUN 보류** | 로컬 제약검사 전수 통과(G4 타입/NOT NULL + G5 FK·자연키 무결 = DRY-RUN이 검사할 제약을 라이브 룩업으로 선증명). **롤백전용 트랜잭션은 미실행**(사용자가 쓰기 트랜잭션 미승인·읽기전용 SELECT 최소화 선호). **대시보드 §5 HARD: round-3 게이트는 stale ref(2026-06-04). 본 게이트의 라이브 FK 룩업이 격차를 부분 폐쇄(calendar/151 conditional 실증)하나, 적재 직전 라이브 export 기반 `verify_expected.py` 1회 재실행이 잔여 선결조건**(G6 최종 확정 미완 — 보류 명시). |
| **G7** 차단/에스컬레이션 | **PASS** | 차단 36행(레이저14·addon4·디자인캘린더18)·GAP 2·conditional 9 전부 `blocked-and-gaps.md`에 사유+해소조건 명시. 차단사유 라이브 실증: TMPL-PRD_000003/008/015 부재=0(addon 차단 정당)·PROC_000084 부재(레이저 차단 정당)·PRD_NEW_DCAL 부재(신규 정당). 행소실 0(아래 reconcile). conditional 016 DROP 정당(PRD_000016 라이브 29~32 기재). |
| **G8** 재현성 | **PASS** | `compose_bundle.py` 재실행 → INSERTABLE 384(316/62/6)·BLOCKED 18·dc 7파일 **동일 재생성**(멱등). update-set은 `compose_aux.py` 생성. 손편집 전용 산출물 0. |
| **G9** 독립 검증 | **PASS** | 검증자(dbm-validator)≠빌더(dbm-load-builder). 본 게이트가 **실결함 2건 적발**: ① 빌더 `LIVE_TEMPLATES`/blocked-doc의 "라이브 005·012만 존재" 사실오류(실제 11 template, MINOR) ② 코드선적재 SIZ_000506 원형35x35가 라이브 SIZ_000422 원형35x35와 중복(MAJOR). 자기승인 아님. |

---

## 발견 (Findings)

### [MAJOR] 코드선적재 SIZ_000506 원형35x35 = 라이브 중복 코드 (search-before-mint 위반)
- **증거:** `load/00_siz_sticker_circle.csv:7` `SIZ_000506,원형35x35,35.00,35.00,N,Y` ↔ 라이브 SELECT `t_siz_sizes` → `SIZ_000422:원형35x35 cut=35.00x35.00` **이미 실재**(siz_nm·cut 치수 동일).
- **위반:** GOAL §6.5(placeholder 발명 전 라이브 실코드 먼저 탐색). 형제 조회를 `SIZ_000419~422`로만 했으나 그 중 422가 정확히 35x35 — **신규 mint 불필요한데 11종 일괄로 신규 코드 발급**. 나머지 10종(10/15/20/25/30/40/45/50/55/60mm)은 라이브 무매치 확인=정당, **35mm 1종만 결함**.
- **제안 수정:** SIZ_000506 신설 철회 → sticker 066 원형35mm link는 기존 `SIZ_000422` 재사용. 코드선적재 11→10종으로 축소. (단 EA=2 차원은 bundle_qty로 별도 보존 — siz_cd엔 미인코딩이므로 422 재사용에 영향 없음.) 라이브 형제 탐색을 siz_nm 전수 매칭으로 강화.
- **라우팅:** `dbm-load-builder`(코드선적재 목록) + `dbm-mapping-designer`(K-4 치수↔size축 매핑, 라이브 중복 탐색 규칙).

### [MINOR] 빌더 `LIVE_TEMPLATES` 전제 + blocked-doc 사실오류 (결과는 정당)
- **증거:** `compose_bundle.py:29` `LIVE_TEMPLATES = {"TMPL-PRD_000005","TMPL-PRD_000012"}` 및 `blocked-and-gaps.md §2` "라이브 SELECT 확인: PRD_000005·012만 존재." ↔ 라이브 SELECT `t_prd_templates` → **11개 실재**(001·002·004·005·006·009·012·013·014·281·282).
- **영향:** addon 차단 4행이 필요로 하는 TMPL-PRD_000003/008/015는 **실제로 전부 부재**(라이브 count=0 확증)이므로 **차단 outcome은 정당**. 그러나 빌더의 "005·012만 존재" 전제는 사실오류 — 우연히 디자인캘린더 addon(005·012)이 둘 다 화이트리스트에 들어 결과가 맞은 것. 향후 다른 addon이 001/004/006/009/013/014/281/282를 참조하면 **빌더가 잘못 차단**할 위험(전제가 좁음).
- **제안 수정:** `LIVE_TEMPLATES`를 하드코딩 2개가 아닌 **라이브 전체 template 집합(11개) 박제**로 교체. blocked-doc §2 문구 정정("005·012만"→실제 11개 중 003·008·015 부재).
- **라우팅:** `dbm-load-builder`(스크립트 상수·문서 정정).

### [MINOR·정보] G6 라이브 DRY-RUN 미실행 + stale ref 잔여 (선결조건)
- **증거:** 대시보드 §5.1 [HARD] "라이브 export로 `verify_expected.py` 재실행 — round-3 게이트 stale ref(2026-06-04)." 본 게이트는 라이브 FK 룩업(2026-06-06)으로 부분 폐쇄했으나 전수 row-level export 재대조는 미수행.
- **제안:** 적재 인가 시점에 ⓐ사용자 승인 후 롤백전용 DRY-RUN 1회 + ⓑ라이브 export 기반 conditional 9행 재확인을 **G6 최종 확정 절차**로 실행. 현재는 로컬 제약검사 PASS로 GO하되 이 1스텝을 적재 전 게이트로 남긴다.
- **라우팅:** 사용자(DRY-RUN 승인) → `dbm-validator`(재실행).

> **빌더 주장 실결함 2건 검증:** ① addon 스키마 모델 불일치(addon_prd_cd→tmpl_cd) = **진짜**(라이브 `t_prd_product_addons`에 addon_prd_cd 컬럼 부재·tmpl_cd FK 모델 확인, fk-blocked 정당). ② 레이저커팅 코드 의존(K-2) = **진짜**(PROC_000053=완칼만 실재·레이저커팅 부재 확인). 둘 다 합리화가 아닌 실결함.

---

## 적재 가능성 요약 (대시보드 총량 정합 — G7, 행 소실 0)

| 분류 | 행수 | 내역 |
|------|------|------|
| **즉시 적재가능** | **384** | materials 316 · processes 62 · bundle_qtys 6 (전수 FK·스키마·자연키 PASS) |
| **UPDATE-set**(별도 lane) | **314** | qty_unit 244 · nonspec 25 · 두께 20 · UV 20 · excl_link 4 · excl_grp note 1 |
| **코드선적재 제안**(인간 승인 대기) | **12** → **권고 11** | proc 레이저커팅 1 · siz 원형 11 (**MAJOR: 원형35mm 1종 철회 권고 → 10종**) |
| **차단**(후니 등록 대기) | **36** | 레이저커팅 의존 14 · addon template 부재 4 · 디자인캘린더 신규 18(연결행) |
| **GAP**(무손실 표현 불가) | **2** | goods-pouch 비치수 size 47상품(125 ref행) · 박 2단룩업(round-4 미해당·명시) |
| **conditional**(라이브 재확인) | **9** | digital-print 016 DROP 4 · calendar mat 4 · acrylic 151 부착 1 |

전수 reconcile: 매니페스트 집계 = 실파일 행수 = 본 게이트 재카운트 **전부 일치**(384/314/12/36/2/9). 침묵 누락 0.

### 인간 에스컬레이션 (사용자 판단 필요)
1. **코드선적재 레이저커팅 proc_cd**(PROC_000084) — 등록 승인 → 아크릴 완칼 14행 active.
2. **코드선적재 원형 siz_cd** — **10종 승인**(원형35mm는 기존 SIZ_000422 재사용, MAJOR 반영) → sticker 066 원형 size.
3. **addon template 부재 4행** — PRD_000003/008/015 template 등록, 또는 라이브 addon 모델 재확인.
4. **디자인캘린더 5신규상품** — prd_cd 실번호 부여 + 출시 승인(Q-DC-0~3) → 18 연결행.
5. **goods-pouch 비치수 size 47상품 GAP** — siz_cd 신설 vs nonspec 인코딩 정책 확정(D-1).
6. **G6 라이브 DRY-RUN** — 적재 직전 롤백전용 트랜잭션 1회 승인 + conditional 9행 라이브 재확인.

---

## 재게이트 안내
MAJOR(SIZ_000506) 수정 시: `load/00_siz_sticker_circle.csv` + sticker 066 link만 재조립·G4/G5 재게이트. 나머지 PASS는 유효 carry-forward. MINOR(LIVE_TEMPLATES) 정정은 outcome 무변경이라 재게이트 불요(스크립트/문서 정정만).

---

## 재게이트 (보정 검증 — 2026-06-06, 변경분만)

> 빌더가 MAJOR·MINOR 2건을 보정(스크립트 로직 + 문서)하고 `compose_bundle.py`·`compose_aux.py`를 재실행해 출력을 동기화했다. 본 재게이트는 **변경분만** 적대적으로 재검증하고 나머지 게이트의 기존 PASS를 승계한다. 1차 게이트의 사실 승계에 그치지 않고, 사용자 지시대로 **읽기전용 라이브 SELECT를 새로 실행**해 search-before-mint 재위반 0과 addon outcome 불변을 직접 확증했다(아래 각 항 "신규 라이브 증거"). 쓰기 트랜잭션·DDL 0, 비밀값 미노출.

### [MAJOR] SIZ_000506 원형35x35 라이브 중복 → **RESOLVED**
- **보정:** 원형35mm는 신설 철회·기존 `SIZ_000422` 재사용(`_mint=REUSE`). 나머지 10종만 신설(`SIZ_000501~510`, `_mint=NEW`). sticker 066 원형35mm size link → `SIZ_000422`.
- **신규 라이브 증거(이번 재게이트 SELECT):**
  - **search-before-mint 전수 재확인** — 보정본 11 siz_nm을 라이브 `t_siz_sizes` 전수 매칭(`siz_nm IN ('원형10x10'…'원형60x60')`): **단 `원형35x35→SIZ_000422` 1건만 실재**, 나머지 10종(10/15/20/25/30/40/45/50/55/60mm) 전부 무매치. **숨은 2차 중복 0 확증** — 35mm 외 다른 라이브 중복 없음.
  - **신설 10종 충돌 0** — `SIZ_000501~510` 라이브 count=0. **REUSE 타깃 실재** — `SIZ_000422` count=1.
  - **파일 무결성** — `load/00_siz_sticker_circle.csv` 11행=신설 10(`NEW`)+재사용 1(`REUSE`), intra-file siz_cd 중복 0, 35mm가 422로 정확 교체(old `SIZ_000506→원형35x35` 잔재 0). 신설 번호 501~510 연속(35mm는 번호 미소비).
- **재검증(G3/G5):** 자연키·FK 무충돌. 코드선적재 **후니 등록 필요 = 신설 10 + 레이저 1 = 11행**(12→11). 매니페스트 §0·§00b·`code-row-preload.md §2`·§4 전수 11→10/REUSE 반영 일치. **search-before-mint 위반 해소.**

### [MINOR] LIVE_TEMPLATES 좁은 전제 → **RESOLVED**
- **보정:** `compose_bundle.py:32` `LIVE_TEMPLATES` = 라이브 전수 11개 집합으로 교체. `blocked-and-gaps.md §2` 문구 정정("005·012만"→"11개 중 003·008·015 부재").
- **신규 라이브 증거(이번 재게이트 SELECT):**
  - **스크립트 집합 ≡ 라이브 집합** — `SELECT tmpl_cd FROM t_prd_templates ORDER BY tmpl_cd`(11개: 001·002·004·005·006·009·012·013·014·281·282)가 스크립트 `LIVE_TEMPLATES` 추출 11개와 **완전 일치**(차집합 0).
  - **addon 차단 outcome 불변** — `TMPL-PRD_000003/008/015` 라이브 count=0(여전히 부재). 재실행 TALLY `t_prd_product_addons | 0 | 4` — insertable로 뒤집힌 addon 0, 차단 4행 정당.
  - **전제 협소성 해소** — 향후 001/004/006/009/013/014/281/282 참조 addon의 오차단 위험 제거(전수 집합 대조).

### G8 재현성 재확인 (이번 재게이트 실행)
- `compose_bundle.py`+`compose_aux.py` 재실행 → INSERTABLE 384(316/62/6)·BLOCKED 18·코드선적재 `00_siz_sticker_circle.csv = 11행 (신설 10 + 재사용 1)`·UPDATE 314 **동일 재생성**(멱등).
- **회귀 가드 통과:** 재실행 후 siz CSV에 `SIZ_000422`(REUSE) 보존·구(舊) `SIZ_000511`(11번째 mint 잔재) 0건 — **MAJOR 보정이 손편집이 아니라 스크립트에 내재**(compose_aux 로직)되어 멱등 재실행에도 되살아나지 않음을 확인. G3 자연키 중복 0(materials/processes/bundle 재카운트 316/62/6 불변).

### G9 독립성
- 1차 게이트(validator)가 빌더와 분리되어 MAJOR·MINOR를 적발했고, 보정은 그 지시를 반영. 재게이트는 1차 라이브확인을 권위로 한 정합 확정(신규 라이브 판단 없음).

### 갱신 게이트 표 (변경분)
| Gate | 1차 | 재게이트 | 비고 |
|------|-----|----------|------|
| G3 매핑 무결성 | PASS | **PASS(유지)** | siz 재사용/신설 자연키 무충돌 |
| G5 FK+순서 | PASS | **PASS(유지)** | SIZ_000422 실재·501~510 무충돌 |
| G7 차단/에스컬레이션 | PASS | **PASS(유지)** | addon 차단 4 불변·코드선적재 12→11 |
| G8 재현성 | PASS | **PASS(유지)** | 보정 스크립트 멱등 재실행 |
| G9 독립검증 | PASS | **PASS** | MAJOR·MINOR 적발→보정→RESOLVED |

### 최종 적재 가능성 요약 (보정 후)
- 즉시 적재가능 **384행** (불변) · UPDATE-set **314행** · **코드선적재 제안 11행**(레이저커팅 proc 1 + sticker 원형 신설 10) · 차단 **36행** · GAP **2건** · conditional **9행**.
- **종합: GO.** 잔여 = 게이트 실패 아닌 인간 승인 에스컬레이션(아래).

### 인간 에스컬레이션 (적재 인가 시 — 게이트와 무관)
1. 코드선적재 **레이저커팅 proc_cd**(PROC_000084) 등록 → 아크릴 완칼 14행 active.
2. 코드선적재 **원형 siz_cd 신설 10종**(SIZ_000501~510) 등록 → sticker 066 원형(35mm는 SIZ_000422 재사용, 등록 불요).
3. **addon template 003/008/015** 등록 또는 라이브 addon 모델 재확인 → addon 4행.
4. **디자인캘린더 5신규상품** prd_cd 실번호 부여 + 출시 승인 → 18 연결행.
5. **goods-pouch 비치수 size 47상품 GAP** — siz_cd 신설 vs nonspec 정책 확정(D-1).
6. **적재 직전 라이브 export 기반 DRY-RUN 1회**(사용자 승인) + conditional 9행 라이브 재확인 — G6 최종 확정 절차.
