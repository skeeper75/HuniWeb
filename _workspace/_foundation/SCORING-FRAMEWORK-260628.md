# 상품 구성 채점 프레임워크 SOT (2026-06-28) — 파이프라인 종료 척도

> 권위 문서. 이 프레임워크가 "한 상품이 가격적으로·주문가능하게 완성됐다"의 **객관적 종료 술어**를 정의한다.
> 목적: RC-1(종료 척도 부재)을 닫아 분석 과잉·문서 난립을 끝낸다. **새 하네스 아님** — §27 마스터 오케스트레이터의 계측 레이어.
> 근본원인 진단(2 독립 에이전트 수렴)=`call-analysis-260628/`(반환 종합·본 문서가 그 단일 산출물).

## 0. 왜 안 풀렸는가 (수렴 진단)
부품은 다 있다(§26 권위격자 3,199행·엔진 `grand_total` `price_views.py:1810`·라이브 오라클 `_huni_live_crosscheck.md`·`_sim_verify.sh`). **배선이 없다** — `enumerate→evaluate→reconcile→GROUP BY prd_cd`로 묶어 상품당 수치를 내는 드라이버 + 스코어보드 CSV가 부재. 그래서 판정이 **산문 매트릭스**에 갇히고 점수로 안 모임. (`_foundation` 전체 `score/일치율/pass_rate` grep 0건.)

근본원인 레버리지 순서: **RC-1 종료척도 부재**(최고) → RC-2 오라클이 맨 끝(사후 재발견) → RC-3 분석과잉 vs 적재부족(46 designed_not_loaded) → RC-4 가격 정답표 SOT 부재 → RC-5 엔진 계약 갭은 데이터로 못 닫음(C트랙).

## 1. 두 점수 (상품 단위·별도 산출·합산 금지)
합산하면 결함이 가려진다. 성격이 다르므로 분리.

### A. 가격 재현 점수 (PR_score) 0~100
- 자 = **권위 격자**(§26 정답 격자·엑셀 절대권위). 케이스 = 전 사이즈 × 대표 수량밴드 × 옵션 토글.
- `cell_match` = `|actual − authority_supply| ≤ 0원`(돈크리티컬·허용오차 0).
- **PR_score = 일치 셀 / 권위격자 전 셀 × 100.** 만점 = 전 셀 일치 + 미적재 셀 0 + `PRICE≠0` 전건.
- 부가(점수만큼 중요): **`money_delta_sum`**(권위−실제 절대오차 합·over/under 방향별). 1% 셀 틀려도 ×1000 밴드총액이면 치명.
- ★**G1/G2 자동노출**: 채점 격자를 **자동주입 없는 엔진 입력 그대로**(필수공정 `mand_proc_yn`·기본자재 `dflt_yn` 미주입) 돌리면 = 위젯/API 실제 경로 재현 → 인쇄비·자재 comp 누락 = PR 하락 + `money_delta` 음수(저청구). 엔진 갭이 점수로 스스로 드러남.

### B. 주문 완전성 점수 (OC_score) 0~100
- 9축(사이즈·자재·공정·도수·기초코드·카테고리·옵션·템플릿·제약) 중 권위가 요구한 축을 손님이 **선택 가능**하게 등록했는가.
- 축 충족 = ① 권위 요구(needed=Y) → ② 라이브에 손님 선택 엔티티 존재(★`option_items.ref_key1` 봐야 함·`product_materials` 단독 함정 [[sticker-pipeline-260628]]) → ③ 선택이 견적 환원(`PRICE≠0`).
- **OC_score = 충족 축 / 권위 요구 축 × 100.** 어느 한 축이라도 손님이 못 고르면 주문 불가 = **상한 cap**(이진 게이트 우선).
- 목표 화면 분모 = 경쟁사(레드/와우)+인쇄도메인+라이브 ASP `goods.asp` `<select>` 옵션 셋(설계 선행은 OC에만·PR엔 부적절).

## 2. 스코어보드 스키마 (빠진 산출물)
케이스 격자 CSV 1행 = 채점의 원자. **이 한 파일이 RTM의 서사 status를 대체한다.**
```
prd_cd, case_id(siz×qty×opt), authority_supply, engine_price, live_price, match(0/1), money_delta, axis_filled(9bit), oracle(excel|engine|live), note
```
→ `GROUP BY prd_cd` 로 상품당 `PR_score`·`OC_score`·`money_delta_sum` 산출. 진척판 = 275상품 × {PR, OC, money_delta, C트랙_blocked, next_action}.

## 3. 채점 대상 = 권위 충실도 (자유 구성 탐색 아님)
- 9축 **값**은 권위 엑셀이 given(탐색 금지·SOT·[[price-design-before-verify]]). "어떤 조합이 최고점"을 자유 탐색하면 권위 위반.
- ★단 **구현 모델 선택**은 채점 가치: 같은 권위값을 재현하는 모델이 여럿(고정가 by-siz/면적격자/addon템플릿/합가/누적 [[price-model-decision-tree-sim-gate]] 5모델). **어느 모델이 PR=100 AND OC=100을 동시 만족하는가**가 실제 선택지(예: addon을 opt_cd 가산형으로 짜면 라이브 미작동→PR 0 [[addon-optcd-model-broken-live]]). 비용 커서 상품군 대표 1개만 모델 셰이크아웃→동형 전파.

## 4. 종료 술어 (stopping criterion)
**상품 닫힘 = PR_score=100 AND OC_score=100 AND 미해결 조사신호 0 AND C트랙 항목 반영.**
- ★**C트랙을 점수 1급 시민으로**: 엔진 H1(필수공정·기본자재 자동주입 불변식)·webadmin B1/B2/B3 코드결함은 데이터로 못 닫음. 점수에 `C트랙_blocked` 플래그를 명시해 "개발팀 배포 없이는 점수 100 불가"를 가시화(안 하면 "영원히 92%" 새 무한꼬리).
- 파이프라인 전체 종료 = 275상품 전부 닫힘. "분석 남았는가"가 아니라 "점수 100인가"가 종료 기준 → 문서 생성 동력 차단.

## 5. 첫 실행 (파일럿) — 아크릴 키링 146
- 선정 이유: 3모델(면적격자+addon 고리/볼체인) 한 상품에 다 보유·라이브 1:1 검증됨(`acryl-live-crosscheck-matrix.md`)·회귀 핫스팟([[acrylic-integrity-260628]]).
- 드라이버(신규·단일 스크립트·기존 부품 재사용): `conformance-checklist.csv` 146행 + §26 권위격자 읽어 케이스 enumerate → (a) 엔진 `price_simulate` (b) `_sim_verify.sh compute_read`(webadmin 시뮬) (c) `_huni_live_crosscheck.md`(라이브 ASP 공급가) 3원 채점 → 스코어보드 CSV 1행/케이스 → 146 상품점수.
- 진단 검증: 산문 매트릭스(acryl-matrix)가 자동 수치로 재현되면 = RC-1 처방 입증 → 동형 전파.

## 6. 하드닝 액션 (이 프레임워크가 닫는 갭)
| 액션 | 대상 | RC |
|---|---|---|
| 스코어보드 CSV가 RTM 서사 status 대체 | §27 `huni-price-master-orchestrator` SKILL | RC-1 |
| 채점 드라이버(enumerate→3원 채점→집계) | 신규 스크립트(§27 도구·문서 아님) | RC-1·RC-2 |
| C트랙 점수 1급 시민(엔진 H1·B1/B2/B3) | §27 종료 술어 + 개발팀 큐 | RC-5 |
| 라이브 오라클을 채점기 본체로(끝이 아니라) | 드라이버 (c)단계 | RC-2 |
| 미적재면 0점(설계≠적재 가시화) | PR_score 정의 | RC-3 |

## 7. 멈출 것 / 시작할 것
- **멈춤**: 새 하네스·새 진단 문서·새 매트릭스 동결(22 하네스=분석과잉). FINDING/crosscheck/매트릭스가 같은 교훈 3~5중 재서술.
- **시작**: 채점 드라이버 + 스코어보드 CSV **단 하나**. 파일럿 146 → 전수 전파. 이게 "분석 과잉 vs 적재 부족"을 끝낼 객관적 진척 자.
