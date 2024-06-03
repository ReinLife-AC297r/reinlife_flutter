# ReinLife:

An mHealth Flutter project.

## Getting Started

We use flutter as frontend platform:
Step 1: follow this tutorial on [setting up Flutter and an editor](https://docs.flutter.dev/get-started/install). 

The next step is to create a database in the cloud:
Step 2: create a [Firebase account](https://firebase.google.com/_d/signin?continue=https%3A%2F%2Ffirebase.google.com%2F%3Fgad_source%3D1%26gclid%3DCjwKCAiA-P-rBhBEEiwAQEXhH8j_MvM6HBU3U6-wnui5gVv7rAP5RaurnILUfYogCBMDqu6RM_PsFBoC1X4QAvD_BwE%26gclsrc%3Daw.ds&prompt=select_account) using your Google account

Step 3: create a [Flutter Firebase project](https://console.firebase.google.com/u/0/?fb_gclid=CjwKCAiA-P-rBhBEEiwAQEXhH8j_MvM6HBU3U6-wnui5gVv7rAP5RaurnILUfYogCBMDqu6RM_PsFBoC1X4QAvD_BwE&_gl=1*72g9gv*_ga*NjgwMTYwNDYzLjE2ODkwMzQyMDk.*_ga_CW55HF8NVT*MTcwMjkzMTE3My4yMi4xLjE3MDI5MzI2MjAuNDguMC4w) and follow the steps

Step 4: create [Firestore database](https://www.youtube.com/watch?v=2yNyiW_41H8). Make sure to allow your local firbase admin to read an write to the cloud Firestore by setting `allow read, write` to `true`. To do that, Firestore rules should look like the following:
```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
``` 

To link our database to our flutter app:
Step 5: set up [Flutterfire CLI](https://firebase.flutter.dev/docs/cli/?gclid=Cj0KCQiAj_CrBhD-ARIsAIiMxT9ssAjBnXvTHfhDygV_ZngMfzcRgEH8zEtf2poqmDtpy3AMJHKm7r4aArzlEALw_wcB&gclsrc=aw.ds) to connect Flutter app to the firebase in multiple platforms

Step 6: configure firbase in [Flutter app](https://firebase.google.com/docs/flutter/setup?platform=ios)
