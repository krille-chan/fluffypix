# Privacy

FluffyPix is available on Android, iOS and as a web version.

*   [Mastodon API](#1)
*   [Database](#2)
*   [Encryption](#3)
*   [App Permissions](#4)
*   [Push Notifications](#5)

## Mastodon API<a id="1"/>
FluffyPix uses the Mastodon API. This means that FluffyPix is just a client that can be connected to any compatible server. The respective data protection agreement of the server selected by the user then applies.

For convenience, FluffyPix loads a list of servers from the API at https://instances.social/.

FluffyPix only communicates with https://instances.social/ and the selected server.

More information is available at: https://docs.joinmastodon.org/client/intro/

## Database<a id="2"/>
FluffyPix caches some data received from the server in a local database on the device of the user.

More information is available at: https://pub.dev/packages/hive

## Encryption<a id="3"/>
All communication of substantive content between FluffyPix and any server is done in secure way, using transport encryption to protect it.

## App Permissions<a id="4"/>

The permissions are the same on Android and iOS but may differ in the name. This are the Android Permissions:

#### Internet Access
FluffyPix needs to have internet access to communicate with the server.

#### Vibrate
FluffyPix uses vibration for local notifications. More informations about this are at the used package: https://pub.dev/packages/flutter_local_notifications

#### Write External Storage
The user is able to save received files and therefore app needs this permission.

#### Read External Storage
The user is able to send files from the device's file system.

## Push Notifications<a id="6"/>
FluffyPix uses the Firebase Cloud Messaging service for push notifications on Android and iOS. This takes place in the following steps:
1. The selected server sends the (encrypted) push notification to the FluffyPix Push Gateway
2. The FluffyPix Push Gateway forwards the message in a different format to Firebase Cloud Messaging
    Important: The Push Gateway is **not** able to decrypt the notification and doesn't need to be anyway!
3. Firebase Cloud Messaging waits until the user's device is online again
4. The device receives the push notification from Firebase Cloud Messaging and displays it as a notification

The source code of the push gateway can be viewed here: https://gitlab.com/KrilleFear/fluffypix-push-gateway

The push notifications are using the Web Push API. They are encrypted using AES. Keys are shared using ECDH-prime256v1 while the public key is uploaded by the client once. More information about Web Push can be found here: https://developer.mozilla.org/de/docs/Web/API/Push_API

FluffyPix can only share the public key. The selected server is then responsible to encrypt them correctly.
