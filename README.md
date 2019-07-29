# flutteradal

Plugin to use ADAL from an on premise ADFS Server and Azure Active directory. Tested with 3.0 & Azure (27.07.2019).

Currently only iOS supported.

ios pod used 
    https://github.com/AzureAD/azure-activedirectory-library-for-objc


How-to


## IOS 

Set the minium deployment target of your project to 10.0 - This is a requirement set by the azure-activedirectory-library-for-objc https://github.com/AzureAD/azure-activedirectory-library-for-objc/issues/1435

Use the following commands in your flutter project after adding the package to your pubspec.yaml file. Flutter should do this alone but better save than sorry.

```
flutter packages get
cd /ios
pod init
pod install
```

## FLUTTER

**Checkout the example for details and an implementation!**

Create an AdalAuthContext. Call Flutteradal.adalLogin and pass your configuration data to it. 
The AdalAuthContext will hold the result.

On error and error will be set on AdalAuthContext.errorType

```
AdalAuthContext authContext;
authContext = await Flutteradal.adalLogin(
    authority: Config.authority,
    resourceUrl: Config.resourceUrl,
    clientId: Config.clientId,
    redirectUrl: Config.redirectUrl);
```