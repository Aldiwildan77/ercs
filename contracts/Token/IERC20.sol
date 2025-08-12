// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

// We define an interface for the basic ERC20 standard
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address addr) external view returns (uint256);

    // this only do by the contract
    function transfer(address to, uint256 value) external returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}
