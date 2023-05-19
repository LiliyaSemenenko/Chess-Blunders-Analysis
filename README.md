# Chess-Blunders-Analysis
Analysis of chess blunders using Poisson Regression model in both R and SAS.

## Introduction
Since September 2022, I became very interested in the game of chess and have been playing it every day since then. In order to improve, I watched many videos of chess games played by people of different levels and made an interesting observation: no matter how strong the player is, they could still make blunder/s during the game. Blundering is one of my biggest issues when playing so I decided to find a dataset related to chess blunders for this project. I found a dataset on Kaggle, which was originally posted on Lichess [1]. The data has predictors (both white and black players' information) and a count response variable (total number of blunders made by white). I decided to use the Poisson regression method for the count response and find which variables are significant predictors of blundering and which are not.

## Background
This project was inspired by a well-known game of chess, which originates at the beginning of the 7th century. It is a popular board game between two players. It is played on a board with 64 squares arranged in an eight-by-eight grid. At the start, each player has sixteen pieces: a king, a queen, two rooks, two bishops, two knights, and eight pawns. The player holding the white pieces goes first, followed by the player holding the black pieces. The goal of the game is to checkmate the opponent's king, so it’s under immediate attack (check) and there is no way out (checkmate). There are also several ways a game can end in a draw [2].
Nowadays, chess is played by around 605 million adults on a regular basis, according to the most used website for online chess Chess.com [3]. Those people who play online may hold an Elo rating, which is used to determine the strength of chess players. One interesting thing here is that no matter what rating a chess player has, everyone still makes mistakes on a board. Sometimes those mistakes are game-changing and making them leads to a complete loss of a game. This kind of mistake is called a blunder. I personally make them every now and then and therefore I dedicated this project to learning which factors determine how many blunders a player makes on average.

## Data Description
The data used in this project was found on Kaggle.com [4] but was originally posted on Lichess [5] database. Kaggle is an open online community for people interested in data science, where users post their data-related projects and datasets. Lichess is a free and open-source Internet chess server, where users may play and analyze their games. The data originally had 1044858 observations and 40 predictor variables. In this analysis, I sampled 93 observations from this data with 6 predictors. The response variable is telling us how many blunders a white player made in a given game. The predictors included are Termination (Time forfeit/Normal/Rules infraction/Abandoned), Increment, Game Type(Bullet/Blitz/Rapid/Classica/Correspondence), Total Moves,  and ELO Category for white and black (Low rating/High rating/GM rating). Since the response variable is counted, it is suggested to test if a Poisson regression model is suitable. 



Figure 1: Part of a dataset 

Inside the dataset, predictors have their meanings and categories:

- Termination
Time forfeit -- One of the players ran out of time.
Normal -- Game terminated with checkmate.
Rules infraction -- Game was terminated due to rule-breaking.
Abandoned -- Game was abandoned.

- Increment
An amount of time is added to the player's main time after each move.

- Game Type
Bullet -- Starting time below 2 minutes.
Blitz -- Starting time between 2 and 10 minutes.
Rapid -- Starting time between 10 and 15 minutes.
Classical -- Starting time above 15 minutes or increment 2 minutes or higher.
Correspondence -- No time information.

- Total Moves
A total number of moves in the game.

- ELO Category
Low rating -- Rating below 1900.
High rating -- Rating above 1900 and below 2400.
GM rating -- Rating above 2400.


___________________________________________________________________

## Introduction

Liliya_Bot is a chess engine fully written in Python that utilizes:

- [minimax](https://en.wikipedia.org/wiki/Minimax) algorithm for move searching the best legal moves. The time complexity: O(b^d), where b is the number of legal moves at each point and d is the maximum depth of the tree;
- [alpha-beta pruning](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning), a simplified and much faster version of the minimax algorithm. Best-case time complexity: O(b^d/2).
- simple evaluation function and an alternative incremental board evaluation. Both evaluation options include piece-square tables;
- [move ordering](https://www.chessprogramming.org/Move_Ordering) based on heuristics like captures, positions on the board, and promotions;
- a [Universal Chess Interface](http://wbec-ridderkerk.nl/html/UCIProtocol.html) to communicate with lichess.org and other GUI of your preference. Liliya_Bot is registered on [lichess](https://lichess.org/@/Liliya_Bot)!
- a command-line user interface.

# Play against Liliya-Bot!
## Use it via command-line

The simplest way to run Liliya_Bot is through the terminal interface:

`python main.py`

<pre>
_________________________
White  to move

Enter current & destination square or resign: e2e4

evaluation:  40 

8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 
7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 
6 ☐ ☐ ☐ ☐ ☐ ☐ ☐ ☐ 
5 ☐ ☐ ☐ ☐ ☐ ☐ ☐ ☐ 
4 ☐ ☐ ☐ ☐ ♙ ☐ ☐ ☐ 
3 ☐ ☐ ☐ ☐ ☐ ☐ ☐ ☐ 
2 ♙ ♙ ♙ ♙ ☐ ♙ ♙ ♙ 
1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 
  a  b  c  d  e  f  g  h

Total number of moves:  1 
_________________________
Black  to move

chosen move: g8f6 

evaluation:  -10 

8 ♜ ♞ ♝ ♛ ♚ ♝ ☐ ♜ 
7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 
6 ☐ ☐ ☐ ☐ ☐ ♞ ☐ ☐ 
5 ☐ ☐ ☐ ☐ ☐ ☐ ☐ ☐ 
4 ☐ ☐ ☐ ☐ ♙ ☐ ☐ ☐ 
3 ☐ ☐ ☐ ☐ ☐ ☐ ☐ ☐ 
2 ♙ ♙ ♙ ♙ ☐ ♙ ♙ ♙ 
1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 
  a  b  c  d  e  f  g  h

Total number of moves:  2 
_________________________
</pre>

## Use it as a UCI engine

`python uci.py`

This is how the communication between the engine and GUI can look like (responses have '#'):

```
uci
# id name Liliya-Bot
# id author Liliya
# uciok
isready
# readyok
ucinewgame
position startpos moves e2e4
go
# bestmove g8f6
b1c3
# bestmove b8c6 
```
To quit the game, type `quit`

Note: Liliya_Bot does not accept a FEN string.

<br>

See the [UCI interface doc](https://www.wbec-ridderkerk.nl/html/UCIProtocol.html) for more information on communicating with the engine.

## Connect it to Lichess.org

To play Liliya_Bot on lichess.org, you'll need to use a tool [ShailChoksi/lichess-bot](https://github.com/ShailChoksi/lichess-bot), which acts as a bridge between the Lichess API and chess engines. Additionally, you'll need a BOT account. To use this tool, you'll also need to generate an engine executable file using [pyinstaller](https://www.pyinstaller.org/).

# Tests

To test the engine's performance, an average time engine has used to choose the best move and an evaluation plot are printed after every game. A positive evaluation score means white is winning, negative means black is winning, and 0 is a draw.

Output example where white was clearly winning:

`Average engine time per move:  0.209038734436035` 

![game eval](https://github.com/LiliyaSemenenko/Chess_Engine/blob/master/plots/evalplot.png)

In addition, `python test.py` could be used to run n number of games and test their result and the number of moves it took Liliya_Bot to win. It will also record the number of games, which failed to run till the end due to a bug.

An experiment involving a compilation of 100 games at depth 3, where the engine operated as the white player against a random black player (random mode uses no heuristics and picks any legal move available), was carried out. The outcomes are illustrated in the plots displayed below:
![100 games reslut](https://github.com/LiliyaSemenenko/Chess_Engine/blob/master/plots/testBar_depth_3.png)
![100 games distribution](https://github.com/LiliyaSemenenko/Chess_Engine/blob/master/plots/testHist_depth_3.png)

`Failed games: 0`

# Limitations

Liliya_Bot supports all chess rules, except:

- threefold repetition rule
- fifty-move rule
- fivefold repetition
- seventy-five-move rule
- draw by mutual agreement
- en passant capture

# Contribution

If you would like to contribute by proposing a bug fix or a new feature, please raise an issue. You can also choose to work on an existing issue. If you need any help along the way, feel free to reach out to ([@LiliyaSemenenko](https://github.com/LiliyaSemenenko)).


