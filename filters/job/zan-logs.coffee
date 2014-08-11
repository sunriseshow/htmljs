func_job = __F 'job/job'
module.exports = (req,res,next)->
  func_job.getZans req.params.id,(error,zans)->
    res.locals.zan_logs = zans
    next()