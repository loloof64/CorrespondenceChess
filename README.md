# Correspondence Chess

Play correspondence chess on your device.

## Developers

### Firebase CLI

Don't forget to set up **FlutterFire CLI** and to call `flutterfire configure` in your terminal ! Because this will generate the file **lib/firebase_options.dart** that you will need in order to run and build the project.

### Firestore

Don't forget to allow read access and to restric write access to connected users, with rules such as :

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow write: if request.auth != null;
      allow read: if true;
    }
  }
}
```