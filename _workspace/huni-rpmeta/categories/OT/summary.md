# OT(상자·패키징 = 케이크/납작/반달/봉투/답례품 상자 + 클래퍼·에어홀더) 카테고리 — RP-Meta 파이프라인 요약

> 후니 RP-Meta 하네스. RedPrinting OT(박스/패키징) 카테고리의 역공학→메타모델→갭→deepcheck→검증→codex 교차검증 파이프라인 산출 인덱스.
> **★OT 본질 = 평면 인쇄지(접지 가공)로 출고·입체 조립은 고객 수작업 · distinct 0 → 17축 재포화(12번째 카테고리).** OT는 **선별 모드 프로브** = "전개도/dieline(접지 구조)이 distinct #18 관리축인가". 박스는 전개도(dieline/net)·3D 입체치수·칼틀(도무송)·접합이라는 *평면 인쇄물에 전무했던 입체/전개 차원*을 가진 첫 상품군이라 강력한 #18 후보였으나 **부결** — ①전용 슬롯조차 부재(박스 옵션=평면 인쇄물 paper/sodu/size/number 100% 동형)·②후니 KB 무왜곡 흡수. PH-2 거치·FS-1 타일링(①OBSERVED·②불충족)보다 더 약한 후보의 더 깨끗한 부결.

## 산출물
- **역공학(reverse):** [`reverse.md`](reverse.md) — 대표 6/7상품(OTPKCAK 케이크·OTPKFLT 납작·OTPKHMN 반달·OTPKENV 봉투·OTPKARP 답례품 상자 + OTPOCLP 클래퍼; OTCPHOL 에어홀더 미캡처) playwright `/detail` 레거시 SSR select 폼 실측([`captures/`](captures/)·읽기전용·주문 0). 원자추출 + 박스 특유 슬롯 + 전개도 #18 1차 예측. Ambiguous fragments O-1~O-4.
- **메타모델(02_metamodel):** [`_resolved-fragments.md`](../../02_metamodel/_resolved-fragments.md)(OT O-1~O-4) + [`discovered-axes.md`](../../02_metamodel/discovered-axes.md) §OT(v12.0). **★distinct 승급 0건.** OT facet 흡수: 전개도 work/cut 치수→사이즈#13·3D 입체치수(W×D×H)→사이즈#13 파생(앱계산·미저장)·도무송 칼틀/오시 접지→공정#2·박스형태(케이크/납작/반달)→사이즈#13 프리셋+카테고리#7·dieline 에디터→완제SKU#16 TemplateAsset·OTPKENV 커스텀→카테고리#7 운영 라벨.
- **★전개도/dieline distinct #18 적대검증 (선별 모드 프로브):**
  - **전개도 #18 부결.** ①전용 슬롯 부재(박스 옵션 = 평면 인쇄물 paper/paper_sub/sodu/size/number 5슬롯 100% 동형·ST `shape_info` 같은 전개도/접지/3D 전용 슬롯 0)·②KB 결함 부재(사이즈#13 work/cut·공정#2 도무송/오시·카테고리#7 흡수). ST 형상#17(①②둘 다 충족=승격)과 결정적 분기.
  - **★형태가공#14 음의 사례 확정(핵심):** #14(GS/PD)=RP가 평면→입체 *생성* ↔ 박스=평면 접지지까지만 RP 생산·입체 조립은 **고객 수작업**("납작하게 접힌 상태 배송") = #14의 정반대. 박스가 "#14는 본체 생성이지 모든 입체화가 아니다"를 음의 사례로 확정.
  - **★O-3 결정적 분기 = data-gap/PASS(vessel-gap 아님):** 박스 재단(485×270) vs 작업(495×280) 2치수는 후니가 이미 `t_siz_sizes` 단일행 work_width/height·cut_width/height·margin 8컬럼으로 분리 모델링(실데이터 66행 work≠cut). 박스 siz 프리셋 미적재일 뿐 표현력은 완비. ST 형상 vessel-gap과 결정적 구분.
- **갭(03_gap):** [`gap-matrix.md`](../../03_gap/gap-matrix.md) §OT(v12.0) — 후니 라이브 information_schema 직접 SELECT(2026-06-19 read-only). **★OT facet = PASS(전개도 2치수·도무송/오시 PROC·3D 파생·커스텀 라벨)·data-gap/unobserved(dieline 에디터 템플릿)·★신규 vessel-gap 0**. **OT가 추가하는 vessel-needs = 0건**(V-11·V-12 불변·search-before-mint 12연속 통과). data-gap: 박스 siz 프리셋 미적재(round-22 ②사이즈)·dieline 에디터 접지좌표 스키마 미관측.
- **deepcheck(Phase 4.5·codex 발굴):** [`deepcheck.md`](deepcheck.md) — codex(gpt-5.5) triage(전부 unverified·거부 0). **신규 distinct 후보 0·codex 전개도 #18 부결 12번째 독립 동의.** 최강 DC-1(structural dieline subtype)도 distinct 도전 아닌 vessel 정밀화(makers 응답=generic 포인터·구조 좌표 부재→TemplateAsset 충분으로 닫힘). DC-2 OTPKENV custom parametric·DC-3 rigid flat-ship·DC-4 골판 flute·DC-5 식품접촉 constraint = 전부 data-gap/엣지/unobserved.
- **검증(05_validation):** [`mgate-verdict-OT.md`](../../05_validation/mgate-verdict-OT.md) — **M1~M6 전건 GO**·distinct 0 비준·전개도 부결 확인·라이브 4쿼리 일치(t_siz 8컬럼·work≠cut 66행·PROC 오시/접지/형압/타공·templates 그릇·height 컬럼 부재=3D 파생)·결함 0(Low 2: L-OT-1 O-3 문구 단일화·L-OT-2 makers observed→부결 보강).

## ★codex 교차검증 (Phase 6.5·정식 에이전트 3번째 실증)
> codex cross-validation (Phase 6.5): gpt-5.5 독립 ABSORBED 판정 = validator 전개도 #18 부결과 **전 10항 합의·고신뢰 confirm·divergence 0**. 원문 [`codex-verdict.md`](codex-verdict.md)·reconcile [`codex-reconcile-OT.md`](../../05_validation/codex-reconcile-OT.md).

- **독립성[HARD] 보존:** codex에 우리 verdict("전개도 부결") 비노출·workdir=`categories/OT/` 격리. codex가 17축 frame만 보고 ABSORBED를 독립 도출(전개도→#13·칼선/오시→#2·glue tab→#2/TemplateAsset·박스형태→#7+#13·flat 3D 조립=#14 아님). codex가 validator의 L-OT-2(makers gcs 미해석 fabrication 경계)를 **독립 일치** 지적.

## 종단 결론
**OT = 17축 재포화 12번째 카테고리·distinct 0·신규 vessel 0.** M1~M6 GO + codex 교차검증 전 10항 합의로 고신뢰 확정. 상품 커버리지 누적 ≈ 394/479(82%). **★OT의 의미:** 평면 인쇄물에 전무했던 *입체/전개/접합* 차원을 가진 첫 상품군조차 새 축이 아니라 사이즈#13(work/cut)·공정#2(도무송/오시)·카테고리#7의 무왜곡 분배 흡수 → 17축 그릇의 강건성을 입체물에서 재입증. data-gap(박스 siz 프리셋·dieline 좌표)은 dbmap 적재 트랙. carry-forward: OTCPHOL 에어홀더 미캡처·DC-2 OTPKENV custom parametric 재확인·박스 식품접촉 constraint.
