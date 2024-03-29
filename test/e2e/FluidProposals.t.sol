// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/FluidProposals.sol";

contract FluidProposalsE2E is Test {
    FluidProposals c;

    address cv = vm.envAddress("CONVICTION_VOTING_APP");
    address superfluid = vm.envAddress("SUPERFLUID_APP");
    address superToken = vm.envAddress("SUPER_TOKEN");
    
    address fp = 0x77af4F40D013670a9285E6EBA6774Ff746df6aF0;
    address owner = 0x5CfAdf589a694723F9Ed167D647582B3Db3b33b3;

    string GNOSIS_RPC_URL = vm.envOr("GNOSIS_RPC_URL", string("https://rpc.ankr.com/gnosis"));

    function setUp() public {
        // run the setup scripts
        vm.createSelectFork(GNOSIS_RPC_URL);

        c = FluidProposals(fp);

        vm.label(owner, "owner");
        vm.label(fp, "fp");
        vm.label(cv, "cv");
        vm.label(superfluid, "superfluid");
        vm.label(superToken, "superToken");
   }


    function testSyncTokens() public {
        vm.prank(owner);
        c.syncSupertoken();
    }
}