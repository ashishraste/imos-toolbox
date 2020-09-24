function dimensions = gen_dimensions(type, ndims, names, types, datac, varargin)
%function dimensions = gen_dimensions(type, ndims, names, types, datac, varargin)
%
% Generate a toolbox dimension cell of structs. Empty or incomplete
% arguments will generate random entries.
%
% Inputs:
%
%  type - `timeSeries` | `profile`. If empty, 'timeSeries' is used.
%  ndims - number of dimensions [int]. If empty, 1 is used.
%  names - dimension names [cell{str}]. if empty, randomized named.
%  types - dimension types [cell{@function_handle}]. Ditto.
%  datac - dimension data [cell{any}]. Ditto.
%  varargin - extra parameters are cast to all structure fieldnames.
%
% Outputs:
%
%  d - a cell with dimensions structs.
%
% Example:
%
% dimensions = gen_dimensions('timeSeries',1,{'TIME'},{@double},{[1:10]},'calendar','gregorian','start_offset',10);
% tdim = dimensions{1};
% assert(isequal(tdim.name,'TIME'))
% assert(isequal(tdim.typecastFunc,@double))
% assert(all(isequal(tdim.data,1:10)));
% assert(strcmp(tdim.calendar,'gregorian'));
% assert(tdim.start_offset==10);
%
% author: hugo.oliveira@utas.edu.au
%
if nargin < 1
    type = 'timeSeries';
end

if nargin < 2
    if strcmpi(type, 'timeSeries')
        ndims = 1;
        ts_names = {'TIME'};
        ts_types = {@double};
        ts_datac = {1/86400:1/86400:1};
        dimensions = gen_dimensions(type,ndims,ts_names,ts_types,ts_datac,'comment','');
        return
    elseif strcmpi(type, 'profile')
        ndims = 2;
        p_names = {'DEPTH', 'PROFILE'};
        p_types = {'@single', '@int32'};
        p_datac = {random_between(-5, 12000, 100, 'int'), int32(1)};
        dimensions = gen_dimensions(type,ndims,p_names,p_types,p_datac);
        dimensions{1}.comment = '';
        dimensions{1}.axis = 'Z';
        return
    else
        ndims = 1;
        names = random_names();
        types = random_numeric_typefun();
        typecast = types{1};
        datac = {typecast(randn(1, 100))};
    end

end

dimensions = cell(1, ndims);

for k = 1:ndims

    try
        name = names{k};
    catch
        name = random_names();
        name = name{1};
    end

    try
        type = types{k};
    catch
        type = random_numeric_typefun();
        type = type{1};
    end

    try
        data = datac{k};
    catch
        data = type(randn(1, 100));
    end

    dimensions{k} = struct('name', name, 'typecastFunc', type, 'data', data, varargin{:});
end

end
