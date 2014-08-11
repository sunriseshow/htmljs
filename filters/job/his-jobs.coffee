func_job = __F 'job/job'
module.exports = (req,res,next)->
  func_job.getAll 1,10,{"user_id":res.locals.job.user_id},'sort desc,id desc',(error,jobs)->
    res.locals.user_jobs = jobs;
    next()