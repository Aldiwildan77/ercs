import { assert, expect } from 'chai';
import { ethers } from 'hardhat';
import { describe, it } from 'mocha';
import { ERC20 } from '../../typechain-types';

describe('Given ERC20 token tests', function () {
  let ERC20Token: ERC20;

  before(async function () {
    const ERC20 = await ethers.getContractFactory('ERC20');
    ERC20Token = await ERC20.deploy();
    await ERC20Token.waitForDeployment();
  });

  describe('When supply check', () => {
    it('Then it should return the total supply of the token', async function () {
      const totalSupply = await ERC20Token.totalSupply();
      expect(totalSupply).to.be.a('bigint');
      assert.isAbove(
        Number(totalSupply.toString(10)),
        0,
        'Total supply should be greater than zero'
      );
    });

    it('Then it should return the balance of a specific address', async function () {
      const [owner] = await ethers.getSigners();
      const balance = await ERC20Token.balanceOf(owner.address);
      expect(balance).to.be.a('bigint');
      assert.isAbove(
        Number(balance.toString(10)),
        0,
        'Owner balance should be greater than zero'
      );
    });
  });

  describe('When contract owner balance check', () => {
    it('Then it should return the balance of a specific address', async function () {
      const [owner] = await ethers.getSigners();
      const balance = await ERC20Token.balanceOf(owner.address);
      expect(balance).to.be.a('bigint');
      assert.isAbove(
        Number(balance.toString(10)),
        0,
        'Owner balance should be greater than zero'
      );
    });
  });

  describe('When transferring tokens', () => {
    it('Then it should transfer tokens successfully', async function () {
      const addressTo = '0x0000000000000000000000000000000000000001';
      const transferAmount = 100n;

      const initialBalance = await ERC20Token.balanceOf(addressTo);
      const transferTx = await ERC20Token.transfer(addressTo, transferAmount);

      await transferTx.wait();

      const finalBalance = await ERC20Token.balanceOf(addressTo);

      expect(finalBalance).to.equal(initialBalance + transferAmount);
      assert.isTrue(
        finalBalance > initialBalance,
        'Final balance should be greater than initial balance after transfer'
      );
    });

    it('Then it should fail to transfer tokens if insufficient balance', async function () {
      const addressTo = '0x0000000000000000000000000000000000000002';
      const transferAmount = 1_000_000_000_001n; // Assuming this amount exceeds the owner's balance

      const [_, addrWithoutTokens] = await ethers.getSigners();
      await expect(
        ERC20Token.connect(addrWithoutTokens).transfer(
          addressTo,
          transferAmount
        )
      ).to.be.revertedWith('ERC20: insufficient balance');
    });
    it('Then it should transfer tokens from one address to another', async function () {
      const [owner, recipient] = await ethers.getSigners();
      const transferAmount = 50n;
      const initialOwnerBalance = await ERC20Token.balanceOf(owner.address);
      const initialRecipientBalance = await ERC20Token.balanceOf(
        recipient.address
      );
      const transferTx = await ERC20Token.transferFrom(
        owner.address,
        recipient.address,
        transferAmount
      );
      await transferTx.wait();
      const finalOwnerBalance = await ERC20Token.balanceOf(owner.address);
      const finalRecipientBalance = await ERC20Token.balanceOf(
        recipient.address
      );
      expect(finalOwnerBalance).to.equal(initialOwnerBalance - transferAmount);
      expect(finalRecipientBalance).to.equal(
        initialRecipientBalance + transferAmount
      );
      assert.isTrue(
        finalOwnerBalance < initialOwnerBalance,
        'Final owner balance should be less than initial owner balance after transfer'
      );
      assert.isTrue(
        finalRecipientBalance > initialRecipientBalance,
        'Final recipient balance should be greater than initial recipient balance after transfer'
      );
    });
  });
});
