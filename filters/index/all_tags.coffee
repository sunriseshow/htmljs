func_tag = __F 'qa/channel'
module.exports = (req,res,next)->
  if req.query.page 
    next()
    return
  func_tag.getAll 1,100,null,"id asc",(error,tags)->
    res.locals.tags = tags
    next()