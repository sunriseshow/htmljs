Resume = __M 'job/resumes'
# User = __M "users"

# User.hasOne Job,{foreignKey:"user_id"}
# Job.belongsTo User,{foreignKey:"user_id"}

Resume.sync()


func_resume = {}
  
  
__FC func_resume,Resume,['getByField','getById','delete','update','count','add']
module.exports = func_resume
