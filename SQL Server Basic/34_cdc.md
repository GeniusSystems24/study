# 34. تتبع تغيير البيانات (Change Data Capture - CDC)

## ما هو CDC؟

ميزة تتبع جميع التغييرات (INSERT/UPDATE/DELETE) على جدول.

## تفعيل CDC

```sql
-- 1. تفعيل على مستوى القاعدة
EXEC sys.sp_cdc_enable_db;

-- 2. تفعيل على جدول محدد
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Employees',
    @role_name = NULL;
```

## قراءة التغييرات

```sql
-- الحصول على التغييرات
DECLARE @from_lsn BINARY(10) = sys.fn_cdc_get_min_lsn('dbo_Employees');
DECLARE @to_lsn BINARY(10) = sys.fn_cdc_get_max_lsn();

SELECT 
    __$operation AS Operation,  -- 1=Delete, 2=Insert, 3=Update(Before), 4=Update(After)
    __$start_lsn,
    __$update_mask,
    *
FROM cdc.fn_cdc_get_all_changes_dbo_Employees(@from_lsn, @to_lsn, 'all');

/*
Operation values:
1 = DELETE
2 = INSERT
3 = UPDATE (قبل التحديث)
4 = UPDATE (بعد التحديث)
*/
```

## مثال عملي - Audit Trail

```sql
-- إنشاء جدول للتدقيق
CREATE TABLE EmployeeAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    EmployeeID INT,
    Operation VARCHAR(10),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ChangedDate DATETIME2 DEFAULT SYSDATETIME()
);

-- Trigger لتسجيل التغييرات
CREATE TRIGGER tr_Employee_Audit
ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- INSERT
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO EmployeeAudit (EmployeeID, Operation, NewValue)
        SELECT 
            EmployeeID,
            'INSERT',
            CONCAT('Name:', FirstName, ', Salary:', Salary)
        FROM inserted;
    END
    
    -- UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO EmployeeAudit (EmployeeID, Operation, OldValue, NewValue)
        SELECT 
            i.EmployeeID,
            'UPDATE',
            CONCAT('Name:', d.FirstName, ', Salary:', d.Salary),
            CONCAT('Name:', i.FirstName, ', Salary:', i.Salary)
        FROM inserted i
        INNER JOIN deleted d ON i.EmployeeID = d.EmployeeID;
    END
    
    -- DELETE
    IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO EmployeeAudit (EmployeeID, Operation, OldValue)
        SELECT 
            EmployeeID,
            'DELETE',
            CONCAT('Name:', FirstName, ', Salary:', Salary)
        FROM deleted;
    END
END;
```

## تعطيل CDC

```sql
-- تعطيل على جدول
EXEC sys.sp_cdc_disable_table
    @source_schema = N'dbo',
    @source_name = N'Employees',
    @capture_instance = N'dbo_Employees';

-- تعطيل على القاعدة
EXEC sys.sp_cdc_disable_db;
```

## الخلاصة

- يتتبع جميع التغييرات تلقائياً
- مفيد للتدقيق والمزامنة
- يستهلك مساحة تخزين إضافية

---

[⬅️ السابق: Full-Text Search](33_fulltext_search.md)
 [التالي: Temporal Tables ⬅️](35_temporal_tables.md)
 [🏠 العودة للفهرس](README.md)
