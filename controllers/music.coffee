func_music = __F 'music'
musics = {}
module.exports.controllers =
  "/show_url":
    get:(req,res,next)->
      res.send {show:1,url:"http://www.html-js.com/music"}
      return;
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
          func_music.getAll page,count,condition,'musics.index desc',(error,musics)->
            if error then next error
            else
              res.locals.musics = musics
              res.render 'music/all.jade'
  ".json":
    get:(req,res,next)->
      last_id = req.query.last_id
      condition = null
      if last_id
        condition = ['id > ?',last_id]
      if !last_id 
        last_id = -1

      if musics[last_id]
        res.send musics[last_id]
      else
        func_music.getAll 1,10000,condition,'musics.index desc',(error,musics)->
          if error
            res.send error
          else
            res.locals.musics = musics
            res.send musics
            if !musics[last_id]
              musics[last_id] = musics
  "/add":
    get:(req,res,next)->
      res.render 'music/add.jade'
    post:(req,res,next)->
      func_music.add req.body,(error,music)->
        musics = {}
        res.redirect '/music/'+music.id
  "/:id.json":
    get:(req,res,next)->
      func_music.getById req.params.id,(error,music)->
        if error 
          res.send error
        else
          res.send music
          func_music.addCount req.params.id,'visit_count',(()->),1
  "/:id":
    get:(req,res,next)->
      func_music.getById req.params.id,(error,music)->
        if error then next error
        else
          func_music.getNext req.params.id,(error,next)->
            if(next)
              res.locals.next = next
            res.locals.music = music
            res.render 'music/music.jade'
            func_music.addCount req.params.id,'visit_count',(()->),1
  
  "/tool/:id":
    get:(req,res,next)->
      func_music.getById req.params.id,(error,music)->
        if error then next error
        else
          func_music.getNext req.params.id,(error,next)->
            if(next)
              res.locals.next = next
            res.locals.music = music
            res.render 'music/music-tool.jade'
            func_music.addCount req.params.id,'visit_count',(()->),1
            
  

