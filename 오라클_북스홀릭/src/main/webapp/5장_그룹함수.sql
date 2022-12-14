/************************************************************************
 * < 참조 : 오라클 실행 순서 >
 * from -> where -> group by -> having -> select 컬럼명의 별칭 -> order by
 * 
 * 따라서 'where절, group by절, having절'에서 '컬럼명의 별칭' 인식 못함
 * (예를 들어, where + '컬럼명의 별칭' 사용불가)
 * order by절에서만 '컬럼명의 별칭' 인식
 * 
 * 단, 아래 SQL문은 where절에 별칭 사용가능
 * select *
 * from (select salary AS "급여" from employee)
 * where "급여" > 1000;
 ************************************************************************/
--[순서-1]
select salary AS "급여" from employee;
--[순서-2]
select *
from (select salary AS "급여" from employee)
where "급여" > 1000;

select salary AS "급여"
from employee
--where "급여" > 1000; --[오류]ORA-00904: "급여": invalid identifier
where salary > 1000; --가능



--<북스-5장> 그룹 함수 : '하나 이상의 행을 그룹으로 묶어 연산'하여 총합, 평균 등 결과를 구함
--★★ 주의 : count(*) 함수를 제외한 모든 그룹함수들은 null값은 무시

--사원들의 급여 총액, 급여 평균액, 급여 최고액, 급여 최저액 출력
select
SUM(salary),
AVG(salary),--실수
--trunc(AVG(salary)) --정수
MAX(salary),
MIN(salary)
from employee;
--'전체 사원테이블'이 대상이면 group by 사용안함(이유?전체가 하나의 그룹이므로...)

--max(), min() 함수는 숫자데이터 이외에 다른 '모든 데이터 유형'에 사용가능
--[문제] 최근에 입사한 사원과 가장 오래전에 입사한 사원의 입사일을 출력
select
MAX(hiredate) as "최근사원",
MIN(hiredate) as "첫 사원"--별칭이 너무 길면 오류 발생함
from employee;

--1.1 그룹함수와 NULL값(145P~)
--사원들의 커미션 총액 출력
select
sum(commission) as "커미션 총액"
from employee;--2200
--null값과 연산한 결과는 무조건 null이 나오지만
--count(*) 함수를 제외한 모든 그룹함수들은 null값은 무시

--1.2 '행 개수'를 구하는 count함수
select count(*) as "전체 사원수"
from employee; --14

--커미션을 받는 사원수
--[방법-1] count(*) : null제외안함
select count(*) as "커미션을 받는 사원수"
from employee
where commission IS NOT null;

--[방법-2] count(컬럼명) : null제외
select count(commission) as "커미션을 받는 사원수"
from employee;

--직업(job)이 어떤 종류?
select job
from employee;

select DISTINCT job --distinct : 중복 제외
from employee;

--직업(job)의 개수
select count(job), count(ALL job) as "ALL한 직업수"
from employee;--14	14

select count(commission), count(ALL commission) as "ALL한 커미션", count(*)
from employee;--4	4	14

--업(job)의 개수 : DISTINCT (중복 제외)
select count(job), count(distinct job) as "중복제외한 직업수"
from employee;

--★★★★★★★★★ 1-3. 그룹함수와 단순컬럼 ★★★★★★★★★★★★★★★★★★★★★★★★★★
SELECT ename, max(salary) --다:1
from EMPLOYEE;--ORA-00937: not a single-group group function
--오류? 그룹함수의 결과값은 1개인데, 
--그룹함수를 적용하지 않은 컬럼은 결과가 여러 개 나올 수 있으므로
--매치시킬 수 없기 때문에 오류발생

--2. 데이터 그룹 : GROUP BY - 특정 컬럼을 기준으로 그룹별로 나눠야 할 경우
-- ★★ group by 절 뒤에 '컬럼의 별칭' 사용불가. 반드시 컬럼명만 기술

--[문제] 소속 부서별로 평균급여를 부서번호와 함께 출력(부서번호를 기준으로 오름차순 정렬)
--[순서-1]
select distinct dno
from employee; --10 20 30

--[순서-2]
select dno, AVG(salary)--1 : 1
from employee
GROUP BY dno--10 20 30
order by dno asc;

select AVG(salary) --dno(부서번호)가 없으면 결과는 무의미해짐
from employee
GROUP BY dno--10 20 30
order by dno asc;

--오류? ORA-00979: not a GROUP BY expression
select dno, ename, AVG(salary)--3 : 14 : 3
from employee
GROUP BY dno--10 20 30
order by dno asc;

select dno, ename, AVG(salary)--14 : 14
from employee
GROUP BY dno, ename--(10, 같은이름) (20, 같은이름) (30, 같은이름)
order by dno asc;

select dno, job, count(*), SUM(salary), AVG(salary)
from employee
GROUP BY dno, job--(10, 같은직업) (20, 같은직업) (30, 같은직업)
order by dno asc;
--GROUP BY 절은 먼저 dno(부서번호)를 기준으로 그룹화한 다음
--해당 부서 번호 그룹 내에서 job(직업)을 기준으로 다시 그룹화

--3. 그룹 함수 제한 : havikng (152p~)
--그룹 함수의 결과 중 having절 다음에 지정한 조건에 true인 그룹으로 결과 제한

--[문제] '부서별 급여총액이 10000이상'인 부서의 부서번호와 부서별 급여총액 구하기
--(부서번호로 오름차순 정렬)
--[1] 부서별 급여총액 구하기
select dno, sum(salary)
from EMPLOYEE
GROUP BY dno;

--[2] '부서별 급여총액이 10000이상' -> 정렬
select dno, sum(salary)
from EMPLOYEE
--where sum(salary) > 10000 -- where 조건 => 오류발생? 그룹함수의 조건은 having절에
GROUP BY dno
HAVING SUM(salary) > 10000 -- 그룹 조건
order by dno asc;

--[문제] 'MANAGER'를 제외'하고 '급여총액이 5000이상'인 직급별 수와 급여총액
--(급여총액을 기준으로 내림차순 정렬)
--[1] 직급별 수와 급여총액 구하기
select job, count(*), sum(salary)--job이 없으면 무의미하다
from employee
group by job;

--[2] 'MANAGER를 제외'하기 [방법-1]
select job, count(*), sum(salary)
from employee
where job != 'MANAGER' -- != ^= <>
group by job;

--[2] 'MANAGER를 제외'하기 [방법-2]
select job, count(*), sum(salary)
from employee
where job not like 'MANAGER'
group by job;

--[3] 급여총액이 5000이상 [방법-1]
select job, count(*), sum(salary) as "급여 총액"
from employee
where job != 'MANAGER'	-- != ^= <>
group by job
having sum(salary) >= 5000
--order by sum(salary) desc;
--order by 3 desc;
order by "급여 총액" desc; --별칭으로도 정렬 가능!

--[3] 급여총액이 5000이상 [방법-2]
select job, count(*), sum(salary) as "급여 총액"
from employee
where job NOT like 'MANAGER'
group by job
having sum(salary) >= 5000
order by 3 desc;

--아래는 오류 발생함
select job, count(*), sum(salary) as "급여 총액"
from employee
where job NOT like 'MANAGER' AND sum(salary) >= 5000
group by job
--having sum(salary) >= 5000
order by 3 desc;
--ORA-00934: group function is not allowed here
-- 오류 : 그룹함수가 포함된 조건은 HAVING절에서만 사용가능


--★★ 그룹함수는 2번까지만 중첩해서 사용가능
--[문제] 부서번호 별 급여평균의 최고값을 출력
--[1] 부서번호 별 급여평균 구하기
select dno, avg(salary)--dno이 없으면 결과는 무의미하다
from employee
group by dno;

--[2] 부서번호 별 급여평균의 최고값을 출력
select dno, MAX(avg(salary)) --3:1 => 매칭불가 => 오류
from employee
group by dno;--오류 발생? dno은 3가지이지만 MAX(avg(salary))는 무조건 1개이므로 매치불가

--오류 해결하는 [방법-1] : 간단하게 해결
select MAX(avg(salary)) as "부서별급여평균최고"--dno이 없으면 결과는 무의미하다
from employee
group by dno;

select trunc(MAX(AVG(salary))) as "부서별급여평균최고"--dno이 없으면 결과는 무의미하다
from employee
group by dno;

--오류 해결하는 [방법-2] : dno도 함께 출력하고 싶다면 => '서브쿼리' 이용
--[1] 부서번호 별 급여평균 구하기
select dno, avg(salary)--dno이 없으면 결과는 무의미하다
from employee
group by dno;

--[2] 부서 별 평균이 급여평균의 최고값과 같은 것 구하기
select dno, AVG(salary)--dno이 없으면 결과는 무의미하다
from employee
group by dno
HAVING AVG(salary) = (select MAX(AVG(salary))--dno이 없으면 결과는 무의미하다
					  from employee
					  group by dno);

----[교재없는 내용]---------------------------------------------------------------------
--★★ rank() : 순위 구하기

--[문제-1] 급여 상위 3개 조회
--(만약 급여가 같다면 커미션이 높은 순으로 조회, 커미션이 같다면 사원명을 알파벳 순으로 조회)

--아래 방법으로 해결불가
--[1]
select ename, salary, commission
from EMPLOYEE;--

--[2]
select ename, salary, commission
from EMPLOYEE
where rownum <= 3--정렬되기 전 전체 중 위에서 3줄만 가져옴
order by salary desc, commission desc; --select(조회) 후 정렬

--방법-1 : rank() 함수 사용
--[1]
select ename, salary, commission,
RANK() OVER(order by salary desc) AS "급여 순위-1",--1 2 2 4
DENSE_RANK() OVER(order by salary desc) AS "급여 순위-2", --1 2 2 3
RANK() OVER(order by salary desc, commission desc, ename asc) AS "급여 순위-3" --1 2 3 4 순위가 중복되지 않도록 하기 위해
from EMPLOYEE;

--[2]최종해결법★★ 1 2 3등만 출력
select *
from (select ename, salary, commission,
RANK() OVER(order by salary desc, commission desc, ename asc) AS "급여 순위"	--1 2 3 4 순위가 중복되지 않도록 하기 위해
from employee)
where "급여 순위" <= 3;
--where "급여 순위" = 1 or "급여 순위" = 2 or "급여 순위" = 3;


--부서그룹 별 '부서 안에서 각 순위 구하기' : partition by + 그룹 컬럼명
select dno, ename, salary, commission,
RANK() OVER(partition by dno order by salary desc, commission desc, ename asc) AS "부서별 급여 순위" --순위가 중복되지 않도록 하기 위해
from EMPLOYEE;


--방법-2 : UNION ALL 사용(-->이 방법은 나중에 'SQL 활용 시험 정리'할 때 설명하기)
--UNION ALL : 중복 제거X, 			UNION : 중복 제거
--사원테이블에서 '연봉 상위 3명'의 이름, 급여 조회(단, 급여가 같으면 사원이름으로 오름차순 정렬)
--[1]
select ename, salary from employee where dno = 10;--3
select ename, salary from employee where dno = 20;--5
select ename, salary from employee where dno = 30;--6
select ename, salary from employee where dno = 40;--0

--[2]
select ename, salary from employee where dno = 10
UNION ALL--중복 제거X
select ename, salary from employee where dno = 20
UNION ALL
select ename, salary from employee where dno = 30
UNION ALL
select ename, salary from employee where dno = 40

ORDER BY salary desc, ename asc;

--[3]최종해결방법★★
select *
from (	select ename, salary from employee where dno = 10
		UNION ALL--중복 제거X
		select ename, salary from employee where dno = 20
		UNION ALL
		select ename, salary from employee where dno = 30
		UNION ALL
		select ename, salary from employee where dno = 40
		
		ORDER BY salary desc, ename asc )
WHERE rownum <= 3; --1 2 3

--[문제-2] 그룹 별 급여 최소값, 최대값 구하기----------------------------------------------
--부서그룹 별 급여 최소값, 최대값 구하기
--keep()함수와 FIRST, LAST키워드를 활용하면 그룹 내에 최소값, 최대값을 쉽게 구할 수 있다.
--DENSE_RANK함수만 사용가능하다.

select MIN(salary), MAX(salary)
from employee; --전체 사원테이블에서 최대값, 최소값은 1개씩만 존재하므로

--dno, ename, salary로 그룹을 만들어 실행하면 각각 1명씩에 대한 급여가 바로 최소이자 최대급여
select dno, ename, salary,
MIN(salary), MAX(salary)--그룹함수
from employee
group by dno, ename, salary;

--[해결방법-1]
select dno,--ename, salary, 추가하면 오류 발생(1:n 관계이므로)
MIN(salary), MAX(salary)--그룹함수
from employee
group by dno
order by dno asc;

--[해결방법-2] ★★
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "부서별 최소 급여",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "부서별 최대 급여"
from employee
order by dno asc;

--[문제-3] 그룹 별 최소값, 최대값 구하기 + 전체 급여 순위 구하기 (같은 급여는 같은 등수 예. 1 2 2 4) -----------------------------------------------
select dno, ename, salary,
MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "부서별 최소 급여",
MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "부서별 최대 급여",
RANK() OVER(partition by dno order by salary desc) AS "부서별 급여 순위-1" -- 1 2 2 4
from employee
order by dno asc;

--[문제-4] 문제3의 결과에서 각 그룹의 1등만 표시
select *
from (
	select dno, ename, salary,
	MIN(salary) keep(DENSE_RANK FIRST order by salary asc) OVER(partition by dno) as "부서별 최소 급여",
	MAX(salary) keep(DENSE_RANK LAST order by salary asc) OVER(partition by dno) as "부서별 최대 급여",
	RANK() OVER(partition by dno order by salary desc) AS "부서별 급여 순위-1" -- 1 2 2 4
	from EMPLOYEE
	order by dno asc)
where "부서별 급여 순위-1" = 1;


--<5장 그룹함수-혼자해보기>----------------------------------------------------------------------------
/*
 * 1.모든 사원의 급여 최고액, 최저액, 총액 및 평균 급여를 출력하시오.
 * 컬럼의 별칭은 결과 화면과 동일하게 저장하고 평균에 대해서는 정수로 반올림하시오.
 */
select 
MAX(salary) 최고액,
MIN(salary) 최저액,
SUM(salary) 총액,
round(AVG(salary)) as "평균 급여" -- 소수 첫 째 자리에서 반올림하여 정수(=일의자리까지)로 출력
from employee;

select MAX(salary) as "Maximum",
MIN(salary) as "Minimum",
SUM(salary) as "Sum",
ROUND(AVG(salary), 0) as "Average"
from employee;

/*
 * 2.각 담당 업무 유형별로 급여 최고액, 최저액, 총액 및 평균액을 출력하시오.
 * 컬럼의 별칭은 결과 화면과 동일하게 저장하고 평균에 대해서는 정수로 반올림하시오.
*/

select job,	-- 추가하여 결과가 무의미해지지 않도록 함
MAX(salary) 최고액,
MIN(salary) 최저액,
SUM(salary) 총액,
round(AVG(salary), 0) as "평균 급여" --소수 첫 째 자리에서 반올림하여 정수로 출력
from employee
group by job;


/*
 * 3.count(*)함수를 이용하여 담당 업무가 동일한 사원 수를 출력하시오.
 */
select job as "담당 업무", count(*) as "사원 수"
from employee
group by job;

/*
 * 4.관리자(=manager : 컬렴명)수(count())를 나열하시오. 
 * 컬럼의 별칭은 결과 화면과 동일하게 지정하시오.
 * (=> 문제 해석의 차이로 여러 방법이 있을 수 있음..)
 */
select manager from employee;

--[방법-1] : count(컬럼명) : 수 세기( null제외 )
select count(manager) as "관리자 수"
from employee;--13

--[방법-2] : job이 'MANAGER'인 수?
--[1]
select job as "직급", count(*) as "수" --1:1
from employee
GROUP BY job;

--[2]
select job as "직급", count(*) as "수" --1:1
from employee
where job = 'MANAGER' --대문자로 입력
GROUP BY job;--3

/*
 * 5.급여 최고액, 급여 최저액의 차액을 출력하시오. 
 * 컬럼의 별칭은 결과 화면과 동일하게 지정하시오. 
 */
select MAX(salary) - MIN(salary) as "차액"
from employee;

/*
 * 6.직급별 사원의 최저 급여를 출력하시오. 
 * '관리자를 알 수 없는 사원' 및 '최저 급여가 2000 미만'인 그룹은 '제외'시키고 
 * 결과를 급여에 대한 내림차순으로 정렬하여 출력하시오. 
 */
--[1]
select job, MIN(salary) "최저 급여"
from employee
group by job;

--[2] 방법-1. (이상>= , 이하<= , 초과> , 미만<)
select job, MIN(salary) "최저 급여"
from employee
where manager IS NOT NULL
group by job
having MIN(salary) >= 2000 --그룹함수 조건
order by 2 desc;

--[2] 방법-2.
select job, MIN(salary) "최저 급여"
from employee
where manager IS NOT NULL
group by job
having NOT MIN(salary) < 2000 --그룹함수 조건
order by "최저 급여" desc;

/*
select job, MIN(salary) "최저 급여"
from employee
where manager IS NOT NULL
group by job
having MIN(salary) >= 2000
order by MIN(salary) desc;
*/

/*
 * 7.각 부서에 대해 부서번호, 사원수, 부서 내의 모든 사원의 평균 급여를 출력하시오. 
 * 컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 소수점 둘째 자리로 반올림하시오. 
 */
select dno, count(*) as "각 부서의 사원 수",
round(avg(salary), 2) as "평균 급여"
from employee
group by dno;

--★★7번 문제에 추가(★단, 테이블을 조회하기 전에 salary의 null여부를 모른 상태에서 조회한다면)
--테스트 위해 추가해봄
INSERT INTO employee VALUES
(7002, 'JANG', 'CLERK', 7902, '2022/05/30', NULL, null, 20);

--사실 avg(salary)는 null제외하고 평균을 구함
--그래서 null값 급여를 받는 사원이 있으면 그 사원을 제외하고 평균을 구함
--그러나 null값 급여를 받는 사원도 함께 포함시켜 평균을 계산하려면
--반드시 null처리함수(nvl, nvl2) 사용하여 구체적인 값으로 변경
select dno, count(*) as "각 부서의 사원 수",
round(avg(NVL(salary,0)), 2) as "평균 급여"
from employee
group by dno;

--[추가문제] '커미션을 받는 사원들만의 커미션 평균'과 '전체 사원의 커미션 평균' 구하기
select
avg(commission) as "커미션O-평균",
avg(NVL(commission, 0)) as "전체사원-커미션평균"
from employee;

delete from employee where eno=7002;


/*
 * 8.각 부서에 대해 부서번호, 이름, 지역명, 사원수, 부서내의 모든 사원의 평균 급여를 출력하시오. 
 * 컬럼의 별칭은 결과 화면과 동일하게 지정하고 평균 급여는 정수로 반올림하시오.
 */
select dno,

decode(dno, 10, 'ACCOUNTING',
			20, 'RESEARCH',
			30, 'SALES',
			40, 'OPERATIONS') as "부서이름",
			       
decode(dno, 10, 'NEW YORK',
	   		20, 'DALLAS',
	   		30, 'CHICAGO',
	   		40, 'BOSTON') AS "지역명",
	   		
sum(salary) as "부서별 급여총액",
count(*) as "각 부서의 사원 수",

round(AVG(salary)) as "부서별 평균급여-1", --null 급여받는 사원제외
round(AVG(NVL(salary, 0))) as "부서별 평균급여-2" --null 급여받는 사원포함

from employee
group by dno
order by dno asc;

--[문제-8]을 join 이용하여 해결--------------------------------------
select *
from employee, DEPARTMENT; --14*4=56

--1.join 이용한 '방법-1' : , where	  (테이블 별칭 사용)
select eno, ename, department.dno, dname
from employee, DEPARTMENT
where employee.dno = department.dno; --조인조건

select eno, ename, d.dno, dname --e.dno와 d.dno는 같음
from employee e, DEPARTMENT d --테이블 별칭 사용(이유?조인결과 중복된 컬럼을 구분하기 위해)
where e.dno = d.dno; --조인 조건

--위 방법을 '문제 8'에 적용시키면
select e.dno, dname as "부서 이름", loc as "지역명",
sum(salary) as "부서별 급여총액",
count(*) as "각 부서의 사원 수",

round(AVG(salary)) as "부서별 평균급여-1", --null 급여받는 사원제외
round(AVG(NVL(salary, 0))) as "부서별 평균급여-2" --null 급여받는 사원포함

from employee e, department d

where e.dno = d.dno --조인 조건
--AND (e.dno = 10 OR e.dno = 30) --검색조건 : 주의 ()넣기(이유?우선순위 NOT > AND > OR)

group by e.dno, dname, loc --그룹함수 앞(주의 : ★컬럼의 별칭 인식못함)
order by e.dno asc;

--2.join 이용한 '방법-2' : join ~ on 		(테이블 별칭 사용)
select eno, ename, department.dno, dname
from employee JOIN DEPARTMENT
ON employee.dno = department.dno; --조인조건

select eno, ename, d.dno, dname --e.dno와 d.dno는 같음
from employee e JOIN DEPARTMENT d --테이블 별칭 사용(이유?조인결과 중복된 컬럼을 구분하기 위해)
ON e.dno = d.dno; --조인 조건

--위 방법을 '문제 8'에 적용시키면
select e.dno, dname as "부서 이름", loc as "지역명",
sum(salary) as "부서별 급여총액",
count(*) as "각 부서의 사원 수",

round(AVG(salary)) as "부서별 평균급여-1", --null 급여받는 사원제외
round(AVG(NVL(salary, 0))) as "부서별 평균급여-2" --null 급여받는 사원포함

from employee e JOIN department d
ON e.dno = d.dno --조인 조건
--WHERE e.dno = 10 OR e.dno = 30--검색조건
group by e.dno, dname, loc --그룹함수 앞(주의 : ★컬럼의 별칭 인식못함)
order by e.dno asc;

--3.join 이용한 '방법-3' : natural join 		(중복된 컬럼을 제거하므로 테이블 별칭 사용 안함)
select eno, ename, dno, dname
from employee NATURAL JOIN DEPARTMENT; --조인조건 없어도 알아서 같은 컬럼끼리 조인하고 중복된 컬럼은 제거

--위 방법을 '문제 8'에 적용시키면
select dno, dname as "부서 이름", loc as "지역명",

sum(salary) as "부서별 급여총액",
count(*) as "각 부서의 사원 수",

round(AVG(salary)) as "부서별 평균급여-1", --null 급여받는 사원제외
round(AVG(NVL(salary, 0))) as "부서별 평균급여-2" --null 급여받는 사원포함

from employee e NATURAL JOIN department d
--WHERE dno = 10 OR dno = 30	--검색조건
group by dno, dname, loc --그룹함수 앞(주의 : ★컬럼의 별칭 인식못함)
order by dno asc;

--4.join 이용한 '방법-4' : join~USING		(중복된 컬럼을 제거하므로 테이블 별칭 사용 안함)
select eno, ename, dno, dname
from employee JOIN DEPARTMENT --중복된 컬럼은 제거
USING(dno); --조인조건

--위 방법을 '문제 8'에 적용시키면
select dno, dname as "부서 이름", loc as "지역명",

sum(salary) as "부서별 급여총액",
count(*) as "각 부서의 사원 수",

round(AVG(salary)) as "부서별 평균급여-1", --null 급여받는 사원제외
round(AVG(NVL(salary, 0))) as "부서별 평균급여-2" --null 급여받는 사원포함

from employee e JOIN department d
USING(dno) --조인조건
--WHERE dno = 10 OR dno = 30	--검색조건
group by dno, dname, loc --그룹함수 앞(주의 : ★컬럼의 별칭 인식못함)
order by dno asc;

/*
 * 9.업무를 표시한 다음 해당 업무에 대해 부서번호별 급여 및 부서 10, 20, 30의 급여 총액을 각각 출력하시오.
 * 각 컬럼에 별칭은 각각 job, 부서 10, 부서 20합, 부서 30, 총액으로 지정하시오.
 */
select job, dno,
count(*), --문제 이해위해 추가함
decode(dno, 10, SUM(salary), 0) as "부서 10",
decode(dno, 20, SUM(salary)) as "부서 20",
decode(dno, 30, SUM(salary)) as "부서 30",
SUM(salary) as "총액"
from employee
group by job, dno
order by dno;



select * from employee;
select * from DEPARTMENT;
