func_job = __F 'job/job'
module.exports = (req,res,next)->
  func_job.hasZan req.params.id,res.locals.user.id,(error,zan)->
    if zan
      res.locals.has_zan = true
    else
      res.locals.has_zan = false
    next()