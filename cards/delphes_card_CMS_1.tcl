#######################################
# Order of execution of various modules
#######################################

set ExecutionPath {
  ParticlePropagator
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

# Save particles before and after ParticlePropagator
# Delphes/stableParticles = input particles (before propagation)
# ParticlePropagator/stableParticles = output particles (after propagation)

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
}
