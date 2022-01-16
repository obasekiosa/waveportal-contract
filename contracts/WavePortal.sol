// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaves;
    address maxWaverAddress;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }
    Wave[] waves;
    mapping(address => Wave[]) addressToWaves;

    constructor() {
        console.log("Logging from WavePortal constructor by %s", msg.sender);
        console.log("Current max waver is %s", maxWaverAddress);
    
    }

    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved! with a message %s", msg.sender, _message);


        Wave memory newWave = Wave(msg.sender, _message, block.timestamp);

        waves.push(newWave);
        addressToWaves[msg.sender].push(newWave);


        if (addressToWaves[msg.sender].length > addressToWaves[maxWaverAddress].length) {
            maxWaverAddress = msg.sender;
        }

        emit NewWave(newWave.waver, newWave.timestamp, newWave.message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getAllWavesByAddress(address _address) public view returns (Wave[] memory) {
        return addressToWaves[_address];
    }

    function getAllWavesByCaller() public view returns (Wave[] memory) {
        return addressToWaves[msg.sender];
    }

    

    function getHeighestWaver() public view returns (address) {
        console.log("%s waved the most", maxWaverAddress);
        return maxWaverAddress;
    }

    function getMaxIndividualWave() public view returns (uint256) {
        console.log("The most wave is %d total waves!", addressToWaves[maxWaverAddress].length);

        return addressToWaves[maxWaverAddress].length;
    }

    function getWaveCountByAddress(address _address) public view returns (uint256) {
        console.log("The most wave by %s is %d total waves!", _address, addressToWaves[_address].length);

        return addressToWaves[_address].length;
    }

    function getWaveCountByCaller() public view returns (uint256) {
        console.log("The most wave by %s is %d total waves!", msg.sender, addressToWaves[msg.sender].length);

        return addressToWaves[msg.sender].length;
    }
}