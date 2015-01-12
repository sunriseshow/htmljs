config = require './../config.coffee'
authorize=require("./../lib/sdk/authorize.js");
md5 = require 'MD5'
fs = require ("fs")
Sina=require("./../lib/sdk/sina.js")
sina=new Sina(config.sdks.sina)
uids =  ["2252437617", "1846033411", "2178801065", "1831341547", "5141278301", "2681090281", "2806931970", "3292220974", "2972790670", "3386378800", "1784310664", "1742204845", "2929980180", "2689385573", "5283165711", "1677535517", "3803546831", "1799944952", "3911319195", "2643806542"]
accesses = [
  '2.00wVkPsB0TxWcicc5109411a3ZiiaE',
  '2.00fsus3D0TxWci14bea75806wgrFKE',
  '2.00hD64tB0TxWci4963829b470VOKJE',
  '2.00bQrlEC0TxWci8873a0be81Wuh9aC',
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
    comment:"iphone或者ipad，在AppStore搜索“颜文字输入法”下载后，在【最近精选】分类里就能找到这个表情啦，可以直接集成到输入法哦，N多分类表情，2000"+(if Math.random()>0.5 then "+" else "多")+"颜文字。"
    access_token:accesses[index]
    rip:"122.224.209.220"
  ,(error,message)->
      if error&&(error.message=="发布内容过于频繁")
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