---
id: SPEC-WIDGET-WIRING-001
doc: plan
version: "0.2.0"
updated: 2026-08-22
---

# 실행 계획 — SPEC-WIDGET-WIRING-001 v0.2.0

> v0.1.0 대비 변경: 렌즈 B(게시 위젯 실호출) 트랙 신설 · 스냅샷에 `t_wgt_*` 추가 ·
> 렌즈 A 정정 패스 · 대조 뷰. 원칙은 그대로 — **재사용 최대·알고리즘 mint 0·읽기 전용**.

## 0. 산출물 트리 (v0.2.0)

```
_workspace/huni-widget-wiring/
├─ CONSULT-DENOMINATOR-260821.md · CROSS-VERIFY-260822.md      (입력)
├─ bin/
│  ├─ harvest_sim_meta.py            (기존)
│  ├─ harvest_publish_cfg.py         ★신규 — 게시 스냅샷/항목 덤프
│  ├─ lens_b_runner.py               ★신규 — 게시 위젯 실호출 스윕
│  ├─ build_wiring_health.py         (확장 — NOT_EVALUATED·cross·blast_radius)
│  └─ build_artifact.py              (확장 — 대조 뷰)
└─ out/
   ├─ publish-cfg/<wgt_cd>.json      ★ · sim-meta/<prd_cd>.json
   ├─ defects/{widget,price,lens-b}-defects.jsonl
   ├─ wiring-health/<prd_cd>.json · wiring-health-index.json
   ├─ cross-view.json                ★ 두 렌즈 대조 집계
   ├─ wiring-explorer.html · REPORT-260822.md · worklist.csv
```

## 1. 마일스톤

| M | 내용 | 선행 | 산출 |
|---|---|---|---|
| **M-A0** | 감사 도구 소재 탐색(search-before-mint) | — | **완료**(spec §1.6): 저장소 내 부재 확인. 흡수 대상 = 경로(4자산) |
| **M0'** | 스냅샷 갱신 + `t_wgt_*` 3테이블 추가 | — | `snap_*` (39테이블) |
| **M1** | hdx 가격 레이어 as-is 재실행 | M0' | 결함보드 갱신 |
| **M2'** | 렌즈 A 어댑터 **정정 패스** | M0' | 심각도 원복·E1 재정의·`--all-types`·문구 교체 |
| **M3** | sim-meta 하베스터(기존) | M0' | `sim-meta/*.json` |
| **M7** | **게시 cfg 하베스터**(G1 입력) | M0' | `publish-cfg/*.json` + G1 결함 |
| **M8** | **렌즈 B 러너**(실호출 스윕) | M7 | `lens-b-defects.jsonl` |
| **M4'** | 조립기 확장(NOT_EVALUATED·cross·blast_radius) | M1·M2'·M3·M7·M8 | `wiring-health/*` · `cross-view.json` |
| **M5'** | 아티팩트 확장(대조 뷰·신규 엣지 범례) | M4' | `wiring-explorer.html` |
| **M6'** | 보고 + worklist(값 삭제 금지 문구·파급 상품 수) | M4' | `REPORT-260822.md` · `worklist.csv` |

순서: M0' → M1 ∥ M2' ∥ M3 ∥ M7 → M8 → M4' → M5' → M6'.

## 2. M0' — 스냅샷 확장

- `live-snapshot/snapshot.sh` 의 테이블 목록에 `t_wgt_widgets`·`t_wgt_widget_versions`·`t_wgt_widget_items` 추가.
  (`snapshot.sh` 는 `_foundation` 자산 — `raw/` 아님. 수정 허용 범위)
- 게시 상태 판정 컬럼: `t_wgt_widgets.sts_typ_cd`(기초코드) + `use_yn='Y'` + `del_yn='N'`.
  **[HARD] 게시 상태 코드값은 라이브 `t_cod_base_codes` 에서 실측해 확정**(하드코딩 추정 금지).
- 산출 콘솔: 활성 상품 수 · 게시 위젯 수 · 감사 분모(194) 대비 차이.

## 3. M2' — 렌즈 A 정정 패스

**위험 3건은 v0.1.0 run 이 이미 교정 완료**(progress.md "교정 3건 반영"). M2' 의 잔여 작업만 남는다.

| 정정 | 대상 | 상태 |
|---|---|---|
| E1 재정의(직접가 보유 시 결함 아님) | `widget_wiring_dx._coverage` | **완료** — E1 59→2 |
| 문구 교체(값 삭제 금지) · `auto_data` 제거 | `widget_wiring_dx` REMEDIATION | **완료** — auto_data 29→0 |
| `NOT_EVALUATED` 산출 · 센서 실패 전 상품 강등 | `build_wiring_health.py` | **완료** — 51건 |
| **TRUNCATED 분류** | `widget_wiring_dx.py:54` | **잔여** — Defect 가 아니라 커버리지 고지로 분리(OK 판정 차단) |
| **`use_dims` 파싱**(JSON 문자열을 쉼표 분해) · `code_of` 한글 토큰 | `build_wiring_health.py:102` | **잔여** — 아티팩트 근거 추적 복구 |
| **`evaluated_by` 증거화** | 조립기 | **잔여** — AC5 를 합집합 상수가 아닌 실행 증거로(§acceptance AC5) |

> 유형 커버는 `--all-types` 로 풀 수 없다 — `verify_price_coverage.py:180` 은 `PRD_TYPE.01` 하드코딩이고
> 플래그가 없으며 원본 수정은 OUT-1 금지다. **셋트구성원·기성은 렌즈 B(M8)로 메운다.**

## 4. M7 — 게시 cfg 하베스터

```
t_wgt_widgets(게시) ⨝ t_wgt_widget_versions(act_yn='Y') ⨝ t_wgt_widget_items
→ publish-cfg/<wgt_cd>.json {prd_cd, ver_no, cfg, items[{ref_key, ctrl_typ_cd, dflt_val, visible_yn, props}]}
```
- **G1 판정**: `dflt_val`·`cfg` 안의 코드값(`MAT_*`·`SIZ_*`·`POPT_*`·`OPT_*`)을 상품 활성 등록값과 조인.
  부재 → `WIDGET_DEFAULT_STALE`. 값 없음 → `INFO-1`.
- 결정론 조인만(스냅샷 CSV). 실호출 불필요.

## 5. M8 — 렌즈 B 러너 [핵심 신규]

```python
# 개념 — 전부 기존 함수 호출. 알고리즘 재구현 0.
for w in published_widgets:                       # t_wgt_widgets
    cfg  = active_version(w).cfg                  # 게시 스냅샷
    base = default_selection(cfg)                 # dflt_val + 마스터 dflt
    for combo in base_plus_one_change(cfg):       # 기본화면 + 항목 1개씩 변경
        body = widget_api._prep_selections/_expand_opt_sels/_prep_proc_sels/_prep_set_body(...)
        res  = pricing.evaluate_price(...)        # 서버와 동일 판정
        defects += classify(res)                  # 엔진 오류코드 → 엣지
```
- 오류코드 → 엣지 매핑(§spec R8): `no_plate_pansu`→**E5** · `below_min`→**Q1** · 셋트 실패→**S1** ·
  매칭 0→E4 · 소스 없음→E1 · 옵션 유형 오류→**W6** · 상세옵션 검증 실패→W5.
- 제약(JSONLogic)으로 불가한 조합은 스킵(감사 방법 승계) — `widget_api` 제약 평가 재사용.
- 절단 상한 도달 시 `combos_truncated` 기록. **절단된 상품은 OK 판정 금지**.
- 한계 명시: 다중 항목 동시 변경 미검사(감사와 동일).
- 성능: 194위젯 × 조합. 상한/캐시로 제어하고 실측 소요를 보고에 기록.

## 6. M4' — 조립기 확장

1. 렌즈 A·B 결함을 `(prd_cd, edge, node)` 로 병합.
2. `NOT_EVALUATED` 산출: 센서 미지원 유형 · 센서 실패 · 절단 · 렌즈 B 미도달(미게시).
3. `cross.state` 판정: CONVERGE / A_ONLY / B_ONLY / BOTH_OK / UNCOMPARABLE.
   - `A_ONLY` → 게시 스냅샷으로 미게시 여부 확인 → 확인 전 `[추정]`.
4. `blast_radius`: 결함 comp 를 쓰는 활성 상품 수(공유도 §1.5-라).
5. 교정 라우팅: `ANCHOR_*`·재키 계열은 `review` 고정(auto_data 금지).

## 7. M5' — 아티팩트 대조 뷰

- 신규 탭 **[대조]**: 3분면(수렴 / 불일치 A만·B만 / 미평가) 카운트 + 상품 목록 + 사유.
- 상품 상세에 렌즈 A·B 판정 배지 병기, 렌즈 B 는 실패 조합의 요청 본문·엔진 사유 표시.
- 범례에 신규 엣지 5종 + INFO-1 + `NOT_EVALUATED` 추가.
- 기존 규율 유지: 인라인 임베드·외부 fetch 0·라이트/다크 명시.

## 8. 실행 순서

```bash
bash _workspace/_foundation/live-snapshot/snapshot.sh                      # M0'
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price     # M1
python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope widget    # M2'
python3 _workspace/huni-widget-wiring/bin/harvest_sim_meta.py              # M3
python3 _workspace/huni-widget-wiring/bin/harvest_publish_cfg.py           # M7
python3 _workspace/huni-widget-wiring/bin/lens_b_runner.py                 # M8
python3 _workspace/huni-widget-wiring/bin/build_wiring_health.py           # M4'
python3 _workspace/huni-widget-wiring/bin/build_artifact.py                # M5'
```

## 9. 미해결로 남기는 것 (검증 전 결론 금지)

| # | 항목 | 상태 |
|---|---|---|
| U-1 | 우리에만 BROKEN 10건이 미게시라서 감사 분모 밖인가 | **[추정]** — M7 게시 스냅샷으로 확인 |
| U-2 | 트윈링책자 `COMP_BIND_TWINRING` 단가행 `proc_cd` 가 전부 무선제본(`PROC_000019`) | 리뷰 §3.1 · **백로그 t2** · M8 에서 확인 |
| U-3 | 책자 3종 공식에 인쇄비·용지비 구성요소 부재(제본비 단일) · 책자 5상품 `mand_proc_yn` 공백 | E2 후보 · **백로그 t3** · M8 재평가 |
| U-4 | "가격경로 둘 다 없음 50" 의 성격(미완성 vs 미게시) | M8 + M7 교차로 규명 |
| U-5 | 감사 도구가 우리와 동일 경로를 탔는지 | 원본 부재로 확증 불가 · 수렴율로만 방증 |

## 10. 워크트리 주의

SPEC 정본은 메인 체크아웃 `.moai/specs/SPEC-WIDGET-WIRING-001/`. 본 세션은 워크트리에서 작성 후
`cp` 로 정본을 갱신한다(워크트리 사본은 남기지 않는다).
