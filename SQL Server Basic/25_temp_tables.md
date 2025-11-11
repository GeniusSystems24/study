# 25. الجداول المؤقتة (Temporary Tables)

## أنواع الجداول المؤقتة

SQL Server يوفر عدة أنواع من الجداول المؤقتة:

1. **Local Temp Tables** (#Table)
2. **Global Temp Tables** (##Table)
3. **Table Variables** (@Table)
4. **CTEs** (WITH statement)

## 1. Local Temporary Tables (#)

```sql
-- إنشاء جدول مؤقت محلي
CREATE TABLE #TempEmployees (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2)
);

-- إدراج بيانات
INSERT INTO #TempEmployees
SELECT EmployeeID, FirstName, Salary
FROM Employees
WHERE DepartmentID = 1;

-- الاستخدام
SELECT * FROM #TempEmployees;

-- التحقق من الوجود وإعادة الإنشاء
IF OBJECT_ID('tempdb..#TempEmployees') IS NOT NULL
    DROP TABLE #TempEmployees;

CREATE TABLE #TempEmployees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2)
);
```

### خصائص Local Temp Tables

```sql
-- 1. متاحة فقط في الجلسة الحالية
-- 2. تُحذف تلقائياً عند إغلاق الجلسة
-- 3. يمكن إنشاء فهارس عليها
-- 4. تُخزن في tempdb

-- إنشاء فهرس على جدول مؤقت
CREATE INDEX IX_Salary ON #TempEmployees(Salary);

-- إضافة قيود
ALTER TABLE #TempEmployees
ADD CONSTRAINT CK_Salary CHECK (Salary > 0);
```

## 2. Global Temporary Tables (##)

```sql
-- إنشاء جدول مؤقت عام (متاح لجميع الجلسات)
CREATE TABLE ##GlobalTemp (
    ID INT,
    Data NVARCHAR(100)
);

-- يمكن الوصول إليه من أي جلسة
INSERT INTO ##GlobalTemp VALUES (1, N'بيانات عامة');

-- يُحذف عندما تُغلق آخر جلسة تستخدمه
DROP TABLE ##GlobalTemp;
```

## 3. Table Variables (@)

```sql
-- تعريف متغير جدول
DECLARE @TempEmployees TABLE (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2),
    INDEX IX_Salary (Salary)  -- SQL Server 2014+
);

-- إدراج بيانات
INSERT INTO @TempEmployees
SELECT EmployeeID, FirstName, Salary
FROM Employees
WHERE Salary > 10000;

-- الاستخدام
SELECT * FROM @TempEmployees
ORDER BY Salary DESC;

-- ⚠️ لا يمكن استخدام ALTER مع Table Variables
```

### الفرق بين # و @

```sql
-- Local Temp Table (#)
-- ✅ يدعم ALTER TABLE
-- ✅ يدعم TRUNCATE
-- ✅ إحصائيات أفضل للمُحسِّن
-- ⚠️ يسبب recompilation أكثر

-- Table Variable (@)
-- ✅ أسرع للبيانات القليلة (<1000 صف)
-- ✅ لا يسبب recompilation
-- ✅ نطاقه محدود بالـ batch
-- ⚠️ لا يدعم ALTER
-- ⚠️ الإحصائيات محدودة
```

## أمثلة عملية

### مثال 1: تحليل مبيعات معقد

```sql
-- خطوة 1: حساب مبيعات كل موظف
CREATE TABLE #EmployeeSales (
    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    TotalSales DECIMAL(15,2),
    OrderCount INT
);

INSERT INTO #EmployeeSales
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName,
    SUM(o.TotalAmount),
    COUNT(o.OrderID)
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- خطوة 2: حساب متوسط كل قسم
CREATE TABLE #DepartmentAvg (
    DepartmentID INT,
    AvgSales DECIMAL(15,2)
);

INSERT INTO #DepartmentAvg
SELECT 
    e.DepartmentID,
    AVG(es.TotalSales)
FROM #EmployeeSales es
INNER JOIN Employees e ON es.EmployeeID = e.EmployeeID
GROUP BY e.DepartmentID;

-- خطوة 3: المقارنة والنتيجة النهائية
SELECT 
    es.EmployeeName,
    es.TotalSales,
    da.AvgSales AS DepartmentAvg,
    es.TotalSales - da.AvgSales AS DifferenceFromAvg,
    CASE 
        WHEN es.TotalSales > da.AvgSales THEN N'فوق المتوسط'
        WHEN es.TotalSales < da.AvgSales THEN N'تحت المتوسط'
        ELSE N'في المتوسط'
    END AS Performance
FROM #EmployeeSales es
INNER JOIN Employees e ON es.EmployeeID = e.EmployeeID
INNER JOIN #DepartmentAvg da ON e.DepartmentID = da.DepartmentID
ORDER BY es.TotalSales DESC;

-- التنظيف
DROP TABLE #EmployeeSales;
DROP TABLE #DepartmentAvg;
```

### مثال 2: معالجة البيانات على دفعات (Batch Processing)

```sql
-- جدول مؤقت لتخزين IDs المطلوب معالجتها
CREATE TABLE #OrdersToProcess (
    OrderID INT PRIMARY KEY,
    ProcessedStatus BIT DEFAULT 0
);

-- جلب الطلبات التي تحتاج معالجة
INSERT INTO #OrdersToProcess (OrderID)
SELECT OrderID
FROM Orders
WHERE OrderStatus = 1  -- جديد
    AND OrderDate >= DATEADD(DAY, -7, GETDATE());

-- معالجة على دفعات (1000 صف في المرة)
DECLARE @BatchSize INT = 1000;
DECLARE @ProcessedCount INT;

WHILE EXISTS (SELECT 1 FROM #OrdersToProcess WHERE ProcessedStatus = 0)
BEGIN
    -- معالجة دفعة
    UPDATE TOP (@BatchSize) o
    SET 
        o.OrderStatus = 2,  -- قيد المعالجة
        o.ModifiedAt = GETDATE()
    FROM Orders o
    INNER JOIN #OrdersToProcess tp ON o.OrderID = tp.OrderID
    WHERE tp.ProcessedStatus = 0;
    
    -- تحديث حالة المعالجة
    UPDATE tp
    SET ProcessedStatus = 1
    FROM #OrdersToProcess tp
    INNER JOIN Orders o ON tp.OrderID = o.OrderID
    WHERE o.OrderStatus = 2 AND tp.ProcessedStatus = 0;
    
    SET @ProcessedCount = @@ROWCOUNT;
    PRINT N'تمت معالجة ' + CAST(@ProcessedCount AS NVARCHAR(10)) + N' طلب';
    
    -- انتظار قصير لتقليل الضغط
    WAITFOR DELAY '00:00:01';
END;

DROP TABLE #OrdersToProcess;
```

### مثال 3: Pivot ديناميكي مع جداول مؤقتة

```sql
-- تخزين النتائج المحورية
CREATE TABLE #SalesPivot (
    EmployeeName NVARCHAR(100)
);

-- إضافة الأعمدة ديناميكياً
DECLARE @Columns NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);

-- الحصول على قائمة الأشهر
SELECT @Columns = STRING_AGG(QUOTENAME(MonthName), ', ')
FROM (
    SELECT DISTINCT DATENAME(MONTH, OrderDate) AS MonthName
    FROM Orders
    WHERE YEAR(OrderDate) = 2025
) AS Months;

-- بناء الاستعلام
SET @SQL = N'
SELECT *
INTO #SalesPivot
FROM (
    SELECT 
        e.FirstName + '' '' + e.LastName AS EmployeeName,
        DATENAME(MONTH, o.OrderDate) AS MonthName,
        o.TotalAmount
    FROM Orders o
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    WHERE YEAR(o.OrderDate) = 2025
) AS SourceTable
PIVOT (
    SUM(TotalAmount)
    FOR MonthName IN (' + @Columns + ')
) AS PivotTable;

SELECT * FROM #SalesPivot;';

EXEC sp_executesql @SQL;
```

## استخدام Temp Tables في Stored Procedures

```sql
CREATE PROCEDURE sp_AnalyzeEmployeePerformance
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- جدول مؤقت للنتائج
    CREATE TABLE #Results (
        EmployeeID INT,
        EmployeeName NVARCHAR(100),
        CurrentSalary DECIMAL(10,2),
        TotalSales DECIMAL(15,2),
        PerformanceScore DECIMAL(5,2),
        Recommendation NVARCHAR(200)
    );
    
    -- جمع البيانات
    INSERT INTO #Results (EmployeeID, EmployeeName, CurrentSalary, TotalSales)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName,
        e.Salary,
        ISNULL(SUM(o.TotalAmount), 0)
    FROM Employees e
    LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE 
        (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
        AND (@MinSalary IS NULL OR e.Salary >= @MinSalary)
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Salary;
    
    -- حساب درجة الأداء
    UPDATE #Results
    SET PerformanceScore = 
        CASE 
            WHEN TotalSales > 100000 THEN 95
            WHEN TotalSales > 50000 THEN 85
            WHEN TotalSales > 20000 THEN 75
            ELSE 60
        END;
    
    -- إضافة التوصيات
    UPDATE #Results
    SET Recommendation = 
        CASE 
            WHEN PerformanceScore >= 90 THEN N'ترقية + مكافأة'
            WHEN PerformanceScore >= 80 THEN N'زيادة راتب'
            WHEN PerformanceScore >= 70 THEN N'تشجيع'
            ELSE N'تدريب وتطوير'
        END;
    
    -- النتيجة النهائية
    SELECT * FROM #Results
    ORDER BY PerformanceScore DESC;
    
    -- التنظيف
    DROP TABLE #Results;
END;
GO

-- الاستخدام
EXEC sp_AnalyzeEmployeePerformance @DepartmentID = 1;
```

## Table Variables في Functions

```sql
CREATE FUNCTION fn_GetTopProducts(@TopN INT)
RETURNS @ProductList TABLE (
    ProductID INT,
    ProductName NVARCHAR(200),
    TotalSales DECIMAL(15,2),
    Rank INT
)
AS
BEGIN
    INSERT INTO @ProductList
    SELECT TOP (@TopN)
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS Rank
    FROM Products p
    INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
    ORDER BY TotalSales DESC;
    
    RETURN;
END;
GO

-- الاستخدام
SELECT * FROM fn_GetTopProducts(10);
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم # للبيانات الكبيرة (>1000 صف)
CREATE TABLE #LargeData (...);

-- ✅ استخدم @ للبيانات الصغيرة (<100 صف)
DECLARE @SmallData TABLE (...);

-- ✅ احذف الجداول المؤقتة يدوياً في نهاية الإجراء
DROP TABLE #TempTable;

-- ✅ تحقق من الوجود قبل الإنشاء
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
    DROP TABLE #TempTable;

-- ✅ أنشئ فهارس على الجداول المؤقتة الكبيرة
CREATE INDEX IX_Column ON #TempTable(Column);

-- ⚠️ تجنب استخدام SELECT INTO في Stored Procedures
-- يسبب schema locking
-- بدلاً من:
SELECT * INTO #Temp FROM LargeTable;
-- استخدم:
CREATE TABLE #Temp (...);
INSERT INTO #Temp SELECT * FROM LargeTable;

-- ✅ استخدم TRUNCATE بدلاً من DELETE للأداء
TRUNCATE TABLE #TempTable;  -- أسرع
-- بدلاً من:
DELETE FROM #TempTable;

-- ✅ راقب استخدام tempdb
SELECT 
    session_id,
    SUM(user_objects_alloc_page_count) * 8 / 1024 AS UserObjectsMB,
    SUM(internal_objects_alloc_page_count) * 8 / 1024 AS InternalObjectsMB
FROM sys.dm_db_session_space_usage
WHERE session_id > 50
GROUP BY session_id
ORDER BY UserObjectsMB DESC;
```

## الخلاصة

| النوع | الرمز | النطاق | الاستخدام الأمثل |
|------|------|--------|------------------|
| **Local Temp** | `#Table` | الجلسة | بيانات كبيرة، معالجة معقدة |
| **Global Temp** | `##Table` | جميع الجلسات | مشاركة بيانات مؤقتة |
| **Table Variable** | `@Table` | الـ Batch | بيانات صغيرة، functions |
| **CTE** | `WITH` | الاستعلام | استعلامات قابلة للقراءة |

---

[⬅️ السابق: MERGE Statement](24_merge.md)
 [التالي: Dynamic SQL ⬅️](26_dynamic_sql.md)
 [🏠 العودة للفهرس](README.md)
