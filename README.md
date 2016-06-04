baresip-android
===============

Baresip for Android


This project shows how to build baresip for Android NDK.
Baresip is a modular SIP-client with audio/video support
that supports many target platforms. Baresip can be used
as a standalone console application, or as a powerful
toolkit (libbaresip) for 3rd-party applications.




## Step 1 - download source code

Download baresip/librem/libre source from creytiv.com [1]

```
$ wget http://www.creytiv.com/pub/baresip-0.4.19.tar.gz
$ wget http://www.creytiv.com/pub/rem-0.4.7.tar.gz
$ wget http://www.creytiv.com/pub/re-0.4.16.tar.gz
$ # .. and download OpenSSL source from openssl.org [2]
$ wget https://www.openssl.org/source/openssl-1.0.2h.tar.gz
$ # .. download Android NDK from [3]
```



## Step 2 - unpack source code

unpack the source code in the current directory, or create
symlinks to the source code so that you have a layout like this:

    baresip/
    openssl/
    re/
    rem/



## Step 3 - build openssl

libre depends on openssl for crypto and TLS.

```
$ make openssl
```



## Step 4 - build baresip + libs

baresip depends on librem and libre.

```
$ make baresip
```

this will create a statically linked binary in baresip/baresip




## Step 5 - install baresip in Emulator or target

```
$ make install
```

this will use adb to install baresip in your configured Android emulator.
you can also copy the binary to an Android device using ssh.




## Support

if you have questions or issues you are welcome to join our
mailing-list [4] and contribute patches here :)




## References:

[1] www.creytiv.com
[2] www.openssl.org
[3] http://developer.android.com/tools/sdk/ndk/index.html
[4] http://lists.creytiv.com/mailman/listinfo/re-devel
