using System.Text;

using LabOrchestrator.Core.Models;

namespace LabOrchestrator.Core.Services
{
    public class VagrantfileGenerator
    {
        public string Generate(LabConfig config)
        {
            var sb = new StringBuilder();
            sb.AppendLine("Vagrant.configure(\"2\") do |config|");
            sb.AppendLine($"  config.vm.box = \"{config.VagrantBox}\"");
            
            
            foreach (var machine in config.MachineConfigs)
            {
                sb.AppendLine($"config.vm.define \"{machine.MachineName}\" do | vm | ");
                sb.AppendLine($"vm.vm.hostname = \"{machine.MachineName}\"");
                sb.AppendLine("vm.vm.provider \"virtualbox\" do |vb|");
                sb.AppendLine($"vb.memory = {machine.MachineRam}");
                sb.AppendLine($" vb.cpus = {machine.CpuCount}");
                sb.AppendLine("end");
                
            }
            sb.AppendLine("end");
            return sb.ToString();
            
        }
    }
}
