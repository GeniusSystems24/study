# 21. دوال النوافذ (Window Functions)

## مقدمة

**Window Functions** تسمح بإجراء حسابات عبر مجموعة من الصفوف المرتبطة بالصف الحالي دون تجميعها.

## ROW_NUMBER()

```sql
-- ترقيم الموظفين حسب الراتب في كل قسم
SELECT 
    FirstName,
    LastName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RowNum
FROM Employees;

-- الموظف الأعلى راتباً في كل قسم
WITH RankedEmployees AS (
    SELECT 
        FirstName,
        LastName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
    FROM Employees
)
SELECT * FROM RankedEmployees WHERE Rank = 1;
```

## RANK() و DENSE_RANK()

```sql
-- الفرق بين RANK و DENSE_RANK
SELECT 
    FirstName,
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS Rank,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
FROM Employees;

/*
إذا كان هناك رواتب متساوية:
ROW_NUMBER: 1, 2, 3, 4, 5 (لا تكرار)
RANK: 1, 2, 2, 4, 5 (يقفز الرقم)
DENSE_RANK: 1, 2, 2, 3, 4 (لا يقفز)
*/
```

## NTILE()

```sql
-- تقسيم الموظفين إلى 4 مجموعات حسب الراتب
SELECT 
    FirstName,
    Salary,
    NTILE(4) OVER (ORDER BY Salary DESC) AS Quartile
FROM Employees;

-- الموظفون في الربع الأعلى (Top 25%)
WITH Quartiles AS (
    SELECT 
        FirstName,
        Salary,
        NTILE(4) OVER (ORDER BY Salary DESC) AS Quartile
    FROM Employees
)
SELECT * FROM Quartiles WHERE Quartile = 1;
```

## LAG() و LEAD()

```sql
-- مقارنة الراتب مع الموظف السابق والتالي
SELECT 
    FirstName,
    Salary,
    LAG(Salary) OVER (ORDER BY Salary) AS PreviousSalary,
    LEAD(Salary) OVER (ORDER BY Salary) AS NextSalary,
    Salary - LAG(Salary) OVER (ORDER BY Salary) AS DifferenceFromPrevious
FROM Employees;

-- مقارنة المبيعات الشهرية
SELECT 
    SaleMonth,
    TotalSales,
    LAG(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS LastMonthSales,
    TotalSales - LAG(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS Growth
FROM MonthlySales;
```

## FIRST_VALUE() و LAST_VALUE()

```sql
-- أول وآخر راتب في كل قسم
SELECT 
    FirstName,
    DepartmentID,
    Salary,
    FIRST_VALUE(Salary) OVER (PARTITION BY DepartmentID ORDER BY Salary) AS LowestSalary,
    LAST_VALUE(Salary) OVER (
        PARTITION BY DepartmentID 
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS HighestSalary
FROM Employees;
```

## SUM() و AVG() كـ Window Functions

```sql
-- المجموع التراكمي (Running Total)
SELECT 
    OrderDate,
    OrderAmount,
    SUM(OrderAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- متوسط متحرك (Moving Average)
SELECT 
    OrderDate,
    OrderAmount,
    AVG(OrderAmount) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg3Days
FROM Orders;

-- النسبة من الإجمالي
SELECT 
    ProductName,
    Sales,
    SUM(Sales) OVER () AS TotalSales,
    CAST(Sales * 100.0 / SUM(Sales) OVER () AS DECIMAL(5,2)) AS PercentageOfTotal
FROM ProductSales;
```

## مثال متقدم - تحليل المبيعات

```sql
-- تحليل شامل للمبيعات
WITH SalesAnalysis AS (
    SELECT 
        EmployeeID,
        YEAR(OrderDate) AS SaleYear,
        MONTH(OrderDate) AS SaleMonth,
        SUM(OrderAmount) AS MonthlySales,
        
        -- الترتيب حسب الأداء
        RANK() OVER (
            PARTITION BY YEAR(OrderDate) 
            ORDER BY SUM(OrderAmount) DESC
        ) AS YearlyRank,
        
        -- المبيعات التراكمية السنوية
        SUM(SUM(OrderAmount)) OVER (
            PARTITION BY EmployeeID, YEAR(OrderDate)
            ORDER BY MONTH(OrderDate)
        ) AS YTDSales,
        
        -- مقارنة مع الشهر السابق
        LAG(SUM(OrderAmount)) OVER (
            PARTITION BY EmployeeID
            ORDER BY YEAR(OrderDate), MONTH(OrderDate)
        ) AS LastMonthSales
        
    FROM Orders
    GROUP BY EmployeeID, YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
    *,
    MonthlySales - LastMonthSales AS MonthlyGrowth,
    CASE 
        WHEN LastMonthSales > 0 
        THEN ((MonthlySales - LastMonthSales) * 100.0 / LastMonthSales)
        ELSE NULL
    END AS GrowthPercentage
FROM SalesAnalysis
ORDER BY SaleYear, YearlyRank;
```

## ROWS vs RANGE

```sql
-- ROWS: يحسب بناءً على عدد الصفوف
SELECT 
    OrderDate,
    OrderAmount,
    AVG(OrderAmount) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS AvgLast3Rows
FROM Orders;

-- RANGE: يحسب بناءً على القيم
SELECT 
    OrderDate,
    OrderAmount,
    SUM(OrderAmount) OVER (
        ORDER BY OrderDate
        RANGE BETWEEN INTERVAL '7' DAY PRECEDING AND CURRENT ROW
    ) AS Last7DaysTotal
FROM Orders;
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم Window Functions بدلاً من Subqueries
-- بدلاً من:
SELECT 
    e.FirstName,
    e.Salary,
    (SELECT AVG(Salary) FROM Employees WHERE DepartmentID = e.DepartmentID) AS AvgDeptSalary
FROM Employees e;

-- استخدم:
SELECT 
    FirstName,
    Salary,
    AVG(Salary) OVER (PARTITION BY DepartmentID) AS AvgDeptSalary
FROM Employees;

-- ⚠️ انتبه لـ LAST_VALUE - يحتاج window frame صحيح
-- خطأ شائع:
SELECT LAST_VALUE(Salary) OVER (ORDER BY Salary); -- قد لا يعطي النتيجة المتوقعة

-- الصحيح:
SELECT LAST_VALUE(Salary) OVER (
    ORDER BY Salary
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);
```

## الخلاصة

- **ROW_NUMBER**: ترقيم فريد لكل صف
- **RANK/DENSE_RANK**: ترتيب مع معالجة القيم المتساوية
- **NTILE**: تقسيم البيانات إلى مجموعات متساوية
- **LAG/LEAD**: الوصول للصفوف السابقة والتالية
- **FIRST_VALUE/LAST_VALUE**: أول وآخر قيمة في النافذة
- **Running Totals**: المجاميع التراكمية
- **Moving Averages**: المتوسطات المتحركة

---

[⬅️ السابق: الأداء والتحسين](20_performance.md)
 [التالي: PIVOT & UNPIVOT ⬅️](22_pivot_unpivot.md)
 [🏠 العودة للفهرس](README.md)
