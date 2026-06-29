# 가격테이블 무결성 결정론 배치 빌더 (_batch)

권위 가격테이블(엑셀 L1 CSV)이 라이브 DB(스냅샷 CSV)에 이 빠짐 없이·정확히 적재됐는지를
**AI 셀분석(토큰폭발) 대신 결정론 스크립트로 diff**하는 공용 엔진. 토큰 0으로 전 셀 처리.

## 파이프라인 (시트당)

```
권위 L1 CSV (huni-dbmap/06_extract/<sheet>-l1.csv)
   │  matrix_parse.py  ── ADAPTERS[sheet] (차원 축·단가·도수 추출)
   ▼  정규 격자 (plt_grade × clr × side × min_qty → unit_price·prc_typ)
   │  grid_diff.py     ── vs 스냅샷(_foundation/live-snapshot/latest/t_prc_*.csv)
   ▼  결함보드 CSV (5종: dim_missing·missing_cell·transpose·mismatch·prc_typ_typo)
   │  build_load.py    ── 권위 verbatim UPSERT + dryrun(BEGIN…ROLLBACK)
   ▼  교정 적재본 (<sheet>-load.sql + -load-dryrun.sql) → 게이트·codex·인간 승인 → COMMIT
```

## scripts/ (공용 엔진 + 시트 어댑터)

- **matrix_parse.py** — 권위 L1 long-format CSV → 정규 격자. 공용 코어 `parse_l1()` +
  `ADAPTERS[sheet]`(digital-print·coating). `read_csv()`는 BOM 안전 공용 로더.
- **grid_diff.py** — 정규 격자 ↔ 스냅샷 셀 diff. `live_grid_<sheet>()`이 라이브 차원코드를
  정규 키로 환원하고 `detect()`가 결함을 함수로 판정. 결정론 정렬.
- **build_load.py** — 결함보드 → verbatim 교정 SQL. mismatch=UPDATE·prc_typ_typo=UPDATE·
  **missing_axis_cells=verbatim sparse fill INSERT**(`build_coating_glossy_load`)·
  **dim_missing/transpose=BLOCKED escalation**(자동 적재 금지).
- **run_all.py** — 전 19시트 드라이버. `SHEET_REGISTRY`로 DIFFED 시트는 실 diff,
  나머지는 status(L2_PENDING·AREA_PENDING·OUT_OF_SCOPE·UNMAPPED)로 정직 분류.
  `ALL-SHEETS-defects.csv`·`ALL-SHEETS-summary.md` 생성.

## 결함 6분류 (verbatim 적재 가능 vs 설계 결정 필요)

| 결함 | 의미 | 라우팅 |
|------|------|--------|
| `mismatch` | 적재값 ≠ 권위 | verbatim UPDATE |
| `missing_axis_cells` | comp 존재·단가행 0(sparse) | **verbatim sparse fill INSERT** |
| `missing_cell` | 축 살아있고 일부 셀만 빠짐 | verbatim 단일 INSERT |
| `prc_typ_typo` | 합가형인데 .01(×qty) | UPDATE prc_typ |
| `dim_missing` | use_dims에 축 자체 없음(collapse) | **BLOCKED → §18/dbmap 설계** |
| `transpose` | 차원 뒤바뀜 | **BLOCKED → verbatim 재적재 설계** |

★ 핵심 구분: 코팅 유광=`missing_axis_cells`(comp 존재·0행→verbatim 적재 가능) vs
디지털 흑백=`dim_missing`(use_dims에 도수축 없음→차원 설계 결정·blind insert 금지).

## 어댑터 패밀리 (11시트 DIFFED · 전 12 diff대상 완결)

| 패밀리 | 차원축 | 매핑키 | 구현(DIFFED) | 매핑미상 |
|--------|--------|--------|--------------|----------|
| **L1 밴드(차원코드)** | 종류×면×수량 | 차원코드 환원 | ✅ digital-print·coating | — |
| **L1 밴드(note키)** | 종류×수량 | **note 시그니처** | ✅ folding·post-process·binding | 커팅타공(multi-value 컬럼) |
| **L1 면적격자** | 가로×세로 | siz_w×siz_h·block→comp | ✅ acrylic·poster-sign | 박대형/박소형(면적박 comp 부재) |
| **L1 소재(wide)** | 종이명×판형 | note 시그니처(float) | ✅ import-paper | — |
| **L2 선조립 합가표** | 통가격(합가) | note 시그니처 | ✅ envelope·gangpan-sticker·postcard-book | 스티커(블록좌표)·명함(다종) |
| (L3 modifier) | 수량구간→율 | t_dsc_* | 범위 밖 | 판걸이수·굿즈파우치 |

### 면적격자 (`live_grid_area`·`detect_area`)
`AREA_BLOCK_COMP[sheet]`={block_id: comp_cd}(셀수 1:1 확인·미상=None). 키=(comp,가로,세로). **transpose 검출 활성**(권위 (w,h)↔라이브 (h,w) 동일값). off-grid는 결함 아님(ceiling).

### L2/밴드 note 시그니처 (`live_grid_l2`·`live_grid_bandkey`·`live_grid_paper`)
라이브 통가격 comp 의 **note** 로 (종류·소재·수량) 복원 — 코드 환원 회피=날조 가드. `L2_SHEETS`·`BANDKEY_SHEETS`.
- ★ `unparsed_live_rows` 가드: note 미파싱 多 = 거짓 missing 신호(합판 555→regex 보정→0·커팅 18 unparsed→매핑미상).
- 밴드키 `use_proc_key`: 동일 kind 충돌 시만 공정 추가(post-process 가변텍스트/이미지). 그 외 (kind,qty).
- float(용지 절가): 권위 3자리↔라이브 2자리 반올림 ≤0.01 = 정상(rounding 거짓 mismatch 가드).
- del_yn=Y comp 제외: 중철제본(BIND_JUNGCHEOL)·흑백(DIGITAL_S2) 논리삭제 → dim_missing 으로 노출.

lib 재사용: `_foundation/batch/lib_huni.py`(라이브 DB·시뮬레이터 — 본 배치는 스냅샷만 써서
결정론 유지, DB 호출 안 함). CSV 로딩은 `read_csv()` 로컬 헬퍼.

## 어댑터 패턴 (전파의 핵심)

시트마다 다른 건 **차원 축 매핑**뿐. 공용 엔진은 불변, 어댑터만 추가:

```python
ADAPTERS = {
  "digital-print": {"dims": ["plt_grade","clr","side","min_qty"], ...},  # 밴드형(수량구간)
  # 새 시트 1줄 추가:
  # "booklet":     digital-print 동형(인쇄비 밴드형) → 어댑터 복제 + comp_cd 집합만 교체
  # "poster-sign": {"dims": ["siz_width","siz_height"], "grid": "area"} + live area 매퍼
  # "goods-pouch": 고정가 by-siz_cd → {"dims": ["siz_cd","min_qty"]}
}
```

라이브 매퍼(`live_grid_<adapter>`)는 시트별 comp_cd 집합·차원코드 환원만 다르다.
밴드형(digital·booklet)은 `live_grid_digital` 거의 그대로 재사용 가능.

## 전 시트 전파 방법

1. 권위 L1 CSV 확인(`06_extract/<sheet>-l1.csv`).
2. `matrix_parse.ADAPTERS` 에 시트 항목 추가(차원 축·band_split·grade/clr 규칙).
3. `grid_diff` 에 `live_grid_<sheet>` 매퍼 추가(comp_cd 집합·차원코드→정규키). 밴드형은
   `live_grid_digital`·`live_grid_coating` 복사 후 comp 필터만 교체. 면적격자는 siz_width/height
   매퍼 신규(transpose 검출 활성). L2 합가는 통가격 comp 단일키 매퍼.
4. `run_all.SHEET_REGISTRY` 에서 해당 시트 status 를 DIFFED 로·sheet_key 지정.
5. `python3 run_all.py` → 전 시트 결함보드(토큰 0). `build_load.py`/시트 전용 빌더 → 교정 적재본.
   게이트·codex·인간 승인 후 COMMIT.

**현재 구현**: digital-print·coating(밴드형) DIFFED. 나머지 17시트는 SHEET_REGISTRY에
family·comp_hint·라우팅 확정 — 매퍼만 추가하면 동형 전파.

## 재실행 명령

```bash
cd scripts
python3 matrix_parse.py                                  # 권위 격자 요약
python3 grid_diff.py                                     # 결함보드 생성(기본 경로)
python3 build_load.py                                    # 교정 적재본 생성
# 명시 경로:
# python3 grid_diff.py <l1.csv> <snapshot_dir> <defects.csv>
```

## 스냅샷 신선도 [HARD]

스냅샷은 시점 사진. 라이브 COMMIT 후엔 stale. 돈크리티컬 적재본 전:
`_foundation/live-snapshot/latest/_manifest.csv` 행수 ↔ 실제 CSV 행수 대조(grid_diff 가
freshness 요약 출력). 불일치면 `live-snapshot/snapshot.sh` 재생성 후 재실행.

## 위상·안전 [HARD]

권위=엑셀(절대)·라이브=감사대상·스냅샷=거울. 라이브 읽기전용(스냅샷만)·DB 미적재.
적재본=생성측 산출물 — 게이트 골든 시뮬 + codex 스냅샷 교차 + **인간 승인 후에만** dbmap COMMIT.
단가 verbatim(계산·배수·blind swap 금지). webadmin 코드 미변경. 결정론(같은 입력→같은 결함보드).

## 파일럿 결과 (디지털인쇄비)

권위 954셀 중 742셀 라이브와 **정확 일치**(값 불일치 0·transpose 0). 단일 결함=
**흑백(1도) 도수축 212셀 통째 미적재**(dim_missing). 라이브 활성 comp(DIGITAL_S1)는
칼라만 적재·use_dims 에 도수축 부재 → 흑백/칼라 구분 불가 → BLOCKED(차원 설계 결정).
명함·포스터 기존 COMMIT 케이스는 어댑터 검증 참고만(미터치).
