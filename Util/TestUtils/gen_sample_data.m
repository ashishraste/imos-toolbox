function [sample_data] = gen_sample_data(dimensions, variables, meta, varargin)
% function [sample_data]] = gen_sample_data(dimensions,variables,meta,varargin)
%
% Create a sample_data toolbox structure
%
% Inputs:
%
% dimensions - the dimensional struct. Use empty for auto-generated.
% variables -  the variable struct. ditto.
% meta - the meta struct. ditto.
% varargin - other attributes to assign at the root level.
%
% Outputs:
%
% sample_data - a toolbox sample_data struct.
%
% Example:
%
% [sample_data] = gen_sample_data();
% assert(iscell(sample_data.dimensions))
% assert(~isempty(sample_data.dimensions))
% assert(isstruct(sample_data.dimensions{1}))
% assert(~isempty(fieldnames(sample_data.dimensions{1})))
% assert(isfield(sample_data.dimensions{1},'name'))
% assert(iscell(sample_data.variables))
% assert(~isempty(sample_data.variables))
% assert(isstruct(sample_data.variables{1}))
% assert(~isempty(fieldnames(sample_data.variables{1})))
% assert(isfield(sample_data.variables{1},'data'))
% assert(isstruct(sample_data.meta))
% assert(isfield(sample_data.meta,'site_id'))
% assert(isfield(sample_data,'toolbox_input_file'))
% assert(isfield(sample_data,'time_coverage_start'))
% assert(isfield(sample_data,'instrument_nominal_depth'))
%
% author: hugo.oliveira@utas.edu.au
%
if nargin < 1
    dimensions = gen_dimensions();
end

if nargin < 2
    variables = gen_variables(dimensions);
end

if nargin < 3
    meta_args = {...
                'site_id', '[site_id]', ...
                'instrument_make', '[make]', ...
                'instrument_model', '[model]', ...
                'instrument_serial_no', '[serial_no]', ...
                'depth', 999
            };
    meta = struct(meta_args{:});
end

root_args = {...
            'toolbox_input_file', '', ...
            'time_coverage_start', 0, ...
            'time_coverage_end', 1, ...
            'instrument_nominal_height', 1, ...
            'instrument_nominal_depth', 1, ...
            'site_nominal_depth', 1, ...
            'site_depth_at_deployment', 1, ...
            'dimensions', {dimensions}, ...
            'variables', {variables}, ...
            'meta', meta, ...
            varargin{:}, ...
            };
sample_data = struct(root_args{:});
end
