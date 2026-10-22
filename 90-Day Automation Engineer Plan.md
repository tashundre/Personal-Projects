# 90-Day Automation Engineer Plan

Prepared for Tashundre Gilmore, October 2026

Goal: build the skills and proof needed to move from IT Operations Analyst into a systems, infrastructure or cloud automation role, on the way to platform engineering and an MS in Systems Engineering.

**Time assumption:** you have plenty of free time, plus quiet monitoring time at work. Plan on **20–25 hours a week**. At that pace the core plan (Python → Ansible → Terraform → AZ-104) fits in about **60 days**, and days 61–90 go to stretch skills that make you stand out. See Part 2.

**Your work environment (confirmed):**
- Python: allowed on your work machine
- PowerShell: **.ps1 scripts are now blocked** after a recent update, and the Active Directory module isn't installed. **Python is your main work automation tool.**
- Batch (.bat) files: still run. Use them only as simple launchers for Python scripts, never to get around the PowerShell block.
- UC4: job list export or API access is likely, still to confirm
- Zabbix: dashboard only, no API
- Approvals: your current scripts haven't needed formal approval

---

## Part 1: Automation at UF Health

You're already doing this work. Your GHX report script and production UC4 jobs count as automation engineering. The goal now is to do **2–3 more**, measure the impact, and give them the right labels.

### Ground rules (read first)

1. **Tell your supervisor, even if approval isn't required.** A quick heads-up like "I built a script that does X, here's what it touches" protects you, gets you credit and gives you a reference for future jobs. Anything that *changes* production systems should still go through your normal change process.
2. **Start read-only.** Scripts that only *look* (reports, checks, lookups) are low risk and easy to approve. Save scripts that *change* things for later.
3. **Never hard-code passwords.** Use CyberArk, Windows Credential Manager or whatever secure method your team approves.
4. **No patient data, ever, in scripts, logs or emails.**
5. **Don't copy work code to your personal GitHub.** Rebuild a clean, generic version at home for your portfolio. More on this below.
6. **Don't work around the PowerShell block.** Tricks like launching PowerShell from a .bat file with a "bypass" option go around a security control. In a HIPAA environment that can put your job at risk. Ask your supervisor or security team whether there's an approved way, such as digitally signed scripts.

### Top 3 ideas to start with

#### 1. After-hours account lookup tool (Python). Start here.

**The problem:** On lockout, password and access calls, you check several screens to find out what's wrong.

**The automation:** One script where you type a username and get back:
- Locked out or not, and when
- Bad password count and last bad password time
- Password last set and expiration date
- Account enabled or disabled
- Key group memberships, to spot access mismatches
- Optional: which domain controller recorded the lockout, to help find the source

**Why first:** it's read-only, low risk, useful every shift and easy to get approved. It fits your IAM experience too.

**Tools:** Python, since .ps1 scripts are blocked and the AD module isn't installed.
- **Simplest:** use Python's `subprocess` to run the built-in `net user <username> /domain` command and format the results (password last set, expiration, account active, group memberships). First check that the command still runs at your workstation.
- **Fuller version:** if you're allowed to install Python packages, the `ldap3` library can read `lockoutTime`, `badPwdCount`, `badPasswordTime`, `pwdLastSet`, `userAccountControl` and `memberOf` directly.

Keep it read-only. If a query is denied, stop there and ask your team before trying anything else.

**Measure:** time per lockout call before and after. For example: "from 6 minutes to 2 minutes."

**Resume bullet:** "Built a Python account diagnostics tool that cut average lockout and access-issue triage time by X% across after-hours support."

---

#### 2. Monthly reboot pre/post check (Python)

**The problem:** For monthly UC4 test and production reboots, you RDP in, stop services, reboot through VMware and confirm everything comes back. Your 10-minute breakpoint story shows how time-sensitive this is.

**The automation:** a two-part script:
- **Before reboot:** record which services are running, their startup type, disk space, uptime and pending patches. Save it to a timestamped file.
- **After reboot:** compare against the "before" snapshot and flag any service that didn't come back, any change, and confirm the server responds. Output a simple PASS/FAIL report you can attach to your documentation.

**Later step:** stop services in the correct order automatically. This needs more approval because it changes things.

**Tools:** Python, with `psutil` (`psutil.win_service_iter()` lists Windows services) or `subprocess` running built-in commands like `sc query`. Save JSON snapshots and compare them before and after. VMware PowerCLI is out while PowerShell is blocked.

**Measure:** minutes spent on manual checks per reboot, and any issues caught early.

**Resume bullet:** "Automated pre- and post-reboot validation for monthly patching of UC4 servers, reducing manual verification time by X% and standardizing results for audit."

---

#### 3. UC4 documentation audit (Python)

**The problem:** You're the sole documentation administrator for UC4 jobs in DocuShare. You've handled hundreds of archived jobs (the DO NOT RUN initiative) and 50 JAX/SF records by hand.

**The automation:** a script that compares an **export of UC4 job names** (CSV from Automic, or its REST API if your version supports it) with a **list of documents in DocuShare**, then reports:
- Jobs with no documentation
- Documentation for jobs that no longer exist, or should be marked DO NOT RUN
- Naming that doesn't follow your standard
- Documents not updated in X months

**Why it's strong:** it shows data comparison, reporting and governance, which are the same skills used in platform and data engineering.

**Tools:** Python (`csv`, plus `pandas` if you can install it). First confirm you can export the UC4 job list.

**Measure:** hours saved per audit and number of gaps found.

**Resume bullet:** "Developed an automated audit comparing more than X UC4 production jobs to DocuShare documentation, finding Y gaps and cutting audit time from Z hours to minutes."

---

### More ideas for later

| Idea | What it does | Risk |
|---|---|---|
| **Finish the GHX script end to end** | If the PowerShell version is now blocked, rebuild it in Python first. Then send automatically, log confirmation, alert if the website or login fails, and run it from UC4 or Task Scheduler. | Medium. Needs approval to auto-send. |
| **Daily UC4 job status summary** | At shift start, email a list of failed, blocked or on-hold jobs | Low (read-only) |
| **File transfer arrival check** | Confirm expected vendor files arrived or were sent on time, with the right size and timestamp, and alert if missing | Low to medium |
| **Zabbix alert log (manual + Python)** | You only have the dashboard, so log recurring alerts in a simple CSV during your shift. A Python script then summarizes the top repeat alerts each week to spot trends. Later, ask whether a read-only API token is possible. | Very low |
| **Shift handoff report (Python)** | Combine the UC4 job status export, your Zabbix alert log and notes into one report | Low |
| **Python version of the GHX script** | Rebuild the GHX workflow in Python (for example with `requests` or `playwright`) to practice Python on a real task | Low |
| **Commissioning/decommissioning checklist** | Generate a checklist and validate that dcTrack fields are complete before closing | Low |
| **Ticket note templates** | Pre-written Ivanti note templates for common issues, for consistent tickets | Very low |

### Impact tracker

For every automation, record:

| Field | Example |
|---|---|
| Task | Lockout call triage |
| How often | About 15 times a week |
| Time before | 6 minutes |
| Time after | 2 minutes |
| Weekly time saved | 15 × 4 min = **1 hour a week** |
| Errors before or after | Missed group mismatch twice a month → 0 |
| Who uses it | After-hours desk, 3 analysts |
| Approved by / date | Supervisor name, date |

These numbers become your resume bullets and interview answers.

---

## Part 2: The 90-day skills plan

**Order:** Python + Git → Linux → Ansible → Terraform → AZ-104 (studied alongside from day 46)

### Faster schedule at 20–25 hours a week

The stage details below use the original 90-day pace. With your time, compress them like this:

| Days | Stage | Projects |
|---|---|---|
| 1–20 | Python + Git | Project 1 + rebuild the GHX workflow in Python. At work, build the account lookup tool. |
| 21–28 | Linux + Bash | Project 2. At work, build the reboot pre/post check. |
| 29–40 | Ansible | Project 3. Start AZ-104 study (1 hour a day). At work, build the UC4 documentation audit. |
| 41–52 | Terraform | Project 4 |
| 53–60 | AZ-104 exam prep + capstone | Project 5. **Take AZ-104 around day 60.** |
| 61–75 | **Stretch: Docker + GitHub Actions** | Containerize your health checker and SkyEvents. Add automatic testing and linting on every push. |
| 76–90 | **Stretch: HashiCorp Terraform Associate cert or Kubernetes basics** | Earn the Terraform Associate cert, or deploy a container to a small Kubernetes cluster (k3s on your lab VMs) |

**Downtime at work:** use quiet monitoring time for reading, Microsoft Learn modules and building work automations. Keep personal portfolio projects on your own devices and time.

**PowerShell at home:** keep practicing it on your own machine even though it's blocked at work. Many employers rely on it, and AZ-104 uses it.

All projects live in **one GitHub repo** called `homelab-automation`, or one repo per stage. Your portfolio grows step by step.

### Days 1–20: Python + Git with "Automate the Boring Stuff"

(This is the faster 20-day pace. At the original pace, stretch it to 30 days.)

**Main resource:** *Automate the Boring Stuff with Python*, Third Edition, free online at automatetheboringstuff.com. You've used it before, so treat it as a reference, not a cover-to-cover read.

#### How to use each chapter

1. **Skim** the explanations, and slow down only on what's new.
2. **Do the practice questions.** If you get them right, move on.
3. **Do one practice project** from the chapter.
4. **Write one mini-script of your own** using that chapter's skill on an IT or automation problem. This is the step that matters most.
5. **Commit it to GitHub** with a one-line note on what it does.

#### Day-by-day map

| Days | Book chapters | Your mini-script |
|---|---|---|
| **1–3** (review) | 1–7: basics, flow control, loops, functions, debugging, lists, dictionaries | Store servers in a dictionary (name, IP, role) and print a formatted list. Learn **logging** from chapter 5 and use it in every script after this. |
| **4–5** | 8: Strings and Text Editing; 9: Regular Expressions | **Log parser:** find error lines and timestamps in a sample log file and count them. |
| **6–7** | 10: Reading and Writing Files; 11: Organizing Files | **File checker:** check that expected files exist, report size and age, and archive old ones. A practice version of your UC4 file-transfer and archiving work. |
| **8–9** | 12: Command Line Programs | Turn the file checker into a command-line tool (`python filecheck.py --folder X --max-age 24`). |
| **10–11** | 18: CSV, JSON and XML Files | **UC4 doc audit practice:** compare a "job list" CSV with a "docs list" CSV and report what's missing from each. Fake data at home, real exports at work. |
| **12–13** | 19: Scheduling Tasks and Launching Programs | **Project 1 starts.** Use `subprocess` for ping or `net` commands, and schedule the script to run on its own. |
| **14–15** | 20: Sending Email and Notifications | The health checker alerts you only when something fails. |
| **16–17** | 13: Web Scraping | **GHX rebuild practice:** log into a practice site, capture a page and build an email. Public test sites only at home, never work credentials. |
| **18–20** | 16: SQLite Databases (optional) + polish | Save health-check history to SQLite. Finish Project 1: README, error handling, example output. |

**Skip for now:** chapters 14–15 (Excel, Google Sheets), 17 (PDF/Word) and 21–24 (graphs, images, text recognition, mouse control, speech). Come back only if a real task needs them. Chapter 23 can help automate a desktop app that has no other way in.

#### What the book doesn't cover

| Skill | When | Why |
|---|---|---|
| **Git and GitHub** | Day 1 | Every job expects it: `add`, `commit`, `push`, branches, README files. Use GitHub's free tutorials. |
| **Virtual environments** (`venv`) plus the book's Appendix A on `pip` | Days 1–2 | Keeps each project's packages separate. Standard practice. |
| **`psutil`** | Days 12–13 | Services, CPU, disk and memory checks for the health checker and reboot check |
| **`requests` for APIs** | Days 16–17 | Most automation talks to APIs: UC4/Automic, Azure, monitoring tools. |
| **`pytest`** | Days 18–20 | Basic tests for your scripts. A big plus with employers. |

#### How it connects to work

The days 10–11 mini-script becomes your **UC4 documentation audit**. Days 12–15 become your **reboot pre/post check** and **account lookup tool**. Days 16–17 become the **Python version of the GHX script**. Build each at home with fake data first, then build the real version on your work machine with real exports.

**Going faster:** if days 1–3 feel easy, finish the review in 1–2 days and give the extra time to Project 1 or your work automations.

#### Project 1: Server Health Checker (Python)

- Reads a list of servers or services from a CSV file
- Checks whether each one responds (ping or port), plus disk space and uptime on your lab machines
- Writes a timestamped report (CSV or HTML) and logs results
- Emails or notifies you if anything fails
- Optional: stores history in SQLite
- This is the generic, portfolio-safe version of your reboot check and monitoring work.

**Done when:** the script runs cleanly, handles errors, has a few `pytest` tests, and the repo has a README explaining what it does and how to run it.

---

### Days 31–45: Linux command line + Bash basics

**Learn:**
- Navigating, file permissions, users and groups (`chmod`, `chown`, `useradd`, `sudo`)
- Services (`systemctl`), logs (`journalctl`, `/var/log`), packages (`apt`)
- SSH keys, networking basics (`ip`, `ss`, `curl`)
- Simple Bash scripts and cron jobs

**Project 2: Linux lab setup**
- Build 3 Ubuntu VMs on your laptop with VirtualBox, VMware Workstation or Hyper-V
- Set up SSH key login from your main machine to all three
- Schedule your Python health checker from Project 1 with cron, monitoring all three VMs
- Document the setup in the repo

**Done when:** you can SSH into all 3 VMs without a password, and your health checker runs on a schedule.

---

### Days 46–60: Ansible

**Learn:**
- Inventory files, playbooks, modules, variables, handlers
- Idempotence: running a playbook twice shouldn't change anything the second time
- Roles, which organize playbooks into reusable parts
- Ansible Vault for secrets

**Resources:** the official Ansible "Getting Started" guide and Jeff Geerling's "Ansible for DevOps."

**Project 3: Configure the lab with Ansible**

Playbooks that:
- Create standard users and SSH keys on all VMs
- Apply updates (your patching experience, automated)
- Install and configure a web server such as nginx
- Deploy your Python health checker and its cron job
- Check that services are running after changes, similar to your post-reboot check

**Done when:** you can wipe a VM, run one command and have it fully rebuilt.

**Start AZ-104 study here:** about 30 minutes a day on the free Microsoft Learn AZ-104 path.

---

### Days 61–75: Terraform

**Learn:**
- Providers, resources, variables, outputs
- State files and why they matter
- `plan`, `apply`, `destroy`
- Modules

**Resources:** HashiCorp's official Terraform tutorials (the Azure track).

**Project 4: Build Azure infrastructure with Terraform**
- Use an Azure free account
- Create a resource group, virtual network, subnet, network security group and one Linux VM
- Output the VM's IP address
- Run your Ansible playbooks from Project 3 against the Azure VM
- **Always run `terraform destroy` when you're done** to avoid charges, and set a budget alert in Azure.

**Done when:** one Terraform command builds the environment, one Ansible command configures it, and one command tears it all down.

---

### Days 76–90: AZ-104 + capstone

**Learn (AZ-104 domains):**
- Managing Azure identities and governance: Entra ID, RBAC, policies. Your IAM experience helps here.
- Storage
- Compute (VMs, scale sets, containers)
- Virtual networking
- Monitoring and backup

**Resources:** the free Microsoft Learn AZ-104 path, Microsoft's free practice assessment, and one paid practice test set if you want extra prep.

**Project 5 (capstone): end-to-end automated environment**

Combine everything into one repo:
1. **Terraform** builds Azure resources
2. **Ansible** configures the servers
3. **Python** monitors them and reports health
4. **Git** stores it all, with a clear README and a simple diagram (use Canva or draw.io)
5. Optional: add **GitHub Actions** to run checks automatically when you push code

**Exam:** schedule AZ-104 for about day 90–100, once you score 80% or higher on practice tests.

---

## Part 3: What you'll have after 90 days

| Proof | Example |
|---|---|
| Workplace automation | 2–3 approved scripts at UF Health with measured impact |
| GitHub portfolio | 5 projects: Python, Linux, Ansible, Terraform and a capstone, plus SkyEvents and SysHealth Monitor |
| Certifications | AZ-104 (around day 60), plus Terraform Associate if you take that stretch track |
| Extra skills | Docker, GitHub Actions, and Kubernetes basics if you take that stretch track |
| Resume | New bullets with real numbers |
| Interview stories | Your existing stories plus new automation stories |

### Resume section to add

**Automation and Infrastructure Projects**
- Built a Python account diagnostics tool reducing lockout triage time by X% (UF Health)
- Automated pre- and post-reboot validation for monthly UC4 server patching (UF Health)
- Developed a UC4 documentation audit comparing X jobs against DocuShare records (UF Health)
- Homelab: provisioned Azure infrastructure with Terraform, configured servers with Ansible and monitored health with Python (GitHub)

### Jobs to apply for once you have this

Systems Administrator II · Infrastructure Engineer I · Systems Engineer (Automation) · Cloud Operations Engineer · Automation Engineer I · Junior Platform Engineer

---

## Weekly routine

| Time | Focus |
|---|---|
| Quiet time at work | Reading, Microsoft Learn modules, building work automations |
| Weekday evenings (Mon–Thu) | 2–3 hours of hands-on project work |
| Fri | Rest or light review |
| Sat | 3–4 hours of project work |
| Sun | 1–2 hours: update GitHub README, impact tracker and notes, plan the next week |

Small and steady beats long and occasional. Commit to GitHub every day you work on it, even if it's one line.
