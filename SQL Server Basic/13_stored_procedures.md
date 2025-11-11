# 13. الإجراءات المخزنة (Stored Procedures)

## ما هي Stored Procedure؟

برنامج SQL محفوظ في قاعدة البيانات يمكن استدعاؤه وتنفيذه متى شئت.

## إنشاء Stored Procedure بسيطة

```sql
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;

-- تنفيذ
EXEC GetAllEmployees;
```

## Stored Procedure مع معاملات

```sql
-- معامل إدخال
CREATE PROCEDURE GetEmployeesByDept
    @DepartmentID INT
AS
BEGIN
    SELECT * FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

-- تنفيذ
EXEC GetEmployeesByDept @DepartmentID = 2;
```

## معاملات متعددة

```sql
CREATE PROCEDURE GetEmployeesBySalaryRange
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2)
AS
BEGIN
    SELECT FirstName, LastName, Salary
    FROM Employees
    WHERE Salary BETWEEN @MinSalary AND @MaxSalary
    ORDER BY Salary;
END;

-- تنفيذ
EXEC GetEmployeesBySalaryRange 4000, 6000;
```

## معامل إخراج (OUTPUT)

```sql
CREATE PROCEDURE GetEmployeeCount
    @DepartmentID INT,
    @Count INT OUTPUT
AS
BEGIN
    SELECT @Count = COUNT(*)
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

-- تنفيذ
DECLARE @EmpCount INT;
EXEC GetEmployeeCount @DepartmentID = 1, @Count = @EmpCount OUTPUT;
SELECT @EmpCount AS عدد_الموظفين;
```

## Stored Procedure مع INSERT

```sql
CREATE PROCEDURE AddEmployee
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10,2),
    @DepartmentID INT
AS
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, Salary, DepartmentID)
    VALUES (@FirstName, @LastName, @Email, @Salary, @DepartmentID);
    
    SELECT SCOPE_IDENTITY() AS NewEmployeeID;
END;
```

## مع معالجة الأخطاء

```sql
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;
        
        PRINT N'تم تحديث الراتب بنجاح';
    END TRY
    BEGIN CATCH
        PRINT N'خطأ: ' + ERROR_MESSAGE();
    END CATCH
END;
```

## تعديل Stored Procedure

```sql
ALTER PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE IsActive = 1;
END;
```

## حذف Stored Procedure

```sql
DROP PROCEDURE GetAllEmployees;
```

---

[⬅️ السابق: Keys](12_keys.md)
 [التالي: Triggers ⬅️](14_triggers.md)
 [🏠 الفهرس](README.md)
