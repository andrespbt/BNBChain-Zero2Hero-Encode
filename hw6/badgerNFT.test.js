const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('BadgerNFT contract', function () {
  let badgerNFT;
  let addr1;
  let addr2;
  let tokenURI = 'https://example.com/metadata/1.json';

  beforeEach(async function () {
    const BadgerNFT = await ethers.getContractFactory('BadgerNFT');
    badgerNFT = await BadgerNFT.deploy();
    await badgerNFT.deployed();

    [addr1, addr2] = await ethers.getSigners();
  });

  describe('tests on BadgerNFT', function () {
    it('should award a new NFT to the player', async function () {
      // Award NFT to addrs
      await badgerNFT.awardItem(addr1.address, tokenURI);

      expect(await badgerNFT.ownerOf(0)).to.equal(addr1.address);
      expect(await badgerNFT.tokenURI(0)).to.equal(tokenURI);
    });

    it('should transfer an NFT from one player to another', async function () {
      // Award NFT to addr1
      await badgerNFT.awardItem(addr1.address, tokenURI);

      // Check that addr1 is the owner of the NFT
      expect(await badgerNFT.ownerOf(0)).to.equal(addr1.address);

      // Transfer NFT from addr1 to addr2
      await badgerNFT.connect(addr1).transferFrom(addr1.address, addr2.address, 0);

      // Check that addr2 is the new owner of the NFT
      expect(await badgerNFT.ownerOf(0)).to.equal(addr2.address);
    });
  });
});
