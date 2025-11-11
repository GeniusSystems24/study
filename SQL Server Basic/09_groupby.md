# 9. التجميع والتصنيف (GROUP BY & Aggregates)

## GROUP BY الأساسي

```sql
-- عدد الموظفين في كل قسم
SELECT 
    DepartmentID,
    COUNT(*) AS عدد_الموظفين
FROM Employees
GROUP BY DepartmentID;
```

## الدوال التجميعية

```sql
-- إحصائيات الرواتب حسب القسم
SELECT 
    DepartmentID,
    COUNT(*) AS العدد,
    SUM(Salary) AS مجموع_الرواتب,
    AVG(Salary) AS متوسط_الراتب,
    MIN(Salary) AS أقل_راتب,
    MAX(Salary) AS أعلى_راتب
FROM Employees
GROUP BY DepartmentID;
```

## GROUP BY مع JOIN

```sql
-- عدد الموظفين في كل قسم مع اسم القسم
SELECT 
    D.DepartmentName,
    COUNT(E.EmployeeID) AS عدد_الموظفين,
    AVG(E.Salary) AS متوسط_الراتب
FROM Departments D
LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;
```

## HAVING (التصفية بعد التجميع)

```sql
-- الأقسام التي بها أكثر من 5 موظفين
SELECT 
    DepartmentID,
    COUNT(*) AS العدد
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 5;

-- الأقسام بمتوسط راتب أكبر من 6000
SELECT 
    DepartmentID,
    AVG(Salary) AS متوسط_الراتب
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 6000;
```

## GROUP BY مع أعمدة متعددة

```sql
-- التجميع حسب القسم والوظيفة
SELECT 
    DepartmentID,
    JobTitle,
    COUNT(*) AS العدد,
    AVG(Salary) AS المتوسط
FROM Employees
GROUP BY DepartmentID, JobTitle
ORDER BY DepartmentID, JobTitle;
```

## ترتيب الأوامر

```sql
SELECT 
    DepartmentID,
    COUNT(*) AS العدد
FROM Employees
WHERE IsActive = 1           -- 1. WHERE (تصفية قبل التجميع)
GROUP BY DepartmentID        -- 2. GROUP BY (التجميع)
HAVING COUNT(*) > 3          -- 3. HAVING (تصفية بعد التجميع)
ORDER BY COUNT(*) DESC;      -- 4. ORDER BY (الترتيب)
```

## أمثلة عملية

```sql
-- إجمالي المبيعات حسب الفئة
SELECT 
    C.CategoryName,
    COUNT(DISTINCT O.OrderID) AS عدد_الطلبات,
    SUM(OD.Quantity) AS الكمية_المباعة,
    SUM(OD.Quantity * OD.UnitPrice) AS إجمالي_المبيعات
FROM Categories C
INNER JOIN Products P ON C.CategoryID = P.CategoryID
INNER JOIN OrderDetails OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.OrderDate >= '2025-01-01'
GROUP BY C.CategoryName
HAVING SUM(OD.Quantity * OD.UnitPrice) > 10000
ORDER BY إجمالي_المبيعات DESC;
```

---

[⬅️ السابق: JOINs](08_joins.md)
 [التالي: Subqueries ⬅️](10_subqueries.md)
 [🏠 الفهرس](README.md)
