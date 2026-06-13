# 후가공_박(대형) import 그릇 — 독립 검증 게이트 (round-16)

> 검증자: dbm-validator (생성자≠검증자). 빌더 산출을 의심·라이브 information_schema + openpyxl 원본 직접 실측.
> 일시: 2026-06-13. 라이브 read-only(`-d railway` @ zephyr.proxy.rlwy.net:45948). 원본 openpyxl data_only.
> 대상: `20_price-import/foil-large/` (structure·decomposition·import.xlsx·mapping-flow)
> 박소형 게이트(`_gate/foil-small-gate.md`) 동형 — 박대형이 2단 룩업 + 동판 면적매트릭스 패턴인지 평결.

---

## 0. 직접 실측 인용 (권위)

### openpyxl 전수 스캔 — `후가공_박(대형)` 시트
- 격자 `A1:BR992`(max_col 70) = **빈 아티팩트**. 실데이터 = non-empty **417셀**·max data row **48**·max data col **16**(P열). 추가 박종/면적구간 블록 0 → 빌더 "70열 가설 반증·실데이터 48행16열" **확인**.
- **B1 동판비** A1~I10: `B3~I10` = 가로 8(30·50·70·90·110·130·150·170mm) × 세로 8(30~170mm) = **64셀**(11,000~64,000원). A11=`*아연판` 노트.
- **B2a 일반박 면적→등급** A14~I23: `B16~I23` = 8×8 = 64셀(등급 A~E 라벨). A14 헤더 박종 = 금유광/금무광/은유광/은무광/동박/청박(6종).
- **B2b 일반박 가격** K14~P28: 등급 `L15~P15=A·B·C·D·E(5등급)` × 수량 `K16~K28=13구간`(10·200·500·1000·2000·3000·4000·5000·6000·7000·8000·9000·10000) = **65셀**.
- **B3a 특수박 면적→등급** A34~I43: B2a와 동일 매핑. A34 헤더 박종 = 먹유광/백박/홀로그램/트윙클/적박/녹박(6종).
- **B3b 특수박 가격** K34~P48: 5등급 × 13구간 = **65셀**.
- **가격셀 합계 = 동판 64 + 일반박 65 + 특수박 65 = 194** (직접 재카운트로 빌더 주장 일치). 면적→등급 128셀(64×2)은 가격 아님.

### 라이브 information_schema + 데이터 실측
- `t_prc_price_formulas` 컬럼 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` → **frm_typ_cd/prd_cd 부재 확인**.
- `t_prc_component_prices` 차원 = `siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·proc_cd·opt_cd`(8) + comp_cd·apply_ymd·unit_price·note·comp_price_id·reg_dt·upd_dt(=15컬럼).
- `t_prc_price_components` = `comp_cd·comp_nm·comp_typ_cd·note·use_yn·reg_dt·upd_dt·prc_typ_cd·use_dims`.
- `t_cod_base_codes` = `cod_cd·cod_nm·upr_cod_cd·disp_seq·use_yn·note·reg_dt·upd_dt`(code_group_cd 없음).
- **박 공식**: `frm_nm LIKE '%박%' OR frm_cd LIKE '%FOIL%'` = **0행**.
- **FOIL comp**: `comp_cd LIKE '%FOIL%'` = 전부 명함박(`COMP_NAMECARD_FOIL_S1/S2_STD/HOLO·SETUP_S1/S2_STD`). **대형박 전용 comp 없음·채번 충돌 0**.
- **component_prices FOIL** = 명함박 38행(S1/S2 STD/HOLO 각 9 + SETUP 각 1). **대형박 0행**.
- **명함박 거동**: `COMP_NAMECARD_FOIL_S1_STD` 200매=19,200 / 300=24,800 / ... 1000=92,000(HOLO). 수량할인 총액(장당 하락) = **합가 거동인데 comp_nm "오리지널박 합가(완제품가)"·prc_typ_cd=PRICE_TYPE.01 단가형 등록** = 🔴 충돌 **실재 확인**.
- **명함박 formula_components 배선** = **0행**(comp만 있고 배선 0 = 단절 실재).
- **opt_cd 전역 비NULL** = **0행**(등급 opt_cd = 첫 실사용).
- **GRADE_A~E / FOIL_GRADE 코드** = `cod_cd LIKE 'GRADE%'` = **0행**(미등록).
- **박종 proc**: PROC_000033=박·41=동박·42=적박·43=청박·**44=트윙클**·45=펄박·46=백박·47=녹박 → 특수박 군에 트윙클 포함.
- **동판 좌표 siz**: NxNmm 패턴 `t_siz_sizes` 실재 = **13개**(110x110·110x170·170x110·30x30·30x70·50x30·50x50·50x70·50x90·70x50·70x70·90x50·90x90). 64좌표 중 13등록·**51 미등록** 확인.

### import.xlsx 그릇 실측 (9시트)
- _NEW 시트 ROW2 DB컬럼이 라이브 information_schema와 **1:1 일치**(price_formulas=frm_cd/frm_nm/use_yn/note·frm_typ_cd 없음 / B1_grade=cod_cd/cod_nm/upr_cod_cd/disp_seq/use_yn/note).
- `4_component_prices_NEW` 실데이터(row4~) = PLATE 64 + PROC_STD 65 + PROC_SPC 65 = **194행**. **자연키 중복 0**(plate=(comp,siz)·proc=(comp,opt,min_qty)).
- plate 64행 = **siz_cd 등록 13 + `?? WxH` 미등록 51**. proc opt_cd = GRADE_A~E·min_qty 13구간.
- `2_formula_components_NEW` = **3배선**(PLATE seq1 + PROC_STD seq2 + PROC_SPC seq3, addtn_yn=Y).
- `3_price_components_NEW` = 3 comp: PLATE=**.01 단가형**(use_dims=`["siz_cd"]`) / PROC_STD·SPC=**.02 합가형**(`["opt_cd","min_qty"]`).
- 별 시트: `1b_product_formulas_BLOCK`(prd_cd 미확정 분리)·`A1_area_grade_map_REF`(64행)·`A2_plate_siz_proposal`(51행)·`B1_grade_codes_proposal`(5행).

### 무손실 round-trip 직접 대조 (원본 ↔ import 값)
- **PLATE**: siz_cd→WxH 역매핑(라이브 t_siz_sizes) + ?? note WxH 파싱 → 원본 매트릭스 64좌표 양방향 매칭 = **matched 64 / mismatch 0**.
- **STD**: 65좌표 (등급×수량) = src 65 / imp 65 / mismatch **0**.
- **SPC**: 65좌표 = src 65 / imp 65 / mismatch **0**.
- **A1 면적→등급**: 64행, 원본 B16~I23 등급 라벨과 mismatch **0**.

---

## 1. P1~P6 게이트 표

| 게이트 | 판정 | 근거(직접 실측) |
|--------|------|-----------------|
| **P1 그릇=라이브 1:1** | ✅ PASS | _NEW ROW2 DB컬럼 = 라이브 information_schema 1:1. price_formulas에 frm_typ_cd/prd_cd 부존재 실측 일치. 상품바인딩 별 테이블(1b) 분리. component_prices 차원 컬럼 표기 모두 라이브 실재. B1_grade ROW2가 라이브 base_codes 실컬럼(cod_cd·upr_cod_cd…)과 일치(code_group_cd 같은 부재 컬럼 표기 0). |
| **P2 stale 차단** | ✅ PASS | prc_typ_cd(.01/.02)·use_dims(jsonb)·opt_cd 차원 반영(round-14 Phase11 단가/합가 구조). round-2 BLOCKED NULL 회귀 0(BLOCKED는 별 시트 1b·B1·A2로 분리, NULL 강제 없음). 8→10차원 명칭 무영향. |
| **P3 분해 무손실** | ✅ PASS | openpyxl 직접 재카운트 동판64+일반박65+특수박65=**194** = import 194행 일치. **값 round-trip mismatch 0**(PLATE 64·STD 65·SPC 65·A1 64). 드롭/날조 0. 면적→등급 128셀은 A1_REF 64행(공통) 보존. 노트(A11·헤더 박종) 보존. |
| **P4 단가/합가 정당** 🔴 | ⚠️ PASS-with-CONFIRM | 거동 직접 판정: B2b/B3b 값=수량구간 **총액**(일반박 GRADE_A 1000매=75,000·2000매=150,000 정확 2배=수량비례) → 합가형(.02) 거동상 정당. **라이브 충돌 실재 확인**: 명함박(`COMP_NAMECARD_FOIL_*`) comp_nm "오리지널박 합가(완제품가)"·수량할인 총액 거동인데 prc_typ_cd=**.01 단가형** 등록. 빌더 컨펌-A가 라이브 실재 충돌 위에 서 있음 — 추정 금지·인간 컨펌 정당. |
| **P5 동시매칭 0 + 등급 opt_cd** | ✅ PASS | 자연키 중복 **0**(194건 유니크: PLATE=(comp,siz)·PROC=(comp,opt,min_qty)·STD/SPC comp 분리로 NULL행+전용행 공존 0). 등급=opt_cd 정당(opt_cd 전역 0행=첫 실사용·라이브 grade 차원 부재). siz_cd=NULL 강제 안 함(박가공 등급은 사이즈 아님). 동판 comp는 siz_cd 실사용(별 comp이므로 충돌 0). GRADE_A~E·FOIL_GRADE 미등록→B1 선적재 분리. **🔴 opt_cd vs comp_cd 횡단 쟁점**: 빌더가 opt_cd 채택 + comp_cd 분리 대안 병기·인간 컨펌 표기 = 정직(박소형과 동시 결정 권고). |
| **P6 가격사슬** 🔴 | ✅ PASS | 박 공식·대형박 단가행·명함박 배선 모두 라이브 **0행** 실측 = 전면 미적재(아크릴/떡메 "적재됐으나 배선0" 단절과 달리 **아예 없음**). 신규 사슬(formula→3배선→3 comp→194 단가행) 완결 설계. 동판 좌표 13등록·51미등록 실측 일치 → 경로(a 앱룩업 권장)/경로(b siz_cd 51좌표 선적재 A2) 병기·컨펌 정당. 면적→등급 앱 분리 = 메모리 권위 `dbmap-compute-in-app-db-stores-lookup` 정합. |

---

## 2. 빌더 주장 대비 검증 결과 (뒤집힘/보정/확인)

| 항목 | 빌더 주장 | 검증자 실측 | 평결 |
|------|-----------|-------------|------|
| 70열 가설 | 반증·실데이터 48행16열·417셀 | non-empty 417·max row 48·col 16 | **확인** |
| 194 단가행 | 동판64(8×8)+일반박65+특수박65 | openpyxl 재카운트 194 = import 194 = **값 mismatch 0** | **확인**(카운트·값 모두 정확) |
| 동판 매트릭스 | 8×8 면적매트릭스(64좌표·use_dims=["siz_cd"]) | B3~I10 8×8=64·PLATE round-trip 64/0 | **확인**(소형 단일고정과 진짜 다름) |
| 등급 = opt_cd 5등급 | GRADE_A~E·opt_cd 첫 실사용 | L15~P15=A~E·opt_cd 비NULL 전역 0행·import opt_cd distinct=GRADE_A~E | **확인** |
| 단가/합가 | 가격표=합가(.02)·라이브 명함박 .01 충돌 컨펌 | 거동(총액·수량비례) + 명함박 .01 "합가" 등록 **실재** | **확인(CONFIRM 필수)** — 박소형과 공통 최대 쟁점 |
| 가격사슬 미적재 | 공식·단가행·배선 모두 0(명함박 comp만·배선0) | 박 공식0·대형박 comp0·opt_cd0·명함박 배선0 전부 실측 | **확인**(전면 미구축) |
| 동판 좌표 13/51 | 64좌표 중 13등록·51미등록 | NxN siz_cd 13개 실재·import ?? 51개·A2 51행 | **확인**(정확) |
| GRADE 코드 미등록 | GRADE_A~E·FOIL_GRADE 미등록→B1 선적재 | cod_cd LIKE 'GRADE%' 0행·base_codes에 code_group_cd 없음 | **확인** |
| 면적→등급 거처 | 앱 책임 + A1_REF 별 시트 64행 | A1 64행·원본 등급라벨 mismatch 0·메모리 권위 정합 | **확인** |
| opt_cd vs comp_cd | opt_cd 채택 + comp_cd 대안 병기·컨펌 | 박소형 게이트 횡단 쟁점 그대로 승계·import opt_cd로 빌드 | **확인**(정직·동시 결정 권고) |
| 박소형 동형 | 2단 룩업·등급opt_cd·합가컨펌·STD/SPC 분리·바인딩 BLOCKED 재사용 | 구조 전부 박소형과 동형(동판만 매트릭스로 차이) | **확인** |
| 박종 proc 나열 | structure §3 "트윙클(PROC_000044)" 명시 | PROC_000044=트윙클·특수박 헤더(홀로그램/트윙클) 일치 | **확인**(박소형 게이트가 지적한 트윙클 누락 보정 반영됨) |
| 10차원 | component_prices "10차원" | 실제 차원성 컬럼 8개(+comp_cd·apply_ymd=10) | **명목 표기**(round-14 명칭·자연키 검사 무영향) |

**뒤집힌 항목: 0건.** 박소형 게이트가 지적했던 경미 보정 2건(트윙클 명시·3배선)이 대형 산출에는 이미 반영(structure §2에 트윙클 명시·decomposition §0에 3배선 일관) = 빌더가 박소형 피드백 학습 적용.

---

## 3. 종합 평결

### 박대형 = 박소형 2단 룩업 동형 평결
- **YES(동형)**: 2단 룩업(면적→등급→가격) 구조·등급 opt_cd 첫 실사용·면적→등급 앱 분리·STD/SPC comp 분리·상품 바인딩 BLOCKED·단가/합가 컨펌·opt_cd vs comp_cd 횡단 쟁점 = **박소형 패턴 그대로 재사용**. round-5 DDL GAP "박 2단룩업" 정체 동일 규명.
- **차이(직접 분해·검증 통과)**: ① 동판비가 **면적매트릭스**(64좌표·use_dims=["siz_cd"]·소형은 단일 고정) → 동판 comp가 siz_cd 차원 사용·좌표 51개 선적재 차단(경로b). ② 수량구간 13개(소형 18). ③ 면적→등급 8×8 대칭(소형 3×5 비대칭) → 무손실 보존 더 깔끔.
- **세트형 아님**: 박대형도 후가공 합산(동판비 + 등급별 가공비)이지 "여러 구성품 1세트 고정가" 아님. 세트형 신규구조 여전히 미발견(박소형 평결과 동일).

### GO / NO-GO
**조건부 GO (CONDITIONAL-GO)** — 그릇 분해는 무손실(값 mismatch 0)·정합(라이브 1:1)·동시매칭0로 **구조적으로 GO**. 단 실 적재 전 **3개 선결 차단 + 1개 컨펌**이 인간 승인 대기:
1. **차단1(코드 선적재)**: GRADE_A~E·FOIL_GRADE 코드 미등록 → B1 제안 선적재 후 opt_cd 적재.
2. **차단2(상품 바인딩)**: 박이 붙는 prd_cd 미확정 → 1b BLOCKED, NULL 강제 금지(준수 확인).
3. **차단3(동판 좌표·경로b 채택 시)**: 동판 51좌표 siz 미등록 → A2 제안 선적재. 경로(a) 앱룩업 채택 시 불필요(메모리 권위 권장).
4. **컨펌(P4 단가/합가)**: 가격표 거동=합가형(.02)이나 라이브 명함박 동형이 .01 단가형 등록 = 충돌 실재. 박소형·대형 동시 결정 + 명함박 .01 등록 정합 감사로 확대 권고.

### 검증자 권고
- P4 컨펌 + opt_cd vs comp_cd 통일 컨펌은 박소형·대형 **동시 결정**(같은 박 도메인·코드 공유 B1).
- 명함박 라이브 .01 등록("합가(완제품가)"라 적힌 comp가 .01)의 정합 감사 = round-13 교정 트랙 연계 권고(전사 박 단가/합가 관례인지 오등록인지).
- 동판 경로 a(앱룩업) vs b(siz_cd 선적재) 최종 결정 = 메모리 권위는 앱룩업(a) 권장이나 좌표 직접가라 b도 정당 → 인간 컨펌.
- 이상 모두 구조 무손상 → 게이트 **GO 유지**. 뒤집힌 결함 0건.
