--1장.오라클과 데이터베이스
/*
14p~
01.데이터베이스 관리 시스템(=DBMS) : 연관성 있는 데이터들의 집합을 효율적으로 관리하는 프로그램
데이터베이스 관리 시스템 제품 : 오라클, MySQL, MS-SQL 등

데이터 저장 장소인 데이터베이스와 관리하고자 하는 모든 데이터를 서로 연관관계를 가진 테이블(=표) 형식으로
저장하는 '관계형 데이터베이스'라고 함
*/

/*
26p~
03.SQL과 데이터 조회하기
3.1 오라클에 접속하기

'데이터베이스 사용자'는 '오라클 계정'과 같은 의미

<오라클에서 제공하는 사용자 계정>
1. SYS : 시스템 유지, 관리, 생성 '모든 권한', 오라클시스템의 '총관리자', sysdba권한
2. SYSTEM : 생성된 DB운영, 관리, '관리자'계정, sysoper권한
3. HR : 처음 오라클 사용하는 사용자를 위해 실습 위한 '교육용 계정'
*/


--교재 28~29p 참조
--테이블 삭제
DROP TABLE employee;	--사원테이블부터 삭제
DROP TABLE department;	--부서테이블의 dno를 사원테이블에서 참조하고 있으므로...
DROP TABLE salgrade;

--부서 정보---------------------------------------
--★★먼저, '부서 정보 테이블'부터 만든다.(이유?사원정보 테이블에서 참조하고 있으므로)
CREATE TABLE department(
	dno number(2) PRIMARY KEY, --'부서번호'를 기본키(=primary key:중복X(=unique유일한, index자동생성함)+not null) ※MySQL : int
	dname varchar2(14), --'부서명':가변크기 (※MySQL : varchar)
	loc varchar2(13) --'지역명'
);

--부서정보 테이블에 데이터를 추가한다.
INSERT INTO department VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO department VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO department VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO department VALUES(40, 'OPERATIONS', 'BOSTON');

--부서 정보 테이블 조회(모든 것 : *)
SELECT * FROM department;

--사원 정보---------------------------------------
--사원 정보 테이블을 만든다.
CREATE TABLE employee(
	eno number(4) PRIMARY KEY, -- 사원번호(기본키=PK:중복X, 유일unique)
	ename varchar2(10), --사원명
	job varchar2(9), --업무명
	manager number(4), --해당 사원의 상사번호(=관리자)
	hiredate date, --입사일
	salary number(7,2), --급여(실수:소수점을 제외한 전체 자리수, 소수점 이하 3째 자리에서 반올림하여 2째 자리까지 표현)
	commission number(7,2), --커미션
	dno number(2) REFERENCES department	--dno(참조키=외래키=Foreign Key=FK)
	--department테이블에 dno가 primary key 또는 unique로 존재해야 함
	
	--만약, 기본키가 2개 이상이면
	--PRIMARY KEY(eno,ename)
);

--사원정보 테이블에 데이터를 추가한다.
INSERT INTO employee VALUES(7369, 'SMITH', 'CLERK', 7902, to_date('17-12-1980','dd-mm-yyyy'), 800, NULL, 20);
INSERT INTO EMPLOYEE VALUES
(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);
INSERT INTO EMPLOYEE VALUES
(7521,'WARD','SALESMAN', 7698,to_date('22-2-1981', 'dd-mm-yyyy'),1250,500,30);
INSERT INTO EMPLOYEE VALUES
(7566,'JONES','MANAGER', 7839,to_date('2-4-1981', 'dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7654,'MARTIN','SALESMAN', 7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMPLOYEE VALUES
(7698,'BLAKE','MANAGER', 7839,to_date('1-5-1981', 'dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMPLOYEE VALUES
(7782,'CLARK','MANAGER', 7839,to_date('9-6-1981', 'dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMPLOYEE VALUES
(7788,'SCOTT','ANALYST', 7566,to_date('13-07-1987', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMPLOYEE VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981', 'dd-mm-yyyy'),1500,0,30);
INSERT INTO EMPLOYEE VALUES
(7876,'ADAMS','CLERK',   7788,to_date('13-07-1987', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7900,'JAMES','CLERK',   7698,to_date('3-12-1981', 'dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMPLOYEE VALUES
(7902,'FORD','ANALYST',  7566,to_date('3-12-1981', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMPLOYEE VALUES
(7934,'MILLER','CLERK',  7782,to_date('23-1-1982', 'dd-mm-yyyy'),1300,NULL,10);

--사원 정보 테이블 조회(모든 것 : *)
SELECT * FROM employee;

--급여 정보---------------------------------------
--급여 정보 테이블을 만든다.
CREATE TABLE salgrade(
	grade number,	--급여 등급
	losal number,	--급여 하한값
	hisal number	--급여 상한값
);

--급여정보 테이블에 데이터를 추가한다.
INSERT INTO salgrade VALUES(1, 700, 1200);
INSERT INTO salgrade VALUES(2, 1201, 1400);
INSERT INTO salgrade VALUES(3, 1401, 2000);
INSERT INTO salgrade VALUES(4, 2001, 3000);
INSERT INTO salgrade VALUES(5, 3001, 9999);

--급여 정보 테이블 조회(모든 것 : *)
SELECT * FROM salgrade;

/*
 * 1장-30p
 * desc : describe(묘사하다)의 약어로 RUN~에서 실행되는 SQL*Plus명령어임
 * 				테이블의 구조 확인
 */
DESC department;
DESC employee;
DESC salgrade;

--3.4. 조회(* 모든 것)
--전체 사원 조회하기(=출력하기)
SELECT * FROM employee;

--사원번호와 사원명만 조회하기
SELECT eno, ename FROM employee;

--3.5 산술 연산자
SELECT ename, salary, salary*12
FROM employee
WHERE ename='SMITH';	/*sql에서는 =같다 (※자바에서는 =대입연산자 ==같다)*/

SELECT ENAME, SALARY, SALARY*12
FROM EMPLOYEE
WHERE ENAME='smith';		-- 결과는 존재하지 않는다.(입력되는 값은 대소문자 구분함!)

SELECT ENAME, SALARY, SALARY*12
FROM EMPLOYEE
WHERE lower(ENAME)='smith';/*lower(문자)를 소문자로 변환*/

SELECT ENAME, SALARY, SALARY*12
FROM EMPLOYEE
WHERE ENAME=upper('smith');/*upper(문자)를 대문자로 변환*/

/*
 * 산술 연산에 null을 사용하는 경우에는 특별한 주의가 필요함
 * null은 '미확정', '알 수 없는 값'의 의미이므로 '연산, 할당, 비교가 불가능'함
 */
SELECT ename, salary, commission, salary*12+commission
FROM employee;
--commission이 null이면 결과도 null(연산이 안되는 문제 발생)

--[해결방법-1]NVL()함수 사용하여 위의 문제 해결함
--NVL(값, ) 0값이 null이면 0으로 변경, null이 아니면 값을 그대로 사용
SELECT ename, salary, commission, salary*12 + NVL(commission, 0)
FROM employee;

--[해결방법-2]NVL2()함수 사용하여 위의 문제 해결함
--NVL2(값, 값1, 값2) 값이 null이 아니면 값1을 그대로 사용, 값이 null이면 값2를 사용
SELECT ename, salary, commission, salary*12 + NVL2(commission, commission, 0)
FROM employee;

--※NVL2()함수는 값이 null이 아닐 때 대체할 값을 지정할 수 있다.
SELECT ename, salary, commission, salary*12 + NVL2(commission, 800, 0)
FROM employee;

/*
 * 별칭
 * 1. 컬럼명 별칭
 * 2. 컬럼명 AS 별칭
 * 3. 컬럼명 AS "별 칭"
 * 
 * 반드시 ""해야 되는 경우
 * 별칭 글자 사이에 '공백,특수문자 추가' 또는 '대소문자 구분'
 */
SELECT ename 사원이름, salary as "급 여", commission AS "Cms",
salary*12 + NVL(commission, 0) as "연봉+커미션"
FROM employee;

-- distinct : 중복된 데이터를 한번씩만 표시
SELECT DISTINCT dno	--부서번호
FROM employee;

/*
 * dual : 가상테이블, 결과값을 1개만 표시하고 싶을 때 사용
 */
--sysdate 함수 : 컴퓨터 시스템으로부터 오늘 날짜(★주의 : 뒤에 ()없음!)
SELECT * FROM employee;--14행
SELECT sysdate FROM employee; --14행 같은 날짜
SELECT DISTINCT sysdate FROM employee;

SELECT * FROM dual;	--1행
SELECT sysdate FROM dual;	--1행 날짜

COMMIT; -- 수정된 데이터를 DB에 영구 저장

