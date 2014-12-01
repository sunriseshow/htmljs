tip_func = __F "tip"
func_article = __F 'article/article'
moment = require 'moment'
moment.lang('zh-cn')
config = require './../config.coffee'
Sina=require("./../lib/sdk/sina.js")
sina=new Sina(config.sdks.sina)
module.exports.controllers =

  "/add":
    post:(req,res,next)->
      req.body.user_id = res.locals.user.id
      req.body.user_nick = res.locals.user.nick
      req.body.user_headpic = res.locals.user.head_pic
      tip_func.add req.body,(error,tip)->
        res.send tip
        if !req.body.parent_id
          func_article.getById req.body.target_id,(error,article)->
            if article
              sina.statuses.update
                access_token:res.locals.user.weibo_token
                status:'我在@前端乱炖 为原创文章《'+article.title+'》http://www.html-js.com/article/'+req.body.target_id+'添加了一枚【评注】:'+req.body.content
  "/:id":
    get:(req,res,next)->
      tip_func.getById req.params.id,(error,tip)->
        tips = [tip]
        tip_func.getAll 1,30,{parent_id:req.params.id},"id asc",(error,ts)->
          if ts
            tips = tips.concat(ts)
          if tips&&tips.length
            tips.forEach (tip)->
              tip.dataValues.time =  moment(tip.createdAt).fromNow()
              console.log(tip)
          res.send tips
  "/p/:id":
    get:(req,res,next)->
      tip_func.getAllByTargetId req.params.id,(error,tips)->

        res.send tips


module.exports.filters =
  "/add":
    post:["checkLoginJson"]