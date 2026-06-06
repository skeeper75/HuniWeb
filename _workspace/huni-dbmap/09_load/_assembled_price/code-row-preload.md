# 코드행 선적재 제안 — round-4 가격 (단계 00)

> FK-target 코드값이 라이브에 부재하여, 하위 가격 적재행이 의존한다. **DDL 변경이 아니라 `t_cod_base_codes` 코드행 INSERT 1건을 제안**한다(스키마 무변경). 실제 INSERT는 **후니 등록(인간 승인)** 대상 — 본 하네스는 제안까지.

작성: dbm-load-builder · 권위: 라이브 `t_cod_base_codes` PRC_COMPONENT_TYPE 형제 코드 + `02_mapping/load_price/t_cod_base_codes.csv` + 가격엔진 DDL.

---

## 제안 1: `PRC_COMPONENT_TYPE.06 완제품비`

### 산출 파일
`load/00_prc_component_type.csv` (단계 00, FK 위상 최상위)

### 적재 행 (DB 컬럼명 그대로)

| cod_cd | cod_nm | upr_cod_cd | disp_seq | use_yn |
|--------|--------|------------|----------|--------|
| `PRC_COMPONENT_TYPE.06` | 완제품비 | `PRC_COMPONENT_TYPE` | 6 | Y |

note: "D-D 확정 신설(규칙⑩·AWK-7 해소). 완제품 통가격(비분해) 가격구성요소 유형. FK 부모 선행(t_prc_price_components보다 선적재). PRD_TYPE.01 완제품(상품분류)과 별개 축. 봉투제작 COMP_ENV_MAKING이 사용"

### 라이브 부재 확증 (read-only SELECT)

```
SELECT count(*) FROM t_cod_base_codes WHERE cod_cd='PRC_COMPONENT_TYPE.06';  -- → 0
```

라이브 형제 코드(부재 아님, 확증):

| cod_cd | cod_nm | upr_cod_cd | disp_seq | use_yn |
|--------|--------|------------|----------|--------|
| PRC_COMPONENT_TYPE.01 | 인쇄비 | PRC_COMPONENT_TYPE | 1 | Y |
| PRC_COMPONENT_TYPE.02 | 코팅비 | PRC_COMPONENT_TYPE | 2 | Y |
| PRC_COMPONENT_TYPE.03 | 용지비 | PRC_COMPONENT_TYPE | 3 | Y |
| PRC_COMPONENT_TYPE.04 | 후가공비 | PRC_COMPONENT_TYPE | 4 | Y |
| PRC_COMPONENT_TYPE.05 | 박형압비 | PRC_COMPONENT_TYPE | 5 | Y |

→ 라이브는 **.01~.05까지만**. `.06`은 다음 일련번호로, **형제 명명 규칙을 그대로 따른다**(접미 `.NN` 2자리·upr_cod_cd 동일·disp_seq 연속·use_yn=Y). 명명 발명 0(기존 스킴 답습).

### 이 코드행에 의존하는 적재행 (rationale)

- `t_prc_price_components` 중 **comp_typ_cd='PRC_COMPONENT_TYPE.06'인 91행**(완제품 통가격 구성요소: 봉투제작·완칼·스티커·명함·엽서북·떡메·포토카드·포스터완제품가 등)이 이 코드행을 FK 부모로 한다.
- 단계 00에 코드행이 없으면 단계 02(price_components)의 91행이 `fk_prc_price_components_comp_typ_cd` 위반으로 INSERT 실패 → 연쇄로 단계 04(component_prices)도 차단.
- 따라서 **반드시 단계 00(최선행)** 에 위치.

### 왜 라이브에 부재한가 (설계 정당성)

라이브 가격엔진은 분해형 원가(.01 인쇄/.02 코팅/.03 용지/.04 후가공/.05 박형압)만 코드화했고, **완제품 통가격(비분해)** 유형은 미정의 상태였다. round-2가 "실무진 셀텍스트=가격의미"(포함가 "출력+코팅+가공", 세트단가 등)를 분해하지 않고 통가격으로 보존하기로 확정(규칙④⑩)하면서 `.06 완제품비`가 필요해졌다. 이는 매핑 결함이 아니라 **신규 가격 유형의 정당한 코드 확장**이며, DDL(스키마) 변경 없이 코드마스터 1행 추가로 충족된다.

---

## 에스컬레이션

- **결정 주체**: 후니(코드마스터 등록 권한).
- **해소 조건**: 후니가 `t_cod_base_codes`에 위 1행을 등록(INSERT)하면 → 단계 02의 91행 + 그에 묶인 단계 04 단가행이 FK 충족.
- **하네스 권한 밖**: 본 트랙은 코드행 INSERT를 **실행하지 않는다**(제안·CSV 산출까지). validator의 DRY-RUN은 이 코드행을 동일 트랜잭션 선행 INSERT로 가정하고 롤백 검증한다.
