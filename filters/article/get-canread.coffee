
func_article = __F 'article/article'
module.exports = (req,res,next)->
  if res.locals.user
    func_article.checkCanRead res.locals.user.id,res.locals.article.id,(error)->
      if not error
        res.locals.can_read = 1
      next()
  else
    next()