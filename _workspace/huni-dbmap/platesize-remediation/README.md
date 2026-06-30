# 상품별 판형(plate_size) 오류 진단·교정 (2026-06-30)

> 권위=상품마스터 260610 "파일사양_출력용지규격" + 판걸이수 시트(pangeori). 결정론 스크립트·라이브 읽기전용+승인 COMMIT.
> 판형(plate_size)=출력 전지규격[HARD·종이류만]. pricing.py: 판수=fn_calc_pansu(판형 work−margin, 완제품 work).

## 결론 (COMMIT 3건)

- **가격결함(견적0) 1건 = 썬캡051 → COMMIT**: 판형 SIZ_000195(완제품313x400) → SIZ_000499(국4절). 견적0→용지153 매칭.
- **상품-판형 매핑 오적재 17상품 → COMMIT**: 완제품/재단 사이즈가 판형 자리에 적재된 것을 권위 전지규격으로 정합(여분삭제13+전지교체4). 권위 대조 18→1.
- **★비종이류 판형 오적재 127상품·252행 → COMMIT(논리삭제)**: 아크릴/실사/보드/굿즈 등 비종이류는 출력 전지 판형이 없어야 하는데 완제품 사이즈가 판형 자리에. 4중 확증(자재 비종이+spine 비종이+output_paper_typ 빔+상품뷰어 라이브)으로 논리삭제. 비종이+빔 판형 262→18. undo `nonpaper-fix-undo.sql`.
- **머그컵193 판형 오분류 수정 → COMMIT(논리삭제)**: 자재 .01에 PET 섞이고 .12(굿즈 머그) 보유→종이류로 오분류돼 127건에서 누락. 실제 굿즈 승화전사(판형축 comp 미사용·전지출력 아님)라 판형 불필요. SIZ_000392(190x80) 논리삭제. undo `mug-fix-undo.sql`. ★대조: 투명엽서019는 PET를 전지(국4절)에 출력하는 디지털인쇄(PRF_DGP_A·COMP_PAPER)라 판형 정상=삭제 금지(false-positive).
- **보류**: 투명엽서019(1mm차) · A2/A1 여백 · 종이류+출력유형빔 20상품(명함/엽서 검토) · 비종이+빔 잔여 18.

## ★판형 적재 판정 신호 (상품뷰어 라이브로 발견)

- **종이류 여부[HARD 1차]**: 자재유형 종이(.01/.11/.13/.14/.18/.21)+§29 spine. 비종이류(아크릴.03/.20·실사.08·보드.16·굿즈.12)는 판형 자체 불필요.
- **output_paper_typ_cd**: 전지규격이면 채움(예 "국전계열"), 완제품 오적재면 빔. = 상품뷰어 "출력용지유형코드" 컬럼.
- **상품뷰어 검증**: 펄명함=316x467 국전계열(정상)·아크릴코스터=104x104 빈값(오적재). product-viewer/<prd>/ "판형" 섹션.
- ★진단 교훈: impos_yn만으로 "면적가=완제품판형 정당" 합리화는 오류. 종이류 여부를 1차 기준으로.

## 진단 방법 (결정론 스크립트)

| 스크립트 | 역할 | 결과 |
|---|---|---|
| `diagnose.py` | COMP_PAPER 판형 정합(상품판형↔자재 단가판형) | 썬캡 1건 |
| `diagnose_all.py` | 전 판형축 comp(인쇄비·코팅·도무송·용지) 미스매치 | 썬캡 3 comp 전부 |
| `audit_impos.py` | impos_yn 기준 판형/완제품 분류 | A 정상96·B 결함1·C 비판형338 |
| `audit_impos2.py` | C 분해(면적가 정당 vs 완제품가 오적재) | C2 종이인쇄 50상품 |
| `authority_audit.py` | 권위 출력용지규격↔라이브 plate_size 대조 | 18건 불일치(교정후 1) |
| `gen_fix.py`·`gen_authority_fix.py` | 교정 SQL 생성(UPDATE/논리삭제/INSERT)+dryrun+undo | — |

## 핵심 원리 (재사용)

1. **판형=출력 전지규격**(impos_yn=Y·국4절 SIZ_000499 316x467 등). 완제품/재단 사이즈(impos_yn=N)가 plate_size에 들어가면 오적재.
2. **fn_calc_pansu**(`raw/webadmin/sql/32_fn_calc_pansu.sql`): 판형 work−margin(인쇄영역) ÷ 완제품 work = 판수. 판형은 work+margin 필수.
3. **판형 마스터 현황**: 국4절·3절·A3·330x470·315x467 완비 / **A2·A1 여백 미등록**(단 대형출력 판형·판형축 comp 미사용→가격영향 0·권위 부재로 보류).
4. **가짜결함 가드**: C 338행 중 면적가 상품(아크릴굿즈·실사·현수막)은 1:1 출력이라 완제품=판형 정당(false-positive). 종이인쇄(명함·책자·스티커·노트)만 진짜 오적재.

## COMMIT 내역 / undo

- 썬캡: `UPDATE … SIZ_000195→SIZ_000499` (undo `platesize-fix-undo.sql`).
- 매핑 17: `authority-fix-COMMIT.sql`(UPDATE 40 논리삭제+INSERT 4 전지·undo `authority-fix-undo.sql`).
- 보류: 투명엽서019·A2/A1 여백·C3 공식미바인딩 92상품(판형 판정 보류).

## 재현
```bash
bash _workspace/_foundation/live-snapshot/snapshot.sh
cd _workspace/huni-dbmap/platesize-remediation
python3 diagnose_all.py && python3 audit_impos.py && python3 audit_impos2.py && python3 authority_audit.py
```
