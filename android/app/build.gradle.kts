plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.eventapp_final"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.eventapp_final"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        // For native dependencies
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            // Disable resource shrinking for debug builds
            isShrinkResources = false
            isMinifyEnabled = false
        }
        release {
            isDebuggable = false
            // DISABLE minification to avoid R8 errors for now
            isMinifyEnabled = false
            isShrinkResources = false

            // Use debug signing config for release builds (for testing)
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "/META-INF/*.kotlin_module"
        }
    }

    lint {
        disable += "InvalidPackage"
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}