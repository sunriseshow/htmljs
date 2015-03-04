func_url = __F 'url'
module.exports.controllers =
  "/":
    get:(req,res,next)->
      func_url.count condition,(error,count)->
        if error then next error
        else
          res.locals.total=count
          res.locals.totalPage=Math.ceil(count/20)
          res.locals.page = (req.query.page||1)
          func_url.getAll res.locals.page,20,{},"visit_count desc",(error,urls)->
            res.locals.urls = urls
            res.render 'urls.jade'
  "/add":
    get:(req,res,next)->
      if req.query.url
        func_url.getByPath req.query.url,(error,u)->
          if u
            res.send u
          else
            func_url.add
              path:req.query.url
            ,(error,u)->
              if error
                next error 
                return
              func_url.getUUSById u.id,(error,uus)->
                if error 
                  next error
                else
                  func_url.update u.id,{key:uus.key},(error,url)->
                    if error
                      next error
                    else
                      res.send url
      else
        next new Error '错误的参数'
  "/:id":
    get:(req,res,next)->
      func_url.getByKey req.params.id,(error,u)->
        if u
          func_url.addCount u.id,['visit_count']
          res.redirect u.path
        else
          next error

  
