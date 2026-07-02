# 결함 보드 — 가격경로 축 전면 재검증 (R3·260703)

> 대상: 03_kb (build 재실행 노드204/엣지430·hard=0·soft=30) · 원천: live-snapshot/latest(snap_20260702_1119) · 작성: 2026-07-03
> 배정 축: ① 8상품 상품→차원→자재/공정→옵션그룹→공식→구성요소 경로 재귀 CTE 실탐색(끊김=GAP 선언 여부) ② KB 배선(priced_by·has_component·option_refs·has_process) live 전수 스크립트 diff ③ 8상품 밖 dead-link ④ GAP 15 반증
> 재현 스크립트(전부 재실행 가능·05_verification/scripts/):
>  - `verify_r3_price_path_260703.py` (신규·①②③④ 통합·재귀 CTE+use_dims verbatim+dead-link+GAP 형식)
>  - `verify_r2_wiring_260703.py`·`wiring_vs_live.py`·`option_refs_and_extras.py`·`product_axis_vs_live.py`·`price_path_traverse.py` (재사용)
> ★생성자(builder)·빌드 리포트 비신뢰 — 그래프 직접 재빌드(2회 멱등)·라이브 스냅샷 직접 대조로만 판정.
> ★R2에서 이 축 반환 유실 → 처음부터 재검증. R1 결함(defect-price-path-260703.md V1-01~05) 해소 여부도 재실측.

## 판정: 통과 (가격경로 축 결함 0 · 미해소/신규 High 0)

8 파일럿 상품 전부 상품→공식→구성요소 종단 경로 무결. KB↔라이브 배선 전수 정합. 조용한 누락·dead-link·환각 관계 0. 잔여는 **정직 선언된 커버리지 GAP 1건(Medium)** + **GAP 문구 정밀도 1건(Low)** 뿐 — 둘 다 가격경로를 끊지 않음.

## 반증 실패 = 생존(통과) 항목

- **① 8상품 재귀 CTE 종단 경로 무결** — 8/8 상품 `product→priced_by→formula→has_component→component` 경로 끊김 0. 공식 없는 상품 0·구성요소 없는 공식 0·dead component leaf 0. (016=10comp·024=2·027=2공식14comp·032=2·033=2·041=10·043=4·046=3)
- **② priced_by 9쌍 전수 라이브 일치** — KB(prd→frm) ↔ t_prd_product_price_formulas: KB-only 0·LIVE-only(8상품) 0. 027=2공식(PRF_DGP_E·E_FOIL).
- **② has_component 10공식 전수 일치** — KB(frm→comp) ↔ t_prc_formula_components 10/10 MATCH. 인용 comp 중 del_yn=Y/use_yn=N/부재 = 0.
- **② price_component 26 노드 use_dims·prc_typ_cd verbatim 일치** — 26/26 라이브 t_prc_price_components CSV와 use_dims·prc_typ_cd 오차 0. 환각 anchor 0·del_yn=Y 인용 0. (단가행 t_prc_component_prices는 D-22 규약대로 노드로 펼치지 않고 use_dims 속성으로 접음 — 값 계산=evaluate_price 권위, 경계 문서화됨)
- **② has_process 배선 라이브 일치(R2 교정 재확인)** — 016 has_process 7/7·041 5/5 라이브 완전 일치. PROC_000085 환각 배선 0(라이브 상품바인딩 0·그래프 has_process→085 0). R1 V1-01·V1-02 해소 재실측 확인.
- **② option_refs 75건 전수 실재** — dst(material/process/print_option) 전부 라이브 실재·부재 0. 043 option_group 0 = 라이브 0 일치(조용한 누락 아님).
- **③ dead-link 0** — dst 노드 부재 엣지 0건(8상품 내외 전수). 8상품 밖 addon 대상(봉투/기성)은 4 GAP(gap-016/024/027-addon·GAP_envelope_set_model)로 정직 선언·조용한 dead-link 없음.
- **④ GAP 15 형식·반증** — build_graph.py:324가 gap_what/gap_fill_from/gap_owner 3필드를 빌드 시 hard-lint(누락=hard fail). hard=0이므로 15 GAP 전부 3필드 보유. 가격경로 관련 GAP 전부 anchor:none 정당(원천 부재)·정직.
- **그래프 무결성 자체검사** — build_graph.py 2회 실행 md5 동일(2baf5426…)·hash 동일(nodes f116635e/edges da3e882a) = 멱등. edges.jsonl 430 unique·중복 0·graph.db 430·리포트 430 삼자 일치(R1 V1-04 dup 해소).
- **R1 V1-05 해소** — pack §193 봉투 addon tmpl 038/039로 교정·010/011을 STALE 함정으로 명시 flag.

## 결함 (미해소/잔존)

| ID | 노드/엣지 | 축 | 결함 | 심각도 | 라우팅 |
|----|-----------|-----|------|--------|--------|
| R3-01 | GAP_016_material · product-016 uses_material | ⑤연결완전성(커버리지) | 016 라이브 활성자재 21 vs 그래프 배선 4(대표). 17종 미배선 — **GAP_016_material 노드로 정직 선언**(product-016 references 실재·badge unknown). 조용한 누락 아님·가격경로 미차단(mat_cd는 COMP_PAPER의 런타임 차원, 그래프 배선에 가격 종속 안 함). 형제 027/033/041은 전 자재 배선. architect 완전성 정책 대기 | Medium | architect(파일럿 커버리지 정책) |
| R3-02 | GAP_016_material gap_what 문구 | ①출처실재성(정밀도) | gap_what이 "17종 미민팅"으로 서술하나 실측=17 중 **7종은 axis 노드 민팅됨(미배선)**·10종만 미민팅(MAT_000109/123/347/348/349/350/356 민팅 확인). "미민팅"→"미배선(7 민팅·10 미민팅)"으로 정밀화 필요. 커버리지 결론엔 무영향 | Low | curator |

## 증거(재현)

### R3-01 / R3-02
```
$ python3 05_verification/scripts/product_axis_vs_live.py    # PRD_000016
  uses_material: DIFF KB=4 LIVE=21  라이브에만(미배선)=[MAT_000109,123,124,347~360]  # 17종
$ python3 -c "17 미배선 중 axis 노드 민팅 여부"
  17 중 axis 노드 민팅됨: 7 [MAT_000109,123,347,348,349,350,356]   미민팅: 10
# GAP_016_material 노드 실재·product-016→references→GAP_016_material 확인(그래프)
# gap_what 원문(L325): "…17종…이 공유 axis/materials에 미민팅…" → 7종은 실제 민팅(문구 부정확)
```
교정: (R3-01) architect가 "대표 subset 유지(GAP 선언)" vs "17 product-local 민팅+전수 배선(041 방식)" 결정. (R3-02) gap_what 문구를 실측(7 민팅·10 미민팅)으로 정밀화.

### 배선 전수 정합(R2 교정 재확인·PASS)
```
$ python3 05_verification/scripts/verify_r2_wiring_260703.py
  VERDICT: PASS (라이브↔그래프 배선 전수 정합·085 환각 0)
$ python3 05_verification/scripts/verify_r3_price_path_260703.py
  ① 8상품 재귀 CTE: 8/8 [OK]   ② use_dims/prc_typ 불일치=0·del_yn=Y 인용=0   ③ DEAD-DST 0   ④ GAP 15
  VERDICT: PASS
```

## 검증 범위·한계 (정직)

- **전수(스크립트):** ① 8상품 재귀 CTE 종단 경로 ② priced_by(9)·has_component(10공식)·option_refs(75)·has_process·8상품×4축(process/material/print_option/size) KB↔라이브 diff ③ dead-link 전수 ④ price_component 26 use_dims·prc_typ_cd verbatim ⑤ GAP 15 형식. 그래프 2회 재빌드 멱등.
- **표본/미확인(이 라운드 밖):**
  - ① **evaluate_price 실호출 가격 오차 대조 미수행** — 라이브 DB 미접속·이 라운드는 배선·경로·차원선언 실재까지. 실제 가격값 오차 0(PRICE≠0)은 별도 라운드 필요(O6 종단 질의 게이트). 배선·use_dims는 정합하나 단가행(t_prc_component_prices 값)이 이 빠짐 없이 채워졌는지는 §26 무결성 트랙 소관.
  - ② has_size 사이즈 차원 수치(가로/세로) 값 정합 미대조(배선 존재만).
  - ③ 8상품 외 나머지 카탈로그·비디지털 시트 미검(파일럿 범위).
- **by-design(결함 아님):** aliaslabel DEAD-SRC 19건(build_graph.py:52·388 I-2 src 예외·term 투영 라벨)·orphan axis 노드(printopt-POPT_000008/009·process-PROC_000001/007/013/056·size-SIZ_000499=축 정의만·8상품 미참조)·orphan GAP 3(GAP_product_count·roll_material_price·transparent019_pansu=전역 미확정·8상품 경로 밖·정직 등재).
- **결함 0 아님이 아니라 "가격경로 축 결함 0·잔여=정직 GAP 1+문구 1"** — "무결" 단정은 evaluate_price 가격 오차 라운드까지 유보.
```
