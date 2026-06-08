# D-WIRE 포스터/실사 가격공식 상품별 재모델 — 적재 실행본

생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 · **생성 단계**(검증·실 적재는 별도, 인간 승인)

## 한 줄 요약
포스터/실사 **28상품**이 1 공유공식 `PRF_POSTER_FIXED`(28바인딩/**1배선**)에 묶여 27상품 가격조회 사슬이 **단절(D-WIRE)**. 근본원인 = 라이브에 상품→comp 직결 경로 부재 → 공유공식은 상품별 comp 분기 불가. 해소 = **상품별 단순형 공식 `PRF_POSTER_<X>` 28개** 신설 + 자기 comp 배선(30) + 재바인딩(28). `PRF_POSTER_FIXED` 는 0상품 도달 후 은퇴(use_yn='N'). **라이브 쓰기 0건**(멱등 SQL + DRY-RUN 계획만).

## D-WIRE 문제 (라이브 실측 2026-06-07)
- 가격사슬: 상품 → `t_prd_product_price_formulas`(prd→frm) → `t_prc_formula_components`(frm→comp[]) → `t_prc_component_prices`(comp,siz…→단가).
- `PRF_POSTER_FIXED` = **28 bound / 1 wired**(ARTPRINT만). 27상품 자기 comp 미배선 → 사슬 단절.
- 상품→comp 직결 테이블 **부재**(실증) → 공유공식에 28 comp 를 다 배선해도(합산이면 오가격, 택일이면 라우팅 불가) 해결 안 됨. **유일 해법 = 상품별 공식 1:1**.

## 파일
| 파일 | 용도 |
|------|------|
| `audit.md` | 전수 배선 감사(16공식) — broken 4공식 식별·공유정당성 판정·근본원인·live-vs-doc 모순 |
| `mapping.md` | 28상품↔comp 매핑·재모델 설계(공식28/배선30/재바인딩28)·PRF_POSTER_FIXED 은퇴·Slice A/C3 결합·설계결정 |
| `load.sql` | 멱등 단일 tx (공식·배선·재바인딩·은퇴 + 단계0 FK검증 + 말미 사슬무결성 assert). BEGIN/COMMIT 미포함(apply.sh 주입) |
| `dryrun-plan.md` | FK 적재순서 + DRY-RUN 게이트(R1~R6) + 설계자 사전점검(read-only 증거). **실행 안 함** |
| `load/t_prc_price_formulas.csv` | 신규 공식 28 |
| `load/t_prc_formula_components.csv` | 신규 배선 30 |
| `load/t_prd_product_price_formulas_INSERT.csv` | 재바인딩 추가 28 |
| `load/t_prd_product_price_formulas_DELETE.csv` | 재바인딩 제거 키 28 |

## 적재 상태
- **INSERTABLE**: 공식 28 + 배선 30 + 재바인딩(DELETE 28 + INSERT 28) + 은퇴 UPDATE 1. **BLOCKED 0**(28상품 전부 comp 선존재·FK 충족).
- component_prices(단가 본체) **미적재** — 본 트랙 범위 밖(Slice A 670 + C3 73).

## 다른 broken 사슬 (audit.md §2·§3 — 본 번들 밖, 후속 트랙)
| frm_cd | bound/wired | broken | 처방 |
|---|---|--:|---|
| `PRF_BIND_SUM` | 4/1 | 3 | 무선/PUR/트윈링 상품별 공식 분리(FRM_TYPE.01 합산형) |
| `PRF_NAMECARD_FIXED` | 3/2 | 2 | 프리미엄/코팅 상품별 공식 분리 |
| `PRF_PHOTOCARD_FIXED` | 2/2 | 2 | 공유공식이라 라우팅 불가 — 포토카드/투명 분리 |
> 정당공유(rebind 불요): `PRF_STK_FIXED`(3상품 단일 매트릭스 공유), `PRF_DGP_A~F`(원자합산형 레시피 공유).

## 적용 순서 (Slice A / C3)
```
[1] 본 트랙: PRF_POSTER_<X> 28공식 INSERT
[2] 본 트랙: formula_components 30 배선 INSERT  (←[1])
[3] 본 트랙: 재바인딩 DELETE 28 + INSERT 28      (←[1])  ⇒ 사슬 '구조' 복구
[4] Slice C3: component_prices 73 INSERT  (직교)
[5] (인간승인) siz 108 등록 → Slice A: component_prices 670 INSERT  ⇒ 단가 본체 충전
```
본 트랙(구조) ↔ Slice A/C3(단가)는 직교하나 **셋 다 적용돼야** 모든 치수 가격조회 가능. 본 트랙 단독은 사슬만 연결(단가 sparse).

## 다음 단계
1. dbm-validator 독립 재검증 (감사 수치 live 재확인 + R1~R6 + 사슬 무결성).
2. (인간 승인) load.sql DRY-RUN 2-pass 멱등 실증 → COMMIT.
3. Slice C3 / Slice A 단가 적재(siz 108 승인 의존).
4. 후속 트랙: BIND/NAMECARD/PHOTOCARD 동일 재모델 상신.

## 설계결정 — 인간 확인 필요
- **D-RETIRE**: PRF_POSTER_FIXED(0상품) = use_yn='N' 비활성 권고(DELETE 는 ARTPRINT 배선 FK RESTRICT·별건 승인).
- **D-WIRE-VARIANT**: 폼보드/포맥스 2-comp = 단일공식 2배선 택일(addtn_yn='N').
- **D-OTHER3**: BIND/NAMECARD/PHOTOCARD broken 3건 별도 트랙(`price211-sticker-namecard` 의 공유공식+택일 설계는 폐기·상품별 분리로 통일).
