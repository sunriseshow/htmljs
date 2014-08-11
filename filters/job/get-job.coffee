func_job = __F 'job/job'
module.exports = (req,res,next)->
  func_job.getById req.params.id,(error,job)->
    if error then next error
    else
      res.locals.job = job
      next()