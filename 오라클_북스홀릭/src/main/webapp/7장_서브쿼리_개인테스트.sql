--7장 혼자해보기 다시 풀어보기

--<7장.서브쿼리-혼자해보기>----------------------------------
--1.사원번호가 7788인 사원과 '담당업무가 같은' 사원을 표시(사원이름과 담당업무)
--[1] 사원번호가 7788인 사원의 담당업무
select job
from EMPLOYEE
where eno = 7788;

--[2] 담당업무가 ANALYST인 사원 표시, 사원번호 7788 사원 제외
select ename, job
from employee
where job IN (select job
				from EMPLOYEE
				where eno = 7788)
AND eno <> 7788;

--2.사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당업무)
--[1] 사원번호 7499의 급여
select salary
from employee
where eno = 7499;

--[2] 7499보다 급여 많은 사원들 (사원이름, 담당업무)
select ename, job
from employee
where salary > (select salary
				from employee
				where eno = 7499);

--3.최소급여를 받는 사원의 이름, 담당 업무 및 급여 표시(그룹함수 사용)
--[1]최소급여
select min(salary)
from employee;

--[2]최소급여 받는 사원 구하기 (사원 이름, 담당업무, 급여 표시)
select ename, job, salary
from employee
where salary = (select min(salary)
				from employee);
				
--4.'직급별' 평균 급여가 가장 적은 담당 업무를 찾아 '직급(job)'과 '평균 급여' 표시
--단, 평균의 최소급여는 반올림하여 소수1째자리까지 표시
--[1] 직급별 평균의 최소급여
select min(avg(salary))
from employee
group by job;

--[2] 평균 급여가 가장 적은 담당 업무와 평균 급여
select job, ROUND(avg(salary), 1) as "평균 급여"
from employee
group by job
having avg(salary) IN (select min(avg(salary))
						from employee
						group by job);
				
--5.각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서 번호 표시
--[1] 각 부서의 최소 급여
select dno, min(salary)
from employee
group by dno;

--[2]부서 내 최소 급여 받는 사원 구하기 (사원 이름, 급여 , 부서 번호)
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, min(salary)
						from employee
						group by dno)
ORDER by dno asc;
						
--6.'담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 업무가 분석가가 아닌' 
--사원들을 표시(사원번호, 이름, 담당 업무, 급여)
--[1]담당 업무가 'ANALYST' 인 사원의 급여
select salary
from employee
where job = 'ANALYST';

--[2]담당 업무가 'ANALYST'인 사원보다 급여가 적으면서 업무가 'ANALYST'가 아닌 사원 구하기(사원번호, 이름, 담당 업무, 급여)
select

--★★7.부하직원이 없는 사원이름 표시(먼저 '문제 8. 부하직원이 있는 사원이름 표시'부터 풀기)

--★★8.부하직원이 있는 사원이름 표시

--9.BLAKE와 동일한 부서에 속한 사원이름과 입사일을 표시(단,BLAKE는 제외)

--10.급여가 평균 급여보다 많은 사원들의 사원번호와 이름 표시(결과는 급여에 대해 오름차순 정렬)

--11.이름에 K가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 이름 표시

--12.부서위치가 DALLAS인 사원이름과 부서번호 및 담당 업무 표시

--[과제-1]
--[12번 변경문제]. 부서위치가 DALLAS인 사원이름, 부서번호, 담당 업무, + '부서위치' 표시 

--13.KING에게 보고하는 사원이름과 급여 표시

--14.RESEARCH 부서의 사원에 대한 부서번호, 사원이름, 담당 업무 표시

--15.평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무하는 
--사원번호,이름,급여 표시

--16.평균 급여가 가장 적은 업무와 그 평균급여 표시

--17.담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원이름 표시