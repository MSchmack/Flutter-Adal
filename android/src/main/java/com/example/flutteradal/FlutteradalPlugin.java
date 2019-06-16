package com.example.flutteradal;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.microsoft.aad.adal.ADALError;
import com.microsoft.aad.adal.AuthenticationCallback;
import com.microsoft.aad.adal.AuthenticationContext;
import com.microsoft.aad.adal.AuthenticationException;
import com.microsoft.aad.adal.AuthenticationResult;
import com.microsoft.aad.adal.IDispatcher;
import com.microsoft.aad.adal.Logger;
import com.microsoft.aad.adal.PromptBehavior;
import com.microsoft.aad.adal.Telemetry;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.annotation.VisibleForTesting;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.FileProvider;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/** FlutteradalPlugin */
public class FlutteradalPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

  private static final String TAG = "android plugin";
      /* Azure AD Variables */
      private AuthenticationContext mAuthContext;
      private AuthenticationResult mAuthResult;

    private static MethodChannel channel;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutteradal");
    activity = registrar.activity();
    channel.setMethodCallHandler(new FlutteradalPlugin());

    FlutteradalPlugin.channel = channel;

    // registrar.addActivityResultListener(instance);
  }
  private Result result;
  private static Activity activity;
  /* Azure AD Constants */
  /* Authority is in the form of https://login.microsoftonline.com/yourtenant.onmicrosoft.com */
  private static final String AUTHORITY = "https://stfs.bosch.com/adfs";
  /* The clientID of your application is a unique identifier which can be obtained from the app registration portal */
  private static final String CLIENT_ID = "ba1169fd-37c7-45ce-acbb-937c64bb0fb1";
  /* Resource URI of the endpoint which will be accessed */
  private static final String RESOURCE_ID = "https://stfs.bosch.com/adfs/userinfo";
  /* The Redirect URI of the application (Optional) */
  private static final String REDIRECT_URI = "https://rb-portal.bosch.com";
Result mResult;
  @Override
  public void onMethodCall(MethodCall call, Result result) {


    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      
    } else if(call.method.equals("adalGetToken")) {
      result.success(mAuthResult);
    } else if(call.method.equals("adalSilentLogin")) {
      // result.success(mAuthContext.acquireTokenSilentSync(RESOURCE_ID, CLIENT_ID, userId));
    } else {
      
      channel.invokeMethod("callback2", "FFF");
      // this.result = result;
          mResult = result;
      // Initialize your app with MSAL
      mAuthContext = new AuthenticationContext(
              activity,
              AUTHORITY,
              false);
      // Perform authentication requests
      Log.d(TAG, "starting");
      mAuthContext.acquireToken(
              activity,
              RESOURCE_ID,
              CLIENT_ID,
              REDIRECT_URI,
              PromptBehavior.Auto,
              getAuthInteractiveCallback() );

    }
  } 
  // @Override
  // protected void onActivityResult(int requestCode, int resultCode, Intent data) {
  //     super.onActivityResult(requestCode, resultCode, data);
  //     if (mAuthContext != null) {
  //       mAuthContext.onActivityResult(requestCode, resultCode, data);
  //     }
  // }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        // super.onActivityResult(requestCode, resultCode, data);
        mAuthContext.onActivityResult(requestCode, resultCode, data);
        return false;
    }

  private AuthenticationCallback<AuthenticationResult> getAuthInteractiveCallback() {
    channel.invokeMethod("init callback", "qweqweqwe");
     return new AuthenticationCallback<AuthenticationResult>() {
            @Override
            public void onSuccess(AuthenticationResult authenticationResult) {
                if(authenticationResult==null || TextUtils.isEmpty(authenticationResult.getAccessToken())
                        || authenticationResult.getStatus()!= AuthenticationResult.AuthenticationStatus.Succeeded){
                    Log.e(TAG, "Authentication Result is invalid");
                      channel.invokeMethod("init callback inside", "odd behavior"); 
                    return;
                }
                
                channel.invokeMethod("init callback inside", "this is fine");    
                /* Successfully got a token, call graph now */
                Log.d(TAG, "Successfully authenticated");
                Log.d(TAG, "ID Token: " + authenticationResult.getIdToken());

                /* Store the auth result */
                mAuthResult = authenticationResult;

                /* Store User id to SharedPreferences to use it to acquire token silently later */
                // SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                // preferences.edit().putString(USER_ID, authenticationResult.getUserInfo().getUserId()).apply();
            }

            @Override
            public void onError(Exception exception) {
                /* Failed to acquireToken */
                Log.e(TAG, "Authentication failed: " + exception.toString());
                channel.invokeMethod("error", "qwe");
                if (exception instanceof AuthenticationException) {
                  
                    ADALError  error = ((AuthenticationException)exception).getCode();
                    if(error==ADALError.AUTH_FAILED_CANCELLED){
                        Log.e(TAG, "The user cancelled the authorization request");
                    }
                }
            }
        };
  }
}
