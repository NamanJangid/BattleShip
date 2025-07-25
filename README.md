# CS 442 MP5: Battleships

## 1. Overview

For this machine problem, your task is to implement an application that interfaces with an existing RESTful service to allow users to register, log in, and play games of [Battleships](https://en.wikipedia.org/wiki/Battleship_(game)) against both human and computer opponents.

The primary objective of this MP is to provide you with an opportunity to integrate a prototypical RESTful API into a Flutter application. To do this, you will need to study the provided REST API documentation and use asynchronous operations provided by the `http` package to communicate with the API.

## 2. Specifications

You can view a demo of a running application that fulfills the requirements of this MP at <https://youtu.be/0oMGXxXpp04?si=ZaUBT2EZMU6Zrxif>.

This section starts with a feature overview, and is followed by detailed behavioral specifications your application should conform to.

### 2.1. Feature overview

Here are the high-level features that the final application should support:

1. Logging in and registering new users
2. Keeping track of session tokens across application restarts, and requiring users to log in again after their session tokens expire.
3. Listing ongoing and completed games of Battleships played by the user.
4. Playing games of Battleships against human and computer opponents.

### 2.2. Behavioral specifications

#### 2.2.1. Login and Registration

The login screen allows the user to enter their username and password, and to log in to the application. If the user does not have an account, they may also register for a new account from this screen. After logging in or registering, the session token returned by the server should be stored locally and used to authenticate all subsequent requests to the server. If the session token expires, the user should be required to log in again.

#### 2.2.2. Game List

The game list page displays, by default, a list of all games that are either in the matchmaking or active state. A manual refresh button should be provided to allow the user to refresh the list of games. Each game in the list should display the following information:

- The game ID
- The usernames of the two players, if the game has already started
- The current game status (matchmaking, lost, won, user's turn, opponent's turn)

The game list page should also provide access to a menu that has the following options:

1. Start a new game with a human opponent
2. Start a new game with an AI opponent
3. Show completed games (this should be a toggled option that switches between showing active and completed games)
4. Log out

Both completed and active game items in the list should be tappable, and should take the user to the game view page, which displays the game board and allows the user to play the game if it is their turn.

Active games and games in the matchmaking phase may also be deleted, which will automatically forfeit them on the server. The deletion mechanism is up to you (e.g., dedicated button or swipe-to-delete).

#### 2.2.3. New Game

When starting a new game, the user should be prompted to place their ships on the board. In our version of Battleships, the game board is 5x5 tiles in dimension, and each ship occupies a single tile. To start a game, the user must place 5 separate ships on the board.

The visual representation of the board is ultimately up to you, but the row labels (the letters `A` through `E`) and column labels (the numbers 1 through 5) must be used to label a visible grid. The user should be able to place ships by tapping on the board, and should be able to remove ships by tapping on them again. The user should not be able to place ships on top of each other, and should not be able to place ships outside of the board. The user should be able to start the game once they have placed 5 ships on the board. This will submit the ships to the server.

After submitting their ships to start a game, the user should be returned to the game list page, which should now show the new game in the list of active games retrieved from the server.

#### 2.2.4. Playing a Game

The game view page should display the game board, and should allow the user to play the game if it is their turn. The game board should visually display the following information:

- the locations of the user's ships
- the locations of the user's ships that have been hit by the opponent
- the locations of the user's shots that missed
- the locations of the user's shots that hit an enemy ship

You may choose to display this information in any way you like, but the user should be able to clearly distinguish between the different types of information.

If it is the user's turn, the user should be able to play a shot by tapping on the board to select a location, and submitting it to the server with another button/action. If the shot hits an enemy ship, the user should be able to see the location of the ship that was hit. If the shot misses, the user should be able to see the location of the shot that missed. If the shot wins the game for the user, the user should be notified that they have won the game.

In a human vs. human game, after playing a shot the user will not be able to play again until after the opponent has played. This may require the user to return to the game list page and refresh the list of games to see the updated game status before tapping on the game again.

In a human vs. AI game, so long as the user does not win the game, the AI will immediately update the game state with a follow-up shot after the user plays a shot. The application should fetch the updated game state and allow the user to play again.

#### 2.2.5. Responsiveness

Your app should be responsive to changes in screen size. In particular, the entire 5x5 board grid should be scaled up to take advantage of all screen sizes, and it should not be cropped or clipped. On larger screens, you may wish to display the game list and game play views side-by-side, but this is not a requirement.

## 3. Implementation requirements

This section provides implementation-level requirements for your application.

### 3.1. External packages

We have included the following packages in the `pubspec.yaml` file:

- [`http`](https://pub.dev/packages/http): a library that provides a set of high-level asynchronous functions for communicating with HTTP servers
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): a library that provides a persistent store for simple data
- [`provider`](https://pub.dev/packages/provider): a library that provides a set of utilities for managing and disseminating stateful data

Do not add any additional packages to your `pubspec.yaml` file without first consulting with us.

### 3.2. Code structure and organization

While the specific widget breakdown is up to you, we ask that you modularize your UI code so that it is easy to read and understand. At a minimum, you should define a separate widget for each of the pages described above, though it may make sense to further modularize your code into smaller widgets (e.g., a widget representing a single deck or card).

Your implementation should not make use of any global variables or functions. All data should be encapsulated in your model classes, and you should use some combination of the state management techniques discussed in class.

Major widget classes should live in their own files in the "lib/views" directory. Model classes should live in their own files in the "lib/models" directory. Helper classes should live in their own files in the "lib/utils" directory. You may create additional directories as needed.

### 3.3. Managing asynchronous operations

Your app should not cause the UI to block while performing any asynchronous operations. This includes database operations, which should be performed asynchronously. You may use `FutureProvider`, `FutureBuilder`, or `StreamBuilder` to manage asynchronous operations, and should display a loading indicator while lengthy operations are in progress.

## 4. Battleships REST API

The Battleships REST API service can be reached at the base-URL `http://165.227.117.48` (note, this is not a secure connection, so don't use passwords that you're worried about being compromised!). **Do not implement your own server for this MP -- your application should only interact with our running server.**

The `test.http` file in your repository contains a set of sample requests that you can use to test your application or better understand the API. You can use the [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension for Visual Studio Code to run these requests.

The full API is documented below -- all routes that require body content only accept JSON data, and all responses are JSON objects. Route names are prefixed with the corresponding HTTP method.

### 4.1. Authentication

- `POST base-URL/register`: Registers a new user. The JSON request body should contain the following fields:
  - `username`: The username of the new user.
  - `password`: The password of the new user.

  Both username and password must be at least 3 characters long and cannot contain spaces. If the username is not already taken, the server will respond with a JSON object containing the following fields:

  - `message`: A message indicating that the user was successfully created.
  - `access_token`: A string containing the user's access token. This token should be included in subsequent requests to API calls that require it. Tokens expire after 1 hour, and must be refreshed by logging in again.

- `POST base-URL/login`: Logs in an existing user. The JSON request body should contain the following fields:
  - `username`: The username of the user to log in.
  - `password`: The password of the user to log in.

  If the username and password are correct, the server will respond with a JSON object containing the following fields:

  - `message`: A message indicating that the user was successfully logged in.
  - `access_token`: A string containing the user's access token. This token should be included in subsequent requests to API calls that require it. Tokens expire after 1 hour, and must be refreshed by logging in again.

### 4.2. Managing Games

For all the routes in this section, the HTTP request header should contain the field named "`Authorization`", with the value "`Bearer <access_token>`", where `<access_token>` is the access token returned by the server when the user logged in. If the access token is missing or invalid, the server will respond with a `401 Unauthorized` error, which means that a new token must be obtained by logging in again.

All successful operations will result in an HTTP status code of `200`.

- `GET base-URL/games`: Retrieves all games (active and completed) for one user.

  - The server will respond with a JSON object containing the field `games`, whose value is a list of JSON objects representing the games. Each game object contains the following fields:

    - `id`: The unique ID of the game.
    - `player1`: The username of the player in position 1.
    - `player2`: The username of the player in position 2.
    - `position`: The position of the user in the game (either `1` or `2`).
    - `status`: The status of the game, which can be one of the following values:
      - `0`: The game is in the matchmaking phase.
      - `1`: The game has been won by player 1.
      - `2`: The game has been won by player 2.
      - `3`: The game is actively being played.
    - `turn`: If the game is active, then the position of the player whose turn it is (either `1` or `2`); if the game is not active, `0`.
  
- `POST base-URL/games`: Starts a game with the provided ships. The JSON request body should contain the following fields:

  - `ships`: a list of 5 unique ship locations, each of which is a string of the form "`<row><col>`", where `<row>` is a letter between `A` and `E` and `<col>` is a number between `1` and `5`. For example, the string "`A1`" represents the top-left corner of the board, and the string "`E5`" represents the bottom-right corner of the board.
  - `ai`: (optional) one of the strings "`random`", "`perfect`", or "`oneship`", which select an AI opponent to play. If omitted, the server will match the user with another human player.
  - e.g., some sample request bodies:
    - `{ "ships": ["A1", "A2", "A3", "A4", "A5"] }`
    - `{ "ships": ["B1", "A2", "D3", "C4", "E5"], "ai": "random" }`

  If the request is successful, the server will respond with a JSON object containing the following fields:

  - `id`: the unique ID of the game
  - `player`: the position of the user in the game (either `1` or `2`)
  - `matched`: `True` if the user was matched with another human player, or if the game is against an AI opponent; `False` if the game is waiting for a human opponent.

- `GET base-URL/games/<game_id>`: Gets detailed information about a game with the integer id `<game_id>`. The server will respond with a JSON object containing the following fields:

  - `id`: The unique ID of the game.
  - `status`: The status of the game, which can be one of the following values:
    - `0`: The game is in the matchmaking phase.
    - `1`: The game has been won by player 1.
    - `2`: The game has been won by player 2.
    - `3`: The game is actively being played.
  - `position`: The position of the user in the game (either `1` or `2`).
  - `turn`: If the game is active, then the position of the player whose turn it is (either `1` or `2`); if the game is not active, `0`.
  - `player1`: The username of the player in position 1.
  - `player2`: The username of the player in position 2.
  - `ships`: a list of coordinates of remaining ships (of the form `A1`, `E5`, etc.) belonging to the user
  - `wrecks`: a list of coordinates of wrecked ships belonging to the user
  - `shots`: a list of shot coordinates previously played by the user, excluding those that successfully hit a ship
  - `sunk`: a list of shot coordinates previously played by the user that hit an enemy ship

- `PUT base-URL/games/<game_id>`: Plays a shot in the game with the integer id `<game_id>`. The JSON request body should contain the following field:

  - `shot`: a string of the form "`<row><col>`", where `<row>` is a letter between `A` and `E` and `<col>` is a number between `1` and `5`.

  If the request is successful, the server will respond with a JSON object containing the following fields:

  - `message`: a message indicating that the shot was played successfully
  - `sunk_ship`: `True` if the shot hit an enemy ship, `False` otherwise.
  - `won`: `True` if the shot won the game for the user, `False` otherwise.

- `DELETE base-URL/games/<game_id>`: Cancels/Forfeits the game with the integer id `<game_id>`. Note that only games which are currently in the matchmaking or active states can be canceled/forfeited. The server will respond with a JSON object containing the following field:

  - `message`: a message indicating that the game was successfully canceled or forfeited.

## 5. Testing

In your `REPORT.md` file, please indicate which of the listed platforms you have tested your app on. We will test your application by building and running it in one of your selected platforms, and manually verifying that it meets the requirements outlined above.
