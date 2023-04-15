// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC721.sol";

contract ERC721 is IERC721 {
    string public name;
    address public owner;

    mapping(address => uint) _balances;
    mapping(uint => address) _owners;
    mapping(uint => address) _tokenApprovals;
    mapping(address => mapping(address => bool)) _operatorApprovals;

    constructor(string memory _name) {
        name = _name;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    function transferOwnership(address _to) external onlyOwner {
        require(
            _to != msg.sender && _to != address(0),
            "cant transfer ownership"
        );
        owner = _to;
    }

    function mint(address _to, uint256 _tokenId) external onlyOwner {
        require(_to != address(0), "cant mint for 0 address");
        require(_to != msg.sender, "cant mint for caller");
        require(ownerOf(_tokenId) == address(0), "token minted");
        _balances[_to]++;
        _owners[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return _owners[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(_isApprovedOrOwner(_to, _tokenId), "not an owner or approved");

        require(ownerOf(_tokenId) == _from, "not an owner of token");
        require(_to != address(0), "cannot transfer to zero address");

        _balances[_from]--;
        _balances[_to]++;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        address _owner = ownerOf(_tokenId);
        require(_owner == msg.sender, "not an owner");
        require(_owner != _approved, "cant approve to caller");
        _tokenApprovals[_tokenId] = _approved;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(_balances[msg.sender] != 0, "");
        require(msg.sender != _operator, "");
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function _isApprovedOrOwner(
        address _spender,
        uint _tokenId
    ) internal view returns (bool) {
        address _ownerOfToken = ownerOf(_tokenId);

        require(
            _ownerOfToken == _spender ||
                isApprovedForAll(_ownerOfToken, _spender) ||
                getApproved(_tokenId) == _spender,
            "Not an owner or approved"
        );
    }
}
