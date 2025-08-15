// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "./IERC20.sol";

interface IERC20Burnable is IERC20 {
    /**
     * @dev Burns `amount` tokens from the caller's account.
     * Can only be called by the token holder.
     */
    function burn(uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `amount` tokens are burned from the caller's account.
     */
    event Burn(address indexed from, uint256 amount);
}
