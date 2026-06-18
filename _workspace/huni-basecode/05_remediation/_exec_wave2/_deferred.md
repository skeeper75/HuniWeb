# Wave 2 실행본화 — 안전 판정 결과 (전건 ESCALATE)

> **하네스** hbg Phase 5 · `dbm-load-builder`(dbm-load-execution 스킬). **작성** 2026-06-18.
> **입력 권위:** `remediation-roadmap.md`(Wave 2 = R8·R9·R7) · `_approval-queue.md`(Wave 2 카드) · `price-chain-impact.md` · `regspec-{material §3.4/§3.5, printoption, process}.md` · **라이브 읽기전용 실측(2026-06-18)**.
> **[HARD] 실 COMMIT 0.** 본 회차 결론 = **Wave 2 3항목 전건 라이브 직접(경로 X) 실행본화 부적격 → 경로 Y 백로그 + Wave 재배치로 escalate.** 무리한 라이브 직접 금지 원칙(task brief §★4) 적용.

---

## 0. 한 줄 평결

**Wave 2(R8 인쇄면→print_side·R9 구수→bundle·R7 dtl_opt param)는 "그릇 실재 축이동·라이브 직접·즉시"로 로드맵에 배치됐으나, 라이브 실측 결과 셋 다 "목적지 행 대량 신규 INSERT + 무손실 소스 부재(NOT NULL FK 날조 요구·dflt 선택 근거 없음·AX-5 범위 미해소)"에 해당 → 안전·가역 판정 불가분.** 로드맵의 "그릇 실재 = 추가 선적재 불요" 전제가 **부분적으로 틀림** — 그릇(테이블)은 실재하나 **대상 상품의 목적지 행이 전무**(print_options 0행·bundle_qtys 0행·option_items 0행)이라 축이동 = 빈 그릇에 신규 INSERT이고, 그 INSERT가 **소스에 없는 NOT NULL 값(도수 front/back colrcnt·dflt_yn)을 요구**한다. **→ 라이브 직접 실행본 0. 전건 경로 Y(교정 v03 재적재)로 escalate.**

가격사슬 영향: **R8/R9/R7 전건 component_prices 직접 0참조**(price-chain-impact 재확인). 돈 크리티컬은 본 wave에 **없음**(UV PO-1은 Wave 3b). 단 R8 print_side는 아크릴 가격공식과 **formula 간접경로**가 있으나 — 본 escalate는 그 경로를 건드리지 않음(INSERT 자체가 부적격이라 미실행).

---

## 1. 라이브 실측 보드 (2026-06-18 read-only SELECT·날조 0)

### 1.1 목적지 그릇 스키마 (information_schema 실측)

| 목적지 테이블 | PK | NOT NULL 컬럼 (소스 필요) | FK |
|---------------|----|--------------------------|----|
| `t_prd_product_print_options` | (prd_cd, opt_id) | print_side · **front_colrcnt_cd** · **back_colrcnt_cd** · dflt_yn | front/back_colrcnt_cd → `t_clr_color_counts.clr_cd`(도수) · prd_cd → products · print_opt_cd → t_prt_print_options |
| `t_prd_product_bundle_qtys` | (prd_cd, bdl_qty) | **bdl_qty(int)** · **dflt_yn** | prd_cd → products · bdl_unit_typ_cd → base_codes |
| `t_prd_product_option_items` (R7 dtl_opt) | (자연키) | dtl_opt = jsonb 기존 컬럼(채움 대상) | ref_dim_cd/ref_key 트리거 fn_chk_opt_item_ref |

### 1.2 R8 인쇄면 14 → print_side — 대상 행·소유 상품·목적지 상태

- **소스 .09 인쇄면 행 14**(MAT_000271 단면·272 양면·290 양면가로형·291 양면세로형·309 양면인쇄·311 전면만·313 배면만·316 양면유광·317 양면유광M·318 양면유광L·332 세로형·333 가로형·334 세로M·336 가로L) — **전건 라이브 del_yn='Y'**(이미 소프트삭제).
- **BOM link → 소유 상품 16종**: PRD_000195 벨벳쿠션·208 슬로건·220 폰스트랩·226 아크릴쉐이커코롯토·227 미니우치와키링·228 하트이미지피켓·229 이미지피켓·264 레더숄더백·267 린넨에코백·268 캔버스심플백·270 캔버스에코백·271 캔버스숄더백·276 타이벡에코백·277 타이벡보냉에코백·278 메쉬토트백·279 메쉬에코백.
- **★목적지 실측: 16상품 전건 `t_prd_product_print_options` 행 0개** → 축이동 = **신규 INSERT 16+상품**(in-place UPDATE 아님).
- **★무손실 차단**: INSERT에 `front_colrcnt_cd`·`back_colrcnt_cd`(도수·NOT NULL FK) 필요 — 소스 자재행("단면"·"양면 가로형")에 **도수 정보 전무**. 무손실 소스 없음 → 값 날조 필요(HARD 위반: NOT NULL 무소스 백필 금지).
- 소유 16상품 중 **6상품 use_yn='N'**(비활성) — 비활성 상품에 인쇄옵션 신규 INSERT는 도메인상 부적절.

### 1.3 R9 구수 5 → bundle — 대상 행·소유 상품·목적지 상태

- **소스 .09 구수 행 5**(MAT_000277 2구·278 3구·279 4구·280 1구·294 2개1팩) — 전건 del_yn='Y'.
- **BOM link → 소유 상품 3종**: PRD_000202 키캡키링·203 LED투명키캡키링·214 자석북마크.
- **★목적지 실측: 3상품 전건 `t_prd_product_bundle_qtys` 행 0개** → 신규 INSERT.
- **★무손실 차단**: `bdl_qty`(int)는 "2구"→2 파싱 가능하나 — (a) "2개1팩"(MAT_000294)은 bdl_qty 해석 모호(2? 1?), (b) NOT NULL `dflt_yn`(어느 구수가 기본?) 소스 근거 없음, (c) `bdl_unit_typ_cd`(묶음 단위 base_code) 미정. dflt 선택·2개1팩 해석은 인간/실무진 결정.

### 1.4 R7 dtl_opt param 채움 — 목적지 상태

- `option_items.dtl_opt` 전역 채움 = **6/477행**(전건 봉제 param). 그릇(컬럼) 실재 PASS.
- **★목적지 행 부재**: R8/R9 소유 상품(+UV 21상품) 전건 `option_items` 행 **0개** → dtl_opt UPDATE 대상 자체가 없음.
- **★AX-5 미해소**(`_approval-queue.md §6`): "어느 옵션 항목에 어느 param 값을 채울지" 범위가 **잔여 컨펌**(인간 결정 대기) → 실행할 구체 행-값 매핑 부재. 추측 적재 = dodge.

### 1.5 가격사슬 (price-chain-impact 재확인·SELECT만)

| 항목 | cp 직접 참조 | 돈 크리티컬 |
|------|:--:|:--:|
| R8 인쇄면 .09 14 | 0 | 없음(단 print_side→formula PRF_CLR_ACRYL 간접경로 존재 — 본 escalate는 미실행이라 무접촉) |
| R9 구수 .09 5 | 0 | 없음 |
| R7 dtl_opt | 0(가격축 아님) | 없음 |

---

## 2. 항목별 안전 판정 (task brief §★축이동 안전성)

| 항목 | 목적지 행 INSERT? | 무손실? | BOM load-bearing | 가격영향 | 판정 |
|------|:--:|:--:|:--:|:--:|------|
| **R8 인쇄면→print_side** | **신규 INSERT(16상품·현 0행)** | **불가**(front/back colrcnt NOT NULL FK 무소스) | BOM link 활성(Wave 4 제거 전) | 0(formula 간접·미실행) | **🔴 ESCALATE — 라이브 직접 부적격** |
| **R9 구수→bundle** | **신규 INSERT(3상품·현 0행)** | **부분 불가**(dflt_yn·2개1팩 무근거) | BOM link 활성 | 0 | **🟡 ESCALATE — 결정 선결 후 가능** |
| **R7 dtl_opt param** | option_items 행 0개(UPDATE 대상 부재) | AX-5 범위 미해소 | — | 0 | **🟡 ESCALATE — AX-5 선결** |

**[HARD] 셋 다 task brief §★4 "안전·가역 판정 불가분(목적지 행 대량 INSERT·무손실 부재) → 실행본화 금지·Wave 분리 또는 경로 Y 백로그 escalate" 조건 충족.** 무리한 라이브 직접 INSERT 금지.

---

## 3. 권고 — 경로 판정 (장단 병기·침묵 선택 금지)

### 3.1 R8/R9 (인쇄면·구수 → print_side/bundle)

| 경로 | 장 | 단 | 권고 |
|------|----|----|------|
| 라이브 직접(경로 X) | — | **NOT NULL FK 날조 필요(R8 도수)·dflt 무근거(R9)·신규 INSERT·TRUNCATE 재적재 시 휘발** | **부적격** |
| **경로 Y(교정 v03 재적재·근본)** | v03에서 인쇄면/구수 값을 **올바른 칸(상품마스터 인쇄면·묶음 컬럼)으로 재인코딩** → 개발자 재적재 시 load_master가 print_options/bundle_qtys로 정상 적재(도수·dflt 포함 v03 원본 권위). P-TRUNCATE 안전 | 개발자 협업·재적재 사이클 | **★권고**(`dbm-axis-staged-load` P-TRUNCATE 가드·교정 입력 엑셀) |

> R8/R9는 **본질적으로 입력 v03 인코딩 결함**(인쇄면/구수를 자재 .09에 인코딩) → load_master 무변환 전파 → 라이브 오적재. 근본 교정 = v03을 올바른 축 컬럼으로 재인코딩 후 재적재(경로 Y). 라이브 직접 INSERT는 무소스 NOT NULL을 날조해야 하므로 **부적격**(임시책조차 안전하지 않음).

### 3.2 R7 (dtl_opt param 채움)

- **선결 = AX-5 범위 컨펌**(인간/실무진: 어느 상품·옵션부터 어느 param 값) + **option_items 행 선적재**(현 0행). 둘 다 해소 후에만 dtl_opt UPDATE 실행본화 가능.
- 경로: option_items는 load_master 적재 단위 외(휘발 위험 낮음·dbmap CPQ 트랙) → AX-5 해소 후 `dbm-load-execution` 라이브 직접 UPDATE 가능. **단 본 회차 미실행**(범위 미정).

---

## 4. Wave 재배치 제안 (escalate 결과)

| 원 배치 | 실측 후 제안 | 사유 |
|---------|--------------|------|
| Wave 2 R8 인쇄면→print_side | **→ 경로 Y(`dbm-axis-staged-load`) + Wave 4 BOM 제거와 동기** | 목적지 행 신규 INSERT·도수 NOT NULL 무소스 → v03 재인코딩 근본 교정 |
| Wave 2 R9 구수→bundle | **→ dflt_yn·2개1팩 결정 선결 후 경로 Y** | 신규 INSERT·dflt 무근거 |
| Wave 2 R7 dtl_opt | **→ AX-5 컨펌 + option_items 선적재 후 별 승인** | 목적지 행 0·범위 미해소 |

**결론: Wave 2는 "그릇 실재 = 즉시 라이브 직접" 가정이 라이브에서 무너짐(목적지 행 전무). 안전한 실행본 0건. 전건 경로 Y/선결 escalate.** Wave 1(in-place UPDATE·가역)과 본질이 다름 — Wave 1은 기존 행 교정, Wave 2는 빈 목적지에 무소스 신규 INSERT.

---

## 5. 인간 승인 질문 (평이한 한국어)

> "Wave 2(인쇄면·구수를 알맞은 칸으로 옮기기, 공정 세부값 채우기)를 라이브에서 직접 하려고 보니, **옮길 '목적지 칸'이 해당 상품들에 아직 하나도 없어서 새로 만들어 넣어야** 합니다. 그런데 ① 인쇄면을 넣는 칸은 '도수(앞면/뒷면 색 수)'를 반드시 함께 적어야 하는데 자재행엔 그 정보가 없고(없는 값을 지어내면 안 됨), ② 구수 칸은 '어느 것이 기본인지'와 '2개1팩'의 묶음수 해석이 정해지지 않았으며, ③ 공정 세부값은 '어느 옵션에 어느 값'을 채울지(AX-5)가 아직 미정입니다. 그래서 **이번엔 라이브 직접 적재를 하지 않고**, 개발자가 원본 엑셀에서 인쇄면·구수를 올바른 칸으로 옮겨 재적재하는 '근본 교정(경로 Y)'을 권합니다. 이렇게 진행할까요?"
