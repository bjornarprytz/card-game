using Godot;
using System;
using System.Linq;
using System.Text.Json;
using cardgame;
using cardgame.backend.mapping;
using Godot.Collections;
using Array = System.Array;

public partial class GameAPI : Node
{
	private readonly InternalAPI _internalApi = new ();
	
	public string[] ParseCardPool(string json)
	{
		try
		{
			var options = new JsonSerializerOptions
			{
				PropertyNameCaseInsensitive = true,
				ReadCommentHandling = JsonCommentHandling.Skip,
				AllowTrailingCommas = true
			};
			var cardPool = JsonSerializer.Deserialize<CardPool>(json, options);

			if (!_internalApi.TryInitCardPool(cardPool, out var error))
			{
				GD.PrintErr(error);
				return Array.Empty<string>();
			}

			return _internalApi.GetCardNames().ToArray();
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error parsing JSON: {e.Message}");
			return Array.Empty<string>();
		}
	}
	
	public Variant GetCard(string name)
	{
		if (_internalApi.TryGetCard(name, out var error) is not CardProto card)
		{
			GD.PrintErr(error);
			return new Dictionary<string, Variant>();
		}
		if (card.ToDictionary() is not { } dict)
		{
			GD.PrintErr("Card is null");
			return new Dictionary<string, Variant>();
		}

		return Variant.CreateFrom(dict);
	}

	public Variant ResolveCard(string name, Variant playContext)
	{
		throw new NotImplementedException();
	}
	
}


