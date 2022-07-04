using System;
using System.Collections.Concurrent;
using System.Threading.Tasks;

using Amazon;
using Amazon.SQS;
using Amazon.SQS.Model;

using Externalscaler;

using Grpc.Core;

namespace Scaler.Services;

public class ScalerService : ExternalScaler.ExternalScalerBase
{
  private static readonly ConcurrentDictionary<string, ConcurrentBag<IServerStreamWriter<IsActiveResponse>>> Streams =
    new();

  private static async Task<int> GetMessageCount(string queue, string region)
  {
    var client = new AmazonSQSClient(RegionEndpoint.GetBySystemName(region));

    var createQueue = new CreateQueueRequest
    {
      QueueName = queue
    };
    var createQueueResponse = await client.CreateQueueAsync(createQueue);
    var myQueueUrl = createQueueResponse.QueueUrl;

    var getQueueAttributesRequest = new GetQueueAttributesRequest
    {
      QueueUrl = myQueueUrl
    };
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessages);
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessagesNotVisible);
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessagesDelayed);

    var queueAttributes = await client.GetQueueAttributesAsync(getQueueAttributesRequest);
    return queueAttributes.ApproximateNumberOfMessages + queueAttributes.ApproximateNumberOfMessagesNotVisible;
  }

  public override async Task<IsActiveResponse> IsActive(ScaledObjectRef request, ServerCallContext context)
  {
    if (!request.ScalerMetadata.ContainsKey("sqsQueue")
        || !request.ScalerMetadata.ContainsKey("region"))
      throw new ArgumentException("SQS Queue name and region should be specified");

    var queue = request.ScalerMetadata["sqsQueue"];
    var region = request.ScalerMetadata["region"];
    var messageCount = await GetMessageCount(queue, region);
    return new IsActiveResponse
    {
      Result = messageCount > 1
    };
  }

  public override async Task StreamIsActive(ScaledObjectRef request,
    IServerStreamWriter<IsActiveResponse> responseStream, ServerCallContext context)
  {
    if (!request.ScalerMetadata.ContainsKey("sqsQueue")
        || !request.ScalerMetadata.ContainsKey("region"))
      throw new ArgumentException("SQS Queue name and region should be specified");

    var queue = request.ScalerMetadata["sqsQueue"];
    var region = request.ScalerMetadata["region"];

    while (!context.CancellationToken.IsCancellationRequested)
    {
      var messageCount = await GetMessageCount(queue, region);
      if (messageCount > 1)
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
      MetricName = "messageCount",
      TargetSize = 10
    });
    return Task.FromResult(resp);
  }

  public override async Task<GetMetricsResponse> GetMetrics(GetMetricsRequest request, ServerCallContext context)
  {
    if (!request.ScaledObjectRef.ScalerMetadata.ContainsKey("sqsQueue")
        || !request.ScaledObjectRef.ScalerMetadata.ContainsKey("region"))
      throw new ArgumentException("SQS Queue name and region should be specified");

    var queue = request.ScaledObjectRef.ScalerMetadata["sqsQueue"];
    var region = request.ScaledObjectRef.ScalerMetadata["region"];

    var messageCount = await GetMessageCount(queue, region);

    var resp = new GetMetricsResponse();
    resp.MetricValues.Add(new MetricValue
    {
      MetricName = "messageCount",
      MetricValue_ = messageCount
    });

    return resp;
  }
}