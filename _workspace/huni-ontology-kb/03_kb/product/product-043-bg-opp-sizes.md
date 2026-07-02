<!-- 상품 전용 사이즈 하위 노드: 인쇄배경지(043)의 6 사이즈(SIZ_000033~038). 마스터 t_siz_sizes 앵커. -->
<!-- ★공유 축 axis/sizes.md에는 016 엽서 7행+국전만 있어 043 전용 6행은 여기(상품 전용 하위 노드)에 둔다. -->
<!-- ★이 6 사이즈는 마스터 사이즈이므로 축 오너가 axis/sizes.md로 이관 가능(open_questions 반환). -->
<!-- ★수치(작업·재단 치수)는 아래 전사표(transcribed-by)에만. 블록 props에 raw 치수 미기입(D-9·L-12). -->
<!-- 판걸이수(UP수)는 사이즈 컬럼 아님 — 파생·엔진 fn_calc_pansu 계산(F-9·T-7). -->

# 상품 전용 사이즈: 인쇄배경지(OPP봉투타입) PRD_000043

배경지(043)는 OPP봉투 타입 배경지로, 016 엽서와 다른 이산(離散) 사이즈 6행을 쓴다(면적매트릭스
아님·팩 §3.2). 상품→사이즈(R2 `has_size`)는 [[product-043-bg-opp]]가 건다. 아래 6 사이즈는
라이브 마스터(t_siz_sizes)에 실재하는 코드로, 축 오너가 공유 `axis/sizes.md`로 이관할 수 있다.

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_043.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (PRD_000043 sizes) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000033 | 76x100 | 80x104 | 76x100 |
| SIZ_000034 | 76x120 | 80x124 | 76x120 |
| SIZ_000035 | 86x120 | 90x124 | 86x120 |
| SIZ_000036 | 94x94 | 98x98 | 94x94 |
| SIZ_000037 | 62x180 | 66x184 | 62x180 |
| SIZ_000038 | 105x160 | 109x164 | 105x160 |

## 사이즈 노드

### [size-SIZ_000033] 76x100 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000033
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000033", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000033", 사용: "043 배경지 기본 사이즈(dflt_yn=Y)"}

### [size-SIZ_000034] 76x120 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000034
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000034", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000034"}

### [size-SIZ_000035] 86x120 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000035
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000035", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000035"}

### [size-SIZ_000036] 94x94 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000036
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000036", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000036"}

### [size-SIZ_000037] 62x180 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000037
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000037", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000037"}

### [size-SIZ_000038] 105x160 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000038
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000038", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000038"}
