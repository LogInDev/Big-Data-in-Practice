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
select job, ename, sal, dense_rank() over(partition by job order by sal desc) 순위 from emp;
select dense_rank(2975) within group (order by sal desc) 순위 from emp;

--43
select ename, job, sal, ntile(4) over(order by sal desc) 등급 from emp where job in ('ANALYST', 'MANAGER', 'CLERK');
select ename, hiredate, ntile(5) over(order by hiredate) 등급 from emp;

--44
select ename, sal, dense_rank() over (order by sal desc) 순위, round(cume_dist() over (order by sal desc), 2) 비율 from emp;
select deptno, ename, sal, round(cume_dist() over (partition by deptno order by sal desc), 2) 비율 from emp;

--45
select deptno, listagg(ename, ',') within group (order by ename) from emp group by deptno;
select job, listagg(ename, ' | ') within group (order by sal desc) from emp group by job;

--46
select empno, ename, sal, lag(sal, 1) over (order by sal), lead(sal) over (order by sal) from emp where job in ('ANALYST', 'MANAGER');
select ename, hiredate, hiredate - lag(hiredate, 1) over (order by hiredate) from emp;

--47
select deptno, sum(sal) from emp group by deptno;

select sum(decode(deptno, 10, sal, 0)) as "10" ,
        sum(decode(deptno, 20, sal, 0)) as "20",
        sum(decode(deptno, 30, sal, 0)) as "30"
from emp;

select job, sum(sal) from emp group by job;

select 
    sum(decode(job, 'PRESIDENT', sal, null)) as PRESIDENT,
    sum(decode(job, 'MANAGER', sal, null)) as MANAGER,
    sum(decode(job, 'SALESMAN', sal, null)) as SALESMAN,
    sum(decode(job, 'CLERK', sal, null)) as CLERK,
    sum(decode(job, 'ANALYST', sal, null)) as ANALYST
from emp;

--48
select * 
from (select deptno, sal from emp)
pivot(sum(sal) for deptno in (10, 20, 30));

select job, sum(sal) from emp group by job;

select *
from (select job, sal from emp)
pivot(sum(sal) for job in ('PRESIDENT', 'MANAGER', 'SALESMAN', 'CLERK', 'ANALYST'));

select *
from (select job, sal from emp)
pivot(sum(sal) for job 
		  in ('PRESIDENT' as "PRESIDENT", 'MANAGER' as "MANAGER", 'SALESMAN' as "SALESMAN", 'CLERK' as "CLERK", 'ANALYST' as "ANALYST"));
          
--49
drop table order2;

create table order2
( ename varchar2(10),
bicycle number(10),
camera number(10),
notebook number(10) );

insert into order2 values('SMITH', 2,3,1);
insert into order2 values('ALLEN', 1,2,3);
insert into order2 values('SMITH', 3,2,2);

commit;

select *
from order2;

select *
from order2
unpivot (건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));

--범죄 원인 데이터 생성 스크립트

drop table crime_cause;

create table crime_cause
(
crime_type  varchar2(30),
생계형  number(10),
유흥 number(10),
도박 number(10),
허영심 number(10),
복수  number(10),
해고  number(10),
징벌 number(10),
가정불화  number(10),
호기심 number(10),
유혹  number(10),
사고   number(10),
불만   number(10), 
부주의   number(10),
기타   number(10)  );


 insert into crime_cause values( '살인',1,6,0,2,5,0,0,51,0,0,147,15,2,118);
 insert into crime_cause values( '살인미수',0,0,0,0,2,0,0,44,0,1,255,38,3,183);
 insert into crime_cause values( '강도',631,439,24,9,7,53,1,15,16,37,642,27,16,805);
 insert into crime_cause values( '강간강제추행',62,19,4,1,33,22,4,30,1026,974,5868,74,260,4614);
 insert into crime_cause values( '방화',6,0,0,0,1,2,1,97,62,0,547,124,40,339);
 insert into crime_cause values( '상해',26,6,2,4,6,42,18,1666,27,17,50503,1407,1035,22212);
 insert into crime_cause values( '폭행',43,15,1,4,5,51,117,1724,45,24,55814,1840,1383,24953);
 insert into crime_cause values( '체포감금',7,1,0,0,1,2,0,17,1,3,283,17,10,265);
 insert into crime_cause values( '협박',14,3,0,0,0,10,11,115,16,16,1255,123,35,1047);
 insert into crime_cause values( '약취유인',22,7,0,0,0,0,0,3,8,15,30,6,0,84);
 insert into crime_cause values( '폭력행위등',711,1125,12,65,75,266,42,937,275,181,52784,1879,1319,29067);
 insert into crime_cause values( '공갈',317,456,12,51,17,116,1,1,51,51,969,76,53,1769);
 insert into crime_cause values( '손괴',20,4,0,1,3,17,8,346,61,11,15196,873,817,8068);
 insert into crime_cause values( '직무유기',0,1,0,0,0,0,0,0,0,0,0,0,18,165);
 insert into crime_cause values( '직권남용',1,0,0,0,0,0,0,0,0,0,1,0,12,68);
 insert into crime_cause values( '증수뢰',25,1,1,2,5,1,0,0,0,10,4,0,21,422);
 insert into crime_cause values( '통화',15,11,0,1,1,0,0,0,6,2,5,0,2,44);
 insert into crime_cause values( '문서인장',454,33,8,10,37,165,0,16,684,159,489,28,728,6732);
 insert into crime_cause values( '유가증권인지',23,1,0,0,2,3,0,0,0,0,3,0,11,153);
 insert into crime_cause values( '사기',12518,2307,418,225,689,2520,17,47,292,664,3195,193,4075,60689);
 insert into crime_cause values( '횡령',1370,174,58,34,86,341,3,10,358,264,1273,23,668,8697);
 insert into crime_cause values( '배임',112,4,4,0,30,29,0,0,2,16,27,1,145,1969);
 insert into crime_cause values( '성풍속범죄',754,29,1,6,12,100,2,114,1898,312,1051,60,1266,6712);
 insert into crime_cause values( '도박범죄',1005,367,404,32,111,12969,4,8,590,391,2116,9,737,11167);
 insert into crime_cause values( '특별경제범죄',5313,91,17,28,293,507,31,75,720,194,9002,1206,6816,33508);
 insert into crime_cause values( '마약범죄',57,5,0,1,2,19,3,6,399,758,223,39,336,2195);
 insert into crime_cause values( '보건범죄',2723,10,6,4,63,140,1,6,5,56,225,6,2160,10661);
 insert into crime_cause values( '환경범죄',122,1,0,2,1,2,0,0,15,3,40,3,756,1574);
 insert into crime_cause values( '교통범죄',258,12,3,4,2,76,3,174,1535,1767,33334,139,182010,165428);
 insert into crime_cause values( '노동범죄',513,11,0,0,23,30,0,2,5,10,19,3,140,1251);
 insert into crime_cause values( '안보범죄',6,0,0,0,0,0,1,0,4,0,4,23,0,56);
 insert into crime_cause values( '선거범죄',27,0,0,3,1,0,2,1,7,15,70,43,128,948);
 insert into crime_cause values( '병역범죄',214,0,0,0,2,7,3,35,2,6,205,50,3666,11959);
 insert into crime_cause values( '기타',13872,512,35,55,552,2677,51,455,2537,1661,18745,1969,20957,87483);


commit;

select * from crime_cause
unpivot (건수 for 범죄원인 IN (생계형, 유흥, 도박, 허영심, 복수, 해고, 징벌, 가정불화, 호기심, 유혹, 사고, 불만, 부주의, 기타))
where crime_type = '방화' order by 건수 desc;

--50
select empno, ename, sal, sum(sal) over(order by sal) 누적합 from emp where job in ('ANALYST', 'MANAGER');

select ename, sal, sum(sal) over(order by ename) 누적치 from emp where deptno = 20;
select ename, sal, 
	sum(sal) over(order by ename rows between unbounded preceding and current row) 누적치 
from emp 
where deptno = 20;

--51
select empno, ename, sal, round(ratio_to_report(sal) over (),2) 비율
from emp
where deptno = 20;

select empno, ename, sal, round(ratio_to_report(sal) over(),2) 비율
from emp;

--52
select job, sum(sal) 
from emp
group by rollup(job);

select deptno, sum(sal) from emp group by rollup(deptno);

--53
select job, sum(sal) from emp 
group by cube(job);

select to_char(hiredate, 'RRRR'), sum(sal)
from emp
group by cube(to_char(hiredate, 'RRRR'));

--54
select deptno, job, sum(sal)
from emp
group by grouping sets((deptno), (job),());

select deptno, sum(sal)
from emp
group by grouping sets((deptno), ());

select to_char(hiredate, 'RRRR'), job, sum(sal)
from emp
group by grouping sets((to_char(hiredate, 'RRRR')), (job));

--55
select empno, ename, sal, rank() over(order by sal desc) rank,
    dense_rank() over(order by sal desc) dense_rank,
    row_number() over(order by sal desc)
from emp
where deptno = 20; 

select ename, sal, row_number() over (order by sal)
from emp
where sal between 1000 and 3000;

--56
select rownum, empno, ename, job, sal
from emp
where rownum <= 5;


SELECT ENAME, SAL, JOB
FROM EMP
WHERE JOB = 'SALESMAN'
and rownum <= 2;

--57
select empno, ename, job, sal
from emp
order by sal desc fetch first 4 rows only;

select ename, hiredate, sal
from emp
order by hiredate desc fetch first 5 rows only;

--58
select * from dept;

select ename, loc from emp,dept where emp.deptno = dept.deptno;
select e.ename, e.job, d.loc from emp e, dept d where e.deptno = d.deptno 
		and e.job = 'SALESMAN';
        
select e.ename, e.sal, d.loc from emp e, dept d where e.deptno = d.deptno and d.loc = 'DALLAS';     

--59
drop  table  salgrade;
 
create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );
 
insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);
 
commit;

select * from salgrade;
select * from emp;

select e.ename, e.sal, s.grade from emp e, salgrade s
where e.sal between s.losal and s.hisal;

select e.ename, e.sal from emp e, salgrade s where e.sal between s.losal and s.hisal and s.grade = 4 order by e.sal desc;

--60
select e.ename, d.loc from emp e, dept d where e.deptno (+) = d.deptno;

insert into emp(empno, ename, sal, deptno)
values(7122, 'JACK', 3000, 70);

commit;
select e.ename, d.loc from emp e, dept d where e.deptno = d.deptno(+);

--61
select 사원.Ename as 사원, 사원.job as 직업, 관리자.Ename as 관리자, 관리자.JOb as 직업 
from emp 사원, EMP 관리자 where 사원.mgr = 관리자.Empno and 관리자.sal < 사원.sal;

--62
select e.ename, e.sal, d.loc from emp e join dept d on (e.deptno = d.deptno) where e.job='SALESMAN';

select e.ename, e.sal, d.loc from emp e join dept d on (e.deptno = d.deptno) where e.sal between 1000 and 3000;

--63
select e.ename, e.job, e.sal, d.loc from emp e join dept d
using (deptno) where e.job='SALESMAN';

select e.ename, e.sal, d.loc from emp e join dept d using(deptno) where detno=10;

--64
select e.ename as 이름, e.job as 직업, E.SAL AS 월급, D.loc as 부서위치
FROM Emp e natural join dept d where e.job = 'SALESMAN';

select e.ename, e.job, e.sal, d.loc from emp e natural join dept d where e.job = 'SALESMAN' and deptno = 30;

--65
select e.ename, e.job, e.sal, d.loc 
from emp e right outer join dept d
on (e.deptno = d.deptno);

insert into emp(empno, ename, sal, job, deptno)
values(8282, 'JACK', 3000, 'ANALYST', 50);
commit;
select * from emp;

select e.ename, e.job, e.sal, d.loc from emp e left outer join dept d
on (e.deptno = d.deptno);

--66
select e.ename, e.job, e.sal, d.loc from emp e full outer join dept d on (e.deptno = d.deptno);

select e.ename, e.job, e.sal, d.loc from emp e full outer join dept d on (e.deptno = d.deptno) where e.job = 'ANALYST' or d.loc = 'BOSTON';

--67
delete from emp where deptno = 70;
commit;

select deptno, sum(sal) from emp group by deptno
union all
select null,sum(sal)
from emp;

select job, sum(sal) from emp group by job
union all
select to_char(null), sum(sal) from emp;

--68
select deptno, sum(sal) from emp group by deptno
union
select to_number(null) as deptno, sum(sal) from emp;

select job, sum(sal) from emp group by job
union 
select to_char(null), sum(sal) from emp
order by job;

select to_char(hiredate, 'RRRR') as hiredate, sum(sal) from emp group by to_char(hiredate, 'RRRR')
union 
select to_char(null), sum(sal) from emp order by hiredate;

--69
select ename, sal, job, deptno
from emp
where deptno in (10, 20)
intersect
select ename, sal, job, deptno
from emp
where deptno in (20, 30);

select deptno from emp
intersect
select deptno from dept;

--70
select ename, sal, job, deptno
from emp
where deptno in (10, 20)
minus
select ename, sal, job, deptno
from emp
where deptno in (20, 30);

select deptno from dept
minus
select deptno from emp;
