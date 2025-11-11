# 27. عمليات النصوص (String Operations)

## الدوال الأساسية

### LEN و DATALENGTH

```sql
SELECT 
    LEN(N'أحمد') AS Length,              -- 4 (عدد الأحرف)
    DATALENGTH(N'أحمد') AS DataLength,   -- 8 (بايت - Unicode)
    LEN('Ahmed') AS LengthEn,             -- 5
    DATALENGTH('Ahmed') AS DataLengthEn;  -- 5 (ASCII)

-- الفرق مع المسافات
SELECT 
    LEN('Ahmed   ') AS LEN_Result,        -- 5 (يتجاهل المسافات في النهاية)
    DATALENGTH('Ahmed   ') AS DATA_Result; -- 8 (يحسب المسافات)
```

### SUBSTRING

```sql
-- استخراج جزء من نص
SELECT 
    SUBSTRING(N'أحمد محمد علي', 1, 4) AS FirstName,    -- أحمد
    SUBSTRING(N'أحمد محمد علي', 6, 3) AS MiddleName,   -- محمد
    SUBSTRING(N'أحمد محمد علي', 12, 3) AS LastName;    -- علي

-- استخراج آخر 4 أرقام من رقم الجوال
SELECT 
    PhoneNumber,
    SUBSTRING(PhoneNumber, LEN(PhoneNumber) - 3, 4) AS Last4Digits
FROM Customers;

-- استخراج كود البلد
SELECT 
    PhoneNumber,
    SUBSTRING(PhoneNumber, 1, 3) AS CountryCode
FROM Customers
WHERE PhoneNumber LIKE '+%';
```

### LEFT و RIGHT

```sql
-- أول وآخر أحرف
SELECT 
    FirstName,
    LEFT(FirstName, 1) AS Initial,                    -- الحرف الأول
    RIGHT(Email, 10) AS EmailDomain,                  -- آخر 10 أحرف
    LEFT(NationalID, 1) AS Century                    -- القرن من الرقم القومي
FROM Employees;

-- تنسيق رقم الجوال
SELECT 
    PhoneNumber,
    LEFT(PhoneNumber, 4) + '-' + 
    SUBSTRING(PhoneNumber, 5, 3) + '-' + 
    RIGHT(PhoneNumber, 4) AS FormattedPhone
FROM Employees;
```

### CHARINDEX و PATINDEX

```sql
-- البحث عن موضع نص
SELECT 
    Email,
    CHARINDEX('@', Email) AS AtPosition,
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS Username,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain
FROM Employees;

-- PATINDEX مع Wildcards
SELECT 
    ProductName,
    PATINDEX('%[0-9]%', ProductName) AS FirstDigitPosition,
    PATINDEX('%[A-Z]%', ProductName) AS FirstUpperPosition
FROM Products;

-- التحقق من وجود نص
SELECT 
    FirstName,
    CASE 
        WHEN CHARINDEX(N'محمد', FirstName) > 0 THEN N'يحتوي على محمد'
        ELSE N'لا يحتوي'
    END AS CheckResult
FROM Employees;
```

### REPLACE

```sql
-- استبدال نص
SELECT 
    ProductName,
    REPLACE(ProductName, N'قديم', N'جديد') AS NewName
FROM Products;

-- إزالة المسافات الزائدة
SELECT 
    REPLACE(REPLACE(REPLACE(N'  نص   به   مسافات  ', '  ', ' '), '  ', ' '), '  ', ' ') AS CleanText;

-- تنظيف أرقام الجوال
SELECT 
    REPLACE(REPLACE(REPLACE(PhoneNumber, '-', ''), '(', ''), ')', '') AS CleanPhone
FROM Customers;

-- استبدال متعدد
SELECT 
    Address,
    REPLACE(REPLACE(REPLACE(Address, N'شارع', N'ش.'), N'محافظة', N''), N'  ', ' ') AS ShortAddress
FROM Customers;
```

### UPPER, LOWER, INITCAP

```sql
-- تحويل الحالة
SELECT 
    Email,
    UPPER(Email) AS UpperCase,
    LOWER(Email) AS LowerCase
FROM Employees;

-- توحيد البريد الإلكتروني
UPDATE Customers
SET Email = LOWER(Email)
WHERE Email COLLATE Latin1_General_CS_AS <> LOWER(Email);

-- أول حرف كبير (لا توجد دالة built-in)
SELECT 
    FirstName,
    UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName))) AS ProperCase
FROM Employees;
```

### LTRIM, RTRIM, TRIM

```sql
-- إزالة المسافات
SELECT 
    '  Ahmed  ' AS Original,
    LTRIM('  Ahmed  ') AS LeftTrimmed,   -- 'Ahmed  '
    RTRIM('  Ahmed  ') AS RightTrimmed,  -- '  Ahmed'
    TRIM('  Ahmed  ') AS Trimmed;        -- 'Ahmed' (SQL Server 2017+)

-- إزالة أحرف محددة (SQL Server 2017+)
SELECT 
    TRIM(',' FROM ',Ahmed,') AS TrimComma,      -- 'Ahmed'
    TRIM('.' FROM '...Data...') AS TrimDots;    -- 'Data'

-- تنظيف البيانات
UPDATE Products
SET ProductName = TRIM(ProductName)
WHERE ProductName <> TRIM(ProductName);
```

### CONCAT و CONCAT_WS

```sql
-- دمج النصوص
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT(N'الموظف: ', FirstName, N' - القسم: ', DepartmentID) AS Info
FROM Employees;

-- CONCAT يتجاهل NULL تلقائياً
SELECT 
    CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName
FROM Employees;
-- مقابل + الذي يعطي NULL إذا كان أي جزء NULL

-- CONCAT_WS (With Separator) - SQL Server 2017+
SELECT 
    CONCAT_WS(' - ', FirstName, Email, PhoneNumber) AS ContactInfo,
    CONCAT_WS(', ', City, Region, Country) AS Location
FROM Employees;
```

### STRING_AGG

```sql
-- دمج عدة صفوف في نص واحد (SQL Server 2017+)
SELECT 
    DepartmentID,
    STRING_AGG(FirstName, ', ') AS EmployeeList
FROM Employees
GROUP BY DepartmentID;

-- مع ترتيب
SELECT 
    DepartmentID,
    STRING_AGG(FirstName, ', ') WITHIN GROUP (ORDER BY FirstName) AS SortedList
FROM Employees
GROUP BY DepartmentID;

-- قائمة المنتجات لكل فئة
SELECT 
    c.CategoryName,
    STRING_AGG(p.ProductName, ' | ') AS Products
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
```

### STRING_SPLIT

```sql
-- تقسيم نص إلى صفوف (SQL Server 2016+)
DECLARE @Tags NVARCHAR(100) = N'إلكترونيات,كمبيوتر,لابتوب,جديد';

SELECT value AS Tag
FROM STRING_SPLIT(@Tags, ',');

-- استخدام عملي
SELECT 
    p.ProductID,
    p.ProductName,
    t.value AS Tag
FROM Products p
CROSS APPLY STRING_SPLIT(p.Tags, ',') t;

-- البحث في قائمة
DECLARE @SearchIDs VARCHAR(100) = '1,3,5,7,9';

SELECT *
FROM Employees
WHERE EmployeeID IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(@SearchIDs, ','));
```

### REVERSE

```sql
-- عكس النص
SELECT 
    ProductCode,
    REVERSE(ProductCode) AS ReversedCode
FROM Products;

-- التحقق من Palindrome
SELECT 
    Word,
    CASE 
        WHEN Word = REVERSE(Word) THEN N'نعم - متناظر'
        ELSE N'لا'
    END AS IsPalindrome
FROM (VALUES (N'مدام'), (N'أحمد'), (N'12321')) AS T(Word);
```

### STUFF

```sql
-- إدراج أو استبدال جزء من نص
SELECT 
    STUFF('ABCDEFGH', 3, 2, 'XYZ') AS Result;  -- ABXYZEFGH
    -- البدء من الموضع 3، حذف 2 حرف، إدراج 'XYZ'

-- تنسيق الرقم القومي
SELECT 
    NationalID,
    STUFF(NationalID, 4, 0, '-') AS Formatted  -- 123-4567890123
FROM Employees;

-- إخفاء جزء من البريد
SELECT 
    Email,
    STUFF(Email, 2, CHARINDEX('@', Email) - 2, '****') AS MaskedEmail
FROM Employees;
-- ahmed@email.com → a****@email.com
```

### REPLICATE و SPACE

```sql
-- تكرار نص
SELECT 
    REPLICATE('*', 10) AS Stars,          -- **********
    REPLICATE('=', 5) AS Equals,          -- =====
    REPLICATE(N'أ', 3) AS RepeatedChar;   -- أأأ

-- إنشاء padding
SELECT 
    ProductCode,
    REPLICATE('0', 10 - LEN(ProductCode)) + ProductCode AS PaddedCode
FROM Products;

-- SPACE لإنشاء مسافات
SELECT 
    FirstName + SPACE(20 - LEN(FirstName)) + LastName AS PaddedName
FROM Employees;
```

### FORMAT

```sql
-- تنسيق الأرقام (SQL Server 2012+)
SELECT 
    Salary,
    FORMAT(Salary, 'N2', 'en-US') AS FormattedSalary,    -- 10,000.00
    FORMAT(Salary, 'C', 'ar-EG') AS Currency,            -- ج.م.‏ 10,000.00
    FORMAT(GETDATE(), 'dd/MM/yyyy', 'ar-EG') AS Date,    -- 11/11/2025
    FORMAT(GETDATE(), 'dddd', 'ar-EG') AS DayName        -- الاثنين
FROM Employees;
```

## أمثلة عملية

### مثال 1: تنظيف وتوحيد البيانات

```sql
-- تنظيف أسماء الموظفين
UPDATE Employees
SET 
    FirstName = TRIM(UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName)))),
    LastName = TRIM(UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, LEN(LastName)))),
    Email = LOWER(TRIM(Email))
WHERE 
    FirstName <> TRIM(FirstName)
    OR LastName <> TRIM(LastName)
    OR Email <> LOWER(TRIM(Email));
```

### مثال 2: استخراج معلومات من النص

```sql
-- استخراج معلومات من البريد الإلكتروني
SELECT 
    Email,
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS Username,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, 
        CHARINDEX('.', Email, CHARINDEX('@', Email)) - CHARINDEX('@', Email) - 1) AS Domain,
    RIGHT(Email, LEN(Email) - CHARINDEX('.', Email, CHARINDEX('@', Email))) AS Extension
FROM Employees;
```

### مثال 3: توليد رموز

```sql
-- توليد كود منتج
SELECT 
    CategoryName,
    ProductName,
    UPPER(LEFT(CategoryName, 3)) + '-' + 
    REPLICATE('0', 5 - LEN(CAST(ProductID AS VARCHAR))) + 
    CAST(ProductID AS VARCHAR) AS ProductCode
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;
```

### مثال 4: بحث متقدم

```sql
CREATE FUNCTION fn_SearchText
(
    @SearchTerm NVARCHAR(100),
    @TextToSearch NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
    
    IF CHARINDEX(@SearchTerm, @TextToSearch) > 0
        SET @Result = 1;
    
    RETURN @Result;
END;
GO

-- الاستخدام
SELECT *
FROM Products
WHERE dbo.fn_SearchText(N'لابتوب', ProductName) = 1;
```

## نصائح الأداء

```sql
-- ✅ استخدم LIKE بدلاً من CHARINDEX عندما ممكن
-- LIKE يستخدم الفهارس بشكل أفضل
SELECT * FROM Employees WHERE FirstName LIKE 'A%';  -- ✅ أفضل
SELECT * FROM Employees WHERE CHARINDEX('A', FirstName) = 1;  -- ⚠️ أبطأ

-- ✅ تجنب الدوال على الأعمدة المُفهرسة في WHERE
SELECT * FROM Employees WHERE UPPER(Email) = 'AHMED@EMAIL.COM';  -- ❌ لن يستخدم الفهرس
SELECT * FROM Employees WHERE Email = 'ahmed@email.com';  -- ✅ سيستخدم الفهرس

-- ✅ استخدم Computed Columns للعمليات المتكررة
ALTER TABLE Employees
ADD EmailLower AS LOWER(Email) PERSISTED;

CREATE INDEX IX_EmailLower ON Employees(EmailLower);
```

## الخلاصة

| الدالة | الاستخدام |
|--------|-----------|
| `LEN` | طول النص |
| `SUBSTRING` | استخراج جزء |
| `CHARINDEX` | موضع نص |
| `REPLACE` | استبدال نص |
| `UPPER/LOWER` | تحويل الحالة |
| `TRIM` | إزالة مسافات |
| `CONCAT` | دمج نصوص |
| `STRING_AGG` | دمج صفوف |
| `STRING_SPLIT` | تقسيم نص |

---

[⬅️ السابق: Dynamic SQL](26_dynamic_sql.md)
 [التالي: JSON & XML ⬅️](28_json_xml.md)
 [🏠 العودة للفهرس](README.md)
