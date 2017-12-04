package com.zzstudio.ane;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.security.InvalidParameterException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREObject;

import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

public class ZZExtContext extends ExtContextBase {

    @ANE
    public FREObject loadGame(byte[] md5b) {
        FREByteArray ba = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            md5.update(md5b);
            String loaderHash = toHexString(md5.digest());
            String md5str = md5String(loaderHash
                    + getActivity().getPackageName());
            // 2d4af50c3d7a4c2d59abe5beb721731f
            //
            InputStream in = getActivity().getAssets().open("game.bin");
            byte[] bytes = new byte[in.available()];
            in.read(bytes);
            restore(bytes);
            ba = FREByteArray.newByteArray();
            ba.setProperty("length", FREObject.newObject(bytes.length));
            ba.acquire();
            ByteBuffer bb = ba.getBytes();
            bb.put(bytes);
            ba.release();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ba;
    }

    @ANE
    public void saveFile(String name, byte[] bytes) {
        if (Environment.getExternalStorageState().equals(
                Environment.MEDIA_MOUNTED)) {

            File sdCardDir = Environment.getExternalStorageDirectory();
            File sdFile = new File(sdCardDir, "droid4xShare/xxxxx.swf");
            FileOutputStream fos;
            try {
                fos = new FileOutputStream(sdFile);
                fos.write(bytes);
                fos.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static String md5String(String str) throws NoSuchAlgorithmException {
        MessageDigest md5 = MessageDigest.getInstance("MD5");
        md5.update(str.getBytes());
        return toHexString(md5.digest());
    }

    private static String toHexString(byte[] b) {
        final char[] hexChar = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
                '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        StringBuilder sb = new StringBuilder(b.length * 2);
        for (int i = 0; i < b.length; i++) {
            sb.append(hexChar[(b[i] & 0xf0) >>> 4]);
            sb.append(hexChar[b[i] & 0x0f]);
        }
        return sb.toString();
    }

    private void restore(byte[] bytes) {
    }

    @ANE
    public void saveImage(byte[] bytes) {
        String imageName = System.currentTimeMillis() + ".jpg";
        try {
            saveImage(imageName, bytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void saveImage(String imageName, byte[] bytes) throws Exception {
        String filePath = "zzstudio/" + imageName;
        File file = new File(Environment.getExternalStorageDirectory(),
                filePath);

        try {
            if (!file.exists()) {
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
            }
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(bytes);
            fos.close();
        } catch (FileNotFoundException e) {
            throw new InvalidParameterException();
        }

        MediaStore.Images.Media.insertImage(//
                getActivity().getContentResolver(), //
                file.getAbsolutePath(), //
                imageName, null);
        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,
                Uri.fromFile(file));
        getActivity().sendBroadcast(intent);
    }

    public static String getCurrentDate() {
        Date d = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        return sf.format(d);
    }

    @ANE
    public void showADByTimes() {
    }

    @ANE
    public void showAD() {
    }

    @ANE
    public void showIngameAD() {
    }

    @ANE
    public void showPromotion() {
    }

    @ANE
    public String getDeminsion() {
        return "";
    }

    @ANE
    public String getMode2() {
        return "";
    }

    @ANE
    public void toast(String str, String str2) {
//		Toast.makeText(getActivity(), str2, Toast.LENGTH_SHORT).show();
    }

    @ANE
    public void init() {
    }

    @ANE
    public int getSound() {
        return 1;
    }
}
