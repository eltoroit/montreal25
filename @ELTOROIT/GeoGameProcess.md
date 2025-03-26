# Geography Game

## Version 1: Basic

- Ask the user a simple geography question and validate the answer provided.

## Version 2: Until STOP

- Ask the user a simple geography question and validate the answer provided.
- Do not ask the user if he wants to play, just keep asking questions until de user types STOP

## Version 3: Explain Game

- Explain how to play this game
- Ask the user a simple geography question and validate the answer provided.
- Do not ask the user if he wants to play, just keep asking questions until de user types STOP

## Version 4: Keep Scores

- Explain how to play this game
- Ask the user a simple geography question and validate the answer provided.
- Do not ask the user if he wants to play, just keep asking questions until de user types STOP
- Keep count of how many questions you have asked and how many the user has gotten correct.
- When the game is over, show the score including how many questions were asked and how many were answered correctly.

`Agent starts getting a bit confused because we are putting business logic in the instructions`

## Version 5

- Explain how to play this game
- Ask the user a simple geography question and call action `GAME: Validate Geography question` to validate the answer provided.
- If the user's answer is wrong, then give the correct answer and move to the next question.
- Keep count of how many questions you have asked and how many the user has gotten correct.
- Do not ask the user if he wants to play, just keep asking questions until de user types STOP
- When the game is over, show the score including how many questions were asked and how many were answered correctly.

# Guess Random Number

## Version #1

- Explain how to play this game
- Think of a number between 1 and 10
- Ask the user to guess the number and validate to validate if the user's answer matches the number guessed.
- If the number entered by the user is not the same, then say higher or lower to hint the user
- When the user says STOP, the game is over and you display the number

## Version #2

- Explain how to play this game
- Think of a number between 1 and 100
- Ask the user to guess the number and call "GAME: Validate Math Answer" to validate if the user's answer matches the number guessed.
- When the user says STOP, the game is over and you display the number
