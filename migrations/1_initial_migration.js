const NFTMarketplace = artifacts.require("NFTMarketplace");
const NFT = artifacts.require("NFT");

module.exports = async function (deployer) {

  await deployer.deploy(NFTMarketplace);
  const NFTMarketplaceC = await NFTMarketplace.deployed();

  await deployer.deploy(NFT, 'Pepsi', 'PEP', NFTMarketplaceC.address);
  const NFTC = await NFT.deployed();

};
