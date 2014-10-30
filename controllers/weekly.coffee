module.exports.controllers =
  "/":
    get:(req,res,next)->
      res.render 'weekly/index.jade'
