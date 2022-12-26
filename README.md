# Suggest a feature

This Flutter package is a ready-made module which allows other developers to implement additional menu in their own mobile app where users can share their suggestions about the application in real time, discuss them with others, and vote for each other`s suggestions    
  
Here is a small demo:

![gif](/assets/suggest_a_feature.gif)

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

## Localization 

At the moment the package supports 3 languages: English, Russian and Ukrainian. 

``` dart
MaterialApp(
  home: SuggestionsPage(),
  localizationsDelegates: [
    SuggestionsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
  ],
);
```
`SuggestionsLocalizations` - strings localization
`GlobalMaterialLocalizations`- date format localization

## Essential checks

For each suggestion and comment manipulation (updating or deleting) we recommend to check either user have author rights to fulfil those actions. Author rights is such a concept that only the user who created a suggestion/comment can delete or update it. If somehow happens the situation when user without author rights will try to delete/update a suggestion will be thrown an Exception.
`onGetUserById()` function in `SuggestionsPage` constructor will help you with this.