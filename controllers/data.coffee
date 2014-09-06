fs = require 'fs'

if fs.existsSync './data.json'
  data = require './../data.json'
else
  data = 
    share_friend_count:0
    open_count:0
    share_timeline_count:0
module.exports.controllers = 
  "/add_share_friend":
    get:(req,res,next)->
      data.share_friend_count=data.share_friend_count*1+1
      fs.writeFileSync './data.json',JSON.stringify(data)
      res.send 'ok'
  "/add_share_timeline":
    get:(req,res,next)->
      data.share_timeline_count=data.share_timeline_count*1+1
      fs.writeFileSync './data.json',JSON.stringify(data)
      res.send 'ok'
  "/add_open":
    get:(req,res,next)->
      data.open_count=data.open_count*1+1
      fs.writeFileSync './data.json',JSON.stringify(data)
      res.send 'ok'
  "/show":
    get:(req,res,next)->
      res.send '浏览量：'+data.open_count+"<br/>"+"分享到朋友圈："+data.share_timeline_count+"<br/>"+"分享到好友："+data.share_friend_count+"<br/>"

