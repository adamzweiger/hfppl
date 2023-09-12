from .distribution import Distribution

class LogCategorical(Distribution):
    """A Geometric distribution."""

    def __init__(self, logits):
        """Create a Categorical distribution from unnormalized log probabilities (logits). 
        Given an array of logits, takes their `softmax` and samples an integer in `range(len(logits))`
        from the resulting categorical.
        
        Args:
            logits (np.array): a numpy array of unnormalized log probabilities.
        """
        self.log_probs = log_softmax(logits)

    def sample(self):
        n = np.random.choice(len(self.log_probs), p=np.exp(self.log_probs))
        return n, self.log_prob(n)

    def log_prob(self, value):
        return self.log_probs[value]
    
    def argmax(self, idx):
        return np.argsort(self.log_probs)[-idx]