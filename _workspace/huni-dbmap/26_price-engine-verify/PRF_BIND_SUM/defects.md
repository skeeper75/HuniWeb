# PRF_BIND_SUM — 결함 보드 (BLOCKING / DEFERRED)

> 작성 2026-06-15 · round-18+ · 클래스 PRF_BIND_SUM(제본 합산형 4상품).
> 분류 기준 = full-class-pipeline-design §3 ("이 결함을 풀지 않으면 다음 케이스/클래스 판정을 내릴 수 있나?" → 못 내림=BLOCKING·내림=DEFERRED).
> 라우팅 + 재검증 기준 포함. DB 미적재·실 적용 인간 승인.

---

## 0. 결함 요약

| ID | 결함 | 패턴 | 분류 | 라우팅 |
|---|---|---|---|---|
| B-WIRE | 공식 PRF_BIND_SUM에 중철 comp만 배선(무선/PUR/트윈링 미배선) | BIND 고유(round-16 단절1 재발견) | 🔴 **BLOCKING** | ddl-proposer/option-mapper + BIND-C1 결정 |
| B-FORMULA | 책자4종 공유 1공식 ↔ 제본방식 상품별 1고정 미스매치 | BIND 고유(round-16 §5.⚠️ 재발견) | 🔴 **BLOCKING** | 공식 설계 A안 vs B안·BIND-C1 |
| D-2 | 제본 선택→comp 멤버십 자리 부재(.08 없음·PROC≠comp·opt_cd NULL) | 횡단(PRF_DGP_A 재발견) | 🟡 **DEFERRED** | 횡단 AQ(option_items+.08)·BIND은 A안으로 완화 가능 |
| B-OPT-070 | PRD_000070 PUR 옵션 레이어 0행 | L2 미적재 | 🟡 **DEFERRED** | L2 적재 트랙(round-6) |

> **값 결함 0** — 단가행 32셀 가격표 전건 일치. 모든 결함은 배선/공식설계/멤버십(구조)이지 값 손상 아님.

## 1. BLOCKING

### B-WIRE — 배선 단절 (3/4 comp 미배선)
- **증거**: `formula_components(PRF_BIND_SUM)` = COMP_BIND_JUNGCHEOL 1행만. 무선/PUR/트윈링 comp 단가행은 8행씩 적재됐으나 공식에 미배선.
- **영향**: 무선책자(069)·PUR책자(070)·트윈링책자(071) = 엔진(evaluate_price) 경로로 제본비 산출 불가. 또는 4상품 모두 중철 단가로 오산출.
- **왜 BLOCKING**: 이걸 안 풀면 3상품(클래스 4상품 중 3) 가격 검증 자체 불가 → 클래스 GO 판정 불가.
- **재검증 기준**: 무선/PUR/트윈링 각자 comp가 공식에 배선되고, recompute가 보정 없이 골든값(G2 50,000·G4 200,000·G5 130,000) 엔진 경로로 재현.

### B-FORMULA — 공식 설계 미스매치
- **증거**: PRF_BIND_SUM 1개를 책자4종이 공유. 제본방식은 상품별 1고정(중철책자→중철)이나 공식엔 중철 comp만.
- **단순 배선 추가로 해결 안 됨**: 1공식에 4 comp 다 배선하면 동시매칭(공식판) = 모든 제본비 합산 오류(round-16 §6).
- **해법 2안(BIND-C1 컨펌)**:
  - **A안(권장)**: 제본방식별 공식 분리 PRF_BIND_<방식>, 각 책자 1:1 바인딩(중철책자→PRF_BIND_JUNGCHEOL…). 동시매칭 0. **BIND은 제본방식 상품고정이라 A안으로 D-2(옵션 멤버십)까지 안 가도 됨.**
  - **B안**: 제본방식을 CPQ 옵션(opt_cd)으로 올려 공식 1개가 선택값으로 comp 1개 매칭(L2 재설계 필요).
- **왜 BLOCKING**: 어느 안인지 정해야 B-WIRE 교정 형태가 확정됨(배선만 추가 ≠ 안전).
- **재검증 기준**: 채택 안에서 4상품 각 제본방식 단가로 골든값 재현·동시매칭 0.

## 2. DEFERRED

### D-2 — 멤버십 자리 부재 (횡단 재발견)
- **재발견 표기**: PRF_DGP_A에서 진단·정립 완료된 횡단 결함(opt_cd 전건 NULL·OPT_REF_DIM .08 부재). 바닥부터 재진단 안 함 → 횡단 트랙(AQ) 연결.
- **BIND 맥락**: 제본방식이 공정(PROC_000018/19/21)으로 적재됐으나 가격 comp(COMP_BIND_*) 연결 자리 없음.
- **왜 DEFERRED**: BIND은 제본방식이 상품별 1고정이라 **B-FORMULA A안(상품별 공식)으로 멤버십을 공식 분리로 해소** 가능 → D-2 옵션 멤버십(.08) 적용 없이도 BIND 클래스 검증 판정 가능. D-2 자체 해소(횡단)는 PRF_DGP_A 가설A 적용과 함께 승인큐.
- **재검증 기준**: 횡단 트랙에서 .08 도입 시 또는 A안 공식분리로 멤버십 결정 0추론 달성.

### B-OPT-070 — PUR 옵션 미적재
- **증거**: PRD_000070 option_groups·option_items 0행.
- **왜 DEFERRED**: 가격 사슬·제본비 재계산과 무관(제본 고정 PUR). L2 옵션 레이어 적재 트랙(round-6) 책임.
- **재검증 기준**: PUR 옵션 레이어 적재 후 L2 정합(다른 형제 책자와 동형).

## 3. 횡단 연결 (재발견 → 트랙)
- **D-2** → 횡단 AQ(PRF_DGP_A AQ-1 가설A·OPT_REF_DIM.08). BIND은 A안 완화 경로 보유.
- **D-1b** → BIND 미해당 확인(단조감소·22 comp 리스트 밖). C-D1b-SCOPE 무관.

## 4. 승인큐 적재 항목 (인간 승인 대기)
| 항목 | 결함 | 정립안 | 트랙 | 상태 |
|---|---|---|---|---|
| AQ-BIND-1 | B-FORMULA+B-WIRE | A안: PRF_BIND_<방식> 4공식 분리 + 1:1 바인딩 + comp 배선 | 공식설계/option-mapper | 컨펌 BIND-C1 후 적용 |
| AQ-BIND-2 | D-2(횡단) | PRF_DGP_A AQ-1 가설A 공유(또는 A안으로 우회) | 횡단 | 적용 대기 |
| AQ-BIND-3 | B-OPT-070 | PUR 옵션 레이어 적재 | round-6 L2 | 적용 대기 |

## 5. 컨펌 (사용자/실무진)
- **BIND-C1 [핵심]**: 공식 모델 A안(제본방식별 공식 분리) vs B안(opt_cd 선택). **권고 A안**(책자는 제본방식 상품고정·동시매칭 0·D-2 우회). round-16 BIND-C1 승계.
- **BIND-C2**: 하드커버/캘린더 제본 comp(7종)는 책자4 범위 밖 — 어느 상품에 바인딩? (round-16 단절2·BIND-C2 승계·본 클래스 외).
- **BIND-C3**: 하드커버 "표지비용 따로 계산" 그릇 위치(별 상품 vs 별 comp) — 본 클래스 외(round-16 승계).
