func_comment = __F 'job/comment'

module.exports = (req,res,next)->
  condition = 
    job_id:req.params.id
  page = req.query.page || 1
  count = req.query.count || 30
  func_comment.count condition,(error,_count)->
    if error then next error
    else
      if not req.query.page and _count>30
        page = Math.ceil(_count/30)
      res.locals.total=_count
      res.locals.totalPage=Math.ceil(_count/count)
      res.locals.page = (page||1)
      func_comment.getAll page,count,condition,"id",(error,comments)->
        if error then next error
        else
          res.locals.comments = comments
          next()