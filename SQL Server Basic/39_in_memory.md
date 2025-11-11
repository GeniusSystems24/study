# 39. In-Memory OLTP

## ما هو In-Memory OLTP؟

تقنية تخزين الجداول في الذاكرة RAM بدلاً من القرص لأداء فائق السرعة.

## المزايا

- ✅ أسرع 10-30 مرة من الجداول العادية
- ✅ لا توجد أقفال (Lock-free)
- ✅ مثالي للعمليات الكثيفة (High throughput)

## إنشاء Memory-Optimized Table

```sql
-- 1. إضافة Filegroup للـ Memory
ALTER DATABASE MyDatabase 
ADD FILEGROUP MyDB_MemoryOptimized CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE MyDatabase 
ADD FILE (
    NAME = 'MyDB_MemoryOptimized',
    FILENAME = 'C:\SQLData\MyDB_MemoryOptimized'
) TO FILEGROUP MyDB_MemoryOptimized;

-- 2. إنشاء الجدول
CREATE TABLE SessionData (
    SessionID INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
    UserID INT NOT NULL,
    SessionStart DATETIME2 NOT NULL,
    SessionData NVARCHAR(4000),
    INDEX IX_UserID NONCLUSTERED (UserID)
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
```

## أنواع Durability

```sql
-- SCHEMA_AND_DATA: يحفظ البيانات (افتراضي)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);

-- SCHEMA_ONLY: لا يحفظ البيانات (أسرع)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_ONLY);
```

## Natively Compiled Stored Procedures

```sql
CREATE PROCEDURE sp_GetUserSession
    @UserID INT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC WITH (
    TRANSACTION ISOLATION LEVEL = SNAPSHOT,
    LANGUAGE = N'English'
)
    SELECT SessionID, SessionStart, SessionData
    FROM dbo.SessionData
    WHERE UserID = @UserID;
END;
```

## متى تستخدم؟

```sql
-- ✅ استخدم عندما:
-- 1. عمليات INSERT/UPDATE كثيفة جداً
-- 2. Session state, Shopping carts
-- 3. Staging tables
-- 4. Real-time analytics

-- ❌ لا تستخدم عندما:
-- 1. البيانات كبيرة جداً (RAM محدود)
-- 2. استعلامات معقدة (محدودية الميزات)
-- 3. بيانات نادرة الاستخدام
```

## مثال - Session Management

```sql
-- جدول Sessions سريع
CREATE TABLE UserSessions (
    SessionID UNIQUEIDENTIFIER NOT NULL 
        PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
    UserID INT NOT NULL,
    LoginTime DATETIME2 NOT NULL,
    LastActivity DATETIME2 NOT NULL,
    IsActive BIT NOT NULL,
    
    INDEX IX_UserID NONCLUSTERED (UserID),
    INDEX IX_LastActivity NONCLUSTERED (LastActivity)
) WITH (
    MEMORY_OPTIMIZED = ON, 
    DURABILITY = SCHEMA_ONLY  -- لا نحتاج حفظ Sessions بعد Restart
);

-- Procedure سريعة
CREATE PROCEDURE sp_UpdateSession
    @SessionID UNIQUEIDENTIFIER,
    @UserID INT
WITH NATIVE_COMPILATION, SCHEMABINDING
AS
BEGIN ATOMIC WITH (
    TRANSACTION ISOLATION LEVEL = SNAPSHOT,
    LANGUAGE = N'English'
)
    UPDATE dbo.UserSessions
    SET LastActivity = SYSDATETIME()
    WHERE SessionID = @SessionID AND UserID = @UserID;
END;
```

## المحددات

```sql
-- ❌ لا يدعم:
-- - FOREIGN KEY (يمكن استخدام CHECK constraints)
-- - IDENTITY (استخدم SEQUENCE)
-- - Computed columns مع PERSISTED
-- - بعض أنواع البيانات (VARCHAR(MAX), XML كبير)
```

## مراقبة الأداء

```sql
-- استهلاك الذاكرة
SELECT 
    object_name(object_id) AS TableName,
    memory_allocated_for_table_kb,
    memory_used_by_table_kb
FROM sys.dm_db_xtp_table_memory_stats;

-- إحصائيات
SELECT * FROM sys.dm_db_xtp_table_memory_stats;
SELECT * FROM sys.dm_db_xtp_hash_index_stats;
```

## الخلاصة

- **In-Memory OLTP**: جداول في RAM
- أسرع بكثير من الجداول العادية
- مثالي للعمليات الكثيفة جداً
- يحتاج RAM كافي
- له محددات في الميزات

---

[⬅️ السابق: Database Snapshots](38_snapshots.md)
[التالي: Spatial Data ⬅️](40_spatial_data.md)
[🏠 العودة للفهرس](README.md)
