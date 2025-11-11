# 14. المحفزات (Triggers)

## ما هو Trigger؟

كود يتم تنفيذه تلقائياً عند حدوث حدث معين (INSERT, UPDATE, DELETE).

## AFTER Trigger

```sql
-- Trigger بعد الإدراج
CREATE TRIGGER trg_AfterInsert_Employee
ON Employees
AFTER INSERT
AS
BEGIN
    PRINT N'تم إضافة موظف جديد';
    
    -- تسجيل في جدول آخر
    INSERT INTO EmployeeAudit (EmployeeID, Action, ActionDate)
    SELECT EmployeeID, 'INSERT', GETDATE()
    FROM INSERTED;
END;
```

## AFTER UPDATE Trigger

```sql
CREATE TRIGGER trg_AfterUpdate_Salary
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)  -- إذا تم تحديث عمود الراتب
    BEGIN
        INSERT INTO SalaryHistory (EmployeeID, OldSalary, NewSalary, ChangeDate)
        SELECT 
            I.EmployeeID,
            D.Salary AS OldSalary,
            I.Salary AS NewSalary,
            GETDATE()
        FROM INSERTED I
        INNER JOIN DELETED D ON I.EmployeeID = D.EmployeeID;
    END
END;
```

## AFTER DELETE Trigger

```sql
CREATE TRIGGER trg_AfterDelete_Employee
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedEmployees (EmployeeID, FirstName, DeletedDate)
    SELECT EmployeeID, FirstName, GETDATE()
    FROM DELETED;
END;
```

## INSTEAD OF Trigger

```sql
-- تنفيذ كود بدلاً من الأمر الأصلي
CREATE TRIGGER trg_InsteadOfDelete_Employee
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    -- بدلاً من الحذف، نضع علامة غير نشط
    UPDATE Employees
    SET IsActive = 0, DeletedDate = GETDATE()
    WHERE EmployeeID IN (SELECT EmployeeID FROM DELETED);
    
    PRINT N'تم تعطيل الموظف بدلاً من حذفه';
END;
```

## عرض Triggers

```sql
-- عرض triggers لجدول معين
SELECT * FROM sys.triggers
WHERE parent_id = OBJECT_ID('Employees');
```

## تعطيل/تفعيل Trigger

```sql
-- تعطيل
DISABLE TRIGGER trg_AfterInsert_Employee ON Employees;

-- تفعيل
ENABLE TRIGGER trg_AfterInsert_Employee ON Employees;
```

## حذف Trigger

```sql
DROP TRIGGER trg_AfterInsert_Employee;
```

---

[⬅️ السابق: Stored Procedures](13_stored_procedures.md)
 [التالي: Transactions ⬅️](15_transactions.md)
 [🏠 الفهرس](README.md)
