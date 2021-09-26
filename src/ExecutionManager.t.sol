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

    function proveUpdatingGasConfig(L1_NovaExecutionManager.GasConfig calldata newGasConfig) external {
        executionManager.updateGasConfig(newGasConfig);

        (
            uint32 calldataByteGasEstimate,
            uint96 missingGasEstimate,
            uint96 strategyCallGasBuffer,
            uint32 execCompletedMessageGasLimit
        ) = executionManager.gasConfig();

        assertUint32Eq(newGasConfig.calldataByteGasEstimate, calldataByteGasEstimate);
        assertUint96Eq(newGasConfig.missingGasEstimate, missingGasEstimate);
        assertUint96Eq(newGasConfig.strategyCallGasBuffer, strategyCallGasBuffer);
        assertUint32Eq(newGasConfig.execCompletedMessageGasLimit, execCompletedMessageGasLimit);
    }

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
