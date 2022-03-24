package com.example.ussd_sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;

public class SinkBroadcastReceiver extends BroadcastReceiver {
    private EventChannel.EventSink sink;

    SinkBroadcastReceiver(EventChannel.EventSink sink) {
        this.sink = sink;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // Get extra data included in the Intent
        Log.d("SinkBroadcastReceiver", "====================================================================");
        String message = intent.getStringExtra("message");
        Log.d("SinkBroadcastReceiver", "Got message: " + message);
        this.sink.success(message);
        
    }
}
