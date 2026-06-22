---
name: hbg-basecode-diagnosis
description: >
  후니프린팅 기초코드 거버넌스 하네스의 4-way 진단 방법론 스킬. 권위 정답 사전을 기준으로 라이브 t_*(자재/사이즈/도수/인쇄옵션/
  공정/기초코드/카테고리)를 ①권위 ②라이브 ③역공학 ④경쟁사 4-way 대조해 오염/누락/오매칭/고아를 전수 진단. 결함 분류
  (현재값 vs 정답·원인유형·라우팅 신규/교정/축이동)·라이브 읽기전용 psql 실측·dbmap round-13/22 정합(중복 재진단 금지·stale 경계).
  트리거: 기초코드 진단, 4-way 대조, 자재 오염 진단, 카테고리 고아 진단, 오매핑 진단, 결함 보드, 라우팅 분류.
  정답 사전은 hbg-authority-curation, 등록 명세는 hbg-registration-spec이 담당.
---

# 4-way 진단 방법론

## 핵심 — 경계면 교차 비교

진단은 "존재 확인"이 아니라 **4-way 교차 대조**다. 한 항목에 대해 권위·라이브·역공학·경쟁사를 동시에 놓아야
"왜 틀렸고 어디로 라우팅할지"가 나온다.

## 4-way 원천

1. **권위** — `01_authority/axis-authority-*.md` 정답값.
2. **라이브** — `psql` 읽기전용 SELECT(`.env.local` `RAILWAY_DB_*`). 행수/코드값/소속 t_* 실측.
3. **역공학** — rpmeta `04_vessel/_vessel-roadmap.md`·`categories/*`. vessel-gap vs data-gap·17축.
4. **경쟁사** — 갭헌팅 보드 후니 빈칸 후보(판정만).

## 라이브 실측 패턴 (읽기전용)

```bash
# .env.local 로드 후 (자격증명 stdout 노출 금지)
psql "$RAILWAY_DB_URL" -c "SELECT mat_typ_cd, count(*) FROM t_mat_materials GROUP BY mat_typ_cd ORDER BY 1;"
psql "$RAILWAY_DB_URL" -c "SELECT cat_cd, upr_cat_cd, use_yn FROM t_cat_categories WHERE upr_cat_cd IS NOT NULL;"
```

[HARD] SELECT만. INSERT/UPDATE/DELETE 절대 금지. 라이브가 등록/NULL/존재 판정의 권위(추출본은 stale 가능).

## 결함 분류 [HARD]

각 결함:
- **현재값 vs 정답** — 라이브 실제 ↔ 권위.
- **원인유형** — ⓐ 입력 v03 전파(load_master 무변환·round-22 §03) / ⓑ 그릇 부재(vessel-gap·V-10/11/12) / ⓒ 미적재(data-gap) / ⓓ 코드 도메인 오류(잘못된 t_*).
- **결함 종류** — 오염·누락·오매칭·고아.
- **라우팅** — 신규 등록 / 교정 / 축이동(자재→CPQ·자재→siz) / 카테고리 재연결·삭제.

## dbmap 진단 인용·정합 [HARD]

round-13(라이브 정합 교정)·round-22(6축 staged)가 이미 진단/교정한 부분은 **재진단하지 말고 인용**하고, 현재
상태만 라이브 재확인(stale 경계 — 이미 COMMIT된 결함을 미교정으로 오판 금지). 신규 = "기초코드 등록" 렌즈의 갭.

## 1순위 진단 (자재·카테고리)

- **자재 🔴** — MAT_TYPE .08/.09/.10 오염(색/형상/사이즈/구수가 자재행). 본체색 합성 정당 vs CPQ 축이동 vs siz 축이동 분리. component_prices 참조 여부(가격사슬 영향) 실측. round-22 ④/B-3·GPM 인용.
- **카테고리 🔴** — 고아 노드(부카테고리 중복·빈 노드). round-22 ⑥ COMMIT(DELETE 111·UPDATE 12) 후 잔여 라이브 재실측.
- 나머지 4축 스캐폴드 요약 보드.

## 산출

`_workspace/huni-basecode/02_diagnosis/`: `diagnosis-material.md`·`diagnosis-category.md`·`diagnosis-scaffold.md`·`_routing-summary.md`(신규/교정/축이동 집계).

## 금지

- 추정 결함 단정(4-way 근거 명시·모호분은 "판정불가+추가관측" 정직 분류).
- dbmap 기진단 중복 재진단.
- DB 쓰기.
