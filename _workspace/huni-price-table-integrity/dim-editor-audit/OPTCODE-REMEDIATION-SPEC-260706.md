# 옵션코드 정합 교정 스펙 — 키링 repoint · 14중복 · UNIQUE 인덱스 (260706)

> 근거: webadmin `verify_optcode_integrity.py` 결과 + `.planning/quick/260706-vfy` SUMMARY(권위).
> 라이브 DB 쓰기 = 인간승인 + 백업 + DRY-RUN + webadmin 실화면 후. 값 verbatim. 대상 DB=railway(webadmin 도메인).

## Part 1 — 키링 고리 opt_cd 재연결 (매핑 검증 완료)

### 군번줄 명칭 = 확정 (담당자 대기 불필요)
권위 인쇄상품가격표 B04b: **"아크릴키링: 고리없음 0 · 은색구슬줄(군번줄) 300 · 은색고리 1100 · 금색고리 1200"**.
→ 은색구슬줄=군번줄(권위 병기). 라이브 OPV_000627=은색구슬줄=300 일치. 명칭 미해결 아님.

### 재연결 매핑 (값·권위·라이브 3중 검증)
정본 옵션 OPV_000624~627은 PRD_000146 아크릴키링·그룹 OPT_000157에 **이미 등록**(활성)·단가행 0.
현 단가행이 옛/오귀속 코드를 가리킴 → 정본으로 repoint:
| 현 opt_cd(단가행) | 값 | → 정본 opt_cd | 뜻 | 검증 |
|---|---|---|---|---|
| OPV_000473 | 0 | OPV_000624 | 고리없음 | 값0·권위0 ✓ |
| OPV_000474 | 300 | OPV_000627 | 은색구슬줄(군번줄) | 값300·권위300 ✓ |
| OPV-000026 | 1100 | OPV_000625 | 은색고리 | 값1100·권위1100 ✓ |
| OPV-000027 | 1200 | OPV_000626 | 금색고리 | 값1200·권위1200 ✓ |
- 옛 코드 안전성: OPV_000473/474=orphan(딴 곳 미참조)·OPV-000026/027=카드봉투 옵션(그 상품은 무영향, 키링 단가행만 이동).

### DRY-RUN SQL (COMP_ACRYL_KEYRING 4행)
```sql
-- 백업: CREATE TABLE z_bak_keyring_optcd_260706 AS SELECT * FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_KEYRING';
BEGIN;
UPDATE t_prc_component_prices SET opt_cd='OPV_000624' WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV_000473';
UPDATE t_prc_component_prices SET opt_cd='OPV_000627' WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV_000474';
UPDATE t_prc_component_prices SET opt_cd='OPV_000625' WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV-000026';
UPDATE t_prc_component_prices SET opt_cd='OPV_000626' WHERE comp_cd='COMP_ACRYL_KEYRING' AND opt_cd='OPV-000027';
-- 검증: 4행 opt_cd 정본화 + verify_optcode [4] 유실 4↓
ROLLBACK; -- DRY-RUN. 확인 후 COMMIT.
```

### ★동반 의존성 (repoint만으로 부족)
COMP_ACRYL_KEYRING은 **죽은 공식 PRF_ACRYL_KEYRING(상품0)**에 배선. 라이브 아크릴키링(PRD_000146)은
PRF_CLR_ACRYL(면적)만 씀 → repoint해도 **고리 addon이 견적 사슬에 도달 못함**. 동반 필요 =
COMP_ACRYL_KEYRING을 아크릴키링 활성 공식에 재배선(또는 PRD_000146↔PRF_ACRYL_KEYRING 연결). 설계 확인 필요.

### 볼체인 9행 (OPV_000475~483·0+1000×8) = 결정 대기
정본 옵션 미등록(PRD_000146에 볼체인 옵션 없음) + 죽은 공식. **볼체인이 실 판매 옵션인가**부터 확인 →
맞으면 옵션 등록+repoint, 아니면 tombstone. (리포트도 "처리 결정" 미결.)

## Part 2 — 교차상품 중복 14건 정리

### 두 패턴 (전부 7/3 마이그레이션 후 신규입력)
**A. 채번 타이밍 충돌** (keeper=접지리플렛 PRD_000048·먼저 벌크입력 / 재번호=반팔티셔츠 PRD_000206):
| 코드 | keeper | 재번호 대상 |
|---|---|---|
| OPT_000147·OPT_000148 (그룹2) | 접지리플렛 | 반팔티셔츠 |
| OPV_000556~561 (옵션6) | 접지리플렛 | 반팔티셔츠 |

**B. 명시코드 벌크** (아크릴 상품이 6월말 타상품 코드 재사용·keeper=원 상품):
| 코드 | keeper(원) | 재번호 대상(아크릴) |
|---|---|---|
| OPT-000014·OPV-000028 | 봉투제작(050) | 아크릴 머리끈(154) |
| OPT_000074·OPV_000465 | 아크릴마그넷(147) | 아크릴 코스터(159) |
| OPT_000076 | 아크릴집게(149) | 아크릴 포카키링(158) |
| OPV_000468 | 아크릴집게(149) | 아크릴네임택(157) |

### 권고 조치 (리포트 §6-1)
- **담당자 화면 재입력**(안전·자동채번): 재번호 대상 상품에서 해당 옵션/그룹 삭제 → 코드칸 비워 재입력 →
  자동채번이 새 OPV_/OPT_ 발급. 참조(제약·단가·use_dims)는 keeper 유지라 무편집.
- **또는** `migrate_optcode_global_unique.py` 재실행(트랜잭션·백업·keeper 유지·나머지 재번호). 단 B의
  아크릴 3상품 입력경로(화면 아님) 원인은 담당자 확인 권장.

## Part 3 — 전역 UNIQUE 인덱스 (재발 방지)

### 전제
반드시 **Part 2 중복 14건 해소 후**(중복 상태에서 UNIQUE 생성 시 실패).

### DDL (부분 유니크·활성만)
```sql
-- 활성(del_yn='N') 코드 전역 유일 강제. 논리삭제분은 제외.
CREATE UNIQUE INDEX CONCURRENTLY ux_opt_grp_cd_active
  ON t_prd_product_option_groups (opt_grp_cd) WHERE del_yn='N';
CREATE UNIQUE INDEX CONCURRENTLY ux_opt_cd_active
  ON t_prd_product_options (opt_cd) WHERE del_yn='N';
```
- 근본원인 해소: PK가 (prd_cd,코드) 복합이라 코드 단독 유일 미강제였음 → 이 인덱스가 교차상품 중복 재발 차단.
- (선택) 신규 등록 폼 코드칸 읽기전용화로 자동채번 강제(리포트 §5).

## ★실행 기록 (260706 완료·verify ✅ 전 항목 정상)
- **P1 키링 4행 repoint** COMMIT — opt_cd→정본(624~627)·백업 z_bak_keyring_optcd_260706·[4] 11→9.
- **P1+2 재배선+볼체인** COMMIT — PRD_146→PRF_ACRYL_KEYRING(면적+고리)·볼체인 tombstone(use_yn=N/del_yn=Y·단가행0)·
  백업 z_bak_keyring_rewire_fc/ppf·z_bak_ballchain_260706·[4] 9→0.
- **P2 14중복** COMMIT — migrate_optcode_global_unique.py(그룹5+옵션9 재번호·keeper 유지·검증통과)·7/3 baseline 보존/복원·[1] 14→0.
- **P3 UNIQUE 인덱스** — ux_opt_grp_cd_active·ux_opt_cd_active(부분·WHERE del_yn='N'·CONCURRENTLY)·valid=t unique=t·재발 차단.
- 라이브 base 가격 무변경(면적 CLEAR3T 동일). 최종 가격 실화면 확인=담당자 webadmin 시뮬레이터(신규 조립 시점).

## 실행 순서 (권장)
1. Part 1 키링 repoint(4행·매핑 검증완) + 동반 재배선 설계 확인 → 백업 → DRY-RUN → 승인 → COMMIT.
2. Part 2 중복 14건 담당자 화면 재입력(또는 migrate 재실행).
3. Part 3 UNIQUE 인덱스 2개 생성(2 완료 후).
4. verify_optcode_integrity.py 재실행 → [1][4] ✅ 확인.
- 볼체인 9행·아크릴 입력경로 = 담당자 결정 대기.
