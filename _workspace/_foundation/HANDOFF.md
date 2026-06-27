# 가격 파이프라인 세션 핸드오프 — 2026-06-27

## 다음 시작점 (한 줄)
**`huni-price-master-orchestrator` 스킬로 아크릴 상품군 종단 실행** — 단, 먼저 아래 "미해결 결정 1(코드 배포)"을 사용자에게 확인하고 시작.

---

## 이번 세션 라이브 COMMIT (되돌리지 말 것)
모두 dryrun→검증→인간 승인 후 COMMIT. 단가값 권위 verbatim·물리삭제 0(논리삭제 del_yn). 로그=`remediation/_REMEDIATION-LOG.md`.

1. **명함 034 펄** — 자재 collapse 해소(단가행 8: 다이아/실버/골드=9000/10000·로츠쿼츠=10000/11000) + 바인딩(PRD_000034→PRF_NAMECARD_PEARL). 견적 가능. 바인딩 distinct prd 82→83. 엔진 검증 8경우 ✅. SQL=`namecard-034-pearl-{fix,dryrun,undo}.sql`.
2. **굿즈 기초 시범 3(230/231/232 레더 파우치)** — 크기 연결(기존 코드 재사용 6: SIZ_433~438) + 잘못 적재된 M/L 소재(MAT_319/320) 논리해제. SQL=`goods-pouch-pilot-*.sql`.
3. **굿즈 사이즈 라벨 모델 확정 + 230 표본** — ★방식 B 확정(라벨 옵션). 230에 옵션그룹 OPT_000073(사이즈·택1)+옵션 OPV_000463/464(M/L)+아이템 2(→siz_cd). 손님 라벨(M/L)→크기코드→가격축 연결. SQL=`goods-size-label-pilot-*.sql`.
4. **아크릴 157 등록사이즈 가격모델** — 신규 COMP_ACRYL_3T_BYSIZ(완제품비·단가형·use_dims=[siz_cd,min_qty]·자재무관) + PRF_ACRYL_BYSIZ + 단가행 2(60x60=5900·55x86=7800) + 바인딩. 엔진 검증 ✅(전 버그 2500→정답). SQL=`acryl-bysiz-157-{fix,dryrun,undo}.sql`.

## 이번 세션 신규 구축 (하네스/오케스트레이터)
- **§26 Huni-Price-Table-Integrity 하네스** — 권위→라이브 적재 무결성 진단(미적재 셀·차원 누락·정합 불일치). 4 에이전트 hpti-*·방법론 스킬 `hpti-load-integrity-audit`·오케스트레이터. CLAUDE.md §26.
- **§27 가격 종단 마스터 오케스트레이터** — 상품군 단위 5단계(무결성§26→교정적재§7→설계§18→적재§7→검증§21/§13) 수렴 실행. 스킬 `huni-price-master-orchestrator`·진척판 RTM. CLAUDE.md §27.

## ★미해결 결정 (다음 세션 선결)
1. **[코드 배포] 가장 중요** — 사용자가 `pricing.py`에 `_reduce_siz_dims`(siz_cd→cut_width/height 환원) 추가. **검증 완료: 로직·연결(evaluate_price L407)·효과 모두 정상**(아크릴 전 사이즈 정답가). 단 **raw/webadmin은 로컬 복사본**(미배포). 라이브 운영(huni-admin-production)=별도 레포 HuniProductPrice2.
   - **확인 필요:** 이 수정이 운영에 배포됐나?
     - 배포됨 → 아크릴 6개를 **기존 면적공식(PRF_CLR_ACRYL)에 바인딩**(단일 진실원). 내가 만든 157 데이터모델(COMP_ACRYL_3T_BYSIZ)은 **중복→되돌림**(undo 있음).
     - 미배포 → 157 데이터모델 유지(임시책)·배포 후 면적공식 전환.
   - 운영 코드 반영 전 `tools/test_pricing.py` 회귀 실행 권장(돈 영역).
2. **[아크릴 158~162]** — dryrun 준비됨(`acryl-bysiz-rest-dryrun.sql`·신규 단가행 8+바인딩 5, 전 사이즈 커버 검증). 단 결정1에 종속(코드 배포면 데이터모델 대신 면적바인딩).
3. **[굿즈 batch1 67개]** — dryrun 있으나(`goods-pouch-batch1-dryrun.sql`) **t_prd_product_sizes 연결만**. 방식 B(라벨 옵션) 확정됐으니 **옵션 층(그룹→옵션→아이템) 라벨까지 추가하도록 재생성 필요**(230 표본 형태). 73개 중 67 기존코드/7 신규/14 무권위.

## 이번 세션 결정 (relitigate 금지)
- **가격은 설계 먼저·시뮬레이터는 검증도구**(표면 바인딩 금지·돈크리티컬). → memory [[price-design-before-verify]].
- **사이즈 표현 = 방식 B(라벨 옵션)** — 손님 라벨(opt_nm)→크기코드(siz_cd·생산치수)→가격축. 새 속성/코드 0·기존 장치만. 레드프린팅도 동일(사이즈=치수차원·변형=라벨/코드).
- **기초마스터 코드 삭제금지·추가가능·이름변경가능** → memory [[base-master-code-no-delete]].
- **사용자=비전문가·쉬운 말** → memory [[user-nonexpert-plain-language]].
- 아크릴 siz_cd×면적 = 순수 코드버그(데이터 우회 가능하나 등록사이즈 모델 or 코드환원이 정석).

## 건드리지 말 것
- 위 COMMIT 4건(명함034·굿즈230~232·230라벨·아크릴157). undo 스크립트 보유.
- 명함 대표코드 MAT_127/130, 굿즈 M/L 마스터코드 MAT_319/320(논리해제만·코드 보존).

## 진척판 (다음 세션 갱신)
`_workspace/_foundation/price-pipeline-rtm.csv` — 미생성. 마스터 오케스트레이터 첫 실행 시 생성(상품군×5단계 상태).
