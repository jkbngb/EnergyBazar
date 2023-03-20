// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract EnergyBazar {
  
  struct EnergyArticle{
    bytes32 id;
    address payable seller;
    address buyer;
    string name;
    uint256 price;
    bool renewable;
  }

  //linking unique article IDs to corresponding EnergyArticle struct
  mapping(bytes32 => EnergyArticle) public articles;

  //Events
  event ArticleToSell(bytes32 indexed _id, address indexed _seller, string _name, uint256 _price, bool _renewable);
  event ArticleSold(bytes32 indexed _id, address indexed _seller, address indexed _buyer, string _name, uint256 _price, bool _renewable);


  //Sell an article
  function sellPower(string memory _name, uint256 _price, bool _renewable) public {
    //generation of unique ID
    bytes32 id = keccak256(abi.encodePacked(msg.sender, _name, _price, _renewable, block.timestamp));
    
    //create an EnergyArticle struct with name "article"
    EnergyArticle memory article = EnergyArticle({
      id: id,
      seller: payable(msg.sender),
      buyer: address(0),
      name: _name,
      price: _price,
      renewable: _renewable
    });

    //stores EnergyArticle struct in the "articles" mapping
    articles[id] = article;

    //triggers event
    emit ArticleToSell(article.id, article.seller, article.name, article.price, article.renewable);
  }

  //Return article for sale
  function getArticle(bytes32 _id) public view returns(
    bytes32 id,
    address _seller,
    address _buyer,
    string memory _name,
    uint256 _price,
    bool _renewable
  ){
    
    //retrieves the EnergyArticle struct associated with the input _id from the articles mapping and stores it in a memory variable named article.
    EnergyArticle memory article = articles[_id]; //updated
    return (article.id, article.seller, article.buyer, article.name, article.price, article.renewable);
  }

  //Buy an article
    function buyPower(bytes32 _id) public payable {
      EnergyArticle storage article = articles[_id];

      //is article for sale?
      require(article.seller != address(0), "Article not available");
      
      //is article sold yet?
      require(article.buyer == address(0), "Article already sold");

      //is price correct?
      require(msg.value == article.price, "Wrong price");

      //Check if renewable energy is used
      require(article.renewable, "Non-renewable energy source used");

      //Sender is recorded as Buyer
      article.buyer = msg.sender;

      // Transfer the value of the transaction to the seller's address
      article.seller.transfer(msg.value);

      //trigger event
      emit ArticleSold(article.id, article.seller, article.buyer, article.name, article.price, article.renewable);
  }
}
