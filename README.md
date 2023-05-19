# Chess-Blunders-Analysis
Analysis of chess blunders using the Poisson Regression model in both R and SAS.

## Introduction
Since September 2022, my passion for chess has grown immensely, leading me to play the game daily. Seeking improvement, I immersed myself in analyzing chess games at various skill levels. Through this exploration, I made a fascinating observation: regardless of players' strength, they can still make blunders during a game. As blundering remains a challenge for me, I embarked on a project to explore a dataset related to chess blunders. This dataset, sourced from Kaggle and originally posted on Lichess [1], provides predictors for both white and black players, alongside a response variable indicating the total number of blunders made by white. To identify significant predictors of blunders, I employed the Poisson regression method.

## Background
This project explores the occurrence of blunders in the game of chess. Chess, a renowned board game dating back to the 7th century, involves two players competing on a 64-square board arranged in an eight-by-eight grid. Each player begins with sixteen pieces, including a king, queen, rooks, bishops, knights, and pawns. The game commences with the player controlling the white pieces, followed by the player controlling the black pieces. The objective is to checkmate the opponent's king, rendering it under immediate attack (check) with no escape (checkmate). Additionally, there are various ways a game can end in a draw [2].

In today's era, chess enjoys widespread popularity, with approximately 605 million adults engaging in regular play, according to Chess.com [3], a leading online chess platform. Online players often possess an Elo rating, which quantifies their skill level. Interestingly, regardless of a player's rating, mistakes are commonplace during a game. These mistakes, known as blunders, can be game-changing and lead to a complete loss. This project delves into understanding the factors influencing the average number of blunders made by players.

## Data Description
The data used in this project was found on Kaggle.com [4] but was originally posted on Lichess [5] database. Kaggle is an open online community for people interested in data science, where users post their data-related projects and datasets. Lichess is a free and open-source Internet chess server, where users may play and analyze their games. The data originally had 1044858 observations and 40 predictor variables. In this analysis, I sampled 93 observations from this data with 6 predictors. The response variable is telling us how many blunders a white player made in a given game. The predictors included are Termination, Increment, Game Type, Total Moves, and ELO Category for white and black.

<p align="center">
  <img width="700" height="400" src="https://github.com/LiliyaSemenenko/Chess-Blunders-Analysis/blob/main/data_sample.jpg">
</p>

<p align="center">
Figure 1: Part of a dataset 
</p>

Inside the dataset, predictors have their meanings and categories:

- **Termination**

  - Time forfeit: one of the players ran out of time.
  
  - Normal: game terminated with checkmate.
  
  - Rules infraction: the game was terminated due to rule-breaking.
  
  - Abandoned: the game was abandoned.

- **Increment**

  - An amount of time is added to the player's main time after each move.

- **Game Type**

  - Bullet: starting time below 2 minutes.
  
  - Blitz: starting time between 2 and 10 minutes.
  
  - Rapid: starting time between 10 and 15 minutes.
  
  - Classical: starting time above 15 minutes or increment 2 minutes or higher.
  
  - Correspondence: no time information.

- **Total Moves**

  - A total number of moves in the game.

- **ELO Category**

  - Low rating: rating below 1900 points.
  
  - High rating: rating above 1900 and below 2400 points.
  
  - GM rating: rating above 2400 points.

## Method
Since the response is countable, I decided to use the Poisson regression model for fitting. The method follows the following formulas:

- ***Probability mass function***

  $\mathbb{P}(Y=y)=\frac{\lambda^{y} e^{-\lambda\}}{y !}, \quad y=0,1,2, \ldots$

- ***Rate***

  $\lambda = \mathbb{E}(y) = e^{ \beta_{0} + \beta_{1} x_{1} + \cdots + \beta_{k} x_{k} \}$

- ***Fitted Model***

  $\widehat{\lambda} = e^{\widehat{\beta}\_{0} + \widehat{\beta}\_{1} x_{1} + \cdots + \widehat{\beta}\_{k} x_{k}}$

- ***Predicted Response***

   $y^{0}= e^{\widehat{\beta}\_{0}+\widehat{\beta}\_{1} x_{1}^{0}+\cdots+\widehat{\beta}\_{k} x_{k}^{0}}$

## Tests

In order to check the model's fit, the program ran a deviance test, which was then used to obtain a p-value. A p-value that is less than 0.05 means that the regression coefficient β is a significant predictor of the response variable at the 5% level of significance.

Based on the deviance test conducted in both R and SAS, we can conclude that the Poisson model is a good fit due to the p-value being 4.875617e-05, which is less than 0.05.   

## Results
Both R and SAS codes have similar outputs. Coefficients that are significant at the 5% level are termination by time forfeit, black player with a high rating, bullet game type, and the total number of moves. 

$$
\text{The fitted model rate} = exp(0.296639 + 0.487098 \cdot \text{{termination by time forfeit}} - 0.108995 \cdot \text{{white player with high rating}} -
$$

$$
0.672123 \cdot \text{{black player with high rating}} - 0.007350 \cdot \text{{increment}} - 0.204080 \cdot \text{{blitz game}} - 0.583696 \cdot \text{{bullet game}} - 
$$

$$
0.682544 \cdot \text{{classical game}} + 0.008025 \cdot \text{{total number of moves}})
$$

**Interpretation of significant coefficients:**

The estimated average number of blunders made by white when a game termination by time forfeit is 162.76% of that for abandoned games. When white plays against an opponent with a high rating, the estimated mean number of blunders made by white is 51.06% of that when its opponent has a low rating. If white decides to play a bullet game, the estimated average number of blunders they make is 55.78% of that for a rapid game. As the total number of moves increases by one, the estimated average number of blunders made by white increases by 0.81%. 

## Predict number of blunders given predictor values

Predict the number of blunders made by white given that the player has a low rating (below 1900), plays a Rapid game (between 10 and 15 minutes) against an opponent with a high rating (between 1900 and 2400) who plays black, with 0 time increment, 40 total number of moves, and the game terminated with checkmate.

- Using a fitted model for prediction in R
  ```
  prediction = predict(fitted.model, type="response", data.frame(Termination.rel="Normal", White_cat.rel="Low rating", 
  Black_cat.rel="High rating", increment=0, Game_type.rel="Rapid", Total_moves=40))
  print(prediction)

  Output: 0.946971
  ```

- Calculate the same y0 (number of blunders) manually in R
  ```
  y0 = exp(0.296639 - 0.672123 + 0.008025*40)
  print(y0)

  Output: 0.9469737
  ```

## Conclusion
In conclusion, the fitting of the model resulted in 4 significant predictors termination by time forfeit, the black player with a high rating, bullet game type, and the total number of moves. The deviance test analysis shows that the Poisson regression method fits the data nicely. Now, we can exclude white Elo rating, increment, blitz, and classical game types from the model as their p-value is greater than 0.05.

## References
[1] Lichess.org, https://lichess.org/.<br>
[2] “Chess.” Wikipedia, Wikimedia Foundation, 11 Dec. 2022, https://en.wikipedia.org/wiki/Chess.<br>
[3] Emmett, Ryan. “How Popular Is Chess?” Chess.com, Chess.com, 9 Mar. 2020, https://www.chess.com/news/view/how-popular-is-chess-8306.<br>
[4] Noobiedatascientist. “Analysis of Lichess Games.” Kaggle, Kaggle, 23 Dec. 2021, https://www.kaggle.com/code/noobiedatascientist/analysis-of-lichess-games/data?select=Sept_20_analysis.csv.<br>
[5] “Lichess.org Open Database.” Lichess.org Open Database, https://database.lichess.org/. <br>
