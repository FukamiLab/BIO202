data {
  //Data objects declared
    int<lower=0> N; //Sample size for MCMC simulations
    vector[N] y; 
    vector[N] x;
}

parameters {
  //Model parameter objects declared
    vector[2] beta;
    real<lower=0> sigma; 
}

model {
  //Prior distributions 
    beta ~ normal(0,5);
    sigma ~ cauchy(0,5);
  //Likelihood 
    y ~ normal(beta[1] + beta[2] * x, sigma);
}