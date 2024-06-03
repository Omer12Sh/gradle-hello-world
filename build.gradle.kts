plugins {
    kotlin("jvm") version "1.6.20"
    id("application")
    id("java")
    id("idea")

    // This is used to create a GraalVM native image
    id("org.graalvm.buildtools.native") version "0.9.11"

    // This creates a fat JAR
    id("com.github.johnrengelman.shadow") version "7.1.2"
}

group = "com.ido"
description = "HelloWorld"

application.mainClass.set("com.ido.HelloWorld")

repositories {
    mavenCentral()
}

graalvmNative {
    binaries {
        named("main") {
            imageName.set("helloworld")
            mainClass.set("com.ido.HelloWorld")
            fallback.set(false)
            sharedLibrary.set(false)
            useFatJar.set(true)
            javaLauncher.set(javaToolchains.launcherFor {
                languageVersion.set(JavaLanguageVersion.of(17))
                vendor.set(JvmVendorSpec.matching("GraalVM Community"))
            })
        }
    }
}
version = "1.0.0" // Initial version

fun getCurrentVersion(): String {
    return try {
        val process = Runtime.getRuntime().exec("git describe --tags --abbrev=0")
        process.inputStream.bufferedReader().use { it.readText().trim() }.replace("[^\\d.]".toRegex(), "")
    } catch (e: Exception) {
        version.toString() // Use initial version if no tags are found
    }
}

fun incrementPatchVersion(version: String): String {
    val versionParts = version.split(".").toMutableList()
    val patchVersion = versionParts.last().toInt() + 1
    versionParts[versionParts.size - 1] = patchVersion.toString()
    return versionParts.joinToString(".")
}

tasks.register("updateVersion") {
    doLast {
        val currentVersion = getCurrentVersion()
        val newVersion = incrementPatchVersion(currentVersion)
        project.version = newVersion

        println("Updated version to $newVersion")
    }
}

tasks.named("build") {
    dependsOn("updateVersion")
}
