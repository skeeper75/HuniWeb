# SPEC-PRICEGRID-001 — 진행 기록

## §E.1 Plan-phase Audit-Ready Signal

- 산출: `spec.md` (요구사항 GEARS **16항** — Tier M 상한과 동일, 증설 불가 · 범위 제외 5구획) · `plan.md` (마일스톤 M0~M7 + M1b + M5b · 미해결 질문 **0건**) · `acceptance.md` (AC **16항**(0.3.0 에서 13→14 · 0.4.0 에서 14→15 · 0.6.0 에서 15→16) · 경계 6건)
- **[HARD] Tier M 양축 상한 도달(0.6.0)** — 요구사항 16/16 · 인수 기준 16/16. 다음 정정이 어느 한쪽이라도 늘려야 한다면 **티어 판단(`plan.md` §B-5)을 다시 여는 신호**다
- SPEC ID 검사: `[[ "SPEC-PRICEGRID-001" =~ ^SPEC(-[A-Z][A-Z0-9]*)+-[0-9]{3}$ ]]` → `PASS` (2026-08-29)
- 권위 최신본 절대경로 확인: `후니프린팅_상품마스터_260822_1.xlsx` · `후니프린팅_인쇄상품_가격표_260822_1.xlsx` (2026-08-29)
- 라이브 쓰기: 0건 (plan-phase 는 읽기만 — 실행한 것은 `SELECT` 뿐)

### 판본 0.2.0 — 독립 계획감사 지적 처리 (2026-08-29)

감사 점수 0.74 / Tier M 기준선 0.80. 지적 13건 중 **11건 확인·반영 · 1건 기각 · 1건 부분 반영**.
감사자도 하나의 에이전트이므로 **모든 지적을 인용 원본에 대조한 뒤** 반영했다.

#### 확인·반영 (원본 대조 결과 지적이 성립)

| # | 확인한 것 | 실행한 명령 / 읽은 좌표 | 관측 |
|---|---|---|---|
| D1 | 차원 공간이 9가 아니라 12 | `price_views.py:38-51` `DIM_META` · `admin.py:157-161` `_USE_DIM_CHOICES` | 12종. 0.1.0 이 `plt_siz_cd`·`coat_side_cnt`·`spot_side_cnt` 누락 |
| D1 | `plt_siz_cd` 는 제3의 출처 | `price_views.py:126-130` `DIM_FK_FILTER` · `1348-1358` `_fk_options` | 사이즈정보 마스터를 `impos_yn='Y'` 로 거름. 상품 축도 권위 축도 아님 |
| D1 | `plt_siz_cd` 실사용 | `axis-260829.csv:12-15` | `PRD_000108`·`109`·`111`·`112` / `COMP_PAPER` / `mat_cd,plt_siz_cd,min_qty` |
| D2 | `proc_grp` 는 분모를 좁힌다 | `price_views.py:1386-1391` → `536-548` `proc_child_options` | `TProcProcesses.filter(upr_proc_cd=group, del_yn='N')` — **상품 축 아님** |
| D2 | `opt_grp` 도 같다 | `price_views.py:1393-1397` → `1361-1373` `_opt_cd_options` | `TPrdProductOptions.filter(opt_grp_cd=…)` |
| D3 | `dims` 에 `param_cols` 가 낀다 | `price_views.py:1382-1391` · 응답 `1420-1427` | `proc_grp` 있으면 `proc_cd` **바로 뒤**에 삽입. 응답 `dims` 가 이미 포함 |
| D4 | 인용 오기 | `sed -n '778,781p' pricing.py` · `grep -n "proc_grp" pricing.py` | `:779` 는 `opt_grp:` 만. `proc_grp` grep **0건** — 지적대로 오기 |
| D5 | `opt_cd` 원천 | `price_views.py:1361-1373` | `TPrdProductOptions`(`t_prd_product_options`). CPQ 레이어 가설 기각 |
| D6 | 마커 (D)·(E) 가 기결정과 모순 | `spec.md` REQ-PG-009 / REQ-PG-001 · `acceptance.md` AC-PG-009 / AC-PG-004 | 두 결정 모두 이미 요구사항에 확정돼 있었음 |
| D7 | 마커 (F) 오분류 | `plan.md` §D M3 | 이미 M3 로 예약돼 있음 — 사용자 결정 아닌 조사 작업 |
| D8·D9·D10 | AC 3건 | `acceptance.md` 본문 대조 | AC-PG-012 참 전체집합 필요 · AC-PG-001 기준선 명령 부재 · AC-PG-005↔D.2 게이트 상충 |

#### 감사자가 미검증으로 남긴 2건 — 실측으로 확정

읽기전용 `SELECT` 로 확인했다(`raw/webadmin/.venv/bin/python`, Django ORM 경유, 2026-08-29).

**① 골든 케이스 라이브 277행 — 확인됨**

```sql
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T';
SELECT apply_ymd, count(*) FROM t_prc_component_prices
WHERE comp_cd='COMP_ACRYL_CLEAR3T' GROUP BY apply_ymd ORDER BY apply_ymd;
```

관측: `277` · `('2026-06-01', 277)` — 적용일 단일.
`use_dims` = `["mat_cd", "siz_width", "siz_height", "min_qty"]` (선언과 일치).

**② `coat_side_cnt` / `spot_side_cnt` 실사용 — 사용 중이었다**

게시 상품(`use_yn='Y' AND del_yn<>'Y'`)에 공식으로 물린 구성요소의 `use_dims` 를
`jsonb_array_elements_text` 로 펼쳐 차원별 집계. 관측(구성요소 수 / 게시 상품 수):

`min_qty` 106/135 · `siz_cd` 52/94 · `proc_cd` 31/43 · `opt_cd` 22/19 · `mat_cd` 14/75 ·
`print_opt_cd` 12/44 · `siz_width` 10/28 · `siz_height` 10/28 · `bdl_qty` 8/10 ·
**`plt_siz_cd` 6/34** · **`coat_side_cnt` 2/20** · **`spot_side_cnt` 2/10**

⇒ **12종 전건 실사용.** 감사자가 「오늘 미사용이면 그렇게 적으라」고 남긴 조건부는 발생하지 않았다.
해당 4개 구성요소:

```
COMP_PRINT_SPOT_WHITE_S1  ["plt_siz_cd","proc_cd","spot_side_cnt","min_qty","proc_grp:PROC_000007"]
COMP_COAT_GLOSSY          ["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]
COMP_COAT_MATTE           ["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]
COMP_NAMECARD_SPOT        ["proc_cd","spot_side_cnt","min_qty","proc_grp:PROC_000007"]
```

`COMP_COAT_GLOSSY` 는 갈래 ①·②·③·④ + `proc_grp` 스코프를 **한 구성요소에서 전부** 밟는다 →
AC-PG-004 · M1b · M2 의 검증 대상으로 채택.

#### 감사가 놓친 것 — 원본 대조 중 추가 발견 2건

| 발견 | 좌표 | 반영 |
|---|---|---|
| 그리드 헤더는 `dims[].name` 이 아니라 **`label`** | `comp_price_grid_page.html:212-223` | REQ-PG-001 · AC-PG-004 |
| **단가 헤더가 고정 문자열이 아니다** — `prc_typ` 에 따라 `단가`\|`합가`\|`고정` | `comp_price_grid_page.html:225-228` · `price_views.py:688` `PRC_TYPE_LABEL` | REQ-PG-001. 골든은 `합가형` 이므로 헤더가 **`합가`** — 0.1.0 계약대로 「단가」로 쓰면 골든에서부터 틀린다 |

#### 기각 1건 — D13 (`related_specs` 프론트매터)

**지적**: `related_specs:` 는 정본 선택 필드가 아니므로 `depends_on:` 을 써야 한다.

**기각 사유**: `.claude/agents/moai/manager-spec.md` § SPEC Frontmatter Canonical Schema 가
`related_specs` 를 **이 에이전트가 쓰는, 스키마 SSOT 표에 없는 선택 필드 4종 중 하나**로 명시하고
(`related_specs: [SPEC-Z-001]` — 비차단 참조), `superseded_by` · `partially_superseded_by` ·
`merged_pr` 와 함께 열거한다. 의미도 다르다 — `depends_on` 은 **차단**(Phase 1 Depends_on
Pre-flight 가 미완료 의존을 블로커로 올린다), `related_specs` 는 **비차단 참조**다.

이 SPEC 이 참조하는 3건은 §3 이 「병합하지 말 것」으로 경계를 그은 **형제 SPEC** 이지 선행 조건이 아니다.
`depends_on` 으로 바꾸면 `SPEC-PRCSTRUCT-001`(draft) · `SPEC-PRICEWIRE-001`(draft) 의 미완료가
**run 진입을 막는다** — 의미가 반대로 뒤집힌다. 원 필드 유지.

#### 부분 반영 1건 — D12 (REQ-PG-005 3분류)

「좁히는 것을 고려하라」는 권고를 따라 **골든 검증용으로 한정**했다(REQ-PG-005 `Where` 절 추가 +
149종 전개에서 정합 판정으로 승격 금지). 요구사항 자체는 삭제하지 않았다 —
골든 재현(REQ-PG-013)의 판정 수단이라 제거하면 AC-PG-001·002 가 판정 근거를 잃는다.

#### 반영한 D11 (선택 지적)

「적용일」 칸의 값 원천을 REQ-PG-001 에 명시 — 생성기는 **공란**으로 두고
그리드의 「선택영역 새 적용일로 개정」으로 실무진이 지정한다(P-7 추적성).

#### 손대지 않은 4축 (감사가 건전하다고 판정 — 재작성 금지 지시 준수)

생성 SPEC 정체성(§3) · [HARD] 제약 4종(라이브 쓰기 0 · 날조 0 · 절대경로 · 원천 우선순위) ·
범위 제외 사유(§6) · 프로토타입 수치 격리(`plan.md` §A L-3 · §G) — **전건 무수정**.

### 판본 0.3.0 — 재감사(CONDITIONAL 0.81 / Tier M 0.80) 지적 처리 (2026-08-29)

선행 지적 10건은 전부 해소됐고 보호 4축은 생존했다는 판정. 잔여 지적 **4건**(차단 2 · 권고 2)을
문단 단위로 반영했다. **요구사항은 16항 그대로** — Tier M 상한이 16 이므로 F-1 은
요구사항이 아니라 **인수 기준**으로 신설했다(17번째 REQ 는 티어 위반).
아래 4건 모두 **인용 원본을 직접 읽어 확인한 뒤** 반영했다.

#### 원본 대조 — 실행한 명령과 관측

| # | 확인한 것 | 실행한 명령 / 읽은 좌표 | 관측 |
|---|---|---|---|
| F-1 | 갈래 ③ 분모의 정본 | `sed -n '126,130p' price_views.py` | `DIM_FK_FILTER = {"plt_siz_cd": {"impos_yn": "Y"}}` — 지적대로 |
| F-1 | 필터 적용 **순서** | `sed -n '1348,1356p' price_views.py` (`_fk_options`) | `exclude(del_yn="Y")` **먼저**, 그 다음 `filter(**extra)`. 지적의 순서 주장이 성립 |
| F-1 | `plt_siz_cd` 의 FK 모델 | `sed -n '38,51p' price_views.py` `DIM_META` | `("판형사이즈","fk","TSizSizes","siz_nm")` |
| F-1 | 그 모델의 실 테이블·컬럼 | `grep -n "class TSizSizes" -A 25 models.py` | `db_table = 't_siz_sizes'` · pk `siz_cd` · `impos_yn`(조판판형여부) · `del_yn` 존재 ⇒ AC 의 `SELECT` 가 코드와 대응 |
| F-1 | 갈래 ③ 실사용 + 곱해질 분모 | `sed -n '12,15p' axis-260829.csv` | `PRD_000108·109·111·112` / `COMP_PAPER` / `mat_cd,plt_siz_cd,min_qty`. `PRD_000111` 은 `mat_cd` 만으로 상품 보유 **21개** |
| F-1 | 갈래 ③ 이 즉시 구현 대상 | `plan.md` M1b | 「`impos_yn='Y'` FK 필터로 **즉시 가능**」 ⇒ 갈래 ④ 와 달리 REQ-PG-016 블로커 경로를 타지 않는다 |
| F-2 | `dims` 가 빌 수 있는가 | `sed -n '1339,1345p' price_views.py` (`_comp_dims`) | `out.append("min_qty")` 가 **무조건**. `dims` 는 절대 빈 배열이 아니다 ⇒ **컬럼 0개 격자는 존재하지 않는다** |
| F-2 | 최소 격자의 컬럼 수 | `sed -n '205,232p' comp_price_grid_page.html` | `[적용일] + g.dims + 단가헤더 + [비고]` ⇒ `dims==["min_qty"]` 이면 **4컬럼** |
| F-2 | 「항상 매칭」의 층위 | `sed -n '770,790p' pricing.py` | `if not non_qty_dims: entry["note"]="판별차원 없음 — …항상 매칭"` — **매칭 의미론**이지 격자 형태가 아니다. E-1 의 「1행」은 오독 |
| F-3 | 3↔4 표기 불일치 | `grep -n "3갈래\|세 갈래\|네 갈래\|4갈래" spec.md acceptance.md` | `spec.md:30`·`:68`·`:96` 이 3, `:98`·`:211`·`:293`·`acceptance.md:156` 이 4 |
| F-4 | `F` 의 층위 · `A` 의 의존 | `acceptance.md` AC-PG-012 본문 | `F` 를 구성요소로 정의하고 조합처럼 사용 · `A` 의 M3 의존과 번역 실패 처리가 미기재 — 지적 성립 |

#### 반영

| # | 대상 | 변경 |
|---|---|---|
| F-1 | `acceptance.md` **신규 AC-PG-014** | 갈래 ③ 분모 = `t_siz_sizes` 중 `impos_yn='Y' AND COALESCE(del_yn,'N')<>'Y'` 와 **차집합 양방향 0건**. AC-PG-003 과 같은 모양(판정 `SELECT` 를 본문에 내장). D.2 에 「과생성 게이트」 1행 추가. **요구사항 신설 아님** |
| F-2 | `acceptance.md` D.1 **E-1·E-2 교체** + 근거 블록 | 「컬럼 0개」·「1행 격자」를 폐기하고 `dims` 최소 `["min_qty"]` · 4컬럼 `[적용일, 수량(이상), <단가헤더>, 비고]` 로 정정. 행수는 갈래 ② 권위 수량 축에서 충전 |
| F-2 | `spec.md` §2.1 각주 | `min_qty` 「항상 마지막으로 **이동**」 → 「**없으면 추가하고, 있으면 말미로 이동**」 + `price_views.py:1339-1345` 좌표 |
| F-3 | `spec.md:30`·`:68`·`:96` | 3 → 4 로 통일 |
| F-4 | `acceptance.md` AC-PG-012 | `F` 를 「배선된 구성요소들이 **만들어 내는 조합** 집합」으로 재정의 · `A` 는 **M3 번역 성립 셀로 한정**하고 미성립 셀은 AC-PG-010 목록에 **별도 계수**(판정 시 두 수를 함께 기재) |

#### 손대지 않은 것

- **보호 4축 무수정** — 생성 SPEC 정체성(§3) · [HARD] 제약(REQ-PG-006/008/014 · §5.2) ·
  범위 제외 사유(§6) · 프로토타입 수치 격리(`plan.md` §A L-3 · §G).
- **재감사가 건전하다고 확인한 결정 무수정** — 4갈래 분기 · §2.2.1 분모 축소 ·
  `dims` 기반 컬럼 계약 · `label`/`prc_typ` 가변 헤더 · 확정 전제 B-1~B-4 ·
  AC-PG-005 2단계 분리 · AC-PG-001 기준선 `SELECT` 내장.
- **`spec.md:211` 「세 갈래」는 정정하지 않았다** — REQ-PG-003 이 덮는 것이
  갈래 ②·③·④ 로 실제 **세 갈래**이므로 그 자리에서는 「3」이 맞다. F-3 의 대상이 아니다.

#### 지적을 넘어 함께 정정한 1건 (F-3 범위 내)

`spec.md:96` 「**세** 갈래가 한 구성요소에서 동시에 터진다」 — 재감사는 `:68`·`:30` 만 지목했으나,
바로 다음 줄(`:98`)이 갈래 ①②③④ **네 개**를 열거하므로 같은 불일치다. 「네 갈래」로 통일했다.

#### 라이브 접근

이 판본에서 **라이브 DB 접근 0건** — 전부 소스 파일 직독(`price_views.py` · `pricing.py` ·
`models.py` · `comp_price_grid_page.html` · `axis-260829.csv`)으로 확인했다. 쓰기 0건.

### 판본 0.4.0 — 산출물 경계 재설정 + 티어 판단 (2026-08-29)

사용자 지시: 「실제 값까지 넣는 상태를 원한 건데, 산출물 경계 다시 잡자 — 값은 반드시 WebUI를 이용하자」.
종착점이 **「표 하나」에서 「값이 실제로 얹힌 상태」**로 옮겨갔고, 붙여넣기 표는 **중간 산출물**이 됐다.

#### 원본 대조 — 실행한 명령과 관측

**전 항목을 인용 원본에 직접 대조한 뒤** 반영했다. 이 판본에서 **라이브 DB 접근 0건** — 전부 소스 직독.

| # | 확인한 것 | 실행한 명령 / 읽은 좌표 | 관측 |
|---|---|---|---|
| G1 | UI 투입 근거([HARD] 추적성)의 정본 문구 | `sed -n '329,345p' huni-product-lifecycle.md` | §7.2 PM 확정 2026-08-29 — 「등록되는 시점이 기록이 되어서 언제 가격이 변경되었는지 트레이싱」 · 「직접 DB로 넣지 말고 UI를 토대로 넣으라」. REQ-PG-008 에 **문구 그대로** 승계 |
| G2 | 건별 승인 기록 6항 | `sed -n '346,391p' huni-product-lifecycle.md` | §7.3 [HARD] — 「대상 · 화면 경로 · 변경 전후 값 · 파급 범위 · 권위 근거(시트+셀 좌표) · 승인 사실을 1:1로」 + 변경 전후 스크린샷이 증거. → 002 REQ-PW-003 |
| G3 | 저장이 **전체동기화**이고 미제출 키를 삭제한다 | `awk 'NR>=1435&&NR<=1475' price_views.py` · `NR>=1500&&NR<=1572` | `:1438` full-sync docstring · `:1443` 「DB에만 있고 그리드에 없는 키는 삭제」 · `:1549-1553` 실제 `.delete()`. → 002 REQ-PW-004 |
| G4 | 서버 안전장치가 **전멸만** 막는다 | 같은 명령 `:1540-1544` | `if not clean and ex_by_key` — 유효 행 **0개**일 때만 422. **부분 페이로드는 통과한다** ⇒ 「합쳐 보내기」가 정책이 아니라 필수 |
| G5 | 롤백 수단의 실체 | `awk 'NR>=125&&NR<=145' comp_price_grid_page.html` · `NR>=385&&NR<=405` | 그리드 자체에 `:139` 「선택 행 삭제」가 있고 `:395` 「[변경분 저장]을 눌러야 DB에 반영」 — 전체동기화가 실제 `DELETE` 를 낸다 |
| G6 | 값 이력이 새 적용일 행에만 남는다 | `sed -n '61,90p' huni-product-lifecycle.md` | §3.1 — 24,468행 전건 `reg_dt` · **같은 차원키에 적용일 2개 이상 = 1건**. → 002 REQ-PW-005 |
| G7 | 감사 컬럼의 기제 | `grep "CREATE TABLE.*t_prc_component_prices" -A 40 sql/*.sql` · `grep "trg_" sql/03_triggers.sql` | `01b_tables_relations.sql:240` `reg_dt ... NOT NULL DEFAULT now()` · `03_triggers.sql:213-216` `BEFORE UPDATE` 트리거 |
| **D1** | `COALESCE` 근거가 **사실이 아니다** | `grep -n "del_yn char(1) NOT NULL DEFAULT" sql/13_phase7_del_yn.sql` · `models.py:649` | `:35` — `t_siz_sizes ... del_yn char(1) **NOT NULL** DEFAULT 'N'` · 모델은 `models.CharField(max_length=1, ...)` 로 **`null=True` 아님** ⇒ Django 는 NULL 보존 절 없이 `NOT (del_yn='Y')` 만 낸다. **지적 성립** |
| **D2** | `_fk_options` 실제 좌표 | `awk 'NR>=1345&&NR<=1362' price_views.py` | 함수는 **`1348-1358`**. `acceptance.md:190` 의 `1348-1356` 은 오기이고 `spec.md:77` 의 `1348-1358` 이 맞다. **지적 성립** |

#### 반영

| # | 대상 | 변경 |
|---|---|---|
| — | `spec.md` §1 · §5.1 | 종착점을 「표 하나」에서 **파이프라인 5단계(①격자 산출 ②값 충전 ③붙여넣기 표 ④UI 투입 ⑤투입 검증)**로 재작성. 표는 **인계물**로 격하 |
| — | `spec.md` REQ-PG-008 | **주어 반전** — 「라이브 쓰기 금지」 → **금지 절**(DB 직접 쓰기 `shall not`) + **허용 절**(UI 실화면 경로). [HARD] 추적성 근거는 G1 문구 그대로 유지. 「금지의 방향을 뒤집어 읽지 말 것」 각주 추가 |
| — | `spec.md` §3.1 신설 | `SPEC-PRICEGRID-002` 와의 경계 — 병렬 형제 3종과 달리 **후속** SPEC 임을 표로 명시 |
| — | `spec.md` §6 | 범위 제외 5구획 **유지**. 「webadmin 실화면 투입」을 **「실무진의 몫」에서 「002 의 소유」**로 재분류 — 금지가 아니라 소유 이전임을 명시 |
| — | `plan.md` §B-5 신설 | 티어 판단과 대안 비교(아래) |
| — | `plan.md` M5b 신설 | 인계 게이트. `save/` API 호출 grep 을 여기서 함께 돌린다 |
| — | `plan.md` M6 | 게이트 두 개(골든 · 인계) 뒤임을 명시 |
| — | `plan.md` R-9 · R-10 신설 | 경계 확장의 오독 · `save/` 자동 호출 우회 |
| — | `acceptance.md` **AC-PG-015 신설**(14→15) | 인계 가능성 4항. 4항이 `save/` 자동 호출 grep 을 담아 AC-PG-005 의 구멍을 막는다 |
| **D1** | `acceptance.md` AC-PG-014 각주 | 틀린 기제(「NULL 인 행을 남기므로」)를 폐기하고 실측 근거로 교체. **`COALESCE` 는 유지** — 두 식이 동치이고 스키마 가정을 판정문에 담지 않으므로. 「단순화 대상이 아니다」 의도 보존 |
| **D2** | `acceptance.md` AC-PG-014 | `1348-1356` → **`1348-1358`** |

#### 티어 판단 — Tier L 승격이 아니라 **형제 SPEC 분리**를 택했다

이 SPEC 은 `tier: M` 이고 요구사항이 **정확히 16항 = Tier M 상한**이다. 확장분의 최소 요구사항은
5항이므로 21항이 되어 상한을 넘는다. 두 선택지를 비교했다(전문은 `plan.md` §B-5).

**채택: 형제 SPEC 분리(`SPEC-PRICEGRID-002`)** — 세 가지 이유.

1. **[HARD] 불변식이 깨진다.** 한 문서에서 REQ-PG-008 이 「쓰지 마라」와 「이렇게 써라」를 동시에
   지시하면 **「라이브 쓰기 0건」이 SPEC 전체 불변식에서 마일스톤별 조건으로 약해진다.**
   그 불변식은 선행 감사 3회가 보호해 온 [HARD] 4축 중 하나다.
2. **게이트가 기계적으로 강제된다.** 002 의 `depends_on: [SPEC-PRICEGRID-001]` 이
   Depends_on Pre-flight 에 걸려, 001 이 `completed` 가 아니면 **002 의 run 진입 자체가 블로커**다.
   Tier L 승격이었다면 「골든 게이트 뒤에 투입」은 마일스톤 서술로만 존재해 사람이 어기면 막을 것이 없다.
3. **`design.md`·`research.md` 에 넣을 내용이 없다.** 그 자리의 것은 이미
   `AUDIT-3-4-260829.md`·`HANDOFF-260829.md`·프로토타입에 있다. 없는 문서를 형식 때문에 만드는 것은
   티어 분류가 막으려는 과형식화 그 자체다.

부수 효과로 이 SPEC 의 감사 점수(0.95)가 Tier L 기준선(0.85) 재감사에 노출되지 않는다.
**다만 이것은 채택 사유가 아니라 결과다** — 점수 보존을 위해 경계를 나눈 것이 아니다.

**기각한 반론**: 「사용자는 하나의 산출물 경계를 말했으니 SPEC 도 하나여야 한다」 —
사용자가 옮긴 것은 **일의 종착점**이지 SPEC 의 개수가 아니다. §1·§5.1 이 5단계를 **전부** 명시하고
자기 경계를 밝히므로 종착점은 여전히 ⑤ 이며, 그 상태에 두 SPEC 으로 도달한다.

#### 손대지 않은 것 (보호 지시 준수)

- **보호 3축 무수정** — 생성 SPEC 정체성(§3 원 표) · 범위 제외 5구획의 **사유** ·
  프로토타입 수치 격리(`plan.md` §A L-3 · §G). 4번째 축인 [HARD] 제약 중
  **REQ-PG-006(날조 금지) · REQ-PG-014(절대경로) · §5.2(원천 우선순위)는 무수정**이고,
  REQ-PG-008 만 지시대로 **형태가 바뀌었다**(사라지지 않았다 — 금지 절이 그대로 살아 있다).
- **선행 3회 감사가 확정한 것 무수정** — 4갈래 분모 · §2.2.1 분모 축소 · `dims` 기반 컬럼 계약 ·
  `label`/`prc_typ` 가변 헤더 · 확정 전제 B-1~B-4 · AC-PG-005 2단계 분리 ·
  AC-PG-001 기준선 `SELECT` 내장 · AC-PG-003·AC-PG-014 양방향 차집합 · AC-PG-012 교집합 형태.
- **AC-PG-014 의 `COALESCE`** — D1 은 **근거만** 틀렸고 식은 옳다. 식을 바꾸지 않았다.

#### 정직한 기재 (Gap)

- **미검증**: 원시 SQL `INSERT` 에 `reg_dt` 를 명시 지정하거나 원시 `UPDATE` 를 실행했을 때
  감사 컬럼이 실제로 어떻게 남는지는 **실행하지 않았다**(라이브 쓰기 금지).
  트리거가 `BEFORE UPDATE` 이므로 원시 `UPDATE` 에서도 `upd_dt` 는 갱신될 것으로 **추정**되나 실측이 없다.
  §7.2 의 「비거나 조작됨」은 **PM 확정 [HARD]** 이며 이 추정으로 약화시키지 않는다.
- **브라우저 조작 vs `save/` 직접 호출**: 두 경로가 같은 Django 뷰에 도달하고 감사 컬럼도 동일하게
  남는 것을 **소스로 확인했다**. 따라서 결정의 근거는 감사 컬럼이 아니라
  **스크린샷 증거 + 화면 안전장치**이며, 그 논리를 002 spec.md §5.1 결정표에 그대로 적었다.
- **라이브 재실측 없음**: 골든 277행 등 0.3.0 의 수치는 2026-08-29 값 그대로 인용했고
  이 판본에서 재측정하지 않았다. 투입 시점 재실측은 002 pre-flight 6 이 요구한다.

### 판본 0.5.0 — 독립 계획감사(CONDITIONAL 0.94) 지적 처리 (2026-08-29)

지적 7건(차단 2 · 권고 5). **7건 전부 원천 대조로 확인했고 기각 0건이다.** 라이브 DB 접근 0건 —
확인은 전부 소스 직독과 `/tmp` 합성 파일에 대한 grep 실행이다.

#### 확인 — 실행한 명령과 관측 (2026-08-29)

| 지적 | 실행한 명령 | 관측 | 판정 |
|---|---|---|---|
| **D1** 「투입 게이트」 부재 | `acceptance.md` §D.2 직독 · `plan.md` M6 직독 | §D.2 의 게이트는 골든·안전·차원·과생성·날조·언더차지·**인계** 7종 — 「투입 게이트」 **0건**. `plan.md` M6 은 같은 문장을 「① 골든 게이트(M4) ② 인계 게이트(M5b)」로 옳게 적고 있었다. 그리고 spec.md 안에서 「투입」은 §5.1 ④ · §6 에서 일관되게 **002 의 영역**을 가리킨다 | **확인 · 반영**(§3.1 문장 교체 + 순환 위험 각주) |
| **D2** grep 위양성 | `/tmp/pgverify/gen.py` 에 `requests.post(".../price-viewer/comp/C/save/")` 를 두고 두 형태 실행 | 0.4.0 표 셀 형태 `grep -nE 'price-viewer.*save\|requests\.post\|urlopen'` → **출력 없음, exit 1**. `plan.md:217` 형태(이스케이프 없음) → `2:requests.post(...)`, exit 0. `grep -E` 에서 `\|` 는 리터럴 파이프이므로 0.4.0 형태는 「`price-viewer...save|requests.post|urlopen` 이라는 한 덩어리 문자열」을 찾고 있었다 | **확인 · 반영**(코드블록 이동 + 패턴 확장 + 미탐지 Gap 선언) |
| **D3** REQ-PG-008 허용 절 서법 | `spec.md` REQ-PG-008 직독 | 금지 절 2문장은 `shall not` 명시, 허용 절만 「이뤄진다」 평서문. 「만」이 배타성을 지므로 실질 모호성은 없으나 **반쪽 서법**이 맞다 | **확인 · 반영**(`shall` 명시) |
| **D4** 「기록을 통째로 건너뛴다」 과장 | `sed -n '235,245p' sql/01b_tables_relations.sql` · `sed -n '205,220p' sql/03_triggers.sql` | `01b:240` — `reg_dt timestamp NOT NULL DEFAULT now()`. `03_triggers:213-217` — `trg_t_prc_component_prices_upd_dt BEFORE UPDATE ... EXECUTE FUNCTION fn_upd_dt()`. ⇒ 원시 `UPDATE` 도 `upd_dt` 를, `reg_dt` 미지정 원시 `INSERT` 도 `reg_dt` 를 남긴다. **시각은 살아남는다** | **확인 · 반영**(파기 범위를 행위자·사유·이전 값·화면 증거로 축소) |
| **D5** 「0.95 보존」 과잉주장 | `spec.md` §0 HISTORY 0.4.0 행 직독 | 0.4.0 이 §1 · §5.1 · REQ-PG-008 을 고쳐 쓰고 AC 를 14→15 로 늘렸다. 점수는 그 문서에 붙은 것이 아니다 — 이번 0.94 CONDITIONAL 이 반례 | **확인 · 반영**(「재감사 범위가 델타로 한정」) |
| **D6** §B 절 번호 역순 | `grep -n '^### B-' plan.md` | 순서가 B-1 · B-2 · B-3 · **B-5** · B-4 | **확인 · 반영**(B-4 를 B-5 앞으로) |
| **D7** AC-PG-015 2항 판정 승계 | `acceptance.md` AC-PG-015 표 직독 | 2항의 판정 칸이 「AC-PG-004 PASS 승계」 — 독립 증거 없음. 4항 중 1항이 자립하지 않으므로 인계 증명 강도는 실질 3/4 | **확인 · 명시**(식은 유지, 승계 사실을 AC 안에 기재) |

#### D4 의 소유 경계 — §7.2 는 손대지 않았다

D4 는 **이 SPEC 이 §7.2 를 옮겨 적은 문장**만 고쳤다. `huni-product-lifecycle.md` §7.2 자체(표의
「비거나 조작됨」 칸 포함)는 **PM 확정 [HARD]** 이고 이 SPEC 의 소유가 아니다 — 0.4.0 판본에서
세운 처리(§7.2 는 그대로 승계하고 관측은 Gap 으로 남긴다)를 그대로 유지한다.
§7.2 표 칸에 대한 위 실측은 **규칙 소유자에게 라우팅할 관측**이며 여기서 편집하지 않는다.

#### 정직한 기재 (Gap) — 0.5.0

- **AC-PG-015 4항은 브라우저 자동화를 판정하지 못한다.** 새 패턴은 HTTP 클라이언트(`requests` ·
  `httpx` · `aiohttp` · `session.post` · `urlopen`)와 셸 우회(`subprocess` · `curl`)까지 덮지만,
  **gstack 류로 「변경분 저장」을 클릭하는 경로는 어떤 텍스트 패턴에도 걸리지 않는다.**
  002 가 바로 그 방식을 쓰므로 이 우회는 가상의 것이 아니다. AC 본문에 **판정 불가로 선언**했고
  `plan.md` §F 에 R-11 로 등재했다. 기계적 게이트는 없고 문서 규약만 있다.
- **새 패턴의 검증은 합성 파일에 대한 것이다.** `/tmp/pgverify/tool.py` 에 위반 형태 6종
  (`.objects.create` · `.filter().update` · `.filter().delete` · `session.post` · `subprocess`+`curl` ·
  소문자 `insert into`)과 정상 읽기 1종(`.objects.filter().values()`)을 두고 확인했다 —
  **실제 생성기 소스에 대해서는 아직 돌리지 않았다**(생성기가 아직 없다. M5b 산출물이다).
- **라이브 재실측 없음**: 0.5.0 도 라이브를 읽지 않았다. 골든 277행은 여전히 2026-08-29 값이다.

### 판본 0.6.0 — 설계 결함 정정 (2026-08-29)

run-phase 가 M0 실측 중 §2.2 의 설계 결함을 발견하고 **구현 전에 멈췄다.**
멈춘 판단이 옳았다 — 현행 규칙 위에 구현했다면 골든 게이트를 통과시키기 위해
나중에 규칙을 구부려야 했다. 이 판본은 **라이브 쓰기 0건**(전부 읽기전용 `SELECT`)이다.

#### 실행 환경

`raw/webadmin/.venv/bin/python` · `sys.path.insert(0, ".../raw/webadmin/webadmin")` ·
`DJANGO_SETTINGS_MODULE=config.settings` · `load_dotenv(".../raw/webadmin/.env")` ·
`django.db.connection.cursor()` 로 `SELECT` 만 실행.
**측정 시각: 2026-08-29 20:43 KST**(`SELECT now()` → `2026-08-29 20:43:04.288489`).
권위 워크북은 **절대경로**로 열었다(`/Users/innojini/Dev/HuniWeb/docs/huni/…_260822_1.xlsx`) —
`ls -la` 로 최신본 확인(REQ-PG-014).

#### 결함 확인 — 실행한 명령과 관측

| # | 확인한 것 | 명령 | 관측 |
|---|---|---|---|
| H1 | 단가표에 `prd_cd` 컬럼 | `SELECT string_agg(column_name,…) FROM information_schema.columns WHERE table_name='t_prc_component_prices'` | 20컬럼 — `comp_cd`·`mat_cd`·`siz_width`… **`prd_cd` 없음**. `huni-product-lifecycle.md` §5.3 의 기록과 일치 |
| H2 | 골든 `mat_cd` 분포 | `SELECT mat_cd,count(*) … WHERE comp_cd='COMP_ACRYL_CLEAR3T' GROUP BY mat_cd` | `MAT_000386` **196** · `MAT_000387` **81** (합 277) |
| H3 | 자재 이름 | `SELECT mat_cd,mat_nm FROM t_mat_materials WHERE mat_cd IN (…)` | 386=아크릴(투명)3mm · 387=아크릴(투명)1.5mm · 417=은색고리 · 418=금색고리 · 456=군번줄 |
| H4 | `PRD_000146` 자재 축 | `SELECT … FROM t_prd_product_materials WHERE prd_cd='PRD_000146' AND COALESCE(del_yn,'N')<>'Y'` | **4종** — 386 · 417 · 418 · 456. **387 없음** |
| H5 | 공유 상품 수 | `SELECT DISTINCT ppf.prd_cd … JOIN t_prd_product_price_formulas ppf ON ppf.frm_cd=fc.frm_cd WHERE fc.comp_cd='COMP_ACRYL_CLEAR3T'` | **13종**(`PRD_000146`~`PRD_000162`), 전건 `use_yn='Y'`·`del_yn='N'` |
| H6 | 13종 자재 축 **합집합** | 위 목록으로 `t_prd_product_materials` 집계 | **15종** — 386 외 14종이 전부 부속(고리·자석·핀·집게·톡바디·머리끈·군번줄). **387 여전히 없음** ⇒ 상품 축을 넓혀도 누락은 안 풀리고 과생성만 나빠진다 |
| H7 | 387 보유 상품의 공식 | `SELECT … FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000163','PRD_000313')` | `PRD_000163` → `PRF_ACRYL_MINIPART` / `COMP_ACRYL_MINIPART_TBD`(**다른 구성요소**) · `PRD_000313` → **바인딩 0건** ⇒ 387 은 어떤 상품 축 경로로도 도달 불가 |

⇒ **어떤 상품 축 규칙도 누락 0 · 잉여 0 에 동시 도달할 수 없다.** AC-PG-001·002 는
0.5.0 시점에 **도달 불가능한 기준**이었다.

#### 참값의 정체 — 권위 표와 셀 단위 일치

| # | 확인 | 명령 | 관측 |
|---|---|---|---|
| H8 | 골든 내부 구조 | `SELECT mat_cd,count(DISTINCT siz_width),count(DISTINCT siz_height),count(*) … GROUP BY mat_cd` | 386 → 14×14=**196**(20~200mm) · 387 → 9×9=**81**(20~100mm). 각각 **완전 조밀**(가로별 행수 전부 14 / 9) |
| H9 | 권위 하위표 | `cells-260829.csv` 시트 「아크릴」 `(title,col_axis)` 집계 | 투명3T **196** · 투명1.5T **81** · 미러3T **81** · 코롯토 **36** |
| H10 | 구성요소 대조 | `SELECT comp_cd,use_dims,count(*) … WHERE comp_cd LIKE '%ACRYL%'` | `COMP_ACRYL_CLEAR3T` **277**(=196+81) · `COMP_ACRYL_MIRROR3T` **81** · `COMP_ACRYL_COROTTO` **36** — **3/3 정확히 일치** |

⇒ 분모의 생성자는 **구성요소의 권위 하위표**다. 전체 교차곱(2×14×14=**392**)이 아니라
**하위표 합집합**(196+81=**277**)이다.

#### 두 번째 검증 대상 — 축 번역이 1:N 이다

| # | 확인 | 관측 |
|---|---|---|
| H11 | `COMP_COAT_GLOSSY` 형태 | **138행** = `proc_cd` 1 × `plt_siz_cd` 3 × `coat_side_cnt` 2 × `min_qty` 23 |
| H12 | FK 필터 크기 | `SELECT count(*) FROM t_siz_sizes WHERE impos_yn='Y' AND COALESCE(del_yn,'N')<>'Y'` → **21** (참값 3) |
| H13 | `proc_grp` 그룹 크기 | `SELECT … WHERE upr_proc_cd='PROC_000013'` → **2**(PROC_000014 유광 · PROC_000015 무광), 라이브 **1**(유광) |
| H14 | 권위 「코팅」 시트 원문 | `openpyxl` 직독 A1:E56 | `코팅(국4절)`(3~26행) · `코팅(3절)`(31~56행) **2블록**, 각 블록에 무광·유광 단면/양면 4열 × 23 수량 |
| H15 | 축 번역 확인 | 라이브 단가 대조 | `SIZ_000499` = 국4절 값(2000/1500/1200) · `SIZ_000077`·`SIZ_000475` = **둘 다** 3절 값(3000/2500/2000) ⇒ 권위 축 「3절」 **1 → 코드 2** — **[0.8.0 철회]** 이 추론은 라이브 단가만 보고 한 것이다. 권위 판형 칸(판걸이수 시트)에 `300x625` 는 0히트이며 권위 「3절」은 `SIZ_000475`·`SIZ_000535` 다. `SIZ_000077` 의 46행은 라이브에만 있는 **보고 대상 관측**이다(spec.md §2.2.3 ④ 0.8.0) |

⇒ 3 × 23 × 2 = **138 = 라이브.** 권위 셀 수(유광 92)와 라이브 행 수(138)의 차이는
결함이 아니라 **1:N 번역**의 결과다. **`table_parse.py` 는 이 시트에서 유광 열의 title 을
「무광코팅」으로 잘못 배정한다**(`cells-260829.csv` 에 `무광코팅` 2건, `유광코팅` 0건) —
파서 결함이며 M3 의 조사 대상으로 라우팅한다. 이 판본에서 고치지 않았다.

#### 일반성 — 과적합 방지 확인

| # | 확인 | 관측 |
|---|---|---|
| H16 | 최대 구성요소 구조 | `COMP_STK_PRINT` **5,424행**. 전체 교차곱 26×11×36 = **10,296**(과생성 90%) |
| H17 | 하위표별 축 범위 | 자재별 `siz_cd` 범위 3~24 로 상이. (자재,사이즈) **179쌍** 중 34쌍은 `min_qty` **6단계**, 145쌍은 **36단계** ⇒ 수량 축조차 하위표마다 다르다 |
| H18 | 상품 축 이탈 전수 | (구성요소,`mat_cd`) **167쌍 중 38쌍(23%) · 4개 구성요소**가 바인딩 상품 자재 축 합집합 밖 |
| H19 | FK 포함 제약 | 라이브 `plt_siz_cd` 가 `impos_yn='Y'` 밖 — **16개 구성요소 전건 0건** |
| H20 | `proc_grp` 포함 제약 | (구성요소,`proc_cd`) **69쌍 전건 그룹 안**. 그러나 거의 항상 진부분집합(`COMP_BIND_JUNGCHEOL` 1/12 · `COMP_FOIL_PROC_SMALL_SPECIAL` 2/11) |
| H21 | `opt_grp` 포함 제약 | 22개 중 14개 일치 · 4개 진부분집합 · **4개는 그룹 밖**(`COMP_NAMECARD_FOIL` 2/1 · `COMP_PCB` 2/0 · `COMP_PHOTOCARD_BULK`·`_SET` 1/0) |

⇒ H19·H20 이 **포함 제약의 성립**을 보이고, 동시에 진부분집합이라는 사실이
**생성자로는 성립하지 않음**을 보인다. H21 의 4건은 제약 자체의 예외다.

#### 반영

| 대상 | 변경 |
|---|---|
| `spec.md` §2.2 | **전면 재작성** — 4갈래 표를 폐기하고 §2.2.1(두 질문 분리) · §2.2.2(생성자 1 + 제약 2) · §2.2.3(실측) 신설 |
| `spec.md` §2.2.1(구) | §2.2.4 로 이동 + 「분모 축소」→「포함 제약」 재작성 |
| `spec.md` REQ-PG-002 | 「정확매칭 = 상품 축」 → **「생성자 = 권위 하위표 합집합」(12종 전건)** |
| `spec.md` REQ-PG-003 | 「상품 축 아닌 차원의 분모」 → **「상품 축·FK·스코프는 제약이지 생성자가 아니다」** |
| `spec.md` REQ-PG-004 | 「분모 = 그룹 구성원과 정확히 같게」 → **「부분집합인지 점검」** |
| `spec.md` REQ-PG-016 | ㉠(못 채움) 단일 → **㉠ + ㉡(채웠으나 권위 귀속 없음)** 양 갈래 |
| `spec.md` §7 | 기준 1 판정 단위를 상품→구성요소 · 1b·6b·6c 신설 |
| `acceptance.md` AC-PG-001·002 | 비교 대상을 구성요소로 · 기준선 ③(하위표 구조) 추가 · 잉여 81건 회귀선 명시 |
| `acceptance.md` AC-PG-003 | 양방향 차집합 0 → **부분집합** + 권위 귀속 |
| `acceptance.md` AC-PG-007 | 근거 REQ-PG-003 → REQ-PG-002 · 적용 범위 주석 |
| `acceptance.md` AC-PG-008 | **판정 방향 반전** — 「부분집합이어야 한다」(옳은 격자를 기각) → 「이탈을 보고하고 제거하지 않는다」 |
| `acceptance.md` AC-PG-014 | **21 → 3** · 「생성은 권위 · 상한은 FK」 두 항 판정 · 대상을 `COMP_PAPER`→`COMP_COAT_GLOSSY` |
| `acceptance.md` **AC-PG-016 신설** | 권위 귀속 · 합집합 형태 · 제약 보고 · 제약 비개입 4항 (15→**16** = Tier M 상한) |
| `acceptance.md` D.2 · D.3 | 귀속 게이트 신설 · 차원/과생성 게이트 문구 · DoD 2항 |
| `plan.md` §A | L-3 **격리 해제** + 784 = 4×14×14 분해 · 「덮지 못한 범위」 재정의 |
| `plan.md` M0·M1·M1b·M2·M3 | M0 완료 · M1 범위 확대(12종) · M1b 성격 반전(제약 계층 + ㉡) · M2 검증 대상 추가 · **M3 임계 경로** + 산출 3종 |
| `plan.md` §F · §G | R-12·R-13·R-14 신설 · R-3·R-7 갱신 · 안티패턴 6종 추가 |

#### 손대지 않은 4축 (보호 지시 준수)

- **생성 SPEC 정체성(§3) · §3.1 경계표** — 무수정. 이 정정은 001 을 여전히 생성 SPEC 으로 둔다
  (제약 위반을 **보고**만 하고 고치지 않는 것이 그 경계를 지키는 장치다 — R-14)
- **범위 제외 5구획(§6)과 그 사유** — 무수정
- **REQ-PG-006(날조 0) · REQ-PG-014(절대경로) · §5.2(원천 우선순위)** — 무수정
- **REQ-PG-008** — 무수정. 0.5.0 에서 확정된 `shall` 절과 좁혀진 근거(행위자·사유·이전 값·화면 증거)
  그대로. 이 정정은 분모 규칙에만 닿는다
- **`SPEC-PRICEGRID-002`** — 손대지 않았다. 정정이 002 에 닿는지 검토한 결과 **닿지 않는다**:
  002 는 인계물 3종(TSV · 블로커 목록 · 실측시각+권위파일명)만 소비하고 001 의 분모 규칙에
  의존하지 않는다(`plan.md` §E 인계 경계). 표의 **내용**이 바뀌지만 **형식**은 그대로다

#### 정직한 기재 (Gap) — 0.6.0

- **매핑의 기계적 도출은 미해결.** 구성요소 → 권위 하위표 매핑이 **구성요소 코드만으로는
  도출되지 않는다.** 확인한 3건은 이름 유사성(`COMP_ACRYL_CLEAR3T` ↔ 「투명아크릴3T」)으로
  사람이 짝지은 것이고, 그 방식은 REQ-PG-011 이 승격을 금지하는 근사 매칭이다.
  **M3 가 풀어야 할 문제로 남긴다** — 실측 3건은 회귀 기준선이지 규칙이 아니다.
- **일반성 검증은 4개 구성요소 + 전수 집계 3건에 근거한다.** 셀 단위 권위 대조를 실제로
  돌린 것은 아크릴 3건 + 코팅 1건이다. 나머지는 구조 통계(H16~H21)로 확인했고,
  **149종 전건에 대한 권위 대조는 하지 않았다**(M3·M6 의 일이다).
- **`table_parse.py` 의 유광/무광 title 오배정을 고치지 않았다.** `cells-260829.csv` 는
  그 결함을 담은 채로 있다. M3 의 조사 대상으로 라우팅했을 뿐이며, 다른 시트에 같은
  형태의 오배정이 있는지는 **확인하지 않았다.**
- **`opt_grp` 밖 4건(H21)의 정체를 판정하지 않았다.** 결함인지 정상인지는 진단 SPEC 소유다
  (`SPEC-PRICECONF-001` / `SPEC-PRICEWIRE-001`). `OPT_000082`·`OPT_000084` 는 그룹 구성원이
  **0명**이라 데이터 공백으로 보이나, **그 판정도 하지 않았다** — 관측만 남긴다.
- **`clr_cd` 컬럼.** `t_prc_component_prices` 에 `clr_cd` 가 있으나 `use_dims` 12종에 없다.
  이 SPEC 의 범위 밖으로 두었고 **조사하지 않았다.**
- **라이브 쓰기 0건** — 실행한 것은 `SELECT` 와 `openpyxl` 읽기뿐이다.

## §F Phase 4 Mode Selection

실측 시각 2026-08-29 · 주 체크아웃 `/Users/innojini/Dev/HuniWeb` · `main` · HEAD `a2335213`

**입력 파라미터**

| 항목 | 값 |
|---|---|
| tier | M (요구사항 16 = 상한) |
| 범위(파일 수) | 산출 대상 ≈ 3~6 (`_workspace/price-setup/` 신규 생성기 + 리포트 + TSV) |
| 도메인 수 | 1 (가격 격자 생성기 — 권위 CSV 읽기 + 라이브 읽기전용 조회) |
| 파일 언어 | Python 단일 |
| 병렬 이득 | LOW — 코딩 중심이고 M3 → M1 → M1b/M2 → M4 가 직렬 의존 |

**모드 평가**

| 모드 | 선택 | 사유 |
|---|---|---|
| `direct` | 미선택 | 오타·1줄 수정이 아니다. 신규 생성기 구현 |
| `serial` | **선택** | 코딩 중심 + 단일 도메인 + 마일스톤 직렬 의존. Anthropic 코딩 병렬화 유보 조항이 그대로 적용된다 |
| `fanout` | 미선택 | 도메인 1개(≥3 미달) · 리서치 중심 아님 |
| `sweep` | 미선택 | ~30 파일 기계적 일괄 변환이 아니다. 규칙 자체를 세우는 일이라 균일 변환 규칙이 없다 |

**Decision: direct** (최초 `serial` 선택 → 실측 후 정정)

**근거** — M3 이 임계 경로이고(plan.md R-13) M1 의 분모가 그 산출에 의존하므로 마일스톤을 동시에 열 수 없다. 파일 쓰기 대상도 `_workspace/price-setup/` 한 곳이라 병렬화의 이득 대신 쓰기 경합만 생긴다. 여기까지가 `serial` 을 고른 이유였고, 그 판단 자체는 유지된다.

**`serial` → `direct` 정정 (실측 근거)** — manager-develop 위임을 실행했고 런타임이 그 에이전트를 워크트리에 자동 격리했다. 격리 트리의 실측:

```
pwd                        → /Users/innojini/Dev/HuniWeb/.claude/worktrees/agent-<id>
git rev-parse --short HEAD → 3be167a5   (2026-07-05, main 기준 115커밋·55일 뒤)
ls .moai/specs/SPEC-PRICEGRID-001 _workspace/price-setup raw/webadmin
                           → 세 경로 전부 No such file or directory
ls docs/huni/*260822*      → no matches   ← 최신본이 260702 로 보인다 (spec.md §2.4 함정)
```

원인은 **이 SPEC 의 입력 자산 상당수가 git 미추적**이라는 구조적 사실이다. SPEC 아티팩트 4종이 `??` 상태이므로 워크트리를 새로 만들어도 복제되지 않는다. 즉 워크트리 격리는 이 작업과 맞지 않으며, 재시도해도 같은 결과가 나온다.

에이전트는 산출물을 만들지 않고 블로커를 반환했다(위임 프롬프트 Section A 의 cwd 선확인 지시가 작동). 고아 워크트리는 `git worktree remove --force` 로 제거했고 `git worktree list` 는 main 단일로 복귀했다.

⇒ 주 체크아웃에서 오케스트레이터가 직접 구현한다. `fanout`·`sweep` 은 §F 표의 사유로 여전히 미선택이다.

---

## §E.2 Run-phase Evidence

_<pending run-phase>_

## §E.3 Run-phase Audit-Ready Signal

_<pending run-phase>_

## §E.4 Sync-phase Audit-Ready Signal

_<pending sync-phase>_
