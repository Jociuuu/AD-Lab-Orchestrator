
namespace LabOrchestrator.Core.Models
{
    public class MachineConfig
    {
        public string MachineName { get; set; } = string.Empty;
        public MachineType Type { get; set; } = MachineType.Workstation;
        public int MachineRam { get; set; } = 1024;
        public int CpuCount { get; set; } = 1;
    }
}
