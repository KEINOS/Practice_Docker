#!/usr/local/bin/python

import cgi

html_body = """
<!DOCTYPE html>
<html>
<head>
<title>受信したデータを表示</title>
<style>
h1 {
font-size: 3em;
}
</style>
</head>
<body>
<h1>%s</h1>
</body>
</html>
"""

form = cgi.FieldStorage()
text = form.getvalue('text','')

print(html_body % (text))