
func_article = __F 'article/article'
module.exports = (req,res,next)->
  if res.locals.article.is_buy
    func_article.canReaders res.locals.article.id,(error,payers)->
      if payers
        res.locals.payers = payers
      next()
  else
    next()