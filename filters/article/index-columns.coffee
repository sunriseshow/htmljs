func_column = __F 'column'
module.exports = (req,res,next)->

  func_column.count {is_publish:1},(error,count)->
    if error then next error
    else
      res.locals.total=count
      res.locals.totalPage=Math.ceil(count/30)
      res.locals.page = (req.query.page||1)

      
    func_column.getAll res.locals.page,30,null,"article_count desc",(error,columns)->
      if error then next error
      else
        columns.sort (r1,r2)->
          return if Math.random()>0.5 then 1 else -1
        res.locals.columns = columns.splice(0,13)
        next()