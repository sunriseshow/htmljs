func_music = __F 'music'
module.exports.controllers =
  "/":
    get:(req,res,next)->
      page = req.query.page || 1
      count = req.query.count || 20
      condition = null
      func_music.count condition,(error,_count)->

        if error then next error
        else
          res.locals.total=_count
          res.locals.totalPage=Math.ceil(_count/count)
          res.locals.page = (req.query.page||1)
          func_music.getAll page,count,condition,'index desc',(error,musics)->
            if error then next error
            else
              res.locals.musics = musics
              res.render 'music/all.jade'
  "/add":
    get:(req,res,next)->
      res.render 'music/add.jade'
    post:(req,res,next)->
      func_music.add req.body,(error,music)->
        res.redirect '/music/'+music.id
  "/:id":
    get:(req,res,next)->
      func_music.getById req.params.id,(error,music)->
        if error then next error
        else
          res.locals.music = music
          res.render 'music/music.jade'
          func_music.addCount req.params.id,'visit_count',(()->),1

