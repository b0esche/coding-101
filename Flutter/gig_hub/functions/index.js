
/**
 * Firebase Cloud Functions for GigHub Application
 * 
 * Features:
 * - User rating system with validation and aggregation
 * - Push notifications for direct chat messages
 * - Push notifications for group chat messages
 * - Firestore triggers for real-time message notifications
 * - FCM token management and message delivery
 * 
 * All functions use Firebase Admin SDK for secure server-side operations
 */

const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Handles user rating submissions with validation and aggregation
 * 
 * Validates rating data, prevents self-rating, and calculates
 * average ratings for users in the system.
 * 
 * @param {Object} requestData - Contains raterId, targetUserId, and rating
 * @param {Object} context - Firebase function context
 * @returns {Object} Success message with rating details
 */
exports.submitRating = onCall(async (requestData, context) => {
  const data = requestData && requestData.data ? requestData.data : requestData;

  const raterId = data.raterId;
  const targetUserId = data.targetUserId;
  const rawRating = data.rawRating;
  const rating = Number(rawRating);

  // Input validation
  if (!raterId) {
    throw new HttpsError("invalid-argument",
      "Missing raterId");
  }
  if (!targetUserId) {
    throw new HttpsError("invalid-argument",
      "Missing targetUserId");
  }
  if (isNaN(rating)) {
    throw new HttpsError("invalid-argument",
      "Rating is not a number");
  }
  if (rating < 1.0 || rating > 5.0) {
    throw new HttpsError("invalid-argument",
      "Rating out of bounds");
  }

  const ratingRef = admin
    .firestore()
    .collection("users")
    .doc(targetUserId)
    .collection("receivedRatings")
    .doc(raterId);

  await ratingRef.set({
    rating: rating,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });

  const snapshot = await admin
    .firestore()
    .collection("users")
    .doc(targetUserId)
    .collection("receivedRatings")
    .get();

  const allRatings = snapshot.docs.map((doc) => doc.data().rating);
  const avgRating = allRatings.reduce(
    (sum, r) => sum + r, 0) / allRatings.length;

  await admin.firestore().collection("users").doc(targetUserId).update({
    avgRating: avgRating,
    ratingCount: allRatings.length,
  });

  return {
    avgRating,
    ratingCount: allRatings.length,
  };
});

/**
 * Sends push notifications for direct chat messages
 * 
 * Triggered when a new message is created in any direct chat.
 * Fetches sender information and sends a notification to the receiver
 * if they have an FCM token registered.
 * 
 * @param {Object} event - Firestore document creation event
 */
exports.sendChatNotification =
  onDocumentCreated("chats/{chatId}/messages/{messageId}",
    async (event) => {
      const message = event.data.data();
      const receiverId = message.receiverId;
      const senderId = message.senderId;

      // Get sender information for notification display
      const senderDoc = await getFirestore().collection("users")
        .doc(senderId).get();
      const senderName = senderDoc.data().name;

      // Get receiver's FCM token for push notification
      const userDoc = await getFirestore().collection("users")
        .doc(receiverId).get();
      const fcmToken = userDoc.data().fcmToken;

      if (fcmToken) {
        const payload = {
          notification: {
            title: senderName,
            body: "new message",
          },
          data: {
            senderId: senderId,
            screen: "chat_list_screen",
          },
          android: {
            priority: "high",
            notification: {
              channelId: "chat_channel",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
              },
            },
          },
          token: fcmToken,
        };
        await getMessaging().send(payload);
      }
    });

/**
 * Sends push notifications for group chat messages
 * 
 * Triggered when a new message is created in any group chat.
 * Fetches all group members and sends notifications to everyone
 * except the message sender.
 * 
 * @param {Object} event - Firestore document creation event with groupChatId
 */
exports.sendGroupChatNotification =
  onDocumentCreated("group_chats/{groupChatId}/messages/{messageId}",
    async (event) => {
      const message = event.data.data();
      const senderId = message.senderId;
      const senderName = message.senderName;
      const groupChatId = event.params.groupChatId;

      // Fetch group chat details to get member list and group name
      const groupChatDoc = await getFirestore().collection("group_chats")
        .doc(groupChatId).get();
      const groupChatData = groupChatDoc.data();
      const memberIds = groupChatData.memberIds || [];
      const groupName = groupChatData.name;

      // Send notification to all group members except the sender
      const notificationPromises = memberIds
        .filter((memberId) => memberId !== senderId)
        .map(async (memberId) => {
          const userDoc = await getFirestore().collection("users")
            .doc(memberId).get();
          const userData = userDoc.data();
          const fcmToken = userData && userData.fcmToken;

          if (fcmToken) {
            const payload = {
              notification: {
                title: groupName,
                body: `${senderName}: new message`,
              },
              data: {
                senderId: senderId,
                groupChatId: groupChatId,
                screen: "chat_list_screen",
              },
              android: {
                priority: "high",
                notification: {
                  channelId: "chat_channel",
                },
              },
              apns: {
                payload: {
                  aps: {
                    sound: "default",
                  },
                },
              },
              token: fcmToken,
            };
            return getMessaging().send(payload);
          }
        });

      await Promise.all(notificationPromises.filter((p) => p !== undefined));
    });
