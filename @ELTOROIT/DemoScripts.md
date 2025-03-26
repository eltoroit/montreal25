# Basic Agentforce

1. Setup > Agents
2. Create agent
3. Remove every topics

    | Field       | Value                                                                                                                |
    | ----------- | -------------------------------------------------------------------------------------------------------------------- |
    | Name        | First Agent                                                                                                          |
    | Description | This agent will help learn how to build agents in Salesforce's Agentforce by playing 2 person games                  |
    | Role        | You are one of the players in a 2 person game and your participation in these games will help learn about Agentforce |
    | Company     | ELTOROit is not a company but he know how to build good demos 😳                                                     |
    | User        | <New User>                                                                                                           |

4. A brand new empty agent has been created

# Fun Demo

0. Back to slides
1. Create a new topic

    | Field                      | Value                                                                                      |
    | -------------------------- | ------------------------------------------------------------------------------------------ |
    | Topic Label                | Geography Game                                                                             |
    | Classification Description | Allows the user to play a geography game                                                   |
    | Scope                      | Agent will not have access to data, this is just a game that will be played with the user. |
    | Instruction                | - Ask the user an easy geography question and validate the answer provided.                |

This topic is for engaging users in a geography-based game where they can answer questions about different geographical locations and features.
**Bad description**: Play a game that plays a game where the player of the game plays a game, and the player of that game can play a game to win or to lose like in any game there is a game and players some win and some loose. A player wins or loses in a game that allows players to play a game to win or lose in such a game.
**Fixed Description**: Engage in a geography game where players answer geography questions to earn points. The goal is to test and improve geographical knowledge through a fun and competitive format.
**Fixed Scope**: Play a geography game where the player answers geography questions. The player earns points for correct answers. The Agent should only provide questions, keep score, and declare winners or losers based on points earned.

2. No actions
3. Refresh conversation
4. `Play a game`

5. Add this instruction:
    1. `- Do not ask the user if he wants to play, just keep asking questions until the user types STOP`
6. `Play a game`

7. Add this instruction:
    1. `- Explain how to play this game`
8. `Play a game`

9. Add these instruction:
    1. `- Keep count of how many questions you have asked and how many the user has gotten correct.`
    2. `- When the game is over, show the score including how many questions were asked and how many were answered correctly.`
10. `Play a game`

Agent starts breaking, because it's trying to handle too much

11. Show the Prompt Template
12. Preview with this question

    1.  `Which continent is the Sahara Desert located on?`
    2.  `Africa`

13. Show the Agent action
14. Add action to agent
15. Update instructions
    1.  `- Ask the user a simple geography question and call action `GAME: Validate Geography question` to validate the answer provided.`
    2.  `- If the user's answer is wrong, then give the correct answer and move to the next question.`
16. `Play a game`
17. x
