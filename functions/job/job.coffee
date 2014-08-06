Job = __M 'job/jobs'
User = __M "users"

User.hasOne Job,{foreignKey:"user_id"}
Job.belongsTo User,{foreignKey:"user_id"}

Job.sync()


func_job =
  getAll:(page,count,condition,order,include,callback)->
    if arguments.length == 4
      callback = order
      order = null
      include = null
    else if arguments.length == 5
      callback = include
      include = null
    query = 
      offset: (page - 1) * count
      limit: count
      order: order
      include:[User]
      raw:true
    if condition then query.where = condition
    Job.findAll(query)
    .success (jobs)->
      callback null,jobs
    .error (e)->
      callback e
  
__FC func_job,Job,['getById','delete','update','count','add']
module.exports = func_job
