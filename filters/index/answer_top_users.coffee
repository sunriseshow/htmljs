func_count = __F 'user/count'
module.exports = (req,res,next)->
  func_count.getTopUser "answer_count",12,(error,users)->
    if users
      res.locals.answer_top_users = users
    next();