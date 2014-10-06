func_count = __F 'user/count'
module.exports = (req,res,next)->
  func_count.getTopUser "article_count",10,(error,users)->
    if users
      res.locals.article_top_users = users
    next();