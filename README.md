## Description

This repository contains multiple modules related to blockchain development. Below is a brief description of the modules:

- **modul-03**: Contains Solidity code for smart contract development.
- **modul-04**: Contains additional Solidity code for advanced smart contract features.
- **modul-05**: Contains a web application interacting with a particular hardcoded smart contract using `ethers.js`. This module is the focus of this README.

## Setup Instructions for modul-05

### Prerequisites

Make sure you have the following installed on your machine:
- Node.js (v14.x or higher)
- npm (v6.x or higher)

### Step-by-Step Guide

1. **Clone the Repository**

    ```bash
    git clone https://github.com/lilicatzo/blockchain_training.git
    cd blockchain_training
    ```

2. **Navigate to `modul-05` Directory**

    ```bash
    cd modul-05
    ```

3. **Install Dependencies**

    Run the following command to install all necessary dependencies:

    ```bash
    npm install
    ```

4. **Create `.env` File**

    Create a `.env` file in the `modul-05` directory with the following template:

    ```plaintext
    REACT_APP_CONTRACT_ADDRESS=0xe4EE33F790f790950E0064E0E5aC474BE36d577F
    REACT_APP_ETHERSCAN_API_KEY=your_etherscan_api_key
    ```

    Replace `your_etherscan_api_key` with your actual Etherscan API key.

5. **Run the Application**

    Start the application by running:

    ```bash
    npm start
    ```

    This will start the development server and open the application in your default web browser.


### Using the `makeMove` Function


To use the `makeMove` function within the application, you will need to:

1. **Connect MetaMask**

    Ensure you have the MetaMask extension installed in your web browser and are connected to your Ethereum wallet.

2. **Execute a Move**

    When you execute a move, you will be prompted by MetaMask to confirm the transaction and pay the necessary gas fees.

    **Note**: Each move requires a small amount of ETH to cover the gas fees for the transaction on the Ethereum blockchain.

