using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;



namespace LabOrchestrator.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StatusController : ControllerBase
    {
        [HttpGet("stream")]
        public async Task<IActionResult> Stream()
        {
            Response.Headers["Content-Type"] = "text/event-stream";
            Response.Headers["Cache-Control"] = "no-cache";
            for (int i = 0; i < 10; i++)
            {
                await Response.WriteAsync($"data: Log line {i}\n\n");
                await Response.Body.FlushAsync();
                await Task.Delay(1000);
            }
            return Ok();
        }
            
    }

}
