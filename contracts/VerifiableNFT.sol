// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VerifiableNFT is ERC721URIStorage, Ownable {
    // Mapping from token ID to the array of verifier addresses
    mapping(uint256 => address[]) private _verifiers;

    // Mapping to store operator addresses
    mapping(address => bool) private _operators;

    // Event to log when a token is verified
    event TokenVerified(uint256 tokenId, address verifier);

    // Event to log when an operator is added or removed
    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);

    // Base URI for metadata
    string private _baseTokenURI;

    constructor(string memory name, string memory symbol, string memory baseURI) ERC721(name, symbol) Ownable(msg.sender) {
        _baseTokenURI = baseURI;  // Set the base URI in the constructor
    }

    /**
     * @dev Modifier to restrict access to only the owner or authorized operators.
     */
    modifier onlyOwnerOrOperator() {
        require(owner() == msg.sender || _operators[msg.sender], "Caller is not owner or operator");
        _;
    }

        /**
     * @dev Modifier to restrict access to only operators.
     */
    modifier onlyOperator() {
        require(isOperator(msg.sender), "Caller is not an operator");
        _;
    }


    /**
     * @dev Function to verify a token by an operator.
     * This function stores the verifier's address in the list for the token.
     * Only callable by authorized operators.
     * @param tokenId The ID of the token being verified.
     */
    function verify(uint256 tokenId) public onlyOperator {
        // Add the verifier (operator) to the list of verifiers for the token
        _verifiers[tokenId].push(msg.sender);

        emit TokenVerified(tokenId, msg.sender);
    }

    /**
     * @dev Returns the list of verifiers for a specific token ID.
     * @param tokenId The ID of the token.
     * @return An array of addresses that verified the token.
     */
    function getVerifiers(uint256 tokenId) public view returns (address[] memory) {
        return _verifiers[tokenId];
    }

    /**
     * @dev Check if an address is an operator.
     * @param operator The address to check.
     * @return True if the address is an operator, false otherwise.
     */
    function isOperator(address operator) public view returns (bool) {
        return _operators[operator];
    }

    /**
     * @dev Owner function to add a new operator.
     * @param operator The address to be granted operator rights.
     */
    function addOperator(address operator) public onlyOwner {
        require(!_operators[operator], "Address is already an operator");
        _operators[operator] = true;

        emit OperatorAdded(operator);
    }

    /**
     * @dev Owner function to remove an operator.
     * @param operator The address to be removed from operator role.
     */
    function removeOperator(address operator) public onlyOwner {
        require(_operators[operator], "Address is not an operator");
        _operators[operator] = false;

        emit OperatorRemoved(operator);
    }

    /**
     * @dev Mint an NFT with a specific metadata URI.
     * Only the owner can mint NFTs.
     * @param to The address to mint the NFT to.
     * @param tokenId The ID of the token to be minted.
     * @param tokenURI The metadata URI for the token.
     */
    function mintWithMetadata(address to, uint256 tokenId, string memory tokenURI) public onlyOwnerOrOperator {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
    
    /**
     * @dev Batch mint multiple NFTs with specific metadata URIs.
     * Only the owner can mint NFTs.
     * @param to Array of addresses to mint the NFTs to.
     * @param tokenIds Array of token IDs to be minted.
     * @param tokenURIs Array of metadata URIs for each token.
     */

    function batchMintWithMetadata(address[] memory to, uint256[] memory tokenIds, string[] memory tokenURIs) public onlyOwnerOrOperator {
        require(to.length == tokenIds.length, "Mismatched input lengths");
        require(to.length == tokenURIs.length, "Mismatched input lengths");

        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], tokenIds[i]);
            _setTokenURI(tokenIds[i], tokenURIs[i]);
        }
    }


    /**
     * @dev Sets the base URI for all tokens.
     * This function can be called only by the owner.
     * @param baseURI The base URI to be set.
     */
    function setBaseURI(string memory baseURI) public onlyOwnerOrOperator {
        _baseTokenURI = baseURI;
    }

    /**
     * @dev Internal function to return the base URI for the metadata.
     * This overrides OpenZeppelin's _baseURI function.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
}
