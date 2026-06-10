# 책자 — 매핑 확정 독립 게이트 (round-12 M1~M6)

> **검증자** `dbm-validator`. **작성** 2026-06-10 · **재게이트** 2026-06-10(D-BK-1 보정 후 M5만). 증거 동반 판정. DB 쓰기 0.

## 게이트 매트릭스 (재게이트 반영)

| # | 게이트 | 판정 | 핵심 증거 |
|---|--------|:----:|-----------|
| M1 | 커버리지 | **PASS** (carry-fwd) | L1 헤더 직접 카운트(43 의미컬럼) |
| M2 | 권위 인용 실재 | **PASS** (carry-fwd) | 표본 7행 |
| M3 | 실무진 정합 | **PASS** (carry-fwd) | Q3/Q4/Q5/Q9 반영 |
| M4 | 오모델 부재 | **PASS** (carry-fwd) | OM 점검·기계적 변경 회피 |
| M5 | 라이브 실측 | **PASS** (1차 FAIL→보정→재게이트) | 레더 3-way 보정 독립 재실측 일치 |
| M6 | 외부 갭 처분 | **PASS** (carry-fwd) | 3 갭 전부 처분+Sources |

**판정: GO** (D-BK-1 RESOLVED — M5 재게이트 PASS. M1~M4·M6은 1차 게이트 PASS carry-forward, 재검 불요)

---

## M1 커버리지 — PASS
`06_extract/booklet-l1.csv` 54 컬럼 = 파서/메타 11(sheet·row_seq·prd_nm·_anchor_ffilled·_row_hidden·_work_size_col·_work_size_value·AR·AS·AT·cell_meta_json) + **의미 43**(C1~C43). mapping-final §1 = C1~C43 전수 행 존재. 제외 사유 명기(파서 스캐폴딩 11). **누락 0.**

## M2 권위 인용 실재 — PASS
표본(라이브 재실측):
- C30 박칼라 → `PRD_000069` 박 processes = PROC_000037~044(홀로그램~트윙클) 8종 실재 재확인 ✓. (박 family root PROC_000033은 16자식 034~049, 책자 엑셀은 037~044 서브셋 사용 — 서술 정확)
- C26 코팅 → PROC_000013 코팅·014유광·015무광 재확인 ✓
- C28 형압 → PROC_000050 형압 재확인 ✓
- 제본 family PROC_000017 자식·mand=N → live-crosscheck 쿼리 재현 가능(N|9)
- C33/34/35 면지/링/D링 자재 usage → (mapping-final 인용·일관)
- option_groups 0행(GAP-OG) → 일관
- 레더(C24) → §M5 참조(부분실측). 날조는 없으나 불완전.

## M3 실무진 정합 — PASS
- **Q3 ★**(반제품=제본 전체관점) → 하드/레더/하드링/레더바인더 sub_prd+sets + 일반책자 parent usage 병행 모델 반영 ✓
- **Q4**(레더=자재+용도 표지) → C24 usage=USAGE.02 표지 반영(자재유형은 CONFLICT-1 — §M5) ✓
- **Q5 ★**(부속=시트별 확인 후 귀속) → 링/D링/투명커버 전부 자재(usage .05/.07) 라이브 권위 ✓
- **Q9**(코팅=공정) → C26 PROC_000014/015 ✓
- Q2(박=공정) → C30 PROC_000037~044 ✓

## M4 오모델 부재 — PASS
색=siz 없음·size↔option 혼동 없음·이중의미 평면화 없음. 떡메모지 page_rule 3/3/3(CONFLICT-2)은 **침묵 삭제 금지**(round-10 교훈) 준수 — escalate로 정직 처리. 제본 택일그룹 GAP-OG는 "상품=제본 1:1이라 불요"로 정직 철회(과적재 회피). 기계적 .06 변경 금지 명시(OM 회피). 매핑 오모델 재발 0.

## M5 라이브 실측 — PASS (1차 FAIL → 보정 → 재게이트)

### 재게이트(2026-06-10) — D-BK-1 보정본 독립 재실측 4기준
- **기준1 3-way 전수:** `SELECT … count(pm.prd_cd) … WHERE mat_nm ~ '레더' GROUP BY` 재실측 = 006 .01종이 link1 · 008/173/174/175 .06가죽 link0(고아 4행) · 186 .08실사 link6. 보정 `live-crosscheck.md §5.1` 표(L94~101)와 **수치 전수 일치** ✓
- **기준2 in-scope 연결:** 077→MAT_000186(.08 USAGE.02)·088→MAT_000186(.08 USAGE.02) 재실측 일치. 표지 sub_prd(078/089) 레더 직접연결 0 ✓
- **기준3 컨펌 3선택지·search-before-mint:** Q-BK-A(L136)=(a).08 유지/(b).06 가죽 고아행 재연결/(c).06 신설(불요). "search-before-mint=.06 신설 불요(MAT_000008/173~175 재사용)" 명시 ✓. CONFLICT-1(L89~96)·결정요약(L127)도 3-way+고아 반영 ✓
- **기준4 scope:** 보정이 레더 섹션(CONFLICT-1·결정요약 레더행·Q-BK-A·live §5.1)에 국한, CONFLICT-2/GAP-OG/GAP-PAPER/박·코팅·제본 등 무관 섹션 1차 게이트와 동일 유지 ✓

> **결론: M5 PASS 전환. D-BK-1 RESOLVED.** 보정이 3-way 실태·in-scope 연결·3선택지·search-before-mint를 정확·전수·scope-한정으로 반영.

### 1차 게이트(FAIL) 기록 — D-BK-1 [MAJOR] (보존)
mapping-final ★2/CONFLICT-1 + live-crosscheck §5 = "**라이브 레더(화이트)=MAT_000186 MAT_TYPE.08 실사소재**"로 단일 인용. **독립 재실측 결과 라이브 레더 자재는 3-way 혼재**:

```sql
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_nm ~ '레더' ORDER BY mat_cd;
```
| mat_cd | mat_nm | mat_typ_cd | 상품연결 |
|--------|--------|-----------|---------|
| MAT_000006 | 레더하드커버 | **MAT_TYPE.01 종이** | PRD_000100(포토북)만 |
| MAT_000008 | 레더 | **MAT_TYPE.06 가죽** | **0(고아)** |
| MAT_000173 | 레더하드커버 A | **MAT_TYPE.06 가죽** | **0(고아)** |
| MAT_000174 | 레더하드커버 A5 | **MAT_TYPE.06 가죽** | 0(고아) |
| MAT_000175 | 레더하드커버 A4 | **MAT_TYPE.06 가죽** | 0(고아) |
| MAT_000186 | 레더(화이트) | MAT_TYPE.08 실사소재 | 6상품(077·088·100·126·174·175) |

```sql
SELECT pm.prd_cd, p.prd_nm, pm.mat_cd, m.mat_typ_cd FROM t_prd_product_materials pm
JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd JOIN t_prd_products p ON pm.prd_cd=p.prd_cd
WHERE m.mat_nm ~ '레더';
-- PRD_000077 레더 하드커버책자 → MAT_000186 (.08) USAGE.02
-- PRD_000088 레더 링바인더 → MAT_000186 (.08) USAGE.02
```

**판정:**
- **in-scope 책자 상품(PRD_000077·088)이 실제 연결하는 자재 = MAT_000186(.08)** — mapping-final 우변(.08)은 *이 상품들에 한해* 정확. 따라서 매핑 자체는 적재 가능하고 BLOCKER 아님.
- **그러나 CONFLICT-1 서술이 "라이브=.08"이라고 일반화한 것은 부분실측** — 라이브에는 (a) **MAT_TYPE.06 가죽 레더 4행이 실재**(MAT_000008/173~175, Q4 "가죽" 의도와 정확히 일치) 하나 어느 상품에도 미연결(고아), (b) MAT_000006 레더하드커버=.01(종이). CONFLICT-1은 "Q4 가죽 vs 라이브 .08"로 양자택일 제시했으나, **실제로는 가죽(.06) 레더 자재가 이미 존재**한다는 사실을 누락 → 컨펌 Q-BK-A의 전제가 부정확.
- **라우팅:** `dbm-domain-researcher`(책자 시트) — CONFLICT-1/Q-BK-A를 정정: "라이브 레더는 .06 가죽 4행(고아)·.08 실사소재(연결)·.01 종이(포토북) 혼재. in-scope 077/088은 .08 연결. 결정 = (a) .08 유지 (b) 미연결 .06 가죽 행으로 재연결 — 둘 다 라이브에 실재." round-11 G-1 교훈(부분 인용으로 권위 왜곡) 재발 방지.

## M6 외부 갭 처분 — PASS
3 갭(GAP-EXT-1 표지별 page·GAP-EXT-2 레이플랫·GAP-EXT-3 CIP4 sewn) 전부 처분(무시+사유) + Sources(CIP4 Binding ICS·Mixam 등 URL·KB 재사용). 정직.

---

## 발견 결함 요약
| ID | 심각도 | 게이트 | 상태 | 요지 |
|----|:------:|:------:|:----:|------|
| D-BK-1 | MAJOR | M5 | **RESOLVED** | 레더 CONFLICT-1 부분실측 → 3-way 전수+고아 .06+3선택지 보정 완료, 재게이트 독립 재실측 PASS |

> 매핑 우변(in-scope 상품 077/088=.08)은 적재 가능. 보정으로 CONFLICT 서술/컨펌 전제 정확성 확보.

**최종: GO** (D-BK-1 RESOLVED·재게이트 M5 PASS)
