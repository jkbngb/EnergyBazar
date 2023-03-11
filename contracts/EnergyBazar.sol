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

}
