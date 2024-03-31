# 함수의 종류

#### 단일행 함수
하나의 행만 입력했을 때 값을 내는것

| 함수        | 함수명         |
| ----------- | ---------- |
| 문자함수    | upper, lower, initcap, substr, instr, length, concat, lpad, rpad, itrim, rtrim, trim |       |
| 숫자함수    | round, trunc, mod                                                                    |       |
| 날짜함수    | months_between, add_months, next_day, last_day                                       |       |
| 변환함수    | to_char, to_number, to_date                                                          |       |
| 일반함수    | nvl, nvl2, case, decode                                                              |       |

#### 다중행 함수
여러 행을 입력했을 때 값을 내는 것

| 함수        | 함수명                |
| ----------- | --------------|
| 최대값                         | max   |
| 최소값                                  | min   |
| 평균값                                   | avg   |
| 합계                                       | sum   |
| 갯수                                | count |

---
## lower(), upper(), initcap()

```sql
select ename, lower(ename), upper(ename), initcap(ename) from emp;
```

![[2-1.png]]

- `lower()` : 전부 소문자로 출력
- `upper()` : 전부 대문자로 출력
- `initcap()` : 첫 글자만 대문자 나머지는 소문자로 출력


---
## 









