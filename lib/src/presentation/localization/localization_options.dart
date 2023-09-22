class LocalizationOptions {
  final String locale;
  final String suggestion;
  final String suggestAFeature;
  final String feature;
  final String bug;
  final String postedBy;
  final String upvote;
  final String attachedPhotos;
  final String labels;
  final String notifyMe;
  final String notificationDescription;
  final String save;
  final String edit;
  final String delete;
  final String deletionQuestion;
  final String deletionPhotoQuestion;
  final String deletionCommentQuestion;
  final String title;
  final String description;
  final String postAnonymously;
  final String postFromAdmin;
  final String suggest;
  final String status;
  final String anonymousAuthorName;
  final String adminAuthorName;
  final String requests;
  final String requestsHeader;
  final String requestsDescription;
  final String inProgress;
  final String inProgressHeader;
  final String inProgressDescription;
  final String completed;
  final String completedHeader;
  final String completedDescription;
  final String duplicated;
  final String duplicatedHeader;
  final String duplicatedDescription;
  final String declined;
  final String cancelledHeader;
  final String cancelledDescription;
  final String savingImageError;
  final String savingImageSuccess;
  final String addPhoto;
  final String cancel;
  final String done;
  final String yesDelete;
  final String commentsTitle;
  final String newComment;
  final String commentHint;
  final String publish;
  final String add;
  final String eventPhotosRestriction;
  final String sortBy;
  final String numberOfLikes;
  final String creationDate;

  const LocalizationOptions(
    this.locale, {
    this.suggestion = 'Suggestion',
    this.suggestAFeature = 'Suggest a feature',
    this.feature = 'Feature',
    this.bug = 'Bug',
    this.postedBy = 'Posted by:',
    this.upvote = 'Upvote',
    this.attachedPhotos = 'Attached photos',
    this.labels = 'Labels',
    this.notifyMe = 'Notify me',
    this.notificationDescription = 'When this suggestion is completed',
    this.save = 'Save',
    this.edit = 'Edit suggestion',
    this.delete = 'Delete suggestion',
    this.deletionQuestion = 'Are you sure you want to delete the suggestion?',
    this.deletionPhotoQuestion = 'Are you sure you want to delete this photo?',
    this.deletionCommentQuestion =
        'Are you sure you want to delete this comment?',
    this.title = 'Briefly describe your suggestion',
    this.description = 'Describe your suggestion in details',
    this.postAnonymously = 'Post anonymously',
    this.postFromAdmin = 'Post from Admin',
    this.suggest = 'Suggest',
    this.status = 'Status',
    this.anonymousAuthorName = 'Anonymous',
    this.adminAuthorName = 'Admin',
    this.requests = 'Requests',
    this.requestsHeader = 'Feature requests',
    this.requestsDescription = 'Join other users',
    this.inProgress = 'In Progress',
    this.inProgressHeader = 'Features in development',
    this.inProgressDescription = 'What will be added to the app soon',
    this.completed = 'Completed',
    this.completedHeader = 'Implemented features',
    this.completedDescription = 'What’s been already implemented',
    this.duplicated = 'Duplicated',
    this.duplicatedHeader = 'Duplicated features',
    this.duplicatedDescription = 'What’s been already suggested',
    this.declined = 'Declined',
    this.cancelledHeader = 'Cancelled features',
    this.cancelledDescription = 'Cancelled features',
    this.savingImageError = 'Error: can’t save the photo',
    this.savingImageSuccess = 'The photo has been successfully saved',
    this.addPhoto = 'Add Photo',
    this.cancel = 'Cancel',
    this.done = 'Done',
    this.yesDelete = 'Yes, delete',
    this.commentsTitle = 'Comments',
    this.newComment = 'New сomment',
    this.commentHint = 'Your comment…',
    this.publish = 'Publish',
    this.add = 'Add',
    this.eventPhotosRestriction = 'You can attach up to 10 photos 🖼️',
    this.sortBy = 'Sort by',
    this.numberOfLikes = 'Number of likes',
    this.creationDate = 'Creation date',
  });

  factory LocalizationOptions.en() => const LocalizationOptions('en');

  factory LocalizationOptions.ru() => const LocalizationOptions(
        'ru',
        suggestion: 'Предложение',
        suggestAFeature: 'Предложить фичу',
        feature: 'Фича',
        bug: 'Баг',
        postedBy: 'Опубликовал:',
        upvote: 'Проголосовать',
        attachedPhotos: 'Прикрепленные фото',
        labels: 'Лейблы',
        notifyMe: 'Уведомить меня',
        notificationDescription: 'Когда это будет сделано',
        save: 'Сохранить',
        edit: 'Редактировать предложение',
        delete: 'Удалить предложение',
        deletionQuestion: 'Вы действительно хотите удалить это предложение?',
        deletionPhotoQuestion: 'Вы действительно хотите удалить это фото?',
        deletionCommentQuestion:
            'Вы действительно хотите удалить этот комментарий?',
        title: 'Кратко опишите ваше предложение',
        description: 'Опишите ваше предложение более подробно',
        postAnonymously: 'Опубликовать анонимно',
        postFromAdmin: 'Опубликовать от имени администратора',
        suggest: 'Предложить',
        status: 'Статус',
        anonymousAuthorName: 'Аноним',
        adminAuthorName: 'Администратор',
        requests: 'Предложения',
        requestsHeader: 'Актуальные предложения',
        requestsDescription: 'Присоединяйтесь к сообществу',
        inProgress: 'В разработке',
        inProgressHeader: 'Предложения в разработке',
        inProgressDescription: 'Скоро появится в приложении',
        completed: 'Реализовано',
        completedHeader: 'Реализованные предложения',
        completedDescription: 'Было реализовано в приложении',
        duplicated: 'Дубликаты',
        duplicatedHeader: 'Продублированные предложения',
        duplicatedDescription: 'Было предложенно ранее',
        declined: 'Отклонено',
        cancelledHeader: 'Отклонённые предложения',
        cancelledDescription: 'Было отклонено',
        savingImageError: 'Ошибка сохранения фото',
        savingImageSuccess: 'Фото успешно сохранено',
        addPhoto: 'Добавить Фото',
        cancel: 'Отмена',
        done: 'Готово',
        yesDelete: 'Да, удалить',
        commentsTitle: 'Комментарии',
        newComment: 'Новый комментарий',
        commentHint: 'Ваш комментарий…',
        publish: 'Опубликовать',
        add: 'Добавить',
        eventPhotosRestriction: 'Вы можете прикрепить до 10 фото 🖼️',
        sortBy: 'Сортировать по',
        numberOfLikes: 'Количеству лайков',
        creationDate: 'Дате создания',
      );

  factory LocalizationOptions.uk() => const LocalizationOptions(
        'uk',
        suggestion: 'Пропозиція',
        suggestAFeature: 'Запропонувати фічу',
        feature: 'Фіча',
        bug: 'Баг',
        postedBy: 'Опублікував:',
        upvote: 'Проголосувати',
        attachedPhotos: 'Прикріплені фото',
        labels: 'Лейбли',
        notifyMe: 'Повідомити мене',
        notificationDescription: 'Коли це буде зроблено',
        save: 'Зберегти',
        edit: 'Редагувати пропозицію',
        delete: 'Видалити пропозицію',
        deletionQuestion: 'Ви дійсно бажаєте видалити цю пропозицію?',
        deletionPhotoQuestion: 'Ви дійсно бажаєте видалити це фото?',
        deletionCommentQuestion: 'Ви дійсно бажаєте видалити цей коментар?',
        title: 'Коротко опишіть вашу пропозицію',
        description: 'Опишіть вашу пропозицію більш детально',
        postAnonymously: 'Опублікувати анонімно',
        postFromAdmin: 'Опублікувати від імені розробника',
        suggest: 'Запропонувати',
        status: 'Статус',
        anonymousAuthorName: 'Анонім',
        adminAuthorName: 'Адміністратор',
        requests: 'Пропозиції',
        requestsHeader: 'Актуальні пропозиції',
        requestsDescription: 'Приєднуйтесь до спільноти',
        inProgress: 'У розробці',
        inProgressHeader: 'Пропозиції у розробці',
        inProgressDescription: "Незабаром з'явиться у додатку",
        completed: 'Реалізовано',
        completedHeader: 'Реалізовані пропозиції',
        completedDescription: 'Було реалізовано у додатку',
        duplicated: 'Дублікати',
        duplicatedHeader: 'Продубльовані пропозиції',
        duplicatedDescription: 'Було запропоновано раніше',
        declined: 'Відхилено',
        cancelledHeader: 'Відхилені пропозиції',
        cancelledDescription: 'Було відхилено',
        savingImageError: 'Помилка збереження фото',
        savingImageSuccess: 'Фото успішно збережено',
        addPhoto: 'Додати Фото',
        cancel: 'Скасування',
        done: 'Готово',
        yesDelete: 'Так, видалити',
        commentsTitle: 'Коментарі',
        newComment: 'Новий коментар',
        commentHint: 'Ваш коментар…',
        publish: 'Опублікувати',
        add: 'Додати',
        eventPhotosRestriction: 'Ви можете прикріпити до 10 фото 🖼️',
        sortBy: 'Сортувати за',
        numberOfLikes: 'Кількістю лайків',
        creationDate: 'Датою створення',
      );
}
