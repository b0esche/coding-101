plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin") // Must be last!
}

android {
    namespace = "com.example.gig_hub"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.gig_hub"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["appAuthRedirectScheme"] = "com.example.gig_hub"
    }

    buildTypes {
        getByName("release") {
            // Temporarily sign with the debug key for testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (only once is needed)
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // Enable core library desugaring for Java 8+ APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Firebase components
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Facebook SDK
    implementation("com.facebook.android:facebook-android-sdk:16.3.0")
}