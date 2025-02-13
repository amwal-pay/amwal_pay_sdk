import com.vanniktech.maven.publish.AndroidSingleVariantLibrary
import com.vanniktech.maven.publish.SonatypeHost
import org.gradle.internal.impldep.org.junit.experimental.categories.Categories.CategoryFilter.include

plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.serialization)
    id("com.vanniktech.maven.publish") version "0.30.0"
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
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
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

dependencies {
    val compileFlutterModule : Boolean = gradle.extra["compileFlutterModule"] as Boolean

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.kotlinx.serialization.json)
    if (compileFlutterModule) {
        implementation(project(":flutter"))
    }else{
        debugImplementation("com.amwal-pay.flutter:flutter_debug:1.0")
        add("profileImplementation", "com.amwal-pay.flutter:flutter_profile:1.0")
        releaseImplementation("com.amwal-pay.flutter:flutter_release:1.0")
    }
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}

mavenPublishing {
    publishToMavenCentral(SonatypeHost.CENTRAL_PORTAL)

    signAllPublications()

    configure(AndroidSingleVariantLibrary(
        // the published variant
        variant = "release",
        // whether to publish a sources jar
        sourcesJar = false,
        // whether to publish a javadoc jar
        publishJavadocJar = true,
    ))

    coordinates("com.amwal-pay", "amwal-sdk", "1.0.0")

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
}