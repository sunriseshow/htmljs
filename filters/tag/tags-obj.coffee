module.exports = (req,res,next)->
  (__F 'tag').getAll 1,200,null,"id desc",(error,tags)->
    ts = {}
    tags.forEach (t)->
      ts[t.id]= t
    res.locals.ts = ts
    next()