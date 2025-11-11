# 31. CROSS APPLY و OUTER APPLY

## الفرق بين APPLY و JOIN

```sql
-- APPLY يعمل مثل JOIN لكن يسمح باستخدام القيم من الجدول الأيسر
-- في الجدول الأيمن (دالة أو استعلام فرعي)

-- CROSS APPLY = INNER JOIN
-- OUTER APPLY = LEFT JOIN
```

## CROSS APPLY

```sql
-- مثال: الحصول على أعلى 3 موظفين راتباً في كل قسم
SELECT 
    d.DepartmentName,
    e.FirstName,
    e.Salary
FROM Departments d
CROSS APPLY (
    SELECT TOP 3 FirstName, Salary
    FROM Employees
    WHERE DepartmentID = d.DepartmentID
    ORDER BY Salary DESC
) e;
```

## OUTER APPLY

```sql
-- يُرجع جميع الصفوف من الأيسر حتى لو لم يكن هناك تطابق
SELECT 
    d.DepartmentName,
    e.FirstName,
    e.Salary
FROM Departments d
OUTER APPLY (
    SELECT TOP 1 FirstName, Salary
    FROM Employees
    WHERE DepartmentID = d.DepartmentID
    ORDER BY Salary DESC
) e;
```

## استخدام مع Table-Valued Functions

```sql
CREATE FUNCTION fn_GetEmployeeOrders(@EmployeeID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT OrderID, OrderDate, TotalAmount
    FROM Orders
    WHERE EmployeeID = @EmployeeID
);
GO

-- استخدام CROSS APPLY
SELECT 
    e.FirstName,
    o.OrderID,
    o.TotalAmount
FROM Employees e
CROSS APPLY fn_GetEmployeeOrders(e.EmployeeID) o;
```

## STRING_SPLIT مع APPLY

```sql
SELECT 
    p.ProductName,
    t.value AS Tag
FROM Products p
CROSS APPLY STRING_SPLIT(p.Tags, ',') t;
```

## الخلاصة

- **CROSS APPLY**: مثل INNER JOIN مع إمكانيات أكثر
- **OUTER APPLY**: مثل LEFT JOIN مع إمكانيات أكثر
- مفيد مع Table-Valued Functions
- يسمح باستخدام قيم من اليسار في اليمين

---

[⬅️ السابق: Error Handling](30_error_handling.md)
 [التالي: Table Partitioning ⬅️](32_partitioning.md)
 [🏠 العودة للفهرس](README.md)
