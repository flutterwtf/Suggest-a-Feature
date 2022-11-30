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
        userId: '1',
        suggestionsDataSource: MyDataSource(
          userId: '1',
        ),
        theme: SuggestionsTheme.initial() ,
        onUploadMultiplePhotos: null,
        onSaveToGallery: null,
        onGetUserById: () {},
      ),
    ),
  );
```

If you want to give the user the ability to attach photos to suggestions and save them to the gallery, you just need to implement the `onUploadMultiplePhotos` and `onSaveToGallery` methods.

You can also either use our standard theme or create your own:

``` dart
 theme: SuggestionsTheme().copyWith(...),
```
 
If you use [firestore](https://firebase.google.cn/docs/firestore?hl=en) as a data source, you can use our ready-made implementation [Suggest a feature Firestore](TODO: add link) 
or create your own by implementing `SuggestionsDataSource` abstract class.
