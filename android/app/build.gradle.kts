import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing key: from android/key.properties on your machine, or from
// SANTARONI_KEYSTORE* environment variables in CI (see docs/RELEASING.md).
// Neither is ever committed. Without a key, release builds fall back to the
// debug key so `flutter run --release` still works locally; CI refuses to.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
fun signingValue(property: String, env: String): String? =
    System.getenv(env)?.takeIf { it.isNotEmpty() } ?: keyProperties.getProperty(property)
val releaseStoreFile = signingValue("storeFile", "SANTARONI_KEYSTORE")
val hasReleaseKey = releaseStoreFile != null
if (!hasReleaseKey && System.getenv("CI") != null) {
    throw GradleException("No release signing key: can't sign a release in CI.")
}

android {
    namespace = "com.luxaeternasoft.santaroni"
    compileSdk = flutter.compileSdkVersion
    // Pinned to the installed side-by-side NDK (Flutter default 28.2 is not available).
    ndkVersion = "30.0.16248370"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.luxaeternasoft.santaroni"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appLabel"] = "Santaroni"
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                storeFile = file(releaseStoreFile!!)
                storePassword = signingValue("storePassword", "SANTARONI_KEYSTORE_PASSWORD")
                keyAlias = signingValue("keyAlias", "SANTARONI_KEY_ALIAS")
                keyPassword = signingValue("keyPassword", "SANTARONI_KEY_PASSWORD")
            }
        }
    }

    // Builds signed with the debug key (debug, profile, and release without
    // the real key) are a separate "Santaroni Dev" app, so they install next
    // to the published app instead of clashing with its signature. On a
    // signature clash `flutter run` uninstalls the existing app, which would
    // delete its data.
    fun com.android.build.api.dsl.ApplicationBuildType.devApp() {
        applicationIdSuffix = ".debug"
        versionNameSuffix = "-dev"
        manifestPlaceholders["appLabel"] = "Santaroni Dev"
    }

    buildTypes {
        debug {
            devApp()
        }
        maybeCreate("profile").devApp()
        release {
            if (hasReleaseKey) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
                devApp()
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
