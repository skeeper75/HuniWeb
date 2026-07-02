# 오염 차단 목록 (blocklist) — Huni-Ontology-KB

> 작성: 2026-07-03 · okb-knowledge-builder (검증 라운드 1 결함 V1-02/V1-01 교정 — 게이트 원천 실체화)
> 권위: `01_curation/source-registry.md` §8 STALE 인용 금지 목록 + 오염 4종(방법론 O2/I-6).
> 역할: `04_graph/build_graph.py`의 `load_blocklist()`가 이 파일을 읽어, 정본 노드의 `sources`가
>   금지 원천을 인용하면 빌드를 FAIL(하드) 또는 경고(어드바이저리)한다. **이 파일이 없으면 빌드는
>   조용히 통과하지 않고 하드 FAIL** — "검사 원천 없음"을 PASS로 위장하지 않기 위함(V1-01B 교정).

---

## 읽는 법 (기계 파싱 규약)

빌더는 아래 토큰 라인만 읽는다(설명 문장은 무시). 형식:

```
- <hard|advisory> <src_id|path>: <값>
```

- `hard` = 사실 근거로 인용 시 **빌드 FAIL**. `advisory` = 배경 서술로만 허용, 인용 시 **소프트 경고**.
- `src_id` = 노드 source의 `src_id` 값과 정확히 일치하면 히트.
- `path` = 노드 source의 `source_file` 경로에 이 문자열이 **부분 포함**되면 히트(경로 기반 = src_id 우회 방지).
- 현재 정본(`03_kb/`)에는 아래 어떤 원천도 인용되지 않음(2026-07-03 실측 0) — 이 목록은 **회귀 방어**(향후 STALE 인용 조용한 유입 차단)용.

---

## HARD — 사실 근거 인용 금지 (source-registry §8 #1·2·4·7·10)

> 어떤 이유로도 사실 근거로 인용하면 빌드 FAIL. 대체 소스는 §8 참조.

- hard path: prdmaster_full_migration_v03
- hard src_id: SR-STALE-v03
- hard path: price-engine-ddl.md
- hard src_id: SR-STALE-price-engine-ddl
- hard path: huni-widget/03_spec/huni-db-mapping.md
- hard src_id: SR-STALE-huni-db-mapping
- hard path: 후가공_박(백업)
- hard src_id: SR-STALE-bak-baking
- hard path: ~$
- hard src_id: SR-STALE-xlsx-lock

## ADVISORY — 배경 서술로만 허용(사실 근거 금지·소프트 경고) (source-registry §8 #3·5·6·8·9)

> §8이 "설계 의도 배경 서술로만 허용"한 원천, 또는 경로만으로는 정오 판별이 불가한 content 규칙.
> 인용 시 소프트 경고 — 사람이 "배경 서술인지 사실 근거인지" 검토(게이트 O2 수동 판정 보조).

- advisory path: prcx01-pricing-model.md
- advisory src_id: SR-STALE-prcx01
- advisory path: pricing-erd.md
- advisory src_id: SR-STALE-pricing-erd

---

## 경로로 못 잡는 오염(내용 규칙 — 게이트 수동 판정) 

아래는 경로/ src_id 부분 매칭으로 자동 차단 불가. 검증가(okb-adversarial-gate O2·O3)가 원문 대조로 수동 판정한다. 자동 lint 대상이 아니므로 위 토큰 라인에 넣지 않는다.

- 위키 각 페이지 상단 **STALE 마킹분**(constraint_json·dep_proc_cd·excl_groups 등 삭제 컬럼/테이블 서술) — source-registry §8 #5. 대체=live-snapshot 컬럼 실측 + `raw/webadmin/sql/18~23_*.sql`.
- **구 260610/260527 수치의 무대조 인용** — §8 #6. `26_change-tracking-260702/` diff 65행 대조 후에만 인용. 06_extract L1 캐시 자체는 정당(diff 없는 셀=260702 동일).
- 위키 `recipes`의 **round-13 결함 목록을 "현재 결함"으로 인용** — §8 #9. 7월 초 교정 COMMIT 다수. live-snapshot 재실측 + 각 하네스 HANDOFF 최신분으로 재판정.
- `docs/reversing` 4월 초판 위젯 캡처·분석 — §8 #8. 6월 재역공학(redo-260623)·`_latest`가 대체.

---

## Sources
- `01_curation/source-registry.md` §8 (STALE 인용 금지 목록 — 이 blocklist의 권위)
- `02_ontology/file-format-spec.md` §5.2 O2 · `graph-build-spec.md` §5.6 I-6 (오염 검사 하드 규칙)
- `.claude/skills/okb-adversarial-gate/SKILL.md` §2.3·§4 O3 (오염 적발 축)
