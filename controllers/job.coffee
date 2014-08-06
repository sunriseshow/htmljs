func_job = __F 'job/job'
func_resume = __F 'job/resume'
func_comment = __F 'job/comment'
pagedown = require("pagedown")
safeConverter =new pagedown.Converter()
pagedown.Extra.init(safeConverter);
config = require './../config.coffee'
Sina=require("./../lib/sdk/sina.js")
sina=new Sina(config.sdks.sina)
module.exports.controllers = 
  "/":
    get:(req,res,next)->
      res.render 'job/list'
  "/add":
    get:(req,res,next)->
      res.render 'job/add'
    post:(req,res,next)->
      func_job.add req.body,(error,job)->
        if error
          next error
        else
          res.redirect '/job'
  "/:id":
    get:(req,res,next)->
      func_job.getById req.params.id,(error,job)->
        if error then next error
        else
          res.locals.job = job
          res.render 'job/job'
  "/:id/add":
    post:(req,res,next)->
      req.body.html = safeConverter.makeHtml req.body.md
      req.body.user_id = res.locals.user.id
      req.body.user_headpic = res.locals.user.head_pic
      req.body.user_nick = res.locals.user.nick
      req.body.job_id = req.params.id
      func_comment.add req.body,(error,commment)->
        if error 
          res.send
            success:0
            info:error.message
        else
          res.send 
            success:1
  "/resume/add":
    get:(req,res,next)->
      res.render 'job/add-resume'
    post:(req,res,next)->
      func_resume.add req.body,(error,resume)->
        if error
          next error
        else
          res.redirect '/job'
  "/resume/edit/:id":
    get:(req,res,next)->
      func_resume.getById req.params.id,(error,resume)->
        if error then next error
        else
          res.locals.resume = resume
          res.render 'job/add-resume'

module.exports.filters = 
  "/":
    get:['freshLogin','job/all-publish-jobs','job/check-resume']
  "/add":
    get:['checkLogin']
  "/:id":
    get:['freshLogin',"job/comments"]
  "/:id/add":
    post:['checkLogin']
  "/resume/add":
    get:['checkLogin']
  "/resume/edit/:id":
    get:["checkLogin"]