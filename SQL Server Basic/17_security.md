# 17. الأمان والصلاحيات (Security & Permissions)

## إنشاء Login (تسجيل دخول)

```sql
-- Windows Authentication
CREATE LOGIN [DOMAIN\Username] FROM WINDOWS;

-- SQL Server Authentication
CREATE LOGIN ahmed WITH PASSWORD = 'StrongPassword123!';
```

## إنشاء User (مستخدم قاعدة البيانات)

```sql
USE CompanyDB;
GO

-- ربط Login بـ User
CREATE USER ahmed FOR LOGIN ahmed;
```

## الأدوار الثابتة (Fixed Roles)

```sql
-- إضافة لدور قاعدة البيانات
ALTER ROLE db_datareader ADD MEMBER ahmed;    -- قراءة فقط
ALTER ROLE db_datawriter ADD MEMBER ahmed;    -- كتابة
ALTER ROLE db_owner ADD MEMBER ahmed;         -- صلاحيات كاملة
```

## منح صلاحيات (GRANT)

```sql
-- صلاحية SELECT على جدول
GRANT SELECT ON Employees TO ahmed;

-- صلاحيات متعددة
GRANT SELECT, INSERT, UPDATE ON Products TO ahmed;

-- صلاحية على جميع الجداول
GRANT SELECT ON SCHEMA::dbo TO ahmed;

-- صلاحية تنفيذ Stored Procedure
GRANT EXECUTE ON GetEmployees TO ahmed;
```

## إلغاء صلاحيات (REVOKE)

```sql
REVOKE SELECT ON Employees FROM ahmed;
REVOKE INSERT, UPDATE ON Products FROM ahmed;
```

## منع صلاحيات (DENY)

```sql
-- منع صريح (أقوى من GRANT)
DENY DELETE ON Employees TO ahmed;
DENY DROP ANY TABLE TO ahmed;
```

## إنشاء دور مخصص

```sql
-- إنشاء دور
CREATE ROLE SalesTeam;

-- منح صلاحيات للدور
GRANT SELECT ON Customers TO SalesTeam;
GRANT SELECT ON Orders TO SalesTeam;
GRANT INSERT, UPDATE ON Orders TO SalesTeam;

-- إضافة مستخدمين للدور
ALTER ROLE SalesTeam ADD MEMBER ahmed;
ALTER ROLE SalesTeam ADD MEMBER fatima;
```

## عرض الصلاحيات

```sql
-- صلاحيات مستخدم
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');

-- صلاحيات على جدول
SELECT * FROM fn_my_permissions('Employees', 'OBJECT');
```

## Row-Level Security

```sql
-- إنشاء دالة تصفية
CREATE FUNCTION fn_SecurityPredicate(@DepartmentID INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS result
WHERE @DepartmentID = USER_ID();

-- تطبيق السياسة
CREATE SECURITY POLICY DepartmentFilter
ADD FILTER PREDICATE dbo.fn_SecurityPredicate(DepartmentID)
ON dbo.Employees
WITH (STATE = ON);
```

## تشفير البيانات

```sql
-- إنشاء Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';

-- إنشاء Certificate
CREATE CERTIFICATE MyCert WITH SUBJECT = 'Data Encryption';

-- إنشاء Symmetric Key
CREATE SYMMETRIC KEY MyKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE MyCert;
```

---

[⬅️ السابق: Backup](16_backup.md)
 [التالي: Views ⬅️](18_views.md)
 [🏠 الفهرس](README.md)
