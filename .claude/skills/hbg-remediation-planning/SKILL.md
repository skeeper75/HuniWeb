---
name: hbg-remediation-planning
description: >
  후니프린팅 기초코드 거버넌스 하네스의 교정 실행 우선순위 방법론 스킬. 검증 GO된 등록 명세 마스터의 전 교정
  항목(축이동·BOM link 제거·소프트삭제·재연결·.10→.07·색오염)을 라이브 실제 적재 내용·구조 재분석으로 "어떤
  순서로 라이브에서 실제 교정할지" 로드맵화하는 절차를 제공한다. 5축 스코어링(가역성·위험·효과·FK 의존·돈
  크리티컬), 안전·가역성 우선 정렬, ★가격사슬 영향 분석(t_prc_price_formulas·formula_components·component_prices
  교정 영향·dbm-price-arbiter 협업), 교정 경로 혼합(가역=라이브 직접 / 근본=경로 Y v03 재적재 병기·TRUNCATE 휘발
  경고), wave 배치 그룹핑, 단계별 인간 승인 큐, dbmap 적재 트랙 위임 인터페이스를 정의한다. '교정 우선순위',
  '교정 로드맵', '라이브 교정 순서', '교정 실행 계획', '안전 가역성 우선', '가격사슬 영향', '교정 경로 혼합',
  '단계별 승인 큐', 'wave 그룹핑', '교정 로드맵 다시' 작업 시 반드시 이 스킬을 사용. 등록 명세 자체 설계는
  hbg-registration-spec, 진단은 hbg-basecode-diagnosis, 실 적재 실행은 dbmap dbm-axis-staged-load/
  dbm-load-execution이 담당하므로 그 작업에는 트리거하지 않는다.
---

# 교정 실행 우선순위 방법론

## 핵심 — 명세에서 실 적재 사이의 다리

등록 명세가 "무엇을 교정할지"를 GO시켰다면, 본 단계는 **"라이브에서 어떤 순서로·어떤 경로로·어떤 위험 통제
하에 실제 교정할지"**를 로드맵화한다. 실 COMMIT은 dbmap 트랙 위임(인간 승인)이고, 본 스킬은 그 앞단의 의사결정.

## 5축 스코어링

각 교정 항목에 점수(높음/중간/낮음):

| 축 | 평가 | 우선 방향 |
|----|------|----------|
| **가역성** | undo·멱등·백업 가능성 | 높음 = 우선 |
| **위험** | 본체 BOM 파손·FK 전손·가격 파손 | 낮음 = 우선 |
| **효과** | 결함 해소 폭 | (안전 동률 시) 큼 = 우선 |
| **FK 의존** | 선행 조건 수 | 적음 = 우선 |
| **돈 크리티컬** | 가격사슬 영향 | 0 = 우선 |

[HARD] **안전(가역+저위험)이 절대 1순위.** 효과·돈크리티컬이 커도 위험 높으면 후순위 wave로.

## ★가격사슬 영향 분석 [HARD]

6축 기초코드 교정이 가격공식/가격구성요소에 반영될 수 있다. 각 교정에 대해 라이브 읽기전용 SELECT:
```bash
# 교정 대상 코드가 단가행에 박혀 있는가 (축이동/삭제 시 가격 파손)
psql "$RAILWAY_DB_URL" -c "SELECT count(*) FROM t_prc_component_prices WHERE mat_cd = '<대상>';"
# 가격공식 구성요소 배선 여부
psql "$RAILWAY_DB_URL" -c "SELECT * FROM t_prc_formula_components WHERE ... ;"
```
- component_prices에 prd_cd 부재 시 formula(PRF_*) 경유 **간접 영향** 규명(아크릴 PRF_CLR_ACRYL 등).
- "가격사슬 안전" 단정은 라이브 실측 근거 필수. 깊은 정합·정립은 **dbm-price-arbiter** 협업(가격 트랙 권위).
[HARD] SELECT만. 쓰기 절대 금지.

## 교정 경로 혼합 [HARD]

각 항목에 두 경로 병기(침묵 선택 금지):
- **라이브 직접** — 즉효·가역. 단 webadmin TRUNCATE 재적재 시 휘발(del_yn='Y' 등·[[dbmap-del-yn-soft-delete-authority]]) → "임시책" 명시.
- **경로 Y** — v03 입력엑셀 교정 + 개발자 재적재. 영구·휘발 없음. 단 개발자 협업 필요.
판정: 가역·즉효 = 라이브 직접 / TRUNCATE 휘발성·근본 = 경로 Y 백로그. 두 경로 장단 항목별 명시.

## wave 배치 그룹핑

동형 클래스·FK 위상으로 묶음:
- **Wave 1** — 즉시 무위험 가역(색오염 cp 0참조·소프트삭제 연결0 등). dry-run 후 즉시 승인 가능.
- **Wave 2** — 목적지 그릇 선행 후 가능(축이동·dtl_opt 채움).
- **Wave N** — 고위험 의존분(BOM link 제거 → 본체 선적재 → 오염행 삭제·아크릴 가격사슬 연결 UV).
[HARD] FK 위상 위반 금지(목적지 선행·BOM link 제거가 소프트삭제 선행).

## 단계별 인간 승인 큐

각 wave에 승인 카드: {대상·행수·예상 영향·가격사슬 영향·dry-run 결과·롤백 방법·평이한 승인 질문}. 사용자가 wave
단위로 GO/STOP. GO분만 dbmap 위임.

## dbmap 적재 트랙 위임 인터페이스

GO 승인 wave를:
- **경로 Y(6축 교정엑셀 재적재)** → `dbm-axis-staged-load`(P-TRUNCATE 가드·교정 v03)
- **라이브 직접 멱등 UPSERT** → `dbm-load-execution`(WHERE del_yn='N' 가드·백업·롤백전용 DRY-RUN)
- **검증** → `dbm-validator`(R1~R6) + `hbg-validator`(거버넌스 정합)
- **신규 그릇 DDL** → `dbm-ddl-proposer`
재발명 금지. 본 스킬은 *어느 wave·어떤 경로·무슨 순서·무슨 위험 통제*까지.

## 산출

`_workspace/huni-basecode/05_remediation/`: `remediation-roadmap.md`(5축 스코어링·wave·경로·정렬)·`price-chain-impact.md`(가격사슬 영향 보드)·`_approval-queue.md`(wave 단계별 승인 큐).

## 금지

- 직접 COMMIT/DDL(실 적재는 dbmap 위임·인간 승인).
- "가격사슬 안전" 무근거 단정(라이브 실측 필수).
- 경로 침묵 선택(라이브직접/경로Y 장단 병기).
- FK 위상 위반(목적지 선행).
