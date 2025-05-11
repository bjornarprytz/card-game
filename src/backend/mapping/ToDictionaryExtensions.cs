using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Godot.Collections;

namespace cardgame.backend.mapping;

internal static class ToDictionaryExtensions
{
    public static Dictionary? ToDictionary<T>(this T? obj)
        where T : class
    {
        if (obj == null)
        {
            return null;
        }
        
        return obj.ToDictionaryInternal();
    }
    
    private static Dictionary? ToDictionaryInternal(this object? obj)
    {
        if (obj == null)
        {
            return null;
        }
        
        var dict = new Dictionary();
        
        var properties = obj.GetType().GetProperties();
        
        foreach (var property in properties)
        {
            var value = property.GetValue(obj);
            if (value is IEnumerable<object> enumerable)
            {
                var list = new Godot.Collections.Array();
                foreach (var item in enumerable.Select(ToDictionaryInternal))
                {
                    if (item == null)
                    {
                        continue;
                    }
                    
                    list.Add(item);
                }
                dict[property.Name] = list;
            }
            else
            {
                // TODO: Handle other types
            }
        }
        
        return dict;
    }
}