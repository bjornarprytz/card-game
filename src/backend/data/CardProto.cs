using Godot;
using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;
using cardgame.data;

internal record CardPool
{
    [JsonPropertyName("cards")]
    public CardProto[] Cards { get; init; } = Array.Empty<CardProto>();
}

internal record CardProto
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

internal record EffectProto
{
    [JsonPropertyName("keyword")]
    public string? Keyword { get; init; }

    [JsonPropertyName("targetIndex")] 
    public int TargetIndex { get; init; } = 0;
    
    [JsonPropertyName("parameters")]
    public List<object>? Parameters { get; init; }
}


internal record TargetData
{
    [JsonPropertyName("requiredType")]
    public string? RequiredType { get; init; }
}
