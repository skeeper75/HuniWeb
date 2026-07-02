<!-- 상품 전용 사이즈 하위 노드: 인쇄배경지(투명케이스타입)(044)의 2 사이즈(SIZ_000039·SIZ_000041). 마스터 t_siz_sizes 앵커. -->
<!-- ★공유 축 axis/sizes.md에는 이 2행이 없어 044 전용으로 여기(상품 전용 하위 노드·자기 네임스페이스)에 둔다. -->
<!-- ★이 2 사이즈는 마스터 사이즈이므로 축 오너가 axis/sizes.md로 이관 가능(needed_shared_nodes로 반환·비차단). -->
<!-- ★수치(작업·재단 치수)는 아래 전사표(transcribed-by)에만. 블록 props에 raw 치수 미기입(D-9·L-12). -->
<!-- 판걸이수(UP수)는 사이즈 컬럼 아님 — 파생·엔진 fn_calc_pansu 계산(T-7). -->

# 상품 전용 사이즈: 인쇄배경지(투명케이스타입) PRD_000044

배경지(044)는 투명케이스(포토카드 케이스 등) 삽입용 배경지로, 043(OPP봉투타입)과 다른 이산(離散)
사이즈 2행을 쓴다(면적매트릭스 아님·팩 §3.2). 상품→사이즈(R2 `has_size`)는
[[product-044-backing-card-clear-case]]가 건다. 아래 2 사이즈는 라이브 마스터(t_siz_sizes)에
실재하는 코드로, 축 오너가 공유 `axis/sizes.md`로 이관할 수 있다(마스터 사이즈).

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_044.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (PRD_000044 sizes) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000039 | 74x74 | 78x78 | 74x74 |
| SIZ_000041 | 74x109 | 78x113 | 74x109 |

## 사이즈 노드

### [size-SIZ_000039] 74x74 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000039
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000039", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000039", 사용: "044 투명케이스타입 배경지 기본 사이즈(dflt_yn=Y)"}

### [size-SIZ_000041] 74x109 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000041
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000041", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000041"}
</content>
</invoke>
