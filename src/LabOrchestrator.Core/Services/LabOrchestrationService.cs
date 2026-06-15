using System;
using System.IO;
using System.Threading.Tasks;

using LabOrchestrator.Core.Models;

namespace LabOrchestrator.Core.Services
{
    public class LabOrchestrationService
    {
        private readonly VagrantfileGenerator _generator;
        private readonly ProcessRunner _runner;

        public LabOrchestrationService(VagrantfileGenerator generator, ProcessRunner runner)
        {
            _generator = generator;
            _runner = runner;

        }
        public async Task StartLabAsync(LabConfig config)
        {
            var vagrantfile = _generator.Generate(config);
            File.WriteAllText("Vagrantfile", vagrantfile);
            await _runner.RunAsync("vagrant up", Directory.GetCurrentDirectory(), logi => Console.WriteLine(logi));

        }
        public string GenerateVagrantfile(LabConfig config)
        {
            return _generator.Generate(config);
        }
    }
}
