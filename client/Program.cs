using System;
using System.Linq;
using System.Threading.Tasks;

namespace Client;

public static class Program
{
  private static async Task<int> GetNumberOfMessages(this IAmazonSQS client, string myQueueUrl)
  {
    Console.WriteLine("Printing Queue Attributes");
    var getQueueAttributesRequest = new GetQueueAttributesRequest();
    getQueueAttributesRequest.QueueUrl = myQueueUrl;
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessages);
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessagesNotVisible);
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.ApproximateNumberOfMessagesDelayed);
    getQueueAttributesRequest.AttributeNames.Add(QueueAttributeName.MessageRetentionPeriod);

    var queueAttributes = await client.GetQueueAttributesAsync(getQueueAttributesRequest);
    Console.WriteLine($" ApproximateNumberOfMessages : {queueAttributes.ApproximateNumberOfMessages}");
    Console.WriteLine(
      $" ApproximateNumberOfMessagesNotVisible : {queueAttributes.ApproximateNumberOfMessagesNotVisible}");
    Console.WriteLine($" ApproximateNumberOfMessagesDelayed : {queueAttributes.ApproximateNumberOfMessagesDelayed}");
    Console.WriteLine($" MessageRetentionPeriod : {queueAttributes.MessageRetentionPeriod}");

    return queueAttributes.ApproximateNumberOfMessages + queueAttributes.ApproximateNumberOfMessagesNotVisible;
  }

  private static async Task DeleteMessages(this IAmazonSQS client, string myQueueUrl)
  {
    var receiveMessageRequest = new ReceiveMessageRequest();
    receiveMessageRequest.QueueUrl = myQueueUrl;
    receiveMessageRequest.MaxNumberOfMessages = 10;
    receiveMessageRequest.VisibilityTimeout = 5;
    var receiveMessageResponse = await client.ReceiveMessageAsync(receiveMessageRequest);
    Console.WriteLine("Printing received message.\n");
    foreach (var message in receiveMessageResponse.Messages)
      Console.WriteLine("  MessageId: {0} Body: {1}", message.MessageId, message.Body);

    if (receiveMessageResponse.Messages.Count > 0)
    {
      var deleteMessageBatchRequest = new DeleteMessageBatchRequest();
      deleteMessageBatchRequest.QueueUrl = myQueueUrl;
      deleteMessageBatchRequest.Entries.AddRange(receiveMessageResponse.Messages.Select(message =>
        new DeleteMessageBatchRequestEntry(message.MessageId, message.ReceiptHandle)));
      await client.DeleteMessageBatchAsync(deleteMessageBatchRequest);
    }
  }


  private static async Task HandlerFunc(string queue, string region, int batchSize, int batchNumber,
    TimeSpan batchDelay)
  {
    var client = new AmazonSQSClient(RegionEndpoint.GetBySystemName(region));

    var createQueue = new CreateQueueRequest
    {
      QueueName = queue
    };
    var createQueueResponse = await client.CreateQueueAsync(createQueue);
    var myQueueUrl = createQueueResponse.QueueUrl;


    for (var batch = 0; batch < batchNumber; batch++)
    {
      Console.WriteLine($"Sending a message to {queue}.");
      var sendMessageRequest = new SendMessageBatchRequest();
      sendMessageRequest.QueueUrl = myQueueUrl;

      sendMessageRequest.Entries.AddRange(Enumerable.Range(0, batchSize).Select(_ =>
      {
        var entry = new SendMessageBatchRequestEntry();
        entry.MessageBody = "This is my message text." + DateTime.UtcNow;
        entry.Id = Guid.NewGuid().ToString();
        return entry;
      }));

      await client.SendMessageBatchAsync(sendMessageRequest);
      await Task.Delay(batchDelay);
    }

    await Task.Delay(batchDelay);

    while (await client.GetNumberOfMessages(myQueueUrl) > 0)
    {
      await client.DeleteMessages(myQueueUrl);
      await Task.Delay(batchDelay);
    }

    for (var i = 0; i < 10; i++)
    {
      await client.GetNumberOfMessages(myQueueUrl);
      await client.DeleteMessages(myQueueUrl);
      await Task.Delay(batchDelay);
    }
  }

  private static async Task Main(string[] args)
  {
    var rootCommand = new RootCommand(
      "Inserts and removes messages from AWS SQS.");

    var queueOption = new Option<string>(
      new[] { "--queue", "-q" }, () => "myQueue"
      , "The queue in which insert/pull messages.");
    rootCommand.AddOption(queueOption);

    var regionOption = new Option<string>(
      new[] { "--region", "-r" }, () => "us-east-2"
      , "The AWS region in which the SQS instance should be located.");
    rootCommand.AddOption(regionOption);

    var batchSizeOption = new Option<int>(
      new[] { "--batchsize", "-b" }, () => 10
      , "The number of messages to put in the SQS instance at a time.");
    rootCommand.AddOption(batchSizeOption);

    var batchNumberOption = new Option<int>(
      new[] { "--batchnumber", "-n" }, () => 10
      , "The number of batches to insert in the SQS instance.");
    rootCommand.AddOption(batchNumberOption);

    var batchDelayOption = new Option<TimeSpan>(
      new[] { "--batchdelay", "-d" }, () => TimeSpan.FromSeconds(3)
      , "The delay between the insertion of two batches in the SQS instance.");
    rootCommand.AddOption(batchDelayOption);

    rootCommand.SetHandler(HandlerFunc, queueOption, regionOption, batchSizeOption,
      batchNumberOption, batchDelayOption);

    await rootCommand.InvokeAsync(args);
  }
}