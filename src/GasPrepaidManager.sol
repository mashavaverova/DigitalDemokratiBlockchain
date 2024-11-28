// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import "lib/forge-std/src/console.sol";

contract GasPrepaidManager {
    address public metaVoting; // Address of the MetaVoting contract
    address payable public admin; // Admin of the contract
    address public relayer; // Authorized relayer
    mapping(address => uint256) public balances; // Prepaid balances by admin/relayer

    // Custom Errors
    error InsufficientBalance(uint256 requested, uint256 available);
    error InsufficientPrepaidBalance(uint256 required, uint256 available);
    error UnauthorizedAccess();
    error UnauthorizedAccessAdmin();

    // Events
    event FundsDeposited(address indexed depositor, uint256 amount);
    event FundsWithdrawn(address indexed admin, uint256 amount);
    event GasPaid(address indexed relayer, uint256 gasUsed, uint256 amount);
    event RelayerSet(address indexed relayer);
    event MetaVotingSet(address indexed metaVoting);

    // Modifiers
    modifier onlyAdmin() {
    console.log("Caller in onlyAdmin:", msg.sender);
    console.log("Expected admin:", admin);
        if (msg.sender != admin) {
            revert UnauthorizedAccessAdmin();
        }
        _;
    }

   modifier onlyAdminOrRelayerOrMetaVoting() {
    console.log("Caller:", msg.sender);
    console.log("Expected Admin:", admin);
    console.log("Expected Relayer:", relayer);
    console.log("Expected MetaVoting:", metaVoting);

    if (msg.sender != admin && msg.sender != relayer && msg.sender != metaVoting) {
        revert UnauthorizedAccess();
    }
    _;
}

    // Constructor
  constructor(address _metaVoting, address _admin) {
    require(_admin != address(0), "Admin address cannot be zero");
    admin = payable(_admin); // Use the explicitly passed `_admin` parameter
    metaVoting = _metaVoting;

    console.log("MetaVoting address initialized to:", _metaVoting);
    console.log("Admin set in GasPrepaidManager constructor:", admin);
}

    // Set MetaVoting Contract
    function setMetaVoting(address _metaVoting) external onlyAdmin {
        metaVoting = _metaVoting;
        emit MetaVotingSet(_metaVoting);
        console.log("MetaVoting address set to:", _metaVoting);
    }

    // Set Relayer
function setRelayer(address _relayer) external onlyAdmin {
    require(_relayer != address(0), "Relayer address cannot be zero");
    relayer = _relayer;

    emit RelayerSet(_relayer);
    console.log("Relayer address set to:", _relayer);
}

    // Deposit Funds
    function depositFunds() external payable onlyAdmin {
        balances[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
        console.log("Funds deposited by admin:", msg.value);
        console.log("Updated admin balance:", balances[admin]);
    }

    // Pay Gas
    function payGas(
        address relayerAddress,
        uint256 gasUsed,
        uint256 gasPrice
    ) external onlyAdminOrRelayerOrMetaVoting {
        console.log("=== Debugging payGas ===");
        console.log("Caller:", msg.sender);
        console.log("Relayer Address Passed:", relayerAddress);
        console.log("Stored Relayer Address:", relayer);
        console.log("MetaVoting Address:", metaVoting);

        require(relayerAddress == relayer, "Invalid relayer address");

        console.log("Gas Used:", gasUsed);
        console.log("Gas Price:", gasPrice);

        uint256 gasCost = gasUsed * gasPrice;
        console.log("Calculated Gas Cost:", gasCost);
        console.log("Admin Balance Before Deduction:", balances[admin]);

        if (balances[admin] < gasCost) {
            console.log("Insufficient Balance Error Triggered!");
            revert InsufficientPrepaidBalance({required: gasCost, available: balances[admin]});
        }

        balances[admin] -= gasCost;
        console.log("Admin Balance After Deduction:", balances[admin]);

        payable(relayerAddress).transfer(gasCost);
        console.log("Transfer Successful: Gas Cost Sent to Relayer");

        emit GasPaid(relayerAddress, gasUsed, gasCost);

        console.log("Gas Paid Successfully!");
        console.log("=== End Debugging payGas ===");
    }

    // Withdraw Funds
    function withdrawFunds(uint256 amount) external onlyAdmin {
        if (balances[msg.sender] < amount) {
            revert InsufficientBalance({requested: amount, available: balances[msg.sender]});
        }
        balances[msg.sender] -= amount;
        admin.transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
        console.log("Funds withdrawn by admin:", amount);
    }
}
