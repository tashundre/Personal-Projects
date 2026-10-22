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

## Start Here: Your First Week

Do these in order. Part 1 (work automations) and Part 2 (skills plan) run **at the same time**. Learn a skill at home, then use it at work.

| Day | Home (skills) | Work (automation) |
|---|---|---|
| **Today** | Make a GitHub account (or log in), create a repo called `homelab-automation`, and install Python + Git on your home machine | Nothing yet |
| **Day 1** | Set up a virtual environment (`venv`). Start the book review: chapters 1–3. Commit your first script. | Start timing lockout and password calls: minutes per call and calls per shift. This is your "before" number. |
| **Day 2** | Book chapters 4–5 (functions, debugging and **logging**) | Keep timing calls |
| **Day 3** | Book chapters 6–7 (lists, dictionaries). Write the server-dictionary mini-script. | Check whether you can export the UC4 job list. Ask your supervisor if needed. |
| **Days 4–5** | Book chapters 8–9 (strings, regex) → log parser mini-script | Check whether `net user <username> /domain` runs on your work machine, and whether the GHX PowerShell script still works |
| **Days 6–7** | Book chapters 10–11 (files) → file checker mini-script | Give your supervisor a quick heads-up about the automations you plan to build |

**After week 1:** follow the day-by-day map in Part 2 and the schedule table.

**Order of work automations:** account lookup tool (around day 12) → reboot pre/post check (days 21–28) → UC4 documentation audit (days 29–40) → GHX Python rebuild (when ready).

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

This is the schedule to follow. The detailed sections below use the same day numbers.

| Days | Stage | Projects |
|---|---|---|
| 1–20 | Python + Git | Project 1 + rebuild the GHX workflow in Python. At work: time your lockout calls (week 1), confirm the UC4 export, then build the account lookup tool (around day 12). |
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

### Days 21–28: Linux command line + Bash basics

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

### Days 29–40: Ansible

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

**Start AZ-104 study here:** about 1 hour a day on the free Microsoft Learn AZ-104 path.

---

### Days 41–52: Terraform

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

### Days 53–60: AZ-104 + capstone

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

**Exam:** take AZ-104 around day 60, once you score 80% or higher on practice tests. If you're not there yet, push it back 1–2 weeks. Don't rush it.

---

### Days 61–90: Stretch tracks

- **Days 61–75, Docker + GitHub Actions:** package your health checker and SkyEvents as containers, and set up automatic tests and code checks every time you push to GitHub.
- **Days 76–90, pick one:** the HashiCorp Terraform Associate certification, or Kubernetes basics (run k3s on your lab VMs and deploy one of your containers).

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

---

## Part 4: Astronomy Data Track (after the 90 days)

**When:** start after day 90, or run it lightly alongside the stretch tracks (days 61–90) if you have energy for it. It builds on everything above, so don't start it early.

**Goal:** prepare for observatory and telescope data jobs at organizations like Rubin Observatory/SLAC, STScI, IPAC (Caltech), NRAO and NOIRLab, by turning SkyEvents into a mini telescope data pipeline.

### Why this track

Observatory data jobs come in two kinds:

| Path | What you do | Fit for you | Example |
|---|---|---|---|
| **Observatory infrastructure and data operations** | Run and automate the systems telescope data flows through: servers, storage, data movement, Kubernetes, monitoring | **Your faster route.** Same skills as Parts 1–3. | Rubin's US Data Facility at SLAC needs people to "operate, automate, and improve" its data systems ([SLAC](https://bebee.com/us/jobs/software-developer-4-slac-national-accelerator-laboratory-menlo-park--lensa-2365_14f980ba57c2f9244f3ae4e3d5dc7e973a7f52dc425be57af85bc6cd29b71550)). IPAC's data center team builds "the vital pipelines that connect the global astronomical community" to science data ([IPAC](https://www.simplyhired.com/job/K_c0fRubcRZJHycojZFZcmKRvXNp0fZsnNgV8PfBEWSjoSNzeqt8HQ)). |
| **Science pipeline development** | Write the software that processes telescope data | A 2–3 year goal. Needs professional software engineering experience. | STScI's Software Engineer I ($80K–$95K) asks for intermediate Python, testing, astronomy data experience and 2+ years as a software engineer ([STScI](https://www.linkedin.com/jobs/view/software-engineer-i-at-space-telescope-science-institute-4368821910)). |

**Good to know:**
- No PhD is needed for software and technical roles ([AAS](https://aas.org/careers/career-in-astronomy)).
- Pay is lower than private industry but still a big step up for you. For example, NRAO Software Engineer II/III jobs pay $60.4K–$120.8K, and fully remote is possible for highly qualified candidates ([NRAO](https://spacecrew.com/space-jobs/m3ttwsse-national-radio-astronomy-observatory-software-engineer-ii-iii)).
- Your UC4 experience transfers directly. Airflow, which STScI asks for ([STScI](https://www.linkedin.com/jobs/view/senior-cloud-software-developer-at-space-telescope-science-institute-4346293339)), does the same core job as UC4: dependent jobs, schedules, retries and monitoring.

### New skills in this track

| Skill | What it is | Why observatories want it |
|---|---|---|
| **PostgreSQL / SQL** | A relational database and its query language | Used for catalogs, metadata and pipeline tracking. Rubin and SLAC postings ask for PostgreSQL experience ([SLAC](https://www.wearedevelopers.com/jobs/ext/1216973-scientific-systems-software-developer)). |
| **Apache Airflow** | A workflow scheduler for data pipelines, similar to UC4 | Schedules and monitors pipeline steps |
| **Astropy + NumPy** | The core Python libraries for astronomy data | Required or preferred in STScI science software roles ([STScI](https://www.linkedin.com/jobs/view/science-software-engineer-at-space-telescope-science-institute-4329017786)) |
| **FITS files** | The standard astronomy image and data file format | Telescope data usually comes in FITS |
| **astroquery** | A Python library for downloading data from public astronomy archives | Gets real telescope data for your projects |
| **Docker + Kubernetes** | Containers and container orchestration (from your stretch tracks) | Rubin and SLAC run their pipelines on Kubernetes ([SLAC](https://www.linkedin.com/jobs/view/senior-site-reliability-engineer-at-slac-national-accelerator-laboratory-4437330073)) |
| **Kafka (later)** | Real-time data streaming | Rubin uses it to publish alerts to astronomers worldwide ([SLAC](https://www.linkedin.com/jobs/view/senior-site-reliability-engineer-at-slac-national-accelerator-laboratory-4437330073)) |

### Project 6: SkyEvents Pipeline Upgrade (about 6 weeks)

Turn SkyEvents into a small telescope data pipeline. Build it in stages, and commit each stage to GitHub.

| Weeks | Stage | What you build |
|---|---|---|
| **1** | **PostgreSQL** | Install PostgreSQL in your Linux lab (use Ansible from Project 3). Design tables for sky events, ISS passes and pipeline run history. Change SkyEvents to save results to the database instead of only files. |
| **2** | **Astropy + real telescope data** | Use `astroquery` to download a small set of public telescope data, such as images or catalogs from NASA's public archives. Open FITS files with Astropy, read their headers (metadata), and extract basics like target, date, instrument and exposure. |
| **3** | **Data quality checks** | Add checks: missing fields, bad coordinates, duplicate records, corrupted files. Log every problem to a `quality_issues` table with a severity level. This is the same kind of defect tracking the Peraton job asked for. |
| **4** | **Airflow** | Rebuild the pipeline as an Airflow DAG (a workflow of dependent steps): **fetch → validate → process → load to PostgreSQL → generate report**. Add retries and failure alerts. Write a short README section comparing it to UC4. |
| **5** | **Docker** | Package the pipeline (Airflow, PostgreSQL, SkyEvents code) with Docker Compose so anyone can run it with one command |
| **6** | **Output + polish** | Generate the SkyEvents newsletter's "Into the Sky" section from the database. Add `pytest` tests, a pipeline diagram (Canva or draw.io) and a README that explains the architecture. |

**Optional later stages:**
- Deploy it to Kubernetes (k3s) on your lab VMs
- Use Terraform to run it in Azure
- Add a simple dashboard showing pipeline runs and data quality over time

**Done when:** one command starts the whole pipeline. It downloads real public astronomy data, checks and processes it, stores it in PostgreSQL, runs on a schedule in Airflow and produces a report. Your README explains it clearly.

**Resume bullet:** "Built a containerized astronomy data pipeline (Python, Astropy, Airflow, PostgreSQL, Docker) that ingests public telescope data, validates quality, and generates automated reports."

### Other steps in this track

1. **Contribute to open-source astronomy software.** Start small with documentation fixes, tests or beginner issues in Astropy or astroquery. People who hire at these organizations notice contributors.
2. **Watch these job boards:** the AAS Job Register, Rubin Observatory jobs, STScI careers, IPAC/Caltech opportunities, NRAO careers and NOIRLab careers.
3. **Target titles at first:** Systems Engineer, DevOps Engineer, Site Reliability Engineer, Data Operations Engineer, Systems Administrator (Linux), Data Center Engineer. Later: Software Engineer I/II and Science Software Engineer.
4. **Keep your MS in Systems Engineering plan.** Observatories hire systems engineers for large projects. NRAO's systems engineer role pays $114K–$138K, but it asks for 10 years of experience ([NRAO](https://careers.ohsonline.com/job/systems-engineer/85743708/)), so it's a long-term goal.

### Timeline

| When | Milestone |
|---|---|
| Days 1–90 | Core plan: Python → Linux → Ansible → Terraform → AZ-104 → stretch tracks |
| Months 4–5 | Project 6: SkyEvents Pipeline Upgrade |
| Months 4–12 | Land an infrastructure or automation job. Start open-source contributions. |
| Years 1–3 | Apply for observatory infrastructure, DevOps or data operations roles. Start your MS in Systems Engineering, ideally with tuition help from your employer. |
| Years 3+ | Move toward science pipeline development or systems engineering for observatory and space missions |
