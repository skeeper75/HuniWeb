# round-17 가격공식 정리 검증 게이트 — F1~F5 (dbm-validator 독립 검증)

> 작성 2026-06-13 · **생성자(auditor)≠검증자**. auditor 산출(`21_price-formula-audit/`)을 의심하고 라이브 `t_prc_*` information_schema·webadmin 소스·round-16 산출을 **직접 떠서** 대조.
> 라이브 = `db railway` 읽기전용 SELECT만(비밀번호 비노출). DB 직접 쓰기 0.
> 권위 순서: ① 라이브 information_schema 실측 ② webadmin `price_views.py`·`sql/01a_tables_master.sql` 소스 ③ round-16 산출.

---

## 종합 평결: **GO** (F1~F5 전건 PASS)

auditor의 핵심 5주장(frm_typ_cd 라이브 부재 결판 / 16 카운트 / 가독성 16/16 🟡 / 212·275 커버리지 / 고아 1)을 **전건 라이브·소스 독립 재현으로 CONFIRMED**. 날조·과장·누락 0. 화면 leg BLOCKED(bun 미설치)는 정직하게 분리·소스+DB 2축으로 대체 판정. 개선안은 비파괴(DB 쓰기 0건·전건 인간 승인).

---

## F1~F5 결과표

| 게이트 | 판정 | 핵심 근거(직접 실측·grep) |
|--------|:----:|---------------------------|
| **F1 스키마 결판 재현 🔴** | **PASS** | 라이브 `information_schema` 실측 컬럼 6개 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` → **frm_typ_cd 부재 CONFIRMED**. `price_views.py` 전수 `grep frm_typ_cd` = **0건**. **메인 지시의 'price_views.py:234 frm_typ_cd 사용' 주장은 틀림** — 234행은 `grade_rates`(`dsc_rate·dsc_amt`)이지 frm_typ가 아님(재현 확인). auditor가 이를 적발한 것이 정확. |
| **F2 인벤토리 무손실** | **PASS** | 라이브 `count(*)=16`. formula-table.csv 16행과 1:1. use_yn=N 1건(PRF_DGP_F)도 라이브 일치. frm_cd·frm_nm·use_yn 16행 전건 byte 대조 일치. 날조 0. |
| **F3 4축 판정 일관** | **PASS** | note 실측: "행N"(행+숫자) **15건**·영문약어(comp/mat/component) **5건**·빈 note **0** → auditor "15/16·5/16" 정확. 16/16 🟡 = 모든 공식이 note 내부참조 보유라 동일등급 일관. PRF_TTEOKME만 B🟡+C/D🔴(고아 추가)도 일관. 과장/누락 0. |
| **F4 배선/뷰어 실측 🔴** | **PASS** | 배선/연결상품 16행 전건 일치(DGP_A 29/9·POSTER 1/28 등). **고아 1 = PRF_TTEOKME_FIXED(연결상품 0) CONFIRMED**. 커버리지 **63 FORMULA / 0 DIRECT / 212 NONE / 275 = CONFIRMED**. **EMPTY 배선 0**(16공식 사슬단절 0). use_dims NULL comp 2건(포스터 add-on)·배선 0(고아 구성요소) CONFIRMED. 뷰어 미노출 경로 `price_views.py:80 has_frm→:86 NONE` 소스 결정적. |
| **F5 개선안 비파괴** | **PASS** | `improvement-proposal.md`에 "전건 인간 승인·DB 직접 UPDATE/INSERT/DDL 0건 실행" 명시(키워드 8회). note 개선안 16건 = 쉬운 한국어(영문약어·행번호 제거). frm_typ_cd 백필은 DDL 트랙(dbm-ddl-proposer)으로 분리. |

---

## 라이브 실측 직접 인용 (재현 증거)

```
-- F1: information_schema.columns WHERE table_name='t_prc_price_formulas'
frm_cd|character varying|NO    frm_nm|character varying|NO    note|character varying|YES
use_yn|character|NO    reg_dt|timestamp|NO    upd_dt|timestamp|YES        → frm_typ_cd 없음

-- F1: grep frm_typ_cd raw/webadmin/webadmin/catalog/price_views.py  → [0건]
--     price_views.py:234 = grade_rates: dsc_rate/dsc_amt (frm_typ 아님)  ← 메인 주장 반증
-- F1: sql/01a_tables_master.sql:187 = frm_typ_cd varchar(50) NOT NULL  (선언됨·미적용)
--     seed 05_seed.sql:294 FRM_TYPE.01 합산형 / :298 .02 단순형          (선언≠적용 패턴)

-- F2: count(*) = 16 ;  use_yn=N → PRF_DGP_F 1건

-- F4: 가격원천 커버리지 = 63 FORMULA | 0 DIRECT | 212 NONE | 275 total
-- F4: 고아 공식(연결상품 0) = PRF_TTEOKME_FIXED
-- F4: EMPTY 배선(배선됐으나 단가행 0) = 0   ← 16공식 내부 사슬단절 0
-- F4: use_dims IS NULL = COMP_POPT_BNR_GAKMOK_STR_900_4, COMP_POSTEROPT_BANNER_MESH_PROC_OPT (둘 다 배선 0)
-- 행수: formula_components 85 | product_price_formulas 63 | price_components 144 | component_prices 3481 | product_prices 0
```

---

## auditor 주장 검증 결과표 (뒤집힘/보정)

| auditor 주장 | 검증 방법 | 결과 |
|--------------|-----------|:----:|
| frm_typ_cd 라이브 부재 (메인 'price_views.py:234 사용'이 틀림) | information_schema + grep 재현 | **CONFIRMED**(auditor가 메인 오류 적발한 것이 정확) |
| 공식 총 16(합산형 8·단순형 8) | 라이브 count(*)·use_yn | **CONFIRMED** |
| 가독성 16/16 🟡 (행N 15·영문약어 5) | note 전수 실측 | **CONFIRMED**(15·5 정확) |
| 212/275 가격원천 0 | LEFT JOIN 커버리지 | **CONFIRMED**(63/0/212/275) |
| 고아 공식 1(PRF_TTEOKME_FIXED) | NOT EXISTS 바인딩 | **CONFIRMED** |
| 16공식 사슬단절 0(EMPTY 배선 0) | formula_components↔component_prices | **CONFIRMED** |
| 포스터 add-on 2 comp 미배선 | use_dims NULL + 배선 0 | **CONFIRMED** |
| 화면 leg BLOCKED(bun 미설치) | `which bun` = not found | **정직**(소스+DB 2축 대체 판정 정당) |

**뒤집힌 항목: 0건. 보정 항목: 0건.** 단, 경로 표기 미세 오차 1건(MINOR, 아래).

---

## 발견(MINOR — 평결 불변)

- **M-1 (MINOR) 소스 경로 표기 한 단계 오차**: auditor가 DDL을 `raw/webadmin/webadmin/sql/01a_tables_master.sql:187`로 인용했으나 실제 경로는 `raw/webadmin/sql/01a_tables_master.sql:187`(`webadmin/` 한 번). 내용(frm_typ_cd NOT NULL 선언·187행·seed .01/.02)은 정확. 재현엔 지장 없으나 인용 경로 정정 권고. price_views.py 경로(`raw/webadmin/webadmin/catalog/`)는 정확.
- **관찰**: F4 BLOCKED는 픽셀 렌더(배지 색·레이아웃)만 미확인. 가독성(B)·노출경로(D) 판정은 note=DB권위·`has_frm`=소스로직이라 화면 없이 결정적 — BLOCKED가 평결을 흔들지 않음.

---

## 결론

round-17 가격공식 정리 산출(인벤토리·정리표·결함보드·개선안)은 **GO**. auditor가 메인 지시의 frm_typ_cd 오주장을 라이브로 반증한 점, 16/15/5/212/고아1 카운트가 전건 라이브 재현 일치한 점, 개선안이 비파괴인 점을 독립 확인. 실 적용(note UPDATE·떡메 바인딩·frm_typ_cd 백필 DDL)은 전건 인간 승인 대상으로 정당 분리. 화면 픽셀 재확인은 bun 설치 후 다음 세션.
