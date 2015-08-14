# hangman-game

My take on the classic Hangman game.

Features: 

- This game chooses a random 5 to 12 letter word from over 47,000 words in the english language.
- The player is given 10 attempts at guessing what the secret word is. If they do, they are congratulated. If they dont, the game will let them know what the word was.
- Load and Save feature! Players may choose to save their current game at any time and resume when they get back.

Other features we can include:

- When they type in a correct letter that has already been typed in, nothing happens (no penalty or reward). This behavior is fine, but we need to check when that happens and let the user know that.
- If a user attempts a letter they have already done, don't penalize them and let them know instead.

More player choice:

- An option for the player to give in their own list of words for the game, rather than using our own list.
- Letting the player choose the range of letters for the secret word instead of 5 to 12.
- Letting the player choose how many tries they receive instead of 1.