#!/bin/bash

# Indicate the start of the script
echo "Script execution started..."


# Prompt to confirm Ubuntu version
echo "Are you using Ubuntu 20.04? (y/n)"
read answer

if [ "$answer" != "y" ]; then
  echo "The script can only be run on Ubuntu 20.04. Exiting..."
  exit 1
fi
# 1. Update the system and install necessary dependencies
echo "Step 1: Updating system and installing required dependencies..."
if ! sudo apt update || !  sudo apt install git build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev python3 ccache doxygen graphviz -y ; then
  echo "Error: Failed to install dependencies. Please check your network or the required packages."
  exit 1
fi

# 2. Navigate to the home directory
echo "Step 2: Navigating to the home directory..."
if ! cd ~; then
  echo "Error: Unable to return to the home directory."
  exit 1
fi

# 3. Clone the monero-classic repository
echo "Step 3: Cloning the monero-classic repository..."
if ! git clone --recursive https://github.com/monero-classic-lab/monero-classic-v4.git; then
  echo "Error: Failed to clone the repository. Please check your network connection."
  exit 1
fi

# 4. Initialize and update the submodules
echo "Step 4: Initializing and updating the repository submodules..."
if ! cd monero-classic-v4 || ! git submodule init || ! git submodule update; then
  echo "Error: Failed to initialize or update submodules."
  exit 1
fi

# 5. Create the build directory and enter it
echo "Step 5: Creating and entering the build directory..."
if ! mkdir build || ! cd build; then
  echo "Error: Failed to create or navigate to the build directory."
  exit 1
fi

# 6. Configure the project using CMake
echo "Step 6: Configuring the project using CMake..."
if ! cmake .. -DMANUAL_SUBMODULES=1; then
  echo "Error: Failed to configure the project."
  exit 1
fi

# 7. Compile the project
echo "Step 7: Compiling the project..."
if ! make; then
  echo "Error: Failed to compile the project."
  exit 1
fi

# 8. Enter the bin directory
echo "Step 8: Entering the bin directory..."
if ! cd bin; then
  echo "Error: Failed to enter the bin directory."
  exit 1
fi

# 9. Start the Monero Classic daemon
echo "Step 9: Starting the Monero Classic daemon..."
if ! ./moneroclassicd --data-dir BD --detach; then
  echo "Error: Failed to start the Monero Classic daemon."
  exit 1
fi

# 10. Start the Monero Classic wallet CLI
echo "Step 10: Starting the Monero Classic wallet CLI..."
if ! ./moneroclassic-wallet-cli; then
  echo "Error: Failed to start the Monero Classic wallet CLI."
  exit 1
fi

# Indicate to the user how to monitor the logs
echo "Monero Classic daemon has started! If you wish to monitor the logs, open a new terminal and run the following command:"
echo "tail -f ~/.bitmoneroclassic/bitmoneroclassic.log"

# Indicate the completion of the script
echo "Script execution completed!"

