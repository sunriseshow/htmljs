module.exports = (req,res,next)->
  if res.locals.user

    (__F 'job/resume').getByField "user_id",res.locals.user.id,(error,resume)->
      if error
        next error
      else
        res.locals.resume = resume
        next()
  else 
    next()