Power simulations for count data in one factorial designs
===================

This app runs power calculations for one factorial designs.
One the left you can specify the expected `Effects` to simulate,
settings for the `Simulation` design and the `Inference` procedure.

To run the app with default options, simply hit the `Run simulation` Button and explore the results for a global test and a test for LOEC.
After making changes on the left, you have to hit the `Run simulation` Button again.




### Data
Count data are simulated from a negative binomial distribution ($NB(\mu, \kappa)$) with mean = $\mu$ and variance = $\mu + \mu^2 / \kappa$.

$\kappa$ is a dispersion parameter: 

* if $\kappa \rightarrow 0$ overdispersion increases
* if $\kappa \rightarrow \infty$ data become Poisson distributed (no overdispersion)

The summary in the `Simulation-Design` tab gives mean and variances per treatment as well as graphical representation of the simulated data (assuming a sample size of 1000).

### Design 
Data are simulated for a one factorial design with 4 treatments and a step effect between treatments 2 and 3:

Abundance in in treatments 1 + 2 are draw from $NB(\mu_c, \kappa)$, whereas the mean abundance in treatments 3 + 4 are reduced by factor $r$: $NB(r \times \mu_c, \kappa)$. 
Therefore, the LOEC is at treatment 3 and NOEC at treatment 2.

Note, that $\kappa$ is equal between all treatments.

$\mu_c$, $\kappa$ and $r$ can be controlled by the sliders (on the left, `Effects`).
The `Simulation-Design` tab on the right gives a graphical representation of the design.
For demonstration purposes, 1000 data points per replicate are drawn from the specified design.


### Models

Two type of models are currently implemented:

1. Linear model on transformed data
2. Quasi-Poisson model

Both are computationally feasible and give correct Type I errors.


### Inference
The global treatment effect is assessed using an F-test.
LOEC is determined via Dunnett contrasts.
The type of hypothesis (one-sided / two-sided) can be specified (on the left, `Inference`).


### Simulations
Power is calculated using simulations.
The number of simulated datasets can be specified (currently max. 250 to take care of the server).
Moreover, up to 5 sample sizes (displayed on the x-axis) can be entered. (on the left, `Simulations`)

Press the `Run simulation` button to start the simulations.


## Output
Results for the global test and LOEC determination are given graphical and in tabular form on the right.
Both can be downloaded using the respective buttons.
