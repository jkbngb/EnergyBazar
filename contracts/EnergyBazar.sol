// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract EnergyBazar {
  
  // Struct for offered article with relevant parameters
  struct EnergyArticle {
    bytes32 articleId;
    address payable seller;
    address buyer;
    string name;
    uint256 price;
    bool renewable;
    bytes32 auctionId;
  }

  // Struct to represent an auction
  struct Auction {
    bytes32 auctionId;
    uint256 highestBid;
    address payable highestBidder; // Change the type to 'address payable'
    uint256 endTime;
    bool finalized;
  }


  // Linking unique article IDs to corresponding EnergyArticle struct
  mapping(bytes32 => EnergyArticle) public articles;

  // Linking unique auction IDs to corresponding Auction struct
  mapping(bytes32 => Auction) public auctions;

  // Events
  event AuctionCreated(bytes32 indexed _auctionId, bytes32 indexed _articleId, uint256 _endTime);
  event NewBid(bytes32 indexed _auctionId, address indexed _bidder, uint256 _value);
  event AuctionFinalized(bytes32 indexed _auctionId, address indexed _winner, uint256 _value);

  // Sell an article and create an auction
  function sellPower(string memory _name, uint256 _price, bool _renewable, uint256 _auctionDuration) public {
    bytes32 articleId = keccak256(abi.encodePacked(msg.sender, _name, _price, _renewable, block.timestamp));
    
    EnergyArticle memory article = EnergyArticle({
      articleId: articleId,
      seller: payable(msg.sender),
      buyer: address(0),
      name: _name,
      price: _price,
      renewable: _renewable,
      auctionId: bytes32(0)
    });

    articles[articleId] = article;

    // Create an auction for the energy article
    bytes32 auctionId = keccak256(abi.encodePacked(articleId, block.timestamp));
    uint256 endTime = block.timestamp + _auctionDuration;

    Auction memory auction = Auction({
      auctionId: auctionId,
      highestBid: 0,
      highestBidder: payable(address(0)),
      endTime: endTime,
      finalized: false
    });

    auctions[auctionId] = auction;
    articles[articleId].auctionId = auctionId;
    emit AuctionCreated(auctionId, articleId, endTime);
  }

  // Place a bid on an auction
  function placeBid(bytes32 _articleId) public payable {
    EnergyArticle storage article = articles[_articleId];
    Auction storage auction = auctions[article.auctionId];

    require(block.timestamp < auction.endTime, "Auction has ended");
    require(msg.value >= article.price, "Bid is below seller's initial price");
    require(msg.value > auction.highestBid, "Bid is too low");
    require(!auction.finalized, "Auction already finalized");

    if (auction.highestBidder != address(0)) {
      // Refund previous highest bidder
      auction.highestBidder.transfer(auction.highestBid);
    }

    auction.highestBid = msg.value;
    auction.highestBidder = payable(msg.sender);
    emit NewBid(article.auctionId, msg.sender, msg.value);
  }

  // Finalize the auction
  function finalizeAuction(bytes32 _articleId) public {
    EnergyArticle storage article = articles[_articleId];
    Auction storage auction = auctions[article.auctionId];

    require(msg.sender == article.seller, "Only the seller can finalize the auction");
    require(block.timestamp >= auction.endTime, "Auction has not ended yet");
    require(!auction.finalized, "Auction already finalized");

    article.seller.transfer(auction.highestBid);
    article.buyer = auction.highestBidder;
    auction.finalized = true;

    emit AuctionFinalized(auction.auctionId, auction.highestBidder, auction.highestBid);
  }
}
