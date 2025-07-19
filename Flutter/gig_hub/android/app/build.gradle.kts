plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // muss zuletzt kommen!
}

android {
    namespace = "com.example.gig_hub"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
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
            // Vorübergehend mit Debug-Key signieren
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (nur einmal nötig)
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // Firebase Komponenten
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Facebook SDK
    implementation("com.facebook.android:facebook-android-sdk:16.3.0")
}