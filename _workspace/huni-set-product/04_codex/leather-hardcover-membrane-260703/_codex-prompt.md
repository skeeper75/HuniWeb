# 독립 교차검증 요청 — 072 하드커버책자 셋트 "면지 통합" 재설계

당신은 후니프린팅 셋트상품(부품조립형) 재설계의 **독립 2차 검증자**다. 아래 설계를 **처음 보는 눈으로 냉철히 반박**하라. 다른 검증자의 판정은 당신에게 제공되지 않는다(독립 판정).

## 읽어야 할 파일 (읽기전용, 이미 리포 안에 있음)
- 설계 명세: `_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/redesign-spec.md`
- 적재본: `_workspace/huni-set-product/03_design/leather-hardcover-membrane-redesign-260703/apply.sql` (8스텝) · `undo.sql`
- 골든 재현: `.../golden-reproduce.md` · `.../t_prd_product_sets.csv` · `.../blocked-board.csv`
- 라이브 가격엔진 코드(권위): `raw/webadmin/webadmin/catalog/pricing.py` (evaluate_price / evaluate_set_price)
- 셋트 시뮬레이터 메타: `raw/webadmin/webadmin/catalog/price_views.py` (함수 `_set_members_meta` line~1685)
- 시뮬레이터 렌더: `raw/webadmin/webadmin/catalog/templates/catalog/price_simulator.html` (renderInsts / memberMulti)

## 재설계 요지 (당신이 반박할 대상)
072 셋트 = 표지(073) + 내지(284) + 면지. 현재 면지는 빈 멤버 3개(074화/075블/076그)로 이중표현. 재설계:
- 면지 1멤버(074)로 통합. 075/076 셋트링크 논리삭제(del_yn=Y).
- 부모 072의 면지자재(MAT_382/383/384 USAGE.03)와 옵션그룹(OPT_064)을 면지 멤버 074로 이관.
- 색 택1(화/블/그)은 면지 멤버 074의 "자재 드롭다운"으로 발현한다고 주장.
- 신규 mint 0. 골든 34,100/159,100/796,900(1/10/100부) 재설계 전후 동일하다고 주장.

## 당신이 독립 판정할 5개 핵심 질문
아래 각 항목에 대해 **AGREE / DISAGREE / UNCERTAIN**과 근거(파일:라인 또는 코드 로직)를 명시하라. 환각 금지 — 코드/파일에서 실증되는 것만.

1. **골든 무손상 주장이 안일한가.** 면지 자재/옵션을 부모→멤버 074로 이관한 뒤 evaluate_set_price가 정말 34,100/159,100/796,900 그대로인가. pricing.py의 evaluate_price/evaluate_set_price 로직상, 면지 멤버 074에 자재를 붙이면 그 멤버 기여가 0이 아니게 되거나·이중합산·누락이 생길 여지가 있는가? (멤버 074가 가격공식이 없다는 전제가 코드상 정말 "기여 0"을 보장하는가?)

2. **fn_chk_opt_item_ref 트리거 순서 안전성.** apply.sql 순서(자재[2]→옵션아이템[5]→부모옵션은퇴[6]→부모자재은퇴[7])가 트리거를 위반하지 않는가. 이관 중간 상태에서 고아 참조·트리거 위반·FK 파손 가능성은? undo.sql의 복원 순서도 안전한가?

3. **075/076 은퇴(del_yn=Y) 무결성.** 복합PK·FK·사후 무결성에 안전한가. 다른 곳에서 075/076을 참조할 가능성을 설계가 확인했는가(설계 문서 근거)?

4. **색 택1 "자재 드롭다운" 발현 주장 — 선택지 손실(오차단) 위험.** `_set_members_meta`가 멤버별로 무엇을 동봉하는가(materials 포함? opt_groups 포함?). price_simulator.html의 renderInsts가 멤버 카드에 자재(용지) 드롭다운을 렌더하는가? 옵션그룹을 멤버 UI에 렌더하지 않는다면, 이관한 면지색 옵션그룹은 휴면이 되는데 — 그렇다면 손님이 화/블/그를 정말 고를 수 있는가, 아니면 선택지가 사라지는가(오차단)?

5. **계열 전파 주의.** 설계의 082 USAGE.07 자재 불가침·088 내지 없음·088 적재대기 조율 등 전파 주의가 타당·완전한가. 072 파일럿에서 놓친 위험이나 계열로 새는 오염 가능성은?

## 출력 형식
- 각 질문 1~5: 판정(AGREE/DISAGREE/UNCERTAIN) + 근거 1~3줄.
- 마지막에 종합: 이 재설계를 S1~S8 게이트로 넘겨도 되는가? 반드시 실측/보강해야 할 잔여 리스크 Top 3.
- 당신 판정은 "가설"임을 인지하라 — 라이브 실측 없이 코드/파일 근거만으로 판단.
