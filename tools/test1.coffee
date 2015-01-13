config = require './../config.coffee'
authorize=require("./../lib/sdk/authorize.js");
md5 = require 'MD5'
fs = require ("fs")
Sina=require("./../lib/sdk/sina.js")
sina=new Sina(config.sdks.sina)
uids =  ["2252437617", "1846033411", "2178801065", "1831341547", "5141278301", "2681090281", "2806931970", "3292220974", "2972790670", "3386378800", "1784310664", "1742204845", "2929980180", "2689385573", "5283165711", "1677535517", "3803546831", "1799944952", "3911319195", "2643806542"]
accesses = [
#  '2.00wVkPsB0TxWcicc5109411a3ZiiaE',
#  '2.00fsus3D0TxWci14bea75806wgrFKE',
#  '2.00hD64tB0TxWci4963829b470VOKJE',
#  '2.00bQrlEC0TxWci8873a0be81Wuh9aC',
  '2.00Zc6zuB0TxWciaae5b2e9c1Jp_LbB',
  '2.00XEnI3C0TxWci3b1100993avhw27D',
  '2.00L8rMJC0TxWcib158f34f1b0IE_n8',
  '2.00WuTR6C0TxWci330e3df100SqTUVE',
  '2.00LwfzbC0TxWci7478c964a1004jA2',
  '2.00vOHeED0TxWcib434c18d8evi6zWE',
  '2.00t5SBVD0TxWci21de38d87ctXC5PD',
  '2.00MzSjqB0TxWci450decf736Yau2BB',
  '2.001omjGC0TxWci3ff7bff1570apl3x',
  '2.006M6mvB0TxWcic028679d6ejfmfWC',
  '2.00NzjtED0TxWci749431db2b0bsdeR'
  '2.00LNw1AC0TxWcid3264a746erDEGDC',
  '2.00h9IY2C0TxWci605c66717d3AZ5bE',
  '2.005uhVWD0TxWci4b0fd154cfklQ7HE',
  '2.00fS7egC0TxWci26e5cbe91e049Rnz',
  '2.000I6BeE0TxWci81f3b8f259s_RYKE',
  '2.00zd96FC0TxWci5026a22774xgfV1C',
  '2.00VYDhqC0TxWcicd2fc91331LzMWQE'
]
queuedo = require("queuedo")

uids = require("./comments.json")
commented = require("./commented.json")

weiboid = "3797563129883982"
index = 0;
queuedo uids,(id,next,context)->
  if commented.indexOf(id) != -1
    next.call(context)
    return
  if(index>=accesses.length)
    process.exit()
  sina.comments.create
    id:id
    comment:"我一直在用另一个更好用的“颜文字 输入法”，切换速度比这个快多了，而且表情更多更逗比，AppStore搜索“颜文字 输入法”第一个就是。"
    access_token:accesses[index]
    rip:"122.224.209.220"
  ,(error,message)->
      if error&&(error.message=="发布内容过于频繁"||error.message=="用户不存在"||error.message=="用户请求特殊接口 (%s) 频次超过上限")
        console.log error
        index++
        console.log("now:"+accesses[index])
        return
      if (!error)
        console.log("success")
        commented.push(id)
        fs.writeFileSync './commented.json',JSON.stringify(commented,null,4),'utf-8'
      else
        console.log error
        commented.push(id)
        fs.writeFileSync './commented.json',JSON.stringify(commented,null,4),'utf-8'
  setTimeout ()->
    next.call(context)
  ,1500
,()->
  console.log("end")