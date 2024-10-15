# Table of Contents


- [Table of Contents](#table-of-contents)
- [Work Done](#work-done)
- [In Progress](#in-progress)
- [Next Steps](#next-steps)
- [Static Analys and Bug Fxing Summary](#static-analys-and-bug-fxing-summary)
	- [Files Summary](#files-summary)
	- [Files Details](#files-details)
	- [Issue Summary](#issue-summary)
- [High Issues](#high-issues)
	- [H-1: Uninitialized State Variables   FIXED](#h-1-uninitialized-state-variables---fixed)
	- [H-2: Return value of the function call is not checked.  NOT AN ISSUE, INSIDE A MODIFIER](#h-2-return-value-of-the-function-call-is-not-checked--not-an-issue-inside-a-modifier)
- [Low Issues](#low-issues)
	- [L-1: Solidity pragma should be specific, not wide   FIXED](#l-1-solidity-pragma-should-be-specific-not-wide---fixed)
	- [L-2: `public` functions not used internally could be marked `external`  FIXED](#l-2-public-functions-not-used-internally-could-be-marked-external--fixed)
	- [L-3: Event is missing `indexed` fields   FIXED](#l-3-event-is-missing-indexed-fields---fixed)
	- [L-4: Empty `require()` / `revert()` statements FIXED](#l-4-empty-require--revert-statements-fixed)
	- [L-5: PUSH0 is not supported by all chains  FIXED](#l-5-push0-is-not-supported-by-all-chains--fixed)
	- [L-6: Internal functions called only once can be inlined  PARTLY FIXED](#l-6-internal-functions-called-only-once-can-be-inlined--partly-fixed)
	- [L-7: Uninitialized local variables.  FIXED](#l-7-uninitialized-local-variables--fixed)
	- [L-8: Costly operations inside loops.  !!!!! CHECK IN THE END!!!!](#l-8-costly-operations-inside-loops---check-in-the-end)
	- [L-9: State variable changes but no event is emitted. FIXED](#l-9-state-variable-changes-but-no-event-is-emitted-fixed)
	- [L-10: Timestamp comparisons used for critical logic may be manipulated by miners.   DOUBLE CHECK](#l-10-timestamp-comparisons-used-for-critical-logic-may-be-manipulated-by-miners---double-check)
	- [L-11: High Cyclomatic Complexity ?REWRITE??](#l-11-high-cyclomatic-complexity-rewrite)


# Work Done
 - Documentation 
 - Static Analys and Bug fixing
 - Gas optimisation 
 - Naming 
   
# In Progress 
- Unit Tests coverage 
- Dynamic Tests 

# Next Steps
- Finish bug fixing and optimisation
- Upd documentations 
- Zero Knowlege Poof implimentation 

# Static Analys and Bug Fxing Summary

## Files Summary

| Key | Value |
| --- | --- |
| .sol Files | 9 |
| Total nSLOC | 571 |


## Files Details

| Filepath | nSLOC |
| --- | --- |
| src/Delegations.sol | 185 |
| src/PollHelpers.sol | 66 |
| src/Polls.sol | 128 |
| src/PredictionBetHelpers.sol | 14 |
| src/PredictionBets.sol | 42 |
| src/PredictionHelpers.sol | 25 |
| src/Predictions.sol | 21 |
| src/ProposalHelpers.sol | 53 |
| src/RightToVote.sol | 37 |
| **Total** | **571** |


## Issue Summary

| Category | No. of Issues |
| --- | --- |
| High | 2 |
| Low | 11 |



# High Issues

## H-1: Uninitialized State Variables   FIXED

Solidity does initialize variables by default when you declare them, however it's good practice to explicitly declare an initial value. For example, if you transfer money to an address we must make sure that the address has been initialized.

<details><summary>1 Found Instances</summary>


- Found in src/PollHelpers.sol [Line: 49](src/PollHelpers.sol#L49)

	```solidity
	    uint256 public pollCount;
	```

</details>



## H-2: Return value of the function call is not checked.  NOT AN ISSUE, INSIDE A MODIFIER 
Function returns a value but it is ignored.

<details><summary>2 Found Instances</summary>


- Found in src/PredictionBets.sol [Line: 33](src/PredictionBets.sol#L33)

	```solidity
	        requireProposalToExist(_pollId, _proposalId);
	```

- Found in src/PredictionBets.sol [Line: 34](src/PredictionBets.sol#L34)

	```solidity
	        requirePredictionToExist(_proposalId, _predictionId);
	```

</details>


◊
# Low Issues

## L-1: Solidity pragma should be specific, not wide   FIXED 

Consider using a specific version of Solidity in your contracts instead of a wide version. For example, instead of `pragma solidity ^0.8.0;`, use `pragma solidity 0.8.0;`

<details><summary>9 Found Instances</summary>


- Found in src/Delegations.sol [Line: 2](src/Delegations.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PollHelpers.sol [Line: 2](src/PollHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/Polls.sol [Line: 2](src/Polls.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionBetHelpers.sol [Line: 2](src/PredictionBetHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionBets.sol [Line: 2](src/PredictionBets.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionHelpers.sol [Line: 2](src/PredictionHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/Predictions.sol [Line: 2](src/Predictions.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/ProposalHelpers.sol [Line: 2](src/ProposalHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/RightToVote.sol [Line: 2](src/RightToVote.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

</details>



## L-2: `public` functions not used internally could be marked `external`  FIXED

Instead of marking a function as `public`, consider marking it as `external` if it is not used internally.

<details><summary>14 Found Instances</summary>


- Found in src/Delegations.sol [Line: 112](src/Delegations.sol#L112)

	```solidity
	    function becomeDelegate(uint256 _groupId) public {
	```

- Found in src/Delegations.sol [Line: 144](src/Delegations.sol#L144)

	```solidity
	    function delegate(uint256 _groupId, address _delegateTo) public requireAddressIsDelegate(_groupId, _delegateTo) {
	```

- Found in src/Delegations.sol [Line: 181](src/Delegations.sol#L181)

	```solidity
	    function removeDelegation(address _delegate, uint256 _groupId) public {
	```

- Found in src/Delegations.sol [Line: 223](src/Delegations.sol#L223)

	```solidity
	    function resignAsDelegate(uint256 _groupId) public requireAddressIsDelegate(_groupId, msg.sender) {
	```

- Found in src/PollHelpers.sol [Line: 65](src/PollHelpers.sol#L65)

	```solidity
	    function getPoll(uint256 _pollId) public view returns (Poll memory) {
	```

- Found in src/Polls.sol [Line: 47](src/Polls.sol#L47)

	```solidity
	    function createPoll(
	```

- Found in src/Polls.sol [Line: 93](src/Polls.sol#L93)

	```solidity
	    function vote(uint256 _pollId, uint256 _proposalId, uint8 _score) public {
	```

- Found in src/Polls.sol [Line: 131](src/Polls.sol#L131)

	```solidity
	    function voteAsDelegate(uint256 _pollId, uint256 _proposalId, uint8 _score) public {
	```

- Found in src/Predictions.sol [Line: 32](src/Predictions.sol#L32)

	```solidity
	    function createPrediction(uint256 _pollId, uint256 _proposalId, string memory _prediction) public {
	```

- Found in src/ProposalHelpers.sol [Line: 47](src/ProposalHelpers.sol#L47)

	```solidity
	    function addProposal(uint256 _pollId, string calldata _description) public {
	```

- Found in src/ProposalHelpers.sol [Line: 67](src/ProposalHelpers.sol#L67)

	```solidity
	    function getPollResults(uint256 _pollId)
	```

- Found in src/RightToVote.sol [Line: 38](src/RightToVote.sol#L38)

	```solidity
	    function becomeMemberOfGroup(uint256 _group) public {
	```

- Found in src/RightToVote.sol [Line: 50](src/RightToVote.sol#L50)

	```solidity
	    function removeGroupMembership(uint256 _group) public {
	```

- Found in src/RightToVote.sol [Line: 84](src/RightToVote.sol#L84)

	```solidity
	    function getGroupsUserIsMemberIn() public view returns (uint256[] memory) {
	```

</details>



## L-3: Event is missing `indexed` fields   FIXED 

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

<details><summary>7 Found Instances</summary>


- Found in src/Delegations.sol [Line: 56](src/Delegations.sol#L56)

	```solidity
	    event NewDelegate(
	```

- Found in src/Polls.sol [Line: 32](src/Polls.sol#L32)

	```solidity
	    event PollCreated(uint256 pollId, string title);
	```

- Found in src/Polls.sol [Line: 84](src/Polls.sol#L84)

	```solidity
	    event VoteSubmitted(uint256 indexed pollId, address indexed voter, uint256 votesForProposal);
	```

- Found in src/PredictionBets.sol [Line: 23](src/PredictionBets.sol#L23)

	```solidity
	    event PredictionBetCreated(uint256 indexed predictionId, bool bet, uint256 likelihood);
	```

- Found in src/Predictions.sol [Line: 23](src/Predictions.sol#L23)

	```solidity
	    event PredictionCreated(uint256 pollId, uint256 proposalId, uint256 predictionId, string prediction);
	```

- Found in src/ProposalHelpers.sol [Line: 39](src/ProposalHelpers.sol#L39)

	```solidity
	    event ProposalAdded(uint256 indexed pollId, uint256 proposalId, string description);
	```

- Found in src/RightToVote.sol [Line: 31](src/RightToVote.sol#L31)

	```solidity
	    event GroupMembershipChanged(address indexed user, uint256 indexed group, bool isMember);
	```

</details>



## L-4: Empty `require()` / `revert()` statements FIXED 

Use descriptive reason strings or custom errors for revert paths.

<details><summary>2 Found Instances</summary>


- Found in src/Polls.sol [Line: 100](src/Polls.sol#L100)

	```solidity
	        require(requireProposalToExist(_pollId, _proposalId));
	```

- Found in src/Polls.sol [Line: 140](src/Polls.sol#L140)

	```solidity
	        require(requireProposalToExist(_pollId, _proposalId));
	```

</details>



## L-5: PUSH0 is not supported by all chains  FIXED 

Solc compiler version 0.8.20 switches the default target EVM version to Shanghai, which means that the generated bytecode will include PUSH0 opcodes. Be sure to select the appropriate EVM version in case you intend to deploy on a chain other than mainnet like L2 chains that may not support PUSH0, otherwise deployment of your contracts will fail.

<details><summary>9 Found Instances</summary>


- Found in src/Delegations.sol [Line: 2](src/Delegations.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PollHelpers.sol [Line: 2](src/PollHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/Polls.sol [Line: 2](src/Polls.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionBetHelpers.sol [Line: 2](src/PredictionBetHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionBets.sol [Line: 2](src/PredictionBets.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/PredictionHelpers.sol [Line: 2](src/PredictionHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/Predictions.sol [Line: 2](src/Predictions.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/ProposalHelpers.sol [Line: 2](src/ProposalHelpers.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

- Found in src/RightToVote.sol [Line: 2](src/RightToVote.sol#L2)

	```solidity
	pragma solidity ^0.8.18;
	```

</details>



## L-6: Internal functions called only once can be inlined  PARTLY FIXED 

Instead of separating the logic into a separate function, consider inlining the logic into the calling function. This can reduce the number of function calls and improve readability.

<details><summary>5 Found Instances</summary>


- Found in src/PollHelpers.sol [Line: 56](src/PollHelpers.sol#L56)  (need to be inlined?) 

	```solidity
	    function controlProposalEndDate(uint256 _pollId) internal view {
	```

- Found in src/PollHelpers.sol [Line: 96](src/PollHelpers.sol#L96)

	```solidity
	    function requireMaxVoteScoreWithinRange(uint8 _maxVoteScore) internal pure {
	```

- Found in src/PollHelpers.sol [Line: 115](src/PollHelpers.sol#L115)

	```solidity
	    function hasVoted(uint256 _pollId) internal view returns (bool voted) {
	```

- Found in src/PollHelpers.sol [Line: 134](src/PollHelpers.sol#L134)

	```solidity
	    function hasVotedAsDelegate(uint256 _pollId) internal view returns (bool voted) {
	```

- Found in src/PredictionHelpers.sol [Line: 39](src/PredictionHelpers.sol#L39)

	```solidity
	    function requirePredictionToExist(uint256 _proposalId, uint256 _predictionId)
	```

</details>



## L-7: Uninitialized local variables.  FIXED 

Initialize all the variables. If a variable is meant to be initialized to zero, explicitly set it to zero to improve code readability.

<details><summary>14 Found Instances</summary>


- Found in src/Delegations.sol [Line: 160](src/Delegations.sol#L160)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 188](src/Delegations.sol#L188)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 192](src/Delegations.sol#L192)

	```solidity
	                for (uint256 k; k < groupDelegates[_groupId][i].delegationsFrom.length;) {
	```

- Found in src/Delegations.sol [Line: 208](src/Delegations.sol#L208)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 228](src/Delegations.sol#L228)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 239](src/Delegations.sol#L239)

	```solidity
	        for (uint256 i; i < affectedUsers.length; i++) {
	```

- Found in src/Delegations.sol [Line: 241](src/Delegations.sol#L241)

	```solidity
	            for (uint256 k; k < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 262](src/Delegations.sol#L262)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 298](src/Delegations.sol#L298)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 301](src/Delegations.sol#L301)

	```solidity
	                for (uint256 k; k < arrayLength;) {
	```

- Found in src/PollHelpers.sol [Line: 118](src/PollHelpers.sol#L118)

	```solidity
	        for (uint256 i; i < addresses.length;) {
	```

- Found in src/PollHelpers.sol [Line: 137](src/PollHelpers.sol#L137)

	```solidity
	        for (uint256 i; i < addresses.length;) {
	```

- Found in src/Polls.sol [Line: 147](src/Polls.sol#L147)

	```solidity
	        for (uint256 i; i < pollGroupLength;) {
	```

- Found in src/Polls.sol [Line: 157](src/Polls.sol#L157)

	```solidity
	        for (uint256 i; i < delegatingAddresses.length; i++) {
	```

</details>



## L-8: Costly operations inside loops.  !!!!! CHECK IN THE END!!!!

Invoking `SSTORE`operations in loops may lead to Out-of-gas errors. Use a local variable to hold the loop computation result.

<details><summary>10 Found Instances</summary>


- Found in src/Delegations.sol [Line: 160](src/Delegations.sol#L160)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 188](src/Delegations.sol#L188)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 192](src/Delegations.sol#L192)

	```solidity
	                for (uint256 k; k < groupDelegates[_groupId][i].delegationsFrom.length;) {
	```

- Found in src/Delegations.sol [Line: 208](src/Delegations.sol#L208)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 228](src/Delegations.sol#L228)

	```solidity
	        for (uint256 i; i < arrayLength;) {
	```

- Found in src/Delegations.sol [Line: 239](src/Delegations.sol#L239)

	```solidity
	        for (uint256 i; i < affectedUsers.length; i++) {
	```

- Found in src/Delegations.sol [Line: 241](src/Delegations.sol#L241)

	```solidity
	            for (uint256 k; k < arrayLength;) {
	```

- Found in src/Polls.sol [Line: 108](src/Polls.sol#L108)

	```solidity
	        for (uint256 i; i < proposalsLength;) {
	```

- Found in src/Polls.sol [Line: 173](src/Polls.sol#L173)

	```solidity
	        for (uint256 i; i < proposalsLength;) {
	```

- Found in src/RightToVote.sol [Line: 62](src/RightToVote.sol#L62)

	```solidity
	        for (; index < voters[msg.sender].memberGroups.length - 1; index++) {
	```

</details>



## L-9: State variable changes but no event is emitted. FIXED

State variable changes in this function but no event is emitted.

<details><summary>1 Found Instances</summary>


- Found in src/Delegations.sol [Line: 181](src/Delegations.sol#L181)

	```solidity
	    function removeDelegation(address _delegate, uint256 _groupId) public {
	```

</details>


## L-10: Timestamp comparisons used for critical logic may be manipulated by miners.   DOUBLE CHECK

Comparisons involving block timestamps are used in this function, which could be manipulated by miners, potentially leading to undesirable behavior in the contract.

<details><summary>2 Found Instances</summary>

- Found in src/PollHelpers.sol [Line: 55]

```solidity
function controlProposalEndDate(uint256 _pollId) internal view {
    if (polls[_pollId].proposalEndDate <= block.timestamp) {
        revert PH_ProposalPhaseEnded(_pollId, polls[_pollId].proposalEndDate, block.timestamp);
    }
}
```

- Found in src/PollHelpers.sol [Line: 55]

```solidity
Copy code
function isVotingOpen(uint256 _pollId) internal view {
    if (polls[_pollId].votingStartDate >= block.timestamp || polls[_pollId].endDate <= block.timestamp) {
        revert PH_VotingNotAllowed(_pollId, polls[_pollId].votingStartDate, polls[_pollId].endDate, block.timestamp);
    }
}
```
</details>

## L-11: High Cyclomatic Complexity ?REWRITE?? 

The function voteAsDelegate(uint256, uint256, uint8) has a high cyclomatic complexity of 15, meaning the function has too many independent execution paths, making it harder to maintain and increasing the risk of bugs. Functions with high cyclomatic complexity are difficult to test and understand due to the numerous conditionals and loops.

<details><summary>1 Found Instance</summary>

- Found in src/Polls.sol [Lines: 152-230]
  
</details>