import { expect } from 'chai';
import { ZeroAddress } from 'ethers';
import { ethers } from 'hardhat';
import { describe, it } from 'mocha';
import { ERC20 } from '../../typechain-types';

describe('Given ERC20 token', function () {
  let ERC20Token: ERC20;

  before(async function () {
    const ERC20Factory = await ethers.getContractFactory('ERC20');
    ERC20Token = (await ERC20Factory.deploy()) as unknown as ERC20;
    await ERC20Token.waitForDeployment();
  });

  describe('When call a totalSupply()', () => {
    it('Then return initial token supply', async () => {
      const totalSupply = await ERC20Token.totalSupply();
      expect(totalSupply).to.be.a('bigint');
      expect(totalSupply).equal(0);
    });
  });

  describe('When call a zero value transfer()', () => {
    it('Then the balance must be the same', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const receiverAddress = '0x0000000000000000000000000000000000000001';
      const initialBalance = await ERC20Token.balanceOf(senderAddress);

      const tx = await ERC20Token.transfer(receiverAddress, 0);
      await tx.wait();

      expect(await ERC20Token.balanceOf(senderAddress)).equal(initialBalance);
      expect(await ERC20Token.balanceOf(receiverAddress)).equal(0);
    });
  });

  describe('When call a transfer() with insufficient balance', () => {
    it('Then revert with "ERC20: transfer amount exceeds balance"', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const receiverAddress = '0x0000000000000000000000000000000000000001';
      const initialBalance = await ERC20Token.balanceOf(senderAddress);
      const transferAmount = initialBalance + 1n;

      await expect(
        ERC20Token.transfer(receiverAddress, transferAmount)
      ).to.be.revertedWith('ERC20: transfer amount exceeds balance');
    });
  });

  describe('When call a transfer() to self', () => {
    it('Then the balance must be the same', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const initialBalance = await ERC20Token.balanceOf(senderAddress);

      const tx = await ERC20Token.transfer(senderAddress, 0);
      await tx.wait();

      expect(await ERC20Token.balanceOf(senderAddress)).equal(initialBalance);
    });
  });

  describe('When call a transfer() to zero address', () => {
    it('Then revert with "ERC20: transfer to the zero address"', async () => {
      await expect(
        ERC20Token.transfer('0x0000000000000000000000000000000000000000', 1)
      ).to.be.revertedWith('ERC20: transfer to the zero address');
    });
  });

  describe('When call a transfer() from zero address', () => {
    it('Then revert with "ERC20: insufficient allowance"', async () => {
      const receiverAddress = '0x0000000000000000000000000000000000000001';
      const transferAmount = 1;

      await expect(
        ERC20Token.transferFrom(ZeroAddress, receiverAddress, transferAmount)
      ).to.be.revertedWith('ERC20: insufficient allowance');
    });
  });

  describe('When call a approve() to zero address', () => {
    it('Then revert with "ERC20: approve to the zero address"', async () => {
      await expect(ERC20Token.approve(ZeroAddress, 1)).to.be.revertedWith(
        'ERC20: approve to the zero address'
      );
    });
  });

  describe('When call a approve() with zero value', () => {
    it('Then the allowance must be zero', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const tx = await ERC20Token.approve(senderAddress, 0);
      await tx.wait();

      expect(await ERC20Token.allowance(senderAddress, senderAddress)).equal(0);
    });
  });

  describe('When call a approve() with non-zero value', () => {
    it('Then the allowance must be set', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const tx = await ERC20Token.approve(senderAddress, 100);
      await tx.wait();

      expect(await ERC20Token.allowance(senderAddress, senderAddress)).equal(
        100
      );
    });
  });

  describe('When call a approve() with non-zero value and then zero', () => {
    it('Then the allowance must be zero', async () => {
      const [sender] = await ethers.getSigners();
      const senderAddress = await sender.getAddress();

      const tx = await ERC20Token.approve(senderAddress, 0);
      await tx.wait();

      expect(await ERC20Token.allowance(senderAddress, senderAddress)).equal(0);
    });
  });
});
