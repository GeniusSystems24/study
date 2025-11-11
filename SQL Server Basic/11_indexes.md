# 11. الفهارس (Indexes)

## ما هو الفهرس؟

الفهرس هو بنية بيانات تُحسّن سرعة استرجاع البيانات (مثل فهرس الكتاب).

## Clustered Index

```sql
-- يُنشأ تلقائياً مع PRIMARY KEY
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,  -- Clustered Index تلقائي
    FirstName NVARCHAR(50)
);

-- إنشاء Clustered Index يدوياً
CREATE CLUSTERED INDEX IX_Employees_ID
ON Employees(EmployeeID);
```

⚠️ **ملاحظة**: جدول واحد = فهرس clustered واحد فقط

## Non-Clustered Index

```sql
-- إنشاء فهرس على عمود واحد
CREATE NONCLUSTERED INDEX IX_Employees_LastName
ON Employees(LastName);

-- فهرس على أعمدة متعددة
CREATE NONCLUSTERED INDEX IX_Employees_Name
ON Employees(FirstName, LastName);

-- فهرس مع أعمدة مضمنة
CREATE NONCLUSTERED INDEX IX_Employees_DeptID
ON Employees(DepartmentID)
INCLUDE (FirstName, LastName, Salary);
```

## Unique Index

```sql
-- فهرس يضمن عدم التكرار
CREATE UNIQUE INDEX IX_Employees_Email
ON Employees(Email);
```

## عرض الفهارس

```sql
-- عرض فهارس جدول معين
EXEC sp_helpindex 'Employees';

-- استعلام تفصيلي
SELECT 
    I.name AS IndexName,
    I.type_desc AS IndexType,
    COL_NAME(IC.object_id, IC.column_id) AS ColumnName
FROM sys.indexes I
INNER JOIN sys.index_columns IC ON I.object_id = IC.object_id 
    AND I.index_id = IC.index_id
WHERE I.object_id = OBJECT_ID('Employees');
```

## حذف فهرس

```sql
DROP INDEX IX_Employees_LastName ON Employees;
```

## متى تستخدم الفهارس؟

✅ **استخدم الفهارس على:**

- أعمدة WHERE المستخدمة كثيراً
- أعمدة JOIN
- أعمدة ORDER BY
- أعمدة Foreign Keys

❌ **تجنب الفهارس على:**

- الجداول الصغيرة جداً
- الأعمدة التي تتغير كثيراً
- الأعمدة بقيم قليلة التنوع (مثل Gender)

---

[⬅️ السابق: Subqueries](10_subqueries.md)
 [التالي: Keys & Relationships ⬅️](12_keys.md)
 [🏠 الفهرس](README.md)
