package com.zzstudio.dressup3d;

import android.app.Application;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

public class MyApp extends Application {
    public static GoogleAnalytics analytics;
    public static Tracker tracker;

    @Override
    public void onCreate() {
        super.onCreate();
        analytics = GoogleAnalytics.getInstance(this);
        analytics.setLocalDispatchPeriod(1800);

        tracker = analytics.newTracker("UA-110257958-1"); // Replace with actual tracker id
        tracker.enableExceptionReporting(true);
//        tracker.enableAdvertisingIdCollection(true);
        tracker.enableAutoActivityTracking(true);
    }

    public static void setScreenName(String screenName) {
        tracker.setScreenName(screenName);
    }

    public static void track(String screenName, String cat, String action, String label) {
        setScreenName(screenName);
        track(cat, action, label);
    }

    public static void track(String cat, String action, String label) {
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(cat)
                .setAction(action)
                .setLabel(label)
                .build());
    }
}
