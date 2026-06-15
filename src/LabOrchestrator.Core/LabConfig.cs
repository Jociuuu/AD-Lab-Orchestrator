
namespace LabOrchestrator.Core.Models
{
    public class LabConfig
    {
        public string DomainName { get; set; } = "test.local";
        public string AdminPassword { get; set; } = "Admin123!";
        public string NetworkPrefix { get; set; } = "192.168.56";
        public string DomainControllerIp { get; set; } = "192.168.56.10";
        public string VagrantBox { get; set; } = "gusztavvargadr/windows-server";

        public List<MachineConfig> MachineConfigs { get; set; } = new List<MachineConfig>();
 




    }
}
