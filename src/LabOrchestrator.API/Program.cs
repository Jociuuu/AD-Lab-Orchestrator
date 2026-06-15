using LabOrchestrator.Core.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddScoped<VagrantfileGenerator>();
builder.Services.AddScoped<ProcessRunner>();
builder.Services.AddScoped<LabOrchestrationService>();



builder.Services.AddControllers();

builder.Services.AddOpenApi();

var app = builder.Build();


if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
