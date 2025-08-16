// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "../Ownable/IOwnable.sol";
import "./IERC20.sol";
import "./IERC20Mintable.sol";
import "./IERC20Burnable.sol";

contract ERC20Mintable is IERC20, IERC20Mintable, IERC20Burnable, IOwnable {
    address private _owner;

    uint256 private _tokenSupply;
    uint256 private constant _decimals = 16; // Custom for ERC20 tokens

    string private _name = "ERC20CustomToken";
    string private _symbol = "ECTA";

    mapping(address => uint256) private _userBalances;
    mapping(address => mapping(address => uint256)) private _allowed;

    constructor() {
        _owner = msg.sender; // Set the contract deployer as the owner
        _tokenSupply = 0; // Initialize total supply to zero
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "ERC20: caller is not the owner");
        _;
    }

    function owner() external view override returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) external override onlyOwner {
        require(
            newOwner != address(0),
            "ERC20: new owner must not be zero address"
        );
        _owner = newOwner;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
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

    function approve(
        address spender,
        uint256 value
    ) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
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

    // Minting function

    function mint(
        address to,
        uint256 amount
    ) external override onlyOwner returns (bool) {
        require(to != address(0), "ERC20: mint to the zero address");
        require(amount > 0, "ERC20: mint amount must be greater than zero");

        _tokenSupply += amount;
        _userBalances[to] += amount;

        emit Transfer(address(0), to, amount);
        return true;
    }

    // Burning function

    function burn(uint256 amount) external override onlyOwner returns (bool) {
        require(amount > 0, "ERC20: burn amount must be greater than zero");
        require(
            _userBalances[msg.sender] >= amount,
            "ERC20: burn amount exceeds balance"
        );

        _userBalances[msg.sender] -= amount;
        _tokenSupply -= amount;

        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
}
