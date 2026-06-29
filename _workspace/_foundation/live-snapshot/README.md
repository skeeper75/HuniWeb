# 라이브 Railway DB 실측 환경 (표준 헬퍼 + 스냅샷 캐시)

목적: 라이브 `railway` DB(PostgreSQL·t_* 42테이블)를 **신뢰성 있게 실측**하는 표준 토대.
배경: Claude(에이전트)는 라이브 직접 SELECT 가능하나 **codex(2nd AI)는 샌드박스 네트워크 제한으로 라이브 접속 불가**(DNS) → 교차검증이 약화됨. 이 캐시로 codex·배치·진단이 **같은 라이브 실데이터를 파일로** 읽는다.

## 구성
- `db-check.sh` — 연결 검증(값 비노출·`CONN OK: railway | t_*=42 | prc_comp=N`).
- `snapshot.sh` — 전 t_* 테이블을 `snap_<TS>/<table>.csv`로 export + `_manifest.csv`(테이블별 행수) + `latest` 심볼릭 링크.
- `snap_<TS>/` · `latest` — 스냅샷 데이터(gitignore·생성물).

## 사용
```bash
# 연결 검증
bash _workspace/_foundation/live-snapshot/db-check.sh
# 스냅샷 생성(전 t_* CSV)
bash _workspace/_foundation/live-snapshot/snapshot.sh
```
★Bash 도구로 실행 시 **dangerouslyDisableSandbox=true** 필요(외부 DB 네트워크). 자격증명 = `.env.local RAILWAY_DB_*`(읽기전용 SELECT/COPY만).

## codex 교차검증에 쓰는 법
codex는 라이브 직접 접속 대신 **`latest/` 스냅샷 CSV를 입력**으로 받아 같은 실데이터로 독립 판정한다(라이브 우회·결정론). codex 프롬프트에 `live-snapshot/latest/<table>.csv` 경로를 명시.

## 위상 / 안전 [HARD]
- 권위 = 엑셀(상품마스터·가격표) 절대 · 라이브 = 감사 대상 · 스냅샷 = 라이브의 **시점 사진**.
- ★**드리프트 주의**: 스냅샷은 생성 시점 고정. 라이브가 COMMIT으로 변하면 재생성 필요. 돈크리티컬 판정 전 `db-check.sh` 행수와 `latest/_manifest.csv` 대조해 신선도 확인.
- 읽기전용(SELECT/COPY)·물리 쓰기 없음 · 비밀값 비노출(CSV·stdout·git).
