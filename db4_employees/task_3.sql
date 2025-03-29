with recursive emp_tree as (
  select
    e.employeeid,
    e.managerid,
    e.departmentid,
    e.name,
    e.roleid,
    (select count(et.employeeid) from employees et where et.managerid = e.employeeid) as count
  from
    employees e
  where
    employeeid = 1
  union
  select
    e.employeeid,
    e.managerid,
    e.departmentid,
    e.name,
    e.roleid,
    (select count(et.employeeid) from employees et where et.managerid = e.employeeid) as count
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
  array_to_string(array_agg(distinct CONCAT(p.projectname)),
  ', ') as ProjectNames,
  string_agg(t.taskname,
  ',') as TaskNames,
  count(t.taskid) as TotalTasks,
  e.count as TotalSubordinates
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
where r.roleid  = 1 and e.count > 0
group by
  e.name,
  e.employeeid,
  e.managerid,
  d.departmentname,
  r.rolename,
  e.count
order by
  e.name