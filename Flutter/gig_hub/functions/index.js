const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.submitRating = functions.https.onCall(async (requestData, context) => {
  const data = requestData && requestData.data ? requestData.data : requestData;

  const raterId = data.raterId;
  const targetUserId = data.targetUserId;
  const rawRating = data.rawRating;
  const rating = Number(rawRating);

  if (!raterId) {
    throw new functions.https.HttpsError("invalid-argument",
        "Missing raterId");
  }
  if (!targetUserId) {
    throw new functions.https.HttpsError("invalid-argument",
        "Missing targetUserId");
  }
  if (isNaN(rating)) {
    throw new functions.https.HttpsError("invalid-argument",
        "Rating is not a number");
  }
  if (rating < 1.0 || rating > 5.0) {
    throw new functions.https.HttpsError("invalid-argument",
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
