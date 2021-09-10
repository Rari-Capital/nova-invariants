// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.7.6;

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
                              INVARIANTS
    //////////////////////////////////////////////////////////////*/

    // function invariantCalldataByteGasEstimate() public {
    //     assertUint128Eq(executionManager.calldataByteGasEstimate(), 13);
    // }

    // function invariantMissingGasEstimate() public {
    //     assertUint128Eq(executionManager.missingGasEstimate(), 200000);
    // }

    function invariantCurrentExecHash() public {
        assertEq(executionManager.currentExecHash(), executionManager.DEFAULT_EXECHASH());
    }

    /*///////////////////////////////////////////////////////////////
                        PROPERTY/SYMBOLIC TESTS
    //////////////////////////////////////////////////////////////*/

    // function proveUpdatingMissingGasEstimate(uint128 newMissingGasEstimate) public {
    //     executionManager.setMissingGasEstimate(newMissingGasEstimate);

    //     assertUint128Eq(executionManager.missingGasEstimate(), newMissingGasEstimate);
    // }

    // function proveUpdatingCalldataByteGasEstimate(uint128 newCalldataByteGasEstimate) public {
    //     executionManager.setCalldataByteGasEstimate(newCalldataByteGasEstimate);

    //     assertUint128Eq(executionManager.calldataByteGasEstimate(), newCalldataByteGasEstimate);
    // }

    function proveFailTransferFromRelayerOutsideOfActiveExec(address token, uint256 amount) public {
        executionManager.transferFromRelayer(token, amount);
    }

    function testExec(
        uint256 nonce,
        address strategy,
        bytes memory l1Calldata,
        uint256 gasLimit,
        address recipient,
        uint256 deadline
    ) public {
        try executionManager.exec(nonce, strategy, l1Calldata, gasLimit, recipient, deadline) {
            assert(executionManager.currentExecHash() == executionManager.DEFAULT_EXECHASH());
            assert(executionManager.currentRelayer() == address(this));
            assert(executionManager.currentlyExecutingStrategy() == strategy);
        } catch {}
    }
}
