# G3 렌즈 검증 결과 — 운영·자산 (Claude)

> 대상: `_workspace/huni-worldmodel/04_design/design-FINAL.md`
> 잣대: `_workspace/huni-worldmodel/04_design/evaluation-rubric.md` v1.0 (사전등록)
> 렌즈 G3: 지식의 유지주체와 유지비용 · 선행 하네스 자산 정합 · 이미 기각된 접근의 부활 여부
> [HARD] 규율: 루브릭 규칙에 근거하지 않은 지적은 제기하지 않는다. 5요건 미충족 지적은 제출하지 않는다.
> 라이브 DB 미조회 · `raw/webadmin` 읽기 전용 · 파일 수정 0건.

---

## 0. 제기 요약

| 항목 | 값 |
|---|---:|
| 제기 총건 | 2 |
| 주장 등급 | MAJOR 1 · MINOR 1 |
| BLOCKER 주장 | **0** |
| 강점 기록 | 5 |

**제기하지 않은 것을 먼저 밝힌다.** 이 렌즈로 6개 후보를 검토했고 그 중 4개를 스스로 각하했다(§3). 각하 사유는 전부 §2.1 기본값 규정(근거 불충분 시 기본값은 각하) 또는 실측 반례 확인이다.

---

## 1. 반증 OBJ-G3-01 · G0.5 파리티 게이트가 **서로 다른 두 차원 어휘**를 하나로 취급한다

```
반증 ID: OBJ-G3-01
위반 RULE-ID: RULE-12 (①)
주장 등급: MAJOR
```

### (b) 실패 시나리오

- **입력/상태**: S1 착수. `gates/dim_parity.py`를 설계 규정대로 구현한다 — 측정 대상 = `views.py`의 4표면 + DB 트리거 `fn_chk_opt_item_ref`, 분모 = "축 12종(`price_views.py:31` `DIM_META` 기준)", 임계 = "5벌 전부 동일, 불일치 1건이면 빌드 FAIL"(`design-FINAL.md:566`).
- **기대 결과**: 5벌이 갈리지 않았다면 PASS. 갈렸다면 그 축을 지목하며 FAIL.
- **실제(예상) 결과**: **드리프트가 0건이어도 즉시 FAIL한다.** `views.py` 4표면과 DB 트리거는 전부 `OPT_REF_DIM.01~.07` **7축** 계열이고, 분모로 지정된 `DIM_META`는 **12축**의 다른 어휘다. 두 집합은 부분집합 관계조차 아니다 — `DIM_META`에 없는 축이 `OPT_REF_DIM` 쪽에 3개(`mat_cd__usage_cd` 결합키·`opt_id`·`sub_prd_cd`), `OPT_REF_DIM`에 없는 축이 `DIM_META` 쪽에 6개(`print_opt_cd`·`coat_side_cnt`·`spot_side_cnt`·`siz_width`·`siz_height`·`min_qty`)다. 따라서 게이트는 정상 상태를 상시 위반으로 보고하고, S1은 첫 게이트에서 영구 정지하거나(설계 문언대로 "롤아웃 금지") 구현자가 분모를 조용히 7로 바꿔 문서와 코드가 갈린다. 어느 쪽이든 §4.5가 선언한 "재사용이 낳는 감시 의무"의 핵심 센서가 무력화된다.

### (c) 근거 (전부 직접 실측)

| 사실 | 실측 위치 |
|---|---|
| G0.5 감시 대상 = `views.py` 4표면 + `fn_chk_opt_item_ref` | `_workspace/huni-worldmodel/04_design/design-FINAL.md:352` |
| G0.5 분모 = "축 12종(`price_views.py:31` `DIM_META` 기준)" · 임계 "불일치 1건이면 빌드 FAIL" | `design-FINAL.md:566` |
| `DIM_META` 키 **12개**(`siz_cd`·`plt_siz_cd`·`print_opt_cd`·`mat_cd`·`proc_cd`·`opt_cd`·`coat_side_cnt`·`spot_side_cnt`·`bdl_qty`·`siz_width`·`siz_height`·`min_qty`) | `raw/webadmin/webadmin/catalog/price_views.py:31-43` |
| `VAR_KEY_MAP` = `OPT_REF_DIM.01~.07` **7축** | `raw/webadmin/webadmin/catalog/views.py:61-69` |
| `DIM_REF_MODELS` = 동일 7축 | `views.py:1882-1890` |
| `_DIM_LABEL_FIELDS` = 동일 7축 | `views.py:1893-1901` |
| `_IMPACT_SECTIONS` = 동일 7축 | `views.py:3670-3678` |
| DB 트리거가 분기하는 축도 `OPT_REF_DIM.01`~`.07` (7분기) | `raw/webadmin/sql/10_phase7_ddl.sql:193` 이하; enum 정의 `raw/webadmin/sql/12_phase7_seed.sql:27,37-61` ("루트 1 + 자식 **7**") |
| 두 계열이 사상으로도 합치되지 않음 — `OPT_REF_DIM.03`→`mat_cd__usage_cd`(결합키), `.06`→`opt_id`, `.07`→`sub_prd_cd` 는 `DIM_META`에 부재 | `views.py:61-69` vs `price_views.py:31-43` |
| 설계가 `DIM_META`를 "차원 어휘"의 정의처로 별도 지정 | `design-FINAL.md:432` |

### RULE-12 ① 적용 (violation_test 그대로)

> "설계가 도입하는 각 개념(차원·규칙·효과·상태 등)에 대해 '정의가 사는 곳'이 문서에 **정확히 하나** 지정되어 있는가. 두 곳 이상이면 위반."(`evaluation-rubric.md:110`)

설계가 G0.5로 도입한 개념은 **"차원 축 집합"** 하나다. 그런데 그 개념의 정의처로 `DIM_META`(분모, `design-FINAL.md:566`·`:432`)와 `OPT_REF_DIM` 계열(비교 대상 5표면, `:352`) **두 곳**이 동시에 지정되어 있고, 둘은 실제로 다른 집합이다(위 실측). 두 곳 지정 → 위반.

**BLOCKER로 올리지 않는 이유**를 밝힌다. RULE-05의 violation_test는 "①측정 대상 ②도구 ③임계 ④분모 4항이 모두 없으면 위반"이며 본 설계는 4항을 **기재했다**. 기재된 분모의 *내용*이 틀렸다는 것은 그 test가 재는 항목이 아니다. 다른 기준으로 판정하면 §4.2 FP-4(오판)에 해당하므로, RULE-05 위반은 주장하지 않는다. 또한 §3.3 MAJOR→BLOCKER 승격은 "교정 불가능성"을 요구하는데, 본 건은 게이트 1개의 분모 정정으로 끝나며 설계 뼈대(§3 계층도·§4 데이터 모델)와 무관하다.

### (d) 자기 반증조건

설계 문서 어딘가에 **`OPT_REF_DIM.NN` → `DIM_META` 컬럼 사상 규정**(예: "G0.5는 `VAR_KEY_MAP`이 반환하는 컬럼명으로 환원해 비교하며, `DIM_META`의 티어 차원 3종과 셋트/도수 축은 대조 대상에서 제외한다")이 명시되어 있다면 이 지적은 철회된다. 나는 `design-FINAL.md` 전문에서 `DIM_META`가 등장하는 3지점(`:352` 감시 대상 · `:432` 어휘 정의처 · `:566` 분모)을 확인했고 그런 사상 규정을 찾지 못했다. 또한 §13-3(`:800`)이 미확정으로 남긴 것은 "**트리거 본문 파싱 방법**"이지 분모 정의가 아니다 — 즉 이 건은 문서가 미확정으로 유보한 항목이 아니다.

### (e) 교정 방향 (RULE-12 ①을 어떻게 만족시키는가)

G0.5를 **두 개의 독립 센서로 분리**해 개념당 정의처를 하나로 만든다.

- **G0.5a — 참조차원 파리티(P-16이 지목한 5벌 그 자체)**: 정의처 = `OPT_REF_DIM` enum(`sql/12_phase7_seed.sql:27,37-61`). 대상 = `views.py` 4표면 + `fn_chk_opt_item_ref`. **분모 = 7축.** 임계 = 5벌 전부 동일.
- **G0.5b — 가격차원 어휘 파리티**: 정의처 = `pricing.NON_QTY_DIMS ∪ TIER_DIMS`(`pricing.py:45-46`·`:52`, 실측 9+3=12). 대상 = `price_views.DIM_META`(`price_views.py:31`). **분모 = 12축.** 임계 = 두 벌 동일.

이 분리는 설계의 논지를 약화시키지 않고 오히려 강화한다 — §4.5가 주장한 "5벌이 갈리는 순간을 감지한다"의 5벌은 정확히 `OPT_REF_DIM` 계열이며, `DIM_META`는 그 5벌에 포함된 적이 없다(`design-FINAL.md:352`의 대상 목록에도 없다). 분모 문구 한 줄만 갈렸다.

---

## 2. 반증 OBJ-G3-02 · 에스컬레이션 1순위 목적지 `gap_owner`는 큐가 아니라 **채택하지 않은 계층의 필드**다

```
반증 ID: OBJ-G3-02
위반 RULE-ID: RULE-14 (③)
주장 등급: MINOR (NOTE — violation_test는 통과함, §3.1 "위반은 아니나 기록할 위험")
```

### (b) 실패 시나리오

- **입력/상태**: S2 진입. `sim_escalation`에 `TMPL_COMBO_UNREGISTERED`·`ANCHOR_MISSING`·`AFFECT_UNDEFINED` 행이 쌓인다. `route_to`는 "기존 `gap_owner` 큐"를 가리킨다.
- **기대 결과**: 실무진이 자기 화면에서 그 행을 보고 처리한다(설계 §4.7의 "새 큐를 만들지 않고 기존 큐를 쓴다").
- **실제(예상) 결과**: `gap_owner`는 화면도 테이블도 아니라 **KB 마크다운 축 페이지의 GAP 노드 YAML 필드**다. 그 필드가 사는 계층(`huni-ontology-kb` 그래프)을 본 설계는 §12-7에서 **명시적으로 도입하지 않는다**고 선언했다. 결과적으로 `sim_escalation` 행이 실무진 시야에 도달하는 경로는 설계 안에 존재하지 않고, 큐는 아무도 읽지 않는 쓰기 전용 로그가 된다. 이는 설계가 P-20에 대해 비판한 탈출구("관리자에게 문의", `design-FINAL.md:597`)와 형태만 다른 같은 실패다.

### (c) 근거

| 사실 | 위치 |
|---|---|
| `route_to` 1순위 = "§26 `hpti` 권위 격자 트랙 (기존 `gap_owner`)" | `design-FINAL.md:395` |
| 계층도 STAFF 노드 = "실무진 큐 (기존 gap_owner)" | `design-FINAL.md:181` |
| `gap_owner`는 KB GAP 노드의 YAML 필드(`gap_owner: staff`) | `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md:83` (동 패턴 `:245`, ERD 표기 `:309`) |
| KB 빌더가 파싱하는 노드 필드이며 `type=gap`에 3필드 필수(lint) | `_workspace/huni-ontology-kb/04_graph/build_graph.py:109`, `:324`; 규격 `02_ontology/file-format-spec.md:61,129` |
| 본 설계는 온톨로지/지식그래프 계층을 도입하지 않는다 | `design-FINAL.md:781` (§12-7), 사유 §2.2 (3) `:75-76` |
| B안이 인용한 착지점도 KB 스키마(`ontology-schema.md:75-84`)였다 — 즉 KB 채택을 전제한 처방 | `design-B-knowledge-first-graphrag.md:432` |

### RULE-14 ③ 적용 — **위반으로 확정하지 않는다**

> "'권위 격자 미적재 셀 / 신규 조합 / 제약 미커버' 같은 고불확실 케이스의 **라우팅 목적지가 문서에 없으면** 위반."(`evaluation-rubric.md:156`)

목적지는 문서에 **있다** — `esc_kind` 6종 × `route_to` 매핑표(`design-FINAL.md:389-399`). 따라서 violation_test는 통과하며, 나는 이를 확정 위반으로 올리지 않는다. 목적지의 *운영 실체성*은 이 test가 재는 항목이 아니고, 재지 않는 것을 재면 §4.2 FP-4다. 루브릭 §3.1의 NOTE 정의("위반은 아니나 기록할 위험이 있다")에 따라 기록만 한다.

### (d) 자기 반증조건

`gap_owner` 필드를 실무진이 실제로 주기적으로 소비하는 운영 표면(화면·대시보드·리포트)이 존재하고, `sim_escalation` 행이 그 표면으로 유입되는 경로가 설계 또는 선행 산출물에 명시되어 있다면 이 기록은 철회된다. 구체적으로는 — `huni-product-readiness/05_gate/dashboard/`(D7 A17, `D7-prior-harness.md:40`)나 §26 트랙 산출물이 KB GAP 노드를 소비해 실무진에게 제시하는 절차가 문서화되어 있으면 철회 대상이다. 나는 `_workspace` 전역 `gap_owner` grep에서 소비처가 KB 빌더·스키마·04_design 문서뿐임을 확인했다(라이브 화면·webadmin 코드 히트 0건).

### (e) 교정 방향

MINOR이므로 대안 부담(§2.2 (e))은 없으나 함께 적는다 — `route_to` 값을 **채택된 자산으로만 한정**한다. 예: `PRICE_ROW_MISSING`/`ANCHOR_MISSING`은 §26 `_batch` 산출 CSV(`huni-price-table-integrity/_batch/`)에 append 되는 결함 행으로, `TMPL_COMBO_UNREGISTERED`는 webadmin 조합템플릿 등록 화면의 작업 목록으로 착지시키고, 각 `esc_kind`에 **소비 표면 + 소비 주기 + 소유 트랙** 3항을 명시한다. KB `gap_owner`를 계속 쓰려면 §12-7의 "KB 계층 미도입" 선언과의 관계(=KB의 GAP 노드만 부분 채택하는가)를 한 줄로 규정하면 족하다.

---

## 3. 스스로 각하한 후보 (제기하지 않음)

검증자도 측정 대상이라는 §4.1 규정에 따라, 검토했으나 각하한 것을 남긴다.

| # | 후보 지적 | 각하 사유 |
|---|---|---|
| C-1 | "§26 권위 격자가 260702에 머물러 있어 §0의 260705 단일 선언과 어긋난다(RULE-15 ④)" | **실측 반례로 각하.** `_workspace/huni-dbmap/24_price-extract-260705/` 가 37파일로 실재하며 260702 추출본과 동수다. §26 HANDOFF의 "재추출 미완(라 트랙)" 서술이 오히려 구 상태다. 텍스트 인용만으로 제기했다면 FP-2였다 |
| C-2 | "`provenance-map`의 `xlsx:파일#시트!셀` 앵커를 만들 원천이 없다(RULE-11)" | **실측 반례로 각하.** `24_price-extract-260705/price-coating-l1.csv` 헤더가 `sheet, block_id, block_title, row_seq, col, cell_ref, value, cell_meta_json` — 시트명과 셀 좌표가 그대로 있다. 앵커 산출 가능 |
| C-3 | "캐시(`cache_hit`)가 N-13(스냅샷 신뢰 가격 판정)의 부활이다(RULE-15 ①)" | **각하.** 설계가 §5.3·§8 RULE-13 ③에서 구속력 값의 라이브 재계산을 규정하고 G0.9로 다이제스트 불일치 시 판정 거부를 건다. 나아가 §11-6이 잔여 한계를 스스로 기록했다. 다이제스트가 `upd_dt` 미갱신 UPDATE를 못 잡는다는 반례는 **내가 실측하지 못했다**(라이브 DB 미조회). §2.1 기본값 = 각하, J-5(도구 없이 텍스트 패턴만으로 확정) 회피 |
| C-4 | "`simcore` 20구성물 + 게이트 10종의 유지비용이 과다하다" | **각하.** §2.2 (b) 실패 시나리오를 재현 가능한 형태로 쓸 수 없고, private 심볼 의존 비용은 §11-5가 이미 자기 기록했다. 막연한 우려는 각하 |

---

## 4. 대칭 규율 — 설계가 규칙을 잘 만족하는 지점 (근거 포함)

### S-1. RULE-15 ③④ — 하네스 경계와 고정 선언이 실측과 일치한다

- P-08(가격 사슬 배선)을 §0 표(`design-FINAL.md:16`)·대응표(`:46`)·비목표 §12-10(`:784`) **세 곳에서 일관되게 범위 밖**으로 선언했다. D7 A12(4하네스 재병합 금지, `D7-prior-harness.md:35`)와 원장 §3.1-4(`problem-ledger.md:432`) 준수.
- 상품 분모 **288** 단일 선언(`:14`)이 D8 라이브 실측표의 "라이브 상품(del_yn≠Y) 288"과 정확히 일치한다(`D8-live-schema.md` §3 가격 사슬 실측표). D7 C2가 지적한 분모 3종(275/283/297) 혼재를 실측 최신값으로 봉합했다.

### S-2. RULE-11 앵커 원천이 실물 자산으로 뒷받침된다 (직접 실측)

`design-FINAL.md:598`의 "앵커 원천은 §26 권위 격자(260705)"는 실물이다 — `_workspace/huni-dbmap/24_price-extract-260705/price-coating-l1.csv` 1행 헤더에 `sheet`·`cell_ref`·`value`가 존재하고, §26 배치가 이 디렉터리를 참조한다(`huni-price-table-integrity/_batch/pansu_basis_audit.py:16`). **선행 하네스 자산을 이름으로 인용한 것이 아니라 실제로 소비 가능한 형태로 지목했다.**

### S-3. G0.5의 감시 대상 5표면이 인용 라인 그대로 실재한다

OBJ-G3-01이 분모를 지적하지만, **대상 자체는 전건 실재**한다 — `views.py:61-69`·`:1882-1890`·`:1893-1901`·`:3670-3678` 4표면과 DB 트리거 `fn_chk_opt_item_ref`(`sql/10_phase7_ddl.sql:193`)를 직접 확인했다. P-16이 "5벌 병렬"이라 부른 대상을 정확히 지목했으며, 이는 설계가 라이브 코드를 실측하고 썼다는 증거다.

### S-4. RULE-15 ① — 기각목록을 비목표 18항으로 기계적으로 봉쇄했다

`design-FINAL.md:775-792`의 비목표 18항이 N-16(§12-1 raw/webadmin 무수정)·N-19(§12-6 전수열거 금지)·N-18(§12-14 LLM 판정권 0)·N-17(§12-16 학습·self-refine 금지)을 각각 명문으로 잠갔다. 특히 A안의 `t_wm_*` 선언 테이블 미채택 사유를 **인상이 아니라 실측**으로 논증했다 — `admin.site.register` 루프가 `models.py` 선언 모델만 순회하므로 편집 화면이 존재하지 않는다(`:69`, `admin.py:1922` 인용). 기각 판단에 근거를 댄 것이 RULE-12(편집 표면) 규범과 정합한다.

### S-5. RULE-13②·RULE-14② — 라이브 write 0과 인간 승인 게이트가 프로젝트 [HARD] 규약과 정합

라이브 write 0건(`:17`, §12-2 `:776`), 확정 권위는 위젯 `/handoff` + 인간 확인(`:439-440`, §12-13 `:787`), 자동 확정 임계 자체를 두지 않음(§12-15 `:789`). 이는 MEMORY [HARD] "라이브 적재 전 webadmin 실화면 필수 · COMMIT=인간승인"과 R3 §C의 "초기엔 자동 확정 임계를 사실상 100%로" 처방(`:706` 인용)을 동시에 만족한다. 부작용 0의 보장 논증도 새로 만들지 않고 라이브에서 이미 검증된 `assistant_tools.run_sql` 방어선(N-26)을 복제한다(`:345`) — **이미 잘 되고 있는 것을 모방하는** 태도가 RULE-15 ②와 정합한다.

---

## 5. 미확인 · 한계

1. **라이브 DB를 조회하지 않았다.** 본 문서의 실측은 `raw/webadmin` 소스와 `_workspace` 산출물 파일에 한정된다. `upd_dt` 갱신 실태(C-3)·`t_prc_component_prices` 현재 행수 등 라이브 사실은 미검증이다.
2. **`design-FINAL.md` 전문을 읽었으나 A/B/C 원안과 L1/L2 심사문은 읽지 않았다.** L3(운영부담) 심사문만 대조했다. 따라서 "L1/L2가 이미 지적했는데 중복 제기"인지는 이 문서가 판정하지 못한다(§3.2 중복 병합은 종합 시점에 처리).
3. **`fn_chk_opt_item_ref`의 트리거 본문을 라이브에서 조회하지 않았다.** 축 7분기는 `sql/10_phase7_ddl.sql:193` 이하 정의 소스와 `sql/12_phase7_seed.sql:27`("루트 1 + 자식 7")로 판정했다. 라이브 실제 트리거가 배포본과 다를 가능성은 배제하지 못한다.
4. **웹 검색 미사용.** 저장소 내부 파일만 근거이므로 `Sources:` 절을 두지 않는다.
