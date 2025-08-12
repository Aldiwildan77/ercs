// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 private _tokenSupply;

    uint256 private constant _decimals = 16; // Custom for ERC20 tokens

    mapping(address => uint256) private _userBalances;

    constructor() {
        _tokenSupply = 1_000_000_000 * 10 ** _decimals; // 1 billion tokens with 16 decimals
        _userBalances[msg.sender] = _tokenSupply; // Assign all tokens to the contract
        emit Transfer(address(0), msg.sender, _tokenSupply); // Emit transfer event for
    }

    function totalSupply() external view override returns (uint256) {
        return _tokenSupply;
    }

    function balanceOf(address addr) external view override returns (uint256) {
        return _userBalances[addr];
    }

    function transfer(
        address to,
        uint256 value
    ) external override returns (uint256) {
        _transfer(msg.sender, to, value);
        return value;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        _transfer(from, to, value);
        return true;
    }

    // internal
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value > 0, "ERC20: transfer value must be greater than zero");
        require(value <= _userBalances[from], "ERC20: insufficient balance");

        uint256 _fromBalance = _userBalances[from];
        uint256 _toBalance = _userBalances[to];

        // ! we don't allow negative value here
        _userBalances[from] = _fromBalance - value;
        _userBalances[to] = _toBalance + value;

        emit Transfer(from, to, value);
    }
}
