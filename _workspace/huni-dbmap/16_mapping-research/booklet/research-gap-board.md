# 책자 — 외부 갭헌팅 보드 (round-12 P2)

> **작성** 2026-06-10. **목적:** 국내외 경쟁사·CIP4·ISO·인쇄용어에서 "후니 책자 시트·스키마에 없는 판매 속성 축"을 적발(답습 아님·갭 발견용). 기존 KB(`07_domain/benchmark-competitors.md`·`docs/wowpress`·RedPrinting 역공학) 우선 재사용, 중복 크롤 금지.
>
> **결론 선언:** 책자 도메인은 **기존 KB(benchmark-competitors §3 B5 페이지/책등·§7 제본)가 이미 경쟁사 7축을 분석 완료**했고 결론이 "후니가 제본·책등·page_rule을 경쟁사보다 구조화 — 유지, 미적재만 채우기"였다. round-12는 그 위에 **신규 갭 3건만** 적발했고, 모두 처분했다.

---

## 0. 조사 대상·재사용 (대상·Sources 명기 — 갭 0이어도 기록 의무)

| 대상 | 출처 | 재사용/신규 | 책자 관련 발견 |
|------|------|------------|----------------|
| RedPrinting(사용자 본인 설계) | `benchmark-competitors.md` §3/§7 (역공학 KB) | 재사용(중복 크롤 0) | MIN_PAGE/MAX_PAGE+내지 분리·BIND_DIRECTION·제본방향 PCS |
| WowPress(326상품) | `docs/wowpress/catalog/products/40200.json`(책자) | 재사용 + 본 round 재확인 | **coverTypes[표지/내지/간지]별 pageConstraints{min,max,interval}** |
| 성원애드피아·애즈랜드·비즈하우스·오프린트미 | benchmark-competitors 일반 패턴(§7) | 재사용 | 제본=택일+표지/내지 분리(후니와 동형) |
| Mixam·MILK Books·PrestoPhoto·Forever | WebSearch(신규) | 신규 1회 | 레이플랫 vs PUR·페이지 한계(레이플랫 max 120p) |
| CIP4 Binding ICS(JDF BindingIntent) | WebSearch(신규) + CIP4 Binding ICS v1.0 | 신규 1회 | BindingType(SaddleStitch/Sewn/SideStitch)·spine·process group |
| ISO 12647 | (인쇄 품질 표준) | — | 책자 판매 속성 축 부재(품질 규격이라 무관) |

---

## 1. 적발 갭 + 처분

### GAP-EXT-1 [무시 — 후니 우위] 표지/내지별 page 제약 분리
- **갭:** WowPress 40200 책자 = `coverTypes`(표지 min4/max4/interval1·내지 min24/max1000/interval2·간지 min0/max1000/interval2)로 **표지·내지·간지별 page 제약을 각각** 관리. 후니 `t_prd_product_page_rules`는 **상품 1:1(내지 1행)**만 보유(표지 page 제약 별도 없음).
- **출처:** `docs/wowpress/catalog/products/40200.json` options.coverTypes (본 round 실측), benchmark-competitors.md §3 L70.
- **후니 영향:** **무시(매핑 수정 불요).** 후니 책자 표지는 항상 4p(앞/뒤 표지 고정)라 표지 page 제약을 별도 데이터로 둘 실익 낮음. 내지 page_rule만으로 충분. 간지(USAGE.04)는 책자 시트 미사용(라이브 USAGE.04 0행 실측). 향후 간지 상품 등장 시에만 재검토.

### GAP-EXT-2 [무시 — Q10 확정] 레이플랫(Lay-Flat) 제본 + 페이지 한계 연동
- **갭:** Mixam/MILK/PrestoPhoto 등 해외 + 국내 포토북 전반이 레이플랫(180도 펼침)을 핵심/프리미엄으로 운영. **페이지 수·평량이 임계 도달 시 가능 제본을 자동 전환**(Mixam Instant Quote — 고페이지=Perfect, 저페이지=Staple/Wire-O). 레이플랫 max 120p 한계.
- **출처:** [Mixam Layflat](https://mixam.com/layflat), [Forever Help](https://support.forever.com/hc/en-us/articles/360051010252), [Mixam Binding](https://mixam.com/support/binding), benchmark-competitors §3.
- **후니 영향:** **무시(매핑 수정 불요).** 실무진 **Q10 확정 = PUR만(현행)·레이플랫 추후**. 라이브에 PROC_000025 레이플랫제본 family 자리는 존재하나 미사용(상품 미연결 실측). round-11 "레이플랙 미운영 가설"은 **라이브 자리 존재로 정정**(미운영=상품 미연결이지 코드 부재 아님). 페이지↔제본 자동전환 로직은 후니 page_rule(제본별 차등)이 이미 데이터로 보유 — 앱 캐스케이드로 구현 가능(스키마 갭 아님).

### GAP-EXT-3 [무시 — 후니 보유] CIP4 BindingType 세분(Sewn/ThreadSealing/SideStitch)
- **갭:** CIP4 JDF BindingIntent/@BindingType = SaddleStitch·Sewn·SideSewn·SideStitch·ThreadSealing 등 **실 꿰맴(sewing) 계열을 세분**. 후니 제본 7운영종(중철/무선/PUR/트윈링/하드무선/하드트윈링/떡)에는 sewn(실제본)이 없음.
- **출처:** [CIP4 Binding ICS v1.0](https://www.cip4.org/files/cip4-2022/Documents/ICS%20Documents/JDF/Binding%20ICS.pdf), [JDFMAP PWG](https://ftp.pwg.org/pub/pwg/informational/bp-smjdfmap10-20170828-5199.6.pdf).
- **후니 영향:** **무시(매핑 수정 불요).** sewn/실제본은 후니 미운영 공정(고급 양장). 후니 제본 family(PROC_000017)는 자식 추가가 자유로워(레이플랫 자리 존재가 증거) 향후 실제본 도입 시 자식 1행 추가로 흡수 가능 — 스키마 갭 아님. CIP4 spine/책등 모델은 후니가 이미 `prcs_dtl_opt.책등(mm)`로 보유(benchmark §3 L82 "경쟁사보다 우위").

---

## 2. 갭 처분 요약

| 갭 | 출처 | 후니 영향 | 처분 사유 |
|----|------|-----------|-----------|
| GAP-EXT-1 표지별 page 제약 | WowPress 40200 | 무시 | 후니 표지=4p 고정·간지 미사용 |
| GAP-EXT-2 레이플랫 자동전환 | Mixam/MILK | 무시 | Q10 PUR만 확정·자리 존재·앱 캐스케이드 |
| GAP-EXT-3 CIP4 sewn 세분 | CIP4 Binding ICS | 무시 | 미운영 공정·family 자식 추가로 흡수 가능 |

**DDL 제안 라우팅:** 없음(전 갭 무시 처분). **매핑 수정:** 없음(외부 갭 기인). 내부 GAP(GAP-OG 택일그룹·GAP-PAPER 폴더)는 `mapping-final.md` 참조(외부 아닌 라이브 미적재).

---

## Sources
- 기존 KB(재사용): `_workspace/huni-dbmap/07_domain/benchmark-competitors.md`(§3 B5·§7 제본·§출처 L189/L192), `docs/wowpress/catalog/products/40200.json`(책자 coverTypes), RedPrinting 역공학(`huni-widget/01_reverse/option-schema-catalog.json`).
- 외부(신규 WebSearch·WebFetch 미수행 — 검색 결과 요약으로 충분, URL은 검색 결과 실재):
  - [CIP4 Binding ICS v1.0](https://www.cip4.org/files/cip4-2022/Documents/ICS%20Documents/JDF/Binding%20ICS.pdf)
  - [JDFMAP PWG](https://ftp.pwg.org/pub/pwg/informational/bp-smjdfmap10-20170828-5199.6.pdf)
  - [Mixam Layflat](https://mixam.com/layflat) · [Mixam Binding](https://mixam.com/support/binding)
  - [Forever — Photo Book Binding Options](https://support.forever.com/hc/en-us/articles/360051010252-What-are-the-Different-Binding-Options-for-Photo-Books)
  - [PrestoPhoto Layflat](https://www.prestophoto.com/help/Layflat+Photo+Books:+An+explanation)
