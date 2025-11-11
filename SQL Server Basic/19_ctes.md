# 19. Common Table Expressions (CTEs)

## ما هو CTE؟

تعبير جدول مؤقت يُستخدم داخل استعلام واحد.

## البنية الأساسية

```sql
WITH CTE_Name AS
(
    SELECT ...
    FROM ...
)
SELECT * FROM CTE_Name;
```

## مثال بسيط

```sql
-- CTE للموظفين ذوي الرواتب العالية
WITH HighSalaryEmployees AS
(
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE Salary > 6000
)
SELECT * FROM HighSalaryEmployees
ORDER BY Salary DESC;
```

## CTE مع JOIN

```sql
WITH EmployeeDept AS
(
    SELECT 
        E.EmployeeID,
        E.FirstName,
        D.DepartmentName,
        E.Salary
    FROM Employees E
    INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
)
SELECT * FROM EmployeeDept
WHERE DepartmentName = N'المبيعات';
```

## CTEs متعددة

```sql
WITH 
Sales AS (
    SELECT DepartmentID, SUM(Amount) AS TotalSales
    FROM Transactions
    WHERE TransactionType = 'Sale'
    GROUP BY DepartmentID
),
Expenses AS (
    SELECT DepartmentID, SUM(Amount) AS TotalExpenses
    FROM Transactions
    WHERE TransactionType = 'Expense'
    GROUP BY DepartmentID
)
SELECT 
    D.DepartmentName,
    S.TotalSales,
    E.TotalExpenses,
    S.TotalSales - E.TotalExpenses AS NetProfit
FROM Departments D
LEFT JOIN Sales S ON D.DepartmentID = S.DepartmentID
LEFT JOIN Expenses E ON D.DepartmentID = E.DepartmentID;
```

## Recursive CTE (عودي)

```sql
-- الهيكل التنظيمي
WITH EmployeeHierarchy AS
(
    -- نقطة البداية
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- الجزء العودي
    SELECT E.EmployeeID, E.EmployeeName, E.ManagerID, EH.Level + 1
    FROM Employees E
    INNER JOIN EmployeeHierarchy EH ON E.ManagerID = EH.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY Level, EmployeeName;
```

## مثال: أرقام من 1 إلى 100

```sql
WITH Numbers AS
(
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1
    FROM Numbers
    WHERE Num < 100
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 100);
```

## CTE vs Subquery vs View

| الميزة | CTE | Subquery | View |
|--------|-----|----------|------|
| قابل لإعادة الاستخدام | مرة واحدة | مرة واحدة | متعدد |
| وضوح الكود | ✅ ممتاز | ❌ معقد | ✅ جيد |
| العودية | ✅ يدعم | ❌ لا يدعم | ❌ لا يدعم |
| الحفظ | ❌ مؤقت | ❌ مؤقت | ✅ دائم |

---

[⬅️ السابق: Views](18_views.md)
 [التالي: Performance Tuning ⬅️](20_performance.md)
 [🏠 الفهرس](README.md)
