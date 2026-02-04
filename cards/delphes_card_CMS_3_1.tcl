#######################################
# Order of execution of various modules
#######################################

set ExecutionPath {
  ParticlePropagator

  ChargedHadronTrackingEfficiency
  ElectronTrackingEfficiency
  MuonTrackingEfficiency

  ChargedHadronMomentumSmearing
  ElectronMomentumSmearing

  TreeWriter
}

#################################
# Propagate particles in cylinder
#################################

module ParticlePropagator ParticlePropagator {
  set InputArray Delphes/stableParticles

  set OutputArray stableParticles
  set ChargedHadronOutputArray chargedHadrons
  set ElectronOutputArray electrons
  set MuonOutputArray muons

  # radius of the magnetic field coverage, in m
  set Radius 1.29
  # half-length of the magnetic field coverage, in m
  set HalfLength 3.00

  # magnetic field
  set Bz 3.8
}


####################################
# Charged hadron tracking efficiency
####################################

module Efficiency ChargedHadronTrackingEfficiency {
  set InputArray ParticlePropagator/chargedHadrons
  set OutputArray chargedHadrons

  # add EfficiencyFormula {efficiency formula as a function of eta and pt}

  # tracking efficiency formula for charged hadrons
  set EfficiencyFormula {                                                    (pt <= 0.1)   * (0.00) +
                                           (abs(eta) <= 1.5) * (pt > 0.1   && pt <= 1.0)   * (0.70) +
                                           (abs(eta) <= 1.5) * (pt > 1.0)                  * (0.95) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1   && pt <= 1.0)   * (0.60) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 1.0)                  * (0.85) +
                         (abs(eta) > 2.5)                                                  * (0.00)}
}

##############################
# Electron tracking efficiency
##############################

module Efficiency ElectronTrackingEfficiency {
  set InputArray ParticlePropagator/electrons
  set OutputArray electrons

  # set EfficiencyFormula {efficiency formula as a function of eta and pt}

  # tracking efficiency formula for electrons
  set EfficiencyFormula {                                                    (pt <= 0.1)   * (0.00) +
                                           (abs(eta) <= 1.5) * (pt > 0.1   && pt <= 1.0)   * (0.73) +
                                           (abs(eta) <= 1.5) * (pt > 1.0   && pt <= 1.0e2) * (0.95) +
                                           (abs(eta) <= 1.5) * (pt > 1.0e2)                * (0.99) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1   && pt <= 1.0)   * (0.50) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 1.0   && pt <= 1.0e2) * (0.83) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 1.0e2)                * (0.90) +
                         (abs(eta) > 2.5)                                                  * (0.00)}
}

##########################
# Muon tracking efficiency
##########################

module Efficiency MuonTrackingEfficiency {
  set InputArray ParticlePropagator/muons
  set OutputArray muons

  # set EfficiencyFormula {efficiency formula as a function of eta and pt}

  # tracking efficiency formula for muons
  set EfficiencyFormula {                                                    (pt <= 0.1)   * (0.00) +
                                           (abs(eta) <= 1.5) * (pt > 0.1   && pt <= 1.0)   * (0.75) +
                                           (abs(eta) <= 1.5) * (pt > 1.0   && pt <= 1.0e3) * (0.99) +
                                           (abs(eta) <= 1.5) * (pt > 1.0e3 )               * (0.99 * exp(0.5 - pt*5.0e-4)) +

                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1   && pt <= 1.0)   * (0.70) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 1.0   && pt <= 1.0e3) * (0.98) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 1.0e3)                * (0.98 * exp(0.5 - pt*5.0e-4)) +
                         (abs(eta) > 2.5)                                                  * (0.00)}
}

########################################
# Momentum resolution for charged tracks
########################################

module MomentumSmearing ChargedHadronMomentumSmearing {
  set InputArray ChargedHadronTrackingEfficiency/chargedHadrons
  set OutputArray chargedHadrons

  # set ResolutionFormula {resolution formula as a function of eta and pt}

  # resolution formula for charged hadrons
  # based on arXiv:1405.6569
  set ResolutionFormula {                  (abs(eta) <= 0.5) * (pt > 0.1) * sqrt(0.06^2 + pt^2*1.3e-3^2) +
                         (abs(eta) > 0.5 && abs(eta) <= 1.5) * (pt > 0.1) * sqrt(0.10^2 + pt^2*1.7e-3^2) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1) * sqrt(0.25^2 + pt^2*3.1e-3^2)}
}

###################################
# Momentum resolution for electrons
###################################

module MomentumSmearing ElectronMomentumSmearing {
  set InputArray ElectronTrackingEfficiency/electrons
  set OutputArray electrons

  # set ResolutionFormula {resolution formula as a function of eta and energy}

  # resolution formula for electrons
  # based on arXiv:1502.02701
  set ResolutionFormula {                  (abs(eta) <= 0.5) * (pt > 0.1) * sqrt(0.03^2 + pt^2*1.3e-3^2) +
                         (abs(eta) > 0.5 && abs(eta) <= 1.5) * (pt > 0.1) * sqrt(0.05^2 + pt^2*1.7e-3^2) +
                         (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1) * sqrt(0.15^2 + pt^2*3.1e-3^2)}
}

########################################
# Tree writer
########################################

module TreeWriter TreeWriter {
# add Branch InputArray BranchName BranchClass
  
  # All particles before propagation
  add Branch Delphes/stableParticles ParticleBeforeProp GenParticle
  
  # All particles after propagation
  add Branch ParticlePropagator/stableParticles ParticleAfterProp GenParticle
  
  # Separated outputs from ParticlePropagator
  add Branch ParticlePropagator/chargedHadrons ChargedHadron Track
  add Branch ParticlePropagator/electrons Electron Track
  add Branch ParticlePropagator/muons Muon Track
  
  # Charged hadrons after tracking efficiency filter
  add Branch ChargedHadronTrackingEfficiency/chargedHadrons ChargedHadronEfficiency Track

  # Electrons after tracking efficiency filter
  add Branch ElectronTrackingEfficiency/electrons ElectronEfficiency Track

  # Muons after tracking efficiency filter
  add Branch MuonTrackingEfficiency/muons MuonEfficiency Track

  # Charged hadrons after momentum smearing
  add Branch ChargedHadronMomentumSmearing/chargedHadrons ChargedHadronSmeared Track

  # Electrons after momentum smearing
  add Branch ElectronMomentumSmearing/electrons ElectronSmeared Track
}
