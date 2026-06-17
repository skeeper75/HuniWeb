---
name: hbg-authority-curation
description: >
  후니프린팅 기초코드 거버넌스 하네스의 권위 큐레이션 방법론 스킬. 6축(자재/사이즈/도수/인쇄옵션/공정/기초코드)의
  "후니 정답 기준"을 권위 원천에서 추출해 축별 정답 사전(authority dictionary)을 만드는 절차를 제공한다. 권위
  순서[HARD] ① 상품마스터(260610)+가격표(260527) ② 라이브 t_* 설계의도 ③ 인쇄 도메인+rpmeta 역공학 ④ 경쟁사
  (갭헌팅). 정답 사전 포맷(코드값·의미·소속 t_*·코드 도메인·출처·확정도), 삼중 바인딩 인용 규칙, 추정 0(가설+출처+
  컨펌ID), 경쟁사 갭헌팅 vs 권위 덮어쓰기 금지 경계를 정의한다. '권위 정답 사전', '축별 정답 기준', '권위 큐레이션',
  '상품마스터 권위 추출', '갭헌팅 보강', '권위 충돌 정리' 작업 시 반드시 이 스킬을 사용. 라이브 진단(어긋남 판정)은
  hbg-basecode-diagnosis, 등록 명세는 hbg-registration-spec이 담당하므로 그 작업에는 트리거하지 않는다.
---

# 권위 큐레이션 방법론

## 왜 이 단계인가

진단가가 "라이브가 정답과 어긋났다"를 판정하려면 **무엇이 정답인지**가 먼저 축별로 못박혀야 한다. 정답 없는 진단은
추측이다. 본 단계는 권위에서 정답을 추출해 진단의 기준선을 만든다.

## 권위 순서 [HARD]

1. **상품마스터 + 인쇄상품 가격표** — `docs/huni/후니프린팅_상품마스터_260610.xlsx`·`후니프린팅_인쇄상품_가격표_260527.xlsx`. 명시값 = 정답.
2. **라이브 t_* 설계의도** — `_workspace/huni-dbmap/00_schema/schema-design-intent-map.md`(t_* 왜 그렇게 설계됐나·삼중 바인딩)·`ref-*.csv`·`schema-relationship-analysis.md`(행수 권위 §0).
3. **인쇄 도메인 + rpmeta 역공학** — `_workspace/huni-rpmeta/04_vessel/*`·`categories/*`·`_index.md`. 17축·그릇 처방.
4. **경쟁사** — WowPress(공개 API)·RedPrinting(rpmeta)·CIP4·ISO. **갭헌팅 전용**.

[HARD] ③④는 권위를 덮어쓰지 못한다. 권위에 명시값이 있으면 그것이 정답. 역공학/경쟁사는 권위가 **침묵하거나
모호한 빈칸**에만 개입한다.

## 정답 사전 포맷

축별로 다음 표를 만든다:

| 코드값/분류 | 올바른 의미 | 소속 t_* | 코드 도메인(상위그룹) | 권위 출처(파일:시트:셀) | 확정도 |
|---|---|---|---|---|---|
| MAT_TYPE.05 | 종이 본체 자재 | t_mat_materials | MAT_TYPE | 상품마스터 자재시트 C? | 확정 |
| (색 본체) | 본체색은 2~3종 자재유지/4종+ CPQ | t_mat_materials or option | — | round-22 §01 경계규칙 | 가설+컨펌Q |

- **확정도** = 확정(권위 명시) / 가설(권위 침묵·도메인 유추) / 컨펌(사용자 결정 필요).
- 가설은 반드시 `출처 + 컨펌ID`를 단다.

## 삼중 바인딩 인용 [HARD]

각 구성요소가 ① UI componentType ② 생산 BOM/MES ③ 가격엔진에 어떻게 귀속되는지를 `schema-design-intent-map`에서
인용한다(재유도 금지). 같은 값을 잘못된 t_*에 두는 위험(카드봉투 색=`t_siz_sizes` 사례)을 정답 사전이 사전 차단한다.

## 경쟁사 갭헌팅 경계 [HARD]

- 경쟁사가 가진 정답 분류축이 후니 권위에 **없으면** → "후니 빈칸 후보"로 `_authority-conflict-board.md`에 올린다.
- 후니에 도입할지는 **판정만**(강제 아님). 등록명세 설계가/사용자가 결정.
- 경쟁사 naming/codes를 후니로 유입 금지(rpmeta 원칙). 표현력만 흡수.

## 1순위 축 (자재·카테고리)

- **자재** — MAT_TYPE 11종의 올바른 의미·.08/.09/.10 오염 경계(색/형상/사이즈/구수가 자재가 아님)·본체색 합성 정당분 기준. round-22 §01 정답 규칙 인용.
- **카테고리** — `t_cat_categories` 트리 정답(잎노드=상품 분류·고아=부카테고리 중복). round-22 ⑥ 인용.
- 나머지 4축은 스캐폴드 표(헤더만)로 후속 확장 대비.

## 산출

`_workspace/huni-basecode/01_authority/`: `axis-authority-material.md`·`axis-authority-category.md`·`axis-authority-scaffold.md`·`_authority-conflict-board.md`.

## 금지

- 추정 단정(가설은 반드시 분리).
- 권위 엑셀 명시값을 역공학/경쟁사로 덮어쓰기.
- DB 쓰기. 라이브 행수는 schema-design-intent-map §0 권위 주석 사용(추가 접속 불요).
