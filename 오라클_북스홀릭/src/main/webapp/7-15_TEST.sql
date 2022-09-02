--[문제] 3개의 테이블 조인하기
--'사원이름, 소속된 부서번호, 소속된 부서명, 급여, 급여등급' 조회
-- 4가지 join 방법 활용
--[join 방법-1] 사원테이블과 부서테이블
select ename, e.dno, dname, salary
from employee e, DEPARTMENT d
where e.dno = d.dno;

--[join 방법-2] 사원테이블과 부서테이블
select ename, e.dno, dname, salary	--e.dno 구분하기 위해 생략 불가
from employee e JOIN DEPARTMENT d
ON e.dno = d.dno;

--[join 방법-3] natural join (자연스럽게 동일조인, 중복된 컬럼 제거->별칭 필요없음)
select ename, dno, dname, salary
from employee NATURAL JOIN DEPARTMENT;
--ON e.dno = d.dno;

--[join 방법-4] (중복된 컬럼 제거->별칭 필요없음)
select ename, dno, dname, salary
from employee JOIN department
USING(dno);

--[최종] "조인한 결과 테이블"과 "급여정보 테이블" => salary로 비등가조인
select ename, dno, edname, salary, grade
from SALGRADE JOIN (select ename, e.dno, dname, salary--e.dno:구분하기 위해 생략불가
					from EMPLOYEE e JOIN DEPARTMENT d
					ON e.dno = d.dno 
					)
ON salary BETWEEN losal AND hisal;--비등가조인

--별칭들(ed. s.) 생략 가능함
select ename, dno, edname, salary, s.grade
from SALGRADE JOIN (select ename, dno, dname, salary
					  from EMPLOYEE JOIN DEPARTMENT
					  USING(dno)
					  )
ON losal <= salary AND salary <= hisal;--비등가조인


--[문제-2] 사원이름(ename)과 직속상관이름(ename) 조회하기 => 셀프조인
--(출력예) A의 직속상관은 B
select e.ename || '의 직속상관은 ' || m.ename
from employee e JOIN employee m--반드시 별칭 사용
ON e.manager=m.eno--'KING'은 직속상관이 NULL이므로 등가조인에서 제외됨
order by 1;




/*
--[최종] "조인한 결과 테이블"과 "급여정보 테이블" join 하기
select ename, dno, dname, salary, grade
from SALGRADE JOIN (select ename, dno, dname, salary
					from employee JOIN department
					USING(dno))
ON salary between losal AND hisal;

--[문제-2] 사원이름과 직속상관이름 조회하기
--(출력에) A의 직속상관은 B
select e.ename || '의 직속상관은 ' || m.ename
from employee e, employee m
where e.manager = m.eno;
*/
