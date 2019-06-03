package com.rnbepaid;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;

public class SecureActivity extends Activity {

    static String url;
    static String endUrl;
    static Promise promise;

    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        String url = SecureActivity.url;

        webView = new WebView(this);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return handleUrl(url);
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                if (request.getUrl() == null) {
                    return false;
                }

                return handleUrl(request.getUrl().toString());
            }

            private boolean handleUrl(String url) {
                if (url.contains(SecureActivity.endUrl)) {
                    success();
                    finish();
                    return true;
                }
                webView.loadUrl(url);
                return true;
            }
        });
        setContentView(webView);
        webView.loadUrl(url);
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            error();
            super.onBackPressed();
        }
    }

    private void success() {
        WritableMap map = Arguments.createMap();

        map.putBoolean("status", true);

        SecureActivity.promise.resolve(map);
    }

    private void error() {
        WritableMap map = Arguments.createMap();

        map.putBoolean("status", false);
        map.putString("message", "Canceled");

        SecureActivity.promise.reject("Canceled");
    }
}
