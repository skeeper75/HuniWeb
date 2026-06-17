# vessel-form-assembly (V-8, #14 본체 형태가공) — GAP ❌ (재판정) → 그릇 설계

> rpm-vessel-designer. RP `FormAssembly`(봉제/조립/지퍼/접합 = 평면→입체 본체 *생성* 공정)를 후니가 표현할 최소 그릇.
> 권위 = 라이브 read-only 실측(2026-06-17·본 세션 직접 측정). design ≠ apply.
> **버전:** v2.0 (GS 신축). BN 무관(BN은 형태가공 없는 평면 인쇄물). **+ §7 PD 봉제 family 메모(v8.0·신규 그릇 0).**

## 0. 한 줄 평결
**갭분석(gap-matrix §V #14)의 "봉제 2행만·그릇 부재 GAP"은 GS 라이브 재측으로 *대폭 완화*된다.** 형태가공의 *파라미터 그릇*은 이미 라이브에 실재(`PROC_000080 봉제`=`{유형:[오버로크/말아박기/봉미싱], 폭:mm}`, `PROC_000081 부착`=`{대상:[라벨/맥세이프/끈/테입]}`) — V-1 `ref_param_json`이 선택값을 받으면 봉제·부착의 형태가공 옵션은 무손실 표현된다. 진짜 vessel-gap은 **단 1개: 공정의 "유형 분류(형태가공 vs 후가공 vs 인쇄) 축"이 없다**(`t_proc_processes`에 `proc_typ_cd`/분류 컬럼 부재 — 실측). 나머지(지퍼/조립 공정 행, 파우치 가공 행)는 **공정 행 추가 = data**(봉제·부착 선례 그대로). 사다리 = **PROC_FACET 코드행 1그룹 + 조건부 `proc_class_cd` 컬럼 1개**. 신규 테이블 mint 불요.

## 1. search-before-mint (라이브 실측 — 결정적·갭분석 정정)
`t_proc_processes` 라이브 컬럼(실측 2026-06-17):
```
proc_cd, proc_nm, upr_proc_cd(계층 부모), prcs_dtl_opt(jsonb 파라미터 스키마),
disp_seq, use_yn, note, reg_dt, upd_dt, del_yn, del_dt
```
→ **`proc_typ_cd` 컬럼 부재 확정** — 후니 공정은 *유형 분류 축이 전혀 없다*(인쇄/후가공/형태가공/포장 구별 안 함). upr_proc_cd는 부모-자식 계층(봉제→봉제 variant)일 뿐 유형 분류 아님.

**갭분석 "봉제 2행만"은 과소 — GS 재측 실제 형태가공/입체 생성 관련 행:**
| proc_cd | proc_nm | prcs_dtl_opt(파라미터 스키마) | 형태가공성 |
|---|---|---|---|
| PROC_000080 | 봉제 | `{유형:[오버로크/말아박기/봉미싱], 폭:mm}` | ✅ 본체 봉합(파우치) |
| PROC_000081 | 부착 | `{대상:[라벨/맥세이프/끈/테입]}` | ✅ 부자재 부착(끈/맥세이프) |
| PROC_000082 | 족자제작 | `{모양:[사각/원형]}` | ✅ 입체 생성 |
| PROC_000083 | 에폭시 | (없음) | ✅ 입체 코팅 |
| PROC_000075 | 포장 | — | (마감) |

**상품 링크 실측:** 봉제 5상품·부착 10상품·족자 1·에폭시 1이 `t_prd_product_processes`로 실제 연결됨 → 형태가공 *공정-상품 링크 그릇*은 작동 중(PASS).

| RP FormAssembly 요구 | 후니 기존 그릇 | 무손실 가능? |
|---|---|:--:|
| assembly_type(봉제/조립/지퍼/접합) | 공정 행(봉제/부착/족자/에폭시) + 신규 행(지퍼/조립) | ✅ 행 추가=data (봉제 선례) |
| 파라미터(봉제 유형·폭·부착 대상·방향) | `prcs_dtl_opt`(스키마) + `ref_param_json`(값, V-1) | ✅ (봉제 prcs_dtl_opt 이미 실재) |
| direction_variant(세로/가로) | `prcs_dtl_opt.inputs`에 `{방향:enum}` 추가(공정 행 메타) | ✅ jsonb 스키마 확장=data |
| consumes_material(지퍼=부자재) | 부착이 이미 `{대상}` 부자재 참조·`t_prd_product_materials.usage_cd`(부자재 usage) | ✅ 기존 그릇 |
| **공정 유형 분류**(형태가공 vs 후가공 vs 인쇄) | ❌ `proc_typ_cd` 부재 — 봉제가 코팅·박과 한 평면에 섞임 | ❌ **← 진짜 vessel-gap** |
| **본체 생성성**(없으면 본체 미완 = essential 공정) | ❌ 표시 플래그 부재. 일반 후가공(optional)과 미구별 | △ (분류 축에 흡수 가능) |

**결론:** RP가 1급 엔티티로 다루는 FormAssembly의 거의 전부를 후니는 **기존 공정 그릇 + prcs_dtl_opt + ref_param_json**으로 표현 가능 — *행만 추가*하면 된다(data). 후니에 진짜 없는 것은 **"이 공정이 형태가공(본체 생성)인가"를 분류·게이팅하는 유형 축**이다. 이게 없으면 봉제가 코팅과 동급 optional 후가공으로 보여 "본체 생성성"(없으면 본체 미완) 거버넌스 불가.

## 2. 그릇 설계 (최소 — 코드행 1그룹 + 조건부 컬럼 1)
### 2.1 공정 유형 분류 축 — `t_cod_base_codes` 신규 그룹 `PROC_CLASS` (코드행, 사다리 최저단)
```sql
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, reg_dt) VALUES
 ('PROC_CLASS',    '공정유형',       NULL,         NULL, 'Y', now()),
 ('PROC_CLASS.01', '인쇄',          'PROC_CLASS', 1,    'Y', now()),
 ('PROC_CLASS.02', '후가공',        'PROC_CLASS', 2,    'Y', now()),
 ('PROC_CLASS.03', '형태가공(본체생성)','PROC_CLASS',3, 'Y', now()),
 ('PROC_CLASS.04', '포장/마감',     'PROC_CLASS', 4,    'Y', now());
```
- "형태가공(본체생성)"(.03)이 RP `FormAssembly`의 1급성을 후니 코드행으로 흡수 — 봉제/부착/족자/에폭시/(신규)지퍼/조립을 .03으로 분류 → "없으면 본체 미완" 게이팅 가능.

### 2.2 공정 행에 유형 분류 매다는 슬롯 — `t_proc_processes.proc_class_cd` 컬럼 (조건부)
```sql
ALTER TABLE t_proc_processes ADD COLUMN proc_class_cd varchar NULL;
-- FK → t_cod_base_codes(cod_cd). NULL=미분류(기존 행 무영향).
COMMENT ON COLUMN t_proc_processes.proc_class_cd IS '공정유형(PROC_CLASS): 인쇄/후가공/형태가공/포장. 형태가공=본체 생성 게이팅.';
```
- **search-before-mint 잔여:** `upr_proc_cd` 계층 최상위 부모(봉제/부착=NULL 부모, 인쇄/코팅도 NULL 부모)로는 유형을 *알 수 없다*(모든 최상위가 동격) → 계층 재사용 불가, **분류 슬롯이 진짜 필요**. 단 컬럼 1개 NULL이라 최소.

### 2.3 direction_variant·consumes·지퍼/조립 = data (vessel 아님)
- 방향(세로/가로) variant: 해당 공정 행의 `prcs_dtl_opt.inputs`에 `{방향:enum}` 추가 = jsonb 스키마 갱신(data·앱 권위).
- 지퍼(FLX_ZIP)·조립(PDT_WRK·마이크텍): **공정 행 INSERT**(봉제 선례 그대로) + 지퍼=부자재 consumes는 `t_prd_product_materials.usage_cd`(부자재 슬롯)·부착의 `{대상}` 패턴 재사용. → dbmap round-22 GPM/공정 트랙.

## 3. 정규화 / 영향
- **무손실:** 유형 분류=PROC_CLASS 코드·값(파라미터)=prcs_dtl_opt+ref_param_json·행=공정 행·부자재=usage_cd. 각 분리 함수종속, 형태가공의 4요소(유형/파라미터/방향/consumes)가 서로 다른 정규 슬롯에.
- **무중복:** PROC_CLASS=분류 메타, prcs_dtl_opt=파라미터 스키마, 행=인스턴스 — 이중저장 없음.
- **함수종속:** proc_cd → proc_class_cd 완전종속. 부분/이행 신설 0.
- **영향:** 코드행 5개 + 컬럼 1개(NULL). 라이브 공정 행(봉제/부착/코팅/박 등) **무영향**(NULL-add). FK 1(proc_class_cd→base_codes). 백필=형태가공 공정 행에 .03 부여(UPDATE, dbmap 공정 트랙). 잠금=ADD COLUMN NULL 메타데이터 변경·무잠금.
- **롤백:** 코드행 use_yn='N' + DROP COLUMN(값 백필분 백업 권고).
- **★ load-bearing(HARD):** 파우치 103상품 본체 BOM이 형태가공 공정에 의존(round-22 "평면→입체 조립"). 분류 그릇·신규 공정 행 **선행** → 상품 링크. 단 이 vessel은 분류축만이라 기존 링크 무파손.

## 4. GAP → 판정 (갭분석 정정)
- #14 형태가공: gap-matrix **GAP** → **부분 PASS로 하향**. 파라미터/링크/방향/consumes는 기존 그릇(prcs_dtl_opt·ref_param_json·usage_cd·공정 행)으로 PASS. 진짜 vessel-gap = **공정 유형 분류 축 1개**(PROC_CLASS 코드+proc_class_cd 컬럼). 지퍼/조립 행은 data. → "봉제만 GAP"이 아니라 "형태가공을 *후가공과 구별*하는 분류축 부재"가 정확한 결손.
- **이 vessel이 닫는 것:** 형태가공을 1급 게이팅 축으로 — 본체 생성성(essential 공정) 거버넌스·옵션 캐스케이드(방식→형태가공 집합) 가능.

## 5. DDL 참조
- 코드행(PROC_CLASS) = `dbm-ddl-proposer` 코드그룹 패턴. `proc_class_cd` 컬럼 = ddl-proposer 위임(V-1 `ref-param-json-proposal` 동일 ALTER 패턴 — ADD COLUMN NULL + FK).

## 6. open decision (날조 금지)
1. **proc_class_cd 컬럼 vs 코드행만:** 코드행만으로는 공정-유형 연결 불가(인스턴스 매핑 필요) → 컬럼 채택 권장. 단 후니가 "형태가공" 게이팅을 앱 하드코딩(공정 코드 목록)으로 충분히 처리 중이면 컬럼 보류 가능(over-modeling 경계).
2. **essential(본체 생성성) 표현:** 별 플래그(`form_essential_yn`) vs PROC_CLASS.03 자체로 흡수(.03이면 essential) — 후자 권장(컬럼 절약). 부착(끈)처럼 optional 형태가공이 있으면 V-4 제약(essential RULE_TYPE)로 분기.
3. **지퍼 consumes_material:** 부착 `{대상}` jsonb vs `t_prd_product_materials` 부자재 링크 — 후자(자재 그릇)가 BOM/MES 정합. 지퍼 부자재 행 mint는 dbmap.
4. **방향 variant 키 표기:** prcs_dtl_opt 한글 키(`방향`) 권위 유지.
5. 실 적용 = 인간 승인.

---

## ═══ §7. PD 봉제/제품가공 family 메모 (V-8 PD·v8.0·신규 그릇 0) ═══
> PD 갭(`categories/PD/reverse.md`·`02_metamodel/_resolved-fragments.md` PD-1~PD-6·`gap-matrix §XIX`·`vessel-needs.md PD 흡수 매핑 ①`). 후니 대조 = `vessel-mat-type-relabel.md`·round-22 ⑤공정. **PD distinct 신축 0(완제 구조물 내재BOM #18 부결·17축 재포화·8번째 카테고리). PD facet 5항 중 GAP 1(봉제/제품가공)이 본 V-8(#14) 형태가공 family에 합류·신규 V-번호 0.**

- **PD-1(봉제/제품가공)이 §1 GS 형태가공 family에 합류 — 새 family 멤버지 새 그릇 아님:** PD 봉제 구조물(스툴·슬리퍼·강아지계단)은 RP에서 `SEW_LTR`(레더 재봉)·`PDT_WRK`(제품가공/조립/솜충전)로 입력 — GS `PDT_WRK`(파우치가공)·`FLX_ZIP`(지퍼)와 **동일 #14 GAP family**(`vessel-needs.md §122 V-8`·메타모델 명제 #14). 형태가공 = 평면→입체 본체 *생성* 공정이라는 본질 동일.
- **라이브 실측 = §1 결론 그대로(과소 "봉제 2행만" 정정 유효):** PD가 요구하는 봉제(`PROC_000080 봉제`={유형:[오버로크/말아박기/봉미싱], 폭:mm})·제품가공/조립/솜충전 행은 §1 표 그대로 — 봉제 1행 실재(파라미터 그릇 PASS)·제품가공/조립/솜충전/논슬립부착은 **공정 행 미생성**(data·봉제 선례 INSERT). 진짜 vessel-gap = §1과 동일 **공정 유형 분류 축(`PROC_CLASS`·`proc_class_cd`) 1개**뿐 — PD가 새 결손을 더하지 않음(GS와 같은 1개로 닫힘).
- **그릇 조치 = §2 PROC_CLASS 그대로(별 추가 0):**
  - 봉제(`SEW_LTR`)·제품가공/조립/솜충전(`PDT_WRK`) 공정 행을 §2.1 `PROC_CLASS.03 형태가공(본체생성)`으로 분류 → "없으면 본체 미완" essential 거버넌스(스툴 다리 조립·슬리퍼 봉제는 본체 생성성 있음).
  - 봉제 유형/폭·솜 충전량·논슬립 부착 대상 = `prcs_dtl_opt`(스키마) + `ref_param_json`(값, V-1) — §1.1 표 무손실 표현(부착 `{대상:[라벨/맥세이프/끈/테입]}`에 논슬립/패드 enum 추가 = jsonb 스키마 data).
  - 지퍼(PD 파우치형 변형)·솜충전 consumes = §2.3 `t_prd_product_materials.usage_cd .07`(부자재 sub_mtrl) 재사용(아래 §11 V-3 PD 메모·솜/지퍼=내재BOM data-gap `_data-gaps-noted §9`와 정합).
- **search-before-mint:** PD 봉제 family 전부 §1 실측으로 검증됨 — 파라미터(prcs_dtl_opt)·링크(t_prd_product_processes)·consumes(usage_cd)·방향(prcs_dtl_opt jsonb) 기존 그릇 PASS·신규 공정 행=data. **신규 테이블/컬럼 0 — V-8 §2 PROC_CLASS 그릇이 PD 봉제 구조물 완제품을 견딘다(이것이 PD가 더한 것: 새 그릇이 아니라 *기존 형태가공 분류축이 봉제 구조물 완제품까지 커버한다는 검증*).**
- **dbmap 라우팅:** PD 봉제/제품가공/솜충전/논슬립 공정 행 INSERT·솜·지퍼 sub_mtrl·내재BOM(다리/받침/논슬립=부속물#8) 적재 = round-22 GPM-4·⑤공정·`dbm-ddl-proposer`(신규 공정 행)·`_data-gaps-noted.md §9`. **vessel(분류축 PROC_CLASS)=여기(§2) / data(PD 공정 행·내재BOM 적재)=dbmap.**
- **★PD 직답:** "봉제/제품가공"은 #14 V-8 GAP family — 후니 PROC 봉제 행 실재(파라미터 PASS)·제품가공/조립/솜충전 공정 행 미적재(GAP=공정행 data·봉제/조립/솜충전/지퍼 멤버 적재 필요). vessel 조치 = §2 PROC_CLASS 분류축뿐(GS와 동일·PD 추가 0).
