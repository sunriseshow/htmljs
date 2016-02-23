mail = require './../lib/mail.js'
mustache = require 'mu2'
config = require './../config.coffee'
tplmail = require "./../lib/tpl_mail.js"
buffer = ""

mustache.compileAndRender('./../static/htmljs-year-2015.html', {})
.on 'data',(c)->
   buffer += c.toString()
.on 'end',()->
  mail({
    subject:"[前端乱炖]2015年最受欢迎的20篇[原创]文章",
    to:"xinyu198736@gmail.com",
#    to:"weekly@htmljs.sendcloud.org",
 #   use_maillist:"true",
    api_user:config.mail.api_user_list,
    api_key: config.mail.api_key_list,
    html:buffer
  })
  tplmail({
    subject:"[前端乱炖]2015年最受欢迎的20篇[原创]文章2",
    substitution_vars:JSON.stringify({
      to:["xinyu198736@gmail.com"],
      sub:{
        "%content%":[buffer],
        "%title%":['[前端乱炖]2015年最受欢迎的20篇[原创]文章2'],
        "%url%":['http://www.html-js.com/static/htmljs-year-2015.html']
      }
    }),
    template_invoke_name:"common",
  })
