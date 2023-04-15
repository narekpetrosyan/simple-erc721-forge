// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ERC721.sol";

contract MyToken {
    ERC721 token;

    constructor() {
        token = new ERC721("MyToken");
    }
}
