// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract EnergyBazar {
  address seller;
  string name;
  uint256 price;

  struct source{
    bool solar;
    bool wind;
    bool hydro;
    bool fossil;
    bool other;
  }

  bool renewable;

  //Event
  event ArticleToSell(address indexed _seller, string _name, uint256 _price, bool _renewable);

  //Sell an article
  function sellPower(string memory _name, uint256 _price, bool _renewable) public{
    seller = msg.sender;
    name = _name;
    price = _price;
    renewable = _renewable;

    emit ArticleToSell(seller, name, price, renewable);
  }

  //Return article for sale
  function getArticle() public view returns(
    address _seller,
    string memory _name,
    uint256 _price,
    bool _renewable
  ){
    return (seller, name, price, renewable);
  }
}
