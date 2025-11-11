# 2. التثبيت والإعداد

## تثبيت SQL Server

### الخطوة 1: تحميل SQL Server

#### خيار 1: SQL Server Express (مجاني - للتعلم)

```text
رابط التحميل: https://www.microsoft.com/sql-server/sql-server-downloads
اختر: Express Edition
```

#### خيار 2: SQL Server Developer (مجاني - للتطوير)

```text
رابط التحميل: https://www.microsoft.com/sql-server/sql-server-downloads
اختر: Developer Edition
```

### الخطوة 2: تشغيل ملف التثبيت

1. **قم بتشغيل** الملف المحمل (SQLServer2022-xxx.exe)
2. **اختر نوع التثبيت:**
   - **Basic**: تثبيت سريع بالإعدادات الافتراضية (مُنصح للمبتدئين)
   - **Custom**: تثبيت مخصص
   - **Download Media**: تحميل للتثبيت لاحقاً

### الخطوة 3: الإعدادات الأساسية

#### إذا اخترت Basic

```text
1. قبول الترخيص
2. اختيار مجلد التثبيت
3. الانتظار حتى اكتمال التثبيت
4. تدوين Instance Name (غالباً: SQLEXPRESS أو MSSQLSERVER)
```

#### إذا اخترت Custom

**أ. Feature Selection:**

- ✅ Database Engine Services (إلزامي)
- ✅ SQL Server Replication
- ✅ Full-Text and Semantic Extractions
- ⬜ Machine Learning Services (اختياري)

**ب. Instance Configuration:**

- **Default Instance**: MSSQLSERVER
- أو اختر **Named Instance** مع اسم مخصص

**ج. Server Configuration:**

- **Service Accounts**: اترك الافتراضي
- **Collation**: SQL_Latin1_General_CP1_CI_AS (الافتراضي)

**د. Database Engine Configuration:**

**Authentication Mode:**

```sql
خياران:
1. Windows Authentication (مُنصح للتطوير المحلي)
2. Mixed Mode (Windows + SQL Server Authentication)
```

إذا اخترت Mixed Mode:

- قم بإنشاء كلمة مرور قوية لحساب **sa** (System Administrator)
- أضف المستخدم الحالي كـ SQL Server Administrator

### الخطوة 4: إكمال التثبيت

انتظر حتى تكتمل العملية (قد تستغرق 10-30 دقيقة)

## تثبيت SQL Server Management Studio (SSMS)

### الخطوة 1: التحميل

```text
رابط التحميل: https://aka.ms/ssmsfullsetup
الحجم: ~600 MB تقريباً
```

### الخطوة 2: التثبيت

1. قم بتشغيل SSMS-Setup-ENU.exe
2. اضغط Install
3. انتظر حتى الانتهاء (5-15 دقيقة)
4. إعادة التشغيل (إذا طُلب منك)

## الاتصال بـ SQL Server لأول مرة

### فتح SSMS

1. ابحث عن "SQL Server Management Studio" في قائمة Start
2. افتح البرنامج

### نافذة الاتصال (Connect to Server)

```text
Server type: Database Engine
Server name: 
  - للـ Default Instance: localhost أو .
  - للـ Named Instance: localhost\SQLEXPRESS أو .\SQLEXPRESS
  
Authentication:
  - Windows Authentication (إذا اخترتها عند التثبيت)
  - SQL Server Authentication (إذا فعّلت Mixed Mode)
    - Login: sa
    - Password: [كلمة المرور التي أدخلتها]
```

اضغط **Connect**

## واجهة SSMS

### الأجزاء الرئيسية

#### 1. Object Explorer (مستكشف الكائنات)

```text
الموقع: الجانب الأيسر
الوظيفة: عرض قواعد البيانات، الجداول، الإجراءات المخزنة، إلخ
```

#### 2. Query Editor (محرر الاستعلامات)

```text
الموقع: المنطقة الوسطى
الوظيفة: كتابة وتنفيذ استعلامات SQL
الاختصار: Ctrl+N لفتح نافذة جديدة
```

#### 3. Results Pane (نافذة النتائج)

```text
الموقع: أسفل محرر الاستعلامات
الوظيفة: عرض نتائج الاستعلامات
```

#### 4. Properties Window (نافذة الخصائص)

```text
الموقع: الجانب الأيمن السفلي
الوظيفة: عرض خصائص العنصر المحدد
```

## إنشاء أول قاعدة بيانات

### طريقة 1: باستخدام الواجهة الرسومية

```text
1. في Object Explorer، انقر بالزر الأيمن على Databases
2. اختر New Database...
3. أدخل اسم قاعدة البيانات: MyFirstDB
4. اضغط OK
```

### طريقة 2: باستخدام SQL

```sql
-- إنشاء قاعدة بيانات جديدة
CREATE DATABASE MyFirstDB;
GO

-- استخدام قاعدة البيانات
USE MyFirstDB;
GO
```

### التحقق من إنشاء القاعدة

```sql
-- عرض جميع قواعد البيانات
SELECT name, database_id, create_date 
FROM sys.databases;
```

## إنشاء أول جدول

```sql
-- التأكد من استخدام القاعدة الصحيحة
USE MyFirstDB;
GO

-- إنشاء جدول للموظفين
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    HireDate DATE DEFAULT GETDATE(),
    Salary DECIMAL(10,2)
);
GO

-- عرض بنية الجدول
EXEC sp_help 'Employees';
```

## إدراج بيانات تجريبية

```sql
-- إدراج موظفين
INSERT INTO Employees (FirstName, LastName, Email, Salary)
VALUES 
    (N'أحمد', N'محمد', 'ahmed@example.com', 5000.00),
    (N'فاطمة', N'علي', 'fatima@example.com', 6000.00),
    (N'خالد', N'حسن', 'khaled@example.com', 5500.00);
GO

-- عرض البيانات
SELECT * FROM Employees;
```

## اختصارات SSMS المهمة

| الاختصار | الوظيفة |
|----------|---------|
| **Ctrl+N** | نافذة استعلام جديدة |
| **F5** أو **Ctrl+E** | تنفيذ الاستعلام |
| **Ctrl+R** | إظهار/إخفاء نافذة النتائج |
| **Ctrl+L** | عرض Execution Plan |
| **Ctrl+Shift+R** | تحديث IntelliSense |
| **Ctrl+K, Ctrl+C** | تعليق الكود |
| **Ctrl+K, Ctrl+U** | إلغاء التعليق |
| **Ctrl+U** | تحويل لأحرف صغيرة |
| **Ctrl+Shift+U** | تحويل لأحرف كبيرة |

## قواعد بيانات النظام

عند فتح Object Explorer ستجد:

### 1. master

```text
قاعدة البيانات الرئيسية للنظام
تحتوي على معلومات جميع قواعد البيانات
لا تقم بحذفها أبداً!
```

### 2. model

```text
قالب لقواعد البيانات الجديدة
أي تغيير هنا سيؤثر على القواعد الجديدة
```

### 3. msdb

```text
تُستخدم من SQL Server Agent
تخزين Jobs, Alerts, Backups history
```

### 4. tempdb

```text
تخزين البيانات المؤقتة
يتم إعادة إنشائها عند كل إعادة تشغيل
```

## التحقق من تشغيل SQL Server

### طريقة 1: من SSMS

```sql
SELECT @@VERSION;
SELECT @@SERVERNAME;
SELECT SERVERPROPERTY('Edition');
```

### طريقة 2: من Services

```text
1. اضغط Win+R
2. اكتب: services.msc
3. ابحث عن: SQL Server (MSSQLSERVER) أو SQL Server (SQLEXPRESS)
4. تأكد أن الحالة: Running
```

## حل المشاكل الشائعة

### 1. لا أستطيع الاتصال بـ SQL Server

**الحل:**

```text
1. تأكد من تشغيل SQL Server Service
2. تحقق من اسم الـ Instance
3. فعّل TCP/IP Protocol:
   - افتح SQL Server Configuration Manager
   - SQL Server Network Configuration > Protocols
   - فعّل TCP/IP
   - أعد تشغيل SQL Server Service
```

### 2. نسيت كلمة مرور sa

**الحل:**

```text
استخدم Windows Authentication للدخول
ثم قم بتغيير كلمة المرور:

ALTER LOGIN sa WITH PASSWORD = 'NewStrongPassword123!';
ALTER LOGIN sa ENABLE;
```

### 3. خطأ: Login failed for user

**الحل:**

```sql
-- إضافة مستخدم جديد
CREATE LOGIN MyUser WITH PASSWORD = 'StrongPassword123!';
USE MyFirstDB;
CREATE USER MyUser FOR LOGIN MyUser;
ALTER ROLE db_owner ADD MEMBER MyUser;
```

## بدائل SSMS

### 1. Azure Data Studio

- حديث ومتعدد المنصات (Windows, Mac, Linux)
- واجهة عصرية مع امتدادات
- مناسب لـ SQL Server وPostgreSQL وMySQL

### 2. Visual Studio

- يحتوي على SQL Server Data Tools
- تكامل ممتاز مع مشاريع .NET

### 3. DBeaver

- مجاني ومفتوح المصدر
- يدعم أنظمة قواعد بيانات متعددة

## خلاصة

الآن أصبحت جاهزاً للبدء:

- ✅ تم تثبيت SQL Server
- ✅ تم تثبيت SSMS
- ✅ تم إنشاء أول قاعدة بيانات
- ✅ تم إنشاء أول جدول
- ✅ فهمت واجهة SSMS

في الدرس القادم، سنتعمق في أنواع البيانات!

---

[⬅️ الموضوع السابق: مقدمة](01_introduction.md)
 [الموضوع التالي: أنواع البيانات ⬅️](03_data_types.md)
 [العودة للفهرس 🏠](README.md)
