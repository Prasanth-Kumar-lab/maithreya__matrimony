-keep class com.itgsa.opensdk.** { *; }
-keep class com.zego.** { *; }
-keep class **.**.zego_zpns.** { *; }
-keep class com.google.firebase.** { *; }
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-keep class com.itgsa.opensdk.** { *; }
-keep class java.beans.** { *; }
-keep class org.w3c.dom.bootstrap.** { *; }
-dontwarn java.beans.**
-dontwarn org.w3c.dom.**
-dontwarn com.itgsa.opensdk.mediaunit.KaraokeMediaHelper