mail = require './../lib/mail.js'
mustache = require 'mu2'
config = require './../config.coffee'

buffer = ""

mustache.compileAndRender('./../static/htmljs-weekly-clear.html', {})
.on 'data',(c)->
   buffer += c.toString()
.on 'end',()->
  mail({
    subject:"！",
    to:"676588498@qq.com",
    #to:"weekly@htmljs.sendcloud.org",
    #use_maillist:"true",
    api_user:config.mail.api_user_list,
    api_key: config.mail.api_key_list,
    html:buffer
  })

