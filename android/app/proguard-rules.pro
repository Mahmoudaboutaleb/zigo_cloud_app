# قواعد ProGuard لحفظ الكود المتعلق بـ Zego
-keep class **.zego.** { *; }
-keep class **.*.*.zego_zpns.** { *; }

# حفظ جميع الفئات العامة والطرق العامة
-keep public class * {
    public protected *;
}

# حفظ الفئات والأساليب التي قد يتم استدعاؤها عبر الانعكاس (Reflection)
-keepclassmembers class * {
    *;
}

# عدم تقليل حجم الكود الخاص بالأكواد العامة والطرق العامة المستخدمة في مشروعك
-dontwarn **.zego.**
-dontwarn **.*.*.zego_zpns.**
