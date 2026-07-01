# design-selreq-260701 — 옵션그룹 sel_typ_cd(선택방식) 미기입 17건 채움 설계

## 배경
실무진이 2026-06-28~07-01 webadmin에서 22개 상품에 옵션그룹을 대거 신규 추가.
그중 **17건이 `sel_typ_cd`(선택방식) NULL** → sim-meta/위젯 렌더에서 해당 opt_group이
누락되어 손님이 선택 불가(가격 영향은 미미, **노출/선택가능성 기능 자체가 안 됨**).
대상 전수 = `staff-edit-scan-260701.json` `A_missing_sel_typ`(17건). 라이브 재조회로 재확인함.

- 대상 테이블: `t_prd_product_option_groups` (PK=(prd_cd, opt_grp_cd))
- 채울 컬럼: `sel_typ_cd`, `min_sel_cnt`, `max_sel_cnt` (전부 NULL 상태 확인)
- 코드값: `SEL_TYPE.01`=택1(단일선택), `SEL_TYPE.02`=복수선택 (t_cod_base_codes 실재 확인)
- **범위 제한**: sel_typ_cd/min/max만. mand_yn·use_yn·del_yn·옵션값 미변경.
  PRD_000129(폼보드)는 별도 트랙(design-foamboard-260701) 파손 진행 중 → 이 2개 opt_grp의
  sel_typ_cd만 채우고 폼보드의 다른 파손(사이즈 0원 등)은 미접촉(범위 밖).

## 판정 원칙 (search-before-mint)
각 그룹의 옵션값(t_prd_product_options)을 라이브에서 확인 → 상호배타(단일선택)인지 판단하고,
**라이브에 이미 정상 동작하는 동명 그룹의 sel_typ_cd 패턴을 답습**(임의 판단 금지).

### 라이브 참조 패턴 (working groups, del_yn='N')
- 동명 그룹 sel_typ_cd 분포: 인쇄18·종이20·코팅10·모서리8·접지2·칼라1·화이트인쇄1
  → **전부 SEL_TYPE.01. SEL_TYPE.02(복수선택)은 이 축들에서 0건.** (결정적)
- 상품마스터 추출본(digital-print-l1 / sticker-l1)의 속성 컬럼은 "(필수)" 표기만 존재,
  복수선택 마커 없음 → 종이/소재/인쇄/모서리 등은 전부 단일선택 속성으로 일치.

### min/max 관례 (라이브 지배 패턴)
working group의 (sel_typ_cd, mand_yn, min, max) 분포:
- `SEL_TYPE.01 | mand_yn=Y | min=1 max=1` → **95건 (지배)**
- `SEL_TYPE.01 | mand_yn=N | min=0 max=1` → **38건 (지배)**
- `SEL_TYPE.01 | mand_yn=N | min=1` → **0건** (라이브에 없는 신규패턴 = 회피)
- `SEL_TYPE.02 | mand_yn=N | min=0 max=N` (2~10)

⇒ 채움 규칙:
- **SEL_TYPE.01 + mand_yn='Y' → min_sel_cnt=1, max_sel_cnt=1**
- **SEL_TYPE.01 + mand_yn='N' → min_sel_cnt=0, max_sel_cnt=1**

> ★ 지시서의 "택1이면 min=1,max=1 채워라"와 라이브 관례가 mand_yn='N'에서 충돌.
> 라이브에는 mand_yn=N 단일선택에 min=1인 그룹이 **0건**이며, min=1을 넣으면
> "선택 안 해도 되는(mand_yn=N)" 그룹을 "반드시 1개 고르라"로 바꿔 실무진 의도(선택)와
> 어긋남. search-before-mint·"라이브 관례 답습"·"임의 결정 금지" 지시가 우선하므로
> **min = (mand_yn=='Y' ? 1 : 0), max=1** 로 결정. (핵심 결정 — relitigate 대상)

## 17건 판정표 (전부 SEL_TYPE.01 = 택1, BLOCKED 0)

| # | prd_cd | 상품 | opt_grp | 그룹명 | 활성 옵션값(개수) | mand_yn | → sel_typ / min / max |
|---|--------|------|---------|--------|-------------------|---------|-----------------------|
| 1 | PRD_000019 | 투명엽서 | OPT-000021 | 인쇄 | 단면(1) | N | .01 / 0 / 1 |
| 2 | PRD_000019 | 투명엽서 | OPT-000022 | 소재 | 투명PET260g·반투명PET260g(2) 배타 | N | .01 / 0 / 1 |
| 3 | PRD_000019 | 투명엽서 | OPT-000023 | 화이트인쇄 | 화이트인쇄(1; "없음"은 del) 토글 | N | .01 / 0 / 1 |
| 4 | PRD_000019 | 투명엽서 | OPT-000024 | 모서리 | 직각·둥근(2) 배타 | N | .01 / 0 / 1 |
| 5 | PRD_000021 | 핑크별색엽서 | OPT-000018 | 인쇄 | 단면·양면(2) 배타 | N | .01 / 0 / 1 |
| 6 | PRD_000021 | 핑크별색엽서 | OPT-000020 | 핑크인쇄 | 핑크별색(단면)·(양면)(2) 배타 | N | .01 / 0 / 1 |
| 7 | PRD_000030 | 지그재그엽서 | OPT-000028 | 인쇄 | 양면(1) | N | .01 / 0 / 1 |
| 8 | PRD_000030 | 지그재그엽서 | OPT-000029 | 종이 | 몽블랑130g(1) | N | .01 / 0 / 1 |
| 9 | PRD_000030 | 지그재그엽서 | OPT-000030 | 접지 | 6단오시접지·6단미싱접지(2) 배타 | N | .01 / 0 / 1 |
| 10 | PRD_000055 | 낱장자유형스티커 | OPT-000039 | 조각수 | 5~10조각(6) 배타 | N | .01 / 0 / 1 |
| 11 | PRD_000058 | 반칼원형스티커 | OPT-000035 | 인쇄 | 단면(1) | N | .01 / 0 / 1 |
| 12 | PRD_000058 | 반칼원형스티커 | OPT-000036 | 종이 | 유포·미색·아트·무광코팅·유광코팅(5) 배타 | N | .01 / 0 / 1 |
| 13 | PRD_000067 | 타투스티커 | OPT-000042 | 용지 | 타투스티커(1) | N | .01 / 0 / 1 |
| 14 | PRD_000118 | 아트프린트포스터 | OPT-000043 | 소재 | 인화지(1) | **Y** | **.01 / 1 / 1** |
| 15 | PRD_000129 | 폼보드 | OPT-000044 | 코팅 | 무광코팅·유광코팅(2) 배타 | N | .01 / 0 / 1 |
| 16 | PRD_000129 | 폼보드 | OPT-000045 | 보드칼라 | 화이트보드(5mm)·블랙보드(5mm)(2) 배타 | N | .01 / 0 / 1 |
| 17 | PRD_000143 | 미러아크릴스티커 | OPT-000046 | 칼라 | 골드아크릴·실버아크릴(2) 배타 | N | .01 / 0 / 1 |

- **명확(clear)**: 17건 전부. **BLOCKED: 0건.**
- 복수선택(SEL_TYPE.02) 후보: 0건. "후가공/가공" 류 다중 체크박스 그룹은 대상에 없음.
  각 그룹은 인쇄방식/소재/종이/용지/모서리/조각수/코팅종류/보드칼라/칼라/접지방식/토글 —
  전부 손님이 하나만 고르는 상호배타 속성.
- 옵션값 1개뿐인 그룹(인쇄 단면, 종이 몽블랑, 용지 타투, 소재 인화지)도 배타 단일선택 = .01
  (mand_yn=N이면 손님이 안 골라도 됨 = min 0).

## 산출물
- `selreq-backup-260701.csv` — 대상 17행 현재 스냅샷(전부 sel_typ_cd/min/max 공백=NULL)
- `selreq-fix-dryrun.sql` — BEGIN → UPDATE(16 mand_yn=N + 1 mand_yn=Y) → 검증 SELECT → ROLLBACK
- `selreq-undo.sql` — COMMIT 후 원복(3컬럼 NULL 복원)
- 본 문서

## Dry-run 실측 (BEGIN…ROLLBACK)
```
BEGIN
UPDATE 16   -- mand_yn=N → min=0,max=1
UPDATE 1    -- mand_yn=Y → min=1,max=1 (PRD_000118)
검증 SELECT: 17행 전부 sel_typ_cd=SEL_TYPE.01, min/max 채워짐
remaining_null_sel_typ = 0
ROLLBACK
```
롤백 후 라이브 재확인: 대상 17건 여전히 sel_typ_cd NULL(무변경) ✓ — 파괴적 쓰기 0.

## sim-meta 기대치 (실반영은 인간 승인 COMMIT 후)
- `sel_typ_cd` NULL이면 webadmin sim-meta 응답에서 해당 opt_group이 drop되어 손님 선택 불가.
- COMMIT 후 기대: 위 17개 opt_group이 sim-meta의 opt_groups에 **택1(SEL_TYPE.01)** 로 노출되어
  손님이 선택 가능. min/max로 선택 강제 여부 제어(mand_yn=Y 소재는 필수 1개, 나머지는 선택).
- ★ dryrun은 ROLLBACK되므로 현재 라이브 sim-meta에는 미노출 상태 유지 — 실측 노출 확인은
  COMMIT(인간 승인) 후 webadmin 실화면(가격시뮬레이터)에서 수행 필요([HARD] 적재 전 실화면 확인).

## COMMIT 절차 (인간 승인 후, 이 세션 범위 밖)
1. `selreq-fix-dryrun.sql`의 마지막 `ROLLBACK` → `COMMIT`으로 교체한 사본으로 실행.
2. webadmin 가격시뮬레이터에서 17개 상품의 해당 opt_group 노출·택1 동작 실화면 확인(제외 0).
3. 문제 시 `selreq-undo.sql`(ROLLBACK→COMMIT 교체)로 원복.
