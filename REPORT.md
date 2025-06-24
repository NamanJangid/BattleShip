# MP Report

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] Users can register and log in to the server via the app
- [X] Session management works correctly; i.e., the user stays logged in after closing and reopening the app, and token expiration necessitates re-login
- [X] The game list displays required information accurately (for both active and completed games), and can be manually refreshed
- [X] A game can be started correctly (by placing ships, and sending an appropriate request to the server)
- [X] The game board is responsive to changes in screen size
- [X] Games can be started with human and all supported AI opponents
- [X] Gameplay works correctly (including ship placement, attacking, and game completion)

## Summary and Reflection

In this implementation, I really focused on creating a clean and modular structure for the Battleships app. The goal was to make sure the app could scale well and remain easy to work with in the future. I separated the different parts of the app into models, views, and utils, which helped keep things organized and maintainable. The ApiService class became the central point for all API interactions, making it much easier to update server-side logic when needed. For authentication, I used a simple username and password flow, with token-based authentication to secure the communication between the app and the server.

I really enjoyed working with the REST APIs for this project. It felt great to have such a structured way to interact with the backend and manage the game’s data. Watching everything come together and seeing how the API integration brought the app to life was definitely one of the most rewarding parts. That said, I did run into a few challenges along the way. For example, keeping the session active across app restarts and handling token expiration was trickier than I expected. It required careful management of shared preferences, state persistence, and some solid error handling to make sure the user experience remained smooth. Looking back, I wish I had spent more time learning about efficient state management practices in Flutter before diving in. I think that would have made the whole process a lot smoother and helped me avoid some of the struggles I ran into later on.
