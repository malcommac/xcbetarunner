<p align="center" >
<img src="logo.png" width=368px alt="SwiftDate" title="SwiftDate">
</p>

**Debug & Test your app on iOS's beta device using stable Xcode version**

<p align="center" >★★ <b>Star me to follow the project! </b> ★★<br>
Created and maintaned by <b>Daniele Margutti</b> - <a href="http://www.danielemargutti.com">www.danielemargutti.com</a>
</p>

## What's xcbetarunner?
xcbetarunner is a really simple command line utility which allows you to deploy and test your application using stable XCode version inside a device where you have installed an iOS Beta or Pre-Release version.

## Usage
There are three different commands you can use with `xbetarunner`:

### 1. List iOS DeviceSupport's SDK for an Xcode version

The following command return a list of all iOS DeviceSupport's SDKs available in a particular Xcode version (if `xc` parameter is not specified `/Applications/Xcode` is used instead).

```
~ xcbetarunner -a list [-xc <path_to_xcode>]
```

Result is something like this:

```
~ xcbetarunner -a list
📲 Welcome to xcbetarunner

18 SDKs supported by Xcode 10.0(18A313):
- 11.4 (15F79)
- 11.3
- 11.2
- 11.1
- 11.0
...
```

### 2. Compare for new DeviceSupport's SDKs between two Xcode versions

The following command return the list of new DeviceSupport's SDKs currently available on `Xcode-beta.app` which are not available on `Xcode.app` (you can change versions by passing `-xc <path>` paramater for a different `Xcode.app` and `- xcb <path>` for a different `Xcode-beta.app`).


```
~ xcbetarunner -a new
```

Result is something like this:

```
~ xcbetarunner -a new
📲 Welcome to xcbetarunner, a simple way to use new iOS SDKs on old XCode

2 SDKs from Xcode 10.0(18A313) but not available on Xcode 9.4.1(17E158):
- 12.0 (16A5318d)
- 11.4
```

### 3. Use DeviceSupport's SDKs from Xcode-beta to Xcode stable

The last command is the most important of the set.
It allows you to support device with a specified iOS SDK version (available in an `Xcode-beta.app`) inside your `Xcode.app` stable version.

As for previous you can specify both the `-xc` and `-xcb` parameter (if `xc` parameter is not specified `/Applications/Xcode.app` is used instead, if `xcb` is not specified `/Applications/Xcode-beta.app` ).

`sudo` is required for this command.

#### Copy all new SDKs not available into stable Xcode.app

`~ sudo xcbetarunner -a use -sdk all`

or 

`~ sudo xcbetarunner -a sync`

#### Copy specified SDKs into stable Xcode.app

The following command copy SDK named/contained into `12.0 (16A5318d)` folder.
(You can pass multiple SDKs by passing a `,` separated list as `-sdk` parameter).

`~ sudo xcbetarunner -a use -sdk 12.0\ \(16A5318d\)`

Result is like this:

```
~ sudo xcbetarunner -a use -sdk 12.0\ \(16A5318d\)
Password:
📲 Welcome to xcbetarunner, a simple way to use new iOS SDKs on old XCode

🕑 Now copying "12.0 (16A5318d)"...
✅ Device Support for SDK "12.0 (16A5318d)" is now available on Xcode 9.4.1(17E158) 🎉
```

Default behaviour create a symbolic link (enough if you plan to keep the `Xcode-beta.app` installed in your system). If you want to copy the SDK (it requires a bit more time) just puss `-l false` as parameter.

## Installation
Installation is pretty simple, just execute the following commands from your terminal.
Application will be installed in `/usr/local/bin` folder and you can use it using `xbetarunner` command.

```bash
$ git clone git@github.com:malcommac/xcbetarunner.git
$ cd xcbetarunner
$ make
```

Now you can call it just by using `xcbetarunner` from your terminal, folloed by the required arguments.

## Questions or feedback?

xcbetarunner was created by [Daniele Margutti](http://www.danielemargutti).

Feel free to [open an issue](https://github.com/malcommac/xcbetarunner/issues/new), or find me [@danielemargutti on Twitter](https://twitter.com/danielemargutti).
