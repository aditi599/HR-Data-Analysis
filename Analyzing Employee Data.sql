

-- min and max salary by department 

select distinct d.department_name , round(min(e.salary) over (partition by d.department_name)) as min_salary , 
round(max(e.salary) over(partition by d.department_name)) as max_salary
from employees e 
left join departments d
on e.department_id = d.department_id;

-- employee count by department 

select count(employee_id) , d.department_name from employees e
join departments d 
on e.department_id = d.department_id
group by d.department_name;

-- record of all employess whose hire date is before august of every year

select e.employee_id , e.first_name, e.last_name, d.department_name, month(hire_date) as `month`
from employees e
join departments d 
on e.department_id = d.department_id 
where month(hire_date)  > 8;


-- country with employee contribution percentage

select * , sum(total_emp_cnt) over() as total_contribution , round(total_emp_cnt * 100.00 / sum(total_emp_cnt) over(),2) as contribution_percentage from 
(select c.country_name  , count(e.employee_id) as total_emp_cnt from countries c
left join locations l on c.country_id = l.country_id
left join departments d on l.location_id = d.location_id
left join employees e on e.department_id = d.department_id
group by c.country_name 
order by count(e.employee_id) desc) as sub;


-- job title wise salary split on the basis of avg salary

select job_title , avg_salary , count( distinct case when avg_salary > salary then employee_id end) below_avg_salary , 
count( distinct case when avg_salary <= salary then employee_id end) as above_avg_salary from 
(select j.job_title , j.job_id, round(avg(e.salary),2) as avg_salary from jobs j 
left join employees e on j.job_id = e.job_id
group by j.job_title, j.job_id) as temp_table
left join employees e on e.job_id = temp_table.job_id
group by 1,2;


-- extracting the manager info from the employees table

select sub.manager_id , concat(first_name ,' ', last_name) as full_name , salary , sub.emp_count from 
(select manager_id, count(distinct employee_id)as emp_count from employees where manager_id is not null group by manager_id) as sub
left join employees e on e.employee_id = sub.manager_id;



-- days to hire next employee
select department_id, avg(days_to_hire_new_emp) from ( 
select * , datediff( next_hire_date , hire_date ) as days_to_hire_new_emp from  
(select distinct  e.hire_date, lead(hire_date,1) over(partition by department_id order by hire_date asc) as next_hire_date , e.department_id  from employees e   order by department_id) sub
where sub.next_hire_date is not null
) sub_2
group by department_id ;




