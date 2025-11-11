# 37. الأقفال والحجز (Locks & Blocking)

## أنواع الأقفال

```sql
-- Shared Lock (S) - القراءة
-- Exclusive Lock (X) - الكتابة
-- Update Lock (U) - التحديث
-- Intent Lock (IS, IX) - النية
```

## عرض الأقفال الحالية

```sql
-- عرض جميع الأقفال
SELECT 
    resource_type,
    resource_database_id,
    resource_associated_entity_id,
    request_mode,
    request_type,
    request_status
FROM sys.dm_tran_locks;

-- Blocking Queries
SELECT 
    blocking_session_id,
    session_id,
    wait_type,
    wait_time,
    wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
```

## Isolation Levels

```sql
-- 1. READ UNCOMMITTED (أقل عزل - قراءة قذرة)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM Employees;  -- قد تقرأ بيانات غير مُلتزمة

-- 2. READ COMMITTED (افتراضي)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM Employees;  -- يقرأ البيانات المُلتزمة فقط

-- 3. REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
    SELECT * FROM Employees WHERE EmployeeID = 1;
    -- نفس الاستعلام سيعطي نفس النتيجة
    SELECT * FROM Employees WHERE EmployeeID = 1;
COMMIT;

-- 4. SERIALIZABLE (أقوى عزل - أبطأ)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- 5. SNAPSHOT (مثالي للتقارير)
ALTER DATABASE MyDatabase SET ALLOW_SNAPSHOT_ISOLATION ON;
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
```

## NOLOCK Hint

```sql
-- قراءة بدون انتظار (قد تقرأ بيانات غير ملتزمة)
SELECT * FROM Employees WITH (NOLOCK);

-- مفيد للتقارير التي لا تحتاج دقة 100%
```

## حل Deadlocks

```sql
-- Deadlock: جلستان تنتظران بعضهما

-- الوقاية:
-- ✅ استخدم نفس ترتيب الجداول
-- ✅ اجعل Transactions قصيرة
-- ✅ استخدم Isolation Level مناسب

-- معالجة Deadlock
BEGIN TRY
    BEGIN TRANSACTION;
        UPDATE Table1 SET ...;
        UPDATE Table2 SET ...;
    COMMIT;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 1205  -- Deadlock
    BEGIN
        ROLLBACK;
        WAITFOR DELAY '00:00:01';
        -- إعادة المحاولة
    END
END CATCH;
```

## قتل جلسة معلقة

```sql
-- عرض الجلسات
EXEC sp_who2;

-- قتل جلسة
KILL 53;  -- رقم الجلسة
```

## الخلاصة

- **Locks**: آلية التحكم في التزامن
- **Blocking**: جلسة تنتظر أخرى
- **Deadlock**: جلستان تنتظران بعضهما
- استخدم Isolation Level المناسب
- NOLOCK للقراءات السريعة

---

[⬅️ السابق: Statistics](36_statistics.md)
 [التالي: Database Snapshots ⬅️](38_snapshots.md)
 [🏠 العودة للفهرس](README.md)
