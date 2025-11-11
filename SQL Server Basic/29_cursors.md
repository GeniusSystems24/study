# 29. المؤشرات (Cursors)

## ⚠️ تحذير

**Cursors بطيئة جداً!** استخدمها فقط عند عدم وجود بديل بـ SET-based operations.

## البنية الأساسية

```sql
-- تعريف Cursor
DECLARE EmployeeCursor CURSOR FOR
SELECT EmployeeID, FirstName, Salary
FROM Employees
WHERE DepartmentID = 1;

-- متغيرات للبيانات
DECLARE @EmpID INT, @Name NVARCHAR(50), @Salary DECIMAL(10,2);

-- فتح Cursor
OPEN EmployeeCursor;

-- جلب أول صف
FETCH NEXT FROM EmployeeCursor INTO @EmpID, @Name, @Salary;

-- حلقة المعالجة
WHILE @@FETCH_STATUS = 0
BEGIN
    -- معالجة الصف الحالي
    PRINT N'الموظف: ' + @Name + N' - الراتب: ' + CAST(@Salary AS NVARCHAR(20));
    
    -- جلب الصف التالي
    FETCH NEXT FROM EmployeeCursor INTO @EmpID, @Name, @Salary;
END;

-- إغلاق وتحرير Cursor
CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;
```

## أنواع Cursors

```sql
-- 1. FORWARD_ONLY (افتراضي) - الأسرع
DECLARE MyCursor CURSOR FORWARD_ONLY FOR
SELECT * FROM Employees;

-- 2. SCROLL - يسمح بالتنقل في جميع الاتجاهات
DECLARE MyCursor CURSOR SCROLL FOR
SELECT * FROM Employees;

OPEN MyCursor;
FETCH FIRST FROM MyCursor;  -- أول صف
FETCH LAST FROM MyCursor;   -- آخر صف
FETCH PRIOR FROM MyCursor;  -- الصف السابق
FETCH NEXT FROM MyCursor;   -- الصف التالي
FETCH ABSOLUTE 5 FROM MyCursor;  -- الصف رقم 5
FETCH RELATIVE 2 FROM MyCursor;  -- بعد صفين من الحالي

-- 3. STATIC - نسخة ثابتة
DECLARE MyCursor CURSOR STATIC FOR
SELECT * FROM Employees;

-- 4. DYNAMIC - يعكس التغييرات
DECLARE MyCursor CURSOR DYNAMIC FOR
SELECT * FROM Employees;

-- 5. KEYSET - يعكس التحديثات فقط
DECLARE MyCursor CURSOR KEYSET FOR
SELECT * FROM Employees;
```

## مثال عملي - تحديث مع Cursor

```sql
-- زيادة الرواتب بنسب مختلفة
DECLARE @EmpID INT, @CurrentSalary DECIMAL(10,2), @NewSalary DECIMAL(10,2);

DECLARE SalaryCursor CURSOR FOR
SELECT EmployeeID, Salary
FROM Employees
WHERE IsActive = 1;

OPEN SalaryCursor;
FETCH NEXT FROM SalaryCursor INTO @EmpID, @CurrentSalary;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- حساب الزيادة
    SET @NewSalary = CASE 
        WHEN @CurrentSalary < 5000 THEN @CurrentSalary * 1.15
        WHEN @CurrentSalary < 10000 THEN @CurrentSalary * 1.10
        ELSE @CurrentSalary * 1.05
    END;
    
    -- التحديث
    UPDATE Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmpID;
    
    FETCH NEXT FROM SalaryCursor INTO @EmpID, @CurrentSalary;
END;

CLOSE SalaryCursor;
DEALLOCATE SalaryCursor;
```

## مثال - معالجة على دفعات

```sql
DECLARE @BatchSize INT = 100;
DECLARE @CurrentBatch INT = 0;
DECLARE @TotalProcessed INT = 0;

DECLARE OrderCursor CURSOR FOR
SELECT OrderID
FROM Orders
WHERE OrderStatus = 1
ORDER BY OrderID;

DECLARE @OrderID INT;

OPEN OrderCursor;
FETCH NEXT FROM OrderCursor INTO @OrderID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- معالجة الطلب
    EXEC sp_ProcessOrder @OrderID;
    
    SET @CurrentBatch = @CurrentBatch + 1;
    SET @TotalProcessed = @TotalProcessed + 1;
    
    -- استراحة بعد كل دفعة
    IF @CurrentBatch = @BatchSize
    BEGIN
        WAITFOR DELAY '00:00:02';  -- انتظار ثانيتين
        SET @CurrentBatch = 0;
        PRINT N'تمت معالجة ' + CAST(@TotalProcessed AS NVARCHAR(10)) + N' طلب';
    END;
    
    FETCH NEXT FROM OrderCursor INTO @OrderID;
END;

CLOSE OrderCursor;
DEALLOCATE OrderCursor;
```

## البديل الأفضل - SET-based Operations

```sql
-- ❌ باستخدام Cursor (بطيء)
DECLARE @EmpID INT;
DECLARE EmpCursor CURSOR FOR SELECT EmployeeID FROM Employees;
OPEN EmpCursor;
FETCH NEXT FROM EmpCursor INTO @EmpID;
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Employees SET Salary = Salary * 1.1 WHERE EmployeeID = @EmpID;
    FETCH NEXT FROM EmpCursor INTO @EmpID;
END;
CLOSE EmpCursor;
DEALLOCATE EmpCursor;

-- ✅ بدون Cursor (أسرع 100x)
UPDATE Employees
SET Salary = Salary * 1.1;
```

## متى تستخدم Cursor؟

```sql
-- ✅ استخدم عندما:
-- 1. عمليات معقدة لكل صف تحتاج Logic مخصص
-- 2. استدعاء Stored Procedures لكل صف
-- 3. معالجة تدريجية لتجنب Blocking

-- ❌ لا تستخدم عندما:
-- 1. يمكن استخدام UPDATE/INSERT/DELETE عادي
-- 2. يمكن استخدام JOINs
-- 3. يمكن استخدام Window Functions
```

## الخلاصة

- **تجنب Cursors قدر الإمكان**
- استخدم SET-based operations
- إذا اضطررت: FORWARD_ONLY و FAST_FORWARD
- أغلق وحرر Cursor دائماً

---

[⬅️ السابق: JSON & XML](28_json_xml.md)
 [التالي: معالجة الأخطاء ⬅️](30_error_handling.md)
 [🏠 العودة للفهرس](README.md)
