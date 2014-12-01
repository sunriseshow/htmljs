Tip = new __BaseModel 'tips'
Tip.sync()
func = new __BaseFunction(Tip)
func.getAllByTargetId = (target_id,callback)->
  Tip.findAll
    where:
      target_id:target_id
      parent_id:null
  .success (tips)->
    callback null,tips
  .error (e)->
    callback e
module.exports =  func