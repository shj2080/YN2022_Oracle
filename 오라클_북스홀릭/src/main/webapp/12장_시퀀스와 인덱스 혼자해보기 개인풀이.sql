--<12장 시퀀스와 인덱스-혼자 해보기>---------------------

/*
 * 1.사원 테이블의 사원번호가 자동으로 생성되도록 시퀀스를 생성하시오.
 */
create sequence seq_emp01_no
start with 1000
increment by 1
maxvalue 2000;

/*
 * 2.EMP01 테이블을 생성하시오.
 * (사원번호 NUMBER(4) 기본키, 사원이름 VARCHAR2(10), 가입일)
 * 사원번호를 시퀀스로부터 발급받으시오.
 */
create table emp01 (
	사원번호 number(4) primary key,
	사원이름 varchar2(10),
	가입일 date
);

insert into emp01 values(seq_emp01_no.nextval, '홍길동', '2022/09/01');
insert into emp01 values(seq_emp01_no.nextval, '이순신', '2022/08/01');
insert into emp01 values(seq_emp01_no.nextval, '이재용', '2022/07/01');

select * from emp01;

/*
 * 3.EMP01 테이블의 이름 컬럼을 인덱스로 설정하되 인덱스 이름을 IDX_EMP01_ENAME로 지정하시오.
 */
create index idx_emp01_ename
ON emp01(사원이름);

select index_name, column_name
from user_ind_columns
where table_name in ('EMP01');

