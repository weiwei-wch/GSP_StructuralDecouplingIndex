function fiff_write_double_matrix(fid,kind,mat)
%
% fiff_write_double_matrix(fid,kind,mat)
% 
% Writes a double-precision floating-point matrix tag
%
%     fid           An open fif file descriptor
%     kind          The tag kind
%     mat           The data matrix
%

%
%
%   Author : Matti Hamalainen, MGH Martinos Center
%   License : BSD 3-clause
%
%   Revision 1.1  2006/09/23 14:43:56  msh
%   Added routines for writing complex and double complex matrices.
%   Added routine for writing double-precision real matrix.
%
%

me='MNE:fiff_write_double_matrix';

if nargin ~= 3
   error(me,'Incorrect number of arguments');
end

if length(size(mat)) ~= 2
   error(me,'Input should be a two-dimensional matrix');
end

FIFFT_DOUBLE  = 5;
FIFFT_MATRIX = bitshift(1,30);
FIFFT_MATRIX_DOUBLE = bitor(FIFFT_DOUBLE,FIFFT_MATRIX);
FIFFV_NEXT_SEQ=0;

datasize = 8*numel(mat) + 4*3;

count = fwrite(fid,int32(kind),'int32');
if count ~= 1
    error(me,'write failed');
end
count = fwrite(fid,int32(FIFFT_MATRIX_DOUBLE),'int32');
if count ~= 1
    error(me,'write failed');
end
count = fwrite(fid,int32(datasize),'int32');
if count ~= 1
    error(me,'write failed');
end
count = fwrite(fid,int32(FIFFV_NEXT_SEQ),'int32');
if count ~= 1
    error(me,'write failed');
end
count = fwrite(fid,double(mat'),'double');
if count ~= numel(mat)
    error(me,'write failed');
end
dims(1) = size(mat,2);
dims(2) = size(mat,1);
dims(3) = 2;
count = fwrite(fid,int32(dims),'int32');
if count ~= 3
    error(me,'write failed');
end

return;

