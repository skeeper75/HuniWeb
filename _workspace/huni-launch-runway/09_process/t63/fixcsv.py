import re
path = 'ev-opt.csv'
with open(path, encoding='utf-8') as f:
    text = f.read()
fixes = {
    '별색은 공정(PROCSEL, 예 뒷면별색)으로 선택되고': '별색은 공정(PROCSEL·예 뒷면별색)으로 선택되고',
    'TPrdProductSizes(상품별사이즈, dflt_yn)가': 'TPrdProductSizes(상품별사이즈·dflt_yn)가',
    '수량 구간이 적으면 select 프리셋(5019~), 많으면': '수량 구간이 적으면 select 프리셋(5019~) 많으면',
    '코팅 선택 UI는 확인되나, 가격 매칭 세부는': '코팅 선택 UI는 확인되나 가격 매칭 세부는',
    '직경 병기 로직(공정 판정용, 877행 부근)은': '직경 병기 로직(공정 판정용·877행 부근)은',
    '도무송은 상품명(합판도무송스티커)으로만 코드에서 확인되고, TProcProcesses': '도무송은 상품명(합판도무송스티커)으로만 코드에서 확인되고 TProcProcesses',
    'PRICE_TYPE.03(고정금액=매칭 구간 금액 그대로, 수량 무관)이': 'PRICE_TYPE.03(고정금액=매칭 구간 금액 그대로·수량 무관)이',
}
for old, new in fixes.items():
    if old not in text:
        print('MISSING:', old)
    text = text.replace(old, new)
with open(path, 'w', encoding='utf-8') as f:
    f.write(text)
print('done')
