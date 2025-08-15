// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

interface IOwnable {
    /**
     * @dev Returns the address of the current owner of the contract.
     */
    function owner() external view returns (address);

    /**
     * @dev Transfers ownership of the contract to a new address.
     * @param newOwner The address of the new owner.
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external;
}
