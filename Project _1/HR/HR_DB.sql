-- psql -f /home/workspace/scratchpad.sql
------------------------------------------------------------------------------------------------------------------------
-- clean up
drop table if exists salary cascade;
drop table if exists employee_history cascade;
drop table if exists department cascade;

drop table if exists job cascade;
drop table if exists employee cascade;
drop table if exists location cascade;

-- create statement for employee table
create table employee
(
    employee_id     varchar(256),
    email           varchar(256),
    employee_name   varchar(256),
    hire_date       date,
    education_level varchar(256),
    location_id     serial
);

-- create statement for employee history table
create table employee_history
(
    employee_id   varchar(256),
    start_date    date,
    end_date      date,
    job_id        serial,
    department_id serial,
    manager_id    varchar(256)
);

-- create statement for job table
create table job
(
    job_id   serial,
    job_name varchar(256)
);

-- create statement for salary table
create table salary
(
    salary_id   serial,
    salary      int,
    employee_id varchar(256)
);

-- create statement for department table
create table department
(
    department_id   serial,
    department_name varchar(256)
);

-- create statement for location table
create table location
(
    location_id   serial,
    location_name varchar(256),
    address       varchar(256),
    city          varchar(256),
    state         varchar(256)
);

-- primary key for employee
alter table employee
    add primary key (employee_id);
-- primary key for employee history
alter table employee_history
    add primary key (employee_id, job_id);
-- primary key for job
alter table job
    add primary key (job_id);
-- primary key for salary
alter table salary
    add primary key (salary_id);
-- primary key for department
alter table department
    add primary key (department_id);
-- primary key for location
alter table location
    add primary key (location_id);

-- foreign key for employee
alter table employee
    add constraint employee_location_fk
        foreign key (location_id)
            references location (location_id);
-- foreign key for employee_history
alter table employee_history
    add constraint employee_history_employee_fk
        foreign key (employee_id)
            references employee (employee_id);
alter table employee_history
    add constraint employee_history_job_fk
        foreign key (job_id)
            references job (job_id);
alter table employee_history
    add constraint employee_history_department_fk
        foreign key (department_id)
            references department (department_id);
alter table employee_history
    add constraint employee_history_manager_fk
        foreign key (employee_id)
            references employee (employee_id);
-- foreign key for salary
alter table salary
    add constraint salary_employee_fk
        foreign key (employee_id)
            references employee (employee_id);

-- CRUD
-- create db
-- init location
insert into location (location_name, address, city, state)
select distinct uda.location as location_name
     , uda.address  as address
     , uda.city     as city
     , uda.state    as state
from proj_stg as uda;

-- init job
insert into job (job_name)
select distinct uda.job_title as job_name
from proj_stg as uda;

-- init department
insert into department (department_name)
select distinct uda.department_nm as department_name
from proj_stg as uda;

-- init employee
insert into employee (employee_id, email, employee_name, hire_date, education_level, location_id)
select distinct uda.Emp_ID        as employee_id
              , uda.Email         as email
              , uda.Emp_NM        as employee_name
              , uda.hire_dt       as hire_date
              , uda.education_lvl as education_level
              , loc.location_id as location_id
from proj_stg as uda
left join location as loc on loc.location_name = uda.location
and loc.address = uda.address
and loc.city = uda.city
and loc.state = uda.state;

-- init employee_history
insert into employee_history (employee_id, start_date, end_date,job_id,department_id, manager_id)
select distinct uda.Emp_ID   as employee_id
              , uda.start_dt as start_date
              , uda.end_dt   as end_date
              , jb.job_id as job_id
              , dp.department_id as department_id
              , mg.Emp_ID as manager_id
from proj_stg as uda
left join proj_stg as mg on uda.manager = mg.Emp_NM
left join department as dp on uda.department_nm = dp.department_name
left join job as jb on jb.job_name = uda.job_title;

-- init salary
insert into salary (salary, employee_id)
select distinct uda.salary as salary
     , uda.Emp_ID as employee_id
from proj_stg as uda;


-- read (retrieve) from db
-- read from location table
select *
from location
limit 10;
-- read from department table
select *
from department
limit 10;
-- read from job table
select *
from jobs
limit 10;
-- read from salary table
select *
from salary
limit 10;
-- read from employee table
select *
from employee
limit 10;
-- read from employee_history table
select *
from employee_history
limit 10;

-- Question 1: Return a list of employees with Job Titles and Department Names    
select emp.employee_name, emp_job.job_name, dep.department_name
from employee as emp
left join employee_history as emp_hist on emp.employee_id = emp_hist.employee_id
left join job as emp_job on emp_hist.job_id = emp_job.job_id
left join department as dep on emp_hist.department_id = dep.department_id;

-- -- Question 2: Insert Web Programmer as a new job title
insert into job (job_name) values ('Web Programmer');
select job_name
from job
where job_name = 'Web Programmer';

-- -- Question 3: Correct the job title from web programmer to web developer
update job set job_name = 'Web Developer'
where job_name = 'Web Programmer';
select job_name
from job
where job_name = 'Web Developer';

-- -- Question 4: Delete the job title Web Developer from the database
delete from job where job_name = 'Web Developer';
select job_name
from job
where job_name = 'Web Developer';

-- -- Question 5: How many employees are in each department?
select dep.department_name as "Department Name"
    , count(distinct emp_hist.employee_id) as "Number of employees"
from employee_history as emp_hist
left join department as dep on emp_hist.department_id = dep.department_id
group by dep.department_name;

-- Question 6: Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
select emp.employee_name as "Employee Name"
    , emp_job.job_name as "Job Title"
    , dep.department_name as "Department Name"
    , emp_man.employee_name as "Manager Name"
    , emp_hist.start_date as "Start Date"
    , emp_hist.end_date as "End Date"
from employee as emp
left join employee_history as emp_hist on emp.employee_id = emp_hist.employee_id
left join job as emp_job on emp_hist.job_id = emp_job.job_id
left join department as dep on emp_hist.department_id = dep.department_id
left join employee as emp_man on emp_hist.manager_id = emp_man.employee_id
where emp.employee_name = 'Toni Lembeck';


