Counts = __M 'user_counts'
Counts.sync()
Users = __M 'users'

func_counts =
  addCount:(user_id,field,callback)->
    Counts.find
      where:
        user_id:user_id
    .success (user)->
      if not user
        query = {user_id:user_id}
        query[field] = 1
        Users.find
          where:
            id:user_id
        .success (uu)->
          if uu
            query.user_nick = uu.nick
            query.user_headpic = uu.head_pic
            Counts.create(query)
            .success ()->
              callback null
            .error (e)->
              callback e
      else
        updates = {}
        updates[field]=user[field]*1+1
        user.updateAttributes(updates,[field])
        .success ()->
          callback&&callback null,user
        .error (error)->
          callback&&callback error
    .error (e)->
      callback&&callback e
  getTopUser:(field,count,callback)->
    Counts.findAll
      offset: 0
      limit: count
      order: field+" desc"
      raw:true
    .success (users)->
      callback null,users
    .error (e)->
      callback e
__FC func_counts,Counts,['getAll','add','getByField']

module.exports = func_counts