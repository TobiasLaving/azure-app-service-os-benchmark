var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

app.MapGet("/test", async (context) =>
{
    var size = context.Request.Query["size"];
    if (string.IsNullOrEmpty(size))
    {
        await context.Response.WriteAsync("Hello");
        return;
    }

    int sizeInBytes = int.Parse(size) * 1024;
    string responseString = new string('A', sizeInBytes);
    context.Response.ContentType = "text/plain";
    await context.Response.WriteAsync(responseString);
});

app.Run();
