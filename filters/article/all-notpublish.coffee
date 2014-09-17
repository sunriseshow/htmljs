module.exports = (req,res,next)->
  if not res.locals.user
    next();
    return;
  condition = 
    is_publish:0
    is_yuanchuang:1
    user_id:res.locals.user.id
  (__F 'article/article').getAll 1,30,condition,(error,articles)->
    if error then next error
    else
      res.locals.nopublish_articles = articles
      next()