# 8. الربط بين الجداول (JOINs)

## INNER JOIN

```sql
-- إرجاع الصفوف المتطابقة فقط
SELECT 
    E.FirstName,
    E.LastName,
    D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;
```

## LEFT JOIN (LEFT OUTER JOIN)

```sql
-- جميع الصفوف من الجدول الأيسر + المتطابقات من الأيمن
SELECT 
    E.FirstName,
    D.DepartmentName
FROM Employees E
LEFT JOIN Departments D ON E.DepartmentID = D.DepartmentID;
-- سيظهر الموظفون حتى لو لم يكن لهم قسم
```

## RIGHT JOIN

```sql
-- جميع الصفوف من الجدول الأيمن + المتطابقات من الأيسر
SELECT 
    E.FirstName,
    D.DepartmentName
FROM Employees E
RIGHT JOIN Departments D ON E.DepartmentID = D.DepartmentID;
-- ستظهر جميع الأقسام حتى الفارغة
```

## FULL OUTER JOIN

```sql
-- جميع الصفوف من الجدولين
SELECT 
    E.FirstName,
    D.DepartmentName
FROM Employees E
FULL OUTER JOIN Departments D ON E.DepartmentID = D.DepartmentID;
```

## CROSS JOIN

```sql
-- حاصل الضرب الديكارتي (كل صف مع كل صف)
SELECT 
    E.FirstName,
    D.DepartmentName
FROM Employees E
CROSS JOIN Departments D;
```

## SELF JOIN

```sql
-- ربط الجدول بنفسه
SELECT 
    E1.FirstName AS الموظف,
    E2.FirstName AS المدير
FROM Employees E1
LEFT JOIN Employees E2 ON E1.ManagerID = E2.EmployeeID;
```

## JOIN متعدد

```sql
SELECT 
    E.FirstName,
    D.DepartmentName,
    C.CityName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
INNER JOIN Cities C ON E.CityID = C.CityID;
```

## مثال عملي

```sql
-- تقرير الطلبات
SELECT 
    O.OrderID,
    C.FirstName + ' ' + C.LastName AS العميل,
    P.ProductName AS المنتج,
    OD.Quantity AS الكمية,
    OD.UnitPrice * OD.Quantity AS الإجمالي
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
WHERE O.OrderDate >= '2025-01-01'
ORDER BY O.OrderID;
```

---

[⬅️ السابق: الدوال](07_functions.md)
 [التالي: GROUP BY ⬅️](09_groupby.md)
 [🏠 الفهرس](README.md)
