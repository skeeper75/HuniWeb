# CR1~CR7 독립 검증 게이트 리포트 (wave-1 파일럿 · 129/130 + 부수 016/058 + wave-2 CN-5)

> §31 Huni-Constraint-Rules · Phase 3 · hcr-gate-validator · 2026-07-02
> 방법론: `hcr-gate-validation` 스킬(CR1~CR7). designer 주장 비신뢰 — 전건 직접 재실측.
> 라이브 읽기전용 SELECT + BEGIN…ROLLBACK dryrun만 사용 · COMMIT 0 · 비밀값 비노출.
> DB 서버시각 UTC 기준(재실측 시점 2026-07-02 05:08 UTC = 14:08 KST).

---

## 0. 전체 판정 — **GO** (wave-1 8규칙)

| 게이트 | 판정 | 근거(직접 재실측) |
|--------|------|-------------------|
| **CR1** 필요상황 충실 | **PASS** | 8규칙 전건 CN-2 귀속·근거(candidates/need-spec/라이브) 실재 |
| **CR2** 정합·오차단 0 [HARD] | **PASS** | 스냅샷 이후 단가행 무변경·차단 8셀 부재/허용 8셀 실존 전수 대조·병합 규칙집합 16셀 오차단 0·누락 0 |
| **CR3** UI 역파싱 전수 | **PASS** | views.py `_parse_logic_to_conditions` 독립 재구현으로 8/8 PARSEABLE |
| **CR4** 가독성 | **PASS** | rule_cd `R_MATSIZ_*` 규약·err_msg 쉬운 한국어+대안 안내 전건 |
| **CR5** 이관 정합 | **N/A** | 이번 wave 옵션그룹 이관 0건(P-3 별색 CN-6은 미설계) — 통과 위장 아님 |
| **CR6** 등록 안전 | **PASS** | ON CONFLICT(prd_cd,rule_cd) 멱등·undo 대칭·validate 로컬 시뮬 재현·500 위험 0·dryrun 라이브 적용 성공 |
| **CR7** 독립성·전달안 실재 | **PASS** | 전 판정 직접 실측·dev-handoff 인용 파일:라인 전건 실재 |

**UNVERIFIED 게이트 0 · HARD 게이트(CR2) PASS → wave-1 8규칙 GO.**
GO분(8규칙 = `apply-fix.sql`)만 인간 승인 큐로 → hcr-ui-registrar.

**부수 판정**: 016 R_DEMO_VIS/R_DEMO_EXC = PASS(무수정, GO). 058 RULE_001 = NO-GO(CONFIRM-QUEUE·apply-fix 미포함 정당). wave-2 CN-5 19건 = BLOCKED-UI(설계 반려 타당).

**잔여 위험(GO 유지)**: 이 규칙들은 `evaluate_price`/`simulate`가 제약을 안 보므로(코드 실측 확인) **위젯/주문이 `/validate/`를 호출할 때만 실효**. 0원 오노출 자체는 그대로. 강제 계층 신설은 dev-handoff C-1·C-2·R-1~R-3 개발 항목(본 wave 범위 밖). 규칙 자체의 정확성·안전성은 GO.

---

## 1. CR1 — 필요상황 충실 (PASS)

- 8규칙 전건 `rule_typ_cd=RULE_TYPE.03`(필수동반)·CN유형=CN-2. 규정(constraint-need-spec §2 CN-2·판례 P-1) 밖 규칙 0.
- 근거 실재 재확인:
  - `constraint-candidates.csv` L124-125: 129/130 = CN-2, "mat4×siz2=8셀 중 단가행 4셀만(50%)·나머지 0원 위험".
  - 라이브 재실측(§2 CR2)이 이 근거를 그대로 재현(각 컴포넌트 4행=대각 4셀).
- 규정 밖 규칙 0건 → **PASS**.

## 2. CR2 — 정합·오차단 0 [HARD] (PASS)

### 2-1. 스냅샷 신선도 (유도 시점 2026-07-02 13:59:30 이후 단가행 변경 0)
```sql
SELECT comp_cd, count(*), min(reg_dt), max(reg_dt), max(upd_dt)
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_POSTER_FOAMBOARD_BOARD','COMP_POSTER_FOMEXBOARD_BOARD')
 GROUP BY comp_cd;
```
결과: FOAMBOARD 4행(max reg_dt 2026-07-01 15:41 UTC), FOMEXBOARD 4행(2026-07-02 02:08 UTC). 전 행 reg_dt가 스냅샷(13:59:30 KST=04:59 UTC) **이전**, upd_dt 전건 NULL(사후 변경 없음). → **추가/삭제/수정 0건, 스냅샷 유효.**

### 2-2. 허용/차단 셀 전수 대조 (규칙이 막는 집합 vs 단가행 실존 집합)
재현 쿼리(상품·컴포넌트별):
```sql
-- 제공 자재
SELECT pm.mat_cd, pm.usage_cd, m.mat_nm FROM t_prd_product_materials pm
  LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
 WHERE pm.prd_cd=:prd AND COALESCE(pm.del_yn,'N')<>'Y' ORDER BY pm.disp_seq;
-- 제공 사이즈
SELECT ps.siz_cd, s.siz_nm FROM t_prd_product_sizes ps
  LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
 WHERE ps.prd_cd=:prd AND COALESCE(ps.del_yn,'N')<>'Y' ORDER BY ps.disp_seq;
-- 실존 (mat,siz) = 허용 집합
SELECT DISTINCT mat_cd, siz_cd FROM t_prc_component_prices
 WHERE comp_cd=:comp AND mat_cd IS NOT NULL AND siz_cd IS NOT NULL;
```

| 상품 | 제공 그리드 | 실존(허용) | 부재(차단) | 규칙 매핑 |
|------|-----------|-----------|-----------|-----------|
| 129 | mat{398,399,612,613}×siz{198,315}=8 | 398×315·399×315·612×198·613×198 | 398×198·399×198·612×315·613×315 | 각 자재→실존 사이즈 1:1 |
| 130 | mat{022,554,023,555}×siz{174,197}=8 | 022×174·023×174·554×197·555×197 | 022×197·023×197·554×174·555×174 | 각 자재→실존 사이즈 1:1 |

- 규칙이 막는 8셀 = 라이브 component_prices에 **실제 부재**(전수 확인). 허용 8셀 = **실존**(전수 확인).
- 자재당 실존 사이즈 정확히 1개(1:1) → 정당 조합 오차단 0 구조.

### 2-3. 병합 규칙집합 평가 (compile_constraints_orm 동형 · 독립 스크립트)
`{"and":[활성 4규칙]}`(cfg_utils.py:23-53 병합 동형)로 상품별 8셀 전수 평가:
- **16셀 전수: 실존 셀=통과(pass=True), 부재 셀=차단(pass=False)** 정확 일치.
- **오차단(false-positive·매출차단)=0 · 누락(엇갈림 통과)=0 · 평가예외(500)=0.**

→ HARD 게이트 **PASS**. (매출 직결 오차단 0 실증.)

## 3. CR3 — UI 역파싱 전수 (PASS)

- designer `parse_check.py` 미재사용. `views.py:200-315` `_parse_logic_to_conditions`를 **독립 재구현**한 별도 스크립트로 8규칙 대조.
- 8규칙 shape: `{"or":[{"!":{"===":[{"var":"mat_cd__usage_cd"},MAT]}},{"===":[{"var":"siz_cd"},SIZ]}]}`.
  - `.03` 역파서: `or`(len 2) → `neg_part.get("!")` 성공 → 조건 leaf `mat_cd__usage_cd`(OPT_REF_DIM.03), 결과 `siz_cd`(OPT_REF_DIM.01) 복원.
- **결과: 8/8 PARSEABLE** (cond=OPT_REF_DIM.03·result=OPT_REF_DIM.01). raw 폴백 필요 규칙 0.
- ★함정 회피 확인: 부정을 `{"!":{"===":...}}` 형태로 생성(폼빌더 `_build_logic_from_conditions` views.py:188 `{"!":combined}`와 동형). `RULE_TYPE_TEMPLATES`(views.py:120-130)의 `!==` 형태였다면 `.03` 역파서(`neg_part.get("!")`=None)가 못 여는데, 8규칙은 `!==`를 쓰지 않아 정합.

## 4. CR4 — 가독성 (PASS)

- rule_cd 규약: `R_MATSIZ_FB_*`(폼보드)·`R_MATSIZ_FX_*`(포맥스) 접두 일관 8건.
- rule_nm: `[제약조건데모] <자재> 는 <크기> 크기 전용` — 데모 태그 내장(129/130=제약조건데모 정합).
- err_msg 8건 전건 형식: `이 자재(<자재명>)는 <크기> 크기 전용입니다. 크기를 <크기>로 선택해 주세요.`
  - **왜**(전용)+**무엇/대안**(크기를 X로 선택) 포함. 쉬운 한국어. 고객 노출문에 코드(MAT_*/SIZ_*) 미노출.

## 5. CR5 — 이관 정합 (N/A)

- 이번 wave에 옵션그룹 오용 이관(CN-6) 설계 0건. P-3(별색 명명 분열)은 `optiongroup-misuse-board.md`에 판정만 있고 본 wave 미설계.
- 이관 대상 없음 → **N/A 명시**(통과 위장 아님). 후속 wave에서 이관 설계 시 CR5 집합 비교 적용.

## 6. CR6 — 등록 안전 (PASS)

- **PK 실재**: `t_prd_product_constraints_pkey PRIMARY KEY (prd_cd, rule_cd)` → `ON CONFLICT (prd_cd,rule_cd)` 유효.
- **컬럼 정합**: INSERT 컬럼 전건 실재. `reg_dt` NOT NULL **DEFAULT now()** → INSERT 생략 무결(함정 회피).
- **멱등**: dryrun 트랜잭션 내 fix 본문 2회 적용 → active=8·total=10·중복 0(ON CONFLICT UPDATE 재발).
- **undo 대칭**: undo 본문 실행 후 R_DEMO_MATSIZ(129/130) use_yn=Y/del_yn=N 복원 + 신규 8건 use_yn=N/del_yn=Y. 논리삭제 규약상 대칭(신규 8행은 물리 잔존하나 del_yn=Y — 규약 정합).
- **validate 재현**: 로컬 JSONLogic 시뮬(§2-3)로 막힘/통과 케이스 재현. 결측키(size만/mat만) 평가 시 예외 없음(=== None 비교 안전).
- **500 위험 0**: dryrun 실행 시 JSONB 캐스팅 정상·평가예외 0. 깨진 var/타입 없음(전 var가 문자열 === 비교, 숫자형 var 미사용).
- **dryrun 라이브 재실증**: `apply-dryrun.sql` BEGIN…ROLLBACK — UPDATE 2 + INSERT 8, 최종 활성 8+구데모 비활성 2, ROLLBACK 청결(무기록).

재현:
```
psql -f 03_rules/wave1-pilot/apply-dryrun.sql   # BEGIN…ROLLBACK
# 멱등: BEGIN; <fix본문>; <fix본문>; SELECT count(*) FILTER(use_yn='Y' AND del_yn='N'); <undo본문>; ROLLBACK;
```

## 7. CR7 — 독립성·전달안 실재 (PASS)

- 전 판정이 생성물 재인용이 아닌 직접 실측(라이브 SELECT·독립 스크립트·dryrun).
- `dev-handoff-draft.md` 부록 A 인용 파일:라인 재확인(전건 실재):
  - `cfg_utils.py:23-53` compile_constraints_orm(and 병합) ✓ / `:61-72` evaluate_constraints(try 없음→500) ✓ / `:80-98` logical_delete ✓
  - `views.py:52-60` VAR_KEY_MAP(7 ref_dim, width/height 없음) ✓ / `:67-70` OPT_DIM_VAR ✓ / `:88-94` mat 결합키 ✓ / `:120-130` RULE_TYPE_TEMPLATES ✓ / `:133-193` _build_logic ✓ / `:200-315` _parse_logic ✓ / `:2454-2493` 저장 3경로 ✓ / `:2496-2523` 자동채번 ✓ / `:2525-2538` update_or_create ✓ / `:2683,2758` impact ref_dim_cd=NULL ✓ / `:2798-2846` validate_preview(except→result=True) ✓ / `:3058-3080` SKU 콜백(warn·저장 결과 불변) ✓
  - `constraint_builder.html`(861행) 존재·`:597` VAR_KEY_MAP 미러·`:265-269` 역변환 불가 폴백 안내 ✓
  - `pricing.py`·`price_views.py` 제약 참조 **grep 0건** ✓ (C-1 근거)
- 허위/불명 근거 항목 0 → dev-handoff 전 항목 승격 자격.

---

## 8. 부수 규칙 재확인 (016 PASS / 058 NO-GO)

### 016 프리미엄엽서 — PASS (무수정, GO)
- `R_DEMO_VIS`(.01) `{"or":[{"!":{"in":["OPV_000018",{"var":"sel_opts"}]}},{"in":["OPT-000007",{"var":"sel_opt_grps"}]}]}` — PARSEABLE. err_msg 공백이나 가시성(.01) 규칙이라 정당.
- `R_DEMO_EXC`(.02) `{"!":{"and":[in OPT-000005, in OPT-000006]}}` — PARSEABLE. err_msg "오시(접지선)와 미싱(절취선)은 동시에 적용할 수 없습니다." 정합.
- 라이브 실측 일치 → designer PASS 판정 **재확인 정확**.

### 058 반칼원형스티커 — NO-GO → CONFIRM-QUEUE (apply-fix 미포함 정당)
- 라이브 RULE_001: `rule_typ_cd=RULE_TYPE.03` 인데 logic=`{"!":{"and":[siz===SIZ_000426, in OPV-000066..073]}}` = `.02`(not-and) shape.
- **결함 3중 재확인**:
  1. type↔shape 불일치 → `.03` 역파서(최상위 `or` 기대) **RAW-ONLY**.
  2. **죽은 규칙**: 조건 `siz_cd===SIZ_000426`인데 상품 제공 사이즈=SIZ_000170(A5)·SIZ_000520(A4 반칼)뿐 → **SIZ_000426 미제공**(라이브 확인) → antecedent 영구 거짓 → 절대 발동 안 됨.
  3. err_msg 공백.
- 규칙명 'A5 커팅'↔코드(SIZ_000426) 불일치=의도 불명 → **CONFIRM-QUEUE**(curator/실무진 컨펌). designer가 apply-fix에 미포함한 것 **정당**.

## 9. wave-2 CN-5 (BLOCKED-UI 19건 — 설계 반려 타당)

- 폼빌더 구조 재확인(views.py):
  - `VAR_KEY_MAP`(52-60): 7 ref_dim만. **`width`/`height`/`size_mode` 부재** → `_REVERSE_VAR_KEY.get("width")=""` → 역파싱 불가.
  - `_dim_clause`(106-114)·`_is_leaf`(239-241): 연산자 `===`/`in` **뿐**. `>=`/`<=` 생성·인식 경로 없음.
  - 기존 committed 범위규칙(118 RULE_001): `{"or":[{"!=":[size_mode,nonspec]},{"and":[{">=":[width,200]},{"<=":[width,1200]},...]}]}` = **RAW-ONLY** 실증.
- nonspec 컬럼 실측(119=200~900×200~3000·138=500~1750×500~5000·146=20~100×20~100) — 후보 CSV값 일치, genuine range 상품.
- → 범위규칙은 폼빌더 정형 shape로 표현 불가 = "UI-확인가능 우선"[HARD] 위반. **BLOCKED-UI 19건 반려 타당**. 해소=§6 컬럼 강제 or 폼빌더 수치범위 조건 타입 추가(dev-handoff C-9 신설).

---

## 10. NO-GO / 라우팅

| 항목 | 판정 | 사유 | 라우팅 |
|------|------|------|--------|
| wave-1 8규칙 | **GO** | CR1~CR7 통과(CR5 N/A) | 인간 승인 → hcr-ui-registrar(apply-fix.sql COMMIT + webadmin 실화면 재현) |
| 058 RULE_001 | NO-GO | type/shape 불일치+죽은 규칙+err 공백+의도 불명 | curator/실무진 CONFIRM-QUEUE |
| wave-2 CN-5 19건 | BLOCKED-UI | 폼빌더 수치범위 미표현 | §6 컬럼 강제 / 폼빌더 확장(dev-handoff C-9) |
| AMBIG 아크릴 5건 | 스코프 밖 | 단가 TBD(제약 아님) | 실무진 BLOCKED |
