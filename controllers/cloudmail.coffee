func_mail = __F 'cloudmail'
module.exports.controllers = 
  "/post_raw/recieve":
    post:(req,res,next)->
      console.log req.body
      console.log req.file
      func_mail.add req.body,(error)->
        console.log error
      res.send "ok"
