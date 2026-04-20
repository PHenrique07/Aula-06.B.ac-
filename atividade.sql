
--1)
-- permissões para INSTRUCTOR (exceto salary)
GRANT SELECT (ID, name, dept_name) ON dbo.instructor TO User_B;

-- permissões para TAKES (exceto grade)
GRANT SELECT (ID, course_id, sec_id, semester, year) ON dbo.takes TO User_B;
GO

--2) 
--o User_C pode recuperar e modificar apenas quatro colunas específicas da tabela SECTION
GRANT SELECT (course_id, sec_id, semester, year), 
      UPDATE (course_id, sec_id, semester, year) 
ON dbo.section TO User_C;
GO

--3)
--view grade_points
GO
CREATE OR ALTER VIEW dbo.grade_points AS
SELECT ID, course_id, sec_id, semester, year, grade, 
       CASE WHEN grade = 'A' THEN 4.0 WHEN grade = 'B' THEN 3.0 ELSE 0.0 END AS points
FROM dbo.takes;
GO

GRANT SELECT ON dbo.instructor TO User_D;
GRANT SELECT ON dbo.student TO User_D;
GRANT SELECT ON dbo.grade_points TO User_D;
GO

--4)
-- criação da View que filtra os dados
GO
CREATE OR ALTER VIEW dbo.view_student_civil AS
SELECT * FROM dbo.student
WHERE dept_name = 'Civil Eng.';
GO

-- permissão de SELECT na View para o User_E
GRANT SELECT ON dbo.view_student_civil TO User_E;
GO

--5) 
--remover tudo do User_E
REVOKE SELECT ON dbo.view_student_civil FROM User_E;
GO

--6)
SELECT 
    princ.name AS Usuario,
    princ.type_desc AS Tipo_Usuario,
    perm.permission_name AS Permissao,
    perm.state_desc AS Estado,
    object_name(perm.major_id) AS Nome_do_Objeto,
    col_name(perm.major_id, perm.minor_id) AS Nome_da_Coluna
FROM sys.database_principals princ
LEFT JOIN sys.database_permissions perm ON perm.grantee_principal_id = princ.principal_id
WHERE princ.name IN ('User_A', 'User_B', 'User_C', 'User_D', 'User_E')
ORDER BY princ.name, Nome_do_Objeto;
GO