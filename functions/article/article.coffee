
Article = __M 'articles'
Column = __M 'columns'
User = __M "users"
Card = __M 'cards'
Visit_log = __M 'article_visit_logs'
en_func = require './../../lib/translate.coffee'
Visit_log.sync()
User.hasOne Article,{foreignKey:"user_id"}
Article.belongsTo User,{foreignKey:"user_id"}
Article.sync()
Column.hasOne Article,{foreignKey:"column_id"}
Article.belongsTo Column,{foreignKey:"column_id"}

ArticleZanLogs = __M 'article_zan_logs'
User.hasOne ArticleZanLogs,{foreignKey:"user_id"}
ArticleZanLogs.belongsTo User,{foreignKey:"user_id"}
ArticleZanLogs.sync()

CanRead = __M "article_canread"
User.hasOne CanRead,{foreignKey:"user_id"}
CanRead.belongsTo User,{foreignKey:"user_id"}
CanRead.sync()
ArticleTag = __M 'article_tag'
ArticleTag.sync()

Tags = __M 'tags'
Tags.sync()
cache = 
  recent:[]
htmljs_cache = require './../../lib/cache.js'
func_article =
  addTagsToArticle:(article_id,tagIds)->
    ArticleTag.findAll
      where:
        articleid:article_id
    .success (qts)->
      qts.forEach (qt)->
        qt.destroy()
      tagIds.forEach (tagid)->
        ArticleTag.create
          articleid:article_id
          tagid:tagid
  run_sort:()->
    self = this
    this.getAllByField 1,10000,null,(error,articles)->
      if articles && articles.length
        articles.forEach (a)->
          self.run_sort_byid a.id
  run_sort_byid:(articleId)->
    Article.find
      where:
        id:articleId
    .success (article)->
      if article && article.publish_time&&article.publish_time>1000000
        score = (article.comment_count/5+article.visit_count/500)/Math.pow((new Date().getTime()/1000-article.createdAt.getTime()/1000)/60/60+2,1.8)
        article.updateAttributes({score:score},['score'])
        .success ()->
    .error (error)->
      callback error

  getAll:(page,count,condition,order,callback)->

#    if not callback
#      callback = order
#      order = "sort desc,id desc"
#    arguments_key = ['article.getAll',page,count,JSON.stringify(condition),order].join("_")
#    cache_data = htmljs_cache.get(arguments_key)
#    if cache_data
#      callback null,cache_data
#      return
    query = 
      offset: (page - 1) * count
      limit: count
      order: order
      attributes:['id','publish_time','createdAt','zan_count','comment_count','visit_count','main_pic','title','user_id','user_nick','user_headpic','is_jian','is_top','type','column_id','uuid','pinyin']
      include:[User,Column]
      raw:false
    if condition then query.where = condition
    Article.findAll(query)
    .success (articles)->
      cache.recent = articles
#      htmljs_cache.set(arguments_key,articles,1000*60*60*10)
      callback null,articles
    .error (error)->
      callback error
  getAllWithContent:(page,count,condition,order,callback)->
#    if not callback
#      callback = order
#      order = "sort desc,id desc"
#    arguments_key = ['article.getAllWithContent',page,count,JSON.stringify(condition),order].join("_")
#    cache_data = htmljs_cache.get(arguments_key)
#    if cache_data
#      callback null,cache_data
#      return
    query =
      offset: (page - 1) * count
      limit: count
      order: order
      attributes:['id','publish_time','html','zan_count','comment_count','main_pic','visit_count','title','user_id','user_nick','user_headpic','is_jian','is_top','type','column_id','uuid','pinyin']
      include:[User,Column]
      raw:false
    if condition then query.where = condition
    Article.findAll(query)
    .success (articles)->
      cache.recent = articles
#      htmljs_cache.set(arguments_key,articles,1000*60*60*10)
      callback null,articles
    .error (error)->
      callback error
  getAllByField:(page,count,condition,order,callback)->
    if not callback
      callback = order
      order = "sort desc,id desc"
    query =
      offset: (page - 1) * count
      limit: count
      order: order
      attributes:['id','publish_time','zan_count','comment_count','visit_count']
      raw:false
    if condition then query.where = condition
    Article.findAll(query)
    .success (articles)->
      callback null,articles
    .error (error)->
      callback error
  getByUserIdAndType:(id,type,callback)->
    Article.findAll
      where:
        user_id:id
        type:type
        is_publish:1
      order: "id desc"
      limit:20
      raw:true
    .success (articles)->
      callback null,articles
    .error (error)->
      callback error
  getByUrl:(url,callback)->
    Article.find
      where:
        quote_url:url
      raw:true
    .success (article)->
      callback null,article
    .error (error)->
      callback error
  getByPinyin:(pinyin,callback)->
#    arguments_key = ['article.getByPinyin',pinyin].join("_")
#    cache_data = htmljs_cache.get(arguments_key)
#    if cache_data
#      callback null,cache_data
#      return
    Article.find
      where:
        pinyin:pinyin
      raw:true
    .success (article)->
#      htmljs_cache.set(arguments_key,article,1000*60*60*10)
      callback null,article
    .error (error)->
      callback error
  add:(data,callback)->
    data.uuid = uuid.v4()
    
    Article.create(data)
    .success (article)->
      Column.find
        where:
          id:article.column_id
      .success (column)->
        if column && column.name
          title = column.name+" "+ article.title
        else
          title = article.title
        en_func title,(en)->
          article.updateAttributes {pinyin:en},['pinyin']
      callback null,article
    .error (error)->
      callback error
  addComment:(articleId)->
    Article.find
      where:
        id:articleId
    .success (article)->
      if article
        article.updateAttributes
          comment_count: if article.comment_count then (article.comment_count+1) else 1
  addVisit:(articleId,visitor)->
    Article.find
      where:
        id:articleId
    .success (article)->
      if article
        article.updateAttributes {visit_count: if article.visit_count then (article.visit_count+2) else 1},['visit_count']
        if visitor
          Visit_log.create
            article_id:articleId
            user_id:visitor.id
            user_nick:visitor.nick
            user_headpic:visitor.head_pic
  getVisitors:(articleId,count,callback)->
  	if articleId
      condition = 
        article_id:articleId
    else
      condition = null
    Visit_log.findAll
      where:condition
      limit:count
      order:"id desc"
    .success (logs)->
      callback null,logs
    .error (error)->
      callback error
  addZan:(article_id,user_id,score,callback)->
    score = score*1
    ArticleZanLogs.find
      where:
        article_id:article_id
        user_id:user_id
    .success (log)->
      if log then callback new  Error '已经赞过这篇文章了哦'
      else
        Article.find
          where:
            id:article_id
        .success (article)->
          if not article then callback new  Error '不存在的文章'
          else
            ArticleZanLogs.create({
              article_id:article_id
              user_id:user_id
            }).success (log)->
              article.updateAttributes
                zan_count:article.zan_count*1+1
              callback null,log,article
            .error (e)->
              callback e
        .error (e)->
          callback e
    .error (e)->
      callback e
  getZanByArticleIdAndUserId:(article_id,user_id,callback)->
    ArticleZanLogs.find
      where:
        article_id:article_id
        user_id:user_id
    .success (log)->
      callback null,log
    .error (e)->
      callback e
  getRecent:(callback)->
    Article.findAll
      where:
        is_publish:1
      order: "id desc"
      limit:10
      raw:true
    .success (articles)->
      callback null,articles
    .error (error)->
      callback error
  getById:(id,callback)->
    Article.find
      where:
        id:id
      include:[User,Column]
      raw:true
    .success (article)->
      callback null,article
    .error (error)->
      callback error
  getByPinyin:(pinyin,callback)->
    Article.find
      where:
        pinyin:pinyin
      include:[User]
      raw:true
    .success (article)->
      if not article 
        callback new Error '不存在的文章'
      else
        callback null,article
    .error (error)->
      callback error
  getZansByArticleId:(article_id,callback)->
    ArticleZanLogs.findAll
      where:
        article_id:article_id
      include:[User]
      order:"id desc"
      raw:true
    .success (logs)->
      callback null,logs
    .error (e)->
      callback e
  addPay:(article_id,user_id,callback)->
    CanRead.create
      article_id:article_id
      user_id:user_id
    .success ()->
      callback()
    .error (e)->
      callback e
  checkCanRead:(user_id,article_id,callback)->
    CanRead.find
      where:
        article_id:article_id
        user_id:user_id
    .success (c)->
      if c
        callback()
      else
        callback new Error '无权限查看'
    .error (e)->
      callback e
  canReaders:(article_id,callback)->
    CanRead.findAll
      where:
        article_id:article_id
      include:[User]
    .success (readers)->
      callback null,readers
    .error (e)->
      callback e

__FC func_article,Article,['update','count','delete','addCount']
module.exports=func_article
