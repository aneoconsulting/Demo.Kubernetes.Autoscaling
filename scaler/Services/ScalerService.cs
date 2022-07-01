using System;
using System.Collections.Concurrent;
using System.Threading.Tasks;

using Externalscaler;

using Grpc.Core;

namespace Scaler.Services;

public class ScalerService : ExternalScaler.ExternalScalerBase
{
  private static readonly ConcurrentDictionary<string, ConcurrentBag<IServerStreamWriter<IsActiveResponse>>> Streams =
    new();

  private Task<int> GetEarthQuakeCount(string longitude, string latitude, double magThreshold) => Task.FromResult(10);

  public override async Task<IsActiveResponse> IsActive(ScaledObjectRef request, ServerCallContext context)
  {
    if (!request.ScalerMetadata.ContainsKey("latitude") ||
        !request.ScalerMetadata.ContainsKey("longitude"))
      throw new ArgumentException("longitude and latitude must be specified");

    var longitude = request.ScalerMetadata["longitude"];
    var latitude = request.ScalerMetadata["latitude"];
    var earthquakeCount = await GetEarthQuakeCount(longitude, latitude, 1.0);
    return new IsActiveResponse
    {
      Result = earthquakeCount > 2
    };
  }

  public override async Task StreamIsActive(ScaledObjectRef request,
    IServerStreamWriter<IsActiveResponse> responseStream, ServerCallContext context)
  {
    if (!request.ScalerMetadata.ContainsKey("latitude") ||
        !request.ScalerMetadata.ContainsKey("longitude"))
      throw new ArgumentException("longitude and latitude must be specified");

    var longitude = request.ScalerMetadata["longitude"];
    var latitude = request.ScalerMetadata["latitude"];
    var key = $"{longitude}|{latitude}";

    while (!context.CancellationToken.IsCancellationRequested)
    {
      var earthquakeCount = await GetEarthQuakeCount(longitude, latitude, 1.0);
      if (earthquakeCount > 2)
        await responseStream.WriteAsync(new IsActiveResponse
        {
          Result = true
        });
      await Task.Delay(TimeSpan.FromHours(1));
    }
  }

  public override Task<GetMetricSpecResponse> GetMetricSpec(ScaledObjectRef request, ServerCallContext context)
  {
    var resp = new GetMetricSpecResponse();
    resp.MetricSpecs.Add(new MetricSpec
    {
      MetricName = "earthquakeThreshold",
      TargetSize = 10
    });
    return Task.FromResult(resp);
  }

  public override async Task<GetMetricsResponse> GetMetrics(GetMetricsRequest request, ServerCallContext context)
  {
    if (!request.ScaledObjectRef.ScalerMetadata.ContainsKey("latitude") ||
        !request.ScaledObjectRef.ScalerMetadata.ContainsKey("longitude"))
      throw new ArgumentException("longitude and latitude must be specified");

    var longitude = request.ScaledObjectRef.ScalerMetadata["longitude"];
    var latitude = request.ScaledObjectRef.ScalerMetadata["latitude"];

    var earthquakeCount = await GetEarthQuakeCount(longitude, latitude, 1.0);

    var resp = new GetMetricsResponse();
    resp.MetricValues.Add(new MetricValue
    {
      MetricName = "earthquakeThreshold",
      MetricValue_ = earthquakeCount
    });

    return resp;
  }
}