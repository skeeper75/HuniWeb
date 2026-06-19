# reconcile — 공정축 표시중복 정리 Claude↔codex 교차검증 (D4 게이트)

생성: 2026-06-19 / hbd-codex-verifier / codex 가용성: **AVAILABLE model=gpt-5.5**
입력: Phase 2 산출(mapping.csv·dedup-report.md·apply-plan.md) · codex-verdict.md · pricing.py 라이브 코드 보강
권위: 라이브 t_* 실측(Phase 1 캐시) + pricing.py 엔진 코드. codex 주장=가설(검증 전 채택 금지·환각 경계).

---

## 1. 행별 reconcile 매트릭스

| # | 그룹(코드) | Claude 판정 | codex 판정 | 합의 여부 |
|---|---|---|---|---|
| 1 | 반칼 087 (→054) | merge(del_yn=Y·pd=N) | safe-to-merge | ✅ 합의 |
| 2 | 봉제 088 (→080) | merge | safe-to-merge | ✅ 합의 |
| 3 | 부착 089 (→081) | merge | safe-to-merge | ✅ 합의 |
| 4 | 완칼 091 (→053) | merge | safe-to-merge | ✅ 합의 |
| 5 | 족자제작 093 (→082) | merge | safe-to-merge | ✅ 합의 |
| 6 | 스티커완칼 094 (→055) | merge | safe-to-merge | ✅ 합의 |
| 7 | 에폭시 095 (→083) | merge | safe-to-merge | ✅ 합의 |
| 8 | 열재단 096 (→084) | merge | safe-to-merge | ✅ 합의 |
| 9 | UV 097 (→002) | merge | safe-to-merge | ✅ 합의 |
| 10 | 핑크 010/036 | keep(정당구분) | keep(AGREE) | ✅ 합의 |
| 11 | UV 002/016 | keep(정당구분) | keep(016 merge DISAGREE=016 보존) | ✅ 합의 |
| 12 | 미싱 030/086 | BLOCKED(comp30) | BLOCKED(삭제금지) | ✅ 합의(액션) |
| 13 | 오시 029/090 | BLOCKED(comp50) | BLOCKED(삭제금지) | ✅ 합의(액션) |
| 14 | 타공 079/092 | BLOCKED(comp18) | BLOCKED(삭제금지) | ✅ 합의(액션) |

**합의 14 / 14 — divergence 0(액션 기준).**

추가 검토(false-negative 헌팅) 합의:
- PROC_000016: codex 독립 판정도 keep(097과 부모 상이) → Claude keep 보강. 진짜중복 오승격 0.
- PROC_000085/031/032 가변데이타: codex out-of-scope 동의 → 표시중복 후보 아님.

---

## 2. divergence — 액션은 합의, 단 "근거 서술"에 1 nuance

**유일 nuance (Q3-a)**: codex가 BLOCKED 3건의 *근거 서술* 중 Claude의 "엔진이 부모로 조회 시 0행=가격 미산출"을 **과단정**으로 지적. proc_grp 확장조회/fallback 존재 가능성을 SELECT만으론 배제 못 한다는 신중론.

→ **이것은 적재 액션 divergence가 아니다**(양쪽 모두 "자식 삭제 금지"=BLOCKED 합의). 단지 BLOCKED 사유 문구의 확정성 문제.

### Claude의 codex nuance 해소 (라이브 pricing.py 직접 검증)
- `pricing.py:404,466`: 엔진은 `sel["proc_cd"]`(선택 공정코드)로 component_prices를 **정확 일치 조회** — 부모→자식 fallback **없음**.
- `pricing.py:460`: `proc_grp:` use_dim은 `":" in d` 필터로 매칭축에서 **제외**(메타데이터) — codex가 가설한 "proc_grp 확장조회"는 **엔진에 부존재**.
- 판정: codex의 신중론(자동해소 경로 가능성)은 **코드로 기각** → 단절은 실재. 단 이 결과는 BLOCKED를 **강화**(단절 실재 → 자식이 미싱/오시/타공 가격의 유일 키 → 삭제 절대 금지).
- ★잔여: "런타임에 UI가 부모 proc_cd를 proc_sels로 넘기는가"는 위젯/뷰 레이어 추가 확인 사항(dedup 액션과 독립). 본 dedup은 어느 경우든 자식 삭제 금지로 동일 귀결.

→ nuance 해소 완료. **미해소 divergence 0.**

---

## 3. codex 단독 가설 (미검증·채택 보류)

- **Q3-b "comp.proc_cd를 부모로 옮기는 게 더 안전"**: 가격축 재배선 제안. 본 dedup 범위 밖 → dbm-price-arbiter/경로Y escalate 라우팅만 수용(교정안 자체는 미채택).
- **Q3-c "자식 가격행=사고 가능성 높음"**: v03 적재 oracle 확인 전 미확정. 판정 영향 0.

이 2건은 BLOCKED 액션에 영향 없음(escalate 큐로 그대로 이송).

---

## 4. 최종 안전 적재 대상 (합의분만 — D4 통과)

### ✅ GO — safe merge 9건 (del_yn='Y' 논리삭제, Claude·codex 합의)
```
PROC_000087 · 088 · 089 · 091 · 093 · 094 · 095 · 096 · 097
```
- 조건[HARD]: del_yn='Y'만 · 단가행 이동 0 · 바인딩 재배선 0 · 정본 부모 무변경(codex 강조 "merge 표현 위험"=실 작업은 논리삭제만 — apply-plan.md §3 SQL 본문 정합).
- 멱등 가드 WHERE del_yn='N' · 백업 bak_proc_dedup_merge_20260619 · 사후검증 V1~V3(apply-plan.md §4).
- 외부참조 0 실증(`_price_dep.csv`에 087~097 부재·`_prd_bind.csv`에 부재) → 무손실·CASCADE 무관.

### ⛔ BLOCKED — 적재 금지 3건 (Claude·codex 합의)
```
PROC_000086(미싱·comp30) · 090(오시·comp50) · 092(타공·comp18)
```
- 논리삭제 시 가격 98행 전손. 가격축 재배선은 dbm-price-arbiter/경로Y escalate(본 dedup 비대상).
- pricing.py 검증: 부모↔자식 가격키 단절 실재(자동해소 경로 부재) → 삭제 금지 결론 강화.

### 🔒 KEEP — 정당구분/보존 (통합 금지)
```
핑크 010/036(부모 별색007 vs 박033) · UV 002/016(독립 vs 코팅013) · 085/031/032 가변(별개 부모)
```

---

## 5. D4 게이트 판정

| 기준 | 결과 |
|---|---|
| codex 가용성 | **AVAILABLE gpt-5.5** (폴백 불요) |
| Claude↔codex reconcile | 14/14 액션 합의 · divergence 0 |
| 미해소 divergence (적재 차단 사유) | **없음** (Q3-a nuance는 pricing.py로 해소) |
| codex 환각 경계 | 인용 사실 전부 라이브 캐시 일치·날조 0 · 단독 가설 2건은 채택 보류(BLOCKED 영향 0) |
| false-negative 헌팅 | codex 독립도 016 keep·085 out-of-scope 동의 → 진짜중복 오승격 0 |

→ **D4 PASS.** 합의분 9건(del_yn='Y') 안전 적재 가능(인간 승인 후 hbd-load-execution 위임). BLOCKED 3건·KEEP은 적재 제외.

★사이즈 교훈 계승 확인: 사이즈 축에서 codex 2차가 Claude의 NO-OP를 뒤집은 사례와 달리, 공정축은 codex가 Claude 판정을 독립 재현·합의(특히 BLOCKED 분리·016 false-positive 가드를 codex도 동일 도출). 일괄흡수 회피(086/090/092를 comp 보유로 분리·016을 코팅축으로 keep)가 양 검증자에서 일관 → 고신뢰.
