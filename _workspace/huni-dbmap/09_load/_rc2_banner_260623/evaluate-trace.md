# evaluate-trace.md — RC-2 일반현수막 옵션 가산 종단 재계산표

> 2026-06-23 · pricing.py 순수함수(`match_component`·`_row_matches`·`component_subtotal`) verbatim
> 격리(`_pricing_pure.py`·Django 비의존)에 라이브 단가행(설계후 충전) 입력. 재현=`evaluate_trace.py`.
> qty=1·단가형(PRICE_TYPE.01). 본체가는 별도(여기선 옵션 가산분만).

## 엔진 메커니즘 사실 (코드 실측)
- `_evaluate_formula`는 **addtn_yn을 읽지 않는다** — formula_components의 모든 comp를 매칭·합산.
  가산/비가산은 단가행이 selection과 **매칭되느냐**로만 결정. addtn_yn=메타데이터.
- `_row_matches`: 단가행 비수량차원(opt_cd/proc_cd)이 **NULL이면 와일드카드(항상 매칭)** → 빈 단가행=always-add.
  NULL 아니면 selection과 정확일치 필요. dim_vals(타공수)도 정확일치(와일드카드 없음).
- ∴ opt_cd/proc_cd 충전 = "미선택 시 selection에 그 값 없음 → 매칭 안 됨 → 가산 0".

## 재계산표

### 현재(결함) — 단가행 opt_cd/proc_cd 전부 NULL
| 케이스 | 입력 | 결과 | 판정 |
|---|---|---|---|
| ⓐ 옵션 미선택 | selection 없음 | **17000 always-add** + PUNCH_4 `duplicate_rows` ERR | 🔴 과대청구·ERR 결함 입증 |

### 설계후 — opt_cd/proc_cd/dim_vals 충전
| 케이스 | 입력 | 가산 | 단가 verbatim | ERR | 판정 |
|---|---|---|---|---|---|
| ⓐ 옵션 미선택 → 본체만 | {} | **0** | — | 0 | ✅ always-add 해소 |
| ⓑ 타공4 | proc_cd=PROC_000105·타공수=4 | **3000** | 3000 | 0 | ✅ |
| ⓑ 타공6 | 타공수=6 | **4000** | 4000 | 0 | ✅ |
| ⓑ 타공8 | 타공수=8 | **8000** | 8000 | 0 | ✅ |
| ⓒ 끈 | opt_cd=OPV_000014 | **4000** | 4000 | 0 | ✅ 자기단가만 |
| ⓒ 봉미싱 | opt_cd=OPV_000011 | **4000** | 4000 | 0 | ✅ |
| ⓒ 큐방 | opt_cd=OPV_000013 | **3000** | 3000 | 0 | ✅ |
| ⓒ 열재단 | opt_cd=OPV_000006 | **3000** | 3000 | 0 | ✅ |
| ⓒ 양면테입 | opt_cd=OPV_000010 | **3000** | 3000 | 0 | ✅ |
| ⓓ 타공4+끈 동시 | proc_cd+타공수=4 · opt_cd=OPV_000014 | **7000** (3000+4000) | verbatim | 0 | ✅ 정확 합산 |

**ERR_AMBIGUOUS/DUPLICATE: 전 설계후 케이스 0건.** **미선택 always-add 0.** **단가 verbatim 전부 일치.**

## 정직한 한계 (BLOCKED/코드 트랙)
1. **동일 opt_cd 경로 가공+추가 동시선택**(예 봉미싱+큐방): 한 selections에 `opt_cd` 단일키라 두 opt_cd
   동시 표현 불가 → 그룹별 selection 키 분리 필요(코드 트랙). 단 가공그룹=SEL_TYPE.01(택일)·타공은
   proc 경로(차원키 다름)라 **타공+추가 조합은 정확(ⓓ 7000 입증)**. opt 경로 가공(열재단/양면테입/봉미싱)
   +추가 동시는 코드 트랙 의존. → §21 데이터 트랙 범위 밖·**BLOCKED(코드)**.
2. **각목 LE/GT**: 둘 다 차원 NULL → 현재 always-add 12000 이중합산(재계산 입증). CONFIRM-4 미해결
   (CPQ 라벨 "세로/가로"≠권위 "900임계")로 **BLOCKED**·본 파일럿 제외.

## 결론
충전(opt_cd/proc_cd+dim_vals 판별차원)으로 ① 미선택 0가산 ② 선택별 정확 단가 ③ ERR 0 ④ 단가 verbatim
모두 충족. 타공+추가 동시 정확. 한계 2건(opt경로 동시·각목)은 정직 BLOCKED.
