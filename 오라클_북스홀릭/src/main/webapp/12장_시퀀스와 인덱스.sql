--<북스 12장. 시퀀스와 인덱스>
--1. 시퀀스 생성
--※ 시퀀스 : 테이블 내의 유일한 숫자를 자동 생성
--오라클에서는 데이터가 중복된 값을 가질 수 있으나
--'개체 무결성'을 위해 항상 유일한 값을 갖도록 하는 '기본키'
--시퀀스는 기본키가 유일한 값을 반드시 갖도록 자동생성하여 사용자가 직접 생성하는 부담감을 줄인다.

create sequence 시퀀스명
[start with 시퀀스 시작숫자]--시작숫자의 기본값은 증가할 때 minvalue, 감소할 때 maxvalue
[increment by 증감숫자] --증감숫자가 양수면 증가, 음수면 감소 (기본값 : 1)

[minvalue 최소값 | nominvalue(기본값)] --nominvalue(기본값) : 증가일 때 1, 감소일 때 -10의 26승까지
								   --minvalue 최소값 : 최소값 설정, 시작숫자보다 같거나 작아야 하고 maxvalue(최대값)보다 작아야 함
                                   
[maxvalue 최대값 | nomaxvalue(기본값)] --nomaxvalue(기본값) : 증가일 때 10의 27승까지, 감소일 때 -1까지
							       --maxvalue 최대값 : 최대값 설정, 시작숫자와 같거나 커야 하고 minvalue(최소값)보다 커야 함

[cycle | nocycle(기본값)] -- cycle : 최대값까지 증가 후 최소값으로 다시 시작
						-- nocycle : 최대값까지 증가 후 그 다음 시퀀스를 발급받으려면 에러 발생

[cache n | nocache]		-- cache n : 메모리상에 시퀀스 값을 미리 할당(기본값은 20)
						-- nocache : 메모리상에 시퀀스 값을 미리 할당하지 않음(관리X)

[order | noorder(기본값)] -- order : 병렬서버(여러 DB서버가 연결된 구조)를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정
						-- 		   단일서버일 경우 이 옵션과 관계없이 정확히 요청 순서에 따라 시퀀스가 생성됨.
						-- noorder(기본값)
;
--(1) sequence-1 생성
--drop sequence sample_test; --이미 시퀀스가 있는 경우 제거
create sequence sample_test; --옵션은 기본값으로

select *
from USER_sequenceS
where sequence_name in ('SAMPLE_TEST'); --반드시 대문자
--where sequence_name in UPPER('sample_test'); --upper를 이용해 대문자로 변환해도 됨

create sequence sample_test2
start with -999999999999999999999999990 --9가 26번 + 0
increment by -10 --최소값 : -999999999999999999999999999 (9가 27번)
;

select sample_test2.nextval, sample_test2.currval from dual; --성공(-999999999999999999999999990)
select sample_test2.nextval, sample_test2.currval from dual; --오류
--ORA-08004: sequence SAMPLE_TEST2.NEXTVAL goes below MINVALUE and cannot be instantiated

select *
from USER_sequenceS
where sequence_name in ('SAMPLE_TEST2'); --반드시 대문자

--(2) sequence-2 생성
create sequence sample_seq
start with 10
increment by 3
maxvalue 20
cycle
nocache;

select *
from USER_sequenceS
where sequence_name in ('SAMPLE_SEQ'); --반드시 대문자

select sample_seq.nextval, sample_seq.currval from dual;--10 10
select sample_seq.nextval, sample_seq.currval from dual;--13 13
select sample_seq.nextval, sample_seq.currval from dual;--16 16
select sample_seq.nextval, sample_seq.currval from dual;--19 19 (maxvalue 20이므로)
select sample_seq.nextval, sample_seq.currval from dual;--1  1  (cycle:최소값으로..)(maxvalue 20을 초과하는 순간 minvalue인 1로 돌아옴)
select sample_seq.nextval, sample_seq.currval from dual;--4  4

--(3) sequence-3 생성
create sequence sample_seq2
start with 10
increment by 3;

select * 	--maxvalue 99.999(9가 27번=최대값 10의 27승까지=1E+28=10E+27)
from USER_sequenceS
where sequence_name in ('SAMPLE_SEQ2'); --반드시 대문자

select sample_seq2.nextval, sample_seq2.currval from dual;--10 10
select sample_seq2.nextval, sample_seq2.currval from dual;--13 13
select sample_seq2.nextval, sample_seq2.currval from dual;--16 16
select sample_seq2.nextval, sample_seq2.currval from dual;--19 19
select sample_seq2.nextval, sample_seq2.currval from dual;--22 22 (최대값까지 계속 증가 후 nocycle)

--1.1 NEXTVAL -> CURRVAL(★★ 사용순서 주의)
--NEXTVAL : 다음값(★새로운 값 생성) 다음에
--CURRVAL : 시퀀스의 현재값 알아냄

select sample_seq2.nextval from dual;--25
select sample_seq2.currval from dual;
--오류?ORA-08002: sequence SAMPLE_SEQ2.CURRVAL is not yet defined in this session

select sample_seq2.nextval, sample_seq2.currval from dual;--28 28(순서 관계없이 실행됨)
select sample_seq2.currval, sample_seq2.nextval from dual;--31 31
--즉, 순서 관계없이 실행순서:
--먼저 sample_seq2.nextval 다음값 생성 -> 그 다음 sample_seq2.currval로 현재값 알아냄


--1.2 시퀀스를 기본키에 접목하기(295p)
--부서 테이블의 기본키인 부서번호는 반드시 유일한 값을 가져야 함
--유일한 값을 자동 생성해주는 시퀀스를 통해 순차적으로 증가하는 컬럼값 자동생성

--실습위해 dept12 테이블 생성
--drop table dept12; --생성된 테이블이 있다면 먼저 drop
create table dept12
AS
select * from department
where 0=1; --조건을 거짓으로
--테이블 구조만 복사(단, 제약조건은 복사안됨!-dno는 기본키가 아님)

--dno에 기본키 제약조건 추가
alter table dept12
add constraint dept12_dno_pk primary key(dno); --제약조건명을 직접 지정, index 자동생성

alter table dept12
add primary key(dno); --제약조건명 시스템이 자동 지정, index 자동생성

select * from dept12;

--기본키에 접목시킬 시퀀스 생성
create sequence dno_seq
start with 10	--10 부터 시작
increment by 10; --nocycle이 기본값 (10->20->..->80->90(끝)  ->10(X)) 

--구조를 복사한 부서정보 테이블(dept12)에 데이터를 추가한다.
INSERT INTO dept12 VALUES(dno_seq.nextval,'ACCOUNTING', 'NEW YORK'); --10
INSERT INTO dept12 VALUES(dno_seq.nextval, 'RESEARCH', 'DALLAS'); --20
INSERT INTO dept12 VALUES(dno_seq.nextval, 'SALES', 'CHICAGO'); --30
INSERT INTO dept12 VALUES(dno_seq.nextval, 'OPERATIONS', 'BOSTON'); --40

select * from dept12;

--2. 시퀀스 수정 및 제거
--<수정 시 주의할 사항 2가지>
--[1] 'start with 시작숫자'는 수정 불가
--이유? 이미 사용 중인 시퀀스의 시작값을 변경할 수 없으므로
--시작번호를 다른번호로 다시 시작하려면 이전 시퀀스를 DROP으로 사제 후 다시 생성

--[2] 증가 : 현재 들어있는 값보다 '높은 최소값'으로 설정할 수 없다.
--	  감소 : 현재 들어있는 값보다 '낮은 최대값'으로 설정할 수 없다.
--	  (예) 최대값 10000 시작하여 10씩 감소 (10000->9990->9980)
--		 -> 최대값 5000으로 변경하면 5000보다 큰 이미 추가된 값들이 무효화되므로...

ALTER sequence 시퀀스명--시퀀스도 DDL(=데이터 정의어)문이므로 ALTER문으로 수정 가능!
--[start with 시퀀스 시작숫자]--시퀀스 수정 시 사용불가함. CREATE sequence에서만 사용
[increment by 증감숫자] --증감숫자가 양수면 증가, 음수면 감소 (기본값 : 1)

[minvalue 최소값 | nominvalue(기본값)] --nominvalue(기본값) : 증가일 때 1, 감소일 때 -10의 26승까지
								   --minvalue 최소값 : 최소값 설정, 시작숫자보다 같거나 작아야 하고 maxvalue(최대값)보다 작아야 함
                                   
[maxvalue 최대값 | nomaxvalue(기본값)] --nomaxvalue(기본값) : 증가일 때 10의 27승까지, 감소일 때 -1까지
							       --maxvalue 최대값 : 최대값 설정, 시작숫자와 같거나 커야 하고 minvalue(최소값)보다 커야 함

[cycle | nocycle(기본값)] -- cycle : 최대값까지 증가 후 최소값으로 다시 시작
						-- nocycle : 최대값까지 증가 후 그 다음 시퀀스를 발급받으려면 에러 발생

[cache n | nocache]		-- cache n : 메모리상에 시퀀스 값을 미리 할당(기본값은 20)
						-- nocache : 메모리상에 시퀀스 값을 미리 할당하지 않음(관리X)

[order | noorder(기본값)] -- order : 병렬서버(여러 DB서버가 연결된 구조)를 사용할 경우 요청 순서에 따라 정확하게 시퀀스를 생성하기를 원할 때 order로 지정
						-- 		   단일서버일 경우 이 옵션과 관계없이 정확히 요청 순서에 따라 시퀀스가 생성됨.
						-- noorder(기본값)
;


select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequences --	1		1E-28=10E+27	10				N		  20
where sequence_name IN UPPER('dno_seq'); --대문자

--최대값을 50으로 수정
ALTER sequence dno_seq
maxvalue 50;
--최대값 확인
select sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size
from user_sequences --	1		   50			10				N		  20
where sequence_name IN UPPER('dno_seq'); --대문자

insert into dept12 values(dno_seq.nextval, 'COMPUTING', 'SEOUL'); --50
insert into dept12 values(dno_seq.nextval, 'COMPUTING', 'DAEGU'); --60 실패 : 최대값이 50이고 nocycle이므로

select * from dept12;

--60 추가하고 싶으면 : 최대값을 수정, 시퀀스 제거 -> 60추가 가능
--[방법-1]
ALTER sequence dno_seq
maxvalue 60;

insert into dept12 values(dno_seq.nextval, 'COMPUTING', 'DAEGU'); --60 추가 성공

--[방법-2]
DROP sequence dno_seq; --시퀀스 제거
insert into dept12 values(70, 'COMPUTING', 'BUSAN');--70 추가 성공

CREATE sequence dno_seq; --옵션 없이 시퀀스 생성하면 옵션의 값은 기본값으로 셋팅(1로 시작하여 1씩 증가)
insert into dept12 values(dno_seq.nextval, 'COMPUTING', 'DAEJEON');

select * from dept12;

delete from dept12 where loc = 'DAEJEON';
select * from dept12;

ALTER sequence dno_seq
--start with 80 -- 오류?ORA-02283: 시작값 수정 불가 (cannot alter starting sequence number)
increment by 10;

--오류 해결위해
DROP sequence dno_seq; --시퀀스 제거
CREATE sequence dno_seq --다시 생성
start with 80 --시작 숫자 80
increment by 10;

insert into dept12 values(dno_seq.nextval, 'COMPUTING', 'DAEJEON'); --80 추가
select * from dept12;

------------------------------------------------------------------------------------
--3. 인덱스 : DB 테이블에 대한 검색 속도를 향상시켜주는 자료 구조
--			특정 컬럼에 인덱스를 생성하면 해당 컬럼이 데이터들을 "정렬"하여 별도의 메모리 공간에 데이터의 물리적 주소와 함께 저장됨

			<index>						<table>
		 Data	 Location			Location	Data
('김' 찾기) 김		  1					1			 김					
쿼리실행->   김		  3					2			 이
		  김		  1000				3			 김
		  							4			 박
		  이		  2							
		  
		  박		  4
									...
									1000		 김

--			사용자의 필요에 의해서 직접 생성할 수도 있지만
--			데이터 무결성을 확인하기 위해서 수시로 데이터를 검색하는 용도로 사용되는
--			'기본키'나 '유일키(unique)'는 index 자동 생성됨
--USER_indexes 나 USER_IND_columns(컬럼이름까지 검색가능) 데이터 사전에서 index 객체 확인 가능

--index 생성 : CREATE INDEX 인덱스명 ON 테이블명(컬럼1, 컬럼2, 컬럼3...);
--index 삭제 : DROP INDEX 인덱스명;

/*
<index 생성 전략>
생성된 인덱스를 가장 효율적으로 사용하려면 데이터의 분포도는 최대한으로
그리고 조건절에 호출 빈도는 자주 사용되는 컬럼을 index로 생성하는 것이 좋다. 
인덱스는 특정 컬럼을 기준으로 생성하고 기준이 된 컬럼으로 '정렬된 index 테이블'이 생성됨
이 기준 컬럼은 최대한 중복이 되지 않는 것이 좋다.
가장 최선은 PK로 index를 생성하는 것이다.

1. 조건절에 자주 등장하는 컬럼
2. 항상 =으로 비교되는 컬럼
3. 중복되는 데이터가 최소한인 컬럼
4. order by절에서 자주 사용되는 컬럼
5. 조인 조건으로 자주 사용되는 컬럼
 */

--두 테이블에 자동으로 생성된 index 살피기
select index_name, table_name, column_name
from user_IND_columns--column_name 검색가능함
where table_name in ('EMPLOYEE','DEPARTMENT');
--column_name : ENO, DNO (둘 다 PK->자동 index 생성됨)

select index_name, table_name --, column_name
from user_indexes --column_name 검색불가
where table_name in ('EMPLOYEE','DEPARTMENT');

--사용자가 직접 index 생성
CREATE INDEX idx_employee_ename
ON employee(ename);

--확인
select index_name, table_name, column_name
from user_IND_columns
where table_name in ('EMPLOYEE');

--※ 하나의 테이블에 index가 많으면 DB 성능에 좋지 않은 영향을 미칠 수 있다. -> index 제거
DROP INDEX idx_employee_ename;

--확인
select index_name, table_name, column_name
from user_IND_columns
where table_name in ('EMPLOYEE');

--------------------------------------------------------------------------------------------------

--교재 299p
--인덱스 내부구조는 B-Tree(Balanced Tree=균형트리)으로 구성되어 있음
--컬럼에 인덱스를 설정하면 이를 B-Tree도 생성되어야 하기 때문에
--인덱스 생성 위한 시간도 필요하고 인덱스를 위한 추가공간도 필요

--인덱스 생성 후에 새로운 행을 추가하거나 삭제할 경우
--인덱스로 사용된 컬럼값도 함께 변경 -> 내부구조(B-Tree)도 함께 변경
--오라클 서버가 이 작업을 자동으로 발생하므로 인덱스가 있는 경우의 DML 작업이 훨씬 무거워짐
--계획성 없이 너무 많은 인덱스를 지정하면 오히려 성능을 저하시킬 수 있다.

--최대 3개의 자식을 갖는 B-Tree에서 3을 찾는다면 (4 2 6 1 3 5 7)
--					4(root = 뿌리)노드
--				2			6
--			1	  3		5		7

--300p 표 정리
--<index 사용해야 하는 경우>
--테이블의 행 수 많을 때
--where문에 해당 컬럼이 많이 사용될 때
--검색결과가 전체 데이터의 "2%~4% 정도"일 때
--join에 자주 사용되는 컬럼이나 null을 포함하는 컬럼이 많을 때

--<index 사용하지 말아야 하는 경우>
--테이블의 행 수 적을 때
--where문에 해당 컬럼이 자주 사용되지 않을 때
--검색결과가 전체 데이터의 "10%~15% 이상"일 때 (예)10%~100%
--테이블에 DML 작업이 많은 경우, 즉 입력/수정/삭제 등이 자주 일어날 때
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--★ 교재 이외 내용
--실습을 위해
create table emp12
AS
select *
from employee; --제약조건은 복사안됨

--<index 사용해야 하는 경우 1 2 3>에 대한 예
select ename
from emp12
where dno=10;

--쿼리문의 조건이
--1. 테이블 전체 행의 수 : 100000건
--2. 위 쿼리문이 전체 쿼리문 중에서 95% 사용됨
--3. 쿼리문의 결과로 구해지는 행 : 2000건 정도라면 dno 컬럼은 인덱스를 사용하는 것이 효율적이다.
--						  검색결과가 전체 데이터의 2~4% 정도이므로 인덱스가 있어야 검색을 빨리 할 수 있으므로


--인덱스가 생성된 후에 새로운 행이 추가, 수정, 삭제 작업이 잦으면
--node의 갱신이 주기적으로 일어나 '단편화' 현상 발생
--※ 단편화? 삭제된 레코드의 인덱스 값 자리가 비게 되는 현상
-- -> 검색 성능 저하
--따라서
ALTER INDEX inx_employee_ename rebuild; --인덱스 다시 생성하여
--기존의 단편화가 많은 인덱스를 버리는 작업을 해주어야만 빠른 효율을 누릴 수 있다.

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

--4. 인덱스 종류(301p~)
--4.1 고유/비고유 인덱스
--고유 인덱스 : 기본키(unique + not null)나 유일키(unique)처럼 유일한 값을 갖는 컬럼에 생성된 인덱스
--			unique 있으면 (예)부서테이블의 부서번호
--			★★특정 컬럼에 고유 인덱스가 지정되려면 추가한 데이터에 중복된 값이 있어서는 안됨

--비고유 인덱스 : 중복된 데이터를 갖는 컬럼에 생성된 인덱스
--			  unique 없으면 (예)부서테이블의 부서명이나 지역명

create UNIQUE index 인덱스명
ON 테이블명(컬럼명);

--실습위해 'dept12테이블' 사용 : 제약조건은 복사안되어 있음. 따라서 PK 제약조건 이미 추가함
--dno에 고유 인덱스 지정하기
create UNIQUE index idx_dept12_dno
ON dept12(dno);
--실패? ORA-01408: such column list already indexed
--이유 : 위에서 '기본키 제약조건 추가' 하면서 자동 index 생성되었으므로

--[방법-1] 자동 생성된 dno의 index를 찾아서 제거 => 실패
select index_name, table_name, column_name
from user_ind_columns
where table_name IN ('DEPT12');

drop index dept12_dno_pk; --실패:ORA-02429: cannot drop index used for enforcement of unique/primary key

--[방법-2] dno의 '기본키 제약조건'을 찾아 제거 후 -> 다시 dno에 고유 인덱스 지정하기 => 성공
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT12');
--index_name과 constraint_name이 동일하다. (기본키는 자동으로 index가 생성되기 때문)
ALTER table dept12
DROP constraint DEPT12_DNO_PK cascade;

--다시 dno에 고유 인덱스 지정하기 => 성공
create UNIQUE index idx_dept12_dno
ON dept12(dno);

--★★특정 컬럼에 고유 인덱스가 지정되려면 추가한 데이터에 중복된 값이 있어서는 안됨

create UNIQUE index idx_dept12_loc
ON dept12(loc);
--만약 오류가 발생한다면 중복된 데이터가 있기 때문...
--(예) 실습위해 dept12_2 테이블 복사
--drop table dept12_2;
create table dept12_2
AS
select * from department;
--테이블 구조와 데이터 복사(단, 제약조건 복사안됨-dno는 PK가 아님)

select * from dept12_2;
insert into dept12_2 values(10, 'ACCOUNTING', 'SEOUL');
--성공?dno가 기본키가 아니므로 중복된 10 입력가능 - dno는 현재 10 중복, loc는 중복된 값이 없음

--dno에 고유 인덱스 지정하기
create UNIQUE index idx_dept12_2_dno
ON dept12_2(dno);
--실패 : cannot CREATE UNIQUE INDEX; duplicate keys found

--loc에 고유 인덱스 지정하기
create UNIQUE index idx_dept12__2_loc
ON dept12_2(loc);
--성공 : loc는 중복된 값이 없으므로

------------------------------지금까지 생성한 인덱스는 '단순 인덱스'(한 개의 컬럼으로 구성한 인덱스) -------------------

--4.2 결합 인덱스 : 두 개 이상의 컬럼으로 구성한 인덱스
create index idx_dept12_2_complex
ON dept12_2(dname, loc);

--idx_dept12_2_complex 인덱스를 이용하여 검색속도를 높이는데 사용되는 예
--즉, 언제 idx_dept12_2_complex 인덱스를 이용하여 검색속도를 높이느냐...
select *
from dept12_2
where dname=' ', loc=' ';
--그런데 위 쿼리가 거의 사용되지 않는다면 오히려 성능 저하 발생

select *
from dept12_2
where dname=' ';
--dname에 index가 없다면
--dname, loc를 결합하여 생성한 idx_dept12_2_complex 인덱스를 사용하여 검색
--따라서 전체 테이블 검색보다 더 효율적임

--4.3 함수 기반 인덱스 : 수식이나 함수를 적용하여 만든 인덱스
create index idx_emp12_salary12
ON emp12(salary * 12); --'수식'이므로 컬럼명이 없어서 '가상컬럼' 생성됨

select index_name, column_name
from user_ind_columns
where table_name in ('EMP12'); --column_name은 SYS_NC00009$(가상컬럼)

