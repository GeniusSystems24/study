# 20. تحسين الأداء (Performance Tuning)

## تحليل خطة التنفيذ (Execution Plan)

```sql
-- عرض خطة التنفيذ المقدرة
-- في SSMS: Ctrl+L

-- عرض خطة التنفيذ الفعلية
-- في SSMS: Ctrl+M ثم تنفيذ الاستعلام
SET SHOWPLAN_ALL ON;
GO

SELECT * FROM Employees;
GO

SET SHOWPLAN_ALL OFF;
```

## استخدام الفهارس بشكل صحيح

```sql
-- ❌ سيء (لا يستخدم الفهرس)
SELECT * FROM Employees
WHERE YEAR(HireDate) = 2025;

-- ✅ جيد (يستخدم الفهرس)
SELECT * FROM Employees
WHERE HireDate >= '2025-01-01' AND HireDate < '2026-01-01';
```

## تجنب SELECT *

```sql
-- ❌ سيء
SELECT * FROM Employees;

-- ✅ جيد (حدد الأعمدة المطلوبة فقط)
SELECT EmployeeID, FirstName, LastName FROM Employees;
```

## استخدام EXISTS بدلاً من IN

```sql
-- ❌ أبطأ
SELECT * FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- ✅ أسرع
SELECT * FROM Customers C
WHERE EXISTS (SELECT 1 FROM Orders O WHERE O.CustomerID = C.CustomerID);
```

## تجنب الدوال على الأعمدة في WHERE

```sql
-- ❌ سيء
SELECT * FROM Employees
WHERE UPPER(FirstName) = 'AHMED';

-- ✅ جيد
SELECT * FROM Employees
WHERE FirstName = N'أحمد';
```

## استخدام NOLOCK (بحذر!)

```sql
-- قراءة بدون قفل (قد تقرأ بيانات غير ثابتة)
SELECT * FROM Employees WITH (NOLOCK);
```

## تحديث الإحصائيات

```sql
-- تحديث إحصائيات جدول
UPDATE STATISTICS Employees;

-- تحديث جميع الإحصائيات
EXEC sp_updatestats;
```

## إعادة بناء الفهارس

```sql
-- إعادة بناء فهرس معين
ALTER INDEX IX_Employees_LastName 
ON Employees REBUILD;

-- إعادة بناء جميع الفهارس
ALTER INDEX ALL ON Employees REBUILD;

-- إعادة تنظيم (أسرع من REBUILD)
ALTER INDEX IX_Employees_LastName 
ON Employees REORGANIZE;
```

## استخدام WITH (RECOMPILE)

```sql
-- إعادة تجميع لكل تنفيذ (للاستعلامات الديناميكية)
SELECT * FROM Employees
WHERE Salary > @MinSalary
OPTION (RECOMPILE);
```

## STATISTICS IO & TIME

```sql
-- عرض إحصائيات الأداء
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM Employees
WHERE DepartmentID = 5;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

## أفضل الممارسات

### الاستعلامات

- ✅ حدد الأعمدة المطلوبة فقط
- ✅ استخدم WHERE لتقليل النتائج
- ✅ استخدم الفهارس المناسبة
- ✅ تجنب الدوال على أعمدة WHERE
- ✅ استخدم EXISTS بدلاً من IN للاستعلامات الكبيرة

### الفهارس

- ✅ أنشئ فهارس على أعمدة WHERE وJOIN
- ✅ استخدم Covering Indexes
- ✅ لا تُفرط في الفهارس
- ✅ أعد بناء الفهارس المجزأة

### الجداول

- ✅ استخدم أنواع البيانات المناسبة
- ✅ تجنب NULL عندما لا تحتاجه
- ✅ قسّم الجداول الكبيرة جداً (Partitioning)
- ✅ نظّف البيانات القديمة

### الذاكرة

- ✅ راقب استخدام الذاكرة
- ✅ زد الذاكرة المخصصة لـ SQL Server
- ✅ استخدم Buffer Pool بكفاءة

## أدوات مفيدة

```sql
-- عرض الاستعلامات البطيئة
SELECT TOP 10
    qs.execution_count,
    qs.total_worker_time / 1000 AS TotalCPU_ms,
    qs.total_elapsed_time / 1000 AS TotalElapsed_ms,
    SUBSTRING(qt.text, qs.statement_start_offset/2+1,
        (CASE WHEN qs.statement_end_offset = -1
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) AS QueryText
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY TotalCPU_ms DESC;

-- عرض الفهارس المفقودة المقترحة
SELECT 
    mid.statement AS TableName,
    migs.avg_user_impact AS AvgImpact,
    migs.user_seeks + migs.user_scans AS TotalSeeks
FROM sys.dm_db_missing_index_details mid
INNER JOIN sys.dm_db_missing_index_groups mig 
    ON mid.index_handle = mig.index_handle
INNER JOIN sys.dm_db_missing_index_group_stats migs 
    ON mig.index_group_handle = migs.group_handle
ORDER BY AvgImpact DESC;
```

---

[⬅️ السابق: CTEs](19_ctes.md)
 [🏠 العودة للفهرس](README.md)
