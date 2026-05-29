import urllib.request, re, ssl

ctx = ssl._create_unverified_context()

with open('lib/models/models.dart', 'r', encoding='utf-8') as f:
    content = f.read()

urls = re.findall(r"imageUrl: '(https://[^']+)'", content)
names = re.findall(r"name: '([^']+)'", content)

for name, url in zip(names, urls):
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        resp = urllib.request.urlopen(req, timeout=8, context=ctx)
        size = len(resp.read())
        print(f'OK [{size}b] {name}')
    except Exception as e:
        print(f'BROKEN {name}: {e}')
