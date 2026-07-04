# 통합 진단·교정 배치 설계 청사진 (입체·반자동 자기회귀·적대적검증)

> **목적**: 실무진이 **한 명령**으로 전 후니프린팅 카탈로그를 **입체(다차원) 진단 → 통합 결함보드 → 교정본 자동생성 → 적대적 독립 재실측 → 전역 GO/NO-GO** 까지 돌린다. 파편화된 개별 스캐너를 공통 프레임 위로 통합.
> **작성 근거**: 진단·교정 스크립트 생태계 전수 매핑(260704) + 도메인 규칙 SOT(HARNESS-DOMAIN-RULES-12) + 이번 세션 실증(가격구성요소 병합·타공 교정).
> **상태**: 설계(승인 대기). 구축 전 인간 승인.

---

## 0. 왜 필요한가 (현황 = 파편화)

전수 매핑 결론: **통합 배치 없음.** 차원별 결정론 스캐너 6종+·교정생성 패턴·공용 클라이언트(`lib_huni`)는 있으나 —
- 상위 러너 부재(6 스캐너를 한 번에 부르는 코드 0·통합 결함보드 없음)
- 4개 미니 생태계가 CSV 로더/psql을 제각각 재구현(공통 `base` 실파일 없음)
- 자기회귀 = 사람이 매 라운드 수동 재실행(스크립트는 측정·기록만)
- 적대적검증 = 에이전트 스킬로만(배치가 codex 미호출)
- 옵션(CPQ) 차원 전용 스캐너 없음·상시 SQL 게이트는 판형 하나뿐

---

## 1. [HARD] 설계 제약 (먼저 못박기)

1. **완전 무인 자기회귀 금지**: 라이브 COMMIT = 인간 승인 + webadmin 실화면 확인 필수(도메인 규칙 SOT). 배치가 자동으로 하는 최대치 = **교정본 생성까지**. 적재·webadmin은 인간 게이트.
2. **라이브 읽기전용**: 진단·재실측·DRY-RUN은 `RAILWAY_DB_*` 읽기전용 + 롤백전용. 쓰기는 별도 승인 채널.
3. **생성 ≠ 검증**: 교정 생성기(Remediator)와 적대적 재실측기(Verifier)는 **다른 코드경로**여야 한다(같은 코드가 자기 산출을 자기 승인 금지).
4. **권위 우선**: 권위 = 상품마스터 + 인쇄상품 가격표 엑셀(최신판). 값 verbatim(날조 0).
5. **search-before-mint**: 신규 최소화. 각 레이어는 기존 스크립트를 승계/래핑.
6. **비밀 미출력**: 자격증명 `.env.local`에서만·stdout 금지.

→ 그래서 이름도 "전자동 수렴 루프"가 아니라 **반자동 라운드 러너**(scan→board→교정생성→[인간 게이트]→적재→재scan)이다. 돈이 오가므로 이게 정답.

---

## 2. 아키텍처 — 7 레이어

패키지 `hdx/`(huni diagnostics) + 진입점 `diagnose_remediate.py`. 각 레이어에 **승계할 기존 자산** 명시.

```
diagnose_remediate.py  --scope {all|price|platesize|option|wiring|...}  --round N
 │
 ├─(L1) hdx/foundation/   공용 토대 ── 기존 lib_huni·_gate_harness 승격
 │       snapshot.py   live-snapshot CSV 1회 로드·ACTIVE 필터·경로계산 (갭#2 해소)
 │       db.py         라이브 읽기전용 psql            ← lib_huni.db() 승격
 │       authority.py  권위 엑셀 리더                  ← 기존 authority.py 재사용
 │       engine.py     pricing.py 매칭 verbatim 이식   ← _gate_harness.py 범용화
 │       models.py     공통 Defect/Fix 데이터클래스
 │
 ├─(L2) hdx/diagnose/   진단 레이어 ── 기존 스캐너를 공통계약으로 래핑
 │       계약: class Diagnoser: scan(snapshot)->list[Defect]; stop_predicate(defects)->bool
 │       WiringDx           ← wiring_scan.py
 │       DimConformanceDx   ← dim_conformance.py
 │       ContributionDx     ← contribution_scan.py (공정 저청구/silent-0)
 │       PlatesizeDx        ← diagnose_all.py (판형)
 │       PriceGridDx        ← run_all.py + grid_diff.py (19시트 격자)
 │       QtyRuleDx          ← qty_rule_audit_260702.py
 │       ComponentMergeDx   ← component_merge_scan.py (이번 세션)
 │       OptionCpqDx        ★신규 (갭#5 — 옵션 dtl_opt 누락·ref 정합·저청구)
 │
 ├─(L3) hdx/board/      통합 결함보드
 │       defect-board.csv   차원×상품 매트릭스(심각도·돈영향·증거·제안교정)
 │       defect-board.html  실무진 열람(정렬/필터·돈영향 상단)
 │       global_verdict     Σ 차원 stop_predicate → GO/NO-GO
 │
 ├─(L4) hdx/remediate/  교정 생성 ── 기존 gen_*.py 규약 승계
 │       계약: class Remediator: generate(defects)->{dryrun,fix,undo}.sql
 │       백업테이블 + 게이트 하드어서션 내장(이번 세션 COMMIT SQL 패턴)
 │       ★자동은 여기까지. 적재는 인간.
 │
 ├─(L5) hdx/verify/     적대적 독립 재실측 (생성≠검증)
 │       engine 재계산: 교정 전/후 골든 재현 허용오차0·silent합산·저청구 재확인
 │       codex_gate.py  (선택) codex exec -s read-only 독립 2차 ── 갭#4 해소
 │                       미가용→"Claude 단독" 폴백
 │
 ├─(L6) hdx/loop/       반자동 라운드 러너 ── wiring-rounds.csv 패턴 승계
 │       scan→board→(교정생성)→[인간 승인]→적재→재스냅샷→재scan, defect 0까지
 │       rounds.csv append(수렴 추이)·전역 정지 = 전 차원 defect0 + 전상품 PRICE≠0
 │
 └─(L7) 인간 게이트 [HARD]
         COMMIT·webadmin 실화면(제외0·PRICE≠0·판형·분기)·최종 승인. 배치는 여기서 정지.
```

---

## 3. 입체(다차원) 커버리지 표

"입체" = 한 상품을 여러 결함 차원으로 동시 진단. 각 차원의 진단소스·종료술어·돈영향.

| 차원 | 진단 소스(승계) | 종료술어 | 돈 방향 |
|---|---|---|---|
| 배선 | WiringDx(wiring_scan) | 고아·빈배선·오염·미바인딩 = 0 | 저/과청구 |
| 차원정합 | DimConformanceDx | use_dims↔단가행↔선택수단 MISSING/UNDECLARED = 0 | 저/과청구 |
| 공정 저청구 | ContributionDx | 공정 커버리지 silent-0 = 0 | **저청구** |
| 판형 | PlatesizeDx + plate_wiring_integrity_check.sql(상시) | 완제품 as-plate·판형축 미스매치 = 0 | 가격영향 |
| 가격격자 | PriceGridDx(19시트) | 미적재셀·transpose·불일치·prc_typ오타 = 0 | 과/미청구 |
| 수량 | QtyRuleDx | 밴드규칙 min=max(권위,가격표) 위반 = 0 | **과대청구** |
| 옵션(CPQ) | OptionCpqDx ★신규 | 옵션 dtl_opt 누락·ref_key 불일치·저청구 = 0 | **저청구** |
| 컴포넌트 병합 | ComponentMergeDx | 같은차원 분리 comp = 0 | 정합/이중합산 |
| 계산가능성 | score_batch(PR/CALC) | 전 상품 PRICE≠0·PRICED-0 = 0 | 결함신호 |

★신규 OptionCpqDx의 근거 = 이번 세션 발견(메쉬 타공 옵션 dtl_opt 누락 → 저청구). 이 패턴이 다른 상품에도 있을 수 있어 전용 스캐너가 갭.

---

## 4. 공통 Defect 스키마 (파편 출력 통일 = 갭#1 핵심)

각 스캐너가 제각각 출력하던 것(wiring-status.json / ALL-SHEETS-defects.csv / platesize-defects-all.json …)을 하나로:

```python
@dataclass
class Defect:
    dimension: str        # 'wiring'|'dim_conformance'|'option_cpq'|...
    prd_cd: str | None
    comp_cd: str | None
    frm_cd: str | None
    severity: str         # 'critical'|'high'|'medium'|'low'
    money_impact: str     # 'overcharge'|'undercharge'|'none'|'unknown'
    summary: str          # 한 줄 결함
    evidence: dict        # 라이브 실측값·권위값·경로
    suggested_fix: str    # 교정 방향(Remediator 입력)
    authority_ref: str    # 권위 근거(엑셀 시트·셀)
```

→ 이 스키마 하나로 통합 보드·정렬·돈영향 우선순위·교정 라우팅이 성립.

---

## 5. 자기회귀(반자동) — 라운드 루프

```
round N:
  1. snapshot = load()                 # 라이브 읽기전용 1회 로드
  2. defects = Σ Diagnoser.scan(snapshot)
  3. board = merge(defects); verdict = AND(stop_predicate)
  4. if verdict == GO: STOP (전 차원 defect0 + PRICE≠0)  ── 종료
  5. remedies = Σ Remediator.generate(defects)   # dryrun/fix/undo
  6. verify = AdversarialVerify(remedies)         # 엔진 재실측 + (codex)
  7. ── [인간 게이트] ── board+remedies+verify 제시 → 승인?
  8. (승인분만) 적재 + webadmin 실화면 확인
  9. rounds.csv.append(N, defect수, 해소, note)
  → round N+1 (다음 실행)
```

- 완전 무인 아님(7·8이 인간). "돌린다→검토→승인→재실행"이 한 라운드.
- 종료척도는 **코드가 계산**(이미 각 스캐너에 있음), 정지 판단은 보드로 사람이 확인.

---

## 6. 적대적검증 배치 편입 (갭#4)

- **엔진 verbatim 이식**(`hdx/foundation/engine.py`) = `_gate_harness.py` 범용화. 교정 전/후를 pricing.py와 동일 로직으로 독립 재계산 → 골든 재현 허용오차0·silent합산 0·저청구 0 재확인. 생성기와 다른 코드경로.
- **codex 2차(선택)**: `codex_gate.py`가 `codex exec -s read-only`로 교정본을 독립 판정·reconcile. 미가용 시 "Claude 단독" 명시 폴백. ← 배치가 codex를 부르는 최초 지점.

---

## 7. 단계적 구축 로드맵 (파일럿→전파)

| Phase | 산출 | 작업량(추정) |
|---|---|---|
| P1 | `hdx/foundation/`(snapshot·db·engine·models) 공용 토대 추출 | 중(복붙 재구현 통일) |
| P2 | 기존 6 스캐너 → Diagnoser 계약 어댑트 + 통합 결함보드 | **조립 수준** |
| P3 | Remediator 계약 통일(gen_*.py 승계·백업/게이트 내장) | 조립 |
| P4 | AdversarialVerify(engine 재실측) 배치 편입 | **신규(최대)** |
| P5 | 반자동 라운드 러너 + OptionCpqDx 신규 + codex_gate | 중 |

- **파일럿 = 가격 도메인 종단**(score_batch 클러스터 재사용) → 검증 후 판형·옵션·수량 전파.
- 각 Phase는 생성≠검증 별도 패스로 검수.

---

## 8. 확정 결정 (사용자 승인 260704)

1. **패키지 위치**: `_workspace/_foundation/hdx/`(횡단 토대). **확정**.
2. **배치 형태**: **순수 배치(python·실무진 직접 실행) + 얇은 오케스트레이터 스킬 1개**(적대검증·인간게이트·복잡 조율만). 새 전용 하네스 아님. **확정**.
3. **적대검증 편입**: **엔진 verbatim 재실측 먼저**(`_gate_harness` 범용화·결정론·토큰0), **codex 배치 호출은 P5 선택**. **확정**.
4. **파일럿 도메인**: **가격 도메인**(score_batch 클러스터=lib_huni 공유 11+ 스크립트 재사용 최적) 종단 후 전파. **확정**.
5. **결함보드 형식**: CSV+HTML(권장) — 미이견 시 채택.

### 확정 반영 빌드 순서
- 파일럿 = **가격 도메인 종단**: L1 foundation(snapshot·db·engine·models) → 가격 관련 Diagnoser(WiringDx·DimConformanceDx·ContributionDx·ComponentMergeDx·계산가능성) 어댑트 → 통합 결함보드 → Remediator 통일 → **엔진 재실측 적대검증**(codex 없이) → 반자동 루프.
- 오케스트레이터 스킬 1개 = 인간게이트·(P5)codex·복잡 라운드 조율만 담당. 진단/교정/보드/재실측은 순수 배치가 수행.
- 전파 = 가격 파일럿 검증 후 판형·수량·옵션CPQ 도메인.

---

## 부록 A. 재사용 자산 매핑 (search-before-mint)

| 신규 레이어 | 승계 원본 | 변형 |
|---|---|---|
| foundation/db | lib_huni.db() | 그대로 승격 |
| foundation/authority | authority.py | 그대로 |
| foundation/engine | _gate_harness.py | 아크릴 하드코딩 제거·범용화 |
| foundation/snapshot | wiring_scan/contribution_scan의 CSV 로더 | 공통 추출(복붙 제거) |
| diagnose/* | wiring_scan·dim_conformance·contribution_scan·diagnose_all·run_all·qty_rule_audit·component_merge_scan | 계약 래핑 |
| remediate/* | gen_fix.py·qtyrules/gen_sql.py·gen_remediation_sql.py | 규약 통일 |
| loop | wiring-rounds.csv 패턴 | 러너화 |
| verify/codex | hpe-codex-validate 등 스킬 로직 | 배치 훅화 |

## 부록 B. 미해결 리스크
- **완전 통합 vs 도메인 독립**: 4 미니 생태계를 한 프레임으로 강제 통합 시 초기 비용 큼. 완충 = 공통 계약만 맞추고 내부는 점진 이관.
- **옵션(CPQ) 차원**: 전용 스캐너 신규 필요(이번 세션 저청구 발견이 근거). 설계 미확정 영역.
- **상시 게이트 확장**: 현재 판형만 SQL 상시게이트. 타 차원도 상시 SQL 게이트화 여부.
