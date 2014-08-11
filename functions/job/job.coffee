Job = __M 'job/jobs'
JobZan = __M 'job/job_zans'
User = __M "users"

User.hasOne Job,{foreignKey:"user_id"}
Job.belongsTo User,{foreignKey:"user_id"}
User.hasOne JobZan,{foreignKey:"user_id"}
JobZan.belongsTo User,{foreignKey:"user_id"}

Job.sync()
JobZan.sync()

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
  addZan:(job_id,user_id,callback)->
    self = this
    JobZan.find 
      where:
        job_id:job_id
        user_id:user_id
    .success (zan)->
      if zan
        callback new Error '已经表示过感兴趣！'
      else
        JobZan.create
          job_id:job_id
          user_id:user_id
        .success (zan)->

          callback null,zan
          Job.find
            where:
              id:job_id
          .success (job)->
            if job
              job.updateAttributes
                zan_count:job.zan_count*1+1
        .error (e)->
          callback e
    .error (e)->
      callback e
  getZans:(job_id,callback)->
    JobZan.findAll
      where:
        job_id:job_id
      include:[User]
    .success (jobs)->
      callback null,jobs
    .error (e)->
      callback e
  hasZan:(job_id,user_id,callback)->
    JobZan.find
      where:
        job_id:job_id
        user_id:user_id
    .success (job)->
      callback null,job
    .error (e)->
      callback e
__FC func_job,Job,['getById','delete','update','count','add','getByField']
module.exports = func_job
