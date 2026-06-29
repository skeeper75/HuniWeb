당신은 후니프린팅 인쇄 가격엔진 설계의 **독립 2차 검증자**입니다. 아래 박류(foil) 후가공 가격 설계가 권위 가격표·라이브 가격엔진 계약과 정합한지를 **백지에서 독립 판정**하세요. 다른 검증자의 결론은 주어지지 않습니다 — 당신 스스로 증거를 읽고 판단하세요.

## 배경 (도메인)
- 박(foil)=인쇄물에 금속박을 압착하는 후가공. 가격 = **동판비**(박 모양 제작 1회성 셋업비) + **박가공비**(박 찍는 작업비, 면적등급 A~E × 수량구간으로 결정).
- 라이브 가격엔진 `evaluate_price`(파일 `raw/webadmin/webadmin/catalog/pricing.py`)가 단일 권위 알고리즘. 가격공식(price_formula)은 가격구성요소(price_component)들의 합산이고, 각 구성요소는 단가행(component_prices)을 use_dims(차원키)로 정확매칭해 값을 가져온다.
- t_prc_* 테이블 스냅샷(읽기전용 CSV)이 `_workspace/_foundation/live-snapshot/latest/`에 있다(t_prc_price_formulas·formula_components·price_components·component_prices·t_prc_*·t_prd_*·t_proc_processes 등).

## 읽을 파일 (전부 읽기전용)
**설계 산출물 (판정 대상):**
- `_workspace/huni-price-engine-design/03_design/engine-design-foil.md`
- `_workspace/huni-price-engine-design/03_design/design-decisions-foil-rev2.md`
- `_workspace/huni-price-engine-design/03_design/golden-cases-foil.md`

**권위 (절대 기준·엑셀 추출 CSV):**
- `_workspace/huni-dbmap/06_extract/price-foil-large-l1.csv` (박 대형 시트: 동판비 B01 면적매트릭스 / 일반박 B02면적등급·B03수량별 / 특수박 B04·B05)
- `_workspace/huni-dbmap/06_extract/price-foil-small-l1.csv` (박 소형 시트: 동판비 B01 고정 / 일반박 B02·B03 / 특수박 B04·B05)
  - CSV 구조: 컬럼 sheet,block_id,block_title,row_seq,col,cell_ref,row_key,band_header_path,value,cell_meta_json. value 컬럼이 셀 실제값. band_header_path에 누적 경로가 들어있어 행/열 좌표 복원 가능.

**라이브 엔진 계약 (배선 가능 여부 판정 기준):**
- `raw/webadmin/webadmin/catalog/pricing.py` — 특히 NON_QTY_DIMS/TIER_DIMS 정의(상단 ~42-50행), 단가형 ×qty vs 합가형 min_qty 처리(~200-210행), 미선택 proc_cd 처리(~576행), off-grid ceiling(~158-162행), 템플릿가 처리(~441-446행).
- 라이브 스냅샷 t_prc_*.csv (`_workspace/_foundation/live-snapshot/latest/`).

## 독립 판정 질문 (각각 근거 셀/라인 인용·확신도 High/Med/Low)

**Q1. 설계 건전성·엔진 정합:** 박 가격 설계 = 동판비(prc_typ .03 1회성) + 박가공비(prc_typ .02 합가형·면적등급×수량구간×일반/특수, 본체 공식 formula_components에 직접 합산·proc_cd 차원으로 박 선택 시만 매칭)가 ① 권위 박 시트 구조와 정합하는가 ② 라이브 evaluate_price가 실제로 먹는(계산 가능한) 형태인가? 빠진 구성요소로 견적이 안 나오거나 오배선·차원 미스매치·세트 이중계상이 있는가?

**Q2. ★돈크리티컬:** (가) 동판비가 ×qty로 폭발하지 않는가(.03·수량 무관 1회성)? (나) 박가공비가 이중합산되거나 ×qty 폭발하지 않는가(.02 합가형 본체합산·min_qty 구간하한·proc_cd 미선택 시 0)? 설계가 addon 템플릿 경로를 부결하고 본체 공식 합산으로 전환한 것이 ×qty 폭발 방지 측면에서 타당한가? pricing.py 실제 코드로 검증하라.

**Q3. 면적→등급(A~E) 환산:** 박가공비는 가로×세로 → 등급 A~E → 단가의 2단 lookup이다. 라이브 엔진(NON_QTY_DIMS/TIER_DIMS)이 면적값→등급 환산을 **지원하는가**? 미지원이면 설계가 이를 어떻게 다뤘는가(앱 계산? 코드트랙 분리? 고정사이즈 collapse?)가 타당한가, 아니면 견적 불가의 숨은 결함인가?

**Q4. 골든 8케이스 재현:** golden-cases-foil.md의 8개 케이스(G-F1~G-F8) 기대값을, 당신이 권위 CSV에서 **독립적으로** 동판비/박가공비 셀을 찾아 재계산했을 때 일치하는가? 특히:
  - 면적→등급 격자 매핑(예 대형 90×90=C? 170×170=E? 소형 40×80=E?)
  - 동판비 면적매트릭스 셀(대형 90×90=18,000? 170×170=64,000?)
  - 박가공비 단가(대형 일반박 C등급 1000=120,000? 특수박 C등급 1000=150,000? 소형 일반박 E등급 1000=64,000?)
  - 일반/특수 박색상 그룹 시트별 차이(먹유광=소형 일반/대형 특수?)
  불일치 셀이 있으면 권위 셀 좌표와 함께 적시하라.

**Q5. 놓친 결함·환각·false-positive:** 설계가 놓친 결함, 또는 설계가 결함이라 주장하나 실제로는 아닌 false-positive, 또는 권위에 없는데 설계가 만들어낸 환각이 있는가? 명함박과의 1,000원 갭(G6) 처리가 타당한가?

## 출력 형식
질문별로 명확한 판정(정합/결함/조사필요)과 근거(권위 셀 좌표 또는 pricing.py 라인), 확신도를 적어라. 종합 verdict(GO 수준 / CONDITIONAL / NO-GO)와 가장 중대한 발견 1~3건을 마지막에 요약하라. 라이브 인용은 실제로 파일에서 확인한 것만 적고, 추측은 "추정"으로 표시하라.
