package pub.ane;

import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.security.InvalidParameterException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PublisherExtContext extends ExtContextBase {

	private int saveCount = 0;

	@ANE
	public void saveImage(byte[] bytes) {
		String imageName = "ZIMG_" + getCurrentDate() + saveCount + ".jpg";
		try {
			saveImage(imageName, bytes);
		} catch (Exception e) {
		}
		saveCount++;
		if (saveCount > 9)
			saveCount = 0;

	}

	/**
	 * 截屏
	 */
	private void saveImage(String imageName, byte[] bytes) throws Exception {
		String filePath = "zzgames/" + imageName;
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
