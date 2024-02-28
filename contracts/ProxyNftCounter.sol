// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ProxyNftCounter
 * @dev A contract that manages a counter for each address.
 * The counter value represents the number of times an address has been minted an NFT from a collection.
 * The contract provides functions to increment the counter, grant and revoke the counter manager role,
 * and retrieve the count of NFTs owned by a specific user.
 */
contract ProxyNftCounter is AccessControl {
    // ____________________ Constants ________________________

    /**
     * @dev The constant `COUNTER_MANAGER_ROLE` represents the role identifier for the counter manager.
     * This role is used to manage the counter functionality in the contract.
     * This role is granted to each NFT collection contract that wants to use the counter.
     */
    bytes32 public constant COUNTER_MANAGER_ROLE = keccak256("COUNTER_MANAGER_ROLE");

    // ____________________ Variables ________________________

    /**
     * @dev A mapping that stores a counter for each address.
     * The counter value represents the number of times an address has been minted an NFT from a collection.
     * The counter is incremented by the `incrementCounter` function only once in first minting of an NFT.
     */
    mapping(address => uint256) public counter;

    // ____________________ Events ________________________

    /**
     * @dev Emitted when the counter is incremented.
     * @param user The address of the user who incremented the counter.
     * @param count The new value of the counter.
     */
    event CounterIncremented(address indexed user, uint256 count);

    // ____________________ Errors ________________________
    
    /// @dev Error thrown when an address is zero.
    error ZeroAddress();

    /// @dev Throws an error indicating that only the admin role can perform the action.
    error OnlyAdminRole();

    // ____________________ Constructor ________________________
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // ____________________ External functions  ________________________
    /**
     * @dev Increments the counter for a specific user.
     * Only the address with the COUNTER_MANAGER_ROLE can call this function.
     * 
     * @param user The address of the user whose counter will be incremented.
     * 
     * Emits a CounterIncremented event with the updated counter value.
     */
    function incrementCounter(address user) external onlyRole(COUNTER_MANAGER_ROLE) {
        if (user == address(0)) revert ZeroAddress();
        counter[user]++;

        emit CounterIncremented(user, counter[user]);
    }

    /**
     * @dev Grants the COUNTER_MANAGER_ROLE to multiple addresses.
     * Only the DEFAULT_ADMIN_ROLE can call this function.
     * 
     * @param addrs The array of addresses to grant the role to.
     */
    function grantBatchRole(address[] calldata addrs) external onlyRole(DEFAULT_ADMIN_ROLE) {
        for (uint256 i = 0; i < addrs.length; i++) {
            _grantRole(COUNTER_MANAGER_ROLE, addrs[i]);
        }
    }

    /**
     * @dev Revokes the COUNTER_MANAGER_ROLE from multiple addresses.
     * Can only be called by an account with the DEFAULT_ADMIN_ROLE.
     * @param addrs The addresses to revoke the role from.
     */
    function revokeBatchRole(address[] calldata addrs) external onlyRole(DEFAULT_ADMIN_ROLE) {
        for (uint256 i = 0; i < addrs.length; i++) {
            _revokeRole(COUNTER_MANAGER_ROLE, addrs[i]);
        }
    }

    /**
     * @dev Sets the role for an address.
     * Only the sender with the DEFAULT_ADMIN_ROLE can set roles.
     * Grants the COUNTER_MANAGER_ROLE to the specified address.
     * 
     * @param addr The address for which the role is being set.
     * @param sender The address of the sender.
     */
    function setRole(address addr, address sender) external {
        if (!hasRole(DEFAULT_ADMIN_ROLE, sender)) revert OnlyAdminRole();
        _grantRole(COUNTER_MANAGER_ROLE, addr);
    }

    /**
     * @dev Returns the count of NFTs owned by a specific user.
     * @param user The address of the user.
     * @return The count of NFTs owned by the user.
     */
    function getCount(address user) external view returns (uint256) {
        return counter[user];
    }
}
