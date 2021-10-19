"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendOnStaffNotice = exports.sendOnStudentNotice = exports.sendOnHolidays = exports.sendOnEvents = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const fcm = admin.messaging();
exports.sendOnEvents = functions.firestore
    .document('event/{year}')
    .onUpdate(async (change) => {
    var allNotices = [];
    var dataOfNotices = change.after;
    var noticeList = dataOfNotices.data();
    allNotices = noticeList.events;
    var lengthOfNotice = allNotices.length;
    var noticeDetails = allNotices[lengthOfNotice - 1];
    const payload = {
        notification: {
            title: 'New Event Added',
            body: noticeDetails.title
        }
    };
    fcm.sendToTopic('all', payload);
});
exports.sendOnHolidays = functions.firestore
    .document('holiday/{year}')
    .onUpdate(async (change) => {
    var allNotices = [];
    var dataOfNotices = change.after;
    var noticeList = dataOfNotices.data();
    allNotices = noticeList.holidays;
    var lengthOfNotice = allNotices.length;
    var noticeDetails = allNotices[lengthOfNotice - 1];
    const payload = {
        notification: {
            title: 'New Holiday Added',
            body: noticeDetails.title
        }
    };
    fcm.sendToTopic('all', payload);
});
exports.sendOnStudentNotice = functions.firestore
    .document('notice/student')
    .onUpdate(async (change) => {
    var allNotices = [];
    var dataOfNotices = change.after;
    var noticeList = dataOfNotices.data();
    allNotices = noticeList.notices;
    var lengthOfNotice = allNotices.length;
    var noticeDetails = allNotices[lengthOfNotice - 1];
    const payload = {
        notification: {
            title: 'New Notice Added',
            body: noticeDetails.title
        }
    };
    fcm.sendToTopic('student', payload);
});
exports.sendOnStaffNotice = functions.firestore
    .document('notice/teacher')
    .onUpdate(async (change) => {
    var allNotices = [];
    var dataOfNotices = change.after;
    var noticeList = dataOfNotices.data();
    allNotices = noticeList.notices;
    var lengthOfNotice = allNotices.length;
    var noticeDetails = allNotices[lengthOfNotice - 1];
    const payload = {
        notification: {
            title: 'New Notice Added',
            body: noticeDetails.title
        }
    };
    fcm.sendToTopic('staff', payload);
});
//# sourceMappingURL=index.js.map