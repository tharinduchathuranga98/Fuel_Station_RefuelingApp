plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.refueling_app"  // Your app's namespace
    compileSdk = 34
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.refueling_app"
        minSdk = 21  // Explicitly set minSdkVersion if needed
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8  // Use Java 1.8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    // Set the valid Kotlin JVM target to 1.8
    kotlinOptions {
        jvmTarget = "1.8"  // Set the valid JVM target (1.8 or 11)
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    dependencies {
        // Add the desugaring dependency for Java 8+ support
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.0")
    }
}

flutter {
    source = "../.."
}
