function [varargout]=genum(data,varargin)
%GENUM    Get enum string id from SAClab enum header field
%
%    Description: Returns cellstrings containing enum id strings 
%     corresponding to each field/value.
%
%    Usage: [enumcellstr1,enumcellstr2,...]=genum(data,'field1','field2',...)
%
%    Examples:
%     To check if all records are timeseries:
%      if(all(strcmp(genum(data,'iftype'),'itime')))
%          disp('timeseries dataset')
%      end
%
%    See also: gh, glgc, genumdesc

% do nothing on no input
if(nargin<2); return; end

% preallocate output
varnargin=length(varargin);
nvarargout=cell(1,varnargin);
varargout=nvarargout;
[varargout{:}]=deal(cell(length(data),1));

% get header info
[nvarargout{:}]=gh(data,varargin{:});

% loop over versions
v=[data.version];
for i=unique(v)
    % grab header setup
    h=sachi(i);
    
    % indexing of data with this header version
    ind=find(v==i);
    
    % loop over fields
    for j=1:length(varargin)
        varargout{j}(ind)=h.enum(1).id(nvarargout{j}(ind)+1);
    end
end

end

