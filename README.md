# AD Lab Orchestrator

Automated Active Directory lab builder with a web interface. Provisions Windows Server VMs, configures a domain controller, and joins workstations to the domain — all from a browser.

Built with **C# / ASP.NET Core 9**, **Vagrant**, **VirtualBox**, and **PowerShell**.

---

## What it does

- Generates a `Vagrantfile` based on your configuration
- Provisions a **Domain Controller** with AD DS via PowerShell
- Joins **workstations** to the domain automatically
- Streams live `vagrant` output to the browser via **Server-Sent Events**
- Dark terminal web UI on `localhost:5096`

---

## Stack

| Layer | Technology |
|---|---|
| Backend | C# / ASP.NET Core 9 |
| Architecture | Clean Architecture (Core + API) |
| Frontend | Vanilla HTML/CSS/JS |
| Provisioning | Vagrant + VirtualBox |
| Configuration | PowerShell scripts |
| Containerization | Docker / docker-compose |
| Tests | xUnit |

---

## Quick start

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

### Run

```bash
git clone https://github.com/Jociuuu/AD-Lab-Orchestrator
cd AD-Lab-Orchestrator
docker-compose up
```

Open `http://localhost:5096/index.html` in your browser.

---

## Usage

1. Choose a **preset** (Small / Medium / Enterprise) or configure manually
2. Set domain name, admin password, network prefix
3. Click **generate vagrantfile** to preview the configuration
4. Click **start lab** to provision the VMs

### Presets

| Preset | Domain Controller | Workstations |
|---|---|---|
| Small | 1x DC (2GB RAM) | 1x WS (1GB RAM) |
| Medium | 1x DC (2GB RAM) | 3x WS (1GB RAM) |
| Enterprise | 1x DC (4GB RAM) | 5x WS (2GB RAM) |

---

## Project structure

```
AD-Lab-Orchestrator/
├── src/
│   ├── LabOrchestrator.Core/       # Business logic, models, services
│   │   ├── Models/                 # LabConfig, MachineConfig, MachineType
│   │   └── Services/               # VagrantfileGenerator, ProcessRunner, LabOrchestrationService
│   └── LabOrchestrator.API/        # ASP.NET Core Web API
│       ├── Controllers/            # LabController, StatusController (SSE)
│       └── wwwroot/                # Web UI
├── tests/
│   └── LabOrchestrator.Tests/      # xUnit unit tests
├── scripts/
│   ├── setup-ad.ps1                # Domain Controller provisioning
│   ├── join-domain.ps1             # Workstation domain join
│   └── fuzz-ad.ps1                 # AD vulnerability simulation
├── Dockerfile
└── docker-compose.yml
```

---

## API endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/lab/generate` | Generate Vagrantfile from config |
| POST | `/api/lab/start` | Start lab provisioning |
| GET | `/api/status/stream` | SSE stream of live logs |

---

## Architecture

```
Browser (localhost:5096)
    │
    ▼
ASP.NET Core API
    │
    ▼
LabOrchestrator.Core
    │
    ├── VagrantfileGenerator  →  Vagrantfile
    ├── ProcessRunner         →  vagrant up (stdout stream)
    └── LabOrchestrationService → orchestrates the sequence
```

---

## Security notes

- `fuzz-ad.ps1` introduces intentional AD misconfigurations for red/blue team practice (Kerberoasting, AS-REP Roasting)
- Windows Defender can be disabled per-workstation via `$EnableDefender` parameter (red team mode)
- Intended for **isolated lab environments only**

---

*Built as a portfolio project — cybersecurity / blue team focus.*
