// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "./IERC20.sol";

interface IERC20Mintable is IERC20 {
    /**
     * @dev Mints `amount` tokens to the `to` address.
     * Can only be called by the contract owner or an authorized minter.
     */
    function mint(address to, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `amount` tokens are minted to `to`.
     */
    event Mint(address indexed to, uint256 amount);
}
