plugins {
    kotlin("jvm") version "2.4.0"
    application
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(21)
}

application {
    // Top-level `main()` in TwoSum.kt compiles to the class `TwoSumKt`.
    mainClass.set("TwoSumKt")
}
