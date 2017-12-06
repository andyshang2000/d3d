package com.zzstudio.dressup3d;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.adobe.air.AndroidActivityWrapper;

public class MainActivity extends AppCompatActivity {

    AndroidActivityWrapper wrapper;
    private ImageView view;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        wrapper = AndroidActivityWrapper.CreateAndroidActivityWrapper(this, true);
        wrapper.onCreate(this, getOnCreateParam());
        view = new ImageView(this);
        view.setImageResource(R.drawable.splash);
        view.setAdjustViewBounds(true);
        view.setScaleType(ImageView.ScaleType.FIT_XY);
        ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        DisplayMetrics metric = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metric);
        int width = metric.widthPixels;  // 屏幕宽度（像素）
        int height = metric.heightPixels;
        float aspect = (float) width / (float) height;
        if (aspect < 480.0 / 800.0) {
            layoutParams.height = height;
            layoutParams.width = ViewGroup.LayoutParams.WRAP_CONTENT;
        } else {
            layoutParams.width = width;
            layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        }
        view.setLayoutParams(layoutParams);
        ((ViewGroup) findViewById(android.R.id.content)).addView(view);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("cn.abel.action.broadcast");
        this.registerReceiver(new MyBroadcastReciver(), intentFilter);
    }

    private class MyBroadcastReciver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals("cn.abel.action.broadcast")) {
                view.setVisibility(View.GONE);
            }
        }
    }

    private String[] getOnCreateParam() {
        String xmlPath = "";
        String rootDirectory = "";
        String extraArgs = "-nodebug";
        Boolean isADL = Boolean.valueOf(false);
        Boolean isDebuggerMode = Boolean.valueOf(false);
        String[] args = {xmlPath, rootDirectory, extraArgs,
                isADL.toString(), isDebuggerMode.toString()};
        return args;
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        return wrapper.onKeyDown(keyCode, event, super.onKeyDown(keyCode, event));
    }

    @Override
    public void onResume() {
        super.onResume();
        wrapper.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        wrapper.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        wrapper.onDestroy();
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        wrapper.onRestart();
    }

    @Override
    protected void onStop() {
        super.onStop();
        wrapper.onStop();
    }

    @Override
    public void onLowMemory() {
        wrapper.onLowMemory();
    }
}
