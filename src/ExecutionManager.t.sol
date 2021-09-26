// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.7.6;
pragma abicoder v2;

import {DSTestPlus} from "solmate/src/tests/utils/DSTestPlus.sol";

import {MockCrossDomainMessenger} from "nova/contracts/mocks/MockCrossDomainMessenger.sol";

import {L1_NovaExecutionManager} from "nova/contracts/L1_NovaExecutionManager.sol";

contract ExecutionManagerTest is DSTestPlus {
    L1_NovaExecutionManager executionManager;
    MockCrossDomainMessenger mockCrossDomainMessenger;

    function setUp() public {
        mockCrossDomainMessenger = new MockCrossDomainMessenger();
        executionManager = new L1_NovaExecutionManager(DEAD_ADDRESS, mockCrossDomainMessenger);
    }

    /*///////////////////////////////////////////////////////////////
                        PROPERTY/SYMBOLIC TESTS
    //////////////////////////////////////////////////////////////*/

    function proveUpdatingGasConfig(L1_NovaExecutionManager.GasConfig calldata newGasConfig) public {}
}
