func_job = __F 'job/job'
module.exports = (req,res,next)->
  if res.locals.user
    func_job.hasZan req.params.id,res.locals.user.id,(error,zan)->
      if zan
        res.locals.has_zan = true
      else
        res.locals.has_zan = false
      next()
  else
    res.locals.has_zan = false
    next()