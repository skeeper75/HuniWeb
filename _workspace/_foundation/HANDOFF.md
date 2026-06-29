# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 5세션)

> 재시작 포인터. 활성 하네스=가격 종단(§27)·셋트(§23). 권위=2엑셀(상품마스터260610·가격표260527).
> ★사용자 권위모델[[price-authority-model-reframe]]: 엑셀=권위·이전사이트=거울·레드/도메인=구성요소 애매시만·webadmin=상품+가격 둘다 등록.

## ★이번 세션 한 일 (관점 재정립 세션)
1. **파이프라인 감사** — 배치 채점기가 "가격 나오나"만 재고 "맞나"는 0건 측정(PR 0/239)·전문에이전트 우회·공식집 미디코드를 적발.
2. **라이브 webadmin 실측**(`_live-webadmin-observe-260629/`) — 가격이 admin/뷰어 코드로 등록 확인("로더없음" 오판 정정)·HUNI_ADMIN_PW 현재 유효.
3. **★공식집 디코드 정본** — `계산공식집초안`=카탈로그 전상품 가격논리 정본(27블록·3유형)을 디코드, evaluate_price와 1:1. → `price-formula-collection-decode-260629.md`.
4. **전 카탈로그 공식 귀속 지도** — 상품→공식블록 매핑(`formula-block-map-260629.csv`·`formula-block-coverage-260629.md`).
5. **★3가격모델 분류 확정** — 공식형120·직접단가(가격포함)110·기성20. "(가격포함)=직접단가(공식아님)" 사용자 확정.
6. **공식형 구성요소 검증→진짜 저청구 5건** — `verify-atomic-findings-260629.md`.
7. **★반제품/셋트 분석 정본** — `set-semifinished-model-260629.md`(재작업 방지 토대).

## ★다음 시작점 (확정 순서)
**① §23 반제품/셋트 설계·적재 → ② A codify(3-tier 검증).** (사용자 우려=반제품 미분석 채 codify하면 재작업 → 셋트 먼저)

§23에서 할 것(=`set-semifinished-model-260629.md` §3 결함 5):
1. **셋트 미구성 4 신규구성**(중철068·무선069·PUR070·트윈링071=제본값만 청구 심각저청구)→072 패턴(내지·표지 구성원+부모 표지+제본 합산공식).
2. **부모공식 신설 3**(077·082·088)+내지 구성원 승격(082·077 내지 없음).
3. **면지/표지 택1 연결**(현재 3색 항상포함→생산연결 부정확·가격0이라 금액무해).
4. 엽서북094/떡메097 내지 page공식 점검(095·098 공식X).
5. **하드커버링 면지=제본비 포함**(사용자 확정·가격0·생산연결만).

이후 A codify=공식집-정합 검증을 **3-tier(단순 완제품/셋트 완제품/반제품 역할별)** 로 §27 batch계측에 codify(수렴·신규하네스0).

## 미해결/블로커
- **저청구 5**(접지리플렛048 인쇄·용지누락 / 책자068~071 제본만) → §23/§18 교정.
- **가격포함 110 단가 미적재**(굿즈·파우치·문구일부·상품악세·디자인캘)=직접단가 적재(§7·공식아님·난이도낮음).
- **가격표 골든격자 2/19**(아크릴·스티커만)=셀값 전수대조 미흡 → §26 17시트 전파(봉투 FAIL=1000배·포스터사인 97%미채번).
- 지그재그엽서=PRF_DGP_E 공용 바인딩·형압명함=명함 공용(search-before-mint).

## 이번 세션 결정 (relitigate 금지)
- **권위=2엑셀·이전사이트=거울(가격오라클 아님)·레드/도메인=구성요소 애매시만**[[price-authority-model-reframe]].
- **"(가격포함)"=직접단가 모델(공식 계산 아님)**.
- **면지=제본비 포함(가격0)·생산연결(택1)만 필요**.
- **셋트=2레이어**(부모 표지+제본 합산 + 내지 page공식 + 표지/면지=가격0 선택지).
- **검증은 3-tier 필수**(반제품을 부모기준 대조=false-positive 원인).
- **순서=§23 반제품/셋트 먼저→A codify**.

## 건드리지 말 것
- 이번 산출물: `price-formula-collection-decode`·`formula-block-map/coverage`·`verify-atomic-findings`·`set-semifinished-model`·`_live-webadmin-observe-260629/`·`batch/{verify_formula_binding,formula_block_map,verify_formula_full}.py`.
- 이전 세션 라이브 COMMIT 전부(UNDO 보유).

## 산출물 위치
- 정본: `_foundation/{price-formula-collection-decode,formula-block-coverage,verify-atomic-findings,set-semifinished-model}-260629.md`·`formula-block-map-260629.csv`.
- 라이브 실측: `_foundation/_live-webadmin-observe-260629/`.
- 메모리: [[price-authority-model-reframe]]·[[price-formula-collection-keystone-260629]]·[[set-semifinished-3tier-model-260629]]·[[catalog-price-3model-coverage-260629]].
