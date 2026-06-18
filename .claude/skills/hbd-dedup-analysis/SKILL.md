---
name: hbd-dedup-analysis
description: >
  후니프린팅 기초데이터 표시중복 정리 하네스의 4축 검수·정리 매핑 설계 방법론. 축별 인덱스 캐시를
  입력으로, 사용자 표시값과 내부 실제값을 함께 보고 4축(① 권위추출+표시↔실제 정합 ② 표시 중복 ③ 내부값
  중복 ④ 의미구분 보존)으로 검수해 진짜 중복·오적재만 적발하고 정당한 의미 구분(작업/재단/판형/단위/
  상품전용)은 보존하는 절차를 제공한다. canonical(의미축+정규치수+단위) 도출→라이브 환원→충돌·불일치
  검출, 가격종속 BLOCKED 분류, 무손실 정리(정본+논리삭제+재배선), search-before-mint, 통과(NO-OP)
  인정을 다룬다. '표시중복 판정', '4축 검수', '중복 정리 매핑', 'canonical', '오적재 적발', '정리 매핑 다시'
  작업 시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-19"
  tags: "dedup, canonical, mismatch, mapping, basedata"
---

# hbd-dedup-analysis — 4축 검수·정리 매핑 방법론

## 핵심 통찰

키(코드)는 고유하므로 DB 무결성상 중복은 없다. 문제는 **사용자 화면에 같은 게 두 번 보이거나(표시 중복), 라벨과 내부값이 어긋난(오적재)** 것이다. 그런데 "60×60"이 둘 보여도 하나는 작업사이즈, 하나는 재단사이즈면 **정당한 구분**이다. 그래서 권위에서 의미를 먼저 정확히 뽑아 canonical로 환원한 뒤에만 충돌을 판정한다.

## 판정 4축

| 축 | 검사 | 방법 |
|---|---|---|
| ① 권위추출 + 표시↔실제 정합 | 권위 엑셀 의미·치수·단위 정확 추출 + 표시명 ↔ 내부 실제값 일치 | canonical 대조 → 불일치=오적재 |
| ② 표시 중복 | 화면 라벨 동일·코드 다름 | 표시명 정규화 후 키 충돌 |
| ③ 내부값 중복 | 실제값 동일·코드 다름 | 내부값 canonical 충돌 |
| ④ 의미구분 보존(가드) | 작업/재단/판형/단위/상품전용은 중복 제외 | canonical에 semantic_axis 포함 |

## 절차

1. **canonical 키 정의**. 사이즈 예: `(semantic_axis, norm_w, norm_h, unit)`. 표시명 정규화 규칙(공백·단위·괄호 내부치수 추출)은 `_workspace/huni-dbmap/04_audit/size-parity.md` 재사용.
2. **권위→라이브 환원 대조**. canonical은 SOT 엑셀에서 도출. 라이브 각 행을 canonical로 환원해 (a) 권위와 일치하는가(① 정합) (b) 서로 충돌하는가(②③).
3. **충돌 후보 → false-positive 가드(④)**. 표시·내부값이 같아도 semantic_axis가 다르거나 상품바인딩이 배타면 중복 아님. 불확실하면 컨펌 큐.
4. **가격종속 분리**. `price_dependent=Y` 인 통합/정리 대상은 BLOCKED(component_prices CASCADE 위험)로 분류·escalate.
5. **무손실 정리 명세**. 통합=정본 1개 + 멤버 논리삭제(del_yn='Y') + 참조 재배선. 물리삭제 금지. 단가행·바인딩 보존(권위 del_yn: [[dbmap-del-yn-soft-delete-authority]]).
6. **신규 적재**. search-before-mint(기존 코드로 표현 불가 입증) 후에만. 채번 MAX+1·separator '_'.
7. **통과 인정**. 4축 결과 정리/적재 0건이면 "PASS(NO-OP)" 명시. 억지 변경 금지.

## 산출물

`_workspace/huni-basedata-dedup/<axis>/`:
- `mapping.csv` — `action(merge|normalize|new-load|fix-mismatch|keep), target_code, member_codes, canonical, reason, price_dependent, confidence, confirm_needed`
- `dedup-report.md` — 4축별 발견·canonical 정의·BLOCKED·통과 여부·컨펌 큐
- `apply-plan.md` — (적재 대상 있을 때만) executor 실행 안전분 명세

## 하지 말 것

- semantic_axis 확인 없이 표시·내부값 동일만으로 중복 단정(작업/재단 오판).
- 가격종속 코드를 적재 매핑에 포함.
- 통합을 물리 DELETE로 설계.
