# 5. عمليات الإدخال والتحديث والحذف (DML)

## مقدمة

**DML** (Data Manipulation Language) هي الأوامر المستخدمة للتعامل مع البيانات داخل الجداول:

- **INSERT**: إدخال بيانات جديدة
- **UPDATE**: تحديث بيانات موجودة
- **DELETE**: حذف بيانات

## 1. إدراج البيانات (INSERT)

### البنية الأساسية

```sql
INSERT INTO TableName (Column1, Column2, ...)
VALUES (Value1, Value2, ...);
```

### إدراج صف واحد

```sql
-- تحديد الأعمدة
INSERT INTO Employees (FirstName, LastName, Email, Salary)
VALUES (N'أحمد', N'محمد', 'ahmed@example.com', 5000);

-- إدراج في جميع الأعمدة بالترتيب
INSERT INTO Employees
VALUES (N'فاطمة', N'علي', 'fatima@example.com', 6000);
```

### إدراج عدة صفوف دفعة واحدة

```sql
INSERT INTO Employees (FirstName, LastName, Email, Salary)
VALUES 
    (N'خالد', N'أحمد', 'khaled@example.com', 5500),
    (N'مريم', N'حسن', 'mariam@example.com', 6500),
    (N'عمر', N'سالم', 'omar@example.com', 4800);
```

### إدراج مع القيم الافتراضية

```sql
-- إدراج مع ترك الأعمدة الافتراضية
INSERT INTO Orders (CustomerID, TotalAmount)
VALUES (1, 250.50);
-- OrderDate ستأخذ GETDATE() تلقائياً

-- إدراج DEFAULT صراحة
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES (2, DEFAULT, 180.00);
```

### إدراج من جدول آخر (INSERT INTO SELECT)

```sql
-- نسخ بيانات من جدول لآخر
INSERT INTO EmployeesBackup (FirstName, LastName, Salary)
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 5000;

-- إدراج مع حسابات
INSERT INTO EmployeeSalaries (EmployeeID, AnnualSalary)
SELECT EmployeeID, Salary * 12
FROM Employees;
```

### إدراج مع OUTPUT

```sql
-- عرض الصفوف المُدرجة
INSERT INTO Employees (FirstName, LastName, Email, Salary)
OUTPUT INSERTED.EmployeeID, INSERTED.FirstName, INSERTED.LastName
VALUES (N'سارة', N'محمود', 'sara@example.com', 5200);
```

## 2. تحديث البيانات (UPDATE)

### البنية الأساسية

```sql
UPDATE TableName
SET Column1 = Value1, Column2 = Value2, ...
WHERE Condition;
```

⚠️ **تحذير:** عدم استخدام WHERE يحدّث **جميع الصفوف**!

### تحديث صف واحد

```sql
-- تحديث راتب موظف محدد
UPDATE Employees
SET Salary = 6000
WHERE EmployeeID = 1;

-- تحديث عدة أعمدة
UPDATE Employees
SET Salary = 5500,
    Email = 'newemail@example.com',
    LastModified = GETDATE()
WHERE EmployeeID = 2;
```

### تحديث عدة صفوف

```sql
-- زيادة الراتب 10% لجميع الموظفين
UPDATE Employees
SET Salary = Salary * 1.10;

-- زيادة راتب قسم معين
UPDATE Employees
SET Salary = Salary * 1.15
WHERE DepartmentID = 3;

-- تحديث بناءً على شرط معقد
UPDATE Employees
SET Salary = Salary * 1.20
WHERE Salary < 5000 AND DATEDIFF(YEAR, HireDate, GETDATE()) > 5;
```

### تحديث باستخدام CASE

```sql
-- تحديث مختلف حسب الحالة
UPDATE Employees
SET Salary = CASE 
    WHEN Salary < 4000 THEN Salary * 1.25    -- زيادة 25%
    WHEN Salary < 6000 THEN Salary * 1.15    -- زيادة 15%
    ELSE Salary * 1.10                       -- زيادة 10%
END
WHERE DepartmentID = 5;
```

### تحديث من جدول آخر (UPDATE JOIN)

```sql
-- تحديث بناءً على بيانات من جدول آخر
UPDATE E
SET E.DepartmentName = D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;

-- مثال آخر
UPDATE Products
SET CategoryName = C.CategoryName
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE P.CategoryName IS NULL;
```

### تحديث مع OUTPUT

```sql
-- عرض القيم القديمة والجديدة
UPDATE Employees
SET Salary = Salary * 1.10
OUTPUT 
    DELETED.EmployeeID,
    DELETED.FirstName,
    DELETED.Salary AS OldSalary,
    INSERTED.Salary AS NewSalary
WHERE DepartmentID = 2;
```

## 3. حذف البيانات (DELETE)

### البنية الأساسية

```sql
DELETE FROM TableName
WHERE Condition;
```

⚠️ **تحذير:** عدم استخدام WHERE يحذف **جميع الصفوف**!

### حذف صف واحد

```sql
-- حذف موظف محدد
DELETE FROM Employees
WHERE EmployeeID = 10;

-- حذف بناءً على أكثر من شرط
DELETE FROM Employees
WHERE DepartmentID = 5 AND Salary < 3000;
```

### حذف عدة صفوف

```sql
-- حذف جميع الموظفين غير النشطين
DELETE FROM Employees
WHERE IsActive = 0;

-- حذف الطلبات القديمة
DELETE FROM Orders
WHERE OrderDate < DATEADD(YEAR, -2, GETDATE());

-- حذف الموظفين برواتب منخفضة
DELETE FROM Employees
WHERE Salary < 3000;
```

### حذف بناءً على استعلام فرعي

```sql
-- حذف الموظفين في أقسام محذوفة
DELETE FROM Employees
WHERE DepartmentID NOT IN (SELECT DepartmentID FROM Departments);

-- حذف الطلبات بدون تفاصيل
DELETE FROM Orders
WHERE OrderID NOT IN (SELECT DISTINCT OrderID FROM OrderDetails);
```

### حذف مع JOIN

```sql
-- حذف باستخدام JOIN
DELETE E
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.IsActive = 0;
```

### حذف مع OUTPUT

```sql
-- عرض الصفوف المحذوفة
DELETE FROM Employees
OUTPUT 
    DELETED.EmployeeID,
    DELETED.FirstName,
    DELETED.LastName,
    DELETED.Salary
WHERE Salary < 3000;
```

### حذف TOP

```sql
-- حذف أول 10 صفوف
DELETE TOP (10) FROM Employees
WHERE IsActive = 0;

-- حذف أول 5% من الصفوف
DELETE TOP (5) PERCENT FROM OldLogs;
```

## 4. MERGE (دمج العمليات)

```sql
-- دمج INSERT و UPDATE و DELETE في أمر واحد
MERGE INTO TargetTable AS Target
USING SourceTable AS Source
ON Target.ID = Source.ID
WHEN MATCHED THEN
    UPDATE SET Target.Name = Source.Name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, Name) VALUES (Source.ID, Source.Name)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

### مثال عملي للـ MERGE

```sql
-- جدول الموظفين الحالي
CREATE TABLE CurrentEmployees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Salary DECIMAL(10,2)
);

-- جدول الموظفين الجديد (من نظام آخر)
CREATE TABLE NewEmployees (
    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    Salary DECIMAL(10,2)
);

-- إدراج بيانات تجريبية
INSERT INTO CurrentEmployees VALUES (1, N'أحمد', 5000), (2, N'فاطمة', 6000);
INSERT INTO NewEmployees VALUES (2, N'فاطمة', 6500), (3, N'خالد', 5500);

-- دمج البيانات
MERGE INTO CurrentEmployees AS Target
USING NewEmployees AS Source
ON Target.EmployeeID = Source.EmployeeID
WHEN MATCHED THEN
    -- تحديث إذا كان موجوداً
    UPDATE SET 
        Target.EmployeeName = Source.EmployeeName,
        Target.Salary = Source.Salary
WHEN NOT MATCHED BY TARGET THEN
    -- إدراج إذا كان جديداً
    INSERT (EmployeeID, EmployeeName, Salary)
    VALUES (Source.EmployeeID, Source.EmployeeName, Source.Salary)
WHEN NOT MATCHED BY SOURCE THEN
    -- حذف إذا لم يعد موجوداً في المصدر
    DELETE
OUTPUT $action, INSERTED.*, DELETED.*;
```

## 5. TRUNCATE TABLE

```sql
-- حذف جميع البيانات بسرعة
TRUNCATE TABLE Employees;
```

### الفرق بين DELETE و TRUNCATE

| الميزة | DELETE | TRUNCATE |
|--------|--------|----------|
| **السرعة** | بطيء (يسجل كل صف) | سريع جداً |
| **WHERE** | يدعم | لا يدعم |
| **IDENTITY** | لا يعيد التعيين | يعيد للصفر |
| **ROLLBACK** | يمكن التراجع | يمكن التراجع (في Transaction) |
| **Triggers** | تُطلق | لا تُطلق |
| **Foreign Keys** | يتحقق | لا يعمل مع FK |

```sql
-- DELETE: بطيء، يمكن استخدام WHERE
DELETE FROM Logs WHERE LogDate < '2024-01-01';

-- TRUNCATE: سريع، يحذف كل شيء
TRUNCATE TABLE Logs;
```

## 6. معاملات البيانات (Transactions)

### البنية الأساسية

```sql
BEGIN TRANSACTION;

-- عمليات DML
INSERT INTO ...
UPDATE ...
DELETE FROM ...

-- إذا نجح كل شيء
COMMIT;

-- إذا حدث خطأ
ROLLBACK;
```

### مثال عملي

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- خصم من حساب
    UPDATE Accounts
    SET Balance = Balance - 500
    WHERE AccountID = 1;
    
    -- إضافة لحساب آخر
    UPDATE Accounts
    SET Balance = Balance + 500
    WHERE AccountID = 2;
    
    -- إذا نجح كل شيء
    COMMIT;
    PRINT N'تمت العملية بنجاح';
END TRY
BEGIN CATCH
    -- إذا حدث خطأ، التراجع عن كل شيء
    ROLLBACK;
    PRINT N'حدث خطأ: ' + ERROR_MESSAGE();
END CATCH;
```

## 7. أمثلة عملية شاملة

### سيناريو 1: إدارة المخزون

```sql
-- إضافة منتج جديد
INSERT INTO Products (ProductName, CategoryID, Price, Stock)
VALUES (N'لابتوب HP', 1, 3500.00, 10);

-- تحديث المخزون بعد البيع
UPDATE Products
SET Stock = Stock - 1
WHERE ProductID = 101 AND Stock > 0;

-- حذف المنتجات التي نفذت من المخزون
DELETE FROM Products
WHERE Stock = 0 AND IsDiscontinued = 1;
```

### سيناريو 2: معالجة الطلبات

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- إنشاء طلب جديد
    DECLARE @OrderID INT;
    
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (5, GETDATE(), 0);
    
    SET @OrderID = SCOPE_IDENTITY();
    
    -- إضافة تفاصيل الطلب
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES 
        (@OrderID, 101, 2, 3500.00),
        (@OrderID, 102, 1, 1200.00);
    
    -- تحديث إجمالي الطلب
    UPDATE Orders
    SET TotalAmount = (
        SELECT SUM(Quantity * UnitPrice)
        FROM OrderDetails
        WHERE OrderID = @OrderID
    )
    WHERE OrderID = @OrderID;
    
    -- خصم من المخزون
    UPDATE Products
    SET Stock = Stock - OD.Quantity
    FROM Products P
    INNER JOIN OrderDetails OD ON P.ProductID = OD.ProductID
    WHERE OD.OrderID = @OrderID;
    
    COMMIT;
    PRINT N'تم إنشاء الطلب بنجاح';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT N'فشل إنشاء الطلب: ' + ERROR_MESSAGE();
END CATCH;
```

### سيناريو 3: تنظيف البيانات

```sql
-- حذف الطلبات القديمة والملغاة
DELETE FROM Orders
WHERE Status = N'ملغي' 
  AND OrderDate < DATEADD(YEAR, -1, GETDATE());

-- حذف العملاء غير النشطين
DELETE FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Orders
)
AND RegistrationDate < DATEADD(YEAR, -2, GETDATE());

-- تحديث حالة المنتجات
UPDATE Products
SET IsActive = 0
WHERE Stock = 0 
  AND LastOrderDate < DATEADD(MONTH, -6, GETDATE());
```

## أفضل الممارسات

### 1. استخدم WHERE دائماً

```sql
-- ❌ خطير جداً!
UPDATE Employees SET Salary = 10000;

-- ✅ صحيح
UPDATE Employees 
SET Salary = 10000 
WHERE EmployeeID = 5;
```

### 2. اختبر SELECT قبل DELETE/UPDATE

```sql
-- أولاً: اختبر
SELECT * FROM Employees WHERE Salary < 3000;

-- ثانياً: احذف بثقة
DELETE FROM Employees WHERE Salary < 3000;
```

### 3. استخدم Transactions للعمليات المترابطة

```sql
BEGIN TRANSACTION;
-- عمليات مترابطة
COMMIT; -- أو ROLLBACK
```

### 4. استخدم OUTPUT للتدقيق

```sql
DELETE FROM Employees
OUTPUT DELETED.* INTO DeletedEmployeesLog
WHERE IsActive = 0;
```

### 5. احذر من الحذف التسلسلي (CASCADE)

```sql
-- حذف قسم سيحذف جميع موظفيه إذا كان CASCADE
DELETE FROM Departments WHERE DepartmentID = 5;
```

## خلاصة

- ✅ `INSERT` لإدخال بيانات جديدة
- ✅ `UPDATE` لتحديث بيانات موجودة (استخدم WHERE!)
- ✅ `DELETE` لحذف بيانات (استخدم WHERE!)
- ✅ `MERGE` لدمج العمليات
- ✅ `TRUNCATE` لحذف سريع لجميع البيانات
- ✅ استخدم `Transactions` للأمان
- ✅ اختبر `SELECT` قبل `UPDATE/DELETE`

---

[⬅️ الموضوع السابق: إنشاء القواعد والجداول](04_database_tables.md)
 [الموضوع التالي: الاستعلامات الأساسية ⬅️](06_select.md)
 [العودة للفهرس 🏠](README.md)
