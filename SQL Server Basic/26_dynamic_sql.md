# 26. SQL الديناميكي (Dynamic SQL)

## مقدمة

**Dynamic SQL** هو كتابة وتنفيذ أوامر SQL كنصوص (strings) في وقت التشغيل.

## EXEC() - الطريقة البسيطة

```sql
-- تنفيذ استعلام بسيط
EXEC('SELECT * FROM Employees');

-- مع متغير
DECLARE @SQL VARCHAR(MAX);
SET @SQL = 'SELECT * FROM Employees WHERE DepartmentID = 1';
EXEC(@SQL);

-- ⚠️ لا يدعم Parameters - معرض لـ SQL Injection!
```

## sp_executesql - الطريقة الموصى بها

```sql
-- مع Parameters آمنة
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DeptID INT = 1;

SET @SQL = N'SELECT * FROM Employees WHERE DepartmentID = @DepartmentID';

EXEC sp_executesql @SQL, 
    N'@DepartmentID INT',  -- تعريف Parameters
    @DepartmentID = @DeptID;  -- القيم

/*
المزايا:
✅ آمن من SQL Injection
✅ يدعم Plan Reuse
✅ يدعم OUTPUT Parameters
*/
```

## استعلامات ديناميكية مع Parameters

```sql
-- مثال كامل
DECLARE @TableName NVARCHAR(100) = N'Employees';
DECLARE @MinSalary DECIMAL(10,2) = 10000;
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'
SELECT EmployeeID, FirstName, LastName, Salary
FROM ' + QUOTENAME(@TableName) + N'
WHERE Salary >= @MinSalary
ORDER BY Salary DESC';

EXEC sp_executesql @SQL,
    N'@MinSalary DECIMAL(10,2)',
    @MinSalary = @MinSalary;
```

## OUTPUT Parameters

```sql
-- استرجاع قيمة من Dynamic SQL
DECLARE @SQL NVARCHAR(MAX);
DECLARE @EmployeeCount INT;
DECLARE @DeptID INT = 1;

SET @SQL = N'
SELECT @Count = COUNT(*)
FROM Employees
WHERE DepartmentID = @DepartmentID';

EXEC sp_executesql @SQL,
    N'@DepartmentID INT, @Count INT OUTPUT',
    @DepartmentID = @DeptID,
    @Count = @EmployeeCount OUTPUT;

PRINT N'عدد الموظفين: ' + CAST(@EmployeeCount AS NVARCHAR(10));
```

## بناء استعلامات معقدة

### مثال 1: WHERE شرطي ديناميكي

```sql
CREATE PROCEDURE sp_SearchEmployees
    @FirstName NVARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @MinSalary DECIMAL(10,2) = NULL,
    @MaxSalary DECIMAL(10,2) = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Where NVARCHAR(MAX) = N'';
    
    -- بناء WHERE ديناميكياً
    IF @FirstName IS NOT NULL
        SET @Where = @Where + N' AND FirstName LIKE @FirstName';
    
    IF @DepartmentID IS NOT NULL
        SET @Where = @Where + N' AND DepartmentID = @DepartmentID';
    
    IF @MinSalary IS NOT NULL
        SET @Where = @Where + N' AND Salary >= @MinSalary';
    
    IF @MaxSalary IS NOT NULL
        SET @Where = @Where + N' AND Salary <= @MaxSalary';
    
    -- إزالة AND الأولى
    IF LEN(@Where) > 0
        SET @Where = N' WHERE 1=1' + @Where;
    
    -- بناء الاستعلام الكامل
    SET @SQL = N'
    SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
    FROM Employees' + @Where + N'
    ORDER BY Salary DESC';
    
    -- تنفيذ
    EXEC sp_executesql @SQL,
        N'@FirstName NVARCHAR(50), @DepartmentID INT, @MinSalary DECIMAL(10,2), @MaxSalary DECIMAL(10,2)',
        @FirstName = @FirstName,
        @DepartmentID = @DepartmentID,
        @MinSalary = @MinSalary,
        @MaxSalary = @MaxSalary;
END;
GO

-- الاستخدام
EXEC sp_SearchEmployees @MinSalary = 8000, @DepartmentID = 1;
EXEC sp_SearchEmployees @FirstName = N'%أحمد%';
```

### مثال 2: SELECT Columns ديناميكي

```sql
CREATE PROCEDURE sp_GetEmployeeData
    @IncludeEmail BIT = 0,
    @IncludeSalary BIT = 0,
    @IncludeHireDate BIT = 0
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Columns NVARCHAR(500) = N'EmployeeID, FirstName, LastName';
    
    -- إضافة الأعمدة حسب الحاجة
    IF @IncludeEmail = 1
        SET @Columns = @Columns + N', Email';
    
    IF @IncludeSalary = 1
        SET @Columns = @Columns + N', Salary';
    
    IF @IncludeHireDate = 1
        SET @Columns = @Columns + N', HireDate';
    
    SET @SQL = N'SELECT ' + @Columns + N' FROM Employees';
    
    EXEC sp_executesql @SQL;
END;
GO

-- الاستخدام
EXEC sp_GetEmployeeData @IncludeEmail = 1, @IncludeSalary = 1;
```

### مثال 3: PIVOT ديناميكي كامل

```sql
CREATE PROCEDURE sp_DynamicPivotSales
    @Year INT
AS
BEGIN
    DECLARE @Columns NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);
    
    -- الحصول على قائمة الأشهر
    SELECT @Columns = STRING_AGG(QUOTENAME(MonthName), ', ')
    FROM (
        SELECT DISTINCT DATENAME(MONTH, OrderDate) AS MonthName
        FROM Orders
        WHERE YEAR(OrderDate) = @Year
    ) AS Months;
    
    -- بناء استعلام PIVOT
    SET @SQL = N'
    SELECT 
        EmployeeName,
        ' + @Columns + N',
        ' + @Columns + N' AS YearTotal
    FROM (
        SELECT 
            e.FirstName + '' '' + e.LastName AS EmployeeName,
            DATENAME(MONTH, o.OrderDate) AS MonthName,
            o.TotalAmount
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        WHERE YEAR(o.OrderDate) = @Year
    ) AS SourceTable
    PIVOT (
        SUM(TotalAmount)
        FOR MonthName IN (' + @Columns + N')
    ) AS PivotTable
    ORDER BY YearTotal DESC';
    
    EXEC sp_executesql @SQL, N'@Year INT', @Year = @Year;
END;
GO

-- الاستخدام
EXEC sp_DynamicPivotSales @Year = 2025;
```

## Dynamic Table Names

```sql
-- ⚠️ استخدم QUOTENAME لحماية من SQL Injection
CREATE PROCEDURE sp_GetTableData
    @TableName NVARCHAR(100),
    @TopN INT = 100
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- التحقق من وجود الجدول
    IF OBJECT_ID(@TableName) IS NULL
    BEGIN
        RAISERROR(N'الجدول غير موجود', 16, 1);
        RETURN;
    END;
    
    -- استخدام QUOTENAME للحماية
    SET @SQL = N'SELECT TOP (@TopN) * FROM ' + QUOTENAME(@TableName);
    
    EXEC sp_executesql @SQL, N'@TopN INT', @TopN = @TopN;
END;
GO

-- الاستخدام
EXEC sp_GetTableData @TableName = 'Employees', @TopN = 10;
```

## Dynamic DDL

```sql
-- إنشاء جداول ديناميكياً
DECLARE @TableName NVARCHAR(100) = N'DynamicTable_' + CONVERT(NVARCHAR(20), GETDATE(), 112);
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'
CREATE TABLE ' + QUOTENAME(@TableName) + N' (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Data NVARCHAR(200),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
)';

EXEC sp_executesql @SQL;

-- إنشاء فهرس ديناميكياً
SET @SQL = N'CREATE INDEX IX_Data ON ' + QUOTENAME(@TableName) + N'(Data)';
EXEC sp_executesql @SQL;
```

## Cursor ديناميكي

```sql
-- تنفيذ أمر على كل الجداول
DECLARE @TableName NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @RowCount INT;

DECLARE TableCursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
    AND TABLE_SCHEMA = 'dbo';

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- عد الصفوف لكل جدول
    SET @SQL = N'SELECT @Count = COUNT(*) FROM ' + QUOTENAME(@TableName);
    
    EXEC sp_executesql @SQL, N'@Count INT OUTPUT', @Count = @RowCount OUTPUT;
    
    PRINT @TableName + N': ' + CAST(@RowCount AS NVARCHAR(10)) + N' صف';
    
    FETCH NEXT FROM TableCursor INTO @TableName;
END;

CLOSE TableCursor;
DEALLOCATE TableCursor;
```

## مثال متقدم: Bulk Operations

```sql
CREATE PROCEDURE sp_BulkUpdateColumns
    @TableName NVARCHAR(100),
    @UpdateColumn NVARCHAR(100),
    @ValueColumn NVARCHAR(100),
    @WhereClause NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- بناء الاستعلام
    SET @SQL = N'
    UPDATE ' + QUOTENAME(@TableName) + N'
    SET ' + QUOTENAME(@UpdateColumn) + N' = ' + QUOTENAME(@ValueColumn);
    
    -- إضافة WHERE إن وُجد
    IF @WhereClause IS NOT NULL
        SET @SQL = @SQL + N' WHERE ' + @WhereClause;
    
    -- عرض الاستعلام للمراجعة
    PRINT @SQL;
    
    -- تنفيذ
    EXEC sp_executesql @SQL;
    
    PRINT N'تم تحديث ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' صف';
END;
GO
```

## التعامل مع الأخطاء

```sql
CREATE PROCEDURE sp_SafeDynamicSQL
    @SQL NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        EXEC sp_executesql @SQL;
        PRINT N'✅ تم التنفيذ بنجاح';
    END TRY
    BEGIN CATCH
        PRINT N'❌ خطأ في التنفيذ:';
        PRINT N'رسالة الخطأ: ' + ERROR_MESSAGE();
        PRINT N'السطر: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT N'الاستعلام: ' + @SQL;
    END CATCH;
END;
GO
```

## نصائح الأمان وأفضل الممارسات

```sql
-- ✅ استخدم sp_executesql دائماً بدلاً من EXEC
-- ✅ استخدم Parameters بدلاً من تضمين القيم مباشرة

-- ❌ خطير - معرض لـ SQL Injection
DECLARE @UserInput NVARCHAR(50) = N'1 OR 1=1';
EXEC('SELECT * FROM Employees WHERE EmployeeID = ' + @UserInput);

-- ✅ آمن
EXEC sp_executesql N'SELECT * FROM Employees WHERE EmployeeID = @ID',
    N'@ID INT', @ID = @UserInput;

-- ✅ استخدم QUOTENAME لأسماء الكائنات
DECLARE @Table NVARCHAR(100) = N'Employees';
DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM ' + QUOTENAME(@Table);

-- ✅ تحقق من صحة المدخلات
IF @TableName NOT IN (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES)
BEGIN
    RAISERROR(N'اسم جدول غير صحيح', 16, 1);
    RETURN;
END;

-- ✅ سجل Dynamic SQL للمراجعة
CREATE TABLE DynamicSQLLog (
    LogID INT IDENTITY PRIMARY KEY,
    SQLText NVARCHAR(MAX),
    ExecutedAt DATETIME2 DEFAULT SYSDATETIME(),
    ExecutedBy NVARCHAR(100) DEFAULT SYSTEM_USER
);

INSERT INTO DynamicSQLLog (SQLText) VALUES (@SQL);

-- ✅ استخدم TRY-CATCH
BEGIN TRY
    EXEC sp_executesql @SQL;
END TRY
BEGIN CATCH
    -- معالجة الخطأ
    THROW;
END CATCH;
```

## متى تستخدم Dynamic SQL؟

```sql
-- ✅ استخدم عندما:
-- 1. أسماء جداول/أعمدة ديناميكية
-- 2. PIVOT بأعمدة غير معروفة مسبقاً
-- 3. استعلامات بحث معقدة بشروط اختيارية
-- 4. DDL operations في Stored Procedures

-- ❌ تجنب عندما:
-- 1. يمكن استخدام استعلام ثابت
-- 2. الأداء حرج (Plan reuse محدود)
-- 3. المدخلات غير موثوقة (خطر SQL Injection)
```

## الخلاصة

- **EXEC**: بسيط لكن غير آمن
- **sp_executesql**: آمن ويدعم Parameters
- **QUOTENAME**: لحماية أسماء الكائنات
- **التحقق من المدخلات**: ضروري للأمان
- **TRY-CATCH**: لمعالجة الأخطاء
- **التوثيق**: سجل Dynamic SQL للمراجعة

---

[⬅️ السابق: الجداول المؤقتة](25_temp_tables.md)
 [التالي: عمليات النصوص ⬅️](27_string_operations.md)
 [🏠 العودة للفهرس](README.md)
