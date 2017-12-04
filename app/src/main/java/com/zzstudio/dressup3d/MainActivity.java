package com.zzstudio.dressup3d;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;

import com.adobe.air.AndroidActivityWrapper;

public class MainActivity extends AppCompatActivity {

    AndroidActivityWrapper wrapper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        wrapper = AndroidActivityWrapper.CreateAndroidActivityWrapper(this, true);
        wrapper.onCreate(this, getOnCreateParam());
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
