plugins {
    alias(libs.plugins.android.application)
    //  alias(libs.plugins.kotlinAndroid)
    //alias(libs.plugins.kotlinKapt)
    //id("com.google.devtools.ksp") version "1.8.10-1.0.9" apply false
}

android {
    namespace = "com.example.meteoapp"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.meteoapp"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        buildConfigField(
            "String", "OWM_API_KEY",
            "\"${project.findProperty("OWM_API_KEY") ?: "YOUR_KEY"}\""
        )
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

//java {
//    toolchain {
//        languageVersion.set(JavaLanguageVersion.of(11))
//    }
//}

//kapt {
//    correctErrorTypes = true
//    arguments {
//        arg("room.schemaLocation", "$projectDir/schemas")
//        arg("room.incremental", "true")
//        arg("room.expandProjection", "true")
//        arg("room.verifySchemaLocation", "false") // ✅ le bon nom ici
//    }
//}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)

    implementation("com.google.android.gms:play-services-location:21.2.0")
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")

    //implementation("androidx.room:room-runtime:2.6.1")
    //kapt("androidx.room:room-compiler:2.6.1")

    implementation("androidx.work:work-runtime:2.9.0")
    implementation("com.github.bumptech.glide:glide:4.16.0")

    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}
