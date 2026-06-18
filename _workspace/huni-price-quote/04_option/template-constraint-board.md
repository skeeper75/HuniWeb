# template-constraint-board.md — 템플릿(연결상품) · 제약조건(사이즈조건) 정합 보드 (요구 5)

> **Phase 2 — hpq-option-constraint-mapper (생성측)** · 2026-06-18 · `huni-price-quote`
> 권위 = 사용자 [HARD] 정의 + engine-contract(P1 템플릿단가·P8-3 추가상품) + authority-golden + [[dbmap-live-admin-product-viewer]](제약 폼빌더 var 7종).
> 라이브 읽기전용(2026-06-18). DB 미적재. 판정은 검증게이트 독립 재실측.

---

## 1. 템플릿 = "같이 파는 상품 연결" 정합

### 1.1 라이브 템플릿 전수 (13행)
| tmpl_cd | tmpl_nm | base_prd_cd | dflt_qty | use_yn | del_yn | selections |
|---------|---------|-------------|:--:|:--:|:--:|:--:|
| TMPL-000001~003 | 테스트 템플릿 | PRD_000002 | — | Y | **Y(삭제)** | 1~2 |
| TMPL-000004 | 봉투(700x200 50) | PRD_000001 | 50 | Y | **Y** | 2 |
| TMPL-000005 | OPP접착봉투 110x160 50장 | PRD_000001 | 50 | Y | N | 1 |
| TMPL-000006 | OPP비접착봉투 110x160 50장 | PRD_000002 | 50 | Y | N | 2 |
| TMPL-000007 | 카드봉투(화이트) 165x115 50장 | PRD_000281 | 50 | Y | **Y** | 0 |
| TMPL-000008 | 카드봉투(블랙) 165x115 50장 | PRD_000282 | 50 | Y | **Y** | 0 |
| TMPL-000009 | 트레싱지봉투 160x110 20장 | PRD_000283 | 20 | Y | N | 1 |
| TMPL-000010 | 카드봉투(화이트) 165x115 50장 | PRD_000281 | 50 | Y | N | 1 |
| TMPL-000011 | 카드봉투(블랙) 165x115 50장 | PRD_000282 | 50 | Y | N | 1 |
| TMPL-000012 | OPP비접착봉투 60x90 20장 | PRD_000002 | — | Y | N | 2 |
| TMPL-000013 | 테스트 템플릿 | PRD_000136 | — | Y | **Y** | 1 |

```sql
select tmpl_cd,tmpl_nm,base_prd_cd,dflt_qty,use_yn,del_yn from t_prd_templates order by tmpl_cd;
select tmpl_cd,count(*) from t_prd_template_selections group by tmpl_cd;
```

### 1.2 판정
- **base_prd_cd 바인딩**: 활성 템플릿(del_yn<>Y) 전부 실상품(PRD_000001/002/281/282/283/136) 가리킴 ✓. SKU(완제 사이즈+수량 고정)= 봉투류 — "같이 파는 상품" 성격(끼워팔기/완제 SKU) 정합.
- **★결함 ETP-1 [HIGH] — template_prices 전역 0행**: 엔진 우선순위 1(TEMPLATE_PRICE)이 **라이브 미발화**. engine-contract P1: tmpl_cd 타깃은 template_prices 없으면 base_prd_cd로 폴백(P1-1) → 상품 직접단가(0행)도 없어 → 공식(FORMULA)으로 평가. 즉 **템플릿단가 권위가 비어 있어 SKU 단가가 본품 공식으로 재계산됨**. 완제 SKU 고정단가(권위 1순위)가 적재되지 않은 상태.
```sql
select count(*) from t_prd_template_prices;  -- 0
```
  - 권위: authority-golden은 본 파일럿(엽서/현수막/아크릴)에 템플릿단가 골든 없음 → 템플릿단가 정합은 봉투류 권위(가격표) 대조 필요(파일럿 범위 외). **갭 기록**: SKU 단가 미적재 → P1 경로 전 상품 미사용.
- **★결함 ETP-2 [LOW] — 테스트/논리삭제 템플릿 잔존**: TMPL-000001~004·007·008·013 = `테스트 템플릿`·중복 카드봉투, del_yn=Y. selections 0인 TMPL-000007/008(삭제) 존재. price_views가 del_yn 제외하므로 런타임 무해, 위생 리스크. **코드 separator `TMPL-`(하이픈)** — `_` 정책 위반 잔재.
- **파일럿 3상품군 템플릿**: 엽서/현수막/아크릴 base_prd_cd 템플릿 = **0** (봉투류만 SKU 보유). 파일럿엔 연결상품 템플릿 없음 → 결함 아님(해당 상품군은 SKU 미정의).

### 1.3 추가상품(addons) — 끼워팔기 (P8-3)
- 전역 5행. 파일럿 3상품군 addons=0. addon은 tmpl_cd(다른 상품 SKU)를 가리켜 개별 evaluate_price 합산(engine P8-3). template_prices 0이므로 addon도 base 공식으로 평가됨(ETP-1 동일 영향).

---

## 2. 제약조건 = "사이즈 클릭 조건" 정합 (사용자 [HARD] 3유형)

### 2.1 사용자 정의 3유형 vs 라이브
| 사용자 유형 | 정의 | 라이브 표현 |
|------------|------|------------|
| ① 사이즈→**추가상품** | 특정 사이즈 클릭 시 나타나는 추가상품 | **부재(0건)** |
| ② 사이즈→**접지(fold)** | 특정 사이즈에서 해당되는 접지 | **부재(0건)** |
| ③ 사이즈→**박 min/max** | 특정 사이즈의 박 최소/최대 | **부재(0건)** |

### 2.2 라이브 제약 전수 (del_yn<>Y = 8행)
| prd_cd | rule_cd | rule_nm | rule_typ | logic 요지 |
|--------|---------|---------|----------|-----------|
| PRD_000001 | RULE_001 | **금지테스트** | .02 금지 | `!(siz_cd=SIZ_000078 AND bdl_qty=50)` — **테스트 데이터(junk)** |
| PRD_000001 | RULE_002 | **금지테스트** | .02 금지 | `!(siz_cd=SIZ_000078 OR bdl_qty=50)` — **junk**, err_msg `앵앵앵앵` |
| PRD_000118/120/121/122/124/125 | RULE_001 | 사용자입력 치수 범위 | .01 호환 | `size_mode≠nonspec OR (200≤width≤1200 AND 200≤height≤3000)` |
| PRD_000139 | RULE_001 | 사용자입력 치수 범위 | .01 호환 | `size_mode≠nonspec OR (500≤width≤900 AND 500≤height≤3000)` |

```sql
select prd_cd,rule_cd,rule_nm,rule_typ_cd,use_yn,del_yn,logic::text
from t_prd_product_constraints order by prd_cd,disp_seq;
-- RULE_TYPE: .01=호환 .02=금지 .03=필수동반
```

### 2.3 ★판정 — 사용자 3유형 전부 미표현
- **EOC-1 [HIGH] — 사이즈→추가상품/접지/박 제약 0건**: 라이브 제약 8건은 ① **nonspec 치수범위 검증**(width/height min/max — 7건) + ② **테스트 junk**(2건). 사용자가 정의한 "특정 사이즈 클릭 시 추가상품 노출 / 접지 적용 / 박 min·max"은 **하나도 표현되지 않음**.
  - **권위 정답**: 사용자 정의가 권위. 제약 그릇(t_prd_product_constraints, logic jsonb NOT NULL, RULE_TYPE 3종)은 실재하나 **세 유형의 데이터가 미적재**. RULE_TYPE.03(필수동반)으로 사이즈→추가상품을, 추가 var(접지/박)로 ②③을 표현해야 하나 부재.
  - **라우팅**: 미적재(생성 필요). 단, ②접지·③박 min/max는 **그릇 한계 의심** — §2.4.
- **EOC-2 [HIGH] — PRD_000001 금지테스트 = 라이브 junk 데이터**: `금지테스트`·err_msg `앵앵앵앵`은 명백한 개발 테스트 잔재. 실서비스 제약으로 오작동 가능(siz_cd=SIZ_000078 & bdl_qty=50 금지). **정리 대상**(use_yn=Y라 활성).
```sql
select prd_cd,rule_cd,err_msg from t_prd_product_constraints where rule_nm='금지테스트';
```

### 2.4 ★그릇 한계 — 연속수치 var 부재 (③ 박 min/max 표현력)
- [[dbmap-live-admin-product-viewer]]: 폼빌더 표준 var 7종 = `siz_cd·plt_siz_cd·mat_cd__usage_cd·proc_cd·bdl_qty·opt_id·sub_prd_cd` (전부 **코드값 2항**). **연속수치(width/height) var는 폼빌더에 없음.**
- 라이브 nonspec 치수범위 제약은 `size_mode`/`width`/`height` var를 쓰나 — 이는 **폼빌더 산출이 아니라 nonspec 입력검증용 런타임 주입 JSONLogic**(7 var 세트와 별개). 즉 폼빌더로는 못 만드는 logic이 직접 적재됨.
- **함의 (사용자 3유형 매핑 가능성)**:
  - ① 사이즈→추가상품: RULE_TYPE.03(필수동반) + sub_prd_cd/siz_cd 2항으로 **표현 가능**(그릇 충분).
  - ② 사이즈→접지: "접지" var/차원이 폼빌더 7종에 없음 → 접지를 옵션(.04 공정)으로 두고 siz_cd↔proc_cd 호환제약(.01)으로 **부분 표현 가능**. 접지 전용 차원은 부재.
  - ③ 사이즈→박 **min/max**: **그릇 부재** — 박 수량 min/max는 연속수치 범위인데 폼빌더는 코드값 2항만. nonspec width/height처럼 런타임 주입 logic이 필요(폼빌더 밖). [[dbmap-compute-in-app-db-stores-lookup]]: 박 면적→등급은 앱 계산 철학 → 박 min/max도 제약 logic이 아니라 앱/공식 계산일 수 있음. **CONFIRM-EOC3**: 박 min/max를 제약(constraint)으로 둘지 가격공식/앱계산으로 둘지 사용자 도메인 확인 필요.
- **라우팅(rpmeta)**: ② 접지 전용 차원·③ 박 min/max 수치제약 var = **그릇 부재 가능성 → rpmeta vessel-gap 후보**(폼빌더 var 확장 또는 제약유형 신설). ①은 데이터 미적재.

### 2.5 파일럿 상품군 제약 현황
- 엽서 PRD_000017·현수막 PRD_000138·아크릴 PRD_000146 = **제약 0건**.
  - 현수막류 PRD_000139(일반현수막 변종?)에 nonspec 치수범위 제약 존재(500~900 × 500~3000) — 파일럿 PRD_000138 본체엔 없음. **불일치 CONFIRM-EOC4**: 같은 현수막인데 138엔 치수범위 제약 없고 139엔 있음(어느 게 권위인지 라이브 화면 확인).

---

## 3. 결함 요약 (검증게이트 인계)

| ID | 대상 | 결함 | 심각도 | 분류 | 라우팅 |
|----|------|------|:--:|------|--------|
| ETP-1 | 전역 | template_prices 0행 — SKU 1순위 단가 미적재, 본품 공식으로 재계산 | HIGH | 미적재 | dbmap 가격적재 |
| ETP-2 | 전역 | 테스트/논리삭제 템플릿 잔존(TMPL- 하이픈) | LOW | 위생 | 정리 |
| EOC-1 | 전역 | 사용자 3유형(사이즈→추가상품/접지/박 min·max) 0건 표현 | HIGH | 미적재+그릇 | §2.4 분기 |
| EOC-2 | PRD_000001 | 금지테스트 junk 제약 활성(use_yn=Y) | HIGH | 라이브 정리 | 삭제 큐 |
| CONFIRM-EOC3 | — | 박 min/max = 제약 logic vs 앱/공식 계산? 그릇 부재 판정 | — | 도메인확인 | rpmeta/사용자 |
| CONFIRM-EOC4 | 현수막 | PRD_000138 vs 139 치수범위 제약 비대칭 | — | 확인 | 라이브 화면 |

> **제약 한 줄**: 사용자 정의 3유형(사이즈→추가상품/접지/박 min·max)은 라이브에 **0건**. 라이브 제약 8건은 nonspec 치수범위 검증(7) + junk 테스트(2)뿐. ①은 그릇 충분·미적재, ②③은 폼빌더 연속수치 var 부재로 **그릇 한계 의심**(rpmeta 라우팅).
> **템플릿 한 줄**: base_prd_cd 바인딩은 건전하나 **template_prices 0행**으로 SKU 1순위 단가가 비어 본품 공식으로 평가됨.
