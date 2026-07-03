# Excel-to-DB 하네스 CHANGELOG (최신이 위)

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-07-02 | 하네스 초기 구성 — ① 구축 전 리서치 3건(학술 표 이해·프로파일링 23출처 / 산업 ELT·검증·멱등·MDM 20+출처 / 스키마 설계·LLM 에이전트 29출처) ② 플레이북 정본(`_meta/best-practices-playbook.md`) ③ 에이전트 6(x2d-methodology-researcher·profiler·semantic-analyst·schema-designer·load-engineer·gate-validator) ④ 스킬 6(orchestrator + x2d-excel-profiling·semantic-dictionary·schema-design·load-engineering·gate-validation) ⑤ 번들 스크립트 2(profile_workbook.py·workbook_diff.py) ⑥ 스모크: 상품마스터 260702 → 13시트 추출·헤더 정탐지 PASS | 전체 | 사용자 요청 — "이런 엑셀을 받았을 때 접근하는 베스트프랙티스를 리서치 기반 하네스로". 결정: 범용 방법론+후니 사례 내장 / 개발 범위=DB설계+적재 코드까지 / 구축 전 리서치+리서처 내장 / 기존 dbm-* 자산은 참조만(독립 신규) |
