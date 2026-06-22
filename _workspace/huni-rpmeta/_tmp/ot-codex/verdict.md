**판정: ABSORBED**

1. **NEW-AXIS 아님.**  
   승격 규칙 기준으로 `dieline / structural-net` 축은 성립하지 않습니다.

   - **전용 option slot 관측 없음:** 박스 5종의 live slot은 `paper`, `paper_sub_select`, `sodu`, `size`, `number2_sel`, `number1_sel`뿐입니다. `dieline`, `box_type`, `structure`, `net`, `glue_tab` 같은 별도 선택축은 없습니다.
   - **KB defect 없음:** 기존 축으로 왜곡 없이 흡수됩니다. 사용자는 “케이크박스 소/중/대” 같은 `size preset`만 고르고, bracket 값은 flat work-size입니다. 3D 치수는 표시/파생 정보이지 선택축이 아닙니다.

**축 매핑**

| 대상 | 귀속 축 | 이유 |
|---|---:|---|
| flat unfolded work-size / cut-size / margin | **#13 사이즈** | `t_siz_sizes`가 work/cut/margin을 한 row에 담는 구조라 정확히 맞습니다. |
| 3D product W x D x H | **#13 사이즈의 표시/파생 속성** | 선택값은 size preset 하나입니다. 다만 현재 vessel에 `depth/height` 표시 필드가 없다면 “Size 축의 표현력 보강” 문제이지 새 축은 아닙니다. |
| die-cut knife line | **#2 공정** | 도무송/칼선은 공정 facet입니다. |
| crease / fold line | **#2 공정** | 오시/접힘선은 공정 facet입니다. 박스 구조라고 해서 별도 관리축이 되지 않습니다. |
| glue tab | **#2 공정 또는 TemplateAsset 표현 요소** | RP가 접착/조립하지 않으므로 #14 형태가공은 아닙니다. 접착 탭은 dieline geometry 또는 후가공 지시의 일부입니다. |
| box shape, e.g. cake/flat/half-moon/envelope/gift | **#7 카테고리 / product-code split**, 보조적으로 **#13 size preset label** | 5개 박스가 별도 product code로 갈라져 있고, 내부 차이는 size preset label/dimension입니다. dedicated shape slot이 없으므로 #17 승격 사유가 아닙니다. |
| editor dieline artwork/template | **#16 TemplateAsset** | `makers.redprinting.net/v1/templates/{code}`의 `template_uri/resource_id/token`은 editor seed resource입니다. 가격 0의 디자인 자산으로 보는 게 맞습니다. |
| flat → 3D assembly | **축 아님 / #14 아님** | “ships folded flat, customer assembles”이므로 RP가 3D 형태를 제작하는 positive form-processing이 아닙니다. |

**Soundness Flags**

- **Fabrication 경고:** “응답 surface에 CAD/line-type 필드가 없다”는 말은 안전합니다. 다만 `template_uri` 내부 GCS JSON을 열지 않았으므로 “dieline geometry가 존재하지 않는다”까지 말하면 fabrication입니다.
- **Overfit 경고:** `structural-net`을 새 축으로 만들면 박스군 전용 asset/size 표현을 관리축으로 과승격하는 오버핏입니다. 라이브 slot 일반화가 없습니다.
- **Implausible PASS 없음:** 이 증거만으로는 `ABSORBED`가 print-domain expectation에 맞습니다. 박스는 인쇄+도무송+오시된 평면 전개도 상품이고, 조립형 3D 제조 상품이 아닙니다.

결론: **dieline / structural-net은 NEW-AXIS가 아니라 기존 #13 Size + #2 Process + #16 TemplateAsset + #7 Category로 흡수됩니다.**