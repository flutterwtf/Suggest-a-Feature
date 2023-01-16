import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'suggestions_localizations_en.dart';
import 'suggestions_localizations_ru.dart';
import 'suggestions_localizations_uk.dart';

/// Callers can lookup localized strings with an instance of SuggestionsLocalizations
/// returned by `SuggestionsLocalizations.of(context)`.
///
/// Applications need to include `SuggestionsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/suggestions_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SuggestionsLocalizations.localizationsDelegates,
///   supportedLocales: SuggestionsLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SuggestionsLocalizations.supportedLocales
/// property.
abstract class SuggestionsLocalizations {
  SuggestionsLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale);

  final String localeName;

  static SuggestionsLocalizations? of(BuildContext context) {
    return Localizations.of<SuggestionsLocalizations>(context, SuggestionsLocalizations);
  }

  static const LocalizationsDelegate<SuggestionsLocalizations> delegate = _SuggestionsLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @suggestAFeature.
  ///
  /// In en, this message translates to:
  /// **'Suggest a feature'**
  String get suggestAFeature;

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get feature;

  /// No description provided for @bug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get bug;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by:'**
  String get postedBy;

  /// No description provided for @upvote.
  ///
  /// In en, this message translates to:
  /// **'Upvote'**
  String get upvote;

  /// No description provided for @attachedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Attached photos'**
  String get attachedPhotos;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @notifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get notifyMe;

  /// No description provided for @notificationDescription.
  ///
  /// In en, this message translates to:
  /// **'When this suggestion is completed'**
  String get notificationDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit suggestion'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete suggestion'**
  String get delete;

  /// No description provided for @deletionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the suggestion?'**
  String get deletionQuestion;

  /// No description provided for @deletionPhotoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this photo?'**
  String get deletionPhotoQuestion;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your suggestion'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Describe your suggestion in details'**
  String get description;

  /// No description provided for @postAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Post anonymously'**
  String get postAnonymously;

  /// No description provided for @suggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest'**
  String get suggest;

  /// No description provided for @anonymousAuthorName.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymousAuthorName;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @requestsHeader.
  ///
  /// In en, this message translates to:
  /// **'Feature requests'**
  String get requestsHeader;

  /// No description provided for @requestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Join other users'**
  String get requestsDescription;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @inProgressHeader.
  ///
  /// In en, this message translates to:
  /// **'Features in development'**
  String get inProgressHeader;

  /// No description provided for @inProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'What will be added to the app soon'**
  String get inProgressDescription;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedHeader.
  ///
  /// In en, this message translates to:
  /// **'Implemented features'**
  String get completedHeader;

  /// No description provided for @completedDescription.
  ///
  /// In en, this message translates to:
  /// **'What’s been already implemented'**
  String get completedDescription;

  /// No description provided for @savingImageError.
  ///
  /// In en, this message translates to:
  /// **'Error: can’t save the photo'**
  String get savingImageError;

  /// No description provided for @savingImageSuccess.
  ///
  /// In en, this message translates to:
  /// **'The photo has been successfully saved'**
  String get savingImageSuccess;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete'**
  String get yesDelete;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @newComment.
  ///
  /// In en, this message translates to:
  /// **'New сomment'**
  String get newComment;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Your comment…'**
  String get commentHint;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @eventPhotosRestriction.
  ///
  /// In en, this message translates to:
  /// **'You can attach up to 10 photos 🖼️'**
  String get eventPhotosRestriction;
}

class _SuggestionsLocalizationsDelegate extends LocalizationsDelegate<SuggestionsLocalizations> {
  const _SuggestionsLocalizationsDelegate();

  @override
  Future<SuggestionsLocalizations> load(Locale locale) {
    return SynchronousFuture<SuggestionsLocalizations>(lookupSuggestionsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_SuggestionsLocalizationsDelegate old) => false;
}

SuggestionsLocalizations lookupSuggestionsLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SuggestionsLocalizationsEn();
    case 'ru': return SuggestionsLocalizationsRu();
    case 'uk': return SuggestionsLocalizationsUk();
  }

  throw FlutterError(
    'SuggestionsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
