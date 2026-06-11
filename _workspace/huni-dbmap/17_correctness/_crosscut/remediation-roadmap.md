# 교정 로드맵 (remediation-roadmap · round-13 메타)

> **작성** 2026-06-11 · round-13 메타. 횡단 패턴별 교정을 실행 트랙(round-5 멱등 UPSERT · round-6 CPQ · round-10 델타 · round-2 가격 · ddl-proposer)에 배정 + FK 적용순서 + 인간 승인 게이트. **[HARD] 비파괴:** 본 로드맵은 *배정·순서 설계*까지. 실 COMMIT/DDL/DELETE/논리삭제는 **종착점 너머**(round-5/6/10 실행 + 인간 승인). DB 미적재.
>
> **결정 선결:** 각 트랙 진입 전 batch-confirmations.md의 해당 BATCH 결정점이 닫혀야 함(컨펌 미해소 = 트랙 BLOCKED).

---

## 0. 트랙 배정 요약

| 트랙 | 성격 | 담당 패턴 | 실행 도구 |
|------|------|----------|----------|
| **round-10 델타** | 기존 행 UPDATE(값 정정·재연결) | 카테고리 재연결·mat_typ 정정·레더 .06·MES 채움·editor_yn·필수성 | 멱등 UPSERT(ON CONFLICT·upd_dt) |
| **round-5 적재실행** | 신규 INSERT(미적재 연결행) | 공정/자재 연결·봉투 sets·면지/실버링·부속 addon·묶음수 | 멱등 INSERT … ON CONFLICT |
| **round-6 CPQ** | 옵션 레이어 신규 | 색상→옵션·size→option·장수·택일그룹·조각수/형상 param | option_groups/options/items |
| **round-2 가격** | 가격 공식·단가 | 포토북/디자인캘린더/문구/부자재 가격 | dbm-price-formula |
| **ddl-proposer** | 신규 코드/엔티티 mint | 미싱제본·보드마운팅·삼각대거치·ref_param_json·라미 자재·캘린더봉투 template | CREATE/INSERT 코드행 제안 |
| **논리삭제** | use_yn/del_yn(hard-delete 금지) | 잉여 고아 노드·오염 자재행·page 잡음·테스트 잔재 옵션 | UPDATE use_yn='N' |

---

## 1. FK 적용순서 (위상정렬) — 전 패턴 통합

교정은 **마스터(코드행·노드) → 연결(상품-속성) → 논리삭제** 순. 역순 시 FK 위반·고아 발생.

```
[0] 신규 마스터 mint (ddl-proposer) — 필요 시만
    └ 공정 마스터(미싱제본·보드마운팅·삼각대거치) / 자재(라미) / template(캘린더봉투) / ref_param_json 컬럼
[1] 마스터 값 UPDATE (round-10)
    └ mat_typ_cd 정정(.08/.01→.06·.01→.11·.09→소재별) — 자재 마스터 레벨
[2] 상품-카테고리 재연결 (round-10)
    └ t_prd_product_categories cat_cd UPDATE (정상노드 실재 전제·search-before-mint)
[3] 상품-속성 연결 INSERT (round-5)
    └ processes / materials / addons / sets / bundle_qtys (마스터 [0][1] 후)
[4] CPQ 옵션 적재 (round-6)
    └ option_groups → options → option_items (ref_dim_cd 차원행 선적재 전제)
[5] 가격 적재 (round-2)
    └ price_formulas → component_prices / product_prices / template_prices
[6] 논리삭제 (use_yn='N') — 재연결/정정 검증 후 마지막
    └ 잉여 고아 노드 / 오염 자재 연결행 / page 잡음 / 테스트 옵션
```

> **[HARD] 논리삭제는 항상 마지막** — 재연결·재적재가 검증된 뒤. 먼저 삭제하면 사슬 파손(round-10 교훈: 기계적 size 삭제 금지).

---

## 2. 패턴별 교정 배정 (상세)

### ① 카테고리 재연결 → round-10 델타 + 논리삭제 [P1·9 family·113상품]
| 단계 | 작업 | 트랙 | FK 순서 | 게이트 |
|:--:|------|------|:--:|------|
| 1 | 113상품 cat_cd UPDATE(의미매칭 정상노드) | round-10 | [2] | search-before-mint(정상노드 실재 검산 완료) |
| 2 | 빈 고아 노드 14개 use_yn='N' | 논리삭제 | [6] | 재연결 검증 후·CAT_000297(상품0)은 선행 안전 |
- **선결:** BATCH-1 + 명함/상품권/단품형 정상노드 확인(미매칭분).
- **비파괴:** UPDATE만·삭제 아닌 숨김. **인간 승인:** round-10 델타 DRY-RUN(V1~V8) 후 COMMIT.

### ② MAT_TYPE 자재 오염 → round-10(mat_typ) + round-6(옵션) + 논리삭제 [P1·8 family]
| 오염 유형 | 교정 | 트랙 | FK 순서 |
|----------|------|------|:--:|
| 레더 .08/.01→.06 | mat_typ UPDATE(또는 .06 고아행 재연결) | round-10 | [1] |
| 스티커 점착지 .01→.11 | mat_typ UPDATE(4자재) | round-10 | [1] |
| 색상→옵션 | 옵션 신규 + 오염 자재행 논리삭제 | round-6→논리삭제 | [4]→[6] |
| 형상→siz·용량→siz·잉크색→도수 | 정확 축 신규 + 오염 행 논리삭제 | round-5/6→논리삭제 | [3]→[6] |
| 부속→공정 | 공정 연결(+필요시 mint) + 자재행 논리삭제 | ddl→round-5→논리삭제 | [0]→[3]→[6] |
- **선결:** BATCH-2·BATCH-4. **비파괴:** 오염 행은 정확 축 적재 검증 **후** 논리삭제(먼저 삭제 금지).

### ③ v03 진원 → 전 트랙 공통 원칙 [P4·10 family]
- **교정 진원=상품마스터 L1 권위 델타**(v03 재참조 금지·load_master 비수정).
- **[HARD] 재실행 가드:** load_master --all 재실행이 교정을 덮어쓰는 회귀(MES NULL·plate .03·print_side 하드코딩) → 교정은 멱등 UPSERT로·load_master 재실행 시 교정 컬럼 보존 로직 또는 재실행 금지 정책.
- **선결:** BATCH-12(DB 직접 vs v03 상류).

### 추가-A 코팅 통일 → round-5(공정연결) + round-10(자재정정/논리삭제) [P1·4 family]
- (a)선택 시: 스티커 코팅 공정 PROC_000013 연결[3] + 코팅스티커 자재행 논리삭제[6] + 가격엔진 코팅 component(round-2). 문구/포토북 자재명 정정[1]+공정 연결[3].
- **선결:** BATCH-3(CONFLICT 결정). **(b)면 스티커 무교정.**

### 추가-B 레더 .06 → ②에 포함(round-10) [P1·4 family·6상품]
- **단일 결정:** MAT_000186 .08→.06 UPDATE 1회=6상품 동시. **또는** booklet/stationery만 .06 고아행 재연결(그 경우 MAT_000186은 .08 유지). **두 방식 혼용 금지** → BATCH-4 일괄.

### 추가-C plate 경로 → ddl-proposer(코드 정합) [P3·5 family]
- load_master `load_rel_plate_sizes`에 치수→계열 매핑 추가 제안(.01 퇴행 방지). 라이브 값 무수정. 폴더→output_paper는 BATCH-10.

### 추가-D 봉투 세트 → round-5(sets) + ddl(template) + round-6(매칭) [P2·3 family]
| 단계 | 작업 | 트랙 | FK 순서 |
|:--:|------|------|:--:|
| 1 | 캘린더봉투 template mint(캘린더만) | ddl | [0] |
| 2 | t_prd_product_sets INSERT(배경지×봉투) | round-5 | [3] |
| 3 | 사이즈매칭 constraint(JSONLogic) | round-6 | [4] |
- **선결:** BATCH-5. 봉투 상품·template 대부분 실재(search-before-mint).

### 추가-E MES 채움 → round-10(UPDATE) [P3·5 family]
- 중복 없는 군(캘린더 007-0001~5) 우선 UPDATE[1]. 중복 군은 정리 후. **선결:** BATCH-11.

### 추가-F page 잡음 → 논리삭제(note 보존) [P3·2 family]
- page_rule 3/3/3 정리(침묵삭제 금지·note+escalate)[6]·묶음수 dflt 1개. **선결:** BATCH-8.

### 추가-G usage 정정 → round-10(UPDATE) + ddl(코드신설 시) [P3·4 family]
- 종이 usage.07→.01(책자류)[1]·낱장 .07 유지. 본체/부속 코드 신설은 ddl(BATCH-9 결정 시). **주의:** 324행 전부 결함 아님(낱장 정당).

### 추가-H CPQ 전면 → round-6 [P2·6+ family]
- option_groups→options→items[4]. **선결:** BATCH-6(size↔option 경계·SEL_TYPE·ref_param_json). excl_grp_cd 삭제됨(Phase11)→SEL_TYPE.01 단일선택.

### 추가-I 가격 → round-2 [P2·4 family]
- price_formulas→prices/template_prices[5]. **선결:** BATCH-7(목표 테이블). round-14 Phase11(template_prices·PRICE_TYPE) 반영.

### family 단발 → ddl-proposer + round-5 [P4·~20건]
- 미싱제본·보드마운팅·삼각대거치 mint[0]→연결[3]. 완칼 묵시·볼체인 addon 재연결·박색·sub_prd 078 잡음(논리삭제[6]). **선결:** BATCH-13/14.

---

## 3. 인간 승인 게이트 (트랙별 종착점)

| 트랙 | 게이트 | 승인 산출 |
|------|------|----------|
| round-10 델타 | V1~V8 + 롤백전용 DRY-RUN(멱등·delta) | 변경 매니페스트 + DRY-RUN 로그 |
| round-5 적재 | R1~R6 + 롤백전용 DRY-RUN | 적재 SQL + DRY-RUN(제약위반0·COMMIT0) |
| round-6 CPQ | fn_chk_opt_item_ref 무결성 + 트리거 검증 | 옵션 적재본 + ref 무결성 |
| round-2 가격 | R1~R6 + 공식사슬 완결 | 가격 CSV + 공식 검증 |
| ddl-proposer | search-before-mint 입증 + 코드행 제안서 | DDL 제안(직접 적용 금지) |

> **[HARD] 모든 트랙:** 실 COMMIT/DDL 적용/논리삭제 = **인간 승인 후**. 본 round-13 + 메타는 **제안까지**. DB 미적재 원칙 유지(GO분 외 미적재).

---

## 4. 권장 실행 순서 (의존성 기반)

```
Wave-0 (선결 컨펌): BATCH-1~4(P1) + BATCH-12(v03 방향) 닫기
   ↓
Wave-1 (마스터·델타): ① 카테고리 재연결 + ② mat_typ 정정(레더·점착지) + 추가-E MES
   └ round-10 델타·UPDATE 중심·논리삭제는 보류
   ↓
Wave-2 (연결 적재): 추가-A 코팅 공정 + 추가-D 봉투 sets + family 단발 공정/자재
   └ round-5·ddl mint 선행
   ↓
Wave-3 (옵션·가격): 추가-H CPQ + ② 색상→옵션 + 추가-I 가격
   └ round-6 + round-2·BATCH-6/7 선결
   ↓
Wave-4 (정리): 논리삭제 일괄(고아 노드·오염 자재행·page 잡음·테스트 옵션)
   └ 전 재연결·재적재 검증 후·use_yn='N'
```

> **가장 시급한 횡단 1건(roadmap 권장 착수):** **BATCH-4 레더 .06 정정**(MAT_000186 1행 UPDATE=4 family 6상품 동시 교정·round-10·FK [1]·즉시 효과·search-before-mint 검산 완료). 다음 BATCH-1 카테고리(113상품·9 family).

---

## 5. 메타 교훈 (로드맵 설계 근거)

- **횡단 일괄이 개별보다 정확:** 카테고리·mat_typ·코팅은 family를 가로지르는 동일 진원 → 패턴축 일괄 교정이 family별 반복보다 누락·불일치 적음.
- **논리삭제 마지막·재연결 우선:** round-10/12 교훈(레더 고아행 재연결·기계적 size 삭제 금지). search-before-mint 전 패턴 적용(정상노드·.06 고아행·봉투 template·공정 마스터 실재 검산).
- **재실행 가드 필수:** v03 진원 교정은 load_master --all 재실행에 덮일 수 있음(MES·plate·print_side) → 멱등 + 보존 로직 없으면 교정 무효화.
- **컨펌 선결이 BLOCKER:** BATCH 미해소 트랙은 진입 금지(특히 BATCH-3 코팅 CONFLICT·BATCH-6 size↔option 경계·BATCH-12 v03 방향).
- **round-14 정합:** Phase11(excl_grp_cd 삭제·template_prices·PRICE_TYPE) 반영 — 택일그룹은 SEL_TYPE.01·가격은 template_prices 검토.
