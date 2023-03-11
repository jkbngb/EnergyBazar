var EnergyBazar = artifacts.require("./EnergyBazar.sol");

module.exports = function(deployer){
    deployer.deploy(EnergyBazar);
}