Music = new __BaseModel 'musics'
Music.sync()
func = new __BaseFunction(Music)
func.getNext = (id,callback)->
  Music.find
    where:['id<?',id]
    order:"id desc"
  .success (m)->
    callback null,m
  .error (e)->
    callback e

module.exports =  func