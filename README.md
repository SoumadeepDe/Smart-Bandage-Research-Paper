# **Smart Bandage Research Project**

The **Smart Bandage Research Project** integrates advanced sensors, machine learning, and wireless communication to monitor wound healing in real-time. This system is designed to provide healthcare providers with actionable insights by tracking critical wound parameters such as temperature, humidity, gas resistance, and pH levels. The **Central Unit (CU)** coordinates communication with multiple smart bandages, sending commands to manage operations, collect data, and maintain a scalable network.

---

## **Project Overview**

The smart bandage system includes:
- **Smart Bandages**: Wearable devices with embedded sensors and BLE communication capabilities.
- **Central Unit (CU)**: A coordinating hub that sends commands to the bandages, retrieves data, and processes it for actionable insights.
- **Wireless Communication**: BLE is used for efficient data transmission between the CU and bandages.

---

## **Repository Structure**

### 1. **Battery Simulation**
Contains MATLAB scripts for simulating battery performance, optimizing power usage to extend the smart bandage’s lifespan.

### 2. **Programming CPU2 on WB55**
Provides code examples and instructions for programming the WB55 microcontroller's secondary CPU (CPU2), a critical component of the bandage’s operations.

### 3. **Software Functional Philosophy**
Outlines the system’s modular design, focusing on efficient communication, sensor data acquisition, and machine learning integration.

---

## **Command Communication: Central Unit and Smart Bandages**

### **Overview**
The Central Unit (CU) serves as the command hub, coordinating with multiple smart bandages in the network. Commands sent by the CU control the following operations:
1. **Device Discovery**: Ensures all bandages in the network are identified and connected.
2. **Data Collection**: Triggers the bandages to send sensor data to the CU for processing.
3. **Operational Management**: Commands such as firmware updates and sensor reinitialization.

---

### **Key Commands**

#### **LookForLeaf Command**
- **Purpose**:
  - Sent by the CU to discover active smart bandages in the network.
  - Ensures the scalability of the system by efficiently identifying devices in large-scale deployments.
- **Operation**:
  - The CU broadcasts the `LookForLeaf` command across its network.
  - Smart bandages respond by transmitting their unique identifiers, status, and connectivity details.
- **Significance**:
  - Maintains network integrity by detecting new, dormant, or disconnected bandages.
  - Reduces redundant communication, optimizing bandwidth and power usage.

#### **StartDataAcquisition Command**
- **Purpose**:
  - Instructs smart bandages to begin sensor data collection.
- **Operation**:
  - Bandages activate their sensors to measure parameters such as temperature, humidity, and pH.
  - Data is queued and sent back to the CU for processing.

#### **UpdateFirmware Command**
- **Purpose**:
  - Enables remote firmware updates for the smart bandages, ensuring they remain up-to-date.
- **Operation**:
  - The CU transfers the new firmware to the bandages in chunks.
  - Bandages verify and install the update.

#### **ReinitializeSensor Command**
- **Purpose**:
  - Resets and reinitializes specific sensors on the bandage in case of errors or calibration needs.

---

## **Key Features of the System**

### **Sensors**
- **Temperature Monitoring**: Detects potential infections.
- **Humidity Tracking**: Ensures optimal healing conditions.
- **Gas Resistance Measurement**: Provides diagnostic insights into wound status.
- **pH Sensing**: Tracks wound acidity to detect complications.

### **Machine Learning Integration**
- Processes data using n-class classification algorithms to classify wound status.
- Enables real-time anomaly detection and predictive analytics.

### **Wireless Communication**
- Utilizes BLE for low-power, reliable data transmission.
- Supports a scalable network capable of managing thousands of smart bandages.

---

## **How It Works**

1. **Data Collection**:
   - The CU sends the `StartDataAcquisition` command to active smart bandages.
   - Sensors collect wound condition data, which is transmitted back to the CU.

2. **Device Discovery**:
   - The `LookForLeaf` command ensures all bandages in the network are identified and functioning properly.

3. **Data Processing**:
   - The CU analyzes the data using machine learning algorithms to provide actionable insights.

4. **Firmware Management**:
   - Commands like `UpdateFirmware` and `ReinitializeSensor` ensure the system operates efficiently and reliably.

---

## **Future Enhancements**
- Develop advanced machine learning models for more accurate wound classification.
- Implement bandage-to-bandage communication for decentralized networks.
- Enhance scalability by supporting larger networks with minimal power consumption.

---

## **Contributors**
The project is developed by **Soumadeep** and collaborators, focusing on hardware design, software development, and testing.

---

## **License**
This repository is open-source and available under the [MIT License](LICENSE).

---

## **Contact**
For inquiries or collaborations, please contact:
**Soumadeep**  
Email: [s.de@spartans.nsu.edu](mailto:de.soumadeep2023@gmail.com)
