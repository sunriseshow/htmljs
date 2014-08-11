func_job = __F 'job/job'
module.exports = (req,res,next)->
  func_job.getAll 1,10,{"company_city":res.locals.job.company_city},'sort desc,id desc',(error,jobs)->
    res.locals.city_jobs = jobs;
    next()