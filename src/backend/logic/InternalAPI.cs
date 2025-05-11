using System.Collections.Generic;

namespace cardgame;

internal class InternalAPI
{
    private CardPool? CardPool { get; set; }
	
    private Dictionary<string, CardProto> Cards { get; set; } = new();
    
    internal IEnumerable<string> GetCardNames()
    {
        if (CardPool == null)
        {
            yield break;
        }

        foreach (var card in CardPool.Cards)
        {
            if (card.Name != null)
            {
                yield return card.Name;
            }
        }
    }
    
    
    internal bool TryInitCardPool(CardPool? cardPool, out string error)
    {
        error = "";
        
        if (CardPool != null)
        {
            error = "CardPool already initialized.";
            return false;
        }
        
        if (cardPool == null)
        {
            error = "CardPool is null.";
            return false;
        }
        

        foreach (var card in cardPool.Cards)
        {
            if (card.Name == null)
            {
                error = "Card name is null.";
                return false;
            }

            if (!Cards.TryAdd(card.Name, card))
            {
                error = $"Card with name {card.Name} already exists.";
                return false;
            }
        }

        return true;
    }
    
    public CardProto? TryGetCard(string name, out string error)
    {
        error = "";
        
        if (Cards.TryGetValue(name, out var card))
        {
            return card;
        }

        error = $"Card with name {name} not found.";
        return null;
    }
    
}