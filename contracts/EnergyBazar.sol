// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

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

  function sellPower(string memory _name, uint256 _price, bool _renewable) public{
    seller = msg.sender;
    name = _name;
    price = _price;
    renewable = _renewable;
  }

  function getArticle() public view returns(
    address _seller,
    string memory _name,
    uint256 _price,
    bool _renewable
  ){
    return (seller, name, price, renewable);
  }
}
