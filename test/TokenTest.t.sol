//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MyToken} from "../src/ERC-20 Token.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {Ownable} from "../src/Ownable.sol";
import {Pausable} from "../src/Pausable.sol";

contract TokenTest is Test {
    uint256 public constant INITIAL_SUPPLY = 1000_000;
    uint256 private constant OLAF_STARTING_BALANCE = 100 ether;

    address public fiora;
    address public olaf;

    MyToken public token;
    DeployToken public deployer;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        deployer = new DeployToken();
        token = new MyToken(INITIAL_SUPPLY, "MyToken", "MTK");

        fiora = makeAddr("fiora");
        olaf = makeAddr("olaf");

        token.transfer(olaf, OLAF_STARTING_BALANCE);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.prank(olaf);
        vm.expectRevert(Ownable.Ownable__NotOwner.selector);
        token.mint(olaf, 1000 ether);
    }

    function testTransferRevertsWhenAddressInvalid() public {
        vm.prank(olaf);
        vm.expectRevert(MyToken.MyToken__InvalidAddress.selector);
        token.transfer(address(0), 50 ether);
    }

    function testTransferRevertsWhenBalanceInsufficient() public {
        vm.prank(olaf);
        vm.expectRevert(MyToken.MyToken__InsufficientBalance.selector);
        token.transfer(fiora, 200 ether);
    }

    function testTransferRemovesTokensFromSenderAndAddsToRecipient() public {
        uint256 transferAmount = 50 ether;
        uint256 olafStartingBalance = token.balanceOf(olaf);
        uint256 fioraStartingBalance = token.balanceOf(fiora);

        vm.prank(olaf);
        token.transfer(fiora, transferAmount);
        assertEq(token.balanceOf(olaf), olafStartingBalance - transferAmount);
        assertEq(token.balanceOf(fiora), fioraStartingBalance + transferAmount);
    }

    function testTransferEmitsEvent() public {
        uint256 transferAmount = 25 ether;
        vm.prank(olaf);
        vm.expectEmit(true, true, false, true);
        emit Transfer(olaf, fiora, transferAmount);
        token.transfer(fiora, transferAmount);
    }

    function testOwnerCanMintTokens() public {
        uint256 mintAmount = 500 ether;
        uint256 ownerStartingBalance = token.balanceOf(address(this));
        uint256 startingTotalSupply = token.totalSupply();

        token.mint(address(this), mintAmount);

        assertEq(token.balanceOf(address(this)), ownerStartingBalance + mintAmount);
        assertEq(token.totalSupply(), startingTotalSupply + mintAmount);
    }

    function testMintRevertsWhenAddressInvalid() public {
        uint256 mintAmount = 500 ether;
        vm.expectRevert(MyToken.MyToken__InvalidAddress.selector);
        token.mint(address(0), mintAmount);
    }

    function testOwnerCanBurnTokens() public {
        uint256 burnAmount = 200 ether;
        uint256 ownerStartingBalance = token.balanceOf(address(this));
        uint256 startingTotalSupply = token.totalSupply();
        token.burn(burnAmount);
        assertEq(token.balanceOf(address(this)), ownerStartingBalance - burnAmount);
        assertEq(token.totalSupply(), startingTotalSupply - burnAmount);
    }

    function testBurnRevertsWhenAmountExceedsBalance() public {
        uint256 burnAmount = token.balanceOf(address(this)) + 1 ether;
        vm.expectRevert(MyToken.MyToken__BurnAmountExceedsBalance.selector);
        token.burn(burnAmount);
    }

    function testTransferFromRevertsWhenAllowanceExceeded() public {
        uint256 transferAmount = 10 ether;
        vm.prank(olaf);
        vm.expectRevert(MyToken.MyToken__AllowanceExceeded.selector);
        token.transferFrom(olaf, fiora, transferAmount);
    }

    function testTransferFromRevertsWhenBalanceInsufficient() public {
        uint256 approveAmount = 100 ether;
        uint256 transferAmount = 150 ether;

        vm.prank(olaf);
        token.approve(address(this), approveAmount);

        vm.expectRevert(MyToken.MyToken__InsufficientBalance.selector);
        token.transferFrom(olaf, fiora, transferAmount);
    }

    function testApproveAndTransferFromWorks() public {
        uint256 approveAmount = 100 ether;
        uint256 transferAmount = 60 ether;

        vm.prank(olaf);
        token.approve(address(this), approveAmount);

        uint256 fioraStartingBalance = token.balanceOf(fiora);
        uint256 olafStartingBalance = token.balanceOf(olaf);

        token.transferFrom(olaf, fiora, transferAmount);

        assertEq(token.balanceOf(fiora), fioraStartingBalance + transferAmount);
        assertEq(token.balanceOf(olaf), olafStartingBalance - transferAmount);
        assertEq(token.allowance(olaf, address(this)), approveAmount - transferAmount);
    }

    function testTransferIsHaltedWhenPaused() public {
        uint256 transferAmount = 10 ether;

        token.pause();

        vm.prank(olaf);
        vm.expectRevert(Pausable.Pausable__ContractPaused.selector);
        token.transfer(fiora, transferAmount);
    }

    function testApproveIsHaltedWhenPaused() public {
        uint256 approveAmount = 20 ether;

        token.pause();

        vm.prank(olaf);
        vm.expectRevert(Pausable.Pausable__ContractPaused.selector);
        token.approve(address(this), approveAmount);
    }

    function testTransferFromIsHaltedWhenPaused() public {
        uint256 approveAmount = 30 ether;
        uint256 transferAmount = 15 ether;

        vm.prank(olaf);
        token.approve(address(this), approveAmount);

        token.pause();

        vm.expectRevert(Pausable.Pausable__ContractPaused.selector);
        token.transferFrom(olaf, fiora, transferAmount);
    }

    function testOnlyOwnerCanPauseAndUnpause() public {
        vm.prank(olaf);
        vm.expectRevert(Ownable.Ownable__NotOwner.selector);
        token.pause();

        token.pause();

        vm.prank(olaf);
        vm.expectRevert(Ownable.Ownable__NotOwner.selector);
        token.unpause();

        token.unpause();
    }

    function testCannotPauseWhenAlreadyPaused() public {
        token.pause();

        vm.expectRevert(Pausable.Pausable__ContractPaused.selector);
        token.pause();
    }

    function testCannotUnpauseWhenNotPaused() public {
        vm.expectRevert(Pausable.Pausable__ContractNotPaused.selector);
        token.unpause();
    }

    function testUnpauseResumesFunctionality() public {
        uint256 transferAmount = 10 ether;

        token.pause();
        token.unpause();

        vm.prank(olaf);
        token.transfer(fiora, transferAmount);

        assertEq(token.balanceOf(fiora), transferAmount);
    }

    function testPausableStateIsCorrect() public {
        assertEq(token.paused(), false);
        token.pause();
        assertEq(token.paused(), true);
        token.unpause();
        assertEq(token.paused(), false);
    }

    function testOwnershipTransfer() public {
        vm.prank(address(this));
        token.transferOwnership(olaf);
        assertEq(token.owner(), olaf);
    }

    function testOwnershipTransferRevertsForInvalidAddress() public {
        vm.expectRevert(Ownable.Ownable__InvalidOwnershipAssignment.selector);
        token.transferOwnership(address(0));
    }

    function testRenounceOwnership() public {
        vm.prank(address(this));
        token.renounceOwnership();
        assertEq(token.owner(), address(0));
    }
}
