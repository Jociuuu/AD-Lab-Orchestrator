using System.Threading.Tasks;
using System.Diagnostics;

namespace LabOrchestrator.Core.Services
{
    public class ProcessRunner
    {
        public async Task<bool> RunAsync(string command, string workingDirectory, Action<string> onOutput) 
        {
            var processInfo = new ProcessStartInfo();
            var parts =command.Split(' ', 2);
            processInfo.FileName = parts[0];
            processInfo.Arguments = parts[1];
            processInfo.WorkingDirectory = workingDirectory;
            processInfo.RedirectStandardOutput = true;
            processInfo.UseShellExecute = false;
            processInfo.CreateNoWindow = true;
            var process = Process.Start(processInfo);
            string? line;
            while ((line = await process.StandardOutput.ReadLineAsync()) != null)
            {
                onOutput(line);
            }
            await process.WaitForExitAsync();
            return process.ExitCode == 0;
        }
    }
}
