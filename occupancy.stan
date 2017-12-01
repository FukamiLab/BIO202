sink("./src/occupancy.stan")
cat("
  data {
  int<lower=0> N; //Number of Sites
    int<lower=6> J; //Number of Replicates at each site
    int<lower=0, upper=1> y[N, J]; //Detection at each site on each sampling rep
    int<lower=0, upper=1> x[N]; //Observed occupancy at each site
    real DAY[N, J];
    }
    
    parameters {
    real a0; //specifying regression parameters
    real b0;
    real b1;
    real b2;
    }
    
    transformed parameters {
    real<lower=0,upper=1>  psi[N]; 
    real<lower=0,upper=1>  p[N, J];
    for(i in 1:N) {
    psi[i] = inv_logit(a0);  //intercept-only model for occupancy
    for(j in 1:J) {
    p[i, j] = inv_logit(b0 + b1*DAY[i, j] + b2*DAY[i, j]*DAY[i, j]); //Detection probability on inverse logit
    }
    }
    }
    
    model {
    // Priors
    a0 ~ normal(0, 5);
    b0 ~ normal(0, 5);
    b1 ~ normal(0, 5);
    b2 ~ normal(0, 5);
    
    // likelihood
    for(i in 1:N) {
    if(x[i]==1) {
    1 ~ bernoulli(psi[i]);
    y[i] ~ bernoulli(p[i]);
    }
    if(x[i]==0) {
    increment_log_prob(log_sum_exp(log(psi[i]) + log1m(p[i,1]) + log1m(p[i,2]) + 
    log1m(p[i,3]) + log1m(p[i,4]) + log1m(p[i,5]) + log1m(p[i,6]), log1m(psi[i]))); //?
    }
    }
    }
    
    ",fill = TRUE)
sink()
