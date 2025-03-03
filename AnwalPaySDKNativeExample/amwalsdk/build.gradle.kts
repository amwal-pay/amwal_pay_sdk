import com.vanniktech.maven.publish.AndroidSingleVariantLibrary
import com.vanniktech.maven.publish.SonatypeHost


repositories {
    google()
    mavenCentral()
    maven("https://storage.googleapis.com/download.flutter.io")
    maven {
        url = uri("$rootDir/repo") // Updated to point to the `repo` folder in the module directory
    }
}


plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.serialization)
    id("com.vanniktech.maven.publish") version "0.30.0"
    id("maven-publish")
    id("signing")
}

android {
    namespace = "com.anwalpay.sdk"
    compileSdk = 35

    defaultConfig {
        minSdk = 24

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        create("profile") {
            initWith(buildTypes.getByName("debug"))
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }

}

signing {
    useGpgCmd()  // Use the GPG command line tool to sign the artifacts
}

dependencies {
    val compileFlutterModule: Boolean = gradle.extra["compileFlutterModule"] as Boolean

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.kotlinx.serialization.json)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    if (compileFlutterModule) {
        implementation(project(":flutter"))
    }else {
        debugImplementation("com.amwal_pay.flutter:flutter_debug:1.0.1")
        add("profileImplementation", "com.amwal_pay.flutter:flutter_profile:1.0.1")
        releaseImplementation("com.amwal_pay.flutter:flutter_release:1.0.1")
    }


}
signing {
    useInMemoryPgpKeys(
        System.getenv("SIGNING_KEY"),
        System.getenv("SIGNING_PASSWORD")
    )
    sign(publishing.publications)
}
mavenPublishing {
    publishToMavenCentral(SonatypeHost.CENTRAL_PORTAL)

    signAllPublications()


    configure(
        AndroidSingleVariantLibrary(
            // the published variant
            variant = "release",
            // whether to publish a sources jar
            sourcesJar = false,
            // whether to publish a javadoc jar
            publishJavadocJar = true,
        )
    )

    coordinates("com.amwal_pay", "amwal_sdk", "1.0.5")


    // the following is optional

    pom {
        name.set("Amwal SDK")
        description.set("A sample SDK for Amwal Pay.")
        inceptionYear.set("2024")
        url.set("https://amwal-pay.com")
        licenses {
            license {
                name.set("The Apache License, Version 2.0")
                url.set("http://www.apache.org/licenses/LICENSE-2.0.txt")
                distribution.set("http://www.apache.org/licenses/LICENSE-2.0.txt")
            }
        }
        developers {
            developer {
                id.set("amr.elskaan")
                name.set("Amr Said")
                url.set("amr.elskaan@amwal-pay.com")
            }
        }
        scm {
            url.set("https://github.com/username/mylibrary/")
            connection.set("scm:git:git://github.com/username/mylibrary.git")
            developerConnection.set("scm:git:ssh://git@github.com/username/mylibrary.git")
        }
    }

    repositories {
        maven {
            // Local directory to save the artifacts
            url = uri("${buildDir}/repo")
        }
    }
}

//afterEvaluate {
//    publishing {
//        publications {
//            withType<MavenPublication> {
//                // List of all AAR files you want to publish
//                val aarFiles = listOf(
//                    file("repo/dev/fluttercommunity/plus/packageinfo/package_info_plus_release/1.0/package_info_plus_release-1.0.aar"),
//                    file("repo/dev/fluttercommunity/plus/share/share_plus_release/1.0/share_plus_release-1.0.aar"),
//                    file("repo/fman/ge/smart_auth/smart_auth_release/1.0/smart_auth_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/nfc_manager/nfc_manager_release/1.0/nfc_manager_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/pathprovider/path_provider_android_release/1.0/path_provider_android_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/sharedpreferences/shared_preferences_android_release/1.0/shared_preferences_android_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/webviewflutter/webview_flutter_android_release/1.0/webview_flutter_android_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/firebase/crashlytics/firebase_crashlytics_release/1.0/firebase_crashlytics_release-1.0.aar"),
//                    file("repo/io/flutter/plugins/firebase/core/firebase_core_release/1.0/firebase_core_release-1.0.aar"),
//                    file("repo/com/amwal_pay/flutter/flutter_release/1.0/flutter_release-1.0.aar"),
//                    // Add other AAR files here
//                )
//
//                aarFiles.forEach { aarFile ->
//                    val fileName = aarFile.nameWithoutExtension
//                    val parts = fileName.split("-")
//
//                    val pluginName = parts[parts.size - 2] // Extract the plugin name
//                    val version = parts[parts.size - 1]  // Extract the version
//
//                    println("Publishing AAR for plugin: $pluginName, version: $version")
//
//                    // Determine the groupId based on the file name
//                    val groupId = when {
//                        fileName.contains("flutter_release") -> "com.amwal-pay.flutter"
//                        else -> "com.amwal-pay" // Default groupId for other AARs
//                    }
//
//                    // Ensure unique artifactId and classifier to avoid duplication
//                    val artifactId = pluginName // ArtifactId should be unique for each file
//                    val classifier = if (fileName.contains("flutter_release")) "flutter" else null
//
//                    // Publish the AAR with its own coordinates
//                    artifact(aarFile) {
//                        this.classifier = pluginName // Optionally set classifier
//                        this.extension = "aar"      // Set the extension to "aar"
//                    }
//                }
//            }
//        }
//    }
//}


