# 신규 코드값 선적재 제안 — 상품마스터 260527 → 260610

FK 위상정렬상 상품/관계행보다 먼저 적재돼야 할 신규 코드값(siz_cd·opt_cd·mat_cd 등)을
식별한다. 본 트랙은 제안만 — 실 적재는 인간 승인.

## 평결: 이번 버전쌍의 즉시 선적재 필요 신규 코드 = 0건

- **상품 ADDED 0** → 신규 상품 종속 코드행 없음.
- **MODIFIED 527셀**은 신규 스칼라 값이 아니라 size→option **재분류**(굿즈파우치)·
  변형행 감축(아크릴)·범례(실사)다. 새 코드값을 *지금* 도입하지 않는다.

## 후속(escalate) 시 발생할 코드값 — 본 트랙 종착점 너머

굿즈파우치 size→option 재분류를 CPQ 옵션레이어로 구현하면(별도 L2 트랙) 다음
신규 코드 채번이 발생한다. **본 트랙에서는 채번/적재하지 않는다**(설계 미확정):

| 엔티티 | 신규 코드 성격 | 채번 규칙(권위: code-identifier-strategy.md) |
|--------|---------------|----------------------------------------------|
| t_prd_product_option_groups | opt_grp_cd (상품별 옵션그룹) | per-product MAX+1, separator `_` |
| t_prd_product_options | opt_cd (옵션) | per-product MAX+1 |
| t_prd_product_option_items | item_seq + ref_dim_cd | 차원행 polymorphic 참조(OPT_REF_DIM) |

- 재분류 대상 size 값(레더15x30 등)은 **이미 t_siz_sizes/t_prd_product_sizes에 적재**돼
  있으므로(예 PRD_000280 3행), 신규 siz 채번이 아니라 option_items가 그 기존 siz_cd를
  `ref_dim_cd=OPT_REF_DIM, ref_key1=siz_cd`로 참조하는 형태가 유력(L2에서 확정).
- 따라서 search-before-mint: **신규 siz 채번 금지**, 기존 코드 재사용 우선.

## 결론

선적재 CSV/INSERT 산출 없음(0건). escalate 해소(CPQ L2 설계) 시점에 채번 트랙에서 처리.
