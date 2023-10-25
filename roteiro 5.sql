-- 1. Retornar quantas funcionárias estão cadastradas
SELECT COUNT(*) FROM employee WHERE sex = 'F';
-- 2. Retornar a média de salário dos funcionários homens que moram no estado do Texas(TX)
SELECT AVG (Salary) FROM employee WHERE sex = 'M'and address LIKE '%TX%';

-- 3. Retornar os ssn dos supervisores e a quantidade de funcionários  que cada um deles supervisiona (contar também  os que não são supervisionados por ninguem - veja a ultima linha do resultado). Ordenar o resultado pela quantidade.
SELECT superssn AS ssn_supervisor, COUNT(*) as qtd_supervisionados 
FROM employee 
GROUP BY superssn 
ORDER BY qtd_supervisionados;

-- 4. Para cada funcionário que supervisiona alguém, retornar seu nome e a quantidade de funcionários que supervisiona. O resultado deve ser ordenado pela quantidade de funcionarios supervisionados. A consulta NÃO deve ter clásula WHERE. 
SELECT s.fname AS nome_supervisor, COUNT(*) as qtd_supervisionados 
FROM employee AS e INNER JOIN employee AS s ON e.superssn = s.ssn 
GROUP BY s.fname 
ORDER BY qtd_supervisionados;

--5. Faça uma consulta equivalente a anterior,  porém considerando os funcionários que não possuem supervisor (note que o resultado possui uma linha a mais do que o resultado da anterior). Esta consulta também NÃO deve ter clásula WHERE. Não é necessário ordenar o resultado.
SELECT s.fname AS nome_supervisor, COUNT(*) as qtd_supervisionados 
FROM employee AS e LEFT JOIN employee AS s ON e.superssn = s.ssn 
GROUP BY s.fname;

-- 6. Retornar a quantidade de funcionários que trabalham no(s) projeto(s) que contém menos funcionários.
 SELECT MIN(qtd) AS qtd FROM (SELECT COUNT(*) as qtd 
 FROM works_on 
 GROUP BY pno AS quantidade;

-- 7. Faça uma consulta equivalenta a anterior, porém, retorne tb o numero do projeto. 
 SELECT COUNT(*) AS qtd_func, pno AS num_projeto 
 FROM works_on 
 GROUP BY pno 
 HAVING COUNT(*) = (SELECT MIN(qtd) AS qtd FROM (SELECT COUNT(*) as qtd FROM works_on GROUP BY pno) AS quantidade);

-- 8. Retorne a média salarial por projeto
SELECT w.pno AS num_proj, AVG(e.salary) AS media_sal FROM employee AS e, works_on as w WHERE e.ssn=w.essn GROUP BY w.pno;

-- 9. Altere a consulta anterior para retornar também os nomes dos projetos
SELECT proj_num, p.pname AS proj_name, media_sal FROM project AS p INNER JOIN (SELECT w.pno AS proj_num, AVG(e.salary) AS media_sal FROM employee AS e, works_on as w WHERE e.ssn=w.essn GROUP BY w.pno) AS foo ON foo.proj_num=p.pnumber; 

10. SELECT fname, salary FROM employee WHERE salary > (SELECT MAX(e.salary) FROM employee AS e, works_on AS w WHERE e.ssn=w.essn AND w.pno = 92);
-- Retorna a o valor do maior salario do projeto 92: (SELECT MAX(e.salary) FROM employee AS e, works_on AS w WHERE e.ssn=w.essn AND w.pno = 92);
 
-- 11. Retornar a quantidade de projetos por funcionário, ordenando pela quantidade
SELECT e.ssn AS ssn, COUNT(w.pno) AS qtd_proj FROM works_on AS w RIGHT OUTER JOIN employee AS e ON w.essn=e.ssn GROUP BY e.ssn ORDER BY qtd_proj; 

-- 12. Retornar a quantidade de funcionários por projeto (incluindo os funcionários "sem projeto"). Retornar apenas os projetos que possuem menos de 5 funcionários. Ordenar pela quantidade
SELECT w.pno AS num_proj, COUNT(e.ssn) AS qtd_func FROM works_on AS w RIGHT OUTER JOIN EMPLOYEE as e ON w.essn=e.ssn GROUP BY w.pno HAVING COUNT (w.essn) < 5 ORDER BY COUNT(w.essn);
-- vai ser outer porque precisa retornar os funcionarios sem projetos, e pra retornar os que nao estao ligados a um projeto, ou seja, que não entram na cond de juncao, faz o RIGHT OUTER JOIN de EMPLOYEE R WORKS_ON.

-- 13. Usando consultas aninhadas e sem usar junções (nem mesmo as junções feitas com produto cartesiano + filtragem usando cláusula WHERE), formule
-- uma consulta para retornar os primeiros nomes dos funcionários que trabalham no(s) projeto(s) localizado(s) em Sugarland e que possuem dependentes. 

SELECT fname FROM employee WHERE ssn IN ((SELECT essn FROM works_on WHERE pno IN (SELECT pnumber FROM project WHERE plocation LIKE '%Sugarland%')) INTERSECT (SELECT ssn FROM employee WHERE ssn IN (SELECT essn FROM dependent))) 

--(SELECT pnumber FROM project WHERE p.plocation LIKE '%Sugarland%'); -> retorna o numero dos projetos que tem como localizacao em Sugarland
--(SELECT essn FROM dependent) -> retorna todos os ssn que tem dependentes

-- 14. Sem usar IN e sem usar nenhum tipo de junção (nem mesmo as junções feitas com produto cartesiano + filtragem usando clausula WHERE), 
-- formule uma consulta para retornar o(s) departamentos que não possuem projetos. Não é proibido que a consulta contenha uma cláusula WHERE.

(SELECT dnumber FROM department) EXCEPT (SELECT dnum FROM project); -- retorna o numero do departamento que nao tem projeto

SELECT dname FROM department WHERE dnumber =ANY (SELECT dnumber FROM department) EXCEPT (SELECT dnum FROM project);

SELECT d.dname FROM department AS d WHERE NOT EXISTS (SELECT p.dnum FROM project AS p WHERE p.dnum=d.dnumber);


-- 15. Retornar o primeiro e o ultimo nome do(s) funcionario(s) que trabalham em todos os projetos em que trabalha o funcionário com ssn 123456789
-- Listar o nome dos empregados os quais não trabalham em projetos que não são os que o funcionário do ssn 123456789 trabalha

SELECT e.fname, e.lname 
FROM employee AS e
WHERE NOT EXISTS ((SELECT w.pno FROM works_on AS w WHERE essn='123456789') EXCEPT (SELECT w.pno FROM works_on AS w WHERE w.essn=e.ssn AND NOT w.essn='123456789'));-- retorna o primeiro e o ultimo nome dos funcionarios

SELECT w.pno FROM works_on AS w WHERE essn='123456789'; -- retorna o numero dos projetos que o funcionario trabalha