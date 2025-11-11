# 35. الجداول الزمنية (Temporal Tables)

## ما هي Temporal Tables؟

جداول تحفظ تاريخ جميع التغييرات تلقائياً (SQL Server 2016+).

## إنشاء Temporal Table

```sql
CREATE TABLE Employees_Temporal
(
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2),
    
    -- أعمدة إلزامية للتتبع
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Employees_History));
```

## العمليات العادية

```sql
-- INSERT/UPDATE/DELETE تعمل بشكل عادي
INSERT INTO Employees_Temporal VALUES (1, N'أحمد', 10000);
UPDATE Employees_Temporal SET Salary = 12000 WHERE EmployeeID = 1;
DELETE FROM Employees_Temporal WHERE EmployeeID = 1;

-- SQL Server يحفظ التاريخ تلقائياً في جدول History
```

## الاستعلامات الزمنية

```sql
-- الوضع الحالي (الافتراضي)
SELECT * FROM Employees_Temporal;

-- في وقت محدد
SELECT * 
FROM Employees_Temporal 
FOR SYSTEM_TIME AS OF '2025-01-01 12:00:00';

-- خلال فترة
SELECT * 
FROM Employees_Temporal 
FOR SYSTEM_TIME BETWEEN '2025-01-01' AND '2025-12-31';

-- جميع التغييرات
SELECT * 
FROM Employees_Temporal 
FOR SYSTEM_TIME ALL
ORDER BY ValidFrom;
```

## تعطيل وتفعيل

```sql
-- تعطيل مؤقت
ALTER TABLE Employees_Temporal SET (SYSTEM_VERSIONING = OFF);

-- تفعيل مرة أخرى
ALTER TABLE Employees_Temporal SET (SYSTEM_VERSIONING = ON);
```

## مثال - تدقيق الرواتب

```sql
-- من غيّر راتب الموظف؟
SELECT 
    EmployeeID,
    FirstName,
    Salary,
    ValidFrom AS ChangedFrom,
    ValidTo AS ChangedTo,
    DATEDIFF(DAY, ValidFrom, ValidTo) AS DaysValid
FROM Employees_Temporal 
FOR SYSTEM_TIME ALL
WHERE EmployeeID = 1
ORDER BY ValidFrom;
```

## الخلاصة

- يحفظ جميع التغييرات تلقائياً
- استعلامات سهلة على البيانات التاريخية
- مثالي للتدقيق والامتثال
- لا يحتاج Triggers أو كود إضافي

---

[⬅️ السابق: CDC](34_cdc.md)
 [التالي: Statistics ⬅️](36_statistics.md)
 [🏠 العودة للفهرس](README.md)
