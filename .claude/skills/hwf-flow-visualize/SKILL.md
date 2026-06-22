---
name: hwf-flow-visualize
description: 후니 위젯 구조·플로우 문서화 하네스(Huni-Widget-Flow)의 비전문가용 시각화 방법론(codex-imgage 중심). flow-curator 플로우 팩을 입력으로 mermaid가 아닌 "한눈에 파악되는 인포그래픽형 이미지"를 codex-imgage 스킬(최대 5장 병렬)로 생성한다 — 제품군 구성 분류·전체 고객 여정·파일 업로드 vs 에디쿠스 두 갈래 대비. 생성=codex/큐레이션·프롬프트·수집=Claude(codex 산출=가설)·사실 충실(없는 단계 금지)·비전문가 일상어 라벨. 트리거: codex 이미지 시각화, 비전문가 인포그래픽, 제품군 구성 시각화, 전체 플로우 그림, 병렬 이미지 생성, 시각화 다시. 개발자 mermaid는 hwf-mermaid-authoring, 검증은 hwf-flow-validation 담당.
---

# hwf-flow-visualize — 비전문가용 codex-image 시각화 방법론

## 목적
위젯 플로우를 **비전문가(기획·운영·고객)가 한눈에 이해하는 인포그래픽 이미지**로 만든다. 청중이 개발자용 mermaid와 정반대 — 직관·단순·시각적 은유가 핵심.

## 핵심 규칙[HARD]
1. **codex-imgage로 생성**: 이미지 본문은 `codex-imgage` 스킬을 Skill 도구로 호출해 만든다(직접 그리지 않음). 최대 5장 병렬 생성이 강점 → 장면을 배치로 묶어 병렬 호출.
2. **사실 충실(환각 경계)**: 프롬프트엔 flow-curator 팩 사실만. codex가 근거 없는 단계·수치·아이콘을 넣지 않도록 프롬프트로 통제하고, 생성 후 팩과 1차 대조. codex 산출=가설, 최종 정합 판정은 hwf-validator.
3. **비전문가 라벨**: 전문어(uploadType·presigned·Pinia) 금지 → 일상어("내 파일 직접 올리기" / "편집기로 디자인하기" / "가격 자동계산" / "주문하기"). 핵심 라벨만 짧게.

## 권장 장면(배치 병렬)
- **전체 여정 1장**: 상품 선택 → 옵션 → (업로드 / 편집기 분기) → 가격 확인 → 주문, 좌→우 흐름.
- **제품군 구성 분류 1장**: 26 상품군을 "편집기 전용 / 업로드+편집기 / 업로드 전용" 그룹으로 묶은 분류 인포그래픽.
- **경로 대비 1장**: 파일 업로드 여정 vs 에디쿠스 여정 단계 비교(나란히).
- **대표 상품군 여정**: 명함·책자·굿즈·아크릴·배너 등 대표 케이스.

## 프롬프트 작성 가이드
- 구도 지정: "infographic, left-to-right flow, numbered steps, two parallel lanes labeled 'Upload my file' and 'Design in editor'".
- 스타일: 깔끔한 플랫 일러스트, 큰 아이콘, 명확한 화살표, 절제된 색.
- **한글 텍스트 깨짐 주의**: 이미지 내 한글은 렌더가 불안정할 수 있음 → 텍스트 최소화, 핵심 라벨은 짧은 영어 또는 한/영 병기로 요청하고, 깨짐 위험은 manifest에 기록(validator가 F5에서 점검).

## codex-imgage 호출
`codex-imgage` 스킬을 호출하여 장면별 프롬프트로 병렬 생성. 생성 파일은 `_workspace/huni-widget-flow/03_visual/`에 저장.

## 폴백
codex-imgage 미가용/데드락 시 "이미지 생성 codex 의존 — 미생성" 명시 + 임시 mermaid 단순 도해 제공(비전문가 인포그래픽은 pending 아님, 명시적 미생성).

## 산출
`_workspace/huni-widget-flow/03_visual/`: 이미지 파일 + `visual-manifest.md`(의도·담은 사실·근거 참조·프롬프트·우려).
