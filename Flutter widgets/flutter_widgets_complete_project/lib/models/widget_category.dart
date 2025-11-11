class WidgetCategory {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String icon;
  final List<String> features;
  final String route;

  const WidgetCategory({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.icon,
    required this.features,
    required this.route,
  });
}

// جميع الفئات الـ 14
final List<WidgetCategory> widgetCategories = [
  WidgetCategory(
    id: 'material',
    title: 'Material Widgets',
    titleEn: 'Material Design',
    description: 'ويدجت غنية بصرياً تطبق Material Design 3',
    icon: '🎨',
    features: ['أزرار وبطاقات', 'قوائم وحوارات', 'تنقل متقدم'],
    route: '/material',
  ),
  WidgetCategory(
    id: 'cupertino',
    title: 'Cupertino Widgets',
    titleEn: 'iOS/macOS Design',
    description: 'ويدجت بنمط Apple الأصلي',
    icon: '🍎',
    features: ['تصميم iOS', 'مكونات macOS', 'HIG Guidelines'],
    route: '/cupertino',
  ),
  WidgetCategory(
    id: 'accessibility',
    title: 'Accessibility',
    titleEn: 'إمكانية الوصول',
    description: 'جعل التطبيق قابل للوصول للجميع',
    icon: '♿',
    features: ['Semantics', 'قراء الشاشة', 'WCAG 2.1'],
    route: '/accessibility',
  ),
  WidgetCategory(
    id: 'animation',
    title: 'Animation & Motion',
    titleEn: 'الحركة والرسوم المتحركة',
    description: 'إضافة حيوية وانتقالات سلسة',
    icon: '✨',
    features: ['Implicit Animations', 'Hero Transitions', 'Custom Animations'],
    route: '/animation',
  ),
  WidgetCategory(
    id: 'assets',
    title: 'Assets, Images & Icons',
    titleEn: 'الأصول والصور',
    description: 'عرض الصور والأيقونات',
    icon: '🖼️',
    features: ['Image Loading', 'Icons', 'Asset Management'],
    route: '/assets',
  ),
  WidgetCategory(
    id: 'async',
    title: 'Async',
    titleEn: 'العمليات غير المتزامنة',
    description: 'التعامل مع Future و Stream',
    icon: '⏳',
    features: ['FutureBuilder', 'StreamBuilder', 'Async Patterns'],
    route: '/async',
  ),
  WidgetCategory(
    id: 'basics',
    title: 'Basics',
    titleEn: 'الأساسيات',
    description: 'الويدجت الأساسية - نقطة البداية',
    icon: '🏗️',
    features: ['Container', 'Row & Column', 'Text & Scaffold'],
    route: '/basics',
  ),
  WidgetCategory(
    id: 'input',
    title: 'Input',
    titleEn: 'إدخال المستخدم',
    description: 'جمع بيانات من المستخدم',
    icon: '⌨️',
    features: ['TextField', 'Forms', 'Checkboxes & Switches'],
    route: '/input',
  ),
  WidgetCategory(
    id: 'interaction',
    title: 'Interaction Models',
    titleEn: 'نماذج التفاعل',
    description: 'الاستجابة للإيماءات والتنقل',
    icon: '👆',
    features: ['GestureDetector', 'Draggable', 'Navigator'],
    route: '/interaction',
  ),
  WidgetCategory(
    id: 'layout',
    title: 'Layout',
    titleEn: 'التخطيط',
    description: 'ترتيب الويدجت في واجهات معقدة',
    icon: '📐',
    features: ['Flex Layouts', 'Stack', 'GridView'],
    route: '/layout',
  ),
  WidgetCategory(
    id: 'painting',
    title: 'Painting & Effects',
    titleEn: 'الرسم والتأثيرات',
    description: 'تأثيرات بصرية ورسم مخصص',
    icon: '🎭',
    features: ['CustomPaint', 'Transform', 'BackdropFilter'],
    route: '/painting',
  ),
  WidgetCategory(
    id: 'scrolling',
    title: 'Scrolling',
    titleEn: 'التمرير',
    description: 'تمرير المحتوى الطويل',
    icon: '📜',
    features: ['ListView', 'GridView', 'Slivers'],
    route: '/scrolling',
  ),
  WidgetCategory(
    id: 'styling',
    title: 'Styling',
    titleEn: 'التنسيق والثيمات',
    description: 'إدارة مظهر التطبيق',
    icon: '🎨',
    features: ['Theme', 'MediaQuery', 'Responsive Design'],
    route: '/styling',
  ),
  WidgetCategory(
    id: 'text',
    title: 'Text',
    titleEn: 'النصوص',
    description: 'عرض وتنسيق النصوص',
    icon: '📝',
    features: ['Text Styles', 'RichText', 'SelectableText'],
    route: '/text',
  ),
];
