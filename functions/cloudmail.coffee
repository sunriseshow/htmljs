Mail = __M 'cloudmails'
LocalMail = __M 'localmails'

Mail.sync();
LocalMail.sync();

func_mail = {
  addLocalEmail:(source,target,user_id,callback)->
    LocalMail.create
      source_mail:source
      target_mail:target
      user_id:user_id
    .success (m)->
      callback null,m
    .error (e)->
      callback e
}
__FC func_mail,Mail,['getAll','update','count','delete','getById','add']
module.exports = func_mail