select*from Employee
---KPI REQUIREMENTS---
--1:Total Customers
select count(leaveornot) as total_customers
from Employee
--2:Churn
select sum(leaveornot) as total_churn
from Employee
--3:Churn rate
select sum(leaveornot)*100/(count(leaveornot))
from Employee
--4:Gender Wise Churn Rate
select Gender,sum(leaveornot)*100/(select sum(leaveornot) from Employee where LeaveOrNot=1) as pct
from Employee
where LeaveOrNot=1
group by Gender
order by pct desc
--5:Age Group Wise Churn rate
alter table Employee add Age_Group varchar(20)
select min(age),max(age)
from Employee
update Employee
set age_group=case 
             when age<25 then 'Under-25'
			 when age between 25 and 30 then '25-30'
			 when age between 31 and 36 then '31-36'
			 else
			 '37-42'
			 end
----
select age_group,Gender,sum(leaveornot) as total_churn,
sum(leaveornot)*100/(select sum(leaveornot) from Employee where LeaveOrNot=1) as pct
from Employee
where LeaveOrNot=1
group by age_group,Gender
order by pct desc
--5:City wise Churn 
select City,Gender,sum(leaveornot) as churn
from Employee
group by City,Gender
order by churn desc
--6:Churn Rate On City and Paymenttier
select City,PaymentTier,sum(leaveornot) as total
from Employee
group by City,PaymentTier
order by City
--7:Churn On Paymenttier
select PaymentTier,sum(leaveornot) as total
from Employee
group by PaymentTier
order by total desc
--8:Churn On Education
select Education,sum(leaveornot) as total
from Employee
group by Education
order by total desc
--9:Churn Rate on Education/City/Payment Tier
with cte as(
select Education,city,PaymentTier,count(leaveornot) as total,
ROW_NUMBER()over(partition by education order by count(leaveornot) desc) as df
from Employee
where LeaveOrNot=1
group by Education,city,PaymentTier
)
select *from cte where df<=2
--10:Churn Rate On ExperienceInCurrentDomain
select min(experienceincurrentdomain),max(experienceincurrentdomain)
from Employee
----
select *from
(select ExperienceInCurrentDomain,PaymentTier,sum(leaveornot) as total,
ROW_NUMBER()over(partition by ExperienceInCurrentDomain order by sum(leaveornot) desc) as df
from Employee
group by ExperienceInCurrentDomain,PaymentTier)rudra
where df<=1
--11:Churn Rate on Project
select Education,sum(leaveornot) as total
from Employee
where EverBenched='yes'
group by Education
order by total desc
--12:Year Wise Churn Rate
with cte as(
select JoiningYear,PaymentTier,sum(leaveornot) as total,
ROW_NUMBER()over(partition by JoiningYear order by sum(leaveornot)  desc) as df
from Employee
group by JoiningYear,PaymentTier
)
select*from cte where df=1
---Age Group Churn rate
select age_group, gender,sum(leaveornot)
from Employee
group by Age_Group,gender
order by Age_Group
----
select EverBenched,sum(leaveornot)
from Employee 
where City='pune'
group by EverBenched
