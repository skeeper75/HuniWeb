---
name: hbd-source-harvest
description: >
  후니프린팅 기초데이터 표시중복 정리 하네스의 토큰효율 추출 방법론. 두 SOT 권위 엑셀과 라이브 t_*
  기초데이터를 1회만 스크립트로 추출해 정규화 CSV 캐시 + 축별 표준 인덱스로 변환하는 절차를 제공한다.
  ★엑셀을 컨텍스트로 반복 Read 금지 — openpyxl/pandas 추출→CSV→이후 CSV·집계로만(엑셀 원본 로드 0).
  기존 추출본 재사용 우선·freshness 기록·축별 인덱스 표준 스키마·라이브 읽기전용 SELECT를 다룬다.
  '토큰효율 추출', '엑셀 캐시', '사이즈 추출', '기초데이터 추출', '인덱스 생성', '추출 다시' 작업 시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-19"
  tags: "extract, cache, excel, token-efficient, basedata"
---

# hbd-source-harvest — 토큰효율 추출 방법론

## 왜 이렇게 하는가

엑셀(.xlsx)을 컨텍스트로 Read하면 수만 토큰이 든다. 한 번 스크립트로 CSV로 빼두면 이후 모든 탐색은 `Grep`·집계 스크립트로 수십 토큰에 끝난다. 권위 엑셀은 작업 중 거의 안 바뀌므로 캐시가 안전하다.

## 절차

1. **재사용 확인 먼저**. 신규 추출 전에 기존 캐시를 점검한다:
   - 라이브 사이즈: `_workspace/huni-dbmap/00_schema/ref-sizes.csv`(헤더: `siz_cd,siz_nm,work_width,work_height,cut_width,cut_height,margin_*,impos_yn,use_yn,note,reg_dt,upd_dt,del_yn`), `ref-product-sizes.csv`, `ref-product-plate-sizes.csv`
   - 권위 L1: `_workspace/huni-dbmap/24_master-extract-260610/06_extract/*-l1.csv`
   - 재사용 스크립트: `_workspace/huni-dbmap/06_extract/scripts/extract_l1.py`, `09_load/goods-pouch/gen_size_analysis.py`
   - 신선도: `stat -f %m <엑셀>` vs 캐시 mtime. 캐시가 최신이면 재사용, 아니면 재추출.
2. **엑셀은 스크립트로만**. openpyxl(`data_only=True`로 수식 결과값)으로 필요한 시트·컬럼만 읽어 CSV로 쓴다. 시트명을 모르면 `wb.sheetnames` 덤프 먼저. 결과는 행수·컬럼·샘플 3줄만 보고.
3. **라이브 추출**(필요 시). `.env.local`의 `RAILWAY_DB_*`로 `psql ... -c "\copy (SELECT ...) TO STDOUT CSV HEADER"` 읽기전용. 자격값은 stdout 비노출.
4. **축별 표준 인덱스 생성**. `_workspace/huni-basedata-dedup/<axis>/index.csv`:
   `code, display_name, raw_value_json, unit, semantic_axis, product_bindings, price_dependent, source, note`
   - `raw_value_json`: 사이즈=`{"work_w":..,"work_h":..,"cut_w":..,"cut_h":..}`; 공정/옵션=파라미터 JSON.
   - `semantic_axis`: 작업/재단/판형/완제/단위 등 — 중복 false-positive 가드의 근거.
   - `price_dependent`: component_prices 등이 이 code를 참조하면 Y(적재 안전경계 판정).
5. **매니페스트**. `harvest-manifest.md`에 출처 파일·mtime·추출시각·행수·재사용/신규·토큰절약 노트.

## 산출물

`_workspace/huni-basedata-dedup/<axis>/`: `index.csv`·`authority.csv`·`live.csv`·`harvest-manifest.md`.

## 하지 말 것

- .xlsx를 Read 도구로 컨텍스트에 로드 금지.
- v03 마이그레이션 산출 인용 금지(권위 아님).
- 라이브 파괴적 쓰기 금지(SELECT만).
