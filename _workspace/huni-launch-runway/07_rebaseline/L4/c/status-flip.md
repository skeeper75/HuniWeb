# L4c — 상태 뒤집힘 (legacy 미착수/CUSTOM → L2 근거로 `done`)

> 원장 「미착수 359건」 중 내 도메인에서 실제로는 이미 되어 있던 것들.
> **모든 done 은 L2 file:line 인용을 mapping.csv 에 달았다.** done 28행 · 인용 56개 · 실재 검사 불일치 0 (`recheck-15.txt` 보강 절).

## 한 줄 요약

**운영자·상품가격 33행 중 27행이 이미 라이브다.** 후니 IA(260616)·launch-scope(260630)·runway(260811) 세 분모가 전부 이 영역을 `CUSTOM·미착수`로 적어둔 사이, `raw/webadmin` 은 상품·옵션·제약·가격의 관리 화면을 다 지어놨다. 반대로 **주문운영 24행 중 done 0 · 회원CS 14행 중 done 1 · 정산·통계 12행 중 done 0** — 뒤집힘은 상품/가격 축에만 몰려 있다.

| 대분류 | 표준행 | done | partial | todo | new |
|---|---:|---:|---:|---:|---:|
| 운영자·상품가격 | 33 | **27** | 5 | 1 | 0 |
| 운영자·주문운영 | 24 | 0 | 4 | 13 | 7 |
| 운영자·회원CS | 14 | 1 | 0 | 13 | 0 |
| 정산·통계 | 12 | 0 | 0 | 7 | 5 |
| **합** | **83** | **28** | **9** | **34** | **12** |

done 28행 가운데 **25행이 「뒤집힘」**(legacy 가 미착수/CUSTOM 이라 적었는데 실제로는 되어 있던 것)이고, 나머지 3행은 legacy 분모 자체에 없던 채로 이미 라이브인 것(§3).

## 1. 뒤집힘 25건 — legacy 판정 vs 실측

| std_id | 기능 | legacy 원판정 | L2/직접 근거 |
|---|---|---|---|
| STD-ADP-001 | 사이즈 마스터 | F-105/SCOPE-105 CUSTOM·미착수 | urls.py:339,344 · admin.py:2049 |
| STD-ADP-002 | 소재(자재) 마스터 | F-106/SCOPE-106 CUSTOM·미착수 | admin.py:2158 · urls.py:316 |
| STD-ADP-003 | 용지·평량 마스터 | F-107/SCOPE-107 CUSTOM·미착수 | urls.py:304 · admin.py:2052 |
| STD-ADP-004 | 도수/색상 코드 | X-DEC-FRMTYP 미착수 | admin.py:2178 · urls.py:316 |
| STD-ADP-005 | 공정 마스터 | P-DEDUP-PROC-3 미착수 | admin.py:2145 · urls.py:344 |
| STD-ADP-006 | 공정 택일그룹 | P-CONSTRAINT-OG-048 미착수 | admin.py:1595 (모델 DROP·옵션그룹 흡수) · urls.py:356-360 |
| STD-ADP-007 | 판형·판걸이수 | X-ENGINE-PANSU 미착수 | admin.py:1592 · urls.py:333 |
| STD-ADP-010 | 인쇄/제본 상품 등록 | F-100 CUSTOM·1차·L | urls.py:333,353 · admin.py:2064 |
| STD-ADP-011 | 굿즈 상품 등록 | F-110 CUSTOM·2차·L | urls.py:333,353 |
| STD-ADP-012 | 포장재 상품 등록 | F-112 CUSTOM·2차·M | urls.py:333 |
| STD-ADP-013 | 상품-카테고리 귀속(다중분류) | SCOPE-109 CUSTOM | admin.py:2071 · urls.py:349 |
| STD-ADP-016 | 셋트 상품 구성 | P-SET-* 미착수 다수 | urls.py:336 · models.py:510 · admin.py:2071 |
| STD-ADP-017 | 옵션그룹 구성 | P-OPT-D7-65 미착수 | urls.py:356-360 |
| STD-ADP-018 | 옵션↔차원 참조 연결 | P-AXIS-265 미착수 | urls.py:368 |
| STD-ADP-019 | 옵션 참조 무결성 검증 | X-SENSOR-* 미착수 | urls.py:373 |
| STD-ADP-020 | 추가상품 템플릿 | P-ACRYL-ADDON-6 미착수 | urls.py:363-365 |
| STD-ADP-021 | 제약규칙 등록(폼빌더) | X-CR-C9/C10 미착수 | urls.py:371 · models.py:801 |
| STD-ADP-022 | 제약규칙 시뮬레이션·미리보기 | X-CR-ENFORCE-* 미착수 | **urls.py:167** price_sim_constraints |
| STD-ADP-023 | 가격공식 등록·상품 바인딩 | F-108 CUSTOM·1차·XL | **price_views.py:1882** · urls.py:159 · pricing.py:1 |
| STD-ADP-024 | 가격구성요소 등록·차원 지정 | F-104 CUSTOM·1차·L | admin.py:2200-2206 · urls.py:144-148 |
| STD-ADP-026 | 단가유형 설정 | X-CONFIRM-QTYBASIS 미착수 | admin.py:2202 |
| STD-ADP-027 | 수량구간 할인테이블 | P-PED-DSCLINK-4 미착수 | urls.py:137 · admin.py:2219-2231 · price_views.py:2012 |
| STD-ADP-029 | 템플릿 직접단가 | X-WGT-W2B 미착수 | **price_views.py price_source_save kind='tmpl_price'** · urls.py:159 |
| STD-ADP-031 | 가격 시뮬레이터 | X-OPS-ADMINPW 미착수 | urls.py:172,169,157 |
| STD-ADC-014 | 인쇄 가이드 콘텐츠 관리 | IA-087 미착수 | urls.py:72-87 · s3_guide.py:266-350 |

## 2. ★ L2 가 못 본 것 3건 — §4-6 미독 구간을 직접 열어 메웠다

인계사항 §4-6: `views.py`(4773줄)·`widget_api.py`(4666줄)은 L2 가 URL 라우팅표+함수명으로만 식별했다. 그래서 **함수 안을 열어야 보이는 것**은 L2 인벤토리에 없다. 아래 3건은 내가 직접 열어 확인했고, 없었으면 전부 `todo` 로 잘못 적힐 뻔했다.

| 발견 | 어디서 | 무슨 뜻 |
|---|---|---|
| **상품↔가격공식 바인딩 저장이 실재** | `catalog/price_views.py:1882` `TPrdProductPriceFormulas.objects.update_or_create` (엔드포인트 `urls.py:159` price_source_save) | STD-ADP-023 이 `done`. L2 의 WA-017 은 「가격 뷰어(조회)」로만 잡혀 있어 **쓰기 경로가 인벤토리에 없었다** |
| **적용시작일(apply_bgn_ymd) 3층 완비** | 그릇 `models.py:336,411` 복합PK · 엔진 `pricing.py:363` 최신본 선택 · 저장 `price_source_save kind='formula'` | STD-ADP-030 이 `done`. 가격 이력 관리가 이미 동작 |
| **템플릿 직접단가 add/del** | `price_source_save kind='tmpl_price'` (del_all 포함) | STD-ADP-029 가 `done` |
| **제약 cascade 미리보기** | `urls.py:167` price_sim_constraints — "현재 선택 → 각 차원 불가값(비활성)" | STD-ADP-022 가 `done` |

## 3. 분모에 아예 없던 done 3건

legacy 3분모(716건) 어디에도 대응 항목이 없는데 **이미 라이브**인 것. `new`(표준엔 있는데 legacy 에 없음)의 정의에는 맞지만, 「앞으로 만들 것」이 아니라 「이미 있는 것」이라 별도로 적는다.

| std_id | 기능 | 근거 |
|---|---|---|
| STD-ADP-008 | 제본 방식 마스터 관리 | urls.py:320-330 · spine_calc.py:1 (책등 계산 규칙) |
| STD-ADP-030 | 가격 적용시작일 기반 이력 관리 | models.py:336,411 · pricing.py:363 · price_views.py:1039 |
| STD-ADP-032 | 가격뷰어 | urls.py:32 · urls.py:113-117 |

## 4. 반대 방향 — 낙관을 깎은 1건

| std_id | 기능 | 왜 done 이 아닌가 |
|---|---|---|
| **STD-ADP-025** | 단가행 일괄 등록(엑셀 업로드) → **partial** | webadmin 전역에 `openpyxl`·`xlsx` 임포트 코드가 **0건**이다. 있는 것은 엑셀 **클립보드 복붙 그리드**(`price_views.py:1650`, `comp_price_grid_page.html:142-145`). 표준이 요구한 「파일 업로드」가 아니다 — 19시트 배치 적재(P-19SHEET-BATCH)가 사람 손에 묶여 있는 구조적 원인이 여기다 |
