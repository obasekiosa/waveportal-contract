const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy();
    await waveContract.deployed();

    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);


    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    /**
     * Let's send a few waves!
     */
    let waveTxn = await waveContract.wave("A message!");
    await waveTxn.wait(); // Wait for the transaction to be mined

    waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
    await waveTxn.wait(); // Wait for the transaction to be mined

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