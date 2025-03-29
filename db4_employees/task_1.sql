with recursive emp_tree as (
  select
    employeeid,
    managerid,
    departmentid ,
    name,
    roleid
  from
    employees
  where
    employeeid = 1
  union
  select
    e.employeeid,
    e.managerid,
    e.departmentid,
    e.name,
    e.roleid
  from
    employees e
  join emp_tree eh on
    e.managerid = eh.employeeid
)
select
  e.employeeid as EmployeeID,
  e.name as EmployeeName,
  e.managerid as ManagerID,
  d.departmentname as DepartmentName,
  r.rolename as RoleName,
  array_to_string(array_agg(distinct CONCAT(p.projectname)),', ') as ProjectNames,
  string_agg(t.taskname, ',') as TaskNames
from
  emp_tree e
join departments d on
  d.departmentid = e.departmentid
join roles r on
  r.roleid = e.roleid
left join projects p on
  p.departmentid = d.departmentid
left join tasks t on
  t.assignedto = e.employeeid
group by
  e.name,
  e.employeeid,
  e.managerid,
  d.departmentname,
  r.rolename
order by
  e.name