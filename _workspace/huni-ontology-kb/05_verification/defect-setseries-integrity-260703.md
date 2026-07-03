# 결함 보드 — 셋트 계열 확장 · 축 2: 그래프 무결성 + 연결 완전성

> Phase 4 적대적 검증가(okb-adversarial-verifier) · 2026-07-03 · 생성≠검증
> 대상 = 셋트 계열 신규 42 상품 노드 + 공유(Stage A 공식17·구성요소15·GAP9) + 축(Stage C1 신규58) + 배선(Stage C2 엣지132)
> 방법 = 그래프 재빌드 재실행 + 라이브 스냅샷(`_foundation/live-snapshot/latest`) awk 실측 + `04_graph/*.jsonl` 결정론 대조. 구축가 주장 비신뢰.

---

## 0. 통과(PASS)한 무결성 축 — 결함 없음

| 점검 | 방법 | 결과 |
|------|------|------|
| 그래프 재빌드 하드 0 | `python3 04_graph/build_graph.py` | `nodes=1142 edges=3534 hard=0 soft=530` ✅ |
| 멱등(2회 해시 동일) | 2회 빌드 | `nodes=dd19381b7b50e005 edges=6f2ec4b9541fffea` **양회 동일** ✅ |
| 42 상품 노드 전수 실재 | jsonl anchor 대조 | 42/42 · anchor `t_prd_products/PRD_000NNN` 전부 유효 ✅ |
| 은퇴 구성원 미생성 | 075/076/085/086/087/091/092/093 | 전부 ABSENT ✅ (오생성 0) |
| 071 = 셋트 미성립 GAP | product-071 노드 0 · `gap-071-set-notmembered` 실재 | ✅ (셋트 오모델 아님) |
| 캘린더 has_member 없음 | 108~112 has_member out=0 | ✅ (셋트 오모델 아님) |
| `member_of` 엣지 잔존 0 | 폐쇄어휘 검사 | 0 ✅ (스키마 R13 `has_member`만) |
| 폐쇄 관계어휘 19종 밖 엣지 0 | 엣지 rel 집합 − allowed | 0 ✅ |
| has_member 카디널리티 ↔ 팩 §1 | 부모별 구성원 대조 | 068/069/070=2·072/077/082=3·088=2·094=2·097=1·100=7 **전부 팩 일치** ✅ |
| index.md dead-link 0 | 199 md 링크 실존 검사 | 0 ✅ |
| 42 노드 index 도달성 | 36 파일 전부 index 링크(companion `-nodes.md` 규약) | 미링크 0 ✅ |
| L-20 셋트분 마스터앵커 단일소유 | 마스터테이블 앵커 중복 스캔 | 셋트 고유 위반 0 ✅ (074/079/084/090 optgroup=면지 재설계 멤버이관 정합 · qty·junction 규약은 전 KB 균일) |

> **면지 재설계(2026-07-03) 반영 확증:** `optgroup-{074,079,084,090}-membrane*` 노드가 각 면지 멤버(PRD_000074/079/084/090) 앵커로 실재 → 면지 옵션그룹 부모→멤버 이관이 그래프에 정상 반영. 은퇴 면지 멤버 미생성과 정합.

---

## 1. 결함 목록 (High/Medium/Low)

### [Medium] D-1 · priced_by 위조 — 095·096·098 구성원
- **노드:** `product-095-postcard-book-inner`·`product-096-postcard-book-cover`·`product-098-tteok-memo-inner`
- **유형:** priced_by 위조(forged edge) — O5 필수엣지를 라이브 미실재 바인딩으로 충족
- **증거(재현):**
  - 그래프: 세 노드 모두 `priced_by → formula-PRF_PCB_FIXED`(095/096) · `formula-PRF_TTEOKME_FIXED`(098)·`derived_from=[]`·badge=verified.
  - 라이브: `awk -F',' '$1=="PRD_000095,"' live-snapshot/latest/t_prd_product_price_formulas.csv` → **0행**. 096·098 동일 **0행**. (부모 094/097도 0행이나 부모는 팩 §3.10 "고정가형 부모 all-in" — 구성원 기여 0.)
  - 즉 구성원 자신은 라이브에 가격공식 바인딩이 **없음**. R8 `priced_by`는 `t_prd_product_price_formulas`(prd_cd=구성원) 실재를 앵커로 해야 하는데 미실재 → **위조**. O5(priced_by≥1)가 오직 이 위조 엣지로만 충족(제거 시 O5 FAIL).
- **동형 반증:** 같은 "고정가형 부모 all-in"의 100 포토북 표지 5종(102/103/105/106/107)·면지(104)는 **`derived_from → formula-PRF_PHOTOBOOK_FIXED`**로 정직 표기. 하드커버 링(083/084)·레더링(089/090)도 **`derived_from → 부모 product`**. 095/096/098만 priced_by로 어긋남.
- **돈영향:** 직접 없음(부모 all-in이 실제 가격 결정). 단 "이 구성원은 어떤 공식으로 값이 나오나" 질의에 **구성원 자체 공식이 있는 것처럼 오답** + 라이브 미실재 앵커(무결성 오염).
- **교정안:** 095/096/098의 `priced_by` 제거 → **`derived_from → 부모(product-094/097)`**로 재작성(083/084/089/090 동형). O5는 derived_from 경로로 정직 충족.
- **라우팅:** builder(Phase 4 재집필). 원천 결함 아님(라이브 정합 회복 가능).

### [Medium] D-2 · size-SIZ_000499 조용한 고아(중복 표현)
- **노드:** `size-SIZ_000499`(type=size · anchor `t_siz_sizes/SIZ_000499`)
- **유형:** 캐리어 없는 고아 + 중복 표현(silent orphan)
- **증거:**
  - 그래프: `size-SIZ_000499`로 들어오는 엣지 **0**(어떤 상품도 `has_size` 안 함). 별개로 `plate-SIZ_000499-gukc4`(type=plate_size)는 095/096/098이 `has_plate_size`로 정상 배선.
  - 라이브: `grep SIZ_000499 live-snapshot/latest/t_prd_product_sizes.csv` → **헤더만(0행)**. 즉 SIZ_000499를 재단/작업 사이즈로 쓰는 상품 없음(판형 `t_prd_product_plate_sizes`에만 존재). → `size` 노드는 캐리어 부재.
  - 빌드 리포트가 `I-1 고아 노드(연결 대기·Phase 4): size-SIZ_000499`로 방치 = **조용한 미완**(과업 금지 조항).
- **영향:** 그래프 오염(무용 고아). 질의 오답 위험은 낮으나 "고아=조용한 미완 금지" 위배.
- **교정안:** `size-SIZ_000499` 노드 삭제(판형 표현 `plate-SIZ_000499-gukc4`가 이미 실배선 담당) — SIZ_000499는 종이류 판형(국4절 output_paper)이므로 size가 아니라 plate로만 존재해야 함(도메인 규칙: 종이류만 판형·§3.8).
- **라우팅:** builder(Phase 4 노드 정리).

### [Low] D-3 · 제본 process 5종 조용한 고아 판정
- **노드:** `process-PROC_000001`(인쇄)·`PROC_000017`(제본)·`PROC_000021`(트윈링제본)·`PROC_000056`(접지)·`PROC_000098`(싸바리바인더)
- **유형:** 캐리어 없는 고아 — "연결 대기·Phase 4" 방치(조용한 미완)
- **증거·판정(라이브 실측):**
  - `PROC_000001/017/056` = **process-그룹 루트**(t_proc_processes 자식 다수: 017 제본→018중철/019무선/020PUR/021트윈링/023하드커버/098싸바리). `t_prd_product_processes` **0행** = 상품이 직접 안 씀(택소노미 루트).
  - `PROC_000098`(싸바리) = `product_processes` 0행. 088-redesign(pending·미COMMIT·GAP-SET-8)이 `COMP_BIND_SSABARI@PROC_000098` 컴포넌트 레이어로만 참조 → 상품-공정 캐리어 없음.
  - `PROC_000021`(트윈링) = `product_processes` **3행 = PRD_000071(셋트 미구성 GAP)·177·178(문구 셋트·범위 밖)**. 범위 내 42 상품 캐리어 **0**.
  - 결론: 5종 모두 **범위 내 상품 캐리어 부재 → 배선 불가**. 현재 소프트 고아로 방치됨(과업 "고아=조용한 미완 금지" 위배).
- **교정안:** ① 그룹 루트(001/017/056)는 `references`/택소노미 노드로 강등 or 명시 taxonomy 표기 ② 리프(098→`gap-088-redesign`·021→`gap-071`)는 해당 GAP 노드에 연결. 어느 쪽이든 "Phase 4 대기" 침묵 해소.
- **돈영향/답변오염:** 없음(가격·추천 경로 무관). 그래프 위생 + 규범 준수.
- **라우팅:** builder(강등/GAP연결) 또는 아키텍트 결정(택소노미 루트 허용 여부).

### [Low] D-4 · derived_from 타깃 이질(스키마 약일탈)
- **노드:** 073/074/078/079/102/103/104/105/106/107 (→ `derived_from → formula-…`) vs 083/084/089/090 (→ `derived_from → product-부모`)
- **유형:** 스키마 R17 사용 일관성 결여
- **증거:** 072/077 면지·표지 = `derived_from → formula-PRF_HC_MUSEON_SET` / 082/088 면지·표지 = `derived_from → product-082/088` / 100 표지·면지 = `derived_from → formula-PRF_PHOTOBOOK_FIXED`. 같은 "구성원 가격 파생" 의미인데 타깃이 공식/상품으로 갈림. (스키마 R17 정의 = (속성)→(속성)이라 둘 다 확장 사용이나, 혼용은 일관성 결함.)
- **영향:** 매우 낮음(질의 경로 동작). 그래프 규약 통일성.
- **교정안:** 한 규약으로 통일(권장 = `derived_from → 부모 product`, 083/084 방식) — D-1 교정과 함께 반영.
- **라우팅:** builder(선택 교정·저우선).

---

## 2. 격리(builder 교정 대상 아님) — 원천/승인/코드 C트랙

| 항목 | 노드 | 분류 사유 |
|------|------|-----------|
| 088 양면(796,900 vs 1,800,000) | product-088 | 088-redesign 인간 승인 대기(GAP-SET-8) — 양면 정직표기 정상 |
| 094/097/100 화면 0원 | product-094/097/100 | 셋트 UI siz_cd 미전파 코드 C트랙(DEV-REQUEST-set-sim-sizcd) — 엔진 골든 PRICE≠0, 가격사실 아님 |
| 069/070 _FOIL 박분기 | product-069/070 | base=active 정본·_FOIL=🟡 candidate(인간 승인 후) — 정직 표기 정상 |
| 071 셋트 미성립 | gap-071-set-notmembered | cover_mult ×2 엔진 BLOCKED(C트랙) — GAP 정상 |
| 068~070 코팅 드롭 | (골든) | price_views.py:1930 coat_side_cnt 미전달 C트랙 — PRICE≠0 무해 |
| design-calendar 고정가 미적재 | gap-cal-* | t_prd_product_prices 0행·원천 부재 — GAP 정상 |

> 위 6항은 라이브 급변·pending·코드결함을 그래프가 **양면/GAP로 이미 정직 표기**함(축5 연결완전성 관점 결함 아님).

---

## 3. 결론

- **축 2(그래프 무결성 + 연결 완전성) 판정 = DEFECTS(경미).** 하드 무결성(빌드·멱등·어휘·카디널리티·은퇴·GAP·index)은 전부 PASS. 결함 4건(Medium 2·Low 2)은 전부 builder Phase 4 재집필로 교정 가능(원천 격리 아님).
- **최중요 = D-1 priced_by 위조(095/096/098)** — 과업이 명시 경계한 "priced_by 위조" 실적발. O5 필수엣지가 라이브 미실재 바인딩으로 충족되어 있어, 동형(083/084/100표지)대로 `derived_from→부모` 재작성 필요.
- High 0.
