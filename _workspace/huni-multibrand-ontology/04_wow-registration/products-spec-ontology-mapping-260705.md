# 와우 products_spec_v1.0 → 온톨로지 정리 대상 분석 (2026-07-05)

> 트리거: 지니 "products_spec_v1.0.pdf 읽고 어떤 값을 온톨로지에 정리할지 확인".
> 원천: `docs/wowpress/products_spec_v1.0.pdf`(24p·prod_info `/api/v1/std/prod_info/{prodno}`).
> ★원칙(D-18 경계): **온톨로지 = 축·연결·제약·규칙(구조·닫힌세계)** / **엔진 = 가격 값(jobcost)** /
> **런타임 = 주문·배송지 입력**. 값 지어내기 0(전 필드 PDF 앵커).

---

## 0. 제품상세정보 구조 (전체 필드 지도)

기본정보 + coverinfo(페이지구성) + **기준정보 4축**(규격·지류·도수·옵션) + **작업정보**(인쇄 prsjob·후가공 awkjob)
+ 부자재(prodadd) + 배송(deliver). 각 축은 **req_\***(요구사항·이게 있어야 생산 가능) / **rst_\***(제약사항·이건 불가)를 가짐.
기준정보 우선순위: `jobpresetno → sizeno → paperno → optno → colorno → colornoadd`.

---

## A. 이미 등록됨 (04_wow-registration·4세션)

- **축 6종**: 재질504 · 규격919 · 도수115 · 인쇄방식12 · 후가공474 · 부자재32 (+ used_by 공유맥락).
- **제약 2종만**: `paper.rst_prsjob`(758) · `color.req_prsjob`(484).

→ **축은 완비, 제약은 2종뿐.**

---

## B. 추가 정리 대상 (온톨로지에 넣을 값) — PDF가 드러낸 것

### B-1. ★완전한 제약 그래프 (핵심·현재 2/약17종) — feasibility의 데이터 토대
| 축 | req_* (있어야 가능) | rst_* (있으면 불가) |
|---|---|---|
| 규격 size | req_width/height(비규격 입력범위)·req_awkjob | rst_ordqty·rst_awkjob |
| 지류 paper | req_width/height·req_awkjob | rst_ordqty·**rst_prsjob**(등록됨)·rst_awkjob |
| 도수 color | **req_prsjob**(등록됨)·req_awkjob | rst_prsjob·rst_awkjob |
| 인쇄 prsjob | req_color | rst_paper·rst_awkjob |
| 후가공 awkjob | req_joboption·req_jobsize·req_jobqty·req_awkjob | rst_jobqty·rst_cutcnt·rst_size·rst_paper·rst_color·rst_awkjob |

→ 이 **조합 가능/불가 그래프**가 프린틀리 배정 "1층 능력·제약"을 데이터로 뒷받침(어느 사양 조합을 와우가 만드나).
§33 후니 제약(§31 CN-1~6)과 같은 상위개념에 걸어 브랜드-중립 feasibility 질의 가능.

### B-2. 규격 입력 규칙 (값이 아니라 규칙)
- `width·height·cutsize·non_standard`(규격/비규격). **비규격**: `req_width/height{type·unit·min·max·interval}` = 입력 범위·컷수 산출("근사규격 1컷 단가 × 컷수").
- ★jobcost 요청에도 직결: 비규격 상품은 width/height 필수(417 에러 근거).

### B-3. 수량 규칙 (ordqty)
- 조합키(`jobpreset+size+paper+opt+color+coloradd`)별 **주문가능 수량**: `ordqtymin/max/interval` + `ordqtylist`.
- **공통형**(전 기준 null=아무 조합이나 동일) vs **조합형**(조합마다 다름). → 상품별 수량 제약.

### B-4. 구조 코드 (책자·양면)
- `covercd`(0통합·1표지·2내지·3간지) · `pagecd`(0양면·1전면·2후면) · `pagecnt{min·max·interval}`(책자 페이지수).
- 표지/내지 = 서로 다른 지류·후가공 선택 가능(구성 온톨로지).

### B-5. 후가공 계층·단위
- `jobgroup`(그룹) · `namestep1/namestep2`(계층명) · `unit`·`unitlist`("인쇄기 종속" 단위) · `ck_page`(페이지 입력여부) · `displayloc`.

### B-6. 추가도수 (coloradd·별색), B-7. 묶음배송 그룹(dlvygrpno=어느 상품끼리 묶음), B-8. 조판마감(ctptime=리드타임 관련·경계적).

---

## C. 온톨로지 제외 (엔진/런타임 · D-18 경계)

- **가격 값**(`ordcost_sup/bill/tax/sup`·jobcost API) = 엔진 권위. 온톨로지는 경계·price_basis만(09 정책).
- **배송지 입력·배송비 계산**(`dlvyto/dlvyfr`·700~753 에러·costadd) = 주문 런타임. 단 **배송 가능 지역**(dlvyloc 시도/시군구/읍면동)·**착불/선불 가능여부**는 온톨로지 참조 가능(제약성).
- **무료배송 회원등급 최소액**(dlvyfree usrkd·mincost) = 정산 런타임.
- **timestamp** = 동기화 메타(값 아님·최신성 체크용).

---

## D. 결론·함의

1. **현재 등록 = 축 완비·제약 2/17** → **B-1 제약 그래프 등록이 최우선**(feasibility "어느 벤더가 이 조합을 만드나"의 데이터 토대·프린틀리 배정 3층 1·2층).
2. B-2~B-5(규격 입력규칙·수량규칙·구조코드·후가공 계층)는 **주문 화면 구성 + jobcost 요청 생성**에 직결(스펙 정규화·가격 fetch와 같은 데이터).
3. 가격은 온톨로지 밖(엔진)·배송지는 런타임 — 경계 유지.
4. ★후니와 동형: §33도 같은 4축+제약(req/rst) 모델 → 상위개념 정렬 시 브랜드-중립 feasibility 성립.

**다음**: B-1 제약 그래프를 wow-components.json 제약 확장으로 등록(현 2종 → 전 req_*/rst_*)·상위개념 매핑.
