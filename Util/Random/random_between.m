function [arr] = random_between(a,b,n,type)
% function [arr] = random_between(a,b,n,type)
%
% Draw n numbers from the ]a-b[ range.
%
% Inputs:
%
% a - start of random range (inclusive)
% b - end of random range (inclusive)
% n - the number of draws
% type - optional type string.
%      - default: 'double'
%      - available: 'double','int', or 'logical'.
% Outputs:
%
% arr - an array of size 1xn with random numbers in the ]a,b[ open interval.
%
% Example:
%
% for k=1:1000
%	 [arr] = random_between(0,1,10)
%    assert(min(arr)>0);
% 	 assert(max(arr)<1);
% end
%
% from: https://www.mathworks.com/help/matlab/math/floating-point-numbers-within-specific-range.html
% author: hugo.oliveira@utas.edu.au
%

% Copyright (C) 2020, Australian Ocean Data Network (AODN) and Integrated
% Marine Observing System (IMOS).
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.
% If not, see <https://www.gnu.org/licenses/gpl-3.0.en.html>.
%
if nargin>3
	if contains(type,'int')
		range = [a+1,b-1];
		arr = randi([min(range) max(range)],1,n);
		return
	end
	if contains(type,'logical')
		arr = logical(randi([0,1],1,n));
		return
	end
end
if nargin<3
	n = 1;
end
arr = (b-a).*rand(1,n) + a;
end
