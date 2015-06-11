Tag = __M 'tags'
Question = __M 'questions'
QuestionTag = __M 'question_tag'

Question.hasMany QuestionTag,{foreignKey:"questionId"}
QuestionTag.belongsTo Question,{foreignKey:"questionId"}

QuestionTag.sync()
ArticleTag = __M 'article_tag'
Article = __M 'articles'

Article.hasMany ArticleTag,{foreignKey:"articleid"}
ArticleTag.belongsTo Article,{foreignKey:"articleid"}

ArticleTag.sync()

Tag.sync()
Question.sync()
func_tag = 
  countArticles:(id,callback)->
    ArticleTag.count
      where:
        tagid:id
    .success (c)->
      callback null,c
    .error (e)->
      callback e
  getByName:(name,callback)->
    Tag.find
      where:
        name:name
    .success (tag)->
      if not tag then callback new Error '不存在的标签'
      else
        callback null,tag
    .error (e)->
      callback e
  getQuestionsById:(id,page,count,callback)->
    QuestionTag.findAll
      where:
        tagId:id
      include:[Question]
    .success (qt)->
      callback null,qt
    .error (e)->
      callback e
  getArticlesById:(id,page,count,callback)->
    ArticleTag.findAll
      where:
        tagid:id
      offset: (page - 1) * count
      limit: count
      include:[Article]
    .success (as)->
      callback null,as
    .error (e)->
      callback e
  getTagsByIds:(ids,callback)->
    Tag.findAll
      where:
        id:ids
    .success (tags)->
      callback null,tags
    .error (e)->
      callback e
  getQuestionsByTagNames:(tagNames,page,count,callback)->
    if tagNames.length == 0
      callback null,[]
    else
      Tag.findAll
        where:
          name:tagNames
      .success (tags)->
        tagIds= []
        tags.forEach (tag)->
          tagIds
        QuestionTag.findAll
          where:
            id:tagNames
          order:'id desc'
          include:[Question]
        .success (qt)->
          callback null,qt
        .error (e)->
          callback e
      .error (e)->
        callback e
      
__FC func_tag,Tag,['getAll','add','update','getById','addCount']
module.exports = func_tag