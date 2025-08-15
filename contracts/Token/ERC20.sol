// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 private _tokenSupply;

    uint256 private constant _decimals = 16; // Custom for ERC20 tokens

    mapping(address => uint256) private _userBalances;

    mapping(address => mapping(address => uint256)) private _allowed;

    constructor() {
        _tokenSupply = 0; // Initialize total supply to zero
    }

    // View functions

    function totalSupply() external view override returns (uint256) {
        return _tokenSupply;
    }

    function balanceOf(address addr) external view override returns (uint256) {
        return _userBalances[addr];
    }

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowed[owner][spender];
    }

    // Mutation functions

    function transfer(
        address to,
        uint256 value
    ) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        _spendAllowance(from, msg.sender, value);
        _transfer(from, to, value);
        return true;
    }

    function approve(
        address spender,
        uint256 value
    ) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    // internal
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 _fromBalance = _userBalances[from];

        require(
            _fromBalance >= value,
            "ERC20: transfer amount exceeds balance"
        );

        unchecked {
            _userBalances[from] = _fromBalance - value;
        }

        _userBalances[to] += value;

        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal {
        uint256 currentAllowance = _allowed[owner][spender];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= value, "ERC20: insufficient allowance");
            unchecked {
                _allowed[owner][spender] = currentAllowance - value;
            }
        }
    }
}
