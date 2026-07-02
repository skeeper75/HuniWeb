<!-- 상품 전용 사이즈 하위 노드: 인쇄헤더택(045)의 4 사이즈(SIZ_000043~046). 마스터 t_siz_sizes 앵커. -->
<!-- ★공유 축 axis/sizes.md에는 016 엽서 7행+국전·명함만 있어 045 전용 4행은 여기(상품 전용 하위 노드)에 둔다(043 형제 동형). -->
<!-- ★이 4 사이즈는 마스터 사이즈이므로 축 오너가 axis/sizes.md로 이관 가능(open_questions 반환·직접 mint 금지). -->
<!-- ★수치(작업·재단 치수)는 아래 전사표(transcribed-by)에만. 블록 props에 raw 치수 미기입(D-9·L-12). -->
<!-- 판걸이수(UP수)는 사이즈 컬럼 아님 — 파생·엔진 fn_calc_pansu 계산(F-9·T-7). -->

# 상품 전용 사이즈: 인쇄헤더택 PRD_000045

헤더택(045)은 포장(봉투·스낵백 상단에 다는 헤더 태그) 용도 인쇄물로, 043 배경지·016 엽서와 다른
이산(離散) 사이즈 4행을 쓴다(면적매트릭스 아님·팩 §3.2). 폭이 80mm로 고정되고 길이만 80/110/140/160
으로 늘어나는 가로 헤더 형태다(라이브 마스터 재단 치수 기준). 상품→사이즈(R2 `has_size`)는
[[product-045-header-tag]]가 건다. 아래 4 사이즈는 라이브 마스터(t_siz_sizes)에 실재하는 코드로,
축 오너가 공유 `axis/sizes.md`로 이관할 수 있다.

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_045.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (PRD_000045 sizes) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000043 | 80x80 | 84x84 | 80x80 |
| SIZ_000044 | 110x80 | 114x84 | 110x80 |
| SIZ_000045 | 140x80 | 144x84 | 140x80 |
| SIZ_000046 | 160x80 | 164x84 | 160x80 |

## 사이즈 노드

### [size-SIZ_000043] 80x80 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000043
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000043", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000043", 사용: "045 헤더택 기본 사이즈(dflt_yn=Y)"}

### [size-SIZ_000044] 110x80 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000044
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000044", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000044"}

### [size-SIZ_000045] 140x80 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000045
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000045", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000045"}

### [size-SIZ_000046] 160x80 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000046
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000046", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000046"}
