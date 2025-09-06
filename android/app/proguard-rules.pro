# Keep Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep ProGuard annotations
-dontwarn proguard.annotation.**
-keep class proguard.annotation.** { *; }

# Additional Razorpay specific rules
-keepattributes *Annotation*
-keepclassmembers class * {
    @proguard.annotation.Keep *;
    @proguard.annotation.KeepClassMembers *;
}


