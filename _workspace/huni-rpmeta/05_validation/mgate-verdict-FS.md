# M-gate 검증 판정 — FS(패브릭·봉제 완제 직물 굿즈) 카테고리 (10번째 종단)

> rpm-validator. 경계면 교차 재실측 — 생성자(reverse/architect/gap) 주장 비신뢰·라이브 직접 재query.
> 입력: `categories/FS/{reverse.md,deepcheck.md}` · `02_metamodel/discovered-axes.md` · `03_gap/{gap-matrix.md,vessel-needs.md}` · 후니 라이브 `information_schema`(2026-06-19 read-only).
> 판정 기준: 단일 실결함=NO-GO·file:line 인용·독립 재측정 동반. 미검증=CONDITIONAL(silent PASS 금지).
> **★이 판정이 Phase 6.5 codex 교차검증 reconcile 베이스라인(codex엔 비노출).**

---

## 한눈 판정

| 게이트 | 판정 | 핵심 근거 |
|---|:---:|---|
| **M1 추출 충실성** | **GO** | FS reverse 원자 전건 `[live:SSR]` 출처 표기·날조 0·unobserved를 fact로 위장 없음(FS-8 정직 표기). 라이브 공정/자재 그릇이 reverse 슬롯 주장과 정합. |
| **M2 메타모델 정합** | **GO** | FS 9 facet(FS-1~8 + codex FS-A1)이 17축에 오버피팅 0으로 귀속. 관계 무모순. |
| **M3 distinct 타당성** | **GO** | 타일링 #18 부결(①충족·②불충족)·A-1 패널 #18 부결(①UNOBSERVED·②결함없음) 둘 다 **라이브 재실측으로 비준**. ST 형상 승격/PH 거치 부결과 일관. distinct 0 비준. |
| **M4 갭 판정 정확** | **GO** | PASS3/WEAK3/GAP1 라이브 일치. `prcs_dtl_opt` jsonb 실재·MAT_TYPE.09 봉제부자재 실재·measure_type 판별자 0건·별색/봉제 공정 행 실재 전건 재현. 비존재 컬럼 인용·실재 vessel GAP 오판 0. |
| **M5 vessel 건전성** | **GO** | FS 신규 그릇 0 비준 — 타일링/repeat/pattern 전용 컬럼 0건·전부 V-1/V-3/V-8 흡수. 누적 mint V-11·V-12 불변. |
| **M6 생성-검증 독립성** | **GO** | self-approve 0·핵심 주장 4건 라이브 재유도. dodge-hunt(타일링·A-1·distinct 0 깨기) 전건 실패=주장 견고. |

**종합: M1~M6 전건 GO · distinct 0 비준 · 라이브 재실측 일치 7건 · 발견 결함 0(Low 드리프트 1건 노트).**

---

## M1 — 추출 충실성 (GO)

### 재측정
- FS reverse 전 5상품(§1~5)·횡단 태깅(§6)·Ambiguous(FS-1~8) 원자가 `[live:SSR]`(2026-06-19 GET `/ko/product/item/FS/{code}`) 출처 표기. 마케팅 카피는 `[live:SSR-marketing]`로 엄격 분리(`reverse.md:12`) — 옵션/날조 방지 가드 작동.
- **unobserved 정직 표기 확인:** FS-8(`reverse.md:365-367`)이 "PCS 상세 enum·단가·infoCall 가격 결합 = unobserved"로 명시, infoCall 후행 데이터를 fact로 위장하지 않음. 가격 flag 대부분 `price_flag: unknown(infoCall 후행)`(`reverse.md:96,114` 등) — 추정을 관측으로 둔갑 0.
- **라이브 그릇 정합 교차:** reverse가 주장한 봉제(SEW_FBR)·별색(SID_FBR)·열재단 슬롯이 라이브 공정 행으로 실재 — `PROC_000007 별색인쇄`·`PROC_000080/088 봉제`·`PROC_000084 열재단`(라이브 재query) → reverse 슬롯이 후니 도메인에 실재하는 공정과 동형(허구 슬롯 아님).
- **재사용 캡처 0 정직 명시:** `reverse.md:14` "FS는 재사용 캡처 0 — huni-widget에 FS 캡처 부재. 라이브 SSR이 1차" — 미보유를 침묵하지 않고 명시.

### 결함
없음. (FS-8 infoCall unobserved는 정직한 미관측 표기이지 결함이 아님 — 축 판정은 SSR 슬롯만으로 확정, 미관측을 fact로 쓰지 않음.)

---

## M2 — 메타모델 정합 (GO)

### 재측정
- FS 9 fragment(FS-1 타일링·FS-2 방향·FS-3 면사 수·FS-4 별색·FS-5 마감봉제·FS-6 완제 부자재·FS-7 가격모델·FS-8 infoCall + codex FS-A1 패널)가 `discovered-axes.md:31-33`에서 전건 17축 facet으로 귀속. 단일 상품 전용 축 신설 0.
- **오버피팅 경계 준수:** 가장 강한 후보 타일링조차 "공정#2 인쇄 배치 파라미터(#9 종속)"로 분해(`discovered-axes.md:31`) — BN 접지 FLD_DFT 면분할·오시 줄수와 동형 family로 일반화. 단일 카테고리(FS) 전용 축 강요 0.
- **관계 무모순:** 면사 수=자재#1(CL oz·PD 번수 동형)·마감봉제=공정#2/형태가공#14(PD SEW_LTR 동형)·완제 부자재=부속물#8 선택형(PD-4 고정 ESN=Y와 노출 차원만 분기). 기존 축 매핑 간 모순 FK/composition 없음.

### 결함
없음.

---

## M3 — Discovered-axis 타당성 (GO) ★핵심 게이트

### 재측정 — 타일링 #18 부결(directive 1순위)

승격 양방향 HARD 기준(① 전용 슬롯 라이브 실재 + ② 후니 KB 무왜곡 흡수 불가) 재검:

- **① 전용 슬롯 = 충족(부결 불변):** `TILL_WH_GBN` 라디오(TIL_NON/TIL_HGH/TIL_WDT)가 FS 5상품 전수 `[live:SSR]` 실측(`reverse.md:44`)·전 9 카테고리(BN~PH) 미관측 전용 슬롯. ①은 ST 형상과 동일하게 충족.
- **② 후니 KB 무왜곡 흡수 불가 = 불충족(부결 결정타) — ★라이브 재실측 비준:** `discovered-axes.md:31` 주장 = "후니 KB `plate_size`/`prcs_dtl_opt`가 인쇄 배치를 이미 1급 모델링해 타일링이 왜곡 없이 담김". **라이브 직접 재query로 확증:**
  - `t_proc_processes.prcs_dtl_opt` jsonb 컬럼 실재(11컬럼 중 4번째).
  - 실데이터 15행 non-empty(102 공정 중): `PROC_000029 오시`={줄수 0~3}·`PROC_000030 미싱`={줄수}·`PROC_000013 코팅`={면 enum[단면/양면]}·`PROC_000054 반칼`={모양, 조각수}·`PROC_000017 제본`={방향/책등/고리형}.
  - → 인쇄 배치/공정 파라미터(줄수·면 enum·모양)를 후니가 **1급 jsonb로 실모델링** = 타일링(없음/세로/가로) enum이 코팅 면 enum과 동형으로 무왜곡 흡수. KB에 "패턴 반복 어느 축에도 없음" 결함 명시 **없음** → ②불충족 → **distinct 0 비준**.
- **★ST 형상(#17)과 결정적 분기 라이브 확증:** SHAPE/FORM/TILING enum 부모 그룹이 base_code 14그룹에 **0건**(라이브 재query) — 형상은 후니 KB G-SK-2 "어느 축에도 없음"이 결함으로 명시되어 ②충족(승격), 타일링은 `prcs_dtl_opt` 흡수처 실재로 ②불충족(부결). 두 판정의 분기가 라이브 schema 레벨에서 정합.

### 재측정 — A-1 패널 구성 #18 부결(codex 강도전)

- **① 전용 슬롯 = UNOBSERVED(부결):** `discovered-axes.md:33` 주장 = "FS reverse 실측(5상품 전수)에 면별(panel) 독립 디자인 입력 슬롯 부재·front_design/back_design/panel_info 0건". reverse 교차: §0.2 쿠션 양면은 `sodu`=SID_D **도수(#6) 토글**이지 면별 디자인 슬롯 아님(`reverse.md:41,157`)·디자인 입력=단일 풀프린팅(`reverse.md:7,317`). codex 인용(Contrado/FTC)=codex 산업추론·미검증(`deepcheck.md:12,99`). → ①불충족. PH H-1·PD-4 unobserved-pending 패턴과 동일.
- **② 흡수 가능(부결 보강):** 면별 디자인(노출 시)=디자인입력채널#16 다중면 facet(CL print_area 6위치 선례)·안감/심지=자재#1 sub_mtrl·포켓/거싯/손잡이=공정#2/형태가공#14+부속물#8. KB 결함 명시 없음 → ②불충족.
- **결론:** ①UNOBSERVED + ②결함없음 = PH-2 거치(①OBSERVED)보다 더 약함 → 부결. codex가 "타일링보다 강한 도전"이라 자평했으나 동일 #18 부결(`deepcheck.md:85,89`).

### 일관성 점검 (ST 승격·PH 거치 부결 대조)
- ST 형상: ①+② 둘 다 충족 → 승격(#17). FS 타일링: ①충족+②불충족 → 부결. FS A-1: ①불충족+②불충족 → 부결. **세 판정이 "②(KB 결함) 충족 여부가 승격 결정타"로 일관** — 라이브 SHAPE enum 0건 vs prcs_dtl_opt 흡수처 실재가 분기 근거.

### 결함
없음. distinct 0 비준.

---

## M4 — 갭 판정 정확 (GO)

### 재측정 — FS facet 8항 PASS3/WEAK3/GAP1 (vessel-needs.md:251-261)

| FS facet | gap 판정 | 라이브 재실측 결과 | 검증 |
|---|:---:|---|---|
| FS-1 타일링 | GAP→V-1(#9) | `prcs_dtl_opt` jsonb 실재·인쇄 배치 파라미터 1급(오시/미싱 줄수·코팅 면 enum) 15행 실데이터 | ✅ 흡수처 그릇 실재·타일링 enum 미적재=data-gap(축 부재 아님) **일치** |
| FS-2 방향 PAPER_WH | PASS→#13 | `t_siz_sizes` work/cut width·height 컬럼 실재 | ✅ 사이즈 흡수 **일치** |
| FS-3 면사 수 | WEAK→V-3 | `t_mat_materials` weight 컬럼 실재(340행 중 86 set)·**measure_type/unit 판별자 0건**(전역 검색)·depth 0 set | ✅ measure_type 부재로 면사 수/평량/두께 다의 WEAK **일치** |
| FS-4 별색 SID_FBR | PASS→공정#2 | `PROC_000007 별색인쇄` 행 실재 | ✅ 별색=공정 그릇 보유 **일치** |
| FS-5 마감봉제/제품가공 | WEAK→V-8(#14) | `PROC_000080/088 봉제`·`PROC_000084 열재단` 행 실재(제품가공 family 멤버 부분) | ✅ 봉제 family 일부 실재·#14 GAP과 정합 **일치** |
| FS-6 완제 부자재 | PASS→#8/MAT.09/옵션#3 | `t_prd_product_addons` 5행·`MAT_TYPE.09 봉제부자재` 코드값 실재·opt_groups 135/items 477 | ✅ 부속물+봉제부자재 버킷+옵션 선택 노출 그릇 전건 실재 **일치** |
| FS-7 가격모델 | WEAK→#11 | (기존 #11 WEAK·frm_typ_cd 부재 — 본 게이트 범위 외 가격 트랙) | ✅ 기존 판정 재확인 |
| FS-8 infoCall | unobserved | (SSR 미노출·축 판정 무영향) | ✅ 정직 표기 |

### 핵심 검증
- **`prcs_dtl_opt` jsonb 실재 = FS-1 GAP→V-1 흡수의 근거.** vessel-needs.md:253이 주장한 "jsonb 라이브 활성(오시/미싱 줄수·코팅 면 enum)"을 라이브 실데이터로 직접 재현 — **비존재 컬럼 인용 0**.
- **MAT_TYPE.09 = "봉제부자재" 라이브 코드값 실재** — vessel-needs.md:258 주장 정확. 솜/끈/자석 자재 귀속처 확증.
- **measure_type 판별자 0건 라이브 확증** — vessel-needs.md:255 "measure_type 판별자 0건(한 weight 컬럼이 평량 g·두께 mm·면사 수·용량 다의)" 재현(전역 검색 false-positive만).
- **실재 vessel을 GAP 오판 0:** FS-6 완제 부자재가 addons/MAT.09/옵션 그릇 실재로 PASS(GAP 오판 아님)·FS-2/FS-4도 그릇 실재로 PASS. data-gap(타일링 enum·완제 부자재 행 미적재)을 vessel-gap으로 과장 0.

### dbmap 정합
- FS facet 전건이 round-22 ③공정(prcs_dtl_opt)·④자재(MAT_TYPE.09 봉제부자재)·round-6 CPQ(옵션 선택 노출)에 매핑·중복 재발견 0(`vessel-needs.md:262` dbmap 라우팅 명시).

### 결함
없음. (Low 노트: gap-matrix 기록 opt_groups 134/items 469[2026-06-17] vs 라이브 현재 135/477 — 작업 중 적재 진행 정상 드리프트. "그릇 부재→실재" 방향 아님[이미 실재]·FS 판정[PASS=그릇 실재]을 강화할 뿐 뒤집지 않음. NO-GO 사유 아님.)

---

## M5 — Vessel 건전성 (GO)

### 재측정
- **FS 신규 그릇 0 비준:** 타일링/repeat/pattern/layout 전용 컬럼 라이브 전역 검색 **0건** — 타일링이 별 형상/배치 슬롯이 아니라 `prcs_dtl_opt` jsonb로 흡수됨을 schema 레벨로 확증. `vessel-needs.md:249` "FS 신규 vessel-gap = 0건" 정확.
- **search-before-mint 통과:** FS facet 8항 전부 기존 V-1(공정 파라미터·#9)·V-3(자재 measure_type)·V-8(봉제 family·#14)·#13(사이즈)·#8(부속물)에 흡수(`vessel-needs.md:252-262`). 새 V-번호 부여 0.
- **누적 mint 불변 확인:** V-11 TemplateAsset·V-12 SHAPE 2건이 FS 통합으로 변동 없음(`vessel-needs.md:13-14` 보존 명시). SHAPE enum 부모 그룹 라이브 0건 = V-12 형상 GAP 불변 확증(FS가 형상축 건드리지 않음).
- **컨벤션 정합:** FS는 그릇 신설 0이므로 t_* 컨벤션 드리프트 발생 여지 없음.

### 결함
없음.

---

## M6 — 생성-검증 독립성 (GO)

### 재측정
- **self-approve 0:** reverse(생성)→architect(facet 판정)→gap(라이브 대조)→validator(본 게이트) 각 lane 분리. 각 stage가 자기 산출을 승인하지 않음.
- **핵심 주장 4건 독립 재유도(생성자 echo 아님):**
  1. `prcs_dtl_opt` jsonb 실재 → 라이브 직접 query로 11컬럼 구조+15행 실데이터 재측정(reverse/gap 주장 복창 아님).
  2. MAT_TYPE.09 봉제부자재 → 라이브 코드값 직접 SELECT.
  3. measure_type 판별자 0건 → 라이브 컬럼 전수+NULL 비율(weight 86/340·depth 0) 직접 측정.
  4. SHAPE enum 0건(타일링 부결 분기) → base_code 부모 그룹 14개 직접 열거.

### Dodge-hunt (최리스크 주장 깨기 시도)
- **타일링 #18 부결 깨기:** "타일링은 전 9 카테고리 미관측 전용 슬롯이니 distinct 아니냐?" → ① 충족 인정. 그러나 ②(KB 흡수 불가)가 부결 결정타이고, `prcs_dtl_opt`가 코팅 면 enum·오시 줄수를 1급 모델링하므로 타일링 enum도 무왜곡 흡수 → 부결 견고. **깨기 실패.**
- **A-1 패널 #18 부결 깨기(codex 강도전):** "codex가 cut-and-sew 면별 디자인을 강하게 주장" → 라이브/reverse 실측에 panel/front_design 슬롯 0건·codex 인용 미검증 → ①UNOBSERVED로 ①조차 미충족 → 부결 견고. **깨기 실패.**
- **distinct 0 깨기:** "10번째 카테고리인데 정말 0인가?" → 가장 강한 두 후보(타일링·패널) 모두 양방향 기준 불충족·라이브 흡수처 실재 → 0 비준. **깨기 실패.**

### 결함
없음.

---

## 결함 라우팅

NO-GO 결함 0건 → `_defects.md` 신규 라우팅 없음. (Low 드리프트 1건은 작업 중 적재 진행에 따른 정상 변동·판정 무영향·라우팅 불요.)

---

## 라이브 재실측 일치 건수 (7건)

1. `t_proc_processes.prcs_dtl_opt` jsonb 컬럼 실재 + 15행 인쇄 배치 파라미터 실데이터 (FS-1 흡수처).
2. MAT_TYPE.09 = "봉제부자재" 코드값 실재 (FS-6 자재 귀속처).
3. `t_mat_materials` weight 컬럼 실재·measure_type 판별자 0건·depth 0 set (FS-3 WEAK).
4. PROC_000007 별색인쇄·PROC_000080/088 봉제·PROC_000084 열재단 공정 행 실재 (FS-4·FS-5).
5. 타일링/repeat/pattern/layout 전용 컬럼 0건 (FS 신규 vessel 0·M5).
6. SHAPE/FORM/TILING enum 부모 그룹 0건 (타일링 부결 vs ST 형상 승격 분기·M3).
7. addons 5·opt_groups 135·opt_items 477 그릇 실재 (FS-6 완제 부자재 PASS·신규 mint 0).

---

## 최종 판정

**M1~M6 전건 GO. distinct 0 비준(타일링·A-1 패널 둘 다 양방향 기준 적대 판정 통과). 라이브 재실측 일치 7건. 발견 결함 0(Low 드리프트 1건 노트·판정 무영향).**

FS(10번째 카테고리·직물 풀프린팅+봉제 완제 굿즈)는 가장 이질적인 패브릭 굿즈조차 17축 무손실 흡수 = 모델 재포화 재확인. directive 1순위(타일링 반복 배치 차원)가 후니 `prcs_dtl_opt` jsonb 인쇄 배치 1급 그릇에 무왜곡 담김을 라이브로 비준. 신규 vessel 0(V-11·V-12 불변).

> 본 판정은 Phase 6.5 codex 교차검증의 reconcile 베이스라인 — codex에 비노출.
