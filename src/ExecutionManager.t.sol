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

    function invariantGasConfig() public {
        (
            uint32 calldataByteGasEstimate,
            uint96 missingGasEstimate,
            uint96 strategyCallGasBuffer,
            uint32 execCompletedMessageGasLimit
        ) = executionManager.gasConfig();

        assertUint32Eq(calldataByteGasEstimate, 13);
        assertUint96Eq(missingGasEstimate, 200000);
        assertUint96Eq(strategyCallGasBuffer, 5000);
        assertUint32Eq(execCompletedMessageGasLimit, 1500000);
    }

    function invariantCurrentExecHash() public {
        assertEq(executionManager.currentExecHash(), executionManager.DEFAULT_EXECHASH());
    }

    /*///////////////////////////////////////////////////////////////
                        PROPERTY/SYMBOLIC TESTS
    //////////////////////////////////////////////////////////////*/

    function proveUpdatingGasConfig(L1_NovaExecutionManager.GasConfig calldata newGasConfig) public {}

    function proveFailTransferFromRelayerOutsideOfActiveExec(address token, uint256 amount) public {
        executionManager.transferFromRelayer(token, amount);
    }

    function testExec(
        uint256 nonce,
        address strategy,
        bytes calldata l1Calldata,
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
