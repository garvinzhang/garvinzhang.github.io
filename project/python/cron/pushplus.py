# encoding:utf-8
import requests
import json
token = 'e6d6cd1021b343dba8e4ba25750632f1' #在pushpush网站中可以找到
title= '标题' #改成你要的标题内容
content ='内容test' #改成你要的正文内容
url = 'http://www.pushplus.plus/send'
data = {
    "token":token,
    "title":title,
    "content":content
}
body=json.dumps(data).encode(encoding='utf-8')
headers = {'Content-Type':'application/json'}
requests.post(url,data=body,headers=headers)
