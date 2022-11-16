# Suggest a feature

This Flutter package is a ready-made module for collecting suggestions from users and displaying the progress of their implementation.  
  
Here is a small demo:

[![](https://media.giphy.com/media/fbcqgpyyceyYLqiZfa/giphy.gif)](https://media.giphy.com/media/fbcqgpyyceyYLqiZfa/giphy.gif)

## Usage

You need to move the `SuggestionsPage`. For example:

``` dart
Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SuggestionsPage(
        userId: ... ,
        imageHeaders: ... ,
        suggestionsDataSource: ... ,
        theme: ... ,
        onUploadMultiplePhotos: ... ,
        onSaveToGallery: ... ,
        onGetUserById: ... ,
      ),
    ),
  );
```

If you use [firestore](https://firebase.google.cn/docs/firestore?hl=en) as a data source, you can use our ready-made implementation [Suggest a feature Firestore](TODO: add link) 
or create your own by implementing `SuggestionsDataSource` abstract class.
