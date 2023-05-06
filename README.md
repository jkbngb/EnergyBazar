# EnergyBazar

EnergyBazar is a decentralized application (dApp) built on the Ethereum blockchain that allows users to buy and sell energy through an auction system.

## Smart Contract

The core of this dApp is a Solidity smart contract called `EnergyBazar`. It allows users to:

1. Offer energy for sale by creating an auction.
2. Place bids on ongoing auctions.
3. Finalize auctions when they are concluded.

## Key Components

- `EnergyArticle`: A struct representing an energy article with its associated parameters, such as article ID, seller, buyer, name, price, and auction ID.
- `Auction`: A struct representing an auction with parameters like auction ID, highest bid, highest bidder, end time, and finalized status.
- Mappings: Two mappings, `articles` and `auctions`, are used to link unique article IDs and auction IDs to their corresponding structs.
- Events: The contract emits events like `AuctionCreated`, `NewBid`, and `AuctionFinalized` to provide updates on contract interactions.

## Interacting with the Contract

To interact with the deployed contract, you can use the following commands in the Truffle console:

1. `let instance = await EnergyBazar.deployed()`: Get the deployed contract instance.
2. `instance.sellPower("Solar Energy", 100, true, 3600)`: Offer energy for sale by creating an auction.
3. `instance.placeBid(articleId, {value: web3.utils.toWei('1', 'ether'), from: bidderAccount})`: Place a bid on an ongoing auction.
4. `instance.finalizeAuction(articleId, {from: sellerAccount})`: Finalize an auction after its conclusion.

Make sure to replace `articleId`, `bidderAccount`, and `sellerAccount` with the actual values.

Remember to also set up event listeners to monitor contract events, using the `instance.AuctionCreated()`, `instance.NewBid()`, and `instance.AuctionFinalized()` functions.
