module.exports = (req,res,next)->
  if res.locals.user
    (__F 'column').getAll 1,100,{is_public:1},"last_article_time desc,visit_count desc",(error,columns)->
      res.locals.public_columns = columns
      next()
  else
    res.locals.public_columns = []
    next();
