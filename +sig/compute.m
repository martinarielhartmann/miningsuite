% SIG.COMPUTE
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function argouts = compute(algo,varargin)
argouts = recurse(algo,varargin,nargout);


function argouts = recurse(algo,argins,nout)
arg1 = argins{1};
if isa(arg1,'sig.data')
    arg1 = arg1.content;
end
if iscell(arg1)
    l = length(arg1);
    argouts = cell(1,nout);
    for j = 1:nout
        if isa(argins{j},'sig.data')
            argouts{j} = argins{j};
        else
            argouts{j} = cell(1,l);
        end
    end
    for i = 1:l
        argi = argins;
        for j = 1:length(argi)
            if isa(argi{j},'sig.data')
                argj = argi{j}.content;
                if length(argj) == l
                    if iscell(argj)
                        argi{j}.content = argj{i};
                    else
                        argi{j}.content = argj(i);
                    end
                end
            else
                if length(argi{j}) == l
                    if iscell(argi{j})
                        argi{j} = argi{j}{i};
                    else
                        argi{j} = argi{j}(i);
                    end
                end
            end
        end
        y = recurse(algo,argi,nout);
        for j = 1:nout
            if isa(argouts{j},'sig.data')
                argouts{j}.content{i} = y{j}.content;
            else
                argouts{j}{i} = y{j};
            end
        end
    end
else
    argouts = algo(argins{:});
end