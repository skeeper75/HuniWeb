---
name: hcc-authority-curation
description: >-
  후니프린팅 카탈로그 종단 정합 하네스의 권위 기준점·커버리지 큐레이션 방법론. 두 권위 엑셀(상품마스터
  260610·인쇄상품 가격표 260527)과 기존 가격엔진/매핑 하네스 산출물·추출 CSV 캐시를 재사용해(★새 조사 금지),
  인쇄 도메인 의미를 먼저 정립한 12축+가격엔진 정답 기준(authority-spec)과 (상품×축) 전수 커버리지
  체크리스트(누락 0의 자)를 조립한다. 트리거: 권위 기준 큐레이션, 축별 정답 기준, 커버리지 체크리스트,
  도메인 렌즈 정립, 정합 기준점, 재사용 맵, 큐레이션 다시. 결함 판정은 인스펙터, 게이트는 hcc-conformance-gate.
---

# hcc-authority-curation — 권위 기준점·커버리지 큐레이션 방법론

## 목적

검사·게이트가 "무엇을 무엇과 대조할지"의 **자(尺)**를 만든다. 정답 기준(권위) + 전수 체크리스트(누락
0). 결함 판정은 하지 않는다.

## 원칙 [HARD]

1. **인쇄 도메인 먼저.** 코드 표면 대조 전에 각 축의 인쇄 의미를 정립(상품=출력소재+색+부속물+가공
   레시피). 의미 없는 값 대조는 false-positive를 낳는다.
2. **조사 반복 금지(사용자 directive).** 기존 산출물을 재사용해 기준만 조립. 같은 엑셀 재파싱 금지 —
   `24_master-extract-260610/*.csv`·`00_schema/ref-*.csv` 캐시 우선. 재사용한 출처를 `reuse-map.md`에 기록.
3. **권위 = 두 엑셀.** 상품마스터+가격표만 정답. 라이브·기존 산출물은 입력·렌즈. v03/STALE 인용 금지.
4. **전수 열거가 책임.** 빠뜨린 (상품×축) 셀은 영원히 검사 안 됨 → 누락 은폐. 모집단을 라이브
   `t_prd_products`로 확정하고 전 상품 × 12축을 빠짐없이 행으로.

## 12 축 + 가격엔진 (사용자 정의)

사이즈코드 · 도수 · 인쇄옵션 · 판형 · 자재 · 공정 · 묶음수 · 추가상품 · 페이지룰 · 옵션그룹 ·
제약규칙 · 추가상품 템플릿. + **가격엔진**(가격 산출에 필요한 항목 처리)을 횡단 축으로.

각 축에 대해 authority-spec에 기록할 것:
- **권위 컬럼**: 두 엑셀 어느 시트/컬럼이 이 축의 정답인가.
- **대상 t_***: 라이브 어느 테이블/컬럼에 적재되는가(`00_schema/` 인용).
- **도메인 의미**: 인쇄에서 무엇을 뜻하는가(domain-lens).
- **정합 규칙**: 무엇이 MATCH/MISSING/EXTRA/MISMATCH/CONFIRM인가.
- **owner_inspector**: basedata(8축) / cpq-link(4축+2연결) / price-engine(가격 횡단).

## 축↔인스펙터 배정

| owner | 축 |
|-------|----|
| basedata | 사이즈코드·도수·인쇄옵션·판형·자재·공정·묶음수·페이지룰 |
| cpq-link | 옵션그룹·제약규칙·추가상품·추가상품 템플릿 + 옵션→차원 연결·템플릿→추가상품 연결 |
| price-engine | 가격엔진 횡단(공식·구성요소·단가행·use_dims·할인) + 종단 연결 |

## 워크플로

1. **모집단 확정** — 라이브 `t_prd_products` 전 상품(읽기전용) × 상품마스터 11시트 prd_cd 대응.
   기존 `06_extract/`·`09_load/` prd_cd↔상품군 대응 재활용.
2. **도메인 렌즈** — 12축 인쇄 의미를 `domain-lens.md`에 정립(기존 round-11 BOM·print-kb 위키·dbm domain 산출 재사용).
3. **정답 기준** — 축별 권위 컬럼·대상 t_*·정합 규칙을 `authority-spec.md`에.
4. **체크리스트** — (prd_cd × 12축) 전수 행을 `conformance-checklist.csv`에. needed 판정은 엑셀 권위(해당 없으면 needed=N).
5. **재사용 맵** — 어느 기존 산출물을 어디 썼는지 `reuse-map.md`(중복 조사 회피 증거).

## 산출 (`_workspace/huni-catalog-conformance/01_authority/`)

`authority-spec.md` · `conformance-checklist.csv` · `domain-lens.md` · `reuse-map.md`.

## 체크리스트 CSV 포맷

```
prd_cd,product_group,axis,authority_source,target_table,needed,owner_inspector,note
```
needed ∈ {Y,N}. 한 상품이 어떤 축을 안 쓰면 needed=N(그 셀은 인스펙터가 N/A로 빠르게 닫음). 공백 금지.

## CONFIRM 큐

권위 엑셀끼리 충돌(상품마스터↔가격표 불일치)은 결함이 아니라 `CONFIRM` — 어느 쪽이 옳은지 인간 확인
큐로 분리(authority-spec에 표기). 임의 선택 금지.
