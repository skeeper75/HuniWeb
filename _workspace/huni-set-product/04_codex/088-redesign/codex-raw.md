# codex 독립 2차 교차검증 원문 — 088 레더 링바인더 재설계

- 실행 2026-07-02 · `hqv-codex-cross-verify/scripts/codex-review.sh` · model=gpt-5.5 · effort=high · sandbox=read-only
- workdir=`_workspace/huni-set-product` · 프롬프트=`_codex-prompt-088.md`(Claude 판정 비노출·설계+권위 데이터만 제공)
- 가용성: preflight=AVAILABLE(gpt-5.5) · codex exec 정상 종료(rc=0·tokens 29,415)

---

## codex 원문 (verbatim)

아래 판정은 제공 데이터만 기준으로 한 독립 재계산입니다.

**Q1. 골든 재계산: GO**

밴드 lookup은 `min_qty <= copies` 중 최대 밴드로 해석해야 사용자 기대와 일치합니다.

| copies | member 089 표지 | 부모 싸바리 제본 | final_price | 기대값 |
|---:|---:|---:|---:|---:|
| 1 | 9,000 × 1 = 9,000 | 30,000 × 1 = 30,000 | 39,000 | 39,000 |
| 10 | 9,000 × 10 = 90,000 | 20,000 × 10 = 200,000 | 290,000 | 290,000 |
| 100 | 9,000 × 100 = 900,000 | 9,000 × 100 = 900,000 | 1,800,000 | 1,800,000 |

10부는 `min_qty=10` 밴드 20,000원/부, 100부는 `min_qty=100` 밴드 9,000원/부가 맞습니다.

**Q2. 오구성: GO**

제공된 권위상 088은 셋트 완제품이고, 구성원 5개는 모두 `.02` 반제품입니다. 표지 1 + 면지 4 + 내지 없음 구조가 "빈 바인더" 설명과 정합합니다. 완제품을 구성원으로 넣은 흔적도, 권위상 필요한 내지를 누락한 결함도 없습니다.

**Q3. 가격 결함: GO**

(a) 이중합산 없음. 표지 9,000은 member 089 공식에서만 계산되고, 부모 공식은 `COMP_BIND_SSABARI` 제본비만 계산하는 구조입니다.

(b) `COMP_HC_MUSEON_COVERBIND` 배선 제거는 정당합니다. 기존 blended 표지+제본 comp를 유지하면 표지/제본 분리 모델과 충돌합니다. component 자체는 삭제하지 않으므로 타상품 보존 원칙도 맞습니다. 단, 제공 데이터상 부모 공식의 다른 잔여 component는 확인할 수 없으므로 적용 후 formula component 목록 검증은 필요합니다.

(c) 싸바리 6밴드는 권위 데이터와 일치합니다.

(d) `10부=20,000/부` 해석이 맞습니다. 밴드 경계는 `4 <= q < 10`, `10 <= q < 50`, `50 <= q < 100`, `100 <= q < 1000` 식의 하한 매칭으로 보는 것이 제공 골든과 정합합니다.

(e) 표지 flat 단일밴드는 결함이 아닙니다. `min_qty=1` 단일 행이면 모든 수량에서 9,000원/부가 적용되어 100부는 900,000원이 됩니다. 제공 권위도 단일 9,000원 행입니다.

**Q4. SQL 안전: CONDITIONAL GO**

구조상 멱등성은 대체로 타당합니다.

- `component/formula/formula_components/product_formula/product_processes`는 `ON CONFLICT ... DO UPDATE`라 재실행 가능.
- 단가행은 `(comp_cd, apply_ymd, min_qty)` `NOT EXISTS` 가드라 중복 방지 가능.
- 기존 부모 배선 삭제는 무조건 `DELETE`라 멱등.
- undo 순서는 대체로 역순이며, 복원 대상도 명확합니다.

조건부 리스크는 2개입니다.

1. 단가행 `comp_price_id=MAX+1`은 동시 실행 환경에서는 충돌 위험이 있습니다. 단독 maintenance SQL이면 허용 가능하지만, 병렬 실행 가능성이 있으면 sequence/locking 확인이 필요합니다.
2. undo에서 표지 component 삭제 전에 해당 component를 참조하는 행이 모두 제거되어야 합니다. 제공된 8행 범위에서는 대칭이 맞지만, apply 후 다른 참조가 생기면 undo가 FK에 막힐 수 있습니다.

**Q5. False-positive 지점**

결함으로 오판하기 쉬우나 정당한 지점은 다음입니다.

- 면지 4행이 모두 들어간 것: 빈 바인더의 면지 색상 구성원이며, 가격 기여 0으로 유지되는 구조가 제공 설명과 맞습니다.
- 표지 component의 flat 단일밴드: 수량할인이 누락된 게 아니라 권위 단가가 단일 9,000원입니다.
- 부모 088에 `PROC_000098`만 추가하는 proc 격리: `COMP_BIND_SSABARI`의 `proc_cd` 매칭을 위한 정당한 연결입니다.
- `COMP_HC_MUSEON_COVERBIND` 배선 제거: 기존 blended 가격을 분리 모델로 대체하기 위한 필수 조치입니다.
- `COMP_BIND_SSABARI`가 apply 전 고아인 점: 고아 자체가 결함이 아니라, 이번에 부모 공식에 연결되면서 사용됩니다.

**종합 판정: 설계 지지, 적용 전 사후검증 조건부**

가격 모델과 도메인 구성은 GO입니다. 골든 3건이 정확히 일치하고, 표지 소재+인쇄비와 싸바리 제본비의 역할 분리도 타당합니다.

우선순위 리스크는 다음입니다.

1. High: apply 후 `PRF_LEATHER_RINGBINDER_SET`에 `COMP_BIND_SSABARI` 외 잔여 가격 component가 없는지 확인 필요.
2. Medium: `comp_price_id=MAX+1` 동시성 리스크. 단독 실행이면 실질 위험 낮음.
3. Low: undo는 현재 8행 범위에서는 대칭이나, apply 이후 추가 참조가 생기면 component 삭제가 막힐 수 있음.
