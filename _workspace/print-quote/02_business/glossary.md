# 도메인 용어집 — 후니프린팅 인쇄 도메인

**작성:** 2026-05-27 (pq-business-analyst)
**용도:** pq-architect의 DB 컬럼 명명, pq-designer의 UI 라벨, pq-pm의 정책 문서에서 일관 참조.
**원칙:** 한글 용어 + 영문 동의어(snake_case) + 정의 + 출처/예시.

---

## 1. 인쇄·출판 기본 용어

| 한글 | 영문 (DB column 후보) | 정의 | 출처/예시 |
|------|---------|------|------|
| 인쇄 | `printing` / `print` | 잉크를 매체(종이/PET/PVC/패브릭 등)에 옮겨 이미지/텍스트를 재현하는 가공 | — |
| 도수 | `ink_count` | 사용한 잉크 색상의 수. 1도=흑백, 4도=CMYK, 5도+=별색 추가 | xlsx 디지털인쇄비 시트 |
| 단면 | `side='single'` / `D='S'` (PDF) | 종이의 한 면만 인쇄 | xlsx `인쇄(옵션)` 컬럼 |
| 양면 | `side='double'` / `D='D'` | 종이의 양면 모두 인쇄 | 동일 |
| CMYK | `cmyk` | 청록(Cyan)·자홍(Magenta)·노랑(Yellow)·검정(Key/Black) 4도. 컬러 인쇄 표준 | xlsx 디지털인쇄비 |
| RGB | `rgb` | 빛 기반 3색. 디스플레이 색공간. 인쇄 전 CMYK 변환 필수 | 가이드 콘텐츠 |
| 별색 | `spot_color` / `special_ink` | CMYK 외 잉크 (화이트·클리어·핑크·금·은) | xlsx 7도수 중 5개 |
| 화이트인쇄 | `ink_white` | 흰색 잉크 인쇄 (투명 소재에 배경 처리) | 003-0006 화이트인쇄명함 |
| 클리어인쇄 | `ink_clear` | 무색 투명 잉크 인쇄 (UV 광택용) | 디지털인쇄비 시트 |
| 금/은박 | `foil_gold` / `foil_silver` | 금속박 가공 (별색 + 박 가공 둘 다 의미) | 003-0009 박명함 |
| 동판 | `copper_plate` / `embossing_die` | 박/형압 가공용 금속판 | xlsx 박명함 "기본가(아연판) 5000" |
| 아연판 | `zinc_plate` | 동판 대체 저가 옵션 | 박명함 기본 5,000원 |
| 박(가공) | `foil_stamping` | 박지(금/은/먹/청/적/동/홀로그램/트윙클)를 열·압력으로 종이에 전사 | 003-0009 |
| 형압 | `embossing` / `deboss` | 압력으로 양각/음각 효과 | 003 형압명함 (코드 미부여) |
| 코팅 | `lamination` / `coating` | 보호막 필름. 무광/유광 2종 | xlsx 코팅 시트 |
| 라미네이팅 | `laminating` | 코팅의 동의어 (UV·필름) | 공정관리 PDF p.1 |
| 콜코팅 | `cool_coating` | 실사 출력물용 보호 코팅 (라미네이팅의 대형용) | 공정관리 PDF Case 6 |

---

## 2. 후가공 (Finish) 용어

| 한글 | 영문 | 정의 | 출처 |
|------|------|------|------|
| 후가공 | `finish` / `finishing` | 인쇄 후 추가 가공 (코팅·박·형압·접지·오시·타공·귀돌이 등) | xlsx `후가공` 컬럼 |
| 접지 | `folding` | 종이 접기. 2단/3단/지그재그 | xlsx 접지옵션 시트 |
| 오시 | `creasing` | 종이에 접힐 자국 내기 (접지 보조). 1줄/2줄/3줄 | xlsx 인쇄후가공 시트 |
| 미싱 | `perforation` (재봉틀모양) | 점선 절취선 가공. 1줄~3줄 | 인쇄후가공 시트 |
| 타공 | `hole_punch` | 구멍 뚫기. 1구(6mm) / 2구 / 4구 | xlsx 커팅타공·인쇄후가공 |
| 귀돌이 | `corner_rounding` / `round_corner` | 모서리 둥글게 처리 | 인쇄후가공 R3 |
| 직각 모서리 | `square_corner` | 기본 사각 모서리 (가공 없음) | |
| 둥근 모서리 | `round_corner` | 귀돌이 가공 | |
| 반칼 | `kiss_cut` / `half_cut` | 칼선이 점착지의 윗층만 자르고 이형지는 유지 (스티커) | xlsx 스티커 시트 |
| 완칼 | `full_cut` / `die_cut` | 완전 절단 | xlsx 커팅타공 |
| 도무송 | `die_cutting` (Thomson Press) | 톰슨 프레스 가공 (수동/기계 모두). 합판도무송 = 합판에 칼선 모은 가공 | xlsx 합판도무송스티커 |
| 가변 인쇄 | `variable_data_printing` (VDP) | 매수마다 다른 텍스트/이미지 (개인화) | xlsx 인쇄후가공 R32-R40 |
| 싸바리 | `sabari` (일본어 어원) | 하드커버 표지 가공 (보드+종이+가죽 합지) | xlsx 제본 시트 |

---

## 3. 제본 (Binding) 용어

| 한글 | 영문 | 정의 | 가격표 |
|------|------|------|------|
| 제본 | `binding` | 인쇄물 묶기 | 제본 시트 |
| 중철 | `saddle_stitch` / `mid_binding` | 가운데 철심 박기 (적은 페이지·잡지) | 006-0001 |
| 무선 | `perfect_binding` | 접착제 책등 (페이퍼백) | 006-0002 |
| PUR | `pur_binding` | Polyurethane Reactive 강력 접착 (사진집·고급) | 006-0003 |
| 트윈링 | `twin_wire_binding` | 이중 와이어 링 (스프링노트) | 006-0004 |
| 하드커버 | `hardcover` | 단단한 표지 (양장). 무선/트윈링 변형 | 006-0005 |
| 링제본 | `wire_binding` / `spiral` | 와이어 또는 플라스틱 코일 | 공정관리 PDF Case 4 |
| 떡제본 | `padding_binding` | 천연 풀로 메모지 등 위쪽만 접착 | 공정관리 Case 5 |

---

## 4. 종이·소재 (Paper/Material) 용어

| 한글 | 영문/규격 | 정의 | 단가 출처 |
|------|------|------|------|
| 백모조 | `white_modo` | 표준 종이 (스탠다드 명함용 220g) | 명함포토카드 시트 |
| 아트지 | `art_paper` | 코팅된 종이 (광택). 250g/300g | 명함 시트 |
| 스노우지 | `snow_paper` | 매트 무광 코팅 종이. 250g/300g | 명함 시트 |
| 랑데뷰 | `randevu` (수입지) | 프리미엄 무광 종이. 240g/310g | 프리미엄명함 |
| 몽블랑 | `mont_blanc` (수입지) | 프리미엄 모양명함용 종이. 210g/240g | 프리미엄명함, 모양명함 |
| 아코팩 | `aco_pack` | 친환경 종이. 250g | 프리미엄명함 |
| 매쉬멜로우 | `mashmellow` | 부드러운 텍스처 종이. 233g | 프리미엄명함 |
| 리사이클러스 | `recycle_us` / `recycled` | 재생지. 240g | 프리미엄명함 |
| 린넨커버 | `linen_cover` | 린넨 텍스처 종이 | 프리미엄명함 |
| 스타드림 | `stardream` | 펄 (반짝이는) 종이. 다이아/실버/골드/로츠쿼츠 240g | 펄명함 |
| 큐리어스스킨 | `curious_skin` | 컬러 표면 종이 (화이트/레드/타크블루/바이올렛/블랙) | 화이트인쇄명함 |
| PET (260) | `pet_260` | 폴리에틸렌 테레프탈레이트 투명 시트 | 투명명함 |
| 유포 (스티커) | `yupo` (BOPP) | 폴리프로필렌 합성지 | 스티커 시트 |
| 인화지 | `photo_paper` | 사진 인쇄용 | 포스터사인 시트 |
| 매트지 | `matte_paper` | 무광 종이 | 아트페이퍼포스터 |
| 패브릭 | `fabric` | 그래픽천/린넨/캔버스 | 포스터사인 |
| 타이벡 | `tyvek` (DuPont) | 합성 부직포 (방수·찢김 강) | 004-0010 |
| 라텍스 | `latex_ink` | 잠수형 라텍스 잉크 (투명 출력) | 공정관리 Case 7 |
| 평판 | `flatbed` (UV) | UV평판 프린터 (단단한 매체 직접 인쇄) | 공정관리 Case 10-12 |

---

## 5. 사이즈·규격 용어

| 한글 | 영문 | 정의 |
|------|------|------|
| 사이즈 | `size` | 인쇄물 크기 (WxH mm) |
| 규격 | `preset_size` | 표준화된 사이즈 (A4, A5, 명함 90x50 등) |
| 비규격 | `custom_size` | 가로/세로 직접입력 (아크릴, 포스터) |
| 작업사이즈 | `work_size` | 블리드 포함 작업 영역 |
| 재단사이즈 | `trim_size` / `cut_size` | 재단 후 최종 결과물 사이즈 |
| 블리드 | `bleed` | 재단선 밖 여백 (보통 2~3mm) — 재단 오차 보정용 | xlsx `블리드(mm)` 컬럼 |
| 판수 | `imposition` / `up` | 한 인쇄판에 들어가는 카피 수 (예: A5 4판 = A5 사이즈가 한 판에 4개) | xlsx 판걸이수 시트 |
| 판걸이수 | `imposition_count` / `nup` | 다도안 인쇄 시 판당 들어가는 도안 수 | xlsx 판걸이수 시트 (126행) |
| 출력용지규격 | `output_paper_size` | 인쇄기에 들어가는 원지 사이즈 (316x467 = 국4절, ?x? = 3절) | xlsx 디지털인쇄비 |
| 국4절 | `kkok_quarto` (1/4) | 한국 표준 인쇄용지 절단 사이즈. 316 x 467 mm | 디지털인쇄비 시트 R1 |
| 3절 | `kkok_octavo` (1/8 추정) | 더 큰 원지 사이즈 (와이드 접지 용도) | 디지털인쇄비 R61 |
| 아이마크 | `aimark` / `eye_mark` | 자동 정렬용 마커 (조판 시 추가) | 주문프로세스 p.5 |
| 인포지션 | `imposition_layout` | 다도안 판걸이 배치 (출력팀 Pain) | 주문프로세스 p.5 |
| 조판 | `imposition` (typesetting) | 인쇄 전 다중 도안을 한 판에 배치 | 주문프로세스 p.5 |

### 5.1 ISO 규격 사이즈 (참고)

| 규격 | mm (WxH) | 예시 상품 |
|------|------|------|
| A6 | 105 x 148 | 반칼 자유형 스티커 |
| A5 | 148 x 210 | 소량전단지, 시트커팅 |
| A4 | 210 x 297 | 디자인캘린더, 시트커팅 |
| A3 | 297 x 420 | 포스터, 폼보드, 시트커팅 |
| A2 | 420 x 594 | 대형 포스터, 시트커팅 |
| A1 | 594 x 841 | 폼보드 A1 |
| B4 | 250 x 353 | 낱장스티커 |
| B3 | 353 x 500 | 낱장스티커 |
| 명함 | 90 x 50 | 003-0001~0009 |
| 미니명함 | 50 x 50 | 003-0008 |
| 포토카드 | 55 x 86 | 001-0012 |
| 엽서 | 73 x 98 / 100 x 150 | 001-0001~ |

---

## 6. 파일 (File) 용어

| 한글 | 영문/포맷 | 정의 | 출처 |
|------|------|------|------|
| 출력파일 | `output_file` | 인쇄에 사용되는 최종 파일 (PDF/JPG/AI) | xlsx `출력파일` 컬럼 |
| 원본파일 | `source_file` | 고객 업로드 또는 디자인 원본 | 주문프로세스 p.10 |
| 접수파일 | `received_file` / `intake_file` | 발주팀이 가공 후 등록한 파일 | 주문프로세스 p.10 |
| 칼선파일 | `cutline_file` | 커팅 윤곽선만 분리한 AI 파일 | 주문프로세스 p.5 |
| 조판파일 | `imposed_file` | 다도안 조판 완료된 출력 파일 | 주문프로세스 p.5 |
| 썸네일 | `thumbnail` | 미리보기 이미지 (의뢰서·관리자용) | 주문프로세스 p.10 |
| 의뢰서 | `work_order` / `printing_request` | 인쇄 공정 의뢰서 (대표 썸네일 + 사양) | 주문프로세스 p.10 |
| 발주서 | `purchase_order` (외주) | 외주처 발주 문서 | 주문프로세스 p.10 |
| 납품명세서 | `delivery_note` | 퀵 출고 시 함께 보내는 명세서 | 주문프로세스 p.2 |
| 출고명세서 | `dispatch_note` | 직접방문 수령 시 함께 보내는 명세서 | 주문프로세스 p.2 |
| PDF | `pdf` | Portable Document Format (출력 표준) | xlsx 출력파일 |
| AI | `ai` (Adobe Illustrator) | 벡터 원본 (커팅·박·도장용 권장) | xlsx 출력파일 |
| JPG | `jpg` | 비트맵 (실사·패브릭·전사 출력용) | xlsx 출력파일 |
| EPS9 | `eps` (Encapsulated PostScript v9) | 외주 동판제작 표준 포맷 | 주문프로세스 p.5 |
| 파일고유번호 | `file_uid` | 5자리 시스템 생성 ID (예: 30146712 with `30135121` 업체작업번호) | 주문프로세스 p.6 |
| 파일명 RENAME | `file_rename` | 표준 포맷 `발주일_품목_사이즈_양단면_소재_거래처_고객_고유번호_수량` | 주문프로세스 p.6 |

---

## 7. 주문·결제 용어

| 한글 | 영문 | 정의 | 출처 |
|------|------|------|------|
| 미입금 | `unpaid` | 결제 미완료 상태 (가상계좌 입금 대기) | 주문프로세스 p.1 |
| 결제완료 | `paid` | 결제 승인 상태 | p.1 |
| 제작대기 | `preparing` | MES 주문 등록, 의뢰서 출력 대기 | p.1 |
| 제작중 | `producing` | 의뢰서 출력 완료, 생산 진입 | p.1 |
| 제작완료 | `done` | 모든 상품 1차포장 완료 | p.1 |
| 출고완료 | `shipped` | 송장 출력 또는 수령 완료 | p.1 |
| 주문취소 | `cancelled` | 환불·취소 처리 완료 | p.1 |
| 가상계좌 | `virtual_account` | 1회용 가상 입금 계좌 (이니시스) | p.1 |
| 이니시스 | `inicis` | KG이니시스 PG사 | p.1 |
| 에스크로 | `escrow` | 안전결제 (이니시스 보유) | p.1 |
| 포인트결제 | `point_payment` | 적립금/프린팅머니 결제 | p.1 |
| 신용결제 | `credit_payment` | B2B 후불 결제 (오프라인 MES 입력) | p.1 |
| 프린팅머니 | `printing_money` (huni 자체 명명) | 적립금 + 충전 기능 결합 | 정책체크리스트 A-3-5 |
| 옵션보관함 | `option_storage` | 저장된 인쇄옵션 (재주문용) | 정책체크리스트 A-3-3 |
| 알림톡 | `kakao_alimtalk` | Kakao Business 인증 알림 메시지 | 주문프로세스 p.2 |
| 팝빌 | `popbill` | 세금계산서·현금영수증 API 서비스 | 정책체크리스트 A-3-14 |
| 후불결제 | `postpayment` (B2B) | 정산일에 일괄 청구 | 정책체크리스트 B-8-8 |

---

## 8. 운영·조직 용어

| 한글 | 영문 | 정의 | 출처 |
|------|------|------|------|
| MES | `mes` (Manufacturing Execution System) | 생산실행시스템 | 주문프로세스 p.1 |
| MES ITEM_CD | `mes_item_cd` | 후니 상품 코드 `NNN-NNNN` | xlsx 상품마스터 |
| BIZ / FUJI / HUNI | `channel_biz` / `channel_fuji` / `channel_huni` | 4채널 거래처 코드 (비즈하우스·후지필름·자사·컨티뉴) | 주문프로세스 p.5 |
| 비즈하우스 | `biz_house` | OEM 채널 (해외배송 색깔종이) | p.5 |
| 후지필름 | `fujifilm` | OEM 채널 (생산관리 프로그램 → SCV) | p.5 |
| 컨티뉴 | `continue` (Continue) | OEM 채널 (웹하드 다운로드) | p.5 |
| 수작 | `sujak` (SUJAK Brand) | 후니의 디자인 의뢰 서브 브랜드 (D-PM-30: V1 제외·V2 재검토 이연, 브랜드 자산 보존 — 폐지 아님) | 정책체크리스트 A-10-4 |
| 상상 | `sangsang` (Sangsang Brand) | 디자인 의뢰 서브 브랜드 (수작과 별도) | A-6-7 메모 |
| 디지털인쇄팀 | `digital_print_team` | 출력 부서 | 공정관리 p.1 |
| 스티커가공파트 | `sticker_processing` | 반칼/완칼 부서 | p.1 |
| 인쇄후가공팀 | `post_processing_team` | 제본·재단·박 부서 | p.1 |
| 특수인쇄가공팀 | `special_print_team` | 실사·UV·전사·패브릭 부서 | p.1 |
| 봉재가공파트 | `sewing_processing` | 봉제미싱 부서 (파우치·에코백) | p.1 |
| 아크릴가공 | `acrylic_processing` | 아크릴 가공 부서 | p.1 |
| 굿즈가공 | `goods_processing` | 굿즈 후가공 부서 | p.1 |
| 쿠마샵 | `kuma_shop` (외주) | 화이트인쇄·패브릭·UV·전사 외주처 | 주문프로세스 p.3 |
| 합판인쇄 | `multi_panel_print` | 여러 도안을 한 판에 모아 인쇄 (외주 봉투·도무송) | 공정관리 Case 17 |
| 고주파 | `high_frequency` (Welding) | 고주파 용접 가공 (외주) | Case 17 |
| 동판제작 | `copper_plate_mfg` | 박 동판 외주 제작 | Case 15 |
| 박작업 | `foil_work` (외주) | 박 가공 외주 | Case 15 |
| 발주팀 | `order_processing_team` | 주문 접수·파일 처리 부서 | 주문프로세스 p.4 |
| 생산팀 | `production_team` | 파일 다운로드 후 제작 부서 | p.4 |
| 출고팀 | `dispatch_team` | 포장·송장 부서 | p.4 |

---

## 9. 빌더·시스템 용어 (To-Be)

| 한글 | 영문 | 정의 |
|------|------|------|
| 자체 빌더 | `self_builder` (D-002) | 후니가 구축하는 Elementor 류 자체 웹빌더 |
| 견적 마법사 | `quote_wizard` | 다단계 옵션 선택 + 실시간 가격 계산 UI |
| 옵션 폼 | `option_form` | 다단계 종속옵션 입력 폼 (TM EPO 대응) |
| 가격 엔진 | `pricing_engine` | 8축 입력 → 단가 계산 백엔드 |
| BFF | `bff` (Backend For Frontend) | Shopby Server API 활용 위한 미들웨어 |
| Edicus SDK | `edicus_sdk` (D-003) | 외부 디자인 에디터 SDK (edicusbase.firebaseapp.com) |
| Aurora | `shopby_aurora` | Shopby Enterprise 표준 React Skin (D-004에서 폐기) |
| huniprinting48 | `shopby_mall_81683` | 후니의 Shopby Enterprise mall (D-004에서 폐기) |
| Big-Bang 컷오버 | `big_bang_cutover` (D-002) | 전체 전환 (단계 마이그레이션과 대비) |
| 옵션 C | `option_c` (D-004) | 자체 빌더 100% + Shopby Server API 부분 활용 |

---

## 10. 약어 및 별칭

| 약어 | 풀이 | 출처 |
|------|------|------|
| EPO | Extra Product Options (TM 플러그인) | buysangsang |
| TM | ThemeComplete (플러그인 회사) | buysangsang |
| WC | WooCommerce | buysangsang |
| WP | WordPress | buysangsang |
| CPF | Custom Product Form (TM 메타) | buysangsang `tm_meta_cpf` |
| TM Meta | Theme Complete Meta | buysangsang `_msdp_*`, `_mnks_*` |
| MShop | 엠샵 (Korea Commerce) — 한국 커머스 플러그인 마더 | buysangsang |
| NCE | Naver Cloud Edge (CDN 캐시) | Shopby |
| PitStop | PDF 검수 자동화 도구 (Enfocus PitStop) | 정책체크리스트 |
| SCV | (후지필름) 생산관리 파일 포맷 | 주문프로세스 p.5 |
| PG | Payment Gateway | A-5-1 |
| KCP | NHN KCP (PG사) | 운영정책 #7 |
| VAT | Value Added Tax (부가가치세 10%) | xlsx `calc_taxes=YES` |
| SLA | Service Level Agreement | 공정관리 PDF |
| KPI | Key Performance Indicator | 공정관리 p.2 |
| OEM | Original Equipment Manufacturer | 주문프로세스 p.5 (4채널) |
| B2B | Business-to-Business | 정책체크리스트 |
| B2C | Business-to-Consumer | Shopby |
| ERP | Enterprise Resource Planning | CUSTOM 필수 개발 #6 |
| OAuth | Open Authorization | A-1-SNS2 |
| BFF | Backend For Frontend | D-004 |
| API | Application Programming Interface | — |
| CDN | Content Delivery Network | Shopby NCE Cache |
| CRD | Custom Resource Definition | — |
| SKU | Stock Keeping Unit | xlsx ID 컬럼 추정 |
| FK | Foreign Key | DB 무결성 |

---

## 11. UI 표시 라벨 (사용자 표시 권장 한국어)

| 내부 코드 | UI 표시 라벨 (권장) | 비고 |
|---------|---------|------|
| `quote_wizard` | "견적 마법사" | 친근감 |
| `quote` | "예상 견적" | 정확성 |
| `option_storage` | "내 옵션 보관함" | 마이페이지 |
| `printing_money` | "프린팅머니" | 후니 자체 브랜딩 |
| `unpaid` | "입금 대기" | 친근 |
| `paid` | "결제 완료" | 명확 |
| `preparing` | "제작 대기 중" | |
| `producing` | "제작 중" | |
| `done` | "제작 완료" | |
| `shipped` | "출고 완료" / "배송 중" | 택배는 "배송 중" 권장 |
| `cancelled` | "주문 취소" | |
| `file_upload` | "파일 업로드" | |
| `edicus_editor` | "디자인 편집기" | "Edicus" 노출 X |
| `quantity_discount` | "수량 할인" | |
| `vat_included` | "부가세 포함" | |

✅ **DECISION D-PM-35 (Decided 2026-05-28):** 외부 브랜드명 사용자 노출 **금지**. 모두 후니 자체 브랜드 라벨로 변환 (잠정안 A 채택).

**외부 브랜드 → 후니 라벨 변환표:**

| 외부 브랜드 | 사용자 노출 라벨 | 내부 문서 표기 |
|---|---|---|
| Edicus | "에디터" 또는 "디자인 에디터" | Edicus |
| Aurora | "쇼핑몰 운영" (내부 노출 시에만) | Aurora |
| MShop | "모바일 쇼핑몰" | MShop |
| Shopby | (사용자 노출 없음, 백엔드 전용) | Shopby |

---

## 12. 본 문서 신규 등록 결정 항목

| ID | 내용 | 권장 |
|----|------|---|
| D-PM-35 | UI 라벨 외부 브랜드명 노출 정책 | 노출 금지 (후니 라벨로 변환) |

---

## 13. 출처

- `docs/huni/후니프린팅_상품마스터_260527.xlsx` 13 시트 (소재·종이·후가공 용어)
- `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 19 시트 (가격·후가공 용어)
- `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf` 2 페이지 (공정·부서 용어)
- `docs/huni/후니프린팅_주문프로세스_20251001.pdf` 12 페이지 (주문·파일·채널 용어)
- `docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx` 5 시트 (정책·BFF·플러그인 용어)
- `_workspace/print-quote/01_research/crawl-evidence/2026-05-27_buysangsang/C_findings.md` (TM EPO, MShop, EDICUS 등)
- `_workspace/print-quote/01_research/shopby/SHOPBY_FINDINGS.md` (Shopby, Aurora, NCE 등)
