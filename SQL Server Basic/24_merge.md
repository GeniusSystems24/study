# 24. أمر MERGE

## مقدمة

**MERGE** يسمح بتنفيذ INSERT و UPDATE و DELETE في أمر واحد بناءً على شرط معين. يُعرف أيضاً بـ "UPSERT".

## البنية الأساسية

```sql
MERGE TargetTable AS Target
USING SourceTable AS Source
ON Target.ID = Source.ID
WHEN MATCHED THEN
    UPDATE SET Target.Column = Source.Column
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Columns...) VALUES (Source.Columns...)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

## مثال بسيط

```sql
-- إنشاء جداول للتجربة
CREATE TABLE EmployeesTarget (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2),
    LastModified DATETIME2
);

CREATE TABLE EmployeesSource (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    Salary DECIMAL(10,2)
);

-- إدراج بيانات
INSERT INTO EmployeesTarget VALUES 
(1, N'أحمد', 10000, GETDATE()),
(2, N'فاطمة', 12000, GETDATE()),
(3, N'محمد', 9000, GETDATE());

INSERT INTO EmployeesSource VALUES 
(2, N'فاطمة', 13000),  -- تحديث
(3, N'محمود', 9500),   -- تحديث الاسم والراتب
(4, N'سارة', 11000);   -- إضافة جديد

-- تنفيذ MERGE
MERGE EmployeesTarget AS T
USING EmployeesSource AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED THEN
    UPDATE SET 
        T.FirstName = S.FirstName,
        T.Salary = S.Salary,
        T.LastModified = GETDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, FirstName, Salary, LastModified)
    VALUES (S.EmployeeID, S.FirstName, S.Salary, GETDATE())
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- النتيجة: 
-- تم تحديث: 2, 3
-- تم إضافة: 4
-- تم حذف: 1
```

## MERGE مع OUTPUT

```sql
-- تتبع التغييرات
MERGE EmployeesTarget AS T
USING EmployeesSource AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED THEN
    UPDATE SET T.Salary = S.Salary
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, FirstName, Salary)
    VALUES (S.EmployeeID, S.FirstName, S.Salary)
OUTPUT 
    $action AS Action,
    INSERTED.EmployeeID AS EmployeeID,
    INSERTED.FirstName AS NewName,
    DELETED.FirstName AS OldName,
    INSERTED.Salary AS NewSalary,
    DELETED.Salary AS OldSalary;

/*
النتيجة:
Action  | EmployeeID | NewName | OldName | NewSalary | OldSalary
--------+------------+---------+---------+-----------+-----------
UPDATE  | 2          | فاطمة   | فاطمة   | 13000     | 12000
INSERT  | 4          | سارة    | NULL    | 11000     | NULL
*/
```

## MERGE بشروط إضافية

```sql
-- تحديث فقط إذا تغير الراتب
MERGE EmployeesTarget AS T
USING EmployeesSource AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED AND T.Salary <> S.Salary THEN
    UPDATE SET 
        T.Salary = S.Salary,
        T.LastModified = GETDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, FirstName, Salary, LastModified)
    VALUES (S.EmployeeID, S.FirstName, S.Salary, GETDATE());
```

## MERGE مع عدة UPDATE

```sql
-- شروط تحديث مختلفة
MERGE ProductsTarget AS T
USING ProductsSource AS S
ON T.ProductID = S.ProductID
WHEN MATCHED AND S.Price > T.Price THEN
    UPDATE SET 
        T.Price = S.Price,
        T.PriceIncreased = 1,
        T.LastModified = GETDATE()
WHEN MATCHED AND S.Price < T.Price THEN
    UPDATE SET 
        T.Price = S.Price,
        T.PriceDecreased = 1,
        T.LastModified = GETDATE()
WHEN MATCHED THEN
    UPDATE SET T.LastModified = GETDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (S.ProductID, S.ProductName, S.Price);
```

## مثال عملي: مزامنة المخزون

```sql
-- جدول المخزون الرئيسي
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Quantity INT,
    LastUpdated DATETIME2,
    UpdatedBy NVARCHAR(50)
);

-- جدول التحديثات القادمة من النظام الخارجي
CREATE TABLE InventoryUpdates (
    ProductID INT,
    ProductName NVARCHAR(100),
    QuantityChange INT,  -- موجب = زيادة، سالب = نقص
    UpdateSource NVARCHAR(50)
);

-- مزامنة المخزون
MERGE Inventory AS T
USING InventoryUpdates AS S
ON T.ProductID = S.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        T.Quantity = T.Quantity + S.QuantityChange,
        T.LastUpdated = GETDATE(),
        T.UpdatedBy = S.UpdateSource
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Quantity, LastUpdated, UpdatedBy)
    VALUES (S.ProductID, S.ProductName, S.QuantityChange, GETDATE(), S.UpdateSource)
OUTPUT 
    $action,
    INSERTED.ProductID,
    INSERTED.ProductName,
    DELETED.Quantity AS OldQuantity,
    INSERTED.Quantity AS NewQuantity,
    INSERTED.UpdatedBy;
```

## MERGE مع CTE

```sql
-- استخدام CTE كمصدر
WITH EmployeeSalaryUpdates AS (
    SELECT 
        EmployeeID,
        CASE 
            WHEN Performance >= 90 THEN Salary * 1.15
            WHEN Performance >= 75 THEN Salary * 1.10
            WHEN Performance >= 60 THEN Salary * 1.05
            ELSE Salary
        END AS NewSalary
    FROM EmployeePerformance
)
MERGE Employees AS T
USING EmployeeSalaryUpdates AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED AND T.Salary <> S.NewSalary THEN
    UPDATE SET 
        T.Salary = S.NewSalary,
        T.LastSalaryUpdate = GETDATE();
```

## مثال متقدم: إدارة الطلبات

```sql
-- دمج بيانات الطلبات من نظام خارجي
MERGE Orders AS T
USING ExternalOrders AS S
ON T.OrderNumber = S.OrderNumber
WHEN MATCHED AND S.OrderStatus = 'Cancelled' THEN
    UPDATE SET 
        T.OrderStatus = 5,  -- ملغي
        T.CancelledDate = GETDATE(),
        T.ModifiedAt = GETDATE()
WHEN MATCHED AND S.OrderStatus = 'Completed' THEN
    UPDATE SET 
        T.OrderStatus = 4,  -- مكتمل
        T.DeliveredDate = S.CompletionDate,
        T.ModifiedAt = GETDATE()
WHEN MATCHED THEN
    UPDATE SET 
        T.TotalAmount = S.TotalAmount,
        T.ModifiedAt = GETDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        OrderNumber, CustomerID, OrderDate, 
        TotalAmount, OrderStatus, CreatedAt
    )
    VALUES (
        S.OrderNumber, S.CustomerID, S.OrderDate,
        S.TotalAmount, 1, GETDATE()
    )
OUTPUT 
    $action AS Action,
    INSERTED.OrderNumber,
    DELETED.OrderStatus AS OldStatus,
    INSERTED.OrderStatus AS NewStatus,
    DELETED.TotalAmount AS OldAmount,
    INSERTED.TotalAmount AS NewAmount
INTO OrderAuditLog (
    Action, OrderNumber, OldStatus, NewStatus, 
    OldAmount, NewAmount, AuditDate
);
```

## MERGE مع Transaction

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- تحديث المنتجات
    MERGE Products AS T
    USING StagingProducts AS S
    ON T.ProductCode = S.ProductCode
    WHEN MATCHED THEN
        UPDATE SET 
            T.ProductName = S.ProductName,
            T.Price = S.Price,
            T.StockQuantity = S.StockQuantity
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (ProductCode, ProductName, Price, StockQuantity)
        VALUES (S.ProductCode, S.ProductName, S.Price, S.StockQuantity)
    WHEN NOT MATCHED BY SOURCE THEN
        UPDATE SET T.IsActive = 0;  -- تعطيل المنتجات غير الموجودة
    
    -- حذف بيانات الـ Staging بعد النجاح
    TRUNCATE TABLE StagingProducts;
    
    COMMIT TRANSACTION;
    PRINT N'✅ تمت المزامنة بنجاح';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT N'❌ حدث خطأ: ' + ERROR_MESSAGE();
END CATCH;
```

## MERGE مقابل INSERT/UPDATE/DELETE منفصلة

```sql
-- ❌ الطريقة التقليدية (3 أوامر)
UPDATE T
SET T.Salary = S.Salary
FROM Employees T
INNER JOIN EmployeesSource S ON T.EmployeeID = S.EmployeeID;

INSERT INTO Employees (EmployeeID, FirstName, Salary)
SELECT EmployeeID, FirstName, Salary
FROM EmployeesSource S
WHERE NOT EXISTS (SELECT 1 FROM Employees T WHERE T.EmployeeID = S.EmployeeID);

DELETE T
FROM Employees T
WHERE NOT EXISTS (SELECT 1 FROM EmployeesSource S WHERE S.EmployeeID = T.EmployeeID);

-- ✅ الطريقة الأفضل (MERGE - أمر واحد)
MERGE Employees AS T
USING EmployeesSource AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED THEN UPDATE SET T.Salary = S.Salary
WHEN NOT MATCHED BY TARGET THEN INSERT (EmployeeID, FirstName, Salary) VALUES (S.EmployeeID, S.FirstName, S.Salary)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
```

## Stored Procedure مع MERGE

```sql
CREATE PROCEDURE sp_SyncEmployees
    @SourceTable NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @RowsAffected TABLE (
        Action VARCHAR(10),
        EmployeeID INT
    );
    
    SET @SQL = N'
    MERGE Employees AS T
    USING ' + @SourceTable + N' AS S
    ON T.EmployeeID = S.EmployeeID
    WHEN MATCHED THEN
        UPDATE SET 
            T.FirstName = S.FirstName,
            T.LastName = S.LastName,
            T.Salary = S.Salary,
            T.ModifiedAt = GETDATE()
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (EmployeeID, FirstName, LastName, Salary, CreatedAt)
        VALUES (S.EmployeeID, S.FirstName, S.LastName, S.Salary, GETDATE())
    OUTPUT $action, INSERTED.EmployeeID;';
    
    INSERT INTO @RowsAffected
    EXEC sp_executesql @SQL;
    
    -- عرض الإحصائيات
    SELECT 
        Action,
        COUNT(*) AS Count
    FROM @RowsAffected
    GROUP BY Action;
END;
GO

-- الاستخدام
EXEC sp_SyncEmployees @SourceTable = 'EmployeesSource';
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم MERGE عندما تحتاج مزامنة كاملة
-- ✅ ضع MERGE داخل Transaction للبيانات الحساسة
-- ✅ استخدم OUTPUT لتتبع التغييرات

-- ⚠️ احذر من استخدام WHEN NOT MATCHED BY SOURCE THEN DELETE
-- قد يحذف بيانات غير مقصودة إذا كان المصدر فارغاً

-- ✅ أضف شرط حماية
MERGE Employees AS T
USING EmployeesSource AS S
ON T.EmployeeID = S.EmployeeID
WHEN MATCHED THEN UPDATE SET T.Salary = S.Salary
WHEN NOT MATCHED BY TARGET THEN INSERT (...)
WHEN NOT MATCHED BY SOURCE 
    AND T.IsActive = 1  -- فقط السجلات النشطة
    THEN DELETE;

-- ✅ استخدم مع الفهارس للأداء الأفضل
CREATE INDEX IX_EmployeeID ON EmployeesSource(EmployeeID);

-- ⚠️ MERGE قد يسبب deadlocks في الجداول الكبيرة
-- استخدم TOP في حالة المعالجة المجمعة (Batch Processing)
WHILE 1 = 1
BEGIN
    MERGE TOP (1000) Employees AS T
    USING EmployeesSource AS S
    ON T.EmployeeID = S.EmployeeID
    WHEN MATCHED THEN UPDATE SET T.Salary = S.Salary;
    
    IF @@ROWCOUNT = 0 BREAK;
END;
```

## الخلاصة

- **MERGE**: عملية واحدة لـ INSERT/UPDATE/DELETE
- **WHEN MATCHED**: تحديث السجلات الموجودة
- **WHEN NOT MATCHED BY TARGET**: إضافة سجلات جديدة
- **WHEN NOT MATCHED BY SOURCE**: حذف السجلات غير الموجودة في المصدر
- **OUTPUT**: تتبع التغييرات
- **مثالي للمزامنة** بين الجداول أو الأنظمة

---

[⬅️ السابق: CASE Expressions](23_case_expressions.md)
 [التالي: الجداول المؤقتة ⬅️](25_temp_tables.md)
 [🏠 العودة للفهرس](README.md)
