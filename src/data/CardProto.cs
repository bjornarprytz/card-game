using Godot;
using System;
using System.Text.Json.Serialization;
using cardgame.data;

public partial class CardProto : Resource
{
    [JsonPropertyName("name")]
    public string? Name { get; init; }
    [JsonPropertyName("description")]
    public string? Description { get; init; }
    [JsonPropertyName("cost")]
    public int Cost { get; init; }
    [JsonPropertyName("type")]
    public string? Type { get; init; }
    [JsonPropertyName("targetData")]
    public TargetData[] TargetData { get; init; } = { new TargetData() };
    [JsonPropertyName("effects")]
    public EffectProto[]? Effects { get; init; }
}
