function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

X = [ones(m, 1) X];
a2 = sigmoid(X * Theta1');

a2 = [ones(m, 1) a2];
h = sigmoid(a2 * Theta2');

for c = 1:num_labels
  y2 = (y == c);
  J = J - 1/m*(log(h(:,c))' * y2 + log(1-h(:,c))' * (1 - y2));
endfor

th1sq = Theta1 .* Theta1;
th2sq = Theta2 .* Theta2;
th1sq(:,1) = 0;
th2sq(:,1) = 0;
J = J + lambda/(2*m)*(sum(th1sq(:))+sum(th2sq(:)));

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%

for t = 1:m
  a1 = X(t,:);  % a1 is a row vector
  z2 = a1 * Theta1';
  a2 = sigmoid(z2); % a2 is a row vector

  a2 = [1 a2];
  z3 = a2 * Theta2';
  a3 = sigmoid(z3); % a3 is a row vector
  for c = 1:num_labels
    d3(c) = a3(c) - (y(t) == c);
  endfor
  d2 = d3 * Theta2; % dimension 1x26
  d2 = d2(2:end);  % remove d2_0
  d2 = d2 .* sigmoidGradient(z2);  % dimension 1x25 
%  d3 = d3(2:end);
  Theta2_grad = Theta2_grad + d3' * a2;
%  d2 = d2(2:end);
  Theta1_grad = Theta1_grad + d2' * a1;
endfor

Theta1_grad = Theta1_grad/m;
Theta2_grad = Theta2_grad/m;


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

reg1 = lambda/m * Theta1;
reg2 = lambda/m * Theta2;
reg1(:, 1) = 0;
reg2(:, 1) = 0;
Theta1_grad = Theta1_grad + reg1;
Theta2_grad = Theta2_grad + reg2;

















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
