using LabOrchestrator.Core.Models;
using LabOrchestrator.Core.Services;

namespace LabOrchestrator.Tests
{
    public class VagrantfileGeneratorTests
    {
        [Fact]
        public void Generate_ShouldContainMachineName()
        {
            var generator = new VagrantfileGenerator();
            var config = new LabConfig();
            config.MachineConfigs.Add(new MachineConfig { MachineName = "DC01" });
            var result = generator.Generate(config);
            Assert.Contains("DC01",result);

        }

    }
}
