# vessel-constraint-logic-types (V-4, #5 제약 논리유형) — WEAK 🟡 → 그릇 설계 (경량)

> rpm-vessel-designer. RP `Constraint` 6 논리유형(disable/force/require/essential/match/exclude/min-max)을 후니가 거버넌스할 그릇.
> 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.

## 0. 한 줄 평결
**그릇은 이미 충분 — `logic jsonb`가 임의 논리를 무손실 표현, essential은 option_groups가 이미 흡수.** 결손은 거버넌스용 **RULE_TYPE 코드 2~3개**(match·범위)뿐. 사다리 = **코드행(최저단)**. 신규 테이블/컬럼 0. essential은 **PASS 재분류**(아래 §1).

## 1. search-before-mint (라이브 실측)
RP 6 논리유형 vs 후니 표현:
| RP 논리유형 | 후니 기존 그릇 표현 | 판정 |
|---|---|---|
| disable | `RULE_TYPE.02 금지` + `logic jsonb` | ✅ PASS |
| force | RULE_TYPE.01 호환/.03 필수동반 + logic (force=disable 역방향) | ✅ PASS |
| require/필수동반 | `RULE_TYPE.03 필수동반` | ✅ PASS |
| exclude | `RULE_TYPE.02 금지` | ✅ PASS |
| **essential**(그룹내 필수) | **`t_prd_product_option_groups.mand_yn` + `min_sel_cnt`/`max_sel_cnt`** (라이브 실측 — 컬럼 실재) | ✅ **PASS 재분류 — 신규 그릇 불요, option_groups 사용** |
| **match**(사이즈↔부속물 캐스케이드) | `logic jsonb`는 표현 *가능*하나 RULE_TYPE에 분류 코드 없음 → 호환/금지로 환원 시 의미축 drop | 🟡 코드행 1개 |
| **min-max**(nonspec 범위) | `logic jsonb` 표현 가능, 분류 코드 없음. V-6 사이즈 nonspec과 동일 개념 | 🟡 코드행 1개(V-6 통합) |

**핵심:** `logic jsonb`(라이브 실재·constraints.logic NOT NULL)는 JSONLogic으로 disable/force/match/min-max 전부 *표현 가능*. 부족한 건 표현력이 아니라 **거버넌스 분류**(실무진이 "이건 match 룰" "이건 범위 룰"로 관리·필터). → 코드행으로 충분. essential은 별 유형조차 불요(option_groups가 구조로 강제).

## 2. 그릇 설계 (코드행 — 사다리 최저단)
```sql
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, reg_dt) VALUES
 ('RULE_TYPE.04', '캐스케이드(match)', 'RULE_TYPE', 4, 'Y', now()),
 ('RULE_TYPE.05', '범위(min-max)',     'RULE_TYPE', 5, 'Y', now());
-- essential = 코드행 불요 (option_groups.mand_yn + min/max_sel_cnt)
```
- `logic jsonb`는 변경 0(이미 충분). 새 유형의 의미는 logic 내용으로, 분류는 rule_typ_cd로.
- match shape 예: `{"if":[{"==":[{"var":"사이즈"},"A"]}, {"require":["부속물:거치대A"]}]}` (rule_typ_cd=RULE_TYPE.04).
- min-max shape 예: `{"<=":[0,{"var":"가로"},5000]}` (rule_typ_cd=RULE_TYPE.05) — V-6 nonspec과 동일 그릇 공유.

## 3. 정규화 / 영향
- **무손실:** logic jsonb가 값(임의 논리) 보유, rule_typ_cd가 분류축. 6 유형 전부 표현·거버넌스.
- **무중복:** 분류(rule_typ_cd) ≠ 논리(logic). essential을 코드로도 두면 option_groups와 이중관리 → **코드 안 만듦(PASS 재분류)**.
- **영향:** 코드행 2개. 기존 constraints 10행·option_groups 134행 무영향. FK/컬럼/테이블 0. 백필 0.
- **롤백:** 코드행 use_yn='N'.

## 4. WEAK → 판정
- #5 제약 WEAK → **PASS**: match/min-max 코드행 2개 추가로 6 논리유형 거버넌스 완비. essential은 이미 PASS(option_groups).

## 5. DDL 참조
- 코드행만 = `dbm-ddl-proposer` 코드그룹 패턴. DDL 테이블/컬럼 craft 불요.

## 6. open decision
1. **match/min-max를 별 RULE_TYPE 코드로 vs logic 내부 컨벤션만:** 권고 = 코드행(실무진 거버넌스·필터). 다만 후니가 "logic만으로 충분, 분류 불요"로 보면 코드행도 생략 가능(그릇 0).
2. **min-max 범위 그릇을 제약(여기) vs 사이즈 행(V-6):** V-6과 통합 — designer 권고는 제약(RULE_TYPE.05)으로 일원화(V-6 §참조).
3. 실 적용 = 인간 승인.
