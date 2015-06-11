func_tag = __F 'tag'
pagedown = require("pagedown")
safeConverter = pagedown.getSanitizingConverter()
module.exports.controllers = 
  '/':
    get:(req,res,next)->

      res.render 'tag/index.jade'
  "/add":
    get:(req,res,next)->

      res.render 'tag/add.jade'
    post:(req,res,next)->
      req.body.desc = safeConverter.makeHtml req.body.desc_md
      func_tag.add req.body,(error,tag)->
        if error then next error
        else
          
          res.redirect '/tag'
  "/:id":
    get:(req,res,next)->
      func_tag.getById req.params.id,(error,tag)->
        if error then next error
        else if not tag then next new Error '不存在的标签'
        else
          func_tag.getQuestionsById tag.id,1,20,(error,qt)->
            res.locals.qts =  qt
            res.locals.tag = tag
            res.render 'tag/tag.jade'
  "/:id/articles":
    get:(req,res,next)->
      page = req.query.page || 1
      count = req.query.count || 20
      func_tag.getById req.params.id,(error,tag)->
        if error then next error
        else if not tag then next new Error '不存在的标签'
        else
          func_tag.countArticles tag.id,(error,_count)->
            if error then next error
            else
              func_tag.getArticlesById tag.id,page,count,(error,qt)->
                res.locals.articles =  qt
                res.locals.tag = tag
                res.locals.total=_count
                res.locals.totalPage=Math.ceil(_count/count)
                res.locals.page = (req.query.page||1)
                res.render 'tag/tag-article.jade'
  "/n/:name":
    get:(req,res,next)->
      func_tag.getByName req.params.name,(error,tag)->
        if error then next error
        else if not tag then next new Error '不存在的标签'
        else
          func_tag.getQuestionsById tag.id,1,20,(error,qt)->
            res.locals.qts =  qt
            res.locals.tag = tag
            res.render 'tag/tag.jade'
  "/:id/edit":
    get:(req,res,next)-> 
      func_tag.getById req.params.id,(error,tag)->
        if error then next error
        else
          res.locals.tag =tag
          res.render 'tag/add.jade'
    post:(req,res,next)->
      req.body.desc = safeConverter.makeHtml req.body.desc_md
      func_tag.update req.body.id,req.body,(error,tag)->
        if error then next error
        else
          res.redirect '/tag'    

module.exports.filters = 
  "/":
    get:['freshLogin','tag/all-tags']
  "/:id":
    get:['freshLogin']
  "/add":
    get:["checkLogin"]
    post:["checkLogin"]