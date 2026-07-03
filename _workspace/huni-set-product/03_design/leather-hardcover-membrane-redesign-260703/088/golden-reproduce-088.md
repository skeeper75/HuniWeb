# 088 면지 통합 — 골든 재현 (라이브 실엔진 · 무손상 실증)

> §23 · 2026-07-03 · 실측 = `_golden-088-current.py`(real pricing.py helpers: match_component + component_subtotal).
> 라이브 읽기전용. 088-redesign 미적재(COVERBIND 현행) 확정 하 재현.

## 1. 현행 라이브 골든 (COVERBIND 모델 · 면지 통합 前)

실엔진 실행 결과(`_golden-088-current.py`):

```
# COVERBIND live rows = 6
# discount tables on 088 = 0
copies  parent_coverbind  members(089-093)  base_total  final
1       34100.0           0                 34100.0     34100.0   [tier_min_qty=1 unit=34100.0]  OK
10      159100.0          0                 159100.0    159100.0  [tier_min_qty=10 unit=15910.0] OK
100     796900.0          0                 796900.0    796900.0  [tier_min_qty=100 unit=7969.0] OK
CURRENT-GOLDEN (COVERBIND, pre-redesign): ALL MATCH
```

- 부모공식 `PRF_LEATHER_RINGBINDER_SET → COMP_HC_MUSEON_COVERBIND` (prc_typ .01·use_dims=["min_qty"]) = 밴드단가 × 부수.
- 멤버 089~093 = 가격공식 0건 → **기여 0**(전 케이스).
- 088 할인테이블 0건 → final = base_total.

## 2. 면지 통합 後 골든 = 동일 (무손상)

면지 통합(apply-088.sql)은 다음만 변경 — **가격 입력 어느 것도 미터치**:
- 090 rename · 090 자재/옵션 이관 · 088 OPT_067/USAGE.03 은퇴 · 091~093 은퇴.

| copies | 통합 前 (5멤버) | 통합 後 (표지089+면지090) | 판정 |
|---|---|---|---|
| 1 | 34,100 | 34,100 | 불변 |
| 10 | 159,100 | 159,100 | 불변 |
| 100 | 796,900 | 796,900 | 불변 |

**근거(삼각확인)**:
1. 부모공식 COVERBIND 밴드 = **미터치** → 부모 기여 불변.
2. 은퇴되는 면지 멤버 091/092/093 = 공식 0건 → 애초 기여 0 → 은퇴해도 base_total 불변.
3. 통합 멤버 090 = 자재/옵션 부여받아도 **공식 0건 유지** → 기여 0(자재는 색 택1 UI 수단일 뿐 가격축 아님).
4. 부모공식 use_dims=["min_qty"] = 자재 미종속 → 부모 USAGE.03 자재 은퇴 무영향.

## 3. 088-redesign COMMIT 후 골든 (참고 · 본 건 미터치)

088-redesign(9,000 표지+싸바리)이 나중에 COMMIT되면 골든이 **39,000/290,000/1,800,000**으로 바뀐다(재설계 트랙 소관). 이는 부모 배선(COVERBIND→SSABARI)+member 089 공식 mint 때문이며 **면지 통합과 무관**. 면지 통합은 그 새 모델 위에서도 면지 기여 0 유지 → 재설계 골든 그대로 보존.

## 4. 보존 확인 (D링·표지·SSABARI)
- USAGE.07 D링 자재(MAT_247/248/249): apply-088 미터치 → DRY-RUN 실측 3종 잔존(가격 보존).
- 표지 089·부모 배선·9,000 mint: apply-088 미터치 → 088-redesign 소관 그대로.
