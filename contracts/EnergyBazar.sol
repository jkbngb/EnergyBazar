// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract EnergyBazar {
  address payable seller;
  address buyer;
  string name;
  uint256 price;

  struct source{
    bool solar;
    bool wind;
    bool hydro;
    bool fossil;
    bool other;
  }

  source energySource;

  //Events
  event ArticleToSell(address indexed _seller, string _name, uint256 _price, source _energySource);
  event ArticleSold(address indexed _seller, address indexed _buyer, string _name, uint256 _price, source _energySource);


  //Sell an article
  function sellPower(string memory _name, uint256 _price, bool _solar, bool _wind, bool _hydro, bool _fossil, bool _other) public{
    seller = payable(msg.sender); 
    name = _name;
    price = _price;

    energySource = source({
        solar: _solar,
        wind: _wind,
        hydro: _hydro,
        fossil: _fossil,
        other: _other
    });

    emit ArticleToSell(seller, name, price, energySource);
  }

  //Return article for sale
  function getArticle() public view returns(
    address _seller,
    address _buyer,
    string memory _name,
    uint256 _price,
    source memory _energySource
  ){
    return (seller, buyer, name, price, energySource);
  }

  //Buy an article
    function buyPower() public payable {
      //is article for sale?
      require(seller != address(0), "Article not available");
      
      //is article sold yet?
      require(buyer == address(0), "Article already sold");

      //is price correct?
      require(msg.value == price, "Wrong price");

      //Check if renewable energy is used
      require(energySource.solar || energySource.wind || energySource.hydro, "Non-renewable energy source used");

      //Sender is recorded as Buyer
      buyer = msg.sender;

      // Transfer the value of the transaction to the seller's address
      seller.transfer(msg.value);

      //trigger event
      emit ArticleSold(seller, buyer, name, price, energySource);
  }
}
