--<12�� �������� �ε���-ȥ�� �غ���>---------------------

/*
 * 1.��� ���̺��� �����ȣ�� �ڵ����� �����ǵ��� �������� �����Ͻÿ�.
 */
create sequence seq_emp01_no
start with 1000
increment by 1
maxvalue 2000;

/*
 * 2.EMP01 ���̺��� �����Ͻÿ�.
 * (�����ȣ NUMBER(4) �⺻Ű, ����̸� VARCHAR2(10), ������)
 * �����ȣ�� �������κ��� �߱޹����ÿ�.
 */
create table emp01 (
	�����ȣ number(4) primary key,
	����̸� varchar2(10),
	������ date
);

insert into emp01 values(seq_emp01_no.nextval, 'ȫ�浿', '2022/09/01');
insert into emp01 values(seq_emp01_no.nextval, '�̼���', '2022/08/01');
insert into emp01 values(seq_emp01_no.nextval, '�����', '2022/07/01');

select * from emp01;

/*
 * 3.EMP01 ���̺��� �̸� �÷��� �ε����� �����ϵ� �ε��� �̸��� IDX_EMP01_ENAME�� �����Ͻÿ�.
 */
create index idx_emp01_ename
ON emp01(����̸�);

select index_name, column_name
from user_ind_columns
where table_name in ('EMP01');

