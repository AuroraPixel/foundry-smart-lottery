// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

error Raffle__NotEnoughEthEntered();

/**
 * @title  A sample Raffle Contract
 * @author Andrew Wang
 * @notice This contract is for creating a sample raffle
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */
contract Raffle is VRFConsumerBaseV2Plus {
    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval,address vrfCoordinator) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthEntered();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    // 1. Get a random number
    // 2. Use the random number to pick a winner
    // 3. Be automatically called
    function pickWinner() external {
        // check to see if enough time has passed
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }
        // get our random number from chainlink VRF
        // requestId = s_vrfCoordinator.requestRandomWords(
        //     VRFV2PlusClient.RandomWordsRequest({
        //         keyHash: keyHash,
        //         subId: s_subscriptionId,
        //         requestConfirmations: requestConfirmations,
        //         callbackGasLimit: callbackGasLimit,
        //         numWords: numWords,
        //         extraArgs: VRFV2PlusClient._argsToBytes(
        //             VRFV2PlusClient.ExtraArgsV1({
        //                 nativePayment: enableNativePayment
        //             })
        //         )
        //     })
        // );
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal  override {

    }

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }


}
