# 스티커 — 도메인 리서치 노트 (round-11 확대 #1)

> **작성** 2026-06-10 · round-11. **신규로 리서치한 갭·발견한 충돌·🔴/🟡 컨펌 질문만** 기록. 07_domain이 이미 닫은 것은 재기술하지 않는다(재유도 0).
>
> **권위:** 후니 PDF > 07_domain KB > 국내외 표준(보조). 표준 충돌 시 후니 권위.

---

## 0. 07_domain 재사용 — 신규 리서치 불요 영역 (재유도 0)

스티커의 다음 의미는 07_domain이 이미 권위로 확정 → 본 round-11은 인용만:

| 주제 | 07_domain 권위 | round-11 적용 |
|------|----------------|---------------|
| 완칼/반칼/스티커완칼 정의·param | `db-domain-structure-live §109-167`(PROC_053 완칼{모양}·054 반칼{모양,조각수}·055 스티커완칼{조각수≥1}) | C24 커팅 → 공정 매핑 |
| 화이트 별색 = 투명/홀로그램 필수 | `entity-semantic-model §3-2·§97`(투명 underbase·G-SK-1) | C18 화이트 → PROC_000008 |
| 형상 enum = 공정 prcs_dtl_opt 권위 | `benchmark-competitors §2`(RP=후가공PCS·WP=non_standard 플래그 모두 후니보다 열등, 후니 prcs_dtl_opt.모양 유지) | C24 형상 귀속 원칙 |
| 조각수 = 묶음수+위젯 표시 | `benchmark-competitors §3`(후니 결정: 조각수=묶음수 차원+위젯 표시 조각수) | C25 이중 귀속 |
| 스티커 레시피 | `process-recipe-tree §2-2`(디지털출력→(코팅)→반칼/완칼→재단→포장) | 공정 체인 |
| MAT_TYPE.11 스티커 | `db-domain-structure-live §191` | C16 자재 |
| 인쇄방식=공정 root(코드그룹 아님) | `db-domain-structure-live §204`(인쇄방식은 PROC_000001 자식 트리로만) | C13 폴더 도출 |

→ **스티커는 07_domain 커버리지가 높다**(스티커 결함 G-SK-1~6이 이미 KB에 등록). 신규 리서치는 아래 컨펌에 국한.

---

## 1. 발견한 충돌 — 합판도무송 형상의 size 흡수 (G-SK-2 실증)

엑셀 실측 × 07_domain 권위 × round-10 변경추적 3자가 **한 곳에서 충돌**:

> **합판도무송스티커(R131~168)**: C24 커팅 **전 행 빈값**, 형상 37종(원형 11·정사각 12·직사각 14)이 **C5 사이즈에 `정사각 30 x 30mm (2EA)` 형태로 흡수**됨.
>
> - **07_domain 권위(benchmark §2):** 형상 enum은 공정 `prcs_dtl_opt.모양` 권위 유지 — size 축 재배치 **금지**.
> - **엑셀 현실(260610):** 합판도무송은 형상을 size로 인코딩(C24 비움).
> - **round-10 변경추적:** 260527→260610에서 "스티커 커팅옵션 클리어 37셀"로 escalate(라이브도 size로 적재: 정사각NxN(EA), 커팅 옵션그룹 없음).
>
> → **이것은 round-9가 경고한 "같은 값을 잘못된 t_*에 매핑" 패턴의 스티커 판**(카드봉투 색=siz와 동류). 형상이 본질적으로 공정인데 size로 평면화. `schema-design-intent-map.md`(HANDOFF #1)와 결합해 닫아야 함.

**다른 15상품은 충돌 없음** — 반칼/완칼 규격형은 C24에 형상을 두고(올바름), 합판도무송만 size로 흡수.

---

## 2. 🔴/🟡 컨펌 질문 (인간 결정 대기)

### CONFIRM-ST-1 [🟡·HIGH] 합판도무송 형상 37종 — size vs 공정 귀속?
- **상황:** 형상(원형/정사각/직사각 NNmm NEA)이 C5 size에 흡수, C24 커팅 빈값. 라이브도 size로 적재(round-10). 다른 스티커는 C24(공정)에 형상.
- **두 모델:** (A) 형상=공정 `prcs_dtl_opt.모양` 권위 → 적재된 size행을 공정으로 재귀속(`use_yn='N'` 또는 논리삭제) (B) 합판도무송은 size로 유지(라이브 현실 인정·예외).
- **가설(유력):** (A) — benchmark §2 권위가 명시적으로 size 재배치 금지. 단 합판도무송 형상엔 **EA(면적당 조각수)가 결합**돼 size 흡수가 가격격자와 얽혀 있을 수 있음(가격표 대조 필요).
- **검증 필요:** `06_extract/price-gangpan-sticker-l1.csv`(합판 가격표)가 형상×사이즈로 가격 격자를 짜는지 확인 → 가격이 size에 의존하면 size 유지가 정당할 수 있음(메모리 `l2-requires-l1-price-table`).
- **질문:** 합판도무송 형상을 공정(prcs_dtl_opt)으로 재귀속할까요, size로 유지할까요? (round-10 escalate + schema-design-intent-map 동시 의존)

### CONFIRM-ST-2 [🟡] 조각수(C25) 이중 귀속 — bundle_qty + prcs_dtl_opt 동시?
- **상황:** 조각수(*최대20조각·5~10조각·*1조각)가 묶음수이자 커팅 공정 신호. benchmark §3은 "묶음수 차원 + 위젯 표시" 둘 다.
- **가설:** `t_prd_product_bundle_qtys.bdl_qty`(주문 단위) + `prcs_dtl_opt.조각수`(반칼/스티커완칼 생산 param) **동시 적재**. `*최대N조각`=상한(가격/검증), `★최소크기 30x30`=조각 최소면적 제약(constraint_json).
- **질문:** 조각수를 bundle_qty와 prcs_dtl_opt 둘 다에 적재할까요, 한쪽만 둘까요? `*최대N`(범위)의 적재 형태는?

### CONFIRM-ST-3 [🟡] 코팅 자재 흡수 — 별 mat_cd vs 코팅 공정 분리?
- **상황:** 무광코팅스티커·유광코팅스티커가 자재(C16)로 등장, 코팅(C23) 컬럼 빈값. 디지털인쇄는 코팅=공정(C23 활성).
- **가설(유력):** 스티커 코팅=**점착지 완제 표면사양**(라미네이팅 별도 공정 아님) → 무광/유광코팅스티커를 별 `mat_cd`로(현재 5종 자재 중 2종). RedPrinting도 코팅스티커를 자재 productCode로 분기.
- **질문:** 무광/유광코팅스티커를 별 자재(variant)로 둘까요, 비코팅+코팅공정으로 분해할까요?

### CONFIRM-ST-4 [🟡] 인쇄방식(C13 폴더) DB 귀속?
- **상황:** 폴더(디지털/실사/화이트/합판/전사)=상품별 인쇄방식·생산 라우팅. 인쇄방식은 코드그룹 아님(공정 root 트리, db-domain-structure-live §204).
- **가설:** 견적 DB 밖 메타(생산 라우팅)지만, **공정 백본을 게이팅**하므로 상품의 root 공정(PROC_000004/006/…)을 `t_prd_product_processes`에 적재하면 인쇄방식이 암묵 표현됨.
- **질문:** 인쇄방식을 (a) root 공정 적재로 암묵 표현 (b) note 보존 (c) 신규 컬럼 중?

### CONFIRM-ST-5 [🔴] C11 파일명약어 — 견적 DB 귀속?
- **상황:** 파일명약어(반칼(자유형)·완칼(자유형)·반칼(규격)·합판스티커·타투스티커 7종)=생산 파일명/커팅 분류. t_* 컬럼 부재(디지털인쇄 C11과 동일 GAP).
- **가설:** 견적 밖(생산/MES 메타). 단 값이 커팅 정체(반칼/완칼/규격)와 정합 → 공정 도출 보조 단서로만 활용.
- **질문:** (a) 견적 DB 밖 (b) note 보존 (c) 신규 컬럼(ddl-proposer) 중? (디지털인쇄 CONFIRM-DP-2와 통합 결정 가능)

---

## 3. 디지털인쇄 컨펌과의 관계 (중복 제거)

디지털인쇄 `domain-research-notes` 컨펌 중 스티커에 **재등장**(통합 결정 가능):
- **C11 파일명약어·C13 폴더 귀속** = CONFIRM-DP-2 ↔ ST-5/ST-4 (동일 생산메타 패턴, 한 번에 결정).
- 스티커 **고유 신규 컨펌** = ST-1(형상 size 흡수)·ST-2(조각수 이중)·ST-3(코팅 자재). 디지털인쇄엔 없던 축.

---

## 4. 다음 단계 (확대 #1 완료 → #2)

1. **컨펌 5건 해소** — ST-1(가격표 대조 우선)·ST-2~5를 사용자/라이브 대조로 닫기. ST-1은 round-10 escalate + schema-design-intent-map 동시 의존.
2. **확대 #2 = 책자** — 같은 4산출 패턴. 책자=제본(반제품 B 셋트·page_rules) 신규 축 주의([[dbmap-schema-design-intent-first]]).
3. **schema-design-intent-map 입력** — 본 스티커 산출(형상 size 흡수·조각수 이중·인쇄방식 분기)을 HANDOFF #1과 결합.

---

## Sources
- 후니 권위(1순위): `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf`(스티커가공파트·완칼/반칼) · `docs/huni/후니프린팅_주문프로세스_20251001.pdf` · 상품마스터 `260610.xlsx` 스티커 시트(실측 16상품·1090행).
- 07_domain KB(2순위): `db-domain-structure-live.md`(PROC_053/054/055·MAT_TYPE.11·인쇄방식 트리) · `entity-semantic-model.md`(화이트별색 §3-2) · `benchmark-competitors.md`(§2 형상 enum·§3 조각수) · `process-recipe-tree.md`(§2-2 스티커 레시피) · `pdf-domain-knowledge.md`(완칼/반칼/도무송).
- round-10 변경추적: `14_change-tracking/260527-to-260610/change-manifest.md §B`(합판도무송 커팅옵션 클리어 37셀).
- 라이브 적재 소스: `raw/webadmin/webadmin/catalog/{models,admin,basecodes}.py`.
- (신규 WebSearch: 스티커는 07_domain 커버리지 충분으로 미수행 — ST-1 가격표 대조는 06_extract 내부 자산으로 가능.)
