% *************************************************************************
% * Copyright 2015 University of Bonn
% *
% * authors:
% *  - Sebastian Merzbach <merzbach@cs.uni-bonn.de>
% *
% * last modification date: 2015-03-30
% *
% * This file is part of btflib.
% *
% * btflib is free software: you can redistribute it and/or modify it under
% * the terms of the GNU Lesser General Public License as published by the
% * Free Software Foundation, either version 3 of the License, or (at your
% * option) any later version.
% *
% * btflib is distributed in the hope that it will be useful, but WITHOUT
% * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
% * License for more details.
% *
% * You should have received a copy of the GNU Lesser General Public
% * License along with btflib.  If not, see <http://www.gnu.org/licenses/>.
% *
% *************************************************************************
%
% Read bidirectional sampling to a file in one of Bonn University's binary
% formats.
function meta = read_bidir_sampling(fid, meta)
    meta.nV = fread(fid, 1, 'uint32');
    V = zeros(meta.nV, 2);
    L = [];
    for vi = 1 : meta.nV
        V(vi, :) = fread(fid, 2, 'single');
        num_lights = fread(fid, 1, 'uint32');
        if (isempty(L))
            L = utils.fread_matrix(fid, 'single', num_lights, 2);
            meta.nL = num_lights;
        elseif (num_lights ~= meta.nL)
            error('currently only fixed light hemisphere allowed!!');
        else
            fread(fid,  2 * num_lights, 'single'); %skip light directions
        end
    end
    clear v num_lights;
    
    meta.L = utils.sph2cart2(L);
    meta.V = utils.sph2cart2(V);
    
    if size(meta.L, 2) == 1
        meta.L = meta.L';
    end
    assert(size(meta.L, 2) == 3);
    
    if size(meta.V, 2) == 1
        meta.V = meta.V';
    end
    assert(size(meta.V, 2) == 3);
    
    meta.nL = size(L, 1);
end
