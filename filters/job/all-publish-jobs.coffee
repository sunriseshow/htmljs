func_job = __F 'job/job'

module.exports = (req,res,next)->
  condition = 
    is_publish:1
  if res.locals.user && res.locals.user.is_admin
    condition = {}
  page = req.query.page || 1
  count = req.query.count || 20
  func_job.count condition,(error,_count)->
    if error then next error
    else
      res.locals.total=_count
      res.locals.totalPage=Math.ceil(_count/count)
      res.locals.page = (req.query.page||1)
      func_job.getAll page,count,condition,'sort desc,id desc',(error,jobs)->
        if error then next error
        else
          res.locals.jobs = jobs
          next()