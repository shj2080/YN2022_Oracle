--<10�� ������ ���Ἲ�� ��������-ȥ�� �غ���>
--1.employee���̺��� ������ �����Ͽ� emp_sample ���̺� ����
--��� ���̺��� �����ȣ �÷��� ���̺� ������ primary key ���������� �����ϵ�
--�������Ǹ��� my_emp_pk�� ����
--[1] ���̺� ������ �����ͼ� ���̺� ����
create table emp_sample
AS
select * from employee
where 1=0;

--[2] �������� �߰�
alter table emp_sample
add constraint my_emp_pk primary key(eno);

--[3] �������� Ȯ��
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE');
--2.�μ����̺��� �μ���ȣ �÷��� ���̺� ������ primary key �������� �����ϵ�
--�������Ǹ��� my_dept_pk�� ����
/* �μ����̺��� ���纻 ����
create table dept_sample
AS
select * from DEPARTMENT
where 1=0;
*/

alter table dept_sample
add constraint my_dept_pk primary key(dno);


--3.������̺��� �μ���ȣ �÷��� �������� �ʴ� �μ��� ����� �������� �ʵ���
--�ܷ�Ű(=����Ű) ��������(=���� ���Ἲ)�� �����ϵ�
--���� ���� �̸��� my_emp_dept_fk�� ����
--[1] �������� �߰�
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);

--[2] �������� Ȯ��
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE', 'DEPT_SAMPLE');


--4.��� ���̺��� Ŀ�̼� �÷��� 0���� ū ���� �Է��� �� �ֵ��� �������� ����
--[1] �������� �߰�
alter table emp_sample
add constraint �������Ǹ� check(commission > 0);

ALTER TABLE emp_sample
modify commission CHECK(commission > 0);

--[2] �������� Ȯ��
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE', 'DEPT_SAMPLE');

