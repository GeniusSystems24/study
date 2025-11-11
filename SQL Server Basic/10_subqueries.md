# 10. الاستعلامات الفرعية (Subqueries)

## Subquery في WHERE

```sql
-- الموظفون براتب أعلى من المتوسط
SELECT FirstName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- الموظفون في نفس قسم أحمد
SELECT FirstName, DepartmentID
FROM Employees
WHERE DepartmentID = (
    SELECT DepartmentID 
    FROM Employees 
    WHERE FirstName = N'أحمد'
);
```

## Subquery مع IN

```sql
-- الموظفون في الأقسام النشطة
SELECT FirstName, DepartmentID
FROM Employees
WHERE DepartmentID IN (
    SELECT DepartmentID 
    FROM Departments 
    WHERE IsActive = 1
);
```

## Subquery مع EXISTS

```sql
-- الأقسام التي بها موظفون
SELECT DepartmentName
FROM Departments D
WHERE EXISTS (
    SELECT 1 
    FROM Employees E 
    WHERE E.DepartmentID = D.DepartmentID
);

-- الأقسام الفارغة (NOT EXISTS)
SELECT DepartmentName
FROM Departments D
WHERE NOT EXISTS (
    SELECT 1 
    FROM Employees E 
    WHERE E.DepartmentID = D.DepartmentID
);
```

## Subquery في SELECT

```sql
-- عرض عدد الموظفين مع كل قسم
SELECT 
    DepartmentName,
    (SELECT COUNT(*) 
     FROM Employees E 
     WHERE E.DepartmentID = D.DepartmentID) AS عدد_الموظفين
FROM Departments D;
```

## Subquery في FROM

```sql
-- الأقسام بمتوسط راتب أعلى من 5000
SELECT *
FROM (
    SELECT 
        DepartmentID,
        AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) AS DeptSalaries
WHERE AvgSalary > 5000;
```

## Correlated Subquery

```sql
-- الموظفون براتب أعلى من متوسط قسمهم
SELECT E1.FirstName, E1.Salary, E1.DepartmentID
FROM Employees E1
WHERE E1.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employees E2
    WHERE E2.DepartmentID = E1.DepartmentID
);
```

---

[⬅️ السابق: GROUP BY](09_groupby.md)
 [التالي: Indexes ⬅️](11_indexes.md)
 [🏠 الفهرس](README.md)
