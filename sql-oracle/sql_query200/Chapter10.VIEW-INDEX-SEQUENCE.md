## View

>`create view 뷰테이블명`
>`as`
>`뷰 테이블에 넣을 데이터`

### 1. 보안상의 이유로 view 를 만듦.

- 전체 테이블 데이터에서 감춰야하는 데이터가 있는 경우 그 데이터를 제외하고 다른 데이터를 볼 수 있게 하려고 view 테이블을 만듦.(보안상의 이유)
- view 테이블은 데이터를 가지고 있는게 아니고 보기만 하는 것이므로 `update`를 하면 원본 테이블이 수정됨.

### 2. 복잡한 쿼리를 단순하게 만들기 위해 view를 만듦.

>그룹함수로 view를 만들 때 alias를 꼭 붙여줘야 함.

```sql
create view emp_view2
as
	select deptno, round(avg(sal)) as avgsal   --alias를 꼭 넣어줘야함.
		from emp
		group by deptno;
```


---
## INDEX

>`INDEX`는 데이터 검색 속도를 높여주는 객체이다.(책의 목차같은 역할을 한다.)
>`create index 인덱스 이름`
>`on 테이블명(컬럼)

- `Table`, `View`, `index`는 객체이다.

![](10-1.png)

- 인덱스에 데이터를 정렬해서 저장해서 바로 찾음
- 인덱스가 없으면 해당 데이터를 full scan해서 데이터를 찾으므로 더오래 걸림.

```sql
explain plan for
select ename, sal
from emp
where sal = 3000;

select * from table(dbms_xplan.display);
```
![](10-2.png)
⇒ full scan을 해서 데이터를 찾고 있음.

```sql
create index emp_sal
on emp(sal);

explain plan for
select ename, sal
from emp
where sal = 3000;

select * from table(dbms_xplan.display);
```
![](10-3.png)

- `rowid` : 행의 주소. file 번호 + 블럭번호 + row 번호. 테이블에도, 인덱스에도 있음
```sql
-- 테이블에 rowid
select rowid, empno, ename from emp;
```
![](10-5.png)

```sql
--인덱스에 rowid. 자동으로 sal 정렬이 되어있음
select sal, rowid from emp;
```
![](10-4.png)

```sql
create index emp_job
on emp(job);

select ename, job
from emp
where job = 'SALESMAN';
```


---
## SEQUENCE

> 번호가 중복되지 않게 데이터를 넣어줌
>`create sequence 시퀀스이름` : 기본 시퀀스 생성 문장(이후 문장은 옵션 추가)
>`start with 숫자` : 시퀀스 시작 숫자
>`maxvalue 숫자` : 시퀀스 최대 숫자
>`increment by 숫자` : 시퀀스 증가 숫자
>`nocycle` : 시퀀스가 최대 숫자가 되었을 때 다시 처음 시작 숫자로 돌아갈지 안돌아갈지 설정
>(`cycle`) 시작 숫자부터 다시 시작


```sql
create sequence seq1;

select seq1.nextval
from dual;
```

```sql
create sequence seq2
start with 1
maxvalue 100
increment by 1
nocycle;

select seq2.nextval
from dual;
```
- 100이 지나면 에러남.
![](10-6.png)

```sql
create sequence seq3
start with 1
maxvalue 100
increment by 1;

create table emp500
(empno number(10),
ename varchar2(10));

insert into emp500
values(seq3.nextval, 'scott');

select * from emp500;
```

```sql
create sequence dept_seq1
start with 50
increment by 10;

```


