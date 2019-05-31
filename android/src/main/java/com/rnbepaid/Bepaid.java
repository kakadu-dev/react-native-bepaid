package com.rnbepaid;

import android.content.Intent;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class Bepaid extends ReactContextBaseJavaModule {
  public Bepaid(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "RNBepaid";
  }

  @ReactMethod
  public void show3DS(String url, Promise promise) {
    try {
      Intent intent = new Intent(getReactApplicationContext(), CheckoutActivity.class);

      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

      SecureActivity.url = url;
      SecureActivity.promise = promise;

      getReactApplicationContext().startActivity(intent);
    } catch (Exception e) {
      promise.reject(e.getMessage());
    }
  }
}