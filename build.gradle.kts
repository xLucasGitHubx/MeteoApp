plugins {
    alias(libs.plugins.androidApplication) apply false
    alias(libs.plugins.kotlinAndroid)      apply false
    alias(libs.plugins.hiltAndroid)       apply false
    id("com.google.devtools.ksp") version "1.8.10-1.0.9" apply false
}
