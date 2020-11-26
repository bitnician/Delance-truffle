const ProjectFactory = artifacts.require('ProjectFactory');
const { abi: projectABI } = require('../build/contracts/Project.json');
require('chai').use(require('chai-as-promised')).should();
const helpers = require('./helpers');

contract('Project Factory', ([admin, employer, freelancer]) => {
  let projectFactory, deadline, value, gas;

  before(async () => {
    projectFactory = await ProjectFactory.deployed();
    deadline = helpers.getEpochTime(300);

    value = web3.utils.toWei('0.1', 'ether');
    gas = 1000000;
  });

  describe('Project Factory Contract', () => {
    it('should deploy the contract', async () => {
      const address = await projectFactory.address;
      assert.ok(address);
      assert.notEqual(address, 0x0);
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, '');
    });

    it('should create a project', async () => {
      await projectFactory.createProject(freelancer, deadline, { from: employer, value });
      const deployedProjects = await projectFactory.getDeployedProjects();
      assert.deepEqual(deployedProjects.length, 1);
    });

    it('should not create a project with prise of 0', async () => {
      await projectFactory.createProject(freelancer, deadline, { from: employer }).should.be.rejectedWith('Low price!');
    });
  });

  describe('Project Contract', () => {
    let project, requestAmount, requestTitle;

    before(async () => {
      await projectFactory.createProject(freelancer, deadline, { from: employer, value });
      const [projectAddress] = await projectFactory.getDeployedProjects();

      project = await new web3.eth.Contract(projectABI, projectAddress);
      requestAmount = web3.utils.toWei('0.01', 'ether');
      remainingAmount = web3.utils.toWei('0.09', 'ether');
      requestTitle = 'CUSTOM TITLE';
    });

    it('should get the balance of project contract', async () => {
      const balance = await project.methods.getBalance().call();
      assert.deepEqual(value, balance);
    });

    it('should create a request', async () => {
      const result = await project.methods.createRequest(requestTitle, requestAmount).send({ from: freelancer, gas });

      const { title, amount, locked, paid } = result.events.RequestCreated.returnValues;
      assert.deepEqual(requestTitle, title);
      assert.deepEqual(requestAmount, amount);
      assert.deepEqual(locked, true);
      assert.deepEqual(paid, false);
    });

    it('should unlock the request', async () => {
      const result = await project.methods.unlockRequest(0).send({ from: employer, gas });
      const { locked } = result.events.RequestUnlocked.returnValues;
      assert.deepEqual(locked, false);
    });

    it('should pay the request', async () => {
      let initBalance = await web3.eth.getBalance(freelancer);
      initBalance = parseInt(initBalance);

      const result = await project.methods.payRequest(0).send({ from: freelancer, gas });
      const { receiver, amount } = result.events.RequestPaid.returnValues;

      let newBalance = await web3.eth.getBalance(freelancer);
      newBalance = parseInt(newBalance);

      assert.deepEqual(freelancer, receiver);
      assert.deepEqual(requestAmount, amount);
      expect(parseInt(newBalance)).to.be.gt(initBalance);
    });

    it('should increase the deadline', async () => {
      const increasedAmount = 120;
      const oldDeadline = await project.methods.deadline().call();
      await project.methods.increaseDeadline(increasedAmount).send({ from: employer });
      const newDeadline = await project.methods.deadline().call();

      assert.deepEqual(parseInt(newDeadline), parseInt(oldDeadline) + increasedAmount);
    });

    it('should complete the project', async () => {
      const result = await project.methods.completeProject().send({ from: employer, gas });
      const {
        employer: employerAddress,
        freelancer: freelancerAddress,
        amount,
        status,
      } = result.events.ProjectCompleted.returnValues;

      assert.deepEqual(employer, employerAddress);
      assert.deepEqual(freelancer, freelancerAddress);
      assert.deepEqual(remainingAmount, amount);
      assert.deepEqual('0', status);
    });

    it('should cancel the project', async () => {
      await projectFactory.createProject(freelancer, 0, { from: employer, value });
      const deployedProjects = await projectFactory.getDeployedProjects();
      const projectAddress = deployedProjects[deployedProjects.length - 1];

      project = await new web3.eth.Contract(projectABI, projectAddress);

      const result = await project.methods.cancelProject().send({ from: employer, gas });

      const { remainingPayments, status } = result.events.ProjectCanceled.returnValues;
      assert.deepEqual(value, remainingPayments);
      assert.deepEqual('1', status);
    });
  });
});
