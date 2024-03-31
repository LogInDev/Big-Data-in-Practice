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

