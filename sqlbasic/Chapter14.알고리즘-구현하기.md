## 숫자 1~10까지 출력해라.

- 계층형 질의문을 이용하면 가능함.

```sql
select level as num
from dual
connect by level <= 10;
```
![](14-1.png)


## 구구단 2단을 구현해라

```sql
with loop_table as (select level as num
                        from dual
                        connect by level <= 9)
select '2' || 'x' || num || ' = ' || 2 * num as "2단"
    from  loop_table;
```
![](14-2.png)


## 1 ~ 100까지의 합을 구하여라.

```sql
select sum(level) from dual
connect by level <= 100;
```
![](14-3.png)


## 1 ~ 100까지의 합에서 55를 뺀 합을 구하여라

```sql
select sum(level)
from dual
where level != 55
connect by level <= 100;
```


## 1 ~ 100까지 짝수 수의 합을 구하여라

```sql
select sum(level)
from dual
where mod(level,2) =0
connect by level <= 100;
```


## 구구단 2 ~ 9단까지 출력해라

```sql
with eightT as (select level +1 as numr
from dual
connect by level <= 8),
nineT as (select level as numl
from dual
connect by level <= 9)
select numr || 'x' || numl || ' = ' || numr * numl
from nineT, eightT
```
⇒ `where절`없이 join할 경우 모든 경우의 수가 join됨.


## 2, 5, 7단만 출력해라

```sql
with guguT as (select level as numr
from dual
connect by level <=7),
loopT as (select level as numl
from dual
connect by level <= 9)
select numr || 'x' || numl || ' = ' || numr * numl
from guguT, loopT
where numr in (2,5,7);
```


## 짝수 단만 출력해라

```sql
with guguT as (select level + 1 as numr
from dual
connect by level <=8),
loopT as (select level as numl
from dual
connect by level <= 9)
select numr || 'x' || numl || ' = ' || numr * numl
from guguT, loopT
where mod(numr,2) = 0;
```


## 삼각형 별 만들기

```sql
select lpad('★',level, '★'), level from dual
connect by level <=8;
```
![](14-4.png)


## 삼각형을 뒤집어서 출력해라.

```sql
select lpad('★', 9 - level, '★'), level from dual
connect by level <= 8;
```
![](14-5.png)


## 마름모 절반 모양을 출력해라

```sql
select lpad('★',level, '★'), level from dual
connect by level <=8
union all
select lpad('★', 9 - level, '★'), level from dual
connect by level <= 8;
```
![](14-6.png)


## 삼각형을 출력해라

```sql
with loop_table as (select level as num
                        from dual
                        connect by level <=8)
select  lpad(' ', 10-num, ' ') || lpad( '★',num,'★')       
from loop_table;
```

## 역삼각형을 출력해라

```sql
with loop_table as (select level as num
                        from dual
                        connect by level <=8)
select  lpad(' ', num, ' ') || lpad( '★',9 - num,'★')       
from loop_table;
```


## 마름모를 출력해라

```sql
select lpad(' ', 6-level, ' ') || lpad('★',level,'★')       
from dual
connect by level<=5
union all
select lpad(' ', level+1, ' ') || lpad('★',5-level,'★')       
from dual
connect by level<=4;
```
![](14-7.png)


## 치환변수

>`undefine 변수명`
>`accept 변수명 prompt 텍스트'
>사용할 때는 `&변수명`

```sql
undefine p_num
accept p_num prompt '숫자입력 : '

select lpad(' ', &p_num-level, ' ') || rpad('★', level, '★') as star
from dual
connect by level < &p_num+1
union all
select lpad(' ', level, ' ') || rpad('★', (&p_num) - level, '★') as star
from dual
connect by level< &p_num;
```
![](14-8.png)


## 모래시계 모양

```sql
undefine q_num
accept q_num prompt '숫자입력 >> '

select lpad(' ', level, ' ') || rpad('★', &q_num-level+1, '★')
from dual
connect by level<=&q_num
union all
select lpad(' ', &q_num-level, ' ') || rpad('★', level+1, '★')
from dual
connect by level <=&q_num-1;
```
![](14-9.png)


## 직사각형을 출력해라

```
undefine wide
undefine hig
accept wide prompt '가로 >> ';
accept hig prompt '세로 >> ';
with loopT as(select level from dual
                connect by level <=&hig)
select lpad('★', &wide,'★')
from loopT;
```
![](14-10.png)


## 숫자를 한번만 입력받아서 정사각형을 구하여라

```sql
undefine tmp
accept tmp prompt '숫자를 입력해라 >> ';

with loopT as(select level from dual
                connect by level <= &tmp)
select lpad('★', &&tmp,'★')
from loopT;
```

`&&`이렇게 넣으면 두번 물어보지않고 첫번째에 물어본걸로 동시에 처리함.

## 1부터 10까지의 합을 구하여라.

```sql
select sum(level) 
from dual
connect by level<=10;
```

- 숫자 입력해서 합 구하기
```sql
undefined tmp1
accept tmp1 prompt'합계구하기>> ';

select sum(level) from dual
connect by level <= &tmp1;
```


## 1부터 100까지 숫자중 짝수들의 합을 구하여라

```sql
select sum(level) 
from dual
where mod(level,2)=0
connect by level <=100;

-- 홀수들의 합
select sum(level) 
from dual
where mod(level,2)=1
connect by level <=100;
```


## 1부터 10까지의 곱을 구하여라

- `e¹⁰`
```sql
select exp(10)
from dual;
```

- `log𝚎10`
```sql
select ln(10)
from dual;
```

- 1부터 누적 곱
```sql
undefine p_n
accept p_n prompt '숫자를 입력해라 >> '

select round(exp(sum(ln(level)))) 곱
from dual
connect by level <= &p_n;
```
![](14-11.png)

- 1부터 100까지 짝수들의 곱을 구하여라
```sql
select round(exp(sum(ln(level))))
from dual
where mod(level,2)=0
connect by level <=100;
```


## 1부터 10까지 짝수만 가로로 출력해라.

```sql
select listagg(level, ',')
from dual
where mod(level,2)=0
connect by level <=10
```
![](14-12.png)


## 1부터 10까지 홀수만 가로로 출력해라

```sql
select listagg(level, ',')
from dual
where mod(level,2)=1
connect by level <=10
```


## 1부터 10까지 중 소수만 출력해라.

```sql
with loop_table as (select leveel as num
                    from dual
                    connect by level <= 10)
select l1.num as 소수
from loop_table l1, loop_tabel l2
where mod(l1.num, l2.num) = 0  
-- 서로 나눠서 나누에 떨어지는데 1과 자기 자신. 총 2개이면 약수가됨.
group by l1.num
having count(l1.num) = 2;
```

- 소수들의 합을 구하여라
```sql
select sum(소수)
from (with loop_table as (select level as num
                    from dual
                    connect by level <=10)
select l1.num as 소수
from loop_table l1, loop_table l2
where mod(l1.num, l2.num) = 0
group by l1.num
having count(l1.num) =2);
```

- 소수들의 곱을 구하여라
```sql
select round(exp(sum(ln(소수))))
from (with loop_table as (select level as num
                    from dual
                    connect by level <=10)
select l1.num as 소수
from loop_table l1, loop_table l2
where mod(l1.num, l2.num) = 0
group by l1.num
having count(l1.num) =2);
```


## 16과 24의 최대 공약수를 구하여라

```sql
--1. 16과 24를 출력
select 16 as num1, 24 as num2
from dual;

--2. 16과 24를 1부터 나눈 나머지를 출력
with num_d as (select 16 as num1, 24 as num2
                from dual)
select level, mod(num1, level), mod(num2, level)
from num_d
connect by level <= num2;
```
![](14-13.png)
⇒ 나머지 둘다 0이 되는 최대 값을 구하면됨.

```sql
with num_d as (select 16 as num1, 24 as num2
                from dual)
select max(level)
from num_d
where mod(num1, level)=0 
	and mod(num2, level)=0
connect by level <= num2;
```

- 16, 24, 48의 최대 공약수를 구해라
```sql
with numT as (select 16 as num1, 24 as num2, 48 as num3
                from dual)
select max(level)
from numT
where mod(num1,level) =0
    and mod(num2, level) = 0
    and mod(num3, level) =0
connect by level <=num3;
```

## 16과 24의 최소 공배수를 구해라

- 최대 공약수를 구한 후 최대 공약수와 나눈 나머지 값들을 최대 공약수와 곱하면됨.
```sql
select 최대공약수 * (num1/최대공약수) * (num2/최대공약수) as 최소공배수
from (with numT as (select 16 as num1, 24 as num2
                from dual)
select max(level) as 최대공약수 , num1, num2
from numT
where mod(num1, level) = 0
    and mod(num2, level) = 0
connect by level<=num2);
```
![](14-14.png)


- 16, 24, 56의 최소 공배수를 구하여라
```sql
select 최대공약수 * (num1 / 최대공약수) * (num2 / 최대공약수) * (num3 / 최대공약수) as 최소공배수
from (with numT as (select 16 as num1, 24 as num2, 56 as num3 from dual)
select max(level) 최대공약수, num1, num2, num3
from numT
where mod(num1, level) = 0
    and mod(num2, level) = 0
    and mod(num3, level) = 0
connect by level <= num3);  
```


## 피타고라스의 정리로 직각 삼각형 여부를 확인해라.

- `피타고라스의 정리`
![](14-15.png)
- `power`
```sql
--2³ = 8
select power(2,3) from dual;

--case문
select case when 2=2 then '맞습니다.' else '아닙니다.' end
from dual;
```

```sql
accept num1 prompt ' 밑변의 길이를 입력해라>> '
accept num2 prompt '높이를 입력해라>> '
accept num3 prompt '빗변의 길이를 입력해라>> '

select case when(power(&num1, 2) + power(&num2, 2)) = power(&num3,2)
            then '직각 삼각형이 맞습니다.'
            else '직각 삼각형이 아닙니다.' end as "피타고라스의 정리"
from dual;   
```

## 정삼각형이 맞는지 확인하는 쿼리를 작성해라

```sql
accept num1 prompt '왼쪽 빗변의 길이를 입력해라>> '
accept num2 prompt '오른쪽 빗변의 길이를 입력해라>> '
accept num3 prompt '밑변을 입력해라>> '

select case when (&num1 = &num2 and &num2 = &num3)
                then '정삼각형이 맞습니다.'
                else '정삼각형이 아닙니다.' end
from dual; 
```


## 몬테카를로 알고리즘으로 원주율을 구하여라

![](14-16.png)

![](14-17.png)
- `𝛑/4` : 부채꼴의 넓이
- `1` : 정사각형의 넓이

```sql
select sum(case when (power(num1, 2) + power(num2, 2)) <= 1 then 1
                else 0 end) / 100000 * 4 as "원주율"
from (select dbms_random.value(0,1) as num1, 
            dbms_random.value(0,1) as num2  -- 0 ~ 1사이의 난수
        from dual
        connect by level < 100000);
```
![](14-18.png)


## 자연상수 e의 값을 SQL로 알아내라

![](14-19.png)


```sql
with loop_table as (select level as n
                        from dual
                        connect by level <= 1000000
                    )
select result
from (
        select n, power((1 + 1/n), n) as result
        from loop_table
    )
where n = 1000000;   
```
![](14-20.png)

