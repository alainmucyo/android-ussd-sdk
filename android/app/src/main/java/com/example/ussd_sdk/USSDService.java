package com.example.ussd_sdk;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import java.util.Collections;
import java.util.List;

public class USSDService extends AccessibilityService {

    public static String TAG = USSDService.class.getSimpleName();

//    private boolean actionDone;


    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        Log.d("USSDService", "onAccessibilityEvent");
        Intent intent = new Intent("custom-event-name");

        boolean actionDone = false;
//        String text = event.getText().toString();

        if (event.getClassName().equals("android.app.AlertDialog")) {
            performGlobalAction(GLOBAL_ACTION_BACK);

            Log.d(TAG, "Received accessibility event");
            AccessibilityNodeInfo source = event.getSource();
            List<CharSequence> eventText;

            if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
                eventText = event.getText();
            } else {
                eventText = Collections.singletonList(source.getText());
            }

            String text = processUSSDText(eventText);
            if (TextUtils.isEmpty(text)) return;
            intent.putExtra("message", text);
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
            Log.d(TAG, text);
            if (text.contains("Please go ahead and pay") || text.contains("Sender Response sent to agent") || text.contains("External application down")) {
                return;
            }
//            boolean requirePIN = true;

//            if (!actionDone && requirePIN) {
            Log.d("USSDService", "This has send");
            if (text.contains("Merchant : ")) {
                Log.d("USSDService", "Replying with a 1");
                AccessibilityNodeInfo nodeInput = source.findFocus(AccessibilityNodeInfo.FOCUS_INPUT);
                Bundle bundle = new Bundle();
                bundle.putCharSequence(AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE, "1");
                nodeInput.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, bundle);
                nodeInput.refresh();

                List<AccessibilityNodeInfo> list = source.findAccessibilityNodeInfosByText("Send");
                for (AccessibilityNodeInfo node : list) {
                    node.performAction(AccessibilityNodeInfo.ACTION_CLICK);
                }
                return;
            }
            actionDone = true;
//            }
            Log.d("USSDService", "Canceling dialog");
            List<AccessibilityNodeInfo> list;
            list = source.findAccessibilityNodeInfosByText("CANCEL"); // find the cancel button
            for (AccessibilityNodeInfo node : list) {
                node.performAction(AccessibilityNodeInfo.ACTION_CLICK); // click it
            }

        }

        // Close dialog
        // This works on 4.1+ only

        /*      *//* if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED && !event.getClassName().equals("android.app.AlertDialog")) { // android.app.AlertDialog is the standard but not for all phones  *//*
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED && !String.valueOf(event.getClassName()).contains("AlertDialog")) {
            return;
        }
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED && (source == null || !source.getClassName().equals("android.widget.TextView"))) {
            return;
        }
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED && TextUtils.isEmpty(source.getText())) {
            return;
        }
*/

        // Handle USSD response here

    }

    private String processUSSDText(List<CharSequence> eventText) {
        for (CharSequence s : eventText) {
            String text = String.valueOf(s);
            // Return text if text is the expected ussd response
            if (true) {
                return text;
            }
        }
        return null;
    }

    @Override
    public void onInterrupt() {
    }

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        Log.d(TAG, "onServiceConnected");
        AccessibilityServiceInfo info = new AccessibilityServiceInfo();
        info.flags = AccessibilityServiceInfo.DEFAULT;
        info.packageNames = new String[]{"com.android.phone"};
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED | AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED;
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        setServiceInfo(info);
    }
}