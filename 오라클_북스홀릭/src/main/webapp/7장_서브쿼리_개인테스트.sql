--7�� ȥ���غ��� �ٽ� Ǯ���

--<7��.��������-ȥ���غ���>----------------------------------
--1.�����ȣ�� 7788�� ����� '�������� ����' ����� ǥ��(����̸��� ������)
--[1] �����ȣ�� 7788�� ����� ������
select job
from EMPLOYEE
where eno = 7788;

--[2] �������� ANALYST�� ��� ǥ��, �����ȣ 7788 ��� ����
select ename, job
from employee
where job IN (select job
				from EMPLOYEE
				where eno = 7788)
AND eno <> 7788;

--2.�����ȣ�� 7499�� ������� �޿��� ���� ����� ǥ��(����̸��� ������)
--[1] �����ȣ 7499�� �޿�
select salary
from employee
where eno = 7499;

--[2] 7499���� �޿� ���� ����� (����̸�, ������)
select ename, job
from employee
where salary > (select salary
				from employee
				where eno = 7499);

--3.�ּұ޿��� �޴� ����� �̸�, ��� ���� �� �޿� ǥ��(�׷��Լ� ���)
--[1]�ּұ޿�
select min(salary)
from employee;

--[2]�ּұ޿� �޴� ��� ���ϱ� (��� �̸�, ������, �޿� ǥ��)
select ename, job, salary
from employee
where salary = (select min(salary)
				from employee);
				
--4.'���޺�' ��� �޿��� ���� ���� ��� ������ ã�� '����(job)'�� '��� �޿�' ǥ��
--��, ����� �ּұ޿��� �ݿø��Ͽ� �Ҽ�1°�ڸ����� ǥ��
--[1] ���޺� ����� �ּұ޿�
select min(avg(salary))
from employee
group by job;

--[2] ��� �޿��� ���� ���� ��� ������ ��� �޿�
select job, ROUND(avg(salary), 1) as "��� �޿�"
from employee
group by job
having avg(salary) IN (select min(avg(salary))
						from employee
						group by job);
				
--5.�� �μ��� �ּ� �޿��� �޴� ����� �̸�, �޿�, �μ� ��ȣ ǥ��
--[1] �� �μ��� �ּ� �޿�
select dno, min(salary)
from employee
group by dno;

--[2]�μ� �� �ּ� �޿� �޴� ��� ���ϱ� (��� �̸�, �޿� , �μ� ��ȣ)
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, min(salary)
						from employee
						group by dno)
ORDER by dno asc;
						
--6.'��� ������ �м���(ANALYST)�� ������� �޿��� �����鼭 ������ �м����� �ƴ�' 
--������� ǥ��(�����ȣ, �̸�, ��� ����, �޿�)
--[1]��� ������ 'ANALYST' �� ����� �޿�
select salary
from employee
where job = 'ANALYST';

--[2]��� ������ 'ANALYST'�� ������� �޿��� �����鼭 ������ 'ANALYST'�� �ƴ� ��� ���ϱ�(�����ȣ, �̸�, ��� ����, �޿�)
select

--�ڡ�7.���������� ���� ����̸� ǥ��(���� '���� 8. ���������� �ִ� ����̸� ǥ��'���� Ǯ��)

--�ڡ�8.���������� �ִ� ����̸� ǥ��

--9.BLAKE�� ������ �μ��� ���� ����̸��� �Ի����� ǥ��(��,BLAKE�� ����)

--10.�޿��� ��� �޿����� ���� ������� �����ȣ�� �̸� ǥ��(����� �޿��� ���� �������� ����)

--11.�̸��� K�� ���Ե� ����� ���� �μ����� ���ϴ� ����� �����ȣ�� �̸� ǥ��

--12.�μ���ġ�� DALLAS�� ����̸��� �μ���ȣ �� ��� ���� ǥ��

--[����-1]
--[12�� ���湮��]. �μ���ġ�� DALLAS�� ����̸�, �μ���ȣ, ��� ����, + '�μ���ġ' ǥ�� 

--13.KING���� �����ϴ� ����̸��� �޿� ǥ��

--14.RESEARCH �μ��� ����� ���� �μ���ȣ, ����̸�, ��� ���� ǥ��

--15.��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ��ϴ� 
--�����ȣ,�̸�,�޿� ǥ��

--16.��� �޿��� ���� ���� ������ �� ��ձ޿� ǥ��

--17.��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ��� ����̸� ǥ��