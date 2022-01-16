// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;
    mapping(address => uint256) addressToWaveCount;
    address maxWaverAddress;
    uint256 maxWaveCount;

    constructor() {
        console.log("Logging from WavePortal constructor by %s", msg.sender);
        console.log("Current max waver is %s", maxWaverAddress);
    
    }

    function wave() public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        addressToWaveCount[msg.sender] += 1;

        if (msg.sender == maxWaverAddress) {
            maxWaveCount += 1;
        } else if (addressToWaveCount[msg.sender] > maxWaveCount) {
            maxWaverAddress = msg.sender;
            maxWaveCount = addressToWaveCount[msg.sender];
        }
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getHeighestWaver() public view returns (address) {
        console.log("%s waved the most", maxWaverAddress);
        return maxWaverAddress;
    }

    function getMaxIndividualWave() public view returns (uint256) {
        console.log("The most wave is %d total waves!", maxWaveCount);

        return maxWaveCount;
    }

    // function getWaveCount(address _address) public view returns (uint256) {
    //     console.log("The most wave by %s is %d total waves!", _address, addressToWaveCount[_address]);

    //     return addressToWaveCount[_address];
    // }

    function getWaveCount() public view returns (uint256) {
        console.log("The most wave by %s is %d total waves!", msg.sender, addressToWaveCount[msg.sender]);

        return addressToWaveCount[msg.sender];
    }
}