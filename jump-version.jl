using JuMP

# to do: add index; read in data

M = model(IpoptSolver())
sec = [:sec1, :sec2]

### PARAMETERS ###

## Production block

KZ[sec] = [60.,50.]              # inital capital demand
KSZ = sum(KZ)               # capital endowment
LZ[sec] = [20.,90.]              # initial labor demand
LSZ = sum(LZ)               # labor endowment
PKZ = 1.                    # initial capital price
PLZ = 1.                    # initial labor price (wages)
PDZ[sec] = [1.,1.]               # inital commodity price (price of domestically-produced commodities)
IOZ = [5. 40. ; 15. 20.]    # intermediate inputs
io = IOZ/XDZ               # Technical coefficients
XDZ = (PKZ.*KZ)./PDZ + (PLZ.*LZ)./PDZ + (IOZ[1:2]*PDZ + IOZ[3:4]*PDZ)./PDZ
                            # initial commodity production level
sigmaF = [0.8, 1.2]         # elasticity of substition between factors in production function
gammaF = 1/(1+(1+((PLZ/PKZ)*((KZ./LZ)^(-1/sigmaF)))))
                            # distribution parameter of capital
aF = XDZ ./ (gammaF.*KZ.^((sigmaF-1)/sigmaF)+(1-gammaF).*LZ^((1-sigmaF)./sigmaF))^(sigmaF/(sigmaF-1))
                            # efficiency parameter in production function


## Consumption block (household = consumer and provider of labor)
CZ = [55.,165.]                          # household demand for commodities
YZ = PKZ*KSZ + PLZ*LSZ			             # household's total income
frisch = -1.1			                       # Frisch parameter
elasY = [0.9,1.1]                        # income elasticities of demand for commodities
alphaHLES = (elasY.*(PDZ.*CZ.))/YZ	       # marginal budget shares of utility function
muH = CZ + (alphaHLES.*YZ)/(PDZ.*frisch) 	            # Subsistence level
UZ = prod(CZ. - muH.).^alphaHLES	       # utility level of household


# Variables

## Production
@variables M begin
  K, start = KZ
  PK, start = PKZ
  L, start = LZ
  PL, start = PLZ
  PD, start = PDZ
  KS, start = KSZ
  LS, start = LSZ
  XD, start = XDZ
end

## Consumption
@variables M begin
  C, start = CZ
  Y, start = YZ
  U, start = UZ
end


### EQUATIONS (constraints) ###

## Consumption
@constraints M begin
  # HOUSEHOLDS
  EQC, C == muH + alphaHLES/(PD * (Y - sum(PD * muH))    	 #consumer consumption
  EQY, Y == PK*KS + PL*LS	                                 #income balance
  EQU, U == prod((C - muH)^alphaHLES)	                     #household utility

  # MARKET CLEARING
  EQXD, XD == sum(io * XD) + C	                           #market clearing consumption

end

## Production
@constraints M begin
  # FIRMS
  EQK, K	== gammaF^sigmaF * PK^(-sigmaF) * (gammaF^sigmaF * PK^(1-sigmaF) +
        (1-gammaF)^sigmaF * PL^(1-sigmaF))^(sigmaF/(1-sigmaF)) * (XD/aF)                #firm demand for capital

  EQL, L == (1-gammaF)^sigmaF * PL^(-sigmaF) * (gammaF^sigmaF * PK^(1-sigmaF) +
        (1-gammaF)^sigmaF * PL^(1-sigmaF)^(sigmaF/(1-sigmaF)) * (XD/aF)                 #firm demand for labor

  EQZPC, PD * XD == PK*K + PL*L + sum(io*PD)*XD                                         #zero-profit condition

  # MARKET CLEARING
  EQKS, sum(K) == KS           #capital market clearing  == sum(K)
  EQLS, sum(L) == LS           #labor market clearing == sum(L)
end

### SOLVER ###

#TRICK == 0  #objective function -> unnecessary because using solver
solve(M)
