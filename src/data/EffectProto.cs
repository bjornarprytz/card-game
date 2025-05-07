using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace cardgame.data;

public record EffectProto
{
    [JsonPropertyName("keyword")]
    public string? Keyword { get; init; }

    [JsonPropertyName("targetIndex")] 
    public int TargetIndex { get; init; } = 0;
    
    [JsonPropertyName("parameters")]
    public List<object>? Parameters { get; init; }
}