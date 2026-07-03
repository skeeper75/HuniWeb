# 적대적 검증 결함 보드 — 문구 셋트(SB-1) · 축 1: 출처 실재성 + 권위 정합 + 오염 적발

> **검증자:** okb-adversarial-verifier (Phase 4·생성≠검증) · 2026-07-03
> **범위:** SB-1 신규 25노드(부모 9 = 172/173/174/175/176/177/178/179/181 + 구성원 16 = 293~308)
> **방법:** 구축가 주장 비신뢰 — live-snapshot(snap_20260702_1119) 결정론 awk + 라이브 DB 실측 SELECT(@2026-07-03) 재대조.
> **판정 요약:** 권위 사실(공식 바인딩·단가행 셀수·값·177 conflict·구성원 역할)은 **전부 라이브와 일치·오염 0**. 결함 = **KB 표현(slug·정직표기) 2건**. 원천결함(sparse grid·사이즈 마스터 삭제)은 **격리**(staff/dbmap C트랙).

---

## ✅ 재대조 통과 (권위 정합·오염 — 결함 아님)

| 검증 항목 | 구축가 주장 | 재실측(라이브 SELECT/awk) | 판정 |
|---|---|---|---|
| PRF_STN_* 바인딩 9건 | 172~181 → PRF_STN_{DIARY_SOFT/HARD/LHARD/LSOFT/MONTHLY/SPRINGNOTE/SPRINGNOTEBK/MEMOPAD/JUNGCHEOL} | `t_prd_product_price_formulas` awk 9/9 일치 | PASS |
| has_component 배선 | 각 PRF_STN_* → COMP_STN_* 1:1(disp1·addtn Y) | `t_prc_formula_components` 9/9 일치 | PASS |
| 단가행 셀수(sparse) | 179 메모패드만 2셀·나머지 1셀 | live: MEMOPAD=2(5000/6000)·나머지=1 · 일치 | PASS |
| 173 하드 값 | 130x190 = 12,000 | live COMP_STN_DIARY_HARD: SIZ_000375(130x190)=12000 | PASS |
| 구성원 역할·유형 | 293~308 = .02 반제품·SEMI_ROLE 내지.01/표지.02/면지.03 | `t_prd_products`·`t_prd_product_sets` awk 16/16 일치 | PASS |
| **177 분류 conflict** | current prd_typ .02(라이브) / authority 셋트완제품 · **badge=defect 프론트매터 미사용(candidate+props+gap)** | 라이브 SELECT: 177 = PRD_TYPE.02 + sets 부모(2 구성원) 재확인. 노드 front matter `badge: candidate` + props(prd_typ_cd_live/prd_typ_authority) + `references gap-stn-177-classification` | PASS(과업 요구대로 정확 처리) |
| 오염(STALE) T-2/T-6/T-9 | — | 노드 인용 = pack + live-snapshot only. recipes ST-01~16 "현재결함" 오인용 0 · 단일 evaluate_price 오모델 0(전부 evaluate_set_price) · sparse "채워짐" 가정 0 | PASS(오염 미검출) |

---

## 🟡 결함 (KB 표현) — 교정 요망

### [D-1·Medium] 구성원 305/306/307/308 slug/id가 **부모 prd_cd**를 사용 — slug 정본[HARD] 위반

- **노드/파일:**
  `product/product-179-memo-pad-cover.md` (anchor `PRD_000305`)
  `product/product-179-memo-pad-inner.md` (anchor `PRD_000306`)
  `product/product-181-jungcheol-note-cover.md` (anchor `PRD_000307`)
  `product/product-181-jungcheol-note-inner.md` (anchor `PRD_000308`)
- **유형:** 출처/식별 정합(id↔anchor prd_cd 불일치·[HARD] 규칙 위반)
- **증거(재현):**
  - pack §1 line 52 [HARD] `slug 정본 = product-NNN-kebab` (NNN=자기 prd_cd) · 구성원 = `product-NNN-<부모>-<역할>`.
  - 형제 12구성원(293~304)은 전부 자기 prd_cd 사용: `product-301-spring-note-cover` (anchor PRD_000301). {`awk 'id:|anchor:' product-30[1-4]*.md`}
  - 그러나 305~308은 **부모 prd_cd(179·181)** 사용: `id: product-179-memo-pad-cover` ↔ `anchor: PRD_000305`.
  - 재현: `grep -E '^id:|^anchor:' product-179-memo-pad-cover.md` → id=179 / anchor=PRD_000305 (불일치).
- **영향:**
  1. **자기 prd_cd 미해소** — 구성원 자기번호(305~308)를 slug 규약(`product-<own>-…`)으로 조회하면 노드 미발견.
  2. **접두 충돌** — `product-179-*` 접두가 서로 다른 3개 prd_cd(부모 179 + 구성원 305/306)에 걸침 → 1 slug ↔ 1 prd_cd 불변식 파손. 181/307/308 동일.
  3. **비일관** — 16구성원 중 12는 자기번호·4만 부모번호(비균질).
  ※ 부모 has_member `target`이 명시 id로 배선돼 **그래프 엣지는 정상 해소**(끊긴 엣지 아님) → Medium.
- **교정안:** 4파일 rename + front matter `id:` = `product-305-memo-pad-cover`/`-306-…-inner`/`product-307-jungcheol-note-cover`/`-308-…-inner`, 부모 179/181 has_member `target` 및 그래프 재빌드 동반. (형제 301~304 패턴에 정합)
- **라우팅:** okb-knowledge-builder(자기교정·rename) → build_graph 재빌드.

### [D-2·Medium] 176 먼슬리·177 스프링노트 노드가 **유일 sparse 셀의 사이즈(SIZ_000170·마스터 논리삭제)를 정상 사이즈로 표기** — 정직표기 비일관

- **노드/파일:** `product/product-176-monthly-planner.md` · `product/product-177-spring-note.md` · (교차)`axis/sizes.md`
- **유형:** 정직표기 정합(양면 disclosure 누락·형제 불일치)
- **증거(재현):**
  - 라이브 SELECT: `COMP_STN_MONTHLY` 유일셀 = SIZ_000170=12000 · `COMP_STN_SPRINGNOTE` 유일셀 = SIZ_000170=4500 · **`t_siz_sizes.SIZ_000170.del_yn=Y`(마스터 논리삭제 2026-06-17)** (`refs_deleted_size = t`).
  - 176 노드 `has_size` note = `"A5 148x210(dflt·부모 레벨)"`, sparse 서술 = `"등록 사이즈 PRICE≠0 가능"` — **마스터 삭제 미고지**.
  - 177 노드 동일(has_size SIZ_000170 note 삭제 언급 없음).
  - **대조:** 형제 181 중철노트는 동일 상황(SIZ_000196 A6 마스터 삭제)을 `has_size` note에 `"마스터 논리삭제이나 load-bearing"`으로 **정직 고지** → 형제 간 표기 불일치.
  - `axis/sizes.md`는 `[size-SIZ_000170] … {defect}`로 양면 포착하나 **근거 src가 스티커 PRD_000052만 인용**(176/177 문구 미포함) → 176/177 노드 독자는 유일 견적 사이즈가 은퇴 사이즈임을 알 수 없음.
- **영향:** "공식 존재≠가격 완성" 정직표기가 형제(181)보다 낙관적. 유일 견적 셀이 은퇴 사이즈 위에 있음(junction 활성이라 견적은 됨 → 값 오류 아님·격리). KB의 결함 disclosure 일관성 파손.
- **교정안:** 176/177 `has_size` SIZ_000170 note에 `마스터 del_yn=Y(2026-06-17)·junction 활성·load-bearing` 추가(181 문구 계승). `axis/sizes.md` SIZ_000170 defect src에 (PRD_000176/PRD_000177) junction 추가.
- **라우팅:** okb-knowledge-builder(정직표기 보강). 사이즈 마스터 삭제 자체 정리(junction vs 마스터 복원 택1)는 **격리**(dbmap/실무진 C트랙).

---

## 🔒 격리 (원천결함 — KB 결함 아님)

- **문구 셋트 완제품가 sparse grid(1~2셀)** = 상품마스터 문구 시트 미충전(원천부재) → gap-stn-sparse-grid(dbmap/§26). KB는 candidate+gap로 정직 표기함(정상).
- **SIZ_000170(A5)·SIZ_000196(A6) 마스터 논리삭제 + junction 활성** = 사이즈 재키잉 파손복구 잔존 의심(실무진 확인) → 라이브 데이터 정리 C트랙. KB 표기 책임은 D-2로 한정.

---

## 반환 요약
- high 0 · medium 2 · low 0
- 권위 정합·오염 = 전부 PASS(라이브 재실측 일치·오염 0). 177 conflict 처리 = 과업 요구대로 정확.
- 결함 = KB 표현 2건(D-1 slug HARD 위반 4노드 · D-2 삭제사이즈 정직표기 비일관 2노드) → okb-knowledge-builder 자기교정.
