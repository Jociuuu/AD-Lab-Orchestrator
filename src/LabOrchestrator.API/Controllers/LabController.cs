using LabOrchestrator.Core.Models;
using LabOrchestrator.Core.Services;
using Microsoft.AspNetCore.Mvc;


namespace LabOrchestrator.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LabController : ControllerBase
    {
        private readonly LabOrchestrationService _labService;
        public LabController(LabOrchestrationService labService)
        {
            _labService = labService;
        }
        [HttpPost("start")]
        public async Task<IActionResult> StartLab(LabConfig config)
        {
            await _labService.StartLabAsync(config);
            return Ok();
        }
        [HttpPost("generate")]
        public  IActionResult Generate(LabConfig config)
        {
            var result = _labService.GenerateVagrantfile(config);
            return Ok(result);

        }
    }
    
}
