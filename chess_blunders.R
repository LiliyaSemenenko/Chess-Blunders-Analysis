#########################################################
#                                                       #
#              Code to predict the number               #
#              of blunders made by white                #
#              during a chess match using               #
#              Poisson regression method.               #
#                                                       #
#                   Liliya Semenenko                    #
#                      STAT 410                         #
#                    December, 2022                     #
#                                                       #
#########################################################

#########################################################
#   Sample data with 6 predictors and 93 observations
#########################################################

library(readxl)
data = read.csv(file="C:\\Users\\lilin\\OneDrive\\Документы\\CSULB Classes\\STAT 410\\My codes\\Project\\sample_chess.csv",
                 stringsAsFactors = TRUE,header=TRUE, sep=",")

####################################################################
#   Specify reference levels and fit Poisson regression to the data
####################################################################

library(janitor)
tabyl(data, Termination )
tabyl(data, Black_elo_category)
tabyl(data, White_elo_category )
tabyl(data, Game_type )

Termination.rel = relevel(data$Termination, ref="Normal")
Black_cat.rel = relevel(data$Black_elo_category, ref="Low rating")
White_cat.rel = relevel(data$White_elo_category, ref="Low rating")
Game_type.rel = relevel(data$Game_type, ref="Rapid")

#fitting a model
fitted.model = glm(White_blunders ~ Termination.rel + 
                     White_cat.rel + Black_cat.rel + increment + Game_type.rel + Total_moves,
                   data=data, family=poisson(link=log))
summary(fitted.model)

# Coefficients:
#                                Estimate  Std. Error  t value  Pr(>|t|)
#   (Intercept)                  0.296639   0.242939   1.221 0.222070    
#   Termination.relTime forfeit  0.487098   0.211500   2.303 0.021275 *  
#   White_cat.relHigh rating    -0.108995   0.325007  -0.335 0.737353    
#   Black_cat.relHigh rating    -0.672123   0.339397  -1.980 0.047664 *  
#   increment                   -0.007350   0.039119  -0.188 0.850960    
#   Game_type.relBlitz          -0.204080   0.201378  -1.013 0.310860    
#   Game_type.relBullet         -0.583696   0.284767  -2.050 0.040391 *  
#   Game_type.relClassical      -0.682544   0.727803  -0.938 0.348340    
#   Total_moves                  0.008025   0.002092   3.837 0.000125 ***


# Fitted model has the rate = exp(0.296639 + 0.487098*termination by time forfeit -  
#                 0.108995*white player with high rating -
#                 0.672123*black player with high rating - 
#                 0.007350 *increment - 0.204080*Blitz game - 
#                 0.583696*Bullet game - 0.682544*classical game +
#                 0.008025*total number of moves)
# Significant coefficients at 5% level: termination by time forfeit, 
# black player with high rating, bullet game type, total number of moves.

#########################################################
#   Check model fir by running a deviance test
#########################################################

#checking model fit
#y ~ 1 means "fit an intercept only"
intercept.only.model = glm(White_blunders ~ 1,
                           data = data, family=poisson(link=log))

deviance = -2*
  (logLik(intercept.only.model)-logLik(fitted.model))
print(deviance)
# Output: 33.56226 

# degrees of freedom
df.value = length(coef(fitted.model)) - 
  length(coef(intercept.only.model))
print(df.value)

# p-value
# pchisq gives the distribution function
p.value = pchisq(deviance, df=df.value, lower.tail=FALSE)
print(p.value)
# Output: 4.875617e-05


# The model is a good fit due to p-value < 0.05 for the deviance test.                                          

#########################################################
#   Interpret significant parameters
######################################################### 

print(exp(0.487098)*100) # termination by time forfeit
# Output: 162.7586%

print(exp(-0.672123)*100) # black player with high rating
# Output: 51.06234%

print(exp(-0.583696)*100) # bullet game type
# Output: 55.78328%

print((exp(0.008025)-1)*100) # total number of moves
# Output: 0.8057287%

# Answer: 
# 1) The estimated average number of blunders made by white when a game 
#    termination by time forfeit is 162.76% of that for abandoned games.
# 2) When white plays agains an opponent with high rating, the 
#    estimated mean number of blunders made by white is 51.06% of that
#    when its opponent has a low rating.
# 3) If white decides to play a bullet game, the estimated average 
#    number of blunders they make is 55.78% of that for a rapid game.
# 4) As total number of moves increases by one, the estimated average 
#    number of blunders made by white increases by 0.81%. 

#########################################################
#   Predict number of blunders given predictor values
#########################################################

# Predict the number of blunders made by white given that the player  has
# a low rating (below 1900), plays a Rapid game (between 10 and 15 minutes)
# against an opponent with high rating (between 1900 and 2400) who plays black, 
# with 0 time increment, 40 total number of moves, and the game
# terminated with check mate.

# using fitted model for prediction
prediction = predict(fitted.model, type="response", data.frame(
  Termination.rel="Normal", White_cat.rel="Low rating", 
  Black_cat.rel="High rating", increment=0,
  Game_type.rel="Rapid", Total_moves=40))
print(prediction)
# Output: 0.946971

#calculate same y0 manually
y0 = exp(0.296639 - 0.672123 + 0.008025*40)
print(y0)
# Output: 0.9469737