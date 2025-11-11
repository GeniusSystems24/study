# 4. إنشاء قواعد البيانات والجداول

## إنشاء قاعدة بيانات (CREATE DATABASE)

### البنية الأساسية

```sql
CREATE DATABASE DatabaseName;
```

### مثال بسيط

```sql
-- إنشاء قاعدة بيانات
CREATE DATABASE SchoolDB;
GO

-- التحقق من الإنشاء
SELECT name, database_id, create_date
FROM sys.databases
WHERE name = 'SchoolDB';
```

### إنشاء قاعدة بيانات بخيارات متقدمة

```sql
CREATE DATABASE CompanyDB
ON PRIMARY
(
    NAME = 'CompanyDB_Data',
    FILENAME = 'C:\SQLData\CompanyDB.mdf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = 'CompanyDB_Log',
    FILENAME = 'C:\SQLData\CompanyDB_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
);
GO
```

### حذف قاعدة بيانات

```sql
-- تأكد أولاً أنك لست متصلاً بالقاعدة
USE master;
GO

-- حذف القاعدة
DROP DATABASE SchoolDB;
GO
```

### نسخ احتياطي سريع

```sql
-- عمل نسخة احتياطية
BACKUP DATABASE CompanyDB
TO DISK = 'C:\Backups\CompanyDB.bak'
WITH FORMAT, INIT;
GO
```

## استخدام قاعدة بيانات (USE)

```sql
-- الانتقال لقاعدة بيانات محددة
USE CompanyDB;
GO

-- التحقق من القاعدة الحالية
SELECT DB_NAME() AS CurrentDatabase;
```

## إنشاء جدول (CREATE TABLE)

### البنية الأساسية

```sql
CREATE TABLE TableName (
    Column1 DataType Constraints,
    Column2 DataType Constraints,
    ...
);
```

### مثال بسيط

```sql
USE CompanyDB;
GO

CREATE TABLE Employees (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email VARCHAR(100),
    HireDate DATE
);
GO
```

### عرض بنية الجدول

```sql
-- طريقة 1
EXEC sp_help 'Employees';

-- طريقة 2
EXEC sp_columns 'Employees';

-- طريقة 3: في SSMS
-- انقر بالزر الأيمن على الجدول > Design
```

## القيود (Constraints)

### 1. PRIMARY KEY (المفتاح الأساسي)

```sql
-- طريقة 1: في تعريف العمود
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100)
);

-- طريقة 2: كقيد منفصل
CREATE TABLE Teachers (
    TeacherID INT,
    TeacherName NVARCHAR(100),
    CONSTRAINT PK_Teachers PRIMARY KEY (TeacherID)
);

-- مفتاح أساسي مركب (Composite)
CREATE TABLE Enrollment (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    CONSTRAINT PK_Enrollment PRIMARY KEY (StudentID, CourseID)
);
```

### 2. IDENTITY (الترقيم التلقائي)

```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),  -- يبدأ من 1، يزيد بمقدار 1
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

-- إدراج بيانات (لا تحتاج لإدراج ProductID)
INSERT INTO Products (ProductName, Price)
VALUES (N'لابتوب', 3500.00);

-- عرض
SELECT * FROM Products;
```

### 3. UNIQUE (قيمة فريدة)

```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) UNIQUE,            -- لا يمكن التكرار
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20) UNIQUE
);

-- محاولة إدراج قيمة مكررة ستفشل
INSERT INTO Users VALUES ('ahmed', 'ahmed@example.com', '0501234567');
-- INSERT INTO Users VALUES ('ahmed', 'another@example.com', '0507654321'); -- خطأ!
```

### 4. NOT NULL (قيمة إلزامية)

```sql
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,        -- إلزامي
    LastName NVARCHAR(50) NOT NULL,         -- إلزامي
    Email VARCHAR(100),                     -- اختياري
    PhoneNumber VARCHAR(20) NOT NULL        -- إلزامي
);

-- هذا سيفشل (FirstName مفقود)
-- INSERT INTO Customers (LastName, PhoneNumber) VALUES (N'أحمد', '0501234567');

-- هذا صحيح
INSERT INTO Customers (FirstName, LastName, PhoneNumber)
VALUES (N'محمد', N'علي', '0501234567');
```

### 5. DEFAULT (قيمة افتراضية)

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),          -- التاريخ الحالي افتراضياً
    Status NVARCHAR(20) DEFAULT N'قيد المعالجة',
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);

-- الإدراج بدون تحديد القيم الافتراضية
INSERT INTO Orders (CustomerID) VALUES (1);

-- عرض
SELECT * FROM Orders;
```

### 6. CHECK (شرط فحص)

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 18 AND Age <= 65),   -- العمر بين 18 و 65
    Salary DECIMAL(10,2) CHECK (Salary > 0),   -- الراتب أكبر من صفر
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Email VARCHAR(100) CHECK (Email LIKE '%@%.%')
);

-- هذا سيفشل (العمر أقل من 18)
-- INSERT INTO Employees (FirstName, Age, Salary, Gender, Email)
-- VALUES (N'أحمد', 15, 3000, 'M', 'ahmed@example.com');

-- هذا صحيح
INSERT INTO Employees (FirstName, Age, Salary, Gender, Email)
VALUES (N'محمد', 25, 5000, 'M', 'mohamed@example.com');
```

### 7. FOREIGN KEY (المفتاح الخارجي)

```sql
-- جدول الأقسام (الجدول الأب)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL
);

-- جدول الموظفين (الجدول الابن)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT FK_Employees_Departments 
        FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
);

-- إدراج بيانات
INSERT INTO Departments VALUES (N'الموارد البشرية');
INSERT INTO Departments VALUES (N'تقنية المعلومات');

INSERT INTO Employees VALUES (N'أحمد محمد', 1);
INSERT INTO Employees VALUES (N'فاطمة علي', 2);

-- هذا سيفشل (القسم رقم 99 غير موجود)
-- INSERT INTO Employees VALUES (N'خالد', 99);
```

### خيارات FOREIGN KEY

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    
    -- عند حذف العميل، احذف الطلبات
    CONSTRAINT FK_Orders_Customers 
        FOREIGN KEY (CustomerID) 
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE          -- حذف تلقائي
        ON UPDATE CASCADE          -- تحديث تلقائي
);

-- الخيارات المتاحة:
-- CASCADE: حذف/تحديث تلقائي
-- SET NULL: وضع NULL
-- SET DEFAULT: وضع القيمة الافتراضية
-- NO ACTION: منع الحذف/التحديث (الافتراضي)
```

## جدول شامل بجميع القيود

```sql
CREATE TABLE ComprehensiveTable (
    -- المفتاح الأساسي مع ترقيم تلقائي
    ID INT PRIMARY KEY IDENTITY(1,1),
    
    -- قيود NOT NULL و UNIQUE
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    
    -- قيود CHECK
    Age INT CHECK (Age BETWEEN 18 AND 100),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Salary DECIMAL(10,2) CHECK (Salary >= 3000),
    
    -- قيود DEFAULT
    RegistrationDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    Status NVARCHAR(20) DEFAULT N'نشط',
    
    -- مفتاح خارجي
    DepartmentID INT NOT NULL,
    CONSTRAINT FK_Dept FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
        ON DELETE CASCADE,
    
    -- قيد مخصص بالاسم
    CONSTRAINT CK_Email CHECK (Email LIKE '%@%.%')
);
```

## تعديل الجداول (ALTER TABLE)

### إضافة عمود

```sql
ALTER TABLE Employees
ADD PhoneNumber VARCHAR(20);

-- إضافة عمود مع قيمة افتراضية
ALTER TABLE Employees
ADD Country NVARCHAR(50) DEFAULT N'السعودية';
```

### حذف عمود

```sql
ALTER TABLE Employees
DROP COLUMN PhoneNumber;
```

### تعديل نوع عمود

```sql
ALTER TABLE Employees
ALTER COLUMN FirstName NVARCHAR(100);
```

### إضافة قيد (Constraint)

```sql
-- إضافة Primary Key
ALTER TABLE Employees
ADD CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);

-- إضافة Foreign Key
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID);

-- إضافة Check
ALTER TABLE Employees
ADD CONSTRAINT CK_Salary CHECK (Salary > 0);

-- إضافة Unique
ALTER TABLE Employees
ADD CONSTRAINT UQ_Email UNIQUE (Email);

-- إضافة Default
ALTER TABLE Employees
ADD CONSTRAINT DF_IsActive DEFAULT 1 FOR IsActive;
```

### حذف قيد

```sql
-- حذف Foreign Key
ALTER TABLE Employees
DROP CONSTRAINT FK_Employees_Departments;

-- حذف Check
ALTER TABLE Employees
DROP CONSTRAINT CK_Salary;
```

## حذف جدول

```sql
-- حذف جدول
DROP TABLE Employees;

-- حذف إذا كان موجوداً فقط
IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;

-- في SQL Server 2016+
DROP TABLE IF EXISTS Employees;
```

## مسح البيانات (TRUNCATE)

```sql
-- مسح جميع البيانات (أسرع من DELETE)
TRUNCATE TABLE Employees;

-- الفرق بين TRUNCATE و DELETE:
-- TRUNCATE: لا يمكن التراجع، يعيد IDENTITY للصفر، أسرع
-- DELETE: يمكن التراجع، لا يعيد IDENTITY، أبطأ
```

## الجداول المؤقتة (Temporary Tables)

### جدول مؤقت محلي

```sql
-- يُحذف تلقائياً عند إغلاق الاتصال
CREATE TABLE #TempEmployees (
    EmployeeID INT,
    EmployeeName NVARCHAR(100)
);

INSERT INTO #TempEmployees VALUES (1, N'أحمد');
SELECT * FROM #TempEmployees;
```

### جدول مؤقت عام

```sql
-- مرئي لجميع الاتصالات
CREATE TABLE ##GlobalTemp (
    ID INT,
    Name NVARCHAR(100)
);
```

## متغيرات الجداول (Table Variables)

```sql
DECLARE @EmployeeTable TABLE (
    EmployeeID INT,
    EmployeeName NVARCHAR(100),
    Salary DECIMAL(10,2)
);

INSERT INTO @EmployeeTable VALUES (1, N'أحمد', 5000);
INSERT INTO @EmployeeTable VALUES (2, N'فاطمة', 6000);

SELECT * FROM @EmployeeTable;
```

## أمثلة عملية شاملة

### قاعدة بيانات متجر إلكتروني

```sql
-- إنشاء القاعدة
CREATE DATABASE OnlineStoreDB;
GO

USE OnlineStoreDB;
GO

-- جدول الفئات
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);

-- جدول المنتجات
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Stock INT DEFAULT 0 CHECK (Stock >= 0),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
        ON DELETE CASCADE
);

-- جدول العملاء
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    RegistrationDate DATE DEFAULT GETDATE()
);

-- جدول الطلبات
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    Status NVARCHAR(20) DEFAULT N'قيد المعالجة',
    
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

-- جدول تفاصيل الطلبات
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2),
    
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
        
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
```

## خلاصة

- ✅ `CREATE DATABASE` لإنشاء قاعدة بيانات
- ✅ `CREATE TABLE` لإنشاء جدول
- ✅ `PRIMARY KEY` للمفتاح الأساسي
- ✅ `FOREIGN KEY` للعلاقات بين الجداول
- ✅ `NOT NULL, UNIQUE, CHECK, DEFAULT` للقيود
- ✅ `IDENTITY` للترقيم التلقائي
- ✅ `ALTER TABLE` للتعديل
- ✅ `DROP TABLE` للحذف

---

[⬅️ الموضوع السابق: أنواع البيانات](03_data_types.md)
 [الموضوع التالي: عمليات الإدخال والتحديث والحذف ⬅️](05_dml.md)
 [العودة للفهرس 🏠](README.md)
