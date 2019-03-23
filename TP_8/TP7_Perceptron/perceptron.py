import math
import torch


class Perceptron:
    def __init__(self, neurons_per_layout, alpha=0.01, max_rand_weights=5):
        if isinstance(neurons_per_layout, (list, tuple)) and len(neurons_per_layout) != 3:
            raise TypeError('neurons_per_layout must be a list o tuple with 3 values')
        self.W = [max_rand_weights * torch.rand(neurons_per_layout[0], neurons_per_layout[1]),
                  max_rand_weights * torch.rand(neurons_per_layout[1], neurons_per_layout[2])]
        self.alpha = alpha
        self.P = [torch.Tensor(neurons_per_layout[1]), torch.Tensor(neurons_per_layout[2])]
        self.deltas = [torch.Tensor(neurons_per_layout[1]), torch.Tensor(neurons_per_layout[2])]

    def activation_sigmoid(self, output):
        return 1/(1+math.e**(-1*output))

    def compute_delta(self, output, layout, t=None):
        self.deltas[layout] = output*(1 - output)
        if layout == 1:
            self.deltas[layout] *= output - t
        else:
            self.deltas[layout] *= self.deltas[1].mm(self.W[1])

    def compute_back_propagation(self, x, y_o, y_s, t):
        self.compute_delta(y_s, 1, t)
        self.compute_delta(y_o, 0)
        self.update_weights_by_delta(x, y_o)

    def compute_feed_forward(self):
        pass

    def compute_net_weight(self, x, layout):
        self.P[layout] = x.mm(self.W[layout])

    def train(self, epoch, X, T):
        for i in range(epoch):
            print('Epoch', i)
            for j in range(len(X)):
                print('Data', j + 1)
                x = X[j].resize(1, X[j].size()[0])
                self.compute_net_weight(x, 0)
                y_o = self.activation_sigmoid(self.P[0])
                self.compute_net_weight(y_o, 1)
                y_s = self.activation_sigmoid(self.P[1])
                print('Weights={}\nNet Weights={}\nOutput O={}\nOutput S={}\nTarget={}\n'.format(self.W, self.P,
                                                                                                 y_o, y_s, T[j]))
                # Feed forward
                self.compute_back_propagation(x, y_o, y_s, T[j])

    def update_weights_by_delta(self, x, y_o):
        self.W[1] -= self.alpha * self.deltas[1] * y_o
        self.W[0] -= self.alpha * self.deltas[0] * x

    def valid_error(self, X, T):
        pass

    def valid_sample(self, X):
        pass


torch.manual_seed(0)

neuronPerLayout = [2, 2, 2]
iterationNumber = 10000
X_XOR = torch.FloatTensor([[0, 0], [0, 1], [1, 0], [1, 1]])
T_XOR = torch.FloatTensor([0, 1, 1, 0])

red = Perceptron(neuronPerLayout, 0.001, 1)
red.train(iterationNumber, X_XOR, T_XOR)
