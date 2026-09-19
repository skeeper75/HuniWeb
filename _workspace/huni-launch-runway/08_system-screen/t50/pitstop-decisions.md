# PitStop — 이 원장(screens.csv)에 넣지 않은 결정·관리 안건

계약 「보충 4」(260919 · 리드 lane-1 · t50 제기): `screens.csv` 는 「시스템×역할×화면×기능」 원장이다. 아래 7건은 화면도 기능도 없는
**결정/관리 안건**이라 원래 `parts/pitstop.csv` 의 `manual` 행(PS-02·03·04·05·06·26·28)으로 실렸던 것을 여기로 옮긴다.
전부 9/17 원장(`plan-rows.csv` 735행)에 이미 있는 항목이라, `screens.csv` 에 두면 원장 중복이 된다.

| plan_row_id | 안건 | 미결 내용 | 근거 (path:line) | 결정 주체 |
|---|---|---|---|---|
| STD-ART-034 | PitStop 연동방식 결정(핫폴더 vs CLI) | 핫폴더/CLI 중 하나가 선택되어 설계 문서에 기록되면 완료 — 아직 미확정 | `docs/huni/후니정기미팅 정리260915.html` §PDF 프리플라이트 미결3 · `planrows-pitstop.csv` STD-ART-034 | 미정 |
| STD-ART-033 | PitStop 연동 소요시간 다음 미팅 상정·일정 반영 | 다음 정기미팅 안건에 PitStop 연동 일정이 오르고 회의록에 반영 결과가 남으면 완료 — 아직 안건 상정 안 됨 | `docs/huni/후니정기미팅 정리260915.html` §PDF 프리플라이트 미결1 · `planrows-pitstop.csv` STD-ART-033 | 미정 |
| STD-ART-035 | PitStop 작업범위 산정(상품별 프로파일·S3↔서버 파일이동·결과표시·대용량테스트) | 네 갈래 각각의 작업 분량 추정치가 문서 한 장으로 나오면 완료 — 아직 산정 안 됨(선행: STD-ART-034) | `docs/huni/후니정기미팅 정리260915.html` §PDF 프리플라이트 미결4 · `planrows-pitstop.csv` STD-ART-035 | 미정 |
| STD-MYP-024 | PitStop Server 연동 담당 확정 | 담당자가 역할분담표에 기재되면 완료 — 아직 미기재(선행: STD-ART-016) | `docs/huni/후니정기미팅 정리260915.html` §개발 역할분담 미결4 · `planrows-pitstop.csv` STD-MYP-024 | 미정 |
| BLK-S2-4 | PitStop 구매 진행상태(견적·라이선스·인스턴스 계획) 확인 | 결정·확인 기록 화면에 진행상태가 적혀 있는지 조회해야 함 — 원장에 소유 행 없이 새로 추가된 선행 입력(C4 임계경로 산정용) | `.moai/specs/SPEC-LAUNCHPLAN-001/research.md:317` | 대표(채훈희) |
| T4-3 | 파일 검수 경로 결정·구축 — PitStop 조달 또는 사람 검수(D-P1·D-P2) | webadmin 관리자 메뉴에서 검수 대기 목록 화면이 조회되는지 확인해야 함 — 현재 status="없음" | `_workspace/huni-launch-runway/07_rebaseline/S/S2-pipeline/pipeline-status.csv:17` · `planrows-pitstop.csv` T4-3 | 대표(채훈희) |
| STD-ADO-010 | 검수 게이트 관리(G1 파일·G3 가공·G4 출고)를 현행 MES 상태값으로 대신할지 결정 | 결정 문장 1줄과 결정일이 `R/R3/decisions-for-pm.md` §A-4(Plan B 확정) STD-ADO-010 줄에 기재되어야 완료 — 아직 미기재 | `print-kb/wiki/policy/order-mgmt.md#OMG-05` · `planrows-pitstop.csv` STD-ADO-010 | 미정(실무 담당=최숙진 실장으로 추정되나 결정권자 미확인) |

이 표는 `verdict.md` 에서 "이 원장에 넣지 않은 결정 안건"으로 인용된다. 각 행의 원본 원장 좌표는 `plan_row_id` 로 9/17
원장(`plan-rows.csv` 735행)에서 그대로 추적 가능하다 — 정보 손실 없음.
