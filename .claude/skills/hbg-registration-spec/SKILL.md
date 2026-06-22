---
name: hbg-registration-spec
description: >
  후니프린팅 기초코드 거버넌스 하네스의 등록 명세 설계 방법론 스킬. 진단 결함 라우팅을 "기초코드 마스터에 무엇을 어떻게
  신규 등록/교정/축이동할지" 실행 명세로 변환(대상 t_*·코드값 채번·의미·FK 위상 적재순서·webadmin 적재경로·권위 근거·영향분석).
  search-before-mint 사다리·코드 식별 전략·돈 크리티컬 가격사슬 영향 명시. 분석·명세 전용(실 COMMIT/DDL은 dbmap 위임).
  트리거: 등록 명세 설계, 기초코드 등록명세, 신규 코드 등록, 교정 명세, 축이동 설계, webadmin 적재경로, search-before-mint,
  FK 위상 등록순서. 진단은 hbg-basecode-diagnosis, 검증은 hbg-governance-evaluation이 담당.
---

# 등록 명세 설계 방법론

## 핵심 — 등록 의사결정의 실행 명세

진단이 "무엇이 틀렸고 어디로 라우팅"을 냈다면, 본 단계는 "**기초코드 마스터에 정확히 무엇을 어떻게 등록/교정**"을
실행 가능한 명세로 만든다. 이것이 하네스 최종 산출 = **등록 명세 마스터**.

**분석·명세 전용.** 실 COMMIT은 인간 승인 후 dbmap 적재 트랙(`dbm-load-execution`·`dbm-axis-staged-load`) 위임.

## search-before-mint 사다리 [HARD]

신규 등록 제안 전 반드시:
1. `t_cod_base_codes` **코드행 추가**로 표현 가능한가? (후니 표현력 확장 90%가 여기서 도달)
2. 기존 **컬럼/JSONB**(`tags`·`ref_param_json`·`logic`) 슬롯으로?
3. 기존 **junction 재사용**으로 1:多 표현? (V-12 형상축 교훈: 1:多여도 junction 선재면 컬럼에서 멈춤)
4. 위 모두 불가 입증 후에만 **신규 컬럼/테이블**. rpmeta vessel-gap 3건(V-10/11/12)만 신규 그릇 정당.

## 등록 명세 단위 [HARD]

| 필드 | 내용 |
|---|---|
| 대상 t_* + 코드값 | 채번 규칙(MAX+1·`_`·이름 기반 멱등·신규 DDL 0 지향) |
| 올바른 의미 + 권위 근거 | 정답 사전 인용(파일:셀) |
| FK 위상 적재순서 | 목적지 그릇 선행 → 참조 후행. vessel 선행→data 이동(자재행 use_yn='N'은 마지막) |
| webadmin 적재경로 | catalog Django change form 모델 / product-viewer pvEdit 섹션 (huni-admin-manual 13_admin-ui-spec) |
| 영향분석 | 기존 행·FK·가격사슬(component_prices 참조)·백필·롤백 |

## 코드 식별 전략 [HARD]

dbmap `00_schema/code-identifier-strategy.md` 준수: 순차 surrogate PK 유지 + 이름 기반 멱등(신규 DDL 0) +
separator `_` 통일(CPQ 하이픈 폐기) + 채번 MAX+1.

## vessel/DDL 재사용

rpmeta `04_vessel/vessel-*.md`(V-1~V-12 처방)·dbmap `11_ddl_proposals/*.sql`에 이미 처방/DDL이 있으면 인용·
재사용(재발명 금지). 정밀 DDL 필요 시 `dbm-ddl-proposer` 위임 명시.

## 1순위 설계 (자재·카테고리)

- **자재** — 오염 .08/.09/.10 목적축 등록 명세: 색→본체색(2~3종 자재유지)/CPQ option(4종+)·형상→siz·구수→bundle·인쇄면→print_side. MAT_FACET 코드행(V-3). **★FK load-bearing 주의**(80/82 상품 BOM이 .08/.09/.10 의존 → 축이동 후 use_yn='N' 마지막).
- **카테고리** — 고아 정리 명세(use_yn=N·재연결)·정상 잎노드 보존. round-22 ⑥ COMMIT분 정합(재제안 금지).
- 나머지 4축 명세 스캐폴드(틀).

## 돈 크리티컬 [HARD]

가격사슬(component_prices) 참조 자재행 축이동 시 가격 영향 명시·단가행 보존 원칙. 명세 ≠ 적용(CREATE/ALTER/COMMIT 0).

## 산출

`_workspace/huni-basecode/03_registration/`: `regspec-material.md`·`regspec-category.md`·`regspec-scaffold.md`·`_registration-master.md`(전 축 통합 = 최종 산출).

## 금지

- search-before-mint 생략한 신규 그릇 제안.
- 이미 적재·승인된 항목 재제안.
- DB 쓰기·적재경로 날조("미상"은 정직 표기).
