# basedata-coverage-note.md — 검사 커버리지·BLOCKED 정직 명시

> Phase 2 hcc-basedata-inspector · 디지털인쇄 36상품 × 8축 = 288셀

## 커버리지: 288/288 셀 전부 채움 (빈 셀 0)

| 축 | MATCH | N/A | MISSING | MISMATCH | EXTRA | CONFIRM | 합 |
|----|-------|-----|---------|----------|-------|---------|----|
| 사이즈코드 | 33 | 0 | 3 | 0 | 0 | 0 | 36 |
| 도수 | 32 | 4 | 0 | 0 | 0 | 0 | 36 |
| 인쇄옵션 | 8 | 11 | 11 | 6 | 0 | 0 | 36 |
| 판형 | 30 | 0 | 0 | 2 | 1 | 3 | 36 |
| 자재 | 35 | 0 | 1 | 0 | 0 | 0 | 36 |
| 공정 | 20 | 14 | 1 | 1 | 0 | 0 | 36 |
| 묶음수 | 0 | 25 | 10 | 0 | 1 | 0 | 36 |
| 페이지룰 | 0 | 31 | 5 | 0 | 0 | 0 | 36 |
| **합** | 158 | 85 | 31 | 9 | 2 | 3 | **288** |

## BLOCKED: 0건
- 라이브 접속(`.env.local RAILWAY_DB_*` 읽기전용) 정상, 36상품 1:1 매칭(미매칭 0), 권위 캐시(`24_master-extract-260610/digital-print-l1.csv`) 재사용. 접근 불가·자격증명 부재 셀 없음.

## 데이터 출처
- 권위값: `24_master-extract-260610/digital-print-l1.csv`(재파싱 금지·캐시 재사용) → `_live/authority-values.json`.
- 라이브 실측: psql 읽기전용 SELECT, `_live/{sizes,print-options,plate-sizes,materials,processes,bundles,page-rules}.tsv` → `_live/all-live.json`.
- 판정 엔진 산출: `_live/verdicts.json`.

## 검사 가정·한계 (게이트 재실측 시 주의)
1. **인쇄옵션 vs 공정 테이블 공유**: 라이브는 코팅·접지·별색·박·모서리·가변을 모두 `t_prd_product_processes` 한 테이블에 적재. 인스펙터는 권위 컬럼(별색/코팅/커팅/접지=축3, 후가공/박/형압=축6)으로 분리 판정. proc_nm 키워드 매핑(유광/무광=코팅, *접지=접지, 화이트/클리어/핑크/금색/은색=별색, 금유광/동박 등=박)에 의존 — 게이트는 upr_proc_cd family로 재확인 권장.
2. **별색 미적재 판정**: 별색 family(PROC_000007 upr) product_processes 링크 0 + option_items ref_dim 0 실측 확인. clr_cd=NULL 공정행으로 등록돼야 하나 부재.
3. **자재 표기 정규화**: 권위 약어("아트300","백모조220")↔라이브 정식명("아트지 300g","백색모조지 220g")은 한글토큰+두께 매칭으로 동일 처리(g단위·"지" 접미 무시). 의미구분(투명/반투명) 미분리는 결함 유지(PRD_000019/25/39 라이브 mat_nm="PET"로 단일화 의심 → 게이트 재확인 권장).
4. **페이지룰**: 권위 `판수` 컬럼값(15/12/8/6/4 등)이 낱장 상품에도 존재하나 domain-lens §9상 낱장은 잡음 → 체크리스트 needed(접지카드류 5건만 Y) 우선. 라이브 page_rules 36상품 전부 0행 → needed=Y 5건은 MISSING.
5. **판형 needed 충돌**: authority-spec §4(비판형 needed=N) vs 체크리스트(판형 전부 needed=Y) — 037/050/051을 CONFIRM 처리(결함 아님·needed 재판정 사안).
---

## 배치1 커버리지 (포토북 100~107 · 캘린더 108~112) · 2026-06-22

- **검사 셀:** 69셀(포토북 28 + 캘린더 41). checklist owner=basedata 중 배치1 needed 셀 전수 채움(빈 셀 0).
- **반제품 역할축 한정 검사 적용:** 포토북 101~107은 domain-lens §B.1대로 역할축만(내지=자재/도수/판형/페이지·표지=자재/도수/공정·면지=자재/공정). 역할 외 축은 checklist needed=N이라 cells 미생성(정상).
- **BLOCKED 셀:** 0건. 13상품 모두 라이브 존재(del_yn=N)·8축 자식행 배치 psql 전수 조회 성공.
- **재실측 필요(게이트/codex 위임, 결함 아닌 verdict 분기):**
  - 포토북 101~107 도수/판형/공정 MISSING 12셀: 세트 superset vs 멤버환원 구조 의도 미확정(Q-PB-SUPERSET). MISSING으로 기록했으나 구조정상이면 N/A 재판정.
  - 캘린더 page_rule 5건: 적재 shape(고정 vs 가변) 미확정(Q-CAL-PAGE-SHAPE).
  - PRD_000112 판형 MISMATCH·PRD_000110 공정 EXTRA: 도메인 정당성 codex 2차.

---

## 배치2 커버리지 (책자10·문구9·악세15 = 34상품 × 8축 = 272셀)

- **검사 완료 272/272 (BLOCKED 0).** 라이브 8축 자식행 전수 실측(읽기전용 psql 2026-06-22), 권위=상품마스터 260610 캐시(booklet/stationery/product-accessory-l1.csv) 재사용·재파싱 0.
- needed=Y 129셀(책자60·문구54·악세15) 전건 verdict 산출. needed=N 143셀=N/A로 닫음(인쇄옵션·묶음수·악세 7축 등 권위 미사용).
- 권위 부재로 단정 불가한 셀은 **CONFIRM으로 정직 표기**(MISSING으로 날조 안 함): 만년다이어리 도수 3건·레더커버 판형/공정/페이지·떡메모지 page EXTRA 의심 등.
- 자재 마스터 join은 t_mat_materials, 공정 마스터는 t_proc_processes(t_prc_processes 아님·실측 확인). 사이즈 마스터 t_siz_sizes.cut_* 조인.
- BLOCKED 없음 — 전 셀 라이브 접근 성공.
