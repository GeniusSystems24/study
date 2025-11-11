# 15. المعاملات (Transactions)

## ما هي Transaction؟

مجموعة عمليات تُنفذ كوحدة واحدة: إما تنجح كلها أو تفشل كلها.

## ACID Properties

- **A**tomicity: كل شيء أو لا شيء
- **C**onsistency: الحفاظ على سلامة البيانات
- **I**solation: عزل المعاملات عن بعضها
- **D**urability: الحفظ الدائم بعد COMMIT

## البنية الأساسية

```sql
BEGIN TRANSACTION;

-- عمليات SQL
INSERT ...
UPDATE ...
DELETE ...

-- إذا نجح كل شيء
COMMIT;

-- أو التراجع عند الخطأ
ROLLBACK;
```

## مثال: تحويل مالي

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- خصم من حساب
    UPDATE Accounts
    SET Balance = Balance - 500
    WHERE AccountID = 1;
    
    -- التحقق من الرصيد
    IF (SELECT Balance FROM Accounts WHERE AccountID = 1) < 0
    BEGIN
        RAISERROR(N'رصيد غير كافٍ', 16, 1);
    END
    
    -- إضافة لحساب آخر
    UPDATE Accounts
    SET Balance = Balance + 500
    WHERE AccountID = 2;
    
    -- حفظ التغييرات
    COMMIT;
    PRINT N'تمت العملية بنجاح';
END TRY
BEGIN CATCH
    -- التراجع عند الخطأ
    ROLLBACK;
    PRINT N'فشلت العملية: ' + ERROR_MESSAGE();
END CATCH;
```

## SAVEPOINT

```sql
BEGIN TRANSACTION;

INSERT INTO Employees VALUES ('Ahmed', 5000);
SAVE TRANSACTION SavePoint1;

INSERT INTO Employees VALUES ('Fatima', 6000);
SAVE TRANSACTION SavePoint2;

-- التراجع لنقطة محددة
ROLLBACK TRANSACTION SavePoint1;

COMMIT;
```

## مستويات العزل (Isolation Levels)

```sql
-- READ UNCOMMITTED (الأقل أماناً)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- READ COMMITTED (الافتراضي)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- SERIALIZABLE (الأكثر أماناً)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

## مثال عملي: معالجة طلب

```sql
BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @OrderID INT;
    
    -- 1. إنشاء طلب
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (5, GETDATE(), 0);
    
    SET @OrderID = SCOPE_IDENTITY();
    
    -- 2. إضافة تفاصيل
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (@OrderID, 101, 2, 3500);
    
    -- 3. خصم من المخزون
    UPDATE Products
    SET Stock = Stock - 2
    WHERE ProductID = 101;
    
    -- 4. التحقق من المخزون
    IF (SELECT Stock FROM Products WHERE ProductID = 101) < 0
    BEGIN
        RAISERROR(N'المخزون غير كافٍ', 16, 1);
    END
    
    -- 5. تحديث إجمالي الطلب
    UPDATE Orders
    SET TotalAmount = (SELECT SUM(Quantity * UnitPrice) 
                       FROM OrderDetails 
                       WHERE OrderID = @OrderID)
    WHERE OrderID = @OrderID;
    
    COMMIT;
    PRINT N'تم إنشاء الطلب بنجاح';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT N'فشل الطلب: ' + ERROR_MESSAGE();
END CATCH;
```

---

[⬅️ السابق: Triggers](14_triggers.md)
 [التالي: Backup & Restore ⬅️](16_backup.md)
 [🏠 الفهرس](README.md)
