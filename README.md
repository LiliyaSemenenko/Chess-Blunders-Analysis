# Chess-Blunders-Analysis
Analysis of chess blunders using Poisson Regression model in both R and SAS.

## Introduction
Since September 2022, I became very interested in the game of chess and have been playing it every day since then. In order to improve, I watched many videos of chess games played by people of different levels and made an interesting observation: no matter how strong the player is, they could still make blunder/s during the game. Blundering is one of my biggest issues when playing so I decided to find a dataset related to chess blunders for this project. I found a dataset on Kaggle, which was originally posted on Lichess [1]. The data has predictors (both white and black players' information) and a count response variable (total number of blunders made by white). I decided to use the Poisson regression method for the count response and find which variables are significant predictors of blundering and which are not.

## Background
This project was inspired by a well-known game of chess, which originates at the beginning of the 7th century. It is a popular board game between two players. It is played on a board with 64 squares arranged in an eight-by-eight grid. At the start, each player has sixteen pieces: a king, a queen, two rooks, two bishops, two knights, and eight pawns. The player holding the white pieces goes first, followed by the player holding the black pieces. The goal of the game is to checkmate the opponent's king, so it’s under immediate attack (check) and there is no way out (checkmate). There are also several ways a game can end in a draw [2].
Nowadays, chess is played by around 605 million adults on a regular basis, according to the most used website for online chess Chess.com [3]. Those people who play online may hold an Elo rating, which is used to determine the strength of chess players. One interesting thing here is that no matter what rating a chess player has, everyone still makes mistakes on a board. Sometimes those mistakes are game-changing and making them leads to a complete loss of a game. This kind of mistake is called a blunder. I personally make them every now and then and therefore I dedicated this project to learning which factors determine how many blunders a player makes on average.

## Data Description
The data used in this project was found on Kaggle.com [4] but was originally posted on Lichess [5] database. Kaggle is an open online community for people interested in data science, where users post their data-related projects and datasets. Lichess is a free and open-source Internet chess server, where users may play and analyze their games. The data originally had 1044858 observations and 40 predictor variables. In this analysis, I sampled 93 observations from this data with 6 predictors. The response variable is telling us how many blunders a white player made in a given game. The predictors included are Termination (Time forfeit/Normal/Rules infraction/Abandoned), Increment, Game Type(Bullet/Blitz/Rapid/Classica/Correspondence), Total Moves,  and ELO Category for white and black (Low rating/High rating/GM rating). Since the response variable is counted, it is suggested to test if a Poisson regression model is suitable. 

<p align="center">
  <img width="700" height="400" src="https://github.com/LiliyaSemenenko/Chess-Blunders-Analysis/blob/main/data_sample.jpg">
</p>

<p align="center">
Figure 1: Part of a dataset 
</p>

Inside the dataset, predictors have their meanings and categories:

- **Termination**

  Time forfeit: one of the players ran out of time.
  
  Normal: game terminated with checkmate.
  
  Rules infraction: game was terminated due to rule-breaking.
  
  Abandoned: game was abandoned.

- **Increment**

  An amount of time is added to the player's main time after each move.

- **Game Type**

  Bullet: starting time below 2 minutes.
  
  Blitz: starting time between 2 and 10 minutes.
  
  Rapid: starting time between 10 and 15 minutes.
  
  Classical: starting time above 15 minutes or increment 2 minutes or higher.
  
  Correspondence: no time information.

- **Total Moves**

  A total number of moves in the game.

- **ELO Category**

  Low rating: rating below 1900 points.
  
  High rating: rating above 1900 and below 2400 points.
  
  GM rating: rating above 2400 points.

## Method
Since the response is countable, I decided to use the Poisson regression model for fitting. The method follows the following formulas:

## Results
Both R and SAS codes have similar outputs. Coefficients that are significant at the 5% level are termination by time forfeit, black player with a high rating, bullet game type, and the total number of moves. 

$$
\text{The fitted model rate} = e^{(0.296639 + 0.487098 \cdot \text{{termination by time forfeit}} - 0.108995 \cdot \text{{white player with high rating}} - 0.672123 \cdot \text{{black player with high rating}} - 0.007350 \cdot \text{{increment}} - 0.204080 \cdot \text{{blitz game}} - 0.583696 \cdot \text{{bullet game}} - 0.682544 \cdot \text{{classical game}} + 0.008025 \cdot \text{{total number of moves}})}
$$

The estimated average number of blunders made by white when a game termination by time forfeit is 162.76% of that for abandoned games. When white plays against an opponent with a high rating, the estimated mean number of blunders made by white is 51.06% of that when its opponent has a low rating. If white decides to play a bullet game, the estimated average number of blunders they make is 55.78% of that for a rapid game. As the total number of moves increases by one, the estimated average number of blunders made by white increases by 0.81%. 
Based on the deviance test, we can conclude that the Poisson model is a good fit due to the p-value being 4.875617e-05, which is less than 0.05.                                          
When I tried to predict the number of blunders made by white given that the player has a low rating (below 1900), plays a rapid game (between 10 and 15 minutes) against an opponent with a high rating (between 1900 and 2400) who plays black, with 0-time increment, 40 total number of moves and the game terminated with checkmate, both R and SAS outputted 0.946971 using fitted Poisson prediction.

## Predict number of blunders given predictor values

Predict the number of blunders made by white given that the player  has a low rating (below 1900), plays a Rapid game (between 10 and 15 minutes) gainst an opponent with high rating (between 1900 and 2400) who plays black, with 0 time increment, 40 total number of moves, and the game terminated with checkmate.

- Using fitted model for prediction
  ```
  prediction = predict(fitted.model, type="response", data.frame(Termination.rel="Normal", White_cat.rel="Low rating", 
  Black_cat.rel="High rating", increment=0, Game_type.rel="Rapid", Total_moves=40))
  print(prediction)

  Output: 0.946971
  ```

- Calculate same y0 manually
  ```
  y0 = exp(0.296639 - 0.672123 + 0.008025*40)
  print(y0)

  Output: 0.9469737
  ```

## Conclusion
In conclusion, the fitting of the model resulted in 4 significant predictors termination by time forfeit, the black player with a high rating, bullet game type, and the total number of moves. The deviance test analysis shows that the Poisson regression method fits the data nicely. Now, we can exclude white Elo rating, increment, blitz, and classical game types from the model as their p-value is greater than 0.05. Overall, with the dataset and model, I was able to answer my objective questions and obtain informative results. This project taught me how methods learned in STAT 410 class could be applied to answer real-life questions.

## References
[1] Lichess.org, https://lichess.org/.<br>
[2] “Chess.” Wikipedia, Wikimedia Foundation, 11 Dec. 2022, https://en.wikipedia.org/wiki/Chess.<br>
[3] Emmett, Ryan. “How Popular Is Chess?” Chess.com, Chess.com, 9 Mar. 2020, https://www.chess.com/news/view/how-popular-is-chess-8306.<br>
[4] Noobiedatascientist. “Analysis of Lichess Games.” Kaggle, Kaggle, 23 Dec. 2021, https://www.kaggle.com/code/noobiedatascientist/analysis-of-lichess-games/data?select=Sept_20_analysis.csv.<br>
[5] “Lichess.org Open Database.” Lichess.org Open Database, https://database.lichess.org/. <br>
