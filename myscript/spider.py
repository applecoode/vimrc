import requests
import urllib3
from lxml.html import parse

def get_news_list(url,findstr='.//ul[@class="n_news_ul"]/li/a'):
    parsed = parse(url)
    htmlroot = parsed.getroot()
    aaa = htmlroot.findall(findstr)
    #print(len(aaa))
    aaa = aaa[:9]
    if url == 'http://10.1.24.57:9080/zaj/jsp/news_flshowvideo.jsp?fldm=301003':
        return [i.get('title')[0:-26] for i in aaa]
    return [str(i.text_content()).strip() for i in aaa]

def get_news_list1(url,findstr):
    r = requests.get(url)
    html = etree.HTML(r.text)
    aaa = html.xpath(findstr)
    aaa = aaa[:9]
    return aaa


if __name__=='__main__':
    url = 'http://10.54.49.9/Gongan/news_list.shtml?id=27'
    url2 = 'http://10.48.146.221/ReceiveArticleShow.asp'
    url3 = 'http://10.1.24.57:9080/zaj/jsp/news_flshowvideo.jsp?fldm=301003'
    url4 = 'http://10.48.142.34/module/permissionread/col/col105/col_105.jsp?i_columnid=105&ptype=1'
    url5 = 'http://10.48.142.34/module/permissionread/col/col634/col_634.jsp?i_columnid=634&ptype=1'
    a = get_news_list(url)
    b = get_news_list(url,findstr='.//ul[@class="n_news_ul"]/li/span')
    c = get_news_list(url2,'.//td[@width="367"]')
    d = get_news_list(url2,'.//td[@width="214"]')
    e = get_news_list(url3,'.//a')
    vim.current.buffer.append([''])
    vim.current.buffer.append(['--'*20,'市局通知','--'*20])
    vim.current.buffer.append([i+' '+j for (i,j) in zip(a,b)])
    vim.current.buffer.append(['--'*20,'',''])
    vim.current.buffer.append(['--'*20,'省厅通知','--'*20])
    vim.current.buffer.append([i+' '+j for (i,j) in zip(c,d)])
    vim.current.buffer.append(['--'*20,''])
    vim.current.buffer.append(['--'*20,'三局通知','--'*20])
    vim.current.buffer.append(e)

