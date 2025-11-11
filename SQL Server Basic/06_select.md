# 6. الاستعلامات الأساسية (SELECT)

## مقدمة

**SELECT** هو أكثر أمر استخداماً في SQL. يُستخدم لاسترجاع البيانات من قاعدة البيانات.

## البنية الأساسية

```sql
SELECT Column1, Column2, ...
FROM TableName
WHERE Condition
ORDER BY Column;
```

## اختيار جميع الأعمدة

```sql
-- استرجاع جميع الأعمدة
SELECT * FROM Employees;

-- ⚠️ تجنب * في بيئة الإنتاج (استخدم أسماء الأعمدة)
```

## اختيار أعمدة محددة

```sql
SELECT FirstName, LastName, Email, Salary
FROM Employees;

-- مع أسماء مستعارة
SELECT 
    FirstName AS الاسم_الأول,
    LastName AS الاسم_الأخير,
    Salary AS الراتب
FROM Employees;
```

## WHERE (التصفية)

```sql
-- شرط واحد
SELECT * FROM Employees
WHERE Salary > 5000;

-- شروط متعددة (AND)
SELECT * FROM Employees
WHERE Salary > 5000 AND DepartmentID = 2;

-- شروط متعددة (OR)
SELECT * FROM Employees
WHERE DepartmentID = 1 OR DepartmentID = 2;

-- NOT
SELECT * FROM Employees
WHERE NOT DepartmentID = 3;
```

## المعاملات المنطقية

```sql
-- IN (ضمن قائمة)
SELECT * FROM Employees
WHERE DepartmentID IN (1, 2, 3);

-- BETWEEN (بين قيمتين)
SELECT * FROM Employees
WHERE Salary BETWEEN 4000 AND 6000;

-- LIKE (البحث النصي)
SELECT * FROM Employees
WHERE FirstName LIKE N'أ%';        -- يبدأ بـ أ
WHERE FirstName LIKE N'%مد';       -- ينتهي بـ مد
WHERE FirstName LIKE N'%ح%';       -- يحتوي على ح

-- IS NULL
SELECT * FROM Employees
WHERE Email IS NULL;

-- IS NOT NULL
SELECT * FROM Employees
WHERE Email IS NOT NULL;
```

## ORDER BY (الترتيب)

```sql
-- ترتيب تصاعدي (الافتراضي)
SELECT * FROM Employees
ORDER BY Salary ASC;

-- ترتيب تنازلي
SELECT * FROM Employees
ORDER BY Salary DESC;

-- ترتيب متعدد
SELECT * FROM Employees
ORDER BY DepartmentID ASC, Salary DESC;
```

## DISTINCT (إزالة التكرار)

```sql
-- الأقسام الفريدة
SELECT DISTINCT DepartmentID
FROM Employees;

-- مزيج فريد
SELECT DISTINCT DepartmentID, JobTitle
FROM Employees;
```

## TOP (تحديد عدد النتائج)

```sql
-- أول 10 موظفين
SELECT TOP 10 * FROM Employees;

-- أعلى 5 رواتب
SELECT TOP 5 FirstName, Salary
FROM Employees
ORDER BY Salary DESC;

-- أول 10%
SELECT TOP 10 PERCENT *
FROM Employees
ORDER BY HireDate;

-- TOP مع TIES (تضمين المتساويين)
SELECT TOP 5 WITH TIES FirstName, Salary
FROM Employees
ORDER BY Salary DESC;
```

## الأعمدة المحسوبة

```sql
-- حساب الراتب السنوي
SELECT 
    FirstName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM Employees;

-- دمج النصوص
SELECT 
    FirstName + ' ' + LastName AS FullName,
    Email
FROM Employees;

-- CONCAT (أفضل)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;
```

## GROUP BY (التجميع)

```sql
-- عدد الموظفين في كل قسم
SELECT 
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

-- متوسط الرواتب
SELECT 
    DepartmentID,
    AVG(Salary) AS AvgSalary,
    MIN(Salary) AS MinSalary,
    MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID;
```

## HAVING (تصفية بعد التجميع)

```sql
-- الأقسام التي بها أكثر من 5 موظفين
SELECT 
    DepartmentID,
    COUNT(*) AS EmpCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 5;
```

## خلاصة

- ✅ `SELECT` لاسترجاع البيانات
- ✅ `WHERE` للتصفية قبل التجميع
- ✅ `GROUP BY` للتجميع
- ✅ `HAVING` للتصفية بعد التجميع
- ✅ `ORDER BY` للترتيب
- ✅ `DISTINCT` لإزالة التكرار
- ✅ `TOP` لتحديد عدد النتائج

---

[⬅️ السابق: DML](05_dml.md)
 [التالي: الدوال المدمجة ⬅️](07_functions.md)
 [🏠 الفهرس](README.md)
