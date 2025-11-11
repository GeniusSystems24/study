# 7. الدوال المدمجة (Built-in Functions)

## الدوال النصية (String Functions)

```sql
-- LEN: طول النص
SELECT LEN(N'أحمد محمد');  -- 9

-- UPPER/LOWER: تحويل الحالة
SELECT UPPER('hello'), LOWER('WORLD');

-- SUBSTRING: استخراج جزء
SELECT SUBSTRING(N'أحمد محمد', 1, 4);  -- أحمد

-- LEFT/RIGHT
SELECT LEFT(N'أحمد محمد', 4);   -- أحمد
SELECT RIGHT(N'أحمد محمد', 3);  -- حمد

-- LTRIM/RTRIM/TRIM: إزالة المسافات
SELECT TRIM('  نص  ');

-- REPLACE: الاستبدال
SELECT REPLACE(N'أحمد محمد', N'محمد', N'علي');

-- CONCAT: دمج النصوص
SELECT CONCAT(N'أحمد', ' ', N'محمد');

-- STRING_AGG: دمج صفوف
SELECT STRING_AGG(FirstName, ', ')
FROM Employees;
```

## الدوال الرقمية (Math Functions)

```sql
-- ABS: القيمة المطلقة
SELECT ABS(-15);  -- 15

-- CEILING/FLOOR: التقريب
SELECT CEILING(4.3);  -- 5
SELECT FLOOR(4.9);    -- 4

-- ROUND: التقريب لأقرب رقم
SELECT ROUND(123.4567, 2);  -- 123.46

-- POWER: الأس
SELECT POWER(2, 10);  -- 1024

-- SQRT: الجذر التربيعي
SELECT SQRT(16);  -- 4

-- RAND: رقم عشوائي
SELECT RAND();
```

## دوال التاريخ (Date Functions)

```sql
-- GETDATE: التاريخ والوقت الحالي
SELECT GETDATE();

-- YEAR/MONTH/DAY
SELECT 
    YEAR(GETDATE()) AS السنة,
    MONTH(GETDATE()) AS الشهر,
    DAY(GETDATE()) AS اليوم;

-- DATEADD: إضافة/طرح
SELECT DATEADD(DAY, 7, GETDATE());     -- بعد 7 أيام
SELECT DATEADD(MONTH, -3, GETDATE());  -- قبل 3 أشهر

-- DATEDIFF: الفرق
SELECT DATEDIFF(DAY, '2020-01-01', GETDATE());
SELECT DATEDIFF(YEAR, HireDate, GETDATE()) AS سنوات_الخدمة
FROM Employees;

-- FORMAT: التنسيق
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd');
SELECT FORMAT(GETDATE(), 'dd/MM/yyyy');
```

## الدوال التجميعية (Aggregate Functions)

```sql
-- COUNT: العدد
SELECT COUNT(*) FROM Employees;
SELECT COUNT(Email) FROM Employees;  -- يتجاهل NULL

-- SUM: المجموع
SELECT SUM(Salary) FROM Employees;

-- AVG: المتوسط
SELECT AVG(Salary) FROM Employees;

-- MIN/MAX
SELECT 
    MIN(Salary) AS أقل_راتب,
    MAX(Salary) AS أعلى_راتب
FROM Employees;
```

## دوال التحويل

```sql
-- CAST
SELECT CAST('123' AS INT);
SELECT CAST(Salary AS VARCHAR(10)) FROM Employees;

-- CONVERT
SELECT CONVERT(VARCHAR, GETDATE(), 103);  -- dd/mm/yyyy

-- ISNULL: قيمة بديلة للـ NULL
SELECT 
    FirstName,
    ISNULL(Email, 'غير متوفر') AS البريد
FROM Employees;

-- COALESCE: أول قيمة غير NULL
SELECT COALESCE(Email, Phone, N'لا يوجد') FROM Employees;
```

---

[⬅️ السابق: SELECT](06_select.md)
 [التالي: JOINs ⬅️](08_joins.md)
 [🏠 الفهرس](README.md)
