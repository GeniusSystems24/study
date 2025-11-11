# 12. المفاتيح والعلاقات (Keys & Relationships)

## Primary Key (المفتاح الأساسي)

```sql
-- طريقة 1
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100)
);

-- طريقة 2
CREATE TABLE Teachers (
    TeacherID INT,
    TeacherName NVARCHAR(100),
    CONSTRAINT PK_Teachers PRIMARY KEY (TeacherID)
);

-- مفتاح أساسي مركب
CREATE TABLE Enrollment (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    PRIMARY KEY (StudentID, CourseID)
);
```

## Foreign Key (المفتاح الخارجي)

```sql
-- إنشاء علاقة بين الجداول
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    DepartmentID INT,
    CONSTRAINT FK_Emp_Dept FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);
```

## خيارات Foreign Key

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE      -- حذف الطلبات عند حذف العميل
        ON UPDATE CASCADE      -- تحديث تلقائي
);

-- الخيارات:
-- CASCADE: تطبيق التغيير تلقائياً
-- SET NULL: وضع NULL
-- SET DEFAULT: وضع القيمة الافتراضية
-- NO ACTION: منع الحذف/التحديث (الافتراضي)
```

## أنواع العلاقات

### One-to-Many (واحد لمتعدد)

```sql
-- قسم واحد → موظفون متعددون
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);
```

### Many-to-Many (متعدد لمتعدد)

```sql
-- طلاب متعددون ← → مواد متعددة
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100)
);

-- جدول وسيط
CREATE TABLE StudentCourses (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
```

### One-to-One (واحد لواحد)

```sql
-- موظف واحد ← → بطاقة واحدة
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100)
);

CREATE TABLE EmployeeCards (
    CardID INT PRIMARY KEY,
    EmployeeID INT UNIQUE,  -- UNIQUE لضمان علاقة 1:1
    CardNumber VARCHAR(20),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

---

[⬅️ السابق: Indexes](11_indexes.md)
 [التالي: Stored Procedures ⬅️](13_stored_procedures.md)
 [🏠 الفهرس](README.md)
