func_job = __F 'job/job'

module.exports = (req,res,next)->
  condition = {is_jian:1}
  page = req.query.page || 1
  count = req.query.count || 10
  func_job.getAll page,count,condition,'id desc',(error,jobs)->
    if error then next error
    else
      res.locals.jian_jobs = jobs
      next()