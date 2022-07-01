using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.CommandLine;
using System.CommandLine.Invocation;
using System.Linq;
using Amazon;
using Amazon.Runtime;
using Amazon.SQS;
using Amazon.SQS.Model;

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
    {
      Console.WriteLine("  MessageId: {0} Body: {1}", message.MessageId, message.Body);
    }

    if (receiveMessageResponse.Messages.Count > 0)
    {
      var deleteMessageBatchRequest = new DeleteMessageBatchRequest();
      deleteMessageBatchRequest.QueueUrl = myQueueUrl;
      deleteMessageBatchRequest.Entries.AddRange(receiveMessageResponse.Messages.Select(message =>
        new DeleteMessageBatchRequestEntry(message.MessageId, message.ReceiptHandle)));
      await client.DeleteMessageBatchAsync(deleteMessageBatchRequest);
    }
  }

  private static async Task<int> Main()
  {
    var rootCommand = new RootCommand(
      description: "Converts an image file from one format to another.");

    var queueOption = new Option<string>(
      aliases: new[] { "--queue", "-q" }, () => ""
      , description: "The queue in which insert/pull messages.");
    rootCommand.AddOption(queueOption);


    var createOption = new Option<bool>(
      aliases: new[] { "--create", "-c" }
      , description: "Create Queue");
    rootCommand.AddOption(queueOption);

    var batchSize = 10;
    var nBatch = 50;
    var waitingTime = TimeSpan.FromSeconds(3);

    var client = new AmazonSQSClient();

    var createQueue = new CreateQueueRequest();
    createQueue.QueueName = "MyQueue";
    var createQueueResponse = await client.CreateQueueAsync(createQueue);
    var myQueueUrl = createQueueResponse.QueueUrl;


    for (var batch = 0; batch < nBatch; batch++)
    {
      Console.WriteLine("Sending a message to MyQueue.\n");
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
      await Task.Delay(waitingTime);
    }

    await Task.Delay(waitingTime);

    while (await client.GetNumberOfMessages(myQueueUrl) > 0)
    {
      await client.DeleteMessages(myQueueUrl);
      await Task.Delay(waitingTime);
    }

    for (var i = 0; i < 10; i++)
    {
      await client.GetNumberOfMessages(myQueueUrl);
      await client.DeleteMessages(myQueueUrl);
      await Task.Delay(waitingTime);
    }

    return 0;
  }
}