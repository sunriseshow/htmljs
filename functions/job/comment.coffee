Comment = __M 'job/comments'
# User = __M "users"

# User.hasOne Job,{foreignKey:"user_id"}
# Job.belongsTo User,{foreignKey:"user_id"}

Comment.sync()


func_comment = {}
  
  
__FC func_comment,Comment,['getAll','getByField','getById','delete','update','count','add']
module.exports = func_comment
