importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


const firebaseConfig = {
    apiKey: "AIzaSyANl1-XYCY1B0_qcHrf1ZPN643ii1b5KYU",
    authDomain: "fluffypix-11c3d.firebaseapp.com",
    projectId: "fluffypix-11c3d",
    storageBucket: "fluffypix-11c3d.appspot.com",
    messagingSenderId: "248308891322",
    appId: "1:248308891322:web:8bba27a245174f0d758c83"
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});