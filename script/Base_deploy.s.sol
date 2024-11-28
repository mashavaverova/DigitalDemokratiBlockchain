// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {PollsBridge} from "../src/PollsBridge.sol";
import {RightToVote} from "../src/RightToVote.sol";
import {Delegations} from "../src/Delegations.sol";
import {PollHelpers} from "../src/PollHelpers.sol";
import {ProposalHelpers} from "../src/ProposalHelpers.sol";
import {Predictions} from "../src/Predictions.sol";
import {PredictionHelpers} from "../src/PredictionHelpers.sol";
import {PredictionBetHelpers} from "../src/PredictionBetHelpers.sol";
import {PredictionBets} from "../src/PredictionBets.sol";
import {Polls} from "../src/Polls.sol";
import {MetaVoting} from "../src/MetaVoting.sol";
import {GasPrepaidManager} from "../src/GasPrepaidManager.sol";
import {MetaTxHandler} from "../src/MetaTxHandler.sol";

contract Base_deploy is Script {
    // Public contract variables for reference
    Polls public polls;
    MetaVoting public metaVoting;
    GasPrepaidManager public gasPrepaidManager;
    MetaTxHandler public metaTxHandler;
    PollsBridge public pollsBridge;
    RightToVote public rightToVote;
    Delegations public delegations;
    PollHelpers public pollHelpers;
    ProposalHelpers public proposalHelpers;
    Predictions public predictions;
    PredictionHelpers public predictionHelpers;
    PredictionBetHelpers public predictionBetHelpers;
    PredictionBets public predictionBets;

    /**
     * @dev Deployment script for the full system.
     * @param admin The address to be set as the admin/owner for the contracts.
     */
    function run(address admin) external {
        require(admin != address(0), "Admin address cannot be zero");
        console.log("Starting deployment with admin address:", admin);

        vm.startBroadcast();

        // Deploy dependencies
        deployCoreContracts();

        // Link contracts and finalize setup
        linkContracts(admin);

        // Transfer ownership and finalize setup
        finalizeOwnership(admin);

        vm.stopBroadcast();

        console.log("Deployment complete. Polls contract deployed at:", address(polls));
    }

    function deployCoreContracts() internal {
        console.log("Deploying core contracts...");

        // Deploy each core component
        pollsBridge = new PollsBridge();
        console.log("Deployed PollsBridge at:", address(pollsBridge));

        rightToVote = new RightToVote();
        console.log("Deployed RightToVote at:", address(rightToVote));

        delegations = new Delegations();
        console.log("Deployed Delegations at:", address(delegations));

        pollHelpers = new PollHelpers();
        console.log("Deployed PollHelpers at:", address(pollHelpers));

        proposalHelpers = new ProposalHelpers();
        console.log("Deployed ProposalHelpers at:", address(proposalHelpers));

        predictions = new Predictions();
        console.log("Deployed Predictions at:", address(predictions));

        predictionHelpers = new PredictionHelpers();
        console.log("Deployed PredictionHelpers at:", address(predictionHelpers));

        predictionBetHelpers = new PredictionBetHelpers();
        console.log("Deployed PredictionBetHelpers at:", address(predictionBetHelpers));

        predictionBets = new PredictionBets();
        console.log("Deployed PredictionBets at:", address(predictionBets));

        metaVoting = new MetaVoting(address(pollHelpers), address(0));
        console.log("Deployed MetaVoting at:", address(metaVoting));

        gasPrepaidManager = new GasPrepaidManager(address(metaVoting), msg.sender);
        console.log("Deployed GasPrepaidManager at:", address(gasPrepaidManager));

        polls = new Polls();
        console.log("Deployed Polls at:", address(polls));

        metaTxHandler = new MetaTxHandler(address(polls), address(gasPrepaidManager));
        console.log("Deployed MetaTxHandler at:", address(metaTxHandler));

        console.log("Core contracts deployed.");
    }

    function linkContracts(address admin) internal {
        console.log("Linking contracts...");

        // Link GasPrepaidManager to MetaVoting
        metaVoting.setGasPrepaidManager(address(gasPrepaidManager));
        console.log("Linked MetaVoting to GasPrepaidManager:", address(gasPrepaidManager));

        // Link MetaVoting to PollHelpers
        pollHelpers.setMetaVoting(address(metaVoting));
        console.log("Linked PollHelpers to MetaVoting:", address(metaVoting));

        // Set bridge contract in Polls
        polls.setBridgeContract(address(pollsBridge));
        console.log("Linked Polls to PollsBridge:", address(pollsBridge));

        // Set relayer for GasPrepaidManager
        gasPrepaidManager.setRelayer(admin);
        console.log("Set relayer in GasPrepaidManager to:", admin);

        // Link MetaTxHandler in Polls
        polls.setMetaTxHandler(address(metaTxHandler));
        console.log("Linked MetaTxHandler in Polls:", address(metaTxHandler));

        console.log("Contracts linked successfully.");
    }

    function finalizeOwnership(address admin) internal {
        console.log("Finalizing ownership...");

        // Transfer ownership of Polls contract
        polls.transferOwnership(admin);
        console.log("Transferred ownership of Polls to:", admin);

        console.log("Ownership transfer complete.");
    }
}
