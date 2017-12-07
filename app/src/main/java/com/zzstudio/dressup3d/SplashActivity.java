package com.zzstudio.dressup3d;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

/**
 * Created by Zzisok001 on 2017/12/6.
 */

public class SplashActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startActivity(new Intent(this, MainActivity.class));
        finish();
    }
}
