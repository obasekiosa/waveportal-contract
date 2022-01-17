const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();

    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);

    // get balance
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );

    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );


    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    // send a wave
    let waveTxn = await waveContract.wave("This is wave #1");
    await waveTxn.wait(); // Wait for the transaction to be mined


    // chech contract balance after wave
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    waveTxn = await waveContract.wave("This is another wave #1");
    await waveTxn.wait();

    // chech randomPerson balance before second wave wave
    contractBalance = await hre.ethers.provider.getBalance(randomPerson.address);
    console.log(
        "waver balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    // send another wave
    waveTxn = await waveContract.connect(randomPerson).wave("This is wave #2");
    otherDetails = await waveTxn.wait(); // Wait for the transaction to be mined
    
    console.log("Transaction details", waveTxn);
    console.log("Other details after waiting", otherDetails);

    // chech contract balance after wave
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    // chech randomPerson balance after second wave wave
    contractBalance = await hre.ethers.provider.getBalance(randomPerson.address);
    console.log(
        "waver balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    waveCount = await waveContract.getTotalWaves();

    let mostWaved = await waveContract.getHeighestWaver();

    let maxIndividualWave = await waveContract.getMaxIndividualWave();

    let count = await waveContract.getWaveCountByCaller();

    let countRandomPerson = await waveContract.getWaveCountByAddress(randomPerson.address);

    let ownerWaves = await waveContract.getAllWavesByAddress(owner.address);
    console.log(ownerWaves);
    let randomPersonWaves = await waveContract.getAllWavesByAddress(randomPerson.address);
    console.log(randomPersonWaves);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();