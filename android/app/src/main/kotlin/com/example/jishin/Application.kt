package com.example.jishin

import io.flutter.app.FlutterApplication
import dev.fluttercommunity.workmanager.WorkmanagerPlugin // Import WorkmanagerPlugin

class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        // No need for explicit plugin registration here for workmanager
        // WorkmanagerPlugin handles it internally with V2 embedding
    }
}