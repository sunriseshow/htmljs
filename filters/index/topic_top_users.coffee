func_count = __F 'user/count'
module.exports = (req,res,next)->
  func_count.getTopUser "topic_comment_count",12,(error,users)->
    if users
      res.locals.topic_top_users = users
    next();