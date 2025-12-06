// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

contract UserInactivityAlert is ITrap {
    mapping(address => uint256) public lastActive;
    uint256 public constant INACTIVITY_PERIOD = 1 days;

    struct CollectOutput {
        uint256 lastActivity;
        uint256 currentTimestamp;
    }

    constructor() {}

    function collect() external view override returns (bytes memory) {
        return abi.encode(
            CollectOutput({
                lastActivity: lastActive[msg.sender],
                currentTimestamp: block.timestamp // <— move timestamp HERE
            })
        );
    }

    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        CollectOutput memory current = abi.decode(data[0], (CollectOutput));

        // since this is PURE, we compare values from data only
        if (current.currentTimestamp - current.lastActivity > INACTIVITY_PERIOD) {
            return (true, bytes("User inactive for too long!"));
        }

        return (false, bytes(""));
    }
}

