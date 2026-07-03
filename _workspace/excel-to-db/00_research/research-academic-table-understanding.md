# 학술 리서치: 스프레드시트/엑셀 표 이해 → DB 스키마·적재 코드 자동화

> 목적: 업무용 엑셀(상품마스터·가격표)을 LLM 에이전트 하네스가 읽어 **DB 스키마 + 적재 코드**로
> 바꾸는 설계를 학술 근거로 뒷받침한다. 아래 모든 주장에는 실제 출처(논문·URL)가 붙어 있다.
> 확인 못 한 것은 `미확인`으로 표시했다.
> 작성일: 2026-07-02

---

## 핵심 요약 (5줄)

1. **엑셀은 "표처럼 생긴 그림"이다** — 셀 격자에 표 영역·머리글·데이터가 자유롭게 섞여 있어, 사람은 알아보지만 프로그램은 못 알아본다. 이걸 먼저 **표 영역 찾기 → 셀 역할 분류(머리글/데이터/제목/그룹머리글) → 관계형(1행1레코드)으로 펴기** 3단계로 풀어야 한다(TableSense, DeExcelerator, Koci).
2. **가격표 같은 크로스탭(가로세로 매트릭스)은 "unpivot(피벗 풀기)"** 으로 (행키, 열키, 값) 롱포맷 관계형으로 변환하는 것이 정석이다 — 이게 후니 가격표(사이즈×수량 매트릭스)를 `component_prices` 단가행으로 펴는 작업과 정확히 같다.
3. **스키마 추론은 "데이터 프로파일링"이 토대** — 유일키·함수종속(FD)·포함종속(IND=외래키 후보)을 데이터에서 발굴하면 정규화 스키마와 FK가 상당 부분 자동으로 나온다(Abedjan/Golab/Naumann 서베이, Metanome).
4. **컬럼이 "무슨 의미인가"(사이즈? 자재? 도수?)는 의미형 타입 탐지**로 붙인다 — 값 통계 기반(Sherlock)→표 맥락 반영(Sato)→표 전체를 트랜스포머로(Doduo)→LLM 기반(ArcheType)으로 발전해 왔다.
5. **2024~2025년 LLM 방식**(SpreadsheetLLM/SheetCompressor, LLM 스키마 추론)은 강력하지만 **환각·토큰 폭발**이 실증된 위험이라, 결정론 프로파일링을 1차로 하고 LLM은 의미 부여·모호 해소에만 쓰는 하이브리드가 안전하다.

---

## 주제 1. 스프레드시트 표 구조 이해·추출

### 1-1. TableSense — 엑셀을 "이미지처럼" 보고 표 경계 CNN 탐지
- **무엇인가:** 셀 격자를 픽셀 행렬처럼 취급해 CNN으로 표의 정확한 경계를 찾는다. 셀 피처화(featurization) + 불확실성 기반 능동학습으로 10,220 시트·22,176 표 데이터셋을 구축, EoB-2 기준 재현율 91.3%·정밀도 86.5% 달성.
- **출처:** Dong, Liu, Han, Fu, Zhang, "TableSense: Spreadsheet Table Detection with Convolutional Neural Networks", AAAI 2019 / Microsoft Research. arXiv:2106.13500 — https://arxiv.org/abs/2106.13500
- **하네스 적용(적용도 Medium):** 한 시트에 표가 여러 개 흩어져 있을 때 "표 영역 경계 찾기"가 첫 단계임을 명확히 함. 다만 CNN 재현은 과함 — 후니 엑셀은 시트=표가 대체로 1:1이라, **머리글 행/데이터 시작 행 경계만 규칙+LLM으로 잡아도 충분**. 개념(표 영역 탐지를 별도 단계로 분리)만 차용.

### 1-2. DeExcelerator — 부분구조 문서 → 1정규형 관계 자동 변환
- **무엇인가:** 스프레드시트·HTML 표처럼 서식/레이아웃/메타텍스트가 뒤섞인 "부분 구조 문서"를 **제1정규형(1NF) 관계**로 변환하는 파이프라인. 문자열 행렬 위에서 추출 휴리스틱을 돌리되, 셀 색상 등 메타데이터를 머리글 인식의 근거로 활용.
- **출처:** Eberius, Werner, Thiele, Braunschweig, Damme, Lehner, "DeExcelerator: A framework for extracting relational data from partially structured documents", CIKM 2013. https://dl.acm.org/doi/10.1145/2505515.2508210 · 코드 https://github.com/chrissi007/DeExcelerator
- **하네스 적용(적용도 High):** 우리 목표(엑셀→관계형→DB)의 **정확한 선행 연구**. 핵심 교훈 = 색상/굵기/병합셀 같은 **서식 신호를 머리글·데이터 구분 근거로 쓰라**. 후니 가격표의 굵은 헤더·병합 사이즈 라벨이 그대로 이 신호에 해당.

### 1-3. Koci et al. — 셀 역할 5분류(레이아웃 추론) + DECO 데이터셋
- **무엇인가:** 셀 단위 지도학습으로 각 셀을 5개 레이아웃 역할로 분류. DECO 데이터셋은 셀 단위로 Data/Header/Derived/GroupHeader/Title/Note/Other 라벨을 단 854개 스프레드시트.
- **출처:** Koci, Thiele, Romero, Lehner, "A Machine Learning Approach for Layout Inference in Spreadsheets" / "Cell Classification for Layout Recognition in Spreadsheets", Springer 2018. https://link.springer.com/chapter/10.1007/978-3-319-99701-8_4 · DECO 데이터셋(Koci et al.)
- **하네스 적용(적용도 High):** **셀 역할 분류 체계(Header/Data/GroupHeader/Derived/Title/Note)를 그대로 하네스의 셀 태깅 온톨로지로 채택**하라. 특히 `Derived`(계산된 셀=수식 결과)와 `GroupHeader`(계층 머리글) 구분이 후니 가격표에서 중요 — 소계/합계 행을 데이터로 오적재하는 사고를 막는다.

### 1-4. TabularNet — 공간(격자)+관계(계층) 동시 인코딩
- **무엇인가:** 표의 **공간 정보**(행/열 풀링 + Bi-GRU)와 **관계 정보**(WordNet 트리 기반 그래프 + GCN)를 동시에 뽑아 셀 간 계층·병렬 관계를 이해하는 신경망 백본.
- **출처:** Du, Gao, Han 외, "TabularNet: A Neural Network Architecture for Understanding Semantic Structures of Tabular Data", KDD 2021. arXiv:2106.03096 — https://arxiv.org/abs/2106.03096
- **하네스 적용(적용도 Low):** 표 이해에 "공간 위치"와 "계층 관계"가 둘 다 필요하다는 **원리**만 유용. 전용 신경망 학습은 후니 규모에 과투자. LLM 프롬프트에 셀 좌표(A1 표기)+병합 범위를 같이 넣어 두 신호를 대체.

### 1-5. TUTA — 계층 표 전용 트리기반 트랜스포머 사전학습
- **무엇인가:** 일반적으로 구조화된(계층 머리글 포함) 표를 위해 셀 트리 거리(tree distance) 기반 위치 인코딩을 쓴 사전학습 트랜스포머. 다층 머리글 표를 정면으로 다룸.
- **출처:** Wang, Dong, Han 외, "TUTA: Tree-based Transformers for Generally Structured Table Pre-training", KDD 2021. arXiv:2010.12537 — https://arxiv.org/pdf/2010.12537
- **하네스 적용(적용도 Low~Medium):** 다층 머리글을 "트리"로 모델링한다는 관점이 유용 — 후니 가격표의 [자재 대분류 > 세부 사이즈] 같은 중첩 머리글을 트리로 파싱해 부모-자식을 복원하는 발상에 참고.

### 1-6. SpreadsheetLLM / SheetCompressor — LLM에 엑셀 먹이는 인코딩(2024)
- **무엇인가:** 2차원 격자를 LLM이 이해하도록 인코딩. 3개 압축 모듈(① 구조 앵커 기반 압축 ② 역인덱스 변환 ③ 데이터 포맷 인지 집계)로 **토큰 96% 절감**, 표 탐지 성능 GPT-4 in-context 대비 +25.6%.
- **출처:** Dong, Tian 외(Microsoft), "SpreadsheetLLM: Encoding Spreadsheets for Large Language Models", EMNLP 2024. arXiv:2407.09025 — https://arxiv.org/abs/2407.09025
- **하네스 적용(적용도 High):** **큰 엑셀을 통째로 LLM에 넣지 마라.** ① "구조 앵커"(머리글·경계 행/열만 남기고 반복 데이터 영역은 요약)로 압축, ② 같은 서식·같은 데이터타입 셀 영역은 범위로 집계(`B2:B500=정수`)해서 넣어라. 우리 가격표처럼 수천 셀짜리 매트릭스를 저비용으로 LLM에 이해시키는 직접 레시피.

### 1-7. Detecting Layout Templates in Complex Multiregion Files (참고)
- **무엇인가:** 한 파일에 여러 영역(멀티리전)이 섞인 복잡 파일에서 레이아웃 템플릿을 탐지.
- **출처:** Vitagliano 외, VLDB 2022. http://vldb.org/pvldb/vol15/p646-vitagliano.pdf
- **하네스 적용(적용도 Low):** 시트 하나에 여러 상품군 표가 섞인 경우 "영역별 템플릿"으로 나눠 처리하라는 근거.

---

## 주제 2. 크로스탭(매트릭스) → 관계형 "unpivot"

### 2-1. 계층 머리글 탐지 + 크로스탭 relationalization
- **무엇인가:** 표를 열머리글만/행머리글만/**매트릭스(행+열 머리글 둘 다)** 로 분류하고, 병합셀 범위·들여쓰기로 머리글 계층을 복원한 뒤, 매트릭스를 여러 관계형 서브테이블로 분해. 병합셀이 후행 행들을 덮으면 부모-자식 계층으로 해석.
- **출처(복수):**
  - Fang, Mitra, Tang, Giles, "Table Header Detection and Classification", AAAI 2012. https://clgiles.ist.psu.edu/pubs/AAAI2012-table-header.pdf
  - US Patent "Spreadsheet table transformation"(머리글/데이터 영역 탐지→계층 결정→관계형 변환) 12,307,193 / 11,836,445
  - US Patent "Automatically converting spreadsheet tables to relational tables" 10,599,627
- **하네스 적용(적용도 High):** 후니 가격표는 전형적 **매트릭스 표**(예: 세로축=사이즈, 가로축=수량구간, 셀=단가). 정석 변환 = **unpivot → `(siz_cd, qty_band, price)` 롱포맷 3튜플**. 이게 곧 `t_prc_component_prices` 단가행 적재 형태. 하네스에 "매트릭스 감지 시 자동 unpivot" 단계를 1급 시민으로 넣어라.

### 2-2. FlashRelate — 예시 기반 준구조 데이터 관계 추출
- **무엇인가:** 사용자가 몇 개 출력 예시만 주면(programming-by-example), 준구조 스프레드시트에서 관계형 데이터를 뽑는 DSL 프로그램을 합성.
- **출처:** Barowy, Gulwani, Hart, Zorn, "FlashRelate: Extracting Relational Data from Semi-Structured Spreadsheets Using Examples", PLDI 2015. https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/flashrelate-tech-report-April2014.pdf
- **하네스 적용(적용도 Medium):** **"몇 줄의 정답 매핑 예시 → 나머지 자동 전파"** 패턴은 하네스의 동형(isomorphic) 전파 전략과 정확히 일치(후니의 "대표 상품 1개 파일럿 → 동형 전파"). LLM에게 few-shot 예시로 매핑 규칙을 주고 전체에 적용시키는 근거.

### 2-3. Senbazuru — 계층 스프레드시트 → 관계 튜플(확률적)
- **무엇인가:** 계층 머리글 스프레드시트에서 관계형 튜플을 확률적으로 추출하는 프로토타입 SSDBMS. 데이터 프레임 식별 분류기 + 계층 추론 분류기(병합셀·굵은 폰트 등 피처)로 구성. 단일 표·계층 머리글 구조로 제한.
- **출처:** Chen, Cafarella, "Senbazuru: A Prototype Spreadsheet Database Management System", VLDB 2013. https://dl.acm.org/doi/abs/10.14778/2536274.2536276 · 관련: "Automatic Web Spreadsheet Data Extraction"(SSW 2013), "Integrating Spreadsheet Data via Accurate and Low-Effort Extraction"(KDD 2014)
- **하네스 적용(적용도 Medium):** 병합셀·굵기가 계층 신호라는 점(DeExcelerator와 일치)을 재확인. **"단일 표·계층 머리글"이라는 제약 안에서 잘 동작**한다는 것 = 하네스도 표를 잘게 쪼개 "1시트=1표=1계층" 단위로 다루면 신뢰도가 올라간다.

### 2-4. TabbyXL — 규칙기반 셀→관계 변환
- **무엇인가:** CRL(Cell Recovery Language) 규칙으로 임의 배치 표를 관계형으로 변환하는 오픈 플랫폼.
- **출처:** Shigarov 외, "TabbyXL: Rule-Based Spreadsheet Data Extraction and Transformation", 2019. https://link.springer.com/chapter/10.1007/978-3-030-30275-7_6
- **하네스 적용(적용도 Medium):** 결정론 **규칙 엔진**이 LLM보다 재현성·감사 가능성이 높다는 근거. 후니 하네스가 이미 쓰는 "결정론 배치 diff 스크립트(토큰0)" 철학과 일치 — 반복 패턴은 규칙으로, 애매한 것만 LLM으로.

---

## 주제 3. 데이터 프로파일링 → 스키마 추론

### 3-1. Abedjan, Golab, Naumann — 관계형 데이터 프로파일링 서베이 (표준 교과서)
- **무엇인가:** 데이터 프로파일링의 캐노니컬 서베이. ① 단일 컬럼(값 분포·데이터타입·유일성·패턴) ② 다중 컬럼(**유일키/유일컬럼조합, 함수종속 FD, 포함종속 IND**) ③ 종속성 발굴 알고리즘을 총정리.
- **출처:** Abedjan, Golab, Naumann, "Profiling relational data: a survey", The VLDB Journal 24(4):557–581, 2015. https://link.springer.com/article/10.1007/s00778-015-0389-y · PDF https://dspace.mit.edu/bitstream/handle/1721.1/106176/778_2015_Article_389.pdf
- **하네스 적용(적용도 High):** 스키마 추론의 **뼈대 체크리스트**. 하네스는 엑셀 각 컬럼에 대해 (a) 데이터타입·null율·유일성 프로파일, (b) 유일컬럼조합=후보 기본키(PK), (c) 포함종속=후보 외래키(FK), (d) 함수종속=정규화 분해 힌트를 **순서대로 계산**하면 스키마 초안이 데이터로부터 자동으로 나온다.

### 3-2. Metanome — 프로파일링 알고리즘 통합 플랫폼
- **무엇인가:** FD/IND/UCC(유일컬럼조합) 발굴 알고리즘을 한 곳에 모은 확장형 플랫폼. 유일키=HyUCC/DUCC, 포함종속(FK)=BINDER/SPIDER/FAIDA, 함수종속=정규화용.
- **출처:** Papenbrock, Bergmann, Finke 외, "Data Profiling with Metanome", VLDB 2015. http://www.vldb.org/pvldb/vol8/p1860-papenbrock.pdf · https://hpi.de/naumann/projects/data-profiling-and-analytics/metanome-data-profiling/algorithms.html
- **하네스 적용(적용도 High):** 스키마 추론을 LLM에 맡기지 말고, **UCC→PK후보 / IND→FK후보를 결정론 알고리즘으로 뽑아 LLM에 근거로 제공**하라. 후보를 데이터로 확정하고 LLM은 "이 UCC가 진짜 의미있는 키냐"만 판단 → 환각 제거.

### 3-3. 포함종속(IND) 발굴 13개 알고리즘 실험 평가
- **무엇인가:** IND(=외래키 후보)는 데이터 링키지·질의 최적화·통합의 핵심 메타데이터. 13개 알고리즘을 실험 비교(BINDER·SPIDER·MANY·FAIDA 등).
- **출처:** Dürsch 외, "Inclusion Dependency Discovery: An Experimental Evaluation of Thirteen Algorithms", CIKM 2019. https://github.com/HPI-Information-Systems/inclusion-dependency-algorithms
- **하네스 적용(적용도 Medium):** 여러 엑셀(상품마스터·가격표) 사이 **공통 컬럼으로 FK를 자동 발견**(예: 가격표의 `prd_nm` ⊆ 상품마스터의 `prd_nm`)하는 근거. 후니 JOIN KEY=`prd_nm` only 규칙이 바로 IND 발굴로 검증 가능.

### 3-4. Normalized Relational Schema from Nested Key-Value Data
- **무엇인가:** 비정규화된 중첩 JSON을 학습으로 정규화 관계형 스키마로 자동 변환(FD 발굴 기반).
- **출처:** DiScala, Abadi, "Automatic Generation of Normalized Relational Schemas from Nested Key-Value Data", SIGMOD 2016. https://dl.acm.org/doi/10.1145/2882903.2882924
- **하네스 적용(적용도 Medium):** "비정규 원천 → 정규화 스키마 자동 도출"의 직접 선례. 함수종속으로 반복 그룹을 별도 테이블로 분리하는 알고리즘 = 후니 셋트상품(부모-구성원)·옵션-차원 분해와 구조적으로 동일.

---

## 주제 4. 의미형 컬럼 타입 탐지 (이 컬럼이 "무슨 의미"인가)

### 4-1. Sherlock — 값 통계 기반 딥러닝 의미 타입 탐지
- **무엇인가:** 컬럼 값의 통계·문자분포·워드임베딩·문단벡터 등 1,588개 피처로 78개 의미 타입(DBpedia) 분류. 68만 컬럼 학습, F1 0.89.
- **출처:** Hulsebos 외(MIT), "Sherlock: A Deep Learning Approach to Semantic Data Type Detection", KDD 2019. arXiv:1905.10688 — https://arxiv.org/abs/1905.10688
- **하네스 적용(적용도 Medium):** 헤더가 없거나 애매할 때 **값 자체로 컬럼 의미 추론**(예: "GT-01" 값들 → 코드형, "297x210" → 사이즈형). 후니는 도메인 특화(siz/mat/도수)라 범용 78타입은 부적합하지만, "값 패턴으로 타입 판정" 기법은 채택 가치 있음.

### 4-2. Sato — 표 맥락(주변 컬럼) 반영
- **무엇인가:** Sherlock의 약점(값만 봄) 보완 — LDA로 표 전체 토픽 벡터를 학습해 컬럼 맥락 반영. 모호·희소 타입에서 Sherlock 대비 macro F1 +14.4%.
- **출처:** Zhang 외, "Sato: Contextual Semantic Type Detection in Tables", VLDB 2020. https://www.vldb.org/pvldb/vol13/p1835-zhang.pdf
- **하네스 적용(적용도 Medium):** 컬럼 의미는 **혼자 보지 말고 표 전체 맥락에서 판단**하라 — 같은 "숫자" 컬럼도 옆에 사이즈 컬럼이 있으면 수량, 가격 컬럼 옆이면 단가. LLM 프롬프트에 컬럼 하나가 아니라 표 전체를 주는 이유의 학술 근거.

### 4-3. Doduo — 표 전체를 트랜스포머로 (멀티태스크)
- **무엇인가:** 표 전체를 토큰열로 직렬화, 컬럼마다 [CLS]를 넣어 트랜스포머로 인코딩. 컬럼타입+컬럼관계를 단일 모델로 예측(멀티태스크). 컬럼당 8토큰으로도 SOTA.
- **출처:** Suhara 외(Megagon), "Annotating Columns with Pre-trained Language Models" (Doduo), SIGMOD 2022. arXiv:2104.01785 — https://arxiv.org/abs/2104.01785
- **하네스 적용(적용도 Medium):** 컬럼 "타입"과 컬럼 간 "관계"를 **동시에** 뽑는 발상 = 스키마 추론에서 컬럼 의미와 FK 관계를 한 번에 뽑는 것과 같음. 적은 토큰으로도 된다는 결과는 압축 인코딩(주제1-6)과 시너지.

### 4-4. ArcheType — LLM 기반 오픈소스 컬럼 타입 주석
- **무엇인가:** LLM으로 컬럼 타입 주석(CTA)을 하는 프레임워크. 컨텍스트 샘플링·라벨 재매핑 등으로 학습 없이 신규 타입 대응.
- **출처:** Feuer 외, "ArcheType: A Novel Framework for Open-Source Column Type Annotation using Large Language Models", 2023. arXiv:2310.18208 — https://arxiv.org/html/2310.18208
- **하네스 적용(적용도 High):** 후니처럼 **커스텀 타입(siz_cd, mat_cd, 도수, 판형)** 은 학습 데이터가 없으므로, LLM에 타입 정의+예시 몇 개만 주고 zero/few-shot으로 컬럼 의미를 붙이는 방식이 현실적. 단, 결과는 프로파일링으로 검증(환각 가드).

### 4-5. LLM 기반 스키마 추론 (2025)
- **무엇인가:** LLM으로 테이블에서 **개념 스키마**(엔티티·속성·FK 관계)를 추론. 다단계 파이프라인 — 컬럼 의미 분석 → 관계 발굴(FK) → 스키마 정제(반복 검증) → 기존 지식원 통합.
- **출처:** Wu, Chen, Paton, "Conceptual Schema Inference for Tabular Datasets using Large Language Models", 2025. arXiv:2509.04632 — https://www.arxiv.org/pdf/2509.04632
- **하네스 적용(적용도 High):** 우리 하네스 목표와 가장 근접한 최신 연구. **핵심 = LLM 단독이 아니라 "LLM 추론 + 반복 검증/정제 루프"**. 후니 하네스의 "생성≠검증" 원칙(생성=LLM, 검증=결정론 재실측/게이트)과 정확히 일치.

---

## 주제 5. LLM 에이전트가 스프레드시트를 다루는 법

### 5-1. SheetCopilot — 원자 액션 + 상태머신 계획
- **무엇인가:** 스프레드시트 기능을 **원자 액션(atomic action)** 으로 추상화하고, LLM이 상태머신 기반 계획으로 표를 조작. 시트 상태 관찰 + 오류 피드백으로 해답을 다듬음. 221개 태스크 벤치마크.
- **출처:** Li 외, "SheetCopilot: Bringing Software Productivity to the Next Level through Large Language Models", NeurIPS 2023. https://proceedings.neurips.cc/paper_files/paper/2023/hash/0ff30c4bf31db0119a6219e0d250e037-Abstract-Conference.html
- **하네스 적용(적용도 High):** 하네스 설계 원칙 2개 = ① 엑셀 조작/매핑을 **원자 액션 집합**으로 정의(추출/파싱/unpivot/타입판정/키발굴/DDL생성/적재), ② **상태 관찰 → 실행 → 오류 피드백 → 재시도** 폐루프. 후니의 DRY-RUN→검증→재시도 게이트가 이 폐루프의 구현.

### 5-2. LLMs on Tabular Data — 서베이 (한계 정리)
- **무엇인가:** LLM×표(예측·생성·이해) 전반 서베이. 핵심 난제 = **표 직렬화(serialization)** — 표마다 구조가 달라 텍스트로 순차 변환하기 어렵다.
- **출처:** Fang 외, "Large Language Models(LLMs) on Tabular Data: Prediction, Generation, and Understanding — A Survey", 2024. arXiv:2402.17944 — https://arxiv.org/abs/2402.17944
- **하네스 적용(적용도 Medium):** 표를 LLM에 넣는 "직렬화 방식"이 성능을 좌우 — 마크다운/CSV/앵커압축 중 무엇을 쓸지 실험으로 정하라. 단일 정답 없음.

---

## 안티패턴 / 한계 (연구가 경고하는 것)

1. **엑셀 통째로 LLM에 넣기 = 토큰 폭발.** SpreadsheetLLM이 압축 없이는 실패함을 실증(압축으로 96% 절감). → 반드시 구조 앵커 압축·영역 집계 후 투입. (arXiv:2407.09025)
2. **LLM 스키마/타입 추론은 환각한다.** 값에 없는 컬럼 의미·존재하지 않는 FK를 지어냄. → 프로파일링(UCC/IND/FD)으로 **후보를 데이터에서 확정**하고 LLM은 판단만. (Abedjan 서베이 + Wu 2025의 "반복 검증" 강조)
3. **병합셀·소계행·계산셀을 데이터로 오인.** GroupHeader/Derived 셀을 Data로 넣으면 합계가 데이터로 중복 적재됨. → Koci 5분류로 셀 역할부터 태깅. (Koci et al. / DECO)
4. **매트릭스(크로스탭)를 그대로 컬럼 매핑하면 차원이 뭉개진다.** 사이즈×수량 매트릭스를 안 펴고 넣으면 축이 사라져 단가행이 collapse(후니 실증: 명함 자재·아크릴 사례). → 반드시 unpivot 후 (키,키,값) 롱포맷.
5. **단일 도구/모델 맹신 금지.** 표 레이아웃은 자유도가 너무 커서(Koci) 한 방법이 모든 표를 못 잡음. IND도 13개 알고리즘이 강약이 갈림(Dürsch 2019). → 규칙+통계+LLM 앙상블, 표 종류별 라우팅.
6. **머리글 계층을 무시하면 부모 컨텍스트 손실.** [대분류>세부] 중첩 머리글에서 대분류를 버리면 세부 사이즈의 소속을 잃음(Senbazuru/TUTA). → 병합범위로 계층 복원 후 부모를 자식에 전파.

---

## 하네스 설계 권고 Top 5 (구체적·실행가능)

### 권고 1 — 파이프라인을 "결정론 프로파일링 먼저, LLM은 의미부여만"으로 이층 분리
- **단계:** (a) 셀 역할 분류(Koci 5분류: Header/Data/GroupHeader/Derived/Title/Note) → (b) 표 영역·머리글 경계 확정 → (c) 매트릭스면 unpivot → (d) **결정론 프로파일링**(컬럼별 타입·null·유일성, UCC=PK후보, IND=FK후보, FD=정규화힌트) → (e) LLM으로 컬럼 의미 주석·모호 해소·엔티티 명명 → (f) 스키마 초안 → (g) DDL/적재코드 생성 → (h) DRY-RUN 검증 게이트.
- **근거:** Abedjan 서베이(3-1)+Metanome(3-2)로 후보를 데이터에서 확정, Wu 2025(4-5)·ArcheType(4-4)로 의미만 LLM. 후니 "생성≠검증"과 정합.

### 권고 2 — 매트릭스(크로스탭) 자동 감지 → unpivot을 1급 액션으로
- **실행:** "행머리글+열머리글 둘 다 있고 교차셀이 값"이면 매트릭스로 판정하고 `(row_key, col_key, value)` 롱포맷으로 자동 변환. 다층 머리글은 병합셀 범위로 트리 복원 후 부모키를 각 값행에 전파.
- **근거:** 주제 2 전체(Table Header Detection AAAI 2012, 특허 변환, Senbazuru, TUTA). 후니 가격표→`component_prices` 단가행이 정확히 이 형태. 안티패턴 4·6 회피.

### 권고 3 — 셀 역할 온톨로지를 표준 태그로 고정하고, 서식 신호를 근거로 사용
- **실행:** 모든 셀에 {Header, Data, GroupHeader, Derived, Title, Note, Merged} 태그. **병합셀·굵기·색상·들여쓰기**를 머리글/계층/소계 판정 피처로 명시적으로 추출해 LLM 프롬프트에 함께 제공.
- **근거:** DeExcelerator(1-2), Koci/DECO(1-3), Senbazuru(2-3) 모두 서식=구조 신호임을 실증. 소계·계산셀 오적재(안티패턴 3) 방지.

### 권고 4 — 대용량 시트는 "구조 앵커 압축"으로 LLM에 투입
- **실행:** 머리글 행/열과 경계·타입 전이 지점(앵커)만 원문으로, 반복 데이터 영역은 `범위=타입·값역` 형태로 집계해 넣는다(SheetCompressor 3모듈). 컬럼 의미판정은 표 전체 맥락과 함께(Sato).
- **근거:** SpreadsheetLLM/SheetCompressor(1-6, 토큰 96%↓), Sato(4-2), Doduo(4-3, 8토큰으로도 충분). 안티패턴 1(토큰 폭발) 정면 해결. 후니 기존 "결정론 배치 diff 토큰0" 철학과 결합.

### 권고 5 — 원자 액션 + 상태관찰·오류피드백 폐루프 + 예시기반 동형 전파
- **실행:** 하네스를 원자 액션(추출/파싱/unpivot/타입판정/키발굴/DDL/적재)으로 구성하고, 각 단계마다 상태 관찰→실행→검증→오류시 재시도. **대표 표 1개를 사람이 정답 매핑(few-shot)** 하면 동형 표들에 규칙을 자동 전파(FlashRelate 방식).
- **근거:** SheetCopilot(5-1, 원자액션+상태머신+피드백), FlashRelate(2-2, 예시기반 전파), TabbyXL(2-4, 규칙 재현성). 후니 "대표 파일럿→동형 전파" 전략의 학술 뒷받침.

---

## 부록 — 확인한 출처 목록 (23건)

| # | 논문/시스템 | 저자·연도 | URL |
|---|---|---|---|
| 1 | TableSense | Dong 외, AAAI 2019 | arXiv:2106.13500 |
| 2 | DeExcelerator | Eberius 외, CIKM 2013 | dl.acm.org/doi/10.1145/2505515.2508210 |
| 3 | Koci 레이아웃 추론 / DECO | Koci 외, 2018 | link.springer.com/chapter/10.1007/978-3-319-99701-8_4 |
| 4 | TabularNet | Du 외, KDD 2021 | arXiv:2106.03096 |
| 5 | TUTA | Wang 외, KDD 2021 | arXiv:2010.12537 |
| 6 | SpreadsheetLLM/SheetCompressor | Dong·Tian 외(MS), EMNLP 2024 | arXiv:2407.09025 |
| 7 | Layout Templates in Multiregion Files | Vitagliano 외, VLDB 2022 | vldb.org/pvldb/vol15/p646-vitagliano.pdf |
| 8 | Table Header Detection and Classification | Fang 외, AAAI 2012 | clgiles.ist.psu.edu/pubs/AAAI2012-table-header.pdf |
| 9 | FlashRelate | Barowy 외, PLDI 2015 | microsoft.com FlashRelate tech report |
| 10 | Senbazuru | Chen·Cafarella, VLDB 2013 | dl.acm.org/doi/abs/10.14778/2536274.2536276 |
| 11 | TabbyXL | Shigarov 외, 2019 | link.springer.com/chapter/10.1007/978-3-030-30275-7_6 |
| 12 | Profiling relational data: a survey | Abedjan·Golab·Naumann, VLDB J. 2015 | link.springer.com/article/10.1007/s00778-015-0389-y |
| 13 | Metanome | Papenbrock 외, VLDB 2015 | vldb.org/pvldb/vol8/p1860-papenbrock.pdf |
| 14 | IND 13-알고리즘 평가 | Dürsch 외, CIKM 2019 | github.com/HPI-Information-Systems/inclusion-dependency-algorithms |
| 15 | Normalized Schema from Nested KV | DiScala·Abadi, SIGMOD 2016 | dl.acm.org/doi/10.1145/2882903.2882924 |
| 16 | Sherlock | Hulsebos 외, KDD 2019 | arXiv:1905.10688 |
| 17 | Sato | Zhang 외, VLDB 2020 | vldb.org/pvldb/vol13/p1835-zhang.pdf |
| 18 | Doduo (Annotating Columns w/ PLMs) | Suhara 외, SIGMOD 2022 | arXiv:2104.01785 |
| 19 | ArcheType | Feuer 외, 2023 | arXiv:2310.18208 |
| 20 | LLM Conceptual Schema Inference | Wu·Chen·Paton, 2025 | arXiv:2509.04632 |
| 21 | SheetCopilot | Li 외, NeurIPS 2023 | proceedings.neurips.cc/.../2023 |
| 22 | LLMs on Tabular Data (Survey) | Fang 외, 2024 | arXiv:2402.17944 |
| 23 | FUSE 스프레드시트 코퍼스 | Barik 외 | (Koci 검색 경유 확인) |

> `미확인`: FUSE 코퍼스(#23)는 제목·저자만 확인, 원문 미열람. Doduo·ArcheType의 세부 수치는 서베이/초록 기준(원문 재확인 권장).
