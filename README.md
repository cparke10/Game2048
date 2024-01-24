This application is a simplified version of the 2048 game built in SwiftUI for educational purposes. It also supports simple login and leaderboard functionality.

Source: https://en.wikipedia.org/wiki/2048_(video_game)

Game Set:

1. Initial game logic will draw a 4x4 tile grid with two randomly spawned tiles.
2. Users can swipe in four directions to collapse the board, where a collapse is:
   1. Combining of two equal-valued tiles, like 8 and 8. Collapses will only combine tiles in the direction of the swipe.
   2. Movement of tiles towards the swipe direction, where 0-valued tiles are ignored.
3. When a collapse is completed, the collapsed tiles will increment as a power of 2, e.g., combining two 8 tiles will result in a new single tile valued at 16.
4. When the user has no available collapses left, the game is over.

The game tracks the current user score and displays it to the user. Score is incremented whenever a succesful tile combine occurs at the value of the new tile. When the user combines two 1024 tiles to create a 2048, the game can be considered over. This is not an endgame state; the game will continue along the game logic. Leaderboard functionality is added both for the user and globally.
