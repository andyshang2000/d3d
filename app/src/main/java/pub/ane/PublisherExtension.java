package pub.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class PublisherExtension implements FREExtension {

	private PublisherExtContext publisherExtContext;

	@Override
	public FREContext createContext(String arg0) {
		publisherExtContext = new PublisherExtContext();
		return publisherExtContext;
	}

	@Override
	public void dispose() {
		publisherExtContext.dispose();
		publisherExtContext = null;
	}

	@Override
	public void initialize() {
	}

}
