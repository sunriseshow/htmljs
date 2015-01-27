
func_tag = __F 'tag'

module.exports = (req,res,next)->
  if res.locals.article.tags
    func_tag.getTagsByIds res.locals.article.tags.split(","),(error,tags)->
      res.locals.full_tags = tags
      next()
  else
    next()
