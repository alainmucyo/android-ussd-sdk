package com.example.ussd_sdk;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class UnusedClass {
    private String sim1;
    private String sim2;
//    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
/*    private void checkSim() {
        SubscriptionManager subscriptionManager = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            subscriptionManager = (SubscriptionManager) getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE);
        }

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        List<SubscriptionInfo> subscriptionInfoList = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            subscriptionInfoList = subscriptionManager.getActiveSubscriptionInfoList();
        }

        for (SubscriptionInfo subscriptionInfo : subscriptionInfoList) {
            int subscriptionId = 0;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                subscriptionId = subscriptionInfo.getSubscriptionId();
            }
            Log.d("Sims", "subscriptionId: " + subscriptionId);
        }

        if (subscriptionInfoList != null) {
            if (subscriptionInfoList.size() == 1) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    sim1 = subscriptionInfoList.get(0).getDisplayName().toString();
                }
                Log.d("MainActivity", "Sim 1" + sim1);
            } else {
                sim1 = subscriptionInfoList.get(0).getDisplayName().toString();
                sim2 = subscriptionInfoList.get(1).getDisplayName().toString();

            }

        }
    }

    private void listenToResponse(MethodChannel.Result result) {
        String response = "";
        TelephonyManager manager = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return;
            }
            manager.sendUssdRequest("*131#", new TelephonyManager.UssdResponseCallback() {
                @Override
                public void onReceiveUssdResponse(TelephonyManager telephonyManager, String request, CharSequence response) {
                    Log.d("MainActivity", "Received USSD response succeed: " + response.toString());
                    response = response.toString();
                    result.success(response);
                    super.onReceiveUssdResponse(telephonyManager, request, response);
                }

                @Override
                public void onReceiveUssdResponseFailed(TelephonyManager telephonyManager, String request, int failureCode) {
                    Log.d("MainActivity", "Received USSD response failed");
                    Log.d("MainActivity", failureCode + "");
                    Log.d("MainActivity", request + "");
                    super.onReceiveUssdResponseFailed(telephonyManager, request, failureCode);
                }
            }, new Handler());
        }
    }*/
}
