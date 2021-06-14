# notes-app
Simple Flutter notes app created by João Martins

## Requirements
- Flutter 2.0.0+
- Dart 2.12.0+

## Task
Given task was to prepare a basic notes app using Flutter and SQFLite framework.

Application uses local database to fetch data and display notes.

User can add and display detailed notes where he can then edit or delete them.

If an error occurs while fetching the data, user can retry the request.


Application supports only portrait mode. To make it more comfortable for the user, all the other orientations were blocked.

If there was a real need for supporting the landscape mode as well, then an OrientationBuilder with a separate content layout would be used.

## Approach
For the state management I used BLoC implemented with flutter_bloc package. There are two main blocs in the application:

 - notes_bloc - responsible for acquiring notes data from the database

 - note_details_bloc - responsible for handling selected notes

 - add_note_bloc - responsible for adding new notes


Tests were optional so I decided not to add tests, however the code should be easily testable.


