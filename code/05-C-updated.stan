data {
    int<lower=0> N;                       // sample size
    int<lower=0> Nnests;                  //number of nests
    int<lower=0> y[N];                    //counts (number of youngs)
    vector[N] year;                       //numeric covariate
    int<lower=0, upper=Nnests> nest[N];   // index of nest
  }

parameters {
      vector[2] a;                        // coef of linear pred for theta
      vector[2] b;                        // coef of linear pred for lambda
      real<lower=0> sigma;            // between nest sd in logit(theta)
      real groupefftheta[Nnests];         // nest effects for theta
    }
  
model {
    //transformed parameters (within model to avoid monitoring) 
    vector[N] theta;                      // probability of zero youngs
    vector[N] lambda;                     // avg. number of youngs
                                          // in successful nests
    for(i in 1:N){
      // linear predictors with random effect
      theta[i] = inv_logit(a[1] + a[2] * year[i] + sigma * groupefftheta[nest[i]]);
    }
    lambda = exp(b[1] + b[2] * year); 
    // priors
    a[1] ~ normal(0,5);
    a[2] ~ normal(0,5);
    b[1] ~ normal(0,5);
    b[2] ~ normal(0,5);
    sigma ~ cauchy(0,5);
    
    // random effects
    for(g in 1:Nnests) { 
      groupefftheta[g] ~ normal(0,1);
    }
    
    // likelihood
    for (i in 1:N){ 
      if(y[i] == 0)
        target += log_sum_exp(bernoulli_lpmf(1 | theta[i]), 
            bernoulli_lpmf(0 | theta[i]) + poisson_lpmf(y[i] | lambda[i]));
      else
        target += bernoulli_lpmf(0 | theta[i]) +  poisson_lpmf(y[i] | lambda[i]);
    } 
}