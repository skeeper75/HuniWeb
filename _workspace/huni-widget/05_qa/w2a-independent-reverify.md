# W2-a 독립 재검증 노트 (hw-qa)

**일자:** 2026-06-04 | **대상:** SUB_MTR 이중의미 평면화(A-2) 보정, 미커밋 워킹트리
**판정: GO**

## 직접 재수집한 증거 (builder 자기보고 미신뢰)

### 1. 게이트 (내 손으로 재실행)
- `npx tsc --noEmit` → exit 0 (clean)
- `npx vitest run` → **150 passed (17 files)**, 0 failed (builder 주장 150 일치)
- `npx vite build` → built in 751ms, 173 modules OK

### 2. INV-3 git 증명 (직접)
- `git diff src/widget src/contract` → **0줄** (직접 wc -l 확인)
- `git diff --stat` 변경 4파일: red-adapter.ts(+29), red-types.ts(+4), parity-crossverify.test.ts(+32), .omc state(비코드)
- red-types.ts 변경 = `RedPcsInfo.MTRL_CD?` 추가만 = **Red 원시 shape 타입**(계약/위젯 아님). 정당.

### 3. discriminator 날조 아님 (fixture 실측)
- ACPDSTD pdt_pcs_info SUB_MTR = **12엔트리, 전부 MTRL_CD 비어있지않음(SXAPR005..016), 12 distinct, ATTB_CD 전부 None** → material-multi=true ✓
- AIPPCUT SUB_MTR = **4엔트리, 전부 MTRL_CD="", ATTB_CD None** → allHaveMtrl=false → material-multi=false ✓
- discriminator(allHaveMtrl && distinct≥2 && noAttbCd)가 둘을 올바르게 가름. 실데이터 기반.

### 4. 경계 케이스 probe (합성 fixture traverse)
- ATTB_CD 보유 SUB_MTR → noAttbCd=false → material-multi 아님 → attbCd echo 경로 (L-1 shape b 정합) ✓
- 단일 distinct MTRL_CD SUB_MTR → distinct<2 → material-multi 아님 → quantity echo. **문서화된 한계**(현 데이터 미발생, 잠복 edge). 차단 아님.
- DFXXX 플레이스홀더(MTRL_CD="")는 pdt_pcs_info SUB_MTR 그룹에 미포함(PCS_CD=SUB_MTR 그룹 = 12 clean). 초기 CASE3 오탐(다른 컨테이너 mutate)은 철회.

### 5. field-for-field (내 vite-node serialize walk, fixture 룩업 아님)
- ACPDSTD material-multi reqBody: `{PCS_COD:"SUB_MTR", PCS_DTL_COD:"AB005", ATTB:"", ATTB_2:"", ATTB_3:""}` → ATTB="" (deob_07:2162 권위) ✓
- AIPPCUT 단일 add-on qty=1: ATTB="1"/ATTB_2=""/ATTB_3="" (b1_AIPPCUT 캡처 shape) ✓; qty=13 → ATTB="13" (echo scale 보존) ✓

### 6. 회귀·정직성
- W1: PDT_WRK가 QUANTITY_ECHO_PCS 미포함(W1-b 유지) + PDT_WRK→ATTB="" 통과. WRK_MTR/DIR_MTR characterization 보존. mb_cust_cod 가드 무손상.
- W2-b(INN_DFT) 이연 타당: fixture 0개 보유(grep 확인) → 보정 근거 부재, 정직 보류.
- material-multi ATTB_2/ATTB_3 빈슬롯("")은 엔트리가 여전히 QUANTITY_ECHO_PCS 멤버라 serialize 617/619 발화. 권위 미입증이나 빈문자열=무해, builder 정직 표기됨.

## 잔존·미검증 (은폐 없음)
- ACPDSTD 가격경로 캡처 0건 → ATTB="" "올바름"은 deob 권위에만 의존(캡처 반증 부재). 보정은 캡처 밖 값 주입 아님(빈문자열은 권위값).
- 단일-distinct material SUB_MTR edge는 미커버(현 데이터 미발생).
- 새 미검증 권위 생성 = **0건**. 새 부채 = 0.
