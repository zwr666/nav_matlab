%% 最小二乘法多边测距
% sv_pos: 基站位置 mxn m: 维:2 or 3, n 基站个数
% pos:  mx1  m:2or3
% pr:  伪距 mx1
%dim : 2 or 3 : 2:2D定位  3: 3D定位
function pos = ch_multilateration(sv_pos, pos, pr, dim)

B1= 0.1;
END_LOOP=100;
sv_num = size(sv_pos, 2);
max_retry = 5;
last_pos = pos;

if sv_num < 3
    return
end


while (END_LOOP > B1 && max_retry > 0)
    % 获得当前位置与各个基站的距离
    r = vecnorm(sv_pos - pos);
    
    % 求得H矩阵
    H = (sv_pos - pos) ./ r;
    if dim == 2
        H = [H [0 0 -1]'];
    end
    H =-H';
    
    dp = (pr - r)';
    if dim == 2
        dp = [dp; 0];
    end
    
    % 迭代用户距离
    delta =  (H'*H)^(-1)*H'*dp;
    
    %计算残差
    END_LOOP = norm(delta);
    
    %更新位置
    pos = pos + delta;
    max_retry = max_retry - 1;
    
    %迭代失败
    if(max_retry == 0 && END_LOOP > 10)
        pos = last_pos;
        return;
    end
    
end

end



%
% % 最小二乘法多边测距
%
% function pos = ch_multilateration(anchor_pos,  pos, pr)
%
% pr = pr(1:size(anchor_pos, 2));
%
% b = vecnorm(anchor_pos).^(2) - pr.^(2);
% b = b(1:end-1) - b(end);
% b = b';
%
% A =  anchor_pos - anchor_pos(:,end);
% A = A(:,1:end-1)'*2;
%
% pos = (A'*A)^(-1)*A'*b;
%
%
% end

