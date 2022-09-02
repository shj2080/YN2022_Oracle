--<북스-6장.테이블 조인하기>
--1. 조인
--1.1 카디시안 곱(=곱집합) : (구방식 ,) (현방식 cross join) - 조인조건이 없다.
select * from EMPLOYEE; 	--컬럼(속성)수 : 8, 행수:14
select * from department;   --컬럼수:3, 행수:4

select *	--컬럼수:11, 행수:56
from employee, department;
--조인결과 : 컬럼수(11) = 사원테이블의 컬럼수(8) + 부서테이블의 컬럼수(3)
--	  행(=ROW)수(56) = 사원테이블의 행수(14) * 부서테이블의 행수(4)
--		   	       = 사원테이블의 사원 1명 당 * 부서테이블의 행수(4)

select eno	-- eno 컬럼만, 56개 전체 행수
from employee, department;

select eno	-- eno 컬럼만, 56개 전체 행수
from employee CROSS JOIN department;

select *	--컬럼수:11, eno가 7369인 것만
from employee, department
where eno = 7369;--(조인조건아님)검색조건

--1.2 조인의 유형
--오라클 8i이전 조인 : EQUI 조인(=등가 조인), non-EQUI 조인(=비등가 조인), outer 조인(왼쪽, 오른쪽), self 조인
--오라클 9i이후 조인 : cross 조인, natural 조인(=자연 조인), join~using, outer 조인(왼쪽, 오른쪽, full까지)
--(※오라클 9i부터 ANSI 표준 SQL 조인 : 현재 대부분의 상용 데이터베이스 시스템에서 사용.
--								다른 DBMS와 호환이 가능하기 때문에 ANSI 표준 조인에 대해서 확실히 학습하자.)

--------<아래 4가지 비교 : 내부조인(=inner join)>------------------------------------------------------------------
--[해결할 문제] '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 소속부서번호, 소속부서이름' 얻기
-- 먼저, '사원번호, 사원이름, 소속부서번호, 소속부서이름'의 컬럼들이 어느 테이블에 있는지 부터 파악하기
-- '사원번호, 사원이름, 소속부서번호(dno)' => 사원테이블에 있음
-- '소속부서번호(dno), 소속부서이름' => 부서테이블에 있음

-- '소속부서번호'가 양 테이블에 존재하므로 등가 조인이 가능함
--2. equi 조인(=등가 조인=동일조인) : 동일한 이름과 유형(=데이터 타입)을 가진 컬럼으로 조인
--  단, [방법-1] , ~ where 과 [방법-2] JOIN ~ ON은 '데이터 타입만 같아도 조인'이 됨

--[방법-1] , ~ where ------------------------------------------------------------------------------------------------------------------------------------
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임의의 조건을 지정"하거나 "조인한 컬럼을 지정"할 때 where절을 사용
--조인결과는 중복된 컬럼 제거X -> 따라서, 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야 함
select 컬럼명1, 컬럼명2...--중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno	d.dno
from 테이블1 별칭1, 테이블2 별칭2, ... --별칭사용(별칭 : 해당 SQL명령문내에서만 유효)
where ★조인조건	(※주의 : 테이블의 별칭 사용);
AND	  ★(검색조건)	(※주의 : 습관적으로 () 사용하기)
--★문제점 : 원하지 않는 결과가 나올 수 있다.(이유? AND -> OR의 우선순위 때문에)
--★문제점 해결법 : AND	  ★검색조건에서 '괄호()를 이용하여 우선순위 변경'
--예)부서번호로 조인한 후 부서번호가 10이거나 30인 정보 조회
--where e.dno = d.dno AND d.dno = 10 OR d.dno = 30; --문제 발생(원하지 않는 결과 나옴)
--where e.dno = d.dno AND (d.dno = 10 OR d.dno = 30);--★해결법 : '괄호()를 이용하여 우선순위 변경'

--★★★ [장점] 이 방법은 outer join(=외부조인) 하기가 편리하다.
--(단, 한 쪽에만 (+)사용가능  -> 즉, 왼쪽과 오른쪽 외부조인만 가능.
--		양쪽에 (+)사용불가  -> 즉, full 외부조인은 불가 )
--[1]
select *
from employee, department
order by eno;
--[2]별칭 사용 안한 경우
select *
from employee, department
where employee.dno = department.dno;
--[2]별칭 사용한 경우
select *
from employee e, department d
where e.dno = d.dno;
--두 테이블에서 같은 dno끼리 조인(그 결과 부서테이블의 40은 표시안됨.)

-- 40부서의 정보를 함께 표시하기 위해서는 (+)붙여서 outer join(=외부조인)함.
--[3]
select *
from employee e, department d
where e.dno(+) = d.dno;
--외부조인하기 편리하나 full outer join 안됨
--full outer join은 join~on으로 해결가능함

--[3] 아래 결과는 같다. 그 이유? DEPARTMENT 테이블에만 표시될 내용이 더 있으므로...
select *
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno;

select *
from employee e FULL OUTER JOIN department d
ON e.dno = d.dno;

--[해결할 문제] '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 소속부서번호, 소속부서이름' 얻기
--[문제해결법]
--select e.eno, e.ename, e.dno, d.dname	-- ok
select eno, ename, e.dno, dname--e.dno에는 반드시 별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
from employee e, department d
where e.dno = d.dno
AND eno = 7788;

--[방법-2] (INNER)JOIN ~ ON ------------------------------------------------------------------------------------------------------------------------------------
--동일한 이름과 데이터 유형을 가진 컬럼으로 조인 + "임의의 조건을 지정"하거나 "조인한 컬럼을 지정"할 때 ON절을 사용
--조인결과는 중복된 컬럼 제거X -> 따라서, 테이블에 '별칭 사용'해서 어느 테이블의 컬럼인지 구분해야 함
select 컬럼명1, 컬럼명2...--중복되는 컬럼은 반드시 '별칭.컬럼명'(예)e.dno	d.dno
from 테이블1 별칭1 (INNER)JOIN 테이블2 별칭2, ... --별칭사용(별칭 : 해당 SQL명령문내에서만 유효)
ON 		  ★조인조건	(※주의 : 테이블의 별칭 사용);
where	  ★(검색조건)

--[해결할 문제] '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 소속부서번호, 소속부서이름' 얻기
--[문제해결법]
--select e.eno, e.ename, e.dno, d.dname	-- ok
select eno, ename, e.dno, dname--e.dno에는 반드시 별칭사용 : 두 테이블에 모두 존재하므로 구분하기 위해
from employee e JOIN department d
ON e.dno = d.dno
where eno = 7788;

-------------------------------------[방법-1]과 [방법-2]는 문법적 특징이 동일하다.
-------------------------------------				의 조인 결과 : 중복된 컬럼 제거X -> 테이블의 별칭 필요
-------------------------------------			  ★ 컬럼명이 다르고 데이터 타입만 같아도 JOIN 가능 (예)a.id = b.id2

-------------------------------------[방법-3] : 컬럼명이 다르면 cross join 결과가 나옴
-------------------------------------[방법-4] : 컬럼명이 다르면 join 안됨 (=>오류 발생)


--[방법-3] NATURAL JOIN (=자연조인) ------------------------------------------------------------------------------------------------------------------------------------
--※ Oracle SQL에서만 지원
--조인결과, 중복된 컬럼 제거함

--'자연스럽게' 동일한 이름과 데이터 유형을 가진 컬럼으로 조인(★단, 1개만 있을 때 사용하는 것을 권장)
--동일한 이름과 데이터 유형을 가진 컬럼이 없으면 cross join 이 됨
--★★ 동일한 이름과 데이터 유형을 가진 컬럼으로 자연스럽게 조인되나 문제가 발생할 수 있다.
-----> 문제 발생하는 이유? (예)EMPLOYEE의 dno와 DEPARTMENT의 dno : 동일한 이름(dno)과 데이터 유형(number(2))
--														  ★ 두 테이블에서 dno는 '부서번호'로 의미도 같다.
--					 만약, EMPLOYEE의 manager_id(각 사원의 '상사'를 의미하는 번호)가 있고
--					    DEPARTMENT의 manager_id(각 사원의 '부장'를 의미하는 번호)가 있다고 가정했을 때
--						둘 다 동일한 이름과 데이터 유형을 가졌지만 manager_id의 의미가 다르다면 '자연조인한 후 원하지 않는 결과'가 나올 수 있다.

select 컬럼명1, 컬럼명2...
from 테이블1 별칭1 NATURAL JOIN 테이블2 별칭2, ... --별칭 사용안함(권장)
--★조인조건 필요없음
where	  ★(검색조건)

--[문제해결법-1]
--select eno, ename, dno, dname
select e.eno, e.ename, dno, d.dname		--dno는 중복 제거 했으므로 e.dno, d.dno 별칭사용 안함
from employee e natural JOIN department d 
--ON e.dno = d.dno
where eno = 7788;
--[문제해결법-2_간략]
select eno, ename, dno, dname
from employee natural JOIN department
where eno = 7788;

--[방법-4] JOIN ~ USING(★반드시 '동일한 데이터 유형을 가진 컬럼명'만 가능) ★다르면 오류발생------------------------------------------------------------------------------------------------------------------------------------
--※ Oracle SQL에서만 지원
--조인결과, 중복된 컬럼 제거함

--natural JOIN 은 같은 데이터 유형과 이름을 가진 컬럼을 모두 join 하지만
--USING 은 같은 데이터 유형과 이름을 가진 컬럼들 중에서도 특정컬럼만 따로 선택할 수 있다.

--조인결과는 중복된 컬럼 제거 -> 제거한 결과에 FULL outer join ~ USING(id)하면 하나의 id로 항목값들이 합쳐져서 표시됨
--동일한 이름과 유형을 가진 컬럼으로 조인(★조인 시 1개 이상 사용할 때 편리 : 가독성이 좋아서...)

select 컬럼명1, 컬럼명2...
from 테이블1 별칭1 NATURAL JOIN 테이블2 별칭2, ... --별칭 사용안함(권장)
USING(★조인조건) --USING(동일한 타입과 컬럼명1, 동일한 타입과 컬럼명2) 
where	  ★(검색조건)

--[문제해결법-1]
select e.eno, e.ename, dno, d.dname	--dno는 중복 제거 했으므로 e.dno, d.dno 별칭사용 안함
from employee e JOIN department d --별칭 만들어도 되나
USING (dno)
where eno = 7788;

--[문제해결법-2_간략]
select eno, ename, dno, dname
from employee JOIN department
USING (dno)
where eno = 7788;

--★★ 만약, manager가 department에 있다고 가정 후 아래 결과 유추
select eno, ename, dno, dname, e.manager, d.manager		--★반드시 '테이블명이나 별칭 사용'하여 구분해야 함
from employee e JOIN department d
USING (dno)--dno만 중복제거(★manager는 중복제거 안 함)
where eno = 7788;

--USING을 사용하면 여러개의 컬럼을 기술할 수 있다.
--※ 이 때 기술된 여러 컬럼의 값은 하나의 값으로 묶어서 판단해야 한다.
--[예] 실습을 위해 테이블 생성 후 데이터 추가
create table emp_test(
eno number primary key,
dno_id number,
loc_id char(2)
);

insert into emp_test values(1, 10, 'A1');
insert into emp_test values(2, 10, 'A2');
insert into emp_test values(3, 20, 'A1');

create table dept_test(
dno_id number primary key,
dname varchar2(20),
loc_id char(2)
);

insert into dept_test values(10, '회계', 'A1');
insert into dept_test values(20, '경영', 'A1');
insert into dept_test values(30, '영업', 'A2');

--USING 조인
select *
from emp_test JOIN dept_test
USING(dno_id, loc_id);
--'10A1', '20A1'은 조인결과에 포함되나 '10A2'나 '30A2'는 조인결과에 포함되지 않음
--이에 따라 두 테이블에 공통요소인 '10A1', '20A1'만 조인된 출력결과를 확인할 수 있다.

--※ 여러 테이블 간 조인할 경우 NATURAL JOIN과 JOIN~USING을 이용한 조인 모두 사용 가능하나
--가독성이 높은 JOIN~USING을 이용하는 방법을 권한다.
-------------------------[방법-3] : 컬럼명이 다르면 cross join 결과가 나옴
-------------------------[방법-4] : 컬럼명이 다르면 join 안됨(오류 발생)

-------------------<4가지 정리 끝>---------------------------------------------------------------------------


--3. non-equi 조인(=비등가조인) : 조인조건에서 '=(같다) 연산자 이외'의 연산자를 사용할 때
--							(예) !=	>	<	>=	<=	between~and

--[문제] 사원 별로 '사원이름, 급여, 급여등급' 출력
--[1]. '사원이름, 급여 => 사원테이블,		급여등급 => 급여정보 테이블'
--사원 테이블 출력
select * from EMPLOYEE;
--급여정보 테이블 출력
select * from SALGRADE;

--[2] 두 테이블에는 동일한 이름과 타입을 가진 컬럼이 존재하지 않는다.
--따라서, 비등가 조인함
--[join 방법-2 + between~and]
select ename, salary, grade
from EMPLOYEE JOIN SALGRADE -- 별칭 사용안함(이유? 중복되는 컬럼이 없으므로)
ON salary between losal and hisal; --조인조건(=>비등가 조인조건)

--[join 방법-1 + 비교연산자 이용(=제외)]
select ename, salary, grade
from EMPLOYEE , SALGRADE -- 별칭 사용안함(이유? 중복되는 컬럼이 없으므로)
where losal <= salary and salary <= hisal; --조인조건(=>비등가 조인조건)


--[문제] 사원 별로 '사원이름, 급여, 급여등급' 출력 + [조건추가] : 급여가 1000미만이거나 2000초과
--join 방법-2 => 정확한 결과 O
select ename, salary, grade
from employee JOIN salgrade	-- 별칭 사용안함(이유? 중복되는 컬럼이 없으므로)
on salary between losal and hisal --조인조건(=>비등가 조인조건)
where salary < 1000 or salary > 2000; --[검색조건] 추가

--join 방법-1 => 정확한 결과 X
-- 이유 : AND와 OR 함께 있으면 AND 실행 후 OR 실행
-- => 해결법 : ()괄호 이용하여 우선순위 변경
select ename, salary, grade
from employee, salgrade	-- 별칭 사용안함(이유? 중복되는 컬럼이 없으므로)
where salary between losal and hisal --조인조건(=>비등가 조인조건)
AND salary < 1000 or salary > 2000; --[검색조건] 추가

--위 문제 해결된 SQL문 : ()로 우선순위 변경
select ename, salary, grade
from employee, salgrade	-- 별칭 사용안함(이유? 중복되는 컬럼이 없으므로)
where salary between losal and hisal --조인조건(=>비등가 조인조건)
AND (salary < 1000 or salary > 2000); --[검색조건] 추가

--------------------------------------------------------------------------------------
--[문제] 3개의 테이블 조인하기
--'사원이름, 소속된 부서번호, 소속된 부서명, 급여, 급여등급' 조회
--[분류] 사원테이블 : 사원이름, 급여, 소속된 부서번호
--	    부서테이블 : 소속된 부서번호, 소속된 부서명
--	    급여정보테이블 : 급여등급
--[1] 사원테이블과 부서테이블은 동일한 이름과 타입을 가진 컬럼이 존재(소속된 부서번호 dno)
--		=> 따라서, 사원테이블과 부서테이블은 "등가조인"함
--[join 방법-1]
select ename, e.dno, dname, salary	--e.dno:구분하기 위해 생략불가
from EMPLOYEE e, DEPARTMENT d
where e.dno = d.dno;

--[join 방법-2]
select ename, e.dno, dname, salary	--e.dno:구분하기 위해 생략불가
from EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno;

--[join 방법-3] : natural join (자연스럽게 동일조인, 중복된 컬럼 제거 -> 별칭 필요없음)
select ename, dno, dname, salary
from EMPLOYEE natural JOIN DEPARTMENT;
--ON e.dno = d.dno;

--[join 방법-4] : join~using (중복된 컬럼 제거 -> 별칭 필요없음)
select ename, dno, dname, salary
from EMPLOYEE JOIN DEPARTMENT
USING(dno);

--[2] "등가조인한 결과 테이블"과 "급여정보 테이블"은 salary로 비등가조인 가능함
--e.dno 별칭 사용하면 오류(이유? "등가조인한 결과 테이블"에는 e라는 별칭 사용 안했으므로...)
select ename, dno, dname, salary, grade
from salgrade JOIN (select ename, e.dno, dname, salary
					from EMPLOYEE e JOIN DEPARTMENT d--e. 생략불가
					ON e.dno = d.dno)
ON salary BETWEEN losal AND hisal;	--비등가조인

--별칭들(ed. s.) 생략 가능함
select ed.ename, ed.dno, ed.dname, ed.salary, s.grade
from salgrade s JOIN (select ename, e.dno, dname, salary
					from EMPLOYEE e JOIN DEPARTMENT d--e.dno 생략불가
					ON e.dno = d.dno) ed
ON losal <= salary AND salary <= hisal;	--비등가조인
-------------------------------------------------------------------------------------------

--4. self join : 하나의 테이블에 있는 컬럼끼리 연결해야 하는 조인이 필요한 경우
select * from employee;

--[문제] 사원이름과 직속상관이름 조회
--[분류] 사원이름, 직속상관이름 => 사원테이블
select *
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno--'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
ORDER BY 1;

select e.ename as "사원이름", m.ename as "직속상관이름"
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno--'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
ORDER BY 1;

select e.ename || '의 직속상관은 ' || m.ename
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno--'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
ORDER BY 1;

--[문제+조건추가] : 'SCOTT'란 사원의 '매니저이름(=직속상관이름)'을 검색
-- [분석] 'SCOTT'(사원이름)	직속상관이름 => 사원테이블로 self join함
select e.ename as "사원이름", m.ename as "직속상관이름"
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno--'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
WHERE e.ename = 'SCOTT';

select e.ename || '의 직속상관은 ' || m.ename
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno--'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
WHERE lower(e.ename) = 'scott';
--WHERE e.ename = upper('scott');

-----------------------------------------------------------------------

--5. OUTER join (=외부 조인)
--equi join(=등가조인=동일조인)의 조인조건에서 기술한 컬럼에 대해 두 테이블 중
--어느 한 쪽 컬럼이라도 null이 저장되어 있으면 '='의 비교결과가 거짓이 됩니다.
--그래서 null값을 가진 행은 조인 결과로 얻어지지 않음
--(예) 바로 위 문제 : 'KING'의 직속상관은 NULL이므로 등가조인에서 제외됨
--[1]
select e.ename || '의 직속상관은 ' || m.ename
from EMPLOYEE e JOIN EMPLOYEE m -- ★★★ 반드시 별칭 사용
ON e.manager = m.eno;--등가조인조건('KING'의 직속상관은 NULL이므로 등가조인에서 제외되어 조인한 결과테이블에는 없다.)
--[2-1]
--오류는 없지만 결과가 안나오는 이유? 처음부터 조인한 결과테이블에 이름이 'KING'이 없었으므로...
select e.ename || '의 직속상관은 ' || m.ename
from EMPLOYEE e JOIN EMPLOYEE m
ON e.manager = m.eno
where e.ename = 'KING'; --[검색조건 추가]
--[2-2]
select e.ename || '의 직속상관은 ' || m.ename
from EMPLOYEE e JOIN EMPLOYEE m
ON e.manager = m.eno
where m.ename = 'KING';--직속상관이름이 'KING'인 사원은 3명 검색됨

--위 방법으로는 NULL값을 가진 사원 KING의 정보를 표현할 수 없다.
--따라서, 아래 방법으로 해결 => 외부조인(Outer join)
--[방법-1] NULL값도 표현하기 위한 해결방법 : 조인조건에서 NULL값을 출력하는 곳에 (+)
--주의 : 한쪽만 (+) 붙일 수 있다.(LEFT/RIGHT), 즉 FULL 불가능
select e.ename || '의 직속상관은 ' || NVL(m.ename, '없다.')
from EMPLOYEE e, EMPLOYEE m
where e.manager = m.eno(+);

--[방법-2] LEFT/RIGHT/FULL까지 가능함
--LEFT OUTER JOIN : 왼쪽 테이블의 내용 중 남은 부분 다 출력
--RIGHT OUTER JOIN : 오른쪽 테이블의 내용 중 남은 부분 다 출력
--FULL OUTER JOIN : 왼쪽과 오른쪽 테이블의 내용 중 남은 부분 다 출력
select e.ename || '의 직속상관은 ' || NVL(m.ename, '없다.')
from EMPLOYEE e LEFT OUTER JOIN EMPLOYEE m
ON e.manager = m.eno;
----------------------------------------------------------------
--<6장. 테이블 조인하기-혼자해보기>--------------------------------------
/*
 * 1.EQUI 조인을 사용하여 SCOTT사원의 부서번호와 부서이름을 출력하시오.
 */
--분류 : SCOTT사원은 이름,부서번호=>사원테이블,
--		부서번호, 부서이름=>부서테이블
--방법-1 : dno로 등가조인
select ename, e.dno, dname
from employee e, department d
where e.dno = d.dno	--조인조건
AND ename = 'SCOTT';	--검색조건
--AND LOWER(ename) = 'scott'; --검색조건
--AND ename = upper('scott'); --검색조건


select ename, e.dno, dname
from employee e JOIN department d
ON e.dno = d.dno
where ename = 'SCOTT';

/*
 * 2.(INNER) JOIN과 ON 연산자를 사용하여 사원이름과 함께 그 사원이 소속된 부서이름과 지역명을 
 * 출력하시오.
 */
--분류 : 사원이름 => 사원 테이블
--		부서이름, 지역명 => 부서테이블
--[1]
select * from EMPLOYEE;
select * from department;

--[방법-2]
select ename, dname, loc
from EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno; --조인조건

/*
 * 3.(INNER) JOIN과 USING 연산자를 사용하여 10번 부서에 속하는 모든 담당 업무의 고유 목록
 * (한 번씩만 표시)을 부서의 지역명을 포함하여 출력하시오.
 */
--업무(=job)=>사원테이블, loc=>부서테이블
--[방법-3]
select job, loc
from employee JOIN department	--중복제거 -> 별칭 필요없음
USING(dno)--조인조건
where dno = 10;--검색조건


/*
 * 4.NATURAL JOIN을 사용하여 '커미션을 받는 모든 사원'의 이름, 부서이름, 지역명을 출력하시오.
 */
--사원이름=>사원 테이블, 부서이름/지역명=>부서테이블
select ename, dname, loc
from employee NATURAL JOIN department --자연 : 같은 dno로 조인 후 중복 제거 -> 별칭필요없음
where commission IS NOT NULL;

/*
 * 5.EQUI 조인과 WildCard를 사용하여 '이름에 A가 포함'된 모든 사원의 이름과 부서이름을 출력하시오.
 */
--[방법-4]
select ename, dname
from EMPLOYEE e, DEPARTMENT d
where e.dno = d.dno
AND ename like '%A%'; -- A__, __A__, __A

select ename, dname
from EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno
WHERE ename like '%A%';
/*
 * 6.NATURAL JOIN을 사용하여 NEW YORK에 근무하는 모든 사원의 이름, 업무, 부서번호, 부서이름을 
 * 출력하시오.
 */
select ename, job, dno, dname
from EMPLOYEE natural join DEPARTMENT --자연 : 같은 dno로 조인 후 중복 제거
where loc = 'NEW YORK'; --검색조건
--where lower(loc) = 'new york';

/*
 * 7.SELF JOIN을 사용하여 사원의 이름 및 사원번호를 관리자 이름 및 관리자 번호와 함께 출력하시오.
 */
--[방법-1]
select e.ename as "사원이름", e.eno as "사원번호", m.ename as "관리자이름", m.eno as "관리자번호"
from employee e, employee m	--★★ 반드시 별칭!
where e.manager = m.eno;	--'KING' 제외됨

--[방법-2]
select e.ename as "사원이름", e.eno as "사원번호", m.ename as "관리자이름", m.eno as "관리자번호"
from employee e JOIN employee m	--★★ 반드시 별칭!
ON e.manager = m.eno;	--'KING' 제외됨

/*
 * 8.'7번 문제'+ OUTER JOIN, SELF JOIN을 사용하여 '관리자가 없는 사원'을 포함하여 사원번호를
 * 기준으로 내림차순 정렬하여 출력하시오.
 */
--관리자가 없는 사원 : 'KING'
--[방법-1]
select e.ename as "사원이름", e.eno as "사원번호", m.ename as "관리자이름", m.eno as "관리자번호"
from employee e, employee m--★★ 반드시 별칭!
where e.manager = m.eno(+) --제외된 'KING'을 표시
order by e.eno desc;
--order by 2 desc;

--[방법-2]
select e.ename as "사원이름", e.eno as "사원번호", m.ename as "관리자이름", m.eno as "관리자번호"
from employee e LEFT OUTER JOIN employee m--★★ 반드시 별칭!
ON e.manager = m.eno --제외된 'KING'을 표시 (왼쪽 테이블 다 표시)
order by e.eno desc;
/*
 * 9.SELF JOIN을 사용하여 지정한 사원의 이름('SCOTT'), 부서번호, 지정한 사원과 동일한 부서에서 
 * 근무하는 사원이름을 출력하시오.
 * 단, 각 열의 별칭은 이름, 부서번호, 동료로 하시오.
 */
--[방법-1]
--[1]
select *
from employee e, employee m
where e.dno = m.dno--조인조건 : 동일한 부서로 조인
order by 1 asc;
--[2]
select e.ename as "이름", e.dno as "부서번호", m.ename as "동료" --★★반드시 별칭
from employee e, employee m--★★ 반드시 별칭!
WHERE e.dno = m.dno--조인조건
AND (e.ename = 'SCOTT' AND m.ename != 'SCOTT');--검색조건


--[개인풀이]
select e.ename as "이름", e.dno as "부서번호", e2.ename as "동료"
from employee e JOIN employee e2--★★ 반드시 별칭!
ON e.dno = e2.dno--조인조건
where e.ename = 'SCOTT' AND e2.ename != 'SCOTT';--검색조건

/*
 * 10.SELF JOIN을 사용하여 WARD 사원보다 늦게 입사한 사원의 이름과 입사일을 출력하시오.
 * (입사일을 기준으로 오름차순 정렬)
 */
--[join 방법-1]이용--------------------------------------------------
--방법-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m--cross join : 14*14=196
where e.ename='WARD';--cross join 결과에서 검색 : 14

select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m
where e.ename='WARD' AND e.hiredate < m.hiredate--검색조건추가 : 11
order by m.hiredate asc;

--방법-2
--[1] 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2] 주쿼리, 서브쿼리 이용
select ename, hiredate
from employee
where hiredate > (select hiredate
				  from employee
				  where ename='WARD');

--방법-3
--[1] 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select *
from (select hiredate
	  from employee
	  where ename='WARD') e, employee m;

--[3]	  
select m.ename, m.hiredate
from (select hiredate
	  from employee
	  where ename='WARD') e, employee m
where e.hiredate < m.hiredate	--검색조건
order by m.hiredate asc;
--order by 2 asc;

--[join 방법-2]이용--------------------------------------------------
--방법-1-1
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e JOIN employee m
ON e.ename = 'WARD';--join 결과 : 14

select e.ename, e.hiredate, m.ename, m.hiredate
from employee e JOIN employee m
ON e.ename = 'WARD'
WHERE e.hiredate < m.hiredate--검색조건 : 11
order by m.hiredate asc;

--방법-1-2
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e JOIN employee m
ON e.ename = 'WARD';--join 결과 : 14

select e.ename, e.hiredate, m.ename, m.hiredate
from employee e JOIN employee m
ON e.ename = 'WARD' AND e.hiredate < m.hiredate--조인조건 : 11
order by m.hiredate asc;

--방법-3
--[1] 먼저 'WARD'의 입사일 구하기
select hiredate
from employee
where ename='WARD';--1981-02-22

--[2]
select *
from employee m JOIN employee e--주의 : 별칭순서
ON m.hiredate > (select hiredate
				  from employee
				  where ename='WARD');

--[3]	  
select DISTINCT m.ename, m.hiredate --DISTINCT:중복제거
from employee m JOIN employee e--주의 : 별칭순서
ON m.hiredate > (select hiredate
				  from employee
				  where ename='WARD')
order by m.hiredate asc;
--order by 2 asc;




/*
 * 11.SELF JOIN을 사용하여 관리자보다 먼저 입사한 모든 사원의 이름 및 입사일을 
 * 관리자 이름 및 입사일과 함께 출력하시오.(사원의 입사일을 기준으로 정렬)
 */
--[join 방법-1]이용----------------------------
--[1]
select e.eno, e.ename, e.hiredate, e.manager, m.eno, m.ename, m.hiredate
from employee e, employee m
where e.manager = m.eno -- 조인조건
AND e.hiredate < m.hiredate--검색조건
order by e.hiredate;--asc 생략가능
--[2]
select e.ename, e.hiredate, m.ename, m.hiredate
from employee e, employee m
where e.manager = m.eno -- 조인조건
AND e.hiredate < m.hiredate--검색조건
order by e.hiredate;--asc 생략가능

--[join 방법-2]이용
select e.ename as "사원이름", e.hiredate as "사원입사일",
		m.ename as "관리자이름", m.hiredate as "관리자입사일"
from employee e JOIN employee m
ON e.manager = m.eno
where e.hiredate < m.hiredate
order by e.hiredate;--asc 생략가능
