library(ggplot2)
library(MASS)
library(ggfortify)
library(gridExtra)
library(markdown)

#' @param n number of observations
#' @param a intercept
#' @param b_x effect of continuous variable
#' @param b_fac effect of categorial variable
#' @param b_int interaction effect
#' @param link link function
#' @param family error distribution function
datagen <- function(n = 100, 
                    a = 0, 
                    b_x = 2, 
                    b_fac = -1, 
                    b_int = -3,
                    link = c('identity', 'log'),
                    family = c('gaussian', 'poisson', 'negbin'),
                    sigma = 1,
                    dispersion = 4) {
  link <- match.arg(link)
  family <- match.arg(family)
  
  x <- runif(n)
  fac <- sample(c('A', 'B'), n, replace = TRUE)
  fac_dummy <- ifelse(fac == 'A', 0, 1)
  
  # mean
  link_mu <- a + b_x*x + b_fac*fac_dummy + b_int*fac_dummy*x
  mu <- switch(link,
               identity = link_mu,
               log = exp(link_mu))
  if (family %in% c('poisson', 'negbin') && any(mu < 0))
    stop("Cannot simulate Poisson or NegBin with negative mean. Maybe change link function.")
  # response
  y <- switch(family,
         poisson = rpois(n, mu),
         gaussian = rnorm(n, mean = mu, sd = sigma),
         negbin = rnbinom(n, mu = mu, size = 1/dispersion))
    
  # return
  df <- data.frame(x, y, fac)
  return(df)
}

#' @param df data.frame as returned by datagen
#' @param link link function
#' @param family error distribution function
datamodel <- function(df, 
                      family = c('gaussian', 'poisson', 'negbin'),
                      link = c('identity', 'log'),
                      terms = c('intercept', 'x', 'fac', 'both', 'interaction')){
  link <- match.arg(link)
  family <- match.arg(family)
  terms <- match.arg(terms)
  form <- switch(terms,
                 intercept = as.formula(y ~ 1),
                 x = as.formula(y ~ x),
                 fac = as.formula(y ~ fac),
                 both = as.formula(y ~ x+fac),
                 interaction = as.formula(y ~ x*fac)
                 )
  start <- switch(terms,
                  intercept = 1,
                  x = rep(1, 2),
                  fac = rep(1, 2),
                  both = rep(1, 3),
                  interaction = rep(1, 4)
                  )
  
  mod <- switch(family,
         poisson = glm(form, data = df, family = poisson(link = link),
             start = start),
         gaussian = glm(form, data = df, family = gaussian(link = link),
                        start = start),
         negbin = glm.nb(form, data = df), link = link)
  return(mod)
}

#' @param df data.frame as returned by datagen
#' @param mod model as returned by datamodel
dataplot <- function(df, mod = NULL) {
  lim <- c(-10, 10)
  # model fit + ci
  pdat <- expand.grid(x = seq(min(df$x), max(df$x), 
                              length.out = 100), 
                      fac = levels(df$fac))
  pdat$fit <- predict(mod, newdata = pdat, type = "link")
  pdat$se <- predict(mod, newdata = pdat, type = "link", se.fit = TRUE)$se.fit
  mod_fam <- mod$family$family
  mod_fam <- ifelse(grepl('Negative Binomial', mod_fam), 'negbin', mod_fam)
  crit <- switch(mod_fam,
                 gaussian = qt(0.975, df = mod$df.residual),
                 poisson = qnorm(0.975),
                 negbin = qt(0.975, df = mod$df.residual))
  pdat$lwr <- pdat$fit - crit * pdat$se
  pdat$upr <- pdat$fit + crit * pdat$se
  pdat$fit_r <- mod$family$linkinv(pdat$fit)
  pdat$lwr_r <- mod$family$linkinv(pdat$lwr)
  pdat$upr_r <- mod$family$linkinv(pdat$upr)
  
  # simulate from model for PI
  nsim <- 1000
  y_sim <- simulate(mod, nsim = nsim)
  y_sim_minmax <- apply(y_sim, 1, quantile, probs = c(0.05, 0.95))
  simdat <- data.frame(ysim_min = y_sim_minmax[1, ],
                       ysim_max = y_sim_minmax[2, ],
                       x = df$x,
                       fac = df$fac)
  p <- ggplot() + 
    geom_ribbon(data = simdat, aes(x = x, 
                                   ymax = ysim_max, ymin = ysim_min, 
                                   fill = fac), alpha = 0.2) +
    geom_line(data = pdat, aes(x = x, y = fit_r, col = fac)) +
    geom_line(data = pdat, aes(x = x, y = upr_r, col = fac), 
              linetype = 'dashed') +
    geom_line(data = pdat, aes(x = x, y = lwr_r, col = fac), 
              linetype = 'dashed') +
    geom_point(data = df, aes(x = x, y = y, color = fac)) +
    labs(y = 'y') +
    ylim(lim)
  p
}

coefplot <- function(a = 2, 
                     b_x = 1, 
                     b_fac = 1, 
                     b_int = -2,
                     mod) {
  coefs <- coef(mod)
  se <- diag(vcov(mod))^0.5
  terms <- c('a', 'b_x', 'b_fac', 'b_int')
  terms <- terms[seq_along(coefs)]
  truths <- c(a, b_x, b_fac, b_int)
  truths <- truths[seq_along(coefs)]
  df <- data.frame(term = terms, estimate = coefs, se, truths)
  mod_fam <- mod$family$family
  mod_fam <- ifelse(grepl('Negative Binomial', mod_fam), 'negbin', mod_fam)
  crit <- switch(mod_fam,
                 gaussian = qt(0.975, df = mod$df.residual),
                 poisson = qnorm(0.975),
                 negbin = qt(0.975, df = mod$df.residual))
  df$lwr <- df$estimate - crit * df$se
  df$upr <- df$estimate + crit * df$se
  
  p <- ggplot(df, aes(x = term)) +
    geom_pointrange(aes(y = estimate, ymax = upr, ymin = lwr)) +
    geom_point(aes(y = truths), col = 'red') +
    geom_vline(xintercept = 0, linetype = 'dashed') +
    coord_flip()
  p
}

diagplot <- function(df, mod) {
  rfdat <- data.frame(res = residuals(mod, type = 'pearson'), 
                      fac = df$fac, 
                      fit = predict(mod, type = 'response'))
  p1 <- ggplot() +
    geom_point(data = rfdat, aes(x = fit, y = res, color = fac)) +
    ggtitle('Residuals vs. Fitted') +
    labs(x = 'Residuals', y = 'Fitted') +
    geom_smooth(data = rfdat, aes(x = fit, y = res, color = fac), 
                se = FALSE) +
    geom_smooth(data = rfdat, aes(x = fit, y = res), color = 'blue', 
                se = FALSE) +
    geom_abline(aes(intercept = 0, slope = 0), linetype = 'dashed')
  

  ofdat <- data.frame(obs = df$y, 
                      fac = df$fac, 
                      fit = predict(mod, type = 'response'))
  p2 <- ggplot() +
    geom_point(data = ofdat, aes(x = obs, y = fit, color = fac)) +
    ggtitle('Fitted vs Observed') +
    labs(x = 'Observed', y = 'Fitted') +
    geom_abline(aes(intercept = 0, slope = 1), linetype = 'dashed') 
  plot.list <- list(p1, p2)
  new("ggmultiplot", plots = plot.list, nrow = 1, ncol = 2)
  }


chk_pos <- function(y, fam) {
  if (fam %in% c('poisson', 'negbin') && any(y < 0)) {
    "Negative values in data. Cannot fit Poisson or NegBin."
  } else {
    NULL
  }
}
