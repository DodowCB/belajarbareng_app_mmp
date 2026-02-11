## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.embedding.android.** { *; }

## Google Play Core (untuk Flutter)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

## Google Sign In & Auth
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.api.** { *; }
-dontwarn com.google.api.**

## Google Drive API
-keep class com.google.api.services.drive.** { *; }
-keep class com.google.api.client.** { *; }
-keep class com.google.api.client.json.** { *; }
-keep class com.google.api.client.http.** { *; }

## Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

## Gson
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

## HTTP
-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**
-keep class org.apache.commons.** { *; }
-dontwarn org.apache.commons.**

## Retrofit (if used)
-keepattributes Signature
-keepattributes Exceptions

## Google Play Services
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}

## Google Auth
-keep class com.google.android.gms.auth.** { *; }
-keep interface com.google.android.gms.auth.** { *; }

## Keep Google Sign In Account
-keep class com.google.android.gms.auth.api.signin.GoogleSignInAccount { *; }
-keep class com.google.android.gms.auth.api.signin.GoogleSignInOptions { *; }
-keep class com.google.android.gms.auth.api.signin.GoogleSignInClient { *; }
