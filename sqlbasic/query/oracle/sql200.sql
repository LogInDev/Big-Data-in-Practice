select * from emp;

select empno, ename, sal from emp;

-- 예제 1. 사원 테이블에서 사원이름과 직업과 부서번호를 출력하세요.
select ename, job, deptno from emp;

-- 예제2
select * from emp;

-- 3.
select empno as 사원번호, ename as 사원이름, sal as "Salary"
from emp;

-- 4.
select ename || sal from emp;

select ename||'의 직업은 '||job||'입니다.' from emp;

-- 5.
select DISTINCT(job) from emp;

select distinct(deptno) from emp;

--6.
select ename, sal from emp order by sal;

--7.
select ename, sal,job from emp where sal = 3000;
select empno, ename, sal from emp  where empno = 7788;

--8.
select ename, sal, job, hiredate, deptno from emp where ename = 'SCOTT';
select ename, job, hiredate from emp where job = 'SALESMAN';
select ename, hiredate from emp where hiredate = '81/11/17';

--9.
select ename, sal*12 from emp where (sal*12) >= 36000;

select ename, sal*12 as 연봉 from emp where 연봉 >= 36000;
select ename, sal*12 as 연봉 from emp where job = 'ANALYST';

--10.
select ename, sal, job, deptno from emp where sal <=1200;
select ename, job from emp where job != 'SALESMAN';

--11.
select ename, sal from emp where sal between 1000 and 3000;

select ename, sal from emp where sal not between 1000 and 3000;

select ename, hiredate from emp where hiredate between '81/11/01' and '82/05/30';

--12.
select ename, sal from emp where ename like 'S%';
select ename from emp where ename like '%T';
select ename from emp where ename like '_M%';

--13. 
select ename, comm from emp where comm is null;
select ename, comm from emp where comm is not null;

--14.
select ename, sal, job from emp where job in ('SALESMAN', 'ANALYST', 'MANAGER');
select ename, sal, job from emp where job not in ('SALESMAN', 'ANALYST', 'MANAGER');

--15.
select ename, sal, job from emp where job = 'SALESMAN' and sal >=1200;
select ename, sal, comm from emp where deptno = 30 and comm >=100;

--16.
select ename, lower(ename), upper(ename), initcap(ename) from emp;
select ename, sal from emp where lower(ename) = 'scott';

--17.

select ename, sal from emp where lower(ename) = 'scott' and ename = 'SCOTT';

select substr('SMITH', 2) from emp;

select * from emp;

select lower(substr(ename, 1, 1)) from emp;

select ename, length(ename) from emp;

select instr('SMITH', 'M') from dual;

select ename from emp where instr(ename, 'S') is not null;

select ename, replace(sal,0,'*') from emp;

select ename, regexp_replace(sal, '[0-3]','*') from emp;

select ename, rpad(sal, 10, '*') from emp;

select 'smith', ltrim('smith', 's'), rtrim('smith', 'h'), trim('s' from 'smiths') from dual;

select 876.567, round(876.567, 2) from dual;

select 876.567, round(876.567, 1) from dual;

select ename, round(sal * 0.12) from emp;

select 876.567, trunc(876.567, 1) from dual;

select deptno, ename from emp where mod(deptno, 2) =1;

select empno, ename from emp where mod(empno, 2) = 1;

select sysdate from dual;

delete from emp where trim(ename) = 'JACK';

select ename, round(months_between(sysdate, hiredate)) from emp;

commit;

select months_between(sysdate, '1993/08/11')from dual;

select add_months(sysdate, 100) from dual;

select next_day('2021/5/5', 1) from dual;

select next_day('2021/5/5', 2) from dual;

select next_day('2021/5/5', 7) from dual;

select next_day(sysdate, 6) from dual;

select last_day('2021/5/5') from dual;

select last_day(sysdate) - sysdate from dual;

select to_char(to_date('1993/8/11', 'RRRR/MM/DD'), 'day') from dual;

alter session set nls_date_format='DD/MM/RR';

select * from nls_session_parameters;

select ename, hiredate from emp where hiredate = to_date('81/11/17', 'rr/mm/dd');

alter session set nls_date_format='RR/MM/DD';

select ename, sal from emp where sal = '3000';

select ename, sal from emp where sal like '30%';

explain plan for
select ename, sal from emp where sal like '30%';

select * from table(dbms_xplan.display);

--33
select ename, comm, nvl(comm, 0) from emp;
select ename, sal,  comm, sal+nvl(comm,0) from emp;
select ename, comm, nvl(to_char(comm), 'no comm') from emp;
select ename, nvl(comm, 'no comm') from emp;

--34
select ename, deptno, 
    decode(deptno, 10, 300, 20, 400, 0 ) as 보너스 from emp;

select ename, job, decode(job, 'SALESMAN', 6000, 'ANALYST', 3000,'MANAGER', 2000, 0) as 보너스 from emp; 

--35
select ename, job, sal, 
    case when sal >= 3000 then 500
         when sal >= 2000 then 300
         when sal >= 1000 then 200
         else 0 end as 보너스
from emp where job in ('SALESMAN', 'ANALYST');

select ename, sal, 
    case when sal >= 3000 then 9000
         when sal >= 2000 then 8000
         else 0 end as 보너스
from emp;        

--36
select max(sal) from emp;
select max(sal) from emp where job = 'SALESMAN';
select job, max(sal) from emp where job = 'SALESMAN';

--37
select min(sal) from emp where job = 'SALESMAN';
select min(sal) from emp where deptno = 20;
select deptno, min(sal) from emp group by deptno;

--38
select round(avg(sal)) from emp;
select job, avg(sal)from emp group by job order by 2 desc;
select deptno, avg(sal) from emp group by deptno;
select deptno, to_char(avg(sal), '999,999') from emp group by deptno; 

--39
select deptno, sum(sal) from emp group by deptno;
select sum(sal) from emp where to_char(hiredate, 'RRRR') = 1981;
select job, case when sum(sal) >= 6000 then sum(sal)
else 0 end from emp group by job;
select job, sum(sal) from emp group by job having sum(sal) >= 6000;

--40
select count(comm) from emp;
select avg(comm) from emp;
select avg(nvl(comm,0)) from emp;
select deptno, count(deptno) from emp  group by deptno;
select job, count(job) from emp where job not in ('SALESMAN') group by job having count(job) >= 3;

--41
select ename, job, sal, rank() over (order by sal desc) 순위 from emp where job in ('ANALYST', 'MANAGER');
select ename, deptno, sal, rank() over (order by sal desc) 순위 from emp where deptno = 20;

--42
select ename, job, sal, dense_rank() over( order by sal desc) 순위1, rank() over(order by sal desc) 순위2 from emp where job in ('ANALYST', 'MANAGER');



