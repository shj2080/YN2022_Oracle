--���̺� ����
drop table department;

--�ܷ�Ű(����Ű) �������� ���� �� ����
drop table department cascade constraints;

select * from employee;
select * from department;

--�ܷ�Ű �������� ����
alter table employee
modify dno number(2) REFERENCES department;

--[�ذ��� ����] '�����ȣ�� 7788'�� ����� �Ҽӵ� '�����ȣ, ����̸�, �ҼӺμ���ȣ, �ҼӺμ��̸�' ���
select eno, ename, e.dno, dname
from employee e, department d
where e.dno = d.dno --��������
AND eno = 7788; --�˻�����

select eno, ename, e.dno, dname
from employee e JOIN department d
ON e.dno = d.dno --��������
where eno = 7788; --�˻�����

select eno, ename, dno, dname
from employee natural JOIN department
where eno = 7788;

select eno, ename, dno, dname
from employee JOIN department
USING(dno)
where eno = 7788;




select e.dno
from employee e
where NOT EXISTS (select dno
			 from department d
			 where e.dno = d.dno)
AND e.dno IS NOT NULL;

delete employee
where dno = (select e.dno
			from employee e
			where NOT EXISTS (select dno
						 from department d
						 where e.dno = d.dno)
			AND e.dno IS NOT NULL);
			

			
			
			
			
select * from employee;

