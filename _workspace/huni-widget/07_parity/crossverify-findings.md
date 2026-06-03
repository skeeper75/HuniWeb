# 팀 교차 재검증 발견 (B) — 2026-06-03

에이전트 팀 `huni-parity-crossverify`(authority-lens·integration-lens·assumption-lens 3렌즈, 자체조율)이 코드 레벨 정합(S0~S3, 서브에이전트 순차 검증으로 ALL GO였던) 결과를 교차 재검증. **서브가 못 본 신규 결함을 다중 렌즈 + 실시간 상호확인으로 발견.**

## 신규 결함 (서브 순차 검증이 ALL GO 했던 것)

| ID | 심각도 | 발견 | 근원 | 처방 |
|----|--------|------|------|------|
| **C-B** | MAJOR | 자재 왕복(RXOMO080→RXART300) 시 required 합성그룹(COT__side/__coating) re-enable됐으나 selection 영구 undefined → 가격요청서 코팅 소실. C-A 동형, 136테스트 미커버, day-1 발현 | cascade.ts:136 `cur==null` continue + C-2폴백이 disable-시점만(re-enable 복구경로 없음) + visible+required 합성그룹은 hidden-essential 자가복구(71-76) 못 받음(비대칭) | cascade 종료 시 required+empty+활성값보유 그룹 firstActiveOf 재적재(applyVisibilityAndEssential의 `g.visible` 조건 제거=1곳). Red mod_07:2266 coating watcher(`find(!disabled)` 빈값금지)와 정합. 신규 contract 0 |
| **G-1** | MAJOR | QUANTITY_ECHO 상품별맵 위반 — 어댑터 `{SUB_MTR,PDT_WRK,INN_DFT}` 전역 set인데 Red(mod_06:914 MATERIAL_PCS_CODE_MAP)는 상품별. ① ACPDSTD SUB_MTR 12옵션(add-on, ATTB=None)에 `ATTB=quantity` **날조주입** ② DIR_MTR(5상품)·WRK_MTR(GSTGMIC) **누락** ③ 전역 req.quantity가 Red per-size quantity와도 불일치 | red-adapter.ts:132,566,571 PCS코드 전역 적용. blocker-fix-verification은 수량형 SUB_MTR fixture만 봐서 미검출 | QUANTITY_ECHO를 (상품코드,PCS코드) 쌍 또는 product_info 자재연결 신호 기반으로 좁힘. 컨버전 시 옵션마스터 자재연결 ATTB 의미 게이트 |
| **G-2** | MAJOR | 에디터 가격콜백 미배선(no-op) — EditorOverlay.tsx:24-34가 page-count-changed/prod-var-changed/request-user-token 3콜백 미전달 → editor-bridge `?.` 조용히 no-op. **stale-price 주문벡터**: 면수↑로 가격 올라야 하나 옛 가격(>0) 유지→ok:true→침묵 저가주문(PRICE=0 게이트는 0만 막음). Red getKOIEditorTabData(mod_06:1218)는 PCS_INFO 재구성+가격재호출 | EditorOverlay 콜백 미전달. setPageCount(widget-store.ts:211)는 이미 존재, 연결만 누락 | EditorOverlay가 onPageCountChanged→setPageCount→재quote, onProdVarChanged→재계산, onRequestUserToken→BFF토큰갱신 배선. 책임소재(위젯 재계산 vs 호스트 위임) 계약 명시 |
| **L-3** | PARTIAL (RESOLVED→하향) | size-linked 반경(GSCDPOP factor='size') dead code — red-adapter.ts:206이 divSeq 없이 roundingRadius() 호출 → component-type-map.ts:66-68 size 분기 미도달, cascade radius 재계산 0건. 항상 '4' echo(Red '3'/'6'). 현재 GSCDPOP fixture 부재로 **dormant**, 실 BFF 배선 시 침묵 가격왜곡 | 어댑터 divSeq 미전달 + cascade size-watch 부재 | 어댑터가 ROU size-watch cascade 룰 발행 + cascade.ts divSeq→radius 재계산. 또는 컨버전 게이트로 명시 |
| G-3 | MINOR | deob 라인번호 참조 밀림(2586/2467/2511/3300 등 vs 실제 2607줄) — deob 재생성. 추적성 저하 | 주석 라인앵커 stale | 라인앵커 갱신(증거능력 영향 적음) |
| 잠복 | LOW | price.ts:100-103 합성 재합성이 `{groupId,valueId}`만 emit, attb 미포함. 전 fixture COT/SCO×ATTB_CD 공존 0건이라 현 무발현 | 합성 경로 attb 미전달 | 컨버전 게이트: "합성그룹 ATTB 보유 여부" 체크리스트 |

## 무결 확인 (과대평가 방지)
- P4 visible 토글 × material-disable 시퀀싱: 무결(hidden-essential이 전체-disable 그룹 정확히 skip)
- apparel visibilityRules × 비의류: 무결(비의류 rules=[] no-op, 누출 0)
- L-2 2축 분해·재합성 / L-4 color-chip hex / L-3b 고정반경 GSCDPOP-only / C-A base-id 매칭 / D-L3 PRICE=0 차단: 소스 직접 대조 fabrication 0 재확인(hw-qa 판정 지지)
- S0~S3 골격(38↔14 정규화·5스토어·itemGroup 분기축): 소스 정합 유효

## 팀의 가치 (서브 대비)
공통 패턴: **"통과한 테스트가 본 것은 일부 fixture뿐"**. 서브 순차 재검증은 수량형 SUB_MTR·고정반경·단일자재경로·단위테스트만 봐 GO. 팀은 상품별맵(G-1)·자재왕복(C-B)·에디터 stale(G-2)·size-linked dead(L-3)를 코드 트레이스+vite-node probe로 발견. integration→authority C-B 권위확인 요청, assumption→authority G-2 코드확정 = 실시간 상호검증(순차 불가).

## 보정 우선순위 (제안)
1. C-B(day-1 발현, cascade 1곳) · G-2(stale-price 벡터, EditorOverlay 배선) — 즉시
2. G-1(가격 직결, QUANTITY_ECHO 상품별맵) — 즉시
3. L-3(dormant) · 잠복(컨버전 게이트) — 컨버전 단계 또는 후속
4. G-3 — 정리 시

## 처리 결과 (2026-06-03 fix 라운드 — hw-builder)
- **C-B [RESOLVED]**: cascade.ts `applyVisibilityAndEssential` 의 required 자가복구를 visible/hidden **대칭**으로(이전 `g.visible` 조건 제거) — applyCascade 종료 시 idempotent post-pass 로 동작해 `allDisabled delete; continue` 의 폴백 우회 + re-enable 복구를 모두 닫음. 자재 왕복(RXOMO080→RXART300) → COT__coating 재적재 검증. Red mod_07:2266 coating watcher 정합.
- **G-1 [RESOLVED, 정정반영]**: QUANTITY_ECHO_PCS 에 `WRK_MTR`·`DIR_MTR` 2종 추가(red-adapter.ts). Red 4종 자재연결 PCS(SUB_MTR 2597/PDT_WRK 2954/DIR_MTR 2470/WRK_MTR 3572) 전부 ATTB=orderQty. **정정**: ACPDSTD SUB_MTR `ATTB=quantity` 는 **날조 아님**(Red SUB_MTR 도 orderQty default) → 유지(제거하지 않음). 초기 오검출(SUB_MTR 제거) 철회. LATENT(SUB_MTR QTY_INPUT_YN==='Y' 컴포넌트-로컬 수량 분기)는 fixture 부재로 dormant → 컨버전 이연.
- **G-2 [RESOLVED, severity 정정반영]**: EditorOverlay 가 prod-var-changed→재계산(MAJOR), page-count-changed→setPageCount(MINOR, 최종가는 applyEditorResult 가 이미 재계산), request-user-token→refreshEditorToken(BFF config 재발급) 배선. 이전 no-op stale-price 벡터 해소. store 에 `refreshEditorToken` 액션 추가.
- **PRICE=0 [재정의 반영]**: `mapPriceResponse` finalPrice=0 시 ok:false 유지 + `priceUnavailableReason`(contract additive) + console.warn 비치명적 진단. throw 안 함(미캡처 fixture 보존). B1 "포스터 미가격" 오진 철회 — parity-gap-map.md 정정 섹션 참조. PRICE>0 재캡처 TODO: BNBNFBL/BNPTPET/CLSTSHS/ACPDSTD/GSSBMTL.
- **L-3 [DEFER]**: size-linked 반경(GSCDPOP) dead code — fixture 부재 dormant. cascade post-pass 는 selection 복구만(반경 ATTB 재계산은 별 메커니즘) → 컨버전 게이트 이연.
- **게이트**: tsc 0 / vitest 148(136+12) / build OK.
