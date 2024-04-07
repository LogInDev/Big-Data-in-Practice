## 서열 주고 데이터 출력하기

>`start with 서열 1위인 행 특정`
>`connect by prior 어떻게 연결할건지`

```sql
select empno, mgr, ename, level, sal, job from emp
start with ename='KING'
connect by prior empno = mgr;
```
![](8-1.png)

- level을 시각화해서 표현
```sql
select rpad(' ',level*3) || ename, sal, job from emp
start with ename='KING'
connect by prior empno = mgr;
```
![](8-2.png)

```sql
select ename,level, job from emp 
where level = 2
start with ename='KING'
connect by prior empno=mgr;
```
![](8-3.png)


```sql
-- BLAKE 팀원들만 안나오게 서열대로 출력해라
select rpad(' ', level*3) || ename as employee, level, sal, job from emp
start with ename = 'KING'
connect by prior empno=mgr
and ename != 'BLAKE';
```
![](8-4.png)

```sql
select rpad(' ', level*3) || ename as emplyee, level, sal, job from emp
start with ename = 'KING'
connect by prior empno=mgr
and ename not in( 'SCOTT', 'FORD');
```
![](8-5.png)


### 서열 순위 유지하면서 정렬하기

>`order siblings by` : 계층 유지하면서 정렬

```sql
select rpad(' ', level*3) || ename as employee, level, sal, job 
from emp
start with ename='KING'
connect by prior empno=mgr
order siblings by sal desc;
```
![](8-6.png)

```sql
-- BLAKE와 BLAKE팀원만 나오고 월급이 낮은 순서대로 정렬해라
select rpad(' ', level*3) || ename as employee, level, sal, job
from emp
start with ename='BLAKE'
connect by prior empno=mgr
order siblings by sal;
```
![](8-7.png)


---
## 계층형 질의 가로로 출력

>`sys_connect_by_path(컬럼, 구분기호)` : 계층대로 가로로 출력할 컬럼을 지정해서 가로로 출력.

```sql
select ename, sys_connect_by_path(ename,'/') as path
from emp
start with ename='KING'
connect by prior empno = mgr;
```
![](8-8.png)

```sql
select ename || '('||sal||')', 
		sys_connect_by_path(ename || '('||sal||')', '/') as path
from emp
start with ename='KING'
connect by prior empno=mgr
```
![](8-9.png)


