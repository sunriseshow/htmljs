module.exports.controllers =
  "/":
    get:(req,res,next)->
      res.render 'music/all.jade'