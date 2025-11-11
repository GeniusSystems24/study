# 30. معالجة الأخطاء (Error Handling)

## TRY...CATCH

```sql
BEGIN TRY
    -- الكود المحتمل حدوث خطأ فيه
    INSERT INTO Employees (EmployeeID, FirstName)
    VALUES (1, N'أحمد');  -- قد يفشل إذا كان ID موجود
    
    PRINT N'✅ تم الإدراج بنجاح';
END TRY
BEGIN CATCH
    -- معالجة الخطأ
    PRINT N'❌ حدث خطأ: ' + ERROR_MESSAGE();
END CATCH;
```

## دوال الأخطاء

```sql
BEGIN TRY
    -- عملية خاطئة
    SELECT 1/0;  -- قسمة على صفر
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_LINE() AS ErrorLine,
        ERROR_PROCEDURE() AS ErrorProcedure;
END CATCH;

/*
النتيجة:
ErrorNumber: 8134
ErrorMessage: Divide by zero error encountered
ErrorSeverity: 16
ErrorState: 1
ErrorLine: 3
ErrorProcedure: NULL
*/
```

## RAISERROR

```sql
-- إطلاق خطأ مخصص
IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = 999)
BEGIN
    RAISERROR(N'الموظف غير موجود', 16, 1);
    RETURN;
END;

-- مع Parameters
DECLARE @EmpID INT = 999;
RAISERROR(N'الموظف رقم %d غير موجود', 16, 1, @EmpID);

-- مع Severity مختلفة
RAISERROR(N'تحذير: البيانات ناقصة', 10, 1);  -- Warning
RAISERROR(N'خطأ حرج', 20, 1) WITH LOG;  -- Critical
```

## THROW (SQL Server 2012+)

```sql
-- THROW أبسط وأفضل من RAISERROR
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = 999)
    BEGIN
        THROW 50001, N'الموظف غير موجود', 1;
    END;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- إعادة إطلاق الخطأ
BEGIN TRY
    SELECT 1/0;
END TRY
BEGIN CATCH
    PRINT N'حدث خطأ، سأعيد إطلاقه...';
    THROW;  -- إعادة نفس الخطأ
END CATCH;
```

## Transactions مع Error Handling

```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- عملية 1
    UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1;
    
    -- عملية 2
    UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 2;
    
    -- إذا نجح كل شيء
    COMMIT TRANSACTION;
    PRINT N'✅ تمت العملية بنجاح';
END TRY
BEGIN CATCH
    -- إذا حدث خطأ
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT N'❌ تم التراجع عن العملية';
    PRINT N'الخطأ: ' + ERROR_MESSAGE();
END CATCH;
```

## مثال كامل - Stored Procedure

```sql
CREATE PROCEDURE sp_TransferMoney
    @FromAccount INT,
    @ToAccount INT,
    @Amount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- التحقق من المدخلات
    IF @Amount <= 0
    BEGIN
        RAISERROR(N'المبلغ يجب أن يكون أكبر من صفر', 16, 1);
        RETURN;
    END;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- التحقق من الرصيد
        DECLARE @CurrentBalance DECIMAL(10,2);
        SELECT @CurrentBalance = Balance 
        FROM Accounts 
        WHERE AccountID = @FromAccount;
        
        IF @CurrentBalance IS NULL
        BEGIN
            RAISERROR(N'الحساب المصدر غير موجود', 16, 1);
            RETURN;
        END;
        
        IF @CurrentBalance < @Amount
        BEGIN
            RAISERROR(N'الرصيد غير كافٍ', 16, 1);
            RETURN;
        END;
        
        -- السحب
        UPDATE Accounts 
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccount;
        
        -- الإيداع
        UPDATE Accounts 
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccount;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR(N'الحساب المستهدف غير موجود', 16, 1);
            RETURN;
        END;
        
        -- تسجيل العملية
        INSERT INTO TransactionLog (FromAccount, ToAccount, Amount, TransactionDate)
        VALUES (@FromAccount, @ToAccount, @Amount, GETDATE());
        
        COMMIT TRANSACTION;
        PRINT N'✅ تمت عملية التحويل بنجاح';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- تسجيل الخطأ
        INSERT INTO ErrorLog (ErrorMessage, ErrorProcedure, ErrorLine, ErrorDate)
        VALUES (
            ERROR_MESSAGE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETDATE()
        );
        
        -- إعادة الخطأ
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
```

## جدول لتسجيل الأخطاء

```sql
CREATE TABLE ErrorLog (
    ErrorID INT IDENTITY PRIMARY KEY,
    ErrorNumber INT,
    ErrorMessage NVARCHAR(4000),
    ErrorSeverity INT,
    ErrorState INT,
    ErrorLine INT,
    ErrorProcedure NVARCHAR(200),
    ErrorDate DATETIME2 DEFAULT SYSDATETIME(),
    UserName NVARCHAR(100) DEFAULT SYSTEM_USER
);

-- Stored Procedure لتسجيل الأخطاء
CREATE PROCEDURE sp_LogError
AS
BEGIN
    INSERT INTO ErrorLog (
        ErrorNumber,
        ErrorMessage,
        ErrorSeverity,
        ErrorState,
        ErrorLine,
        ErrorProcedure
    )
    VALUES (
        ERROR_NUMBER(),
        ERROR_MESSAGE(),
        ERROR_SEVERITY(),
        ERROR_STATE(),
        ERROR_LINE(),
        ERROR_PROCEDURE()
    );
END;
GO

-- الاستخدام
BEGIN TRY
    -- عملية قد تفشل
    SELECT 1/0;
END TRY
BEGIN CATCH
    EXEC sp_LogError;
    THROW;
END CATCH;
```

## XACT_ABORT

```sql
-- إيقاف تلقائي عند الخطأ
SET XACT_ABORT ON;

BEGIN TRANSACTION;
    UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1;
    UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 999;  -- خطأ
COMMIT TRANSACTION;  -- لن يصل هنا
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم TRY...CATCH دائماً
-- ✅ سجل الأخطاء في جدول
-- ✅ استخدم THROW بدلاً من RAISERROR
-- ✅ تحقق من @@TRANCOUNT قبل ROLLBACK
-- ✅ أعد الخطأ بعد المعالجة (THROW;)

-- ❌ لا تستخدم GOTO
-- ❌ لا تترك TRY فارغاً
-- ❌ لا تتجاهل الأخطاء الحرجة
```

## الخلاصة

| الأمر | الاستخدام |
|-------|-----------|
| `TRY...CATCH` | معالجة الأخطاء |
| `ERROR_MESSAGE()` | رسالة الخطأ |
| `ERROR_NUMBER()` | رقم الخطأ |
| `RAISERROR` | إطلاق خطأ (قديم) |
| `THROW` | إطلاق خطأ (حديث) |
| `XACT_ABORT` | إيقاف تلقائي |

---

[⬅️ السابق: Cursors](29_cursors.md)
 [التالي: APPLY Operators ⬅️](31_apply_operators.md)
 [🏠 العودة للفهرس](README.md)
