using System.Text;
using LabOrchestrator.Core.Models;

namespace LabOrchestrator.Core.Services
{
    public class VagrantfileGenerator
    {
        public string Generate(LabConfig config)
        {
            var sb = new StringBuilder();
            int wsIndex = 11;

            sb.AppendLine("Vagrant.configure(\"2\") do |config|");
            sb.AppendLine($"config.vm.box = \"{config.VagrantBox}\"");

            foreach (var machine in config.MachineConfigs)
            {
                sb.AppendLine($"config.vm.define \"{machine.MachineName}\" do |vm|");
                sb.AppendLine($"vm.vm.hostname = \"{machine.MachineName}\"");

                if (machine.Type == MachineType.DomainController)
                {
                    sb.AppendLine($"vm.vm.network \"private_network\", ip: \"{config.DomainControllerIp}\"");
                }
                else
                {
                    sb.AppendLine($"vm.vm.network \"private_network\", ip: \"{config.NetworkPrefix}.{wsIndex}\"");
                    wsIndex++;
                }

                sb.AppendLine($"vm.vm.provider \"virtualbox\" do |vb|");
                sb.AppendLine($"vb.memory = {machine.MachineRam}");
                sb.AppendLine($"vb.cpus = {machine.CpuCount}");
                sb.AppendLine("end");
                if (machine.Type == MachineType.DomainController)

                    sb.AppendLine($"vm.vm.provision \"shell\", path: \"scripts/setup-ad.ps1\", args: [\"{config.DomainName}\", \"{config.DomainName.Split('.')[0].ToUpper()}\", \"{config.AdminPassword}\"]");
                else
                    sb.AppendLine($"vm.vm.provision \"shell\", path: \"scripts/join-domain.ps1\", args: [\"{machine.MachineName}\", \"{config.DomainName}\", \"{config.DomainControllerIp}\", \"{config.AdminPassword}\"]");
                sb.AppendLine("end");
            }

            sb.AppendLine("end");
            return sb.ToString();
        }
    }
}