# 규칙으로 못 가른 선행조건 원문 (`precondition`)

- 총 `precondition` 보유 행 104 · 규칙 매칭 58 · **미매칭 46**
- 미매칭은 「의존 없음」이 아니라 **기계 규칙으로 못 가른 것**이다. 사람이 읽고 판정해야 한다.

| legacy_id | precondition 원문 | 근거 |
|---|---|---|
| F-070 | 대량견적 사용자측 IA 보완 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:71 |
| F-116 | 대량견적 사용자측 IA 보완 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:117 |
| F-137 | 파일 검수 기준 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:138 |
| F-146 | 등급별 할인 정책 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:147 |
| F-152 | 국세청/팝빌 연동 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:153 |
| F-153 | 카테고리 구조 확정 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:154 |
| F-154 | 검색 대상·필터축 정의 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:155 |
| F-156 | 자동발급 룰 정의 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:157 |
| F-157 | MES↔Front 통신 규격 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:158 |
| F-159 | 파일명 규칙 확정 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:160 |
| F-161 | 주문상태머신 정의 | _workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv:162 |
| SCOPE-033 | 상품 종류마다 옵션 구성이 달라 상품별 옵션목록을 제공해야 함 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:34 |
| SCOPE-035 | 가로×세로 직접입력 시 면적으로 가격 계산 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:36 |
| SCOPE-048 | 옵션끼리의 규칙(같이 못 고르는 조합·조건부 노출)을 데이터로 정리해야 함 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:49 |
| SCOPE-049 | 상품 종류별로 가격 계산 방식이 다름 (장수기준·면적기준·단가기준) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:50 |
| SCOPE-055 | 디자인 편집기에 딸린 기능 (후순위) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:56 |
| SCOPE-056 | 자료는 인쇄팀, 화면은 쇼핑팀이 함께 작업 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:57 |
| SCOPE-062 | 주문수량은 1로 두고 총액을 옵션 금액으로 처리 (쇼핑몰 연동 방식) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:63 |
| SCOPE-070 | 대량주문 견적 화면이 고객용에도 필요 (현재 빠짐) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:71 |
| SCOPE-116 | PM: 대량견적 사용자측 IA 보완 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:117 |
| SCOPE-137 | 인쇄팀이 정한 파일 검수 기준 필요 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:138 |
| SCOPE-145 | 소셜 OAuth 앱등록·검수 (PM) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:146 |
| SCOPE-146 | 등급별 할인·등급가 정책 (PM) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:147 |
| SCOPE-147 | 개인정보보호법 1년 미접속 의무 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:148 |
| SCOPE-149 | 네이버페이 가맹 (PM) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:150 |
| SCOPE-152 | 국세청/팝빌 연동·사업자정보 동의 (PM) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:153 |
| SCOPE-153 | 카테고리 구조 확정 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:154 |
| SCOPE-154 | 검색 대상·필터축 정의 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:155 |
| SCOPE-155 | 진열 운영정책 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:156 |
| SCOPE-156 | 자동발급 룰 정의 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:157 |
| SCOPE-157 | MES↔Front 통신 규격 (PM) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:158 |
| SCOPE-158 | 라이브 16/275만 채번됨(실측) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:159 |
| SCOPE-159 | 파일명 규칙 확정 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:160 |
| SCOPE-160 | 인쇄공정 파일 기준 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:161 |
| SCOPE-161 | 주문상태머신 정의 | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:162 |
| SCOPE-162 | 라이브 주문테이블 전무(실측·to-be) | _workspace/huni-launch-scope/01_foundation/ia-feature-canon.csv:163 |
| IA-033 | 상품 종류마다 옵션 구성이 달라 상품별 옵션목록을 제공해야 함 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A34:K34 |
| IA-035 | 가로×세로 직접입력 시 면적으로 가격 계산 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A36:K36 |
| IA-048 | 옵션끼리의 규칙(같이 못 고르는 조합·조건부 노출)을 데이터로 정리해야 함 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A49:K49 |
| IA-049 | 상품 종류별로 가격 계산 방식이 다름 (장수기준·면적기준·단가기준) | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A50:K50 |
| IA-055 | 디자인 편집기에 딸린 기능 (후순위) | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A56:K56 |
| IA-056 | 자료는 인쇄팀, 화면은 쇼핑팀이 함께 작업 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A57:K57 |
| IA-062 | 주문수량은 1로 두고 총액을 옵션 금액으로 처리 (쇼핑몰 연동 방식) | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A63:K63 |
| IA-070 | 대량주문 견적 화면이 고객용에도 필요 (현재 빠짐) | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A71:K71 |
| IA-116 | PM: 대량견적 사용자측 IA 보완 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A117:K117 |
| IA-137 | 인쇄팀이 정한 파일 검수 기준 필요 | docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터!A138:K138 |
