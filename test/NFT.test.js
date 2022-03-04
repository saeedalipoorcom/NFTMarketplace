const NFTMarketplace = artifacts.require("NFTMarketplace");
const NFT = artifacts.require("NFT");

contract('Test NFT', async ([deployer , investor1])=>{

    beforeEach(async ()=>{
        this.NFTMarketplace = await NFTMarketplace.new();
        this.NFT = await NFT.new('Pepsi', 'PEP', this.NFTMarketplace.address);
    })

    it('CREATE SOME TOKENS', async()=>{

        //CREATE ITEMS
        await this.NFT.createNFTItem('http://www.google.com', {from : deployer});
        await this.NFT.setApprovalForAll(this.NFTMarketplace.address, true);

        await this.NFT.createNFTItem('http://www.google.com', {from : deployer});
        await this.NFT.setApprovalForAll(this.NFTMarketplace.address, true);

        await this.NFT.createNFTItem('http://www.google.com', {from : deployer});
        await this.NFT.setApprovalForAll(this.NFTMarketplace.address, true);

        //SET PRICE
        const Price = await web3.utils.toWei('10','ether');

        //SET ITEMS IN MARKET
        await this.NFTMarketplace.createItem(1, Price, this.NFT.address, {value : web3.utils.toWei('0.1','ether')});
        await this.NFTMarketplace.createItem(2, Price, this.NFT.address, {value : web3.utils.toWei('0.1','ether')});
        await this.NFTMarketplace.createItem(3, Price, this.NFT.address, {value : web3.utils.toWei('0.1','ether')});

        //BUY ITEMS
        await this.NFTMarketplace.BuyItem(1, this.NFT.address, {from : investor1, value : web3.utils.toWei('10','ether')});
        await this.NFTMarketplace.BuyItem(2, this.NFT.address, {from : investor1, value : web3.utils.toWei('10','ether')});
        await this.NFTMarketplace.BuyItem(3, this.NFT.address, {from : investor1, value : web3.utils.toWei('10','ether')});

        //GET MY OWN ITEMS AND SHOW IN WEBSITE
        const getMyNFTItems = await this.NFTMarketplace.getMyNFTItems({from : investor1});
        console.log(getMyNFTItems);
    })

})
