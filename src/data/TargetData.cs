using System.Text.Json.Serialization;

namespace cardgame.data;

public record TargetData
{
	[JsonPropertyName("requiredType")]
	public string? RequiredType { get; init; }
}
