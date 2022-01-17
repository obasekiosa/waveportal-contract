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

    mapping(address => uint256) public lastWavedAt;

    uint256 private seed;

    constructor() payable {
        console.log("Logging from WavePortal constructor by %s", msg.sender);
        seed = (block.timestamp + block.difficulty) % 100;
    
    }

    function wave(string memory _message) public {

        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15 minutes"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved! with a message %s", msg.sender, _message);


        Wave memory newWave = Wave(msg.sender, _message, block.timestamp);

        waves.push(newWave);
        addressToWaves[msg.sender].push(newWave);


        if (addressToWaves[msg.sender].length > addressToWaves[maxWaverAddress].length) {
            maxWaverAddress = msg.sender;
        }

        

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;

            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
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