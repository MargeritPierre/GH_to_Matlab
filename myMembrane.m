function [U1,U2] = myMembrane(XX,YY,F,E) 
display(char(10)) ;
display('Solving...')        
        
% Initialisation
    [nY,nX] = size(XX) ;
    U1 = zeros(nY,nX) ; U2 = U1 ;
    XX = XX/1000 ;
    YY = YY/1000 ;
    
% Infos
    dx = XX(1,2)-XX(1,1) ;
    dy = YY(2,1)-YY(1,1) ;
    nPts = nX*nY ;
    MASK = reshape(1:nPts,[nY nX]) ;
    
% Build derivation kernels (finite differences)          
    nonzeros_dx = 2*nPts ;  
    nonzeros_dy = 2*nPts ;    
    nonzeros_dx2 = 3*nPts + 2*nY ;  
    nonzeros_dy2 = 3*nPts + 2*nX ; 
    % Pre-Indices
        indI_dx = zeros(nonzeros_dx,1) ;
        indJ_dx = zeros(nonzeros_dx,1) ;
        v_dx = zeros(nonzeros_dx,1) ;
        last_dx = 0 ;
        indI_dx2 = zeros(nonzeros_dx2,1) ;
        indJ_dx2 = zeros(nonzeros_dx2,1) ;
        v_dx2 = zeros(nonzeros_dx2,1) ;
        last_dx2 = 0 ;
        indI_dy = zeros(nonzeros_dy,1) ;
        indJ_dy = zeros(nonzeros_dy,1) ;
        v_dy = zeros(nonzeros_dy,1) ;
        last_dy = 0 ;
        indI_dy2 = zeros(nonzeros_dy2,1) ;
        indJ_dy2 = zeros(nonzeros_dy2,1) ;
        v_dy2 = zeros(nonzeros_dy2,1) ;
        last_dy2 = 0 ;
    for xx = 1:nX
        for yy = 1:nY
            pt = MASK(yy,xx) ;
            if xx==1
                ind_dx = 0:1 ;
                kern_dx = [-1 1] ;
                ind_dx2 = 0:3 ;
                kern_dx2 = [2 -5 4 -1] ;
            elseif xx==nX
                ind_dx = -1:0 ;
                kern_dx = [-1 1] ;
                ind_dx2 = -3:0 ;
                kern_dx2 = [-1 4 -5 2] ;
            else
                ind_dx = [-1 1] ;
                kern_dx = [-1 1]/2 ;
                ind_dx2 = -1:1 ;
                kern_dx2 = [1 -2 1] ;
            end
            if yy==1
                ind_dy = 0:1 ;
                kern_dy = [-1 1] ;
                ind_dy2 = 0:3 ;
                kern_dy2 = [2 -5 4 -1] ;
            elseif yy==nY
                ind_dy = -1:0 ;
                kern_dy = [-1 1] ;
                ind_dy2 = -3:0 ;
                kern_dy2 = [-1 4 -5 2] ;
            else
                ind_dy = [-1 1] ;
                kern_dy = [-1 1]/2 ;
                ind_dy2 = -1:1 ;
                kern_dy2 = [1 -2 1] ;
            end
            % Indexing
                % dU_dx
                    l_dx = length(ind_dx) ;
                    indI_dx(last_dx+(1:l_dx)) = pt ;
                    indJ_dx(last_dx+(1:l_dx)) = MASK(yy,xx+ind_dx) ;
                    v_dx(last_dx+(1:l_dx)) = kern_dx/dx ;
                    last_dx = last_dx + l_dx ;
                % dU_dx2
                    l_dx2 = length(ind_dx2) ;
                    indI_dx2(last_dx2+(1:l_dx2)) = pt ;
                    indJ_dx2(last_dx2+(1:l_dx2)) = MASK(yy,xx+ind_dx2) ;
                    v_dx2(last_dx2+(1:l_dx2)) = kern_dx2/dx^2 ;
                    last_dx2 = last_dx2 + l_dx2 ;
                % dU_dy
                    l_dy = length(ind_dy) ;
                    indI_dy(last_dy+(1:l_dy)) = pt ;
                    indJ_dy(last_dy+(1:l_dy)) = MASK(yy+ind_dy,xx) ;
                    v_dy(last_dy+(1:l_dy)) = kern_dy/dy ;
                    last_dy = last_dy + l_dy ;
                % dU_dx2
                    l_dy2 = length(ind_dy2) ;
                    indI_dy2(last_dy2+(1:l_dy2)) = pt ;
                    indJ_dy2(last_dy2+(1:l_dy2)) = MASK(yy+ind_dy2,xx) ;
                    v_dy2(last_dy2+(1:l_dy2)) = kern_dy2/dy^2 ;
                    last_dy2 = last_dy2 + l_dy2 ;
        end
    end
    d_dx = sparse(indI_dx,indJ_dx,v_dx,nPts,nPts) ;
    d_dx2 = sparse(indI_dx2,indJ_dx2,v_dx2,nPts,nPts) ;
    d_dy = sparse(indI_dy,indJ_dy,v_dy,nPts,nPts) ;
    d_dy2 = sparse(indI_dy2,indJ_dy2,v_dy2,nPts,nPts) ;
    d_dxdy = d_dx*d_dy ;
    O = sparse(nPts,nPts) ;
    
% Complete Kernels
    dU1_dx2 = [d_dx2 O] ;
    dU1_dy2 = [d_dy2 O] ;
    dU1_dxdy = [d_dxdy O] ;
    dU2_dx2 = [O d_dx2] ;
    dU2_dy2 = [O d_dy2] ;
    dU2_dxdy = [O d_dxdy] ;
    
% Membrane generalized stiffness matrix A
    Ex = E(1) ;
    Ey = E(2) ;
    Gxy = E(3) ;
    NUxy = E(4) ;
    %A = [Ex NUxy*Ey 0 ; NUxy*Ey Ey 0 ; 0 0 Gxy]*1e6 ;
    A = [Ex NUxy*Ex 0 ; NUxy*Ex Ex 0 ; 0 0 Ex/(2*(1+NUxy))]*1e6 ;
    
% Global Stiffness Matrix K et force vector F
    % Equilibrium equations (orthotropic membrane)
        % A11 U1,11 + A12 U2,12 + 2*A33 (U1,22 + U2,12) = F1
        % 2* (U1,12 + U2,11) + A12 U1,12 + A22 U2,22 = F2
    K = [A(1,1)*dU1_dx2 + A(1,2)*dU2_dxdy + 2*A(3,3)*(dU1_dy2 + dU2_dxdy) ; ...
         2*A(3,3)*(dU1_dxdy + dU2_dx2) + A(1,2)*dU1_dxdy + A(2,2)*dU2_dy2 ] ;
    pF = F(1)+1 ; % +1 because of the GH indexing...
    Fx = F(2) ;
    Fy = F(3) ;
    F = zeros(2*nPts,1) ;
    F(pF) = -Fx ;
    F(pF+nPts) = -Fy ;
    
% Boundary conditions :
    pBC = [1:nY,1:nY:nPts] ; % points indices for which to lock displacements
    indCL = [pBC pBC+nPts] ;
    K(indCL,:) = [] ;
    K(:,indCL) = [] ;
    F(indCL) = [] ;
    
% DISPLACEMENT COMPUTING
    %warning off
    UU = K\F ;
    %warning on
    U = zeros(2*nPts,1) ;
    U(setdiff(1:2*nPts,indCL)) = UU ;
    NORM = max(abs(UU)) ;
    U2 = U(MASK) ;
    U1 = U(MASK+nPts) ;
    
% PLOT FIGURE
    if 0 % 0 if you don't want to plot the figure
        amp = 1e0 ;
        ampF = 5e-4 ;
        fig = findobj(groot,'tag','figMembrane') ;
        if isempty(fig)
            fig = figure('windowstyle','docked','tag','figMembrane') ;
        end
        srf = findobj(fig,'tag','srfMembrane') ;
        if isempty(srf)
            srf = surf(XX*0,XX*0,XX*0,XX*0,'facecolor','interp','tag','srfMembrane') ;
            axis equal
            axis off
            axis tight
        end
        plF = findobj(fig,'tag','plF') ;
        if isempty(plF)
            plF = plot(0,0,'k','tag','plF') ;
        end
        srf.XData = XX+U1*amp ;
        srf.YData = YY+U2*amp ;
        srf.ZData = XX*0 ;
        srf.CData = sqrt(U1.^2+U2.^2) ;
        plF.XData = (XX(pF)+U1(pF)*amp)*[1 1] + [0 Fx]*ampF ;
        plF.YData = (YY(pF)+U2(pF)*amp)*[1 1] + [0 Fy]*ampF ;
        drawnow ;
    end
    
display('Solved !')
    
    

%end