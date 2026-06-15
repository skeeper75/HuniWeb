# ④ 자재 mat_typ 교정 명세서 (P1·가역 UPDATE) — round-22 v2 경로 Y

> **작성** 2026-06-16 · dbm-correctness-auditor(round-13 방법론·dbm-axis-staged-load round-22 v2). 사용자 선택 = "가역·고효과부터(⑥카테고리·④자재 mat_typ)". 본 문서는 **교정 명세서**다 — 실 라이브 변경·실 COMMIT 없음(읽기전용 실측 + 명세까지).
>
> **권위순서(라이브=교정대상):** ① 상품마스터 260610 + 인쇄상품가격표(`24_master-extract-260610/`·`docs/huni/`) ② webadmin 적재 oracle(`raw/webadmin/tools/load_master.py`·`sql/`) ③ 스키마 설계의도 ④ 확정 도메인. **v03=오염원·정답 아님.**
>
> **[HARD] 비파괴·읽기전용:** 라이브 SELECT만(INSERT/UPDATE/DELETE/DDL 0건). hard-delete 금지(use_yn='N' 제안).
>
> **[HARD] 이번 범위 = mat_typ UPDATE만(가역).** 색/형상/용량/구수/인쇄면 비소재 행의 **논리삭제·색→option 분리는 CPQ 의존**이라 이번 제외·BLOCKED(B-3·다음 단계).

---

## 0. 한 줄 결론 (★실측이 진단을 정정 — 정직 finding)

라이브 t_mat_materials를 mat_typ 12종 전수 스캔한 결과, **mat_typ UPDATE만으로 고칠 명백한 단건 오적재는 사실상 부재**하다. 02 진단·04 재실측이 가정한 **"점착지 .01→.11"은 실데이터에 없고**(아트지·크라프트=종이 정상·스티커지=.11 정상), **레더는 이미 전부 .06으로 정정 완료**(BATCH-4 반영·6행 CONFIRMED). 자재 오염의 본질은 mat_typ_cd가 그룹을 벗어난 것이 아니라(.09 파우치 행도 mat_typ=.09로 "유형 그룹은 일관"), **행 단위가 비소재(색/형상/용량/구수)라는 것** — 이는 mat_typ 정정이 아니라 **축이동(색→option·형상→siz)**으로만 해소되며 본 범위 밖(B-3). **순수 mat_typ UPDATE 대상 = MAT_000166 1건(.01 종이→비종이)이고, 그마저 정답 유형 미확정(BLOCKED).**

---

## 1. 라이브 전수 실측 (2026-06-16·읽기전용 재현 SELECT)

### 1-1. mat_typ 12종 분포 (del 제외) + 코드값

```sql
SELECT mat_typ_cd, count(*) FROM t_mat_materials
WHERE del_yn IS DISTINCT FROM 'Y' GROUP BY mat_typ_cd ORDER BY mat_typ_cd;
```

| mat_typ_cd | 의미 | 행수 | mat_typ 정합 판정 |
|------------|------|:--:|------|
| MAT_TYPE.01 | 종이 | 103 | 🟡 1건 의심(MAT_000166 투명접착PVC) |
| MAT_TYPE.02 | 필름 | 5 | 🟢 정상(투명커버류) |
| MAT_TYPE.03 | 아크릴 | 14 | 🟢 정상(아크릴 색/두께 variant·유형 일관) |
| MAT_TYPE.04 | 금속 | 19 | 🟢 정상(링/D링/볼체인·색 variant는 B-3) |
| MAT_TYPE.05 | 원단 | 14 | 🟢 정상(천류·"파우치" 고아행은 B-3) |
| MAT_TYPE.06 | 가죽 | 6 | 🟢 **이미 정정 완료**(레더 6행·BATCH-4) |
| MAT_TYPE.07 | 부속 | 33 | 🟢 정상(아크릴부속/굿즈부속/삼각대/D링) |
| MAT_TYPE.08 | 실사소재 | 14 | 🟡 5행 색상variant(.255~259)는 B-3·mat_typ는 그룹내 |
| MAT_TYPE.09 | 파우치 | 74 | 🟡 비소재 행 다수(형상/용량/구수)·mat_typ는 .09 일관→B-3 |
| MAT_TYPE.10 | 악세사리 | 43 | 🟡 비소재 행 다수(색/구수/길이)·mat_typ는 .10 일관→B-3 |
| MAT_TYPE.11 | 스티커 | 14 | 🟢 정상(스티커지류) |
| MAT_TYPE.12 | 굿즈 | 1 | 🟡 MAT_000262 무광75mm(형상·B-3) |
| **합계** | | **340** | (04 재실측 fresh 340 정합·del 1=각목 변형) |

### 1-2. 레더 .06 — 이미 정정 완료 CONFIRMED

```sql
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials
WHERE del_yn IS DISTINCT FROM 'Y' AND (mat_nm LIKE '%레더%' OR mat_nm LIKE '%가죽%') ORDER BY mat_cd;
```
| mat_cd | mat_nm | mat_typ_cd | 판정 |
|--------|--------|-----------|------|
| MAT_000006 | 레더하드커버 | MAT_TYPE.06 | 🟢 정상 |
| MAT_000008 | 레더 | MAT_TYPE.06 | 🟢 정상 |
| MAT_000173 | 레더하드커버 A | MAT_TYPE.06 | 🟢 정상 |
| MAT_000174 | 레더하드커버 A5 | MAT_TYPE.06 | 🟢 정상 |
| MAT_000175 | 레더하드커버 A4 | MAT_TYPE.06 | 🟢 정상 |
| MAT_000186 | 레더(화이트) | MAT_TYPE.06 | 🟢 정상 |

> **02/04 "잔존 레더 .08/.01" = 부재 CONFIRMED.** 전 레더 6행 .06. **잔존 mat_typ 오적재 0.** BATCH-4 완료 입증.

### 1-3. 점착지 .01→.11 의심 — 부재 CONFIRMED (정직 정정)

```sql
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE del_yn IS DISTINCT FROM 'Y'
 AND (mat_nm LIKE '%점착%' OR mat_nm LIKE '%스티커%' OR mat_nm LIKE '%아트지%' OR mat_nm LIKE '%크라프트%')
ORDER BY mat_typ_cd, mat_cd;
```
- **아트지 8행(MAT_000076~083)·유니/뉴/팬시크라프트 3행·리무벌아트지 1행 = 전부 .01 종이** → 종이가 맞음(아트지·크라프트=종이). mat_typ 정정 불요.
- **스티커지 11행(비코팅/유포/무광코팅/유광코팅/수분리/투명/홀로그램/크라프트/데드롱/미색스티커) = 전부 .11** → 정상.
- **★판정:** "점착지가 .01에 잘못 들어가 .11로 옮겨야 할 행"은 **실데이터에 없다.** 02/04 진단의 가정은 stale — mat_typ UPDATE 대상 아님.

---

## 2. mat_typ 정정 명세표 (가역 UPDATE)

### 2-1. 유일 후보 — MAT_000166 (정답 유형 미확정·BLOCKED)

```sql
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000166';
-- MAT_000166 | 투명접착 PVC | MAT_TYPE.01
SELECT count(*) FROM t_prc_component_prices WHERE mat_cd='MAT_000166';        -- 0 (가격사슬 무참조)
SELECT count(*) FROM t_prd_product_materials WHERE mat_cd='MAT_000166';        -- 0 (상품 미연결·고아 자재)
```

| mat_cd | mat_nm | 현재 mat_typ | 정답 mat_typ | 근거(권위) | 판정 |
|--------|--------|:--:|:--:|------|------|
| MAT_000166 | 투명접착 PVC | MAT_TYPE.01(종이) | **비종이 확실**(.02 필름 또는 .08 실사소재) | PVC는 종이 아님(도메인). 유사 자재 투명PVC(MAT_000180)=.08 실사소재 | 🔴 **AMBIGUOUS/BLOCKED** |

> **BLOCKED 사유:** (1) "투명접착 PVC"가 상품마스터 260610 L1에 부재(silsa L1엔 "PVC"·"투명PVC"만 존재·이미 .08 적재) → 권위로 정답 유형 단정 불가. (2) 상품 미연결·가격사슬 0 = v03 잔재 가능성. **종이(.01)가 아닌 것은 확실하나 .02/.08 택일은 컨펌 필요**(추측 금지). 비활성/논리삭제 검토 후보이기도 함.

### 2-2. mat_typ가 그룹을 벗어난 행 — 0건 (전수 스캔 결과)

```sql
-- 종이(.01)에 비종이 소재 키워드 스캔
SELECT mat_cd, mat_nm FROM t_mat_materials WHERE mat_typ_cd='MAT_TYPE.01' AND del_yn IS DISTINCT FROM 'Y'
 AND (mat_nm LIKE '%스티커%' OR mat_nm LIKE '%PVC%' OR mat_nm LIKE '%아크릴%' OR mat_nm LIKE '%천%'
      OR mat_nm LIKE '%필름%' OR mat_nm LIKE '%금속%' OR mat_nm LIKE '%가죽%' OR mat_nm LIKE '%레더%');
-- 결과: MAT_000166 투명접착 PVC (1건뿐, §2-1)
```
- 아크릴(.03)·가죽(.06)·스티커(.11)·필름(.02)·원단(.05) 전수도 그룹 일관(키워드-유형 정합). **mat_typ가 명백히 어긋난 행 = MAT_000166 1건뿐**, 그마저 BLOCKED.

---

## 3. 본 범위 제외 — BLOCKED (B-3·다음 단계·CPQ 의존)

> 자재 오염의 **대부분은 mat_typ가 아니라 비소재 행**이다. 이는 mat_typ UPDATE로 안 고쳐지고 **색→option·형상/용량→siz·구수→bundle 축이동 + 자재행 use_yn='N'**으로만 해소된다. CPQ option 적재 + siz 적재가 **선행 의존**이라 이번 범위 밖.

| 비소재 행군 | mat_typ(현재) | 행수 | 정답 처리(다음 단계) | 가격사슬 안전 |
|-------------|:--:|:--:|------|------|
| 파우치 형상/용량/구수/인쇄면/색×사이즈 (원형90mm·11온스·1~4구·단/양면·화이트M/L/XL) | .09 | ~74 | 형상/용량→siz·구수→bundle·인쇄면→print_side·색→option_items | 04 재실측 NEW-5: component_prices 0건 참조(안전)·단 product_materials 64상품 재배선 선행 |
| 악세사리 색×구수/길이 (오렌지(3개1팩)·230mm+면끈·청보라(5cc)) | .10 | ~43 중 비소재 | 색→option·길이→siz/option·잉크색→도수/option | 동상(0건 참조) |
| 실사소재 색상 5행 (화이트/블랙/홀로그램/골드/실버) | .08 | 5 | 색→option 또는 실사 소재 variant 재검토 | 동상 |
| .05 원단 "파우치" 고아 7행(MAT_000061~067·상품 미연결) | .05 | 7 | 색variant·상품 미연결 → 논리삭제 검토 | 안전(상품 미연결) |
| .12 굿즈 무광75mm | .12 | 1 | 형상→siz | 안전 |
| 코팅 평면화 4행 (○○+무광/엠보코팅·MAT_000165/172/250/260) | .01 | 4 | 자재(종이)+공정(코팅 PROC) 분해 — 자재명 정정·mat_typ 유지 | B-4(코팅=공정)·mat_typ 변경 아님 |

> **이번 범위(mat_typ UPDATE)에서 제외하는 이유:** 색/형상/용량/구수 행은 mat_typ_cd가 이미 그룹 내(.09 파우치·.10 악세사리)라 **다른 mat_typ로 바꾸는 게 정답이 아니다.** 정답은 행 자체를 적절한 축(option/siz/bundle)으로 옮기고 자재행을 비활성하는 것 = CPQ·siz 적재 선행. **B-3로 escalate.**

---

## 4. v03 시트 적용 가이드 (경로 Y — 개발자 액션)

> v03 입력 엑셀 실물 우리 repo 부재 → 적용 위치 가이드. **시트명/헤더 v03 동일·행순/surrogate 보존 [HARD].**

### 4-1. `05_자재정보` 시트 (mat_typ 정정 — 이번 범위)

- **시트명:** `05_자재정보` (load_master.py:228 `read_sheet`)
- **헤더 컬럼:** `자재코드·자재명·자재구분·선택유형·최대선택수·가로·세로·높이·무게·묶음수·부모자재코드·사용여부·비고` (load_master.py:236-242)
- **mat_typ 결정 컬럼 = `자재구분`** — load_master가 `enum_code("MAT_TYPE", 자재구분)`으로 한글 라벨→코드 변환(load_master.py:239). 코드 내장 정정 사전 `MAT_TYP_OVERRIDE`(:116-121)가 우선(레더 등 이미 .06 화).
- **★surrogate 행순 보존 [HARD]:** issue가 엑셀 행순으로 MAT surrogate 발급(load_master.py:229) → **행 삭제/재정렬 금지**(SIZ/MAT 가격사슬 component_prices.mat_cd 파손). 정정은 **행 위치 유지·`자재구분` 셀값만 변경**.
- **이번 범위 적용:** MAT_000166 1건(BLOCKED·정답유형 확정 후 `자재구분`을 "필름" 또는 "실사소재"로). **그 외 mat_typ 변경 0**(전수 정합).
- **레더:** 이미 `MAT_TYP_OVERRIDE`(:116-121)가 코드로 .06 정정 → v03 `05_자재정보`의 `자재구분`이 틀려도 코드가 덮음. 추가 작업 불요.

### 4-2. 경로 X(라이브 직접 SQL·보조·다음 재적재 전까지만 유효)

> 가역 UPDATE에 한함·**load_master 재적재 시 소멸 명시 [HARD].**

```sql
-- 비파괴 제안(실행은 인간 승인·BLOCKED 해소 후에만). MAT_000166 정답유형 확정 시:
-- UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.08', upd_dt=now() WHERE mat_cd='MAT_000166';
--   (정답유형=.02 필름 또는 .08 실사소재 컨펌 후 택일)
-- 그 외 mat_typ UPDATE 대상 없음(전수 정합 확인).
```

---

## 5. 개발자 액션 요약

1. **(이번 범위)** mat_typ UPDATE 명세 = **MAT_000166 1건뿐이며 BLOCKED**(정답유형 컨펌 필요). 그 외 전 자재 mat_typ 정합 — **레더 .06 완료·점착지 의심 부재 입증.**
2. **(BLOCKED·B-3·다음 단계)** 비소재 자재행(.08 색5·.09 파우치·.10 악세사리)은 mat_typ가 아니라 축이동 — CPQ option·siz 적재 선행 후 use_yn='N'(별도 단계·인간 승인).
3. **(컨펌)** MAT_000166 정답 mat_typ(.02 필름 vs .08 실사소재)·MAT_000166 자체 정체(v03 잔재 여부).

---

## 6. 적재 로직 근거 (loadlogic — why)

- **자재 오염 진원 = ⓐ v03 입력**(03 분석 §2-1 CONFIRMED). `load_materials`(load_master.py:236-242)는 `자재명`·`자재구분`을 **무변환** INSERT(mat_typ만 enum 라벨→코드). 색/형상이 자재행인 것은 **v03 `05_자재정보`가 그렇게 인코딩**한 것을 그대로 전파 — 코드가 색을 자재로 만들지 않음.
- **MAT_000166 why:** v03 `05_자재정보`에 "투명접착 PVC"의 `자재구분`이 "종이"로 기입됐거나 빈 값 default → .01 적재. 코드 내장 정정 사전 `MAT_TYP_OVERRIDE`(:116-121)에 미등록이라 교정 안 됨. **why 정답:** PVC는 비종이(도메인). 단 상품마스터 권위에 "투명접착 PVC" 부재 → 정답 유형 컨펌 전 BLOCKED.
- **레더 .06 why(이미 교정):** `MAT_TYP_OVERRIDE`(:116-121)가 v03의 "MAT.레더하드커버 A" 등 4건을 코드로 .06(가죽) 정정 → 라이브 반영 완료(BATCH-4). 이것이 ⓑ 코드 정정 선례(03 분석 §2-2).
