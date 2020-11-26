const ProjectFactory = artifacts.require('ProjectFactory');

module.exports = function (deployer) {
  deployer.deploy(ProjectFactory);
};
