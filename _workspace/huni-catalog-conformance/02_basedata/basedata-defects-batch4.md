# basedata-defects-batch4.md — 굿즈파우치 기초데이터 8축 결함 보드 (생성측)

> 검사: hcc-basedata-inspector · 라이브 읽기전용 SELECT 실측 2026-06-23 · DB 미적재 · 게이트 재실측 대상.
> 권위[HARD]: 상품마스터(260610) 굿즈파우치 시트 + 가격표(260527). 라이브=교정 대상. 3원 대조(권위 엑셀↔라이브↔도메인).
> 모집단: 라이브 98 prd(PRD_000183~280·del_yn=N). 784 basedata 셀 전수(빈 셀 0).

## 0. 결함 요약 (302건 / 784셀)

| 축 | verdict | 건수 | 핵심 |
|----|---------|:---:|------|
| 판형 | EXTRA | 85 | ★C-GP-3 작업/재단 사이즈가 plate_sizes에 오적재(전지 없음·output_paper_typ_cd=NULL) |
| 자재 | MISMATCH | 76 | ★자재축 오염: 옵션값(사이즈등급·면·구수·색)이 본체소재로 혼입 |
| 자재 | MISSING | 22 | 본체 소재 자체 미적재(카드거울·투명부채·말랑류 등) |
| 도수 | MISSING | 98 | print_options 전건 미적재(인쇄면 variant 부재) |
| 사이즈코드 | MISSING | 54 | variant 사이즈등급 미적재(일부는 plate_sizes로 오적재) |
| 묶음수 | MISSING | 64 | N구/팩 미적재(일부 구수는 materials로 오적재·GAP-COUNT) |
| 공정·인쇄옵션 | MISSING | 1+1 | 미니우치와키링(PRD_000227) 에폭시 가공 미적재 |

**돈크리티컬: 0건(현재).** 가격 미바인딩(price_engine 전건 MISSING)이라 과대청구 base 자체가 없음.
단 적재 시점에 자재 오염·plate 잔재를 정리하지 않으면 차원 환원 오류→오청구 신규 발생 위험(GP-2 평탄화 가드).

## 1. 판형 EXTRA (85) — C-GP-3 잔재 [중점]

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000183 | 틴거울 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000184 | 컴팩트거울 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000185 | 카드거울 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000186 | 사각손거울 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000187 | 블랙사각손거울 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000188 | 레더코스터 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000189 | 코르크코스터 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000190 | 우드코스터 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000191 | 린넨패브릭코스터 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000192 | 규조토코스터 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000193 | 머그컵 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000194 | 워터북보틀 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000195 | 벨벳쿠션 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000196 | 레더여권케이스 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000197 | 미니매트 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000198 | 피크닉매트 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000200 | 핀버튼 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000201 | 레더스트랩키링 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000205 | 양말 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000206 | 반팔티셔츠 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000209 | 후드티셔츠 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000210 | 초슬림마우스패드 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000211 | 장패드 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000212 | 극세사클리너 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000213 | 틴케이스 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000214 | 자석북마크 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000215 | 클립보드 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000216 | 투명클립보드 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000219 | 밴드톡 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000220 | 폰스트랩 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000221 | 말랑키링 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000223 | 말랑포카홀더 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000224 | 말랑네임택 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000225 | 말랑여권케이스 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000230 | 레더 플랫 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000231 | 레더 슬림 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000232 | 레더 삼각 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000233 | 레더 볼륨 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000234 | 레더 스트링 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000235 | 레더 스트링 원형파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000236 | 레더 플랫 클러치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000237 | 레더 삼각 클러치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000238 | 레더 아이패드/노트북 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000239 | 캔버스 플랫 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000240 | 캔버스 삼각 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000241 | 캔버스 스트랩 라벨파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000242 | 광목 스트링 라벨파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000243 | 린넨 스트링 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000244 | 타이벡 플랫 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000245 | 타이벡 슬림 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000246 | 타이벡 삼각 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000247 | 타이벡 스트링 파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000248 | 타이벡 플랫 클러치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000249 | 메쉬슬림파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000250 | 메쉬볼륨파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000251 | 레더 플랫 미니파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000252 | 레더 슬림 미니파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000253 | 레더 삼각 미니파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000254 | 레더 볼륨 미니파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000255 | 레더 원형 미니파우치 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000256 | 레더 플랫 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000257 | 레더 슬림 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000258 | 레더 삼각 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000259 | 레더 볼륨 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000260 | 레더 원형 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000261 | 캔버스 플랫 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000262 | 캔버스 삼각 필통 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000263 | 레더토트백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000264 | 레더숄더백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000265 | 린넨 미니에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000266 | 린넨 토트백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000267 | 린넨 에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000268 | 캔버스심플백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000269 | 캔버스 포켓심플백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000270 | 캔버스에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000271 | 캔버스숄더백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000272 | 캔버스 포켓숄더백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000273 | 타이벡 양면 백팩 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000274 | 타이벡보냉보틀백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000275 | 타이벡 보냉 미니백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000276 | 타이벡 에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000277 | 타이벡 보냉에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000278 | 메쉬 토트백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000279 | 메쉬에코백 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |
| PRD_000280 | 레더라벨제작 | plate_sizes 잉여 적재(작업/재단 사이즈가 판형에) | plate_sizes 0행(전지 없음) | dbm-axis-staged-load 정리(plate→sizes 이관 또는 삭제) |

재현 SQL(전건): `SELECT prd_cd,siz_cd,output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280' AND del_yn='N';`
→ 85 prd·122행 전부 output_paper_typ_cd=NULL이고 siz_cd가 작업/재단 사이즈(57x91·85x140 등). 굿즈=전지 출력 없음→EXTRA 확정.

## 2. 자재 MISMATCH (76) — 자재축 오염 [중점]

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000183 | 틴거울 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000184 | 컴팩트거울 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000188 | 레더코스터 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000189 | 코르크코스터 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000190 | 우드코스터 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000191 | 린넨패브릭코스터 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000192 | 규조토코스터 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000193 | 머그컵 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000194 | 워터북보틀 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000195 | 벨벳쿠션 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000196 | 레더여권케이스 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000197 | 미니매트 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000198 | 피크닉매트 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000201 | 레더스트랩키링 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000202 | 키캡키링 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000203 | LED투명키캡키링 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000204 | 미니CD앨범 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000206 | 반팔티셔츠 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000208 | 슬로건 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000209 | 후드티셔츠 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000213 | 틴케이스 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000214 | 자석북마크 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000216 | 투명클립보드 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000217 | 만년스탬프 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000220 | 폰스트랩 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000226 | 아크릴쉐이커코롯토 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000227 | 미니우치와키링 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000228 | 하트 이미지피켓 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000229 | 이미지피켓 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000230 | 레더 플랫 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000231 | 레더 슬림 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000232 | 레더 삼각 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000233 | 레더 볼륨 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000234 | 레더 스트링 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000235 | 레더 스트링 원형파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000236 | 레더 플랫 클러치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000237 | 레더 삼각 클러치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000238 | 레더 아이패드/노트북 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000239 | 캔버스 플랫 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000240 | 캔버스 삼각 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000241 | 캔버스 스트랩 라벨파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000243 | 린넨 스트링 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000244 | 타이벡 플랫 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000245 | 타이벡 슬림 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000246 | 타이벡 삼각 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000247 | 타이벡 스트링 파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000249 | 메쉬슬림파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000250 | 메쉬볼륨파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000251 | 레더 플랫 미니파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000252 | 레더 슬림 미니파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000253 | 레더 삼각 미니파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000254 | 레더 볼륨 미니파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000255 | 레더 원형 미니파우치 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000256 | 레더 플랫 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000257 | 레더 슬림 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000258 | 레더 삼각 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000259 | 레더 볼륨 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000260 | 레더 원형 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000261 | 캔버스 플랫 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000262 | 캔버스 삼각 필통 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000263 | 레더토트백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000264 | 레더숄더백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000265 | 린넨 미니에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000266 | 린넨 토트백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000267 | 린넨 에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000268 | 캔버스심플백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000269 | 캔버스 포켓심플백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000270 | 캔버스에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000271 | 캔버스숄더백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000272 | 캔버스 포켓숄더백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000273 | 타이벡 양면 백팩 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000274 | 타이벡보냉보틀백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000276 | 타이벡 에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000277 | 타이벡 보냉에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000278 | 메쉬 토트백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |
| PRD_000279 | 메쉬에코백 | 옵션값 혼입(사이즈등급/면/구수/색) | 본체 소재만(레더/캔버스 등) | dbm-axis-staged-load 자재 정규화(옵션값→해당 축 이관) |

재현 SQL: `SELECT pm.prd_cd, string_agg(m.mat_nm,' / ') FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280' AND pm.del_yn='N' GROUP BY pm.prd_cd;`
→ 예: PRD_000202 키캡키링 materials=`2구/3구/4구`(=묶음수), PRD_000206 반팔티 materials=`블랙 M/화이트 L...`(=사이즈+색), PRD_000220 폰스트랩 materials=`단면/양면`(=도수). 본체소재 아닌 옵션값 혼입.

## 3. 자재 MISSING (22)

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000185 | 카드거울 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000186 | 사각손거울 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000187 | 블랙사각손거울 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000199 | 투명부채 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000200 | 핀버튼 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000205 | 양말 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000207 | 극세사타월 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000210 | 초슬림마우스패드 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000211 | 장패드 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000212 | 극세사클리너 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000215 | 클립보드 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000218 | 타이벡북커버 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000219 | 밴드톡 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000221 | 말랑키링 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000222 | 말랑증사홀더 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000223 | 말랑포카홀더 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000224 | 말랑네임택 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000225 | 말랑여권케이스 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000242 | 광목 스트링 라벨파우치 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000248 | 타이벡 플랫 클러치 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000275 | 타이벡 보냉 미니백 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |
| PRD_000280 | 레더라벨제작 | 본체 소재 미적재 | 본체 자재 1행(usage_cd=USAGE.07) | dbm-axis-staged-load 자재 재적재 |

## 4. 사이즈코드 MISSING (54)

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000183 | 틴거울 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000184 | 컴팩트거울 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000188 | 레더코스터 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000189 | 코르크코스터 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000190 | 우드코스터 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000191 | 린넨패브릭코스터 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000192 | 규조토코스터 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000193 | 머그컵 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000194 | 워터북보틀 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000195 | 벨벳쿠션 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000200 | 핀버튼 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000201 | 레더스트랩키링 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000203 | LED투명키캡키링 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000204 | 미니CD앨범 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000208 | 슬로건 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000213 | 틴케이스 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000214 | 자석북마크 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000216 | 투명클립보드 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000220 | 폰스트랩 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000221 | 말랑키링 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000226 | 아크릴쉐이커코롯토 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000227 | 미니우치와키링 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000228 | 하트 이미지피켓 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000229 | 이미지피켓 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000230 | 레더 플랫 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000231 | 레더 슬림 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000232 | 레더 삼각 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000233 | 레더 볼륨 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000234 | 레더 스트링 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000238 | 레더 아이패드/노트북 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000239 | 캔버스 플랫 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000240 | 캔버스 삼각 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000243 | 린넨 스트링 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000244 | 타이벡 플랫 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000245 | 타이벡 슬림 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000246 | 타이벡 삼각 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000247 | 타이벡 스트링 파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000249 | 메쉬슬림파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000250 | 메쉬볼륨파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000252 | 레더 슬림 미니파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000254 | 레더 볼륨 미니파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000255 | 레더 원형 미니파우치 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000264 | 레더숄더백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000267 | 린넨 에코백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000268 | 캔버스심플백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000269 | 캔버스 포켓심플백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000270 | 캔버스에코백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000271 | 캔버스숄더백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000273 | 타이벡 양면 백팩 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000274 | 타이벡보냉보틀백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000276 | 타이벡 에코백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000277 | 타이벡 보냉에코백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000278 | 메쉬 토트백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |
| PRD_000279 | 메쉬에코백 | variant 사이즈 미적재(일부 plate_sizes로 오적재) | 옵션 사이즈등급 siz | dbm-axis-staged-load sizes 적재(plate→sizes 이관) |

## 5. 묶음수 MISSING (64) — GAP-COUNT

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000183 | 틴거울 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000184 | 컴팩트거울 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000186 | 사각손거울 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000187 | 블랙사각손거울 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000188 | 레더코스터 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000189 | 코르크코스터 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000190 | 우드코스터 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000191 | 린넨패브릭코스터 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000192 | 규조토코스터 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000193 | 머그컵 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000194 | 워터북보틀 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000195 | 벨벳쿠션 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000197 | 미니매트 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000200 | 핀버튼 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000201 | 레더스트랩키링 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000202 | 키캡키링 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000203 | LED투명키캡키링 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000204 | 미니CD앨범 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000208 | 슬로건 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000213 | 틴케이스 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000214 | 자석북마크 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000215 | 클립보드 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000216 | 투명클립보드 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000217 | 만년스탬프 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000218 | 타이벡북커버 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000220 | 폰스트랩 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000221 | 말랑키링 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000226 | 아크릴쉐이커코롯토 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000227 | 미니우치와키링 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000228 | 하트 이미지피켓 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000229 | 이미지피켓 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000230 | 레더 플랫 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000231 | 레더 슬림 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000232 | 레더 삼각 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000233 | 레더 볼륨 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000234 | 레더 스트링 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000238 | 레더 아이패드/노트북 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000239 | 캔버스 플랫 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000240 | 캔버스 삼각 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000241 | 캔버스 스트랩 라벨파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000242 | 광목 스트링 라벨파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000243 | 린넨 스트링 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000244 | 타이벡 플랫 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000245 | 타이벡 슬림 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000246 | 타이벡 삼각 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000247 | 타이벡 스트링 파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000249 | 메쉬슬림파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000250 | 메쉬볼륨파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000252 | 레더 슬림 미니파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000254 | 레더 볼륨 미니파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000255 | 레더 원형 미니파우치 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000264 | 레더숄더백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000267 | 린넨 에코백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000268 | 캔버스심플백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000269 | 캔버스 포켓심플백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000270 | 캔버스에코백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000271 | 캔버스숄더백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000273 | 타이벡 양면 백팩 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000274 | 타이벡보냉보틀백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000276 | 타이벡 에코백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000277 | 타이벡 보냉에코백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000278 | 메쉬 토트백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000279 | 메쉬에코백 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |
| PRD_000280 | 레더라벨제작 | 묶음수(구수/팩) 미적재(일부 구수는 materials로 오적재) | bundle_qtys bdl_qty | dbm-axis-staged-load 묶음수 적재 |

## 6. 공정 MISSING (1)

| prd_cd | 상품명 | 증상 | 권위 정답 | 라우팅 |
|--------|--------|------|----------|--------|
| PRD_000227 | 미니우치와키링 | 에폭시 가공 미적재 | 가공 공정 1행 | dbm-axis-staged-load 공정 적재 |

## 8. CONFIRM 큐 (권위 충돌·인간 확인)

| ID | 쟁점 | 인스펙터 판정 | 라우팅 |
|----|------|--------------|--------|
| C-GP-3 | 판형 85 EXTRA | **EXTRA 확정** — 122행 전부 output_paper_typ_cd=NULL·siz_cd=작업/재단사이즈. 굿즈=전지 없음 | dbm-axis-staged-load: plate→sizes 이관 또는 삭제 |
| C-GP-5 | 구수가 묶음수축인가 | **묶음수축 확정**(도메인) — 키캡 2~4구=개수 단위. 단 현재 materials(2구/3구/4구)로 오적재·bundle_qtys 미적재 | dbm-ddl-proposer/axis-staged-load: 구수→bundle_qtys 이관 |
| C-GP-4 | 가공 가산 개당 vs 1회 | **BLOCKED**(가격 미바인딩) — 가공 6 적재됐으나 가산 단가 없음. 적재 시점 판별 | dbm-price-arbiter 심의(Q-GP-FIN1) |
| C-GP-1 | 폰케이스 5종 | **검증 제외** — 라이브 미등록(존재 안 함). 8축 셀 대상 아님 | round-24 상품 등록 선행 |

## 9. 자재축 오염 = plate/사이즈/묶음 잔재의 공통 진원

round-22 6축 staged 적재가 굿즈의 옵션값을 축별로 분리하지 못하고 자재(USAGE.07)·plate_sizes에 평탄 적재한 결과:
- 사이즈등급(S/M/L) → 일부 sizes(11)·일부 plate_sizes(85)·일부 materials(76)에 산재
- 면(단/양면) → materials·향후 print_options(0)로 가야 함
- 구수(2~4구) → materials·향후 bundle_qtys(1)로 가야 함
교정 진원=상류 v03 입력 분해 규칙. **본 하네스 직접 교정 금지** — dbm-axis-staged-load 트랙(경로 Y·교정 엑셀 재적재)에 라우팅. 기초코드 마스터(t_mat/t_siz) 수정 금지(공유자원).