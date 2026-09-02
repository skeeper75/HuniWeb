import json,sys,re
S=json.load(open('L4/b/_legacy-slim.json'))
pat=re.compile('|'.join(sys.argv[1:]))
for i in S:
    if pat.search(i['기능서술']):
        print(f"{i['legacy_id']}|{i['원천']}|{i['원판정']}|{i['돈여부']}|{i['주문여부']}|{i['기능서술'][:110]}")
