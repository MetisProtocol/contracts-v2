pragma solidity ^0.6.0;


contract MVM_ProjectMaster is {

    address projectOwner;
    uint256 projectStake;
    string  projectURL;

    constructor(
     	address owner,
        uint256 stake,
        string memory url
    )
       public
    {
        projectOwner = owner;
        projectStake = stake;
        projectURL = url
    }
}
