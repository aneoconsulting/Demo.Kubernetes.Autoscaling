using System;
using System.IO;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Scaler.Services;

using Serilog;
using Serilog.Formatting.Compact;

namespace Scaler;

public static class Program
{
  public static async Task<int> Main(string[] args)
  {
    try
    {
      Log.Information("Starting web host");


      var builder = WebApplication.CreateBuilder(args);

      builder.Configuration.SetBasePath(Directory.GetCurrentDirectory())
        .AddJsonFile("appsettings.json",
          true,
          false)
        .AddEnvironmentVariables()
        .AddCommandLine(args);

      Log.Logger = new LoggerConfiguration().ReadFrom.Configuration(builder.Configuration)
        .WriteTo.Console(new CompactJsonFormatter())
        .Enrich.FromLogContext()
        .CreateLogger();

      builder.Host.UseSerilog(Log.Logger);

      builder.Services.AddLogging()
        .AddGrpc();

      builder.Services.AddHealthChecks();

      builder.WebHost.UseKestrel(options => options.ListenAnyIP(1080,
        listenOptions => listenOptions.Protocols = HttpProtocols.Http2));

      var app = builder.Build();

      if (app.Environment.IsDevelopment()) app.UseDeveloperExceptionPage();

      app.UseRouting();

      app.MapGrpcService<ScalerService>();


      if (app.Environment.IsDevelopment()) app.MapGrpcReflectionService();

      await app.RunAsync()
        .ConfigureAwait(false);

      return 0;
    }
    catch (Exception ex)
    {
      Log.Fatal(ex,
        "Host terminated unexpectedly");
      return 1;
    }
    finally
    {
      Log.CloseAndFlush();
    }
  }
}