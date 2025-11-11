# 38. لقطات قاعدة البيانات (Database Snapshots)

## ما هي Database Snapshot؟

نسخة للقراءة فقط من قاعدة البيانات في لحظة معينة.

## إنشاء Snapshot

```sql
CREATE DATABASE MyDB_Snapshot_20251111
ON
(
    NAME = MyDB_Data,
    FILENAME = 'C:\SQLData\MyDB_Snapshot_20251111.ss'
)
AS SNAPSHOT OF MyDatabase;
```

## الاستخدام

```sql
-- القراءة من Snapshot
SELECT * FROM MyDB_Snapshot_20251111.dbo.Employees;

-- مقارنة مع القاعدة الحالية
SELECT 
    Current.EmployeeID,
    Current.Salary AS CurrentSalary,
    Snapshot.Salary AS OldSalary,
    Current.Salary - Snapshot.Salary AS Change
FROM MyDatabase.dbo.Employees AS Current
FULL OUTER JOIN MyDB_Snapshot_20251111.dbo.Employees AS Snapshot
    ON Current.EmployeeID = Snapshot.EmployeeID
WHERE Current.Salary <> Snapshot.Salary;
```

## استعادة من Snapshot

```sql
-- استعادة القاعدة لحالتها وقت Snapshot
RESTORE DATABASE MyDatabase 
FROM DATABASE_SNAPSHOT = 'MyDB_Snapshot_20251111';

-- ⚠️ يحذف جميع التغييرات بعد Snapshot!
```

## حذف Snapshot

```sql
DROP DATABASE MyDB_Snapshot_20251111;
```

## الاستخدامات

```sql
-- ✅ Backup سريع قبل تحديث كبير
-- ✅ تقارير بدون تأثير على Production
-- ✅ استعادة سريعة من أخطاء
-- ✅ مقارنة البيانات قبل وبعد
```

## المحددات

```sql
-- ❌ للقراءة فقط
-- ❌ يعتمد على القاعدة الأصلية
-- ❌ ليس بديلاً عن Backup الكامل
```

## الخلاصة

- نسخة سريعة للقراءة فقط
- مفيدة للتقارير والتجارب
- استعادة أسرع من Backup
- ليست بديلاً عن Backup الحقيقي

---

[⬅️ السابق: Locks](37_locks.md)
 [التالي: In-Memory OLTP ⬅️](39_in_memory.md)
 [🏠 العودة للفهرس](README.md)
