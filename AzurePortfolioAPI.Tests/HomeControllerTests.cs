using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using Xunit;

namespace AzurePortfolioAPI.Tests;

public class HomeControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public HomeControllerTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = _factory.CreateClient();
    }

    [Fact]
    public async Task Root_ReturnsOk()
    {
        var response = await _client.GetAsync("/");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Health_ReturnsOk()
    {
        var response = await _client.GetAsync("/health");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Health_ReturnsHealthyStatus()
    {
        var response = await _client.GetAsync("/health");
        var content = await response.Content.ReadAsStringAsync();
        Assert.Contains("Healthy", content);
    }

    [Fact]
    public async Task Info_ReturnsOk()
    {
        var response = await _client.GetAsync("/info");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Info_ReturnsCorrectAppName()
    {
        var response = await _client.GetAsync("/info");
        var content = await response.Content.ReadAsStringAsync();
        Assert.Contains("Azure Portfolio API", content);
    }
}