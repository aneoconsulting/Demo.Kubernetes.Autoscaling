using System;
using System.Collections.Concurrent;
using System.Threading.Tasks;

using Amazon.SQS;
using Amazon.SQS.Model;

using Externalscaler;

using Grpc.Core;

namespace Scaler.Services;

public class ScalerService : ExternalScaler.ExternalScalerBase
{
  private static readonly ConcurrentDictionary<string, ConcurrentBag<IServerStreamWriter<IsActiveResponse>>> Streams =
    new();

  private static async Task<int> GetMessageCount(string queue)
  {
    var client = new AmazonSQSClient();

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
    if (!request.ScalerMetadata.ContainsKey("sqsQueue"))
      throw new ArgumentException("SQS Queue name should be specified");

    var queue = request.ScalerMetadata["sqsQueue"];
    var messageCount = await GetMessageCount(queue);
    return new IsActiveResponse
    {
      Result = messageCount > 1
    };
  }

  public override async Task StreamIsActive(ScaledObjectRef request,
    IServerStreamWriter<IsActiveResponse> responseStream, ServerCallContext context)
  {
    if (!request.ScalerMetadata.ContainsKey("sqsQueue"))
      throw new ArgumentException("SQS Queue name should be specified");

    var queue = request.ScalerMetadata["sqsQueue"];

    while (!context.CancellationToken.IsCancellationRequested)
    {
      var messageCount = await GetMessageCount(queue);
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
    if (!request.ScaledObjectRef.ScalerMetadata.ContainsKey("sqsQueue"))
      throw new ArgumentException("SQS Queue name should be specified");

    var queue = request.ScaledObjectRef.ScalerMetadata["sqsQueue"];

    var messageCount = await GetMessageCount(queue);

    var resp = new GetMetricsResponse();
    resp.MetricValues.Add(new MetricValue
    {
      MetricName = "messageCount",
      MetricValue_ = messageCount
    });

    return resp;
  }
}