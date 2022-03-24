package com.example.ussd_sdk;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.PersistableBundle;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "alainmucyo.dev/permissions";
    private static final String EVENT_CHANNEL = "alainmucyo.dev/events";
    private MethodChannel methodChannel;
    private boolean broadCastInitialized = false;
    private EventChannel m_eventchannel;
    private EventChannel.EventSink m_stepsStreamSink;
    private EventChannel.StreamHandler m_eventCallHandler;
    private MethodChannel.Result m_result;
    private EventChannel.EventSink m_eventSink;

    private SinkBroadcastReceiver broadcastReceiver;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    Log.d("MainActivity", "Channel called");
                    int permissionCheck = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE);

                    if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                        Log.d("MainActivity", "Request read phone state permission");
                        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
                    } else {
                        Log.d("MainActivity", "Permission already requested");
                        //TODO
                    }

                    if (call.method.equals("myMethod")) {
                        result.success(1);
                    }

                    if (!broadCastInitialized) {
//                        broadCastInitialized = true;
                        Log.d("MainActivity", "Initializing service");
                        Intent serviceIntent = new Intent(this, USSDService.class);
                        this.startService(serviceIntent);
                        Log.d("MainActivity", "Initializing event channel");
                    }

                }
        );

        m_eventCallHandler = new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                Log.d("receiver", "Event channel initialized");
                Log.d("receiver", "+++++++++++++++++++++++++++++++++++++++++++++");
                m_eventSink = eventSink;
                SinkBroadcastReceiver receiver = new SinkBroadcastReceiver(eventSink);
                broadcastReceiver = receiver;
                LocalBroadcastManager.getInstance(MainActivity.this).registerReceiver(receiver,
                        new IntentFilter("custom-event-name"));
//                eventSink.success("This is a message to let you know that I am alive");
            }

            @Override
            public void onCancel(Object o) {

            }
        };
        m_eventchannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL);
        m_eventchannel.setStreamHandler(m_eventCallHandler);
    }

   /* private BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            // Get extra data included in the Intent
            Log.d("Receiver", "====================================================================");
            String message = intent.getStringExtra("message");
            Log.d("receiver", "Got message: " + message);
            methodChannel.invokeMethod("sendResults", message);
        }
    };*/

    @Override
    protected void onDestroy() {
        // Unregister since the activity is about to be closed.
//        LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);
        super.onDestroy();
    }

   /* @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("receiver", "Event channel listening");
        Log.d("receiver", "+++++++++++++++++++++++++++++++++++++++++++++");
        m_eventSink = events;
        m_eventSink.success("Hello world");
    }

    @Override
    public void onCancel(Object arguments) {

    }*/
}

