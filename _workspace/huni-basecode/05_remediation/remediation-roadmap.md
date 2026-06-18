# 교정 실행 우선순위 로드맵 — 후니 기초코드 거버넌스 Phase 5

> **하네스** hbg Phase 5 교정 우선순위 설계가(`hbg-remediation-planner`). **작성** 2026-06-18.
> **입력:** `03_registration/_registration-master.md`(전 축 GO)·`04_gate/gate-verdict.md`(B1~B6 GO·4축 재검증 GO) + **라이브 읽기전용 실측**(2026-06-18).
> **우선순위 기준 [HARD]:** 안전·가역성 우선(위험 낮고 되돌리기 쉬운 것 먼저). 가격사슬 영향 = `price-chain-impact.md`.
> **[HARD] 명세 ≠ 적용.** 본 문서는 로드맵·우선순위·경로까지. 실 COMMIT 0 — GO분 실 적재는 wave 단계별 인간 승인 후 `dbm-axis-staged-load`/`dbm-load-execution` 위임.

---

## 0. 한 줄 평결

**전 교정 항목을 5축 스코어링 → 4 wave로 배치.** **Wave 1 = 즉시 무위험 가역분(가격사슬 0참조·cp 무접촉) — SZ-1 색오염 2 + 카테고리 소프트삭제 11 + 카테고리 재연결 2 + 레이플랫 PROC_000025 소프트삭제 1 + .10→.07 부자재 ~17 + 봉투/헤더 정리 11 = 즉시 승인 가능.** Wave 2~3 = 자재 축이동(목적지 그릇 선행) + UV PO-1(option_items 행 선적재·★돈 크리티컬). Wave 4 = 고위험 의존(BOM link 177 제거 → 오염행 del_yn='Y'·DDL 선행분). **★유일 돈 크리티컬 = PO-1 UV(아크릴 골든 186행 인접) → dbm-price-arbiter 협업.** 나머지 전건 가격사슬 0참조 라이브 실증.

---

## 1. 5축 스코어링표 (전 교정 항목)

> 점수: 가역성(高=되돌리기 쉬움) · 위험(低=안전) · 효과(高=결함 해소 큼) · FK의존(低=선행조건 적음) · 돈크리티컬(無=가격 영향 0). **안전(가역高+위험低)이 절대 1순위.**

| # | 교정 항목 | 축 | 행수 | 가역성 | 위험 | 효과 | FK의존 | 돈크리티컬 | 경로 | wave |
|---|-----------|----|----:|:--:|:--:|:--:|:--:|:--:|------|:--:|
| R1 | SZ-1 색오염 siz_nm 정규화 | 사이즈 | 2 | 高 | 低 | 中 | 無 | 無(cp 0참조) | 라이브 직접 | **1** |
| R2 | 카테고리 소프트삭제(CAT_000294+빈 고아 10) del_yn='Y' | 카테고리 | 11 | 高 | 低 | 中 | 無 | 無 | 라이브 직접 | **1** |
| R3 | 카테고리 재연결(302→134·304→198) upr_cat_cd UPDATE | 카테고리 | 2 | 高 | 低 | 中 | 無 | 無 | 라이브 직접 | **1** |
| R4 | 레이플랫 PROC_000025 소프트삭제 del_yn='Y' | 공정 | 1 | 高 | 低 | 低 | 無(연결 0 실측) | 無(cp 0) | 라이브 직접 | **1** |
| R5 | .10→.07 부자재 mat_typ 교정(자재 유지·mat_cd 불변) | 자재 | ~17 | 高 | 低 | 中 | 無 | 無(cp typ 무관) | 라이브 직접 | **1** |
| R6 | 봉투/헤더/placeholder 정리 del_yn='Y' | 자재 | 11 | 高 | 低 | 低 | 無 | 無 | 라이브 직접 | **1** |
| R7 | 공정 dtl_opt param 채움(data-gap·신규 컬럼 0) | 공정 | (점진) | 高 | 低 | 中 | 低 | 無 | 라이브 직접(dbmap CPQ) | **2** |
| R8 | 자재 축이동 → print_side(.09 인쇄면 14) | 자재 | 14 | 中 | 中 | 高 | 中(print_side 그릇 실재) | 無(cp 0) | 라이브 직접 | **2** |
| R9 | 자재 축이동 → bundle(.09 구수 4+기타 1) | 자재 | 5 | 中 | 中 | 中 | 中(bundle 그릇 실재) | 無 | 라이브 직접 | **2** |
| R10 | 자재 축이동 → 형상 siz+SHAPE(.09 치수11·형상18) | 자재 | 29 | 中 | 中 | 高 | 高(siz·SHAPE 일부 DDL) | 無 | 혼합(치수 직접·형상 DDL) | **3** |
| R11 | 자재 축이동 → option_items 색(.09색21·.10볼체인색8·잉크색7) | 자재 | 36 | 中 | 中 | 高 | 高(option_items 행+트리거) | 無 | 라이브 직접(행 선적재) | **3** |
| R12 | **PO-1a UV 14상품**(option_items 행 선적재→dtl_opt 이관→print_side 정규화) | 인쇄옵션 | ~42 | 中 | **高** | 高 | **高**(행 선적재·★print_opt_cd 가격축 인접) | **🔴간접·주의** | 라이브 직접(arbiter 협업) | **3** |
| R13 | **PO-1b UV 7상품**(PROC_000002 링크 선적재 후 PO-1a 동일) | 인쇄옵션 | ~21 | 中 | **高** | 中 | **高**(공정 링크+정체 컨펌) | **🔴간접·주의** | 라이브 직접(arbiter+컨펌) | **3** |
| R14 | 본체 .05/.06 자재 link 선적재(GPM-1/2 전제·INSERT) | 자재 | 41(설계) | 中 | 中 | 高 | 中(BOM 제거 전제) | 無 | dbmap GPM(round-22) | **4** |
| R15 | **BOM link 177 제거(GPM-4)** | 자재 | 177 | 低 | **高** | 高 | **高**(본체 선적재 후) | 🟡간접·BOM | 혼합(라이브+경로 Y) | **4** |
| R16 | 오염 .08/.09/.10 자재행 del_yn='Y'(마지막) | 자재 | (축이동분) | 低 | **高** | 高 | **高**(BOM 제거 후) | 無 | 혼합(라이브 임시·경로 Y 근본) | **4** |
| R17 | DDL: shape_cd·비치수 size 마스터(R10 형상 전제) | 자재 | DDL 2 | 中 | 中 | 中 | 高(admin 노출 후) | 無 | dbm-ddl-proposer | **4** |
| R18 | 아크릴 두께 분리(AC-2·dbmap 31_acrylic 위임) | 자재 | 22상품 | 中 | 中 | 中 | 中 | 🟡(아크릴 가격사슬 동시) | dbmap 31_acrylic | **4**(별트랙) |

> **★스코어링 근거(라이브 실측):** R1~R6 = cp 0참조/연결 0/mat_cd 불변 → 가역高·위험低·돈無 → **Wave 1.** R12/R13(UV) = print_opt_cd 가격축 인접(아크릴 골든 186행) + option_items 0행(목적지 부재) → 위험高·돈🔴 → Wave 3 + arbiter. R15/R16 = BOM 177 load-bearing(순서 위반 시 본체 전손) → 위험高·FK高 → **Wave 4 마지막.**

---

## 2. Wave 배치 + FK 위상

### Wave 1 — 즉시 무위험 가역 (가격사슬 0 · dry-run 후 즉시 승인 가능)

```
R1 SZ-1 색오염 2 (siz_nm UPDATE)          — cp 0참조·무비용
R2 카테고리 소프트삭제 11 (del_yn='Y')     — CAT_000294 상품 0·빈 고아 10
R3 카테고리 재연결 2 (upr_cat_cd UPDATE)   — 302→134·304→198·활성 상품 보존
R4 레이플랫 PROC_000025 소프트삭제 1        — 연결 0 실측·cp 0
R5 .10→.07 부자재 ~17 (mat_typ UPDATE)     — mat_cd 불변·cp typ 무관
R6 봉투/헤더/placeholder 정리 11 (del_yn='Y') — BOM 미연결
```
- **공통:** 전건 가역(undo 단순)·FK 의존 無·돈 크리티컬 無·라이브 직접. 멱등 가드 `WHERE del_yn='N'`(R2/R4/R6)·`WHERE siz_nm<>정규화값`(R1).
- **순서 무관**(상호 독립). 단 R3 재연결은 부모 노드(CAT_000134/198) 실재 확인됨(Wave 0 전제 충족).

### Wave 2 — 목적지 그릇 실재 축이동 (그릇 선행 불요·라이브 직접)

```
R8 .09 인쇄면 14 → print_side    — print_side 그릇 라이브 실재(166행)
R9 .09 구수 5 → bundle           — bundle 그릇 라이브 실재(28행)
R7 공정 dtl_opt param 채움(점진)  — dtl_opt 그릇 실재(6/477)·data-gap
```
- 목적지 그릇 라이브 실재 → 추가 선적재 불요. 위험 中(축이동=원 자재행 BOM/del_yn은 Wave 4). **단 축이동 후 원 .09 자재행 del_yn='Y'는 BOM 제거(Wave 4) 후로 보류.**

### Wave 3 — 행 선적재 후 축이동 (option_items 트리거·★UV 돈 크리티컬)

```
FK 위상:
 ① R11/R12/R13 공통: option_items 행 INSERT 선행 (현재 0행·트리거 fn_chk_opt_item_ref)
 ② R10 형상 → siz(치수 즉시) + SHAPE(DDL은 Wave 4 R17 후)
 ③ R11 색 → option_items (.09색21·.10볼체인색8·잉크색7=36)
 ④ R12 PO-1a UV 14 → option_items 행 → dtl_opt 이관 → print_side 정규화
       ★print_opt_cd(가격축) 무접촉 가드 — arbiter 협업
 ⑤ R13 PO-1b UV 7 → PROC_000002 링크 선적재 + 정체 컨펌 → ④ 동일
```
- **★Wave 3은 R12/R13(UV)을 R10/R11(자재 색 축이동)과 분리 승인 권장** — UV는 돈 크리티컬(arbiter)·정체 컨펌(PO-1b) 동반.

### Wave 4 — 고위험 의존 (BOM load-bearing · 마지막)

```
FK 위상(엄수·위반 시 본체 자재 전손):
 ① R14 본체 .05/.06 자재 link 선적재 (GPM-1/2·41행 INSERT·dbmap GPM)
 ② R17 DDL: shape_cd 컬럼·비치수 size 마스터 (R10 형상 목적지)
 ③ R15 BOM link 177 제거 (GPM-4·본체 선적재 후)        ← 진짜 미완
 ④ R16 오염 .08/.09/.10 자재행 del_yn='Y' (마지막)
 ⑤ R18 아크릴 두께 분리 (AC-2·dbmap 31_acrylic 별트랙·가격사슬 동시)
```
- **del_yn='Y' 라이브 직접 = 임시책**(TRUNCATE 재적재 시 'N' 휘발) → **근본 = 경로 Y**(v03 오염행 제거·개발자 재적재). 두 경로 병기(§3).

---

## 3. 교정 경로 혼합 (항목별 장단 병기 — 침묵 선택 금지)

| 항목 | 라이브 직접(가역분) | 경로 Y(근본분) | 권고 |
|------|----------------------|----------------|------|
| R1 SZ-1 / R5 .10→.07(UPDATE) | 즉효·멱등 UPSERT·undo 단순. **TRUNCATE 재적재 시 휘발**(load_master v03 무변환 재INSERT) | v03 셀 교정 후 개발자 재적재·영구 | **둘 다** — 라이브 직접 즉효 + 경로 Y 백로그(휘발 방지) |
| R2/R4/R6 소프트삭제(del_yn='Y') | 즉효. **★del_yn='Y'는 TRUNCATE 재적재 시 'N' 휘발**(load_master del_yn 미명시→DEFAULT 'N') | v03 오염행/고아 제거·재적재 | **라이브 직접(즉효) + 경로 Y 필수 백로그**(휘발성 높음) |
| R3 재연결(upr_cat_cd) | 즉효·UPDATE | v03 카테고리 트리 부모 교정 | 둘 다 |
| R8/R9/R10/R11 축이동 | 즉효. 휘발 위험(축이동 = 신규 행/UPDATE 혼재) | v03에서 비소재 값을 올바른 축 컬럼으로 재인코딩 후 재적재 | **경로 Y 우선**(근본·v03 진원 교정·`dbm-axis-staged-load` P-TRUNCATE 가드) + 라이브 직접은 즉효 필요 시 |
| R12/R13 UV PO-1 | option_items 행 INSERT + dtl_opt UPDATE(즉효) | v03에 UV 변형 param 인코딩(개발자) | **라이브 직접(arbiter 가드)** — option_items는 load_master 적재 단위 외(휘발 위험 낮음·dbmap CPQ 트랙) |
| R15 BOM link 177 제거 | 라이브 DELETE/UPDATE(즉효·위험) | v03 .09/.10 link 제거·재적재 | **경로 Y 우선**(근본·휘발 방지) + 라이브는 본체 선적재 검증 후만 |
| R16 오염행 del_yn='Y' | 즉효·휘발 | v03 오염행 제거·재적재 | **경로 Y 근본**(라이브 del_yn='Y'는 임시책 명시·.09 69행 이미 'Y'인데 BOM 활성 = 휘발 실증) |
| R17 DDL | — | DDL 적용은 개발자(`dbm-ddl-proposer` 제안) | DDL 트랙(인간 승인) |
| R18 아크릴 | dbmap 31_acrylic 라이브(가격사슬 동시) | v03 두께 자재 식별자 | dbmap 31_acrylic 트랙 권위 |

> **★경로 판정 원칙(round-22 v2 인용):** load_master = 무변환 전파기 → 오류 진원 전부 ⓐ(v03) → **근본 교정 = 경로 Y(교정 v03 재적재).** 라이브 직접(경로 X)은 즉효이나 TRUNCATE 재적재 시 소멸(특히 del_yn='Y'). **소프트삭제·BOM 제거·축이동은 경로 Y 백로그 필수**(휘발 방지). webadmin 코드 수정 금지(개발자 GitHub 배포·read-only).

---

## 4. 우선순위 정렬 (안전·가역성 우선 최종)

| 순위 | wave | 항목 | 승인 단위 |
|:--:|:--:|------|------|
| 1 | 1 | R1·R2·R3·R4·R5·R6 (무위험 가역·가격 0) | **Wave 1 일괄 즉시 승인 가능** |
| 2 | 2 | R8·R9·R7 (그릇 실재 축이동·data-gap) | Wave 2 승인 |
| 3 | 3 | R10·R11 (행 선적재 색/형상 축이동) | Wave 3a 승인 |
| 4 | 3 | **R12·R13 (UV PO-1·🔴돈 크리티컬)** | **Wave 3b 별도 승인 + arbiter 선행** |
| 5 | 4 | R14→R17→R15→R16 (BOM load-bearing·FK 엄수) | Wave 4 순차 승인(단계별) |
| 6 | 4 | R18 아크릴(별트랙) | dbmap 31_acrylic 위임 |

**핵심:** 안전분(Wave 1) 즉시 → 그릇 실재분(Wave 2) → 행 선적재분(Wave 3, UV 분리) → BOM 의존분(Wave 4 마지막·경로 Y 근본). **돈 크리티컬은 PO-1 UV 1건뿐**(arbiter 협업)·나머지 전건 가격사슬 라이브 0참조.

---

## 5. dbmap 위임 인터페이스 (GO 승인 후)

| wave | 경로 | 위임처 |
|------|------|--------|
| Wave 1 라이브 직접 | 멱등 UPSERT(`WHERE del_yn='N'` 가드) | `dbm-load-execution` + `dbm-validator`(R1~R6) |
| Wave 2~3 축이동 | 경로 Y(교정 v03 재적재·P-TRUNCATE 가드) | `dbm-axis-staged-load` |
| Wave 3b UV | option_items 선적재·dtl_opt 이관·print_opt_cd 가드 | `dbm-load-execution` + **`dbm-price-arbiter`**(아크릴 골든 검증) |
| Wave 4 BOM/DDL | BOM 제거(GPM-4)·del_yn='Y'·shape DDL | `dbm-axis-staged-load`(GPM)·`dbm-ddl-proposer`·경로 Y 개발자 |
| R18 아크릴 | 두께 분리·가격사슬 동시 | `dbmap 31_acrylic-price-link` + `dbm-price-arbiter` |

**[HARD] 실 COMMIT 0 — 본 로드맵은 wave·경로·순서·위험통제까지.** GO분만 백업·멱등·롤백전용 DRY-RUN 선행 후 위임. 승인 큐 = `_approval-queue.md`.
