# 18. Views (العروض)

## ما هي View؟

عرض (View) هو استعلام محفوظ يظهر كجدول افتراضي.

## إنشاء View بسيطة

```sql
CREATE VIEW vw_ActiveEmployees
AS
SELECT EmployeeID, FirstName, LastName, Email, Salary
FROM Employees
WHERE IsActive = 1;

-- الاستخدام
SELECT * FROM vw_ActiveEmployees;
```

## View مع JOIN

```sql
CREATE VIEW vw_EmployeeDepartments
AS
SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    D.DepartmentName,
    E.Salary
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;

-- الاستخدام
SELECT * FROM vw_EmployeeDepartments
WHERE DepartmentName = N'تقنية المعلومات';
```

## View مع حسابات

```sql
CREATE VIEW vw_EmployeeSalaries
AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    Salary * 12 AS AnnualSalary,
    Salary * 0.10 AS MonthlyTax
FROM Employees;
```

## View مع GROUP BY

```sql
CREATE VIEW vw_DepartmentStatistics
AS
SELECT 
    D.DepartmentName,
    COUNT(E.EmployeeID) AS EmployeeCount,
    AVG(E.Salary) AS AvgSalary,
    SUM(E.Salary) AS TotalSalary
FROM Departments D
LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;
```

## تعديل View

```sql
ALTER VIEW vw_ActiveEmployees
AS
SELECT EmployeeID, FirstName, LastName, Email
FROM Employees
WHERE IsActive = 1 AND HireDate >= '2020-01-01';
```

## حذف View

```sql
DROP VIEW vw_ActiveEmployees;
```

## Indexed View (View مفهرسة)

```sql
-- إنشاء View
CREATE VIEW vw_ProductSales
WITH SCHEMABINDING
AS
SELECT 
    P.ProductID,
    P.ProductName,
    SUM(OD.Quantity) AS TotalQuantity,
    COUNT_BIG(*) AS OrderCount
FROM dbo.Products P
INNER JOIN dbo.OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.ProductName;

-- إضافة فهرس
CREATE UNIQUE CLUSTERED INDEX IX_ProductSales
ON vw_ProductSales(ProductID);
```

## مزايا Views

- ✅ تبسيط الاستعلامات المعقدة
- ✅ إخفاء التفاصيل
- ✅ الأمان (إظهار بيانات محددة فقط)
- ✅ إعادة الاستخدام

## قيود Views

- ❌ لا يمكن استخدام ORDER BY (بدون TOP)
- ❌ بعض Views لا تدعم UPDATE/INSERT/DELETE
- ❌ قد تؤثر على الأداء

---

[⬅️ السابق: Security](17_security.md)
 [التالي: CTEs ⬅️](19_ctes.md)
 [🏠 الفهرس](README.md)
