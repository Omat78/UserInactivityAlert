`## Overview
// The AI MUST generate a 2-3 sentence, well-written description of what this specific trap monitors and why it's critical.
This trap monitors user activity and alerts when a user has been inactive for a defined period, ensuring timely notifications to maintain engagement.

---

## What It Does
* Monitors user activity timestamps.
* Triggers an alert if the user is inactive for more than 1 day.
* It demonstrates the essential Drosera trap pattern using deterministic logic.

---

## Key Files
* `src/UserInactivityAlert.sol` - The core trap contract containing the monitoring logic.
* `src/SimpleResponder.sol` - The required external response contract.
* `drosera.toml` - The deployment and configuration file.

---

## Detection Logic

The trap's core monitoring logic is contained in the deterministic `shouldRespond()` function.

solidity
// The AI MUST insert the full, syntax-highlighted Solidity code of the `shouldRespond()` logic here.
if (block.timestamp - current.lastActivity > INACTIVITY_PERIOD) {
    return (true, bytes("User inactive for too long!"));
}
 

---

## :test_tube: Implementation Details and Key Concepts
* **Monitoring Target:** Watching user activity timestamps.
* **Deterministic Logic:** Uses the `view` modifier to ensure off-chain execution for consensus.
* **Calculation/Thresholds:** Monitors inactivity for a period of 1 day.
* **Response Mechanism:** On trigger, the trap calls the external Responder contract, demonstrating the separation of monitoring and action.

---

## Test It
To verify the trap logic using Foundry, run the following command (assuming a test file has been created):

bash
forge test --match-contract UserInactivityAlert`
