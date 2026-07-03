# 결함 보드 — 아크릴 확장 · 축 2: 그래프 무결성 + 연결 완전성 + L-3/L-12/O5 건전성

> Phase 4 적대적 검증가(okb-adversarial-verifier) · 2026-07-04 · 생성≠검증
> 대상 = 아크릴 신규 25 상품 노드(146~166 minus 167 + 168/169/170/226) + 공유(Stage A 공식·구성요소·gap) + 축(Stage C 사이즈10·CAT_000163) + 배선
> 방법 = 그래프 재빌드 2회(멱등 해시 대조) + `04_graph/*.jsonl` 결정론 대조 + `01_curation/_cache/acryl-*-260704.csv` awk 실측(구축가 주장 비신뢰). 라이브 읽기전용·손전사 금지.

---

## 0. 통과(PASS)한 무결성 축 — 결함 없음

| 점검 | 방법 | 결과 |
|------|------|------|
| 그래프 재빌드 하드 0 | `python3 04_graph/build_graph.py` | `nodes=1486 edges=4571 hard=0 soft=712` ✅ |
| 멱등(2회 해시 동일) | 2회 빌드 | `nodes=256b103f0267829c edges=7cf5a9b57d1561e0` **양회 동일**(baseline 일치) ✅ |
| 25 상품 노드 전수 실재 | jsonl 대조 | 146~166(−167)+168/169/170/226 = 25/25 · anchor `t_prd_products/PRD_000NNN` 전부 유효 ✅ |
| 167 결번·171 del_yn=Y 미생성 | product 노드 스캔 | 둘 다 ABSENT(오생성 0) ✅ |
| 142/143(스티커)·223(PVC) 혼입 없음 | universe 대조 | 본 팩 대상 아님·별도 팩 소속 ✅ |
| `member_of` 엣지 잔존 0 | 폐쇄어휘 검사 | 0 ✅ (스키마 R13 `has_member`만·전 아크릴 단품 has_member 0) |
| 폐쇄 관계어휘 밖 엣지 0 | 엣지 rel 집합(17종) − allowed | 0 ✅ (member_of 없음) |
| L-1 파일명↔id(25 신규) | build hard 게이트 | 위반 0 ✅ (magsafe-smart-tok/photocard-corotto 등 비-acryl 슬러그 포함 전부 일치) |
| 비종이 has_plate_size = 0 | acryl 25 노드 has_plate_size out | **0** ✅ (plate_sizes 51행은 props note 양면 표기·엣지 미생성·T-9 준수) |
| index 25상품 등재 | index.md 링크 실존 | 25/25 각 1링크 ✅ |
| index 공유축 등재 | acrylic-formulas/components + axis material/proc/size/cat | 전부 링크 실존 ✅ |
| **dead-link(실 dst) 0** | 전 엣지 dst node_ids 대조 | **실 dst 미해결 0** ✅ (아래 §2 참조) |
| 아크릴 신규 엣지 dst 해소 | acryl 25 노드 out-edge 221건 | UNRESOLVED **0** ✅ (has_size80·priced_by25·references28·uses_material27·has_process19·in_category29·option_group12·qty_rule6) |
| **L-3 사이즈 단일소유** | 제네릭 siz 정의수 | SIZ_000330·333·011·329~336·148 = **각 1 정의**(axis/sizes.md) ✅ (Stage C 통합 완료·L-20 통과) |
| L-20 아크릴 마스터앵커 중복 | 앵커 소유권 스캔 | 아크릴 고유 위반 **0** ✅ (검출된 4 dup=SIZ_521/057/170/520=기존 셋트계열 053/054/058/062·비-아크릴 격리) |
| **needs_axis 11 민팅** | 사이즈10+CAT_000163 노드 실재 | 11/11 실재(size-SIZ_000329~336·011·148 + category-CAT_000163) ✅ |
| **O5 가격사슬 25/25** | priced_by/가격gap 유무 | 전 25 충족(build O5 hard 0) ✅ (아래 §1 정렬 분석) |
| O6 고아 공식 0 | acryl 공식 has_component | TBD 4공식→`COMP_ACRYL_PENDING_TBD`·MINIPART→`COMP_ACRYL_MINIPART_TBD` 배선 ✅ |
| L-12 본문 숫자 건전성 | 32건 acryl L-12 + 캐시 verbatim 대조 | **전부 정당**(§1.2) ✅ · L-16(손전사 의심) acryl **0건** |
| uses_material substrate 한정 | 27 uses_material 엣지 | substrate만(MAT_042/043/044/192/195/196)·부속(자석/핀/집게 MAT_047/048) 미배선(T-8 준수) ✅ |
| 공유축 fan-in 정합 | COMP_ACRYL_CLEAR3T 공유 | 4공식(PRF_CLR_ACRYL+M2 CLIP/HAIRBAND/MAGNET)→**13상품 공유**(팩 §1.1 일치) ✅ |

---

## 1. O5 정렬 분석 (아크릴) — gap 남용 없음 확증

### 1.1 O5 충족 경로 (전 25상품)

| 그룹 | 상품 | O5 충족 경로 | gap 사용 |
|------|------|-------------|----------|
| M1 면적본체 | 146·148·150·151·152·157·158·159·161·162 | `priced_by→PRF_CLR_ACRYL`(COMP_ACRYL_CLEAR3T 277셀) | **미사용**(priced_by만) ✅ |
| M2 면적+부속 | 147·149·154 | `priced_by→PRF_ACRYL_{MAGNET,CLIP,HAIRBAND}` | 미사용 ✅ |
| M3 고정가형 | 153·155·160·166 | `priced_by→PRF_ACRYL_{NAMETAG_GS,BALLPEN,FREESTAND,CARABINER}`(단가행 3~5) | 미사용 ✅ |
| M5 코롯토 | 164(미출시·36행) | `priced_by→PRF_COROTTO_ACRYL` | 미사용 ✅ (실단가 실재→gap 불필요) |
| 지비츠 | 156(2행) | `priced_by→PRF_ZIBITZ_ACRYL` | 미사용 ✅ |
| TBD 0행 | 165·168·169·170(전 미출시) | `priced_by→PRF_ACRYL_*_TBD` **+** `references→gap-acryl-tbd-formula-no-priced-rows` | 가격 gap(정당) ✅ |
| placeholder | 163(단가행 1·10,000 placeholder) | `priced_by→PRF_ACRYL_MINIPART` **+** `references→gap-acryl-tbd-...`(양면) | 가격 gap(정당·양면) ✅ |
| 226 재바인딩 | 226(미출시) | `priced_by→PRF_GOODS_FIXED_SIZ`(공유 77셀) **+** `references→gap-226-acryl-tbd` | 가격 gap(정당·§1.3) ✅ |

**판정:** 면적/고정가형/코롯토(실단가 실재)는 **priced_by 단독으로 O5 충족·gap 미사용** → "가격 실재 상품의 O5 부정직 회피" 남용 **없음**. gap 노드는 오직 단가행 부재(TBD 4)·placeholder(163)·자기 siz 단가 0(226)에서만 사용. gap 슬러그 2종 모두 **가격류 gap**(graph-build-spec v1.0.5 화이트리스트 정합·비가격 gap 우회 없음).

### 1.2 L-12 본문 숫자 정당성 판정 (32건 전부 ①정당)

캐시 verbatim 대조로 **날조 0** 실증:
- 고정가형 범위: 153=3,400~4,700(3행)·155=1,800~2,700(3행)·160=8,800~22,600(5행)·164=3,600~8,400(36행)·166=5,800~6,900(4행) — **`acryl-price-chain-260704.csv`와 완전 일치**.
- addon 단가: 148 원형핀 600·1구자석 1,000·146 볼체인 8종×1,000 — **`acryl-addon-templates-260704.csv`와 일치**.
- 면적 요약 "277셀·2,000~32,700" = use_dims 차원요약(D-22 접기).
- STALE 경고문 "146 키링=480,000·590,000·330/380/300k = 라이브 부재·인용 금지"(T-1) = 경고 인용(정당).
- 163 "current=10,000(placeholder)/authority=미정" = 양면 정직 표기.
→ 전부 정당(use_dims props·차원요약·STALE 경고·addon 단가·placeholder 양면). raw 단가 손전사·transcribed-by 누락 **0건**(L-16 acryl 0).

### 1.3 gap-226-acryl-tbd 정당성 (양면 이중 O5)

226=§23 재바인딩본(PRF_GOODS_FIXED_SIZ→COMP_GOODS_FIXED_SIZ 77셀 공유·`priced_by` 실재로 O5 충족). 그러나 자기 인쇄면 3사이즈(SIZ_000611/612/613·has_size 배선 확인)에 대응하는 component_prices 단가행 **0건** = 자기 siz 견적 불가 → 가격 gap 정직 표기. **미출시(use_yn=N)**·팬텀 가격 금지. priced_by도 실재해 O5는 이중 충족 → gap이 O5 회피용 아님(정직 보강). ✅

---

## 2. "dead-link" 정밀 판정 — 실 결함 아님(설계 예외)

전 엣지 dst 대조 시 19건이 미해결처럼 보이나 **전부 `alias_of` 투영 라벨**(`aliaslabel:UP수→TERM_pansu` 등):
- src=`aliaslabel:*`는 **노드가 아닌 투영 라벨**(build_graph.py:52·410 I-2 src 예외·"src=투영 라벨·노드 아님").
- **dst(TERM_pansu·TERM_die_cut 등 7종)는 전부 실재 노드** — 실 dst dead-link **0**.
- 전부 `_glossary.md` 용어(pansu/die-cut/spot color/digital print/corner round/plate/atomic sum) = **아크릴 무관·기존 시스템 패턴**(격리).
→ **실 dead-link 0**·아크릴 신규 relations 타깃 전부 해소. build hard=0과 정합(I-2 dst 위반 없음).

---

## 3. 결함 목록 (High/Medium/Low)

### High
- **없음.**

### Medium
- **없음.**

### Low

#### L-AC-1 [Low·격리 후보] 226 uses_material — 라이브 7 글리터 중 4만 배선(dflt_yn=N만)
- **노드:** `product-226-acrylic-shaker-corotto`
- **현상:** uses_material 배선 = `MAT_000310/312/314/315`(핑크/화이트/블루/블랙 글리터·MAT_TYPE.09·dflt_yn=N). 라이브 `acryl-prod-materials-260704.csv`는 226에 **7행**(309/310/311/312/313/314/315·dflt_yn: 309·311·313=Y / 310·312·314·315=N). 즉 **dflt_yn=Y 3종(309/311/313) 미배선** + dflt_yn=N 4종만 배선.
- **판정=격리/정직 방향:** ① 배선된 4종은 `acryl-materials-named-260704.csv`에 이름 있는 것들(309/311/313은 무명 → 노드 소재 부재로 미민팅 방어적 정당). ② 226=**미출시(use_yn=N)**·§23 글리터=**무가 CPQ** → 가격 무영향. ③ 글리터 MAT_TYPE.09 오타이핑은 팩 §3.5가 명시한 **§7 위임 원천결함**(현재값 기록). → 그래프 무결성 파손 아님(전 dst 해소·dead-link 0). **Low 관찰**로만 기록.
- **격리 근거:** 원천결함(무명 자재·mat_typ 오타이핑·§7)·미출시·무가. builder 교정 대상 아님.

---

## 4. 격리(builder 교정 대상 아님) — 원천/기존 결함

| 항목 | 성격 | 소유 |
|------|------|------|
| `alias_of` 투영 19건 "미해결 src" | 설계 예외(build_graph.py:52/410)·기존 glossary 패턴 | 시스템(비결함) |
| L-20 dup 4(SIZ_521/057/170/520) | 기존 셋트계열(053/054/058/062) 소프트·아크릴 무관 | 셋트 계열(기존) |
| 226 글리터 MAT_TYPE.09 오타이핑 | 자재 유형 오타이핑(원천) | §7/§12 |
| TBD 4 단가행 0(165/168/169/170) | 실무진 단가 BLOCKED | 실무진(GAP-AC-5) |
| 아크릴 공정 MISSING 10상품 | 공정 미적재(원천) | §7(GAP-AC-2) |
| plate_sizes 51행(비종이) | 생산메타/오적재 판정 대기 | §7/§29(GAP-AC-3) |
| CPQ 옵션 items 미적재·제약 0행 | 원천 미적재 | §31(GAP-AC-4) |

이들은 **정직 표기가 정당**하면 결함 아님 — builder는 라이브 현재값을 충실 기록(팬텀 0·양면 표기).

---

## 5. 종합 판정 — 축 2

**GO(PASS).** 아크릴 25 신규 노드 + 공유축의 그래프 무결성·연결 완전성·L-3/L-12/O5 건전성 **결함 없음**(High 0·Medium 0·Low 1=격리 관찰).
- hard=0·멱등(256b103f)·member_of 0·폐쇄어휘·실 dead-link 0·비종이 plate 0·index 전수 등재.
- L-3 제네릭 사이즈 단일소유 통합·needs_axis 11 민팅 완료.
- L-12 32건 전부 캐시 verbatim 정당(손전사 0·L-16 0).
- O5 25/25 충족·gap 남용 0(면적/고정가형 priced_by 단독·TBD/placeholder/226만 가격 gap).
- 유일 Low(226 글리터 4/7 배선)는 원천결함·미출시·무가 → 격리.
