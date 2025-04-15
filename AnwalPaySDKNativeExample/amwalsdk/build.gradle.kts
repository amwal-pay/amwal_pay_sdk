import com.vanniktech.maven.publish.AndroidSingleVariantLibrary
import com.vanniktech.maven.publish.SonatypeHost
import java.io.File
import java.util.regex.Pattern // Add this import to resolve Pattern




fun getVersionFromPubspec(): String {
    // Resolve path to the `amwal_pay_sdk` directory
    val amwalPaySdkDir = project.rootDir.parentFile
    println("_______________________$amwalPaySdkDir")
    val pubspecFile = File(amwalPaySdkDir, "pubspec.yaml")

    if (amwalPaySdkDir == null || !pubspecFile.exists()) {
        println("Warning: pubspec.yaml not found at ${pubspecFile.absolutePath}. Using default version.")
        return "1.0.1"
    }

    try {
        val pubspecContent = pubspecFile.readText()
        val versionPattern = Pattern.compile("version:\\s*(\\d+\\.\\d+\\.\\d+)")
        val matcher = versionPattern.matcher(pubspecContent)

        if (matcher.find()) {
            val version = matcher.group(1)
            println("Extracted version from pubspec.yaml: $version")
            return version
        } else {
            println("Warning: Version not found in pubspec.yaml. Using default version.")
            return "1.0.1"
        }
    } catch (e: Exception) {
        println("Error reading pubspec.yaml: ${e.message}. Using default version.")
        return "1.0.1"
    }
}



// Get version from pubspec.yaml
val sdkVersion = getVersionFromPubspec()

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
    val compileFlutterModule: Boolean = gradle.extra.get("compileFlutterModule") as? Boolean ?: true
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
        implementation ("com.amwal-pay:amwal_sdk:+")
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

    coordinates("com.amwal_pay", "amwal_sdk", sdkVersion)


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


