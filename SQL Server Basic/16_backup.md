# 16. النسخ الاحتياطي والاستعادة (Backup & Restore)

## أنواع النسخ الاحتياطي

### 1. Full Backup (نسخة كاملة)

```sql
-- نسخة احتياطية كاملة
BACKUP DATABASE CompanyDB
TO DISK = 'C:\Backups\CompanyDB_Full.bak'
WITH FORMAT, INIT,
NAME = 'Full Backup of CompanyDB';
```

### 2. Differential Backup (نسخة تفاضلية)

```sql
-- نسخ التغييرات منذ آخر Full Backup
BACKUP DATABASE CompanyDB
TO DISK = 'C:\Backups\CompanyDB_Diff.bak'
WITH DIFFERENTIAL,
NAME = 'Differential Backup';
```

### 3. Transaction Log Backup

```sql
-- نسخ سجل المعاملات
BACKUP LOG CompanyDB
TO DISK = 'C:\Backups\CompanyDB_Log.trn'
WITH NAME = 'Log Backup';
```

## استعادة قاعدة البيانات

### استعادة كاملة

```sql
-- إغلاق الاتصالات أولاً
USE master;
GO

ALTER DATABASE CompanyDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- الاستعادة
RESTORE DATABASE CompanyDB
FROM DISK = 'C:\Backups\CompanyDB_Full.bak'
WITH REPLACE;

-- إعادة فتح القاعدة
ALTER DATABASE CompanyDB SET MULTI_USER;
```

### استعادة إلى قاعدة جديدة

```sql
RESTORE DATABASE CompanyDB_Copy
FROM DISK = 'C:\Backups\CompanyDB_Full.bak'
WITH MOVE 'CompanyDB_Data' TO 'C:\Data\CompanyDB_Copy.mdf',
     MOVE 'CompanyDB_Log' TO 'C:\Data\CompanyDB_Copy_Log.ldf';
```

## النسخ الاحتياطي التلقائي

```sql
-- استخدام SQL Server Agent لجدولة نسخ احتياطية دورية
-- في SSMS: SQL Server Agent > Jobs > New Job
```

## التحقق من النسخة الاحتياطية

```sql
-- فحص النسخة
RESTORE VERIFYONLY
FROM DISK = 'C:\Backups\CompanyDB_Full.bak';

-- معلومات النسخة
RESTORE HEADERONLY
FROM DISK = 'C:\Backups\CompanyDB_Full.bak';

-- محتويات النسخة
RESTORE FILELISTONLY
FROM DISK = 'C:\Backups\CompanyDB_Full.bak';
```

## أفضل الممارسات

- ✅ نسخ احتياطي Full يومي أو أسبوعي
- ✅ نسخ Differential عدة مرات باليوم
- ✅ نسخ Log كل ساعة (للقواعد المهمة)
- ✅ حفظ النسخ في أماكن متعددة
- ✅ اختبار الاستعادة دورياً

---

[⬅️ السابق: Transactions](15_transactions.md)
 [التالي: Security ⬅️](17_security.md)
 [🏠 الفهرس](README.md)
