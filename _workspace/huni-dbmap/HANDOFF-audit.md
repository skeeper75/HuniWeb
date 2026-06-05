# Huni-DBMap round-3 핸드오프 — 처리(적재) 설계 완료

작성 2026-06-05 · 이 문서만 읽고 이어가도록 정리. 식별자/코드/SQL 영어, 설명 한국어.

## 0. 한 줄 현황

round-3 **처리(적재) 설계 완료 — 11시트 전수 + 도메인 컨펌 해소**. 작업 목적 = 엑셀 적재 결함(누락/오매칭/모호)을 도메인 토대로 처리해 인쇄자동견적 위젯용 DB 정제([[dbmap-true-purpose-remediation]]). digital-print **파일럿**(패턴+자동대조 게이트 정립) → **Wave A/B 전수 적재설계**(dbm-mapping-designer, 11시트) → **독립 적대검증**(dbm-validator 5종) GO → **NO-GO/CONDITIONAL 2시트(calendar·acrylic) 보정** → **도메인 컨펌 해소**(자가확보 권고 → K-1~5 결정). active ~835행 + UPDATE-set, 전 게이트 누락0·날조0, 발명0·dodge0. **DB 미적재 유지**.

> [다음 세션 시작점 — 여기부터]
> 1. **입력** = `09_load/_load-dashboard.md`(전수 종합 대시보드) · `08_remediation/_confirmation-recommendations.md`(컨펌 권고 + 사용자 확정 §10) · 각 `09_load/<sheet>/load-spec.md` · `03_validation/{dp,waveA1,waveA2,waveB1,waveB2}-load-validation.md`(검증 5종).
> 2. **다음 = (A) booklet 실무 자재정보 입력** 또는 **(B) DB 적재 인가** — 둘 다 외부 의존:
>    - **(A)** booklet 5상품(070 PUR·072 하드커버·077 레더하드·082 하드링·088 레더바인더) 내지종이 = 엑셀/IMPORT 소스 부재(K-1 데이터 확인 완료) → **후니 실무 자재정보 필요**. 입력 시 `09_load/booklet/_deferred` 6행 해소.
>    - **(B)** 적재 인가 시: ① **master 신설** — `레이저커팅` proc_cd 1(K-2)·형상 siz_cd(굿즈14·스티커 원형11/형상, K-3/4) ② **[HARD] 적재 직전 라이브 export로 `verify_expected.py` 재실행**(게이트가 stale ref 2026-06-04를 읽음 → 라이브 격차 닫기, calendar PK충돌이 실증) ③ conditional 행(digital-print 016 DROP·calendar material 4·acrylic 151) 라이브 재확인 ④ FK순 INSERT(size→material→process[excl_group 연결]→addon→page_rule).
> 3. **이번 세션 결정**(재론 금지, `_confirmation-recommendations.md §10` 권위):
>    - **K-1** booklet 내지자재 = IMPORT 컬럼 부재 확인 → 실무자재 잔여
>    - **K-2** acrylic 모양컷 = `레이저커팅` proc_cd 신설(053 종이완칼 차용 중단)
>    - **K-3/K-4** 형상+치수 siz_cd master 신설(엑셀 크기 표준목록 등록, 모양=공정 유지·치수=size·A4/A5=plate). goods-pouch "77 BLOCKER"는 의미축 4분리 결과 siz_cd 신설은 14건뿐(용량21·단양면12·라벨49는 다른 축)
>    - **K-5** photobook = 엑셀 제본 컬럼대로(PUR 적재 완료, 외부 표준 재고 불요)
>    - **[도메인해소]** calendar 미연결멤버 = "없음"=빈선택지(proc 신설0)·거치대=addon·장수=옵션(page_rule 아님) / photobook 책등 = master `prcs_dtl_opt.책등` 상속+위젯 런타임(DDL 불요)
> 4. [HARD 원칙] DB 미적재 · 라이브 권위(추출본 stale) · 추정0(provenance) · **엑셀 명시값=권위, 외부표준으로 재고 금지**([[dbmap-domain-knowledge-before-asking]]) · 사용자 질문은 비전문가 이해 가능하게 평이하게.

## 1. 건드리지 말 것 (확정 산출)

- **`09_load/` 11시트 적재설계 + load CSV + 게이트** — 전 시트 self-check PASS(누락0·날조0), 독립검증 GO. calendar(PK충돌 4행 conditional)·acrylic(완칼 17→14·151 conditional) 보정 완료.
- **`03_validation/` 검증 5종** — UPHELD 합계 다수·OVERTURN 0(보정 반영 후)·NO-GO 0.
- digital-print 016 conditional **DROP 확정**(라이브 29~32 실재) · `00_schema/columns.csv` 3테이블 메타 보강 · `08_remediation/digital-print.md` 029 use_yn 정정.
- **보수처리 정당분(재공격 금지)**: silsa 봉제/타공 모범 재적재0 · photobook 9속성 기적재 no-op · product-accessory 대조군 · **goods-pouch size BLOCKED-LEGIT**(비치수 마스터 모델링 미정 — 적재 누락 아님).

## 2. 미해소 (적재 전 — 외부 의존)

- **booklet 5상품 내지자재** = 후니 실무정보(엑셀/IMPORT/라이브 소스 부재, 발명 금지).
- **master siz_cd/proc_cd 신설** = DB 쓰기 승인 필요(레이저커팅 proc·형상 siz_cd).
- **시트별 잔여 컨펌** = 각 `09_load/<sheet>/load-spec.md §컨펌목록` 권위.
- **가격정보(round-2 t_prc_*)** 이연 = `06_extract/price-info-deferred.md`. round-1 구간할인 완료.

## 3. 산출물 지도

```
_workspace/huni-dbmap/
├ 09_load/            (이번 세션 핵심) _load-dashboard.md + 11 <sheet>/{load-spec.md·load/*.csv·verify_expected.py·expected-vs-load.md·_deferred·*conditional.csv}
├ 03_validation/      dp-·waveA1-·waveA2-·waveB1-·waveB2-load-validation.md (독립 검증 5종)
├ 08_remediation/     11 <sheet>.md(결함 진단)·_summary.md·_confirmations.md(C-1~12)·_confirmation-recommendations.md(K-1~5 확정 §10)
├ 07_domain/          db-domain-structure-live·pdf-domain-knowledge·entity-semantic-model(L3)·process-recipe-tree(L2)·benchmark-competitors
├ 06_extract/         15 <slug>-l1.csv(L1 토대)·product-info-foundation·price-info-deferred·seoljeong-import-map
├ 04_audit/           round-3 L2 검증 v2(이전 단계, 보존)
├ 00_schema/          ref-*.csv·columns.csv(3테이블 보강)·price-engine-ddl
└ HANDOFF-audit.md    (이 문서)
```

## 4. 이전 이력

round-3 L1 토대 정립·L2 정합 재검증 v2 상세 = `04_audit/v2`·`06_extract`·이전 git 핸드오프(git log). 본 핸드오프는 그 위에 적재설계까지 완료한 기준으로 갱신됨. 전체 변경 이력 = `CHANGELOG.md`.
