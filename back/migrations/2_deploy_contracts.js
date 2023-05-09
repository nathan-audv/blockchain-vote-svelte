const ContractDeployed = artifacts.require("Voting");

module.exports = function(deployer) {
  deployer.deploy(ContractDeployed);
};

