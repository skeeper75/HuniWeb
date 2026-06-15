# D. 비고(note) 실무진 친화 교정안 — note-remediation

> 사용자 직접 지적: "비고에 실무진이 이해할 수 있도록 넣어달라고 했더니 아직도 전문용어가 들어가 있다."
> 토대 §9-1 위반 판정: note = 전문가용 식별자·내부 코드 나열이면 위반. 실무진이 admin에서 알아보는 쉬운 한국어 라벨이어야 함.
> **비파괴 — 교정안 제안까지. 실 UPDATE는 인간 승인.**

## 1. 라이브 현재 note 실측 (2026-06-15)

### 1-1. t_prc_price_components.note (구성요소 정의행)

| comp_cd | comp_nm (양호) | 현재 note | 전문용어 위반 |
|---------|----------------|-----------|:--:|
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비(단면) | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01` | 🔴 내부 라운드명·코드값 노출 |
| COMP_COAT_GLOSSY | 유광코팅비 | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.02` | 🔴 |
| COMP_PP_CREASE_1L | 오시 1줄 | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04` | 🔴 |
| COMP_PP_VARTEXT_1EA | 가변텍스트 1개 | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.04` | 🔴 |
| COMP_PRINT_SPOT_CLEAR_S1 | 별색인쇄비 클리어(단면) | `round-2 파일럿 자동생성. comp_typ_cd=PRC_COMPONENT_TYPE.01` | 🔴 |
| COMP_PAPER | 용지비(종이별 절가) | `신규: 디지털인쇄 용지비. 차원=mat_cd(종이)×siz_cd(출력용지규격)... 손지율(+5장)·출력매수곱은 앱 런타임(C-4)` | 🟡 식별자(mat_cd·siz_cd)·내부 결정ID(C-4) 노출 |

**comp_nm은 모두 양호**(실무진이 알아보는 한국어). 문제는 **note**다.

### 1-2. t_prc_component_prices.note (단가행) — 전문용어 + 내부 마커

표본:
```
[siz-corrected: SIZ_PENDING_3JEOL→SIZ_000077] 디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수≥1 (별색=공정,clr=NULL)
오시/1줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)
```

| 위반 요소 | 예시 | 판정 |
|-----------|------|:--:|
| 내부 교정 마커 | `[siz-corrected: SIZ_PENDING_3JEOL→SIZ_000077]` | 🔴 시스템 코드·교정이력 노출 |
| 코드값/식별자 | `comp_typ=.04 후가공비`·`clr=NULL`·`별색=공정` | 🔴 내부 설계 메모 |
| 적재 메모 | `옵션=comp흡수` | 🔴 실무진 무관 |
| 양호 부분 | `디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수≥1`·`오시/1줄 제작수량≥1` | 🟢 유지 |

## 2. 교정안 (현재 → 교정) — 쉬운 한국어 라벨

### 2-1. 구성요소 정의행 note 교정

| comp_cd | 현재 note | **교정안 note** |
|---------|-----------|-----------------|
| COMP_PRINT_DIGITAL_S1 | round-2 파일럿 자동생성. comp_typ_cd=...01 | `디지털 인쇄비(단면). 출력매수와 사이즈·도수별 장당 단가표.` |
| COMP_COAT_GLOSSY | round-2 파일럿 자동생성. comp_typ_cd=...02 | `유광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 단가표.` |
| COMP_PP_CREASE_1L | round-2 파일럿 자동생성. comp_typ_cd=...04 | `오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).` |
| COMP_PP_PERF_1L | (동형) | `미싱(점선 절취) 1줄 가공비. 주문수량 구간별 고정 금액(곱하지 않음).` |
| COMP_PP_VARTEXT_1EA | round-2 파일럿 자동생성. comp_typ_cd=...04 | `가변 텍스트 1개 추가비. 주문수량 구간별 고정 금액(곱하지 않음).` |
| COMP_PRINT_SPOT_CLEAR_S1 | round-2 파일럿 자동생성. comp_typ_cd=...01 | `별색(클리어) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.` |
| COMP_PAPER | 차원=mat_cd...출력매수곱은 앱 런타임(C-4) | `용지비. 선택한 종이·출력규격(국4절/3절)별 절가. 실제 청구는 출력매수만큼 시스템이 자동 계산.` |

### 2-2. 단가행 note 교정 (내부 마커 제거·축 한국어 명시)

| 구분 | 현재 | **교정안** |
|------|------|-----------|
| 디지털인쇄 출력축 | `[siz-corrected: ...→SIZ_000077] 디지털인쇄 출력비(3절)/흑백(1도)/단면 출력매수≥1 (별색=공정,clr=NULL)` | `디지털 인쇄비 — 3절 / 흑백 / 단면 / 출력매수 1장 이상` |
| 후가공 주문축 | `오시/1줄 제작수량≥1 (합가, comp_typ=.04 후가공비, 옵션=comp흡수)` | `오시 1줄 — 주문수량 1장 이상 / 작업 1건 고정 금액` |
| 코팅 | `[siz-corrected: ...] 코팅(3절)/유광코팅/단면 출력매수≥1` | `유광 코팅비 — 3절 / 단면 / 출력매수 1장 이상` |

원칙:
1. `[siz-corrected ...]` 등 **내부 교정 마커 전부 제거**(교정 이력은 별도 감사 로그로, note에 남기지 않음).
2. `comp_typ=.04`·`clr=NULL`·`별색=공정`·`옵션=comp흡수` 등 **코드·설계 메모 제거**.
3. 축은 한국어로 — 출력축은 `출력매수`, 주문축은 `주문수량`으로 명시(둘이 다른 축임을 실무진이 알게).
4. 합가형(후가공)은 `작업 1건 고정 금액(수량을 곱하지 않음)`을 풀어 써서, 왜 금액이 큰지 실무진이 오해하지 않게.

## 3. 멱등 UPDATE 제안 SQL (예시 — 실 적용 인간 승인)

```sql
-- 구성요소 정의행 note 교정 (표본 — 전 13+종 동형 적용)
UPDATE t_prc_price_components SET note='오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now()
WHERE comp_cd='COMP_PP_CREASE_1L' AND note <> '오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';

-- 단가행 내부 마커 제거 (배치 정규식 치환은 스크립트로 — 예시 1건)
UPDATE t_prc_component_prices
SET note = regexp_replace(note, '^\[siz-corrected:[^\]]*\]\s*', ''), upd_dt=now()
WHERE comp_cd LIKE 'COMP_PRINT_%' AND note LIKE '[siz-corrected:%';
```

> **비파괴**: 위는 제안문. 실 COMMIT은 인간 승인. note는 가격 계산에 영향 없는 표시 필드라 단가행 값 무회귀(안전). 단, 배치 치환 전 DRY-RUN으로 영향 행수 집계 권장.

## 4. 라우팅

| 항목 | 트랙 | 심각도 |
|------|------|:--:|
| 구성요소 정의행 note 교정 | round-13 정정(표시 필드) | Medium(실무진 가시성·사용자 직접 지적) |
| 단가행 내부 마커 제거 | round-13 정정(배치 정규식·DRY-RUN 선행) | Medium |
| 후가공 note "곱하지 않음" 명시 | prc_typ .03 정정과 함께 배포 권장 | Medium |
