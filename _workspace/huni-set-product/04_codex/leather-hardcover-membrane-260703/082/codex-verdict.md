# codex 독립 2차 판정 — 082 하드커버 링책자 면지 통합(4택1·인쇄면지) 재설계

> §23 · 2026-07-03 · codex gpt-5.5 (reasoning=high) · 읽기전용 샌드박스 · workdir=repo root
> 헬퍼 `hqv-codex-cross-verify/scripts/codex-review.sh ... high` · 프롬프트 `_codex-prompt.md` (082 특이점 집중)
> ★codex 판정 = **가설**(라이브 DB 재실측 안 함·코드/파일 근거만). 라이브 확증은 `reconcile.md`.
> codex 판정 프레이밍: **DISAGREE=질문의 우려가 파일 근거상 약함(=설계 방향 OK)** · **AGREE=우려에 동의(설계 안일)** · **UNCERTAIN=코드상 일부 맞으나 라이브/원시증거 없이 확정 불가**.

## codex 종합
- **재설계 방향 반대 0** — 판정: 1·2·5 DISAGREE(우려 약함=설계 건전) / 3·4 UNCERTAIN(라이브 증거 요구).
- "S1~S8 게이트로 **넘기는 것은 가능**. 단 지금은 'COMMIT GO'가 아니라 '게이트에서 반드시 깨야 할 조건부 후보'." → 072 선례와 동형 결론(코드/파일만으론 확정 불가·라이브가 닫아야 함).

## 항목별 codex 판정 (근거는 codex가 인용한 파일:라인)

| # | 항목(082 특이점) | codex | codex 근거 요지 |
|---|---|---|---|
| 1 | 골든 818,438 무손상 안일한가 | **DISAGREE**(단 게이트 재실측 필요) | `evaluate_price`=직접단가→공식→없음 순, 소스 없으면 lenient 0원(pricing.py:468·490). `evaluate_set_price`=멤버 base.amount + 부모 셋트공식 단순합산(pricing.py:914·930). 골든파일이 084~087 기여0·818,438 재현·44123은 조건차 스테일 명시(golden:15·18). **단 재설계 후 live golden 재계산 체크박스 미완료(golden:84).** |
| 2 | ★★USAGE.07 링자재 미터치 | **DISAGREE**(우려 약함=안전) | apply는 084에 MAT_382~385만 USAGE.03으로 삽입, 부모 은퇴도 `mat_cd IN (382..385) AND usage_cd='USAGE.03'`로 이중 한정(apply:28·87). 링자재 013/014/015는 USAGE.07이라 SQL 미참조·셋트 comp는 mat_cd 미종속(spec:31·golden:51). |
| 3 | 인쇄면지 MAT_385/OPV_443 기여 0 vs 저청구 고착 | **UNCERTAIN** | 코드상 084 무공식이면 MAT_385 붙어도 evaluate_price 0원 경로(apply:33·55) — 맞음. **단 "인쇄면지"가 실제 인쇄비를 가져야 하는지는 파일만으론 판단불가.** blocked-board가 D-3로 올려둠(blocked:2)=은폐 아님. COMMIT하면 0원을 구조적으로 더 자연스럽게 보이게 하는 고착 리스크. |
| 4 | 085/086/087 은퇴 무결성·트리거 순서 | **UNCERTAIN** | 트리거 순서 양호: 자재삽입→옵션아이템, 부모옵션 item→option→group 은퇴(apply:25·60·73). undo 역순(undo:8). **단 전역 역참조 0은 명세 요약주장만(spec:33)·원시 쿼리 결과 미첨부 → 독립 검증자로 확정 GO 불가.** |
| 5 | 색/인쇄 4택1 드롭다운 발현·오차단 | **DISAGREE**(단 UX/가격오도 리스크) | `_set_members_meta`=멤버 materials 동봉·opt_groups 미동봉(price_views:1708·1746). 렌더러가 멤버 "용지" 드롭다운을 m.materials로 생성(price_simulator:687·708). → 084 자재4 살아있으면 화/블/그/인쇄 4개 드롭다운으로 발현·**선택지 손실 없음**. 단 OPT_066 휴면·"인쇄면지"가 용지처럼 보이며 가격0인 UX/저청구 오도 리스크. |

## codex 게이트 보강 Top 3 (원문)
1. 재설계 apply 상태에서 `set_full_scan PRD_000082`로 818,438 **재측정**(현재 파일도 미완료 항목).
2. 085/086/087 전역 역참조 **원시 쿼리 증거 첨부** — 특히 상품마스터 use_yn=N은 셋트링크보다 폭이 큼.
3. MAT_385 인쇄면지 **도메인 가격 정책 확정** — 0원 보존은 코드상 맞으나 실제 인쇄비 누락이면 D-3 미룬 채 저청구 유지.

## 072 선례 대비
- 072 codex는 1·2·4 AGREE / 3·5 UNCERTAIN이었고, 082 codex는 1·2·5 DISAGREE / 3·4 UNCERTAIN. **프레이밍 차이일 뿐 결론 동형** — 둘 다 "직접단가 0행 확인·전역 역참조 스윕·인쇄면지 정책"을 라이브로 닫으라는 요구. 082는 인쇄면지(#3)를 072에 없던 특이 리스크로 추가 적발.

## 독립성 확인
- codex에 Claude(set-designer/게이트) 판정 비노출. 같은 설계·코드 입력으로 codex 독립 판정. codex 라이브 DB 미접근(샌드박스) → 코드/파일 근거 가설. 라이브 확증은 reconcile 담당.
