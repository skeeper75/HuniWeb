# codex 독립 2차 판정 — 072 하드커버책자 면지 통합 재설계

> §23 · 2026-07-03 · codex gpt-5.5 (reasoning=high) · 읽기전용 샌드박스 · workdir=repo root
> 헬퍼 `hqv-codex-cross-verify/scripts/codex-review.sh` · 프롬프트 `_codex-prompt.md`
> ★codex 판정 = **가설**(라이브 DB 재실측 안 함·코드/파일 근거만). 라이브 판정은 `reconcile.md`.

## codex 종합
- **DISAGREE 0** — 재설계 방향에 반대 없음. 판정: 1·2·4 AGREE / 3·5 UNCERTAIN.
- "S1~S8 게이트로 넘겨 검증하는 것은 가능하나, 이 상태로 COMMIT 승인까지 가면 안 된다" → 게이트 보강 Top 3 제시.

## 항목별 codex 판정 (근거는 codex가 인용한 파일:라인)

| # | 항목 | codex | codex 근거 요지 |
|---|---|---|---|
| 1 | 골든 무손상 안일함 | **AGREE**(일부 안일) | `evaluate_set_price`가 멤버별 `evaluate_price` 합산(pricing.py:914-919). `evaluate_price`는 공식 **전에 직접단가 TPrdProductPrices를 먼저**(pricing.py:468-474) → "공식 없음"만으론 기여 0 미보장·"직접단가도 없음"까지 확인 필요. 둘 다 없으면 0 처리 로직은 맞음(pricing.py:490-496). |
| 2 | 트리거 순서 안전 | **AGREE** | apply=074 자재[18-25]→옵션아이템[49-57]→부모옵션은퇴[60-74]→부모자재은퇴. 트리거는 option_items INSERT/UPDATE에 부착. undo=부모자재복원→부모items복원→074items삭제→074자재삭제 순서 맞음. |
| 3 | 075/076 은퇴 무결성 | **UNCERTAIN** | 복합PK(prd_cd,sub_prd_cd)·FK는 논리삭제라 안 깨짐. 그러나 "셋트전용이라 use_yn=N 안전"이 **전역 역참조 쿼리로 미입증**(설계 첨부 안). |
| 4 | 색 택1 자재 드롭다운·오차단 | **AGREE** | `_set_members_meta`는 멤버 `materials` 동봉·`opt_groups` 미동봉(price_views.py:1740-1753). 렌더러가 멤버 카드에 "용지" select+기본자재 선택(price_simulator.html:686-710)·제출 시 mat_cd 전송(741-758→price_views.py:1929-1934). **이관 옵션그룹은 시뮬레이터 휴면**. 위젯/주문 경로가 같은 materials 메타 쓰는지는 이 파일들만으론 미검증. |
| 5 | 계열 전파 주의 | **UNCERTAIN** | 082/088 USAGE.07 불가침·088 내지없음·적재대기 조율 명시는 맞음(spec:113-127). 그러나 082/088 MAT_385 인쇄면지 "무공식→인쇄비0" 선존이슈 잔존·per-set 직접단가/공식/역참조/실UI 재측정 증거 미첨부. |

## codex 게이트 보강 Top 3 (원문)
1. 074/075/076 및 계열 면지 멤버의 `t_prd_product_prices`·`t_prd_product_price_formulas` **활성 행 0건 확인** — "공식 없음"만으론 부족.
2. 075/076 use_yn=N 전 `t_prd_product_sets`·templates·option_items·constraints 등 **전역 역참조 0건/영향 없음** 증명.
3. 실제 시뮬레이터/주문 경로에서 074 멤버 MAT_382/383/384 선택이 렌더→POST payload→`evaluate_set_price`까지 **보존** 실화면 확인. 멤버 opt_groups는 현재 코드상 휴면.

## 독립성 확인
- codex에 Claude(set-designer/게이트) 판정 비노출. 같은 설계·코드 입력으로 codex 독립 판정. codex는 라이브 DB 미접근(샌드박스) → 코드/파일 근거 가설. 라이브 확증은 reconcile 담당.
