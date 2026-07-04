# verify-codex.md — 병합·재배선 매니페스트 codex 독립 2차 교차검증 (Phase 5.5)

> **범위:** 유형 A 병합 9군(27 comp→9) 설계·재배선 매니페스트 + DRY-RUN 9종.
> **codex 가용성:** **AVAILABLE · model=gpt-5.5** · `-s read-only` · workdir=프로젝트 루트 · effort=high · session `019f296b`.
> **독립성:** codex에 Claude/hpe-validator 판정 라벨 비전송(매니페스트 자체 PASS 라벨은 "믿지 말고 재유도"로 지시). codex가 스냅샷 CSV·dry-run SQL·엔진 계약을 **직접 읽고 python 재검증** 후 독립 판정.
> **★경계 [HARD]:** codex 판정 = **가설**. 라이브 Railway DB·webadmin 실화면 재실측 전 사실 채택 금지. codex는 라이브 미조회(스냅샷 2026-07-02 기준). 모든 codex 신규 주장에 `미검증` 태그.

---

## 0. codex 최종 판정 (원문 요지)

**MC-02~09 = GO · MC-01 = 조건부 GO.** 병합·재배선 설계가 가격엔진 계약(pricing.py)과 정합. codex는 스냅샷에서 전군 `print_opt_cd NULL=0`, 병합 후 nat_key 충돌 0, 가격좌표 conflict 0, 골든 대표값 재추출 일치를 **독립 재확인**.

| 군 | codex 판정 | 근거(codex) |
|---|---|---|
| MC-01 PCB | **조건부 GO** | print_opt_cd+opt_cd로 4콤보 disjoint(117×4). 단 라이브 in-place 병합(2026-07-03)은 스냅샷(07-02) 이후라 **문서주장으로만 봄** → 적용 직전 read-only SELECT 재확인 조건 |
| MC-02 PREMIUM | GO | print_opt_cd + mat_cd(MGA/MGB disjoint) |
| MC-03 FOIL | GO | print_opt_cd + opt_cd(일반박/홀로 disjoint) |
| MC-04 WHITE | GO | print_opt_cd + opt_cd(코팅/무코팅 disjoint) |
| MC-05 STD | GO | print_opt_cd 단면/양면 disjoint |
| MC-06 COAT | GO | 동상 |
| MC-07 PEARL | GO | 동상 |
| MC-08 SHAPE | GO | 동상 |
| MC-09 MINISHAPE | GO | 동상 |

codex 필수 게이트(적용 전): `정본+멤버 혼재 0` · `멤버 formula 참조 0` · `정본 nat_key 충돌 0` · `골든 대표값 재계산 0오차`.

---

## 1. reconcile 매트릭스 (codex ↔ Claude 매니페스트)

Claude측 판정 기준선 = 매니페스트 자체 결론(MC-02~09 GO(설계) · MC-01 라이브-이미완료·정합). 별도 gate-verdict 파일 부재 → 매니페스트가 Claude측 산출.

### 합의 (고신뢰 확정)

| 항목 | Claude | codex | 상태 |
|---|---|---|---|
| **병합 안전성(silent 이중합산 불가)** | ERR_AMBIGUOUS 치명차단 + disjoint 타일링 + print_opt_cd NON-NULL | 동일 결론(독립). NULL 와일드카드 행 섞였으면 이미 ERR_AMBIGUOUS 났을 것 | **합의·고신뢰** |
| **골든 재현 0오차** | 병합=comp_cd만 변경·값 verbatim | codex가 스냅샷에서 대표값 **재추출 일치**(MC-02 4500/5000/5500/6500 등) | **합의·고신뢰** |
| **clean-mint 충돌 0·FK 위상** | 정본 9종 미존재·INSERT→UPDATE→fc DELETE/INSERT 순 | 스냅샷 기준 정본 comp_cd 미존재 확인·FK 위상 정합 | **합의·고신뢰** |
| **MC-05 PRF_NAMECARD_FIXED_FOIL 재배선** | 고아공식이나 일관성 위해 재배선 | 옳음. 방치 시 미래 재바인딩 때 비활성 comp 참조 위험 | **합의·고신뢰** |
| **print_opt_cd 잉여축(MC-03/04)** | 무해 잉여축 | 위험 아니라 **보수적 설계**. 제거 시 nat_key 충돌/와일드카드 행 발생 위험 | **합의·고신뢰** |
| **MC-02 bystander 교차합산 없음** | 별개 comp·의도 가산 | proc_cd/dim_vals 게이트로 병합發 교차합산 신규 발생 안 함 | **합의·고신뢰** |
| **comp_nm "단면" cosmetic** | load-bearing 아님·후속 정비 | 가격엔진엔 cosmetic. admin/견적 노출 시 운영혼선 → 후속 정비 권장 | **합의** |

### 불일치 / codex 신규 지적 (조사 신호 · 미검증 가설)

| # | codex 지적 | Claude 매니페스트 | 판별·해소 | 소유자 |
|---|---|---|---|---|
| **D1** | `미검증` dry-run **가드0가 "반쯤 적용된 혼재"(정본행 존재+멤버 잔존)를 방어 못함**. 정상 트랜잭션 전체성공 후 재실행은 멱등이나, **적용 전 "정본 단가행 존재+멤버 잔존 혼재 0" 추가 SELECT 필요** | 멱등 주장(재실행 0)이나 이 특정 부분적용-재개 엣지는 명시 안 함 | **타당·보강 권고.** 저위험(선행 부분적용이 없으면 무관)이나 방어 강화 정당. 적용 스크립트에 혼재-0 사전 SELECT 게이트 추가 | load-executor(적용 단계) |
| **D2** | `미검증` MC-01 라이브 2026-07-03 in-place 병합 상태는 codex가 **직접 조회 못함**(스냅샷 07-02). 적용 직전 read-only SELECT 재확인 조건 | §4/§7에서 **라이브 read-only 재실측·webadmin 실화면 조건 이미 명시** | **진짜 충돌 아님**(프로세스 이미 커버). codex는 라이브 미조회라 조건부 표시. MC-01 라이브 재확인 게이트 유지 | validator/load-executor |
| **D3** | `미검증` 엔진이 `use_yn/del_yn`을 항상 필터한다는 보장 미확인 → MC-01 고아 3멤버 tombstone(117×3 중복본 물리보존) 무해는 **"formula 참조 0"에 의존**. 참조 0 강제 검증이 load-bearing | 고아=배선0·무참조·무해(동일 논리) | **합의 심화.** 실제 안전 근거=엔진이 **공식 배선된 comp_cd의 단가행만 후보풀에 로드**(고아 comp_cd 행은 candidate 진입 불가). "멤버 formula 참조 0" 검증을 게이트로 승격 권고 | validator |

**codex의 어떤 지적도 Claude GO를 뒤집지 않음.** 전부 적용-전 게이트 **추가/승격**(이미 "인간 승인 후 별도 단계" 범위 내). verdict flip 0 · 신뢰도 상승.

---

## 2. reconcile 결론 · 최종 권고 (군별)

| 군 | 병합 후 최종 권고 | 조건 |
|---|---|---|
| MC-01 PCB | **조건부 GO** | 적용 직전 라이브 read-only SELECT로 in-place 병합 현상태(468행·PRF_PCB_FIXED 단일배선·고아3) 재확인 + 멤버 formula 참조 0 강제(D3) |
| MC-02~09 | **GO** | 적용 스크립트에 D1 혼재-0 사전 SELECT 게이트 추가 후 DRY-RUN→인간 승인→webadmin 실화면(PRICE≠0·병합 전후 동일가) |

**공통 필수 게이트(codex+Claude 합의):** ① 정본+멤버 혼재 0(D1) ② 멤버 formula 참조 0(D3) ③ 정본 nat_key 충돌 0 ④ 골든 대표값 재계산 0오차.

**엔진 무변경·DDL 불요** 재확인(codex 독립 동의: 분리축 이미 use_dims·nat_key·NON_QTY_DIMS 등재).

---

## 3. 안전 노트

- codex `-s read-only` 실행(repo/DB 쓰기 0). 자격증명·`.env.local` 프롬프트 비노출.
- codex 판정 = **가설**. D1~D3는 라이브/적용 시점 재실측으로만 확정. 자동 flip 없음·라이브 우선.
- DB 미적재. 실 COMMIT은 게이트 GO + 인간 승인 후 dbm-load-execution 트랙 위임.
- codex 세션 로그(원문 전체): `~/.claude/.../tool-results/b736jh8gz.txt`(session 019f296b).
