# 캘린더 + 디자인캘린더 — 매핑 확정 독립 게이트 (round-12 M1~M6)

> **검증자** `dbm-validator`(생성자≠검증자). **작성** 2026-06-10.
> **이 파일은 검증자가 독립 재작성(덮어쓰기)했다** — 직전 버전은 생성 에이전트(`dbm-domain-researcher`)가 자기 산출을 자가 게이트한 분리 위반본이라 내용 폐기. 판정은 검증자의 독립 라이브 재실측·L1 직접 카운트 증거 기반.

## 게이트 매트릭스

| # | 게이트 | 판정 | 핵심 증거 |
|---|--------|:----:|-----------|
| M1 | 커버리지 | **PASS** | 두 시트 L1 헤더 직접 카운트 |
| M2 | 권위 인용 실재 | **PASS** | 표본 + X-1~X-5 전수 재측 |
| M3 | 실무진 정합 | **PASS** | Q1/Q5/Q12/Q13 ★ 반영 |
| M4 | 오모델 부재 | **PASS** | 우드거치대 단일귀속·링칼라 조건부 분리 |
| M5 | 라이브 실측 | **PASS** | 독립 재실측 8건 |
| M6 | 외부 갭 처분 | **PASS** | 8 갭 전부 처분+Sources WebFetch |

**판정: GO**

---

## M1 커버리지 — PASS
- `calendar-l1.csv` 46 컬럼 = 파서메타 7 + **의미 30**(구분~디자인보유) + 트레일링 빈 8(`0`·AF~AL) + cell_meta_json. mapping-final §A = C1~C30 전수 + §A.99 제외 명기 ✓
- `design-calendar-l1.csv` 44 컬럼 = 파서메타 7 + 의미 29(구분~디자인보유) + 빈 7(AD~AJ) + cell_meta_json. mapping-final §B = 공유 컬럼(§A 적용) + 차이 6(B1~B6) 처리 + §B.99 제외 명기 ✓
- 두 시트 합산 의미 컬럼 전수 매핑. **누락 0.**

## M2 권위 인용 실재 — PASS (X-1~X-5 전수 독립 재측)
- X-3 excl_groups 테이블 부재 → 독립 재실측 `information_schema.tables WHERE table_name ~ 'excl'` = **0건**(테이블 부재 확정) ✓. option_groups 흡수 정당
- X-4 트윈링제본 mand_proc_yn → 벽걸이 PRD_000111 processes = PROC_000079 타공(N)·PROC_000021 트윈링제본(N) 재확인 ✓
- X-5 MES NULL → PRD_000108~112 전부 MES_ITEM_CD 빈값 재확인 ✓
- X-1 종이 usage → 벽걸이 materials 23행 전부 USAGE.07 재확인 ✓
- X-2 출력판형 계열코드 → (mapping-final 인용·OUTPUT_PAPER_TYPE 트리 일관)
- C30 디자인보유 → 5상품 전부 PRD_TYPE.04 재확인 ✓
날조 0. round-11 인용 오류(X-1·X-2)를 라이브 권위로 정정한 것 정직.

## M3 실무진 정합 — PASS
- **Q1**(C10 파일명·C28 가이드파일 견적제외) ✓
- **Q5 ★**(시트별 컬럼 옵션 확인 후 귀속) → C18 삼각대(공정 param)·C21 링칼라(조건부)·우드거치대(자재) 분기 ✓
- **Q12 ★**(장수=고객옵션+가격공식) → C17 CPQ option+공식, page_rule 단정 금지 명시 ✓
- **Q13 ★**(우드거치대=자재) → §A.1에서 round-11 CL-2(OPTION/TEMPLATE) 철회·자재 단일귀속 반영 ✓
- Q14(블리드 도출) → C6 ✓ · Q15(디자인캘린더 고정가) → B6 ✓

## M4 오모델 부재 — PASS
- 색=siz 없음 · **size↔option 혼동 없음**(장수=옵션 Q12 명시·page_rule 아님) · **이중의미 평면화 분리**(링칼라 조건부 캐스케이드 별도·우드거치대 자재 단일귀속·출력판형≠재단≠작업 3축) ✓
- 우드거치대가 C19(가공)·C26(추가상품) 양쪽 표기되나 자재로 단일귀속(Q13) — 평면화 회피. 매핑 오모델 재발 0.

## M5 라이브 실측 — PASS
독립 재실측 8건 전부 일치: 5상품(108~112) 존재·전부 PRD_TYPE.04·MES NULL·QTY_UNIT.01 / 벽걸이 sizes3·page_rule0·opt_grp0·addons0·prices0 / 벽걸이 materials 23행 USAGE.07 / processes 타공079+트윈링021 둘 다 mand=N / excl 테이블 부재 / OUTPUT_PAPER_TYPE·PRD_TYPE·USAGE 코드 트리. 미적재(page/option/addon/price)=적재 대상 정직 분류(OM-6 정합).

## M6 외부 갭 처분 — PASS
8 갭(G-CAL-1~8) 전부 처분(무시 7=에디터콘텐츠/후니보유·매핑반영 1=G-CAL-7 장수 Q12) + Sources WebFetch 검증(RedPrinting 시작월=Non-pricing 분류 인용·퍼블로그·Vistaprint·Mixam URL·KB 재사용). 신규 DDL 0·매핑수정 0(Q12는 이미 mapping-final 반영). 정직.

---

## 발견 결함
**없음(0).** 디자인캘린더=별 상품 아님(CL-1 해소)·우드거치대=자재(Q13)·장수=옵션(Q12) 등 ★결정 전부 라이브로 뒷받침. round-11 인용 오류 2건(X-1 usage·X-2 출력판형)을 라이브 권위로 정직 정정. 잔존 🟡(장수 옵션값·가공 추가가·봉투 addon·디자인 템플릿·고정가 격자)은 미적재(적재 대상)이지 미확정 아님 — 인간 승인 적재 트랙으로 정상 분류.

**최종: GO**
