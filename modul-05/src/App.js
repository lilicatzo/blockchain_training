import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import dotenv from 'dotenv';

dotenv.config();

const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS;
const etherscanApiKey = process.env.REACT_APP_ETHERSCAN_API_KEY;


const App = () => {
    const [provider, setProvider] = useState(null);
    const [signer, setSigner] = useState(null);
    const [contract, setContract] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [isConnecting, setIsConnecting] = useState(false); 

    useEffect(() => {
        const fetchABI = async () => {
            try {
                const url = `https://api-sepolia-optimism.etherscan.io/api?module=contract&action=getabi&address=${contractAddress}&apikey=${etherscanApiKey}`;
                const response = await fetch(url);
                const data = await response.json();
                if (data.status === "1") {
                    return JSON.parse(data.result);
                } else {
                    throw new Error(`Failed to fetch ABI: ${data.result}`);
                }
            } catch (error) {
                console.error("Error fetching ABI:", error);
                throw error;
            }
        };

        const connect = async () => {
            if (isConnecting) return; 
            setIsConnecting(true); 

            try {
                if (!window.ethereum) {
                    throw new Error("MetaMask is not installed");
                }
                const provider = new ethers.providers.Web3Provider(window.ethereum);
                const accounts = await provider.listAccounts();
                if (accounts.length === 0) {
                    await provider.send("eth_requestAccounts", []);
                }
                const signer = provider.getSigner();
                const abi = await fetchABI();
                const contract = new ethers.Contract(contractAddress, abi, signer);

                setProvider(provider);
                setSigner(signer);
                setContract(contract);
                setIsLoading(false);
            } catch (error) {
                console.error("Error connecting to Ethereum:", error);
                alert(`Error connecting to Ethereum: ${error.message}`);
            } finally {
                setIsConnecting(false); 
            }
        };

        connect();
    }, [isConnecting]);

    const calculatePrizesProjection = async () => {
      if (!contract) {
          alert("Contract is not initialized");
          return;
      }
  
      try {
          const result = await contract.calculatePrizesProjection();
          const readableResult = result.map(bn => ethers.utils.formatEther(bn)); 
        
          // berdasarkan contants di file Web3Game2048.sol
          const prizeProjection = {
            sixthPrize: readableResult[0] + " ETH", // 1%
            fifthPrize: readableResult[1] + " ETH", // 2%
            fourthPrize: readableResult[2] + " ETH", // 3%
            thirdPrize: readableResult[3] + " ETH", // 5%
            secondPrize: readableResult[4] + " ETH", // 10%
            firstPrize: readableResult[5] + " ETH", // 20%
            grandPrize: readableResult[6] + " ETH", // 50%
            finalRemainingPrizePool: readableResult[7] + " ETH" 
        };
  
          console.log("Prizes Projection:", prizeProjection);
          alert("Prizes Projection: " + JSON.stringify(prizeProjection, null, 2));
      } catch (error) {
          console.error("Error calculating prizes projection:", error);
          alert(`Error calculating prizes projection: ${error.message}`);
      }
  };
  
    const makeMove = async () => {
        if (!contract) {
            alert("Contract is not initialized");
            return;
        }

        try {
            const moveSelect = document.getElementById("moveSelect");
            const moveType = parseInt(moveSelect.value);
            const tx = await contract.makeMove(moveType);
            await tx.wait();
            console.log("Move executed:", tx);
            alert("Move executed");
        } catch (error) {
            console.error("Error making move:", error);
            alert(`Error making move: ${error.message}`);
        }
    };

    return (
        <div>
            {isLoading ? (
                <p>Loading...</p>
            ) : (
                <>
                <h1>Interact with Smart Contract</h1>
                    <button onClick={calculatePrizesProjection}>Calculate Prizes Projection</button>
                    <button onClick={makeMove}>Make Move</button>
                    <select id="moveSelect">

                      {/* dibuat berdasarkan ABI di smart contract */}
                        <option value="0">UP</option>
                        <option value="1">DOWN</option>
                        <option value="2">LEFT</option>
                        <option value="3">RIGHT</option>
                    </select>
                </>
            )}
        </div>
    );
};

export default App;

