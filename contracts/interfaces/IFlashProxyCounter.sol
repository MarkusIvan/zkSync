// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface IFlashProxyCounter {
    function incrementCounter(address user) external;

    function getCount(address user) external view returns (uint256);

    function setRole(address addr, address sender) external;
}
