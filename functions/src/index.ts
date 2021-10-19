import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const fcm = admin.messaging();

export const sendOnEvents = functions.firestore
    .document('event/{year}')
    .onUpdate(
        async change => {

         var allNotices = [];

        var dataOfNotices = change.after;

        var noticeList = dataOfNotices.data();

    allNotices = noticeList!.events;

var lengthOfNotice = allNotices.length;

var noticeDetails = allNotices[lengthOfNotice - 1];


        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Event Added',
                body: noticeDetails.title
            }
        }
        fcm.sendToTopic('all', payload);

    });


export const sendOnHolidays = functions.firestore
    .document('holiday/{year}')
    .onUpdate(
        async change => {

         var allNotices = [];

        var dataOfNotices = change.after;

        var noticeList = dataOfNotices.data();

    allNotices = noticeList!.holidays;

var lengthOfNotice = allNotices.length;

var noticeDetails = allNotices[lengthOfNotice - 1];


        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Holiday Added',
                body: noticeDetails.title
            }
        }
        fcm.sendToTopic('all', payload);

    });


export const sendOnStudentNotice = functions.firestore
    .document('notice/student')
    .onUpdate(
        async change => {

         var allNotices = [];

        var dataOfNotices = change.after;

        var noticeList = dataOfNotices.data();

    allNotices = noticeList!.notices;

var lengthOfNotice = allNotices.length;

var noticeDetails = allNotices[lengthOfNotice - 1];

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Notice Added',
                body: noticeDetails.title
            }
        }
        fcm.sendToTopic('student', payload);

    });

export const sendOnStaffNotice = functions.firestore
    .document('notice/teacher')
    .onUpdate(
        async change => {

         var allNotices = [];

        var dataOfNotices = change.after;

        var noticeList = dataOfNotices.data();

    allNotices = noticeList!.notices;

var lengthOfNotice = allNotices.length;

var noticeDetails = allNotices[lengthOfNotice - 1];


        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Notice Added',
                body: noticeDetails.title
            }
        }
        fcm.sendToTopic('staff', payload);

    });

