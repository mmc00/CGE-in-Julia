using JuMP

M = model(IpoptSolver())

# Parameters

# from david
#sector = [:sec1, :sec2]
#@variable m begin
#  x[sector]
#end

## Production block

KZ = [60.,50.] # inital capital demand
KSZ = sum(KZ) # capital endowment
LZ = [20.,90.] # initial labor demand
LSZ = sum(LZ) # labor endowment
PKZ = 1. # initial capital price
PLZ = 1. # initial labor price (wages)
PDZ = [1.,1.] # inital commodity price (price of domestically-produced commodities)
IOZ = [5. 40. ; 15. 20.] # technical coefficients for intermediate inputs
XDZ = (PKZ.*KZ)./PDZ + (PLZ.*LZ)./PDZ + (IOZ[1:2]*PDZ + IOZ[3:4]*PDZ)./PDZ # initial commodity production level
sigmaF = [0.8, 1.2]# elasticity of substition between factors in production function
gammaF = 1/(1+(1+((PLZ/PKZ)*((KZ./LZ)^(-1/sigmaF))))) # distribution parameter of capital
aF = XDZ ./ (gammaF.*KZ.^((sigmaF-1)/sigmaF)+(1-gammaF).*LZ^((1-sigmaF)./sigmaF))^(sigmaF/(sigmaF-1)) # efficiency parameter in production function


## Consumption block

CZ = [55.,165.]                          # household demand for commodities
UZ = prod(CZ. - muH.).^alphaHLES	       # utility level of household
YZ = PKZ.*KSZ. + PLZ.*LSZ.			         # household's total income
frisch = -1.1			                       # Frisch parameter
elasY = [0.9,1.1]                        #income elasticities of demand for commodities

io = IOZ./XDZ.                                          # Technical coefficients
alphaHLES = elasY.*(PDZ.*CZ.)./YZ	                      # marginal budget shares of utility function
muH = CZ. + (alphaHLES.*YZ)/(PDZ.*frisch) 	            # Subsistence level


## Equations

# HOUSEHOLDS
EQC = muH + alphaHLES/(PD * (Y - sum(PD * muH))    	#consumer consumption
EQY	= PK*KS + PL*LS		                              #income balance
EQU	= prod((C - muH)^alphaHLES)	                    #household utility

# FIRMS
EQK	= gammaF^sigmaF * PK^(-sigmaF) * (gammaF^sigmaF * PK^(1-sigmaF) +
      (1-gammaF)^sigmaF * PL^(1-sigmaF))^(sigmaF/(1-sigmaF)) * (XD/aF)      #firm demand for capital

EQL = (1-gammaF)^sigmaF * PL^(-sigmaF) * (gammaF^sigmaF * PK^(1-sigmaF) +
      (1-gammaF)^sigmaF * PL^(1-sigmaF)^(sigmaF/(1-sigmaF)) * (XD/aF)       #firm demand for labor

EQZPC = PK*K + PL*L + sum(io*PD)*XD                                         #zero-profit condition

# MARKET CLEARING
EQXD    #market clearing consumption
EQKS		#capital market clearing
EQLS		#labor market clearing

# OBJECTIVE
EQT			#objective function
