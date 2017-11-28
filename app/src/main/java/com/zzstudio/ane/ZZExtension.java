package com.zzstudio.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ZZExtension implements FREExtension {

    private ZZExtContext context;

    @Override
    public FREContext createContext(String arg0) {
        context = new ZZExtContext();
        return context;
    }

    @Override
    public void dispose() {
        context.dispose();
        context = null;
    }

    @Override
    public void initialize() {
    }

}
