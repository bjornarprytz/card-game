using Godot;
using System;
using System.Text.Json;
using System.Text.Json.Serialization;

public partial class GameAPI : Node
{
	public void HelloWorld()
	{
		GD.Print("Hello, World!");
	}
	
	public CardProto[]? ParseCardProtos(string json)
	{
		try
		{
			var options = new JsonSerializerOptions
			{
				PropertyNameCaseInsensitive = true,
				ReadCommentHandling = JsonCommentHandling.Skip,
				AllowTrailingCommas = true
			};
			return JsonSerializer.Deserialize<CardPool>(json, options)?.Cards;
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error parsing JSON: {e.Message}");
			return null;
		}
	}
}

internal record CardPool
{
	[JsonPropertyName("cards")]
	public CardProto[] Cards { get; init; } = Array.Empty<CardProto>();
}
