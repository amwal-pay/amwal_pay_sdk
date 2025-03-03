import java.io.File
import java.util.Properties

pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
       maven {
            url = uri("${settingsDir.parent}/amwal_sdk_flutter_module/build/host/outputs/repo")
        }
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
    }
}

fun checkPropertyInLocalProperties(propertyName: String, defaultValue: Boolean): Boolean {
    val properties = Properties()
    val localProperties = File(settingsDir, "local.properties")

    if (localProperties.exists()) {
        properties.load(localProperties.inputStream())
        return properties.getProperty(propertyName, defaultValue.toString()).toBoolean()
    }
    return defaultValue
}

val compileFlutterModule = checkPropertyInLocalProperties("compileFlutterModule",true)

gradle.extra["compileFlutterModule"] = compileFlutterModule

println(gradle.extra["compileFlutterModule"])

rootProject.name = "AnwalPaySDKExample"
include(":app")
include(":amwalsdk")


if(compileFlutterModule==true){
    val filePath = settingsDir.parentFile.toString() + "/amwal_sdk_flutter_module/.android/include_flutter.groovy"
    apply(from = File(filePath))
}