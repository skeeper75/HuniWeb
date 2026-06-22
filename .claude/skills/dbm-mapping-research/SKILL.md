---
name: dbm-mapping-research
description: >
  후니프린팅 상품마스터 11시트 각 컬럼이 라이브 t_* 기초데이터에 어디로·어떻게 매핑되는지 확정하는 리서치 방법론
  (round-12). 4개 내부 권위(round-11 산출·실무진 Q1~Q15·schema-design-intent-map·webadmin 적재명세) 결합 +
  경쟁사·CIP4/ISO 인쇄표준 갭헌팅 + 라이브 실측 대조로 시트별 mapping-final 산출. DB 미적재.
  트리거: 매핑 확정, 매핑 확정 리서치, 컬럼 기초데이터 매핑, 11시트 매핑 확정, CIP4, 인쇄표준 리서치, 갭헌팅, round-12, 매핑 리서치 다시.
  컬럼 의미(round-11)는 dbm-column-domain, 적재 조립/실행은 dbm-load-readiness/dbm-load-execution, CPQ 옵션은 dbm-cpq-option-mapping.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebSearch, WebFetch, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-10"
---

# dbm-mapping-research — round-12 매핑 확정 리서치

## 목적과 프레임

round-11은 "각 컬럼이 무엇을 의미하는가"(엑셀 측)를, schema-design-intent-map은 "각 t_*가 왜 그렇게
설계됐는가"(DB 측)를 확정했다. round-12는 그 둘을 **결합해 매핑을 도출로 확정**하고, 확정 전에 외부 리서치로
**놓친 정보가 없는지 갭헌팅**한다. 산출물 = 시트별 `mapping-final`(적재 가능한 수준의 컬럼→기초데이터 확정
매핑) — round-4/5 적재본 조립의 직접 입력이 된다.

매핑은 추측이 아니라 도출이다(round-9 HARD directive). 내부 권위 4소스가 일치하면 확정, 불일치하면 충돌을
명시하고 라이브 실측/사용자 컨펌으로 닫는다. 외부 리서치는 **검증·갭 발견용 보조**다 — 경쟁사 답습 금지,
후니 스키마는 이미 경쟁사 표현력을 흡수/능가한다(메모리 `dbmap-domain-knowledge-before-asking`).

## 권위 순서 [HARD]

1. **실무진 확정** — `15_domain-spec/_review/실무진-검토질문.md` ✅확정 섹션(Q1~Q15, ★5건 포함). 회신은 권장안을 이긴다.
2. **후니 공식 문서** — 공정관리/주문프로세스 PDF, `docs/huni/2026-06-05-product-configurator-design.md`(CPQ 설계 의도), `docs/huni/table-spec_260608.html`(34테이블 332컬럼 명세).
3. **라이브 DB 실측** — 등록/NULL/존재/행수 판정은 항상 라이브가 권위(읽기전용 SELECT, `dbm-schema-extract` 툴킷). 추출본은 stale 가능.
4. **webadmin 소스** — `raw/webadmin`의 적재 로직(`_loadspec/loadspec.md` 우선 인용, 부족분만 소스 재추출).
5. **내부 KB** — round-11 `15_domain-spec/<family>/` 4산출, `00_schema/schema-design-intent-map.md`(OM-1~7 오모델·삼중바인딩), 07_domain 의미축(재유도 금지·인용만).
6. **외부 리서치(보조)** — 경쟁사·CIP4·표준·용어. 후니 운영 사실과 충돌 시 후니가 이기고 충돌만 기록.

## 입력 4소스 (시트 착수 전 반드시 로드)

| 소스 | 경로 | 역할 |
|------|------|------|
| round-11 시트 산출 | `15_domain-spec/<family>/`(column-dictionary·product-bom·mapping-info·domain-research-notes) | 컬럼 의미·BOM·매핑 초안 |
| 실무진 확정 | `15_domain-spec/_review/실무진-검토질문.md` | 컨펌 해소·★5건 매핑 수정 지시 |
| 스키마 설계의도 | `00_schema/schema-design-intent-map.md` + table-spec html + configurator-design md | t_* WHY·삼중바인딩·오모델 경고 |
| 적재명세 | `15_domain-spec/_loadspec/loadspec.md`(+webadmin 소스) | 적재 surface·코드값 그룹·FK 순서 |

## 절차 (시트 = 작업 단위, 파일럿 → 확대)

**P0 컨텍스트 확인** — `16_mapping-research/<family>/` 존재 여부로 초기/부분 재실행 판별. 부분 요청이면 해당
시트/컬럼만. 라이브 DB 접속은 `.env.local` `RAILWAY_DB_*`(비밀값 비노출).

**P1 내부 결합(매핑 후보 도출)** — 시트의 각 컬럼에 대해 4소스를 교차해 `컬럼 → 목표 t_*.컬럼 + 변환 규칙 +
코드값 해석 + FK 의존`을 도출. 실무진 ★5건(Q3 반제품 전체관점·Q5 시트별 컬럼옵션·Q7 도무송 형상=size 칼틀
1:1·Q9 코팅=공정·Q13 우드거치대=자재)이 걸린 컬럼은 round-11 매핑 초안을 수정해 반영. OM-1~7 오모델과 같은
패턴(색=siz, size→option 등) 재발 여부를 컬럼마다 점검. 4소스 불일치 = CONFLICT 행으로 명시(침묵 선택 금지).

**P2 외부 갭헌팅 리서치(WebSearch/WebFetch)** — 목적은 "우리가 놓칠 우려가 있는 정보"의 적발이지 답습이 아니다.
시트 상품군에 적합한 대상을 선별:
- **국내 경쟁사 풀(10 내외)**: 레드프린팅(사용자 본인 설계·역공학 KB 보유), 성원애드피아, 와우프레스(326상품
  KB 보유 `docs/wowpress`), 애즈랜드, 프린트시티, 오프린트미, 비즈하우스, 스냅스, 퍼블로그, 포토몬 등.
- **해외 경쟁사 풀(10 내외)**: Vistaprint, MOO, Printful, Printify, Gelato, Mixam, Smartpress, UPrinting,
  GotPrint, Saxoprint 등.
- **공식/표준**: CIP4(JDF/XJDF 공정·자재·임포지션 모델), ISO 12647(인쇄 품질), 한국인쇄학회/대한인쇄협회 용어,
  용지 규격(국전/46전) 표준.
갭헌팅 질문 형식: "이 시트의 상품을 경쟁사/표준은 어떤 속성 축으로 파는가/정의하는가 — 후니 시트·스키마에
없는 축이 있는가?" 발견 갭은 `research-gap-board.md`에 {갭·출처·후니 영향(매핑 수정/DDL 제안/무시)·근거}로
분류. 기존 KB(`07_domain/benchmark-competitors.md`·wowpress·RedPrinting 역공학) 재사용, 중복 크롤 금지.
**모든 외부 인용에 Sources 명기, WebFetch로 URL 검증.**

**P3 라이브 실측 대조** — P1 매핑 후보의 우변(t_* 행)을 라이브에서 실측: 코드값 존재(`t_cod_base_codes`),
대상 행 존재/부재(미적재 = 적재 대상으로 분류), FK 충족, 이미 적재된 행과의 정합(round-7 매트릭스·D-1
"LOADED=행존재만" 교훈 — 행수만이 아니라 변형 커버리지까지). search-before-mint: 신규 코드 제안 전 기존
행/판형/코드 재사용 가능성 먼저 입증.

**P4 산출 + 게이트** — 아래 산출 포맷으로 쓰고 M1~M6 게이트(생성자≠검증자, `dbm-validator` 독립).

## 산출 (write to `_workspace/huni-dbmap/16_mapping-research/<family>/`)

- `mapping-final.md` — 컬럼별 확정 매핑 테이블: `컬럼 · 의미축(round-11 인용) · 목표 t_*.컬럼 · 변환 규칙 ·
  코드값/FK · 라이브 실측 상태(존재/미적재/충돌) · 권위(어느 소스가 확정했나) · 확정도(✅/🟡/🔴) · 비고`.
  빈칸 0 — 🔴는 컨펌 질문과 함께만 허용, 침묵 공란 금지.
- `research-gap-board.md` — 외부 갭헌팅 결과(갭 0건이어도 "조사했고 갭 없음"을 대상·Sources와 함께 기록).
- `live-crosscheck.md` — 라이브 실측 쿼리·결과 요약(재현 가능하게, 비밀값 없이).
- 공유: `16_mapping-research/_gate/<family>-gate.md` — validator 게이트 결과.

## 게이트 M1~M6 (dbm-validator 독립 수행)

| # | 게이트 | 기준 |
|---|--------|------|
| M1 | 커버리지 | 시트 전 컬럼이 mapping-final에 존재(제외는 사유 명기) |
| M2 | 권위 추적 | 각 행에 권위 소스 인용 실재(인용 라인/문서 실존 — round-11 G-1 날조 교훈) |
| M3 | 실무진 정합 | Q1~Q15 확정(특히 ★5건)이 해당 컬럼에 반영됨 |
| M4 | 오모델 부재 | OM-1~7 패턴(색=siz·size↔option 혼동·이중의미 평면화 등) 재발 0 |
| M5 | 라이브 실측 | 매핑 우변 코드값/FK가 라이브에서 검증됨(독립 재실측 표본) |
| M6 | 외부 갭 처분 | research-gap-board의 모든 갭에 처분(매핑 수정/DDL 제안 라우팅/무시+사유) 존재 |

## 에러 핸들링·원칙

- **DB 미적재 [HARD]** — 본 라운드는 매핑 확정까지. 적재본/COMMIT은 round-4/5 트랙 + 인간 승인.
- 라이브 접속 실패: 1회 재시도 후 해당 컬럼을 "실측 보류"로 표기하고 진행(침묵 추정 금지). 비밀번호 비출력.
- WebSearch 무결과/충돌: 출처 병기 후 후니 권위로 닫고 충돌 기록. 3회 실패한 리서치 질문은 🔴 컨펌으로 전환.
- 시트별 주의(메모리 권위): 실사 가격=포스터사인 면적매트릭스(자체 inline 금지) · 굿즈파우치 size→option
  재분류(round-10) · 도무송 형상=size 칼틀 1:1(Q7) · 옵션=자재+공정 BUNDLE · 판형=출력용지규격.
- 위임 시 인라인 한국어 선호(round-10 교훈: "완료"만 반환하는 실패모드 — 산출 파일을 직접 읽어 회수).
