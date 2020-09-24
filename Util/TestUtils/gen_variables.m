function [variables] = gen_variables(dimensions, v_names, v_dims, v_types, v_data, varargin)
% function [variables] = gen_variables(dimensions,v_names,v_dims,v_types,v_data,varargin)
%
% Generate a toolbox variable cell of structs. Empty or incomplete
% arguments will generate random entries.
%
% Inputs:
%
% dimensions - a toolbox dimension cell.
% v_names - a cell of variable names. If cell is empty or
%           out-of-bounds, a random entry is used.
% v_dims - a cell of the variable dimensions indexes. ditto.
% v_types - a cell of MATLAB function handles types. ditto.
% v_data -  a cell with the variable array values. ditto.
% varargin - extra fieldname,fieldvalue to add to each variable.
%            for example: 'comment','test' -> variables.comment = test.
%
% Outputs:
%
% variables - The variable cell.
%
% Example:
% varfields = {'name','typeCastFunc','dimensions','data','coordinates', 'comments'};
% variables = gen_variables();
% assert(iscell(variables))
% assert(~isempty(variables))
% assert(isstruct(variables{1}))
% assert(isequal(fieldnames(variables{1}),transpose(varfields)))
%
% author: hugo.oliveira@utas.edu.au
%
switch nargin
    case 0
        dimensions = gen_dimensions();
        v_names = {};
    case 1
        v_names = {};
    case 2
        v_dims = {};
    case 3
        v_types = {};
    case 4
        v_data = {};
end

is_timeseries = getVar(dimensions, 'TIME') == 1;
is_profile = ~is_timeseries && getVar(dimensions, 'PROFILE') ~= 0;

create_timeseries_var = nargin < 2 && is_timeseries;
create_profile_var = nargin < 2 && is_profile;

if create_timeseries_var
    ts_names = {'TIMESERIES', 'LATITUDE', 'LONGITUDE', 'NOMINAL_DEPTH'};
    ts_dims = {[], [], [], []};
    ts_types = {@int32, @double, @double, @single};
    ts_data = {1, NaN, NaN, NaN};
    coordinates = "TIME LATITUDE LONGITUDE NOMINAL_DEPTH";
    variables = gen_variables(dimensions, ts_names, ts_dims, ts_types, ts_data, 'coordinates', coordinates, 'comments', '');
elseif create_profile_var
    p_names = {'PROFILE', 'TIME', 'DIRECTION', 'LATITUDE', 'LONGITUDE', 'BOT_DEPTH'};
    p_dims = {[], [], [], [], [], [1 2]};
    p_types = {@single, @double, @char, @double, @double, @single};
    p_data = {1, NaN, 'D', NaN, NaN, NaN};
    variables = gen_variables(dimensions, p_names, p_dims, p_types, p_data, 'comments', '');
else
    variables = {};
end

if isempty(v_names)
    return
end

if isempty(varargin)
    varargin = {'comment', ''};
end

ns = numel(variables);
ndata = numel(v_names);
variables{ndata} = {};

for k = ns + 1:ndata

    try
        name = v_names{k};
    catch
        name = random_name(20);
    end

    try
        type = v_types{k};
    catch
        type = random_numeric_typefun(1);
    end

    try
        data = v_data{k};
    catch

        if is_timeseries
            dsize = numel(dimensions{getVar(dimensions, 'TIME')}.data);
        elseif is_profile
            dsize = numel(dimensions{getVar(dimensions, 'DEPTH')}.data);
        else
            dsize = randn(1000, 1);
        end

        data = rand(1, dsize);
    end

    try
        dim = v_dims{k};
    catch
        %guess based on current dimensions or just assign to the first dim
        get_data_size = @(x)(size(x.data));
        dim_sizes = cellfun(get_data_size, dimensions,'UniformOutput',false);
        [~, indexes] = inCell(dim_sizes, size(data));
        if isempty(indexes)
            dim = randi(numel(dimensions), 1);
        else
            dim = indexes(1);
        end
    end
    if isempty(dim)
        %
    elseif ischar(dim)
        error('Variable dimension argument %d contains invalid dimensional index(es): %s',k,dim)
    else
        try
            maxind = 1;
            udim = unique(dim);
            if ~isequal(udim,dim)
                MException()
            end
            if numel(dim) > 1
                for m=1:numel(dim)
                    mdim = dimensions{dim(m)};
                    maxind = maxind*numel(mdim.data);
                end
            else
                mdim = dimensions{dim};
                maxind = maxind*numel(mdim.data);
            end
            data(maxind);
        catch
            fmt=['Variable dimension argument %d contains invalid dimensional index(es): [ ' repmat('%d ',1,numel(dim)) ']'];
            msg=sprintf(fmt,k,dim);
            error(msg);
        end
    end

    variables{k} = struct('name', name, 'typeCastFunc', type, 'dimensions', dim, 'data', data, varargin{:});

end

end
