# codex 독립 2차 교차검증 — §27 배선 서브트랙 §18 설계(DESIGNED 12건) · Phase 5.5

- 산출일 2026-07-01 · 검증자=hpe-codex-validator(Claude) · 외부모델=Codex **gpt-5.5**(읽기전용 샌드박스·high effort)
- 입력(codex에 전달): `orphan-classification-260701.md` + `design-namecard-260701.md`/`.sql` + `design-bind-fold-board-260701.md`/`.sql` + 엔진 매칭 의미(pricing.py `_row_matches`/`_match_entry`/`component_subtotal`) + 골든값. **★Claude 게이트 판정은 비전달(독립성·echo 방지).**
- codex 가용성: **AVAILABLE**(preflight `AVAILABLE model=gpt-5.5`). 미가용 폴백 불필요. codex가 repo 파일을 실제로 읽고 라인 인용(pricing.py:94/657·price_views.py:1360·각 설계문서/SQL 라인) — 환각 아닌 파일근거 판정.
- ★[HARD] **codex 주장 = 가설.** 라이브 스키마·권위 엑셀·엔진 코드 실재 확인 전엔 사실 아님. 단 일부는 **설계문서/SQL 자체에서 즉시 확인 가능**(라이브 불요) → 그건 `파일확인` 태그.

---

## 1. codex 2nd opinion 원문 요지

codex 총평: **"명함/보드 판별 설계는 조건부 타당. 단 엽서북 30p 설계는 그대로 적용 불가"** — 두 가지 신규 결함 발굴(아래 §3). 나머지 대부분은 설계와 **독립 합의**.

### 합의(codex가 독립적으로 같은 결론) — 고신뢰 후보
| 항목 | codex 독립 판정 | 설계문서 주장 | 상태 |
|---|---|---|---|
| 엔진 NULL=wildcard·전 매칭 합산 | 확인(pricing.py:94/657) | §0 근본함정 | **합의** |
| 명함박 body4 (print_opt×opt) disjoint | disjoint 맞음 | §3 PASS | **합의** |
| 박명함 SETUP opt_cd=NULL **안전**(이중 setup 아님) | print_opt로 갈려 의도된 1회 합산·double 아님 | §3 setup 정상 | **합의**(우려점 해소) |
| 화이트명함 (mat×print_opt×opt) 4 body disjoint | disjoint 맞음 | §4 PASS | **합의** |
| PRF_NAMECARD_WHITE 신설 정당 | PRD_000040 공식 바인딩 0·공식 부재 확인 | §B 견적0 | **합의** |
| 보드 siz_cd disjoint(白174/197/293↔黑315/317·3mm↔5mm) | silent-sum hole 없음 | §D | **합의** |
| 보드 배선 안전하나 315/317 미등록=inert | 핵심=등록 전 무효 | §D 발현조건 | **합의** |
| 골든값 산술 재현 | foil S2_HOLO300=33200+5000=38200·white S1nocoat100=14500·PCB30P S1 SIZ3 qty2=23000·보드 8500/14000/10000/16000 **전부 일치** | §5 골든 | **합의(고신뢰)** |
| 화이트 qty≠100 tier 미검증 | 권위 엑셀 없이 검증 불가·§26 의존 맞음 | §6 ① | **합의** |
| 캘린더 BLOCKED 정당 | 공식 바인딩0·proc 076/079/021 ↔ comp 099-102 no_match | B BLOCKED | **합의** |
| 접지카드 BLOCKED 정당 | PRF_DGP_E에 COMP_FOLD_LEAF_* 이미 존재→FOLD_CARD 추가 시 이중과금 | C BLOCKED | **합의** |

→ **disjoint 판별·골든 재현·2건 BLOCKED 강등 모두 codex 독립 합의.** 설계의 핵심 안전논리(silent-sum 가드)와 보수적 BLOCKED 판정은 외부모델이 echo 아닌 독립으로 동의 = 고신뢰.

---

## 2. codex 발굴 핵심 이슈 (가설 — Claude reconcile 대상)

### ⚠ ISSUE-1 [HIGH·파일확인] OPT_000080 코드 충돌 (두 설계 교차)
codex: 명함 설계가 `OPT_000080=박종류`(PRD_000037), 엽서북 설계도 `OPT_000080=페이지수`(PRD_000094)로 **동일 opt_grp_cd를 서로 다른 의미로 mint**.
- **Claude 파일 즉시확인 = 사실.** `design-namecard-dryrun.sql:29` → `OPT_000080 '박종류'`(가드 전역 `WHERE opt_grp_cd='OPT_000080'`). `design-bind-fold-board-dryrun.sql:21` → `OPT_000080 '페이지수'`(가드 per-prd `WHERE prd_cd='PRD_000094' AND opt_grp_cd='OPT_000080'`).
- 근원: 두 설계가 각각 독립적으로 `MAX(opt_grp)=OPT_000079→OPT_000080`을 집었다(배치 전반 채번 미조율). 명함은 OPT_000080·081 둘 다 점유 → 엽서북은 OPT_000082여야 함.
- 위험: 함께 COMMIT 시 ① 전역 PK면 둘째 INSERT가 NOT EXISTS에 걸려 **silent skip**(엽서북 옵션그룹 누락→배선 무효) ② 복합PK면 같은 코드 두 의미 공존(혼선). 가드 스코프도 불일치(전역 vs per-prd)=독립 저작 흔적.
- **라이브 미검증 부분**: opt_grp_cd가 전역 PK인지 (prd_cd,opt_grp_cd) 복합인지 → 스키마 확인 필요. 단 충돌 자체는 파일확인.

### ⚠ ISSUE-2 [MED-HIGH·가설] 엽서북 opt_cd 선택수단 배선 결함
codex: 엽서북 dryrun(A.2)이 `t_prd_product_option_items`에 `ref_dim_cd='opt_cd'`로 넣지만 ① `t_prd_product_options` rows를 안 만들고 ② `ref_dim_cd='opt_cd'`가 스냅샷 `OPT_REF_DIM.01~07` 체계에 없음 → 시뮬레이터 opt_cd 드롭다운이 `TPrdProductOptions`에서 읽으므로(price_views.py:1360) 고객 선택이 실제 `selections.opt_cd`로 안 들어갈 수 있음.
- **내부 모순 교차확인**: 명함 설계는 정반대 경로 — `design-namecard-dryrun.sql`이 `t_prd_product_options`(OPV_000487~490)를 직접 INSERT하고, `design-namecard-260701.md §4`가 "opt_cd 드롭다운·엔진 매칭은 TPrdProductOptions로 충분(price_views `_opt_cd_options`)"이라 **명시**. 즉 같은 opt_cd 선택 메커니즘인데 두 설계가 다른 테이블 경로 사용 = 설계 간 불일치(파일확인).
- **라이브 미검증 부분**: 엔진/시뮬레이터가 opt_cd 선택지를 `t_prd_product_options`에서 읽는지 vs `t_prd_product_option_items`(polymorphic ref_dim_cd) 경로도 먹는지 → price_views/pricing 코드 실독 필요. 명함 설계 자체 주장과 codex 주장이 일치하므로 신뢰도 높으나 라이브 확인 전 가설.
- (부수) `OPV_PCB_PAGE_20P/30P` 네이밍이 OPV_숫자 관례와 다름 — 설계가 "채번 최종확정=dbm-axis-staged-load 위임"으로 이미 deferral 명시(저위험).

---

## 3. codex가 도전하지 않은 것 (이견 없음)

codex는 설계의 BLOCKED 보수성(캘린더·접지카드)을 **"더 설계 가능"이라 뒤집지 않고 정당하다 동의**. 폼보드/포맥스를 "지금 발현 가능"이라 과신하지 않고 "315/317 등록 전 inert" 동의. 박명함 SETUP 이중계상 우려를 "안전" 확정. 골든값 무하나 어긋남 없음. → **자동 flip 신호 없음.** 설계를 약화시킬 외부 반론 0.

---

## 4. Claude 후속 reconcile 대상 목록

| # | 항목 | 유형 | 소유자/해소 | 우선 |
|---|---|---|---|---|
| R-1 | OPT_000080 충돌(명함 박종류 vs 엽서북 페이지수) | **파일확인 충돌** | 배치 채번 재조율(엽서북→OPT_000082+) · 실 COMMIT 전 필수. opt_grp_cd PK 스코프 라이브 확인 | **HIGH** |
| R-2 | 엽서북 opt_cd 선택수단 = option_items/ref_dim_cd vs 명함 = t_prd_product_options 불일치 | 가설+파일확인(내부모순) | 엔진/시뮬 opt_cd 소스 코드 실독(price_views `_opt_cd_options`·pricing `selections`) → 엽서북을 명함 패턴 정합 | **MED-HIGH** |
| R-3 | `ref_dim_cd='opt_cd'`가 OPT_REF_DIM 체계 부재 | 가설(스냅샷) | live-snapshot OPT_REF_DIM 코드값·FK 제약 확인 | MED |
| R-4 | 화이트명함 qty≠100 tier 오산정(합가형 프로레이팅) | 합의(기존 §26 의존) | §26 무결성/권위 엑셀 tier 충전 선행. 골든은 qty=100 한정 유효 | MED(기지) |
| R-5 | (합의·고신뢰 확정) disjoint·골든·BLOCKED 2건 | 합의 | 추가 조사 불요·고신뢰 기록 | — |

**reconcile 원칙**: R-1은 codex가 옳음(파일근거)·라이브 flip 아님·채번 조율로 해소. R-2/R-3은 codex 가설 → 엔진코드/스냅샷 재측정으로 판별(codex에 맞춰 자동 flip 금지·라이브 우선). R-4는 설계가 이미 자인한 선행의존. 합의분(R-5)은 외부모델 독립 동의로 고신뢰.

---

## 5. 결론

- codex 가용=**GO**(gpt-5.5·읽기전용·파일실독). Claude 단독 폴백 불필요.
- codex는 설계의 **안전논리·disjoint·골든·BLOCKED 강등에 광범위 독립 합의**(echo 아님) → 고신뢰.
- **신규 발굴 2건**(설계가 못 본 것): ⚠ **OPT_000080 두 설계 코드충돌**(파일확인·HIGH·실COMMIT 전 채번 재조율 필수) · ⚠ **엽서북 opt_cd 선택수단 경로 불일치**(명함=t_prd_product_options vs 엽서북=option_items/ref_dim_cd·가설·엔진코드 확인 필요).
- ★codex 주장은 라이브/권위 검증 전 사실 아님. 단 R-1 충돌은 두 SQL 파일에서 즉시 확인됨(라이브 불요). R-2/R-3은 엔진코드·스냅샷 재측정 대상.
- 산출: 본 파일 `_workspace/_foundation/batch/wiring/codex-design-260701.md`.
