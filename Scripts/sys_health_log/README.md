# Scope
* Collects CPU %, memory %, free disk Gb (each fixed drive), and status of a few key Windows services.
* Decides health = Healthy/Warning/Critcal by comparing to thresholds.
* Records each run to a rolling log (CSV or JSON) in a known folder
* Alerts via console output and non-zero exit code (1=Warning, 2=Critcal)

# Requirements
*OS: Windows 10/11 or Server 2019/2022 
* Shell: Powershell 7+ (Core)
* Inputs: JSON config with thresholds + service names.
* Outputs: daily CSV (defaults) of JSONL file; rptates when too large
* Behavior: exit code 0/1/2; human-readable console line

# What
1. **Reads settings** (or uses sensible defaults if your config.json is missing)
2. **Checks your machine:**
   * CPU Usage now
   * Memore usage now
   * Free Space on each fixed drive
   * Whether specific services are running
3. **Compares to your rules (warn/critical thresholds)**
4. **Decided** overall health = Healthy/Warning/Critical and why reasons
5. **Writes a row to a daily log ** (CSV or JSON), safely rotating if large
6. **Prints one concise statue line** and **exits with 0/1/2** so other tools can react 

# Why
