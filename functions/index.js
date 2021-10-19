import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const events = functions.firestore.document('event/2030-2031').onUpdate(snapshot => {

 var allEvents = [];

  allEvents = snapshot.data().events;

var lengthOfEvents = allEvents.length;

var eventDetails = allEvents[lengthOfEvents - 1];

       var payload = {
  notification: {
    title: 'Event Added',
    body: eventDetails.title,
    clickAction: 'FLUTTER_NOTIFICATION_CLICK',

  },
  topic: 'all'
};

    fcm.send(payload).then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });

}

);

//export const notifyNewEvent = functions.firestore
//    .document('event/2030-2031')
//    .onUpdate(async snapshot => {
//
//        const event = snapshot.data();
//
//        var eventName;
//
//        const querySnapshot = await db
//            .collection('users')
//            .doc(message.receiverId)
//            .collection('tokens')
//            .get();
//
//        const tokens = querySnapshot.docs.map(snap => snap.id);
//
//        const payload: admin.messaging.MessagingPayload = {
//            notification: {
//                title: `Flutter Chat App | ${message.senderName}`,
//                body: message.messageBody,
//                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
//            }
//        }
//        return fcm.sendToDevice(tokens, payload);
//
//    });



// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
