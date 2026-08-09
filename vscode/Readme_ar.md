<div dir="rtl">

# قواميس البحث والاستبدال في VS Code

مجموعة توثيق مختصرة ومنظمة لإتقان **البحث Search** و**التعبيرات النمطية Regex** وعمليات **Replace / Replace All** في Visual Studio Code. الأمثلة مناسبة بشكل خاص لمشاريع Dart وFlutter، مع إمكانية استخدام معظم القواعد في أي لغة برمجية.

## فهرس الملفات

| القسم | العربية | الإنجليزية | المحتوى |
|---|---|---|---|
| البحث و Regex | [فتح](search/Readme_ar.md) | [English](search/Readme.md) | قواعد البحث، Regex، تحديد الملفات، Glob patterns، وأمثلة عملية للبحث داخل الكود. |
| الاستبدال | [فتح](replace/Readme_ar.md) | [English](replace/Readme.md) | Capture Groups، قواعد Replace، تغيير حالة الأحرف، refactoring، وقواعد الأمان مع Replace All. |

## هيكل المجلدات

```text
vscode/
├── Readme.md
├── Readme_ar.md
├── assets/
│   └── vscode-regex-search-poster.png
├── search/
│   ├── Readme.md
│   └── Readme_ar.md
└── replace/
    ├── Readme.md
    └── Readme_ar.md
```

## طريقة الاستخدام المقترحة

ابدأ بملف **Search & Regex** لتعلّم كيفية العثور على الكلمات والـ identifiers والـ imports وأنماط الكود والملفات، ثم انتقل إلى ملف **Replace** لتنفيذ عمليات إعادة التسمية والتحويلات الجماعية وتعديل المسارات باستخدام Capture Groups.

قبل تنفيذ **Replace All** على المشروع كاملاً، راجع النتائج، وحدد نطاق الملفات، واستبعد الملفات المولدة تلقائياً، وأنشئ Git commit.

![بوستر البحث باستخدام Regex في VS Code](assets/vscode-regex-search-poster.png)
