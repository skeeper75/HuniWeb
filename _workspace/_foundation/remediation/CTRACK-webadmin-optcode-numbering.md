# C트랙 명세 — webadmin 옵션코드 채번 형식 통일(언더스코어)

작성 2026-06-28 · 대상 = 개발팀(HuniProductPrice2 운영 레포). 로컬 `raw/webadmin`은 복사본 — 운영 배포는 인간.

## 문제
옵션그룹/옵션 코드가 두 형식 혼재:
- 언더스코어(OPT_/OPV_) = 다수·최근·대량적재 표준 (옵션그룹 135/149·옵션 510/538).
- 하이픈(OPT-/OPV-) = 초기 레거시 (그룹 14·옵션 28, 146 키링 OPT-000012 포함).

진원 = `webadmin/catalog/views.py`의 `_next_opt_grp_code()`/`_next_opt_code()`가 `startswith="OPT-"`/`"OPV-"` 하드코딩으로 **하이픈을 자동발번** → 운영자가 화면에서 옵션 추가 시마다 하이픈 생성 → 언더스코어 다수와 재혼재. (범용 `admin._next_serial_code`는 사전순 MAX라 언더스코어를 내는데, 옵션은 이 전용 함수를 써서 불일치.)

## 변경 (로컬 raw/webadmin 적용 완료 = 배포 spec)
`views.py` `_next_opt_grp_code`/`_next_opt_code` 두 함수:
- `startswith="OPT-"` → `"OPT_"` · `startswith="OPV-"` → `"OPV_"`
- 정규식 `^OPT-(\d+)$` → `^OPT_(\d+)$` · `^OPV-(\d+)$` → `^OPV_(\d+)$`
- 포맷 `f"OPT-{...:06d}"` → `f"OPT_{...:06d}"` · `f"OPV-{...}"` → `f"OPV_{...}"`
- 힌트 텍스트(`_PLACEHOLDERS["opt_grp_cd"]`) `OPT-000001` → `OPT_000001`

배포 후: UI든 적재든 신규 옵션은 OPT_/OPV_ 로 수렴 → 재혼재 차단. py_compile OK·하이픈 의존 잔존 0(OPT_REF_DIM 등 무관).

## 안전성
- 충돌 없음: 신규 채번 = 언더스코어 MAX(OPT_000073/OPV_000464)+1 = OPT_000074/OPV_000465. 하이픈 레거시와 다른 문자열·다른 namespace.
- 회귀 영향: 채번 함수만 변경(조회/검증/매칭 로직 무관). 기존 코드 조회·표시·편집 정상.

## 잔여(저우선)
- 레거시 14 하이픈 그룹/28 옵션(146 OPT-000012 등) → 언더스코어 개명은 별도 데이터 마이그레이션(FK참조: component use_dims `opt_grp:OPT-...`·option_items·단가행 opt_cd). 기능 정상이라 후순위.
- `_next_tmpl_code`(템플릿 tmpl_cd)는 별도 namespace — 본 변경 범위 외.

## 연계
이 배포 전이라도 데이터 적재(147~152 addon)는 언더스코어로 mint(다수 표준 정합) — 배포되면 UI 발번도 일치. RTM·`_REMEDIATION-LOG.md` 참조.
