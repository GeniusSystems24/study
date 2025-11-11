# 36. الإحصائيات (Statistics)

## ما هي Statistics؟

معلومات يستخدمها SQL Server Query Optimizer لاختيار أفضل Execution Plan.

## عرض الإحصائيات

```sql
-- عرض جميع الإحصائيات على جدول
EXEC sp_helpstats 'Employees', 'ALL';

-- عرض تفاصيل إحصائية معينة
DBCC SHOW_STATISTICS('Employees', 'PK_Employees');
```

## تحديث الإحصائيات

```sql
-- تحديث إحصائيات جدول واحد
UPDATE STATISTICS Employees;

-- تحديث إحصائية محددة
UPDATE STATISTICS Employees PK_Employees;

-- تحديث جميع الجداول
EXEC sp_updatestats;

-- تحديث مع فحص كامل
UPDATE STATISTICS Employees WITH FULLSCAN;
```

## إنشاء إحصائيات يدوياً

```sql
-- إنشاء إحصائية على عمود
CREATE STATISTICS ST_Salary 
ON Employees(Salary)
WITH FULLSCAN;

-- على عدة أعمدة
CREATE STATISTICS ST_Dept_Salary 
ON Employees(DepartmentID, Salary);
```

## Auto Update Statistics

```sql
-- تفعيل التحديث التلقائي (افتراضي)
ALTER DATABASE MyDatabase 
SET AUTO_UPDATE_STATISTICS ON;

-- تحديث غير متزامن (للأداء)
ALTER DATABASE MyDatabase 
SET AUTO_UPDATE_STATISTICS_ASYNC ON;
```

## متى تحدث الإحصائيات؟

```sql
-- ✅ بعد INSERT/UPDATE/DELETE كبيرة
-- ✅ عند ملاحظة بطء الاستعلامات
-- ✅ بعد إعادة بناء الفهارس
-- ✅ دورياً (كل ليلة مثلاً)

-- جدولة تحديث الإحصائيات
CREATE PROCEDURE sp_UpdateAllStatistics
AS
BEGIN
    DECLARE @TableName NVARCHAR(200);
    
    DECLARE TableCursor CURSOR FOR
    SELECT TABLE_NAME 
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE';
    
    OPEN TableCursor;
    FETCH NEXT FROM TableCursor INTO @TableName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC('UPDATE STATISTICS ' + @TableName + ' WITH FULLSCAN');
        FETCH NEXT FROM TableCursor INTO @TableName;
    END;
    
    CLOSE TableCursor;
    DEALLOCATE TableCursor;
END;
```

## الخلاصة

- **Statistics** = معلومات عن توزيع البيانات
- Query Optimizer يعتمد عليها لاختيار الـ Plan
- تحديثها مهم للأداء الجيد
- عادة تُحدث تلقائياً، لكن قد تحتاج تحديث يدوي

---

[⬅️ السابق: Temporal Tables](35_temporal_tables.md)
 [التالي: Locks & Blocking ⬅️](37_locks.md)
 [🏠 العودة للفهرس](README.md)
