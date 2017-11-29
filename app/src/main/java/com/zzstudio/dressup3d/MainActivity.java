package com.zzstudio.dressup3d;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;

import com.adobe.air.AndroidActivityWrapper;

public class MainActivity extends AppCompatActivity {

    AndroidActivityWrapper wrapper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        wrapper = AndroidActivityWrapper.CreateAndroidActivityWrapper(this, true);
        setContentView(R.layout.activity_main);
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
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        wrapper.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        boolean handled = false;
        wrapper.dispatchKeyEvent(event, handled);
        return handled || super.dispatchKeyEvent(event);
    }

    @Override
    public boolean dispatchGenericMotionEvent(MotionEvent ev) {
        boolean handled = false;
        wrapper.dispatchGenericMotionEvent(ev, handled);
        return handled || super.dispatchGenericMotionEvent(ev);
    }

    @Override
    public void onLowMemory() {
        wrapper.onLowMemory();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        wrapper.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        wrapper.onNewIntent(intent);
    }

    @Override
    public void finishActivityFromChild(@NonNull Activity child, int requestCode) {
        super.finishActivityFromChild(child, requestCode);
        wrapper.finishActivityFromChild(child, requestCode);
    }

    @Override
    public void finishFromChild(Activity child) {
        super.finishFromChild(child);
        wrapper.finishFromChild(child);
    }


    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        wrapper.onAttachedToWindow();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        wrapper.onBackPressed();
    }

    @Override
    public void onContentChanged() {
        super.onContentChanged();
        wrapper.onContentChanged();
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        return wrapper.onContextItemSelected(item, super.onContextItemSelected(item));
    }

    @Override
    public void onContextMenuClosed(Menu menu) {
        super.onContextMenuClosed(menu);
        wrapper.onContextMenuClosed(menu);
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v,
                                    ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, v, menuInfo);
        wrapper.onCreateContextMenu(menu, v, menuInfo);
    }

    @Override
    public CharSequence onCreateDescription() {
        return wrapper.onCreateDescription(super.onCreateDescription());
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return wrapper.onCreateOptionsMenu(menu, super.onCreateOptionsMenu(menu));
    }

    @Override
    public boolean onCreatePanelMenu(int featureId, Menu menu) {
        return wrapper.onCreatePanelMenu(featureId, menu, super.onCreatePanelMenu(featureId, menu));
    }

    @Override
    public View onCreatePanelView(int featureId) {
        return wrapper.onCreatePanelView(featureId, super.onCreatePanelView(featureId));
    }

    @Override
    public boolean onCreateThumbnail(Bitmap outBitmap, Canvas canvas) {
        return wrapper.onCreateThumbnail(outBitmap, canvas, super.onCreateThumbnail(outBitmap, canvas));
    }

    @Override
    public View onCreateView(String name, Context context, AttributeSet attrs) {
        View retval = super.onCreateView(name, context, attrs);
        try {
            return wrapper.onCreateView(name, context, attrs, retval);
        }catch(Exception e){
        }
        return retval;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        wrapper.onDetachedFromWindow();
    }

    @Override
    public boolean onKeyLongPress(int keyCode, KeyEvent event) {
        return wrapper.onKeyLongPress(keyCode, event, super.onKeyLongPress(keyCode, event));
    }

    @Override
    public boolean onKeyMultiple(int keyCode, int repeatCount, KeyEvent event) {
        return wrapper.onKeyMultiple(keyCode, repeatCount, event, super.onKeyMultiple(keyCode, repeatCount, event));
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        return wrapper.onKeyUp(keyCode, event, super.onKeyUp(keyCode, event));
    }

    @Override
    public boolean onMenuOpened(int featureId, Menu menu) {
        return wrapper.onMenuOpened(featureId, menu, super.onMenuOpened(featureId, menu));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return wrapper.onOptionsItemSelected(item, super.onOptionsItemSelected(item));
    }

    @Override
    public void onOptionsMenuClosed(Menu menu) {
        super.onOptionsMenuClosed(menu);
        wrapper.onOptionsMenuClosed(menu);
    }

    @Override
    public void onPanelClosed(int featureId, Menu menu) {
        super.onPanelClosed(featureId, menu);
        wrapper.onPanelClosed(featureId, menu);
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        return wrapper.onPrepareOptionsMenu(menu, super.onPrepareOptionsMenu(menu));
    }

    @Override
    public boolean onPreparePanel(int featureId, View view, Menu menu) {
        return wrapper.onPreparePanel(featureId, view, menu, super.onPreparePanel(featureId, view, menu));
    }

    @Override
    public boolean onSearchRequested() {
        return wrapper.onSearchRequested(super.onSearchRequested());
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return wrapper.onTouchEvent(event, super.onTouchEvent(event));
    }

    @Override
    public boolean onTrackballEvent(MotionEvent event) {
        return wrapper.onTrackballEvent(event, super.onTrackballEvent(event));
    }

    @Override
    public void onUserInteraction() {
        super.onUserInteraction();
        wrapper.onUserInteraction();
    }

    @Override
    public void onWindowAttributesChanged(WindowManager.LayoutParams params) {
        super.onWindowAttributesChanged(params);
        wrapper.onWindowAttributesChanged(params);
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        wrapper.onWindowFocusChanged(hasFocus);
    }

    @Override
    protected void onApplyThemeResource(Resources.Theme theme, int resid,
                                        boolean first) {
        super.onApplyThemeResource(theme, resid, first);
//        wrapper.onApplyThemeResource(theme, resid, first);
    }

    @Override
    protected void onChildTitleChanged(Activity childActivity,
                                       CharSequence title) {
        super.onChildTitleChanged(childActivity, title);
        wrapper.onChildTitleChanged(childActivity, title);
    }

    @Override
    @SuppressWarnings("deprecation")
    protected Dialog onCreateDialog(int id) {
        return wrapper.onCreateDialog(id, super.onCreateDialog(id));
    }

    @Override
    @SuppressWarnings("deprecation")
    protected Dialog onCreateDialog(int id, Bundle args) {
        return wrapper.onCreateDialog(id, args, super.onCreateDialog(id, args));
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        wrapper.onPostCreate(savedInstanceState);
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        wrapper.onPostResume();
    }

    @Override
    @SuppressWarnings("deprecation")
    protected void onPrepareDialog(int id, Dialog dialog) {
        super.onPrepareDialog(id, dialog);
        wrapper.onPrepareDialog(id, dialog);
    }

    @Override
    @SuppressWarnings("deprecation")
    protected void onPrepareDialog(int id, Dialog dialog, Bundle args) {
        super.onPrepareDialog(id, dialog, args);
        wrapper.onPrepareDialog(id, dialog, args);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        wrapper.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        wrapper.onSaveInstanceState(outState);
    }

    @Override
    protected void onTitleChanged(CharSequence title, int color) {
        super.onTitleChanged(title, color);
        wrapper.onTitleChanged(title, color);
    }

    @Override
    protected void onUserLeaveHint() {
        super.onUserLeaveHint();
        wrapper.onUserLeaveHint();
    }
}
