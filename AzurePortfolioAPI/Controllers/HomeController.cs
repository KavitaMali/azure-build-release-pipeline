using Microsoft.AspNetCore.Mvc;
using AzurePortfolioAPI.Models;

namespace AzurePortfolioAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class HomeController : ControllerBase
{
    private readonly ILogger<HomeController> _logger;
    private readonly IConfiguration _configuration;

    public HomeController(
        ILogger<HomeController> logger,
        IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;
    }

    [HttpGet("/")]
    public IActionResult Index()
    {
        _logger.LogInformation("Root endpoint called");
        return Ok(new
        {
            message = "Hello from Azure!",
            timestamp = DateTime.UtcNow,
            status = "running"
        });
    }

    [HttpGet("/health")]
    public IActionResult Health()
    {
        _logger.LogInformation("Health endpoint called");
        return Ok(new HealthResponse
        {
            Status = "Healthy",
            Timestamp = DateTime.UtcNow,
            Environment = _configuration["ASPNETCORE_ENVIRONMENT"] ?? "Production",
            Version = "1.0.0"
        });
    }

    [HttpGet("/info")]
    public IActionResult Info()
    {
        _logger.LogInformation("Info endpoint called");
        return Ok(new
        {
            appName = "Azure Portfolio API",
            version = "1.0.0",
            environment = _configuration["ASPNETCORE_ENVIRONMENT"] ?? "Production",
            deployedAt = DateTime.UtcNow,
            framework = ".NET 8",
            deployedBy = "Azure DevOps Pipeline"
        });
    }
}