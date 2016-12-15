## Introduction

With this little application you can simulate data with known effects and properties and then can you fit a GLM to this data.
The aim of this little App is to let you explore interactively Generalized Linear Models, to fit these to data simulated from different distributions, that may or may not match the assumed distribution of the model and to illustrate the resulting diagnostic plots. 
Because we will use simulated data, you know the true distributions and parameters and you can explore what happens if we select an incorrect model.
`Exercises` will guide you through this process.
Overall you should get a better understanding of GLMs, their application and diagnostics.


You can reach the app by clicking on the `App` tab in the navigation bar.
The app consists of two modules:

1. `Simulate`
2. `Model`

Under `Simulate` you can specify which data to simulate.
Under `Model` you can specify which model should be fitted to this data.
Additionally, the `Summary`, a plot of `coefficients` and `Diagnostic` plots are given for the fitted model.




## Data Simulation

Data can be generated from a GLM (`Simulate` tab).
The simulated data can depend on two predictors (one continuous and one categorical) and their interaction.
You can vary the number of observations, the distribution from which the data originates, the link function and the variability within the data.

The simulation model can be written as:

$$Y_i \sim D(\mu_i)$$
$$\eta_i = f(\mu_i)$$
$$\eta_i = \alpha + \beta_{x} x_i + \beta_{fac} fac_i + \beta_{x:fac} x_i fac_i$$

The distribution of the response ($D()$) can be choosen from:

1. Gaussin/Normal Distribution: $N(\mu, \sigma)$
2. Poission Distribution: $Pois(\mu)$
3. Negative Binomial Distribution: $NB(\mu, \theta)$

The link-function $f()$ can be choosen from:

1. identity link: $f(\mu) = \mu$
2. log link: $f(\mu) = log(\mu)$

For ordinary regression you need to choose `Gaussian` and the `identity` link.

Effects that can be varied are:

1. Intercept: $\alpha$
2. Continuous predictors: $x$
3. Categorical predictor with two levels (A and B): $fac$
4. The interaction between the categorical predictor and the continuous predictor: $x:fac$

Additionally, the variance can be varied (via "\sigma" for Normal data and $\theta$ for Negative Binomial data).

All of this can be specified in the `Simulate` tab on the left.
On the right from this tab you see a plot of the simulated data.


## Fit a model to this data

In the `Model` tab you can specify on the left how the GLM should be fitted, which distribution and link should be assumed and which predictors should be included.
On the right you see:

1. The simulated data
2. The fitted model (solid line)
3. The pointwise 95% Confidence Interval (dashed line)

Optional: 
4. The 90% Prediction Interval (PI, shaded band). The PI is based on simulations from the models.

Below you find the corresponding R command.


## Diagnose the model

The App incorporates several model output and diagnostics:

1. `Model Summary`
2. `Model Coefficients`
3. `Model Diagnostics`

Within each, you can change the fitted model on the left to see how this changes the diagnostics.


`Model Summary` print the resulting `summary()`.

`Model Coefficients` show a plot of the estimated coefficients (black dots),
their 95% confidence interval (black lines) and the true (=used for simulation) coefficients.

`Model Diagnostics` shows for diagnostics plots from basic R:

1. (Pearson) Residuals vs. Fitted values
2. Observed vs. Fitted values
3. QQ-Plot
4. (Pearson) Residuals vs. Leverage


Below you find two plots from the [DHARMa package](https://github.com/florianhartig/DHARMa) for diagnosing GL(M)M.
The left plot shows a QQ-Plot of quantile residuals (check the DHARMa page for more information), the right plot quantile residuals vs. fitted values.


## Exercises

Open now the `Exercises` Tab and follow them. 

You can also find them [here](https://github.com/EDiLD/shiny_apps/blob/master/glm_explorer/exercises.md) (click on `Raw` the get the file).
It is best if you have the exercises open in a separate (browser) window.

You can always reset to start by pressing `F5` in your browser.



## Meta
This app was created using [Shiny](https://shiny.rstudio.com/) from RStudio.
It was written by [Eduard Szöcs](edild.github.io) and is licensed under [MIT](https://opensource.org/licenses/MIT).
You can find the source code on [github](https://github.com/EDiLD/shiny_apps/tree/master/glm_explorer).

