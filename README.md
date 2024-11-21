# **Smart Bandage Research Project**

This repository showcases a **Smart Bandage Network** for autonomous wound monitoring. The system integrates **Bluetooth Low Energy (BLE)** communication, advanced sensors, and distributed machine learning for real-time health tracking. Each smart bandage independently collects and processes data, and the **Central Unit (CU)** coordinates network communication with commands such as `START_CALC`, `SEND_DATA`, and `LOOK_FOR_LEAF`.

---

## **System Overview**

### **Key Features**
- **Multi-parameter Sensing**: Measures temperature, pressure, humidity, and gas resistance using integrated BME688 sensors.
- **Scalable Network**: Manages thousands of bandages with dynamic registration and communication.
- **Machine Learning Integration**: Employs on-device ML models for anomaly detection.
- **Inter-bandage Connectivity**: Relays data through nearby bandages when out of direct CU range.

---

## **System Commands**

### **1. START_CALC**
- **Purpose**: Instructs smart bandages to begin collecting sensor data.
- **Process**:
  1. CU sends the `START_CALC` command to all registered bandages.
  2. Bandages activate their sensors via I²C communication and collect data sequentially.
  3. Ensures that all sensing nodes (up to 16 per bandage) acquire readings.

### **2. SEND_DATA**
- **Purpose**: Triggers bandages to transmit collected data to the CU.
- **Process**:
  1. After data collection, the CU issues the `SEND_DATA` command.
  2. Bandages package their data and transmit it over BLE.
  3. CU receives and processes data, forwarding it to the edge unit for visualization and storage.

### **3. LOOK_FOR_LEAF**
- **Purpose**: Ensures communication reliability by finding unresponsive bandages.
- **Process**:
  1. CU sends the `LOOK_FOR_LEAF` command to a deputy bandage (D-CU).
  2. The D-CU attempts to communicate with the unresponsive bandage.
  3. Data is collected and relayed back to the CU, ensuring no data loss.

---

## **Repository Structure**

### **1. Program Explaination**
Contains explaination for:
- **Smart Bandages**: Handles sensor control, BLE communication, and ML data processing.
- **Central Unit (CU)**: Manages network discovery, command issuance, and data aggregation.

### **2. Machine Learning**
Includes NanoEdge AI configurations for on-device ML:
- **ML Training Data**: Collected from controlled environmental tests.
- **ML Models**: Supports anomaly detection and multi-parameter classification.

### **3. Battery Simulation**
MATLAB scripts for simulating battery discharge profiles under various clock speeds and operational phases.

---

## **System Architecture**

### **Hardware Components**
- **Smart Bandages**: Flexible PCBs with BME688 sensors and STM32WB55 microcontrollers.
- **Central Unit (CU)**: Dual-core STM32WB55 MCU for BLE communication.
- **Edge Unit**: Raspberry Pi 4 for data visualization and storage using Grafana.

### **Communication Workflow**
1. **Discovery Phase**:
   - Bandages register with the CU upon activation.
   - CU assigns unique communication channels.

2. **Data Acquisition Phase**:
   - CU issues `START_CALC` to collect sensor data.
   - CU then triggers `SEND_DATA` for data transmission.
   - Data is processed and visualized on the edge unit.

3. **Fallback Mechanism**:
   - If a bandage is unresponsive, `LOOK_FOR_LEAF` is issued to nearby bandages for indirect data retrieval.

---

## **Data Visualization**

The collected data is transmitted to the edge unit via UART and visualized using **Grafana** dashboards. Key parameters like temperature, humidity, and gas resistance are displayed in real-time.

---

## **Future Enhancements**
- **Cloud Integration**: Remote monitoring through secure cloud platforms.
- **Extended Sensor Array**: Addition of biochemical sensors for broader diagnostic capabilities.
- **Enhanced Bandage Communication**: Mesh networking for larger deployments.

---

## **Contact**
For inquiries, please contact:
**Soumadeep De**  
Email: [s.de@spartans.nsu.edu](mailto:s.de@spartans.nsu.edu)
