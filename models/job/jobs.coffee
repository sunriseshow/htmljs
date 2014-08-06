module.exports = 
  id:
    type:"int"
    autoIncrement: true
    primaryKey: true
  title:"varchar(300)"

  visit_count:
    type:"int"
    defaultValue:0

  user_id:"int"
  user_nick:"varchar(100)"
  user_headpic:"varchar(255)"

  tou_count: 
    type:"int"
    defaultValue:0

  zan_count:
    type:"int"
    defaultValue:0

  company_name:"varchar(100)"
  company_personcount:"varchar(100)"
  company_country:"varchar(20)"
  company_city:"varchar(20)"
  company_desc:"text"

  zhiwei:"varchar(100)"
  zhaopin_personcount:"int" #招聘人数
  zhaopin_jingyan:"varchar(20)" #工作经验
  min_price:"int"
  max_price:"int"
  zhaopin_desc:"text"
  sort:"int"
  is_publish:
    type:"tinyint"
    defaultValue:0
