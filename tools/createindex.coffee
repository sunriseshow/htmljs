require './../lib/modelLoader.coffee'
require './../lib/functionLoader.coffee'
func_user = __F 'user'
func_count = __F 'user/count'
func_article = __F 'article/article'
queuedo = require 'queuedo'

func_article.getAll 1,3000,null,"id desc",(error,articles)->
  queuedo articles,(a,next,context)->
    console.log a.user_id
    if a.user_id
      func_count.addCount a.user_id,"article_count",(e,uu)->
        next.call(context)
    else
      next.call(context)
  ,()->
    console.log 'end'
