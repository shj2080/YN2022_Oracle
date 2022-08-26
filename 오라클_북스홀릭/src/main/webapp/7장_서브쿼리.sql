--<북스-7장. 서브쿼리>
--[문제] 'SCOTT'보다 급여를 많이 받는 사원의 사원명과 급여 조회
--[1]. 우선 'SCOTT'의 급여를 알아야 함
select salary
from employee
where ename='SCOTT';--3000

--[2]. 해당급여 3000보다 급여가 많은 사원의 사원명과 급여 검색
select ename, salary
from employee
where salary > 3000;

--[3]. [2]메인쿼리 - [1]서브쿼리
select ename, salary
from employee
where salary > (select salary
				from employee
				where ename='SCOTT');
				--서브쿼리에서 실행한 결과(3000)가 메인쿼리에 전달되어 최종 결과를 출력
				
--단일 행 서브쿼리 : 내부서브쿼리문의 결과가 행 '1개'
--               단일행 비교연산자(>,<,=,>=,<=), IN연산자
--               (예) salary > 3000
--                   salary = 3000와 salary IN(3000)는 같은 표현

--다중 행 서브쿼리 : 내부서브쿼리문의 결과가 행 '1개 이상'
--               다중행 비교연산자(IN, any, some, all, exists)
--               (예) salary IN(1000, 2000, 3000)

--1. 단일 행 서브쿼리
--[문제] 'SCOTT'과 동일한 부서에서 근무하는 사원이름, 부서번호 조회
--[1]. 우선 'SCOTT'의 부서번호 알기
select dno
from EMPLOYEE
where ename='SCOTT';--20		
				
--[2]. 해당부서번호(=20)와 같은 사원이름, 부서번호 검색
select ename, dno
from employee
where dno = (select dno
			from EMPLOYEE
			where ename='SCOTT');--서브쿼리 결과 : 1개	
			
select ename, dno
from employee
where dno IN (select dno
			from EMPLOYEE
			where ename='SCOTT');--서브쿼리 결과 : 1개 이상=여러개라도 가능
			
--위 결과에는 'SCOTT'도 함께 조회됨. 'SCOTT'은 제외하고 조회하려면			
select ename, dno
from employee
where dno = (select dno
			from EMPLOYEE
			where ename='SCOTT')
AND ename != 'SCOTT';--조건 추가
				
select ename, dno
from employee
where dno = 20 AND ename != 'SCOTT';	

--[문제] 회사 전체에서 '최소 급여'를 받는 사원의 이름, 담당업무(job), 급여 조회
--[1]. 최소 급여 구하기
select MIN(salary)
from employee;--800

--[2]. 구한 최소급여(800)를 받는 사원의 이름, 담당업무(job), 급여 조회
select ename, job, salary
from employee
where salary = (select MIN(salary)--서브쿼리 결과 : 1개
				from employee);
--where salary = 800;
				
select ename, job, salary
from employee
where salary IN (select MIN(salary)
				 from employee);						
--where salary IN(800);	

--2. 다중 행 서브쿼리
--1) IN 연산자 : 메인쿼리의 비교조건에서 서브쿼리의 출력결과롸 '하나라도 일치하면'
--             메인쿼리의 where절이 true
--★ 단일 또는 다중 행 서브쿼리 둘다 사용가능함

--[문제]★★★ "부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회	
--[방법-1]		
--[1]."부서별 최소 급여"를 구하기
select min(salary)
from EMPLOYEE
group by dno;--최종결과라면 이 결과가 무의미하다.

--[2]."부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from EMPLOYEE
WHERE salary IN (select min(salary)--dno 제외함
				 from EMPLOYEE
				 group by dno)--IN( 1300,800,950 )
order by 1;

select dno, eno, ename, salary
from EMPLOYEE
WHERE salary IN (950, 800, 1300)
order by 1;

--[방법-2]
--[1]."부서별 최소 급여"를 구하기(dno까지 표시)
select dno, min(salary)--3:3
from EMPLOYEE
group by dno;--결과 : (10,1300),(20,800),(30,950)

--[2-1]서브쿼리  이용: ★★★ "부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno ,salary) IN (select dno, min(salary)--IN( (10,1300),(20,800),(30,950) )
				        from EMPLOYEE
				        group by dno)
order by 1;

select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno, salary) IN ((10,1300),(20,800),(30,950))
order by 1;

--[2-2] join 방법-1 이용
--[1]
select dno, min(salary)
from employee
group by dno;

--[2]
select *
from employee e1, (select dno, min(salary)
					from employee
					group by dno) e2
where e1.dno = e2.dno --조인조건
order by e1.dno;

--[3]
select e1.dno, eno, ename, salary
from employee e1, (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno --조인조건
--AND salary = min(salary)  --검색조건=>오류?(where절에서 min()함수 사용하여)
--[오류해결]별칭 사용
AND salary = "minSalary"
order by e1.dno;

--[2-3] join 방법-2 이용----
select e1.dno, eno, ename, salary
from employee e1 JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
ON e1.dno = e2.dno --조인조건
WHERE salary = "minSalary"	--검색조건
order by e1.dno;

--[2-4] join 방법-3 이용 : dno로 자연조인 -> 조인조건X, 중복제거->별칭X
select dno, eno, ename, salary
from employee natural JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno)
WHERE salary = "minSalary"	--검색조건
order by dno;

--[2-5] join 방법-4 이용 : 중복제거->별칭X
select dno, eno, ename, salary
from employee JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno)
USING(dno)--조인조건
WHERE salary = "minSalary"	--검색조건
order by dno;
----------------------------------------------------------------------------------------

--[위 문제의 '방법-1'의 쿼리에서 'min(salary)도 출력'하려면]
select min(salary)
from employee; --전체 사원 테이블이 대상이므로 1그룹

select dno, min(salary) -- 14:1 매칭불가=>오류
from employee;

select dno, min(salary) --dno 3그룹 : 3
from employee
GROUP BY dno
order by 1;

select dno, eno, ename, salary, min(salary) --"그룹함수 출력"하려면
from employee
GROUP BY dno, eno, ename, salary--GROUP BY절 뒤에 반드시 출력할 컬럼들 나열(그룹함수 제외)
order by 1;

select dno, eno, ename, salary, min(salary)
from employee
WHERE salary IN (950, 800, 1300) --검색조건
GROUP BY dno, eno, ename, salary
order by 1;
--[최종]
select dno, eno, ename, salary, min(salary)
from employee
WHERE salary IN (select min(salary)
				from employee
				group by dno)
GROUP BY dno, eno, ename, salary
order by 1;
----------------------------------------------------------------------------

--2) ANY 연산자 : 서브 쿼리가 반환하는 각각의 값과 비교
--WHERE 컬럼명 = any(서브쿼리의 결과1, 결과2) => 결과들 중 '아무거나와 같다'면 TRUE.
--WHERE 컬럼명 IN(서브쿼리의 결과1, 결과2) => 결과들 중 '아무거나와 같다'면 TRUE.

--정리 : A조건 OR B조건
--합집합 : 각각 만족하는 조건의 결과를 다 합침

--WHERE 컬럼명 < any(서브쿼리의 결과1, 결과2) => 결과들 중 "최대값"보다 작으면 TRUE.
--WHERE 컬럼명 > any(서브쿼리의 결과1, 결과2) => 결과들 중 "최소값"보다 크면 TRUE.

--[문제]★★★ "부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
--[2-6] =ANY 이용
--[1]."부서별 최소 급여"를 구하기(dno까지 표시)
select dno, min(salary)--3:3
from EMPLOYEE
group by dno;--결과 : (10,1300),(20,800),(30,950)

--[2-1]서브쿼리  이용: ★★★ "부서별 최소 급여"를 받는 사원의 부서번호, 사원번호, 이름, 최소급여를 조회
select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno ,salary) = any(select dno, min(salary)-- =ANY( (10,1300),(20,800),(30,950) )
				        from EMPLOYEE
				        group by dno)
order by 1;

--정리 : WHERE (dno, salary) = ANY( (10,1300),(20,800),(30,950) )
--		WHERE (dno, salary)   IN ( (10,1300),(20,800),(30,950) )
--		서브쿼리의 결과 중 '아무거나와 같다'면 TRUE

--정리 : WHERE salary != ANY(1300, 800, 950)
--		WHERE salary <> ANY(1300, 800, 950)
--		WHERE salary ^= ANY(1300, 800, 950)

--		WHERE salary NOT IN(1300, 800, 950)
--		서브쿼리의 결과 중 '어느 것도 아니면' TRUE

--정리 : WHERE salary < ANY(1300, 800, 950) 서브쿼리 결과들 중 "최대값(1300)"보다 작으면 TRUE.
--		WHERE salary > ANY(1300, 800, 950) 서브쿼리 결과들 중 "최소값(800)"보다 크면 TRUE.
--(예1)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
--		salary < ANY(1300, 800, 950)
--		salary < 1300
--		salary < 800
--		salary < 950
--결국	salary < 1300(최대값)의 범위가 나머지 범위들 다 포함함

--(예2)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
--		salary > ANY(1300, 800, 950)
--		salary > 1300
--		salary > 800
--		salary > 950
--결국	salary > 800(최소값)의 범위가 나머지 범위들 다 포함함


--[문제] 직급이 SALESMAN이 아니면서
--급여가 임의의 SALESMAN보다 낮은 사원의 정보(사원이름, 직급, 급여) 출력
--(※임의의 = '각각'으로 해석)
--[1]. 직급이 SALESMAN의 급여 구하기
select DISTINCT salary	--결과 :  1600 1250 1250 1500중복제거
from employee
where job = 'SALESMAN'; --->결과 : 1250 1600 1500

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < any(select distinct salary
				 from employee
				 where job = 'SALESMAN');
-- salary < ANY(1250 1600 1500)의 서브쿼리 결과 중 '최대값'보다 작으면 참

--위 결과를 검증
--[1]. 직급이 SALESMAN의 급여 구하기=>'직급이 SALESMAN의 최대급여 구하기'
select MAX(salary)
from employee
where job = 'SALESMAN';--1600

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < (select MAX(salary)
				from employee
				where job = 'SALESMAN');
----------------------------------------------------------------------------

--3) ALL 연산자 : 서브 쿼리에서 반환되는 모든 값과 비교
--정리 : A조건 and B조건
--교집합 : 모든 조건을 동시에 만족하는 것
				
--정리 : WHERE 컬럼명 < any(1300, 800, 950) => 서브결과들 중 "최대값(1300)"보다 작으면 TRUE.
--		WHERE 컬럼명 > any(1300, 800, 950) => 서브결과들 중 "최소값(800)"보다 크면 TRUE.
		
--정리 : WHERE 컬럼명 < ALL(1300, 800, 950) => 서브결과들 중 "최소값(800)"보다 작으면 TRUE.
--		WHERE 컬럼명 > ALL(1300, 800, 950) => 서브결과들 중 "최대값(1300)"보다 크면 TRUE.		
				

--[문제] 직급이 SALESMAN이 아니면서
--급여가 모든 SALESMAN보다 낮은 사원의 정보(사원이름, 직급, 급여) 출력
--[1]. 직급이 SALESMAN의 급여 구하기
select DISTINCT salary	--결과 :  1600 1250 1250 1500중복제거
from employee
where job = 'SALESMAN'; --->결과 : 1250 1600 1500

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < ALL(select distinct salary
				 from employee
				 where job = 'SALESMAN');
-- salary < ALL(1250 1600 1500)의 서브쿼리 결과 중 '최소값(1250)'보다 작으면 참

--위 결과를 검증
select min(salary)
from employee
where job = 'SALESMAN';

select ename, job, salary
from employee
where job != 'SALESMAN' AND salary < (select min(salary)
									from employee
									where job = 'SALESMAN');

---------------------------------------------------------------------------
--4) EXISTS 연산자 : EXISTS=존재하다.
select
from
where EXISTS (서브쿼리);
--서브쿼리에서 구해진 데이터가 1개라도 존재하면 true -> 메인쿼리 실행
--					  1개라도 존재하지 않으면 false -> 메인쿼리 실행X			

select
from
where NOT EXISTS (서브쿼리);
--서브쿼리에서 구해진 데이터가 1개라도 존재하지 않으면 true -> 메인쿼리 실행
--					  1개라도 존재하면 false -> 메인쿼리 실행X			

--[문제-1] 사원테이블에서 직업이 'PRESIDENT'가 있으면 모든 사원이름을 출력, 없으면 출력안함
--★ 문제의 뜻 : 조건을 만족하는 사원이 있으면 메인쿼리를 실행하여 결과를 출력

--[1] 사원테이블에서 직업이 'PRESIDENT'인 사원의 사원번호 조회
select eno
from employee
where job = 'PRESIDENT';

--[2]
select ename
from employee
where EXISTS (select eno --7839
			from employee
			where job = 'PRESIDENT');

--위 문제를 테스트하기 위해 직업이 'PRESIDENT'인 사원 삭제 후 다시 [2]실행 => 결과 없음(오류아님)
delete
from employee
where job = 'PRESIDENT';

--다시 되돌리기 위해 직업이 'PRESIDENT'인 사원 추가하기
INSERT INTO EMPLOYEE
VALUES(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);

--[위 문제에 "job이 'SALESMAN'이면서" 라는 검색조건을 추가]
--조건을 AND 연결 : 두 조건이 모두 참이면 참
SELECT ENAME
from employee
where job='SALESMAN' AND EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--결과 : 4명 AND 14명 => 동시에 만족 4명 

--[위 문제에 "job이 'SALESMAN'이거나" 라는 검색조건을 추가]
--조건을 OR 연결 : 두 조건 중 하나만 참이면 참
SELECT ENAME
from employee
where job='SALESMAN' OR EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--결과 : 4명 OR 14명 => 14명

--[NOT EXISTS] 
--조건을 AND 연결 : 두 조건이 모두 참이면 참
SELECT ENAME
from employee
where job='SALESMAN' AND NOT EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--결과 : 4명 AND 0명 => 동시에 만족 0명 
								
--조건을 OR 연결 : 두 조건 중 하나만 참이면 참
SELECT ENAME
from employee
where job='SALESMAN' OR NOT EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--결과 : 4명 OR 0명 => 4명								

--[과제-1] : 사원테이블과 부서테이블에서 동시에 없는(참조되지 않은) 부서번호, 부서이름 조회
--(employee의 dno가 department의 dno를 references를 아는 전제 하에서
--즉, 'employee의 dno가 참조하는 dno는 반드시 department의 dno로 존재한다'는
--사실을 아는 전제 하에서 문제 해결함)
--[방법-1] IN 연산자 사용
select dno, dname
from department
where dno NOT IN(select distinct dno --10 20 30
				from employee);
				
------------------------------------------------------------------		
--[방법-2] join방법-1 이용
--[1] 각 테이블에 존재하는 부서 번호 확인
select distinct dno
from employee; -- 10 20 30

select distinct dno, dname
from department; -- 10 20 30 40

--[2] e.dno와 d.dno는 같다.
select distinct e.dno, dname--10 20 30(동시에)
from employee e, department d
where e.dno = d.dno;

--[3] ★e.dno와 d.dno는 다르다.
select *--테이블의 모든 내용을 본 후 검색조건을 생각하기
from employee e, department d
where e.dno(+) = d.dno;

select distinct d.dno, dname--10 20 30(동시에) + 부서테이블의 40 까지 표시
from employee e, department d
where e.dno(+) = d.dno;

--[4] ★e.dno와 d.dno는 다르다.
select distinct d.dno as ddno, dname 
from employee e, department d
where e.dno(+)=d.dno	--조인조건
AND e.dno IS NULL;		--검색조건-방법-1
--AND eno is null;		--검색조건-방법-2 등등
--outer join시 나오는 null을 사용하여 employee 테이블에 존재하지 않는 부서번호 출력

--[방법-3] join방법-1 이용
select distinct d.dno, dname 
from employee e, department d
where e.dno(+)=d.dno	--조인조건
--(10 20 30 40) NOT IN (10 20 30)  => 40만 TRUE
AND d.dno NOT IN(select distinct dno
				from employee);
--검색조건(부서테이블의 부서번호가 사원테이블의 부서번호 중 속하지 않은 것이 TRUE)

--[방법-4] join방법-1 이용
select distinct d.dno, dname 
from employee e, department d
where e.dno(+)=d.dno	--조인조건
--(10 20 30 40) != ALL(10 20 30)  => 40만 TRUE
AND d.dno != ALL(select distinct dno
				from employee);
--검색조건(부서테이블의 부서번호가 사원테이블의 부서번호 중 속하지 않은 것이 TRUE)

--[방법-4] join방법-2 이용
select distinct d.dno, dname 
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno	--조인조건
WHERE e.dno IS NULL;

--< 참조 : 오라클 실행 순서 >
--from -> where -> group by -> having -> select 컬럼명의 별칭 -> order by
--[방법-5] EXISTS 이용
select dno, dname
from department d
where NOT EXISTS (select dno	-- 40=>true
				 from employee--별칭 사용안해도 됨
				 where d.dno = dno);

--[방법-6] : MINUS 이용 {10, 20, 30, 40} - {10, 20, 30} = {40}
SELECT dno, dname
from department

MINUS

select dno, dname
from employee JOIN department
USING(dno);


-------------------------------------------------------------------

select d.dno, dname
from employee e, department d
where e.dno(+) = d.dno
AND e.dno IS NULL;

select d.dno, dname
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno
where e.dno IS NULL;


--<7장.서브쿼리-혼자해보기>----------------------------------
--1.사원번호가 7788인 사원과 '담당업무가 같은' 사원을 표시(사원이름과 담당업무)
--[1]. 사원번호가 7788인 사원의 '담당업무' 조회
select job --결과 1개(ANALYST)
from employee
where eno = 7788;

--[2-1]
select ename, job
from employee
where job = (select job -- = : 서브쿼리결과 1개(ANALYST)
			from employee
			where eno = 7788);

--[2-2]
select ename, job
from employee
where job IN (select job -- IN : 서브쿼리결과 1개 이상일 때
			from employee
			where eno = 7788);

--[2-3]
select ename, job
from employee
where job = ANY (select job -- ANY : 서브쿼리결과 1개 이상일 때
			from employee
			where eno = 7788);

--[2-4]
select ename, job
from employee
where job = ALL (select job -- ALL : 서브쿼리결과 1개 이상일 때
			from employee
			where eno = 7788);

--2.사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당업무)
--[1]. 사원번호가 7499인 사원의 급여 조회
select salary --1600
from employee
where eno = 7499;
			
--[2]
select ename, job
from employee
where salary > (select salary --1600
				from employee
				where eno = 7499);

--3.최소급여를 받는 사원의 이름, 담당 업무 및 급여 표시(그룹함수 사용)
--[1]. 사원테이블에서 최소급여를 조회
select min(salary) --800(결과 1개)
from employee;

--[2] 
select ename, job, salary
from employee
where salary = (select min(salary) --800(결과 1개) =대신 IN, =ANY, =ALL 사용가능
				from employee);

--4.'직급별' 평균 급여가 가장 적은 담당 업무를 찾아 '직급(job)'과 '평균 급여' 표시
--단, 평균의 최소급여는 반올림하여 소수1째자리까지 표시

--[방법-1]
--[1]. '직급별' 평균 급여 중 가장 적은 평균급여를 구한다.
--먼저, 사원전체의 평균 급여 구하기
select avg(salary), 
round(avg(salary), 1) -- 소수 2째자리에서 반올림하여 소수1째자리까지 표시
from employee;
				
--사원전체의 평균 급여의 최소값 구하면
select MIN(avg(salary))
from employee;--오류?ORA-00978: nested group function without GROUP BY

select job, avg(salary) --job : avg(salary) = 5 : 5 매치
from employee
group by job;--1037.5

select job, MIN(avg(salary)) --오류?job : MIN(avg(salary)) = 5 : 1 매치안됨
from employee
group by job;--1037.5

--[위 오류를 해결하기 위해서 job을 조회에서 제거]
--★★ 그룹함수는 2개까지만 중첩허용
--그룹함수 : MIN(), avg()
--※ ROUND는 그룹함수가 아니다.
select ROUND(MIN(avg(salary)), 1) --1073.5
from employee
group by job;

--[2]. 최종-1 : 평균급여가 1037.5와 같은 job이 여러 개 있다면 여러 개 출력됨
select job, avg(salary), round(avg(salary), 1) as "평균급여"
from employee
group by job
having round(avg(salary), 1) = (select round(min(avg(salary)), 1)
								 from employee
								 group by job);


 --[2]. 최종-1 : HAVING절에 별칭사용하면 오류
select job, avg(salary), round(avg(salary), 1) as "평균급여"
from employee
group by job
having "평균급여" = (select round(min(avg(salary)), 1) --1037.5
				 from employee
				 group by job);
--오류? ORA-00904: "평균급여": invalid identifier
/*
 * < 참조 : 오라클 실행 순서 >
 * from -> where -> group by -> having -> select 컬럼명의 별칭 -> order by
 */

--[방법-2] : 단, 직업별 평균급여가 다를 때만 가능
--[1]
select job, avg(salary) as "평균급여"--5:5
from employee
group by job
order by "평균급여" asc; --정렬 : 가장 적은 평균급여가 1번째 줄에 나오도록 정렬

--[2]. 최종-2 : 평균급여가 1037.5와 같은 job이 여러 개 있어도 1개만 출력됨
select *
from (select job, avg(salary) as "평균급여"--5:5
		from employee
		group by job
		order by "평균급여" asc)
where rownum = 1; --조건 : 1번째 줄만 표시


--5.각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서 번호 표시
--[방법-1]
--[1]. 부서별 최소 급여 구하기
select dno, min(salary)--(10, ),(20, ),(30, ) 여러개 결과
from employee
group by dno;

--[2]
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, min(salary)--(10, ),(20, ),(30, ) 여러개 결과
						from employee
						group by dno);

--[방법-2]
--[1]. 부서별 '최소 급여'만 구하기
select min(salary)	--(950),(800),(1300) 여러개 결과
from employee
group by dno;

--[2]
select ename, salary, dno
from employee
where salary IN (select min(salary)	--(950),(800),(1300) 여러개 결과
						from employee
						group by dno);

--[개인풀이]
select ename, salary, e1.dno
from employee e1, (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno
AND salary = "minSalary";


--6.'담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 업무가 분석가가 아닌' 
--사원들을 표시(사원번호, 이름, 담당 업구, 급여)
--[1]. '담당 업무가 분석가(ANALYST)인 사원의 급여 구하기
select salary
from employee
where job = 'ANALYST';

--[2]
select eno, ename, job, salary
from employee
where salary < ALL(select salary
					from employee
					where job = 'ANALYST')-- salary < ALL(3000, 3000)
AND job != 'ANALYST';
--AND job <> 'ANALYST';
--AND job ^= 'ANALYST';

--AND job NOT LIKE 'ANALYST';


--★★7.부하직원이 없는 사원이름 표시(먼저 '문제 8. 부하직원이 있는 사원이름 표시'부터 풀기)
select * from employee;

--[방법-1] : 서브쿼리
--[방법-1-1] : IN 연산자
--[방법-1-1-1]
--[1]. 부하직원이 있는 사원번호 찾기
select manager--(중복)
from employee
where manager IS NOT NULL;

select distinct manager --13명(중복)->(중복제거)6명이 1명 이상의 부하직원을 가짐
from employee
where manager IS NOT NULL;

--[2]. 부하직원이 없는 사원 : 8명
select eno, ename
from employee
where eno NOT IN (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno NOT IN (7839, 7782, 7698, 7902, 7566, 7788);

--[방법-1-1-2]
--[1]. 부하직원이 있는 사원번호 찾기 : where절 대신 NVL()함수로 NULL을 0으로 처리
select distinct manager
from employee;

select distinct NVL(manager, 0)
from employee;

--상관사원번호(manager 컬럼)에 자신의 사원번호(eno)가 없으면 부하직원이 없는 사원이 됨.
--※ 서브쿼리의 결과 중 null이 있으면 결과가 안나옴
select ename
from employee
where eno NOT IN (select distinct manager
			 from employee);
			 
-->★위 문제를 해결하기 위해 : 따라서, NVL()함수로 null값을 처리
select ename
from employee
where eno NOT IN (select distinct NVL(manager, 0)
			 from employee);

select ename
from employee
where eno NOT IN (7839, 7782, 7698, 7902, 7566, 7788, 0);	

--[방법-1-2(잘못된 방법)] : !=ANY 연산자 (결과가 '14명 모두' 나옴)
--ANY 조건 : 만족하는 값 하나만 있으면 참 (※ ALL 조건 : 모든 값을 만족해야 참)
-- eno {1,2,3,4,5}라면
--(1)eno = ANY (1,2,3) : eno에 ANY값과 같은 값이 하나라도 있으면 true 
--   => 조회결과 : {eno 중 ANY값 1과 같은 것} U {eno 중 ANY값 2와 같은 것} U {eno 중 ANY값 3과 같은 것}
--              = {1} U {2} U {3}
--              = 즉, eno {1,2,3} 조회

--(2)eno > ANY (1,2,3) : eno에 ANY값보다 큰 값이 하나라도 있으면 true
--   => 조회결과 : {eno 중 ANY값 1보다 큰 것} U {eno 중 ANY값 2보다 큰 것} U {eno 중 ANY값 3보다 큰 것}
--             = {2,3,4,5} U {3,4,5} U {4,5}              
--               즉, eno {2,3,4,5}조회 =  eno에서 "최소값1"보다 큰 eno 조회

--(3)eno < ANY (1,2,3) : eno에 ANY값보다 작은 값이 하나라도 있으면 true
--   => 조회결과 : {eno 중 ANY값 1보다 작은 것} U {eno 중 ANY값 2보다 작은 것} U {eno 중 ANY값 3보다 작은 것}
--             = 공집합 U {1} U {1,2}              
--               즉, eno {1,2}조회 = eno에서 "최대값3"보다 작은 eno 조회

--(4)eno != ANY (1,2,3) : eno에 ANY값과 다른값이 하나라도 있으면 true
--   => 조회결과 : eno에서 1과 다른 eno 조회 {2,3,4,5} U
--               eno에서 2와 다른 eno 조회 {1,3,4,5} U
--               eno에서 3과 다른 eno 조회 {1,2,4,5} U
--               eno에서 4와 다른 eno 조회 {1,2,3,5} U
--               eno에서 5와 다른 eno 조회 {1,2,3,4} U
--      = {2,3,4,5} U {1,3,4,5} U {1,2,4,5} U {1,2,3,5} U {1,2,3,4} 
--      = {1,2,3,4,5} ANY의 값들 중 모두 일치하지 않는 데이터만 조회된다.
-- ※따라서, "컬럼명 != ANY (값)"에서는 ANY의 값이 2개 이상인 경우 해당 조건은 의미가 없고, 모든 데이터가 조회된다.
-- ※주의 사항 "컬럼명 !=ANY (값)" 는 
--  "서브쿼리결과값이 하나"일 때만 사용(이유?2개 이상일 때는 모든 데이터가 조회되므로...)
select ename
from employee
where eno != ANY (select distinct NVL(manager, 0)
			 from employee);
-- 7369 != 7839아닌 사원 ?
-- 전체 14명 중 != 7782아닌 사원 13명...
-- 전체 14명 중 != 0   아닌 사원 14명
-- 합집합 : 중복 제외하고 모두 나열하면 14명이 결과로 나옴
select ename
from employee
where eno != ANY (7839, 7782, 7698, 7902, 7566, 7788, 0);
			 
select ename --모든 사원이름 결과로 나옴
from employee
where eno != ANY (select distinct manager
			 from employee
			 where manager IS NOT null);			 

select ename
from employee
where eno != ANY (7839, 7782, 7698, 7902, 7566, 7788);

--[방법-2] : self join
--[방법-2-1] : , where
--[1]
select *
from employee e, employee m
where e.manager = m.eno;

select distinct m.eno, m.ename--부하직원이 있는 사원만 출력(중복제거)
from employee e, employee m
where e.manager = m.eno;

--[2]. {부하직원이 없는 사원} = {모든 사원} - {부하직원이 있는 사원}
select eno, ename --모든 사원
from employee

MINUS

select distinct m.eno, m.ename--부하직원이 있는 사원(중복제거)
from employee e, employee m
where e.manager = m.eno

order by 1 asc;

--[방법-2-2] : JOIN ~ ON
--[1]
select *
from employee e JOIN employee m
ON e.manager = m.eno;

select distinct m.eno, m.ename--부하직원이 있는 사원만 출력(중복제거)
from employee e JOIN employee m
ON e.manager = m.eno;

--[2]. {부하직원이 없는 사원} = {모든 사원} - {부하직원이 있는 사원}
select eno, ename --모든 사원
from employee

MINUS

select distinct m.eno, m.ename--부하직원이 있는 사원(중복제거)
from employee e JOIN employee m
ON e.manager = m.eno

order by 1 asc;


--★★8.부하직원이 있는 사원이름 표시
select * from employee;

--[방법-1] : 서브쿼리
--[방법-1-1] : IN 연산자
--[1]. 부하직원이 있는 사원번호 찾기
select manager--13명(중복)
from employee
where manager IS NOT NULL;

select distinct manager --13명(중복)->(중복제거)6명이 1명 이상의 부하직원을 가짐
from employee
where manager IS NOT NULL;

--[2]. 부하직원이 있는 사원 : 6명
select ename
from employee
where eno IN (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno IN (7839,7782,7698,7902,7566,7788);

--[방법-1-2] : =ANY 연산자(eno=7839 합집합 eno=7782 합집합...)
--합집합 : 각 조건을 만족하는 결과를 다 합침(중복 제외)
--[1]. 부하직원이 있는 사원번호 찾기
select manager--13명(중복)
from employee
where manager IS NOT NULL;

select distinct manager --13명(중복)->(중복제거)6명이 1명 이상의 부하직원을 가짐
from employee
where manager IS NOT NULL;

--[2]. 부하직원이 있는 사원 : 6명
select ename
from employee
where eno = ANY (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno = ANY (7839,7782,7698,7902,7566,7788);
			 
--[방법-2] : self join
--[방법-2-1] : , where
--[1]
select *
from employee e, employee m
where e.manager = m.eno;

--[2]
select distinct m.eno, m.ename--부하직원이 있는 사원만 출력(중복제거)
from employee e, employee m
where e.manager = m.eno
order by 1 asc;


--[방법-2-2] : JOIN ~ ON
--[1]
select *
from employee e JOIN employee m
ON e.manager = m.eno;

select distinct m.eno, m.ename--부하직원이 있는 사원만 출력(중복제거)
from employee e JOIN employee m
ON e.manager = m.eno;


--9.BLAKE와 동일한 부서에 속한 사원이름과 입사일을 표시(단,BLAKE는 제외)
--[1]. BLAKE의 부서번호 구하기
select dno--30
from employee
where ename = 'BLAKE';

--[2]
select ename, hiredate
from employee
where dno = (select dno
			from employee
			where ename = 'BLAKE')
AND ename <> 'BLAKE'; --반드시 'BLAKE는 제외' 조건 추가

--10.급여가 평균 급여보다 많은 사원들의 사원번호와 이름 표시(결과는 급여에 대해 오름차순 정렬)
--[1]. 사원테이블에서 평균 급여 구하기
select avg(salary)
from employee; --2073.2142....

--[2]. 
select eno, ename
from employee
where salary > (select avg(salary)
				from employee)
order by salary; --order by절에 asc 생략가능

--11.이름에 K가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 이름 표시
--[1] 이름에 K가 포함된 사원의 부서번호 구하기
select dno
from employee
where ename like '%K%';

--[2]
select eno, ename
from employee
where dno IN(select distinct dno
			from employee
			where ename like '%K%');

			
--12.부서위치가 DALLAS인 사원이름과 부서번호 및 담당 업무 표시
--[1]. 부서위치가 DALLAS 부서번호 구하기
select dno
from department
where loc = 'DALLAS';

--[2]		
select ename, dno, job
from employee
where dno IN (select dno
			from department
			where loc = 'DALLAS');
		
			
--[과제-1]
--[12번 변경문제]. 부서위치가 DALLAS인 사원이름, 부서번호, 담당 업무, + '부서위치' 표시
--'사원이름, 부서번호, 담당 업무' : 사원테이블 / '부서번호, '부서위치' : 부서테이블
-- 두 테이블에 '부서번호'가 있음 -> 같은 부서번호로 조인
--[조인방법-1] , WHERE (단점:검색조건 추가시 괄호 넣기, 장점:(+)로 외부조인 간단하게 만들 수 있다. 왼쪽과 오른쪽만 가능)
--별칭생략안함
select e.ename, e.dno, e.job, d.loc
from employee e, department d
where e.dno = d.dno 	--조인조건
AND d.loc = 'DALLAS'; 	--검색조건

--별칭생략
select ename, e.dno, job, loc
from employee e, department d
where e.dno = d.dno --조인조건
AND loc = 'DALLAS'; --검색조건			

--[조인방법-2] JOIN ~ ON (단점:외부조인 만들기가 방법-1보다 복잡, 장점:검색조건 추가가 편리하고 왼쪽(left)/오른쪽(right)/완전(full)외부조인(outer join) 가능)
select ename, e.dno, job, loc
from employee e JOIN department d
ON e.dno = d.dno 	  --조인조건
WHERE loc = 'DALLAS'; --검색조건		
			
--[조인조건1과 2 공통점] : 중복제거 안함. 컬럼명이 달라도 조인가능(이때,타입은 같아야 함)
--[조인조건3과 4 공통점] : 중복제거 함. 	 컬럼명이 다르면 조인불가능

--[조인조건-3] NATURAL JOIN : 자연스럽게 '동일한 타입과 이름을 가진 컬럼'으로 조인 후 중복 제거
select ename, dno, job, loc
from employee NATURAL JOIN department
--조인조건 필요없음(자연조인 문제점:조인하는 컬럼의 '의미가 다를 때' 문제 발생)
WHERE loc = 'DALLAS'; --검색조건

--[조인조건-4] JOIN ~ USING(컬럼명) : '동일한 타입과 지정한 이름을 가진 컬럼'으로 조인 후 중복 제거
select ename, dno, job, loc
from employee JOIN department
USING(dno) 	  		  --조인조건
WHERE loc = 'DALLAS'; --검색조건	

--[조인조건-3] NATURAL JOIN은 '동일한 타입과 이름을 가진 컬럼'이 1개일 때 사용
--[조인조건-4] JOIN ~ USING(컬럼명1,컬럼명2)은 '동일한 타입과 이름을 가진 컬럼'이 2개 이상일 때 사용

/*
select ename, e1.dno, job, "부서위치"
from employee e1 JOIN (select dno, loc as "부서위치"
						from department
						where loc = 'DALLAS') e2 
ON e1.dno = e2.dno;
*/		
			

--13.KING에게 보고하는 사원이름과 급여 표시(=> KING이 상사인 사원이름과 급여 표시)
--[1] 사원이름이 'KING'인 사원번호 구하기
select eno
from employee
where ename = 'KING';

--[2] KING에게 보고하는 '부하직원' 이름과 급여 표시
select ename, salary
from employee
where manager IN (select eno --상사
				from employee
				where ename = 'KING');

				
--14.RESEARCH 부서의 사원에 대한 부서번호, 사원이름, 담당 업무 표시
--사원테이블 : 부서번호, 사원이름, 담당 업무		/ 부서테이블:부서번호, 부서이름(RESEARCH)
--[1]. RESEARCH 부서번호 구하기
select dno	--20
from department
where dname = 'RESEARCH';

--[2] 그 부서에 근무하는 사원 정보 구하기
select dno, ename, job
from employee
where dno IN (select dno
			from department
			where dname = 'RESEARCH');
				
			
--15.평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무하는 
--사원번호,이름,급여 표시
--[문제 해석-1]평균 급여보다 많은 급여를 받고(조건-1) / 이름에 M이 포함된 사원과 같은 부서에서 근무(조건-2)
--[방법-1]
--[1]. 평균 급여 구하기(조건-1)
select avg(salary) --2073.2142...
from employee;

--[2]. 이름에 M이 포함된 사원과 같은 부서번호 구하기
select distinct dno 	--10, 20, 30
from employee
where ename like '%M%';

--[3]. 
select eno, ename, salary, dno
from employee
where salary > (select avg(salary) --2073.2142...
				from employee)
AND dno IN (select distinct dno
			from employee
			where ename like '%M%');	

--[4] ★주의 : 이름에 M이 포함된 사원은 제외
select eno, ename, salary, dno
from employee
where salary > (select avg(salary) --2073.2142...
				from employee)
AND dno IN (select distinct dno
			from employee
			where ename like '%M%')
AND ename NOT LIKE '%M%';
--[3]과 [4]는 결과가 같다.
--이유? '평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원'이 존재하지 않으므로


--[문제 해석-2]평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무(조건-1)

--★★ [※현재 사원테이블에는 '평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원'이 존재하지 않으므로
------ 데이터를 수정한 후 테스트해보겠다.]
--[수정] : 부서번호가 20이고 이름에 M이 포함된 사원의 급여를 3000으로 수정
update employee
set salary=3000
where dno = 20 AND ename like '%M%';

--수정되었는지
select ename, dno, salary --SMITH, ADAMS
from employee
where dno = 20 AND ename like '%M%';

--[방법-2]
--[1]. 평균 급여 구하기
select round(AVG(salary)) --2366
from employee;

--[2]. 구한 평균급여보다 많은 급여를 받고 이름에 M이 포함된 사원의 부서번호 구하기 --결과로 20
select dno
from employee
where ename like '%M%'
AND salary > (select round(AVG(salary),0) --2366
				from employee);


--[3]. 구한 부서번호(20)와 같은 부서에서 근무하는 사원의 사원번호, 이름, 급여 표시
select eno, ename, salary
from employee
where dno IN (select dno
			from employee
			where ename like '%M%'
			AND salary > (select round(AVG(salary),0) --2366
						 from employee))
AND ename NOT like '%M%'; --★이름에 M이 포함된 사원은 제외

--[수정된 데이터 다시 원상 복구시킴]
update employee
set salary=800
where ename='SMITH';

update employee
set salary=1100
where ename='ADAMS';


--16.평균 급여가 가장 적은 업무와 그 평균급여 표시
--[방법-1]
--[1] 업무별 평균 급여 중 가장 적은 급여 구하기
--※ 그룹함수 최대 2번까지 중첩
select min(AVG(salary)) --1037.5
from employee
group by job;

--[2]
select job, AVG(salary)
from employee
group by job;

--[3]
select job, AVG(salary)
from employee
group by job
--그룹함수에 조건
having AVG(salary) = (최소평균급여);

--[4] 결과 : CLERK 1037.5
select job, avg(salary)
from employee
group by job
--그룹함수에 조건
having avg(salary) = (select min(avg(salary)) --1037.5
					  from employee
					  group by job);

--[방법-2]
--[1]. 업무별 평균 급여를 구해 평균 급여로 오름차순 정렬
select job, avg(salary)
from employee
group by job
ORDER BY AVG(salary) ASC;

--[2]. 위에서 구한 테이블로부터 ROWNUM=1인 것이 바로 가장 적은 평균급여가 됨
select *
from (select job, avg(salary)
	 from employee
	 group by job
	 ORDER BY AVG(salary) ASC)
where rownum = 1; --첫번째 행만
					  
--17.담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원이름 표시
--[1] 담당 업무가 MANAGER인 사원이 소속된 부서번호 구하기
select dno
from employee
where job = 'MANAGER';

--[2] 
select ename
from employee
where dno IN (select dno
			from employee
			where job = 'MANAGER');

--[3]. 문제 해석에 따라 '담당 업무가 MANAGER인 사원'을 제외시킬 수 있다.
select ename
from employee
where dno IN (select dno
			from employee
			where job = 'MANAGER')
AND job != 'MANAGER';

