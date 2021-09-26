// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.7.6;

import {DSTestPlus} from "solmate/src/tests/utils/DSTestPlus.sol";

import {MockCrossDomainMessenger} from "nova/contracts/mocks/MockCrossDomainMessenger.sol";

import {L2_NovaRegistry} from "nova/contracts/L2_NovaRegistry.sol";

contract RegistryTest is DSTestPlus {
    L2_NovaRegistry registry;
    MockCrossDomainMessenger mockCrossDomainMessenger;

    function setUp() public {
        mockCrossDomainMessenger = new MockCrossDomainMessenger();
        registry = new L2_NovaRegistry(mockCrossDomainMessenger);
    }

    /*///////////////////////////////////////////////////////////////
                              INVARIANTS
    //////////////////////////////////////////////////////////////*/

    function invariantExecutionManager() public {
        assertEq(registry.L1_NovaExecutionManagerAddress(), address(0));
    }

    /*///////////////////////////////////////////////////////////////
                        PROPERTY/SYMBOLIC TESTS
    //////////////////////////////////////////////////////////////*/

    function proveConnectingExecutionManager(address newExecutionManager) public {
        registry.connectExecutionManager(newExecutionManager);
        assertEq(registry.L1_NovaExecutionManagerAddress(), newExecutionManager);
    }
}
