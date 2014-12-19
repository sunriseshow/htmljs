module.exports.controllers =
  "/":
    get:(req,res,next)->
      res.render 'app/index'
  "/column":
    get:(req,res,next)->
      res.render 'app/column'
  "/blog/:id":
    get:(req,res,next)->
      res.locals.id = req.params.id
      res.render 'app/blog'
  "/article/:id":
    get:(req,res,next)->
      res.locals.id = req.params.id
      res.render 'app/article'
