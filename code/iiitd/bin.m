function [i,j,k] = bin( theta, phi, rho, numTheta, numPhi, numRho, rhoMin, rhoMax )
    %BIN Gives the bin corresponding to theta, phi, rho
    
    dTheta = 360.0/(numTheta - 1);
    dPhi = 360.0/(numPhi - 1);
    dRho = (rhoMax-rhoMin)/(numRho - 1);

    i = floor(theta/dTheta) + 1;
    j = floor(phi/dPhi) + 1;
    k = floor((rho-rhoMin)/dRho) + 1;
end