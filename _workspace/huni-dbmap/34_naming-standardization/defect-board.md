# 네이밍 결함 보드 + 통계 (round-34)

> **산출자:** dbm-price-formula-auditor · 2026-06-18 · 라이브 실측. **DB 쓰기 0** — 실 UPDATE는 인간 승인.
> **생성자=정리자·자기 GO 금지** — 독립 검증(dbm-validator)으로 라이브 재실측·표준어 일관·코드노출 0 확인 인계.

## 통계 요약

| 지표 | 값 |
|---|---|
| 전체 가격구성요소 comp | 146 |
| **comp_nm 코드 노출(`[COMP_xxx]`)** | **102 (70%)** |
| comp_nm 비표준/모호(코드는 없으나) | 6 (TWINRING 제본비·DIGITAL_S1 출력비·모서리비 직각/둥근·오시/미싱 2~3줄 "비" 누락) |
| comp note 빈값(use_yn=Y) | 2 |
| comp_typ_cd 빈값 | 1 (STK_TATTOO) |
| 가격공식 frm_nm 코드 노출 | 0 / 48 ✅ |
| frm note 빈값 | 3 |
| 기초코드 테스트 잔재 그룹 | 3 (TEST/TESTTEST/TESTTESTTEST_TYPE) |

---

## 결함 분류 (우선순위)

### P1 — comp_nm 코드 노출 102 (실무진이 화면에서 코드를 읽음)
가장 큰 결함. directive 1순위. 클러스터 15종(§component-naming-cleanup A-1~A-12).
- 완제품가 .06: 83건 (포스터 본체 23·추가옵션 23·명함 19·박명함 4·엽서북 4·포토카드 3·커팅 3·스티커 2·합판 1·떡메 1)
- 후가공 .04: 16건 (제본 8·접지 7·타공 1)
- 박형압 .05: 2건
- 빈 typ: 1건(타투)
**조치:** §component-naming-cleanup 표준안 전수 적용(UPDATE comp_nm).

### P2 — 코드 없으나 표준어 미달/모호 (6)
| comp_cd | 현재 | 문제 | 표준안 |
|---|---|---|---|
| COMP_BIND_TWINRING | 제본비 | 종류 변별자 부재 → 8개 제본비와 화면 구분 불가 | 제본비 트윈링 |
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 출력비 | "출력비" 중복어·S2와 변별 모호 | 디지털인쇄비(단면) |
| COMP_PP_CORNER_RIGHT | 모서리 비 | proc 권위는 "귀돌이"·띄어쓰기 오류 | 귀돌이비 직각 |
| COMP_PP_CORNER_ROUND | 모서리 둥근 | "비" 누락 | 귀돌이비 둥근 |
| COMP_PP_CREASE_2L/3L·PERF_2L/3L | 오시 2줄·미싱 3줄 등 | "비" 일관성 누락 | 오시비 2줄·미싱비 3줄 |
| COMP_BIND_SSABARI·CAL_WALL | 하드커버 제본비·캘린더 제본비 | "제본비 {종류}" 어순 비통일 | 제본비 싸바리바인더·제본비 벽걸이캘린더 |

### P3 — note/메타 보강 (3)
- comp note 빈값 2 (COMP_ACRYL_COROTTO·STK_TATTOO)
- COMP_STK_TATTOO comp_typ_cd 빈값 → `PRC_COMPONENT_TYPE.06`
- frm note 빈값 3 (PRF_COROTTO_ACRYL·PRF_STK_PACK·PRF_STK_TATTOO)

### P4 — 기초코드 테스트 잔재 (3) — 인간 승인
TEST_TYPE("Test")·TESTTEST_TYPE("xTest")·TESTTESTTEST_TYPE("TestTest") 그룹 → 기초코드정보 화면에서 노출. use_yn=N 또는 삭제 검토.

### 🔵 라이브 확인 필요 (컨펌 대상·추측 0)
- §A-12 포스터 add-on 일부 접미사 의미 불명: `_GT`/`_LE`(COMP_POPT_BNR_GAKMOK_STR_900_4_GT/LE), `PROC_OPT`(가공옵션 통칭?) — component_prices opt 차원·가격표 원천 또는 라이브 화면 대조 필요.
- frm_typ_cd 라이브 사용 여부(가격공식 필터에 실제 노출되는지) — round-17 "라이브 부재" 전제 재확인 필요(이번 범위 외·캡처 제외).

---

## 미해소 컨펌
1. 포스터 add-on `_GT`/`_LE`/`PROC_OPT` 한글 라벨 (가격표 원천/라이브 확인).
2. use_yn=N 레거시 6건에 `[레거시]` 표기 vs use_yn=N이면 화면 미노출이라 정리 불요 — 정책 결정.
3. comp_nm "비" 일관성: 가변텍스트/가변이미지에 "비" 붙일지(현재 미부착·통용 우선) — 정책 결정.
