# prd_nm→prd_cd 브리지 신뢰도 맵 — 요약 (스텝1b)

> 권위 엑셀(상품마스터 260703, prd_nm) ↔ 라이브 DB(prd_cd) 조인 다리. 매칭=가설(사실 아님). 잘못된 매칭=엉뚱한 상품에 엉뚱한 가격=no-match보다 나쁨.

- **권위 상품 총계**: 253건 (11 상품시트 distinct prd_nm; 비상품 노트행 2건 제외)
- **EXACT**: 234건 (92%) — 233건 자동 확정(needs_human=FALSE), 1건 생애주기 재확인(라이브 del_yn=Y)
- **DOMAIN_INFERRED**: 1건 — 인간 확인 대기
- **AMBIGUOUS**: 13건 — 인간 확인 대기
- **UNMATCHED**: 5건 — 인간 확인 대기
- **인간 확인 필요(needs_human=TRUE) 합계**: 20건

## 재사용한 기존 자산 (search-before-mint)
- `registration_check.py` db_state() `nm2cd` — 라이브 prd_nm→prd_cd 역맵(EXACT 판정 근거).
- `35_category-map/matching.csv` (type=product, norm→live_prd_cd 252건) — 카테고리맵 상품 매칭 harvest(EXACT 보강·불일치건 후보).
- `24_master-extract-260703/*-l1.csv` `MES ITEM_CD` ↔ 라이브 `t_prd_products.MES_ITEM_CD`(16건) — 보강 근거.
- 라이브 스냅샷 `live-snapshot/latest/t_prd_products.csv`(300 상품, prd_nm 전량 유니크) — 대상.

## DOMAIN_INFERRED (문자열 불일치·단일 후보 추론) — 1건
- [silsa] **투명포스터★** → PRD_000122 '접착투명포스터' · card=1:1(추정)
    - 근거: 도메인 코어 '투명포스터' 부분포함 후보: PRD_000122='접착투명포스터'

## AMBIGUOUS (N:1·1:N·후보 복수) — 13건
- [booklet] **떡메모지** → PRD_000097 '떡메모지' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000097) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['booklet', 'stationery'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [booklet] **링바인더 (보류중)** → PRD_000089; PRD_000090; PRD_000091; PRD_000092; PRD_000093; PRD_000088 '레더 링바인더-표지(레더(화이트)); 레더 링바인더-면지; 레더 링바인더-면지(블랙면지); 레더 링바인더-면지(그레이면지); 레더 링바인더-면지(인쇄면지); 레더 링바인더' · card=1:N
    - 근거: 도메인 코어 '링바인더' 부분포함 후보: PRD_000089='레더 링바인더-표지(레더(화이트))'; PRD_000090='레더 링바인더-면지'; PRD_000091='레더 링바인더-면지(블랙면지)'; PRD_000092='레더 링바인더-면지(그레이면지)'; PRD_000093='레더 링바인더-면지(인쇄면지)'; PRD_000088='레더 링바인더'
- [calendar] **미니탁상형캘린더** → PRD_000109 '미니탁상형캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000109) | MES 007-0002 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [calendar] **벽걸이캘린더** → PRD_000111 '벽걸이캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000111) | MES 007-0004 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [calendar] **엽서캘린더** → PRD_000110 '엽서캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000110) | MES 007-0003 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [calendar] **와이드벽걸이캘린더** → PRD_000112 '와이드벽걸이캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000112) | MES 007-0005 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [calendar] **탁상형캘린더** → PRD_000108 '탁상형캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000108) | MES 007-0001 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [design-calendar] **미니탁상형캘린더** → PRD_000109 '미니탁상형캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000109) | MES 007-0002 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [design-calendar] **벽걸이캘린더** → PRD_000111 '벽걸이캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000111) | MES 007-0004 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [design-calendar] **엽서캘린더** → PRD_000110 '엽서캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000110) | MES 007-0003 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [design-calendar] **와이드벽걸이캘린더** → PRD_000112 '와이드벽걸이캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000112) | MES 007-0005 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [design-calendar] **탁상형캘린더** → PRD_000108 '탁상형캘린더' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000108) | MES 007-0001 라이브 일치(보강) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['calendar', 'design-calendar'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)
- [stationery] **떡메모지** → PRD_000097 '떡메모지' · card=N:1
    - 근거: prd_nm 문자열 정확 일치(라이브 PRD_000097) | matching.csv 확립 매핑 일치(보강) | 동일 prd_nm 이 ['booklet', 'stationery'] 2시트 → 라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)

## UNMATCHED (후보 없음·신규/단종 의심) — 5건
- [goods-pouch] **버즈케이스★** → (후보 없음) · card=0:0
    - 근거: 라이브 후보 없음 — rename·신규·단종 의심 | MES 미등재(신규 상품 강신호)
- [goods-pouch] **블랙젤리** → (후보 없음) · card=0:0
    - 근거: 라이브 후보 없음 — rename·신규·단종 의심 | MES 미등재(신규 상품 강신호)
- [goods-pouch] **슬림하드 폰케이스** → (후보 없음) · card=0:0
    - 근거: 라이브 후보 없음 — rename·신규·단종 의심 | MES 미등재(신규 상품 강신호)
- [goods-pouch] **에어팟케이스★** → (후보 없음) · card=0:0
    - 근거: 라이브 후보 없음 — rename·신규·단종 의심 | MES 미등재(신규 상품 강신호)
- [goods-pouch] **임팩트 젤하드** → (후보 없음) · card=0:0
    - 근거: 라이브 후보 없음 — rename·신규·단종 의심 | MES 미등재(신규 상품 강신호)

## 제외된 비상품 노트행 (파싱 아티팩트)
- [booklet] `https://www.redprinting.co.kr/ko/guide2/view/4/116`
- [stationery] `노랑색배경은 신규상품으로 MES에도 없어 등록해야하는 상품입니다
그레이배경의 상품은 품절이…`

## [HARD] 게이트 규칙
- EXACT(needs_human=FALSE)만 자동 조인 확정. 나머지 3등급은 전부 인간 확정 전까지 가설.
- 엑셀 prd_nm=절대 권위. 라이브/이전사이트/레드는 다리(보강 근거)일 뿐 엑셀을 덮어쓰지 않음.
- 근거 없는 매칭 금지 — 모든 추론 매칭에 evidence 문자열 첨부.