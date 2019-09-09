package com.example.upgrade_app;

import android.os.Bundle;

import com.example.upgrade_app.plugins.UpdateVersionPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    // 注册更新组件
    UpdateVersionPlugin.registerWith(registrarFor("example.com/update_version"));
  }
}
