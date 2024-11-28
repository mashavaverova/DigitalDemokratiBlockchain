// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import "../src/GasPrepaidManager.sol";
import "../src/MetaVoting.sol";

contract GasPrepaidManagerTest is Test {
    GasPrepaidManager public gasPrepaidManager;
    MetaVoting public metaVoting;


    address public relayer = address(0x123);
    address public attacker = address(0x456);
    address payable public admin = payable(address(this));
    

    // Enable the test contract to receive Ether
    receive() external payable {}

    function setUp() public {
        // Deploy GasPrepaidManage
    metaVoting = new MetaVoting(address(this), address(this));
    gasPrepaidManager = new GasPrepaidManager(address(metaVoting), admin);

        vm.prank(admin);
        gasPrepaidManager.setRelayer(relayer);

        vm.deal(admin, 1 ether);
    }

    function testDepositFunds() public {
        // Deposit funds as the admin
        uint256 depositAmount = 1 ether;
        vm.deal(admin, depositAmount);
        gasPrepaidManager.depositFunds{value: depositAmount}();

        // Check the balance updates
        assertEq(gasPrepaidManager.balances(admin), depositAmount, "Deposit failed");
    }

    function testWithdrawFunds() public {
        uint256 depositAmount = 1 ether;
        uint256 withdrawAmount = 0.5 ether;
        // Ensure the admin has sufficient balance before depositing
        vm.deal(admin, depositAmount);
        // Deposit funds
        gasPrepaidManager.depositFunds{value: depositAmount}();
        // Capture the admin's balance before withdrawal
        uint256 initialAdminBalance = admin.balance;
        gasPrepaidManager.withdrawFunds(withdrawAmount);


        // Assert the balances after withdrawal
        assertEq(admin.balance, initialAdminBalance + withdrawAmount, "Admin balance mismatch after withdrawal");
        assertEq(gasPrepaidManager.balances(admin), depositAmount - withdrawAmount, "Contract balance mismatch after withdrawal");
    }

    function testWithdrawFundsInsufficientBalance() public {
        vm.expectRevert(abi.encodeWithSelector(
            GasPrepaidManager.InsufficientBalance.selector,
            1 ether, // requested
            0        // available
        ));
        gasPrepaidManager.withdrawFunds(1 ether);
    }

    function testWithdrawFundsAccessControl() public {
        // Switch to an attacker address
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSelector(
            GasPrepaidManager.UnauthorizedAccessAdmin.selector
        ));
        gasPrepaidManager.withdrawFunds(1 ether);
    }

    function testPayGas() public {
        uint256 depositAmount = 1 ether;
        uint256 gasUsed = 100_000;
        uint256 gasPrice = 10 gwei;
        uint256 gasCost = gasUsed * gasPrice;

        // Deposit funds
        gasPrepaidManager.depositFunds{value: depositAmount}();

        // Simulate gas payment
        vm.prank(relayer);
        gasPrepaidManager.payGas(relayer, gasUsed, gasPrice);

        // Assert balances
        assertEq(gasPrepaidManager.balances(admin), depositAmount - gasCost, "Admin balance mismatch.");
        assertEq(relayer.balance, gasCost, "Relayer balance mismatch.");
    }

    function testPayGasInsufficientBalance() public {
        uint256 gasUsed = 1_000_000;
        uint256 gasPrice = 10 gwei;
        uint256 gasCost = gasUsed * gasPrice;

        vm.expectRevert(abi.encodeWithSelector(
            GasPrepaidManager.InsufficientPrepaidBalance.selector,
            gasCost,
            0
        ));
        vm.prank(relayer);
        gasPrepaidManager.payGas(relayer, gasUsed, gasPrice);
    }

    function testPayGasAccessControl() public {
        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSelector(
            GasPrepaidManager.UnauthorizedAccess.selector
        ));
        gasPrepaidManager.payGas(relayer, 100_000, 10 gwei);
    }
}
