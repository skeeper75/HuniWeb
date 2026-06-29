# 가격 파이프라인 세션 핸드오프 (최신 2026-06-30 8세션)

> 재시작 포인터. 활성 하네스=가격테이블 무결성(§26)·가격 종단(§27)·가격엔진 설계(§18).
> 권위=2엑셀(상품마스터260610·가격표260527). 엑셀=권위·라이브=감사대상·단가 verbatim.
> ★시트별 적재 표준절차=`huni-price-table-integrity/_batch/SHEET-LOAD-PLAYBOOK.md`.

## ★이번 세션(8세션) 한 일 — 잔여 시트 종결 + 박류 §18 설계 완주

### 라이브 COMMIT 3건 (전부 verbatim·undo 보유·`_batch/`)
1. **큐리어스스킨 화이트 880**(MAT_000361 COMP_PAPER 1행) — 출력소재 종결. 형제 색상과 정합(부모=화이트 대표값). undo=`paper-curious-white-undo.sql`.
2. **제본비 comp 3종 del_yn=N 복원**(COMP_BIND_JUNGCHEOL/MUSEON/PUR) — 제본 시트 74/74 100%. ★엔진은 del_yn 미필터(가격 무관)·어드민 가격뷰어 표시만 복원·단가/바인딩 불변. 트윈링(del=N)과 정합. undo=`binding-restore-delyn-undo.sql`.
3. **디지털 흑백 양면 106행**(POPT_000009 양면1도·COMP_PRINT_DIGITAL_S1) — 디지털 4도수 완비(칼라단/양면·흑백단/양면 각 106). 권위 흑백양면 verbatim(국4절 qty1=4000·3절 qty1=5000). ★POPT_000009는 사장님이 어드민에서 미리 추가(00:28)→내 적재는 단가행만(ON CONFLICT). 단, **상품 노출(t_prd_product_print_options 연결)은 별도 사장님 결정**(단면 흑백 POPT_000008도 동일 미연결). undo=`digital-mono-s2-undo.sql`.

### 정밀 대조 — UNMAPPED 4시트 전부 "이미 적재(진짜 gap 0)" 확정
§26 batch가 UNMAPPED 판정한 시트는 **파싱 한계의 false 신호**였고 셀단위 정밀 대조 시 gap 0:
- **출력소재**: 30 "미적재"=10 아티팩트(siz_cd 빈값)+9 스티커류(COMP_STK_PRINT 적재)+5 3절(가짜결함)+6 미구성.
- **커팅타공**: 완칼 36/36·타공합가 1구/2구 9/9 verbatim(2중테이블+note행+이중수량축 파싱불가였음). ★합가 우선 규칙 적용.
- **스티커 B01(반칼 메인)**: 5규격×3소재그룹×36수량=540셀 100%·A3컬럼108셀=반칼 미제공 가짜gap. B02~B07 소블록만 정밀확인 잔여(노이즈 추정).
- **명함/포토카드**: 12블록 전부 일치·B12 포토카드대량 50/50 좌표 완전일치(수량라벨을 가격값 오인한 64% 노이즈 제거).

### 박류 §18 면적 가격 설계 완주 (데이터 설계 GO·DB 미적재)
§18 하네스 전단계(카토그래피→벤치마크→설계→E게이트→codex→폐루프2회 REV2/REV3)→**데이터 설계 GO**. 산출=`huni-price-engine-design/03_design/engine-design-foil.md`(+rev2/rev3).
- 박=동판비(setup·.03 1회성)+박가공비(면적→등급A~E→등급×수량구간·일반/특수박·.02). 신규 5 comp·박색상축=proc_cd(공정 16종 재사용·mint 0)·**7상품 본체 공식 합산 바인딩**(addon 아님·명함박/PRF_DGP_E 입증 패턴).
- 골든 8/8 권위 verbatim(Claude+codex 독립 재계산 0오차).
- ★**codex가 돈크리티컬 적발**(designer·Claude validator 둘 다 놓침): 동판비 setup comp에 proc_cd 게이트 없으면 박 미선택 주문에도 동판비 상시 과금→REV3에서 동판비 use_dims에 proc_cd 추가로 해소.

## ★다음 시작점 (우선순위)
1. **박류 실 적재 승인 큐**(인간 승인 후 dbmap 위임): 신규 5 comp + 동판비/박가공비 단가행(★proc_cd 충전 필수·박가공비 .02 NOT NULL) + 7상품 본체 공식 합산 배선. 단, **C트랙 선결**=면적→등급 환산 엔진 미지원(grade가 pricing.py NON_QTY/TIER_DIMS 부재)→가변사이즈 상품(접지카드/책자)만 종속·고정사이즈(명함류)는 단일등급 collapse로 현 엔진 작동. 개발팀 코드트랙.
2. **디지털/제본 후속(사장님)**: ① 1도 인쇄 상품 생길 때 t_prd_product_print_options에 POPT_000008(단면1도)·POPT_000009(양면1도) 연결 ② 068~070 책자 표지/내지 5비목 누락(저청구)=§23 셋트 구성.
3. **스티커 B02~B07 소블록** 정밀확인(낱장/투명/대형/타투/기본가/스티커팩·노이즈 추정이나 미확정).
4. **§17 정리거리**: G6 명함박 1000구간 단가행 63,000→권위 64,000 라이브 1셀 오적재(교정 후보)·중복 mat_cd(MAT_000260 dup).

## 미해결/블로커
- **박 면적→등급 환산 엔진 미지원**(B-FOIL-2·C트랙 개발팀·가변사이즈 상품 종속).
- **디지털 흑백 상품 노출**=사장님이 print_opt를 상품에 연결해야 손님 선택 가능(단가는 적재됨).
- **068~070 책자 저청구**=제본비만 청구·표지/내지 누락=§23 셋트 구성 작업.

## 이번 세션 결정 (relitigate 금지)
- **가격구성요소 통합 vs 분리 기준**=한 상품 안 손님선택(도수)→차원통합 / 종류·상품다름(별색색상·제본종류)→별도 comp. "디지털=통합·제본=분리"는 부정확(디지털도 별색은 분리). 제본 4책자=별개상품→분리 맞음.
- **합가 우선**[HARD·사용자]=한 시트에 단가·합가 같이 있으면 합가 우선.
- **setup/1회성 comp도 proc_cd 게이트 필수**[HARD·codex 적발]=가공비뿐 아니라 setup comp(동판비)에도 proc_cd 충전 안 하면 미선택 주문 silent 과금.
- **del_yn 복원=정합/표시 교정**(엔진 무관)·박색상축=proc_cd·박 바인딩=본체 공식 합산(addon 템플릿은 단일단가만 담아 다차원 박가공비 불가).

## 건드리지 말 것 (라이브 COMMIT·undo 보유)
- 이번 3 COMMIT(큐리어스880·제본복원3·디지털흑백양면106) + 이전 세션 전부(코팅유광92·흑백단면106·PET2·특수용지18·명함18·포스터transpose 등).
- undo: `_batch/{paper-curious-white,binding-restore-delyn,digital-mono-s2}-undo.sql`.

## 산출물 위치
- 플레이북: `huni-price-table-integrity/_batch/SHEET-LOAD-PLAYBOOK.md`
- 박류 설계: `huni-price-engine-design/{01_formula,02_benchmark,03_design,04_validation,05_codex}/*-foil.md`
- 배치 빌더: `_batch/scripts/`·`ALL-SHEETS-summary.md`
- 적재본/undo: `_batch/*-load.sql`·`*-undo.sql`
- 실측 환경: `_foundation/live-snapshot/`·시뮬레이터 `_foundation/batch/lib_huni.py`
- 메모리: [[price-component-unify-vs-split-criterion-260630]]·[[output-material-load-4principles-260629]]
