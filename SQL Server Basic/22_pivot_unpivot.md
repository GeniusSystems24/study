# 22. PIVOT و UNPIVOT

## مقدمة

- **PIVOT**: تحويل الصفوف إلى أعمدة (Cross-tab report)
- **UNPIVOT**: تحويل الأعمدة إلى صفوف

## PIVOT الأساسي

```sql
-- البيانات الأصلية
SELECT EmployeeID, Year, Sales
FROM EmployeeSales;

-- تحويل السنوات إلى أعمدة
SELECT *
FROM (
    SELECT EmployeeID, Year, Sales
    FROM EmployeeSales
) AS SourceTable
PIVOT (
    SUM(Sales)
    FOR Year IN ([2023], [2024], [2025])
) AS PivotTable;

/*
النتيجة:
EmployeeID | 2023    | 2024    | 2025
-----------+---------+---------+--------
1          | 100000  | 120000  | 150000
2          | 80000   | 90000   | 95000
*/
```

## PIVOT مع أسماء ديناميكية

```sql
-- حساب المبيعات حسب القسم والشهر
SELECT *
FROM (
    SELECT 
        DepartmentName,
        DATENAME(MONTH, OrderDate) AS MonthName,
        OrderAmount
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
) AS SourceTable
PIVOT (
    SUM(OrderAmount)
    FOR MonthName IN ([January], [February], [March], [April], [May], [June])
) AS PivotTable;
```

## PIVOT ديناميكي (Dynamic PIVOT)

```sql
-- إنشاء PIVOT ديناميكي لجميع السنوات تلقائياً
DECLARE @Columns NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);

-- الحصول على قائمة السنوات
SELECT @Columns = STRING_AGG(QUOTENAME(Year), ', ')
FROM (SELECT DISTINCT Year FROM EmployeeSales) AS Years;

-- بناء الاستعلام الديناميكي
SET @SQL = N'
SELECT *
FROM (
    SELECT EmployeeID, Year, Sales
    FROM EmployeeSales
) AS SourceTable
PIVOT (
    SUM(Sales)
    FOR Year IN (' + @Columns + ')
) AS PivotTable;';

-- تنفيذ الاستعلام
EXEC sp_executesql @SQL;
```

## UNPIVOT الأساسي

```sql
-- البيانات الأصلية (أعمدة)
CREATE TABLE QuarterlySales (
    EmployeeID INT,
    Q1 DECIMAL(10,2),
    Q2 DECIMAL(10,2),
    Q3 DECIMAL(10,2),
    Q4 DECIMAL(10,2)
);

-- تحويل الأعمدة إلى صفوف
SELECT EmployeeID, Quarter, Sales
FROM QuarterlySales
UNPIVOT (
    Sales FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotTable;

/*
النتيجة:
EmployeeID | Quarter | Sales
-----------+---------+--------
1          | Q1      | 25000
1          | Q2      | 30000
1          | Q3      | 28000
1          | Q4      | 35000
*/
```

## أمثلة عملية

### مثال 1: تقرير المبيعات الشهرية

```sql
-- تقرير المبيعات بالأشهر كأعمدة
SELECT 
    ProductName,
    [Jan], [Feb], [Mar], [Apr], [May], [Jun],
    [Jul], [Aug], [Sep], [Oct], [Nov], [Dec],
    [Jan] + [Feb] + [Mar] + [Apr] + [May] + [Jun] +
    [Jul] + [Aug] + [Sep] + [Oct] + [Nov] + [Dec] AS YearTotal
FROM (
    SELECT 
        p.ProductName,
        DATENAME(MONTH, o.OrderDate) AS MonthName,
        od.Quantity * od.UnitPrice AS Sales
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE YEAR(o.OrderDate) = 2025
) AS SourceTable
PIVOT (
    SUM(Sales)
    FOR MonthName IN (
        [January], [February], [March], [April], [May], [June],
        [July], [August], [September], [October], [November], [December]
    )
) AS PivotTable;
```

### مثال 2: مقارنة الأداء بين الموظفين

```sql
-- مبيعات الموظفين حسب الفئة
SELECT *
FROM (
    SELECT 
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        c.CategoryName,
        od.Quantity * od.UnitPrice AS Sales
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    SUM(Sales)
    FOR CategoryName IN ([Electronics], [Clothing], [Books], [Sports])
) AS PivotTable
ORDER BY EmployeeName;
```

### مثال 3: تحليل الحضور الأسبوعي

```sql
-- حضور الموظفين حسب أيام الأسبوع
SELECT 
    EmployeeName,
    [Monday], [Tuesday], [Wednesday], [Thursday], [Friday],
    ([Monday] + [Tuesday] + [Wednesday] + [Thursday] + [Friday]) / 5.0 AS AvgHours
FROM (
    SELECT 
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        DATENAME(WEEKDAY, a.AttendanceDate) AS DayName,
        DATEDIFF(HOUR, a.CheckInTime, a.CheckOutTime) AS WorkHours
    FROM Attendance a
    INNER JOIN Employees e ON a.EmployeeID = e.EmployeeID
    WHERE DATEPART(WEEK, a.AttendanceDate) = DATEPART(WEEK, GETDATE())
) AS SourceTable
PIVOT (
    AVG(WorkHours)
    FOR DayName IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday])
) AS PivotTable;
```

## UNPIVOT مع بيانات متعددة

```sql
-- جدول به أعمدة متعددة للتحويل
CREATE TABLE EmployeeScores (
    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    MathScore INT,
    ScienceScore INT,
    EnglishScore INT,
    HistoryScore INT
);

-- تحويل جميع الدرجات إلى صفوف
SELECT 
    EmployeeID,
    EmployeeName,
    Subject,
    Score
FROM EmployeeScores
UNPIVOT (
    Score FOR Subject IN (MathScore, ScienceScore, EnglishScore, HistoryScore)
) AS UnpivotTable
ORDER BY EmployeeID, Subject;
```

## بديل بدون PIVOT

```sql
-- يمكن تحقيق نفس نتيجة PIVOT باستخدام CASE
SELECT 
    EmployeeID,
    SUM(CASE WHEN Year = 2023 THEN Sales ELSE 0 END) AS [2023],
    SUM(CASE WHEN Year = 2024 THEN Sales ELSE 0 END) AS [2024],
    SUM(CASE WHEN Year = 2025 THEN Sales ELSE 0 END) AS [2025]
FROM EmployeeSales
GROUP BY EmployeeID;

-- بديل لـ UNPIVOT
SELECT EmployeeID, 'Q1' AS Quarter, Q1 AS Sales FROM QuarterlySales
UNION ALL
SELECT EmployeeID, 'Q2', Q2 FROM QuarterlySales
UNION ALL
SELECT EmployeeID, 'Q3', Q3 FROM QuarterlySales
UNION ALL
SELECT EmployeeID, 'Q4', Q4 FROM QuarterlySales;
```

## Stored Procedure ديناميكي

```sql
-- إجراء مخزن لإنشاء PIVOT ديناميكي
CREATE PROCEDURE sp_DynamicPivot
    @SourceTable NVARCHAR(100),
    @PivotColumn NVARCHAR(100),
    @AggregateColumn NVARCHAR(100),
    @AggregateFunction NVARCHAR(20) = 'SUM'
AS
BEGIN
    DECLARE @Columns NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);
    
    -- الحصول على القيم الفريدة للعمود المحوري
    SET @SQL = N'
    SELECT @Cols = STRING_AGG(QUOTENAME(' + @PivotColumn + '), '', '')
    FROM (SELECT DISTINCT ' + @PivotColumn + ' FROM ' + @SourceTable + ') AS T';
    
    EXEC sp_executesql @SQL, N'@Cols NVARCHAR(MAX) OUTPUT', @Columns OUTPUT;
    
    -- بناء استعلام PIVOT
    SET @SQL = N'
    SELECT *
    FROM ' + @SourceTable + '
    PIVOT (
        ' + @AggregateFunction + '(' + @AggregateColumn + ')
        FOR ' + @PivotColumn + ' IN (' + @Columns + ')
    ) AS PivotTable;';
    
    EXEC sp_executesql @SQL;
END;
GO

-- استخدام الإجراء
EXEC sp_DynamicPivot 
    @SourceTable = 'EmployeeSales',
    @PivotColumn = 'Year',
    @AggregateColumn = 'Sales',
    @AggregateFunction = 'SUM';
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم CTE لتوضيح البيانات المصدرية
WITH SourceData AS (
    SELECT 
        EmployeeID,
        YEAR(OrderDate) AS Year,
        SUM(OrderAmount) AS Sales
    FROM Orders
    GROUP BY EmployeeID, YEAR(OrderDate)
)
SELECT *
FROM SourceData
PIVOT (
    SUM(Sales)
    FOR Year IN ([2023], [2024], [2025])
) AS PivotTable;

-- ✅ تعامل مع القيم NULL
SELECT 
    EmployeeID,
    ISNULL([2023], 0) AS [2023],
    ISNULL([2024], 0) AS [2024],
    ISNULL([2025], 0) AS [2025]
FROM (...) AS PivotTable;

-- ⚠️ PIVOT يحذف الأعمدة غير المذكورة
-- تأكد من تضمين فقط الأعمدة المطلوبة في الاستعلام الفرعي
```

## الخلاصة

- **PIVOT**: تحويل صفوف إلى أعمدة (للتقارير المحورية)
- **UNPIVOT**: تحويل أعمدة إلى صفوف (لتطبيع البيانات)
- **Dynamic PIVOT**: للأعمدة غير المعروفة مسبقاً
- **البدائل**: CASE أو UNION ALL عند عدم الحاجة للديناميكية

---

[⬅️ السابق: Window Functions](21_window_functions.md)
 [التالي: CASE Expressions ⬅️](23_case_expressions.md)
 [🏠 العودة للفهرس](README.md)
