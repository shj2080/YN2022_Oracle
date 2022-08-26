--[SQL 활용] 정리

--<DDL:데이터 정의어>
--1. 테이블 생성
[테이블명 test]
----------------------------------------
필드(=컬럼명) Type           null      key   
----------------------------------------
id         varchar2(20)   no           
password   varchar2(30)   no            
name       varchar2(25)   no            
성별        char(2)        yes           
birth      date           yes          
age        number(4)      yes       
----------------------------------------

--drop table test;
create table test(
	id varchar2(20) not null,
	password varchar2(30) not null,
	name varchar2(25) not null,
	성별 char(2),
	birth date,
	age number(4)
);


--2. 컬럼 이름(=열 이름) 변경 : 성별 -> gender 
alter table test
rename column 성별 TO gender;

--3. 컬럼 이름(=열) 추가:address varchar2(60) 추가
alter table test
add address varchar2(60);

--4. birth 열 제거
alter table test
drop column birth;

/*
 * [컬럼의 길이 변경(줄일 때) 주의사항]
 * 컬럼의 길이를 줄일 경우 이미 insert된 해당 컬럼의 값 중 변경할 길이보다 큰 값이 있으면 오류가 발생한다.
 * ORA-01441: cannot decrease column length because some value is too big 
 * 
 * 이럴 때는 해당 컬럼의 길이를 조회하여 변경할 길이보다 큰 값이 있는지 확인한 후 값을 변경해야 한다.
 * 
 * select id, age -- select *
 * from test
 * where length(age) > 3;
 */

--5. 열 수정 : 아직 insert한 row(=레코드)가 없으므로 컬럼 크기를 자유롭게 줄일 수 있다.
--(1) age : number(3), null:NO, Default값:0
alter table test
modify age number(3) default 0 not null; --★★ 순서 주의 : not null default 0 (오류)

--(2) gender : char(1), Default값:'M'
alter table test
modify gender char(1) default 'M';

--다수의 컬럼 수정할 때
alter table test
modify (age number(3) default 0 not null,
		gender char(1) default 'M');	

--※ '테이블 제약조건'을 확인하려면 'USER_CONSTRAINTS'데이터 사전 사용함
select constraint_name, constraint_type --P, R, C, U
from user_constraints
where table_name in ('TEST');

--6. id에 '기본키 제약조건' 추가
--[방법-1]
--자동으로 생성된 '제약조건명(=constraint_name)'
alter table test
add primary key(id);

--사용자가 입력한 '제약조건명(=constraint_name)'
alter table test
add constraint test_id_pk primary key(id);

--[방법-2] 컬럼 id 수정
alter table test
MODIFY id varchar2(20) primary key;--primary key = not null + unique(index 자동생성됨)

--7. 테이블 구조 확인
desc test;
--SQL PLUS 명령어는 이클립스에서는 실행안됨(ORA-00900: invalid SQL statement)
--(RUN SQL~에서 실행 가능)

--8. TEST 테이블의 제약조건 확인(테이블명, 제약조건명, 제약조건타입)
--[1] 컬럼명을 모르겠으면 *로 조회하여 이름확인한 후
select *
from user_constraints
where table_name in ('TEST');

--[2] 테이블명, 제약조건명, 제약조건타입 조회
select table_name, constraint_name, constraint_type --P(=PK), R(=FK), C(=not null), U(Unique)
from user_constraints
where table_name in ('TEST');--반드시 대문자


-------------------------------------------------------------------------------------------------------------------

--<DML:데이터 조작어(insert, update, delete) -> TCL:트랜잭션 처리어(commit, rollback, savepoint)
--9. insert : 데이터 입력
id     password   name   gender    age    address
---------------------------------------------------
yang1  !1111      양영석     M       27     구미시
yoon2  $2222      윤호섭     M       19     대구광역시
lee3   #3333      이수광     M       30     서울특별시
an4    &4444      안여진     F       24     부산광역시

insert into test values('yang1', '!1111', '양영석', 'M', 27, '구미시');
insert into test values('yoon2', '$2222', '윤호섭', 'M', 19, '대구광역시');
insert into test values('lee3', '#3333', '이수광', 'M', 30, '서울특별시');
insert into test values('an4', '&4444', '안여진', 'F', 24, '부산광역시');

select * from test;
/** 과제 - 월요일까지 풀어오기 **/
--10과 10번 변형문제 => 과제 ------------------------------
--10. update : '광역시' -> '시'로 데이터 변경
--(단, 함수 사용하여 해결하기)

--[방법-1]과 [방법-2] : '광역시' 앞의 문자가 2개씩 있음을 알 때
--[방법-1]
--substr(기존문자열, 시작index, 추출할 개수) : 문자열의 일부만 추출하여 부분문자열 생성
--시작index : 음수이면 문자열의 마지막을 기준으로 거슬러 올라감
--인덱스(index) : 1 2 3...(※자바 index : 0 1 2...)
update test
set address = substr(address, 1, 2) || '시' --'부산' || '시' => '부산시'
where address like '%광역시';

--[방법-2]
--concat('문자열1', '문자열2') : '두 문자열'을 하나의 문자열로 연결(=결합)
--		★반드시 2 문자열만 연결 가능 = 매개변수 2개만
--매개변수=인수=인자=argument
--그러나, '문자열1' || '문자열2' || '문자열3' || ... ||는 여러 문자열 연결가능
update test
set address = concat(substr(address, 1, 2), '시')--CONCAT('대구', '시')
where address like '%광역시';
-----------------------------------------------------------------------------------------------------------
--[방법-3]과 [방법-4] : '광역시' 앞의 문자가 몇 글자인지 모를 때 => 정확한 풀이
--[방법-3]
--replace(컬럼명, '찾을문자', '변환문자') : 찾을 문자를 변경하거나 제거
--(예)찾을 문자를 변경
update test
set address = REPLACE(address, '광역시', '시')
where address like '%광역시';

--(예)찾을 문자를 제거
update test
set address = REPLACE(address, '광역', '')
where address like '%광역시';

--[방법-4] : INSTR() + [방법-1] SUBSTR() => '광역시' 앞의 문자가 몇 글자인지 모를 때 사용
--instr(대상문자열, 찾을 문자열, 시작 index, 몇 번째 발견) : '대상문자열' 내에서 '시작index'부터 시작해서 '몇 번째 발견'하는 '해당 문자열'을 찾아 index번호 리턴
--즉, 찾을 문자열이 어느 '위치(=index번호)'에 있는지와 대상문자열에 존재하는지의 여부를 알 수 있다.
--'시작 index, 몇 번째 발견' 생략하면 모두 1로 간주
--(예)instr('대상문자열', '찾을문자') == instr('대상문자열', '찾을문자', 1, 1)
--찾는 문자가 없으면 0을 결과로 돌려줌(※자바에서는 -1을 돌려줌)
--자바에서는 "행복,사랑".indexOf("사랑") == 3(※자바의 index는 0부터 시작)

--INSTR() : '광역시' 앞의 문자가 몇 글자인지 모를 때 사용
update test
set address = substr(address, 1, instr(address, '광역시',1, 1) - 1) || '시'
where address like '%광역시';

--10번 변형문제. update : '광역시' -> '시'로 데이터 변경
--(단, 서브쿼리 사용하여 해결하기)

--[방법-1] REPLACE() 사용
--[1]
select replace(address, '광역시', '시')
from test
where address like '%광역시';

--[2]
update test
set address = (
				select replace(address, '광역시', '시')
				from test
				where address like '%광역시')
where address like '%광역시';

--[방법-2] substr() 사용
--[1] '광역시'의 index-1 = 광역시 전 까지의 단어 길이
select instr(address, '광역시', 1, 1) - 1
from test
where address like '%광역시';

--[2] 
select substr(address, 1, (select instr(address, '광역시', 1, 1) - 1
							from test
							where address like '%광역시')) || '시'
from test
where address like '%광역시';

--[3]
update test
set address = (select substr(address, 1, (select instr(address, '광역시', 1, 1) - 1
							from test
							where address like '%광역시')) || '시'
				from test
				where address like '%광역시')
where address like '%광역시';

/*
update test
set address = replace(address, '광역시', '시')
where id in (select id
                from test
                where instr(address, '광역시') != 0);
                
update test
set address = substr(address, 1, instr(address, '광역시',1, 1) - 1) || '시'
where id in (select id
                from test
                where instr(address, '광역시') != 0);
*/
---------------------------------------------------------
--11. delete : 나이가 20미만인 데이터 삭제
--미만 <20, 이하 <=20, 초과 >20, 이상>=20
delete test--from test
where age < 20;

--12. 데이터 입력한 후 영구저장(트랜잭션 완료) : RUN SQL~에서 실행
----->결과 확인 : 이클립스에서 결과 확인
--삽입할 데이터 : jun5 *5555 전상호  M 28 NULL

--[1] RUN SQL~에서 실행
insert into test values('jun5', '*5555', '전상호', 'M', 28, null);
commit;

--[2] 이클립스에서 결과 확인
select * from test;

--13. 데이터 삭제한 후 이전 상태로 복귀(트랜잭션 취소) : RUN SQL~에서 실행
----->결과 확인 : 이클립스에서 결과 확인
--[문제] 주소가 '구미시'인 row 삭제 후 트랜잭션 취소 -> 확인
--[1] RUN SQL~에서 실행
delete test
where address = '구미시';

--[2] 트랜잭션 취소(이전 상태로 복귀)
rollback;

--[3] 이클립스에서 결과 확인
select * from test;

--데이터 사전(8장-6. 데이터 사전 참조)
--14. 사용자가 소유한 테이블 이름 조회 => USER_데이터 사전
select table_name
from USER_TABLES;

--15. 테이블 구조 확인
desc test;----SQL PLUS명령어는 이클립스에서 실행안됨(RUN SQL~에서 실행)

--16. index 생성(index 명 : name_idx)
--인덱스 : 검색 속도를 향상시키기 위해 사용
--     	사용자의 필요에 의해서 직접 생성할 수도 있지만
--     	데이터 무결성을 확인하기 위해서 수시로 데이터를 검색하는 용도로 사용되는 
--     	'기본키나 유일키는 인덱스 자동 생성'
create index name_idx
ON test(name);

--★★index 생성 확인 방법-1
select index_name
from USER_indexes
where table_name = 'TEST'; --반드시 테이블명은 대문자로
--where table_name IN ('TEST');

select *
from user_indexes;

--※ index 생성 확인 방법-2
select index_name, column_name
from USER_ind_columns--column_name 알려면 
where table_name = 'TEST'; --반드시 테이블명은 대문자로

--17. view 생성(뷰 이름 : viewTest)
--뷰? 하나 이상의 테이블이나 다른 뷰를 이용하여 생성되는 가상테이블
--뷰는 복잡한 쿼리를 단순화 시킬수 있다.
--뷰는 사용자에게 필요한 정보만 접근하도록 접근을 제한할 수 있다.
create view viewTest
AS
select id, name, gender
from test;

--뷰 생성 확인 방법-1
select * from viewTest;

-- 뷰 생성 확인 방법-2
select view_name
from USER_views
where view_name = 'VIEWTEST';

--사용자가 소유한 뷰 이름 조회
select view_name
from USER_views;

--------------------------------------------------------------------------------------------
--18. test2 테이블 생성
[테이블명 test2]
-------------------------------------
필드       Type           null   key 
-------------------------------------
id        varchar2(20)   no     PK  
major     varchar2(20)   yes  
-------------------------------------

create table test2(
	id varchar2(20) primary key,
	major varchar2(20)
);

insert into test2 values('yang1', '컴퓨터 공학');
insert into test2 values('lee3', '건축 공학');
insert into test2 values('an4', '환경 공학');
insert into test2 values('jun5', '화학 공학');

select * from test2;

--test, test2 EQUI 조인(=등등조인=동일조인) : 데이터 타입이 같아야 함
--[방법-1] : 중복컬럼 제거하지 않으므로 구분하기 위해 '별칭 필요'
--			컬럼명이 달라도 조인가능

--[방법-1] : , where - (+)붙여서 외부조인(왼쪽과 오른쪽만 가능, 완전(Full)외부조인 못함)
select *
from test t1, test2 t2
where t1.id = t2.id;--조인조건
--AND (검색조건)

--[방법-2] : JOIN ~ ON => 권장O - Left Outer Join, Right Outer Join, Full Outer Join
select *
from test t1 JOIN test2 t2
ON t1.id = t2.id;--조인조건
--WHERE 검색조건

--[방법-3][방법-4] : ※오라클에서만 사용가능
--				   중복컬럼 제거하므로 '별칭 필요X'
--				   컬럼명이 반드시 같아야 조인할 수 있다.

--[방법-3] : natural join - 같은 이름, 타입, "의미"를 가진 컬럼이 "하나"일 때 사용 권장
select *
from test natural join test2;
--조인조건 필요없음

--[방법-4] : JOIN ~ USING - 같은 이름, 타입, "의미"를 가진 컬럼이 "2개 이상"일 때 사용 권장
select *
from test JOIN test2
USING(id);

/*
 * ▶ NATURAL 조인과 USING 절을 이용한 조인의 차이점
 * 조인되는 테이블간 공통된 컬럼이 2개 이상이라면 둘의 결과는 완전히 다를 수 있다.
 * 
 * select *
 * from employee 
 * join department USING(dno)--조인한 결과와
 * join test3 USING(manager_id);--조인.(manager_id의 이름, 타입, 의미는 같다.)
 * 
 * select *
 * from employee 
 * NATURAL join department;--자동으로 dno로 조인한 결과와
 * NATURAL join test3;--조인.
 * --(manager_id뿐만 아니라 '같은 이름과 같은 타입이 하나 더 존재'한다면 2개의 공통된 컬럼으로 조인이 되어)
 * -->둘의 결과는 완전히 다를 수 있다.
 * 
 * ※ 따라서, 같은 이름, 타입, 의미의 컬럼이 하나이면  NATURAL 조인을 사용하고
 * 2개 이상이면'가독성이 좋은 USING 절'을 이용한 방법을 권한다.
 */

--------------------------------------[18. join 간단 정리 끝]--------------------------------------

--19. 서브쿼리를 이용하여 major가 '컴퓨터 공학'인 사람의 이름 조회(test와 test2 테이블 사용가능)
--[1] test2 테이블에서 major가 '컴퓨터 공학'인 사람의 id 검색(여러 명 검색 가능성이 있음)
select id
from test2
where major = '컴퓨터 공학';

--[2]
select name
from test
where id in (
	select id
	from test2
	where major = '컴퓨터 공학');

--20. 집합연산자 : 각 쿼리의 '컬럼 개수'와 '데이터 타입'이 일치
--20.1 UNION : 각 쿼리의 결과의 합을 반환하는 '합집합'(중복제거)
--             쿼리의 결과를 합친 후 '중복을 제거'하는 작업이 추가로 적용되므로 쿼리의 속도 및 부하가 발생한다.
--             중복을 제거할 필요가 없으면 UNION ALL을 사용하는 것이 합리적이다.

--(예) employee 테이블 대상
--[1] 사원테이블에서 급여가 3000이상인 사원의 직업과 부서번호 조회
select job, dno
from employee
where salary >= 3000;--결과 : 중복 포함하여 3개 ROW

--[2] 사원테이블에서 부서번호가 10인 사원의 직업과 부서번호 조회             
select job, dno
from employee
where dno = 10;--결과 : 3개 ROW

--[3-1] 위 2개 쿼리의 결과를 하나로 합(중복 제거)
select job, dno
from employee
where salary >= 3000

UNION

select job, dno
from employee
where dno = 10;--결과 : 중복 제거되어 4개 ROW

--[3-2] 위 2개 쿼리의 결과를 하나로 합(중복 제거X)
select job, dno
from employee
where salary >= 3000

UNION ALL

select job, dno
from employee
where dno = 10;--결과 : 중복 제거X되어 6개 ROW

--20.2 INTERSECT : 각 쿼리의 결과 중 '같은 결과만 반환'하는 '교집합'(INTERSECTION)
select job, dno
from employee
where salary >= 3000

INTERSECT

select job, dno
from employee
where dno = 10;

--20.3 MINUS : 앞 쿼리의 결과 - 뒤 쿼리의 결과  ('차집합')(중복제거)
--             앞 쿼리의 결과 - 앞뒤 교집합의 결과
--※ EXCEPT : 일부DBMS에서는 MINUS 대신 사용
select job, dno
from employee
where salary >= 3000

MINUS

select job, dno
from employee
where dno = 10;

----------------------------------------------------------------------------------------------------

--UNION : 특징들을 예로 설명
--(예1) job별로 급여의 총합과 커미션의 총합 구하기
select job as "직업", SUM(salary) as total_sum, SUM(NVL(commission,0)) as total_sum2
from employee
group by job
--order by job asc;--"컬럼명"으로 정렬 가능 
--order by "직업" asc;--"컬럼별칭"으로 정렬 가능
order by 1 asc;--"컬럼순번"으로 정렬 가능

--UNION을 사용한 방법--"컬럼명"으로 정렬 불가능
--(예1 변경-1)
--[1] 각 테이블에 별칭 사용
select 'salary' as kind1, e1.job as job1, SUM(e1.salary) as total_sum
from employee e1
group by e1.job

UNION

select 'commission' as kind2, e2.job as job2, SUM(NVL(e2.commission,0)) as total_sum2
from employee e2
group by e2.job;

--[2] 테이블 별칭 생략 가능
select 'salary' as kind, job as "직업1", SUM(salary) as total_sum
from employee
group by job

UNION

select 'commission' as kind, e2.job as "직업2", SUM(NVL(e2.commission,0)) as total_sum
from employee e2
group by e2.job

ORDER BY kind desc, "직업1" asc;--"위 테이블 컬럼별칭"으로 정렬 가능
--ORDER BY kind desc, "직업2" asc;--"아래 테이블 컬럼별칭"으로 정렬 "불가능"
--ORDER BY 1 desc, 2 asc;--"컬럼순번"으로 정렬 가능

--★★ ORDER BY는 쿼리문의 마지막에 단 1번만 사용가능
--★★ ORDER BY절 + "위 테이블의 컬럼 별칭" 또는 "컬럼 순번"만 사용가능(★★ "컬럼명"은 정렬 불가능)

--(예1 변경-2) 모든 컬럼과 테이블 별칭 생략하면 '1번째 컬럼 자체'가 '컬럼명'으로 표시됨
select 'salary', job, SUM(salary)
from employee
group by job

UNION

select 'commission', job, SUM(NVL(commission,0))
from employee
group by job

ORDER BY 1 desc, 2 asc;--"컬럼순번"으로만 정렬 가능(이유?컬럼별칭 없으므로)

--(예2) 사원 테이블과 부서 테이블을 결합하여 부서번호와 부서이름을 조회(중복 제거)
select DISTINCT dno, dname--10 20 30
from employee NATURAL JOIN department;--같은 dno로 자연스럽게 조인

--[문제] 사원 테이블과 부서 테이블에 '동시에 없는 부서번호, 부서이름' 조회
--(employee의 dno가 department의 dno를 references를 아는 전제 하에서
--즉,'employee의 dno가 참조하는 dno는 반드시 department의 dno로 존재한다'는 사실을 아는 전제 하에서 문제 해결함) 

--[방법-1] IN 연산자 이용
--[1]
select e.dno--10 20 30
from EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno;
--[2]
select dno, dname--40 OPERATIONS
from department
where dno NOT IN (select e.dno--10 20 30
			      from EMPLOYEE e JOIN DEPARTMENT d
			      ON e.dno = d.dno);
			      
--[방법-2] join방법-1 이용   
--[1] 각 테이블에 존재하는 부서 번호 확인  
select distinct dno-- 10 20 30
from employee; 

select distinct dno-- 10 20 30 40
from department; 

--[2] e.dno와 d.dno는 같다.
select DISTINCT e.dno, dname--10 20 30(동시에)
from employee e, department d
where e.dno = d.dno; 

--[3] ★e.dno와 d.dno는 다르다.
select * --테이블의 모든 내용을 본 후 검색조건을 생각하기
from employee e, department d
where e.dno(+) = d.dno;

--[4] ★e.dno와 d.dno는 다르다.
select *  --DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--조인조건
AND e.dno IS NULL;    --검색조건-방법-1
--AND eno IS NULL;  --검색조건-방법-2 등등
--outer join시 나오는 null을 사용하여 employee 테이블에 존재하지 않는 부서번호 출력		

--[5]
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--조인조건
AND ename IS NULL; 

--[방법-3] join방법-1 이용
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--조인조건
--(10 20 30 40) NOT IN (10 20 30)  => 40만 true
AND d.dno NOT IN(select distinct dno
				 from employee); 
--검색조건(부서테이블의 부서번호가 사원테이블의 부서번호 중 속하지 않은 것이 TRUE)

--[방법-4] join방법-1 이용
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--조인조건
--(10 20 30 40) != ALL(10 20 30)  => 40만 true
AND d.dno != ALL(select distinct dno
			     from employee); 				
                 
--[방법-4] join방법-2 이용 
select DISTINCT d.dno, dname 
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno--조인조건
WHERE e.dno IS NULL;  

--< 참조 : 오라클 실행 순서 >
--from -> where -> group by -> having -> select 컬럼명의 별칭 -> order by
--[방법-5] EXISTS 이용
select dno, dname
from department d
where NOT EXISTS (select dno -- 40=>true
                  from employee --별칭 사용안해도 됨
                  where d.dno = dno);                  
                
                  
--[방법-6] : MINUS + JOIN 이용 {10, 20, 30, 40} - {10, 20, 30} = {40}
select dno, dname
from department

MINUS

select dno, dname
from employee JOIN department
USING(dno);

--[방법-7] : INTERSECT 이용 {10, 20, 30, 40} - {10, 20, 30} = {40}
--[1] 
select dno from employee
INTERSECT
select dno from department;

--[2]
select dno, dname
from department
WHERE dno NOT IN (select dno from employee
				  INTERSECT
				  select dno from department);
---------------------------------------------------------------------------------------------------                                         

-- UNION 사용 : 서로 다른 테이블을 사용한 쿼리의 결과가 합쳐서 조회
--             select문의 컬럼의 개수와 각 컬럼의 데이터 타입만 일치하면 된다.   

--(예) 합계를 따로 연산하여 조회 결과에 합치는 용도로 UNION ALL 사용
--[1] 각 직업 별 급여 합을 조회
select job, SUM(salary)
from employee
group by job;

--[2] 전체 사원의 급여 총합 조회
select SUM(salary)
from employee;

--[1]+[2]		
select job, SUM(salary) as "급여"
from employee
group by job		  

UNION ALL

select '합계', SUM(salary)
from employee;

--(예)★★ 사원테이블에서 '연봉 상위 3명'의 이름, 급여 조회(단, 급여가 같으면 사원이름으로 오름차순 정렬)
--(해결 시) UNION ALL 이용
--delete employee where ename='홍길동';
select ename, salary
from employee
where rownum <= 3
order by salary desc;--원하는 결과가 안나옴(이유:rownum번호는 insert한 순서로 매겨짐)

--[방법-1] : 5000 3000 3000
--[1]
select ename, salary from employee where dno=10
UNION ALL
select ename, salary from employee where dno=20
UNION ALL
select ename, salary from employee where dno=30
UNION ALL
select ename, salary from employee where dno=40
ORDER BY 2 desc, 1 asc;--"컬럼순번"으로만 정렬 가능

--[2]
select *
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
where rownum <= 3;	

--[3-1]
select rownum, ename, salary
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
--where rownum <= 3;
--where rownum < 4;	
where rownum = 1 or rownum = 2 or rownum = 3;

--[3-2]
select rownum, ename, salary
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
where rownum IN (1,2,3);	

--[3-3] *를 사용하려면 
select rownum, e.*
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc) e--반드시 테이블 별칭 사용
where rownum IN (1,2,3);	

--[방법-2] rank() 함수 + UNION ALL 이용
--[1]
select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
from employee;

--[2]
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee)
where "등수"=1

UNION ALL

select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee)
where "등수"=2

UNION ALL

select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee)
where "등수"=3;
---------------------------------------------------------------------------------
--[해결 시] UNION ALL 이용X, ROWNUM이나 RANK()만 사용
--[방법-1] RANK()만 사용
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee)
where "등수" <= 3;

--[방법-2] ROWNUM만 사용
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee)
where ROWNUM <= 3;

--ROWNUM까지 출력하려면(*도 사용)
select ROWNUM, e.*
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "등수"
      from employee) e--반드시 테이블 별칭 사용
where ROWNUM <= 3;

--[방법-2-1] ROW_NUMBER()를 이용하여 rownum 직접 만들기
--(=>즉, insert된 순서가 아니라 내가 정한 순서로 rownum 번호 만들기)
--[1]
select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
from employee;

--[2] 오류
select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
from employee
where ROW_NUM <= 3;--오류 ORA-00904: "ROW_NUM": invalid identifier (ROW_NUM 별칭 사용불가)
--★★ 별칭 사용불가 이유? '오라클 실행순서' 때문에
--(from -> where -> group by -> having -> select -> order by)

--[2]
select *
from (select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
      from employee)
where ROW_NUM <= 3;

--[방법-3] : ROWNUM과 RANK() 함께 사용
--[1] ROWNUM : indert한 순서, RANK:salary 큰 순서->ename 알파벳 순
select ROWNUM, ename, salary, RANK() OVER(order by salary desc, ename asc) as "등수"
from employee
where ROWNUM <= 3;--원하는 결과가 아님
--나온 결과 해석 : ROWNUM 1,2,3만 검색한 테이블에서 rank() 함수 적용한 결과가 나옴

--[2] ROWNUM과 RANK() 순서를 같게 만든다.
--[2-1] 
select ROWNUM, ename, salary, "등수"
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) as "등수"
      from employee)
WHERE "등수" <= 3;

--[2-2] 
select ROWNUM, e.*
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) as "등수"
      from employee) e
WHERE ROWNUM <= 3;



