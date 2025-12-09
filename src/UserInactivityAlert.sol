// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "drosera-contracts/interfaces/ITrap.sol";

contract UserInactivityAlert is ITrap {
    // The user we watch
    address public immutable WATCHED;

    // Inactivity threshold
    uint256 public constant INACTIVITY_PERIOD = 1 days;

    // Last activity timestamp
    mapping(address => uint256) public lastActive;

    struct CollectOutput {
        uint256 lastActivity;
        uint256 currentTimestamp;
    }

    constructor(address _watched) {
        WATCHED = _watched;
    }

    // Update activity manually from dApp
    function markActive() external {
        require(msg.sender == WATCHED, "Only watched user");
        lastActive[WATCHED] = block.timestamp;
    }

    function collect() external view override returns (bytes memory) {
        return abi.encode(
            CollectOutput({
                lastActivity: lastActive[WATCHED],
                currentTimestamp: block.timestamp
            })
        );
    }

    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, bytes("")); // guard empty array

        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory previous = abi.decode(data[data.length - 1], (CollectOutput));

        if (previous.lastActivity == 0) return (false, bytes(""));

        uint256 inactiveTime = current.currentTimestamp - previous.lastActivity;

        if (inactiveTime > INACTIVITY_PERIOD) {
            return (true, abi.encode(inactiveTime)); // matches respondCallback(uint256)
        }

        return (false, bytes(""));
    }
} 
