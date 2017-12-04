package pub.ane;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREByteArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

@Retention(RetentionPolicy.RUNTIME)
@interface ANE {
}

public class ExtContextBase extends FREContext {

	@Override
	public Map<String, FREFunction> getFunctions() {

		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

		Method method = null;
		Method[] methods = getClass().getDeclaredMethods();
		for (int i = 0; i < methods.length; i++) {
			method = methods[i];
			System.out.println(method.getName());
			ANE annotation = method.getAnnotation(ANE.class);
			if (annotation != null) {
				functionMap.put(method.getName(),
						createFREFunction(method, annotation));
			}
		}
		return functionMap;
	}

	private FREFunction createFREFunction(final Method method, ANE annotation) {
		// TODO Auto-generated method stub
		return new FREFunction() {
			@Override
			public FREObject call(FREContext arg0, FREObject[] arg1) {
				FREObject obj = null;
				try {
					if (method.getReturnType().equals(Void.class)) {
						method.invoke(ExtContextBase.this, getArgs(arg1));
					} else {
						Object r = method.invoke(ExtContextBase.this,
								getArgs(arg1));
						if (r instanceof FREObject)
							obj = (FREObject) r;
						else if (r instanceof Integer)
							obj = FREObject.newObject((Integer) r);
						else if (r instanceof Double)
							obj = FREObject.newObject((Double) r);
						else if (r instanceof Boolean)
							obj = FREObject.newObject((Boolean) r);
						else if (r instanceof String)
							obj = FREObject.newObject((String) r);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				return obj;
			}

			private Object[] getArgs(FREObject[] arg1) {
				Type[] types = method.getParameterTypes();
				Object[] res = new Object[types.length];
				for (int i = 0; i < res.length; i++) {
					Type t = types[i];
					try {
						if (t.equals(int.class))
							res[i] = arg1[i].getAsInt();
						else if (t.equals(double.class))
							res[i] = arg1[i].getAsDouble();
						else if (t.equals(boolean.class))
							res[i] = arg1[i].getAsBool();
						else if (t.equals(String.class))
							res[i] = arg1[i].getAsString();
						else if (t.equals(byte[].class))
							res[i] = convertFREBaToBytes(arg1[i]);
						else if (t.equals(FREObject.class)
								|| t.equals(FREByteArray.class)
								|| t.equals(FREArray.class)
								|| t.equals(FREBitmapData.class))
							res[i] = arg1[i];
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				return res;
			}

			private byte[] convertFREBaToBytes(FREObject freObject)
					throws IllegalStateException, FREInvalidObjectException,
					FREWrongThreadException {
				FREByteArray byteArray = (FREByteArray) freObject;
				byteArray.acquire();
				ByteBuffer bb = byteArray.getBytes();
				byte[] bytes = new byte[(int) byteArray.getLength()];
				bb.get(bytes);
				byteArray.release();
				return bytes;
			}
		};
	}

	@Override
	public void dispose() {
	}
}
