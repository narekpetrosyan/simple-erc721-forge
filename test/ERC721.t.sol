// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC721.sol";

error Unauthorized();

contract ERC721Test is Test {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    ERC721 public nft;

    function setUp() public {
        nft = new ERC721("MFER");
    }

    function testName() public {
        assertEq(nft.name(), "MFER");
    }

    function testOwner() public {
        assertEq(nft.owner(), address(this));
    }

    // -------mint
    function testNotOwnerRevertMint() public {
        vm.prank(address(1));
        vm.expectRevert("not an owner");
        nft.mint(address(1337), 1);
    }

    function testMintForCallerRevertMint() public {
        vm.expectRevert("cant mint for caller");
        nft.mint(address(this), 1);
    }

    function testMintForZeroAddressRevertMint() public {
        vm.expectRevert("cant mint for 0 address");
        nft.mint(address(0), 1);
    }

    function testAlreadyMintedRevertMint() public {
        nft.mint(address(123), 1);
        vm.expectRevert("token minted");
        nft.mint(address(234), 1);
    }

    function testEmitEventMint() public {
        vm.expectEmit(false, false, false, false, address(nft));
        emit Transfer(address(0), address(123), 1);
        nft.mint(address(123), 1);
    }

    // -------mint

    // -------transfer ownership
    function testZeroAddressTransferRevertTransferOwnership() public {
        vm.expectRevert("cant transfer ownership");
        nft.transferOwnership(address(0));
    }

    function testSameAddressTransferRevertTransferOwnership() public {
        vm.expectRevert("cant transfer ownership");
        nft.transferOwnership(address(this));
    }

    function testOnlyOwnerRevertTransferOwnership() public {
        vm.prank(address(0));
        vm.expectRevert("not an owner");
        nft.transferOwnership(address(1));
    }

    // -------transfer ownership

    // -------mint
    function testTransfer() public {}

    function testBalanceOf() public {
        nft.mint(address(1337), 1);
        assertEq(nft.balanceOf(address(1337)), 1);
    }

    function testOwnerOf() public {
        nft.mint(address(1337), 1);
        assertEq(nft.ownerOf(1), address(1337));
    }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
